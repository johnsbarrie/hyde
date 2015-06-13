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
package com.kool_animation.mediator.window {
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mxml.window.TimelapseWindow;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import spark.events.TitleWindowBoundsEvent;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TimelapseWindowMediator extends Mediator {
		public static const NAME:String="TimelapseWindowMediator";
		protected var app:Hyde;
		protected var window:TimelapseWindow;
		protected var windowInitialised:Boolean;
		protected var timer:Timer;
		public function TimelapseWindowMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			this.app = Hyde (viewComponent);
			this.app.addEventListener(NativeWindowBoundsEvent.RESIZING, windowResizing);
			this.window = Hyde (viewComponent).timelapseWindow;
			this.window.addEventListener(TitleWindowBoundsEvent.WINDOW_MOVING, windowMoving);
			this.window.addEventListener(CloseEvent.CLOSE, closeWindow);
			this.window.addEventListener(TimelapseWindow.START_CAPTURE, startTimelapse);
			this.window.addEventListener(TimelapseWindow.STOP_CAPTURE, stopTimeLapse);
		}
		
		/* Liste des Notifications ecouté par le mediator */
		override public function listNotificationInterests ():Array {
			return [
				ProjectConstant.OPEN_TIMELAPSE_WINDOW
			];
		}
		
		/* Gestion des Notifications */
		override public function handleNotification (notification:INotification):void {
			switch (notification.getName()) {
				case ProjectConstant.OPEN_TIMELAPSE_WINDOW :
					openWindow();
					break;
			}
		}
		
	    private function openWindow ():void {
			sendNotification(TakeConstant.CAPTURE_DISACTIVATE);
			PopUpManager.removePopUp(this.window);
			PopUpManager.addPopUp (this.window, this.app, false);
			PopUpManager.centerPopUp(this.window);
			if(!windowInitialised) {
				this.window.closeButton.addEventListener (MouseEvent.CLICK, closeWindow);
				windowInitialised=true;
			}
		}
			
		private function windowResizing (evt:NativeWindowBoundsEvent):void {
			PopUpManager.centerPopUp(window);
		}
		
		protected function windowMoving (evt:TitleWindowBoundsEvent):void {		
			//evt.stopImmediatePropagation();
			//evt.preventDefault();
		}
		
		private function closeWindow(event:Event):void{
			sendNotification(TakeConstant.CAPTURE_ACTIVATE);
			PopUpManager.removePopUp(window);
		}
		
		private function startTimelapse(evt:Event):void { 
			var delayhours:int= window.delayHoursDesired.value*1000*60*60;
			var delayminutes:int= window.delayMinutesDesired.value*1000*60;
			var delayseconds:int= window.delaySecondsDesired.value*1000;
			var totalTime:int=delayhours+delayminutes+delayseconds
			timer=new Timer (totalTime, 0);
			timer.addEventListener(TimerEvent.TIMER, timelapserTick);
			timer.start();
			//takePhoto();
		}
		
		private function stopTimeLapse(evt:Event):void{
			timer.stop();		
		}
		
		private function timelapserTick(evt:TimerEvent):void{
			takePhoto();
		}
		
		private function takePhoto():void{
			sendNotification(TakeConstant.CAPTURE_FRAMES);
		}
	}
}