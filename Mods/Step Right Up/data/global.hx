import funkin.backend.assets.ModsFolder;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.utils.NdllUtil;
import sys.io.File;

static var initialized:Bool = false;

static var redirectStates:Map<FlxState, String> = [
    MainMenuState => "scary/SRUMainmenu"
];

function preStateSwitch() {
    FlxG.mouse.useSystemCursor = false;
	FlxG.mouse.visible = true;
    
    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}
function update(elapsed){
	cursorShit = new FunkinSprite().loadGraphic(Paths.image("mouse_hover"));
	FlxG.mouse.load(cursorShit.pixels);
}