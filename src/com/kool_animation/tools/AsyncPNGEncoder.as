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
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	* Class that converts BitmapData into a valid PNG
	*/     
	public class AsyncPNGEncoder extends EventDispatcher
	{
		private var timer:Timer=new Timer(1, 1);
		private var IDAT:ByteArray = new ByteArray();
		private var currentLine:int;
		private var startTime:int = 0;
		private var maxTime:int = 40;
		private var img:BitmapData;
		public var png:ByteArray;
		
		function AsyncPNGEncoder(){
			timer.addEventListener(TimerEvent.TIMER, timerTicked);
		}
		
		/**
		 * Created a PNG image from the specified BitmapData
		 *
		 * @param image The BitmapData that will be converted into the PNG format.
		 * @return a ByteArray representing the PNG encoded image data.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */                     
		public function encode(image:BitmapData):void {
			img = image;
			// Create output byte array
			png = new ByteArray();
			// Write PNG signature
			png.writeUnsignedInt(0x89504e47);
			png.writeUnsignedInt(0x0D0A1A0A);
			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(img.width);
			IHDR.writeInt(img.height);
			IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
			IHDR.writeByte(0);
			writeChunk(png,0x49484452,IHDR);
			// Build IDAT chunk 
			
			// Initialisation des données
			startTime = getTimer();
			currentLine = 0;
			timer.start(); 
		}
		
		private function process():void{
			// Traite une ligne
			// no filter
			IDAT.writeByte(0);
			var p:uint;
			var j:int;
			if ( !img.transparent ) {
				for(j=0;j < img.width;j++) {
					p = img.getPixel(j,currentLine);
					IDAT.writeUnsignedInt(
						uint(((p&0xFFFFFF) << 8)|0xFF));
				}
			} else {
				for(j=0;j < img.width;j++) {
					p = img.getPixel32(j,currentLine);
					IDAT.writeUnsignedInt(
						uint(((p&0xFFFFFF) << 8)|
							(p>>>24)));
				}
			}
			
			// Si derniere ligne
			currentLine++;
			if (currentLine >= img.height){
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 80 ,100));
				compress();
			}
			else {
				// get currentTime   
				var currentTime:int = getTimer();     		
				if (currentTime-startTime < maxTime)
					process();
				else{
					dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, Math.floor(currentLine/img.height*80) ,100))	
					timer.start(); 
				}
				
			}
		}
		
		private function timerTicked(event:TimerEvent):void{
			timer.stop();
			timer.reset();
			startTime = getTimer();
			process();
		}	
		
		
		private function compress():void{
			IDAT.compress();
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 90 ,100));
			setTimeout(finishCompression,1);
		}
		
		private function finishCompression():void{
			writeChunk(png,0x49444154,IDAT);
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 100 ,100));
			setTimeout(writeData,1);
		}
		
		private function writeData():void{
			// Build IEND chunk
			writeChunk(png,0x49454E44,null);
			// Event fin de compression			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private var crcTable:Array;
		private var crcTableComputed:Boolean = false;
		
		
		// TODO, eventuellement ameliorable ici pour le coté asynchrone
		private function writeChunk(png:ByteArray, 
									type:uint, data:ByteArray):void {
			if (!crcTableComputed) {
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0; n < 256; n++) {
					c = n;
					for (var k:uint = 0; k < 8; k++) {
						if (c & 1) {
							c = uint(uint(0xedb88320) ^ 
								uint(c >>> 1));
						} else {
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			var len:uint = 0;
			if (data != null) {
				len = data.length;
			}
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			if ( data != null ) {
				png.writeBytes(data);
			}
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			for (var i:int = 0; i < (e-p); i++) {
				c = uint(crcTable[
					(c ^ png.readUnsignedByte()) & 
					uint(0xff)] ^ uint(c >>> 8));
			}
			c = uint(c^uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
	}
}
