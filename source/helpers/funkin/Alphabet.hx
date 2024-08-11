// Alphabet.hx
package helpers.funkin;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import helpers.funkin.MathUtil;
import flixel.FlxG;

/**
 * Loosley based on FlxTypeText lolol
 */
class Alphabet extends FlxSpriteGroup
{
    public var delay:Float = 0.05;
    public var paused:Bool = false;
    public var targetY:Float = 0;
    public var isMenuItem:Bool = false;
    public var text:String = "";
    var _finalText:String = "";
    var _curText:String = "";
    public var widthOfWords:Float = FlxG.width;
    var yMulti:Float = 1;
    var lastSprite:AlphaCharacter;
    var xPosResetted:Bool = false;
    var lastWasSpace:Bool = false;
    var splitWords:Array<String> = [];
    var isBold:Bool = false;
    
    // Spacing variables
    var HSpacing:Float;
    var VSpacing:Float;

    public function new(x:Float = 0.0, y:Float = 0.0, text:String = "", bold:Bool = false, typed:Bool = false, HoriSpace:Float=3, VertSpace:Float=10)
    {
        super(x, y);
        HSpacing = HoriSpace;
        VSpacing = VertSpace;
        _finalText = text;
        this.text = text;
        isBold = bold;

        if (text != "")
        {
            if (typed)
            {
                startTypedText();
            }
            else
            {
                addText();
            }
        }
    }

    public function addText():Void {
        doSplitWords();

        var xPos:Float = 0;
        var yPos:Float = 0; // Added yPos to handle vertical positioning
        lastSprite = null;
        xPosResetted = false;
        lastWasSpace = false;

        for (character in splitWords) {
            if (character == " " || character == "-") {
                lastWasSpace = true;
                continue; // Skip spacing logic for spaces and dashes
            }

            if (AlphaCharacter.alphabet.indexOf(character.toLowerCase()) != -1) {
                if (lastSprite != null) {
                    xPos = lastSprite.x + lastSprite.width + HSpacing; // Apply horizontal spacing
                }

                if (lastWasSpace) {
                    xPos += HSpacing; // Adjust space between words
                    lastWasSpace = false;
                }

                var letter:AlphaCharacter = new AlphaCharacter(xPos, yPos);

                if (isBold) letter.createBold(character);
                else letter.createLetter(character);

                add(letter);
                lastSprite = letter;
            }
        }

        // Adjust position for left alignment
        var totalWidth:Float = lastSprite.x + lastSprite.width;
        for (i in 0...members.length) {
            var item:AlphaCharacter = cast members[i];
            item.x -= totalWidth / 2; // Center align the text
        }
    }

    function doSplitWords():Void
    {
        splitWords = _finalText.split("");
    }

    public function startTypedText():Void
    {
        _finalText = text;
        doSplitWords();

        var loopNum:Int = 0;
        var xPos:Float = 0;
        var yPos:Float = 0; // Added yPos to handle vertical positioning
        var curRow:Int = 0;

        new FlxTimer().start(0.05, function(tmr:FlxTimer) {
            if (_finalText.charCodeAt(loopNum) == "\n".code)
            {
                yPos += VSpacing; // Apply vertical spacing between rows
                xPos = 0;
                curRow += 1;
            }

            if (splitWords[loopNum] == " ")
            {
                lastWasSpace = true;
                loopNum += 1;
                return;
            }

            var isNumber:Bool = AlphaCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
            var isSymbol:Bool = AlphaCharacter.symbols.indexOf(splitWords[loopNum]) != -1;

            if (AlphaCharacter.alphabet.indexOf(splitWords[loopNum].toLowerCase()) != -1
                || isNumber
                || isSymbol)
            {
                if (lastSprite != null && !xPosResetted)
                {
                    lastSprite.updateHitbox();
                    xPos += lastSprite.width + HSpacing; // Apply horizontal spacing
                }
                else
                {
                    xPosResetted = false;
                }

                if (lastWasSpace)
                {
                    xPos += HSpacing;
                    lastWasSpace = false;
                }

                var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * yMulti + yPos); // Use yPos for vertical positioning
                letter.row = curRow;
                if (isBold)
                {
                    letter.createBold(splitWords[loopNum]);
                }
                else
                {
                    if (isNumber)
                    {
                        letter.createNumber(splitWords[loopNum]);
                    }
                    else if (isSymbol)
                    {
                        letter.createSymbol(splitWords[loopNum]);
                    }
                    else
                    {
                        letter.createLetter(splitWords[loopNum]);
                    }

                    letter.x += 90;
                }

                add(letter);
                lastSprite = letter;
            }

            loopNum += 1;
            tmr.time = FlxG.random.float(0.04, 0.09);
        }, splitWords.length);
    }

    override function update(elapsed:Float)
    {
        if (isMenuItem)
        {
            var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
            y = MathUtil.coolLerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
            x = MathUtil.coolLerp(x, (targetY * 20) + 90, 0.16);
        }

        super.update(elapsed);
    }
}

class AlphaCharacter extends FlxSprite
{
    public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";
    public static var numbers:String = "1234567890";
    public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";

    public var row:Int = 0;

    public function new(x:Float, y:Float)
    {
        #if debug trace("creating new AlphaCharacter instance"); #end
        super(x, y);
        var tex = Paths.sparrowAtlas('alphabet', false);
        frames = tex;
    }

    public function createBold(letter:String)
    {
        animation.addByPrefix(letter, letter.toUpperCase() + " bold", 24);
        animation.play(letter);
        updateHitbox();
    }

    public function createLetter(letter:String):Void
    {
        var letterCase:String = "lowercase";
        if (letter.toLowerCase() != letter)
        {
            letterCase = 'capital';
        }

        animation.addByPrefix(letter, letter + " " + letterCase, 24);
        animation.play(letter);
        updateHitbox();

        y = (110 - height);
        y += row * 60;
    }

    public function createNumber(letter:String):Void
    {
        animation.addByPrefix(letter, letter, 24);
        animation.play(letter);

        updateHitbox();
    }

    public function createSymbol(letter:String)
    {
        switch (letter)
        {
            case '.':
                animation.addByPrefix(letter, 'period', 24);
                animation.play(letter);
                y += 50;
            case "'":
                animation.addByPrefix(letter, 'apostraphie', 24);
                animation.play(letter);
                y -= 0;
            case "?":
                animation.addByPrefix(letter, 'question mark', 24);
                animation.play(letter);
            case "!":
                animation.addByPrefix(letter, 'exclamation point', 24);
                animation.play(letter);
        }

        updateHitbox();
    }
}
