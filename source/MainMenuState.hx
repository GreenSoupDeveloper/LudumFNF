package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import options.OptionsMenuState;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'donate', 'options'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var enteredOtherState:Bool = false;

	override function create()
	{
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic('assets/shared/music/title/freakyMenu' + TitleState.soundExt);
		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.1 - (0.02 * (optionShit.length - 4)), 0.06);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(AssetPaths.menuBG__png);
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = yScroll;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(AssetPaths.menuBGMagenta__png);
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = yScroll;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// var tex = FlxAtlasFrames.fromSparrow(AssetPaths.FNF_main_menu_assets__png, AssetPaths.FNF_main_menu_assets__xml);
		for (i in 0...optionShit.length)
		{
			var offset:Float = 100 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			trace("assets/images/mainMenu/menu_" + optionShit[i] + ".png");
			menuItem.frames = FlxAtlasFrames.fromSparrow("assets/images/mainMenu/menu_" + optionShit[i] + ".png",
				"assets/images/mainMenu/menu_" + optionShit[i] + ".xml");
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = true;
			// menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		if (Main.ludumDEBUG == true)
		{
			var fnfDebug:FlxText = new FlxText(12, FlxG.height - 44, 0, "DEBUG Mode Activated", 12);
			fnfDebug.scrollFactor.set();
			fnfDebug.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(fnfDebug);
		}
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Ludum Friday Night Funkin' v" + Main.ludumfnfVersion, 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);

		changeItem();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UP_P)
		{
			FlxG.sound.play('assets/shared/sounds/scrollMenu' + TitleState.soundExt);
			changeItem(-1);
		}

		if (controls.DOWN_P)
		{
			FlxG.sound.play('assets/shared/sounds/scrollMenu' + TitleState.soundExt);
			changeItem(1);
		}

		if (controls.BACK)
		{
			if(FlxG.save.data.oldTitleScreen == true){
				FlxG.switchState(new OldTitleState());
			}else{
				FlxG.switchState(new TitleState());
			}
			
		}
		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new MainEditorMenu());
		}
		/*	if (FlxG.keys.justPressed.NINE){
			PlayState.isStoryMode = true;
			FlxG.switchState(new DialogueEditorState());
		}*/

		super.update(elapsed);

		if (controls.ACCEPT)
		{
			if (enteredOtherState == false)
			{
				if (optionShit[curSelected] == 'donate')
				{
					enteredOtherState = true;
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					enteredOtherState = true;
					FlxG.sound.play('assets/shared/sounds/confirmMenu' + TitleState.soundExt);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										FlxG.switchState(new StoryMenuState());
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
									case 'options':
										FlxG.sound.music.stop();
										FlxG.switchState(new OptionsMenuState());
								}
							});
						}
					});
				}
			}
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
