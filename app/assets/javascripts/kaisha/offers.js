$(function() {
  $('.genre_select').select2({ theme: 'bootstrap-5', dropdownParent: $('#offer-genres'), width: '100%', language: $('.genre_select').data('language'), placeholder: $('.genre_select').data('placeholder') });
  $('#offer-search input[name="search[search_mode]"]').on('change', function() {
    $('#offer-genres').toggle($('#search_search_mode_1').is(':checked'));
  }).trigger('change');
  $(document).on('change', '.offer-selection, #offer-select-page', function() {
    var boxes = $('#offer-request .offer-selection');
    if (this.id === 'offer-select-page') boxes.prop('checked', this.checked);
    var count = boxes.filter(':checked').length;
    $('#offer-selected-count').text(count);
    $('#offer-request-submit').prop('disabled', count === 0);
    $('#offer-select-page').prop('checked', count > 0 && count === boxes.length).prop('indeterminate', count > 0 && count < boxes.length);
  });
  $(document).on('ajax:error', '#offer-search, #offer_list a[data-remote]', function() {
    $('#offer-search-status').text($('#offer-search-status').data('error'));
  });
});
