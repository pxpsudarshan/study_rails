function optionChange(selectElement) {
  $.ajax({
    url: 'get_case_name',
    dataType: 'json',
    method: 'get',
    data: {
        id: selectElement.value,
    },
    success: function(response) {
        var lowerSelect = document.getElementById('title_nation_content_id');
        lowerSelect.innerHTML = '';
        response.forEach(function(item) {
          var option = document.createElement('option');
          option.value = item.id;
          option.textContent = item.content; 
          lowerSelect.appendChild(option);
      });
    },
    error: function(xhr, status, error) {
        console.error(error,status, xhr);
    }
  });
}
