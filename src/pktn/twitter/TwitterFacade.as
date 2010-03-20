package pktn.twitter
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import org.flaircode.oauth.IOAuth;
	import org.flaircode.oauth.OAuth;
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.utils.OAuthUtil;

	public final class TwitterFacade
	{
		public var so:SharedObject = SharedObject.getLocal("TwitterQuest");

		private const CONSUMER_KEY:String = 's2ytnKKnfmc9fTDapeSPoQ';
		private const CONSUMER_SECRET:String = '6t09gdttjK4YdqoqAjVhRUY38SyDieRxo27yY9NS3M';

		private const CROSSDOMAIN_PROXY:String = 'http://pktn.sakura.ne.jp/work/php/crossdomain-proxy.php?url=';
		private const CROSSDOMAIN_PROXY_TXT:String = 'http://pktn.sakura.ne.jp/work/php/crossdomain-proxy-txt.php?url=';

		private var _requestToken:OAuthToken;
		private var _accessToken:OAuthToken;

		private var _myOauth:IOAuth;
		private var _myLoader:URLLoader;

		public function TwitterFacade()
		{
			_myOauth = new OAuth(CONSUMER_KEY, CONSUMER_SECRET);
			_myLoader = new URLLoader();
			_requestToken = new OAuthToken();
			_accessToken = new OAuthToken();

			// TODO
			//getRequestToken();
		}

		public function getRequestToken():void
		{
			if (so.data.requestToken != null)
			{
				_requestToken.key = so.data.requestToken.key;
				_requestToken.secret = so.data.requestToken.secret;
				getAccessToken();
			} else {
				var request:URLRequest = _myOauth.getRequestTokenRequest("http://twitter.com/oauth/request_token");
				_myLoader = new URLLoader(request);
				_myLoader.addEventListener(Event.COMPLETE, requestTokenHandler);
				_myLoader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			}
		}

		public function requestTokenHandler(e:Event):void
		{
			_requestToken = OAuthUtil.getTokenFromResponse(e.currentTarget.data as String);
			so.data.requestToken = _requestToken;
			var request:URLRequest = _myOauth.getAuthorizeRequest(CROSSDOMAIN_PROXY + "http://twitter.com/oauth/authorize", _requestToken.key);
			navigateToURL(request, "_blank");
			_myLoader.removeEventListener(Event.COMPLETE, requestTokenHandler);

			// retrieve access token
			_accessToken = null;
			so.data.accessToken = null;
			getAccessToken();
		}

		public function getAccessToken():void
		{
			if (so.data.accessToken != null)
			{
				_accessToken.key = so.data.accessToken.key;
				_accessToken.secret = so.data.accessToken.secret;
			} else {
	 			_myLoader = _myOauth.getAccessToken(CROSSDOMAIN_PROXY + "http://twitter.com/oauth/access_token", _requestToken, null);
				_myLoader.addEventListener(Event.COMPLETE, accessTokenHandler);
				_myLoader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			}
		}

		public function accessTokenHandler(e:Event):void
		{
			_accessToken = OAuthUtil.getTokenFromResponse(e.currentTarget.data as String);
			so.data.accessToken = _accessToken;
			_myLoader.removeEventListener(Event.COMPLETE, accessTokenHandler);
			_myLoader.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
		}

		public function IOErrorHandler (e:IOErrorEvent):void
		{
			trace(e.toString());
		}

		public function getUserInformationRequest(screenName:String):URLRequest
		{
			var requestParam:Object = new Object();
			requestParam['screen_name'] = screenName;
			var request:URLRequest = _myOauth.getAccessTokenRequest(CROSSDOMAIN_PROXY + "http://api.twitter.com/1/users/show.json", _requestToken, requestParam);

			return request;
		}

		/* for debug */
		public function clearSo():void
		{
				so.data.accessToken = null;
				so.data.requestToken = null;
		}
	}
}