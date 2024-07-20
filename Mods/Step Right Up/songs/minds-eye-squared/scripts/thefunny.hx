import sys.FileSystem;
import openfl.system.Capabilities;
import funkin.backend.utils.NdllUtil;


var winX:Int = 325;
var winY:Int = 185;
var prevWallpaper = [];
var cutscene:Bool = false;
var intro1,error:FlxSprite;
var timerTween:NumTween;
var fsX:Int = Capabilities.screenResolutionX;
var fsY:Int = Capabilities.screenResolutionY;
var resizex:Int = Capabilities.screenResolutionX / 1.5;
var resizey:Int = Capabilities.screenResolutionY / 1.5;
var tweenWindow1X, tweenWindow1Y, tweenWindow2X, tweenWindow2Y:FlxTween;
var getWallpaper = NdllUtil.getFunction('ndll-mario', 'get_wallpaper', 0);
var setWallpaper = NdllUtil.getFunction("ndll-mario", "change_wallpaper", 1);
var setTransparent = NdllUtil.getFunction('ndll-mario', 'set_transparent', 4);
var removeTransparent = NdllUtil.getFunction('ndll-mario', 'remove_transparent', 0);
var realPath = StringTools.replace(FileSystem.absolutePath(Assets.getPath("assets/images/SmileDogBG.webp")), "/", "\\");
var realPath2 = StringTools.replace(FileSystem.absolutePath(Assets.getPath("assets/images/stages/smile/hellnah.png")), "/", "\\");

window.x = winX;
window.y = winY;
window.width = resizex;
window.height = resizey;
changex = window.x;
changey = window.y;
window.fullscreen = false;
window.resizable = false;
window.opacity = 1;

function onCountdown(event:CountdownEvent) event.cancelled = true;

function addBehindDad(thing){
    insert(members.indexOf(dad), thing);
}

function create(){
    //player.cpu = true;

	intro1 = new FlxSprite().loadGraphic(Paths.image("stages/smile/PEEKABOO"));
    intro1.scale.set(0, 0);
	intro1.camera = camHUD;
	intro1.screenCenter();
	add(intro1);

	DEATHTOALL = new FlxSprite();
    DEATHTOALL.frames = Paths.getSparrowAtlas('stages/smile/DEATHTOALL');
    DEATHTOALL.animation.addByPrefix('loop', "loop", 24, true);
	DEATHTOALL.animation.play('loop');
	DEATHTOALL.scale.set(2,2);
	DEATHTOALL.alpha = 0.001;
	addBehindDad(DEATHTOALL);

	error = new FlxSprite().loadGraphic(Paths.image("stages/smile/BLUESCREENXP"));
	error.camera = camHUD;
	error.screenCenter();
	error.alpha = 0.001;
	add(error);

	tweenWindow1Y = FlxTween.tween(window, {y: changey + changex / 4}, 3, {ease: FlxEase.quadInOut, type: 4});
    tweenWindow1X = FlxTween.tween(window, {x: changex + changex / 2}, 5, {ease: FlxEase.quadInOut, type: 4});
    tweenWindow1Y.active = tweenWindow1X.active = false;
}
function destroy(){
    setWallpaper(prevWallpaper);
    window.resizable = true;
}
function onSongStart(){
	FlxTween.tween(intro1.scale, {'x': 1, 'y': 1}, 30, {ease: FlxEase.circInOut});
}
function wallpaper(){
	setWallpaper(realPath);
	camGame.alpha = window.opacity = 0;
}
function move(){
	intro1.alpha = 0.0001;
	remove(intro1);
}
function fullwin(){
	FlxTween.tween(window, {x: 0, y: 0, width: fsX, height: fsY}, 1.6, {
	ease: FlxEase.expoIn,
	onComplete: function(twn:FlxTween){
		window.borderless = false;
	}});
}
function update(){
	DEATHTOALL.x = dad.x;
	DEATHTOALL.y = dad.y - 100;
}
function windowmoves(){	
	cutscene = true;
	boyfriend.alpha = 0.001;
	DEATHTOALL.alpha = 1;
	window.title = "STEP RIGHT TO YOUR GRAVE - SPREAD THE WORD";
	FlxTween.tween(window, {x: changex / 4, y: Std.int(changey / 4)}, 0.01, {ease: FlxEase.backIn});
    new FlxTimer().start(.1, function(tmr:FlxTimer)
	{
		tweenWindow1X.active = tweenWindow1Y.active = true;
		camGame.alpha = 1;
		window.opacity = 1;
	});
}
function postUpdate(){
	if (cutscene){
		healthBar.alpha = iconP1.alpha = iconP2.alpha = healthBarBG.alpha = 0;
    }
}
function crash(){
	tweenWindow1X.active = tweenWindow1Y.active = true;	
	error.alpha = 1;
	DEATHTOALL.alpha = 0.001;
}
function back(){
	setWallpaper(realPath2);
	boyfriend.alpha = 1;
	error.alpha = 0;
	boyfriend.x = 900;
	dad.x = 0;
}