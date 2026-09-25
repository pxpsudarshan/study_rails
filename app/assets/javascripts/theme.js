(function () {
  'use strict';
  if (window.nihoTheme) { window.nihoTheme.refresh(); return; }
  var key = 'niho.theme';
  var system = window.matchMedia('(prefers-color-scheme: dark)');
  var preference;
  function valid(value) { return value === 'light' || value === 'dark'; }
  try { preference = localStorage.getItem(key); } catch (error) {}
  function refresh() {
    var theme = valid(preference) ? preference : (system.matches ? 'dark' : 'light');
    document.documentElement.setAttribute('data-theme', theme);
    document.documentElement.setAttribute('data-bs-theme', theme);
    document.querySelectorAll('[data-theme-choice]').forEach(function (button) {
      button.setAttribute('aria-pressed', String(button.getAttribute('data-theme-choice') === theme));
    });
  }
  window.nihoTheme = { refresh: refresh };
  refresh();
  document.addEventListener('click', function (event) {
    var button = event.target.closest('[data-theme-choice]');
    if (!button) return;
    preference = button.getAttribute('data-theme-choice');
    if (!valid(preference)) return;
    try { localStorage.setItem(key, preference); } catch (error) {}
    refresh();
  });
  ['DOMContentLoaded', 'turbolinks:load', 'turbo:load'].forEach(function (name) {
    document.addEventListener(name, refresh);
  });
  window.addEventListener('storage', function (event) {
    if (event.key === key || event.key === null) { preference = event.newValue; refresh(); }
  });
  if (system.addEventListener) system.addEventListener('change', refresh);
}());
