var boyfriendtween:FlxTween;
var whiteThing,blackBarThingie2,m_scene2,trans:FlxSprite;

function addBehindDad(thing){
    insert(members.indexOf(dad), thing);
}
function create(){
    m_scene2 = new FlxSprite(-2290,-600);
    m_scene2.frames = Paths.getSparrowAtlas('stages/mado/bgs/transitions/monoe_walking');
    m_scene2.animation.addByPrefix('walk bg', "walk bg", 18, true);
    m_scene2.animation.play('walk bg');
    m_scene2.setGraphicSize(2020, 1180);
    m_scene2.updateHitbox();
    addBehindDad(m_scene2);
    m_scene2.alpha = 0;

    whiteThing = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    whiteThing.setGraphicSize(Std.int(whiteThing.width * 10));
    whiteThing.alpha = 0;
    whiteThing.cameras = [camGame];
    add(whiteThing);

    blackBarThingie2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackBarThingie2.setGraphicSize(Std.int(blackBarThingie2.width * 10));
    blackBarThingie2.alpha = 0;
    blackBarThingie2.cameras = [camGame];
    add(blackBarThingie2);

    trans = new FlxSprite(-2290,-600);
    trans.frames = Paths.getSparrowAtlas('stages/mado/bgs/transitions/monoko/monoko-trans');
    trans.animation.addByPrefix('1', "monoko-trans 1", 1, false);
    trans.animation.addByPrefix('2', "monoko-trans 2", 1, false);
    trans.animation.addByPrefix('3', "monoko-trans 3", 1, false);
    trans.animation.addByPrefix('4', "monoko-trans 4", 1, false);
    trans.setGraphicSize(2020, 1180);
    trans.updateHitbox();
    addBehindDad(trans);
    trans.alpha = 0;
}
function transStart(){
    FlxTween.tween(whiteThing, {alpha: 1}, 1.33, {ease: FlxEase.backInOut});
}
function Walk(){
    FlxTween.tween(whiteThing, {alpha: 0}, 2, {ease: FlxEase.backInOut});
    boyfriend.x = boyfriend.x - 900;
    boyfriend.y = boyfriend.y - 200;
    nexus.alpha = 0;
    forest.alpha = 1;
    new FlxTimer().start(.2, function(tmr:FlxTimer){
        FlxTween.tween(boyfriend, {x: 800}, 70, {ease: FlxEase.quadInOut});
    });
}
function walk2(){
    FlxTween.tween(whiteThing, {alpha: 0}, .60, {ease: FlxEase.backInOut});
    forest.alpha = 0;
    block.alpha = 1;
}
function walk3(){
    FlxTween.tween(whiteThing, {alpha: 0}, .60, {ease: FlxEase.backInOut});
    block.alpha = 0;
    desert.alpha = 1;
}
function walkFinal(){
    FlxTween.tween(whiteThing, {alpha: 0}, .60, {ease: FlxEase.backInOut});
    desert.alpha = 0;
}
function fadeOUT(){
    FlxTween.tween(blackBarThingie2, {alpha: 1}, 1.33, {ease: FlxEase.backInOut});
    FlxTween.cancelTweensOf(boyfriend);
}
function fadeOUTEnd(){
    FlxTween.tween(blackBarThingie2, {alpha: 0}, .6, {ease: FlxEase.backInOut});
}
function bgAppear(){
    m_scene2.alpha = 1;
}
function animTrans(anim){
    trans.animation.play(anim);

    if (trans.alpha == 0){
        trans.alpha = 1;
        m_scene2.alpha = 0;
    }
}
function transEnd(){
    trans.alpha = 0;
    monoko.alpha = boyfriend.alpha = dad.alpha = 1;
    boyfriend.x = -380;
    boyfriend.y = -1350;
    gf.x = -880;
    gf.y = -1250;
    boyfriend.cameraOffset.x = 280;
    dad.cameraOffset.x = -500;
    dad.cameraOffset.y = 200;
    dad.x = -341.5;
    dad.y = -1611;
    setZoom(.7);
}
function fadeTrans(){
    FlxTween.tween(trans, {alpha: 0}, .6, {ease: FlxEase.backInOut});
}
function alpha(peoples){
    if (peoples == "bf-dad"){
        boyfriend.alpha = dad.alpha = 0;
    }
}
function setZoom(zoom) {
    defaultCamZoom = zoom;
}