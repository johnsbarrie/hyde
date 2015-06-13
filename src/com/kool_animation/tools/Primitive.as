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