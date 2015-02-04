package com.kool_animation.mediator
{
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mxml.TimelineView;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TakeTimelineMediator extends Mediator
	{
		public static const NAME:String			= "timeLineMediator";
		private var spaceBarPressed:Boolean = false;
		public var _frameArrayCollection:ArrayCollection;
		
		public function TakeTimelineMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			timelineView.addEventListener(TimelineView.EVENT_SELECT_FRAME_CHANGED, onCurrentFrameChanged);
			timelineView.addEventListener(TimelineView.EVENT_COPY, onCopy);
			timelineView.addEventListener(TimelineView.EVENT_CUT, onCut);
			timelineView.addEventListener(TimelineView.EVENT_DELETE, onDelete);
			//timelineView.addEventListener(TimelineView.EVENT_IMPORT, onImport);
			timelineView.addEventListener(TimelineView.EVENT_PASTE_BEFORE, onPasteBefore);
			timelineView.addEventListener(TimelineView.EVENT_PASTE_AFTER, onPasteAfter);
			timelineView.addEventListener(TimelineView.EVENT_REVERSE_PASTE, onReversePaste);
			timelineView.addEventListener(TimelineView.EVENT_REVERSE, onReverse);
			timelineView.addEventListener(TimelineView.EVENT_DUPLICATE, onDuplicate);
		}
		
		/* Liste des notifications prises en compte par ce mediator */
		override public function listNotificationInterests():Array
		{
			return [
				TakeConstant.LOAD_FRAMES,
				TakeConstant.LOAD_FRAMES_SUCCESS,
				TakeConstant.CAPTURE_FRAMES_SUCCESS,
				TakeConstant.CURRENT_FRAME_CHANGED,
				TakeConstant.TIMELINE_ZOOMED_IN,
				TakeConstant.TIMELINE_ZOOMED_OUT
			];
		}
		
		/* Gestion des notifiactions de l'application */
		override public function handleNotification(note:INotification):void {
			var name:String = note.getName();
			switch(name) {
				case TakeConstant.CAPTURE_FRAMES_SUCCESS:
					//	sendNotification(AppFacade.GOTO_LAST_FRAME);
					break;
				case TakeConstant.CURRENT_FRAME_CHANGED:
					changeFrame(note.getBody() as int);
					break;
				case TakeConstant.TIMELINE_ZOOMED_OUT :
				case TakeConstant.TIMELINE_ZOOMED_IN :
					timelineView.refresh();
					break;
			}
		}
		
		/* Mise a jour de la liste des Thumb */
		public function set frameArrayCollection(frameArrayCollection:ArrayCollection):void {	
			this._frameArrayCollection=frameArrayCollection;
			//list est une référence direct au data du proxy, donc
			//tout ajout de vue dans le proxy est répercuté dans le dataViewsList.
			timelineView.frameArrayCollection=frameArrayCollection;
		}
		
		/* Gestion d'une notification de changement du thumb selectionné */
		private function changeFrame(index:int):void { 
			setTimeout(updatePosition,1,index);
		}
		
		/* Mise a jour de la position de la timeline */
		private function updatePosition(index:int):void{
			if(index>=0){
				timelineView.list.ensureIndexIsVisible(index);
				timelineView.list.selectedIndex = index;
				timelineView.list.setFocus();
			}
		}
		
		public function updateSelectedIndices(selectList:Vector.<int>):void {
			timelineView.list.selectedIndices = selectList;
			if(selectList[0]+1<timelineView.list.dataProvider.length){
				timelineView.list.ensureIndexIsVisible(selectList[0]+1);
			}else{
				timelineView.list.ensureIndexIsVisible(selectList[0]);
			}
		}
		
		public function set selectedIndices ( selectList:Vector.<int> ):void {
			setTimeout(updateSelectedIndices,1,selectList);
		}
		
		/* Gestion des evenements UI */
		private function onCopy(e:Event):void { sendNotification(TakeConstant.COPY_FRAMES); }
		private function onPasteBefore(e:Event):void { sendNotification(TakeConstant.PASTE_FRAMES_BEFORE); }
		private function onPasteAfter(e:Event):void { sendNotification(TakeConstant.PASTE_FRAMES_AFTER); }
		private function onCut(e:Event):void { sendNotification(TakeConstant.CUT_FRAMES); }
		private function onDelete(e:Event):void { sendNotification(TakeConstant.DELETE_FRAMES); }
		private function onReverse(e:Event):void { sendNotification(TakeConstant.REVERSE_FRAMES); }
		private function onReversePaste(e:Event):void { sendNotification(TakeConstant.PASTE_INVERTED_FRAMES) }
		private function onImport(e:Event):void { sendNotification(TakeConstant.IMPORT_IMAGE); }
		private function onDuplicate(e:Event):void { sendNotification(TakeConstant.DUPLICATE_FRAMES); }
		
		private function onCurrentFrameChanged(e:Event):void {  
			sendNotification(TakeConstant.TAKETIMELINEMEDIATOR_FRAME_CHANGED, timelineView.list.selectedIndex); 
		}
		
		/* Accesseurs */
		public function get timelineView():TimelineView {	return viewComponent as TimelineView; }
		public function get selectedItems():Vector.<Object> {	return timelineView.list.selectedItems; }
		public function get selectedIndices():Vector.<int> { return timelineView.list.selectedIndices; }
	}
}