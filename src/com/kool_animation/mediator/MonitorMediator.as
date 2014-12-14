package com.kool_animation.mediator
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mediator.TakeViewMediator;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.ProjectProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.mxml.MonitorView;
	
	import flash.events.Event;
	import flash.media.Camera;
	import flash.utils.flash_proxy;
	
	import mx.controls.Alert;
	
	import spark.components.VideoDisplay;
	import spark.components.mediaClasses.DynamicStreamingVideoItem;
	import spark.components.mediaClasses.DynamicStreamingVideoSource;
	import spark.events.ElementExistenceEvent;
	
	import org.osmf.net.StreamType;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MonitorMediator extends Mediator
	{
		public static const NAME:String			= "monitorMediator";
		public static const QUALITY_DRAFT:int		= 1;
		public static const QUALITY_PREVIEW:int		= 2;
		public static const QUALITY_FULL:int		= 3;
		private var _timeLineProxy:TakeTimeLineProxy;  			// Proxy de la time line
		private var _projectProxy:ProjectProxy;
		private var _preferencesProxy:PreferencesProxy;		// proxy des preferences
		private var _cameraFlux:Camera;						// Flux video camera
		private var _videoDisplay:VideoDisplay;				// Un video display a la taille original pour les screen shoots
		public var _quality:int;
		public var cameraStarted:Boolean;
		
		/* Constructeur */
		public function MonitorMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
			monitorView.liveContainer.visible = true;
		}
		
		/* Liste des notifications écoutés */
		override public function listNotificationInterests():Array {
			return [
				ProjectConstant.PROJECT_LOAD_TAKE_SUCCESS,
				TakeConstant.ONIONSKIN_ALPHA_VALUE_CHANGE,
				TakeConstant.TRANSPORT_PLAY,
				TakeConstant.TRANSPORT_STOP,
				TakeConstant.TRANSPORT_SWITCH_PLAY,
				TakeConstant.TRANSPORT_PREPARE_TO_PLAY,
				TakeConstant.TOGGLE_VERTICAL_FLIPPED,
				TakeConstant.TOGGLE_HORIZONTAL_FLIPPED,
				TakeConstant.GRID_TOGGLED,
				ProjectConstant.FULLSCREEN_ENTERED,
				ProjectConstant.FULLSCREEN_LEFT
			];
		}
		
		/* Gestion des notifications de l'application */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case TakeConstant.ONIONSKIN_ALPHA_VALUE_CHANGE:
					onionAlphaChange(Number(note.getBody()) as Number);
					break;
				case TakeConstant.TRANSPORT_PLAY:
					showFrame(timeLineProxy.currentIndex, QUALITY_PREVIEW);
					break;
				case TakeConstant.TRANSPORT_SWITCH_PLAY:
				case TakeConstant.TRANSPORT_STOP:
					cleanMonitor();
					if (timeLineProxy.isPlaying)
						showFrame(timeLineProxy.currentIndex, QUALITY_PREVIEW);
					else
						showFrame(timeLineProxy.currentIndex, QUALITY_FULL);
					break;
				case TakeConstant.TRANSPORT_PREPARE_TO_PLAY :
					cleanMonitor();
					showFrame(0, QUALITY_PREVIEW);
					break;
				case ProjectConstant.PROJECT_LOAD_TAKE_SUCCESS:
					var takeViewMediator:TakeViewMediator = facade.retrieveMediator(TakeViewMediator.NAME) as TakeViewMediator;
					//takeViewMediator.resizeMonitor(Number(projectProxy.imageWidth)/Number(projectProxy.imageHeight));
					_quality = QUALITY_FULL;
					cleanMonitor();
					showFrame(timeLineProxy.currentIndex);
					break;
				case TakeConstant.TOGGLE_VERTICAL_FLIPPED :
				case TakeConstant.TOGGLE_HORIZONTAL_FLIPPED :
					updateFlips();
					break;
				case TakeConstant.GRID_TOGGLED :
					monitorView.gridToggled(this.projectProxy.gridVisible);
					break;
				case ProjectConstant.FULLSCREEN_ENTERED :
				case ProjectConstant.FULLSCREEN_LEFT :
					monitorView.fullscreenChanged();
					sendNotification(AppFacade.DEBUG, "montorView "+ monitorView.frameHolder.width+ " holder "+ monitorView.width);
					break;
			}
		}
		
		/* Connection du flux camera */
		public function connectCameraStream(index:String):void {
			// Envoi a la vue l'index de la camera
			_cameraFlux = Camera.getCamera(index);
			
			if (_cameraFlux) {
				cameraStarted=true;
				_cameraFlux.setMode (1280, 720, preferencesProxy.cameraFPS, true);
				_cameraFlux.setQuality (0,100);	// Fixe la priorité a une qualité maximum sans limite de bande passante
				
				var dynVideoSource:DynamicStreamingVideoSource=new DynamicStreamingVideoSource();
				
			    var videoItems:Vector.<DynamicStreamingVideoItem>;
			    videoItems=new Vector.<DynamicStreamingVideoItem>();
			    videoItems[0]=new DynamicStreamingVideoItem();
				
			    dynVideoSource.host= "";
			    dynVideoSource.streamType=StreamType.LIVE;
			    dynVideoSource.streamItems=videoItems;
				
			    monitorView.videoDisplay.source=dynVideoSource;
				monitorView.addEventListener(Event.RESIZE, updateGUI);
				monitorView.videoDisplay.videoObject.attachCamera(_cameraFlux);
				
				updateFlips();
			}
		}
		
		private function updateGUI(evt:Event):void {
			updateFlips();
		}
		
		public function updateFlips():void{
			if (this.projectProxy.flippedHorizontal) {
				monitorView.scaleX = -1;
				monitorView.x = monitorView.width;
				monitorView.frameHolder.scaleX=-1;
				monitorView.frameHolder.x = monitorView.width;
			} else {
				monitorView.scaleX = 1;
				monitorView.x = 0;
				monitorView.frameHolder.scaleX=1;
				monitorView.x = 0;
				monitorView.frameHolder.x = 0;
			}
			
			if (this.projectProxy.flippedVertical) {
				monitorView.scaleY = -1;
				monitorView.y = monitorView.height;
				monitorView.frameHolder.scaleY=-1;
				monitorView.frameHolder.y = monitorView.height;
			} else {
				monitorView.scaleY = 1;
				monitorView.y = 0;
				monitorView.frameHolder.scaleY=1;
				monitorView.y = 0;
				monitorView.frameHolder.y = 0;
			}
		}
		
		/* Deconnection du flux camera */
		public function disconnectCameraStream():void {
			_cameraFlux=null;
			if(monitorView.videoDisplay.videoObject) {
				monitorView.videoDisplay.videoObject.attachCamera(null);
			}
		}				

		/* Affichage d'une frame sur le monitor */
		public function showFrame(index:int, forcedQuality:int = 0):void {
			var frame:FrameVO = timeLineProxy.getFrame(index);
			if (frame) {
				var quality:int = (forcedQuality) ? forcedQuality:_quality;
				monitorView.frameContainer.addEventListener(spark.events.ElementExistenceEvent.ELEMENT_ADD, onImageUpdated);
				
				if (timeLineProxy.isPlaying) {
					monitorView.frameContainer.addElement(frame.preView);
				} else {
					switch (quality){
						case QUALITY_DRAFT:
							monitorView.frameContainer.addElement(frame.thumb);
							break;
						case QUALITY_PREVIEW:
							monitorView.frameContainer.addElement(frame.preView);
							break;
						case QUALITY_FULL:
							monitorView.frameContainer.addElement(frame.view);
							break;
					}
				}
			}
			else {
				cleanMonitor();
			}
		} 
		
		/* Nouvelle image ajouté au moniteur */
		private function onImageUpdated(event:Event):void{
			monitorView.frameContainer.removeEventListener(spark.events.ElementExistenceEvent.ELEMENT_ADD, onImageUpdated);
			if (monitorView.frameContainer.numElements > 2){
				monitorView.frameContainer.removeElementAt(0);
			}
		}
		
		/* Nettoyage de toutes les frames du frameContainer non visible */
		private function cleanMonitor():void {
			monitorView.frameContainer.removeAllElements();
		}
		
		/* Fixe l'etat visible du monitoring live */
		public function setLiveVisible(state:Boolean):Boolean {
			return monitorView.liveContainer.visible = state;
		}
		
		private function onionAlphaChange(value:Number):void {
			var alpha:Number=value/100
			monitorView.liveContainer.alpha=value/100;
		}
		
		/* Getters */
		public function get isLiveVisible():Boolean { return monitorView.liveContainer.visible }
		
		public function get isCameraConnected ():Boolean {
			if (_cameraFlux) {
				return true;
			}
			return false;
		}
		
		public function get monitorView():MonitorView { return viewComponent as MonitorView; }
		public function get camera():VideoDisplay {
			var videoDisplay:VideoDisplay=monitorView.videoDisplay;
			return videoDisplay; 
		}
		
		public function get timeLineProxy():TakeTimeLineProxy {
			if (!_timeLineProxy)
				_timeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;

			return _timeLineProxy;
		}

		public function get projectProxy():ProjectProxy {
			if (!_projectProxy)
				_projectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;

			return _projectProxy;
		}

		public function get preferencesProxy():PreferencesProxy {
			if (!_preferencesProxy)
				_preferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			return _preferencesProxy;
		}
	}
}