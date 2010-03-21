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

		private const ST_COMMAND:int = 0;
		private const ST_LAST_PLAYER_TURN:int = 1;
		private const ST_PLAYER_ATTACK:int = 11;
		private const ST_OPPONENT_ATTACK:int = 21;
		private const ST_PLAYER_HIT:int = 12;
		private const ST_OPPONENT_HIT:int = 22;
		private const ST_PLAYER_MISS:int = 13;
		private const ST_OPPONENT_MISS:int = 23;
		private const ST_MESSAGE_END:int = 31;
		private const ST_PLAYER_DIED:int = 41;
		private const ST_OPPONENT_DIED:int = 49;
		private const ST_GAME_OVER:int = 99;

		private const MAX_TURN_COUNT:int = 10;

		/**
		 * constructor
		 */
		public function Battle(q:Main)
		{
			this.q = q;
			_player = q.player;
			_opponent = q.opponent;

			_commandStatus = ST_COMMAND;
			// TODO LANG化
			q.echo(_opponent.upperFullName + "が　あらわれた！");
		}

		/**
		 * step battle
		 */
		public function step():void
		{
			switch (_commandStatus)
			{
				// last player turn -> command
				case ST_LAST_PLAYER_TURN:
					q.scene.showCommandWindow();
					_commandStatus = ST_COMMAND;
					break;

				// command -> player turn
				case ST_COMMAND:
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
						_commandStatus = ST_LAST_PLAYER_TURN;
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

				// player hit -> command
				case ST_PLAYER_HIT:
					hit(_player, _opponent);
					_player.queuing = false;
					_commandStatus = ST_COMMAND;
					break;

				// opponent attack -> player hit
				case ST_OPPONENT_ATTACK:
					// TODO 回避判定
					attack(_opponent, _player);
					_commandStatus = ST_OPPONENT_HIT;
					break;

				// opponent hit -> command
				case ST_OPPONENT_HIT:
					hit( _opponent, _player);
					_opponent.queuing = false;
					_commandStatus = ST_COMMAND;
					break;

				// turn end -> command
				case ST_MESSAGE_END:
					q.scene.showCommandWindow();
					_commandStatus = ST_LAST_PLAYER_TURN;
					break;

				// when player died
				case ST_PLAYER_DIED:
					playerDied();
					break;

				// when opponent died
				case ST_OPPONENT_DIED:
					opponentDied();
					break;

				// game over
				case ST_GAME_OVER:
					gameOver();
					break;
			}
			checkEOT();
		}

		private function attack(offencive:PlayerModel, defencive:PlayerModel):void
		{
			q.echo(offencive.upperFullName + "の　こうげき！　");
			q.battleResult = "";
			q.battleResult = offencive.upperFullName + "の　こうげき！　";

			// player attack
			if (offencive.upperFullName == _player.upperFullName)
			{
			}
			// opponent attack
			else
			{
			}
			// TODO 回避判定
			//miss(offencive, defencive);
		}

		private function hit(offencive:PlayerModel, defencive:PlayerModel):void
		{
			var damage:int = 0;
			damage = offencive.offence * 0.5 - defencive.defence * 0.25;
			damage += 1/3 * damage * (Math.random() - 1/6);

			if (damage > defencive.hp) {
				defencive.hp = 0;
			}
			else
			{
				defencive.hp -= damage;
			}

			// player hit
			if (offencive.upperFullName == _player.upperFullName)
			{
				q.fadeImage.play(null, true);
				q.echo(defencive.upperFullName + "に　" + damage + "のダメージ！　");
				q.battleResult += defencive.upperFullName + "に　" + damage + "のダメージ！　";
				//q.sm.playSoundPlayerHit();
			}
			// opponent hit
			else
			{
				q.shake();
				q.echo(defencive.upperFullName + "は　" + damage + "のダメージを　うけた！　");
				q.battleResult += defencive.upperFullName + "は　" + damage + "のダメージを　うけた！　";
				//q.sm.playSoundOpponentHit();
			}
		}

		private function miss(offencive:PlayerModel, defencive:PlayerModel):void
		{
			q.echo(defencive.upperFullName + "は　ひらりと　みをかわした！");
		}

		private function checkEOT():void
		{
			if (_player.maxHp * 0.25 > _player.hp)
			{
				q.changeColor("#FF7763");
			}
			if (_player.hp == 0 && _commandStatus != ST_GAME_OVER)
			{
				_commandStatus = ST_PLAYER_DIED;
			}
			else if (_opponent.hp == 0 && _commandStatus != ST_GAME_OVER)
			{
				_commandStatus = ST_OPPONENT_DIED;
			}
		}

		private function playerDied():void
		{
			q.scene.showMessageWindow();
			q.echo(_player.upperFullName + "は　しんでしまった・・・");
			q.battleResult += _player.upperFullName + "は　しんでしまった・・・";
			_commandStatus = ST_GAME_OVER;
		}
		private function opponentDied():void
		{
			q.scene.showMessageWindow();
			q.echo(_opponent.upperFullName + "を　やっつけた！");
			q.opponentIconImage.visible = false;
			q.battleResult += _opponent.upperFullName + "を　やっつけた！";
			_commandStatus = ST_GAME_OVER;
		}

		private function gameOver():void
		{
			q.showDialog("たたかいの　けっかを　つぶやきますか？", true);
		}
	}
}