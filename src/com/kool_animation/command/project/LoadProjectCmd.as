package com.kool_animation.command.project
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.ProjectProxy;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadProjectCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var diskPathsProxy:DiskPathsProxy = facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			var projectFile:File=new File (diskPathsProxy.projectFilePath);
			if(projectFile.exists){
				var projectFileStream:FileStream= new FileStream();
				projectFileStream.open(projectFile, FileMode.READ);
				var xml:XML = new XML();
				xml = XML(projectFileStream.readUTFBytes(projectFileStream.bytesAvailable));
				projectFileStream.close();
				
				var projectProxy:ProjectProxy= facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;  
				projectProxy.imageHeight= xml.height
				projectProxy.imageWidth = xml.width
				projectProxy.fps = xml.fps;
			}
			
		}
	}
}