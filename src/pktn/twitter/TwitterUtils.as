package pktn.twitter
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import pktn.model.PlayerModel;

	public final class TwitterUtils
	{
		public function TwitterUtils()
		{
		}

		public static function ConvertUserToPlayer(user:Object):PlayerModel
		{
			var player:PlayerModel = new PlayerModel;

			player.name = user.screen_name;
			player.fullName = user.screen_name;

			player.hp = user.statuses_count * 0.1;
			player.mp = user.favourites_count;
			player.offence = user.friends_count * 0.1;
			player.defence = user.followers_count * 0.1;
			player.agility = user.followers_count * 0.05;
			player.icon = user.profile_image_url;
			player.ex = user.statuses_count * 2 + user.followers_count * 15 + user.friends_count * 10 + user.favourites_count * 100;

			player.job = "ニート";
			player.lv = player.ex * 0.001;

			// 'koushiroubot' -> 'KOUS'
			player.name = player.name.substring(0,4).toUpperCase();
			player.fullName = player.name.toUpperCase();

			player.hp = Math.min(player.hp, 255);
			player.hp = Math.max(player.hp, 30);
			player.mp = Math.min(player.mp, 255);
			player.mp = Math.max(player.mp, 0);
			player.offence = Math.min(player.offence, 255);
			player.offence = Math.max(player.offence, 10);
			player.defence = Math.min(player.defence, 255);
			player.defence = Math.max(player.defence, 10);
			player.agility = Math.min(player.agility, 255);
			player.agility = Math.max(player.agility, 5);

			player.lv = Math.min(player.lv, 99);

			return player;
		}
	}
}