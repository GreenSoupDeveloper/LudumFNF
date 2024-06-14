package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
using StringTools;

class SuccessState extends MusicBeatState
{

	var diffText:FlxText;
	

	var results:FlxSprite;
	var scoreSprite:FlxSprite;
	private var boyfriend:Boyfriend;
	var bfGood:FlxSprite;
	var finishedAnim:Bool = false;
	override function create()
		{
			FlxG.sound.playMusic('assets/music/successScreen/normal/resultsNORMAL' + TitleState.soundExt);
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(AssetPaths.menuBG__png);
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0.18;
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
			add(bg);
			results = new FlxSprite(-180, 300);
			var resultsTex = FlxAtlasFrames.fromSparrow(AssetPaths.results__png, AssetPaths.results__xml);
			results.frames = resultsTex;
			results.animation.addByPrefix('result', 'results instance ', 24, false);
			results.animation.play('result');
			
			results.antialiasing = true;
			add(results);
		
		boyfriend = new Boyfriend(-450, 170);
		add(boyfriend);
		boyfriend.playAnim('idle');
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxTween.tween(results, { y: results.y, x: results.x + 300 }, 2, {ease: FlxEase.quartInOut, type: ONESHOT});
				if(PlayState.finalScore > 3000){
					//notin
				}else{
					FlxTween.tween(boyfriend, { y: boyfriend.y, x: boyfriend.x + 600 }, 3, {ease: FlxEase.quartInOut, type: ONESHOT});
				}
				
				new FlxTimer().start(2.5, function(tmr:FlxTimer)
					{
						if(PlayState.finalScore > 3000){
						
						bfGood = new FlxSprite(30, -60);
						var bfGoodaa = FlxAtlasFrames.fromSparrow(AssetPaths.resultBoyfriendGOOD__png, AssetPaths.resultBoyfriendGOOD__xml);
			            bfGood.frames = bfGoodaa;
			            bfGood.animation.addByPrefix('bf', 'Boyfriend Good Anim', 24, false);
			            bfGood.animation.play('bf');
			            bfGood.antialiasing = true;
						bfGood.setGraphicSize(Std.int(bfGood.width / 1.7));
			            add(bfGood);
						}else{
							boyfriend.playAnim('hey');
						}

						scoreSprite = new FlxSprite(695, 400);
			            var scoreSpriteTex = FlxAtlasFrames.fromSparrow(AssetPaths.scorePopin__png, AssetPaths.scorePopin__xml);
			            scoreSprite.frames = scoreSpriteTex;
			            scoreSprite.animation.addByPrefix('scoree', 'tally score', 24, false);
			            scoreSprite.animation.play('scoree');
			            scoreSprite.antialiasing = true;
			            add(scoreSprite);
						var scoretext = new flixel.text.FlxText(910, 510, 0, PlayState.finalScore + "", 64);
						scoretext.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		                //scoretext.screenCenter();
		                add(scoretext);
						finishedAnim = true;
						
					});
			});
		
	}
	override function update(elapsed:Float)
		{
			if (FlxG.keys.justPressed.ENTER)
				{
					if(finishedAnim == true){
					PlayState.finalScore = 0;
					FlxG.sound.music.stop();
		
					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
				    }
				}
		
				
			
			super.update(elapsed);
		}
}
