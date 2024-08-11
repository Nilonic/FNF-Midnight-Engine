package states;

import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import helpers.SaveManager;
import lime.utils.Assets;
import haxe.Timer;
import openfl.display.Screen;
import helpers.Paths;
import helpers.Cache;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.system.FlxAssets;

class CacheState extends FlxState
{
    private var cacheLabel:FlxText;
    private var progressBar:FlxSprite;
    private var avgTimeLabel:FlxText;

    private var totalFiles:Int;
    private var cachedFiles:Int;
    private var startTime:Date;
    private var totalTime:Float;

    private var soundList:Array<String> = ["cancelMenu", "confirmMenu", "scrollMenu", "denied"]; // tracked sounds, to be cached
    private var musicList:Array<String> = ["BGMusicTemp"]; // tracked music, to be cached

    // just some config stuff
    var cfgCacheSounds = SaveManager.loadConfig("CacheSounds");
    var cfgCacheMusic = SaveManager.loadConfig("CacheMusic");

    override public function create():Void
    {
        cacheLabel = new FlxText(0, 0, FlxG.width, "Initializing...");
        cacheLabel.alignment = "center";
        add(cacheLabel);
        
        progressBar = new FlxSprite(0, FlxG.height - 20, null);
        progressBar.makeGraphic(FlxG.width, 20, FlxColor.GRAY);
        add(progressBar);
        
        avgTimeLabel = new FlxText(0, 0, FlxG.width, "Avg Time: N/A");
        avgTimeLabel.y = FlxG.height - avgTimeLabel.height - 30;
        avgTimeLabel.alignment = "center";
        add(avgTimeLabel);

        // Initialize time tracking variables
        totalFiles = soundList.length + musicList.length;
        cachedFiles = 0;
        startTime = Date.now();
        totalTime = 0;

        super.create();
        
        cache();
    }

    private function updateProgressBar():Void
    {
        var progress = cachedFiles / totalFiles;
        progressBar.makeGraphic(Std.int(FlxG.width * progress), 20, FlxColor.GREEN);
    }

    private function updateAvgTimeLabel():Void
    {
        var avgTime = (cachedFiles > 0) ? (totalTime / cachedFiles) : 0;
        avgTimeLabel.text = "Avg Time: " + FlxMath.roundDecimal(avgTime, 2) + "s";
    }

    private function onCachingComplete():Void
    {
        // Set cached flag
        Main.game.cached = true;
        cacheLabel.text = "Caching complete, loading...";
        FlxTimer.wait(2, nextState);
    }

    function nextState():Void
    {
       // Switch to the new state
       FlxG.switchState(new TitleState());
    }

    function cache():Void
    {
        if (cfgCacheSounds)
        {
            trace("Caching Sounds...");
            cacheLabel.text = "Caching sounds...";
            for (sound in soundList)
            {
                try 
                {
                    cacheLabel.text = "Caching sounds... (" + sound + ")";
                    var path = Paths.getSound(sound);
                    var object = FlxG.sound.load(path, 1, false);
                    object.autoDestroy = false;
                    object.persist = true;
                    Cache.soundsMap.set(path, object);
                    onFileCached();
                }
                catch (e:Dynamic) 
                {
                    trace("Error caching sound: " + sound + " at path: " + Paths.getSound(sound));
                    cacheLabel.text = "Error caching sound: " + sound;
                }
            }
        }
        if (cfgCacheMusic)
        {
            trace("Caching music...");
            cacheLabel.text = "Caching music...";
            for (music in musicList)
            {
                try 
                {
                    cacheLabel.text = "Caching music... (" + music + ")";
                    var path = Paths.getMusic(music);
                    var object = FlxG.sound.load(path, 1, true);
                    object.autoDestroy = false;
                    object.persist = true;
                    Cache.musicMap.set(path, object);
                    onFileCached();
                }
                catch (e:Dynamic) 
                {
                    trace("Error caching music: " + music + " at path: " + Paths.getMusic(music));
                    cacheLabel.text = "Error caching music: " + music;
                }
            }
        }
    }

    private function onFileCached():Void
    {
        var endTime = Date.now();
        var elapsed = (endTime.getTime() - startTime.getTime()) / 1000; // in seconds

        cachedFiles++;
        totalTime += elapsed;
        startTime = Date.now();
        updateProgressBar();
        updateAvgTimeLabel();

        if (cachedFiles >= totalFiles)
        {
            onCachingComplete();
        }
    }

    function doNothing():Void {}
}
