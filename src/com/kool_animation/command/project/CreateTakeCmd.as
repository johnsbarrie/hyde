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