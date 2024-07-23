//a
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;
import sys.Http;
import flixel.sound.FlxSound;
import lime.media.AudioBuffer;
import openfl.utils.ByteArrayData;
import Type;
import openfl.media.Sound;
import flixel.math.FlxMath;
import haxe.Json;
import StringTools;
import flixel.FlxG;
import funkin.backend.utils.ThreadUtil;
import flixel.input.mouse.FlxMouseEventManager;
var ServerRequest = importScript("helper/ServerRequest");

var bg:FlxBackdrop;
var bgType:String = "charter";

var record:FlxSprite;

// Radius of the circle
var radius:Float = 50;
var circle:FlxSprite;

var maskSpr:FlxSprite;
var prevMouseVisible = false;
var prevAutoPause = false;


var debugText:FlxText;
var cool:CustomShader = null;
var stopPlaying:Bool = false;

var songPlaying:Bool = {curPlaying: false, songID: -1, instToggled: false};
var chadArray:Array<FlxSprite> = [];
function create() {
    FlxG.autoPause = false;
    Conductor.songPosition = 0;

    prevAutoPause = FlxG.autoPause;
    prevMouseVisible = FlxG.mouse.visible;
    FlxG.mouse.visible = true;
    bg = new FlxBackdrop();
	bg.loadGraphic(Paths.image('editors/bgs/'+bgType));
	bg.antialiasing = true;
    bg.screenCenter();
	add(bg);
    
    for (chad in 0...6) {
        var CHAD = new FlxSprite().loadGraphic(Paths.image((FlxG.random.bool(0.001)) ? 'hi/ZANDCHAD' : 'hi/chad'+chad));
        CHAD.scrollFactor.set();
        CHAD.antialiasing = true;
        if (chad == 2) CHAD.scale.set(2.5,2.5);
        CHAD.updateHitbox();
        CHAD.screenCenter();
        CHAD.ID = chad;
        CHAD.alpha = 0.0001;
        add(CHAD);

        chadArray.push(CHAD);
    }

    record = new FlxSprite(0,0, Paths.image("record"));
    record.setGraphicSize(200,210);
    record.updateHitbox();
    record.x = FlxG.width - record.width - 40;
    record.y = FlxG.height - record.height - 10;

    cool = new CustomShader('cool');
    cool.data.tint.value = [1,1,1,1];
    cool.data.emptyTint.value = [0,0,0,0];
    cool.data.percent.value = [(Conductor.songPosition/FlxG.sound.music.length)*360];

    circle = new FlxSprite().makeGraphic(record.width, record.height-10, 0x00FFFFFF);
    circle.x = record.x; circle.y = record.y + 5;
    circle.alpha = 1;
    circle = FlxSpriteUtil.drawRoundRect(circle, 0,0, circle.width, circle.height, circle.width, circle.height, 0xFFFFFFFF);
    circle.shader = cool;
    add(circle);

    add(record);

    debugText = new FlxText(0, 0, 0, "test", 32);
    debugText.screenCenter();
    debugText.alignment = "center";
    add(debugText);

    getList(); // init array
    changeSel(0);
    new FlxTimer().start(125, function() {
        randomAds();
    }, 0);
}
var paused = false;
var justInst = false;
var canSelectSong = true;
var cooldown = new FlxTimer();

