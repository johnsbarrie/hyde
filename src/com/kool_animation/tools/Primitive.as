package com.kool_animation.tools
{
	import flash.system.Capabilities;

	public class Primitive {
		public static function stringToBoolean(boolStr:String):Boolean {
			switch(boolStr) {
				case "1":
				case "true" : 
					return true;
					break;
				case "0" :
				case "" :
				case "false":
					return false;
					break;
				default :
					throw Error("string not an acceptable as boolean"); 
			}
			return false;
		}
		
		public static function stringToNumber(numstr:String):Number{
			if(numstr=="" || numstr=="undefined" || numstr==null){
				return NaN;
			}
			var num:Number = Number(numstr);
			if(isNaN(num)){
				return NaN;
			}
			return num;
		}
		
		public static function cloneArray(source:Array):Array { 
			var clone:Array = new Array();
			
			for(var i:int; i<source.length; i++){
				clone.push(source[i]);
			}
			return clone;
		}
		
		public static function isStringEmpty(str:String):Boolean{
			if(str=="" || str==null){
				return true
			}
			return false;
		}
		
		public static function nodeToObject(p:XML):Object{
			var nodeObject:Object = new Object();
			
			var attNamesList:XMLList = p.@*;
			for (var i:int = 0; i < attNamesList.length(); i++){
				var prop:String = attNamesList[i].name().toString();
				nodeObject[prop] = attNamesList[i];
			}
			// nodeValue is used to stock the text in the node.
			if(nodeObject["nodeValue"]){
				throw new Error("Primitive.nodeToObject Error : \n[nodeValue] is a reserved property, used to stock the text in the node.");
			}
			nodeObject["nodeValue"]= p.toString();
			
			return nodeObject;
		}
		
		public static function trim(str:String):String{
			var strlen:int = str.length
			var j:int = 0;
			while (str.charAt(j) == " "){j++} 
			if(j) {str = str.substring(j, strlen)}
			var k:int = str.length - 1;
			while(str.charAt(k) == " "){ k--;}
			str = str.substring(0,k+1)
			return str;
		}
		
		public static const WINDOWS:String="WINDOWS";
		public static const MAC:String="MAC";
		public static const LINUX:String="MAC";
		public static function os():String{
			var _os:String= flash.system.Capabilities.os.substr(0, 3);
			if(_os=="Win"){
				return WINDOWS;
			}else if (_os=="Mac"){
				return MAC;
			}
			return LINUX
		}
	}

}