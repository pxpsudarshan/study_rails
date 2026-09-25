const assert = require('node:assert/strict');
const { test } = require('node:test');
const vm = require('node:vm');
const fs = require('node:fs');
const source = fs.readFileSync('app/assets/javascripts/theme.js', 'utf8');
function setup(saved, dark = false, blocked = false) {
  const events = {}, attrs = {}, stored = {};
  const buttons = ['light', 'dark'].map(choice => ({ getAttribute: () => choice, setAttribute: (k, v) => { stored[choice] = v; } }));
  const system = { matches: dark, addEventListener: (name, fn) => { events.system = fn; } };
  const context = { document: { documentElement: { setAttribute: (k, v) => { attrs[k] = v; } }, querySelectorAll: () => buttons, addEventListener: (k, fn) => { events[k] = fn; } }, window: { matchMedia: () => system, addEventListener: (k, fn) => { events[k] = fn; } }, localStorage: { getItem: () => { if (blocked) throw Error(); return saved; }, setItem: (k, v) => { if (blocked) throw Error(); saved = v; } } };
  vm.runInNewContext(source, context);
  return { attrs, events, stored, system, choose: i => events.click({ target: { closest: () => buttons[i] } }) };
}
test('uses system preference unless a valid choice is saved', () => {
  assert.equal(setup(null, true).attrs['data-theme'], 'dark');
  assert.equal(setup('light', true).attrs['data-theme'], 'light');
  assert.equal(setup('invalid').attrs['data-theme'], 'light');
});
test('switching updates appearance and accessibility, surviving navigation', () => {
  const app = setup(null); app.choose(1); app.events['turbo:load']();
  assert.equal(app.attrs['data-theme'], 'dark'); assert.equal(app.stored.dark, 'true'); assert.equal(app.stored.light, 'false');
  app.system.matches = false; app.events.system(); assert.equal(app.attrs['data-theme'], 'dark');
});
test('works when storage is blocked and synchronizes other tabs', () => {
  const app = setup(null, false, true); app.choose(1); assert.equal(app.attrs['data-theme'], 'dark');
  app.events.storage({ key: 'niho.theme', newValue: 'light' }); assert.equal(app.attrs['data-theme'], 'light');
});
