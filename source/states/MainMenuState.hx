package states;

import states.options.OptionsState;
import helpers.MusicManager;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import haxe.Timer;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import helpers.Paths;
import helpers.SaveManager;
import helpers.SoundManager;
import helpers.StaticBackgroundTitleState;
import helpers.funkin.Alphabet;

class MainMenuState extends StaticBackgroundTitleState
{
    var camFollow:FlxObject;

    var options = [
        'play',
        'options',
        'github'
        #if debug ,
        'Tools'
        #end
    ];

    var isOptionDisabled = [
        true,
        false,
        false
        #if debug ,
        false
        #end
    ];

    static var menuItems:FlxTypedGroup<Alphabet>;

    static var curSelected:Int = 0;

    static var selected:Bool = false;

    var targetCameraPos:FlxObject;
    var cameraLerpSpeed:Float = 0.3;

    // Scaling factors
    var selectedScale:Float = 1.2;
    var unselectedScale:Float = 1.0;
    var tweenDuration:Float = 0.3; // Duration of scaling tween

    override public function create():Void {
        bg = new FlxSprite(-80).loadGraphic(Paths.getImage('menuDesat'));
    
        super.create();
    
        initCamera();
        menuItems = new FlxTypedGroup<Alphabet>();
        add(menuItems);
    
        for (i in 0...options.length)
        {
            var offset:Float = 108 - (Math.max(options.length, 4) - 4) * 80;
            var isDisabled:Bool = (i >= isOptionDisabled.length) || isOptionDisabled[i];
            var menuItem:Alphabet = new Alphabet(0 + (i * 5), (i * 120) + offset, options[i], !isDisabled, false, 3, 10); // Adjust vertical spacing
            menuItem.antialiasing = true;
            menuItems.add(menuItem);
            var scr:Float = (options.length - 4) * 0.335;
            if (options.length < 4)
                scr = 0;
            menuItem.scrollFactor.set(0, scr);
            menuItem.updateHitbox();
            menuItem.screenCenter(X); // Center horizontally based on the text width
    
            // Apply initial color based on disabled status
            if (isDisabled) {
                menuItem.color = 0xaaaaaa; // Greyed out color for disabled options
            } else {
                menuItem.color = 0xffffff; // Default color for enabled options
            }
        }
    
        // Set the initial selection
        updateSelection();
        SaveManager.saveAchievement("menu_nocrash", true);
    }
    
    
    

    private function initCamera():Void {
        if (camFollow == null) {
            camFollow = new FlxObject(0, 0, 1, 1);
            add(camFollow);
        }

        if (targetCameraPos == null) {
            targetCameraPos = new FlxObject();
        }

        FlxG.camera.follow(camFollow, null, 9);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (!selected) {
            handleInput();
            updateCamera();
        }
    }

    private function updateCamera():Void {
        var selectedItem:Alphabet = menuItems.members[curSelected];
        targetCameraPos.x = selectedItem.getGraphicMidpoint().x;
        targetCameraPos.y = selectedItem.getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0);

        camFollow.x += (targetCameraPos.x - camFollow.x) * cameraLerpSpeed;
        camFollow.y += (targetCameraPos.y - camFollow.y) * cameraLerpSpeed;
    }

    private function handleInput():Void {
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
        else if (FlxG.keys.justReleased.ESCAPE) {
            // Handle escape key if necessary
        }
    }

    private function updateSelection():Void {
        SoundManager.PlaySound(Paths.getSound("scrollMenu"));
        for (i in 0...menuItems.length) {
            var item:Alphabet = menuItems.members[i];
            if (i == curSelected) {
                item.color = isOptionDisabled[i] ? 0xaaaaaa : 0xffffff; // Highlight disabled items in grey
            } else {
                item.color = isOptionDisabled[i] ? 0xaaaaaa : 0xaaaaaa; // Grey out all non-selected items
            }
            item.updateHitbox();
            item.screenCenter(X);
        }
    }

    var blinkDuration:Float = 0.25;
    var blinkCount:Int = 5;
    
    private function selectOption():Void {
        if (isOptionDisabled[curSelected]) {
            // Option is disabled
            SoundManager.PlaySound(Paths.getSound("denied"));
            return;
        }
        selected = true;
        SoundManager.PlaySound(Paths.getSound("confirmMenu"));
        var selectedItem:Alphabet = menuItems.members[curSelected];
        
        blink(selectedItem, blinkCount);
    }

    private function blink(item:Alphabet, count:Int):Void {
        if (count <= 0) {
            startFadeOut();
            return;
        }

        var duration:Float = blinkDuration / 2;

        FlxTween.tween(item, { alpha: 0 }, duration, {
            onComplete: function(tween:FlxTween):Void {
                FlxTween.tween(item, { alpha: 1 }, duration, {
                    onComplete: function(tween:FlxTween):Void {
                        blink(item, count - 1);
                    }
                });
            }
        });
    }

    private function startFadeOut():Void {
        var fadeDuration:Float = 0.5; // Duration of fade-out effect in seconds

        // Fade out the selected item
        FlxTween.tween(menuItems.members[curSelected], { alpha: 0 }, fadeDuration);

        // Fade out all menu items
        for (item in menuItems.members) {
            if (item != menuItems.members[curSelected]) {
                FlxTween.tween(item, { alpha: 0 }, fadeDuration);
            }
        }

        // Transition to the next state after fading out
        FlxTimer.wait(0.6, transitionToState);
    }

    public static function startFadeIn():Void {
        var fadeDuration:Float = 0.6; // Duration of fade-in effect in seconds

        // Fade in the selected item
        FlxTween.tween(menuItems.members[curSelected], { alpha: 1 }, fadeDuration);

        // Fade in all menu items
        for (item in menuItems.members) {
            if (item != menuItems.members[curSelected]) {
                FlxTween.tween(item, { alpha: 1 }, fadeDuration);
            }
        }
        selected = false;
    }

    private function transitionToState():Void {
        switch (curSelected) {
            case 0: // play
                // FlxG.switchState(new PlayMenu());
            case 1: // options
                FlxG.state.openSubState(new OptionsState());
            case 2: // github
                FlxG.state.openSubState(new GithubState());
            #if debug
            case 3: // tools
                // FlxG.switchState(new ToolsState());
            #end
        }
    }
}
