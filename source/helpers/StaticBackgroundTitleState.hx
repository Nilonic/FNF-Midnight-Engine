package helpers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Exception;
import states.*;

class StaticBackgroundTitleState extends FlxState
{
    var versionText:FlxText;
    var versionBox:FlxSprite; // Box for the background
    var bg:FlxSprite;
    var _fnf_version(default, null):String = "0.4.1";
    var _midnight_engine_version(default, null):String = "0.0.0.0";
    var _build_date(default, null):String = "N/A";
    override function create() {
        super.create();
        bg.antialiasing = true;
        bg.scrollFactor.set(0, 0);
        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);
                // Initialize version text
        versionText = new FlxText(0, 0);
        versionText.text = "FNF (" + _fnf_version + ") | FNF Midnight Engine (" + _midnight_engine_version + ") | Build Date: " + _build_date;
        versionText.y = FlxG.height - versionText.height;

        // Create a box with a slightly transparent black background
        var boxWidth:Int = Std.int(versionText.width + 20); // Convert to integer
        var boxHeight:Int = Std.int(versionText.height + 10); // Convert to integer
        versionBox = new FlxSprite();
        versionBox.makeGraphic(boxWidth, boxHeight, 0x80000000); // 50% transparent black
        versionBox.x = versionText.x - 10; // Offset to center box around text
        versionBox.y = versionText.y - 5;

        // Final setup
        versionText.scrollFactor.set(0,0);
        versionBox.scrollFactor.set(0,0);
        // Add the box and text to the state
        add(versionBox);
        add(versionText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (bg.frames.numFrames > 1){ // if there's more than 1 frame
            throw "StaticBackgroundTitleState cannot be non-static\nuse AnimatedBackgroundTitleState instead";
        }
    }
}