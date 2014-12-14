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