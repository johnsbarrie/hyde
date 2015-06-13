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
package com.kool_animation.model {
	import com.kool_animation.model.PreferencesProxy;
	import com.kool_animation.model.vo.FrameFileVO;
	import flash.filesystem.File;
	import mx.collections.ArrayCollection;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class DiskPathsProxy extends Proxy implements IProxy {
		public static const NAME:String="DiskPathsProxy";
		private var _projectName:String;
		private var _shotName:String=null;
		private var _takeName:String=null;
		public const PREFERENCE_LIST_PATH:String = "settings/preference.xml";
		public const SHOT_FOLDERNAME:String = "shots";
		public const TAKE_FOLDERNAME:String = "takes";
		private const PROJECT_FILE_NAME:String	= "project.apr";
		private const SHOT_FILE_NAME:String	= "shot.xml";
		private const TIMELINE_FILE_NAME:String	= "timeline.xml";
		private const SOUND_FILE_NAME:String	= "sound.xml";
		private const PREVIEW_IMAGE_FOLDERNAME:String = "prev";
		private const THUMB_IMAGE_FOLDERNAME:String = "thumb";
		private const SRC_IMAGE_FOLDERNAME:String = "src";
		private const JPG_IMAGE_FOLDERNAME:String = "jpg";
		private const SOUND_FOLDERNAME:String = "sound";
		
		public function DiskPathsProxy(proxyName:String=NAME, data:Object=null) {
			super(proxyName, data);
		}
		
		public function setCurrentTake(aProjectName:String, aShotName:String, aTakeName:String):void{
			this._projectName=aProjectName;
			this._shotName=aShotName;
			this._takeName=aTakeName;
		}
		
		/* PATHS */
		public function get workSpaceFolder():String {
			return preferenceProxy.workspaceDirectory+"/";
		}
		
		public function set projectName(aProjectName:String):void {
			_projectName=aProjectName;
			if (!new File(projectFolderPath).exists) { trace("WARNING : Project Does Not Exist !! " + projectFolderPath); }
		}
		
		public function get projectName():String{
			return _projectName;
		}
		
		public function set shotName(aShotName:String):void {
			_shotName=aShotName;
		}
		
		public function get shotName():String{
			return _shotName;
		}
		
		public function set takeName(aTakeName:String):void {
			_takeName=aTakeName;
		}
		
		public function get takeName():String{
			return _takeName;
		}
		
		public function get projectFolderPath():String {
			return workSpaceFolder+_projectName+"/";
		}
		
		public function get projectFilePath():String {
			return projectFolderPath+PROJECT_FILE_NAME;
		}		
		
		public function get shotsFolderPath():String {
			return projectFolderPath+SHOT_FOLDERNAME+"/"
		}
		
		public function get shotFolderPath ():String{
			return shotsFolderPath+_shotName+"/"
		}
		
		public function get shotFilePath ():String{
			return shotFolderPath+SHOT_FILE_NAME;
		}
		
		public function get takesFolderPath ():String {
			return shotFolderPath +TAKE_FOLDERNAME;
		}
		
		public function get takeFolderPath ():String {
			return takesFolderPath+"/"+_takeName+"/";
		}
		
		public function get soundFolderPath ():String {
			return takeFolderPath + "/" + SOUND_FOLDERNAME;
		}
		
		public function get timeFilePath ():String {
			return takeFolderPath+"/"+TIMELINE_FILE_NAME;
		}
		
		public function get soundFilePath ():String {
			return takeFolderPath+"/"+SOUND_FILE_NAME;
		}
		
		public function get takeSourceFolderPath ():String{
			return takeFolderPath+"/"+SRC_IMAGE_FOLDERNAME+"/";
		}
		
		public function get takeJPGFolderPath ():String{
			return takeFolderPath+"/"+JPG_IMAGE_FOLDERNAME+"/";
		}
		
		public function get takeThumbFolderPath ():String{
			return takeFolderPath+"/"+THUMB_IMAGE_FOLDERNAME+"/";
		}
		public function get takePrevFolderPath ():String{
			return takeFolderPath+"/"+PREVIEW_IMAGE_FOLDERNAME+"/";
		}
		
		public function  getImagename (id:String):String { 
			return "view"+id+".png";  
		}
		
		public function getThumbimage(id:String):String {
			return "thumb"+id+".png"; 
		}
		
		public function getPreviewimage(id:String):String {
			return "prev"+id+".png"; 
		}
		
		public function getJpgimage(id:String):String {
			return "image"+id+".jpg"; 
		}
		
		public function getFrameFileVO(id:String):FrameFileVO{
			var imageUrl:String = takeSourceFolderPath+getImagename(id);
			var thumbUrl:String = takeThumbFolderPath+getThumbimage(id);
			var previewUrl:String = takePrevFolderPath+getPreviewimage(id);
			var jpgUrl:String = takeJPGFolderPath+getJpgimage(id);
			return new FrameFileVO(imageUrl, thumbUrl, previewUrl, jpgUrl);
		}
		
		public function createFrameId():String {
			// TODO : totaly unsecure ! si on efface un fichier c la merde
			// Determine le nombre de fichier presents
			var src:File = File.userDirectory.resolvePath(takeSourceFolderPath);
			var fileCount:int = 0;
			for each (var file:File in src.getDirectoryListing()){
				if(file.extension == "png")
					fileCount++;
			}
			
			var suffix:String		= String(fileCount+1);
			var lengthSuffix:int	= 7 - suffix.length;
			var prefix:String		= "";
			for(var i:int = 0; i < lengthSuffix; i++){
				prefix += "0";
			}
			return prefix + suffix;
			
			return null;
		}
		
		public function createPhotoBucketFrames():ArrayCollection {
			var source:File=File.userDirectory.resolvePath(takeSourceFolderPath);
			var photoBucketFrameIdArray:Array=new Array();
			if(source.exists){
				
				var fileContentsArray:Array=source.getDirectoryListing();
				
				for each (var file:File in fileContentsArray){
					if(!file.isHidden){
						var idRegExp:RegExp = /view(.*?).png/g;
						var matches:Object = idRegExp.exec(String(file.name));
						photoBucketFrameIdArray.push(matches[1]);
					}
				}
			}else{
				throw new Error("Dossier SRC n'exist pas");
			}
			
			var photoBucketFramesArray:Array = new Array();		
			for each (var id:String in photoBucketFrameIdArray) {
				photoBucketFramesArray.push(new FrameVO(id, getFrameFileVO(id)));
			}
			
			var photoBucketFramesArrayCollection:ArrayCollection= new ArrayCollection(photoBucketFramesArray);
			return photoBucketFramesArrayCollection;
		}
		
		public function get preferenceProxy():PreferencesProxy {
			return facade.retrieveProxy(PreferencesProxy.NAME) as PreferencesProxy;;
		}
	}
}