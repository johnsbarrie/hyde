package com.kool_animation.command.setup.timelapse
{
	import com.kool_animation.mediator.window.TimelapseWindowMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupTimelapseWindowMediator extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var hydeMainWindow:Hyde = notification.getBody() as Hyde;
			facade.registerMediator(new TimelapseWindowMediator(hydeMainWindow));
		}
	}
}