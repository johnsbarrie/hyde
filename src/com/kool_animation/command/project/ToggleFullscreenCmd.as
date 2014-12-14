package com.kool_animation.command.project
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.MonitorMediator;
	
	import flash.display.StageDisplayState;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ToggleFullscreenCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			if(AppFacade.STAGE.displayState== StageDisplayState.NORMAL){
				sendNotification(ProjectConstant.FULLSCREEN);
			}else{
				AppFacade.STAGE.displayState=StageDisplayState.NORMAL;
			}
			
			var monitorMediator:MonitorMediator  = facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			monitorMediator.updateFlips();
		}
	}
}