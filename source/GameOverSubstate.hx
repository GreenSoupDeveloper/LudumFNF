package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	public function new(x:Float, y:Float)
	{

		super();
		var loser:FlxSprite = new FlxSprite(100, 100);
		var loseTex = FlxAtlasFrames.fromSparrow(AssetPaths.lose__png, AssetPaths.lose__xml);
		loser.frames = loseTex;
		loser.animation.addByPrefix('lose', 'lose', 24, false);
		loser.animation.play('lose');
		add(loser);
		FlxG.sound.play('assets/sounds/fnf_loss_sfx' + TitleState.soundExt);
		Conductor.changeBPM(100);
		var restart:FlxSprite = new FlxSprite(500, 50).loadGraphic(AssetPaths.restart__png);
		restart.setGraphicSize(Std.int(restart.width * 0.6));
		restart.updateHitbox();
		restart.alpha = 0;
		restart.antialiasing = true;
		add(restart);
	 FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2 + 10, FlxG.height / 2));
		FlxG.sound.music.fadeOut(2, FlxG.sound.music.volume * 0.6);

		FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			endBullshit();
		}

		

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			
			FlxG.sound.music.stop();
			FlxG.sound.play('assets/music/gameOverEnd' + TitleState.soundExt);
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new PlayState());
				});
			});
		}
	}
}
