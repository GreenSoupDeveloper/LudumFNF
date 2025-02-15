package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class MainEditorMenu extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String>;
	var curSelected:Int = 0;

	override function create()
	{
		menuItems = ['Chart Editor', 'Dialogue Editor BETA', 'Animation Debug State'];
		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		super.create();
	}

	override function update(elapsed:Float)
	{
		

		super.update(elapsed);
	

		
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var back = controls.BACK;

		if (back)
			{
				FlxG.switchState(new MainMenuState());
			}
		if (upP)
		{
			FlxG.sound.play('assets/shared/sounds/scrollMenu' + TitleState.soundExt);
			changeSelection(-1);
		}
		if (downP)
		{
			FlxG.sound.play('assets/shared/sounds/scrollMenu' + TitleState.soundExt);
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Chart Editor":
					PlayState.isStoryMode = true;
					FlxG.switchState(new ChartingState());
				case "Dialogue Editor BETA":
					FlxG.switchState(new DialogueEditorState());
				case "Animation Debug State":
					FlxG.switchState(new AnimationDebug());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}