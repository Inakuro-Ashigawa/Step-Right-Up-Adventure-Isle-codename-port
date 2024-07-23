/**
    ----->     -- Use `UIState(true, thisState)` for this State please. --     <-----
**/
import funkin.editors.ui.UIState;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIWindow;
import funkin.editors.ui.UISlider;
import funkin.editors.ui.UIWarningSubstate;

import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;

import sys.Http;

import flixel.sound.FlxSound;
import lime.media.AudioBuffer;
import openfl.utils.ByteArrayData;
import openfl.media.Sound;

import flixel.FlxG;
import flixel.group.FlxTypedSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

import funkin.backend.utils.ThreadUtil;

import openfl.net.URLLoader;
import openfl.net.URLStream;
import openfl.net.URLRequest;

import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

import funkin.backend.assets.ModsFolder;

import StringTools;
import Type;
var ServerRequest = importScript("helper/ServerRequest");

var bg:FlxSprite;
var bgScale:Float = 1;
var songItems:FlxTypedSpriteGroup;

var _width = FlxG.width/3.25;

var volumeSlider:UISlider;

var instText:UIText;
function create() {
    prevAutoPause = FlxG.autoPause;
    prevMouseVisible = FlxG.mouse.visible;
    prevVolume = FlxG.sound.music.volume;

    FlxG.autoPause = false;
    Conductor.songPosition = 0;


    bg = new FlxSprite(0,0, Paths.image("menus/menuDesat"));
    bg.color = 0xFF67D763;
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.alpha = 0.65;
    bgScale = bg.scale.x;
    add(bg);
    
    getList();

    volumeSlider = new UISlider(30, FlxG.height - 19, 100, 1, [{start: 0, end: 1, size: 1}], false);
    volumeSlider.x = FlxG.width - volumeSlider.bWidth - volumeSlider.width - 40;
    add(volumeSlider);
    
    volumeSlider.onChange = function (v) {
        if (!canSelectSong) {
            volumeSlider.visualProgress = FlxG.sound.music.volume;
            volumeSlider.__barProgress = FlxG.sound.music.volume;
            return;
        }
        FlxG.sound.music.volume = v;
    }
        
    instText = new UIText(0, 0, 250, "only Inst? ( "+justInst+" )");
    instText.size = 20;
    instText.alignment = "right";
    instText.setPosition(FlxG.width - instText.width - 10, instText.height);
    add(instText);
    
}

function createUIsongs() {
    songItems = new FlxTypedSpriteGroup();
    songItems.x = FlxG.width;
    add(songItems);
    // curSel = 0;
    for (i in 0...songs.length) {
        var songData = songs[i];
        songData.desc = (songData.desc == null) ? { size: 12, text: "No description available." } : songData.desc;
        songData.desc.size = (songData.desc.size > 24) ? 24 : songData.desc.size; songData.desc.size = (songData.desc.size < 8) ? 8 : songData.desc.size;
        
        item = new FlxTypedSpriteGroup();
        item.ID = i;
        songItems.add(item);

        var __ID = 0;
        var bgSpr = new FlxSprite().makeGraphic(_width, FlxG.height/1.5, 0x00000000);
        bgSpr = FlxSpriteUtil.drawRoundRect(bgSpr, 0,0, bgSpr.width, bgSpr.height, 50, 50, 0x803E3E3E);
        bgSpr.ID = __ID++;
        item.add(bgSpr);

        var icon = (songData.icon != null) ? Paths.image("AudioFile") : Paths.image("AudioFile");
        var thumbnail = new FlxSprite(0,0, icon);
        thumbnail.scale.set(1.5, 1.5);
        thumbnail.updateHitbox();
        thumbnail.setGraphicSize(Math.min(bgSpr.width - 50, thumbnail.width), Math.min(bgSpr.height/2 - 50, thumbnail.height));
        thumbnail.updateHitbox();
        thumbnail.setPosition(bgSpr.width/2 - thumbnail.width/2, bgSpr.height/2 - thumbnail.height/2);
        thumbnail.ID = __ID++;
        item.add(thumbnail);

        var audioPNG = new FlxSprite(0,0, Paths.image("AudioFile"));
        audioPNG.setPosition(bgSpr.width - audioPNG.width - 10, bgSpr.height - audioPNG.height - 10);
        audioPNG.ID = __ID++;
        item.add(audioPNG);
        
        var title = new UIText(0, 0, bgSpr.width - 5, Std.string(songData.song));
        title.size = 24;
        title.alignment = "center";
        title.setPosition(bgSpr.width/2 - title.width/2, title.height);
        title.ID = __ID++;
        item.add(title);

        var desc = new UIText(0, 0, bgSpr.width - 15, Std.string(songData.desc.text));
        desc.size = songData.desc.size;
        desc.alignment = "center";
        desc.setPosition(bgSpr.width/2 - desc.width/2, title.y + title.height + desc.height);
        desc.ID = __ID++;
        item.add(desc);
    }
    songItems.screenCenter();
    songItems.x = FlxG.width - songItems.members[0].width - 10;
    
    curSel++;
    changeSel(-1);
}
var songs = [];

