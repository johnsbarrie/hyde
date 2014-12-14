package com.kool_animation.command.project {
	import com.kool_animation.mediator.MonitorMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ChangeCameraCmd extends SimpleCommand {
		override public function execute(notification:INotification):void{
			var cameraIndex:String=notification.getBody() as String;
			var monitorMediator:MonitorMediator= facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			monitorMediator.connectCameraStream(cameraIndex);
		}
	}
}