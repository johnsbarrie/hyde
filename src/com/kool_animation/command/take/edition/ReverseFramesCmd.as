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
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ReverseFramesCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			sendNotification(ProjectConstant.ADD_HISTORY);
			var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var timeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			
			var selectList:Vector.<int> = null;
			
			if(timeLineMediator.selectedIndices.length > 0){
				//trace("reversing "+timeLineMediator.selectedIndices.length+" frames");
				
				selectList = timeLineMediator.selectedIndices.concat();
				
				// Réordonne la liste  d'indices dans  l'ordre croissant 
				timeLineMediator.selectedIndices.sort(sortingIndices);
				
				// recupere l'index precedent la selection
				var firstIndex:int = timeLineMediator.selectedIndices[0];
				
				// Récupère les frames selectionnées
				var list:Vector.<Object> = new Vector.<Object>();
				var nbObject:int = timeLineMediator.selectedIndices.length;
				for(var i:int =0; i < nbObject; i++){
					list.push(timeLineMediator.selectedItems[i]);
				}
				
				// Retire les elements de la timeline
				timeLineProxy.removeFrames(timeLineMediator.selectedIndices.concat());
							
				// Ajoute les elements de la liste a la timeline en inversant l'ordre
				for each (var frame:Object in list){
					timeLineProxy.addFrameAt(frame as FrameVO, firstIndex);
				}

			}
			
			// Mise a jour de la frame courante
			timeLineProxy.setCurrentFrame(timeLineProxy.currentIndex,true);
			if(selectList)
				timeLineMediator.selectedIndices = selectList;
		}
		
	   final private function sortingIndices(a:Number, b:Number):int {
		      return (a==b ? 0 : (a < b) ? -1 : 1);
	    }

		
	}
}