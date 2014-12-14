package com.kool_animation.command.take {
	import com.kool_animation.mediator.LiveViewBarMediator;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.mediator.NativeMenuMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowLiveVideoCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var monitorMediator:MonitorMediator = facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			monitorMediator.setLiveVisible(true)
				
			var nativeMenuMediator:NativeMenuMediator =  facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.setLiveViewState(true);
			
			var liveViewBarMediator:LiveViewBarMediator = facade.retrieveMediator(LiveViewBarMediator.NAME) as LiveViewBarMediator;
			liveViewBarMediator.showLiveView(true);
			
		}
	}
}