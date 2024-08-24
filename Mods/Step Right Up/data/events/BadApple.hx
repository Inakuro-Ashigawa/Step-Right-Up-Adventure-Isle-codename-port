import openfl.geom.ColorTransform;

var bAbg = new FunkinSprite();
var colouredBar = (dad != null && dad.xml != null && dad.xml.exists("color")) ? CoolUtil.getColorFromDynamic(dad.xml.get("color")) : 0xFFFFFFFF;
var colouredBarB = (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("color")) ? CoolUtil.getColorFromDynamic(boyfriend.xml.get("color")) : 0xFFFFFFFF;
var colouredBarG = (gf != null && gf.xml != null && gf.xml.exists("color")) ? CoolUtil.getColorFromDynamic(gf.xml.get("color")) : 0xFFFFFFFF;
function postCreate(){
	for (event in events) {
		if (event.name == 'BadApple') {
            bAbg.makeSolid(FlxG.width+10, FlxG.height+12, event.params[2]);// had to make it like this if not it will be blacking your screen
            bAbg.zoomFactor = 0;
            bAbg.scrollFactor.set();
            bAbg.screenCenter();
            bAbg.alpha = 0.0001;
            insert(members.indexOf(dad), bAbg); 
        }
    }
}
function onEvent(e) {
    if (e.event.name == "BadApple"){
        if (e.event.params[0] == true || e.event.params[0] == null){
            //FlxTween.tween(bAbg, {alpha: 1}, e.event.params[1], {ease: FlxEase.quadInOut});
            bAbg.alpha = 1;
            bAbg.colorTransform.color = FlxColor.BLACK;

            for (bfs in strumLines.members[1].characters) bfs.colorTransform.color = colouredBarB;
            for (dads in strumLines.members[0].characters) dads.colorTransform.color = colouredBar;
        } else {
            bAbg.alpha = 0.0001;
            for (bfs in strumLines.members[1].characters) bfs.setColorTransform();
            for (dads in strumLines.members[0].characters) dads.setColorTransform();
        }
    }
}