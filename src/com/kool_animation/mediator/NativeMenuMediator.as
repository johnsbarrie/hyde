package com.kool_animation.mediator
{
	import com.kool_animation.AppFacade;
	import com.kool_animation.constant.ProjectConstant;
	import com.kool_animation.constant.TakeConstant;
	import com.kool_animation.model.KeyboardProxy;
	import com.kool_animation.model.TakeTimeLineProxy;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import mx.resources.IResourceManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class NativeMenuMediator extends Mediator
	{
		public static const NAME:String="NativeMenuMediator";
		private var tontoMenu:NativeMenuItem;
		private var fileMenu:NativeMenuItem;
		private var editMenu:NativeMenuItem;
		private var playbackMenu:NativeMenuItem;
		private var windowMenu:NativeMenuItem;
		private var screenMenu:NativeMenuItem;
		
		
		private var helpMenu:NativeMenuItem;
		private var automatiqueUpdatesCommand:NativeMenuItem 
		
		private var loopCommand:NativeMenuItem;
		private var resourceManager:IResourceManager;
		private var liveViewCommand:NativeMenuItem;
		private var keyboardProxy:KeyboardProxy;
		private var undoCommand:NativeMenuItem;
		private var redoCommand:NativeMenuItem;
		
		private var inversPasteCommand:NativeMenuItem;
		private var pasteCommand:NativeMenuItem;
		
		public function NativeMenuMediator(aResourceManager:IResourceManager=null, mediatorName:String=NAME) {
			super(mediatorName, null);
			this.resourceManager = aResourceManager;
			init();
			
			this.keyboardProxy= new KeyboardProxy();
			keyboardProxy.addEventListener(KeyboardProxy.CAPTURE_CAMERA_FRAME, captureCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.DELETE_FRAME, deleteCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.GOTO_FIRST_FRAME, firstFrameCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.GOTO_LAST_FRAME, endFrameCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.GOTO_NEXT_FRAME, nextCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.GOTO_PREV_FRAME, previousCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.TRANSPORT_SWITCH_PLAY, playCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.SELECT_NEXT_FRAME, selectNextCommandMenu);
			keyboardProxy.addEventListener(KeyboardProxy.SELECT_PREV_FRAME, selectPreviousCommandMenu);
		}
		
		/** Liste des notifications écoutés */
		override public function listNotificationInterests():Array {
			return [
				TakeConstant.TRANSPORT_SWITCH_LOOP,
				TakeConstant.CAPTURE_ACTIVATE,
				TakeConstant.CAPTURE_DISACTIVATE
			];
		}
		
		/** Gestion des notifications de l'application */
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case TakeConstant.TRANSPORT_SWITCH_LOOP:
					setTimeout(updateLoopState,1);
					break;
				case TakeConstant.CAPTURE_ACTIVATE :
					captureKeyboardShortActive(true);
					break;
				case TakeConstant.CAPTURE_DISACTIVATE :
					captureKeyboardShortActive(false);
					break;
			}
		}
		
		public function captureKeyboardShortActive(active:Boolean):void{
			if(active){
				keyboardProxy.addEventListener(KeyboardProxy.CAPTURE_CAMERA_FRAME, captureCommandMenu);
			}else{ 
				keyboardProxy.removeEventListener(KeyboardProxy.CAPTURE_CAMERA_FRAME, captureCommandMenu);
			}
		}
		
		public function setLiveViewState(state:Boolean):void{
			liveViewCommand.checked=state;
		}
		
		public function init(activateAllMenus:Boolean=false):void {
			var root:NativeMenu = new NativeMenu(); 
			if (NativeWindow.supportsMenu){ 
				AppFacade.STAGE.nativeWindow.menu = root;
			} else if (NativeApplication.supportsMenu) { 
				NativeApplication.nativeApplication.menu = root; 	
			}  
			
			tontoMenu = root.addSubmenu (createTontoMenu(), resourceManager.getString('GUI_I18NS', "program_name"));
			fileMenu = root.addSubmenu (createFileMenu(), resourceManager.getString('GUI_I18NS' , "file"));
			editMenu = root.addSubmenu (createEditMenu(), resourceManager.getString('GUI_I18NS', "edit"));
			playbackMenu = root.addSubmenu (createPlaybackMenu(), resourceManager.getString('GUI_I18NS', "playback"));
			
			windowMenu = root.addSubmenu (createWindowMenu(), resourceManager.getString('GUI_I18NS', "window"));
			screenMenu = root.addSubmenu (createScreenMenu(), resourceManager.getString('GUI_I18NS', "screen"));
			helpMenu = root.addSubmenu (createHelpMenu(), resourceManager.getString('GUI_I18NS', "help"));
			menuActived(activateAllMenus);
		}
		
		private function menuActived (activate:Boolean):void {
			fileMenu.enabled=activate;
			editMenu.enabled=activate;
			playbackMenu.enabled=activate;
			windowMenu.enabled=activate;
		}
		
		/** File Menu */	
		private function createTontoMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu(); 
			var aboutCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "about", "a", aboutCommandMenu);
			aboutCommand.keyEquivalent = null;
			aboutCommand.keyEquivalentModifiers =null;
			var separatorB:NativeMenuItem = new NativeMenuItem("B", true);
			fileMenu.addItem(separatorB);
			
			var preferencesCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "preferences", "p", preferencesCommandMenu);
			var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
			fileMenu.addItem(separatorA);
			
			var quitCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "quit", "q", quitCommandMenu);
			return fileMenu; 
		}
		
		private function preferencesCommandMenu(evt:Event):void {
			sendNotification(ProjectConstant.OPEN_PREFERENCEWINDOW);
		}
		
		private function quitCommandMenu(evt:Event):void {
			NativeApplication.nativeApplication.exit();
		}
		
		private function aboutCommandMenu(evt:Event):void {
			sendNotification( ProjectConstant.OPEN_ABOUT_WINDOW );
		}
		
		/**File Menu */		
		private function createFileMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu();
			var projectManagerCommand:NativeMenuItem = createNativeMenuItem(fileMenu, 'project_manager', "m", projectManagerCommandMenu);
			var separatorB:NativeMenuItem = new NativeMenuItem("A", true);
			fileMenu.addItem(separatorB);
			var importCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "import_image", "i", importCommandMenu);
			var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
			fileMenu.addItem(separatorA);
			var exportCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "export", "e", exportCommandMenu);
			return fileMenu; 
		}
		
		private function importCommandMenu (evt:Event):void {
			sendNotification(TakeConstant.IMPORT_IMAGE);
		}
		
		private function exportCommandMenu (evt:Event):void {
			
			sendNotification(ProjectConstant.OPEN_EXPORT_WINDOW);
		}
		
		/** Edit Menu */
		private function createEditMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu(); 
			undoCommand = createNativeMenuItem(fileMenu, "undo", "z", undoCommandMenu);
			undoCommand.enabled=false;
			redoCommand = createNativeMenuItem(fileMenu, "redo", "z", redoCommandMenu);
			redoCommand.enabled=false;
			if(isMac()){
				redoCommand.keyEquivalentModifiers = [Keyboard.COMMAND, Keyboard.SHIFT];
			}else{
				redoCommand.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT];
			}
			var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
			fileMenu.addItem(separatorA);
			var copyCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "copy", "c", copyCommandMenu);			
			inversPasteCommand = createNativeMenuItem(fileMenu, "inverse_paste", "v", inversePasteCommandMenu);
			if(isMac()){
				inversPasteCommand.keyEquivalentModifiers = [Keyboard.COMMAND, Keyboard.SHIFT];
			}else{
				inversPasteCommand.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT];
			}
			inversPasteCommand.enabled=false;
			pasteCommand = createNativeMenuItem(fileMenu, "paste", "v", pasteCommandMenu);
			pasteCommand.enabled=false;
			var cutCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "cut", "x", cutCommandMenu);
			var duplicateCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "duplicate", "d", duplicateCommandMenu);
			var separatorB:NativeMenuItem = new NativeMenuItem("B", true);
			fileMenu.addItem(separatorB);
			var selectCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "select_all", "a", selectallFramesCommandMenu);
			var deleteCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "delete", 'r', deleteCommandMenu);
			deleteCommand.keyEquivalent=null;
			return fileMenu;
		}
		
		public function setUndoState(state:Boolean):void{
			undoCommand.enabled=state;
		}
		
		public function setRedoState(state:Boolean):void{
			redoCommand.enabled=state;
		}
		
		public function setPasteState(state:Boolean):void{
			pasteCommand.enabled=state;
			inversPasteCommand.enabled=state;
		}
		
		private function undoCommandMenu(evt:Event):void {
			sendNotification(ProjectConstant.UNDO_HISTORY);
		}
		
		private function redoCommandMenu(evt:Event):void {
			sendNotification(ProjectConstant.REDO_HISTORY);
		}
		
		private function copyCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.COPY_FRAMES);
		}
		
		private function selectallFramesCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.SELECT_ALL_FRAMES);
		}

		private function pasteCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.PASTE_FRAMES);
		}
		
		private function cutCommandMenu (evt:Event):void {
			sendNotification(TakeConstant.CUT_FRAMES);
		}
		
		private function inversePasteCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.PASTE_INVERTED_FRAMES);
		}
		
		private function duplicateCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.DUPLICATE_FRAMES);
		}		
		
		private function deleteCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.DELETE_FRAMES);
		}	
		
		/** PlayBackMenu */
		private function createPlaybackMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu(); 
			var captureCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "capture", "v", captureCommandMenu);
			captureCommand.keyEquivalent=null;
			captureCommand.keyEquivalentModifiers=null;
			var playCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "play", "v", playCommandMenu);
			playCommand.keyEquivalent=null;
			playCommand.keyEquivalentModifiers=null;
			
			var previousCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "previous", "v", previousCommandMenu);
			previousCommand.keyEquivalent=null;
			previousCommand.keyEquivalentModifiers=null;
			
			var nextCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "next", "v", nextCommandMenu);
			nextCommand.keyEquivalent=null;
			nextCommand.keyEquivalentModifiers=null;
			
			var firstCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "first_frame", "v", firstFrameCommandMenu);
			firstCommand.keyEquivalent=null;
			firstCommand.keyEquivalentModifiers=null;
			
			var endCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "end_frame", "v", endFrameCommandMenu);
			endCommand.keyEquivalent=null;
			endCommand.keyEquivalentModifiers=null;
			
			var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
			fileMenu.addItem(separatorA);
			loopCommand= createNativeMenuItem(fileMenu, "loop", "l", loopCommandMenu);
			loopCommand.keyEquivalentModifiers = [Keyboard.SHIFT];
			
			var separatorB:NativeMenuItem = new NativeMenuItem("B", true);
			fileMenu.addItem(separatorB);
			
			liveViewCommand = createNativeMenuItem(fileMenu, "show_live_view", "l", showLiveCommandMenu);
			return fileMenu;
		}
		
		private function captureCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.CAPTURE_FRAMES);
		}	
		
		private function playCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.TRANSPORT_SWITCH_PLAY);
		}	
		
		private function previousCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.GOTO_PREV_FRAME);
		}	
		
		private function nextCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.GOTO_NEXT_FRAME);
		}	
		
		private function firstFrameCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.GOTO_FIRST_FRAME);
		}	
		
		private function endFrameCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.GOTO_LAST_FRAME);
		}	
		
		private function loopCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.TRANSPORT_SWITCH_LOOP);
		}	
		
		private function showLiveCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.TOGGLE_LIVE_VIDEO);
		}	
		
		/** create Window Menu */
		private function createWindowMenu():NativeMenu { 
			var fileMenu:NativeMenu = new NativeMenu(); 
			 
			var timelapseManagerCommand:NativeMenuItem = createNativeMenuItem(fileMenu, 'timelapse', "t", timelapseCommandMenu);
			return fileMenu; 
		} 
		
		private function timelapseCommandMenu(evt:Event):void {
			sendNotification(ProjectConstant.OPEN_TIMELAPSE_WINDOW);
		}
		
		private function projectManagerCommandMenu(evt:Event):void {
			sendNotification(ProjectConstant.OPEN_PROJECT_MANAGER_WINDOW);
		}
		
		private function createScreenMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu(); 
			var screenMenuCommand:NativeMenuItem = createNativeMenuItem(fileMenu, 'fullscreen', "f", fullscreenCommandMenu);
			return fileMenu; 
		}
		
		private function createHelpMenu():NativeMenu {
			var fileMenu:NativeMenu = new NativeMenu(); 
			var firstCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "help_contents", "v", helpContents);
			firstCommand.keyEquivalent=null;
			firstCommand.keyEquivalentModifiers=null;
			var separatorB:NativeMenuItem = new NativeMenuItem("B", true);
			fileMenu.addItem(separatorB);
			automatiqueUpdatesCommand = createNativeMenuItem(fileMenu, "automatic_updates", "v", toggleAutomaticUpdates);
			automatiqueUpdatesCommand.checked=true;
			automatiqueUpdatesCommand.keyEquivalent=null;
			automatiqueUpdatesCommand.keyEquivalentModifiers=null;
			
			var checkUpdatesCommand:NativeMenuItem = createNativeMenuItem(fileMenu, "check_for_updates_now", "v", automaticUpdatesNow);
			checkUpdatesCommand.keyEquivalent=null;
			checkUpdatesCommand.keyEquivalentModifiers=null;
			
			return fileMenu;
		}
		
		private function helpContents(evt:Event):void {
			trace("helpContents");
		}
		
		private function toggleAutomaticUpdates(evt:Event):void {
			sendNotification(ProjectConstant.TOGGLE_AUTOMATIC_UPDATES);
		}		
		
		private function automaticUpdatesNow(evt:Event):void {
			sendNotification(ProjectConstant.CHECK_FOR_UPDATES);
		}
		
		private function createNativeMenuItem(fileMenu:NativeMenu ,code:String, key:String, func:Function):NativeMenuItem{
			var command:NativeMenuItem = fileMenu.addItem(new NativeMenuItem(resourceManager.getString('GUI_I18NS' , code)));
			command.addEventListener (Event.SELECT, func);
			command.keyEquivalent = key;
			
			addKeyModifier(command);
			return command;
		}
		
		private function addKeyModifier(command:NativeMenuItem):void {
			if (isMac()) {
				command.keyEquivalentModifiers = [Keyboard.COMMAND];
			} else {
				command.keyEquivalentModifiers = [Keyboard.CONTROL];
			}
		}
		
		private function fullscreenCommandMenu(evt:Event):void {
			sendNotification(ProjectConstant.TOGGLE_FULLSCREEN);
		}
		
		private function selectPreviousCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.SELECT_PREVIOUS_FRAME);
		}
		
		private function selectNextCommandMenu(evt:Event):void {
			sendNotification(TakeConstant.SELECT_NEXT_FRAME);
		}
		
		private function updateRecentDocumentMenu(event:Event):void { 
			var docMenu:NativeMenu = NativeMenu(event.target); 
			
			for each (var item:NativeMenuItem in docMenu.items) { 
				docMenu.removeItem(item); 
			}
		} 
		
		private static function isMac():Boolean {
			return Capabilities.os.indexOf('Mac') != -1;
		}
		
		
		private function updateLoopState():void { 
			loopCommand.checked=timeLineProxy.loop; 
		}
		
		public function takeOpenedState():void{
			menuActived(true);
		}
		
		public function setAutomatiqueUpdatesCommandState(state:Boolean):void{
			automatiqueUpdatesCommand.checked=state;
		}
		
		public function get timeLineProxy():TakeTimeLineProxy {
			return facade.retrieveProxy(TakeTimeLineProxy.NAME) as TakeTimeLineProxy;; 
		}
		

	}
}