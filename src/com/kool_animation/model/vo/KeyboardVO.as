package com.kool_animation.model.vo
{
	import flash.events.KeyboardEvent;

	/*
	Structure de lien evenement clavier / Notification
	*/
	public class KeyboardVO
	{
		public var keyboardEvent:KeyboardEvent;
		public var notification:String;

		public function KeyboardVO(keyCodeValue:uint, ctrlKeyValue:Boolean, altKeyValue:Boolean, shiftKeyValue:Boolean, controlKeyValue:Boolean, commandKeyValue:Boolean, notificationValue:String){
			keyboardEvent = new KeyboardEvent("KeyboardLink", true, false, 0, keyCodeValue, 0, ctrlKeyValue, altKeyValue, shiftKeyValue, controlKeyValue, commandKeyValue);
			notification = notificationValue;
		}
	}
}

