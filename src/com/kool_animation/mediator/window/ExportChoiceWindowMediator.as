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
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.mxml.window.ExportationChoiceWindow;
	
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.events.TitleWindowBoundsEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ExportChoiceWindowMediator extends Mediator {
		public static const NAME:String="ExportChoiceWindowMediator";
		protected var app:Hyde;
		protected var exportChoiceWindow:ExportationChoiceWindow;
		
		public function ExportChoiceWindowMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			this.app = Hyde (viewComponent);
			this.app.addEventListener(NativeWindowBoundsEvent.RESIZING, windowResizing);
			this.exportChoiceWindow = Hyde (viewComponent).exportationChoiceWindow;
			this.exportChoiceWindow.addEventListener(CloseEvent.CLOSE, closeWindow);
			this.exportChoiceWindow.addEventListener(ExportationChoiceWindow.EXPORT_IMAGES, exportImages);
			this.exportChoiceWindow.addEventListener(ExportationChoiceWindow.EXPORT_FILM, exportFilm);
		}
		
		/* Liste des Notifications ecouté par le mediator */
		override public function listNotificationInterests():Array {
			return [
				ProjectConstant.OPEN_EXPORT_WINDOW,
			];
		}
		
		/* Gestion des Notifications */
		override public function handleNotification (notification:INotification):void {
			switch(notification.getName ()) {
				case ProjectConstant.OPEN_EXPORT_WINDOW :
					openWindow();
					break;
			}
		}
		
		private function exportImages(evt:Event):void{
			sendNotification(TakeConstant.EXPORT_TAKE_IMAGES, this.exportChoiceWindow.baseName.text);
			this.closeWindow(null);
		}
		
		private function exportFilm(evt:Event):void{
			sendNotification(TakeConstant.EXPORT_FILM, this.exportChoiceWindow.baseName.text);
			this.closeWindow(null);
		}
		
		private function openWindow ():void {
			var diskPathsProxy:DiskPathsProxy = facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			this.exportChoiceWindow.setBaseName(diskPathsProxy.projectName + "_" + diskPathsProxy.shotName + "_" + diskPathsProxy.takeName);
			PopUpManager.removePopUp (this.exportChoiceWindow);
			PopUpManager.addPopUp (this.exportChoiceWindow, this.app, true);
			PopUpManager.centerPopUp (this.exportChoiceWindow);
		}
		
		private function windowResizing(evt:NativeWindowBoundsEvent):void{
			PopUpManager.centerPopUp (this.exportChoiceWindow);
		}
		
		protected function titleWin_windowMovingHandler(evt:TitleWindowBoundsEvent):void {				
			evt.stopImmediatePropagation ();
			evt.preventDefault ();
		}
		
		private function closeWindow(event:Event):void{
			sendNotification (TakeConstant.CAPTURE_ACTIVATE);
			PopUpManager.removePopUp ( this.exportChoiceWindow );
		}
	}
}