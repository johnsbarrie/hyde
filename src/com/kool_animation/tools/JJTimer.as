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

package com.kool_animation.tools
{
	import com.kool_animation.event.JJTimerEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	

	
	/**
	 * Timer de precision AS3
	 * Le principe est de corriger les imperfections du timer standar AS3, en se basant sur l'heure système
	 * Un interval est demandé par l'utilisateur, et on lance en interne un timer AS3. A chaque tick, on prend en compte l'heure system pour déterminer l'imprecision du timer.
	 * On utilise le delta ainssi calculé a chaque tick pour relancer un nouveau timer (si on est en mode autoreset)
	 * On prend en compte egalement les ticks eventuelement "perdus" enc as de grosse imprécision du timer AS3 affin de toujours avoir un tickCount le plus juste possible.
	 * L'evenement généré par le timer envois le temps passé depuis le dernier tick ainssi que l'interval corrigé attendu (interval utilisateur modifié par les algos de correction).
	 */
	public class JJTimer extends EventDispatcher
	{
		private var _autoReset:Boolean;			// Indiquant si Timer doit déclencher l'événement Elapsed chaque fois que l'intervalle spécifié expire ou uniquement la première fois. 
		private var _enabled:Boolean;			// Indique si Timer doit déclencher l'événement Elapsed. 
		private var _interval:int;				// Intervalle auquel l'événement Elapsed doit être déclenché.
		private var _timeOutInterval:int;		// Intervalle corrigé utiliser pour les timeout
		private var _timeOutUID:int;			// UID de l'objet timeOut utilisé
		private var _lastTime:int;				// Pour mémoriser la derniere valeur retourné par getTimer
		private var _count:int;					// Compteur de ticks du timer
		private var _droppedCount:int;			// Compteur de ticks "perdus" du timer 
		
		// Getter et setter AutoReset
		/**
		 * Etat de l'autoReset, s'il est actif le timer se répete automatiquement.
		 * Si il n'est pas actif le timer s'execute une seule fois.
		 */
		public function set autoReset(value:Boolean):void
		{
			_autoReset = value;
		}
		public function get autoReset():Boolean
		{
			return _autoReset;
		}
		
		/**
		 * Etat du timer. Le mettre a true reviens a démarrer le timer, a false reviens a l'arreter
		 */
		public function set enabled(value:Boolean):void
		{
			value ? start() : stop();
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * Valeur d'interval des evenements timer en ms 
		 */
		public function set interval(value:int):void
		{
			_interval = value;
		}
		public function get interval():int
		{
			return _interval;
		}
		
		/**
		 * Nombre de tick timer depuis son dernier reset
		 */
		public function get count():int
		{
			return _count;
		}
		
		/**
		 * Nombre de tick timer depuis son dernier reset
		 */
		public function set count(count:int):void
		{
			_count=count;
		}
		
		/**
		 * Nombre de Tick perdus (qui n'on pas remontés d'évènements timer)
		 */
		public function get droppedCount():int
		{
			return _droppedCount;
		}
		
		/**
		 * Constructeur
		 * 
		 * @param : Interval en ms entre les evenements générés par le timer
		 */
		function JJTimer(intervalValue:uint = 100)
		{
			_autoReset = true;			
			_enabled = false;
			_interval = intervalValue;
			_timeOutInterval = _interval;
			_timeOutUID = 0;
			_lastTime = 0;
			_count = 0;
			_droppedCount = 0;
		}
		
		/** Démarrage du timer */
		public function start():void
		{
			if(_enabled)
				clearTimeout(_timeOutUID);
			_enabled = true;
			
			_lastTime = getTimer();
			_timeOutUID = setTimeout(onTimeOut, _timeOutInterval); // lancement d'un timeout
		}
		
		/** Arret du timer */
		public function stop():void
		{
			if(_enabled)
				clearTimeout(_timeOutUID);
			_enabled = false;
		}
		
		/** Reset du timer */
		public function reset():void
		{
			_count = 0;
			_droppedCount = 0;
		}
		
		// Gestion de l'evenement du timeout
		/** Gestion de l'evenement du timer */
		private function onTimeOut():void
		{
			// Si le timer est activé
			if (_enabled){
				var now:int = getTimer();				// Récupère l'heure actuelle
				var elapsed:int = now - _lastTime;		// Calcule de l'interval réel a reception du timeout
				
				// Incrémente le compteur de tick
				_count++;
				// dispatch l'evenement
				dispatchEvent( new JJTimerEvent(JJTimerEvent.ELAPSED, elapsed, _timeOutInterval) );
				
				// Si l'auto reset est actif
				if (_autoReset){
					now = getTimer();										// Récupère l'heure actuelle
					elapsed = now - _lastTime;								// Calcule de l'interval réel après émission de l'event
					var delta:int = elapsed - _timeOutInterval;				// Calcule du delta a appliquer au prochain timeOut
					_timeOutInterval = _interval - delta;					// Mise a jour de l'interval corrigé
					// Gestion d'une intervalle négatif
					while (_timeOutInterval <= 0){
						// drop un tick
						_timeOutInterval += _interval;
						_count++;	
						_droppedCount++;
					}
					_lastTime = now;	// Mise a jour de lastTime
					_timeOutUID = setTimeout(onTimeOut, _timeOutInterval); 	// relance un timeout
				}
				else{
					_enabled = false;
				}
			}
		}
	}
}
