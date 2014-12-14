package com.kool_animation.command.take
{
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.TakeTimeLineProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SelectAllFramesCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var timeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			
			var selectList:Vector.<int> = new Vector.<int>();
			for(var i:int=0; i<timeLineProxy.numberFrames ; i++){
				selectList.push(i);
			}
				
			timeLineMediator.selectedIndices=selectList;
			timeLineProxy.setCurrentFrame(timeLineProxy.numberFrames - 1);
		}
	}
}