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