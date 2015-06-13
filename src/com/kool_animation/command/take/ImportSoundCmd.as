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
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.SoundProxy;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ImportSoundCmd extends SimpleCommand {
		private var file:File;
		
		override public function execute(notification:INotification):void {
			file= new File();
			file.addEventListener(Event.SELECT, onFileSelected);
			file.browse([new FileFilter("Images", "*.mp3;")]);
		}
		
		private function onFileSelected(event:Event):void {
			var originalFile:File = File(event.target);
			var soundFolder:File=new File(diskPathsProxy.soundFolderPath)
			
			if (!soundFolder.exists) {
				soundFolder.createDirectory();
			}
			
			var newPath:String = diskPathsProxy.soundFolderPath+"/"+file.name;
			originalFile.copyTo(new File(newPath), true);
			
			soundProxy.addSound(originalFile.name);
		}
		
		public function get diskPathsProxy():DiskPathsProxy {
			return facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;;
		}
		
		public function get soundProxy():SoundProxy {
			return facade.retrieveProxy(SoundProxy.NAME) as SoundProxy;;
		}
	}
}