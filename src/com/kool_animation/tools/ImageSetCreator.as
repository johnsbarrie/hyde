package com.kool_animation.tools {	
	import com.kool_animation.event.JPEGAsyncCompleteEvent;
	import com.kool_animation.model.ProjectProxy;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	public class ImageSetCreator extends EventDispatcher {
		
		public static const JPGCREATED_EVENT:String="JPGCREATED_EVENT";
		private var creationCounter:int=0;
		public var pngSrc:ByteArray;
		public var pngPrev:ByteArray;
		public var pngThumb:ByteArray;
		public var jpgSrc:ByteArray;
		private var progressSrc:Number=0;
		private var progressPrev:Number=0;
		private var progressThumb:Number=0;
		private var projectProxy:ProjectProxy;
		public function ImageSetCreator (projectProxy:ProjectProxy ) {
			this.projectProxy = projectProxy;
		}
		
		public function start(displayObject:DisplayObject):void {
			this.createPNG(displayObject, onSrcCreationProgress, onSrcCreationComplete, 1);
			
			/** PREVIEW scale */
			var scale:Number = Math.min(600.0/displayObject.width, 0.5);
			this.createPNG(displayObject, onPrevCreationProgress, onPrevCreationComplete, scale);
			
			/** THUMB scale */
			scale = 80.0/displayObject.width;
			this.createPNG(displayObject, onThumbCreationProgress, onThumbCreationComplete, scale);
			this.createJPG(displayObject, jpgEncodeProgress, jpgComplete, 1);
		}
		
		public function createPNG(displayObject:DisplayObject, progressCallback:Function, completeCallback:Function, scale:Number=1):void {
			// create bitmap at right size
			var viewBitmapData:BitmapData = new BitmapData(displayObject.width*scale,displayObject.height*scale);
			var matrix:Matrix = new Matrix();
			
			if(this.projectProxy.flippedHorizontal) { matrix.scale (-1, 1); }
			(this.projectProxy.flippedVertical) ? matrix.scale ( 1*scale, -1*scale) :  matrix.scale (1*scale, 1*scale);	
			
			if(this.projectProxy.flippedHorizontal) { matrix.translate (viewBitmapData.width, 0);	}
			if(this.projectProxy.flippedVertical) { matrix.translate (0, viewBitmapData.height);	}
			viewBitmapData.draw(displayObject, matrix);
			
			// Start asynchronous png creation
			var encoder:AsyncPNGEncoder = new AsyncPNGEncoder();			
			encoder.addEventListener(ProgressEvent.PROGRESS, progressCallback);
			encoder.addEventListener(Event.COMPLETE,completeCallback );
			encoder.encode(viewBitmapData);
		}
		
		public function createJPG(displayObject:DisplayObject, progressCallback:Function, completeCallback:Function, scale:Number=1):void{
			var viewBitmapData:BitmapData = new BitmapData(displayObject.width*scale,displayObject.height*scale);
			var matrix:Matrix = new Matrix();
			
			if(this.projectProxy.flippedHorizontal) { matrix.scale(-1,1); }
			(this.projectProxy.flippedVertical) ? matrix.scale(1*scale,-1*scale) :  matrix.scale(1*scale,1*scale);	
		
			if(this.projectProxy.flippedHorizontal) { matrix.translate(viewBitmapData.width,0);	}
			if(this.projectProxy.flippedVertical) { matrix.translate(0,viewBitmapData.height);	}
			
			viewBitmapData.draw (displayObject, matrix);
			
			var jpgEncoder:JPEGAsyncEncoder = new JPEGAsyncEncoder (75);
			jpgEncoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, jpgComplete);
			//jpgEncoder.addEventListener(ProgressEvent.PROGRESS, jpgEncodeProgress);
			jpgEncoder.encode(viewBitmapData);
		}
		
		// Encoding Progress
		private function onSrcCreationProgress(event:ProgressEvent):void {
			this.progressSrc=event.bytesLoaded/event.bytesTotal;
			totalProgress();
		}
		
		private function onPrevCreationProgress(event:ProgressEvent):void {
			this.progressPrev=event.bytesLoaded/event.bytesTotal;
			totalProgress();
		}
		
		private function onThumbCreationProgress(event:ProgressEvent):void {
			this.progressThumb=event.bytesLoaded/event.bytesTotal;
			totalProgress();
		}
		
		// Encodage finished
		private function onSrcCreationComplete(event:Event):void {
			pngSrc = (event.target as AsyncPNGEncoder).png;
			creationComplete();
		}
		
		private function onPrevCreationComplete(event:Event):void {
			pngPrev = (event.target as AsyncPNGEncoder).png;
			creationComplete();
		}
		
		private function onThumbCreationComplete(event:Event):void {
			pngThumb = (event.target as AsyncPNGEncoder).png;
			creationComplete();
		}
		// Encodage finished
		private function creationComplete():void {
			if (++creationCounter >= 3) {
				dispatchEvent(new Event(Event.COMPLETE));	
			}
		}
		
		private function jpgEncodeProgress(event:ProgressEvent):void {
			var percentage:String = ((event.bytesLoaded / event.bytesTotal)*100) + "%";
		}
		
		private function jpgComplete(event:JPEGAsyncCompleteEvent):void {
			jpgSrc = event.ImageData;
			dispatchEvent(new Event(JPGCREATED_EVENT));
		}
		
		private function totalProgress():void {
			var progress:Number = Math.floor((this.progressSrc + this.progressPrev + this.progressThumb)/3*100);
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, progress ,100));
		}
	}
}