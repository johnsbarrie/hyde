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
package com.kool_animation.mediator.window
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.mxml.window.PhotoBucketWindow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;
	
	import spark.events.TitleWindowBoundsEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PhotoBucketWindowMediator extends Mediator
	{
		public static const NAME:String="PhotoBucketWindowMediator";
		protected var window:PhotoBucketWindow;
		protected var windowInitialised:Boolean;
		protected var app:Hyde;
		
		public function PhotoBucketWindowMediator (viewComponent:Object=null, mediatorName:String=NAME)  {
			super(mediatorName, viewComponent);
			this.app = Hyde (viewComponent);
			this.app.addEventListener(NativeWindowBoundsEvent.RESIZING, windowResizing);
			this.window = Hyde (viewComponent).photoBucketWindow;
			this.window.addEventListener(TitleWindowBoundsEvent.WINDOW_MOVING, windowMoving);
			this.window.addEventListener(PhotoBucketWindow.INSERT_VIEWS_SELECTED, onInsertFrames);
		}
		
		/* Liste des Notifications ecouté par le mediator */
		override public function listNotificationInterests ():Array {
			return [
				ProjectConstant.OPEN_PHOTO_BUCKET_WINDOW
			];
		}
		
		/* Gestion des Notifications */
		override public function handleNotification (notification:INotification):void {
			switch (notification.getName()) {
				case ProjectConstant.OPEN_PHOTO_BUCKET_WINDOW :
					openWindow();
					break;
			}
		}
		
		private function openWindow ():void {
			sendNotification(TakeConstant.CAPTURE_DISACTIVATE);
			PopUpManager.removePopUp(this.window);
			PopUpManager.addPopUp (this.window, this.app, true);
			PopUpManager.centerPopUp(this.window);
			if(!windowInitialised) {
				this.window.closeButton.addEventListener (MouseEvent.CLICK, closeWindow);
				windowInitialised=true;
				
			}
			var photoframes:ArrayCollection= diskPathsProxy.createPhotoBucketFrames();
			
			window.dataViewsList = photoframes;
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
		
		private function onInsertFrames(e:Event):void {
			sendNotification(TakeConstant.INSERT_PHOTO_BUCKET_FRAMES, window.viewsList.selectedItems);
			sendNotification(TakeConstant.CAPTURE_ACTIVATE);
			PopUpManager.removePopUp(window);
		}
		
		
		private function get diskPathsProxy ():DiskPathsProxy {
			return facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
		}
	}
}