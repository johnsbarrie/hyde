package com.kool_animation.model.vo
	
{
	import mx.collections.ArrayCollection;

	public class HistoryVO
	{
		private var _timelineFrames:ArrayCollection;
		private var _currentIndex:int;
		private var _selectedIndices:Vector.<int>
		
		public function HistoryVO (aTimelineFrames:ArrayCollection, aCurrentIndex:int, aSelectedIndices:Vector.<int>):void {
			_timelineFrames=aTimelineFrames;
			_currentIndex=aCurrentIndex;
			_selectedIndices=aSelectedIndices;
		}
		
		public function get timelineFrames():ArrayCollection {
			return _timelineFrames;
		}
		
		public function get currentIndex():int {
			return _currentIndex;
		}
		
		public function get selectedIndices():Vector.<int> {
			return _selectedIndices;
		}
	}
}