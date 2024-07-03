package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class Main extends Sprite
{
	public static var ludumfnfVersion:String = "0.1.2";
	public static var ludumDEBUG:Bool = true;
	
	public function new()
	{
		//SkipSplash = true;
		super();
		

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
		FlxG.save.bind('ludumfnf', 'greensoupdev');
		Highscore.load();

		GameOptions.oldGameOverMenu = FlxG.save.data.oldGameOverMenu;
		GameOptions.oldTitleScreen = FlxG.save.data.oldTitleScreen;
		if(FlxG.save.data.oldTitleScreen == true){
			addChild(new FlxGame(0, 0, OldTitleState));
		}else{
			addChild(new FlxGame(0, 0, TitleState));
		}
	}
}
