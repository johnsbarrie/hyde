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
package com.kool_animation.command.take.edition
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardTransferMode;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InvertedPasteFramesCmd extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void {
			
			sendNotification(ProjectConstant.ADD_HISTORY);
			var framesList:Vector.<Object> = Clipboard.generalClipboard.getData("framesList", ClipboardTransferMode.ORIGINAL_ONLY) as Vector.<Object>;
			
			if(framesList) {
				
				//trace("past inverted "+framesList.length+" frames");

				var selectList:Vector.<int> = new Vector.<int>();

				// On inverse le tableau car de base il est a l'envers
				var invertedFramesList:Vector.<Object> = framesList.concat();
				
				invertedFramesList = invertedFramesList.reverse();
				
				var timeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
				var frameIndice:int = timeLineProxy.currentIndex;

				for each (var frame:Object in invertedFramesList){
					frameIndice = timeLineProxy.addFrameAt(frame as FrameVO, frameIndice+1);
					selectList.push(frameIndice);
				}
				
				timeLineProxy.setCurrentFrame(frameIndice,true);				
				if(selectList.length > 1){
					var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
					timeLineMediator.selectedIndices = selectList;
				}


			}
		}
		
	}
}