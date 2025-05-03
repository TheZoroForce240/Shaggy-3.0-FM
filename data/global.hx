import flixel.input.gamepad.FlxGamepadInputID;
import funkin.options.PlayerSettings;
import funkin.backend.system.Controls;
import funkin.backend.system.Controls.Control;
import funkin.backend.utils.WindowUtils;
import flixel.input.keyboard.FlxKey;
import funkin.backend.assets.ModsFolder;
import lime.app.Application;
import lime.graphics.Image;


var init = false;
function postStateSwitch()
{
	WindowUtils.winTitle = "Friday Night Funkin' VS Shaggy";

	if (init)
		return;

	init = true;
	PlayerSettings.solo.controls.removeGamepad(0);
	PlayerSettings.solo.controls.addGamepadLiteral(0, [
		Control.ACCEPT => [FlxGamepadInputID.A],
		Control.BACK => [FlxGamepadInputID.B],
		Control.UP => [FlxGamepadInputID.DPAD_UP, FlxGamepadInputID.LEFT_STICK_DIGITAL_UP],
		Control.DOWN => [FlxGamepadInputID.DPAD_DOWN, FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN],
		Control.LEFT => [FlxGamepadInputID.DPAD_LEFT, FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT],
		Control.RIGHT => [FlxGamepadInputID.DPAD_RIGHT, FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT],
		Control.PAUSE => [FlxGamepadInputID.START],
		Control.RESET => [-100]
	]);

	var icon:Image = Paths.assetsTree.getAsset("assets/images/icon.png", "IMAGE");
	Application.current.window.setIcon(icon);
}
function destroy()
{
	//set stuff back
	WindowUtils.winTitle = "Friday Night Funkin' - Codename Engine";
	init = false;
}