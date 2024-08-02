import flixel.text.FlxTextBorderStyle;

var xx,yy,mx,my:Float = 0;
var zoom,zz:Float = 1;
var lerpVal = 0.04;
var Hitbox,blackBarThingie2:FlxSprite;
var moveable,title,oneClick:Bool = false;
var cinematicBar1:FunkinSprite = null;
var cinematicBar2:FunkinSprite = null;

function create(){
    bg = new FlxSprite().loadGraphic(Paths.image('title/background/background'));
    bg.screenCenter();
    bg.scale.set(.7,.7);
    add(bg);

    door = new FlxSprite(420,140);
    door.frames = Paths.getSparrowAtlas('title/background/door');
    door.animation.addByPrefix('idle', "doorclosed0000", 1, false);
    door.animation.addByPrefix('open', "dooropen0000", 1, false);
    door.animation.addByPrefix('open', "dooropening", 12, false);
	door.animation.play('idle');
    add(door);
    
    foreground = new FlxSprite().loadGraphic(Paths.image('title/background/foreground'));
    foreground.screenCenter();
    foreground.scale.set(.7,.7);
    add(foreground);
    
    rays = new FlxSprite().loadGraphic(Paths.image('title/background/rays'));
    rays.screenCenter();
    rays.scale.set(.7,.7);
    rays.alpha = .9;
    add(rays);

    vignette = new FlxSprite().loadGraphic(Paths.image('title/background/vignette'));
    vignette.screenCenter();
    vignette.scale.set(.7,.7);
    vignette.alpha = .7;
    add(vignette);

    doorS = new FlxSprite(490,160);
    doorS.frames = Paths.getSparrowAtlas('title/outlines/door');
    doorS.animation.addByPrefix('idle', "selected", 12, true);
	doorS.animation.play('idle');
    add(doorS);
    doorS.alpha = 0;

    Hitbox = new FlxSprite(500,200);
    Hitbox.makeGraphic(300, 300, 0xFFFF0000);
    Hitbox.scrollFactor;
    Hitbox.visible = false;
    add(Hitbox);

    words = new FlxSprite().loadGraphic(Paths.image('title/background/logo'));
    words.screenCenter();
    words.scale.set(.7,.7);
    add(words);

    blackBarThingie2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackBarThingie2.setGraphicSize(Std.int(blackBarThingie2.width * 10));
    blackBarThingie2.alpha = .6;
    add(blackBarThingie2);


    lyrics = new FlxText(310,760);
    lyrics.setFormat(Paths.font("felix.otf"), 48, FlxColor.YELLOW ,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK , "center");
    lyrics.borderSize = 3;
    lyrics.text = 'PRESS ENTER TO START';
    add(lyrics);

    words = new FlxText(310,760);
    words.setFormat(Paths.font("punk-mono.ttf"), 48, FlxColor.WHITE ,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK , "center");
    words.borderSize = 2;
    words.screenCenter(FlxAxes.X);  
    add(words);

    CoolUtil.playMusic(Paths.music('tea-time'), false, 0);
    Conductor.changeBPM(120);

    FlxG.camera.zoom = .7;
    moveable = true;

    
}
function words(words){
    lyrics.text = words;
}
function beatHit(){
    if (title)
    lyrics.visible = !lyrics.visible;
}
function mouseLook() {  
    if (moveable){
        mx = (FlxG.mouse.screenX - 640) / 10;
        my = (FlxG.mouse.screenY - 320) / 10;
    
        xx = lerp(xx, mx,lerpVal);
        yy = lerp(yy, my, lerpVal);
        zz = lerp(zz, zoom, (lerpVal/4)*3);
    
        FlxG.camera.scroll.x = xx;
        FlxG.camera.scroll.y = yy;
        FlxG.camera.zoom = .73;
    }
}
function update(){
    mouseLook();

    if (FlxG.mouse.overlaps(door) && moveable){
        doorS.alpha = 1;
    }else{
        doorS.alpha = 0;
    }
    if (controls.ACCEPT && title && !oneClick){
        introShits();
    }
    if ((FlxG.mouse.justPressed && FlxG.mouse.overlaps(Hitbox) && moveable)) Menushits();
}
function introShits(){
    oneClick = true;
    lyrics.alpha = 0;
    FlxG.sound.play(Paths.sound("confirmMenu"));
    new FlxTimer().start(2, function(tmr:FlxTimer)
    {
        ticketGet.animation.play('idle');
    });
    new FlxTimer().start(2.6, function(tmr:FlxTimer)
    {
        FlxTween.tween(logo, {alpha: 0}, 2, {ease: FlxEase.quadOut});
        FlxTween.tween(ticketGet, {alpha: 0}, 2, {ease: FlxEase.quadOut});
    });
    new FlxTimer().start(3, function(tmr:FlxTimer)
    {
        FlxTween.tween(booth, {alpha: 1}, 2, {ease: FlxEase.quadOut});
    });
    new FlxTimer().start(4, function(tmr:FlxTimer)
    {
        thumper.animation.play('come');
        thumper.alpha = 1;
    });
    new FlxTimer().start(5, function(tmr:FlxTimer)
    {
        words.text = "hey";
        words.screenCenter(FlxAxes.X); 
    });
    new FlxTimer().start(5.7, function(tmr:FlxTimer)
    {
        thumper.animation.play('strech');
        words.screenCenter(FlxAxes.X); 
        words.text = "Got Your Ticket ?";
    });
}
//for main menu hehe
function Menushits(){
    moveable = false;
    doorS.alpha = 0;
    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        FlxTween.tween(FlxG.camera, {zoom: 1.5}, 1, {ease: FlxEase.quadOut});
        door.animation.play('open');
    });
    new FlxTimer().start(3, function(tmr:FlxTimer)
    {
        FlxG.switchState(new MainMenuState());
    });
}