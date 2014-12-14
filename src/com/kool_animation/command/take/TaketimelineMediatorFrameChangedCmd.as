package com.kool_animation.command.take
{
	import com.kool_animation.constant.TakeConstant;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class TaketimelineMediatorFrameChangedCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			sendNotification(TakeConstant.HIDE_LIVE_VIDEO);
			sendNotification(TakeConstant.GOTO_FRAME, notification.getBody() as int); 
		}
	}
}