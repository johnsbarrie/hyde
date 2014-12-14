package com.kool_animation.command.project
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.model.DiskPathsProxy;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CreateShotCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			var  diskPathProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			diskPathProxy.shotName=notification.getBody() as String;
			
			var shotsFolder:File=new File(diskPathProxy.takesFolderPath);
			shotsFolder.createDirectory();
			
			sendNotification (ProjectConstant.PROJECT_CREATE_SHOT_SUCCESS);
		}
	}
}