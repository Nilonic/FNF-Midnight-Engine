package states.options;

import flixel.FlxSprite;
import flixel.FlxSubState;
import helpers.funkin.Alphabet;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxG;
import helpers.*;

class OptionsState extends FlxSubState{
    var menuItems:FlxTypedGroup<Alphabet>;
    var menus:Array<String> = ["Game", "Engine"];
    var isInMenu:Bool = true;
    var gameMenu:Array<String> = [];
    var isInGameMenu:Bool = false;
    var engineMenu:Array<String> = [];
    var isInEngineMenu:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;
    var targetCameraPos:FlxObject;
    var cameraLerpSpeed:Float = 0.3;
    override function create(){
        //var bg:FlxSprite = new flixel.FlxSprite(-80).loadGraphic(helpers.Paths.getImage('menuDesat'));
        //add(bg);
        super.create();
        menuItems = new FlxTypedGroup<Alphabet>();
        initCamera();
        add(menuItems);
        gameMenu.push("back"); engineMenu.push("back");
        for (i in 0...menus.length){
            var offset:Float = 108 - (Math.max(menus.length, 4) - 4) * 80;
            var x:Alphabet = new Alphabet(0 + (i * 5), (i * 120) + offset, menus[i], true);
            x.antialiasing = true;
            menuItems.add(x);
            var scr:Float = (menus.length - 4) * 0.335;
            if (menus.length < 4)
                scr = 0;
            x.scrollFactor.set(0, scr);
            x.updateHitbox();
            x.screenCenter(X); // Center horizontally based on the text width
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        handleInput();
        updateCamera();
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
            curSelected = (curSelected - 1 + menus.length) % menus.length;
            updateSelection();
        }
        else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) {
            curSelected = (curSelected + 1) % menus.length;
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
                item.color =  0xffffff;
            } else {
                item.color =  0xaaaaaa;
            }
            item.updateHitbox();
            item.screenCenter(X);
        }
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

    function selectOption() {
        switch(menus[curSelected]){
            case "Game":
                
            case "Engine":

            default:
                // do nothing
        }
    }
}