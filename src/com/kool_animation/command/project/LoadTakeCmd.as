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
package com.kool_animation.command.project
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.SoundProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.model.vo.FrameFileVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadTakeCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {			
			var diskPathsProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			
			//check take compatibility
			
			var jpgFolderPath:File = new File(diskPathsProxy.takeJPGFolderPath)
			if(!jpgFolderPath.exists){
				jpgFolderPath.createDirectory();
			}
			//end check
			
			var timelinefile:File=new File (diskPathsProxy.timeFilePath);
			if (timelinefile.exists) {
				var timelineStream:FileStream= new FileStream();
				timelineStream.open(timelinefile, FileMode.READ);
				var xml:XML = new XML();
				xml = XML(timelineStream.readUTFBytes(timelineStream.bytesAvailable));
				timelineStream.close();
				var frameVOArrayCollection:ArrayCollection = new ArrayCollection ();
				
				var uniqueFrameVO:Object= new Object();
				for each (var frame:XML in xml.layer.image){
					var frameVO:FrameVO;
					if(uniqueFrameVO[frame.attribute("id")]){
						frameVO=uniqueFrameVO[frame.attribute("id")];
					} else {
						//trace("creating new FrameVO "+frame.attribute("id"));
						var frameFileService:FrameFileVO = diskPathsProxy.getFrameFileVO (frame.attribute("id"));
						frameVO = new FrameVO ( frame.attribute("id"), frameFileService );
						uniqueFrameVO[frame.attribute("id")]=frameVO;
					} 
					frameVOArrayCollection.addItem(frameVO);
				}
				
				var takeTimeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
				takeTimeLineProxy.frameArrayCollection=frameVOArrayCollection;
				
				var timelineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
				timelineMediator.frameArrayCollection=frameVOArrayCollection;
				
				soundProxy.loadSoundFromFile();
				
				sendNotification(ProjectConstant.PROJECT_LOAD_TAKE_SUCCESS);
			}else{
				throw new Error("take file does not exist");
			}
			
		}
		
		public function get soundProxy():SoundProxy {
			return facade.retrieveProxy(SoundProxy.NAME) as SoundProxy;;
		}
	}
}
