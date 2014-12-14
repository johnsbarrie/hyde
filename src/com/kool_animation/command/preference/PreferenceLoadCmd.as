package com.kool_animation.command.preference {
	import com.kool_animation.model.PreferencesProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PreferenceLoadCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var preferencesProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			preferencesProxy.loadPreferences();
		}
	}
}