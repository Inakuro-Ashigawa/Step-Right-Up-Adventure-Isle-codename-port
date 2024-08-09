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
var scoreTxt1:FlxText;
var currentDogIndex:Int = -1; 
var cancelCameraMove:Bool = true;

function onCameraMove(e) if(cancelCameraMove) e.cancel();

function create(){
    dog1 = strumLines.members[0].characters[1];
    dog2 = strumLines.members[0].characters[2];
    dog3 = strumLines.members[0].characters[3];
    camFollow.x = 200;
    dog.alpha = dog1.alpha = dog2.alpha = dog3.alpha = 0.0001;

    dog1.setPosition(-1300,300);
    dog2.setPosition(1200,-300);

    currentDog = null;
}
function postCreate(){
    health = 2;
    healthBar.alpha = healthBarBG.alpha = iconP1.alpha = iconP2.alpha = 0;
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

    for (i in [scoreTxt,missesTxt,accuracyTxt]){
		remove(i);
    }
    defaultcamZoom = camGame.zoom = .5;
    FlxTween.tween(camFollow, {x: 900, y: 300}, 0.1, {ease: FlxEase.linear});

    healthBar.antialiasing = healthBarBG.antialiasing =true;  
        
}
function update(){

}
function showRandomDog(){
    var randomIndex:Int;

    do {
        randomIndex = Std.int(Math.random() * 3);
    } while (randomIndex == currentDogIndex);

    var newDog;

    switch (randomIndex) {
        case 0:
            newDog = dog;
            camFollow.setPosition(900, 300);
            defaultCamZoom = .8;
        case 1:
            newDog = dog1;
            camFollow.setPosition(-200, 500);
            defaultCamZoom = .7;
        case 2:
            newDog = dog2;
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
