const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync('app/assets/javascripts/breadcrumbs.js', 'utf8');

function page(url, storage = new Map(), options = {}) {
  const events = {}, ajaxEvents = {}, calls = [];
  function element() {
    return { children: [], classList: { add() {}, remove() {} }, attributes: {}, setAttribute(name, value) { this.attributes[name] = value; },
      hidden: false, getBoundingClientRect() { return { width: this.className === 'breadcrumb-item breadcrumb-toggle' ? 50 : 100 }; },
      insertBefore(child, before) { const index = this.children.indexOf(before); this.children.splice(index < 0 ? this.children.length : index, 0, child); },
      appendChild(child) { this.children.push(child); },
      replaceChildren() { this.children = []; },
      addEventListener(name, fn) { this[name] = fn; } };
  }
  const list = element();
  list.clientWidth = options.width || 1000;
  const hiddenList = element();
  const dropdown = { id: 'breadcrumb-history-dropdown', querySelector: () => hiddenList, hidePopover() {} };
  const classes = new Set();
  const nav = { classList: { remove(name) { classes.delete(name); }, toggle(name) { if (classes.has(name)) { classes.delete(name); return false; } classes.add(name); return true; } }, dataset: { scope: 'User:1:student', home: '/', homeLabel: 'Home', label: 'Vocabulary', track: 'true', ...options }, querySelector: selector => selector === '[popover]' ? dropdown : list };
  const document = { querySelector: () => nav, querySelectorAll: () => [], createElement: element, addEventListener: (name, fn) => { events[name] = fn; } };
  const location = { href: 'https://example.com' + url, origin: 'https://example.com', assign(value) { calls.push(value); } };
  const $ = target => ({ on: (name, selector, fn) => { ajaxEvents[name] = fn; }, data: () => null });
  $.ajax = settings => { calls.push(settings.url); return { done(fn) { fn(); } }; };
  vm.runInNewContext(source, { document, window: { location, addEventListener(name, fn) { events[name] = fn; } }, $, URL, URLSearchParams,
    sessionStorage: { getItem: key => storage.get(key), setItem: (key, value) => storage.set(key, value) } });
  events.DOMContentLoaded();
  return { list, dropdown, hiddenList, resize: () => events.resize(), calls, ajaxEvents, entries: () => JSON.parse(storage.get('breadcrumbs:v2:User:1:student')) };
}

test('same controller and changed parameters retain clickable prior URLs', () => {
  const storage = new Map();
  page('/jlpts?jlpt=5', storage);
  const current = page('/jlpts?jlpt=4&page=2', storage);
  assert.equal(current.entries().length, 2);
  assert.equal(current.list.children.filter(item => item.className !== 'breadcrumb-item breadcrumb-toggle')[1].children[0].href, '/jlpts?jlpt=5');
  assert.match(current.entries()[1].label, /N4, Page 2/);
});
test('revisiting a prior state truncates forward entries and refresh does not duplicate', () => {
  const storage = new Map();
  page('/gois?q=one', storage);
  page('/gois?q=two', storage);
  page('/gois?q=three', storage);
  page('/gois?q=two', storage);
  assert.equal(page('/gois?q=two', storage).entries().length, 2);
});
test('query ordering does not create duplicate steps', () => {
  const storage = new Map();
  page('/gois?q=one&page=2', storage);
  assert.equal(page('/gois?page=2&q=one', storage).entries().length, 1);
});
test('home resets history', () => {
  const storage = new Map();
  page('/gois?q=one', storage);
  assert.deepEqual(page('/', storage, { reset: 'true' }).entries(), []);
});
test('GET AJAX state can be restored after rebuilding its base page', () => {
  const storage = new Map();
  const current = page('/gois', storage);
  let done;
  const xhr = { done(fn) { done = fn; } };
  current.ajaxEvents['ajax:beforeSend'].call({ tagName: 'FORM' }, {}, xhr, { type: 'GET', url: '/gois?goi%5Bgoi%5D=word&_=123' });
  done();
  assert.equal(current.entries()[1].url, '/gois?goi%5Bgoi%5D=word');
  const next = page('/parts', storage);
  next.list.children.map(item => item.children[0]).find(link => link.href === '/gois' && link.click).click({ preventDefault() {} });
  const restored = page('/gois', storage);
  assert.deepEqual(restored.calls, ['/gois?goi%5Bgoi%5D=word']);
  assert.equal(restored.entries().length, 2);
});
test('POST operations are not recorded as navigation', () => {
  const current = page('/gois');
  current.ajaxEvents['ajax:beforeSend'].call({ tagName: 'FORM' }, {}, { done() { throw new Error('Recorded POST'); } }, { type: 'POST', url: '/gois' });
  assert.equal(current.entries().length, 1);
});
test('separate accounts do not share history', () => {
  const storage = new Map();
  page('/gois?q=private', storage);
  const other = page('/parts', storage, { scope: 'User:2:student' });
  assert.equal(other.list.children.filter(item => !item.hidden).length, 2);
});
test('raw IDs and parameter keys are never shown in labels', () => {
  const current = page('/vocab_genres?id=uuid-root&child_id=uuid-child&per=20&page=2', new Map(), { label: 'Food › Vegetables' });
  assert.equal(current.entries()[0].label, 'Food › Vegetables (Page 2)');
});
test('AJAX pagination uses the server genre title', () => {
  const current = page('/vocab_genres?id=root', new Map(), { label: 'Food' });
  let done;
  const xhr = { done(fn) { done = fn; }, getResponseHeader() { return encodeURIComponent('Food › Vegetables'); } };
  current.ajaxEvents['ajax:beforeSend'].call({ tagName: 'FORM' }, {}, xhr, { type: 'GET', url: '/vocab_genres?id=root&child_id=child&page=3' });
  done();
  assert.equal(current.entries()[1].label, 'Food › Vegetables (Page 3)');
});
test('available width controls how many steps appear and hidden links open in a dropdown', () => {
  const storage = new Map();
  for (let index = 0; index < 5; index++) page('/gois?q=' + index, storage);
  const current = page('/gois?q=5', storage, { width: 450 });
  const control = current.list.children.find(item => item.className.includes('breadcrumb-toggle'));
  assert.equal(control.hidden, false);
  assert.equal(current.hiddenList.children.length, 3);
  assert.equal(current.hiddenList.children[0].children[0].href, '/gois?q=0');
  assert.equal(control.children[0].attributes.popovertarget, current.dropdown.id);
  current.dropdown.ontoggle({ newState: 'open' });
  assert.equal(control.children[0].attributes['aria-expanded'], 'true');
  current.dropdown.ontoggle({ newState: 'closed' });
  assert.equal(control.children[0].attributes['aria-expanded'], 'false');
  current.list.clientWidth = 250;
  current.resize();
  assert.equal(current.hiddenList.children.length, 5);
  current.list.clientWidth = 1000;
  current.resize();
  assert.equal(control.hidden, true);
  assert.equal(current.hiddenList.children.length, 0);
});
test('an oversized current label is also available in full in the dropdown', () => {
  const current = page('/gois', new Map(), { width: 120, label: 'A long current page' });
  assert.equal(current.hiddenList.children[0].textContent, 'A long current page');
  assert.equal(current.hiddenList.children[0].attributes['aria-current'], 'page');
});
