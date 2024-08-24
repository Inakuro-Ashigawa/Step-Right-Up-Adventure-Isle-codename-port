import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;

var customPlrZoom:Float = 1.5;
var extent:Float  = 5;

var camPos:Array<Float>;
var camExtend:Array<Float>;
public var cancelCameraMove = false;
var scoreTxt2,missesTxt2,accuracyTxt2,accuracyTxt3:FlxText;
var colouredBar = (dad != null && dad.xml != null && dad.xml.exists("color")) ? CoolUtil.getColorFromDynamic(dad.xml.get("color")) : 0xFFFFFFFF;
var colouredBarB = (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("color")) ? CoolUtil.getColorFromDynamic(boyfriend.xml.get("color")) : 0xFFFFFFFF;
var curSong = PlayState.instance.curSong;
public var cameraSpeed:Float = 2;

function postCreate() {
    if (curSong == "mortis") {
        extent = 3;
    }
    scoreTxt2 = new FlxText(healthBarBG.x - 50, healthBarBG.y + 30, Std.int(healthBarBG.width - 100), "Score:0", 30);
	scoreTxt2.setFormat(Paths.font('dialogue.otf'), 30, FlxColor.WHITE, 'left');

    missesTxt2 = new FlxText(healthBarBG.x + 50, healthBarBG.y + 30, Std.int(healthBarBG.width - 100), "Misses:0", 30);
	missesTxt2.setFormat(Paths.font('dialogue.otf'), 30, FlxColor.WHITE, 'center');
    missesTxt2.screenCenter(FlxAxes.X);

    accuracyTxt2 = new FlxText(healthBarBG.x + 300, healthBarBG.y + 30, Std.int(healthBarBG.width - 100), "Accuracy: ", 30);
	accuracyTxt2.setFormat(Paths.font('dialogue.otf'), 30, FlxColor.WHITE, 'center');

    accuracyTxt3 = new FlxText(healthBarBG.x + 400, healthBarBG.y + 30, Std.int(healthBarBG.width - 100), 10, 0, '(N/A)', 30);
    accuracyTxt3.setFormat(Paths.font('dialogue.otf'), 30, FlxColor.WHITE, 'center');

    for(text22 in [scoreTxt, missesTxt, accuracyTxt,]) {
        remove(text22);
    }
    for(text in [scoreTxt2,missesTxt2,accuracyTxt2,accuracyTxt3]) {
        text.scrollFactor.set();
        text.camera = camHUD;
        insert(members.indexOf(dad), text);
    }
}
function getDefaultCamZoom(curCharacter: String, isBoyfriend: Bool){
    switch (curCharacter) {
        //dad's...??
        case "smiledog-tv": return 1;
        case "dog1": return 1.5;
        case "dog2": return 1.1;
        case "NBAdrakelikesyoungboys": return 0.6;
        case "monoe": return 0.65;
        case "monoko": return 0.80;
        case "monoko-broom": return 0.55;
        case "poniko": return 0.52;
        case "poniko-bike": return 0.55;
        case "uboa": return 1.30;
        case "amy-1": return 4.6;
        case "amy-2": return 4.6;
        case "amy-3": return 3.8;
        case "michael-ban": return 3.4;
        case "michael-tilted": return 4.6;
        case "michael-2": return 2.8;
        case "amy-kr": return 2.1;
        case "amy-ban": return 6;
        case "mama-front": return 1.1;
        case "mama-far": return 1.1;
        
        //Boyfriend..'s?
        case "sarah_1": if (isBoyfriend) return 0.750;
        case "sarah_fp": if (isBoyfriend) return customPlrZoom;
        case "evilkaru": if (isBoyfriend) return 0.9;
        case "mado-walk": if (isBoyfriend) return 0.45;
        case "mado-monoko": if (isBoyfriend) return 0.925;
        case "mado-pixel": if (isBoyfriend) return 0.65;
        case "mado-broom": if (isBoyfriend) return 0.55;
        case "mado-poniko": if (isBoyfriend) return 0.65;
        case "mado-bike": if (isBoyfriend) return 0.55;
        case "mado-uboa": if (isBoyfriend) return 0.80;
        case "mado-end": if (isBoyfriend) return 0.90;
        case "john-1": if (isBoyfriend) return 3.4;
        case "john-overworld": if (isBoyfriend) return 4.5;
        case "john-hardstyle": if (isBoyfriend) return 5;
        case "john-ban": if (isBoyfriend) return 3.4;
        case "john-tilted": if (isBoyfriend) return 4.2;
        case 'john-alone': if (isBoyfriend) return 4.2;
        case 'john-end': if (isBoyfriend) return 4.2;
        case "garcia-1": if (isBoyfriend) return 2.8;
        case "john-kr": if (isBoyfriend) return 2.1;
        case "john-exorcist": if (isBoyfriend) return 5;
        case "ruby-front": if (isBoyfriend) return 1.1;
        case "ruby-far": if (isBoyfriend) return 1.1;
        
        default: return 1; 
    }
}
function update(){
    var acc = FlxMath.roundDecimal(Math.max(accuracy, 0) * 100, 2);
    var grade:String;
    if (acc >= 100) {
        grade = "SS";
    } 
    else if (acc >= 95) {
        grade = "S";
        accuracyTxt3.color = FlxColor.YELLOW;
    } 
    else if (acc >= 90) {
        grade = "A";
        accuracyTxt3.color = colouredBarB;
    } else if (acc >= 80) {
        grade = "B";
        accuracyTxt3.color = FlxColor.GREEN;
    } else if (acc >= 70) {
        grade = "C";
        accuracyTxt3.color = FlxColor.RED;
    } else if (acc >= 60) {
        grade = "D";
        accuracyTxt3.color = colouredBar;
    }else if (acc <= 60) {
        grade = "      (N/A)";
        accuracyTxt3.color = FlxColor.RED;
    }
    accuracyTxt3.text = grade;

    FlxG.camera.followLerp = .12 * cameraSpeed;
    scoreTxt2.text = 'Score: ' + songScore;
    missesTxt2.text = comboBreaks ? "Combo Breaks: " : "Misses: " + misses;
}
function stepHit() {
    if (curSong == "Face Me") {
        if (curStep == 640 || curStep == 1152 || curStep == 1408) {
            camZooming = false;
        }

        if (curStep == 880 || curStep == 1200 || curStep == 1648) {
            camZooming = true;
        }
    }

    if (curStep == "Widespread") {
        if (curStep == 1648) {
            camZooming = false;
        }

        if (curStep == 1704) {
            camZooming = true;
            customPlrZoom = 0.8;
        }
    }

    if (curStep == "Deep Dream") {
        if (curStep == 3968) {
            camZooming = false;
            //doTweenZoom("zoomOut", "camGame", 0.90, 3, "quadInOut");
        }
    }

    if (curStep == "Evilkaru") {
        if (curStep == 759) {
            camZooming = false;
        }
    }
    if (camZooming) {
        if (curCameraTarget == 0) {
            defaultCamZoom = getDefaultCamZoom(dad.curCharacter, false);
        } else {
            defaultCamZoom = getDefaultCamZoom(boyfriend.curCharacter, true);
        }
    }
}

