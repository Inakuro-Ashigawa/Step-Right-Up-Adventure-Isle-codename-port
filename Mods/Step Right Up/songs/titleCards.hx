var BlackBG,Card:FlxSprite;
var curSong = PlayState.instance.curSong.toLowerCase();
var selectedCardImagePath:String = curSong;
var randomValue = FlxG.random.int(0, 1);

introLenth = 2;
function onSongStart(){
    FlxTween.tween(BlackBG, {alpha: 0}, 1, {ease: FlxEase.linear});
    FlxTween.tween(Card, {alpha: 0}, 1, {ease: FlxEase.linear});
}
function postCreate(){
    BlackBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    BlackBG.setGraphicSize(Std.int(BlackBG.width * 10));
    BlackBG.alpha = 1;
    BlackBG.cameras = [camHUD];
    add(BlackBG);

    
    if (curSong == "mortis") {
        if (randomValue == 0) {
            selectedCardImagePath = 'mortis';
            trace("normal");
        } 
        else if (randomValue == 1) {
            selectedCardImagePath = 'evilmortis';
            trace("evil");
        }    
    } else {
        selectedCardImagePath =  curSong;
    }

    Card = new FlxSprite().loadGraphic(Paths.image('titlecards/' + selectedCardImagePath));
    Card.scrollFactor.set;
    Card.alpha = 0;
    Card.cameras = [camHUD];
    Card.screenCenter();
    add(Card);


    FlxTween.tween(Card, {alpha: 1}, 0.1, {ease: FlxEase.linear});
}