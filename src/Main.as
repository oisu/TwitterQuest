	import com.adobe.serialization.json.JSON;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	import mx.controls.Alert;
	import mx.core.IUIComponent;
	import mx.effects.Fade;
	import mx.events.CloseEvent;
	import mx.events.TweenEvent;

	import pktn.battle.Battle;
	import pktn.config.Config;
	import pktn.controller.SceneDispatcher;
	import pktn.controller.SoundMaster;
	import pktn.model.PlayerModel;
	import pktn.model.StatusModel;
	import pktn.twitter.TwitterFacade;
	import pktn.twitter.TwitterUtils;

	/* variables */
	[Bindable]
	public var player:PlayerModel;
	[Bindable]
	public var opponent:PlayerModel;
	[Bindable]
	public var scene:SceneDispatcher;

	private var battle:Battle;
	private var tw:TwitterFacade;
	private var urlLoader:URLLoader;
	private var loader:Loader;
	private var msgTimer:Timer;
	private var curTimer:Timer;
	private var fadeBox:Fade;

	private var currentCommand:String;

	private var textInputEnterKeyLock:Boolean;

	private const ATTACK_COMMAND:String = "attackCommand";
	private const SPELL_COMMAND:String = "spellCommand";
	private const GUARD_COMMAND:String = "guardCommand";
	private const ITEM_COMMAND:String = "itemCommand";

	public var fadeImage:Fade;
	public var sm:SoundMaster;
	public var battleResult:String;

	/* functions */
	/**
	 * initialization
	 * called when applicationComplete
	 *
	 */
	public function init():void
	{
		scene = new SceneDispatcher();
		sm = new SoundMaster();
		showTitleWindow();
		initStatusView();

		player = opponent = null;
		tw = new TwitterFacade();
		urlLoader = new URLLoader();
		loader = new Loader();
		msgTimer = new Timer(0);
		curTimer = new Timer(0);

		// mouse click
		commandWindow.addEventListener(MouseEvent.CLICK, mouseDownHandler);
		// mouse over
		attackCommand.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		spellCommand.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		guardCommand.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		itemCommand.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
	}

	/**
	 * initialize status view
	 *
	 */
	public function initStatusView(isClear:Boolean=false):void
	{
		if (isClear)
		{
			// only clear form and text
			if (opponent != null)
			{
				opponent = null;
			}
			else if (player != null)
			{
				player = null;
			}
		}
		else if (player == null)
		{
			inputPlayerId01.text = Config.STRING_INPUT_PLAYER_ID_01;
			inputPlayerId02.text = Config.STRING_INPUT_PLAYER_ID_02;
			disableComponent(previousWindowButton);
		}
		else if (opponent == null)
		{
			playerNameField.text = "";
			inputPlayerId01.text = Config.STRING_INPUT_OPPONENT_ID_01;
			inputPlayerId02.text = Config.STRING_INPUT_OPPONENT_ID_02;
			enableComponent(previousWindowButton);
		}
		else
		{
		}

		playerNameSendButton.label = "けってい";
		playerNameField.enabled = true;
		playerNameField.text = "";

		enableComponent(playerNameSendButton);
		disableComponent(nextWindowButton);

		statusIconImage.load(Config.DEFAULT_ICON_URL);

		setStatusHtml();

		playerNameField.setFocus();
	}

	public function getPlayerInformation():void
	{
		playerNameField.enabled = false;

		if (playerNameSendButton.label == "やりなおす")
		{
			sm.playSoundDecide();
			initStatusView(true);
			textInputEnterKeyLock = false;
		}
		else if (!textInputEnterKeyLock)
		{
			sm.playSoundDecide();

			if (player != null && player.upperFullName == playerNameField.text)
			{
				showDialog("べつのIDを　していしてください");
			}
			else if (playerNameField.text != "")
			{
				urlLoader.load(tw.getUserInformationRequest(playerNameField.text));
				urlLoader.addEventListener(Event.COMPLETE, getUserInformationHandler);
			}
			else
			{
				showDialog("じゅもんが　ちがいます");
			}
			textInputEnterKeyLock = true;
		}
	}
	public function getOpponentInformation(opponentName:String):void
	{
		if (!textInputEnterKeyLock)
		{
			sm.playSoundDecide();

			urlLoader.load(tw.getUserInformationRequest(opponentName));
			urlLoader.addEventListener(Event.COMPLETE, getUserInformationHandler);
		}
	}

	public function getUserInformationHandler(e:Event):void
	{
		var json:String = URLLoader(e.currentTarget).data;
		var user:Object = JSON.decode(json);

		if (user.error != null)
		{
			showDialog("じゅもんが　ちがいます");
		}
		else
		{
			if (player == null)
			{
				player = TwitterUtils.ConvertUserToPlayer(user);
				this.statusIconImage.load(player.icon);
				setStatusHtml(player);
			}
			else if (opponent == null)
			{
				opponent = TwitterUtils.ConvertUserToPlayer(user);
				this.statusIconImage.load(opponent.icon);
				this.opponentIconImage.load(opponent.icon);
				setStatusHtml(opponent);
			}
			playerNameSendButton.label = "やりなおす";

			playerNameField.enabled = false;

			enableComponent(nextWindowButton);
			urlLoader.removeEventListener(Event.COMPLETE, getUserInformationHandler);

			nextWindowButton.setFocus();
			textInputEnterKeyLock = true;

		}
	}

	public function startBattle():void
	{
		if (player != null && opponent != null)
		{
			battle = new Battle(this);
		}
		// fade setting
		fadeImage = new Fade(opponentIconImage);
		fadeImage.alphaFrom=1;
		fadeImage.alphaTo=0;
		fadeImage.duration=200;

		blinkCursol(attackCommand.getChildByName("Cursol"), 500);
		blinkCursol(spellCommand.getChildByName("Cursol"), 500);
		blinkCursol(guardCommand.getChildByName("Cursol"), 500);
		blinkCursol(itemCommand.getChildByName("Cursol"), 500);
		blinkCursol(messageTextCursol, 1000);

		currentCommand = ATTACK_COMMAND;
		opponentIconImage.visible = true;

	}

	/**
	 * SCENE
	 */
	public function showTitleWindow():void
	{
		// fade setting
		fadeBox = new Fade(titleWindow);
		fadeBox.alphaFrom=1;
		fadeBox.alphaTo=0;
		fadeBox.duration=2000;
		fadeBox.play(null, true);
		var playReverse:Function = function (evt:TweenEvent):void {
			fadeBox.play(null, false);
			fadeBox.removeEventListener(TweenEvent.TWEEN_END, playReverse);
			fadeBox.addEventListener(TweenEvent.TWEEN_END, scene.gotoPlayerStatus);
		}
		fadeBox.addEventListener(TweenEvent.TWEEN_END, playReverse);
	}
	public function gotoNextWindow(e:KeyboardEvent=null):void
	{
		if ((e != null && e.keyCode == Keyboard.ENTER && e.currentTarget.id == "nextWindowButton") || e == null)
		{
			if (player != null && opponent != null)
			{
				scene.gotoBattle();
				startBattle();
			}
			else
			{
				enableComponent(previousWindowButton);
				scene.gotoPlayerStatus();
				initStatusView();
			}
			sm.playSoundDecide();
			playerNameField.enabled = true;

			enableComponent(playerNameSendButton);
			disableComponent(nextWindowButton);

			textInputEnterKeyLock = false;
		}
	}
	public function gotoPreviousWindow():void
	{
		sm.playSoundDecide();
		opponent = null;

		playerNameField.enabled = false;
		playerNameField.text = player.upperFullName.toUpperCase();
		playerNameSendButton.label = "やりなおす";

		enableComponent(playerNameSendButton);
		enableComponent(nextWindowButton);
		disableComponent(previousWindowButton);

		this.statusIconImage.load(player.icon);
		setStatusHtml(player);

		playerNameField.setFocus();

		inputPlayerId01.text = Config.STRING_INPUT_PLAYER_ID_01;
		inputPlayerId02.text = Config.STRING_INPUT_PLAYER_ID_02;

		textInputEnterKeyLock = false;

	}

	public function showDialog(s:String, isYesNo:Boolean=false):void
	{
		Alert.buttonHeight = 30;

		if (!isYesNo)
		{
			var closeHandler:Function = function (event:CloseEvent):void {
				textInputEnterKeyLock = false;
				playerNameField.enabled = true;
			}
			Alert.show(s, null, Alert.OK, null, closeHandler);
		}
		else
		{
			var yesNoCloseHandler:Function = function (event:CloseEvent):void {
				if (event.detail==Alert.YES)
				{
					var url:URLRequest = new URLRequest("http://twitter.com/home");
					var uv:URLVariables = new URLVariables();
					url.method = "GET";

					var targetReg:RegExp = new RegExp(player.upperFullName, "g");
					var replaceStr:String = "@" + player.fullName;
					battleResult = battleResult.replace(targetReg, replaceStr);

					targetReg = new RegExp(opponent.upperFullName, "g");
					replaceStr = "@" + opponent.fullName;
					battleResult = battleResult.replace(targetReg, replaceStr);

					uv.status = "《" + battleResult + "》　Twitter Quest β  -  http://bit.ly/twitterquest";
					url.data = uv;
					navigateToURL(url, "_blank");
				}
				else
				{

				}
				changeColor("#FFFFFF");
				init();
			}
			Alert.show(s, null, (Alert.YES | Alert.NO), null, yesNoCloseHandler);
		}
	}
	public function setStatusHtml(p:PlayerModel=null):void
	{
		if (p == null)
		{
			statusLeft.htmlText = Config.DEFAULT_LEFT_STATUS;
			statusRightLabel.htmlText = Config.DEFAULT_RIGHT_STATUS_LABEL;
			statusRight.htmlText = Config.DEFAULT_RIGHT_STATUS;
		}
		else
		{
			statusLeft.htmlText = StatusModel.getStatusHtmlLeft(p);
			statusRight.htmlText = StatusModel.getStatusHtmlRight(p);
			statusBottom.htmlText = StatusModel.getStatusHtmlBottom(p);
		}
	}

	public function disableComponent(c:IUIComponent):void
	{
		c.enabled = false;
		c.visible = false;
	}
	public function enableComponent(c:IUIComponent):void
	{
		c.enabled = true;
		c.visible = true;
	}

	 /* mouse event handler */
	public function mouseDownHandler(e:MouseEvent):void
	{
		switch (currentCommand)
		{
			case ATTACK_COMMAND:
				battle.step();
			case SPELL_COMMAND:
				break;
			case GUARD_COMMAND:
				break;
			case ITEM_COMMAND:
				break;
		}
	}

	public function commandOverHandler(e:MouseEvent):void
	{
		resetCommands();
		e.currentTarget.getChildByName("Cursol").text = "▽";
		currentCommand = e.currentTarget.id;
	}
	private function resetCommands():void
	{
		attackCommandCursol.text = " ";
		spellCommandCursol.text = " ";
		guardCommandCursol.text = " ";
		itemCommandCursol.text = " ";
	}

	/**
	 * EFFECTS
	 */
	public function shake():void
	{
		var mainViewBaseX:int = mainView.x;
		var mainViewBaseY:int = mainView.y;
		var increment:int = 5;
		const RANGE:int = 3;

		var shakeView:Function = function (evt:Event):void {
			mainView.x += increment;
			mainView.y -= increment;
			if (mainView.x - mainViewBaseX >= RANGE)
			{
				increment *= -1;
			}
			else if (mainView.x - mainViewBaseX <= 0)
			{
				mainView.x = mainViewBaseX;
				mainView.y = mainViewBaseY;
				mainView.removeEventListener(Event.ENTER_FRAME, shakeView);
			}
		}
		mainView.addEventListener(Event.ENTER_FRAME, shakeView);
	}

	public function blinkCursol(ui:Object, interval:int):void
	{
		var _interval:int = interval;
		curTimer = new Timer(_interval, 0);
		var blink:Function = function (evt:TimerEvent):void {
			ui.visible = !ui.visible;
		}
		curTimer.addEventListener(TimerEvent.TIMER, blink);
		curTimer.start();
	}

	public function generateDotImage():void
	{
		var tmpImage:BitmapData = new BitmapData(48/6, 48/6, false);
		var dotImage:BitmapData = new BitmapData(48, 48, false);
		var mtrx1:Matrix = new Matrix(1/6,0,0,1/6,0,0);
		var mtrx2:Matrix = new Matrix(6,0,0,6,0,0);

		tmpImage.draw(statusIconImage, mtrx1);
		dotImage.draw(tmpImage, mtrx2);

		statusIconImage.source = new Bitmap(dotImage);
	}
	public function changeColor(color:String):void
	{
		messageWindow.setStyle("borderColor",color);
		commandVBox.setStyle("borderColor",color);
		targetWindow.setStyle("borderColor",color);
		statusVBox.setStyle("borderColor",color);
		targetWindow.setStyle("borderColor",color);
		targetText.setStyle("color",color);
		targetCursol.setStyle("color",color);
		targetCountText.setStyle("color",color);
		name_1p.setStyle("color",color);
		hp_label.setStyle("color",color);
		hp_1p.setStyle("color",color);
		mp_label.setStyle("color",color);
		mp_1p.setStyle("color",color);
		lv_1p.setStyle("color",color);
		attackCommandText.setStyle("color",color);
		attackCommandCursol.setStyle("color",color);
		spellCommandText.setStyle("color",color);
		spellCommandCursol.setStyle("color",color);
		guardCommandText.setStyle("color",color);
		guardCommandCursol.setStyle("color",color);
		itemCommandText.setStyle("color",color);
		itemCommandCursol.setStyle("color",color);
		messageText.setStyle("color",color);
		messageTextCursol.setStyle("color",color);
	}

	/* show message with interval */
	public function echo(s:String):void
	{
		lockEcho();

		var _interval:int = 20;
		msgTimer = new Timer(_interval, s.length);
		messageText.text = "";
		var _i:int = 0;
		var type:Function = function (evt:TimerEvent):void {
			messageText.text = messageText.text + s.substr(_i, 1);
			_i++;
		}
		msgTimer.addEventListener(TimerEvent.TIMER, type);
		msgTimer.addEventListener(TimerEvent.TIMER_COMPLETE, unlockEcho);
		msgTimer.start();
	}
	public function lockEcho():void
	{
		messageTextCursol.visible = false;
		curTimer.stop();
		messageWindow.removeEventListener(MouseEvent.CLICK, mouseDownHandler);
	}
	public function unlockEcho(e:Event):void
	{
		messageTextCursol.visible = true;
		curTimer.start();
		messageWindow.addEventListener(MouseEvent.CLICK, mouseDownHandler);
	}