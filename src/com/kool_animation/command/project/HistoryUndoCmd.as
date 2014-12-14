package com.kool_animation.command.project
{
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.HistoryProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.model.vo.HistoryVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class HistoryUndoCmd extends SimpleCommand {
		override public function execute (notification:INotification):void {
			var historyProxy:HistoryProxy=facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;
			var timelineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			var timelineMediator:TakeTimelineMediator= facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var historyVO:HistoryVO = historyProxy.popHistory();
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.setRedoState(true);
			
			if(historyVO) {
				timelineProxy.frames = historyVO.timelineFrames;
				timelineMediator.selectedIndices=historyVO.selectedIndices;
				timelineProxy.currentIndex=historyVO.currentIndex;	
			}
			
			if(historyProxy.lengthHistory()==0) {
				nativeMenuMediator.setUndoState(false);
			} else {
				nativeMenuMediator.setUndoState(true);
			}
		}
	}
}