import haxe.Json;
import StringTools;
import sys.io.File;
import sys.FileSystem;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

var subtit:FlxText;
var subData;
var subSteps:Array<Array<Int>> = []; 
var subStrings:Array<String> = []; 
var currentSubtitleIndex:Int = 0;

function create() {
    var path = FileSystem.absolutePath(Assets.getPath('assets/songs/' + PlayState.instance.curSong + '/subtitles.json'));

    if (FileSystem.exists(path)) {
        subData = Json.parse(File.getContent(path)); 
        for (s in subData.subtitles) {
            subSteps.push(s.steps);
            subStrings.push(s.curString);
        }
    } 
    subtit = new FlxText(0, FlxG.height / 1.4, 1280, '', 15);
    subtit.setFormat(Paths.font('StepRightUp.ttf'), 22, FlxColor.WHITE, 'center');
    subtit.camera = camHUD;
    add(subtit);
    subtit.alpha = 0;
}

function stepHit() {
    if (currentSubtitleIndex < subSteps.length && currentSubtitleIndex < subStrings.length) { 
        var steps:Array<Int> = subSteps[currentSubtitleIndex];
        var curString:String = subStrings[currentSubtitleIndex];

        var stepIndex:Int = steps.indexOf(curStep);

        if (stepIndex != -1) {
            var words:Array<String> = curString.split('/');

            var markedUpText:String = '';
            for (i in 0...words.length) {
                if (i == stepIndex)
                    markedUpText += '#' + words[i] + '# ';
                else
                    markedUpText += words[i] + ' ';
            }
        
        }
        if (curStep >= steps[steps.length - 1]) {
            currentSubtitleIndex++;
            if (currentSubtitleIndex < subSteps.length && currentSubtitleIndex < subStrings.length) { 
                subtit.text = subStrings[currentSubtitleIndex]; 
            } else {
                subtit.text = ""; 
            }
        }
    }
}
