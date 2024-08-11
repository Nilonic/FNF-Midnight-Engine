package helpers;

import states.MainMenuState;
import flixel.FlxG;
import flixel.FlxSubState;

class EZSubState extends FlxSubState{
    var isMenu:Bool = true;

    override public function create(){
        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ESCAPE) {
            if(isMenu)
                MainMenuState.startFadeIn();
            FlxG.state.closeSubState();
        }
    }
}