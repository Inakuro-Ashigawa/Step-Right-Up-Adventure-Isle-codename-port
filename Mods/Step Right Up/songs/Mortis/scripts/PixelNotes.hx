
//Pixel notes
function onPostNoteCreation(event) {  
    var note = event.note;
    note.splash = "Pixel";
}
var noteSize:Float = 6;
function onNoteCreation(event) {
	event.cancel();
	var note = event.note;
	if (event.note.isSustainNote) {
		note.loadGraphic(Paths.image('pixelUI/noteSkins/NOTE_assetsENDS'), true, 7, 6);
		note.animation.add("hold", [event.strumID]);
		note.animation.add("holdend", [4 + event.strumID]);
	} else {
		note.loadGraphic(Paths.image('pixelUI/noteSkins/NOTE_assets'), true, 17, 17);
		note.animation.add("scroll", [4 + event.strumID]);
	}
	note.scale.set(noteSize, noteSize);
	note.updateHitbox();
}
function onStrumCreation(event) {
	event.cancel();

	var strum = event.strum;
	strum.loadGraphic(Paths.image('pixelUI/noteSkins/NOTE_assets'), true, 17, 17);
	strum.animation.add("static", [event.strumID]);
	strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
	strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);

	strum.scale.set(noteSize, noteSize);
	strum.updateHitbox();
}