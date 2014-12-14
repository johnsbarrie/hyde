package com.kool_animation.command.take
{	
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GotoLastFrameCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy (TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			sendNotification(TakeConstant.GOTO_FRAME, (timeLineProxy.numberFrames - 1));
			


			
		}
	}
}