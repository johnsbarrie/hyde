package com.kool_animation.command.take.edition
{
	import com.kool_animation.constant.TakeConstant;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DuplicateFramesCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void{
			sendNotification(TakeConstant.COPY_FRAMES);
			sendNotification(TakeConstant.PASTE_FRAMES_AFTER);
		}
	}
}