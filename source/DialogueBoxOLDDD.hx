package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;

class DialogueBoxOLDDD extends FlxSpriteGroup
{
	var box:FlxSprite;

	var dialogue:Alphabet;
	
	public var dialogueList:Array<String> = [];

	public var finishThing:Void->Void;
    public var loopingDialog:Bool = false;
	public static var dialogueLine:Int = 0;
	var finishedEditorText:Bool = false;
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	public static var curDialogCharacter:String = '';

	
	
	public function new(talkingRight:Bool = true, loopDialog:Bool = false, ?dialogSex:Array<String>)
	{
		super();

		box = new FlxSprite(40);
		box.frames = FlxAtlasFrames.fromSparrow(AssetPaths.speech_bubble_talking__png, AssetPaths.speech_bubble_talking__xml);
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.play('normalOpen');
		add(box);

		if (!talkingRight)
		{
			box.flipX = true;
		}
		loopingDialog = loopDialog;

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		add(dialogue);
		
		dialogueLine = 0;
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

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

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
				if(loopingDialog == true){
					
					restartDialogue();
				}else{
				    finishThing();
				    kill();
					
				}
			}
			
			
		}

		super.update(elapsed);
	}

	function startDialogue():Void
	{
		if (dialogueList[dialogueLine] != null)
			{
		        cleanDialog();
			}
		var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[dialogueLine], false, true);
		dialogue = theDialog;
		add(theDialog);
		trace(dialogueList[dialogueLine] + " | dialog int: " + dialogueLine);

		/*switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		}*/
	}
	function restartDialogue():Void{
		
		dialogueLine = 0;
		
		startDialogue();
	}
	function cleanDialog():Void
		{
			var splitName:Array<String> = dialogueList[dialogueLine].split(":");
			curDialogCharacter = splitName[1];
			trace("character: " + curDialogCharacter);
			dialogueList[dialogueLine] = dialogueList[dialogueLine].substr(splitName[1].length + 2);
		}
	
}
