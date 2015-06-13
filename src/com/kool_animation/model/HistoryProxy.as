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
package com.kool_animation.model{
	
	import com.kool_animation.model.vo.HistoryVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class HistoryProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "HistoryProxy";		// Nom du proxy
		
		private var historyObjectsArrayCollection:ArrayCollection;
		private var poppedhistoryObjectsArrayCollection:ArrayCollection;
		private var currentIndex:int=0;
		
		public function HistoryProxy(proxyName:String=NAME, data:Object=null) {
			super(proxyName, data);
			historyObjectsArrayCollection=new ArrayCollection();
			poppedhistoryObjectsArrayCollection=new ArrayCollection();
		}
		
		public function addHistory(historyVO:HistoryVO):void{
			historyObjectsArrayCollection.addItem(historyVO);
			poppedhistoryObjectsArrayCollection.removeAll();
		}
		
		public function popHistory():HistoryVO {
			if(historyObjectsArrayCollection.length>0){
				var historyVO:HistoryVO = historyObjectsArrayCollection.removeItemAt(historyObjectsArrayCollection.length-1) as HistoryVO;
				poppedhistoryObjectsArrayCollection.addItem(historyVO);
				return historyVO;
			}
			return null;
		}
		
		public function restoreLastPoppedHistory():HistoryVO{
			if (poppedhistoryObjectsArrayCollection.length>0){
				var historyVO:HistoryVO = poppedhistoryObjectsArrayCollection.removeItemAt(poppedhistoryObjectsArrayCollection.length-1) as HistoryVO;
				historyObjectsArrayCollection.addItem(historyVO);
				return historyVO;
			}
			return null;
		}
		
		public function lengthPoppedHistory():int{
			return poppedhistoryObjectsArrayCollection.length;
		}
		
		public function lengthHistory():int{
			return historyObjectsArrayCollection.length;
		}
	}
}