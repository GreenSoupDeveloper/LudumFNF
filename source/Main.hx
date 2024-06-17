package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var ludumfnfVersion:String = "0.1.1";
	public static var ludumDEBUG:Bool = true;
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
