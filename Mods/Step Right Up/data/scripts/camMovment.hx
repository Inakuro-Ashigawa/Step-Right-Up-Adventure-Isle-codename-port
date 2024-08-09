
var customPlrZoom:Float = 1.5;
var extent:Float  = 5;

var camPos:Array<Float>;
var camExtend:Array<Float>;
public var cancelCameraMove = false;

var curSong = PlayState.instance.curSong;
var camSpeed = FlxG.camera.followLerp;

function postCreate() {
    if (curSong == "mortis") {
        extent = 3;
    }
    camSpeed = 2;
}

function update(elapsed:Float) {
    if (camZooming) {
        if (curCameraTarget == 0) {
            switch (dad.curCharacter) {
                case "smiledog-tv": defaultCamZoom = 1;
                case "dog1": defaultCamZoom = 1.5;
                case "dog2": defaultCamZoom = 1.1;
                case "NBAdrakelikesyoungboys": defaultCamZoom = 0.6;
                case "monoe": defaultCamZoom = 0.65;
                case "monoko": defaultCamZoom = 0.80;
                case "monoko-broom": defaultCamZoom = 0.55;
                case "poniko": defaultCamZoom = 0.52;
                case "poniko-bike": defaultCamZoom = 0.55;
                case "uboa": defaultCamZoom = 1.30;
                case "amy-1": defaultCamZoom = 4.6;
                case "amy-2": defaultCamZoom = 4.6;
                case "amy-3": defaultCamZoom = 3.8;
                case "michael-ban": defaultCamZoom = 3.4;
                case "michael-tilted": defaultCamZoom = 4.6;
                case "michael-2": defaultCamZoom = 2.8;
                case "amy-kr": defaultCamZoom = 2.1;
                case "amy-ban": defaultCamZoom = 6;
                case "mama-front": defaultCamZoom = 1.1;
                case "mama-far": defaultCamZoom = 1.1;
            }
        } else {
            switch (boyfriend.curCharacter) {
                case "sarah_1": defaultCamZoom = 0.750;
                case "sarah_fp": defaultCamZoom = customPlrZoom;
                case "evilkaru": defaultCamZoom = 0.9;
                case "mado-walk": defaultCamZoom = 0.45;
                case "mado-monoko": defaultCamZoom = 0.925;
                case "mado-pixel": defaultCamZoom = 0.65;
                case "mado-broom": defaultCamZoom = 0.55;
                case "mado-poniko": defaultCamZoom = 0.65;
                case "mado-bike": defaultCamZoom = 0.55;
                case "mado-uboa": defaultCamZoom = 0.80;
                case "mado-end": defaultCamZoom = 0.90;
                case "john-1": defaultCamZoom = 3.4;
                case "john-hardstyle": defaultCamZoom = 5;
                case "john-ban": defaultCamZoom = 3.4;
                case "john-tilted": defaultCamZoom = 4.2;
                case "garcia-1": defaultCamZoom = 2.8;
                case "john-kr": defaultCamZoom = 2.1;
                case "john-exorcist": defaultCamZoom = 5;
                case "ruby-front": defaultCamZoom = 1.1;
                case "ruby-far": defaultCamZoom = 1.1;
            }
        }
    }
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
}

public function onCameraMove(e) if(cancelCameraMove) e.cancel();


function onEvent(event) {
    switch (event.event.name) {
        case 'Camera Movement':
            camPos = [camFollow.x,camFollow.y];
    }   
}
public var alignX = true;
public var move = true;

function onCameraMove(event) {
	if (event.position.x == dad.getCameraPosition().x && event.position.y == dad.getCameraPosition().y)
		camTarget = "dad";
	else if (event.position.x == boyfriend.getCameraPosition().x && event.position.y == boyfriend.getCameraPosition().y)
		camTarget = "boyfriend";

	if (dad.animation.curAnim.name == "idle" && boyfriend.animation.curAnim.name == "idle" && move) {} else
		event.cancel();
}

var inte:Float = extent * 2;
var inteW:Float = (extent * 2) * (alignX ? 0.7 : 1);
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
	if (move)
		if (camTarget == "dad")
			camFollow.setPosition(dad.getCameraPosition().x + posOffsets[dir][0], dad.getCameraPosition().y + posOffsets[dir][1]);
		else if (camTarget == "boyfriend")
			camFollow.setPosition(boyfriend.getCameraPosition().x + posOffsets[dir][0], boyfriend.getCameraPosition().y + posOffsets[dir][1]);
}

function toggleMovePress(event)
	move = !move;