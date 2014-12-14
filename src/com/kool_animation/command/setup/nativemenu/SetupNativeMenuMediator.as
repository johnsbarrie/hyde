package com.kool_animation.command.setup.nativemenu
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.model.PreferencesProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupNativeMenuMediator extends SimpleCommand {
		override public function execute(notification:INotification):void {
			 var appfacade:AppFacade = AppFacade.getInstance();
			 var nativeMenuMediator:NativeMenuMediator=new NativeMenuMediator(appfacade.resourceManager)
			facade.registerMediator(nativeMenuMediator);
			
			var preferenceProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			nativeMenuMediator.setAutomatiqueUpdatesCommandState(preferenceProxy.acceptAutomaticUpdates);
		}
	}
}