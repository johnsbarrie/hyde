package com.kool_animation.command.project {
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.model.PreferencesProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ToggleAutomaticUpdateCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {			
			var preferencesProxy:PreferencesProxy= facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			preferencesProxy.acceptAutomaticUpdates = !preferencesProxy.acceptAutomaticUpdates;
			
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.setAutomatiqueUpdatesCommandState(preferencesProxy.acceptAutomaticUpdates);
		}
	}
}