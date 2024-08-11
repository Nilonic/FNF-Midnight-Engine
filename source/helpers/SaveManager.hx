package helpers;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;

class SaveManager {
    private static var save_name = "Funkin";
    private static var file_path:String;

    private static var scores:Array<Dynamic> = [];
    private static var config:Array<Dynamic> = [];
    private static var achievements:Array<Dynamic> = [];

    /**
        Init the save by setting up the file path and loading existing data if available.
    **/
    public static function init():Void {
        file_path = save_name + ".json";
        load();
    }

    /**
        Save the score for a specific difficulty level and track
    **/
    public static function saveScore(difficulty:Int, score:Int, track:String):Void {
        var scoreData:Dynamic = { difficulty: difficulty, score: score, track: track };

        // Check if the score entry for this track already exists
        var updated:Bool = false;
        for (i in 0...scores.length) {
            if (scores[i].track == track && scores[i].difficulty == difficulty) {
                scores[i] = scoreData;
                updated = true;
                break;
            }
        }

        // If no existing entry, add a new one
        if (!updated) {
            scores.push(scoreData);
        }

        save();
    }

    /**
        Save an achievement status
    **/
    public static function saveAchievement(name:String, gotIt:Bool):Void {
        var achievementData:Dynamic = { name: name, gotIt: gotIt };

        // Check if the achievement entry already exists
        var updated:Bool = false;
        for (i in 0...achievements.length) {
            if (achievements[i].name == name) {
                achievements[i] = achievementData;
                updated = true;
                break;
            }
        }

        // If no existing entry, add a new one
        if (!updated) {
            achievements.push(achievementData);
        }

        save();
    }

    /**
        Save a config value
    **/
    public static function saveConfig(name: String, value:Dynamic):Void {
        var configData:Dynamic = { name: name, value: value };

        // Check if the config entry already exists
        var updated:Bool = false;
        for (i in 0...config.length) {
            if (config[i].name == name) {
                config[i] = configData;
                updated = true;
                break;
            }
        }

        // If no existing entry, add a new one
        if (!updated) {
            config.push(configData);
        }

        save();
    }

    /**
        Load a specific score based on difficulty and track
    **/
    public static function loadScore(difficulty:Int, track:String):Int {
        for (i in 0...scores.length) {
            if (scores[i].track == track && scores[i].difficulty == difficulty) {
                return scores[i].score;
            }
        }
        return 0; // Default value when score is not found
    }

    /**
        Load a specific achievement status
    **/
    public static function loadAchievement(name:String):Bool {
        for (i in 0...achievements.length) {
            if (achievements[i].name == name) {
                return achievements[i].gotIt;
            }
        }
        return false; // Default value when achievement is not found
    }

    /**
        Load a specific config value
    **/
    public static function loadConfig(name:String):Dynamic {
        for (i in 0...config.length) {
            if (config[i].name == name) {
                return config[i].value;
            }
        }
        return null; // Default value when config is not found
    }

    /**
        Load data from JSON file
    **/
    private static function load():Void {
        try {
            var file:FileInput = File.read(file_path);
            var jsonString:String = file.readAll().toString();
            file.close();
            var data:Dynamic = Json.parse(jsonString);

            scores = data.scores != null ? data.scores : [];
            config = data.config != null ? data.config : [];
            achievements = data.achievements != null ? data.achievements : [];
        } catch (e:Dynamic) {
            // File might not exist or contain invalid JSON
            scores = [];
            config = [];
            achievements = [];
        }
    }

    /**
        Save data to JSON file
    **/
    private static function save():Void {
        var data:Dynamic = {
            scores: scores,
            config: config,
            achievements: achievements
        };

        try {
            var file:FileOutput = File.write(file_path, false);
            file.writeString(Json.stringify(data));
            file.close();
        } catch (e:Dynamic) {
            #if debug trace("Failed to write to file: " + e); #end
        }
    }

    public static function DeleteSaveFile() {
        throw new haxe.exceptions.NotImplementedException();
    }
}
