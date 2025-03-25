function toggleEditSave(inputId, editBtnId, saveBtnId) {
    const input = document.getElementById(inputId);
    const editBtn = document.getElementById(editBtnId);
    const saveBtn = document.getElementById(saveBtnId);

    if (input.disabled) {
      input.disabled = false;
      editBtn.style.display = "none";
      saveBtn.style.display = "inline-block";
    } else {
      input.disabled = true;
      editBtn.style.display = "inline-block";
      saveBtn.style.display = "none";
    }
  }








