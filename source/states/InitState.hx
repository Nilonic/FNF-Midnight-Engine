package states;

import helpers.MusicManager;
import lime.utils.AssetCache;
import flixel.FlxState;
import flixel.FlxG;
import helpers.SaveManager;

class InitState extends FlxState{
    override public function create()
        {
            super.create();
            MusicManager.getInstance();
            #if debug
            FlxG.sound.muted = true;
            #end
            FlxG.updateFramerate = 120;
            var config = SaveManager.loadConfig("initialBoot");
            trace(config);
            if (config == null){
                FlxG.switchState(new SetupState());
            }
            else if (config != null){ 
                var cfgCacheSounds = SaveManager.loadConfig("CacheSounds");
                var cfgCacheMusic = SaveManager.loadConfig("CacheMusic");
                if (Main.game.cached || (cfgCacheMusic == false && cfgCacheSounds == false))
                    FlxG.switchState(new TitleState());
                else{
                    FlxG.switchState(new CacheState());
                }
            }
        }
}