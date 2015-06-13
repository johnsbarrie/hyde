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
package com.kool_animation.mediator {
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.event.ObjectEvent;
	import com.kool_animation.mxml.CameraToolbarView;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CameraToolbarViewMediator extends Mediator {
		public static const NAME:String	= "CameraToolbarViewMedaitor";
		
		public function CameraToolbarViewMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
			cameraToolbarView.addEventListener(CameraToolbarView.EVENT_CAMERA_CHANGED, cameraChanged);
		}
		
		public function cameraChanged(evt:ObjectEvent):void {
			sendNotification(ProjectConstant.CHANGE_CAMERA, evt.data.cameraNumber);
		}
		
		public function get cameraToolbarView():CameraToolbarView { return viewComponent as CameraToolbarView; }
	}
}