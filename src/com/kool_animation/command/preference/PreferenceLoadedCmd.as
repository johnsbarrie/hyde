package com.kool_animation.command.preference {
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.TransportMediator;
	import com.kool_animation.mediator.window.PreferenceWindowMediator;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PreferenceLoadedCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var preferencesProxy:PreferencesProxy= facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			var preferenceWindowMediator:PreferenceWindowMediator= facade.retrieveMediator(PreferenceWindowMediator.NAME) as PreferenceWindowMediator;
			preferenceWindowMediator.setLanguage(preferencesProxy.language);
			
			if (preferencesProxy.isFirstLaunch  || preferencesProxy.acceptAutomaticUpdates) { sendNotification(ProjectConstant.CHECK_FOR_UPDATES, false); }
			
			
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			timeLineProxy.fps=preferencesProxy.defaultFPS;
			var transportMediator:TransportMediator = facade.retrieveMediator(TransportMediator.NAME) as TransportMediator;
			transportMediator.initFPS(preferencesProxy.defaultFPS);
			
			sendNotification (ProjectConstant.SETUPMENU);
			sendNotification (ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW_WITHOUT_CLOSE_BUTTON);
			if (preferencesProxy.isFirstLaunch){
				sendNotification(ProjectConstant.OPEN_PREFERENCEWINDOW);
			}
			
			if (preferencesProxy.isFirstLaunch ) { preferencesProxy.isFirstLaunch=false; }
		}
	}
}