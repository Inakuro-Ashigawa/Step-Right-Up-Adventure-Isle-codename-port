import flixel.ui.FlxBar;
import flixel.util.FlxPoint;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar.FlxBarFillDirection;

var dog1;
var dog2;
var dog3;
var dog = dad;
var currentDog;
var birds:Array<FlxSprite> = [];
var scoreTxt1:FlxText;
var shooting:Bool = false;
var currentDogIndex:Int = -1; 


function preload(){
    FlxAssets.loadSprite("Bird_up", Paths.getSparrowAtlas('stages/duck/Bird_up'));
}
function addBirds(thing){
    insert(members.indexOf(stage.getSprite("lake")), thing);
    birds.push(thing); 
}

function create(){
    dog1 = strumLines.members[0].characters[1];
    dog2 = strumLines.members[0].characters[2];
    dog3 = strumLines.members[0].characters[3];
    camFollow.x = 200;
    dog.alpha = dog1.alpha = dog2.alpha = dog3.alpha = 0.0001;

    dog1.setPosition(-1300,300);
    dog2.setPosition(1200,-300);

    for (i in 0...5) { 
        var bird = new FlxSprite();
        bird.frames = Paths.getSparrowAtlas('stages/duck/Bird_up');
        bird.animation.addByPrefix('up', "Bird up", 24, false);
        bird.animation.addByPrefix('attack', "Bird atk", 24, false);
        bird.animation.play('up');
        bird.x = bird.x - i * 20;
    }
    healthBar = new FlxBar(390, 630, FlxBarFillDirection.RIGHT_TO_LEFT, 500, 200, PlayState.instance, "health", 0, maxHealth);
    healthBar.createImageBar(Paths.image("healthbars/duck/duck-p2"), Paths.image("healthbars/duck/duck-p1")); 
    healthBar.camera = camHUD;
    healthBar.scale.set(.6,.6);
        
    healthBarBG = new FlxSprite().loadGraphic(Paths.image("healthbars/duck/base"));
    healthBarBG.cameras = [camHUD];
    healthBarBG.screenCenter();
    healthBarBG.scale.set(.6,.6);
    healthBarBG.y += 290;
    add(healthBarBG);
    add(healthBar);  
    currentDog = null;
}
function take(amount){
    health = amount;
}
function postCreate(){
    inst.volume = 2;
    vocals.volume = .6;
    healthBar.alpha = healthBarBG.alpha = iconP1.alpha = iconP2.alpha = 0;
    health = 2;

    for (i in [scoreTxt,missesTxt,accuracyTxt]){
		remove(i);
    }
    defaultcamZoom = camGame.zoom = .5;
    FlxTween.tween(camFollow, {x: 900, y: 300}, 0.1, {ease: FlxEase.linear});

    healthBar.antialiasing = healthBarBG.antialiasing =true;  
        
        
    crosshair = new FlxSprite().loadGraphic(Paths.image('stages/duck/crosshair'));
    crosshair.scrollFactor.set;
    add(crosshair);

    crosshair2 = new FlxSprite().loadGraphic(Paths.image('stages/duck/crosshairTarget'));
    crosshair2.scrollFactor.set;
    add(crosshair2);
    crosshair2.alpha = 0.001;
}
function onCameraMove(e) e.cancel();
function update(){
    crosshair.setPosition(FlxG.mouse.x - 130, FlxG.mouse.y - 90);
    crosshair2.setPosition(FlxG.mouse.x - 130, FlxG.mouse.y - 90);

    if (FlxG.mouse.justPressed) {
        startShooting();
        checkBirdClick();
    }
}
function checkBirdClick(){
    for (bird in birds) {
        if (bird.overlapsPoint(FlxG.mouse.getWorldPosition())) { 
            bird.kill();
            birds.remove(bird);
            break;
        }
    }
}
function showRandomDog(){
    cancelCameraMove = true;
    var randomIndex:Int;

    do {
        randomIndex = Std.int(Math.random() * 3);
    } while (randomIndex == currentDogIndex);

    switch (randomIndex) {
        case 0:
            newDog = dog;
            if (!shooting)
            camFollow.setPosition(900, 300);
            defaultCamZoom = .8;
        case 1:
            newDog = dog1;
            if (!shooting)
            camFollow.setPosition(-200, 500);
            defaultCamZoom = .7;
        case 2:
            newDog = dog2;
            if (!shooting)
            camFollow.setPosition(1900, 200);
            defaultCamZoom = .8;
    }

    if (currentDog != null) {
        FlxTween.tween(currentDog, {alpha: 0.0001}, 0.1, {ease: FlxEase.linear, onComplete: function(t:FlxTween) {
            FlxTween.tween(newDog, {alpha: 1}, 0.1, {ease: FlxEase.linear});
        }});
    } else {
        FlxTween.tween(newDog, {alpha: 1}, 0.1, {ease: FlxEase.linear});
    }

    currentDog = newDog;
    currentDogIndex = randomIndex;
}
function startShooting(){
    crosshair2.alpha = 1;
    new FlxTimer().start(.08, function(start:FlxTimer){
        crosshair2.alpha = 0.001;
    });
}