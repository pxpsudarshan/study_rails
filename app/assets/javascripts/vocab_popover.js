(function () {
  let trigger;
  let popover;

  function close(restoreFocus) {
    if (!popover) return;

    popover.remove();
    popover = null;
    trigger.setAttribute("aria-expanded", "false");
    if (restoreFocus) trigger.focus();
    trigger = null;
  }

  function open(button) {
    trigger = button;
    popover = document.createElement("div");
    popover.className = "vocab-popover";
    popover.setAttribute("role", "dialog");
    popover.setAttribute("aria-label", button.dataset.vocabWord);
    popover.innerHTML =
      '<div class="vocab-popover-reading"></div>' +
      '<a class="vocab-popover-word" target="_blank" rel="noopener"></a>' +
      '<div class="vocab-popover-meaning"></div>';

    const reading = popover.querySelector(".vocab-popover-reading");
    const word = popover.querySelector(".vocab-popover-word");
    const meaning = popover.querySelector(".vocab-popover-meaning");
    reading.textContent = button.dataset.vocabReading;
    word.textContent = button.dataset.vocabWord;
    word.href = button.dataset.vocabUrl;
    meaning.textContent = button.dataset.vocabMeaning || "";
    meaning.hidden = !meaning.textContent;

    document.body.appendChild(popover);
    const anchor = button.getBoundingClientRect();
    const bounds = popover.getBoundingClientRect();
    const viewportWidth = document.documentElement.clientWidth;
    const viewportHeight = document.documentElement.clientHeight;
    const left = anchor.left + (anchor.width - bounds.width) / 2;
    const below = anchor.bottom + 8;
    const above = anchor.top - bounds.height - 8;
    const top = below + bounds.height <= viewportHeight ? below : above;
    popover.style.left = Math.max(8, Math.min(left, viewportWidth - bounds.width - 8)) + "px";
    popover.style.top = Math.max(8, Math.min(top, viewportHeight - bounds.height - 8)) + "px";
    popover.classList.add("vocab-popover-opening");

    button.setAttribute("aria-expanded", "true");
    word.focus({ preventScroll: true });
  }

  document.addEventListener("click", function (event) {
    const button = event.target.closest(".vocab-popover-trigger");
    if (button) {
      const wasOpen = button === trigger;
      close(wasOpen);
      if (!wasOpen) open(button);
    } else if (popover && !popover.contains(event.target)) {
      close(false);
    }
  });

  document.addEventListener("keydown", function (event) {
    if (popover && event.key === "Escape") {
      event.preventDefault();
      close(true);
    }
  });

  document.addEventListener("focusin", function (event) {
    if (popover && event.target !== trigger && !popover.contains(event.target)) close(false);
  });

  window.addEventListener("resize", function () { close(false); });
  window.addEventListener("scroll", function (event) {
    if (popover && (!(event.target instanceof Node) || !popover.contains(event.target))) close(false);
  }, true);
})();
