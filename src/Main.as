	import com.adobe.serialization.json.JSON;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.utils.Timer;

	import mx.controls.Alert;
	import mx.effects.Fade;
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
	private var fadeImage:Fade;
	private var fadeBox:Fade;
	public var sm:SoundMaster;

	/* functions */
	/**
	 * initialization
	 * called when applicationComplete
	 *
	 */
	public function init():void
	{
		scene = new SceneDispatcher();
		// TODO
		 sm = new SoundMaster();
		showTitleWindow();
		initStatusView();

		tw = new TwitterFacade();
		urlLoader = new URLLoader();
		loader = new Loader();
		msgTimer = new Timer(0);
		curTimer = new Timer(0);

		// mouse click
		messageWindow.addEventListener(MouseEvent.CLICK, messageWindowDownHandler);
		attack.addEventListener(MouseEvent.CLICK, attackCommandDownHandler);
		// mouse over
		attack.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		runaway.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		guard.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		item.addEventListener(MouseEvent.MOUSE_OVER, commandOverHandler);
		// mouse out
		runaway.addEventListener(MouseEvent.MOUSE_OUT, commandOutHandler);
		guard.addEventListener(MouseEvent.MOUSE_OUT, commandOutHandler);
		attack.addEventListener(MouseEvent.MOUSE_OUT, commandOutHandler);
		item.addEventListener(MouseEvent.MOUSE_OUT, commandOutHandler);
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
			previousWindowButton.visible = false;
			previousWindowButton.enabled = false;
		}
		else if (opponent == null)
		{
			playerNameField.text = "";
			inputPlayerId01.text = Config.STRING_INPUT_OPPONENT_ID_01;
			inputPlayerId02.text = Config.STRING_INPUT_OPPONENT_ID_02;
			previousWindowButton.visible = true;
		}
		else
		{
		}

		playerNameSendButton.label = "けってい　";
		playerNameField.enabled = true;
		playerNameField.text = "";
		playerNameField.setFocus();
		playerNameSendButton.enabled = true;
		nextWindowButton.enabled = false;

		statusIconImage.load(Config.DEFAULT_ICON_URL);
		statusLeft.htmlText = Config.DEFAULT_LEFT_STATUS;
		statusRightLabel.htmlText = Config.DEFAULT_RIGHT_STATUS_LABEL;
		statusRight.htmlText = Config.DEFAULT_RIGHT_STATUS;
	}

	public function getPlayerInformation():void
	{
		sm.playSoundDecide();

		if (playerNameSendButton.label == "やりなおす")
		{
			initStatusView(true);
		}
		else if (playerNameField.text != "")
		{
			urlLoader.load(tw.getUserInformationRequest(playerNameField.text));
			urlLoader.addEventListener(Event.COMPLETE, getUserInformationHandler);
		}
		else
		{
			showDialog();
		}
	}
	public function getOpponentInformation(opponentName:String):void
	{
		sm.playSoundDecide();

		urlLoader.load(tw.getUserInformationRequest(opponentName));
		urlLoader.addEventListener(Event.COMPLETE, getUserInformationHandler);
	}

	public function getUserInformationHandler(e:Event):void
	{
		var json:String = URLLoader(e.currentTarget).data;
		var user:Object = JSON.decode(json);
		// TODO
		if (player == null)
		{
			player = TwitterUtils.ConvertUserToPlayer(user);
			this.statusIconImage.load(player.icon);
			statusLeft.htmlText = StatusModel.getStatusHtmlLeft(player);
			statusRight.htmlText = StatusModel.getStatusHtmlRight(player);
			statusBottom.htmlText = StatusModel.getStatusHtmlBottom(player);
		}
		else if (opponent == null)
		{
			opponent = TwitterUtils.ConvertUserToPlayer(user);
			this.statusIconImage.load(opponent.icon);
			this.opponentIconImage.load(opponent.icon);
			statusLeft.htmlText = StatusModel.getStatusHtmlLeft(opponent);
			statusRight.htmlText = StatusModel.getStatusHtmlRight(opponent);
			statusBottom.htmlText = StatusModel.getStatusHtmlBottom(opponent);
		}
		playerNameSendButton.label = "やりなおす";
		playerNameField.enabled = false;
		nextWindowButton.enabled = true;
		nextWindowButton.visible = true;
		urlLoader.removeEventListener(Event.COMPLETE, getUserInformationHandler);
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
		fadeImage.duration=50;

		blinkCursol();
	}

	/**
	 * mouse event handler
	 */
	public function messageWindowDownHandler(e:MouseEvent):void
	{
		battle.step();
	}
	public function attackCommandDownHandler(e:MouseEvent):void
	{
		scene.showMessageWindow();
		battle.step();
	}
	public function commandOverHandler(e:MouseEvent):void
	{
		if (e.currentTarget.text.match("^ "))
		{
			e.currentTarget.text = e.currentTarget.text.replace(" ","▽");
		}
	}
	public function commandOutHandler(e:MouseEvent):void
	{
		e.currentTarget.text = e.currentTarget.text.replace("▽"," ");
	}

	/**
	 * effects
	 */
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
		messageWindow.removeEventListener(MouseEvent.CLICK, messageWindowDownHandler);
	}
	public function unlockEcho(e:Event):void
	{
		messageTextCursol.visible = true;
		curTimer.start();
		messageWindow.addEventListener(MouseEvent.CLICK, messageWindowDownHandler);
	}
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
	public function flashImage():void
	{
		fadeImage.play(null, true);
	}
	public function showTitleWindow():void
	{
		// fade setting
		fadeBox = new Fade(titleWindow);
		fadeBox.alphaFrom=1;
		fadeBox.alphaTo=0;
		fadeBox.duration=200;
		fadeBox.play(null, true);
		var playReverse:Function = function (evt:TweenEvent):void {
			fadeBox.play(null, false);
			fadeBox.removeEventListener(TweenEvent.TWEEN_END, playReverse);
			fadeBox.addEventListener(TweenEvent.TWEEN_END, scene.gotoPlayerStatus);
		}
		fadeBox.addEventListener(TweenEvent.TWEEN_END, playReverse);
	}
	public function gotoNextWindow():void
	{
		if (player != null && opponent != null)
		{
			scene.gotoBattle();
			startBattle();
		}
		else
		{
			previousWindowButton.visible = true;
			previousWindowButton.enabled = true;
			scene.gotoPlayerStatus();
			initStatusView();
		}
		sm.playSoundDecide();
		playerNameField.enabled = true;
		playerNameSendButton.enabled = true;
		nextWindowButton.visible = false;
		nextWindowButton.enabled = false;
	}
	public function gotoPreviousWindow():void
	{
		sm.playSoundDecide();
		opponent = null;

		playerNameField.enabled = false;
		playerNameField.text = player.fullName;
		playerNameSendButton.label = "やりなおす";
		playerNameSendButton.enabled = true;
		nextWindowButton.enabled = true;

		this.statusIconImage.load(player.icon);
		statusLeft.htmlText = StatusModel.getStatusHtmlLeft(player);
		statusRight.htmlText = StatusModel.getStatusHtmlRight(player);
		statusBottom.htmlText = StatusModel.getStatusHtmlBottom(player);

		playerNameField.setFocus();

		inputPlayerId01.text = Config.STRING_INPUT_PLAYER_ID_01;
		inputPlayerId02.text = Config.STRING_INPUT_PLAYER_ID_02;
		previousWindowButton.visible = false;
		previousWindowButton.enabled = false;
	}

	public function showDialog():void
	{
		Alert.buttonHeight = 30;
		Alert.show("じゅもんが　ちがいます", null, Alert.OK);
		playerNameField.setFocus();
	}

	public function blinkCursol():void
	{
		var _interval:int = 1000;
		curTimer = new Timer(_interval, 0);
		var blink:Function = function (evt:TimerEvent):void {
			messageTextCursol.visible = !messageTextCursol.visible;
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