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
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * Encodes FLV's into a FileStream
	 */
	public class FileStreamFlvEncoder extends FlvEncoder
	{
		private var _file:File;
		private var _fileStream:ByteableFileStream;
		
		
		public function FileStreamFlvEncoder($file:File, $frameRate:Number)
		{
			_file = $file;
			super($frameRate);
		}
		
		public function get fileStream():FileStream
		{
			return _bytes as FileStream;
		}
		
		public function get file():File
		{
			return _file;
		}

		public override function kill():void
		{
			super.kill();
		}
		
		protected override function makeBytes():void
		{
			_bytes = new ByteableFileStream(_file);
			_fileStream = _bytes as ByteableFileStream;
		}
		
	}
}