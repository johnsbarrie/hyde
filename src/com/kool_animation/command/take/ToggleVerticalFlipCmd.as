package com.kool_animation.command.take
{
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.ProjectProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ToggleVerticalFlipCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var projectProxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			projectProxy.flippedVertical=!projectProxy.flippedVertical;
			sendNotification(TakeConstant.TOGGLE_VERTICAL_FLIPPED);
		}
	}
}