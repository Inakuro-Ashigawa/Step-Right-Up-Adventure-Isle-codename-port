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
var realPath = StringTools.replace(FileSystem.absolutePath(Assets.getPath("assets/images/SmileDogBG.webp")), "/", "\\");
var realPath2 = StringTools.replace(FileSystem.absolutePath(Assets.getPath("assets/images/stages/smile/hellnah.png")), "/", "\\");
var realPath3 = StringTools.replace(FileSystem.absolutePath(Assets.getPath("assets/images/stages/smile/HURRAY.png")), "/", "\\");

window.x = winX;
window.y = winY;
window.width = resizex;
window.height = resizey;
changex = window.x;
changey = window.y;
window.fullscreen = true;
window.resizable = false;
window.opacity = 1;
canPause = true;

function onCountdown(event:CountdownEvent) event.cancelled = true;

function addBehindDad(thing){
    insert(members.indexOf(dad), thing);
}

function create(){
    player.cpu = true;

	camGame.alpha = 0.001;

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

	laugh = new FlxSprite();
    laugh.frames = Paths.getSparrowAtlas('stages/smile/windows/laugh');
    laugh.animation.addByPrefix('laugh', "laugh dog", 48, true);
	laugh.alpha = 0.001;
	laugh.camera = camHUD;
	laugh.scale.set(.6,.6);
	laugh.screenCenter();
	add(laugh);

	error = new FlxSprite().loadGraphic(Paths.image("stages/smile/BLUESCREENXP"));
	error.camera = camHUD;
	error.screenCenter();
	error.alpha = 0.001;
	add(error);

	//healthBar
	healthFil = new FlxSprite(840,540).loadGraphic(Paths.image("healthbars/smile/win-p1"));
	healthFil.camera = camHUD;
	add(healthFil);

	healthFrame = new FlxSprite(770,470).loadGraphic(Paths.image("healthbars/smile/frame"));
	healthFrame.camera = camHUD;
	add(healthFrame);

	tweenWindow1Y = FlxTween.tween(window, {y: changey + changex / 3}, 7, {ease: FlxEase.quadInOut, type: 4});
    tweenWindow1X = FlxTween.tween(window, {x: changex + changex / 2}, 4, {ease: FlxEase.quadInOut, type: 4});
    tweenWindow1Y.active = tweenWindow1X.active = false;

	//stage.getSprite("FIRST_BG").alpha = stage.getSprite("FIRST_PC").alpha = 0;

}
function destroy(){
    setWallpaper(prevWallpaper);
    window.resizable = true;
}
function onSongStart(){
	FlxTween.tween(intro1.scale, {'x': 1, 'y': 1}, 30, {ease: FlxEase.circInOut});
}
function wallpaper(){
	canPause = false;
	setWallpaper(realPath);
	//FlxG.openURL('https://media.discordapp.net/attachments/1256905043462852665/1264307858036752485/Smile.jpg?ex=669d65f3&is=669c1473&hm=9b33f71a870ddf5dc61be3b7f970f0191153c3490b829b9380cee8ca6a17be52&format=webp&');
	camGame.alpha = window.opacity = 0;
}
function move(){
	intro1.alpha = 0.0001;
	remove(intro1);
	camGame.alpha = 1;
    camGame.flash();
}
function fullwin(){
	FlxTween.tween(window, {x: 0, y: 0, width: fsX, height: fsY}, 1.6, {
	ease: FlxEase.expoIn,
	onComplete: function(twn:FlxTween){
		window.borderless = false;
	}});
}
function postCreate(){
	healthBar.alpha = healthBarBG.alpha = 0;
}
function update(){
	iconP1.alpha = iconP2.alpha = 0.001;
	DEATHTOALL.x = dad.x;
	DEATHTOALL.y = dad.y - 100;
}
function windowmoves(){	
	cutscene = true;
	boyfriend.alpha = 0.001;
	DEATHTOALL.alpha = 1;
	window.fullscreen = false;
	window.title = "STEP RIGHT TO YOUR GRAVE - SPREAD THE WORD";
	FlxTween.tween(window, {x: changex / 4, y: Std.int(changey / 4)}, 0.01, {ease: FlxEase.backIn});
    new FlxTimer().start(.1, function(tmr:FlxTimer)
	{
		tweenWindow1X.active = tweenWindow1Y.active = true;
		camGame.alpha = 1;
		canPause = true;
		stage.getSprite("FIRST_BG").alpha = stage.getSprite("FIRST_PC").alpha = 0;
	});
}
function thing(){
	window.fullscreen = false;
	window.opacity = 1;
	camGame.alpha = 0;
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
	noMove();
}
function laughing(){
	laugh.animation.play('laugh');
	laugh.alpha = 1;
	window.fullscreen = true;
	window.resizable = false;	
	window.borderless = false;
	camGame.alpha = healthFrame.alpha = healthFil.alpha = 0.001;
}
function noLaugh(){
	window.fullscreen = false;
	laugh.alpha = 0.001;
	camGame.alpha = healthFrame.alpha = healthFil.alpha = 1;
}
function noMove(){
	tweenWindow1X.active = tweenWindow1Y.active = false;	
	FlxTween.tween(window, {x: winX, y: winY, width: resizex, height: resizey}, .4, {ease: FlxEase.expoOut});
}
function MoveAgian(){
	tweenWindow1X.active = tweenWindow1Y.active = true;
}
function back(){
	setWallpaper(realPath2);
	boyfriend.alpha = 1;
	error.alpha = 0;
	boyfriend.x = 900;
	dad.x = 0;
}
function ending(){
	setWallpaper(realPath);
	DEATHTOALL.alpha = 1;
	boyfriend.alpha = 0.001;
}
function randomMove(){
	tweenWindow1X.active = tweenWindow1Y.active = false;	
	window.x = FlxG.random.float(200, 400);
	window.y = FlxG.random.float(100, -0.5);
	trace(window.x);
	trace(window.y);
}
function endReal(){
	tweenWindow1X.active = tweenWindow1Y.active = false;	
	FlxTween.tween(window, {opacity: 0}, 1, {ease: FlxEase.expoOut});
	setWallpaper(realPath3);
}
function onSongEnd(){
	window.opacity = 1;
}