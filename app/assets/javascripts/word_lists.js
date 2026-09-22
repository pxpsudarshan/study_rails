(function () {
  function initializeGenreSearch() {
    var search = document.querySelector('[data-genre-search]');
    if (!search || search.dataset.ready) return;
    search.dataset.ready = 'true';
    search.hidden = false;
    var input = search.querySelector('input');
    var cards = Array.prototype.slice.call(document.querySelectorAll('[data-genre-card]'));
    var empty = document.querySelector('[data-genre-empty]');
    function filter() {
      var query = input.value.trim().normalize('NFKC').toLocaleLowerCase();
      var matches = 0;
      cards.forEach(function (card) {
        var names = Array.prototype.slice.call(card.querySelectorAll('h3, .library-subgenres'));
        var text = names.map(function (name) { return name.textContent; }).join(' ').normalize('NFKC').toLocaleLowerCase();
        card.hidden = text.indexOf(query) === -1;
        if (!card.hidden) matches += 1;
        var details = card.querySelector('details');
        if (details && query && !card.hidden) details.open = true;
      });
      empty.hidden = matches !== 0;
    }
    input.addEventListener('input', filter);
    filter();
  }
  ['DOMContentLoaded', 'turbolinks:load', 'turbo:load'].forEach(function (event) {
    document.addEventListener(event, initializeGenreSearch);
  });
})();
