package com.kool_animation.command.setup.project {
	import com.kool_animation.model.HistoryProxy;
	import com.kool_animation.model.ProjectProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupProjectProxies extends SimpleCommand {
		override public function execute(notification:INotification):void{
			facade.registerProxy(new ProjectProxy());
			facade.registerProxy(new HistoryProxy());
		}
	}
}