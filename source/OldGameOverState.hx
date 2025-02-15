package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;

class OldGameOverState extends MusicBeatState
{
	var restart:FlxSprite;
	var loser:FlxSprite;
	var gameOverMusic:FlxSound;
	var afterThing:Bool = false;
	var daStage = PlayState.curStage;
	override function create()
	{
		if(daStage == "school" || daStage == "schoolEvil")
		{
			gameOverMusic = new FlxSound().loadEmbedded('assets/shared/music/gameOver/gameOver-pixel' + TitleState.soundExt, true, true);
			FlxG.sound.play('assets/shared/sounds/fnf_loss_sfx-pixel-old' + TitleState.soundExt, 0.7);
		}
		else
		{
			gameOverMusic = new FlxSound().loadEmbedded('assets/shared/music/gameOver/gameOver' + TitleState.soundExt, true, true);
			FlxG.sound.play('assets/shared/sounds/fnf_loss_sfx-old' + TitleState.soundExt, 0.7);
		}

		
		loser = new FlxSprite(100, 100);
		var loseTex = FlxAtlasFrames.fromSparrow(AssetPaths.lose__png, AssetPaths.lose__xml);
		loser.frames = loseTex;
		loser.animation.addByPrefix('lose', 'lose', 24, false);
		loser.animation.play('lose');
		add(loser);

		restart = new FlxSprite(500, 50).loadGraphic(AssetPaths.restart__png);
		restart.setGraphicSize(Std.int(restart.width * 0.6));
		restart.updateHitbox();
		restart.alpha = 0;
		restart.antialiasing = true;
		add(restart);

		FlxG.sound.music.fadeOut(2, FlxG.sound.music.volume * 0.6);

		FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});
		activatethingy();
		super.create();
	}

	function activatethingy():Void
	{
		new FlxTimer().start(2.2, function(tmr:FlxTimer)
		{
			FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
			afterThing = true;
			afterThingieThing();
		});
	}

	function afterThingieThing():Void
	{
		gameOverMusic.volume = 0;
		gameOverMusic.play(false, FlxG.random.int(0, Std.int(gameOverMusic.length / 2)));
	}

	private var fading:Bool = false;

	override function update(elapsed:Float)
	{
		if (gameOverMusic.volume < 1)
			gameOverMusic.volume += 0.05 * elapsed;
		if (FlxG.keys.justPressed.ENTER)
		{
			endBullshit();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			PlayState.songPlaying = false;
			PlayState.finalScore = 0;
			PlayState.sickNotesNumber = 0;
			PlayState.goodNotesNumber = 0;
			PlayState.badNotesNumber = 0;
			PlayState.shitNotesNumber = 0;
			PlayState.missedNotesNumber = 0;
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			gameOverMusic.stop();
			FlxG.sound.music.stop();
			FlxG.camera.follow(restart, LOCKON, 0.09);
			FlxTween.tween(loser, {alpha: -1}, 1, {ease: FlxEase.quartInOut});
			if(daStage == "school" || daStage == "schoolEvil")
			{
				FlxG.sound.play('assets/shared/music/gameOver/gameOverEnd-pixel' + TitleState.soundExt);
			}
			else
			{
				FlxG.sound.play('assets/shared/music/gameOver/gameOverEnd' + TitleState.soundExt);
			}
			new FlxTimer().start(0.9, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					PlayState.songPlaying = false;
					PlayState.finalScore = 0;
					PlayState.sickNotesNumber = 0;
					PlayState.goodNotesNumber = 0;
					PlayState.badNotesNumber = 0;
					PlayState.shitNotesNumber = 0;
					PlayState.missedNotesNumber = 0;
					FlxG.switchState(new PlayState());
				});
			});
		}
	}
}
/* var restart:FlxSprite;
	var loser:FlxSprite;
	public function new(x:Float, y:Float)
	{
		super();

		
	}

	override function create()
	{
			loser = new FlxSprite(100, 100);
			var loseTex = FlxAtlasFrames.fromSparrow(AssetPaths.lose__png, AssetPaths.lose__xml);
			loser.frames = loseTex;
			loser.animation.addByPrefix('lose', 'lose', 24, false);
			loser.animation.play('lose');
			add(loser); 

		


		
		 
			restart = new FlxSprite(500, 50).loadGraphic(AssetPaths.restart__png);
			restart.setGraphicSize(Std.int(restart.width * 0.6));
			restart.updateHitbox();
			restart.alpha = 0;
			restart.antialiasing = true;
			// add(restart); 

		FlxG.sound.music.fadeOut(2, FlxG.sound.music.volume * 0.6);

		FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

		super.create();
	}

	private var fading:Bool = false;

	override function update(elapsed:Float)
	{
		var pressed:Bool = FlxG.keys.justPressed.ANY;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.ANY)
				pressed = true;
		}

		pressed = false;

		if (pressed && !fading)
		{
			fading = true;
			FlxG.camera.follow(restart, LOCKON, 0.001);
			FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
			{
				FlxG.sound.music.stop();
				FlxG.switchState(new PlayState());
			});
		}
		super.update(elapsed);
}*/
