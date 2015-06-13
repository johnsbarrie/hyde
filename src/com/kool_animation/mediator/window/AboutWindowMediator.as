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
package com.kool_animation.mediator.window {
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mxml.window.AboutWindow;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AboutWindowMediator extends Mediator{
		protected var aboutWindow:AboutWindow;
		public static const NAME:String="AboutWindowMediator";
		
		public function AboutWindowMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super ( mediatorName, viewComponent );
			this.aboutWindow = new AboutWindow();
		}
		
		/* Liste des Notifications ecouté par le mediator */
		override public function listNotificationInterests ():Array {
			return [
				ProjectConstant.OPEN_ABOUT_WINDOW
			];
		}
		
		/* Gestion des Notifications */
		override public function handleNotification (notification:INotification):void {
			switch (notification.getName()) {
				case ProjectConstant.OPEN_ABOUT_WINDOW :	
					openWindow();
					break;
			}
		}
		
		private function openWindow ():void {
			this.aboutWindow.close();
			this.aboutWindow = new AboutWindow();
			this.aboutWindow.alwaysInFront = true;
			this.aboutWindow.open (true);
		}
	}
}