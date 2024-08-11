// MusicManager.hx
package helpers;

import flixel.FlxG;
import flixel.sound.FlxSound;
import helpers.Paths;

class MusicManager {
    private static var _instance:MusicManager;
    private var _bgm:FlxSound;

    public static function getInstance():MusicManager {
        if (_instance == null) {
            _instance = new MusicManager();
        }
        return _instance;
    }

    public function new() {
        if (_instance != null) {
            throw "MusicManager is a singleton and should not be instantiated directly.";
        }
        _instance = this;
        // Initialize other components if necessary
    }

    public function playBGM(bgmName:String):Void {
        // Check if the music is already playing
        if (_bgm == null || !_bgm.playing) {
            _bgm = FlxG.sound.play(Paths.getMusic(bgmName), 1.0, true);
            _bgm.persist = true; // Ensure the music persists across state changes
        }
    }

    public function stopBGM():Void {
        if (_bgm != null) {
            _bgm.stop();
        }
    }

    public function setVolume(volume:Float):Void {
        if (_bgm != null) {
            _bgm.volume = volume;
        }
    }

    public function isMusicPlaying():Bool {
        return _bgm != null && _bgm.playing;
    }
}
