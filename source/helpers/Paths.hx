package helpers;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.display.BitmapData;

class Paths{
    
	public static function getImage(name:String):String
	{
        return "assets/images/" + name + ".png";
    }
	public static function getXML(name:String):String
	{
		return "assets/images/" + name + ".xml";
	}

	public static function getMainMenuImage(name:String):String
	{
        return "assets/images/mainmenu/" + name + ".png";
    }

	public static function getMainMenuXML(name:String):String
	{
        return "assets/images/mainmenu/" + name + ".xml";
    }

	public static function sparrowAtlas(name:String, isMainMenu:Bool):FlxAtlasFrames
	{
		#if debug trace("Loading atlas: " + name, "| Is Main Menu: " + isMainMenu); #end
		var image:BitmapData;
		if (isMainMenu)
		{
			image = BitmapData.fromFile(getMainMenuImage(name));
		}
		else
		{
			image = BitmapData.fromFile(getImage(name));
        }
		return FlxAtlasFrames.fromSparrow(image, isMainMenu ? getMainMenuXML(name) : getXML(name));
	}
	public static function getMusic(name:String, isOGG:Bool = true)
	{
        if (isOGG)
		    return "assets/music/" + name + ".ogg";
        return "assets/music/" + name + ".mp3";
	}
	public static function getSound(name:String, isOGG:Bool = true):String
	{
		if (isOGG)
			return "assets/sounds/" + name + ".ogg";
		return "assets/sounds/" + name + ".mp3";
	}
    
}