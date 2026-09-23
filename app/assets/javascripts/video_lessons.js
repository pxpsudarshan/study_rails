(function () {
  'use strict';

  function activeCue(cues, time) {
    for (var i = cues.length - 1; i >= 0; i--) {
      if (cues[i].start <= time && time < cues[i].end) return i;
    }
    return -1;
  }

  function nearbyCue(cues, time) {
    for (var i = cues.length - 1; i >= 0; i--) {
      if (cues[i].start <= time) return i;
    }
    return 0;
  }

  // Kept independent of the DOM so timing and navigation can be tested.
  function StudySession(cues, player) {
    this.cues = cues;
    this.player = player;
    this.loop = -1;
    this.pending = null;
  }
  StudySession.prototype.seek = function (index) {
    index = Math.max(0, Math.min(this.cues.length - 1, index));
    if (this.loop >= 0) this.loop = index;
    this.pending = { index: index, until: Date.now() + 3000 };
    this.player.seekTo(this.cues[index].start, true);
    this.player.playVideo();
  };
  StudySession.prototype.current = function () {
    return this.pending ? this.pending.index : nearbyCue(this.cues, this.player.getCurrentTime());
  };
  StudySession.prototype.move = function (offset) {
    var beforeFirst = !this.pending && this.player.getCurrentTime() < this.cues[0].start;
    this.seek(beforeFirst && offset > 0 ? 0 : this.current() + offset);
  };
  StudySession.prototype.tick = function () {
    var time = this.player.getCurrentTime();
    if (this.pending) {
      var cue = this.cues[this.pending.index];
      if ((time >= cue.start && time < cue.end) || Date.now() > this.pending.until) this.pending = null;
      else return -1;
    }
    if (this.loop >= 0 && (this.player.getPlayerState() === 1 || this.player.getPlayerState() === 0)) {
      var target = this.cues[this.loop];
      if (time >= target.end || time < target.start - 0.3) {
        this.seek(this.loop);
        return this.loop;
      }
    }
    return activeCue(this.cues, time);
  };

  if (typeof module !== 'undefined' && module.exports) module.exports = { activeCue: activeCue, nearbyCue: nearbyCue, StudySession: StudySession };
  if (typeof document === 'undefined') return;

  document.addEventListener('DOMContentLoaded', function () {
    var root = document.querySelector('[data-video-lesson]');
    if (!root) return;
    var rows = Array.from(root.querySelectorAll('[data-cue]'));
    var cues = rows.map(function (row) { return { start: Number(row.dataset.start), end: Number(row.dataset.end) }; });
    var status = root.querySelector('[data-status]');
    var controls = root.querySelector('[data-controls]');
    var speed = root.querySelector('[data-speed]');
    var follow = root.querySelector('[data-follow]');
    var loop = root.querySelector('[data-loop]');
    var transcript = root.querySelector('[data-transcript]');
    var player, session, interval, active = -1;
    var timeout = setTimeout(fail, 20000);

    function fail() {
      clearTimeout(timeout);
      clearInterval(interval);
      controls.disabled = true;
      rows.forEach(function (row) { row.disabled = true; });
      status.textContent = root.dataset.error;
    }
    function highlight(index) {
      if (index === active) return;
      if (active >= 0) {
        rows[active].classList.remove('is-active');
        rows[active].removeAttribute('aria-current');
      }
      active = index;
      if (index < 0) return;
      var row = rows[index];
      row.classList.add('is-active');
      row.setAttribute('aria-current', 'true');
      if (follow.checked) {
        var top = row.getBoundingClientRect().top - transcript.getBoundingClientRect().top + transcript.scrollTop;
        transcript.scrollTop = top - transcript.clientHeight / 2 + row.clientHeight / 2;
      }
    }
    function updateRates() {
      var rates = player.getAvailablePlaybackRates();
      speed.replaceChildren();
      (rates.length ? rates : [1]).forEach(function (rate) {
        var option = document.createElement('option');
        option.value = rate;
        option.textContent = rate + '×';
        speed.appendChild(option);
      });
      speed.value = String(player.getPlaybackRate());
    }
    function initialize() {
      player = new window.YT.Player('video-lesson-player', {
        width: '100%', height: '100%', videoId: root.dataset.videoId,
        playerVars: { playsinline: 1, origin: window.location.origin },
        events: {
          onReady: function (event) {
            player = event.target;
            clearTimeout(timeout);
            session = new StudySession(cues, player);
            controls.disabled = false;
            rows.forEach(function (row) { row.disabled = false; });
            status.textContent = root.dataset.ready;
            player.getIframe().setAttribute('title', root.querySelector('h1').textContent);
            updateRates();
            interval = setInterval(function () { highlight(session.tick()); }, 100);
          },
          onError: fail,
          onAutoplayBlocked: function () { status.textContent = root.dataset.blocked; },
          onPlaybackRateChange: function () { speed.value = String(player.getPlaybackRate()); },
          onStateChange: function (event) { if (event.data === 1) updateRates(); }
        }
      });
    }
    rows.forEach(function (row, index) {
      row.addEventListener('click', function () { if (session) { session.seek(index); highlight(index); } });
    });
    root.querySelectorAll('[data-action]').forEach(function (button) {
      button.addEventListener('click', function () {
        if (!session) return;
        var offset = { previous: -1, next: 1, replay: 0 }[button.dataset.action];
        session.move(offset);
      });
    });
    loop.addEventListener('change', function () {
      session.loop = loop.checked ? session.current() : -1;
      if (loop.checked) session.seek(session.loop);
    });
    speed.addEventListener('change', function () { player.setPlaybackRate(Number(speed.value)); });
    follow.addEventListener('change', function () { var index = active; active = -1; highlight(index); });
    window.addEventListener('pagehide', function () { clearInterval(interval); clearTimeout(timeout); });
    window.addEventListener('pageshow', function (event) {
      if (event.persisted && session && !controls.disabled) interval = setInterval(function () { highlight(session.tick()); }, 100);
    });
    if (window.YT && window.YT.Player) initialize();
    else {
      var previousReady = window.onYouTubeIframeAPIReady;
      window.onYouTubeIframeAPIReady = function () {
        if (previousReady) previousReady();
        initialize();
      };
      var script = document.createElement('script');
      script.src = 'https://www.youtube.com/iframe_api';
      script.onerror = fail;
      document.head.appendChild(script);
    }
  });
})();
