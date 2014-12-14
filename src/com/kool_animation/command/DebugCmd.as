package com.kool_animation.command
{
	import com.kool_animation.AppFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DebugCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var muto:AppFacade= AppFacade.getInstance();
			if (muto.debuggerActive){
				muto.app.debugLabel.text=notification.getBody() as String;
			}
		}
	}
}