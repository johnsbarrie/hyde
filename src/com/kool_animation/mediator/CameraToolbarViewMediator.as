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