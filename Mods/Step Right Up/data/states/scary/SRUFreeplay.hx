// Variables
var SongName: String = '';
var curSelected: Int = 0;
var Characters: Array<String> = [
    'yumenikki',
    'faith',
    'smiledog',
    'tattletail',
    'duckseason'
];

// For preloading lmao lagged at first
var preloadedLogos = [];
var preloadedAnims = [];

var logo:FlxSprite;
var char:FlxSprite;

function create() {
    var bg = new FlxSprite().loadGraphic(Paths.image('freeplay/background'));
    bg.screenCenter();
    add(bg);

    for (i in 0...Characters.length) {
        var logoTexture = Paths.image('freeplay/logos/' + Characters[i]);
        var animFrames = Paths.getSparrowAtlas('freeplay/anims/' + Characters[i]);
        preloadedLogos[i] = logoTexture;
        preloadedAnims[i] = animFrames;
    }

    logo = new FlxSprite(100, 600);
    char = new FlxSprite(0, 0);
    
    char.frames = preloadedAnims[curSelected];
    char.screenCenter();
    add(char);

    var curtain = new FlxSprite(-90, 0).loadGraphic(Paths.image('freeplay/curtain'));
    add(curtain);

    var bottom = new FlxSprite(-90, 600).loadGraphic(Paths.image('freeplay/bottom'));
    bottom.scale.set(0.9, 0.9);
    add(bottom);

    var wheel = new FlxSprite(440, 530).loadGraphic(Paths.image('freeplay/wheel'));
    add(wheel);

    var arrow = new FlxSprite(630, 450).loadGraphic(Paths.image('freeplay/arrow'));
    add(arrow);

    logo.loadGraphic(preloadedLogos[curSelected]);
    add(logo);

    changeItem(0);
}

function update() {
    if (controls.LEFT_P) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(-1);
    }
    if (controls.RIGHT_P) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(1);
    }
    if (controls.BACK) {
        FlxG.switchState(new MainMenuState());
    }
    if (controls.ACCEPT) {
        Play(SongName);
    }
}
function changeItem(huh: Int = 0) {
    curSelected = FlxMath.wrap(curSelected + huh, 0, Characters.length - 1);

    if (curSelected >= 0 && curSelected < preloadedLogos.length && curSelected < preloadedAnims.length) {
        logo.loadGraphic(preloadedLogos[curSelected]);
        char.frames = preloadedAnims[curSelected];
        char.animation.addByPrefix('idle', "play", 24, false);
        char.animation.play('idle');
        char.scale.set(1.4, 1.4);

        switch (curSelected) {
            case 0:
                char.y = 100;
                char.x = 350;
                logo.x = 100;
                logo.y = 600;
                SongName = 'deep-dream';

            case 1:
                char.y = 70;
                char.x = 0;
                logo.x = 100;
                logo.y = 600;
                SongName = 'Mortis';

            case 2:
                char.y = 300;
                char.x = 130;
                logo.x = 50;
                logo.y = 500;
                SongName = 'minds-eye-squared';

            case 3:
                char.y = 30;
                char.x = 0;
                logo.x = 100;
                logo.y = 600;
                SongName = 'no-more';

            case 4:
                char.y = 150;
                char.x = 400;
                logo.x = 100;
                logo.y = 600;
                SongName = '';
        }
    }
}
function Play(songName: String) {
    PlayState.loadSong(songName, "hard");
    FlxG.sound.play(Paths.sound("confirmMenu"));
    trace(songName);
    new FlxTimer().start(1, function(tmr: FlxTimer) {
        FlxG.switchState(new PlayState());
    });
}
