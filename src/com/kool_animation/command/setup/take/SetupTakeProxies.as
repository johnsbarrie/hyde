package com.kool_animation.command.setup.take
{
	import com.kool_animation.model.SoundProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupTakeProxies extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			facade.registerProxy(new TakeTimeLineProxy());
			facade.registerProxy(new SoundProxy());
		}
	}
}