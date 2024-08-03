public var dupe = new CustomShader("camDupe");
var perspect = new CustomShader("perspective");
var fish = new CustomShader("FishEyeShader");
var aberration = new CustomShader('chromaticAberration');
var Glict = new CustomShader('glitchShit');
var fullTimer:Float = 0;

function create(){
	window.title = "SRUAI - MINDS EYE SQUARED";
	camGame.alpha = 0.001;

	//funny shaders
	dupe.multi = 1;
	dupe.mirrorS = false;
    camGame.addShader(dupe); 
	camGame.addShader(aberration);
	camHUD.addShader(aberration);
	setGeneralIntensity(0.001);
}
function beatHit(curBeat:Float) {
	if(camZooming && curBeat % camZoomingInterval == 0) {
		setGeneralIntensity(0.01);
	}
}
var intens:Float = 0;
function setGeneralIntensity(val:Float) {
	intens = val;
	aberration.redOff = [intens, 0];
	aberration.blueOff = [-intens, 0];
}
var canBump:Bool = camZooming;
function aberrationCoolThing() {
	canBump = !canBump;
	if(!canBump) {
		setGeneralIntensity(0.001);
		maxCamZoom = 1.35;
	} else maxCamZoom = 0;
}
function camDupesYAY(num){
	dupe.data.multi.value[0] = num;
	dupe.mirrorS = !dupe.mirrorS;
    camGame.addShader(perspect);
	camGame.addShader(fish);
	camGame.addShader(Glict);
}
function update(elapsed:Float){
    fullTimer += elapsed;
    perspect.data.time = [fullTimer,fullTimer];
	
	if(camZooming && intens > (0.0005)) setGeneralIntensity(intens - (0.001));

    if (dupe.data.multi.value[0] == 1){
        camGame.removeShader(perspect);
		camGame.removeShader(fish);
    }
}
function invert(heh){
	if (heh == "1"){
		camGame.addShader(Glict);
	}
	else if (heh == "0"){
		camGame.removeShader(Glict);
	}
}
function onGameOver() {
    camGame.removeShader(aberration);
    camGame.removeShader(perspect);
    camGame.removeShader(dupe);
	dupe.mirrorS = false;
}