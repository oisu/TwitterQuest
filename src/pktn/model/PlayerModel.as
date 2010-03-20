package pktn.model
{
	import flash.events.EventDispatcher;

	public final class PlayerModel
	{
		private static const INITIAL_VALUE:int = 0;

		[Bindable]
		public var lv:int;
		[Bindable]
		public var name:String;
		[Bindable]
		public var hp:int;
		[Bindable]
		public var mp:int;
		[Bindable]
		public var job:String;
		[Bindable]
		public var fullName:String;

		public var offence:int;
		public var defence:int;
		public var agility:int;
		public var intelligence:int;
		public var luck:int;
		public var ex:int;

		public var icon:String;

		public var queuing:Boolean;

		public function PlayerModel()
		{
			this.lv = INITIAL_VALUE;
			this.name = "";

			this.hp = INITIAL_VALUE;
			this.mp = INITIAL_VALUE;
			this.offence = INITIAL_VALUE;
			this.defence = INITIAL_VALUE;
			this.agility = INITIAL_VALUE;
			this.intelligence = INITIAL_VALUE;
			this.luck = INITIAL_VALUE;
			this.ex = INITIAL_VALUE;

			this.job = "";
			this.icon = "";
			this.queuing = false;
		}

//		public function set lv(i:int):void
//		{
//			_lv = i;
//		}
//		public function get lv():int
//		{
//			return _lv;
//		}
//		public function set name(s:String):void
//		{
//			_name = s;
//		}
//		public function get name():String
//		{
//			return _name;
//		}
//		public function set hp(i:int):void
//		{
//			_hp = i;
//		}
//		public function get hp():int
//		{
//			return _hp;
//		}
//		public function set mp(i:int):void
//		{
//			_mp = i;
//		}
//		public function get mp():int
//		{
//			return _mp;
//		}
//		public function set offence(i:int):void
//		{
//			_offence = i;
//		}
//		public function get offence():int
//		{
//			return _offence;
//		}
//		public function set defence(i:int):void
//		{
//			_defence = i;
//		}
//		public function get defence():int
//		{
//			return _defence;
//		}
//		public function set agility(i:int):void
//		{
//			_agility = i;
//		}
//		public function get agility():int
//		{
//			return _agility;
//		}
//		public function set luck(i:int):void
//		{
//			_luck = i;
//		}
//		public function get luck():int
//		{
//			return _luck;
//		}
//		public function set icon(i:String):void
//		{
//			_icon = i;
//		}
//		public function get icon():String
//		{
//			return _icon;
//		}
	}
}