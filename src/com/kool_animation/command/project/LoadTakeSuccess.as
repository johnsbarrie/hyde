package com.kool_animation.command.project {
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeViewMediator;
	import com.kool_animation.model.DiskPathsProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadTakeSuccess extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var diskPathsProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;			
			var takeViewMediator:TakeViewMediator= facade.retrieveMediator(TakeViewMediator.NAME) as TakeViewMediator;
			takeViewMediator.setTakeTitle(diskPathsProxy.projectName +" | "+ diskPathsProxy.shotName + " | " + diskPathsProxy.takeName);
			
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.takeOpenedState();
			var monitorMediator:MonitorMediator= facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			if(!monitorMediator.cameraStarted){
				monitorMediator.connectCameraStream("0");
			}
			sendNotification(TakeConstant.GOTO_LAST_FRAME);
			sendNotification(TakeConstant.SHOW_LIVE_VIDEO);
		}
	}
}