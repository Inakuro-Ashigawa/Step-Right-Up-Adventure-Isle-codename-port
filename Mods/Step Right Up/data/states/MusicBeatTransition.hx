import funkin.editors.ui.UISlider;
import funkin.editors.ui.UIState;

var Curtin:FlxSprite;

function create() {

	transitionTween.cancel();
	remove(blackSpr);
    remove(transitionSprite);
    transitionCamera.scroll.y = 0;

    FlxG.cameras.add(cuming = new HudCamera(), false);
    cuming.bgColor = FlxColor.TRANSPARENT;

    Curtin = new FlxSprite();
    Curtin.frames = Paths.getSparrowAtlas('curtain_transition');
    Curtin.animation.addByPrefix('close', "close", 24, false);
    Curtin.animation.addByPrefix('open', "open", 24, false);
    Curtin.screenCenter();
    Curtin.camera = cuming;
    Curtin.scale.set(2,2);
    add(Curtin);

    if (newState == null){ 
        Curtin.animation.play('open');
    }else{
        Curtin.animation.play('close');
    }

	new FlxTimer().start(1, ()-> {
        finish();
    });
}