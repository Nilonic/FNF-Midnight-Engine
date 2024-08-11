package states;

import helpers.StaticBackgroundTitleState;
import flixel.text.FlxText;
import helpers.SaveManager;
import flixel.FlxSprite;
import helpers.Paths;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class SetupState extends FlxState {
    // Options and their corresponding tooltips
    var options:Array<String> = [
        "Cache Sounds",
        "Cache Music",
        "FPS",
        "Haxe Splash",
        "Cursor"
    ];
    
    var tooltips:Array<String> = [
        "Toggle sound caching on or off. WARNING: MAY TAKE A LOT OF MEMORY",
        "Toggle music caching on or off. WARNING: MAY TAKE A LOT OF MEMORY",
        "Set the frames per second (FPS) for the game. Range: 30 - 120",
        "Show the Haxeflixel splash on boot"
    ];

    // State variables
    var selectedIndex:Int = 0;
    var optionStates:Array<Bool> = [true, true, true, true, true]; // Initial state for options
    var optionTexts:Array<FlxText> = [];
    var tooltipText:FlxText;
    var controlText:FlxText;
    var bg:FlxSprite;
    
    var fpsOptions:Array<Int> = [30, 60, 90, 120];
    var currentFPSIndex:Int = 1; // Default to 60 FPS

    override function create() {
        setupBackground();
        setupOptions();
        setupControlText();
        setupTooltipText();
        
        updateOptionDisplay();
        updateTooltip();
    }

    override function update(elapsed:Float) {
        handleInput();
        super.update(elapsed);
    }

    // Setup Methods
    private function setupBackground():Void {
        bg = new FlxSprite(-80).loadGraphic(Paths.getImage('menuDesat'));
        bg.antialiasing = true;
        bg.scrollFactor.set(0, 0);
        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        bg.color = 0xa020f0;
        add(bg);
    }

    private function setupOptions():Void {
        for (i in 0...options.length) {
            var text:FlxText = new FlxText(0, 40 + i * 30, FlxG.width, getOptionText(i));
            text.alignment = "center";
            text.size = 16;
            optionTexts.push(text);
            add(text);
        }
    }

    private function setupControlText():Void {
        controlText = new FlxText(0, FlxG.height - 40, FlxG.width, 
            "Use UP/DOWN to navigate, LEFT/RIGHT to toggle, ENTER to confirm. These can be changed in Options");
        controlText.alignment = "center";
        controlText.size = 12;
        controlText.color = 0xAAAAAA;
        add(controlText);
    }

    private function setupTooltipText():Void {
        tooltipText = new FlxText(0, FlxG.height - 80, FlxG.width, "No Tooltip Available");
        tooltipText.alignment = "center";
        tooltipText.size = 14;
        tooltipText.color = FlxColor.WHITE;
        tooltipText.scrollFactor.set(0, 0);
        tooltipText.alpha = 0.75;
        add(tooltipText);
    }

    // Input Handling
    private function handleInput():Void {
        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) {
            changeSelection(-1);
        }
        if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) {
            changeSelection(1);
        }
        if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) {
            adjustOption(-1);
        }
        if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) {
            adjustOption(1);
        }
        if (FlxG.keys.justPressed.ENTER) {
            saveSettings();
            FlxG.switchState(new CacheState());
        }
    }

    private function changeSelection(direction:Int):Void {
        selectedIndex = (selectedIndex + direction + options.length) % options.length;
        updateOptionDisplay();
        updateTooltip();
    }

    private function adjustOption(direction:Int):Void {
        if (selectedIndex == 2) { // FPS option
            currentFPSIndex = (currentFPSIndex + direction + fpsOptions.length) % fpsOptions.length;
            updateFPS();
            optionStates[selectedIndex] = true; // Ensure FPS option is enabled
            updateOptionText(selectedIndex);
        } else {
            toggleOption(selectedIndex);
        }
    }

    // Option Methods
    private function toggleOption(index:Int):Void {
        if (index != 2) { // Skip FPS option
            optionStates[index] = !optionStates[index];
            updateOptionText(index);
        }
    }

    private function getOptionText(index:Int):String {
        switch (index) {
            case 2: // FPS
                return options[index] + ": " + fpsOptions[currentFPSIndex];
            default:
                return options[index] + ": " + (optionStates[index] ? "< ON >" : "< OFF >");
        }
    }

    private function updateOptionText(index:Int):Void {
        optionTexts[index].text = getOptionText(index);
    }

    private function saveSettings():Void {
        SaveManager.saveConfig("initialBoot", true);
        SaveManager.saveConfig("CacheSounds", optionStates[0]);
        SaveManager.saveConfig("CacheMusic", optionStates[1]);
        SaveManager.saveConfig("FPS", fpsOptions[currentFPSIndex]);
        SaveManager.saveConfig("HaxeSplash", optionStates[3]); // Save the splash screen option
        SaveManager.saveConfig("Cursor", optionStates[4]);
    }

    private function updateOptionDisplay():Void {
        for (i in 0...optionTexts.length) {
            if (i == selectedIndex) {
                optionTexts[i].color = 0xFF0000; // Highlight selected option
                optionTexts[i].alpha = 1;
            } else {
                optionTexts[i].color = 0xFFFFFF; // Default color for unselected options
                optionTexts[i].alpha = 0.5;
            }
        }
    }

    private function updateTooltip():Void {
        var tooltip:String;
        if (selectedIndex >= 0 && selectedIndex < tooltips.length) {
            tooltip = tooltips[selectedIndex];
        } else {
            tooltip = "Tooltip Unavailable";
        }
        
        tooltipText.text = tooltip;
        tooltipText.x = 0;
        tooltipText.y = FlxG.height - 80;
        tooltipText.width = FlxG.width; // Adjust width to the screen width
        tooltipText.alpha = 0.75; // Slightly transparent
    }
    

    private function updateFPS():Void {
        var newFPS:Int = fpsOptions[currentFPSIndex];
        FlxG.drawFramerate = newFPS; // Update the FPS value
    }
}
