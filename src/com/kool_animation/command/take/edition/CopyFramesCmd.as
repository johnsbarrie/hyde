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
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	
	import flash.desktop.Clipboard;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CopyFramesCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			if(timeLineMediator.selectedItems.length > 0){
				//trace("copying "+timeLineMediator.selectedItems.length+" frames");
				// Réordonne la liste  d'indices dans  l'ordre croissant 
				timeLineMediator.selectedIndices.sort(sortingIndices);
				var list:Vector.<Object> = new Vector.<Object>();
				var nbObject:int = timeLineMediator.selectedIndices.length;
				for(var i:int =0; i < nbObject; i++) {
					list.push(timeLineMediator.selectedItems[i]);
				}
				
				// Met la liste dans le clipBoard
				Clipboard.generalClipboard.setData("framesList", list, false);
				nativeMenuMediator.setPasteState(true);
			} else { 
				Clipboard.generalClipboard.clear();		
				nativeMenuMediator.setPasteState(false);
			}
		}
		
	   final private function sortingIndices(a:Number, b:Number):int {
		      return (a==b ? 0 : (a < b) ? -1 : 1);
	    }

	}
} 