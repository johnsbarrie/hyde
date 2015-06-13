/**
 Hyde Stop Motion
 An Animation Film Software
 Copyright (c) 2015 lamenagerie.
 Conceived by Kolja Saksida and John Barrie 
 Coded by John Barrie  
 Further help by Xavier Boisnon
    Graphism and Icons by Roland Chenel, John Barrie \n Logo Jaro Jelovac
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU LESSER GENERAL PUBLIC LICENSE for more details.
 
 You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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