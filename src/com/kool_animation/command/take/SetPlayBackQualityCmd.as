package com.kool_animation.command.take
{
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
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.PreferencesProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetPlayBackQualityCmd extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var preferencesProxy:PreferencesProxy= facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			preferencesProxy.playbackQuality= notification.getBody() as Number;
			sendNotification(TakeConstant.TRANSPORT_PLAYBACK_QUALITY_CHANGED);
		}
	}
}

