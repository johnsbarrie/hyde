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
package com.kool_animation.model {
	import com.kool_animation.tools.Primitive;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SoundProxy extends Proxy implements IProxy {
		public static const NAME:String="SoundProxy";
		public var sound:Sound;
		private var soundChannel:SoundChannel;
		private var soundName:String;
		private var soundxml:XML
		
		public function SoundProxy ( proxyName:String=NAME, data:Object=null ) {
			super (proxyName, data);
		}
		
		public function play():void {
			if ( sound ) {
				soundChannel = sound.play((takeProxy.currentIndex/takeProxy.fps)*1000);
			}
		}
		
		public function stop():void {
			if ( sound && soundChannel ) {
				soundChannel.stop();
			}
		}
		
		public function addSound(name:String):void {
			this.soundName = name;
			var soundnode:XML=soundxml.channels.sound[0];
			if ( !soundnode ) {
				soundnode=<sound/>;
				XML(soundxml.channels).appendChild(soundnode);
			}
			soundnode.@filename=name;
			recordSoundXMLToFile();
			loadSound();
		}
		
		public function loadSound():void {
			if (this.soundName) {
				sound = new Sound();
				var path:String = diskPathsProxy.soundFolderPath+"/"+this.soundName;
				var soundFile:File = new File(path);
			
				if ( Primitive.os() == Primitive.MAC ) { path="file:/"+path; }
				if ( soundFile.exists ) { sound.load( new URLRequest(path) ); }
			}
		}
		
		public function loadSoundFromFile():void {
			this.soundName=null;
			this.sound=null;
			var soundListFile:File=new File(diskPathsProxy.soundFilePath);
			if (!soundListFile.exists) {
				//create soundfile
				var xml:XML = <sounds/>;
				xml.appendChild(<channels/>);
				var stream:FileStream = new FileStream();
				stream.open(soundListFile, FileMode.WRITE);
				stream.writeUTFBytes(xml);
				stream.close();
			}
			
			var soundXmlStream:FileStream = new FileStream();
			soundXmlStream.open(soundListFile, FileMode.READ);
			soundxml = XML(soundXmlStream.readUTFBytes(soundXmlStream.bytesAvailable));
			soundXmlStream.close();
			if(soundxml.channels.sound) {
				var soundnode:XML=soundxml.channels.sound[0];
				if(soundnode){
					this.soundName = soundnode.@filename;
				}
			}
			
			loadSound();
		}
		
		private function recordSoundXMLToFile():void {
			var soundListFile:File=new File(diskPathsProxy.soundFilePath);
			var stream:FileStream = new FileStream();
			stream.open(soundListFile, FileMode.WRITE);
			stream.writeUTFBytes(soundxml);
			stream.close();
		}
		
		public function get diskPathsProxy ():DiskPathsProxy { return facade.retrieveProxy (DiskPathsProxy.NAME) as DiskPathsProxy;; }
		public function get takeProxy ():TakeTimeLineProxy { return facade.retrieveProxy (TakeTimeLineProxy.NAME) as TakeTimeLineProxy;; }
	}
}