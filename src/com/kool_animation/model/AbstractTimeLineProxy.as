package com.kool_animation.model {
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.event.JJTimerEvent;
	import com.kool_animation.model.FrameVO;
	import com.kool_animation.tools.JJTimer;
	import mx.collections.ArrayCollection;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AbstractTimeLineProxy extends Proxy implements IProxy {
		public static const NAME:String = "TimeLineProxy";		// Nom du proxy
	
		protected const TIMEBASE:Number = 1000;
		protected var _frames:ArrayCollection;					// Liste des Frames composant la timeLine
		protected var _currentFrame:FrameVO;						// Frame courante
		protected var _currentIndex:int=-1;							// Index de la frame courante
		protected var _fps:Number;								// Vitesse de lecture (frame per second)
		protected var _loop:Boolean;								// Flag lecture en boucle
		protected var _timer:JJTimer;								// Horloge de la timeLine
		protected var currentFrameOffset:int=0;
		public var currentIndexBeforePlay:int=0;
		public var shortplay:Boolean=true;

		/* Constructeur */
		public function AbstractTimeLineProxy(proxyName:String=NAME, data:Object=null) {
			super(proxyName, data);
			_frames = null;
			_fps = 12.5; //(facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy).defaultFPS;  // TODO : a faire proprement la on peut pas (chargement asynch de preferences)
			_timer = new JJTimer (TIMEBASE/_fps);
			_timer.addEventListener(JJTimerEvent.ELAPSED, onTimerTick);
			_frames=new ArrayCollection();
		}
		
		/* Gestion des tick d'horloge de la timeline */
		protected function onTimerTick(te:JJTimerEvent):void {
			if (_timer.count < _frames.length)
				setCurrentFrame(_timer.count);
			else {
				if (this._loop)
					setCurrentFrame(_timer.count - _frames.length);
				else {
					setCurrentFrame(0);
					stopTransport();	
				}
				_timer.reset();
			}
		}
		
		/* Mise en lecture */
		public function play():void {
			if (_frames) {
				if ( shortplay ) {
					currentIndex = _frames.length -15;
					if(currentIndex <0){currentIndex=0;} 
				} else {
					currentIndex = 0;
				}
				
				_timer.reset();
				_timer.start();
				sendNotification (TakeConstant.HIDE_LIVE_VIDEO);
			}
		}
		
		/* Arret de la lecture  */
		public function stop():void {
			_timer.stop();
			//trace("stop : " + currentIndexBeforePlay);
			setCurrentFrame(currentIndex);
			
			sendNotification(TakeConstant.CURRENT_FRAME_CHANGED, currentIndex);
		}
		
		/* Inverse l'etat de lecture play/pause */
		public function switchPlay():void {
			if (_timer.enabled)
				stop();
			else {
				sendNotification(TakeConstant.TRANSPORT_PREPARE_TO_PLAY);
				play();
			}
		}
		/* Inverse l'etat du flag de lecture en boucle */
		public function switchLoop():void {
			_loop=!_loop;
		}
		
		public function set frameArrayCollection(framesArrayCollection:ArrayCollection):void{
			_frames=framesArrayCollection;
		}
		
		/* Selectionne la frame courante */
		public function setCurrentFrame(index:int, force:Boolean = false):void {
			if(!_frames)
				return;
			
			if (force) {
				if (index >= _frames.length)
					_currentIndex = _frames.length -1;
				if (index < -1)
					_currentIndex = -1;
				else
					_currentIndex = index;
				
				if ( (_currentIndex >= 0) && (_currentIndex < _frames.length) )
					_currentFrame = _frames.getItemAt(_currentIndex) as FrameVO;
				else
					_currentFrame = null;

				// Notification du changement de frame
				currentFrameChanged(_currentIndex);
			}
			else if (index != _currentIndex){
				if ((index >= 0)&&(index < _frames.length)){
					_currentIndex = index;
				}
				else
					_currentFrame = null;
				// Notification du changement de frame
				currentFrameChanged(_currentIndex);
			}
		}	
		
		protected function currentFrameChanged(index:int):void { 
			sendNotification(TakeConstant.CURRENT_FRAME_CHANGED, index);
		}
		
		protected function gotoFirstFrame():void{
			sendNotification(TakeConstant.GOTO_FIRST_FRAME, _frames);
		}
		
		protected function stopTransport():void{
			sendNotification(TakeConstant.TRANSPORT_STOP);
		}
		
		/* GETTERS */
		public function get isPlaying():Boolean { return _timer.enabled; };
		public function get numberFrames():int { return (_frames)?_frames.length:0; }
		public function get frames():ArrayCollection { return _frames; }
		public function get currentIndex():int {return _currentIndex; }
		public function get fps():Number{ return _fps; }
		public function get loop():Boolean { return _loop; }
		
		/* SETTERS */
		public function set frames(newframes:ArrayCollection):void {  _frames.source=newframes.source; }
		public function set loop(value:Boolean):void { _loop = value; }
		public function set currentIndex(value:int):void {
			_currentIndex=value; 
		}
		public function set fps(value:Number):void {
			if (value != _fps){
				_fps = value;
				_timer.interval = TIMEBASE / _fps;
			}
		}
	}
}