package com.kool_animation.command.setup.take {
	import com.kool_animation.command.take.CurrentFrameChangedCmd;
	import com.kool_animation.command.take.GotoFirstFrameCmd;
	import com.kool_animation.command.take.GotoFrameCmd;
	import com.kool_animation.command.take.GotoLastFrameCmd;
	import com.kool_animation.command.take.GotoNextFrameCmd;
	import com.kool_animation.command.take.GotoPrevFrameCmd;
	import com.kool_animation.command.take.HideLiveVideoCmd;
	import com.kool_animation.command.take.ImportSoundCmd;
	import com.kool_animation.command.take.OnionSkinAlphaChangedCmd;
	import com.kool_animation.command.take.SelectAllFramesCmd;
	import com.kool_animation.command.take.SelectNextFrameCmd;
	import com.kool_animation.command.take.SelectPrevFrameCmd;
	import com.kool_animation.command.take.SetFramePerSecCmd;
	import com.kool_animation.command.take.ShowLiveVideoCmd;
	import com.kool_animation.command.take.StopCmd;
	import com.kool_animation.command.take.SwitchLoopCmd;
	import com.kool_animation.command.take.SwitchPlayCmd;
	import com.kool_animation.command.take.TaketimelineMediatorFrameChangedCmd;
	import com.kool_animation.command.take.TimelineZoomInCmd;
	import com.kool_animation.command.take.TimelineZoomOutCmd;
	import com.kool_animation.command.take.ToggleGridCmd;
	import com.kool_animation.command.take.ToggleHorizontalFlipCmd;
	import com.kool_animation.command.take.ToggleLiveVideoCmd;
	import com.kool_animation.command.take.ToggleVerticalFlipCmd;
	import com.kool_animation.command.take.ToggleliveViewState;
	import com.kool_animation.command.take.edition.CaptureFrameCmd;
	import com.kool_animation.command.take.edition.CopyFramesCmd;
	import com.kool_animation.command.take.edition.CutFramesCmd;
	import com.kool_animation.command.take.edition.DeleteFramesCmd;
	import com.kool_animation.command.take.edition.DuplicateFramesCmd;
	import com.kool_animation.command.take.edition.ImportImageCmd;
	import com.kool_animation.command.take.edition.InsertPhotoBucketFramesCmd;
	import com.kool_animation.command.take.edition.InvertedPasteFramesCmd;
	import com.kool_animation.command.take.edition.PasteFramesCmd;
	import com.kool_animation.command.take.edition.ReverseFramesCmd;
	import com.kool_animation.constant.TakeConstant;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetupTakeCommands extends SimpleCommand {
		override public function execute(notification:INotification):void {
			facade.registerCommand(TakeConstant.GOTO_FIRST_FRAME, GotoFirstFrameCmd);
			facade.registerCommand(TakeConstant.GOTO_LAST_FRAME, GotoLastFrameCmd);
			facade.registerCommand(TakeConstant.GOTO_FRAME, GotoFrameCmd);
			facade.registerCommand(TakeConstant.GOTO_NEXT_FRAME, GotoNextFrameCmd);
			facade.registerCommand(TakeConstant.GOTO_PREV_FRAME, GotoPrevFrameCmd);
			facade.registerCommand(TakeConstant.TRANSPORT_SWITCH_PLAY, SwitchPlayCmd);
			facade.registerCommand(TakeConstant.TRANSPORT_SWITCH_LOOP, SwitchLoopCmd);
			facade.registerCommand(TakeConstant.TRANSPORT_STOP, StopCmd);
			facade.registerCommand(TakeConstant.TRANSPORT_SET_FPS, SetFramePerSecCmd);
			facade.registerCommand(TakeConstant.CURRENT_FRAME_CHANGED, CurrentFrameChangedCmd);
			facade.registerCommand(TakeConstant.COPY_FRAMES, CopyFramesCmd);
			facade.registerCommand(TakeConstant.CUT_FRAMES, CutFramesCmd);
			facade.registerCommand(TakeConstant.DELETE_FRAMES, DeleteFramesCmd);
			facade.registerCommand(TakeConstant.PASTE_FRAMES, PasteFramesCmd);
			facade.registerCommand(TakeConstant.REVERSE_FRAMES, ReverseFramesCmd);
			facade.registerCommand(TakeConstant.PASTE_INVERTED_FRAMES, InvertedPasteFramesCmd);
			facade.registerCommand(TakeConstant.SELECT_ALL_FRAMES, SelectAllFramesCmd);
			facade.registerCommand(TakeConstant.DUPLICATE_FRAMES, DuplicateFramesCmd);
			facade.registerCommand(TakeConstant.TOGGLE_LIVE_VIDEO, ToggleLiveVideoCmd);
			
			facade.registerCommand(TakeConstant.TOGGLE_GRID, ToggleGridCmd);
			facade.registerCommand(TakeConstant.TOGGLE_VERTICAL_FLIP, ToggleVerticalFlipCmd);
			facade.registerCommand(TakeConstant.TOGGLE_HORIZONTAL_FLIP, ToggleHorizontalFlipCmd);
			
			facade.registerCommand(TakeConstant.TIMELINE_ZOOM_IN, TimelineZoomInCmd);
			facade.registerCommand(TakeConstant.TIMELINE_ZOOM_OUT, TimelineZoomOutCmd);
			
			facade.registerCommand(TakeConstant.SHOW_LIVE_VIDEO, ShowLiveVideoCmd);
			facade.registerCommand(TakeConstant.HIDE_LIVE_VIDEO, HideLiveVideoCmd);
			facade.registerCommand(TakeConstant.TAKETIMELINEMEDIATOR_FRAME_CHANGED, TaketimelineMediatorFrameChangedCmd);
			facade.registerCommand(TakeConstant.CAPTURE_FRAMES, CaptureFrameCmd);
			facade.registerCommand(TakeConstant.INSERT_PHOTO_BUCKET_FRAMES, InsertPhotoBucketFramesCmd);
			facade.registerCommand(TakeConstant.ONIONSKIN_ALPHA_VALUE_CHANGE, OnionSkinAlphaChangedCmd);
			facade.registerCommand(TakeConstant.SELECT_NEXT_FRAME, SelectNextFrameCmd);
			facade.registerCommand(TakeConstant.SELECT_PREVIOUS_FRAME, SelectPrevFrameCmd);
			facade.registerCommand(TakeConstant.IMPORT_IMAGE, ImportImageCmd);
			facade.registerCommand(TakeConstant.IMPORT_SOUND, ImportSoundCmd);
			
			facade.registerCommand(TakeConstant.TOGGLE_LIVE_VIEW_STATE, ToggleliveViewState);
		}
	}
}