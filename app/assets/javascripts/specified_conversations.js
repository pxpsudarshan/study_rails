function optionChange(selectElement) {
    var selectedValue = selectElement.value;
    var lang = document.getElementById('lang').getAttribute('data-lang');
    var audio_b_id = document.getElementById('audio_b_id').value;

    $.ajax({
        url: 'get_case_name',
        dataType: 'json',
        method: 'get',
        data: {
            sort: selectedValue,
            audio_b_id: audio_b_id
        },
        success: function(response) {
            var lowerSelect = document.getElementById('title_nation_case_name_nation');
            lowerSelect.innerHTML = '';
    
            response.forEach(function(item) {
                var option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.case_name_nation[lang]; 
                lowerSelect.appendChild(option);
            });
        },
        error: function(xhr, status, error) {
            console.error(error,status, xhr);
        }
      });
}
