package com.kool_animation.command.take.edition
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardTransferMode;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InvertedPasteFramesCmd extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void {
			
			sendNotification(ProjectConstant.ADD_HISTORY);
			var framesList:Vector.<Object> = Clipboard.generalClipboard.getData("framesList", ClipboardTransferMode.ORIGINAL_ONLY) as Vector.<Object>;
			
			if(framesList) {
				
				//trace("past inverted "+framesList.length+" frames");

				var selectList:Vector.<int> = new Vector.<int>();

				// On inverse le tableau car de base il est a l'envers
				var invertedFramesList:Vector.<Object> = framesList.concat();
				
				invertedFramesList = invertedFramesList.reverse();
				
				var timeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
				var frameIndice:int = timeLineProxy.currentIndex;

				for each (var frame:Object in invertedFramesList){
					frameIndice = timeLineProxy.addFrameAt(frame as FrameVO, frameIndice+1);
					selectList.push(frameIndice);
				}
				
				timeLineProxy.setCurrentFrame(frameIndice,true);				
				if(selectList.length > 1){
					var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
					timeLineMediator.selectedIndices = selectList;
				}


			}
		}
		
	}
}