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
import flixel.system.FlxSound;
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

class LoadingPrecacheState extends FlxState
{
	var songs:Array<String> = [];
	var songPrecache:FlxSound;

	override public function create():Void
	{
		super.create();
		songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

		for (i in 0...songs.length)
		{
			songPrecache = new FlxSound().loadEmbedded('assets/songs/' + songs[i].toLowerCase() + "/Inst" + TitleState.soundExt, true, true);
			songPrecache.stop();
		}
		shitDone();
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
