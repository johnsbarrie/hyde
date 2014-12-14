package com.kool_animation.command.project
{
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.HistoryProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.model.vo.HistoryVO;

	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class HistoryRedoCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			
			// get frames in timeline
			var timeLineProxy:TakeTimeLineProxy=facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			var historyProxy:HistoryProxy=facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;

			var timelineMediator:TakeTimelineMediator= facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			
			var historyVO:HistoryVO= historyProxy.restoreLastPoppedHistory();
			if(historyVO) {
				timeLineProxy.frames = historyVO.timelineFrames;
				timelineMediator.selectedIndices=historyVO.selectedIndices;
				timeLineProxy.currentIndex=historyVO.currentIndex;	
			}
			
			
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.setUndoState(true);
			if(historyProxy.lengthPoppedHistory()==0) {
				nativeMenuMediator.setRedoState(false);
			} else {
				nativeMenuMediator.setRedoState(true);
			}
		}
	}
}