function onEvent(event) {
    switch (event.event.name) {
        case 'Camera Movement':
            camPos = [camFollow.x,camFollow.y];
    }   
}
public var alignX = true;
public var move = true;
public var move2 = true;

function onCameraMove(event) {
    if (event.position.x == dad.getCameraPosition().x && event.position.y == dad.getCameraPosition().y)
		camTarget = "dad";
	else if (event.position.x == boyfriend.getCameraPosition().x && event.position.y == boyfriend.getCameraPosition().y)
		camTarget = "boyfriend";

	if (dad.animation.curAnim.name == "idle" && boyfriend.animation.curAnim.name == "idle" && move) {} else
		event.cancel();

    if(cancelCameraMove) e.cancel();
}

var inte:Float = extent * 1.2;
var inteW:Float = (extent * 1.2) * (alignX ? 0.7 : 1);
var posOffsets:Array<Array<Float>> = [
	[-inte, 0],
	[0, inteW],
	[0, -inteW],
	[inte, 0]
];

function noteDataEKConverter(data, amount) {
	if (amount == 1) {
		if (data == 0) return 2;
		else return data;

	} else if (amount == 2) {
		if (data == 1) return 3;
		else return data;

	} else if (amount == 3) {
		if (data == 1) return 2;
		else if (data == 2) return 3;
		else return data;
	} else if (amount == 5) {
		if (data == 3) return 2;
		else if (data == 4) return 3;
		else return data;

	} else if (amount == 6) {
		if (data == 1) return 2;
		else if (data == 2) return 3;
		else if (data == 3) return 0;
		else if (data == 4) return 1;
		else if (data == 5) return 3;
		else return data;

	} else if (amount == 7) {
		if (data == 1) return 2;
		else if (data == 2) return 3;
		else if (data == 3) return 2;
		else if (data == 4) return 0;
		else if (data == 5) return 1;
		else if (data == 6) return 3;
		else return data;

	} else if (amount == 8) {
		if (data == 4) return 0;
		else if (data == 5) return 1;
		else if (data == 6) return 2;
		else if (data == 7) return 3;
		else return data;

	} else if (amount == 9) {
		if (data == 4) return 2;
		else if (data == 5) return 0;
		else if (data == 6) return 1;
		else if (data == 7) return 2;
		else if (data == 8) return 3;
		else return data;

	} else return data;
}

function onNoteHit(event) {
    var dir:Int = noteDataEKConverter(event.direction, event.note.strumLine.length);
    if (!move2) return;
    if (curCameraTarget == 0 && move2 && camTarget == "dad") { 
        camFollow.setPosition(dad.getCameraPosition().x + posOffsets[dir][0], dad.getCameraPosition().y + posOffsets[dir][1]);
    }
    else if (curCameraTarget == 1 && move2 && camTarget == "boyfriend") {
        camFollow.setPosition(boyfriend.getCameraPosition().x + posOffsets[dir][0], boyfriend.getCameraPosition().y + posOffsets[dir][1]);
    }
}
