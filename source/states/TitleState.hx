package states;

import helpers.SoundManager;
import helpers.MusicManager;
import helpers.Paths;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class TitleState extends FlxState
{
    var _introText:Map<Int, Array<String>>;
    var introGroup:FlxGroup;
    var currentTextIndex:Int = 0;
    var introTextTimer:FlxTimer;
    var textDisplayTime:Float = 2; // Time in seconds to display each text set

	var isInText:Bool = true;

    var titleText:FlxSprite;
    var logoBl:FlxSprite;
    var gfDance:FlxSprite;

    override public function create()
    {
        MusicManager.getInstance().playBGM("BGMusicTemp");
        super.create();

		createRequired();

        var bg:FlxSprite = new FlxSprite(-1).makeGraphic(FlxG.width + 2, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        add(bg);

        // Initialize _introText as a Map
        _introText = new Map<Int, Array<String>>();
        _introText.set(1, ["Friday Night Funkin By:", "The Funkin Crew"]);
        _introText.set(2, ["Friday Night Funkin is in association with:", "Newgrounds"]);
        _introText.set(3, ["Midnight Engine by:", "Nilon"]);
        _introText.set(4, ["this is a mistake", "i don't regret"]);
        _introText.set(5, ["Friday", "Night", "Funkin"]);

        introGroup = new FlxGroup();
        add(introGroup);

        // Start the intro sequence
        startIntro();
    }

	function createRequired() {
		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
        gfDance.frames = Paths.sparrowAtlas('gfDanceTitle', true);
        gfDance.animation.addByIndices('dance', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, true);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
        titleText.frames = Paths.sparrowAtlas('titleEnter', true);
        titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
        titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);

		logoBl = new FlxSprite(-150, -100);
        logoBl.frames = Paths.sparrowAtlas('logoBumpin', true);
        logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
	}

    private function startIntro():Void
    {
        // Initialize and start a timer to handle text display
        introTextTimer = new FlxTimer();
        introTextTimer.start(textDisplayTime, showNextTextSet, Lambda.count(_introText));
    }

    private function showNextTextSet(timer:FlxTimer):Void
    {
        if (_introText.exists(currentTextIndex + 1))
        {
            // Clear existing text
            introGroup.clear();

            // Display the next set of intro text
            var introLines:Array<String> = _introText.get(currentTextIndex + 1);
            var yPos:Float = FlxG.height / 2 - (introLines.length * 30) / 2;
            for (line in introLines)
            {
                var introText:FlxText = new FlxText(0, yPos, FlxG.width, line);
                introText.setFormat(null, 24, FlxColor.WHITE, "center");
                introGroup.add(introText);
                yPos += 30; // Adjust spacing as needed
            }

            currentTextIndex++;
            introTextTimer.start(textDisplayTime, showNextTextSet);
        }
        else
        {
            // All text has been shown, flash the screen white
            FlxG.camera.flash(FlxColor.WHITE, 3);
			showMainElements();
        }
    }

    private function showMainElements():Void
    {
		introGroup.kill();
		isInText = false;
        titleText.animation.play('idle');
        titleText.updateHitbox();
        logoBl.animation.play('bump');
        logoBl.updateHitbox();
        gfDance.animation.play("dance");
        add(logoBl);
        add(gfDance);
        add(titleText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER){
			if (isInText){
				FlxG.camera.flash(FlxColor.WHITE, 3);
				showMainElements();
			}
			else{
				titleText.animation.play("press");
				SoundManager.PlaySound(Paths.getSound("confirmMenu"));
				FlxTimer.wait(1.25, transitionToState);
			}
		}
    }

	function transitionToState(){
        FlxG.camera.fade(0x000000, 1, false, (function () {
            FlxG.switchState(new MainMenuState());
        }));
	}
}
