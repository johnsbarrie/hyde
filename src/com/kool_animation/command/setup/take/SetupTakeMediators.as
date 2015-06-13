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
package com.kool_animation.command.setup.take {
	import com.kool_animation.mediator.CameraToolbarViewMediator;
	import com.kool_animation.mediator.EditionToolbarViewMediator;
	import com.kool_animation.mediator.LiveViewBarMediator;
	import com.kool_animation.mediator.MonitorMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.mediator.TakeViewMediator;
	import com.kool_animation.mediator.TransportMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupTakeMediators extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			var hydeMainWindow:Hyde = notification.getBody() as Hyde;
			
			facade.registerMediator(new TakeViewMediator(hydeMainWindow.takeView));
			facade.registerMediator(new TakeTimelineMediator(hydeMainWindow.takeView.timelineView));
			facade.registerMediator(new MonitorMediator(hydeMainWindow.takeView.monitorView));
			facade.registerMediator(new TransportMediator(hydeMainWindow.takeView.transportView));
			facade.registerMediator(new LiveViewBarMediator(hydeMainWindow.takeView.liveViewBar));
			facade.registerMediator(new EditionToolbarViewMediator(hydeMainWindow.takeView.editionToolbarView));
			facade.registerMediator(new CameraToolbarViewMediator(hydeMainWindow.takeView.cameraToolbarView));
		}
	}
}