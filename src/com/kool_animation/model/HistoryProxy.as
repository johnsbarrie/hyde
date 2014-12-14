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