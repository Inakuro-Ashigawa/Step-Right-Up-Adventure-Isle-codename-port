var dad2;
var blackBarThingie2:FlxSprite;
var boder1 = new FlxSprite(1000,40).loadGraphic(Paths.image('stages/trinity/michael/border'));
var boder2 = new FlxSprite(796,-40).loadGraphic(Paths.image('stages/trinity/michael/border'));
var cutsceneCamera:FlxCamera;

function onCountdown(event:CountdownEvent) event.cancelled = true;

function create(){
    dad2 = strumLines.members[3].characters[0];
    dad2.alpha = dad.alpha = 0.001;

    cutsceneCamera = new FlxCamera();
	cutsceneCamera.bgColor = 0;
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(cutsceneCamera, false);
	FlxG.cameras.add(camHUD, false);
}
function postCreate(){
    //trasitions
    //your not
    pretty = new FlxSprite();
    pretty.frames = Paths.getSparrowAtlas('stages/trinity/transition/pretty');
    pretty.animation.addByPrefix('pretty', "idle", 12, false);
    pretty.animation.finishCallback = function (n:String) {
        pretty.alpha = bg1.alpha = 0.001;
        bg2.alpha = 1;
    }
    pretty.screenCenter();
    pretty.camera = cutsceneCamera;
    pretty.scale.set(6,5);
    pretty.alpha = 0.001;
    add(pretty);

    //suffer part
    suffer = new FlxSprite();
    suffer.frames = Paths.getSparrowAtlas('stages/trinity/transition/suffer');
    suffer.animation.addByPrefix('suffer', "idle", 12, false);
    suffer.animation.finishCallback = function (n:String) {
        suffer.alpha = 0.001;
        dad.alpha = 1;
    }
    suffer.screenCenter();
    suffer.camera = cutsceneCamera;
    suffer.scale.set(4,5);
    suffer.alpha = 0.001;
    add(suffer);

    boder1.scrollFactor.set(1,1);
    boder2.scrollFactor.set(1,1);
    add(boder1);
    add(boder2);
    boder2.alpha = 0;

    blackBarThingie2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackBarThingie2.setGraphicSize(Std.int(blackBarThingie2.width * 10));
    blackBarThingie2.alpha = 0;
    blackBarThingie2.cameras = [camGame];
    add(blackBarThingie2);
}
function events(name){
    if (name == "pretty"){
        pretty.animation.play('pretty');
        pretty.alpha = dad.alpha = 1;
    }
    if (name == "gone"){
        camGame.alpha = 0;
    }
    if (name == "back"){
        camGame.alpha = 1;
        bg2.alpha = 0;
    }
    if (name == "trasiton"){
        defaultCamZoom = 3.5;
        boyfriend.x = 1000;
        boyfriend.y = 40;
        boder2.alpha = 1;
        dad.alpha = 0.001;
    }
    if (name == "moveBorder"){
        FlxTween.tween(boder1, {x: 796}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(boyfriend, {x: 796}, 1, {ease: FlxEase.circOut});
    }
    if (name == "suffer"){
        suffer.animation.play('suffer');
        suffer.alpha = 1;
    }
    if (name == "peak"){
        boder1.alpha = boder2.alpha = 0;
        michaelBG.alpha = 1;
    }
    if (name == "fade1"){
        FlxTween.tween(blackBarThingie2, {alpha: 1}, 2, {ease: FlxEase.circOut});
    }
    if (name == "fade2"){
        FlxTween.tween(blackBarThingie2, {alpha: 0}, 2, {ease: FlxEase.circOut});
        alone_actual.alpha = 1;
        michaelBG.alpha = dad.alpha = 0;
        boyfriend.cameraOffset.x = 50;
        zoom(3.5);
    }
}

function postUpdate(){
    healthBar.alpha = iconP1.alpha = iconP2.alpha = healthBarBG.alpha = 0;
}
function zoom(zoom) {
    defaultCamZoom = zoom;
}