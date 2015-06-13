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

package com.kool_animation.tools {
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	/**
	 * IBytes allows FlvEncoder to do byte operations on either a ByteArray or a FileStream instance,
	 * without explicitly typing to either.
	 * 
	 * But must be used with an instance of "ByteArrayWrapper" or "FileStreamWrapper" rather than
	 * ByteArray or FileStream directly.
	 * 
	 * "position" has a different signature in ByteArray versus FileStream (uint versus Number),   
	 *	so it gets wrapped with the getter/setter "pos"
	 * 
	 * "length" also needs to values > 2^32 so same treatment applies 
	 */
	public interface IByteable extends IDataInput, IDataOutput
	{
		function get pos():Number;
		function set pos($n:Number):void;

		function get len():Number;
		
		function kill():void;
	}
}
