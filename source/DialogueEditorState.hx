package;

import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import flixel.util.FlxTimer;

using StringTools;

class DialogueEditorState extends MusicBeatState
{
	// var _file:FileReference;
	var box:FlxSprite;

	// var daText:TypedAlphabet;
	public static var selectedText:FlxText;

	var dialogAmountText:FlxText;
	var dialogueTestEditor:Array<String> = ['sex', ':dad:_normal_blah blah blah'];
	var dialogAmount:Int = 1;

	// var _dialog:SwagDialogue;
	// bro seriously i gotta fix this shitty state

	override function create()
	{
		FlxG.sound.music.stop();
		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menuDesat__png);
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.color = 0xFF494949;
		add(bg);

		var addLineText:FlxText = new FlxText(10, 10, FlxG.width - 20,
			'Press ALT to remove the current dialogue line, Press CONTROL to add another line after the current one.', 8);
		addLineText.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		addLineText.scrollFactor.set();
		add(addLineText);

		selectedText = new FlxText(10, 32, FlxG.width - 20, 'Current Dialog: 1', 8);
		selectedText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		selectedText.scrollFactor.set();
		add(selectedText);

		dialogAmountText = new FlxText(10, 62, FlxG.width - 20, 'Dialogs: ' + dialogAmount, 8);
		dialogAmountText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		dialogAmountText.scrollFactor.set();
		add(dialogAmountText);

		var addLineText:FlxText = new FlxText(10, 94, FlxG.width - 20,
			'HAVE IN MIND THAT THIS THING IS IN A BETA AND VERY UNSTABLE STATE, TAKE CARE.', 8);
		addLineText.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		addLineText.scrollFactor.set();
		add(addLineText);

		openDialogueBox();
		addEditorBox();

		

		super.create();
	}

	function openDialogueBox()
	{
		var dialogueBox:DialogueBox = new DialogueBox(false, true, dialogueTestEditor);
		// doof.x += 70;
		dialogueBox.y = FlxG.height * 0.5;
		dialogueBox.scrollFactor.set();

		// dialogueBox.finishThing = dialogueBoxRestart;
		add(dialogueBox);
	}

	var UI_box:FlxUITabMenu;

	function addEditorBox()
	{
		var tabs = [{name: 'Dialogue Box', label: 'Dialogue Box'},];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 210);
		UI_box.x = FlxG.width - UI_box.width - 10;
		UI_box.y = 10;
		UI_box.scrollFactor.set();
		addDialogueBoxUI();
		add(UI_box);
	}

	public static var lineInputText:FlxUIInputText;
	public static var characterInputText:FlxUIInputText;
	public static var boxTypeInputText:FlxUIInputText;

	function addDialogueBoxUI()
	{
		var tab_group_dialog = new FlxUI(null, UI_box);
		tab_group_dialog.name = "Dialogue Box";

		boxTypeInputText = new FlxUIInputText(10, 65, 150, 'normal', 8);
		characterInputText = new FlxUIInputText(10, 100, 150, 'dad', 8);
		// blockPressWhileTypingOn.push(soundInputText);

		lineInputText = new FlxUIInputText(10, 135, 230, dialogueTestEditor[DialogueBox.dialogueLine] + "", 8);
		// blockPressWhileTypingOn.push(lineInputText);

		var loadButton:FlxButton = new FlxButton(20, lineInputText.y + 25, "Load Dialogue", function()
		{
			// loadDialog("bopeebo");
		});
		var saveButton:FlxButton = new FlxButton(loadButton.x + 120, loadButton.y, "Apply", function()
		{
			// Create a handle to the file in text format (the false, true is binary)
			removeDialogThingy();
			editDialogThingy();

			// saveDialog();
		});
		tab_group_dialog.add(new FlxText(10, boxTypeInputText.y - 18, 0, 'Dialogue Type: '));
		tab_group_dialog.add(new FlxText(10, lineInputText.y - 18, 0, 'Text: '));
		tab_group_dialog.add(new FlxText(10, characterInputText.y - 18, 0, 'Character:'));
		tab_group_dialog.add(boxTypeInputText);
		tab_group_dialog.add(characterInputText);
		tab_group_dialog.add(lineInputText);
		tab_group_dialog.add(loadButton);
		tab_group_dialog.add(saveButton);
		UI_box.addGroup(tab_group_dialog);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			// DialogueBox.deleteBox();
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			lineInputText.text += "/";
		}
		if (FlxG.keys.justPressed.CONTROL)
		{
			addDialogThingy();
		}
		if (FlxG.keys.justPressed.ALT)
		{
			dialogAmount = dialogueTestEditor.length - 1;
			if(dialogAmount > 1)
			removeDialogThingy();
		}
		super.update(elapsed);
	}

	function removeDialogThingy():Void
	{
		dialogueTestEditor.remove(dialogueTestEditor[DialogueBox.dialogueLine]);
		DialogueBox.dialogueLine -= 1;
		dialogAmount = dialogueTestEditor.length - 1;
		dialogAmountText.text = "Dialogs: " + dialogAmount;

		DialogueBox.dialogueList = dialogueTestEditor;
		trace("removed: " + dialogueTestEditor);
		DialogueBox.updateDialogLine = true;

		// DialogueBox.dialogueLine;
	}

	function addDialogThingy():Void
	{
		dialogueTestEditor.insert(dialogueTestEditor.length, ":dad:_normal_Insert text here");
		dialogAmount = dialogueTestEditor.length - 1;
		dialogAmountText.text = "Dialogs: " + dialogAmount;
		// cleanDialogShit();
		// DialogueBox.dialogueList = dialogueTestEditor;

		DialogueBox.dialogStartFinished = false;

		// DialogueBox.dialogueLine;
	}

	function editDialogThingy():Void
	{
		dialogueTestEditor.insert(dialogueTestEditor.length + 1, ":" + characterInputText.text + ":_" + boxTypeInputText.text + "_" + lineInputText.text);
		dialogAmount = dialogueTestEditor.length - 1;
		dialogAmountText.text = "Dialogs: " + dialogAmount;
		// cleanDialogShit();
		// DialogueBox.dialogueList = dialogueTestEditor;

		DialogueBox.dialogStartFinished = false;

		// DialogueBox.dialogueLine;
	}

	function cleanDialogShit():Void
	{
		var splitName:Array<String> = dialogueTestEditor[dialogueTestEditor.length].split(":");
		DialogueBox.curDialogCharacter = splitName[1];
		var splitDialogShit:Array<String> = dialogueTestEditor[dialogueTestEditor.length].split("_");
		DialogueBox.curDialogStyle = splitDialogShit[1];
		// trace("character: " + DialogueBox.curDialogCharacter);
		dialogueTestEditor[dialogueTestEditor.length] = dialogueTestEditor[dialogueTestEditor.length].substr(splitName[1].length + 2);
		trace("dialog shit parsed: " + dialogueTestEditor);
		DialogueBox.dialogueList[dialogueTestEditor.length] = dialogueTestEditor[dialogueTestEditor.length];

		// trace("dialog shit parsed second: " + dialogueTestEditor);
	}

	function debugTrace(debugTexty:String = ""):Void{
		if (Main.ludumDEBUG == true)
			trace(debugTexty + "");
	}
}
