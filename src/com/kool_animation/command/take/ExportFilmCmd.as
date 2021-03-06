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
package com.kool_animation.command.take {
	import com.kool_animation.AppFacade;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.mxml.window.ExportationWindow;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import com.kool_animation.model.ProjectProxy;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ExportFilmCmd extends SimpleCommand {
		private var exportationInProgressWindow:ExportationWindow;
		private var resourceManager:IResourceManager;
		private var exportImageIndex:int=0;
		private var takeTimeLineProxy:TakeTimeLineProxy;
		private var fileBaseName:String;
		private var imageDirectory:File;
		private var videoDirectory:File;
		private var exportTimer:Timer=new Timer(1,0);
		
		override public function execute(notification:INotification):void {
			fileBaseName = notification.getBody() as String;
			if(!fileBaseName){
				var diskPathProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
				fileBaseName = diskPathProxy.projectName+"_"+diskPathProxy.shotName+"_"+ diskPathProxy.takeName;
			}
			
			this.resourceManager= AppFacade.getInstance().resourceManager;
			var dialog:File= File.desktopDirectory;
			dialog.addEventListener(Event.SELECT, directorySelected);
			dialog.addEventListener(Event.CANCEL, canceled);
			
			openPopup();
			dialog.browseForDirectory(resourceManager.getString('GUI_I18NS'
				,'choose_a_folder'));
		}
		
		private function openPopup():void {
			exportationInProgressWindow = new ExportationWindow();
			exportationInProgressWindow.width = 250;
			exportationInProgressWindow.height = 150;
			
			exportationInProgressWindow.title = resourceManager.getString('GUI_I18NS', 'export_in_progress');
			exportationInProgressWindow.setStyle("modalTrasparancy",0.2);
			exportationInProgressWindow.setStyle("modalTransparencyBlur",5);
			exportationInProgressWindow.setStyle("modalTransparencyDuration",1500);
			
			PopUpManager.addPopUp(exportationInProgressWindow,AppFacade.getInstance().app,true);
			PopUpManager.centerPopUp(exportationInProgressWindow);
		}
		
		private function removePopup():void {
			PopUpManager.removePopUp(exportationInProgressWindow);
		}
		
		private function canceled(event:Event):void{
			removePopup();
		}
		
		private function directorySelected(event:Event):void  {
			var directory:File = event.target as File;
			videoDirectory=new File(directory.url);
			videoDirectory.createDirectory();
			imageDirectory= new File(directory.url+"/"+fileBaseName);
			imageDirectory.createDirectory();
			
			//trace("directory ", directory.url);
			
			takeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			startExporting();
		}
		
		private function startExporting():void {
			exportImage(0);
			exportTimer.addEventListener(TimerEvent.TIMER, exportTick);	
			exportTimer.start();	
		}
		
		private function exportTick(evt:TimerEvent):void {
			exportImageIndex++;
			if(exportImageIndex<takeTimeLineProxy.frames.length){
				exportImage(exportImageIndex);
			}else{
				exportTimer.stop();
				exportVideo();
			}
		}
		
		private function exportImage(index:int):void{
			var frameVO:FrameVO=FrameVO(takeTimeLineProxy.frames.getItemAt(index));
			var viewByteArray:ByteArray=frameVO.viewByteArray;
			
			var i:int=index+1;
			exportationInProgressWindow.exportProgressBar.setProgress(i/takeTimeLineProxy.frames.length*100/2, 100);
			exportationInProgressWindow.exportProgressBar.label=resourceManager.getString('GUI_I18NS'
				,'exported')+" "+ int(50+i/takeTimeLineProxy.frames.length*100/2)+"%";
			var photoFile:File = new File(imageDirectory.url+"/"+fileBaseName+getDigits(i, 5)+".png");
			
			var photoStream:FileStream = new FileStream();
			if(viewByteArray) {
				photoStream.open(photoFile, FileMode.WRITE);
				photoStream.writeBytes(viewByteArray, 0, viewByteArray.length);
				photoStream.close();	
				
			} else {
				var blankFile:File = new File ("app:/assets/blank1280x720.png");
				if(blankFile.exists){
					blankFile.copyToAsync(photoFile, true);
				}
			}
		}

		private var process:NativeProcess;
		private var bytes:ByteArray = new ByteArray();
		private var resultExportVideo:String="";
		private var progressValue:Number=0;
		
		private function exportVideo():void {
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); 
			var file:File = File.applicationDirectory.resolvePath("assets/native_apps/ffmpeg"); 

			nativeProcessStartupInfo.executable = file; 
			var processArgs:Vector.<String> = new Vector.<String>(); 
			// -framerate 1/5 -i img%03d.png -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
			processArgs.push("-i"); 
			
			var projectProxy:ProjectProxy= facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			
			var imagePath:String=imageDirectory.url +"/"+fileBaseName+ "%05d.png";
			processArgs.push(imageDirectory.url +"/"+fileBaseName+ "%05d.png");
			processArgs.push("-r");
			processArgs.push("12");
			
			processArgs.push("-c:v"); 
			processArgs.push("libx264"); 
			processArgs.push("-pix_fmt"); 
			processArgs.push("yuv420p"); 
			
			var videoFile:File = videoDirectory.resolvePath( fileBaseName+ ".mp4");
			if (videoFile.exists && ! videoFile.isDirectory) { videoFile.deleteFile(); }
			
			var videoURL:String = videoDirectory.resolvePath( fileBaseName+ ".mp4").url;
			
			processArgs.push(videoURL); 
			nativeProcessStartupInfo.arguments = processArgs;
			nativeProcessStartupInfo.workingDirectory = File.documentsDirectory; 
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorDataHandler); 
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, dataHandler); 
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.start(nativeProcessStartupInfo);
		}

		private function onExit(e:NativeProcessExitEvent):void 
		{
			
			process.exit();
			imageDirectory.deleteDirectory(true);
			removePopup();
		}
		
		private function dataHandler(event:ProgressEvent):void 
		{ 
			resultExportVideo=(process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
		}
		
		private function errorDataHandler(event:ProgressEvent):void 
		{ 
			resultExportVideo=(process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
			progressValue+=5;
			exportationInProgressWindow.exportProgressBar.setProgress(50+ progressValue/takeTimeLineProxy.frames.length*100/2, 100);
			exportationInProgressWindow.exportProgressBar.label=resourceManager.getString('GUI_I18NS'
				,'exported')+" "+ int(50+progressValue/takeTimeLineProxy.frames.length*100/2)+"%";
			//Alert.show(resultExportVideo);
		}
		

		private function getDigits(num:int, numdigits:int):String{
			var digitlength:int= numdigits-String(num).length;
			var zeroStr:String="";
			for(var i:int=0; i<digitlength; i++){
				zeroStr+="0"
			}
			return zeroStr+num;	
		}
	}
}

