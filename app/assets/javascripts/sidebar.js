(function() {
  var storageKey = 'niho.sidebar.expanded';

  function desktopSidebar() {
    return window.matchMedia('(min-width: 1200px)').matches;
  }

  // The layout calls this before rendering the sidebar, so navigation starts
  // in the saved state without an opening/closing animation.
  window.nihoSidebarRestore = function() {
    if (!document.body.classList.contains('app-with-sidebar')) return;
    if (!desktopSidebar()) {
      document.body.classList.toggle('app-sidebar-expanded', false);
      return;
    }
    try {
      var saved = sessionStorage.getItem(storageKey);
      if (saved !== null) document.body.classList.toggle('app-sidebar-expanded', saved === 'true');
    } catch (error) {}
  };

  window.nihoSidebarSyncButton = function() {
    var button = document.querySelector('button.app-sidebar-toggle');
    if (!button) return;
    var expanded = document.body.classList.contains('app-sidebar-expanded');
    var label = expanded ? button.dataset.collapseLabel : button.dataset.expandLabel;
    button.setAttribute('aria-expanded', String(expanded));
    button.setAttribute('aria-label', label);
    button.setAttribute('title', label);
  };

  // Replace the previous registration if navigation evaluates this script again.
  if (window.nihoSidebarClickHandler) {
    document.removeEventListener('click', window.nihoSidebarClickHandler);
  }

  window.nihoSidebarClickHandler = function(event) {
    var button = event.target.closest('button.app-sidebar-toggle');
    if (!button || !document.body.classList.contains('app-with-sidebar')) return;

    document.body.classList.add('app-sidebar-animate');
    var expanded = document.body.classList.toggle('app-sidebar-expanded');
    window.nihoSidebarSyncButton();
    if (desktopSidebar()) {
      try { sessionStorage.setItem(storageKey, String(expanded)); } catch (error) {}
    }
  };

  document.addEventListener('click', window.nihoSidebarClickHandler);
})();
