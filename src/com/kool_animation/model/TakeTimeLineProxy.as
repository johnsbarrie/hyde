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
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.event.JJTimerEvent;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class TakeTimeLineProxy extends AbstractTimeLineProxy {
		public static const NAME:String = "TakeTimeLineProxy";		// Nom du proxy
		public var includeLiveView:Boolean=true;
		
		private var skippedCurrentFrameForLive:Boolean;
		/* Constructeur */
		public function TakeTimeLineProxy(proxyName:String=NAME, data:Object=null) {
			super(proxyName, data);
		}
		
		/* Gestion des tick d'horloge de la timeline */
		override protected function onTimerTick(te:JJTimerEvent):void {
			if (currentIndex + 1 < _frames.length) {
				setCurrentFrame (currentIndex+1);
			}else if (currentIndex + 1==_frames.length && includeLiveView && !skippedCurrentFrameForLive) {
				sendNotification (TakeConstant.SHOW_LIVE_VIDEO);
				skippedCurrentFrameForLive=true;
				setCurrentFrame (currentIndex + 1);
		    } else {
				skippedCurrentFrameForLive=false;
				if (this._loop) {
					currentIndex = 0;
					sendNotification (TakeConstant.HIDE_LIVE_VIDEO);
					setCurrentFrame (currentIndex);
				} else {
					setCurrentFrame (currentIndex);
					sendNotification (TakeConstant.TRANSPORT_STOP);
				}
				_timer.reset();
			}
		}
		
		override public function play():void{
			skippedCurrentFrameForLive=false;
			super.play();
			soundProxy.play();
		}
		
		override public function stop():void{
			soundProxy.stop();
			super.stop();
		}
		
		public function flushMemory():void{
			if(_frames.length>50){
				for(var i:int=0; i<(_frames.length-50); i++){
					var frameVO:FrameVO=_frames.getItemAt(i) as FrameVO;
					if (i!=currentIndex&& i!=currentIndex-1) {
						frameVO.flushMemory();
					}
				}
			}
		}
		
		public function playBackFlush():void{
			if(currentIndex>10){
				for(var i:int=0; i<(currentIndex-40); i++){
					var frameVO:FrameVO=_frames.getItemAt(i) as FrameVO;
					frameVO.flushMemory();
				}
			}
		}
		
		/* Recupère la frame a l'index souhaité */
		public function getFrame(index:int):FrameVO {
			try {
				return  _frames.getItemAt(index) as FrameVO;
			} catch(error:Error) { }
			return null;
		}
		
		/* Ajoute une frame en fin de liste */
		public function addFrame(frame:FrameVO, number:int = 1):int {
			for (var i:int = 0; i<number; i++)
				_frames.addItem(frame);
			recordTakeToDisk();
			
			return _frames.length -1; // renvoyer l'indice
		}

		/* Insert une frame dans la liste */
		public function addFrameAt(frame:FrameVO, indice:int):int {
			if(indice >= _frames.length)
				return addFrame(frame);
			_frames.addItemAt(frame, indice);
			recordTakeToDisk();
			return indice;
		}
		
		/* Supprime la liste de frames ciblés */
		public function removeFrames(indices:Vector.<int>):void {
			var revertedIndices:Vector.<int> = indices.concat(); // reclasse les indices du plus gros au plus petit pour eviter les blagues 
			revertedIndices = revertedIndices.sort(Array.NUMERIC | Array.DESCENDING);
			for(var i:int=0; i<revertedIndices.length; i++){
				_frames.removeItemAt(revertedIndices[i]);
			}
			recordTakeToDisk();
		}
		
		final protected function recordTakeToDisk():void {
			var xml:XML = <timeline/>;
			xml.appendChild(<layer/>);
			var lostAllFrames:Boolean=true;
			for each (var frameVO:FrameVO in _frames){
				lostAllFrames=false;
				var node:XML=new XML('<image id="'+frameVO.id+'"/>');
				xml.layer.appendChild(node);
			}
			
			if ( lostAllFrames ){ /**throw new Error("lost all frames");	*/}
			
			var diskPathsProxy:DiskPathsProxy= facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;
			var file:File=new File(diskPathsProxy.timeFilePath)
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(xml);
			stream.close();
		}
		
		final override protected function currentFrameChanged(index:int):void{ 
			sendNotification(TakeConstant.CURRENT_FRAME_CHANGED, index);
		}
		
		final override protected function gotoFirstFrame():void{
			sendNotification(TakeConstant.GOTO_FIRST_FRAME, _frames);
		}
		
		public function get soundProxy():SoundProxy {
			return facade.retrieveProxy(SoundProxy.NAME) as SoundProxy;;
		}
	}
}