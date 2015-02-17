package com.kool_animation.mediator {
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.TakeTimeLineProxy;
	import com.kool_animation.mxml.TransportView;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TransportMediator extends Mediator {
		public static const NAME:String="TransportMediator";
		private var _timeLineProxy:TakeTimeLineProxy;
		private var tcTimer:Timer;
		
		/* Constructeur */
		public function TransportMediator(viewComponent:Object=null, mediatorName:String=NAME) {
			super(mediatorName, viewComponent);
			
			tcTimer = new Timer(100,1);
			tcTimer.addEventListener(TimerEvent.TIMER, updatetc);
			transportView.addEventListener(TransportView.TOOGLE_INCLUDE_LIVEVIEW, onToggleIncludeLiveView);
			transportView.addEventListener(TransportView.EVENT_GOTO_FIRST, onGotoFirst);
			transportView.addEventListener(TransportView.EVENT_GOTO_LAST, onGotoLast);
			transportView.addEventListener(TransportView.EVENT_GOTO_NEXT, onGotoNext);
			transportView.addEventListener(TransportView.EVENT_GOTO_PREV, onGotoPrev);
			transportView.addEventListener(TransportView.EVENT_SWITCH_LOOP, onSwitchLoop);
			transportView.addEventListener(TransportView.EVENT_SWITCH_PLAY, onSwitchPlay);
			transportView.addEventListener(TransportView.EVENT_FPS_CHANGED, onFPSChanged);
			transportView.addEventListener(TransportView.TOOGLE_FULLSCREEN, onToggleFullscreen);
			transportView.addEventListener(TransportView.TOOGLE_SHORTPLAY, onToggleShortPlay);
			
		}
		
		/** Liste des notifications écoutés */
		override public function listNotificationInterests():Array {
			return [
				TakeConstant.TRANSPORT_PLAY,
				TakeConstant.TRANSPORT_STOP,
				TakeConstant.TRANSPORT_SWITCH_PLAY,
				TakeConstant.TRANSPORT_SWITCH_LOOP,
				TakeConstant.TRANSPORT_SET_FPS,
				TakeConstant.TRANSPORT_FPS_CHANGED,
				TakeConstant.CURRENT_FRAME_CHANGED
			];
		}
		
		/** Gestion des notifications de l'application */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case TakeConstant.TRANSPORT_PLAY:
				case TakeConstant.TRANSPORT_STOP:
				case TakeConstant.TRANSPORT_SWITCH_PLAY:
					setTimeout(updatePlayState,1);
					break;
				case TakeConstant.TRANSPORT_SWITCH_LOOP:
					setTimeout(updateLoopState,1);
					break;
				case TakeConstant.TRANSPORT_FPS_CHANGED:
					currentFrameChanged()
					break;
				case TakeConstant.CURRENT_FRAME_CHANGED:
					currentFrameChanged ();
					break;
			}
		}
		
		/** initialises fps from preferences when preferences are loaded */
		public function initFPS (fps:Number):void{
			transportView.initFPS (fps);
		}
		
		private function currentFrameChanged():void {
			tcTimer.reset();
			tcTimer.start();
		}
		
		private function updatetc(evt:TimerEvent):void {
			var timeSeconds:Number = (timeLineProxy.currentIndex + 1) / timeLineProxy.fps;
			var totalFrames:int = (timeLineProxy.currentIndex + 1 );
			var seconds:int = Math.floor (timeSeconds) % 60;
			var totalMinutes:Number = ((Math.floor (timeSeconds) - seconds)/60);
			var leftFrames:int = totalFrames-  seconds *timeLineProxy.fps;
			
			transportView.timecode ("Time :"+ totalMinutes + ":" + seconds + ":" + leftFrames + " -- Frame  : "+ totalFrames.toString());
		}
		
		private function updateFPS():void {
			// TODO la methode actuelle n'est pas bonne on ne prend en compte qu'une entrée par l'UI
		}
		
		private function updatePlayState():void { transportView.setPlayState(timeLineProxy.isPlaying); }
		private function updateLoopState():void { transportView.setLoopState(timeLineProxy.loop); }
		private function onFPSChanged (e:DataEvent):void {
			var fps:Number=Number(e.data);
			sendNotification(TakeConstant.TRANSPORT_SET_FPS, fps); 
		};
		private function onGotoFirst (e:Event):void { sendNotification(TakeConstant.GOTO_FIRST_FRAME); }
		private function onGotoLast (e:Event):void { sendNotification(TakeConstant.GOTO_LAST_FRAME); }
		private function onGotoNext (e:Event):void { sendNotification(TakeConstant.GOTO_NEXT_FRAME); }
		private function onGotoPrev (e:Event):void { sendNotification(TakeConstant.GOTO_PREV_FRAME); }
		private function onSwitchLoop (e:Event):void { sendNotification(TakeConstant.TRANSPORT_SWITCH_LOOP); }
		private function onSwitchPlay(e:Event):void { sendNotification(TakeConstant.TRANSPORT_SWITCH_PLAY); }
		private function onToggleFullscreen(e:Event):void { sendNotification(ProjectConstant.TOGGLE_FULLSCREEN); }
		private function onToggleShortPlay(e:Event):void { sendNotification (TakeConstant.TOGGLE_SHORTPLAY); }
		private function onToggleIncludeLiveView(e:Event):void { sendNotification(TakeConstant.TOGGLE_LIVE_VIEW_STATE); }
		
		public function get transportView():TransportView { return viewComponent as TransportView; }
		
		public function get timeLineProxy():TakeTimeLineProxy {
			if (!_timeLineProxy)
				_timeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			return _timeLineProxy; 
		}
	}
}