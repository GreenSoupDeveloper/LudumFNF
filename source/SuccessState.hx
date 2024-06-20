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
	var difficultySprite:FlxSprite;
	
	var shitScoreSprite:FlxSprite;
	var badScoreSprite:FlxSprite;
	var goodScoreSprite:FlxSprite;
	var sickScoreSprite:FlxSprite;
	
	private var boyfriend:Boyfriend;
	var bfGood:FlxSprite;
	var finishedAnim:Bool = false;
	public static var finalScoreNote:Int;
	public var instantShitScore:Bool = false;
	var transitionAnimTime:Float = 2.5;
	override function create()
		{
			//horribly coded, but works so..
			if(PlayState.missedNotesNumber > PlayState.sickNotesNumber && PlayState.missedNotesNumber > PlayState.goodNotesNumber && PlayState.missedNotesNumber > PlayState.badNotesNumber && PlayState.missedNotesNumber > PlayState.shitNotesNumber){
				instantShitScore = true;
			}else{
				instantShitScore = false;
			}

			if(PlayState.sickNotesNumber > 0 && PlayState.goodNotesNumber == 0 && PlayState.badNotesNumber == 0 && PlayState.shitNotesNumber == 0 && PlayState.missedNotesNumber == 0){
				finalScoreNote = 4;
				transitionAnimTime = 2.45;
				trace("perfect score");
			}else{
			if(PlayState.sickNotesNumber > PlayState.goodNotesNumber)
				{
					finalScoreNote = 3;
					trace("sick score");
					
					transitionAnimTime = 3.1;
				}else{
					if(PlayState.goodNotesNumber > PlayState.badNotesNumber)
						{
						
							finalScoreNote = 2;
							trace("good score");
							transitionAnimTime = 2.45;

						}else{
							if(PlayState.badNotesNumber > PlayState.shitNotesNumber)
								{
								
									finalScoreNote = 1;
									trace("bad score");
									transitionAnimTime = 2.45;
								}else{
									
									finalScoreNote = 0;
									trace("shit score");
									transitionAnimTime = 2.45;
								}
						
						}
					
				}
			}   
			if(instantShitScore){
				finalScoreNote = 0;
			}
			//var songText:Alphabet = new Alphabet(100,100, "SEEEX", true, false);
			//songText.isMenuItem = true;
			//songText.targetY = i;
			//songText.add(songText);
			    if(finalScoreNote == 4){
					FlxG.sound.playMusic('assets/music/successScreen/perfect/resultsPERFECT' + TitleState.soundExt);
				}
				else if(finalScoreNote == 3){
					FlxG.sound.playMusic('assets/music/successScreen/excellent/resultsEXCELLENT-intro' + TitleState.soundExt, false);
					//FlxG.sound.playMusic('assets/music/successScreen/excellent/resultsEXCELLENT' + TitleState.soundExt);
				}
				else if(finalScoreNote == 2){
					FlxG.sound.playMusic('assets/music/successScreen/normal/resultsNORMAL' + TitleState.soundExt);
				}
				else if(finalScoreNote == 1){
					FlxG.sound.playMusic('assets/music/successScreen/bad/resultsBAD' + TitleState.soundExt);
				}
				else if(finalScoreNote == 0){
					FlxG.sound.playMusic('assets/music/successScreen/shit/resultsSHIT' + TitleState.soundExt, false);
				}else{
			FlxG.sound.playMusic('assets/music/successScreen/normal/resultsNORMAL' + TitleState.soundExt);
				}
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
				if(finalScoreNote > 2){
					//notin
				}else{
					FlxTween.tween(boyfriend, { y: boyfriend.y, x: boyfriend.x + 600 }, 3, {ease: FlxEase.quartInOut, type: ONESHOT});
				}
				
				new FlxTimer().start(transitionAnimTime, function(tmr:FlxTimer)
					{
						if(finalScoreNote > 2){
						
						bfGood = new FlxSprite(30, -60);
						var bfGoodaa = FlxAtlasFrames.fromSparrow(AssetPaths.resultBoyfriendGOOD__png, AssetPaths.resultBoyfriendGOOD__xml);
			            bfGood.frames = bfGoodaa;
			            bfGood.animation.addByPrefix('bf', 'Boyfriend Good Anim', 24, false);
			            bfGood.animation.play('bf');
			            bfGood.antialiasing = true;
						bfGood.setGraphicSize(Std.int(bfGood.width / 1.7));
			            add(bfGood);
						}
						else if(finalScoreNote < 2){
							boyfriend.playAnim('singLEFTLoss', true);
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
						switch(PlayState.storyDifficulty){
							case 0:
								difficultySprite = new FlxSprite(700, 245).loadGraphic(AssetPaths.diff_easy__png);
								
							case 1:
								difficultySprite = new FlxSprite(700, 245).loadGraphic(AssetPaths.diff_normal__png);
							    
							case 2:
								difficultySprite = new FlxSprite(700, 245).loadGraphic(AssetPaths.diff_hard__png);
								
						}

			            difficultySprite.antialiasing = true;
			            add(difficultySprite);

						var scoretext = new flixel.text.FlxText(910, 510, 0, PlayState.finalScore + "", 64);
						scoretext.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		                //scoretext.screenCenter();
		                add(scoretext);

						finishedAnim = true;
						if(finalScoreNote == 4){
						
						}
						else if(finalScoreNote == 3)
							{
								sickScoreSprite = new FlxSprite(680, 440);
								var sickScoreSpriteTex = FlxAtlasFrames.fromSparrow(AssetPaths.sick_score_result__png, AssetPaths.sick_score_result__xml);
								sickScoreSprite.frames = sickScoreSpriteTex;
								sickScoreSprite.animation.addByPrefix('sick', 'tally sick', 24, false);
								sickScoreSprite.animation.play('sick');
								sickScoreSprite.antialiasing = true;
								add(sickScoreSprite);
							}
						else if(finalScoreNote == 2)
							{						
								goodScoreSprite = new FlxSprite(690, 440);
								var goodScoreSpriteTex = FlxAtlasFrames.fromSparrow(AssetPaths.good_score_result__png, AssetPaths.good_score_result__xml);
								goodScoreSprite.frames = goodScoreSpriteTex;
								goodScoreSprite.animation.addByPrefix('good', 'tally good', 24, false);
								goodScoreSprite.animation.play('good');
								goodScoreSprite.antialiasing = true;
								add(goodScoreSprite);
							}
						else if(finalScoreNote == 1){
										
							badScoreSprite = new FlxSprite(690, 440);
							var badScoreSpriteTex = FlxAtlasFrames.fromSparrow(AssetPaths.bad_score_result__png, AssetPaths.bad_score_result__xml);
							badScoreSprite.frames = badScoreSpriteTex;
							badScoreSprite.animation.addByPrefix('bad', 'tally bad', 24, false);
							badScoreSprite.animation.play('bad');
							badScoreSprite.antialiasing = true;
							add(badScoreSprite);
						}
						else if(finalScoreNote == 0){
				            shitScoreSprite = new FlxSprite(690, 440);
						    var shitScoreSpriteTex = FlxAtlasFrames.fromSparrow(AssetPaths.shit_score_result__png, AssetPaths.shit_score_result__xml);
							shitScoreSprite.frames = shitScoreSpriteTex;
							shitScoreSprite.animation.addByPrefix('shit', 'tally shit', 24, false);
							shitScoreSprite.animation.play('shit');
							shitScoreSprite.antialiasing = true;
						    add(shitScoreSprite);	
						}else{
							shitScoreSprite = new FlxSprite(660, 440);
						    var shitScoreSpriteTex = FlxAtlasFrames.fromSparrow(AssetPaths.missed_score_result__png, AssetPaths.missed_score_result__xml);
							shitScoreSprite.frames = shitScoreSpriteTex;
							shitScoreSprite.animation.addByPrefix('miss', 'tally missed', 24, false);
							shitScoreSprite.animation.play('miss');
							shitScoreSprite.antialiasing = true;
						    add(shitScoreSprite);	
						}
					
							
					
						
					});
			});
		
	}
	override function update(elapsed:Float)
		{
			if (!FlxG.sound.music.playing && finalScoreNote == 3)
				FlxG.sound.playMusic('assets/music/successScreen/excellent/resultsEXCELLENT' + TitleState.soundExt);
			if (FlxG.keys.justPressed.ENTER)
				{
					if(finishedAnim == true){
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
				}
		
				
			
			super.update(elapsed);
		}
}
