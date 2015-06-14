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
package com.kool_animation.model
{
	import com.kool_animation.model.vo.FrameFileVO;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.graphics.BitmapSmoothingQuality;
	
	import spark.primitives.BitmapImage;

	[Bindable]
	public class FrameVO extends EventDispatcher
	{
		public static const EMPTY_FRAME:String="EMPTYFRAME";
		public static const FRAME_LOADED:String="frame_loaded";
		public static const THUMB_LOADED:String="thumb_loaded";
		
		private var _id:String;
		private var _fileFrameService:FrameFileVO;
		
		private var _view:BitmapImage;
		private var _preView:BitmapImage;
		private var _jpgView:BitmapImage;
		private var _thumb:BitmapImage; 
		private var photoData:ByteArray;
		private var thumbData:ByteArray;
		
		//public var isLoaded:Boolean;
		
		public function FrameVO(id:String, fileFrameService:FrameFileVO=null) {
			this._view = new BitmapImage();
			this._thumb = new BitmapImage();
			this._jpgView= new BitmapImage();
			this._preView = new BitmapImage();
			if(id==EMPTY_FRAME) {
				this._preView.source= new BitmapData(400, 240, false , 0);
			}
			this._id=id;
			this._fileFrameService= fileFrameService;
		}
		
		public function get srcPhotoUrl():String {
			return this._fileFrameService.srcPhotoUrl;
		}
		
		public function set frameFileService(frameFileService:FrameFileVO):void{
			this._fileFrameService=frameFileService;
		}
		
		public function makeViewImage(data:ByteArray):void {
			_view.source	 			= data;
		}
		
		public function makeThumbImage(data:ByteArray):void{
			_thumb.source 				= data
		}
		public function makePreviewImage(data:ByteArray):void{
			_preView.source	 			= data;
		}
		
		public function makeJpgImage(data:ByteArray):void{
			_jpgView.source	 			= data;
		}
		/*
		private function loadPreviewFromFile():void {
			if( thumbData == null)
				thumbData=_fileFrameService.loadThumb();
			makePreviewImage(thumbData);
		}

		private function loadThumbFromFile():void {
			if( thumbData == null)
				thumbData=_fileFrameService.loadThumb();

			// Création d'un fileStream
			makeThumbImage(thumbData);
		}
		
		private function loadViewFromFile():void {
			// Création d'un fileStream
			if (photoData == null)
				photoData=_fileFrameService.loadPhoto();
			
			makeViewImage(photoData);
		}
		*/	
		public function save():void{
			_fileFrameService.saveThumb(_thumb.source as ByteArray);
			_fileFrameService.savePhoto(_view.source as ByteArray);
			_fileFrameService.savePreview(_preView.source as ByteArray);
		}
		
		public function saveJpg():void{
			if (_jpgView.source){
				_fileFrameService.saveJpg(_jpgView.source as ByteArray);
			}
		}
		
		/* Accesseurs */
		public function get id():String { return _id; }
		public function get view():BitmapImage {
			if (_view.source == null){
				_view.source = _fileFrameService.loadPhoto();
				_view.smooth=true;
				_view.smoothingQuality=BitmapSmoothingQuality.HIGH;
			}
			return _view;
		}
		
		public function get viewByteArray():ByteArray {
			var imageByteArray:ByteArray;
			//make sure that the photo has been loaded
			if(id!=EMPTY_FRAME){
				this.view;
				imageByteArray = _view.source as ByteArray;
			}
			
			//return the photo byteArray
			return imageByteArray;
		}

		public function get thumb():BitmapImage {
			if (_thumb.source == null){
				_thumb.source = _fileFrameService.loadThumb();
			}
			return _thumb;
		}
		
		public function get preView():BitmapImage {
			
			if (_preView.source == null&& _fileFrameService){
					_preView.source = _fileFrameService.loadPreview();
					//_preView.smooth=true;
					//_preView.smoothingQuality=BitmapSmoothingQuality.HIGH;
			}
			return _preView;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function set thumb(value:BitmapImage):void {
			// do nothing, it's just to avoid warning on bind with interface timeline list
		}
		
		public function flushMemory():void{
			_view.source=null;
			_preView.source	=null;
			_thumb.source	=null;
		}
		
		public function flushJpgMemory():void{
			_jpgView.source=null;		
		}
		
		
	}
}