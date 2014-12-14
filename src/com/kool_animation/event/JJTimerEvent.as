package com.kool_animation.event
{
	import flash.events.Event;
	
	/**
	 *  Evenement pour le timer
	 */
	public class JJTimerEvent extends Event
	{
		public static const ELAPSED:String = "Elapsed";
		
		// Propriétés
		/**
		 * Temps écoulé depuis le dernier appel du timer en ms
		 */
		public var Delay:int;
		
		/**
		 * Interval théorique attendu en ms
		 */
		public var Expected:int;
		
		
		
		/**
		 * Constructeur
		 * 
		 * @param : Type d'evenement
		 * @param : Temps ecoulé depuis le dernier evenement ou le lancement du timer
		 * @param : Interval théorique attendu
		 */
		function JJTimerEvent(type:String, delay:int, expected:int)
		{
			super(type);
			
			Delay = delay;
			Expected = expected;
		}
	}
}