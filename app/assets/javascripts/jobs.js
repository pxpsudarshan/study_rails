$(document).ready(function() {
  var myModal = new bootstrap.Modal(document.getElementById('btn-detail'));
  $('#btn-detail').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget);
      var companyName = button.data('company');
      var description = button.data('description');
      var requirements = button.data('requirements');
      var responsibilities = button.data('responsibilities');

      $('#modal-company').text(companyName);
      $('#modal-description').text(description);

      var requirementsList = requirements.split(", ");
      var requirementsHtml = '';
      requirementsList.forEach(function (requirement) {
          requirementsHtml += '<li>' + requirement + '</li>';
      });
      $('#modal-requirements').html(requirementsHtml);

      var responsibilitiesList = responsibilities.split(", ");
      var responsibilitiesHtml = '';
      responsibilitiesList.forEach(function (responsibility) {
          responsibilitiesHtml += '<li>' + responsibility + '</li>';
      });
      $('#modal-responsibilities').html(responsibilitiesHtml);
  });

  $('#btn-apply').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget);
    $('#job_id').val(button.data('id'));
  });
});
