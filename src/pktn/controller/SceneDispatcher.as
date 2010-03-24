package pktn.controller
{
	import mx.events.TweenEvent;

	public class SceneDispatcher
	{
		[Bindable]
		public var activeView:int;
		[Bindable]
		public var activeWindow:int;

		public const TITLE_VIEW:int = 0;
		public const STATUS_VIEW:int = 1;
		public const BATTLE_VIEW:int = 2;

		private const COMMAND_WINDOW:int = 0;
		private const MESSAGE_WINDOW:int = 1;

		public function SceneDispatcher()
		{
			activeView = TITLE_VIEW;
			activeWindow = MESSAGE_WINDOW;
		}

		public function gotoTitle(evt:Event=null):void
		{
			activeView = TITLE_VIEW;
		}
		public function gotoPlayerStatus(evt:Event=null):void
		{
			activeView = STATUS_VIEW;
		}
		public function gotoBattle(evt:Event=null):void
		{
			activeView = BATTLE_VIEW;
		}
		public function showCommandWindow(evt:Event=null):void
		{
			activeWindow = COMMAND_WINDOW;
		}
		public function showMessageWindow(evt:Event=null):void
		{
			activeWindow = MESSAGE_WINDOW;
		}
		public function isBattleView():Boolean
		{
			if (activeView == BATTLE_VIEW)
			{
				return true;
			}
			return false;
		}
		public function isStatusView():Boolean
		{
			if (activeView == STATUS_VIEW)
			{
				return true;
			}
			return false;
		}
	}
}