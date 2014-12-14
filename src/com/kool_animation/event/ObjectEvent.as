package com.kool_animation.event
{
	import flash.events.Event;
	
	public class ObjectEvent extends Event
	{
		public static var COMPLETE:String = "complete";
		
		public var data:Object;
		
		public function ObjectEvent(type:String, _data:Object)
		{
			data=_data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return new ObjectEvent(type, data);
		}
		
		override public function toString():String {
			return formatToString("ObjectEvent", "type", "_data");
		}
	}
}