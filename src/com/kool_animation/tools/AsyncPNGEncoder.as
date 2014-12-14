
/*
Copyright (c) 2008, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.

* Neither the name of Adobe Systems Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
