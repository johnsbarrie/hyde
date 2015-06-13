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
package com.kool_animation.mediator {
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.PreferencesProxy;
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
		private var _preferencesProxy:PreferencesProxy;
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
			transportView.addEventListener(TransportView.EVENT_QUALITY_CHANGED, onQualityChanged);
			
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
				TakeConstant.CURRENT_FRAME_CHANGED,
				ProjectConstant.PREFERENCES_LOADED
			];
		}
		
		/** Gestion des notifications de l'application */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case TakeConstant.TRANSPORT_PLAY:
				case TakeConstant.TRANSPORT_STOP:
				case ProjectConstant.PREFERENCES_LOADED:
					onPreferenceLoaded();
					break;
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
		
		private function onQualityChanged (e:DataEvent):void {
			var quality:Number=Number(e.data);
			sendNotification(TakeConstant.TRANSPORT_SET_PLAYBACK_QUALITY, quality); 
		};
		
		
		private function onPreferenceLoaded():void{
			transportView.qualityComboBox.selectedIndex=this.preferencesProxy.playbackQuality;
			var fps:Number = this.preferencesProxy.defaultFPS;
			var index:int = transportView.fpsComboBox.dataProvider.getItemIndex(fps); 
			transportView.fpsComboBox.selectedIndex=index;
		}
		
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
		
		public function get preferencesProxy():PreferencesProxy {
			if (!_preferencesProxy)
				_preferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			return _preferencesProxy; 
		}
		
		public function get timeLineProxy():TakeTimeLineProxy {
			if (!_timeLineProxy)
				_timeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			return _timeLineProxy; 
		}
		
		
	}
}