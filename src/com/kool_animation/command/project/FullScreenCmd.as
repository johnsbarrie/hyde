package com.kool_animation.command.project
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.mediator.TakeViewMediator;
	
	import flash.display.StageDisplayState;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FullScreenCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			AppFacade.STAGE.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			var takeViewMediator:TakeViewMediator = facade.retrieveMediator(TakeViewMediator.NAME) as TakeViewMediator;
			takeViewMediator.fullscreen();
		}
	}
}