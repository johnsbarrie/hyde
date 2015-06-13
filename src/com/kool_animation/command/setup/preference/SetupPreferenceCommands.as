/**
 Hyde Stop Motion
 An Animation Film Software
 Copyright (c) 2015 lamenagerie.
 Conceived by Kolja Saksida and John Barrie 
 Coded by John Barrie  
 Further help by Xavier Boisnon
    Graphism and Icons by Roland Chenel, John Barrie \n Logo Jaro Jelovac
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU LESSER GENERAL PUBLIC LICENSE for more details.
 
 You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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