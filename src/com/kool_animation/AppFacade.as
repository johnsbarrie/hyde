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