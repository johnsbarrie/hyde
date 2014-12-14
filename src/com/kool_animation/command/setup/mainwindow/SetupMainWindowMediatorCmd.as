package com.kool_animation.command.setup.mainwindow
{
	import com.kool_animation.mediator.window.MainWindowMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupMainWindowMediatorCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			var hydeMainWindow:Hyde = notification.getBody() as Hyde;
			facade.registerMediator(new MainWindowMediator(hydeMainWindow));
		}
	}
}