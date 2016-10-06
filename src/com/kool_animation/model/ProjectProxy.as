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