package com.kool_animation.model.vo {
	import com.kool_animation.model.TimelineStatic;

	public class PreferencesVO {
		
		public var workspace:String;		// Chemin du workspace
		public var isFirstLaunch:Boolean;
		public var acceptAutomaticUpdates:Boolean;
		public var cameraID:int;					// Identifiant de la caméra utilisé
		public var cameraFPS:Number;				// FPS du flux camera
		public var alwaysAllowLiveView:Boolean;	// Flag de configuration permettant ou non d'afficher le flux camera a n'importe quel moment
		public var defaultFPS:Number;				// FPS par defaut de l'application
		public var defaultHeight:int;				// Hauteur par defaut des images
		public var defaultWidth:int;				// Largeur par defaut des images
		public var defaultThumbFileHeight:int;	// Hauteur des fichiers thumb
		public var defaultThumbFileWidth:int;		// Largeur des fichiers thumb
		public var language:String;

		
		public function PreferencesVO(){}
		
		public function toXML():XML{
			var xml:XML = <preferences/>;
			xml.workspace=workspace;
			xml.isFirstLaunch=isFirstLaunch;
			xml.acceptAutomaticUpdates=acceptAutomaticUpdates;
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
			return xml;
		}
	}
}