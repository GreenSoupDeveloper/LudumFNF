package options;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenuState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var optionsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/shared/music/options/lowkeyOptions' + TitleState.soundExt);
			FlxG.sound.music.volume = 0.35;
		}
		optionsStrings = [
			'Old Game Over Screen = ' + GameOptions.oldGameOverMenu,
			'Old Title Screen = ' + GameOptions.oldTitleScreen
		];
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...optionsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, optionsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);

			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
			FlxG.sound.music.stop();
			FlxG.sound.music.volume = 100;
		}
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					if (GameOptions.oldGameOverMenu == false)
					{
						GameOptions.oldGameOverMenu = true;
						FlxG.save.data.oldGameOverMenu = GameOptions.oldGameOverMenu;
						FlxG.save.flush();
					}
					else
					{
						GameOptions.oldGameOverMenu = false;
						FlxG.save.data.oldGameOverMenu = GameOptions.oldGameOverMenu;
						FlxG.save.flush();
					}
				case 1:
					if (GameOptions.oldTitleScreen == false)
					{
						GameOptions.oldTitleScreen = true;
						FlxG.save.data.oldTitleScreen = GameOptions.oldTitleScreen;
						FlxG.save.flush();
					}
					else
					{
						GameOptions.oldTitleScreen = false;
						FlxG.save.data.oldTitleScreen = GameOptions.oldTitleScreen;
						FlxG.save.flush();
					}
			}
			FlxG.resetState();
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/shared/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
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
