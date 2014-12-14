package com.kool_animation.command.project
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.model.DiskPathsProxy;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CreateTakeCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var  diskPathProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			diskPathProxy.takeName=notification.getBody() as String;
			
			//var url:String=File(shotListData.getItemAt(shotListView.selectedIndex)["file"]).nativePath+"/takes/"+takeCreationInput.text;
			var takesFolder:File=new File(diskPathProxy.takeFolderPath);
			takesFolder.createDirectory();
			
			var takeSourceFolder:File= new File(diskPathProxy.takeSourceFolderPath);
			takeSourceFolder.createDirectory();
			
			var takeJPGFolder:File= new File(diskPathProxy.takeJPGFolderPath);
			takeJPGFolder.createDirectory();
			
			var takeThumbFolder:File= new File(diskPathProxy.takeThumbFolderPath);
			takeThumbFolder.createDirectory();
			
			var takePrevFolder:File= new File(diskPathProxy.takePrevFolderPath);
			takePrevFolder.createDirectory();
			
			var xml:XML = <timeline/>;
			xml.appendChild(<layer/>);
			
			var file:File = new File(diskPathProxy.timeFilePath);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(xml);
			stream.close();
			
			
			
			sendNotification(ProjectConstant.PROJECT_CREATE_TAKE_SUCCESS);
		}
	}
}