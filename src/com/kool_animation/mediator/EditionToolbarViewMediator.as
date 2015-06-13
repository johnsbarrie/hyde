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
package com.kool_animation.mediator
{
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.mxml.EditionToolBarView;
	
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class EditionToolbarViewMediator extends Mediator
	{
		public static const NAME:String			= "EditionToolbarVeiwMediator";
		
		public function EditionToolbarViewMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_COPY, copy_frame);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_CUT, cut_frame);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_DELETE, delete_frame);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_OPEN_PHOTO_BUCKET, open_photo_bucket_frame);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_PASTE_BEFORE, paste_frame_before);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_PASTE_AFTER, paste_frame_after);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_REVERSE, reverse_frame);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_REVERSEPASTE, reverse_paste_frame);
			editionToolbarView.addEventListener(EditionToolBarView.EVENT_EXPORT, export);
		}
		
		private function copy_frame(evt:Event):void{
			sendNotification(TakeConstant.COPY_FRAMES);
		}
		
		private function cut_frame(evt:Event):void{
			sendNotification(TakeConstant.CUT_FRAMES);
		}
		
		private function delete_frame(evt:Event):void{
			sendNotification(TakeConstant.DELETE_FRAMES);
		}
		
		private function open_photo_bucket_frame(evt:Event):void{
			sendNotification( ProjectConstant.OPEN_PHOTO_BUCKET_WINDOW);
		}
		
		private function paste_frame_before(evt:Event):void{
			sendNotification(TakeConstant.PASTE_FRAMES_BEFORE);
		}
		
		private function paste_frame_after(evt:Event):void{
			sendNotification(TakeConstant.PASTE_FRAMES_AFTER);
		}
		
		private function reverse_frame(evt:Event):void{
			sendNotification(TakeConstant.REVERSE_FRAMES);
		}
		
		private function reverse_paste_frame(evt:Event):void{
			sendNotification(TakeConstant.PASTE_INVERTED_FRAMES);
		}
		
		private function export(evt:Event):void{
			sendNotification(ProjectConstant.OPEN_EXPORT_WINDOW);
		}
		
		public function get editionToolbarView():EditionToolBarView { return viewComponent as  EditionToolBarView; }
	}
}