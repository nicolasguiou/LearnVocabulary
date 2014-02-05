package core
{
	
	import events.CoreDataEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import utils.Constants;

	public class CommunicationBingAPI extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function CommunicationBingAPI()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function translate(toTranslate:String, from:String, to:String):void
		{
			var strUrl : String;
			var translator : HTTPService;
			
			strUrl = "http://api.microsofttranslator.com/v2/Http.svc/Translate?";
			strUrl +=  "appId=" + Constants.API_BING_ID;
			strUrl +=  "&text=" + toTranslate;
			strUrl +=  "&from=" + from;
			strUrl +=  "&to=" + to;
			
			translator = new HTTPService();
			translator.url = strUrl;
			translator.resultFormat = "text";
			translator.addEventListener(ResultEvent.RESULT, onResultTranslate);
			translator.addEventListener(ErrorEvent.ERROR, onErrorTranslate);
			translator.send();
		}
		
		
		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function onResultTranslate(event:ResultEvent):void 
		{
			try 
			{
				dispatchEvent(new CoreDataEvent(CoreDataEvent.TRANSLATE_RESULT, event.result));
			} 
			catch(ignored:Error) 
			{
				trace ("erreur Translate API : " + ignored.toString());
			}
		}
		
		private function onErrorTranslate(event:ErrorEvent):void 
		{
			trace ("erreur Translate API");
		}
		
	}
}