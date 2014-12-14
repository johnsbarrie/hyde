package com.kool_animation.command.setup.preference
{
	import com.kool_animation.mediator.window.PreferenceWindowMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupPreferenceWindowMediator extends SimpleCommand
	{
			override public function execute(notification:INotification):void {
				var hydeMainWindow:Hyde = notification.getBody() as Hyde;
				facade.registerMediator(new PreferenceWindowMediator(hydeMainWindow));
			}	
	}
}