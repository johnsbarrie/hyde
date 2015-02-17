package com.kool_animation.command.project {
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CheckForUpDatesCmd extends SimpleCommand {
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		
		override public function execute(notification:INotification):void{
				var visibleState:Boolean=notification.getBody() as Boolean;
				appUpdater.addEventListener(UpdateEvent.INITIALIZED, updateCheckNow);
				//appUpdater.updateURL = "http://localhost:8001/air/update.xml"
				/**
				appUpdater.updateURL = "http://hyde.kool-animation.com/hyde/air_update.xml";
				appUpdater.delay = 0.1;
				appUpdater.isCheckForUpdateVisible = visibleState;
				appUpdater.initialize();
				*/
		}
			
		private function updateCheckNow(event:UpdateEvent):void {
			appUpdater.checkNow();
		}
	}
}