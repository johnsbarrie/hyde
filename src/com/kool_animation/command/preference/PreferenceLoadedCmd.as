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
package com.kool_animation.command.preference {
	import com.kool_animation.constant.ProjectConstant;
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
			
			sendNotification (ProjectConstant.SETUPMENU);
			sendNotification (ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW_WITHOUT_CLOSE_BUTTON);
			if (preferencesProxy.isFirstLaunch){
				sendNotification(ProjectConstant.OPEN_PREFERENCEWINDOW);
			}
			
			if (preferencesProxy.isFirstLaunch ) { preferencesProxy.isFirstLaunch=false; }
		}
	}
}