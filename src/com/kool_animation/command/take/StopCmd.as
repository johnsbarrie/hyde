package com.kool_animation.command.take
{
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StopCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			timeLineProxy.stop();
		}
	}
}