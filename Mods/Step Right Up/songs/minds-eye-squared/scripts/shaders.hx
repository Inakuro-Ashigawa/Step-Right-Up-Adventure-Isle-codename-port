var dupe = new CustomShader("camDupe");
var perspect = new CustomShader("perspective");
var fullTimer:Float = 0;

function create(){
	window.title = "SRUAI - MINDS EYE SQUARED";
	camGame.alpha = 0.001;

	//funny shaders
	dupe.multi = 1;
	dupe.mirrorS = false;
    camGame.addShader(dupe); 
	camHUD.addShader(dupe); 
}
function camDupesYAY(num){
	dupe.data.multi.value[0] = num;
	dupe.mirrorS = !dupe.mirrorS;
    camGame.addShader(perspect);
}
function update(elapsed:Float){
    fullTimer += elapsed;
    perspect.data.time = [fullTimer,fullTimer];
    if (dupe.data.multi.value[0] == 1){
        camGame.removeShader(perspect);
    }
}