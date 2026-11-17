const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync('app/assets/javascripts/sidebar.js', 'utf8');

function page(expanded = false, storage = new Map(), width = 1280) {
  const listeners = {}, classes = new Set(['app-with-sidebar']);
  if (expanded) classes.add('app-sidebar-expanded');
  let changes = 0;
  const button = { dataset: { expandLabel: 'Open menu', collapseLabel: 'Close menu' }, attributes: { 'aria-expanded': String(expanded) }, setAttribute(k, v) { this.attributes[k] = v; } };
  const document = {
    body: { classList: {
      contains(name) { return classes.has(name); },
      add(name) { classes.add(name); },
      toggle(name, force) { changes++; const enabled = force === undefined ? !classes.has(name) : force; enabled ? classes.add(name) : classes.delete(name); return enabled; }
    } },
    querySelector() { return button; },
    addEventListener(name, fn) { (listeners[name] ||= new Set()).add(fn); },
    removeEventListener(name, fn) { listeners[name]?.delete(fn); }
  };
  const context = vm.createContext({ document, window: { matchMedia() { return { matches: width >= 1200 }; } },
    sessionStorage: { getItem(key) { return storage.has(key) ? storage.get(key) : null; }, setItem(key, value) { storage.set(key, value); } }
  });
  const emit = (name, event = {}) => { for (const fn of listeners[name] || []) fn(event); };
  return { listeners, classes, button, emit, storage,
    restore() { context.window.nihoSidebarRestore(); context.window.nihoSidebarSyncButton(); },
    load() { vm.runInContext(source, context); },
    click(targetButton = button) { emit('click', { target: { closest(selector) { assert.equal(selector, 'button.app-sidebar-toggle'); return targetButton; } } }); },
    expanded() { return classes.has('app-sidebar-expanded'); },
    changes() { return changes; }
  };
}

test('only a toggle click opens and closes the sidebar', () => {
  const p = page(); p.load(); assert.equal(p.changes(), 0);
  p.click(); assert.equal(p.expanded(), true); assert.equal(p.changes(), 1);
  assert.equal(p.button.attributes['aria-expanded'], 'true');
  p.click(); assert.equal(p.expanded(), false); assert.equal(p.changes(), 2);
  assert.equal(p.button.attributes['aria-expanded'], 'false');
});

for (const initial of [false, true]) {
  test(`load, hover, resize and navigation events leave ${initial ? 'open' : 'closed'} state unchanged`, () => {
    const p = page(initial); p.load();
    for (const event of ['DOMContentLoaded', 'load', 'turbo:load', 'turbolinks:load', 'resize', 'mouseover', 'mouseenter', 'mouseleave', 'focusin', 'focusout', 'storage', 'transitionend']) p.emit(event);
    assert.equal(p.expanded(), initial); assert.equal(p.changes(), 0);
  });
  test(`other clicks leave ${initial ? 'open' : 'closed'} state unchanged`, () => {
    const p = page(initial); p.load(); p.click(null);
    assert.equal(p.expanded(), initial); assert.equal(p.changes(), 0);
  });
}

test('re-evaluating scripts never changes state or doubles toggle clicks', () => {
  const p = page(); p.load(); p.load(); p.load(); assert.equal(p.changes(), 0);
  assert.equal(p.listeners.click.size, 1);
  p.click(); assert.equal(p.expanded(), true); assert.equal(p.changes(), 1);
  p.load(); assert.equal(p.expanded(), true); assert.equal(p.changes(), 1);
  p.click(); assert.equal(p.expanded(), false); assert.equal(p.changes(), 2);
});

test('load events after opening never close the sidebar', () => {
  const p = page(); p.load(); p.click();
  for (const event of ['DOMContentLoaded', 'turbo:load', 'turbolinks:load']) p.emit(event);
  assert.equal(p.expanded(), true); assert.equal(p.changes(), 1);
});

test('twenty rapid clicks make exactly twenty state changes', () => {
  const p = page(); p.load();
  for (let i = 0; i < 20; i++) { p.click(); assert.equal(p.expanded(), i % 2 === 0); }
  assert.equal(p.changes(), 20);
});

test('pages without a sidebar ignore toggle clicks', () => {
  const p = page(); p.classes.delete('app-with-sidebar'); p.load(); p.click(); assert.equal(p.changes(), 0);
});

for (const open of [true, false]) {
  test(`full page navigation preserves ${open ? 'open' : 'closed'} state without animation`, () => {
    const first = page(false); first.load(); first.restore();
    first.click();
    if (!open) first.click();
    const next = page(false, first.storage); next.load(); next.restore();
    assert.equal(next.expanded(), open);
    assert.equal(next.button.attributes['aria-expanded'], String(open));
    assert.equal(next.classes.has('app-sidebar-animate'), false);
    next.click(); assert.equal(next.expanded(), !open);
    assert.equal(next.classes.has('app-sidebar-animate'), true);
  });
}

test('menu clicks and multiple navigations preserve the open state', () => {
  let p = page(); p.load(); p.restore(); p.click();
  for (let i = 0; i < 4; i++) {
    p.click(null);
    p = page(false, p.storage); p.load(); p.restore();
    assert.equal(p.expanded(), true);
    assert.equal(p.classes.has('app-sidebar-animate'), false);
  }
});

test('a new session starts closed without animation', () => {
  const p = page(); p.load(); p.restore();
  assert.equal(p.expanded(), false);
  assert.equal(p.classes.has('app-sidebar-animate'), false);
});

test('layout restores state before sidebar markup and syncs the toggle afterward', () => {
  const template = fs.readFileSync('app/views/shared/_sidebar.html.erb', 'utf8');
  assert(template.indexOf('nihoSidebarRestore()') < template.indexOf('<aside'));
  assert(template.indexOf('nihoSidebarSyncButton()') > template.indexOf('</aside>'));
});

for (const width of [390, 768, 1024, 1199]) {
  test(`at ${width}px navigation closes the sidebar and preserves desktop preference`, () => {
    const storage = new Map([['niho.sidebar.expanded', 'true']]);
    const first = page(false, storage, width); first.load(); first.restore();
    assert.equal(first.expanded(), false);
    first.click(); assert.equal(first.expanded(), true);
    first.click(null); assert.equal(first.expanded(), true);
    const next = page(false, storage, width); next.load(); next.restore();
    assert.equal(next.expanded(), false);
    assert.equal(next.button.attributes['aria-expanded'], 'false');
    assert.equal(next.classes.has('app-sidebar-animate'), false);
    assert.equal(storage.get('niho.sidebar.expanded'), 'true');
    const desktop = page(false, storage, 1280); desktop.load(); desktop.restore();
    assert.equal(desktop.expanded(), true);
  });
}

test('at the 1200px desktop breakpoint navigation preserves the open sidebar', () => {
  const first = page(false, new Map(), 1200); first.load(); first.restore(); first.click();
  const next = page(false, first.storage, 1200); next.load(); next.restore();
  assert.equal(next.expanded(), true);
});

test('toggle labels describe the next action after opening, closing and restoring', () => {
  const p = page(); p.load(); p.restore();
  assert.equal(p.button.attributes['aria-label'], 'Open menu');
  p.click(); assert.equal(p.button.attributes['aria-label'], 'Close menu');
  assert.equal(p.button.attributes.title, 'Close menu');
  const next = page(false, p.storage); next.load(); next.restore();
  assert.equal(next.button.attributes['aria-label'], 'Close menu');
  next.click(); assert.equal(next.button.attributes['aria-label'], 'Open menu');
  assert.equal(next.button.attributes.title, 'Open menu');
});
