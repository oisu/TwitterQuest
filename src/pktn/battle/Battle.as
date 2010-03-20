package pktn.battle
{
	import pktn.model.PlayerModel;

	public final class Battle
	{
		private var q:Main;

		private var _player:PlayerModel;
		private var _opponent:PlayerModel;
		private var _turnCount:int;

		private var _commandStatus:int;

		private const ST_DEFAULT:int = 0;
		private const ST_PLAYER_ATTACK:int = 11;
		private const ST_OPPONENT_ATTACK:int = 21;
		private const ST_PLAYER_HIT:int = 12;
		private const ST_OPPONENT_HIT:int = 22;
		private const ST_PLAYER_MISS:int = 13;
		private const ST_OPPONENT_MISS:int = 23;
		private const ST_MESSAGE_END:int = 99;

		private const MAX_TURN_COUNT:int = 10;

		/**
		 * constructor
		 */
		public function Battle(q:Main)
		{
			this.q = q;
			_player = q.player;
			_opponent = q.opponent;

			_commandStatus = ST_MESSAGE_END;
			// TODO LANG化
			q.echo(_opponent.name + "が　あらわれた！");
		}

		public function step():void
		{
			switch (_commandStatus)
			{
				// command -> first player turn
				case ST_DEFAULT:
					q.scene.showMessageWindow();
					if (_player.queuing && _opponent.queuing)
					{
						if (_player.agility >= _opponent.agility)
						{
							_commandStatus = ST_PLAYER_ATTACK;
						} else {
							_commandStatus = ST_OPPONENT_ATTACK;
						}
					}
					else if (!_player.queuing && !_opponent.queuing)
					{
						_player.queuing = true;
						_opponent.queuing = true;
						_commandStatus = ST_DEFAULT;
						q.scene.showCommandWindow();
					}
					else if (_player.queuing && !_opponent.queuing)
					{
						_commandStatus = ST_PLAYER_ATTACK;
					}
					else if (!_player.queuing && _opponent.queuing)
					{
						_commandStatus = ST_OPPONENT_ATTACK;
					}
					step();
					break;
				// first player turn -> attack
				case ST_PLAYER_ATTACK:
					// TODO 回避判定
					attack(_player, _opponent);
					_commandStatus = ST_PLAYER_HIT;
					break;
				case ST_PLAYER_HIT:
					hit(_player, _opponent);
					_player.queuing = false;
					_commandStatus = ST_DEFAULT;
					break;
				case ST_OPPONENT_ATTACK:
					// TODO 回避判定
					attack(_opponent, _player);
					_commandStatus = ST_OPPONENT_HIT;
					break;
				case ST_OPPONENT_HIT:
					hit( _opponent, _player);
					_opponent.queuing = false;
					_commandStatus = ST_DEFAULT;
					break;
				case ST_MESSAGE_END:
					q.scene.showCommandWindow();
					_commandStatus = ST_DEFAULT;
				default:
					break;
			}
		}

		public function attack(offencive:PlayerModel, defencive:PlayerModel):void
		{
			q.echo(offencive.name + "の　こうげき！\n");
			q.sm.playSoundOpponentAttack();
			// TODO 回避判定
			//miss(offencive, defencive);
		}

		public function hit(offencive:PlayerModel, defencive:PlayerModel):void
		{
			var damage:int = 0;
			damage = offencive.offence * 0.5 - defencive.defence * 0.25;
			damage += 1/3 * damage * (Math.random() - 1/6);
			defencive.hp -= damage;

			if (offencive.name == _player.name)
			{
				q.flashImage();
				q.echo(defencive.name + "に　" + damage + "のダメージ！");
				q.sm.playSoundOpponentHit();
			}
			else
			{
				q.shake();
				q.echo(defencive.name + "は　" + damage + "のダメージを　うけた！");
			}
		}

		public function miss(offencive:PlayerModel, defencive:PlayerModel):void
		{
			q.echo(defencive.name + "は　ひらりと　みをかわした！");
		}

		private function checkEOT():Boolean
		{
			if (_player.hp <= 0 || _opponent.hp <= 0)
			{
				return false;
			}
			else if (_turnCount >MAX_TURN_COUNT)
			{
				return false;
			}
			return true;
		}
	}
}