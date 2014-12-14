package com.kool_animation.command.setup.photobucket
{
	import com.kool_animation.mediator.window.PhotoBucketWindowMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupPhotoBucketWindowMediator extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var hydeMainWindow:Hyde = notification.getBody() as Hyde;
			facade.registerMediator(new PhotoBucketWindowMediator(hydeMainWindow));
		}
	}
}