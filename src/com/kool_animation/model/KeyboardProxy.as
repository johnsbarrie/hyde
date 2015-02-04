package com.kool_animation.model {
	import com.kool_animation.AppFacade;
	import com.kool_animation.model.vo.KeyboardVO;
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	public class KeyboardProxy extends EventDispatcher {
		public static const TAKE_KEYMAP_TYPE:String	= "TAKE_KEYMAP_TYPE";
		private var takeKeyMap:Vector.<KeyboardVO>;
		
		public static const CAPTURE_CAMERA_FRAME:String="CAPTURE_CAMERA_FRAME";
		public static const TRANSPORT_SWITCH_PLAY:String="TRANSPORT_SWITCH_PLAY";
		public static const GOTO_PREV_FRAME:String="GOTO_PREV_FRAME";
		public static const GOTO_NEXT_FRAME:String="GOTO_NEXT_FRAME";
		
		public static const SELECT_PREV_FRAME:String="SELECT_PREV_FRAME";
		public static const SELECT_NEXT_FRAME:String="SELECT_NEXT_FRAME";
		public static const GOTO_FIRST_FRAME:String="GOTO_FIRST_FRAME";
		public static const GOTO_LAST_FRAME:String="GOTO_LAST_FRAME";
		
		public static const DELETE_FRAME:String= "DELETE_FRAME";
		
		/* Constructeur */
		public function KeyboardProxy() {
			//var stage:Stage=AppFacade.STAGE;
			AppFacade.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			AppFacade.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			takeKeyMap = new Vector.<KeyboardVO>();
			createTakeKeyMap();			
		}
		
		public function onKeyDown(ke:KeyboardEvent):void {
			if (AppFacade.STAGE.displayState!=StageDisplayState.NORMAL) {
				AppFacade.STAGE.displayState = StageDisplayState.NORMAL;
				AppFacade.STAGE.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			var notification:String = getNotificationForKeyboardEvent(ke, KeyboardProxy.TAKE_KEYMAP_TYPE);
			
			if (notification)
				dispatchEvent(new Event(notification));
		}
		
		public function onKeyUp(ke:KeyboardEvent):void {
			//trace("keyUp", ke.keyCode);
		}
		
		/* Création du fichier KeyMap par defaut */
		public function createTakeKeyMap():void{
			takeKeyMap.push(new KeyboardVO(Keyboard.SPACE, false, false, false, false, false, TRANSPORT_SWITCH_PLAY));
			takeKeyMap.push(new KeyboardVO(Keyboard.ENTER, false, false, false, false, false, CAPTURE_CAMERA_FRAME));
			takeKeyMap.push(new KeyboardVO(Keyboard.LEFT, false, false, false, false, false, GOTO_PREV_FRAME));
			takeKeyMap.push(new KeyboardVO(Keyboard.RIGHT, false, false, false, false, false, GOTO_NEXT_FRAME));
				
			takeKeyMap.push(new KeyboardVO(Keyboard.LEFT, false, false, true, false, false, SELECT_PREV_FRAME));
			takeKeyMap.push(new KeyboardVO(Keyboard.RIGHT, false, false, true, false, false, SELECT_NEXT_FRAME));
				
			takeKeyMap.push(new KeyboardVO(Keyboard.LEFT, false, true, false, false, false, GOTO_FIRST_FRAME));
			takeKeyMap.push(new KeyboardVO(Keyboard.RIGHT, false, true, false, false, false, GOTO_LAST_FRAME));
			
			takeKeyMap.push(new KeyboardVO(8, false, false, false, false, true, DELETE_FRAME));
		}

		/*
			Fonction de comparaison de deux KeyEvents
		*/
		public function compareKeyEvents(keyEvent1:KeyboardEvent, keyEvent2:KeyboardEvent):Boolean{
			if((keyEvent1.altKey == keyEvent2.altKey)
				&&	(keyEvent1.commandKey == keyEvent2.commandKey)
				&&	(keyEvent1.controlKey == keyEvent2.controlKey)
				//&&	(keyEvent1.ctrlKey == keyEvent2.ctrlKey)
				&&	(keyEvent1.shiftKey == keyEvent2.shiftKey)
				&&	(keyEvent1.keyCode == keyEvent2.keyCode))
				return true;
			
			return false;
		}
		
		/* Traitement d'un evenement clavier */
		public function getNotificationForKeyboardEvent(keyEvent:KeyboardEvent, keymapType:String):String{
			
			if(keymapType==TAKE_KEYMAP_TYPE){
				for each(var keyLink:KeyboardVO in takeKeyMap){
					if(compareKeyEvents(keyEvent,keyLink.keyboardEvent)){
						return keyLink.notification;
					}
				}
			} 
			// L'évènement clavier est inconnu
			return null;
		}

	}
}