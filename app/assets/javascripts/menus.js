(function () {
  function initializeStudyGoal() {
    var home = document.querySelector('[data-study-home]');
    if (!home || home.dataset.goalReady) return;
    home.dataset.goalReady = 'true';
    var select = home.querySelector('[data-goal-select]');
    var key = 'niho.daily-goal.' + home.dataset.userId;
    var stored;
    try { stored = localStorage.getItem(key); } catch (error) {}
    if (['5', '10', '20'].indexOf(stored) !== -1) select.value = stored;
    function updateGoal(save) {
      var goal = Number(select.value);
      var today = Number(home.dataset.todayCards);
      home.querySelector('[data-goal-target]').textContent = goal;
      var progress = home.querySelector('[data-goal-progress]');
      progress.max = goal;
      progress.value = Math.min(today, goal);
      var message = today >= goal ? 'Daily goal reached. Great work today!' : 'Your goal is saved on this browser.';
      try { if (save) localStorage.setItem(key, String(goal)); }
      catch (error) { message = 'Goal updated for this visit. Browser storage is unavailable.'; }
      home.querySelector('[data-goal-message]').textContent = message;
    }
    select.addEventListener('change', function () { updateGoal(true); });
    updateGoal(false);
  }
  document.addEventListener('DOMContentLoaded', initializeStudyGoal);
  document.addEventListener('turbolinks:load', initializeStudyGoal);
  document.addEventListener('turbo:load', initializeStudyGoal);
})();
