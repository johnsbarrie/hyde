package com.kool_animation.command.project
{
	import com.kool_animation.mediator.TakeViewMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FullScreenLeftCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			var takeViewMediator:TakeViewMediator = facade.retrieveMediator(TakeViewMediator.NAME) as TakeViewMediator;
			takeViewMediator.leavefullscreen();
		}
	}
}