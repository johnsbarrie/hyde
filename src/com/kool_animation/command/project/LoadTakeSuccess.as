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
package com.kool_animation.command.project {
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeViewMediator;
	import com.kool_animation.model.DiskPathsProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadTakeSuccess extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var diskPathsProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;			
			var takeViewMediator:TakeViewMediator= facade.retrieveMediator(TakeViewMediator.NAME) as TakeViewMediator;
			takeViewMediator.setTakeTitle(diskPathsProxy.projectName +" | "+ diskPathsProxy.shotName + " | " + diskPathsProxy.takeName);
			
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			nativeMenuMediator.takeOpenedState();
			var monitorMediator:MonitorMediator= facade.retrieveMediator(MonitorMediator.NAME) as MonitorMediator;
			if(!monitorMediator.cameraStarted){
				monitorMediator.connectCameraStream("0");
			}
			sendNotification(TakeConstant.GOTO_FIRST_FRAME);
			sendNotification(TakeConstant.SHOW_LIVE_VIDEO);
		}
	}
}