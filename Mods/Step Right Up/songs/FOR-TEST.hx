import funkin.editors.charter.Charter;
import funkin.game.PlayState;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

public var curSpeed:Float = 1;
static var curBotplay:Bool = false;
static var devControlBotplay:Bool = true;

public var botplayTxt:FlxText;
function postCreate() {
    botplayTxt = new FlxText(400, strumLines.members[0].members[0].y + 50, FlxG.width - 800, "BOTPLAY", 32);
    botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    botplayTxt.visible = curBotplay;
    botplayTxt.borderSize = 1.25;
    botplayTxt.camera = camHUD;
    add(botplayTxt);
}

function update(elapsed:Float) {
        updateBotplay(elapsed);

    if (startingSong || !canPause || paused || health <= 0) return;
    
    if (FlxG.keys.justPressed.ONE && generatedMusic ) endSong();
    if (FlxG.keys.justPressed.TWO) curSpeed -= 0.1;
    if (FlxG.keys.justPressed.THREE) curSpeed = 1;
    if (FlxG.keys.justPressed.FOUR) curSpeed += 0.1;
    curSpeed = FlxMath.bound(curSpeed, 0.1, 2);
    
    updateSpeed(FlxG.keys.pressed.FIVE ? 20 : curSpeed);

    if (FlxG.keys.justPressed.SEVEN) {
        FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, true));
    }
}

public var botplaySine:Float = 0;
function updateBotplay(elapsed:Float) {

    if (FlxG.keys.justPressed.SIX) curBotplay = !curBotplay;
    for(strumLine in strumLines)
        if(!strumLine.opponentSide)
            strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;

    botplayTxt.visible = curBotplay;
    
    if (!curBotplay) return;

    botplaySine += 180 * elapsed;
    botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
}

function updateSpeed(speed:Float)
    FlxG.timeScale = inst.pitch = vocals.pitch = speed;

function onGamePause() {updateSpeed(1);}
function onSongEnd() {updateSpeed(1);}
function destroy() {FlxG.timeScale = 1;FlxG.sound.muted = false;}