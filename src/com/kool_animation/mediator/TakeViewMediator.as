package com.kool_animation.mediator
{
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mxml.TakeView;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TakeViewMediator extends Mediator
	{
		public static const NAME:String="TakeViewMediator";

		public function TakeViewMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			takeView.addEventListener(TakeView.EVENT_ZOOM_IN, zoomIn);
			takeView.addEventListener(TakeView.EVENT_ZOOM_OUT, zoomOut);
			takeView.addEventListener(TakeView.EVENT_IMPORT_SOUND, importSound);
		}
				
		private function zoomIn(evt:Event):void{
			sendNotification(TakeConstant.TIMELINE_ZOOM_IN);
		}
		
		private function zoomOut(evt:Event):void{
			sendNotification(TakeConstant.TIMELINE_ZOOM_OUT);
		}
		
		public function resizeMonitor(ratio:Number):void {
			viewComponent.ratio = ratio;
			takeView.resizeMonitor();
		}
		
		public function fullscreen():void {
			takeView.setUpForFullScreen();
		}
		
		public function leavefullscreen():void{
			takeView.leavefullscreen();
		}
		
		public function setTakeTitle(title:String):void{
			takeView.title_info.text=title;
		}
		
		public function importSound(evt:Event):void{
			sendNotification(TakeConstant.IMPORT_SOUND);
		}
		
		public function get takeView():TakeView{ return viewComponent as TakeView; }
	}
}