import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
//var COLOR = new CustomShader("Note Shader");

function postCreate(){
    healthBar.alpha = healthBarBG.alpha = iconP1.alpha = iconP2.alpha = 0;
    healthBar = new FlxBar(-350, 550, FlxBarFillDirection.RIGHT_TO_LEFT, 2000, 200, PlayState.instance, "health", 0, maxHealth);
    healthBar.createImageBar(Paths.image("healthbars/mado/yume-p2"), Paths.image("healthbars/mado/yume-p1")); 
    healthBar.camera = camHUD;
    healthBar.scale.set(.4,.4);
    add(healthBar);
    
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