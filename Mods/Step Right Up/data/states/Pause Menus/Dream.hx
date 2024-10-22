import FlxG;
import PlayState;
import lime.utils.Assets;
import openfl.utils.Assets;
import flixel.util.FlxAxes;
import funkin.game.StrumLine;
import funkin.options.OptionsMenu;
import flixel.tweens.FlxTweenType;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.scripting.EventManager;
import funkin.backend.scripting.events.NameEvent;
import funkin.backend.scripting.events.MenuChangeEvent;

var curSelected:Int = 0;
var pauseCam = new FlxCamera();
var Things:Array<String> = ['resume', 'restart', 'options','exit'];

function create(){
    FlxG.cameras.add(pauseCam, false);
    pauseCam.bgColor = FlxColor.BLACK; 
    
    bg = new FlxSprite().loadGraphic(Paths.image("pauseMenus/deep dream/portrait"));
    bg.cameras = [pauseCam];
    bg.scale.set(.6,.6);
    bg.x = -250;
    bg.screenCenter(FlxAxes.Y);
    add(bg);

    box = new FlxSprite(400,-210).loadGraphic(Paths.image("pauseMenus/deep dream/banner"));
    box.cameras = [pauseCam];
    box.scale.set(.6,.6);
    add(box);

    Shits = new FlxTypedGroup();
	add(Shits);

    for (i in 0...4) {
        var option = Things[i];
        options = new FlxSprite(700, 280 + 100 * i).loadGraphic(Paths.image("pauseMenus/deep dream/" + option));
        options.cameras = [pauseCam];
        options.ID = i;
        Shits.add(options);
        add(options);
    }
    cursor = new FlxSprite(630,0).loadGraphic(Paths.image("pauseMenus/deep dream/cursor"));
    cursor.cameras = [pauseCam];
    add(cursor);
}
function update(){
    if (controls.ACCEPT) selectOption();

    if (controls.DOWN_P) changeItem(1, false);

	if (controls.UP_P) changeItem(-1);

    if (curSelected >= 0 && curSelected < Shits.length) {
        var selectedOption = Shits.members[curSelected];
        cursor.y = selectedOption.y - 2; 
    }
}
function selectOption() {
	var event = EventManager.get(NameEvent).recycle(Things[curSelected]);
	if (event.cancelled) return;

	var daSelected:String = event.name;
	switch (daSelected){
		case "resume":
			close();
            pauseCam.bgColor = 0;
		case "restart":
			FlxG.resetState();
		case "options":
            FlxG.switchState(new OptionsMenu());
		case "exit":
			CoolUtil.playMenuSong();
			FlxG.switchState(new MainMenuState());
	}
}
function changeItem(huh: Int = 0) {
    curSelected = FlxMath.wrap(curSelected + huh, 0, Things.length - 1);    
}