var paused = false;
var justInst = false;
var canSelectSong = false;
var cooldown = new FlxTimer();
var songPlaying:Bool = {curPlaying: false, songID: -1, instToggled: false};
var prevMouseVisible = false;
var prevAutoPause = false;
var prevVolume = 0;

var gettingData:Bool = false;
var currentPlayingSong = null;

function playSelectedSong() {
    canSelectSong = false;
    ServerRequest.call("requestThread", [false, "get-music", Json.stringify({
        songName: currentPlayingSong = songs[curSel].song,
        inst: justInst,
    }), ["Content-Type", "application/json"],
    function(msg:String) {
        try {
            FlxG.cameras.flash(0x43FF0000, 0.5);
            if (FlxG.state.subState != null) {
                FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume, prevVolume);
                FlxG.state.subState.close();
            }
            canSelectSong = true;
            ServerRequest.set("onStatusError", true);
            ServerRequest.call("onStatusErrors", [msg]);
        } catch (e:Execption) {
            canSelectSong = true;
            ServerRequest.call("forceWindow", ["Error when running a function", "Custom Function error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript"]);
        }
    }, function(b) {
        try {
            var data = b;
            cooldown.start(1);
            if (data == null) {
                if (FlxG.state.subState != null) {
                    FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume, prevVolume);
                    FlxG.state.subState.close();
                }
                FlxG.cameras.flash(0x43FF0000, 0.5);
                canSelectSong = true;
                return;
            };
            if (songs[curSel].bpm != null) Conductor.changeBPM(songs[curSel].bpm);
            songPlaying.curPlaying = true;
            songPlaying.songID = curSel;
            songPlaying.instToggled = justInst;

            var sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(b));
            FlxG.sound.music.fadeOut(1, 0, function() {
                FlxG.sound.music.loadEmbedded(sound, true);
                FlxG.sound.music.play();
                FlxG.sound.music.fadeIn(1, 0, prevVolume);
                canSelectSong = true;
            });
            if (FlxG.state.subState != null) FlxG.state.subState.close();
        } catch (e:Execption) {
            canSelectSong = true;
            ServerRequest.call("forceWindow", ["Error when running a function", "Custom Function error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript"]);
        }
    }, null, function(status) {
        try {
            ServerRequest.call("onStatusErrors", [status, null, function() {
                canSelectSong = true;
            }]);
        } catch (e:Execption) {
            canSelectSong = true;
            ServerRequest.call("forceWindow", ["Error when running a function", "Custom Function error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript"]);
        }
    }
    ]);
    openSubState(new ModSubState("LoadingServer"));
    FlxG.state.persistentUpdate = true;
}

