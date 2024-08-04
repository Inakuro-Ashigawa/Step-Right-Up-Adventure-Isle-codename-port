var COLOR = new CustomShader("Note Shader");

function postCreate(){
healthBar.alpha = healthBarBG.alpha = iconP1.alpha = iconP2.alpha = 0;
}
function onNoteCreation(event){ 
    event.noteSprite = 'noteSkins/yume_nikki_note_assets';
}
function onStrumCreation(event){
    event.sprite = 'noteSkins/yume_nikki_note_assets';
}
function onPostNoteCreation(e){ 
    e.note.splash = "yume_nikki";
}

function onGamePause(event) {
    event.cancel();
    persistentUpdate = false;
    persistentDraw = paused = true;

    openSubState(new ModSubState('Pause Menus/Dream'));
}
