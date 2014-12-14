package com.kool_animation.command.take
{
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SwitchPlayCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			// If project windows is open don't play.
			var projectProxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			if(projectProxy.modalWindowIsOpen){
				return;
			}
			
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			timeLineProxy.switchPlay();
		}
	}
}