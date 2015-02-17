package com.kool_animation.command.take {
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.model.TakeTimeLineProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ToggleLiveVideoCmd extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			var monitorMediator:MonitorMediator = facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			if (monitorMediator.isLiveVisible) {
				sendNotification(TakeConstant.GOTO_LAST_FRAME);
				sendNotification(TakeConstant.HIDE_LIVE_VIDEO);
			} else {
				var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
				timeLineProxy.stop();
				sendNotification(TakeConstant.GOTO_LAST_FRAME);
				sendNotification(TakeConstant.SHOW_LIVE_VIDEO);
			}
		}
	}
}