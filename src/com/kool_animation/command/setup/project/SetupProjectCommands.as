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
package com.kool_animation.command.setup.project
{
	import com.kool_animation.command.project.ChangeCameraCmd;
	import com.kool_animation.command.project.CheckForUpDatesCmd;
	import com.kool_animation.command.project.CreateProjectCmd;
	import com.kool_animation.command.project.CreateShotCmd;
	import com.kool_animation.command.project.CreateTakeCmd;
	import com.kool_animation.command.project.FullScreenCmd;
	import com.kool_animation.command.project.FullScreenLeftCmd;
	import com.kool_animation.command.project.HistoryAddCmd;
	import com.kool_animation.command.project.HistoryRedoCmd;
	import com.kool_animation.command.project.HistoryUndoCmd;
	import com.kool_animation.command.project.LoadProjectCmd;
	import com.kool_animation.command.project.LoadTakeCmd;
	import com.kool_animation.command.project.LoadTakeSuccess;
	import com.kool_animation.command.project.SaveTakeCmd;
	import com.kool_animation.command.project.ToggleAutomaticUpdateCmd;
	import com.kool_animation.command.project.ToggleFullscreenCmd;
	import com.kool_animation.command.take.ExportFilmCmd;
	import com.kool_animation.command.take.ExportTakeImagesCmd;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupProjectCommands extends SimpleCommand {
			override public function execute(notification:INotification):void {
				facade.registerCommand(ProjectConstant.PROJECT_CREATE_PROJECT, CreateProjectCmd);
				facade.registerCommand(ProjectConstant.PROJECT_LOAD_PROJECT, LoadProjectCmd);
				facade.registerCommand(ProjectConstant.PROJECT_CREATE_SHOT, CreateShotCmd);
				facade.registerCommand(ProjectConstant.PROJECT_CREATE_TAKE, CreateTakeCmd);
				facade.registerCommand(ProjectConstant.PROJECT_LOAD_TAKE, LoadTakeCmd);
				facade.registerCommand(ProjectConstant.PROJECT_LOAD_TAKE_SUCCESS, LoadTakeSuccess);
				facade.registerCommand(ProjectConstant.PROJECT_SAVE_TAKE, SaveTakeCmd);
				facade.registerCommand(TakeConstant.EXPORT_TAKE_IMAGES, ExportTakeImagesCmd);
				facade.registerCommand(TakeConstant.EXPORT_FILM, ExportFilmCmd);
				facade.registerCommand(ProjectConstant.FULLSCREEN, FullScreenCmd);
				facade.registerCommand(ProjectConstant.FULLSCREEN_LEFT, FullScreenLeftCmd);
				facade.registerCommand(ProjectConstant.TOGGLE_FULLSCREEN, ToggleFullscreenCmd);
				
				facade.registerCommand(ProjectConstant.ADD_HISTORY, HistoryAddCmd);
				facade.registerCommand(ProjectConstant.UNDO_HISTORY, HistoryUndoCmd);
				facade.registerCommand(ProjectConstant.REDO_HISTORY, HistoryRedoCmd);
				facade.registerCommand(ProjectConstant.CHECK_FOR_UPDATES, CheckForUpDatesCmd);
				
				facade.registerCommand(ProjectConstant.TOGGLE_AUTOMATIC_UPDATES, ToggleAutomaticUpdateCmd);
				facade.registerCommand(ProjectConstant.CHANGE_CAMERA, ChangeCameraCmd);
			}
	}
}