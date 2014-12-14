import com.kool_animation.command.take;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;
import com.kool_animation.model.TakeTimeLineProxy;
	
	public class PlayCmd extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var timeLineProxy:TakeTimeLineProxy = facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;
			timeLineProxy.play();
		}
	}
}