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

package com.kool_animation.mediator
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.mxml.LiveViewBar;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LiveViewBarMediator extends Mediator
	{
		public static const NAME:String = "LiveViewBarMediator";
		private var _preferencesProxy:PreferencesProxy;
		
		public function LiveViewBarMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
			
			liveViewBar.addEventListener(LiveViewBar.EVENT_TOGGLE_VIDEO, toogleLiveView);
			liveViewBar.addEventListener(LiveViewBar.EVENT_AUTOMATISER, openTimeLapse);
			liveViewBar.addEventListener(LiveViewBar.EVENT_CAPTURE, captureFrame);
			liveViewBar.addEventListener(LiveViewBar.EVENT_ONIONSKIN_VALUE, onionSkinValueChanged);
			liveViewBar.addEventListener(LiveViewBar.EVENT_TOGGLE_GRID, toggleGrid);
			liveViewBar.addEventListener(LiveViewBar.EVENT_TOGGLE_HORIZONTAL_FLIP, toggleHorizontalFlip);
			liveViewBar.addEventListener(LiveViewBar.EVENT_TOGGLE_VERTICAL_FLIP, toggleVerticalFlip);
			liveViewBar.addEventListener(LiveViewBar.EVENT_CAPTURE_NUMBER_CHANGED, captureNumberChanged);
		}
		
		override public function listNotificationInterests():Array {
			return [
				TakeConstant.TOGGLE_HORIZONTAL_FLIPPED,
				TakeConstant.TOGGLE_VERTICAL_FLIPPED,
				TakeConstant.GRID_TOGGLED,
				ProjectConstant.PREFERENCES_LOADED
			];
		}
		
		/* Gestion des notifications de l'application */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case ProjectConstant.PREFERENCES_LOADED:
					liveViewBar.captureComboBox.selectedIndex=preferencesProxy.captureNumber;
					break;
				case TakeConstant.TOGGLE_HORIZONTAL_FLIPPED:
					liveViewBar.horizontalFlipped(this.projectProxy.flippedHorizontal);
					break;
				case TakeConstant.TOGGLE_VERTICAL_FLIPPED:
					liveViewBar.verticalFlipped(this.projectProxy.flippedVertical);
					break;
				case TakeConstant.GRID_TOGGLED:
					liveViewBar.gridToggled(this.projectProxy.gridVisible);
					break;
				default:
			}
		}
		
		private function toggleGrid(evt:Event):void{
			sendNotification(TakeConstant.TOGGLE_GRID);
		}
		
		private function toggleHorizontalFlip(evt:Event):void{
			sendNotification(TakeConstant.TOGGLE_HORIZONTAL_FLIP);
		}
		
		private function toggleVerticalFlip(evt:Event):void{
			sendNotification(TakeConstant.TOGGLE_VERTICAL_FLIP);
		}
		
		public function toogleLiveView(evt:Event):void{
			sendNotification(TakeConstant.TOGGLE_LIVE_VIDEO);
		}
		
		public function openTimeLapse(evt:Event):void{
			sendNotification(ProjectConstant.OPEN_TIMELAPSE_WINDOW);
		}
		
		public function captureFrame(evt:Event):void{
			sendNotification(TakeConstant.CAPTURE_FRAMES);
		}
		
		public function onionSkinValueChanged(evt:DataEvent):void{
		 	sendNotification(TakeConstant.ONIONSKIN_ALPHA_VALUE_CHANGE, evt.data);
		}
		
		public function showLiveView(state:Boolean):void{
			liveViewBar.shownLiveViewButtons(state);
		}
		
		private function captureNumberChanged (e:DataEvent):void {
			var captureNumber:Number=Number(e.data);
			sendNotification(TakeConstant.CAPTURE_NUMBER_CHANGED, captureNumber); 
		};
			
		public function get captureImageNumber():int{
			return liveViewBar.captureComboBox.selectedItem;
		}
		
		public function get liveViewBar():LiveViewBar { return viewComponent as LiveViewBar; }
		public function get projectProxy():ProjectProxy {  return facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy; }
		public function get preferencesProxy():PreferencesProxy{
			if (!_preferencesProxy)
				_preferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			return _preferencesProxy; 
		}
	}
}