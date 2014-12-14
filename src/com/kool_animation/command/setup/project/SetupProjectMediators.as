package com.kool_animation.command.setup.project {	
	import com.kool_animation.mediator.window.AboutWindowMediator;
	import com.kool_animation.mediator.window.ExportChoiceWindowMediator;
	import com.kool_animation.mediator.window.ProjectWindowMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupProjectMediators extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var hydeMainWindow:Hyde = notification.getBody() as Hyde;
			facade.registerMediator(new ProjectWindowMediator(hydeMainWindow));
			facade.registerMediator(new AboutWindowMediator(hydeMainWindow));
			facade.registerMediator(new ExportChoiceWindowMediator(hydeMainWindow));
		}
	}
		
}