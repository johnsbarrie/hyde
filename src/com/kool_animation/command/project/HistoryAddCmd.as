/**
 Hyde Stop Motion
 An Animation Film Software
 Copyright (c) 2015 lamenagerie.
 Conceived by Kolja Saksida and John Barrie 
 Coded by John Barrie  
 Further help by Xavier Boisnon
    Graphism and Icons by Roland Chenel, John Barrie \n Logo Jaro Jelovac
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU LESSER GENERAL PUBLIC LICENSE for more details.
 
 You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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