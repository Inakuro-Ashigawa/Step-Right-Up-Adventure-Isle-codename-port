import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.editors.EditorPicker;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.MusicBeatState;

var optionsHitbox,freeplayHitbox,galleryHitbox,creditsHitbox,spinHitbox:FlxSprite;
var curSelected:Int = 0;

function create(){
    CoolUtil.playMusic(Paths.music('freakymenu'), false, 0);
    FlxTween.tween(FlxG.sound.music, {volume: .6}, 1);

    bg = new FlxSprite().loadGraphic(Paths.image('mainMenu/background'));
    bg.screenCenter();
    bg.scale.set(.38,.38);
    add(bg);

    arcbg = new FlxSprite().loadGraphic(Paths.image('mainMenu/arcbg'));
    arcbg.screenCenter();
    arcbg.scale.set(.4,.4);
    add(arcbg);

    arc = new FlxSprite().loadGraphic(Paths.image('mainMenu/arc'));
    arc.screenCenter();
    arc.scale.set(.5,.5);
    add(arc);
    
    wheel = new FlxSprite(-260,-230).loadGraphic(Paths.image('mainMenu/wheel'));
    wheel.scale.set(.5,.5);
    add(wheel);

    podium = new FlxSprite().loadGraphic(Paths.image('mainMenu/podium'));
    podium.screenCenter();
    podium.scale.set(.38,.4);
    add(podium);

    thumper = new FlxSprite(400,-80);
    thumper.frames = Paths.getSparrowAtlas('mainMenu/thumper');
    thumper.animation.addByPrefix('idle', "idle", 12, true);
	thumper.animation.play('idle');
    thumper.scale.set(.5,.5);
    add(thumper);

    optionsHitbox = new FlxSprite(480,520);
    optionsHitbox.makeGraphic(100, 100, 0xFFFF0000);
    optionsHitbox.scrollFactor;
    add(optionsHitbox);

    freeplayHitbox = new FlxSprite(140,500);
    freeplayHitbox.makeGraphic(100, 100, 0xFFFF0000);
    freeplayHitbox.scrollFactor;
    add(freeplayHitbox);

    galleryHitbox = new FlxSprite(450,620);
    galleryHitbox.makeGraphic(100, 100, 0xFFFF0000); false;
    galleryHitbox.scrollFactor;
    add(galleryHitbox);

    creditsHitbox = new FlxSprite(160,640);
    creditsHitbox.makeGraphic(24, 24, 0xFFFF0000);
    creditsHitbox.scrollFactor;
    add(creditsHitbox);

    spinHitbox = new FlxSprite(870,600);
    spinHitbox.makeGraphic(100, 100, 0xFFFF0000);
    spinHitbox.scrollFactor;
    add(spinHitbox);

    glow = new FlxSprite(0,0).loadGraphic(Paths.image('mainMenu/glow'));
    glow.scale.set(.38,.4);
    add(glow);
    glow.alpha = 1;

    optionsHitbox.visible = freeplayHitbox.visible = galleryHitbox.visible = creditsHitbox.visible = spinHitbox.visible = false;
}
function update(elapsed){
    shits();
}
function shits(){
    if (FlxG.mouse.overlaps(optionsHitbox) && FlxG.mouse.justPressed) {
        FlxG.switchState(new OptionsMenu());
    }
    if (FlxG.mouse.overlaps(freeplayHitbox) && FlxG.mouse.justPressed) {
        FlxG.switchState(new ModState('scary/SRUFreeplay'));
    }
    if (FlxG.keys.justPressed.SEVEN) {
        openSubState(new EditorPicker());
        persistentUpdate = false;
        persistentDraw = true;
    }
    if (controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = false;
        persistentDraw = true;
    }
    if (controls.BACK){
        FlxG.switchState(new TitleState());
    }
}