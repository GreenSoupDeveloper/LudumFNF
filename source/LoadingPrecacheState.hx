package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class LoadingPrecacheState extends MusicBeatState
{
	var songs:Array<String> = [];
	var otherSongs:Array<String> = ["assets/shared/music/title/freakyMenu" + TitleState.soundExt];
	var songPrecache:FlxSound;

	override public function create():Void
	{
		super.create();
		// songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

		var text = new flixel.text.FlxText(0, 0, 0, "Precachin' Assets...", 26);
		text.x = (FlxG.width - text.width) / 2;
		text.y = (FlxG.height - text.height) / 1.26;
		add(text);
		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/ludumlogo.png');
		bg.antialiasing = true;
		bg.scale.set(0.8, 0.8);
		bg.y += 120;
		bg.x = (FlxG.width - bg.width) / 2;
		add(bg);
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

			for (i in 0...songs.length)
			{
				text.text = "Precachin' Assets... (" + (i + 1) + "/" + songs.length + ")";
				
					songPrecache = new FlxSound().loadEmbedded('assets/songs/' + songs[i].toLowerCase() + "/Inst" + TitleState.soundExt, true, true);
					songPrecache.stop();
					
				
			}
			/*for (i in 0...songPrecache.length)
				{
					songPrecache = new FlxSound().loadEmbedded(songPrecache[i], true, true);
					songPrecache.stop();
			}*/
			songPrecache = new FlxSound().loadEmbedded("assets/shared/music/title/freakyMenu" + TitleState.soundExt, true, true);
			songPrecache.stop();
			shitDone();
		});
	}

	function shitDone():Void
	{
		if (FlxG.save.data.oldTitleScreen == true)
		{
			FlxG.switchState(new OldTitleState());
		}
		else
		{
			FlxG.switchState(new TitleState());
		}
	}
}
