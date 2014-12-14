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