var bgElapsed = 125;
var scoreWarningAlphaRot = 0;
function update(elapsed:Float) {
    bg.x += (elapsed * bgElapsed);
    bg.y += (elapsed * bgElapsed);

    record.angle += elapsed * 20;

    if (FlxG.keys.justPressed.M) {
        FlxG.autoPause = prevAutoPause;
        FlxG.mouse.visible = prevMouseVisible;
        FlxG.switchState(new MainMenuState());
    }

    if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) changeSel(1);
    if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) changeSel(-1);

    if (FlxG.keys.justPressed.SHIFT) {
        justInst = !justInst;
        debugText.text = songs[curSel]+"\n\njust the inst: "+justInst+"\n(shift toggle)";
        debugText.screenCenter();
    }

    if (FlxG.keys.justPressed.R) {
        FlxG.sound.music.fadeOut(1, 0, function() {
            FlxG.sound.music.pause();
            FlxG.sound.music.time = 0;
            Conductor.songPosition = 0;
            FlxG.sound.music.resume();
            FlxG.sound.music.fadeIn(0.5, 0.1);
        });
    } 
    
    if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) && !cooldown.active && canSelectSong) {
        cooldown.start(0.75);
        
        if (songPlaying.curPlaying) {
            if (songPlaying.songID != curSel || songPlaying.instToggled != justInst) {
                playSelectedSong();
                return;
            }
            paused = !paused;
            if (!paused) FlxG.sound.music.resume();
            FlxG.sound.music.fadeOut(1, (paused) ? 0 : 1, function() {
                if (paused) FlxG.sound.music.pause();
            });
        } else playSelectedSong();
    }

    if (paused) {
        scoreWarningAlphaRot = (scoreWarningAlphaRot + (elapsed * Math.PI * 0.75)) % (Math.PI * 2);
        record.alpha = (2 / 3) + (Math.sin(scoreWarningAlphaRot) / 3);
    } else record.alpha = FlxMath.lerp(record.alpha, 1, elapsed*2);

    if (showingAd != null && showingAd.onClick != null && showingAd.ad != null) {
        if (FlxG.mouse.overlaps(showingAd.ad)) {
            showingAd.ad.alpha = 0.5;
            if (FlxG.mouse.justPressed) showingAd.onClick();
        }
        else showingAd.ad.alpha = 1;
    }

    if (FlxG.keys.justPressed.TAB) getList();

    var setValue = (stopPlaying) ? -1 : (Conductor.songPosition/FlxG.sound.music.length)*360;

    cool.data.percent.value[0] = FlxMath.lerp(cool.data.percent.value[0], setValue,
    (Conductor.songPosition <= 5*1000 || stopPlaying) ? elapsed*4 : elapsed*10);
}
var songs = ["Server Might be down! Or no songs"];
var curSel = 0;
function changeSel(hur:Int = 0) {
    curSel += hur;
    if (curSel >= songs.length) curSel = 0;
    if (curSel < 0) curSel  = songs.length - 1;
    
    if (debugText != null) {
        debugText.text = songs[curSel]+"\n\njust the inst: " + justInst+"\n(shift toggle)";
        debugText.screenCenter();
    }
}

var currentPlayingSong = null;
function playSelectedSong() {
    canSelectSong = false;
    songPlaying.curPlaying = true;
    songPlaying.songID = curSel;
    songPlaying.instToggled = justInst;

    ServerRequest.call("requestThread", [false, "get-music", Json.stringify({
        songName: currentPlayingSong = songs[curSel],
        inst: justInst,
    }) ,["Content-Type", "application/json"],
    function(msg:String) {
        FlxG.cameras.flash(0x43FF0000, 0.5);
        if (FlxG.state.subState != null) {
            FlxG.sound.music.fadein(1, 1);
            FlxG.state.subState.close();
        }
        canSelectSong = true;
    }, function(b) {
        cooldown.start(1);
        if (b == null) {
            if (FlxG.state.subState != null) {
                FlxG.sound.music.fadeIn(1, 1);
                FlxG.state.subState.close();
            }
            FlxG.cameras.flash(0x43FF0000, 0.5);
            canSelectSong = true;
            return;
        };
        stopPlaying = true;
        var sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(b));
        FlxG.sound.music.fadeOut(1, 0, function() {
            stopPlaying = false;
            FlxG.sound.music.loadEmbedded(sound, true);
            FlxG.sound.music.play();
            FlxG.sound.music.fadeIn(0.5, 0.1);
            canSelectSong = true;
        });
        if (FlxG.state.subState != null) FlxG.state.subState.close();
    }]);
    openSubState(new ModSubState("LoadingServer"));
}


