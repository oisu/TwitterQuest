package pktn.model
{
	import pktn.config.Config;

	public final class StatusModel
	{

		public function StatusModel()
		{

		}

		public static function getStatusHtmlLeft(player:PlayerModel):String
		{
			var statusHtmlLeft:String;
			statusHtmlLeft = player.name + "<BR>" + player.job + "<BR>" + Config.STRING_LEVEL + spacePadding(player.lv.toString(), 2);
			return statusHtmlLeft;
		}

		public static function getStatusHtmlRight(player:PlayerModel):String
		{
			var statusHtmlRight:String;
			statusHtmlRight =
					"：" + spacePadding(player.hp.toString(), 3) + "<BR>" +
					"：" + spacePadding(player.mp.toString(), 3) + "<BR>" +
					"：" + spacePadding(player.offence.toString(), 3) + "<BR>" +
					"：" + spacePadding(player.defence.toString(), 3) + "<BR>" +
					"：" + spacePadding(player.agility.toString(), 3);
			return statusHtmlRight;
		}

		public static function getStatusHtmlBottom(player:PlayerModel):String
		{
			var statusHtmlBottom:String;
			statusHtmlBottom = "Ex：" + spacePadding(player.ex.toString(), 10);
			return statusHtmlBottom;
		}

		public static function spacePadding(s:String, c:int):String
		{
			var paddedString:String = "";

			if (s.length < c)
			{
				for (var i:int=0; i<c-s.length; i++)
				{
					paddedString += "　";
				}
			}
			paddedString += s;

			return paddedString;
		}
	}
}