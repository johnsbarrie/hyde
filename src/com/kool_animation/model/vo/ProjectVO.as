package com.kool_animation.model.vo
{

	[Bindable]
	public class ProjectVO {
		private var _name:String;			// Nom du projet
		private var _uri:String;			// Chemin du projet
		private var _fps:Number;			// FrameRate du projet
		private var _imageHeight:int;		// Hauteur d'image du projet
		private var _imageWidth:int;		// Largeur d'image du projet
		/* Constructeur */
		public function ProjectVO(name:String, uri:String, fps:Number=12, height:int=40, width:int=100) {
			_name	= name;
			_fps	= fps;
			_imageHeight = height;
			_imageWidth = width;
		}
		
		/* Accesseurs */
		public function get name():String { return _name; }
		public function set name(name:String):void { _name = name; }
		public function get fps():Number { return _fps; }
		public function set fps(value:Number):void { _fps = value; }
		public function get imageHeight():int { return _imageHeight; }
		public function set imageHeight(value:int):void { _imageHeight = value; }
		public function get imageWidth():int { return _imageWidth; }
		public function set imageWidth(value:int):void { _imageWidth = value; }
		
	}
}