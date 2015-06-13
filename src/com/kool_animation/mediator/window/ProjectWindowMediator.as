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
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.mxml.window.ProjectWindow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	
	import mx.managers.PopUpManager;
	
	import spark.events.TitleWindowBoundsEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ProjectWindowMediator extends Mediator {
		public static const NAME:String="ProjectWindowMediator";
		
		private var app:Hyde;
		private var projectWindow:ProjectWindow;
		private var projectWindowInitialised:Boolean;
		
		public function ProjectWindowMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			this.app = Hyde (viewComponent);
			this.app.addEventListener(NativeWindowBoundsEvent.RESIZING, windowResizing);
			this.projectWindow = Hyde (viewComponent).projectWindow;
			this.projectWindow.addEventListener(TitleWindowBoundsEvent.WINDOW_MOVING, windowMoving);
		}
		
		/* Liste des Notifications ecouté par le mediator */
		override public function listNotificationInterests ():Array {
			return [
				ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW_WITHOUT_CLOSE_BUTTON,
				ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW, 
				ProjectConstant.PROJECT_CREATE_PROJECT_SUCCESS,
				ProjectConstant.PROJECT_CREATE_SHOT_SUCCESS,
				ProjectConstant.PROJECT_CREATE_TAKE_SUCCESS
			];
		}
		
		/* Gestion des Notifications */
		override public function handleNotification (notification:INotification):void {
			switch (notification.getName()) {
				case ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW_WITHOUT_CLOSE_BUTTON :
					openWindow();
					projectWindow.closeButton.visible=false;
					break;
				case ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW :
					openWindow();
					projectWindow.closeButton.visible=true;
					break;
				case ProjectConstant.PROJECT_CREATE_PROJECT_SUCCESS :
					createProjectSuccess();
					break;
				case ProjectConstant.PROJECT_CREATE_SHOT_SUCCESS :
					createShotSuccess();
					break;
				case ProjectConstant.PROJECT_CREATE_TAKE_SUCCESS:
					createTakeSuccessfully();
					break;
			}
		}
		
		private function windowResizing (evt:NativeWindowBoundsEvent):void {
			PopUpManager.centerPopUp(projectWindow);
		}
		
		protected function windowMoving (evt:TitleWindowBoundsEvent):void {		
			evt.stopImmediatePropagation();
			evt.preventDefault();
		}
		
		private function openWindow ():void {
			PopUpManager.removePopUp(this.projectWindow);
			PopUpManager.addPopUp (this.projectWindow, this.app, true);
			PopUpManager.centerPopUp(projectWindow);
			if(!projectWindowInitialised) {
				projectWindow.init();
				this.projectWindow.addEventListener(ProjectWindow.CREATE_TAKE, createTake);
				this.projectWindow.addEventListener(ProjectWindow.OPEN_TAKE, openTake);
				this.projectWindow.addEventListener(ProjectWindow.CREATE_PROJECT, createProject);
				this.projectWindow.addEventListener(ProjectWindow.CREATE_SHOT, createShot);
				this.projectWindow.addEventListener(ProjectWindow.PROJECT_SELECTED, projectSelected);
				this.projectWindow.addEventListener(ProjectWindow.SHOT_SELECTED, shotSelected);
				this.projectWindow.addEventListener(ProjectWindow.TAKE_SELECTED, takeSelected);
				this.projectWindow.closeButton.addEventListener(MouseEvent.CLICK, closingProjectWindow);
				projectWindowInitialised=true;
			}
			
			projectWindow.setWithWorkSpace(preferencesProxy.workspaceDirectory);
			projectProxy.modalWindowIsOpen=true;
		}
		
		private function projectSelected(evt:Event):void {
			diskPathsProxy.projectName=this.projectWindow.projectCreationInput.text;
			sendNotification(ProjectConstant.PROJECT_LOAD_PROJECT);
		}

		private function shotSelected(evt:Event):void {
			diskPathsProxy.shotName=this.projectWindow.shotCreationInput.text;
		}
		
		private function takeSelected(evt:Event):void {
			diskPathsProxy.takeName = this.projectWindow.takeCreationInput.text;
		}
		
		private function createProject(evt:Event):void {			
			sendNotification(ProjectConstant.PROJECT_CREATE_PROJECT, this.projectWindow.projectCreationInput.text);
		}
		
		private function createProjectSuccess():void{
			this.projectWindow.projectCreatedSuccessfully(diskPathsProxy.projectFolderPath);
		}

		private function createShot(evt:Event):void{
			sendNotification(ProjectConstant.PROJECT_CREATE_SHOT, this.projectWindow.shotCreationInput.text);
		}
		
		private function createShotSuccess():void{
			this.projectWindow.shotCreatedSuccessfully(diskPathsProxy.shotsFolderPath);
		}
		
		private function createTake (evt:Event):void {
			sendNotification(ProjectConstant.PROJECT_CREATE_TAKE, this.projectWindow.takeCreationInput.text);
		}
		
		private function createTakeSuccessfully():void{
			this.projectWindow.takeCreatedSuccessfully(diskPathsProxy.takesFolderPath);
			loadTake();
		}
		
		private function openTake (evt:Event):void {
			loadTake();
		}
		
		private function loadTake ():void {
			PopUpManager.removePopUp (projectWindow);
			sendNotification(ProjectConstant.PROJECT_LOAD_TAKE);
			projectProxy.modalWindowIsOpen=false;
		}
		
		private function closingProjectWindow (evt:MouseEvent):void{
			PopUpManager.removePopUp(projectWindow);
			projectProxy.modalWindowIsOpen=false;
		}
		
		public function get preferencesProxy ():PreferencesProxy {
			return facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;;
		}
		
		public function get diskPathsProxy ():DiskPathsProxy {
			return facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
		}	
		
		public function get projectProxy ():ProjectProxy {
			return facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
		}
	}
}