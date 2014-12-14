 package com.kool_animation.command.take.edition
{
	import com.kool_animation.mediator.NativeMenuMediator;
	import com.kool_animation.mediator.TakeTimelineMediator;
	
	import flash.desktop.Clipboard;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CopyFramesCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var timeLineMediator:TakeTimelineMediator = facade.retrieveMediator(TakeTimelineMediator.NAME) as TakeTimelineMediator;
			var nativeMenuMediator:NativeMenuMediator= facade.retrieveMediator(NativeMenuMediator.NAME) as NativeMenuMediator;
			if(timeLineMediator.selectedItems.length > 0){
				//trace("copying "+timeLineMediator.selectedItems.length+" frames");
				// Réordonne la liste  d'indices dans  l'ordre croissant 
				timeLineMediator.selectedIndices.sort(sortingIndices);
				var list:Vector.<Object> = new Vector.<Object>();
				var nbObject:int = timeLineMediator.selectedIndices.length;
				for(var i:int =0; i < nbObject; i++) {
					list.push(timeLineMediator.selectedItems[i]);
				}
				
				// Met la liste dans le clipBoard
				Clipboard.generalClipboard.setData("framesList", list, false);
				nativeMenuMediator.setPasteState(true);
			} else { 
				Clipboard.generalClipboard.clear();		
				nativeMenuMediator.setPasteState(false);
			}
		}
		
	   final private function sortingIndices(a:Number, b:Number):int {
		      return (a==b ? 0 : (a < b) ? -1 : 1);
	    }

	}
} 