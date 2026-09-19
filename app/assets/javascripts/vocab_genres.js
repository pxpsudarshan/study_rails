// --- helper: ボタンのON/OFF取得（.active or aria-pressed=true をONとみなす）---
function isOn(btn) {
  if (!btn) return false;
  return btn.classList.contains('active') || btn.getAttribute('aria-pressed') === 'true';
}

// --- helper: aria-pressed と .active を同期 ---
function syncPressedState(btn, on) {
  if (!btn) return;
  btn.classList.toggle('active', on);
  btn.setAttribute('aria-pressed', on ? 'true' : 'false');
}

// 表示/非表示の適用（全カードに対して走らせる）
function applyVisibility() {
  const hideH = isOn(document.getElementById('toggleHiragana'));
  const hideK = isOn(document.getElementById('toggleKanji'));
  const hideM = isOn(document.getElementById('toggleMeaning'));

  document.querySelectorAll('.js-hiragana, .js-kanji, .js-meaning').forEach(el => {
    const showAll = el.closest('.flip-target')?.dataset.showAll === '1';
    if (el.classList.contains('js-hiragana')) el.classList.toggle('invisible', !showAll && !!hideH);
    if (el.classList.contains('js-kanji'))    el.classList.toggle('invisible', !showAll && !!hideK);
    if (el.classList.contains('js-meaning'))  el.classList.toggle('invisible', !showAll && !!hideM);
  });
}

// 初期適用（Turbo / Turbolinks / 素のDOM すべて対応）
function init() {
  // 初期状態で aria-pressed が無ければ false をセット（見た目が .active なら同期）
  ['toggleHiragana', 'toggleKanji', 'toggleMeaning'].forEach(id => {
    const btn = document.getElementById(id);
    if (!btn) return;
    const initialOn = btn.classList.contains('active') || btn.getAttribute('aria-pressed') === 'true';
    syncPressedState(btn, initialOn);
  });
  applyVisibility();
}
document.addEventListener('DOMContentLoaded', init);
document.addEventListener('turbo:load', init);
document.addEventListener('turbolinks:load', init);

// （旧）チェックボックスのchange監視は不要になったので削除

// クリック系は全てイベント委譲：新しく挿入された要素にも効く
document.addEventListener('click', (e) => {
  // --- 新トグルボタン（Hide系） ---
  const toggleBtn = e.target.closest('#toggleHiragana, #toggleKanji, #toggleMeaning');
  if (toggleBtn) {
    const nextOn = !isOn(toggleBtn);
    syncPressedState(toggleBtn, nextOn);
    applyVisibility();
    return;
  }

  // --- お気に入りトグル ---
  const fav = e.target.closest('.toggle-favorite');
  if (fav) {
    e.preventDefault(); // <a>や<button type=submit>想定
    if (fav.dataset.busy === '1') return; // 連打ガード
    const cardId = fav.getAttribute('data-card-id');
    const prev = fav.getAttribute('aria-pressed') === 'true';

    // 楽観的に反映
    fav.setAttribute('aria-pressed', prev ? 'false' : 'true');
    fav.dataset.busy = '1';

    $.ajax({
      url: '/vocab_mycards/toggle',
      dataType: 'json',
      method: 'get',
      data: {
        // authenticity_token: '<%= form_authenticity_token %>',
        card_id: cardId
      },
      success: function(data) {},
      error: function(xhr, status, error) {
        alert('An error occurred while submitting your answer');
      },
      complete: function() {
        fav.dataset.busy = '0';
      }
    });

    return; // 下のフリップ処理に落ちない
  }

  // --- 疑似フリップ（見せかけ回転 → 中間で全表示/通常切替） ---
  const flipBtn = e.target.closest('.js-swip');
  if (!flipBtn) return;

  const card = flipBtn.closest('.flip-target') || flipBtn.closest('.card');
  if (!card || card.classList.contains('flipping')) return; // 連打ガード

  card.classList.add('flipping');
  setTimeout(() => {
    card.dataset.showAll = (card.dataset.showAll === '1') ? '0' : '1';
    applyVisibility();
    card.classList.remove('flipping');
  }, 150); // .3s の半分
});
