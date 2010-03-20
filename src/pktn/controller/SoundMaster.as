package pktn.controller
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	public final class SoundMaster
	{
		private var _playerAttack:Sound;
		private var _opponentAttack:Sound;
		private var _playerHit:Sound;
		private var _opponentHit:Sound;
		private var _select:Sound;
		private var _decide:Sound;

		private var _channel:SoundChannel;

		public function SoundMaster()
		{
			_channel = new SoundChannel();

			_playerAttack = new Sound();
			_opponentAttack = new Sound();
			_playerHit = new Sound();
			_opponentHit = new Sound();
			_select = new Sound();
			_decide = new Sound();

			_opponentAttack.load(new URLRequest("assets/opponent_attack.mp3"));
			_playerAttack.load(new URLRequest("assets/player_attack.mp3"));
			_opponentHit.load(new URLRequest("assets/opponent_hit.mp3"));
			_select.load(new URLRequest("assets/select.mp3"));
			_decide.load(new URLRequest("assets/decide.mp3"));
		}

		public function playSoundOpponentHit():void
		{
			_channel = _opponentHit.play();
		}
		public function playSoundPlayerAttack():void
		{
			_channel = _playerAttack.play();
		}
		public function playSoundOpponentAttack():void
		{
			_channel = _opponentAttack.play();
		}
		public function playSoundSelect():void
		{
			_channel = _select.play();
		}
		public function playSoundDecide():void
		{
			_channel = _decide.play();
		}

	}
}