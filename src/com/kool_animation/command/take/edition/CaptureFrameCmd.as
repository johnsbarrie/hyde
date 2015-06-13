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
package com.kool_animation.command.take.edition {
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.LiveViewBarMediator;
	import com.kool_animation.mediator.window.MainWindowMediator;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.model.vo.FrameFileVO;
	import com.kool_animation.tools.ImageSetCreator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.system.System;
	
	import mx.containers.TitleWindow;
	import mx.core.SoundAsset;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	
	import spark.components.Label;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CaptureFrameCmd extends SimpleCommand {
		[Embed(source="assets/sounds/camera_click.mp3")]
		public var CameraEmbeddedSound:Class;
		private var cameraSound:SoundAsset = new CameraEmbeddedSound() as SoundAsset;
		private var frame:FrameVO;
		private var monitorMediator:MonitorMediator;
		private var timeLineProxy:TakeTimeLineProxy;
		private var timeLineMediator:TakeTimelineMediator
		private var liveViewMediator:LiveViewBarMediator;
		private var preferencesProxy:PreferencesProxy;
		private var liveViewBarMediator:LiveViewBarMediator;
		private var titleWin:TitleWindow;
		private var isPopup:Boolean;
		private var imageLabel:Label;
		private var thumbnailLabel:Label;
		private var resourceManager:IResourceManager;
		private var imageSetCreator:ImageSetCreator;

		override public function execute(note:INotification):void {
			// If project windows is open don't capture.
			var projectProxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			if(projectProxy.modalWindowIsOpen){ return; }
			
			resourceManager = AppFacade.getInstance().resourceManager;
			monitorMediator = facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			// test to make sure videoobject has a valide flux
			var videoObject:Video=monitorMediator.camera.videoObject;
			if ( !videoObject || (!(videoObject.videoHeight>0 &&videoObject.videoWidth>0))) {
				if(!videoObject ){
					sendNotification(AppFacade.DEBUG, "no camera");
					return;
				}
				sendNotification(AppFacade.DEBUG, "videoObject.videoHeight ="+videoObject.videoHeight);
				return;
			}
			
			liveViewMediator = facade.retrieveMediator(LiveViewBarMediator.NAME) as LiveViewBarMediator;
			timeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			preferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			
			timeLineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			liveViewBarMediator = facade.retrieveMediator(LiveViewBarMediator.NAME) as LiveViewBarMediator;
			
			isPopup = false;
			// Rajouter un popup si on veut ici
			openPopup ();
			// Ajoute une entrée a l'historique
			sendNotification (ProjectConstant.ADD_HISTORY);				
			// Declanche un son pour la photo
			cameraSound.play ();
			// Création de la nouvelle frame
			var diskPathsProxy:DiskPathsProxy = facade.retrieveProxy (DiskPathsProxy.NAME) as DiskPathsProxy;
			var id:String=diskPathsProxy.createFrameId ();
			var dataService:FrameFileVO = diskPathsProxy.getFrameFileVO (id);
			frame = new FrameVO (id, dataService);
			
			imageSetCreator = new ImageSetCreator (facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy);
			imageSetCreator.addEventListener (ImageSetCreator.JPGCREATED_EVENT, onJPGCreationComplete);
			imageSetCreator.addEventListener (Event.COMPLETE, onCreationComplete);
			imageSetCreator.addEventListener (ProgressEvent.PROGRESS, onImageSetCreationProgress);
			imageSetCreator.start (monitorMediator.camera);
		}
			
		private function onImageSetCreationProgress(event:ProgressEvent):void {
			imageLabel.text = resourceManager.getString('GUI_I18NS', 'image_capture_in_progress') + " : " + Math.floor(event.bytesLoaded/event.bytesTotal*100)+"%";
		}
		
		private function onCreationComplete(event:Event):void {
			imageLabel.text = resourceManager.getString('GUI_I18NS', 'image_capture_completed');
			//trace(System.totalMemory / 1024); 
			frame.makeViewImage (imageSetCreator.pngSrc);
			frame.makePreviewImage (imageSetCreator.pngPrev);
			frame.makeThumbImage (imageSetCreator.pngThumb);
			frame.save();
			timeLineProxy.addFrame(frame, liveViewMediator.captureImageNumber);
			sendNotification(TakeConstant.GOTO_LAST_FRAME);
			
			if (isPopup){ removePopup(); }
		}
		
		private function onJPGCreationComplete(evt:Event):void{
			frame.makeJpgImage(imageSetCreator.jpgSrc);
			frame.saveJpg();
			frame.flushJpgMemory();
			timeLineProxy.flushMemory();
			//trace(System.totalMemory / 1024);
		}
		
		private function openPopup():void {
			titleWin = new TitleWindow();
			titleWin.width = 250;
			titleWin.height = 50;
			titleWin.showCloseButton = false;
			
			imageLabel = new Label();
			thumbnailLabel = new Label();
			titleWin.addChild(imageLabel);
			titleWin.addChild(thumbnailLabel);
			titleWin.title = "Capturing...";
			titleWin.setStyle("modalTrasparancy",1);
			//titleWin.setStyle("modalTransparencyBlur",100);
			titleWin.setStyle("modalTransparencyColor",0x666666);
			titleWin.setStyle("modalTransparencyDuration",0);
			 
			var mainWindowMediator:MainWindowMediator = facade.retrieveMediator(MainWindowMediator.NAME) as MainWindowMediator;
			PopUpManager.addPopUp(titleWin,mainWindowMediator.getViewComponent() as DisplayObject,true);
			PopUpManager.centerPopUp(titleWin);
			
			isPopup = true;
		}
		
		private function removePopup ():void {
			titleWin.setStyle ("modalTransparencyDuration",0);
			PopUpManager.removePopUp(titleWin);
		}	
	}
}