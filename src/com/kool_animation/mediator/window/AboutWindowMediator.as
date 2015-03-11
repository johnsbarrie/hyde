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