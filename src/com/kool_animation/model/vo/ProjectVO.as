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