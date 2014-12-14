package com.kool_animation.command.take
{
	
	
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.ProjectProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ToggleHorizontalFlipCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var projectProxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			projectProxy.flippedHorizontal=!projectProxy.flippedHorizontal;
			sendNotification(TakeConstant.TOGGLE_HORIZONTAL_FLIPPED);
		}
	}
}