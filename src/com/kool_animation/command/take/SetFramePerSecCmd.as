package com.kool_animation.command.take
{
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetFramePerSecCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			timeLineProxy.fps = notification.getBody() as Number;
			sendNotification(TakeConstant.TRANSPORT_FPS_CHANGED);
		}
	}
}