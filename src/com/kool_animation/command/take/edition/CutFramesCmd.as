package com.kool_animation.command.take.edition
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.mediator.TakeTimelineMediator;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import flash.desktop.Clipboard;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CutFramesCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			sendNotification(ProjectConstant.ADD_HISTORY);
			var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var timeLineProxy:TakeTimeLineProxy= facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			
			//var currentIndex:int = timeLineProxy.currentIndex;
			
			if(timeLineMediator.selectedItems.length > 0){
				//trace("cuting "+timeLineMediator.selectedItems.length+" frames");
				// Réordonne la liste  d'indices dans  l'ordre croissant 
				timeLineMediator.selectedIndices.sort(sortingIndices);
				
				// recupere le premier index de la selection
				var firstIndex:int = timeLineMediator.selectedIndices[0];
				
				var list:Vector.<Object> = new Vector.<Object>();
				var nbObject:int = timeLineMediator.selectedIndices.length;
				for(var i:int =0; i < nbObject; i++){
					list.push(timeLineMediator.selectedItems[i]);
				}

				Clipboard.generalClipboard.setData("framesList", list, false);
				timeLineProxy.removeFrames(timeLineMediator.selectedIndices.concat());
			}
			else 
				Clipboard.generalClipboard.clear();
			
			// Mise a jour de la frame courante
			timeLineProxy.setCurrentFrame(firstIndex,true);
		}
		
	   final private function sortingIndices(a:Number, b:Number):int {
		      return (a==b ? 0 : (a < b) ? -1 : 1);
	    }

	}
}