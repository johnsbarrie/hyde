package com.kool_animation.command.setup.take {
	import com.kool_animation.mediator.CameraToolbarViewMediator;
	import com.kool_animation.mediator.EditionToolbarViewMediator;
	import com.kool_animation.mediator.LiveViewBarMediator;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.mediator.TakeViewMediator;
	import com.kool_animation.mediator.TransportMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupTakeMediators extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			var hydeMainWindow:Hyde = notification.getBody() as Hyde;
			
			facade.registerMediator(new TakeViewMediator(hydeMainWindow.takeView));
			facade.registerMediator(new TakeTimelineMediator(hydeMainWindow.takeView.timelineView));
			facade.registerMediator(new MonitorMediator(hydeMainWindow.takeView.monitorView));
			facade.registerMediator(new TransportMediator(hydeMainWindow.takeView.transportView));
			facade.registerMediator(new LiveViewBarMediator(hydeMainWindow.takeView.liveViewBar));
			facade.registerMediator(new EditionToolbarViewMediator(hydeMainWindow.takeView.editionToolbarView));
			facade.registerMediator(new CameraToolbarViewMediator(hydeMainWindow.takeView.cameraToolbarView));
		}
	}
}