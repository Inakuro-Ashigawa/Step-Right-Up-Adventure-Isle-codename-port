//vars
var SongName = '';
var curSelected:Int = 0;
var Characters:Array<String> = [
	'duckseason',
	'faith',
	'smiledog',
	'tattletail',
	'yumenikki'
];
function create(){
    bg = new FlxSprite().loadGraphic(Paths.image('freeplay/background'));
    bg.screenCenter();
    add(bg);

    char = new FlxSprite(0,0);
    char.frames = Paths.getSparrowAtlas('freeplay/anims/' + curSelected);
    char.animation.addByPrefix('idle', "play", 24, false);
	char.animation.play('idle');
    char.screenCenter();
    add(char);

    curtain = new FlxSprite(-90,0).loadGraphic(Paths.image('freeplay/curtain'));
    add(curtain);

    bottom = new FlxSprite(-90,600).loadGraphic(Paths.image('freeplay/bottom'));
    bottom.scale.set(.9,.9);
    add(bottom);

    wheel = new FlxSprite(440,530).loadGraphic(Paths.image('freeplay/wheel'));
    add(wheel);

    arrow = new FlxSprite(630,450).loadGraphic(Paths.image('freeplay/arrow'));
    add(arrow);

    logo = new FlxSprite(100,600);
    logo.loadGraphic(Paths.image('freeplay/logos/' + curSelected ));
    add(logo);

    changeItem(0);
}
function update(){
    if (controls.LEFT_P){
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(-1);
    }       
    if (controls.RIGHT_P){
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(1);
    }	    
    if(controls.BACK){
        FlxG.switchState(new MainMenuState());
    }
    if (curSelected == 0){
        char.y = 100;
        char.x = 350;
        logo.x = 100;
        logo.y = 600;
    }
    if (curSelected == 1){
        char.y = 30;
        char.x = 0;
        logo.x = 100;
        logo.y = 600;   
        SongName = 'no-more';
    }
    if (curSelected == 2){
        SongName = 'Mortis';
    }
    if (curSelected == 3){
        char.y = 150;
        char.x = 400;
        logo.x = 100;
        logo.y = 600;
    }
    if (curSelected == 4){
       char.y = 300;
       char.x = 130;
       logo.x = 50;
       logo.y = 500;
       SongName = 'minds-eye-squared';
    }
    if (controls.ACCEPT) {
        Play(SongName);
    }
}
function changeItem(huh:Int = 0){
    curSelected = FlxMath.wrap(curSelected + huh, 0, Characters.length-1);

    logo.loadGraphic(Paths.image('freeplay/logos/' + curSelected ));
    char.frames = Paths.getSparrowAtlas('freeplay/anims/' + curSelected);
    
    char.animation.addByPrefix('idle', "play", 24, false);
	char.animation.play('idle');
    char.scale.set(1.4,1.4);
    char.y = 70;

    //FlxTween.tween(wheel, {angle: wheel.angle * curSelected}, .5, {ease: FlxEase.circOut});
}
function Play(lol){
    PlayState.loadSong(lol, "hard");
    FlxG.sound.play(Paths.sound("confirmMenu"));
    trace(lol);
    new FlxTimer().start(1, function(tmr:FlxTimer) { 
        FlxG.switchState(new PlayState()); 
    });
}