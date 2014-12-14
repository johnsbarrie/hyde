package com.kool_animation.mediator.window
{
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainWindowMediator extends Mediator
	{
		public static const NAME:String			= "MainWindowMediator";
	
		public function MainWindowMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		public function get mainView():Hyde { return viewComponent as Hyde; }
	}
}