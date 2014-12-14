package com.kool_animation.command.setup.preference
{
	import com.kool_animation.model.PreferencesProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupPreferenceProxy extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			facade.registerProxy(new PreferencesProxy());
		}
	}
}