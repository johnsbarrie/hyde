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
package com.kool_animation.model.vo {
	import com.kool_animation.model.TimelineStatic;

	public class PreferencesVO {
		public var workspace:String;		// Chemin du workspace
		public var isFirstLaunch:Boolean;
		public var acceptAutomaticUpdates:Boolean;
		public var lastVersionFoundOnline:String;
		public var cameraID:int;					// Identifiant de la caméra utilisé
		public var cameraFPS:Number;				// FPS du flux camera
		public var alwaysAllowLiveView:Boolean;	// Flag de configuration permettant ou non d'afficher le flux camera a n'importe quel moment
		public var defaultFPS:Number;				// FPS par defaut de l'application
		public var defaultHeight:int;				// Hauteur par defaut des images
		public var defaultWidth:int;				// Largeur par defaut des images
		public var defaultThumbFileHeight:int;	// Hauteur des fichiers thumb
		public var defaultThumbFileWidth:int;		// Largeur des fichiers thumb
		public var language:String;
		public var playbackQuality:int;
		public var captureNumber:int;
		public var shortPlay:Boolean;
		
		public function PreferencesVO(){}
		
		public function toXML():XML{
			var xml:XML = <preferences/>;
			xml.workspace=workspace;
			xml.isFirstLaunch=isFirstLaunch;
			
			xml.acceptAutomaticUpdates=acceptAutomaticUpdates;
			xml.lastVersionFoundOnline=lastVersionFoundOnline;
			xml.cameraID=cameraID;
			xml.cameraFPS=cameraFPS
			xml.alwaysAllowLiveView=alwaysAllowLiveView;
			xml.defaultFPS=defaultFPS;
			xml.defaultHeight=defaultHeight;
			xml.defaultWidth=defaultWidth;
			xml.defaultThumbFileHeight=defaultThumbFileHeight
			xml.defaultThumbFileWidth=defaultThumbFileWidth;
			xml.language=language;
			xml.timelinethumbsize=TimelineStatic.timelineImageWidth;
			xml.playbackQuality=playbackQuality;
			xml.captureNumber=captureNumber;
			xml.shortPlay=shortPlay;
			return xml;
		}
	}
}