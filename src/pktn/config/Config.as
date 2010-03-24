package pktn.config
{
	import pktn.model.PlayerModel;

	public final class Config
	{
		public static const DEFAULT_ICON_URL:String = "http://s.twimg.com/a/1268354287/images/default_profile_1_normal.png";
		public static const DEFAULT_RIGHT_STATUS_LABEL:String = "HP　　　　<BR>MP　　　　 <BR>こうげき力<BR>ぼうぎょ力<BR>すばやさ";
		public static const DEFAULT_LEFT_STATUS:String = "なまえ<BR>しょくぎょう<BR>せいかく<BR>レベル　１";
		public static const DEFAULT_RIGHT_STATUS:String = ":　　0<BR>:　　0<BR>:　　0<BR>:　　0<BR>:　　0";
		public static const DEFAULT_BOTTOM_STATUS:String = "Ex:　　　　　　　　　0";

		public static const STRING_LEVEL:String = "レベル";
		public static const STRING_INPUT_PLAYER_ID_01:String = "*　あなたの　TwitterIDを";
		public static const STRING_INPUT_PLAYER_ID_02:String = "にゅうりょく　してください";

		public static const STRING_INPUT_OPPONENT_ID_01:String = "*　たいせんあいての　TwitterIDを";
		public static const STRING_INPUT_OPPONENT_ID_02:String = "にゅうりょく　してください　　　　";

		public static const TYPE_ARRAY:Array = [
			"あたまでっかち",
			"あまえんぼう",
			"いくじなし",
			"いっぴきおおかみ",
			"いのちしらず",
			"うっかりもの",
			"おおぐらい",
			"おじょうさま",
			"おせっかい",
			"おちょうしもの",
			"おっちょこちょい",
			"おてんば",
			"おとこまさり",
			"がんこもの",
			"がんばりや",
			"きれもの",
			"くろうにん",
			"ごうけつ",
			"さびしがりや",
			"しあわせもの",
			"しょうじきもの",
			"ずのうめいせき",
			"すばしっこい",
			"セクシーギャル",
			"せけんしらず",
			"タフガイ",
			"ちからじまん",
			"てつじん",
			"でんこうせっか",
			"なきむし",
			"なまけもの",
			"ぬけめがない",
			"ねっけつかん",
			"のんきもの",
			"ひっこみじあん",
			"ひねくれもの",
			"ふつう",
			"へこたれない",
			"まけずぎらい",
			"みえっぱり",
			"むっつりスケベ",
			"やさしいひと",
			"ラッキーマン",
			"らんぼうもの",
			"ロマンチスト",
			"わがまま"
			];

		public static var currentMonster:int;

		public static function getAnyMonster():PlayerModel
		{
			var monsterNum:int = Math.round(Math.random() * 3 + 0.5);
			var monster:PlayerModel;

			switch (monsterNum)
			{
				case 1:
					monster = getSlime();
					break;
				case 2:
					monster = getMetalSlime();
					break;
				case 3:
					monster = getBaramos();
					break;
			}
			return monster;
		}

		public static function getSlime():PlayerModel
		{
			var monster:PlayerModel = new PlayerModel();

			monster.name = "スライム";
			monster.fullName = "スライム";
			monster.upperFullName = "スライム";
			monster.job = "モンスター";
			monster.jobAndColon = "モ：";
			monster.icon = "assets/slime_icon.png";

			monster.lv = 1;
			monster.hp = 8;
			monster.mp = 0;
			monster.offence = 8;
			monster.defence = 5;
			monster.agility = 3;
			monster.ex = 0;
			monster.isMonster = true;
			monster.type = Config.TYPE_ARRAY[Math.round(Math.random() * 45 + 0.5)];
			monster.queuing = false;

			return monster;
		}

		public static function getMetalSlime():PlayerModel
		{
			var monster:PlayerModel = new PlayerModel();

			monster.name = "メタルスライム";
			monster.fullName = "メタルスライム";
			monster.upperFullName = "メタルスライム";
			monster.job = "モンスター";
			monster.jobAndColon = "モ：";
			monster.icon = "assets/metalslime_icon.png";

			monster.lv = 1;
			monster.hp = 3;
			monster.mp = 30;
			monster.offence = 56;
			monster.defence = 230;
			monster.agility = 100;
			monster.ex = 0;
			monster.isMonster = true;
			monster.type = Config.TYPE_ARRAY[Math.round(Math.random() * 45 + 0.5)];
			monster.queuing = false;

			return monster;
		}

		public static function getBaramos():PlayerModel
		{
			var monster:PlayerModel = new PlayerModel();

			monster.name = "バラモス";
			monster.fullName = "バラモス";
			monster.upperFullName = "バラモス";
			monster.job = "モンスター";
			monster.jobAndColon = "モ：";
			monster.icon = "assets/baramos_icon.png";

			monster.lv = 99;
			monster.hp = 900;
			monster.mp = 999;
			monster.offence = 220;
			monster.defence = 100;
			monster.agility = 85;
			monster.ex = 0;
			monster.isMonster = true;
			monster.type = Config.TYPE_ARRAY[Math.round(Math.random() * 45 + 0.5)];
			monster.queuing = false;

			return monster;
		}

		public function Config()
		{
		}

	}
}