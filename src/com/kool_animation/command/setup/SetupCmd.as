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
package com.kool_animation.command.setup {
	import com.kool_animation.command.setup.disk.SetupDiskProxy;
	import com.kool_animation.command.setup.mainwindow.SetupMainWindowMediatorCmd;
	import com.kool_animation.command.setup.nativemenu.SetupNativeCommands;
	import com.kool_animation.command.setup.photobucket.SetupPhotoBucketWindowMediator;
	import com.kool_animation.command.setup.preference.SetupPreferenceCommands;
	import com.kool_animation.command.setup.preference.SetupPreferenceProxy;
	import com.kool_animation.command.setup.preference.SetupPreferenceWindowMediator;
	import com.kool_animation.command.setup.project.SetupProjectCommands;
	import com.kool_animation.command.setup.project.SetupProjectMediators;
	import com.kool_animation.command.setup.project.SetupProjectProxies;
	import com.kool_animation.command.setup.take.SetupTakeCommands;
	import com.kool_animation.command.setup.take.SetupTakeMediators;
	import com.kool_animation.command.setup.take.SetupTakeProxies;
	import com.kool_animation.command.setup.timelapse.SetupTimelapseWindowMediator;
	
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class SetupCmd extends MacroCommand {
		override protected function initializeMacroCommand():void {
			addSubCommand(SetupMainWindowMediatorCmd);
			
			addSubCommand(SetupProjectCommands);
			addSubCommand(SetupProjectMediators);
			addSubCommand(SetupProjectProxies);
			
			addSubCommand(SetupPreferenceWindowMediator);
			addSubCommand(SetupPreferenceProxy);
			addSubCommand(SetupPreferenceCommands);
			
			addSubCommand(SetupDiskProxy);
			addSubCommand(SetupTakeProxies);
			addSubCommand(SetupTakeMediators);
			addSubCommand(SetupTakeCommands);
			
			addSubCommand(SetupNativeCommands);
			
			addSubCommand(SetupTimelapseWindowMediator);
			
			addSubCommand(SetupPhotoBucketWindowMediator);
		}
	}
}