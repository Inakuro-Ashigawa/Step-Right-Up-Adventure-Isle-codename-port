var curSong = PlayState.instance.curSong;

function create(){
    if (curSong != 'face-me'){
        importScript("data/scripts/camMovment");
    }
}