package com.kool_animation.model
{	
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ProjectProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "ProjectProxy";// Nom du proxy
		private var _fps:Number;			// FrameRate du projet
		private var _imageHeight:int;		// Hauteur d'image du projet
		private var _imageWidth:int;		// Largeur d'image du projet
		private var _verticallyFlipped:Boolean=false;		// Cameraflipped and capture flipped vertically
		private var _horizontalFlipped:Boolean=false;		// Cameraflipped and capture flipped horizontally
		private var _modalWindowIsOpen:Boolean=false;
		
		private var _gridVisible:Boolean=false;		// Cameraflipped and capture flipped horizontally
		/*	Constructeur */
		public function ProjectProxy(data:Object=null) {
			super(NAME, data);
		}
		
		/* Accesseurs */
		public function get fps():Number { return _fps; }
		public function set fps(value:Number):void { 
			_fps = value; 
		}
		
		public function get modalWindowIsOpen ():Boolean { return _modalWindowIsOpen; }
		public function set modalWindowIsOpen (value:Boolean):void { 
			_modalWindowIsOpen = value; 
		}
		
		public function get imageHeight():int { return _imageHeight; }
		public function set imageHeight(value:int):void { _imageHeight = value; }
		public function get imageWidth():int { return _imageWidth; }
		public function set imageWidth(value:int):void { _imageWidth = value; }
		
		public function get flippedVertical():Boolean{ return _verticallyFlipped; }
		public function set flippedVertical(value:Boolean):void { _verticallyFlipped = value; }
		
		public function get flippedHorizontal():Boolean { return _horizontalFlipped; }
		public function set flippedHorizontal(value:Boolean):void { _horizontalFlipped = value; }
		
		public function get gridVisible ():Boolean { return _gridVisible; }
		public function set gridVisible (value:Boolean):void { _gridVisible = value; }	
	}
}