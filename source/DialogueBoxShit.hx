package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagDialogue =
{
	var dialog:Int;
    var character:String;
	var text:String;
}

class DialogueBoxShit
{
	public var dialog:Int = 0;
	public var character:String = 'bf';
	public var text:String = '';

	public function new(dialog, character, text)
	{
		this.dialog = dialog;
		this.character = character;
		this.text = text;
        //shhhhhhh
		/*for (i in 0...notes.length)
		{
			this.sectionLengths.push(notes[i]);
		}*/
	}

	public static function loadFromJson(?folder:String):SwagDialogue
	{
		var rawJson = Assets.getText('assets/data/' + folder.toLowerCase() + '/songDialog.json').trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		var swagDialogShit:SwagDialogue = cast Json.parse(rawJson).song;
		trace(swagDialogShit.text[0]);

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.notes);
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daSections = songData.sections;
				daBpm = songData.bpm;
				daSectionLengths = songData.sectionLengths; */

		return swagDialogShit;
	}
}
