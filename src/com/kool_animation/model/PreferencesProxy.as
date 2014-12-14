package com.kool_animation.model {
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.model.DiskPathsProxy;
	import com.kool_animation.model.vo.PreferencesVO;
	import com.kool_animation.tools.Primitive;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/* Préférences de l'application */
	public class PreferencesProxy extends Proxy implements IProxy {
		public static const NAME:String	= "PreferencesProxy";
		
		private var preferencesVO:PreferencesVO=new PreferencesVO();
		private var preferencesWriteStream:FileStream=new FileStream();
		private var preferencesStream:FileStream=new FileStream();
		
		/* Constructeur */
		public function PreferencesProxy(proxyName:String=NAME) {
			super(proxyName, null);
		}
		
		/* Chargement des préférences de l'application */
		public function loadPreferences():void {
			this.preferencesVO=preferencesVO;
			
			var file:File = File.applicationStorageDirectory.resolvePath(diskProxy.PREFERENCE_LIST_PATH);
			if( !file.exists ) {
				var xml:String = '<preferences/>';
				var xmlRoot:XML = new XML(xml);
				xmlRoot.appendChild(new XML("<workspace>"+File.documentsDirectory.nativePath+"/Hyde"+"</workspace>"));
				xmlRoot.appendChild(new XML("<isFirstLaunch>true</isFirstLaunch>"));
				xmlRoot.appendChild(new XML("<acceptAutomaticUpdates>true</acceptAutomaticUpdates>"));
				xmlRoot.appendChild(new XML("<defaultFPS>"+12.5+"</defaultFPS>"));
				xmlRoot.appendChild(new XML("<alwaysAllowLiveView>"+false+"</alwaysAllowLiveView>"));
				xmlRoot.appendChild(new XML("<defaultHeight>"+720+"</defaultHeight>"));
				xmlRoot.appendChild(new XML("<defaultWidth>"+1280+"</defaultWidth>"));	
				xmlRoot.appendChild(new XML("<cameraFPS>"+12+"</cameraFPS>"));
				xmlRoot.appendChild(new XML("<defaultThumbFileHeight>"+50+"</defaultThumbFileHeight>"));
				xmlRoot.appendChild(new XML("<defaultThumbFileWidth>"+80+"</defaultThumbFileWidth>"));
				xmlRoot.appendChild(new XML("<language>"+"en_US"+"</language>"));
				xmlRoot.appendChild(new XML("<timelinethumbsize>"+80+"</timelinethumbsize>"));
				
				preferencesWriteStream.open(file, FileMode.WRITE);
				preferencesWriteStream.writeUTFBytes(xmlRoot.toXMLString());
				preferencesWriteStream.close();
				
				var timer:Timer = new Timer(1000, 1);
				timer.addEventListener(TimerEvent.TIMER, onPreferencesWritten);
				timer.start();
				
			} else {
				readPreferenceFile();
			}
		}
		
		private function onPreferencesWritten (evt:Event):void{
			readPreferenceFile();
		}
		
		private function readPreferenceFile():void{
			var file:File = File.applicationStorageDirectory.resolvePath(diskProxy.PREFERENCE_LIST_PATH);
			
			preferencesStream.addEventListener(Event.COMPLETE, onPreferencesOpened);
			preferencesStream.addEventListener(IOErrorEvent.IO_ERROR, onPreferenceLoadingFailed);
			preferencesStream.openAsync(file, FileMode.READ);
		}
		
		public function onPreferencesOpened(evt:Event):void {
			var xml:XML = XML(preferencesStream.readUTFBytes(preferencesStream.bytesAvailable));
			preferencesVO.workspace=xml.workspace;
			
			xml.isFirstLaunch == "true" ? preferencesVO.isFirstLaunch =true : preferencesVO.isFirstLaunch =false; 
			xml.acceptAutomaticUpdates == "true" ? preferencesVO.acceptAutomaticUpdates =true : preferencesVO.acceptAutomaticUpdates =false;
			preferencesVO.defaultFPS = Number(xml.defaultFPS);
			preferencesVO.alwaysAllowLiveView = Primitive.stringToBoolean(xml.alwaysAllowLiveView);
			preferencesVO.cameraID = Number(xml.cameraID);
			preferencesVO.defaultHeight = Number(xml.defaultHeight);
			preferencesVO.defaultWidth = Number(xml.defaultWidth);
			preferencesVO.cameraFPS = Number(xml.cameraFPS);
			preferencesVO.defaultThumbFileHeight = Number(xml.defaultThumbFileHeight);
			preferencesVO.defaultThumbFileWidth = Number(xml.defaultThumbFileWidth);
			preferencesVO.language=xml.language;
			if(Number(xml.timelinethumbsize)!=0){
				TimelineStatic.timelineImageWidth=Number(xml.timelinethumbsize);
			}
			
			var projectHolder:File= new File (preferencesVO.workspace);
			if (!projectHolder.exists) {
				projectHolder.createDirectory();
			}
			
			var resourceManager:IResourceManager=AppFacade.getInstance().resourceManager;
			if (!projectHolder.isDirectory) {
				Alert.show(preferencesVO.workspace+resourceManager.getString('GUI_I18NS', 'should_be_a_directory'), resourceManager.getString('GUI_I18NS', 'project_path_problem'), Alert.OK);
			}
			
			if (workSpaceContainsOnlyProjects(preferencesVO.workspace)) {
				sendNotification(ProjectConstant.PREFERENCES_LOADED);	
			} else {
				sendNotification(ProjectConstant.OPEN_PREFERENCEWINDOW);	
				Alert.show(resourceManager.getString('GUI_I18NS', 'work_should_contain_only_our_projets'), resourceManager.getString('GUI_I18NS', 'work_space_nonconform'), Alert.OK);				
			}
		}
		
		private function workSpaceContainsOnlyProjects(newWorkSpace:String):Boolean{
			var workSpaceFolder:File = new File(newWorkSpace);
			if (workSpaceFolder.exists && workSpaceFolder.isDirectory){
				for each (var project:File in workSpaceFolder.getDirectoryListing()){
					if (project.name!=".DS_Store"){
						if (! new File(project.nativePath+"/project.apr").exists){
							return false;	
						}
					}
				}
				return true;
			}
			return false;
		}
		
		protected function onPreferenceLoadingFailed (event:Event):void { throw new Error("Erreur : Projectlist file not found"); }
		
		private function savePreference():void {
			var file:File = File.applicationStorageDirectory.resolvePath(diskProxy.PREFERENCE_LIST_PATH);
			preferencesStream.open(file, FileMode.WRITE);
			preferencesStream.writeUTFBytes(this.preferencesVO.toXML());
			preferencesStream.close();
		}
		
		/* GETTERS */
		public function set defaultFPS(value:Number):void { 
			preferencesVO.defaultFPS = value;
			savePreference();
		}
		
		public function set alwaysAllowLiveView(value:Boolean):void { 
			preferencesVO.alwaysAllowLiveView = value; 
			savePreference();
		}
		
		public function set cameraID(value:int):void {
			preferencesVO.cameraID = value; 
			savePreference();
		}
		
		public function set defaultHeight(value:int):void {
			preferencesVO.defaultHeight = value; 
			savePreference();
		}
		
		public function set defaultWidth(value:int):void { 
			preferencesVO.defaultWidth = value; 
			savePreference();
		}
		
		public function set timelineThumbSize(value:int):void{
			//nothing to do this has been stored on the timelinestatic class for the purposes of the timeline renderer
			savePreference();
		}
		
		public function setWorkspaceDirectory(value:String):Boolean {
			var projectHolder:File= new File(value);
			if(!projectHolder.exists) {
				projectHolder.createDirectory();
			}
			
			if(!projectHolder.isDirectory) {
				var resourcemanager :IResourceManager= AppFacade.getInstance().resourceManager;
				Alert.show(value+ " " + resourcemanager.getString('GUI_I18NS',"should_be_a_directory")+" !", resourcemanager.getString('GUI_I18NS',"project_path_problem"), Alert.OK);
				return false;
			}
			if(workSpaceContainsOnlyProjects(value)){
				preferencesVO.workspace = value;
				savePreference();
			}else{
				var resourceManager:IResourceManager=AppFacade.getInstance().resourceManager;
				Alert.show(resourceManager.getString('GUI_I18NS', 'work_should_contain_only_our_projets'), resourceManager.getString('GUI_I18NS', 'work_space_nonconform'), Alert.OK);
				return false;
			}
			return true;
		}
		
		public function set cameraFPS(value:Number):void { 
			preferencesVO.cameraFPS = value; 
			savePreference();
		}

		public function set defaultThumbFileHeight(value:int):void {	
			preferencesVO.defaultThumbFileHeight = value; 
			savePreference();
		}

		public function set defaultThumbFileWidth(value:int):void { 
			preferencesVO.defaultThumbFileWidth = value; 
			savePreference();
		}
		
		public function set language(lang:String):void{
			preferencesVO.language=lang;
			savePreference();
		}

		public function set isFirstLaunch (firstLaunch:Boolean):void{
			preferencesVO.isFirstLaunch=firstLaunch;
			savePreference();
		}
		
		public function get isFirstLaunch ():Boolean{
			return preferencesVO.isFirstLaunch;
		}
		
		public function set acceptAutomaticUpdates (acceptAutomaticUpdates:Boolean):void{
			preferencesVO.acceptAutomaticUpdates=acceptAutomaticUpdates;
			savePreference();
		}
		
		public function get acceptAutomaticUpdates ():Boolean{
			return preferencesVO.acceptAutomaticUpdates;
		}
		/* GETTERS */
		public function get defaultThumbFileWidth():int { return preferencesVO.defaultThumbFileWidth; }
		public function get defaultThumbFileHeight():int { return preferencesVO.defaultThumbFileHeight; }
		public function get cameraFPS():Number {
			var fps:Number=preferencesVO.cameraFPS;
			if(isNaN(fps)){
				fps=12;
			}
			
			return fps; 
		}
		public function get workspaceDirectory():String { 
			return preferencesVO.workspace; 
		}
		public function get defaultWidth():int { return preferencesVO.defaultWidth; }
		public function get defaultHeight():int { return preferencesVO.defaultHeight; }
		public function get cameraID():int { return preferencesVO.cameraID; }
		public function get defaultFPS():Number { return preferencesVO.defaultFPS; }
		public function get alwaysAllowLiveView():Boolean { return preferencesVO.alwaysAllowLiveView; }
		public function get language():String { return preferencesVO.language; }
		
		public function get diskProxy():DiskPathsProxy {
			return facade.retrieveProxy(DiskPathsProxy.NAME) as DiskPathsProxy;;
		}
	}
}