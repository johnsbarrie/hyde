package com.kool_animation.command.setup.nativemenu
{
	import com.kool_animation.constant.ProjectConstant;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupNativeCommands extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			facade.registerCommand(ProjectConstant.SETUPMENU, SetupNativeMenuMediator);
		}
	}
}