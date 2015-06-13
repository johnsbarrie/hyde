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
package com.kool_animation.command.take
{
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SelectPrevFrameCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			
			// si on est pas au debut de la time line
			if (timeLineProxy.currentIndex > 0) {
				var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
				
				// Récupère la selection actuelle
				var selectList:Vector.<int> = timeLineMediator.selectedIndices.concat();
				
				// Organise dans l'ordre
				selectList.sort(sortingIndices);
				var firstIndex:int = selectList[0];
				var lastIndex:int = selectList[selectList.length-1];
				
				// Test si c'est une liste consécutive ou non
				var compareIndex:int = firstIndex-1;
				var badSelection:Boolean = false;
				for (var i:int=0; i < selectList.length; i++){
					if ((compareIndex +1) != selectList[i]){
						badSelection=true;
						break;
					}
					compareIndex = selectList[i];
				}
				// Création d'une nouvelle selection
				if(badSelection){
					selectList = new Vector.<int>();
					selectList.push(timeLineProxy.currentIndex);
					firstIndex = lastIndex = timeLineProxy.currentIndex;
				}
				
				// Si on est en debut de selection on ajoute l'element precedent
				if (timeLineProxy.currentIndex == firstIndex){
					selectList.splice(0,0,firstIndex-1);
				}
				// Si on est en fin de selection on Supprime l'element
				else if (timeLineProxy.currentIndex == lastIndex){
					selectList.pop();
				}

				// Mise a jour de la position courante
				timeLineProxy.setCurrentFrame(timeLineProxy.currentIndex-1);
				
				// Mise a jour de la selection
				//timeLineMediator.selectedIndices = selectList;			
			}
		}
		
		final private function sortingIndices(a:Number, b:Number):int {
			    	return (a==b ? 0 : (a < b) ? -1 : 1);
		}
		
		
	}
}