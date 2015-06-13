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
	import com.kool_animation.model.SoundProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.mxml.window.ExportationWindow;
	import com.kool_animation.tools.FileStreamFlvEncoder;
	import com.kool_animation.tools.FlvEncoder;
	import com.kool_animation.tools.VideoPayloadMakerAlchemy;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
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
		private var exportTimer:Timer=new Timer(1,0);
		private var fsFlvEncoder:FileStreamFlvEncoder;
		private var photodata:ByteArray ;
		private var loader:Loader;
		private var filmFile:File;
		private var soundByteArray:ByteArray
		
		override public function execute(notification:INotification):void {
			fileBaseName = notification.getBody() as String;
			if (!fileBaseName) {
				var diskPathProxy:DiskPathsProxy = facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
				fileBaseName = diskPathProxy.projectName+"_"+diskPathProxy.shotName+"_"+ diskPathProxy.takeName;
			}
			this.resourceManager= AppFacade.getInstance().resourceManager;
			var dialog:File= new File();
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
			var directory:File= event.target as File;
			filmFile=new File(directory.url+"/"+fileBaseName+".flv");
			
			takeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			startExporting();
		}
		
		private function startExporting():void {
			fsFlvEncoder = new FileStreamFlvEncoder(filmFile, takeTimeLineProxy.fps);
			fsFlvEncoder.fileStream.openAsync(filmFile, FileMode.WRITE);
			fsFlvEncoder.setVideoProperties(1280, 720, VideoPayloadMakerAlchemy);
			
			if (soundProxy.sound) {
				soundByteArray = new ByteArray();
				soundProxy.sound.extract(soundByteArray, soundProxy.sound.length / 1000 * FlvEncoder.SAMPLERATE_44KHZ, 0);            
				soundByteArray.position = 0;
				fsFlvEncoder.setAudioProperties(FlvEncoder.SAMPLERATE_44KHZ, true, true,true);
			}
			
			fsFlvEncoder.start();
			addImage();
		}
		
		private function addImage():void {
			exportImageIndex++;
			if (exportImageIndex<takeTimeLineProxy.frames.length){
				var frameVO:FrameVO=FrameVO(takeTimeLineProxy.frames.getItemAt(exportImageIndex));
				var viewByteArray:ByteArray=frameVO.viewByteArray;
				
				var percentage:Number = Math.ceil(exportImageIndex/takeTimeLineProxy.frames.length*100);
				exportationInProgressWindow.exportProgressBar.label="Percentage : " + percentage + "%";
				var bmpData:BitmapData = new BitmapData(1280, 720, false, 0x000000);
				var matrix:Matrix = new Matrix();
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void {
					bmpData.draw(loader, matrix,null,null,null,true);
					if(soundProxy.sound){
						var newBytes:ByteArray = new ByteArray();
						if ((exportImageIndex+1)*fsFlvEncoder.audioFrameSize < soundByteArray.length) {
							newBytes.writeBytes(soundByteArray, exportImageIndex*fsFlvEncoder.audioFrameSize, fsFlvEncoder.audioFrameSize);
						}
						
						newBytes.position=0;
						fsFlvEncoder.addFrame(bmpData, newBytes);
					}else{
						fsFlvEncoder.addFrame(bmpData, null);
					}
					setTimeout(	addImage, 1);
				});
				loader.loadBytes(viewByteArray);
			} else {
				exportationInProgressWindow.exportProgressBar.label="Percentage : 100%";
				fsFlvEncoder.updateDurationMetadata();
				fsFlvEncoder.fileStream.close();
				fsFlvEncoder.kill();
				removePopup();
			}
		}
		/*
		private function startListener(e:Event):void {
			exportationInProgressWindow.exportProgressBar.label="Percentage : " + Math.ceil((i/totalFrames)*100).toString()+"%";
			var content:* = loader.content;
			var bmpData:BitmapData = new BitmapData(1280, 720, false, 0x000000);
			var matrix:Matrix = new Matrix();
			bmpData.draw(content, matrix,null,null,null,true);
			if(soundProxy.sound){
				var newBytes:ByteArray = new ByteArray();
				if ((i+1)*fsFlvEncoder.audioFrameSize < soundByteArray.length) {
					newBytes.writeBytes(soundByteArray, i*fsFlvEncoder.audioFrameSize, fsFlvEncoder.audioFrameSize);
				}
				
				newBytes.position=0;
				fsFlvEncoder.addFrame(bmpData, newBytes);
			}
			fsFlvEncoder.addFrame(bmpData, null);
			setTimeout(	addImage, 1);				
		}*/
		
		private function getDigits(num:int, numdigits:int):String{
			var digitlength:int= numdigits-String(num).length;
			var zeroStr:String="";
			for(var i:int=0; i<digitlength; i++){
				zeroStr+="0"
			}
			return zeroStr+num;	
		}
		
		public function get soundProxy():SoundProxy { return facade.retrieveProxy(SoundProxy.NAME) as SoundProxy; }
		
	}
}