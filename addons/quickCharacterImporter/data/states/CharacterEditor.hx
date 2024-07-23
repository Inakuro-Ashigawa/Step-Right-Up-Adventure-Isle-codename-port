import funkin.editors.ui.UITopMenu;
import lime.graphics.Image;
import openfl.display.BitmapData;
import StringTools;
import Xml;
function postCreate()
{
	//add new menu stuffs
	topMenu.push({
		label: "Quick Import",
		childs: [
			{
				label: "Auto Fill Anims",
				onSelect: function()
				{
					attemptAnimFill();
				},
			},
			{
				label: "Set Offsets To Center",
				onSelect: function()
				{
					attemptAutoOffset();
				},
			},
			{
				label: "Auto Icon Color",
				onSelect: function()
				{
					attemptIconColor();
				},
			},
		]
	});

	remove(topMenuSpr);
	topMenuSpr = new UITopMenu(topMenu);
	topMenuSpr.cameras = uiGroup.cameras = [uiCamera];
	insert(members.indexOf(uiGroup), topMenuSpr);
}

function attemptAnimFill()
{
	var xmlPath = Paths.image('characters/'+character.sprite, null, false, "xml");
	if (!Assets.exists(xmlPath))
		return;
	var plainXML = Assets.getText(xmlPath);
	var spriteSheetXml = Xml.parse(plainXML);

	var numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];


	var animNames = [];
	var animWidths = [];
	var animHeights = [];
	for (spriteSheetData in spriteSheetXml.elementsNamed("TextureAtlas"))
	{
		for (anim in spriteSheetData.elementsNamed("SubTexture"))
		{
			var name = anim.get("name");
			while(name.length > 0 && numbers.contains(name.charAt(name.length - 1)))
				name = name.substring(0, name.length - 1); //remove numbers

			if (!animNames.contains(name))
			{
				animNames.push(name); //add to list if not already in there
				animWidths.push(Std.parseFloat(anim.get("width")));
				animHeights.push(Std.parseFloat(anim.get("height")));
			}
				
		}
	}
	//trace(animWidths);

	var animsToAdd = [];

	for (name in animNames)
	{
		var n = name.toLowerCase();
		var animName = "";

		//sing anims
		if (StringTools.contains(n,"left"))
			animName = "singLEFT";
		else if (StringTools.contains(n,"right"))
			animName = "singRIGHT";
		else if (StringTools.contains(n,"up"))
			animName = "singUP";
		else if (StringTools.contains(n,"down"))
			animName = "singDOWN";
		if (StringTools.contains(n,"miss")) //check for miss
			animName += "miss";

		//idle anim
		if (animName == "" && (StringTools.contains(n,"idle") || StringTools.contains(n,"dance")))
			animName = "idle";

		//check for alt
		if (StringTools.contains(n,"alt"))
			animName += "-alt";

		if (animName == "")
			animName = name; //cant find anything so call it the same as prefix


		//check if anim already exists
		var animOrder = character.getAnimOrder();
		var animAlreadyExists = character.animation.exists(animName);

		if (!animAlreadyExists)
		{
			//now actually add the anim
			animData = {
				name: animName,
				anim: name+"0",
				fps: 24,
				loop: false,
				animType: 0,
				x: 0,
				y: 0,
				indices: []
			};
			createAnim(animData);
			//trace(name);
		}
	}
}

function attemptAutoOffset()
{
	character.playAnim("idle");
	character.updateHitbox();

	for (name => data in character.animDatas)
	{
		character.playAnim(name);

		var width = character.frameWidth * character.scale.x;
		var height = character.frameHeight * character.scale.y;

		var x = (width*0.5) - (character.width*0.5);
		var y = (height) - (character.height); //put onto floor instead of centering
	
		data.x = x;
		data.y = y;

		character.addOffset(name, x, y);
	}

	for (charButton in characterAnimsWindow.buttons.members)
		charButton.updateInfo(charButton.anim, character.getAnimOffset(charButton.anim), ghosts.animGhosts[charButton.anim].visible);
}

function attemptIconColor()
{
	var path = Paths.image('icons/'+character.getIcon());
	if (!Assets.exists(path))
		return;

	var image:Image = Paths.assetsTree.getAsset(path, "IMAGE"); //make sure its not loaded on the gpu?

	var pixelMap:Map<Int, Int> = [];
	var highestCol = 0;

	for (x in 0...image.width)
	{
		for (y in 0...image.height)
		{
			var col = image.getPixel32(x, y, 1); //1 = ARGB
			if (col != 0 && col != 0xFF000000) //ignore transparent and black
			{
				if (!pixelMap.exists(col))
					pixelMap.set(col, 0); //add to map

				pixelMap.set(col, pixelMap.get(col)+1); //increase count

				if (highestCol == 0)
					highestCol = col;
				else
				{
					if (col != highestCol)
					{
						//if current color now has higher count
						if (pixelMap.get(col) > pixelMap.get(highestCol))
							highestCol = col;
					}
				}
			}
		}
	}

	character.iconColor = highestCol;

	image = null;
}