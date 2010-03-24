package pktn.twitter
{
	import pktn.model.PlayerModel;
	import pktn.config.Config;

	public final class TwitterUtils
	{
		public function TwitterUtils()
		{
		}

		public static function ConvertUserToPlayer(user:Object):PlayerModel
		{
			var player:PlayerModel = new PlayerModel;
			var id:int = user.id;

			player.name = user.screen_name;
			player.upperFullName = user.screen_name;
			player.fullName = user.screen_name;

			// 'koushiroubot' -> 'KOUS'
			player.name = player.name.substring(0,4).toUpperCase();
			// 'koushiroubot' -> 'KOUSHIROUBOT'
			player.upperFullName = player.upperFullName.toUpperCase();

			player.ex = user.statuses_count * 20 +
								user.followers_count * 240 +
								user.friends_count * 80 +
								user.favourites_count * 80;

			if (player.ex < 600000)
			{
				player.lv = Math.sqrt(player.ex * 0.0025);
			}
			else if (player.ex > 600000 + 100000 * 30)
			{
				player.lv = 40 + 30 + Math.sqrt( ( player.ex - (600000 + 100000 * 30) ) / 500000 );
			}
			else
			{
				player.lv = 40 + Math.sqrt( ( player.ex - 600000 ) / 100000 );
			}
			player.lv = rangeCheck(player.lv, 99, 1);

			player.hp = Math.max(user.statuses_count * 0.02, player.lv * 7);
			player.mp = Math.max(user.favourites_count, player.lv * 3);
			player.offence = Math.max(user.friends_count * 0.1, player.lv * 3);
			player.defence = Math.max(user.followers_count * 0.1, player.lv * 3);
			player.agility = Math.max(user.followers_count * 0.06, player.lv * 2);

			player.hp = Math.min(player.hp, player.lv * 12);
			player.mp = Math.min(player.mp, player.lv * 10);
			player.offence = Math.min(player.offence, player.lv * 12);
			player.defence = Math.min(player.defence, player.lv * 11);
			player.agility = Math.min(player.agility, player.lv * 9);

			player.job = decideJob(user);
			player.jobAndColon = player.job.charAt(0) + "：" ;
			player.type = decideType(user.id);

			if (player.job == "スーパースター")
			{
				player.hp *= 0.8;
				player.mp *= 0.4;
				player.offence *= 0.8;
				player.defence *= 0.8;
				player.agility *= 0.8;
			}
			else if (player.job == "まほうつかい")
			{
				player.hp *= 0.6;
				player.mp *= 1.2;
				player.offence *= 0.6;
				player.defence *= 1;
				player.agility *= 1.2;
			}
			else if (player.job == "ぶとうか")
			{
				player.hp *= 0.9;
				player.mp *= 0;
				player.offence *= 1.2;
				player.defence *= 1;
				player.agility *= 1.4;

			}
			else if (player.job == "せんし")
			{
				player.hp *= 1.3;
				player.mp *= 0;
				player.offence *= 1.2;
				player.defence *= 1;
				player.agility *= 0.7;

			}
			else if (player.job == "そうりょ")
			{
				player.hp *= 1;
				player.mp *= 1.2;
				player.offence *= 0.8;
				player.defence *= 1.2;
				player.agility *= 1.2;
			}

			player.hp = rangeCheck(player.hp, 999, 30);
			player.mp = rangeCheck(player.mp, 999, 0);
			player.offence = rangeCheck(player.offence, 999, 10);
			player.defence = rangeCheck(player.defence, 999, 10);
			player.agility = rangeCheck(player.agility, 999, 5);

			player.icon = user.profile_image_url;

			player.maxHp = player.hp;
			player.maxMp = player.mp;

			return player;
		}

		public static function rangeCheck(value:int, max:int, min:int):int
		{
			var _returnValue:int;

			_returnValue = Math.max(value, min);
			_returnValue = Math.min(value, max);

			return _returnValue;
		}

		public static function decideJob(user:Object):String
		{
			if (user.followers_count > 10000)
			{
				return "スーパースター";
			}
			else if (user.statuses_count < user.favourites_count * 10 && user.favourites_count > 50)
			{
				return "まほうつかい";
			}
			else if (user.friends_count > user.followers_count * 1.2)
			{
				return "せんし";
			}
			else if (user.followers_count > 500)
			{
				return "ぶとうか";
			}
			else
			{
				return "そうりょ";
			}
		}
		public static function decideType(id:String):String
		{
			var typeInt:int = parseInt(id)%46;
			return Config.TYPE_ARRAY[typeInt];
		}
	}
}