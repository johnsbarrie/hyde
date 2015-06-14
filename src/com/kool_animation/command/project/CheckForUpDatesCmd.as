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
package com.kool_animation.command.project {
	import com.kool_animation.AppFacade;

	import com.kool_animation.model.PreferencesProxy;
	
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import flash.system.Capabilities;
	public class CheckForUpDatesCmd extends SimpleCommand {
		private var _preferencesProxy:PreferencesProxy;		// proxy des preferences
		private var urlLoader:URLLoader = new URLLoader();
		private var versionXML:XML
		override public function execute(notification:INotification):void {
			var preferencesProxy:PreferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			
			var urlReq:URLRequest = new URLRequest();
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			
			var urlString:String="http://hyde.kool-animation.com/version?version="+appXml.ns::versionNumber+"&system="+Capabilities.os;
			urlReq.url = urlString;
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener("complete", onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			urlLoader.load(urlReq);
		}
		
		private function onComplete(e:Event):void {
			versionXML= new XML (urlLoader.data);
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			
			if (versionXML.version> preferencesProxy.lastVersionFoundOnline) {
				var appfacade:AppFacade = AppFacade.getInstance();
				Alert.show(appfacade.resourceManager.getString("GUI_I18NS","want_to_download_new_version"), appfacade.resourceManager.getString("GUI_I18NS","new_hyde_version")+" v."+versionXML.version+"\n"+versionXML.description, Alert.YES|Alert.NO, null, version_available, null);
			}
		}
		
		private function version_available(evt:CloseEvent):void{
			if (evt.detail == Alert.YES) {
				navigateToURL(new URLRequest("http://hyde.kool-animation.com/"));
			}else if (evt.detail==Alert.NO){
				preferencesProxy.lastVersionFoundOnline=versionXML.version;
			}
		}
		
		private function errorHandler(e:Event):void{
			
		}
		
		private function updateCheckNow():void {
			
		}
		
		
		public function get preferencesProxy():PreferencesProxy {
			if (!_preferencesProxy)
				_preferencesProxy = facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;
			return _preferencesProxy;
		}
	}
}