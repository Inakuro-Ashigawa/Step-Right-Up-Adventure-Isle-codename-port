//a
import funkin.editors.ui.UIState;

function create() {
    
}

function update() {
    if (FlxG.keys.justPressed.M) {
        FlxG.switchState(new ModState("Music Track"));
    }
    if (FlxG.keys.justPressed.N) {
        FlxG.switchState(new UIState(true, "New Music Track"));
    }
}