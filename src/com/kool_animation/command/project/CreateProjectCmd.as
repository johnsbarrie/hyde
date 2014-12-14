package com.kool_animation.command.project
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.PreferencesProxy;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CreateProjectCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var preferencesProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			var projectFolderName:String=notification.getBody() as String;
			var projectFolder:File=new File(preferencesProxy.workspaceDirectory+"/"+projectFolderName+"/shots");
			//create Directory Folder
			
			projectFolder.createDirectory();
			
			var diskPathsProxy:DiskPathsProxy = facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			diskPathsProxy.projectName=projectFolderName;
			
			var xml:XML = <project/>;
			xml.height="1280";
			xml.width="720"
			xml.fps="12.5";
			var projectFile:File = projectFolder.resolvePath(diskPathsProxy.projectFilePath);
			
			var projectStream:FileStream= new FileStream();
			projectStream.open(projectFile, FileMode.WRITE);
			projectStream.writeUTFBytes(xml.toXMLString());
			projectStream.close();
				
			sendNotification(ProjectConstant.PROJECT_CREATE_PROJECT_SUCCESS );
		}
	}
}