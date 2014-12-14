package com.kool_animation.command.preference
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.model.PreferencesProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PreferenceWorkSpaceChangedCmd extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			var workspace:String= notification.getBody().workSpace as String;
			var preferenceProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			if(preferenceProxy.setWorkspaceDirectory(workspace)){
			 sendNotification(ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW_WITHOUT_CLOSE_BUTTON);
			}
		}
	}
}