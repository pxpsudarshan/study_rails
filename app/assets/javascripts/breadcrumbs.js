(function () {
  'use strict';

  let nav, key, entries = [], pendingKey;

  function localURL(value) {
    const url = new URL(value, window.location.href);
    if (url.origin !== window.location.origin) throw new Error('External breadcrumb');
    url.searchParams.delete('_'); // jQuery's script cache buster is not a page state.
    url.searchParams.sort();
    return url.pathname + url.search + url.hash;
  }

  function read(name, fallback) {
    try { return JSON.parse(sessionStorage.getItem(name)) || fallback; }
    catch (_) { return fallback; }
  }

  function save(name, value) {
    try { sessionStorage.setItem(name, JSON.stringify(value)); } catch (_) { /* Keep in-memory navigation. */ }
  }

  function labelFor(url, title) {
    const details = [];
    new URL(url, window.location.origin).searchParams.forEach(function (value, name) {
      if (!value || ['utf8', 'commit', 'locale', 'authenticity_token'].includes(name)) return;
      const control = Array.from(document.querySelectorAll('select')).find(select => select.name === name);
      const option = control && Array.from(control.options).find(option => option.value === value);
      if (name === 'page' && /^\d+$/.test(value)) {
        details.push((nav.dataset.pageLabel || 'Page %{number}').replace('%{number}', value));
      } else if (name === 'jlpt' && /^[1-5]$/.test(value)) {
        details.push('N' + value);
      } else if (option && !['id', 'child_id'].includes(name)) {
        details.push(option.text);
      } else if (/^(q|query|goi\[goi\]|kanji\[kanji\])$/.test(name)) {
        details.push(value);
      }
    });
    return title + (details.length ? ' (' + details.join(', ') + ')' : '');
  }

  function record(entry) {
    const index = entries.findIndex(item => item.url === entry.url && item.base === entry.base);
    entries = index < 0 ? entries.concat([entry]) : entries.slice(0, index).concat([entry]);
    save(key, entries);
    render();
  }

  let resizeObserver;
  let fitTrail = function () {};

  function breadcrumbLink(entry) {
    const link = document.createElement('a');
    link.href = entry.base || entry.url;
    link.textContent = entry.label;
    link.title = entry.label;
    if (entry.base) link.addEventListener('click', function (event) {
      if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
      event.preventDefault();
      save(pendingKey, entry);
      window.location.assign(entry.base);
    });
    return link;
  }

  function render() {
    const list = nav.querySelector('ol');
    const dropdown = nav.querySelector('[popover]');
    const hiddenList = dropdown.querySelector('ol');
    dropdown.hidePopover();
    list.replaceChildren();
    const trail = [{ url: nav.dataset.home, label: nav.dataset.homeLabel }].concat(entries);
    const items = trail.map(function (entry, index) {
      const item = document.createElement('li');
      item.className = 'breadcrumb-item';
      if (index === trail.length - 1) {
        item.classList.add('active');
        item.setAttribute('aria-current', 'page');
        const label = document.createElement('span');
        label.textContent = entry.label;
        label.title = entry.label;
        item.appendChild(label);
      } else {
        item.appendChild(breadcrumbLink(entry));
      }
      list.appendChild(item);
      return item;
    });
    const control = document.createElement('li');
    control.className = 'breadcrumb-item breadcrumb-toggle';
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = '…';
    button.setAttribute('aria-label', nav.dataset.expandLabel);
    button.setAttribute('aria-expanded', 'false');
    button.setAttribute('aria-controls', dropdown.id);
    button.setAttribute('popovertarget', dropdown.id);
    dropdown.onbeforetoggle = function (event) {
      if (event.newState !== 'open') return;
      const bounds = button.getBoundingClientRect();
      const width = Math.min(384, window.innerWidth - 24);
      dropdown.style.left = Math.max(12, Math.min(bounds.left, window.innerWidth - width - 12)) + 'px';
      dropdown.style.top = (bounds.bottom + 6) + 'px';
      dropdown.style.maxHeight = Math.max(80, window.innerHeight - bounds.bottom - 18) + 'px';
    };
    dropdown.ontoggle = function (event) {
      button.setAttribute('aria-expanded', String(event.newState === 'open'));
    };
    control.appendChild(button);
    list.insertBefore(control, items[1] || null);
    nav.hidden = false;

    fitTrail = function () {
      dropdown.hidePopover();
      items.forEach(item => { item.hidden = false; });
      control.hidden = true;
      list.classList.add('breadcrumb-measuring');
      const widths = items.map(item => item.getBoundingClientRect().width);
      const available = list.clientWidth;
      let total = widths.reduce((sum, width) => sum + width, 0);
      const hidden = [];
      if (total > available) {
        control.hidden = false;
        total += control.getBoundingClientRect().width;
        // Keep Home and the current page; hide older steps before recent ones.
        for (let index = 1; index < items.length - 1 && total > available; index++) {
          items[index].hidden = true;
          hidden.push(trail[index]);
          total -= widths[index];
        }
        // The current label may itself be wider than the screen. Show its full
        // text in the dropdown as well as its single-line, truncated trail label.
        if (total > available) hidden.push(trail[trail.length - 1]);
      }
      list.classList.remove('breadcrumb-measuring');
      hiddenList.replaceChildren();
      hidden.forEach(function (entry) {
        const item = document.createElement('li');
        if (entry === trail[trail.length - 1]) {
          item.textContent = entry.label;
          item.setAttribute('aria-current', 'page');
        } else {
          item.appendChild(breadcrumbLink(entry));
        }
        hiddenList.appendChild(item);
      });
    };
    fitTrail();
    if (resizeObserver) resizeObserver.disconnect();
    if (window.ResizeObserver) {
      let previousWidth = list.clientWidth;
      resizeObserver = new window.ResizeObserver(function () {
        if (list.clientWidth !== previousWidth) {
          previousWidth = list.clientWidth;
          fitTrail();
        }
      });
      resizeObserver.observe(list);
    }
  }

  function initialize() {
    if (resizeObserver) resizeObserver.disconnect();
    fitTrail = function () {};
    nav = document.querySelector('[data-breadcrumb-history]');
    if (!nav) return;
    key = 'breadcrumbs:v2:' + nav.dataset.scope;
    pendingKey = key + ':pending';
    entries = read(key, []);
    if (!Array.isArray(entries)) entries = [];
    entries = entries.filter(entry => {
      try { return typeof entry.label === 'string' && localURL(entry.url) && (!entry.base || localURL(entry.base)); }
      catch (_) { return false; }
    });
    if (nav.dataset.reset === 'true') {
      save(key, []);
      save(pendingKey, null);
      return;
    }
    if (nav.dataset.track !== 'true') return;
    const pending = read(pendingKey, null);
    save(pendingKey, null);
    if (pending && pending.base === localURL(window.location.href)) {
      // Rebuild the page before replaying a remote filter or detail navigation.
      render();
      const target = entries.findIndex(entry => entry.url === pending.url && entry.base === pending.base);
      let start = target;
      while (start > 0 && entries[start - 1].base === pending.base) start -= 1;
      const steps = target < 0 ? [pending] : entries.slice(start, target + 1);
      function replay(index) {
        if (index === steps.length) { record(pending); return; }
        $.ajax({ url: localURL(steps[index].url), dataType: 'script' }).done(function () { replay(index + 1); });
      }
      replay(0);
    } else {
      record({ url: localURL(window.location.href), label: labelFor(window.location.href, nav.dataset.label) });
    }
  }

  // jquery-ujs GET navigation also changes the visible page without a full load.
  $(document).on('ajax:beforeSend', 'a[data-remote], form[data-remote]', function (event, xhr, settings) {
    if (!nav || nav.dataset.track !== 'true' || (settings.type || 'GET').toUpperCase() !== 'GET') return;
    if ($(this).data('type') && $(this).data('type') !== 'script') return;
    const url = new URL(settings.url, window.location.href);
    if (settings.data) new URLSearchParams(settings.data).forEach((value, name) => url.searchParams.append(name, value));
    const title = this.tagName === 'A' && !this.closest('.pagination') ? this.textContent.trim() : nav.dataset.label;
    const entry = { url: localURL(url.href), base: localURL(window.location.href), label: labelFor(url.href, title || nav.dataset.label) };
    // The response can replace the initiating form/link before ajax:success bubbles.
    xhr.done(function () {
      const label = xhr.getResponseHeader && xhr.getResponseHeader('X-Breadcrumb-Label');
      if (label) {
        nav.dataset.label = decodeURIComponent(label);
        entry.label = labelFor(entry.url, nav.dataset.label);
      }
      record(entry);
    });
  });
  window.addEventListener('resize', function () { fitTrail(); });
  if (document.fonts) document.fonts.ready.then(function () { fitTrail(); });
  document.addEventListener('DOMContentLoaded', initialize);
  document.addEventListener('turbo:load', initialize);
  document.addEventListener('turbolinks:load', initialize);
  window.addEventListener('pageshow', function (event) { if (event.persisted) initialize(); });
})();