function getList() {
    ServerRequest.call("requestThread", [false, "get-music-list", null , null,
    function(msg:String) {
        songs = ["Server Might be down! Or no songs"];
        FlxG.cameras.flash(0x43FF0000, 0.5);
    }, null, function(d) {
        songs = Json.parse(d).data;
        var tempSort = [];
        for (i in songs) tempSort.push(i.song);
        tempSort.sort(compareStrings);
        for (i in 0...songs.length) {
            songs[i] = tempSort[i];
        }
        changeSel(0);
    }]);
}

function beatHit(curBeat) {
    if (currentPlayingSong == "CHAD") {
        switch(curBeat) {
            case 17:
                FlxTween.tween(FlxG.camera, {zoom:2}, 5, {ease: FlxEase.quadIn});
            case 24:
                FlxG.camera.shake(0.0035, 1.5, () -> { }, true);
            case 26:
                FlxG.camera.shake(0.0015, 0.5, () -> { }, true);
                FlxTween.tween(FlxG.camera, {zoom:1}, 0.35, {startDelay: 0.1, ease: FlxEase.quadOut, onStart: function() {
                    chad_Time(3);
                }});
                FlxTween.num(bgElapsed, bgElapsed - 75, 0.35, {ease: FlxEase.quadOut}, function(v:Float) {
                    bgElapsed = v;
                });
            case 28:
                FlxTween.num(bgElapsed, bgElapsed + 50, 0.15, {ease: FlxEase.quadIn}, function(v:Float) {
                    bgElapsed = v;
                });
            case 29:
                FlxTween.num(bgElapsed, bgElapsed - 25, 0.15, {startDelay: 0.15, ease: FlxEase.quadIn}, function(v:Float) {
                    bgElapsed = v;
                });
            case 32:
                FlxTween.num(bgElapsed, 125, 0.15, {ease: FlxEase.quadIn}, function(v:Float) {
                    bgElapsed = v;
                });
            case 38:
                FlxG.camera.shake(0.0015, 0.45, () -> { }, true);
                FlxTween.tween(FlxG.camera, {zoom:1.4}, 0.25, {ease: FlxEase.quadOut});
            case 39:
                FlxTween.tween(FlxG.camera, {zoom:1}, 0.25, {ease: FlxEase.quadIn});
            case 51:
                FlxG.camera.shake(0.0015, 0.45, () -> { }, true);
                FlxTween.tween(FlxG.camera, {zoom:1.4}, 0.25, {ease: FlxEase.quadOut});
            case 52:
                FlxTween.tween(FlxG.camera, {zoom:1}, 0.25, {ease: FlxEase.quadIn});
        }
    }
}

// yes shut im re using
function chad_Time(time:Int = 2) {
    if (FlxG.random.bool(1)) {
        var yes = FlxG.random.int(0,5);
        chadArray[yes].loadGraphic(Paths.image("hi/ZANDCHAD"));
        chadArray[yes].updateHitbox();
        chadArray[yes].screenCenter();
    }
    chadArray[0].x = -150;
    FlxTween.tween(chadArray[0], {x: FlxG.width / 8}, time + time);

    FlxTween.tween(chadArray[0], {alpha: 1}, time, {ease: FlxEase.linear, onComplete: function () {
        FlxTween.tween(chadArray[0], {alpha: 0.0001}, time, {ease: FlxEase.linear});
        chadArray[1].y = 150;
        FlxTween.tween(chadArray[1], {y: (FlxG.height / 2 - FlxG.height / 2)}, time + time);

        FlxTween.tween(chadArray[1], {alpha: 1}, time, {ease: FlxEase.linear, onComplete: function () {
            FlxTween.tween(chadArray[1], {alpha: 0.0001}, time, {ease: FlxEase.linear});
            chadArray[2].y = -150;
            FlxTween.tween(chadArray[2], {y: FlxG.height / 2}, time + time);

            FlxTween.tween(chadArray[2], {alpha: 1}, time, {ease: FlxEase.linear, onComplete: function () {
                FlxTween.tween(chadArray[2], {alpha: 0.0001}, time, {ease: FlxEase.linear});
                
                chadArray[3].x = 150;
                FlxTween.tween(chadArray[3], {x: FlxG.width / 2}, time + time);
                FlxTween.tween(chadArray[3], {alpha: 1}, time, {ease: FlxEase.linear, onComplete: function () {
                    FlxTween.tween(chadArray[3], {alpha: 0.0001}, time, {ease: FlxEase.linear});

                    chadArray[4].y = 150;
                    FlxTween.tween(chadArray[4], {y: (FlxG.height / 2 - FlxG.height / 2)}, time + time);
                    FlxTween.tween(chadArray[4], {alpha: 1}, time, {ease: FlxEase.linear, onComplete: function () {
                        FlxTween.tween(chadArray[4], {alpha: 0.0001}, time, {ease: FlxEase.linear});

                        chadArray[5].x = 150;
                        FlxTween.tween(chadArray[5], {x: FlxG.width / 8}, time + time);
                        FlxTween.tween(chadArray[5], {alpha: 1}, time, {ease: FlxEase.linear, onComplete: function () {
                            FlxTween.tween(chadArray[5], {alpha: 0.0001}, time, {ease: FlxEase.linear});
                            if (FlxG.sound.music.playing && currentPlayingSong.toLowerCase() == "chad") chad_Time(time);
                        }});
                    }});
                }});
            }});
        }});
    }});
}

