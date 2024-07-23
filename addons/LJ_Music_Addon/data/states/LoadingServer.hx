//a

var subCam:FlxCamera;

var loadingTxt:FlxText;
function create() {
	camera = subCam = new FlxCamera();
	subCam.bgColor = 0;
    subCam.alpha = 0.0001;
	FlxG.cameras.add(subCam, false);

    var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x80000000);
    bg.screenCenter();
    add(bg);

    var loadingBF = new FlxSprite();
    loadingBF.frames = Paths.getSparrowAtlas("menus/pauseAlt/bfLol");
    loadingBF.animation.addByPrefix("idle", "funnyThing instance 1", 12, true);
    loadingBF.animation.play("idle");
    loadingBF.screenCenter();
    loadingBF.y += loadingBF.height;
    add(loadingBF);

    loadingTxt = new FlxText(0,0,0, "Loading...", 32);
    loadingTxt.setPosition(0 - loadingTxt.width, loadingTxt.height);
    add(loadingTxt);

    
    FlxTween.tween(camera, {alpha: 1}, 1);
    FlxG.sound.music.fadeOut(0.5, 0.25);
}

function update(elapsed) {
    loadingTxt.x += 200*elapsed;
    if (loadingTxt.x > FlxG.width + loadingTxt.width + 10) loadingTxt.x = 0 - loadingTxt.width;
    if (loadingTxt.x < 0 - loadingTxt.width) loadingTxt.x = FlxG.width + loadingTxt.width + 10;
}

var onClosing = false;
function onClose(e) {
    if (onClosing) return;
    onClosing = true;
    FlxTween.tween(camera, {alpha: 0}, 1, {onComplete: close});

    e.cancel();
}