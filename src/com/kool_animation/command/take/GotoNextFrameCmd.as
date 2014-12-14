package com.kool_animation.command.take
{
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GotoNextFrameCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy (TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			
			if (timeLineProxy.currentIndex >= (timeLineProxy.numberFrames-1))
				sendNotification(TakeConstant.SHOW_LIVE_VIDEO);
			else
				sendNotification(TakeConstant.GOTO_FRAME, (timeLineProxy.currentIndex + 1));	
		}
	}
}