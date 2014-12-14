package com.kool_animation.command.take.edition {

	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InsertPhotoBucketFramesCmd extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			
			sendNotification(ProjectConstant.ADD_HISTORY);
			var framesList:Vector.<Object> =  notification.getBody() as Vector.<Object>;//Clipboard.generalClipboard.getData("framesList", ClipboardTransferMode.ORIGINAL_ONLY) as Vector.<Object>;
			
			if(framesList) {
				//trace("Import "+framesList.length+" frames");
				
				var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
				var frameIndice:int = timeLineProxy.currentIndex + 1;
				
				for each (var frame:Object in framesList){
					frameIndice = timeLineProxy.addFrameAt(frame as FrameVO, frameIndice );
				}
						
				sendNotification(TakeConstant.GOTO_FRAME, frameIndice - 1);
			}
		}
	}
}