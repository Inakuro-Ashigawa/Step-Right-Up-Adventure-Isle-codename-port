function onNoteCreation(event) event.noteSprite = 'noteSkins/SRU_Note_Assets';
function onStrumCreation(event) event.sprite = 'noteSkins/SRU_Note_Assets';
function onDadHit(note) if (health > 0.1) health -= .025 * 1;
function onPostNoteCreation(e) e.note.splash = "SRU";
