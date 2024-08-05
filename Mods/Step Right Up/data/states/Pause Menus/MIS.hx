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
    
    bg = new FlxSprite().loadGraphic(Paths.image("pauseMenus/minds eye squared/portrait"));
    bg.cameras = [pauseCam];
    bg.scale.set(.6,.6);
    bg.x = -250;
    bg.screenCenter(FlxAxes.X);
    add(bg);

    Shits = new FlxTypedGroup();
	add(Shits);

    for (i in 0...4) {
        var option = Things[i];
        options = new FlxSprite(0, 50 + 170 * i);
        options.frames = Paths.getSparrowAtlas('pauseMenus/minds eye squared/' + option);
        options.animation.addByPrefix('idle', option + "idle", 24);
		options.animation.addByPrefix('selected', option + "selected", 24);
        options.animation.play('selected');
        options.cameras = [pauseCam];
        options.ID = i;
        Shits.add(options);
        add(options);
        
        if (options.ID == 1){
            options.x = 700;
            options.y = 50;
        }
        if (options.ID == 2){
            options.x = 0;
            options.y = 500;
        }
        if (options.ID == 3){
            options.x = 800;
            options.y = 500;
        }
    }
}
function update(){
    if (controls.ACCEPT) selectOption();

    if (controls.DOWN_P) changeItem(1, false);

	if (controls.UP_P) changeItem(-1);

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
   
    Shits.forEach(function(spr:FlxSprite) {
		if (spr.ID == curSelected) {
            options.animation.play('selected');
        }else{
            options.animation.play('idle');
        }
    });
}