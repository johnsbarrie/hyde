package com.kool_animation.command.preference
{
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.model.PreferencesProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PreferenceLanguageCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var lang:String=notification.getBody() as String;
			var preferenceProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			preferenceProxy.language = lang;
			
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.init(true);
		}
	}
}