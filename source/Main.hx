package;

import helpers.MusicManager;
import helpers.SaveManager;
import FPSCounter;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.*;

class Main extends Sprite
{
	public static var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: InitState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: false, // if the default flixel splash screen should be skipped
		startFullscreen: false, // if the game should start at fullscreen mode
		cached: false
	};

	public static var fpsVar:FPSCounter;

	public function new()
	{
		SaveManager.init();
		super();

		if (SaveManager.loadConfig("FPS") != null)
			game.framerate = SaveManager.loadConfig("FPS");
		else
			game.framerate = 60;
		if (SaveManager.loadConfig("HaxeSplash") != null)
			game.skipSplash = !SaveManager.loadConfig("HaxeSplash");
		else
			game.skipSplash = false;
		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
	}
}
