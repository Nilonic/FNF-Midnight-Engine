package helpers;

import flixel.sound.FlxSound;
import flixel.FlxG;

class SoundManager{

    /**
        Expects an .ogg file. Use ` 
        Paths.getSound("name here", true);
        `
        as the input.
    **/
    public static function PlaySound(soundName:String):Void
    {
        #if debug trace("Playing sound: " + soundName); #end
        var sound = Cache.soundsMap.get(soundName);
        if (sound != null) {
            #if debug trace("Sound found in cache!"); #end
            sound.play(true);
        } else {
            #if debug trace("Sound not found. Please ensure the file is added to the cache list. Refer to: source/states/CacheState.hx:21"); #end
            PlaySoundUncached(soundName);
        }
    }

    public static function PlayBGM(BGMName:String)
    {
        #if debug trace("Playing background music: " + BGMName); #end
        var sound = Cache.musicMap.get(BGMName);
        if (sound != null) {
            #if debug trace("Music found in cache!"); #end
            sound.looped = true;
            sound.play(true);
        } else {
            #if debug trace("Background music not tracked. Please add it to the cache. Refer to: source/states/CacheState.hx:22"); #end
            PlaySoundUncached(BGMName, true);
        }
    }

    public static function StopBGM(BGMName:String)
    {
        #if debug trace("Stopping background music: " + BGMName); #end
        var sound = Cache.musicMap.get(BGMName);
        if (sound != null) {
            #if debug trace("Music found in cache!"); #end
            sound.looped = true;
            sound.stop();
        } else {
            #if debug trace("Background music not tracked. stopping all sound and music. Refer to: source/states/CacheState.hx:22"); #end
            FlxG.sound.pause();
        }
    }

    /**
        For when the sound isn't cached.

        The argument is the same as `PlaySound`.

        For best results, add the file to the cache lists found here:
            `source/states/CacheState.hx:21`
            `source/states/CacheState.hx:22`
    **/
    @:deprecated("Use PlaySound and ensure your music is cached in CacheState.hx")
    public static function PlaySoundUncached(soundName:String, volume:Float = 1.0, loop:Bool = false):Void
    {
        #if debug trace("Playing uncached sound: " + soundName); #end
        FlxG.sound.play(soundName, volume, loop);
    }
}