function getList() {
    gettingData = true;
    trace(songItems);
    if (songItems != null && songItems.length > 0) {
        remove(songItems);
        songItems.kill();
        songItems.destroy();
    }
    ServerRequest.call("requestThread", [false, "get-music-list", null , null,
    function(msg:String) {
        try {
            FlxG.cameras.flash(0x43FF0000, 0.5);
            gettingData = false;
        } catch (e:Execption) {
            canSelectSong = true;
            ServerRequest.call("forceWindow", ["Error when running a function", "Custom Function error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript"]);
        }
    }, null, function(d) {
        try {
            songs = Json.parse(d).data;
            var tempSort = [];
            for (i in songs) tempSort.push(i);
            tempSort.sort(function(a, b) { compareStrings(a.song, b.song); });
            for (i in 0...songs.length) songs[i] = tempSort[i];
            new FlxTimer().start(0.25, function() {
                createUIsongs();
                canSelectSong = true;
                gettingData = false;
            });
        } catch (e:Execption) {
            canSelectSong = true;
            ServerRequest.call("forceWindow", ["Error when running a function", "Custom Function error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript"]);
        }
    }]);
}

function compareStrings(a:String, b:String) {
    if (a < b) return -1;
    else if (a > b) return 1;
    else return 0;
}

var curSel:Int = 0;
var timerWait:FlxTimer = new FlxTimer();
var bufferTimer:FlxTimer = new FlxTimer();
function changeSel(bruh:Int = 0) {
    if (songs.length <= 1 || (timerWait.active || bufferTimer.active)) return;
    curSel += bruh;
    if (bruh != 0) {
        timerWait.start(0.25);
        bufferTimer.start(0.5);
    }
    if (curSel >= songs.length) curSel = 0;
    if (curSel < 0) curSel = songs.length-1;
}

var doubleClick = false;
var clickTimerInt = 0;
function update(elapsed) {
    curDecStep = Conductor.getStepForTime(Conductor.songPosition);
    curDecBeat = curDecStep / 4;
    if (volumeSlider != null) volumeSlider.value = FlxG.sound.music.volume;
    if (FlxG.keys.justPressed.L) FlxG.switchState(new UIState(true, "New Music Track"));

    if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) changeSel(1);
    if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) changeSel(-1);

    if (FlxG.mouse.justPressed) {
        clickTimerInt++;
        new FlxTimer().start(0.2, function(tmr) {
            doubleClick = (clickTimerInt == 2); // clicked twice in 0.15s
            clickTimerInt = 0;
        });
    }

    if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || doubleClick) && !cooldown.active && canSelectSong) {
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
    if (FlxG.keys.justPressed.SHIFT) {
        justInst = !justInst;
        instText.text = "only Inst? ( "+justInst+" )";
        instText.setPosition(FlxG.width - instText.width - 10, instText.height);
    }

    if (FlxG.keys.justPressed.TAB) getList();
    var lerp = FlxMath.lerp(bgScale + 0.015, bgScale, FlxEase.cubeOut(curDecBeat % 1));
    bg.scale.set(lerp,lerp);

    
    if (FlxG.keys.justPressed.ESCAPE) {
        // FlxG.autoPause = prevAutoPause; // disabled for now
        FlxG.mouse.visible = prevMouseVisible;
        FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume, prevVolume);
        FlxG.switchState(new MainMenuState());
    }

    if (FlxG.mouse.wheel != 0) {
        changeSel(FlxG.mouse.wheel);
    }

    if (!gettingData) {
        if (songItems != null && songItems.members != null) {
            songItems.forEach(function(spr) {
                var isID = (spr.ID == curSel);
    
                var x = (isID && !timerWait.active) ? FlxG.width - spr.width - 10 : FlxG.width + spr.width + 10;
                spr.x = FlxMath.lerp(spr.x, x, FlxG.elapsed*6);
            });
        }
    }
}