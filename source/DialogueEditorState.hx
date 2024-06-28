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
import flixel.system.FlxSound;
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
	var _file:FileReference;
	var box:FlxSprite;
	//var daText:TypedAlphabet;

	var selectedText:FlxText;
	var animText:FlxText;
    var dialogueTestEditor:Array<String> = ['blah blah blah', 'coolswag', 'swaggyness', "sex"];
    //var _dialog:SwagDialogue;



	override function create() {
		FlxG.sound.music.stop();
		FlxG.mouse.visible = true;
        
        var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menuDesat__png);
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.color = 0xFF494949;
		add(bg);

        addEditorBox();
        
		var addLineText:FlxText = new FlxText(10, 10, FlxG.width - 20, 'Press O to remove the current dialogue line, Press P to add another line after the current one.', 8);
		addLineText.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		addLineText.scrollFactor.set();
		add(addLineText);

		selectedText = new FlxText(10, 32, FlxG.width - 20, '', 8);
		selectedText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		selectedText.scrollFactor.set();
		add(selectedText);

		animText = new FlxText(10, 62, FlxG.width - 20, '', 8);
		animText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		animText.scrollFactor.set();
		add(animText);
		/*_dialog = {
            dialog: 0,
            character: "dad",
            text: "sex"
        }; //wip...*/
		openDialogueBox();

		super.create();
	}
    
    function openDialogueBox(){
        
        var dialogueBox:DialogueBox = new DialogueBox(false, true, dialogueTestEditor);
		// doof.x += 70;
		dialogueBox.y = FlxG.height * 0.5;
		dialogueBox.scrollFactor.set();
   
		//dialogueBox.finishThing = dialogueBoxRestart;
        add(dialogueBox);
    }
   
	var UI_box:FlxUITabMenu;
	function addEditorBox() {
		var tabs = [
			{name: 'Dialogue Box', label: 'Dialogue Box'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 210);
		UI_box.x = FlxG.width - UI_box.width - 10;
		UI_box.y = 10;
		UI_box.scrollFactor.set();
		addDialogueBoxUI();
		add(UI_box);
	}

	var lineInputText:FlxUIInputText;
    var soundInputText:FlxUIInputText;
	function addDialogueBoxUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Dialogue Box";

		
		//soundInputText = new FlxUIInputText(10, 100, 150, '', 8);
		//blockPressWhileTypingOn.push(soundInputText);
       
       
		lineInputText = new FlxUIInputText(10, 135, 230, dialogueTestEditor[0] + "", 8);
		//blockPressWhileTypingOn.push(lineInputText);

	
		var loadButton:FlxButton = new FlxButton(20, lineInputText.y + 25, "Load Dialogue", function() {
			//loadDialog("bopeebo");
		});
		var saveButton:FlxButton = new FlxButton(loadButton.x + 120, loadButton.y, "Save Dialogue", function() {
            // Create a handle to the file in text format (the false, true is binary)
           
			//saveDialog();
		});

		//tab_group.add(new FlxText(10, speedStepper.y - 18, 0, 'Interval/Speed (ms):'));
		//tab_group.add(new FlxText(10, characterInputText.y - 18, 0, 'Character:'));
		tab_group.add(new FlxText(10, soundInputText.y - 18, 0, 'Sound file name:'));
		tab_group.add(new FlxText(10, lineInputText.y - 18, 0, 'Text:'));
        tab_group.add(soundInputText);
		tab_group.add(lineInputText);
		tab_group.add(loadButton);
		tab_group.add(saveButton);
		UI_box.addGroup(tab_group);
	}

	
	override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE)
            {
               
                //DialogueBox.deleteBox();
                FlxG.switchState(new MainMenuState());
                
            }
		super.update(elapsed);
	}
   

    //WIP SHIIIIT
    /*function loadDialog(song:String):Void
        {
            var saveDifficulty:String = "";
    
    
            if (sys.FileSystem.exists('assets/data/'+ song.toLowerCase() + '/songDialog.json')) {
                _dialog = DialogueBoxShit.loadFromJson(song.toLowerCase());
            }else{
                _dialog = DialogueBoxShit.loadFromJson("bopeebo");
            }
            //lineInputText = _dialog.text + "";
            FlxG.resetState();
        }
    
        private function saveDialog()
        {
            var saveDifficulty:String = "";
            var json = {
                'dialog': _dialog.dialog,
                'character': _dialog.character,
                'text': _dialog.text
    
            };
    
          
    
            var data:String = Json.stringify(json);
    
            if ((data != null) && (data.length > 0))
            {
                _file = new FileReference();
                _file.addEventListener(Event.COMPLETE, onSaveComplete);
                _file.addEventListener(Event.CANCEL, onSaveCancel);
                _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                
                _file.save(data.trim(), "songDialog.json");
            }
        }
    
        function onSaveComplete(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.notice("Successfully saved DIALOG DATA.");
        }
    

        function onSaveCancel(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
        }

        function onSaveError(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.error("Problem saving Dialog data");
        }*/


}