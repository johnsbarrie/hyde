package com.kool_animation.command.project {
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.HistoryProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.model.vo.HistoryVO;
	import mx.collections.ArrayCollection;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class HistoryAddCmd extends SimpleCommand {
		override public function execute (notification:INotification):void {
			// get frames in timeline
			var timeLineProxy:TakeTimeLineProxy=facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			var frames:ArrayCollection= new ArrayCollection(timeLineProxy.frames.source.concat());
			
			// get current Index
			var currectIndex:int=timeLineProxy.currentIndex;
			
			// get selected indices
			var timeLineMediator:TakeTimelineMediator=facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var selectedIndices:Vector.<int>=timeLineMediator.selectedIndices.concat();
			var historyVO:HistoryVO=new HistoryVO(frames, currectIndex, selectedIndices);
			
			var historyProxy:HistoryProxy=facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;
			historyProxy.addHistory(historyVO);
			
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.setUndoState(true);
		}
	}
}