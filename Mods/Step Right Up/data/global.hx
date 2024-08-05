
import sys.io.File;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.utils.NdllUtil;
import funkin.backend.assets.ModsFolder;
import funkin.backend.system.framerate.Framerate;

static var initialized:Bool = false;
static var redirectStates:Map<FlxState, String> = [
    MainMenuState => "scary/SRUMainmenu",
    TitleState => "scary/SRUTitlescreen"
];

function preStateSwitch() {
    FlxG.mouse.useSystemCursor = false;
	FlxG.mouse.visible = true;
    
    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}
function new(){
    if (FlxG.save.data.seenTITLE == null) FlxG.save.data.seenTITLE = false;
}
function update(elapsed){
	cursorShit = new FunkinSprite().loadGraphic(Paths.image("mouse_hover"));
	FlxG.mouse.load(cursorShit.pixels);
    
    Framerate.codenameBuildField.text = 'Step Right Up Advanture Isle (CNE Port)';
}