//a
import sys.Http;
import funkin.editors.ui.UIWarningSubstate;
import funkin.editors.ui.UIState;
import Type;
import StringTools;

var serverIP:String = "us-la02.pylex.me:8845";
var onStatusError:Bool = false;
function requestThread(post:Bool = false, requestPath:String = null,
    setPostData:Dynamic, header:Array<String> = ["Content-Type", "application/json"],
    ?onError:Dynamic->Dynamic, ?onBytes:Dynamic->Dynamic, ?onData:Dynamic->Dynamic, ?onStatus:Dynamic->Dynamic,
    ?onFailTry:Dynamic->Dynamic) {

    var http:Http = new Http(serverIP+"/"+requestPath);
    if (setPostData != null) http.setPostData(setPostData);
    if (header != null) http.addHeader(header[0], header[1]);
    var __onError = onError;
    if (__onError != null) http.onError = function(e) {
        try {
            if (!onStatusError) __onError(e);
        } catch(e:Exception) {
            forceWindow("Error when running a function", "onError error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript");
        }
    }; else http.onError = onStatusErrors;
    var __onBytes = onBytes;
    if (__onBytes != null) http.onBytes = function(bytes) {
        try {
            __onBytes(bytes);
        } catch(e:Exception) {
            forceWindow("Error when running a function", "onBytes error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript");
        }
    }
    var __onData = onData;
    if (__onData != null) http.onData = function(data) {
        try {
            __onData(data);
        } catch(e:Exception) {
            forceWindow("Error when running a function", "onData error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript");
        }
    };
    var __onStatus = onStatus;
    if (__onStatus != null) http.onStatus = function(status) {
        try {
            __onStatus(status);
        } catch(e:Exception) {
            forceWindow("Error when running a function", "onStatus error:\n"+e+"\n Try Resetting the state, Threads can cause issues in HScript");
        }
    };
    else http.onStatus = onStatusErrors;

    var newHttp = http;
    var newPost = post;

    var _onFailTry = onFailTry;
    Main.execAsync(() -> {
        try {
            newHttp.request(newPost);
        } catch(e:Exception) {
            try {
                if (_onFailTry != null) _onFailTry(e);
                else {
                    onStatusErrors(e);
                }
            } catch(e:Exception) {
                onStatusErrors('failedTryTry', e);
            }
        }
    });
}

function forceWindow(title, desc) {
    
    var prevVolume = FlxG.sound.music.volume;
    FlxG.sound.music.fadeIn(1, 0.25);
    var className = Type.getClassName(Type.getClass(this));
    className = Std.string(className.substr(className.lastIndexOf(".")+1));

    if (className != "UIState") {
        if (FlxG.state.subState != null) FlxG.state.subState.close();
        customShitThing(desc);
        return;
    }

    openSubState(new UIWarningSubstate("(Default Error Handler) "+title, desc, [
        {
            label: "OK",
            onClick: function(t) {
                FlxG.sound.music.fadeIn(1, prevVolume);
            }
        }
    ]));
}

// default errors to say for help
function onStatusErrors(e, ?other, ?onStart) {
    e = Std.string(e);
    onStatusError = true;

    var title = "Unkown Error...";
    var desc = "You somehow got an error, and the default error handler does not have a case for this...";
    switch(e) {
        case "404":
            title = "Http Error #404";
            desc = "The server cannot find the requested resource";
        case "500":
            title = "Http Error #500";
            desc = "Internal Server Error | The server has encountered a situation it does not know how to handle.";
        case "Custom(EOF)":
            title = "Custom(EOF)";
            desc = "Custom Error Status";

        case "EOF":
            desc = "Server may no longer exist or is OFFLINE";

        case "failedTryTry": // rip
            title = "Failed a try catch recursive";
            desc = "Apparently CodenameEngine doesn't like Threads for you, it somehow failed 2 try catches. Congrats on this try catch for working tho
            \nTry Catch Error: "+other;


        default:
            onStatusError = false;
    }
    if (onStart != null) onStart();

    if (!onStatusError) return;
    desc = desc+"\n\nError Code: "+e;
    
    forceWindow(title, desc);
}

function customShitThing(desc) {
    var fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x80000000);
    fade.screenCenter();
    add(fade);
    
    var bg = new FlxSprite().makeGraphic(400, 350, 0x80454545);
    bg.screenCenter();
    add(bg);

    var text = new FlxText(0,0,bg.width, "Test", 16);
    text.alignment = 'center';
    text.text = desc;
    text.x = bg.x + bg.width/2 - text.width/2;
    text.y = bg.y + text.height + 50;
    add(text);
    
    var countdown = new FlxText(0,0,0, "5", 12);
    countdown.alignment = 'center';
    countdown.x = bg.x + bg.width/2 - countdown.width/2;
    countdown.y = bg.y + bg.height - countdown.height -10;
    add(countdown);

    new FlxTimer().start(1, function(tmr) {
        trace(tmr.loopsLeft);
        countdown.text = tmr.loopsLeft;
        if (tmr.loopsLeft <= 0) {
            for (itm in [fade, bg, text, countdown]) {
                FlxTween.tween(itm, {alpha: 0}, 1, {onComplete: function() {
                    itm.destroy();
                    itm.kill();
                    remove(itm);
                }});
            }
        }
    }, 5);

}