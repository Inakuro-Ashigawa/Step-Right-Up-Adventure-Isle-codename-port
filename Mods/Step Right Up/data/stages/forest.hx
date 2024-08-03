import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideoSprite;
var dad2;
var fullTimer:Float = 0;
var cutsceneCamera:FlxCamera;
var cancelCameraMove:Bool = false;
var blackBarThingie2,whiteThingie,healthBarCross:FlxSprite;
var boder1 = new FlxSprite(1000,36).loadGraphic(Paths.image('stages/trinity/michael/border'));
var boder2 = new FlxSprite(-1000,-40).loadGraphic(Paths.image('stages/trinity/michael/border'));
var boderv1 = new FlxSprite(996,-240).loadGraphic(Paths.image('stages/trinity/michael/border_vertical'));
var boderv2 = new FlxSprite(696,-240).loadGraphic(Paths.image('stages/trinity/michael/border_vertical'));
var mortis:FlxVideoSprite;
var pixelShader = new CustomShader("pixel perfect");

function onCountdown(event:CountdownEvent) event.cancelled = true;

function onCameraMove(e) if(cancelCameraMove) e.cancel();

function addBehindDad(thing){
    insert(members.indexOf(dad), thing);
}
function create(){
    pixelShader.blockSize = 6; // (6 due to assets scale)
    pixelShader.res = [FlxG.width, FlxG.height];
    camGame.addShader(pixelShader); 

    PlayState.instance.comboGroup.alpha = 0;

    dad2 = strumLines.members[3].characters[0];
    remove(dad2);
    addBehindDad(dad2);
    dad2.y = 200;
    dad2.x = 800;

    gf.alpha = dad2.alpha = dad.alpha = 0.001;

    cutsceneCamera = new FlxCamera();
	cutsceneCamera.bgColor = 0;
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(cutsceneCamera, false);
	FlxG.cameras.add(camHUD, false);  
}
//pauses video
function onSubstateOpen(event) if (mortis!= null && paused && mortis.alpha == 1) mortis.pause();
function onSubstateClose(event) if (mortis!= null && paused && mortis.alpha == 1) mortis.resume();
function focusGained() if (mortis != null && !paused && mortis.alpha == 1) mortis.resume();

function postCreate(){
    healthBarCross = new FlxSprite().loadGraphic(Paths.image("healthbars/trinity/bar-p1"));
	healthBarCross.camera = camCinema;
    healthBarCross.scale.set(3,3);
    healthBarCross.x = 1200;
	healthBarCross.screenCenter(FlxAxes.Y);
	add(healthBarCross);

    //trasitions
    //your not pretty
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

    //worship part
    worship = new FlxSprite();
    worship.frames = Paths.getSparrowAtlas('stages/trinity/transition/bang');
    worship.animation.addByPrefix('worshipME', "idle", 12, false);
    worship.animation.finishCallback = function (n:String) {
        worship.alpha = tweo.alpha = dad2.alpha = gf.alpha = 0.001;
    }
    worship.screenCenter();
    worship.camera = cutsceneCamera;
    worship.scale.set(4,5);
    worship.alpha = 0.001;
    add(worship);

    mortis = new FlxVideoSprite();
    mortis.load(Assets.getPath(Paths.video("cutscenes/mortis")));
    mortis.cameras = [cutsceneCamera];
    mortis.play();
    mortis.pause();
    mortis.alpha = 0.001;
    mortis.antialiasing = false;
    add(mortis);
    
    boder1.scrollFactor.set(1,1);
    boder2.scrollFactor.set(1,1);
    boderv1.scrollFactor.set(1,1);
    boderv2.scrollFactor.set(1,1);
    boderv1.scale.set(1.2,1.2);
    boderv2.scale.set(1.2,1.2);
    boder2.alpha = boder1.alpha = 0;
    boderv1.alpha = boderv2.alpha = 0;
    add(boder1);
    add(boder2);
    add(boderv1);
    add(boderv2);

    blackBarThingie2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackBarThingie2.setGraphicSize(Std.int(blackBarThingie2.width * 10));
    blackBarThingie2.alpha = 0;
    blackBarThingie2.cameras = [camGame];
    add(blackBarThingie2);

    whiteThingie = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    whiteThingie.setGraphicSize(Std.int(whiteThingie.width * 10));
    whiteThingie.alpha = 0;
    whiteThingie.cameras = [camGame];
    add(whiteThingie);
}
function update(elapsed:Float){
    pixelShader.blockSize = .3 * FlxG.camera.zoom;
}

function events(name){
    if (name == "pretty"){
        pretty.animation.play('pretty');
        pretty.alpha = dad.alpha = 1;
    }
    if (name == "gone"){
        camGame.alpha = bg2.alpha = 0;
    }
    if (name == "back"){
        camGame.alpha = 1;
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
        FlxTween.tween(boder2, {x: 796}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(boyfriend, {x: 780}, 1, {ease: FlxEase.circOut});
        boder1.alpha = 1;
    }
    if (name == "suffer"){
        suffer.animation.play('suffer');
        suffer.alpha = 1;
        trace("suffer");
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
    if (name == "whitefade"){
        FlxTween.tween(whiteThingie, {alpha: 1.1}, 2, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){
            alone_actual.alpha = whiteThingie.alpha = 0.001;
            boderv1.alpha = boderv2.alpha = dad.alpha = 1;
            boyfriend.y = 40;
            boyfriend.x = 1000;
            dad.y = -35;
            dad.x = 710;
            boderv1.y = boderv2.y = -80;
            zoom(2.5);
            trace("Father");
        }});
    }
    if (name == "two"){
        dad2.alpha = gf.alpha = tweo.alpha= 1;
        boderv1.alpha = boderv2.alpha = 0.001;
        bg2.alpha = 0;
        dad.x = 900;
        dad.y = 150;
        cancelCameraMove = true;
        camFollow.y = 160;
        zoom(2);
        trace("2v2");
    }
    if (name == "worship"){
        worship.animation.play('worshipME');
        worship.alpha = 1;
    }
    if (name == "last"){
        entrance.alpha = 1;
        boyfriend.x = 744.5;
        boyfriend.y = 66.5; 
        cancelCameraMove = false;
        zoom(4);     
    }
    if (name == "solo"){
        entrance.alpha = dad.alpha =  0.001;
    }
    if (name == "video"){
        mortis.alpha = 1;
        FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(healthBarCross, {alpha: 0}, 1, {ease: FlxEase.circOut});
        mortis.play();
    }
}
function zoomINTween(){
    FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.linear});		
}
function postUpdate(){
    healthBar.alpha = iconP1.alpha = iconP2.alpha = healthBarBG.alpha = 0;
}
function zoom(zoom) {
    defaultCamZoom = zoom;
}