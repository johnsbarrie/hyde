package com.kool_animation.mediator.window
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.event.ObjectEvent;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.mxml.window.PreferencesWindow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.events.TitleWindowBoundsEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PreferenceWindowMediator extends Mediator
	{
		public static const NAME:String="PreferenceWindowMediator";
		protected var app:Hyde;
		protected var preferenceWindow:PreferencesWindow;
		protected var preferenceWindowInitialised:Boolean;
		
		public function PreferenceWindowMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			this.app = Hyde (viewComponent);
			this.app.addEventListener(NativeWindowBoundsEvent.RESIZING, windowResizing);
			this.preferenceWindow = Hyde (viewComponent).preferenceWindow;
			this.preferenceWindow.addEventListener(PreferencesWindow.EVENT_WORKSPACE_CHANGED, workSpaceChanged);
			this.preferenceWindow.addEventListener(PreferencesWindow.LANGUAGECHANGED, languageChanged);
			this.preferenceWindow.addEventListener(TitleWindowBoundsEvent.WINDOW_MOVING, titleWin_windowMovingHandler);
			//this.preferenceWindow.closeButton.addEventListener(MouseEvent.CLICK, closingProjectWindow);
			this.preferenceWindow.addEventListener(CloseEvent.CLOSE, closeWindow);
		}
		
		/* Liste des Notifications ecouté par le mediator */
		override public function listNotificationInterests():Array {
			return [
				ProjectConstant.OPEN_PREFERENCEWINDOW,
			];
		}
		
		/* Gestion des Notifications */
		override public function handleNotification (notification:INotification):void {
			switch(notification.getName()) {
				case ProjectConstant.OPEN_PREFERENCEWINDOW :
					openPreferenceWindow();
					break;
			}
		}
		
		private function openPreferenceWindow():void {
			sendNotification(TakeConstant.CAPTURE_DISACTIVATE);
			PopUpManager.removePopUp(preferenceWindow);
			PopUpManager.addPopUp (this.preferenceWindow, this.app, true);
			PopUpManager.centerPopUp(preferenceWindow);
			if (!preferenceWindowInitialised) {
				var preferencesProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
				preferenceWindow.init(preferencesProxy.workspaceDirectory);
				this.preferenceWindow.closeButton.addEventListener (MouseEvent.CLICK, closeWindow);
				preferenceWindowInitialised=true;
			}
		}
		
		private function workSpaceChanged(evt:ObjectEvent):void {
			sendNotification(ProjectConstant.PREFERENCE_WORKSPACE_CHANGED, evt.data);
		}
		
		public function setLanguage(language:String):void{
			this.preferenceWindow.setLanguage(language);
		}
		
		private function languageChanged(evt:ObjectEvent):void {
			sendNotification(ProjectConstant.PREFERENCE_LANGUAGE_CHANGED, evt.data);
		}
		
		private function windowResizing(evt:NativeWindowBoundsEvent):void{
			PopUpManager.centerPopUp(preferenceWindow);
		}
		
		protected function titleWin_windowMovingHandler(evt:TitleWindowBoundsEvent):void {				
			evt.stopImmediatePropagation();
			evt.preventDefault();
		}
		
		private function closeWindow(event:Event):void{
			sendNotification(TakeConstant.CAPTURE_ACTIVATE);
			PopUpManager.removePopUp(preferenceWindow);
		}
	}
}