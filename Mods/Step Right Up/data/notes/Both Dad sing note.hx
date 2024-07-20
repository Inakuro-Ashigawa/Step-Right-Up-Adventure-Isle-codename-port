var singDir = ["LEFT", "DOWN", "UP", "RIGHT"];
var dad2;
function create(){
    dad2 = strumLines.members[3].characters[0];
}
function onNoteHit(note:NoteHitEvent){
    var curNotes = note.noteType;

    switch(curNotes){
    case "Both Dad sing note":
        dad.playAnim("sing" + singDir[note.direction], true);
        dad2.playAnim("sing" + singDir[note.direction], true);
        note.cancelAnim();
        note.healthGain += 0.002;
    }
}