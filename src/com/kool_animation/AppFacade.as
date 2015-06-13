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

package com.kool_animation {
	import com.kool_animation.command.DebugCmd;
	import com.kool_animation.command.setup.SetupCmd;
	import com.kool_animation.constant.ProjectConstant;
	
	import flash.display.Stage;
	import flash.events.FullScreenEvent;
	
	import mx.resources.IResourceManager;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class AppFacade extends Facade implements IFacade {
			public static const SETUP:String	= "SETUP";
			public static const DEBUG:String    = "DEBUG";
			public static var STAGE:Stage;
			public var app:Hyde;
			public var resourceManager:IResourceManager;
			public var debuggerActive:Boolean=true;
			public static function getInstance():AppFacade {
				if(instance == null) instance = new AppFacade();
				return instance as AppFacade;
			}
			
			override protected function initializeController():void {
				super.initializeController();
				registerCommand(DEBUG, DebugCmd);
				registerCommand(SETUP, SetupCmd);
			}
			
			public function setup (app:Hyde, resourceManager:IResourceManager):void {
				this.app=app;
				//this is used for all services except the menu
				sendNotification(SETUP, app);
				this.resourceManager=resourceManager;
			}
			
			public function startup():void {
				STAGE=this.app.stage;
				STAGE.addEventListener(FullScreenEvent.FULL_SCREEN, fullscreen);
				sendNotification(ProjectConstant.PREFERENCES_LOAD);
			}
			
			public function fullscreen(evt:FullScreenEvent):void{
				if (!evt.fullScreen) {
					sendNotification(ProjectConstant.FULLSCREEN_LEFT);
				}else{
					sendNotification(ProjectConstant.FULLSCREEN_ENTERED);
				}
			}
	}
}