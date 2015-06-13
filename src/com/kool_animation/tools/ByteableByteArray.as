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

package com.kool_animation.tools
{
	import flash.utils.ByteArray;

	public class ByteableByteArray extends ByteArray implements IByteable
	{
		public function ByteableByteArray()
		{
			super();
		}
		
		public function get canPosition():Boolean
		{
			return true;
		}

		public function get pos():Number
		{
			return this.position;
		}
		public function set pos($pos:Number):void
		{
			this.position = uint($pos);
		}
		
		public function get len():Number
		{
			return this.length;
		}
		public function set len($len:Number):void
		{
			this.length = uint($len);
		}
		
		public function kill():void
		{
			this.length = 0;
		}
	}
}
