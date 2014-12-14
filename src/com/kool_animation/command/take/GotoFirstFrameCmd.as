package com.kool_animation.command.take
{
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.MonitorMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GotoFirstFrameCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var monitorMediator:MonitorMediator = facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
				
			if ((monitorMediator.isLiveVisible))
				sendNotification(TakeConstant.HIDE_LIVE_VIDEO);

			sendNotification(TakeConstant.GOTO_FRAME, 0);			
		}
	}
}