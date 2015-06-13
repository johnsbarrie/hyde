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
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.model.vo.FrameFileVO;
	import com.kool_animation.mxml.window.ExportationWindow;
	import com.kool_animation.mxml.window.ImportationWindow;
	import com.kool_animation.tools.ImageSetCreator;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	
	import spark.components.Image;
	import spark.primitives.BitmapImage;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ImportImageCmd extends SimpleCommand {
		private var openerfile:File;
		private var imageFilesArray:Array;
		private var imageSetCreator:ImageSetCreator;
		private var importationWindow:ImportationWindow;
		
		override public function execute(notification:INotification):void{
			var preferencesProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			//openerfile=new File("/Users/javanai/Documents/Tonto/john/shots/shot1/takes/remy_kerian/src");
			openerfile=new File(preferencesProxy.workspaceDirectory);
			var resourceManager:IResourceManager =AppFacade.getInstance().resourceManager
			var txtFilter:FileFilter = new FileFilter("Image", "*.png"); 
			
			openerfile.browseForOpenMultiple(resourceManager.getString('GUI_I18NS'
				,'import_image'), [txtFilter]); 
			openerfile.addEventListener(FileListEvent.SELECT_MULTIPLE, fileSelected); 
			
		}
		
		private function fileSelected(event:FileListEvent):void { 
			imageFilesArray=event.files;
			setUpImport();
		} 
		
		private function setUpImport():void{
			importationWindow = new ImportationWindow();
			importationWindow.title = AppFacade.getInstance().resourceManager.getString('GUI_I18NS'
				,'importation_in_progress');
			importationWindow.setStyle("modalTrasparancy",0.2);
			importationWindow.setStyle("modalTransparencyBlur",5);
			importationWindow.setStyle("modalTransparencyDuration",1500);
			
			PopUpManager.addPopUp(importationWindow,AppFacade.getInstance().app,true);
			PopUpManager.centerPopUp(importationWindow);
			var timer:Timer=new Timer(50,1);
			timer.addEventListener(TimerEvent.TIMER, setUpTimerTick);	
			timer.start();
		}
		
		private function setUpTimerTick(evt:TimerEvent):void {
			importImage();
		}
		
		private function importImage():void {
			var file:File=imageFilesArray.pop();
			var dataService:FrameFileVO = new FrameFileVO (file.nativePath);
			
			var bitmapImage:BitmapImage=  new BitmapImage();
			var byteArray:ByteArray=dataService.loadPhoto();
			
			importationWindow.importingImage.source=byteArray;
			setTimeout(createSet, 500);
		}
		
		private function createSet():void{
			imageSetCreator = new ImageSetCreator(facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy);
			imageSetCreator.addEventListener(ProgressEvent.PROGRESS, imageImportationProgress);
			imageSetCreator.addEventListener(Event.COMPLETE, imageImportationComplete);
			imageSetCreator.start(importationWindow.importingImage);
		}
		
		private function imageImportationComplete(evt:Event):void {
			var newId:String=diskPathProxy.createFrameId();
			//trace("newId : ",newId);
			var frame:FrameVO=new FrameVO(newId, diskPathProxy.getFrameFileVO(newId));
			frame.makeViewImage(imageSetCreator.pngSrc);
			frame.makePreviewImage(imageSetCreator.pngPrev);
			frame.makeThumbImage(imageSetCreator.pngThumb);
			frame.save();
			
			timeLineProxy.addFrame(frame, 1);
			sendNotification(TakeConstant.GOTO_LAST_FRAME);
			if (imageFilesArray.length==0) {
				PopUpManager.removePopUp(importationWindow);
			} else {
				importImage();
			}
		}
		
		private function imageImportationProgress(evt:ProgressEvent):void {
			importationWindow.progressBar.setProgress( evt.bytesLoaded/evt.bytesTotal*100, 100);
			importationWindow.progressBar.label= int( evt.bytesLoaded/evt.bytesTotal*100)+"%";
		}
		
		private function  get diskPathProxy():DiskPathsProxy { return facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy; }
		private function  get timeLineProxy():TakeTimeLineProxy { return facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy; }
	}
}