function status(stat) {
    trace("Status: " + stat);
    switch(stat) {
        case "EOF":
            throw "Server might be shut down!";
        case "Http Error #404":
            throw "Error 404";
    }
}

function compareStrings(a:String, b:String):Int {
    // Compare two strings lexicographically
    if (a < b) return -1;
    else if (a > b) return 1;
    else return 0;
}

var ads = [
    {
        path: "LJ Arcade Advertisment",
        size: {width: null, height: null},
        screenCenter: true,
        pos: {x: 0, y: 0},
        side: "bottom",
        animData: {
            animated: false,
            anim: "",
            fps: 24
        },
        onClick: function() {
            CoolUtil.openURL("https://github.com/ItsLJcool/LJ-Arcade-Mod");
        }
    },
    {
        path: "LJ vs Bf",
        size: {width: 600, height: 100},
        screenCenter: true,
        pos: {x: 0, y: 0},
        side: "bottom",
        animData: {
            animated: false,
            anim: "",
            fps: 24
        },
        onClick: function() {
            CoolUtil.openURL("https://gamebanana.com/mods/496723");
        }
    },
];

var showingAd = {onClick: null, ad: null};
function randomAds() {
    if (!FlxG.random.bool(30)) return;
    var randomAd = FlxG.random.int(0, ads.length-1);
    var adData = ads[randomAd];

    var ad = new FlxSprite();
    if (!adData.animData.animated) {
        ad.loadGraphic(Paths.image("ads/"+ads[randomAd].path));
    } else {
        ad.frames =  Paths.getSparrowAtlas("ads/"+ads[randomAd].path);
        ad.animations.addByPrefix(adData.animData.name, adData.animData.name, adData.animData.fps, true);
        ad.animations.play(adData.animData.name, true);
    }
    ad.setGraphicSize((adData.size.width != null) ? adData.size.width : ad.width, (adData.size.height != null) ? adData.size.height : ad.height);
    ad.updateHitbox();
    if (adData.screenCenter) ad.screenCenter();
    switch(adData.side) {
        case "position", null:
            ad.setPosition(pos.x, pos.y);
        case "bottom":
            ad.setPosition(ad.x, FlxG.height - ad.height);
        case "top":
            ad.setPosition(ad.x, 0);
    }
    add(ad);
    ad.alpha = 0.0001;
    showingAd.onClick = adData.onClick;
    FlxSpriteUtil.fadeIn(ad, 1, false,  function(_) {
        showingAd.ad = ad;
        new FlxTimer().start(30, function() {
            FlxSpriteUtil.fadeOut(ad, 1, function(_) {
                ad.kill();
                ad.destroy();
                remove(ad);
                showingAd = {onClick: null, ad: null};
            });
        });
    });
}