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
package com.kool_animation.model.vo
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FrameFileVO extends EventDispatcher
	{
		public static const PHOTO_LOADED:String="photoloaded";
		public static const THUMB_LOADED:String="thumbloaded";
		
		private var thumbStream:FileStream;
		private var photoStream:FileStream;
		private var jpgStream:FileStream
		private var previewStream:FileStream;
		private var photoFile:File;
		private var jpgFile:File;
		private var thumbFile:File;
		private var previewFile:File;
		//private var photodata:ByteArray;
		//private var thumbdata:ByteArray;
		//private var previewdata:ByteArray;
		private var photoUrl:String;
	
		public function FrameFileVO(photoUrl:String, thumbUrl:String=null, previewUrl:String=null, jpgUrl:String=null) {
			//Create FILES
			this.photoUrl=photoUrl;
			photoFile=new File(photoUrl);
			photoStream = new FileStream();
			
			if (jpgUrl) {
				jpgFile = new File (jpgUrl);
				jpgStream = new FileStream();
			}
			
			if (thumbUrl) {
				thumbFile = new File(thumbUrl);
				thumbStream = new FileStream();
			}
			
			if (previewUrl) {
				previewFile = new File(previewUrl);
				previewStream = new FileStream();	
			}
		}
		
		public function get srcPhotoUrl():String{
			return photoUrl;
		}
		
		public function loadPreview():ByteArray {
			var previewdata:ByteArray= new ByteArray();
			// Patch retro compatibilité
			try {
				previewStream.open(previewFile, FileMode.READ);
			}
			catch(e:Error){
				previewStream.open(thumbFile, FileMode.READ);
			}
			previewStream.readBytes(previewdata);
			previewStream.close();
			
			return previewdata;
		}

		public function loadThumb():ByteArray {
			var thumbdata:ByteArray= new ByteArray();
			// Chargement de l'image thumb
			// thumbStream.addEventListener(Event.COMPLETE, thumbLoadedHandler);
			thumbStream.open(thumbFile, FileMode.READ);
			thumbStream.readBytes(thumbdata);
			thumbStream.close();
			return thumbdata;
		}
		
		public function loadPhoto():ByteArray {
			var photodata:ByteArray = new ByteArray();
			// Chargement de l'image fullSize
			//photoStream.addEventListener(Event.COMPLETE, photoLoadedHandler);
			photoStream.open/*Async*/(photoFile, FileMode.READ);
			photoStream.readBytes(photodata);
			photoStream.close();
			return photodata;
		}	
		
		public function savePhoto(byteArray:ByteArray):void{
			photoStream.open (photoFile, FileMode.WRITE);
			photoStream.writeBytes(byteArray, 0, byteArray.length);
			photoStream.close();
		}
		
		public function saveJpg (byteArray:ByteArray):void {
			jpgStream.open(jpgFile, FileMode.WRITE);
			jpgStream.writeBytes(byteArray, 0, byteArray.length);
			jpgStream.close();
		}
		
		public function saveThumb(byteArray:ByteArray):void{
			thumbStream.open(thumbFile, FileMode.WRITE);
			thumbStream.writeBytes(byteArray, 0, byteArray.length);
			thumbStream.close();
		}
		
		public function savePreview(byteArray:ByteArray):void{
			previewStream.open(previewFile, FileMode.WRITE);
			previewStream.writeBytes(byteArray, 0, byteArray.length);
			previewStream.close();
		}
	}
}