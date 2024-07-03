package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var dialogue:Alphabet;

	public static var dialogueList:Array<String> = [];

	public var finishThing:Void->Void;
	public var editMode:Bool = false;

	public static var dialogueLine:Int = 1;

	var finishedEditorText:Bool = false;
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	public static var curDialogCharacter:String = 'dad';
	public static var curDialogStyle:String = 'normal';
	public static var dialogStartFinished:Bool = false;

	public static var parseThingy:Bool = false;
	public static var updateDialogLine:Bool = false;

	// this will break your head
	// at least it works i think

	public function new(talkingRight:Bool = true, loopDialog:Bool = false, ?dialogSex:Array<String>)
	{
		super();

		box = new FlxSprite(40);
		box.frames = FlxAtlasFrames.fromSparrow(AssetPaths.speech_bubble_talking__png, AssetPaths.speech_bubble_talking__xml);
		box.animation.addByPrefix('angryOpen', 'speech bubble loud open', 24, false);
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('angry', 'AHH speech bubble', 24);
		box.animation.play('normalOpen');
		add(box);

		if (!talkingRight)
		{
			box.flipX = true;
		}
		editMode = loopDialog;

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		add(dialogue);

		dialogueLine = 1;
		dialogueList = dialogSex;
	}

	override function update(elapsed:Float)
	{
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		if (updateDialogLine == true)
		{
			remove(dialogue);
			startEditorEditDialogue();
			updateDialogLine = false;
		}
		switch (curDialogStyle)
		{
			case "angry":
				box.y = 285;
				box.x = 5;
			case "normal":
				box.y = 360;
				box.x = 40;
			default:
				box.y = 360;
				box.x = 40;
		}
		if (parseThingy == true)
		{
			remove(dialogue);
			dialogueLine += 1;
			startDialogue();
			parseThingy = false;
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		if (editMode == false)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				remove(dialogue);
				if (dialogueList[dialogueLine] != null)
				{
					dialogueLine += 1;

					startDialogue();
				}

				if (dialogueList[dialogueLine] == null)
				{
					if (editMode == true)
					{
						restartDialogue();
					}
					else
					{
						finishThing();
						kill();
					}
				}
			}
		}
		else
		{
			if (FlxG.keys.justPressed.CONTROL)
			{
				remove(dialogue);
				dialogueLine += 1;
				startDialogue();
			}
			if (FlxG.keys.justPressed.UP)
			{
				remove(dialogue);
				if (dialogueList[dialogueLine] != null)
				{
					dialogueLine += 1;
					dialogStartFinished = true;
					startDialogue();
				}

				if (dialogueList[dialogueLine] == null)
				{
					dialogStartFinished = true;
					restartDialogue();
				}
			}
			if (FlxG.keys.justPressed.DOWN)
			{
				remove(dialogue);
				if (dialogueList[dialogueLine] != null)
				{
					var thing:Int = dialogueLine - 1;
					if (thing > 0)
					{
						dialogueLine -= 1;
						dialogStartFinished = true;

						startDialogue();
					}else{
						restartDialogue();
					}
				}

				if (dialogueList[dialogueLine] == null)
				{
					var thing:Int = dialogueLine - 1;
					if (thing > 0)
					{
						dialogStartFinished = true;
					}
				}
			}
		}
		super.update(elapsed);
	}

	function startDialogue():Void
	{
		if (dialogueList[dialogueLine] != null || parseThingy == true)
		{
			cleanDialog();
		}
		box.animation.play(curDialogStyle);
		var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[dialogueLine], false, true);
		dialogue = theDialog;
		add(theDialog);
		debugTrace(dialogueList[dialogueLine] + " | dialog int: " + dialogueLine);
		if (editMode == true)
		{
			DialogueEditorState.lineInputText.text = dialogueList[dialogueLine];

			DialogueEditorState.selectedText.text = 'Current Dialog: ' + dialogueLine;

			DialogueEditorState.characterInputText.text = curDialogCharacter;
			DialogueEditorState.boxTypeInputText.text = curDialogStyle;
		}
	}

	function startEditorEditDialogue():Void
	{
		box.animation.play(curDialogStyle);
		var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[dialogueLine], false, true);
		dialogue = theDialog;
		add(theDialog);
		debugTrace(dialogueList[dialogueLine] + " | dialog int: " + dialogueLine);
		DialogueEditorState.lineInputText.text = dialogueList[dialogueLine];
		DialogueEditorState.selectedText.text = 'Current Dialog: ' + dialogueLine;
		DialogueEditorState.characterInputText.text = curDialogCharacter;
		DialogueEditorState.boxTypeInputText.text = curDialogStyle;

		var splitName:Array<String> = dialogueList[dialogueLine + 1].split(":");
		curDialogCharacter = splitName[1];
		debugTrace("character: " + curDialogCharacter);
		dialogueList[dialogueLine + 1] = dialogueList[dialogueLine + 1].substr(splitName[1].length + 2);
		var splitDialogShit:Array<String> = dialogueList[dialogueLine + 1].split("_");
		curDialogStyle = splitDialogShit[1];
		debugTrace("dialog style: " + curDialogStyle);
		dialogueList[dialogueLine + 1] = dialogueList[dialogueLine + 1].substr(splitDialogShit[1].length + 2);

		dialogueLine += 1;
		remove(dialogue);
		box.animation.play(curDialogStyle);
		var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[dialogueLine], false, true);
		dialogue = theDialog;
		add(theDialog);
		debugTrace(dialogueList[dialogueLine] + " | dialog int: " + dialogueLine);
		DialogueEditorState.lineInputText.text = dialogueList[dialogueLine];
		DialogueEditorState.selectedText.text = 'Current Dialog: ' + dialogueLine;
		DialogueEditorState.characterInputText.text = curDialogCharacter;
		DialogueEditorState.boxTypeInputText.text = curDialogStyle;
	}

	function restartDialogue():Void
	{
		dialogueLine = 1;

		startDialogue();
	}

	function cleanDialog():Void
	{
		if (dialogStartFinished == false)
		{
			var splitName:Array<String> = dialogueList[dialogueLine].split(":");
			curDialogCharacter = splitName[1];
			debugTrace("character: " + curDialogCharacter);
			dialogueList[dialogueLine] = dialogueList[dialogueLine].substr(splitName[1].length + 2);
			var splitDialogShit:Array<String> = dialogueList[dialogueLine].split("_");
			curDialogStyle = splitDialogShit[1];
			debugTrace("dialog style: " + curDialogStyle);
			dialogueList[dialogueLine] = dialogueList[dialogueLine].substr(splitDialogShit[1].length + 2);
		}
	}

	function debugTrace(debugTexty:String = ""):Void
	{
		if (Main.ludumDEBUG == true)
			trace(debugTexty + "");
	}
}
