package states;

import helpers.funkin.Alphabet;
import helpers.EZSubState;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxObject;
import helpers.SoundManager;
import helpers.SaveManager;
import helpers.Paths;

class GithubState extends EZSubState {
    var options:Array<String> = [
        'Midnight engine repo',
        'Psych engine repo',
        'Official repo'
    ];

    var urls:Array<String> = [
        'https://github.com/Nilonic/FNF-Midnight-Engine',
        'https://github.com/ShadowMario/FNF-PsychEngine',
        'https://github.com/FunkinCrew/Funkin/'
    ];

    var menuItems:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;

    var targetCameraPos:FlxObject;
    var cameraLerpSpeed:Float = 0.3;

    var camFollow:FlxObject;
    
    override function create():Void {
        super.create();
        //MusicManager.getInstance().playBGM("BGMusicTemp");
        camFollow = new FlxObject(0, 0, 1, 1);
        add(camFollow);
        
        menuItems = new FlxTypedGroup<Alphabet>();
        add(menuItems);
        
        for (i in 0...options.length) {
            var offset:Float = 108 - (Math.max(options.length, 4) - 4) * 80;
            var menuItem:Alphabet = new Alphabet(-5, (i * 140) + offset, options[i], true, false, 15, 10);
            menuItem.color = 0xffffff;
            menuItem.antialiasing = true;
            menuItems.add(menuItem);
            
            var scr:Float = (options.length > 4 ? (options.length - 4) * 0.335 : 0);
            menuItem.scrollFactor.set(0, scr);
            
            menuItem.updateHitbox();
            menuItem.screenCenter(X);
        }
        
        updateSelection();
        
        targetCameraPos = new FlxObject();
        FlxG.camera.follow(camFollow, null, 9);
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) {
            curSelected = (curSelected - 1 + options.length) % options.length;
            updateSelection();
        }
        else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) {
            curSelected = (curSelected + 1) % options.length;
            updateSelection();
        }
        else if (FlxG.keys.justPressed.ENTER) {
            selectOption();
        }

        // Smooth camera movement
        var selectedItem:Alphabet = menuItems.members[curSelected];
        targetCameraPos.x = selectedItem.getGraphicMidpoint().x;
        targetCameraPos.y = selectedItem.getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0);

        camFollow.x += (targetCameraPos.x - camFollow.x) * cameraLerpSpeed;
        camFollow.y += (targetCameraPos.y - camFollow.y) * cameraLerpSpeed;
    }

    private function updateSelection():Void {
        SoundManager.PlaySound(Paths.getSound("scrollMenu"));
        for (i in 0...menuItems.length) {
            var item:Alphabet = menuItems.members[i];
            if (i == curSelected) {
                item.color = 0xffff00; // Highlight selected item
            } else {
                item.color = 0x777700; // Grey out non-selected items
            }
        }
        var selectedItem:Alphabet = menuItems.members[curSelected];
        selectedItem.updateHitbox();
        selectedItem.screenCenter(X);
    }

    private function selectOption():Void {
        var selectedURL:String = urls[curSelected];
        openURL(selectedURL);
    }

    public static function openURL(targetUrl:String):Void
        {
          #if linux
          Sys.command('/usr/bin/xdg-open $targetUrl &');
          #else
          // This should work on Windows and HTML5.
          FlxG.openURL(targetUrl);
          #end
        }
}
