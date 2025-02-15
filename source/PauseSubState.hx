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

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String>;
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var difficHere = "";
	public static var currentREALDifficulty:Int = 0; //wip


	public function new(x:Float, y:Float)
	{
		super();
		
		switch (PlayState.storyDifficulty)
		{
			case 0:
				difficHere = 'EASY';
				case 1:
				difficHere = 'NORMAL';
			case 2:
				difficHere = 'HARD';
		}
		menuItems = ['Resume', 'Restart Song', 'Exit to menu'];

		pauseMusic = new FlxSound().loadEmbedded('assets/shared/music/pause/breakfast' + TitleState.soundExt, true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
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

		





		

		var defficTexty:FlxText = new FlxText(10, 15 + 32, FlxG.width - 60, 'Difficulty: ');
		// scoreText.autoSize = false;
		defficTexty.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		//scoreText.screenCenter(X);
		defficTexty.scrollFactor.set();
		defficTexty.text += difficHere;
		  add(defficTexty);
		  
		var songnameTexty:FlxText = new FlxText(30, 15 + 72, FlxG.width - 100, 'Difficulty: ');
		// scoreText.autoSize = false;
		songnameTexty.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		//scoreText.screenCenter(X);
		songnameTexty.scrollFactor.set();
		songnameTexty.text = PlayState.SONG.song;
		  add(songnameTexty);
		
	
	
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
	

		
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

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
				case "Resume":
					close();
				case "Restart Song":
					PlayState.songPlaying = false;
					PlayState.finalScore = 0;
					PlayState.sickNotesNumber = 0;
					PlayState.goodNotesNumber = 0;
					PlayState.badNotesNumber = 0;
					PlayState.shitNotesNumber = 0;
					PlayState.missedNotesNumber = 0;
					FlxG.sound.music.stop();
					PlayState.vocals.stop();
					FlxG.resetState();
				case "Exit to menu":
					PlayState.songPlaying = false;
					PlayState.finalScore = 0;
					PlayState.sickNotesNumber = 0;
					PlayState.goodNotesNumber = 0;
					PlayState.badNotesNumber = 0;
					PlayState.shitNotesNumber = 0;
					PlayState.missedNotesNumber = 0;
					FlxG.sound.music.stop();
					PlayState.vocals.stop();

					if (PlayState.isStoryMode){
						FlxG.switchState(new StoryMenuState()); 
						FlxG.resetState();
					}
					else{
						FlxG.switchState(new FreeplayState());
						FlxG.resetState();
					}
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
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
