package com.kool_animation.command.take.edition
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DeleteFramesCmd extends SimpleCommand
	{
		private var delayTimer:Timer;
		
		override public function execute(notification:INotification):void {
			sendNotification(ProjectConstant.ADD_HISTORY);
			var appfacade:AppFacade = AppFacade.getInstance();
					
			Alert.show(appfacade.resourceManager.getString("GUI_I18NS","are_you_you_want_to_delete"), appfacade.resourceManager.getString("GUI_I18NS","delete_files"), Alert.OK    | Alert.CANCEL, null, closing, null);
			var projectProxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			projectProxy.modalWindowIsOpen=true;
		}
		
		private function closing(evt:CloseEvent):void {
			if (evt.detail==Alert.OK) {
				var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
				var timeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;

				if(timeLineMediator.selectedItems.length > 0){
					timeLineProxy.removeFrames(timeLineMediator.selectedIndices.concat());
				}
				// Mise a jour de la frame courante
				timeLineProxy.setCurrentFrame(timeLineProxy.currentIndex-1,true);
			}
			
			
			delayTimer=new Timer(20, 1);
			delayTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			delayTimer.start();
		}
		
		private function timerHandler(e:TimerEvent):void{
			delayTimer.stop();
			var projectProxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			projectProxy.modalWindowIsOpen=false;
		}

	}
	
}