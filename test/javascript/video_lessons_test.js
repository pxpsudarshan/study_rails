const { test } = require('node:test');
const assert = require('node:assert/strict');
const { activeCue, nearbyCue, StudySession } = require('../../app/assets/javascripts/video_lessons');
const cues = [{ start: 2, end: 4 }, { start: 5, end: 7 }, { start: 6, end: 8 }];

test('highlights exact boundaries and overlaps; clears during gaps and after the last cue', () => {
  assert.equal(activeCue(cues, 0), -1);
  assert.equal(activeCue(cues, 2), 0);
  assert.equal(activeCue(cues, 4), -1);
  assert.equal(activeCue(cues, 6), 2);
  assert.equal(activeCue(cues, 8), -1);
  assert.equal(nearbyCue(cues, 4.5), 0);
});
function setup() {
  const calls = [];
  const player = { time: 0, state: 1, getCurrentTime() { return this.time; }, getPlayerState() { return this.state; }, seekTo(time, allow) { calls.push([time, allow]); }, playVideo() { calls.push('play'); } };
  return { player, calls, session: new StudySession(cues, player) };
}
test('seeking uses the sentence start and resumes playback, including rapid next clicks', () => {
  const { session, calls } = setup();
  session.seek(0);
  session.seek(session.current() + 1);
  assert.deepEqual(calls, [[2, true], 'play', [5, true], 'play']);
  session.seek(100);
  assert.equal(session.current(), 2);
  session.seek(-1);
  assert.equal(session.current(), 0);
});
test('loop keeps its target at the boundary and waits for the seek to complete', () => {
  const { session, player, calls } = setup();
  session.loop = 0;
  player.time = 4;
  assert.equal(session.tick(), 0);
  session.tick();
  assert.equal(calls.length, 2);
  player.time = 2;
  session.tick();
  player.time = 4;
  session.tick();
  assert.equal(calls.length, 4);
});
test('loop does not restart a paused player and follows deliberate subtitle selection', () => {
  const { session, player, calls } = setup();
  session.loop = 0;
  player.time = 4;
  player.state = 2;
  session.tick();
  assert.equal(calls.length, 0);
  session.seek(1);
  assert.equal(session.loop, 1);
});
test('loop restarts when video ends on the final sentence', () => {
  const { session, player, calls } = setup();
  session.loop = 2;
  player.time = 8;
  player.state = 0;
  session.tick();
  assert.deepEqual(calls, [[6, true], 'play']);
});

test('next before the first subtitle selects the first sentence instead of skipping it', () => {
  const { session, calls } = setup();
  session.move(1);
  assert.deepEqual(calls, [[2, true], 'play']);
  session.move(1);
  assert.equal(session.current(), 1);
});
