function Openmodal(kanji, meaning, kunyomi, onyomi, parts) {
    let modalPartsContainer = document.getElementById("modal-parts");
    let modalKunyomiContainer = document.getElementById("modal-kunyomi");
    let modalOnyomiContainer = document.getElementById("modal-onyomi");

    // Clear existing content
    modalPartsContainer.innerHTML = "";
    modalKunyomiContainer.innerHTML = "";
    modalOnyomiContainer.innerHTML = "";

    // Update modal content
    document.getElementById("ModalHeaderLabel").textContent = kanji;
    document.getElementById("modal-meaning").textContent = meaning;

    // Convert comma-separated strings to arrays if they are not already
    let partsArray = parts ? parts.split(",") : [];
    let kunyomiArray = kunyomi ? kunyomi.split(",") : [];
    let onyomiArray = onyomi ? onyomi.split(",") : [];

    // Populate Parts as Buttons
    partsArray.forEach(part => {
        let link = document.createElement("a");
        link.href = "#";
        link.textContent = part.trim();
        link.classList.add("mx-1", "text-decoration-none", "btn", "btn-outline-primary", "btn-sm"); 
        modalPartsContainer.appendChild(link);
    });

    // Populate Kunyomi as Links
    kunyomiArray.forEach(kun => {
        let link = document.createElement("a");
        link.href = "#";
        link.textContent = kun.trim();
        link.classList.add("mx-1", "text-decoration-none", "modal-link"); 
        modalKunyomiContainer.appendChild(link);
    });

    // Populate Onyomi as Links
    onyomiArray.forEach(ony => {
        let link = document.createElement("a");
        link.href = "#";
        link.textContent = ony.trim();
        link.classList.add("mx-1", "text-decoration-none", "modal-link"); 
        modalOnyomiContainer.appendChild(link);
    });
}

function Openmodal2(parts,meaning,vocab_code,read_code) {
    let modalVocabPartsContainer = document.getElementById("vocab-parts");
    // let modalVocabCodeContainer = document.getElementById("vocab-vocab_code");
    // let modalReadCodeContainer = document.getElementById("vocab-read_code");
     //let modalMeaningContainer = document.getElementById("vocab-meaning");

    // Clear existing content
    modalVocabPartsContainer.innerHTML = "";

  
    document.getElementById("vocab-meaning").textContent = meaning;
    document.getElementById("detailsModalLabel").textContent = vocab_code;
    document.getElementById("vocab-read_code").textContent = read_code;

    // Convert comma-separated strings to arrays if they are not already
    let partsArray = parts ? parts.split(",") : [];
   
    // Populate Parts as Buttons
    partsArray.forEach(part => {
        let link = document.createElement("a");
        link.href = "#";
        link.textContent = part.trim();
        link.classList.add("mx-1", "text-decoration-none", "btn", "btn-outline-primary", "btn-sm"); 
        modalVocabPartsContainer.appendChild(link);
    });

    
}

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








