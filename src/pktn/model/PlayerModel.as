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
		public var jobAndColon:String;
		[Bindable]
		public var upperFullName:String;

		public var fullName:String;

		public var maxHp:int;
		public var maxMp:int;
		public var offence:int;
		public var defence:int;
		public var agility:int;
		public var type:String;
		public var ex:int;

		public var isMonster:Boolean;

		public var icon:String;

		public var queuing:Boolean;

		public function PlayerModel()
		{
			this.lv = INITIAL_VALUE;
			this.name = "";

			this.maxHp = INITIAL_VALUE;
			this.maxMp = INITIAL_VALUE;
			this.hp = INITIAL_VALUE;
			this.mp = INITIAL_VALUE;
			this.offence = INITIAL_VALUE;
			this.defence = INITIAL_VALUE;
			this.agility = INITIAL_VALUE;
			this.ex = INITIAL_VALUE;
			this.type = "";

			this.job = "";
			this.jobAndColon = "";
			this.icon = "";
			this.queuing = false;
			this.isMonster = false;
		}
	}
}