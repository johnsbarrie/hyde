package com.kool_animation.command.take {
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.model.TimelineStatic;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class TimelineZoomInCmd extends SimpleCommand {
		override public function execute (notification:INotification):void {
			if ( TimelineStatic.timelineImageWidth <= 130 ) {
				TimelineStatic.timelineImageWidth = TimelineStatic.timelineImageWidth+10;
				
				var preferencesProxy:PreferencesProxy= facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
				preferencesProxy.timelineThumbSize=TimelineStatic.timelineImageWidth;
				sendNotification(TakeConstant.TIMELINE_ZOOMED_IN);
			}
		}
	}
}