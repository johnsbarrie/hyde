package com.kool_animation.command.setup.preference{
	import com.kool_animation.command.preference.PreferenceLanguageCmd;
	import com.kool_animation.command.preference.PreferenceLoadCmd;
	import com.kool_animation.command.preference.PreferenceLoadedCmd;
	import com.kool_animation.command.preference.PreferenceWorkSpaceChangedCmd;
	import com.kool_animation.constant.ProjectConstant;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupPreferenceCommands extends SimpleCommand
	{
			override public function execute(notification:INotification):void {
				facade.registerCommand(ProjectConstant.PREFERENCES_LOAD, PreferenceLoadCmd);
				facade.registerCommand(ProjectConstant.PREFERENCES_LOADED, PreferenceLoadedCmd);
				
				facade.registerCommand(ProjectConstant.PREFERENCE_WORKSPACE_CHANGED, PreferenceWorkSpaceChangedCmd);
				facade.registerCommand(ProjectConstant.PREFERENCE_LANGUAGE_CHANGED, PreferenceLanguageCmd);
			}
	}
}