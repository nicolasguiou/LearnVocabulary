package core
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxConfig;
	import org.hamster.dropbox.DropboxEvent;
	import org.hamster.dropbox.models.DropboxFile;
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	
	public class CommunicationDropBox
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private static const APP_KEY:String = "a1w6docuubtu7sq";
		private static const APP_SECRET:String = "8a0ntbs8ohbt67h";
		private static const ROOT_LOCATION:String = "sandbox";
		
		public var client:DropboxClient;
		
		private var config:DropboxConfig;
		private var file:DropboxFile;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CommunicationDropBox()
		{
			setConfigDropBox();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		public function getAccess():void
		{
			client.addEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, onResultAccessTokenHandler);
			client.addEventListener(DropboxEvent.ACCESS_TOKEN_FAULT, onFaultAccessTokenHandler);
			
			client.accessToken();
		}
		
		public function writeFile(path:String, fileName:String, data:ByteArray):void
		{
			client.addEventListener(DropboxEvent.PUT_FILE_RESULT, putFileResultHanlder);
			client.addEventListener(DropboxEvent.PUT_FILE_FAULT, putFileFaultHanlder);
			var url:URLLoader = client.putFile(path, fileName, data, "", true, "", ROOT_LOCATION);
		}
		
		public function readFile(path:String):void
		{
			client.addEventListener(DropboxEvent.GET_FILE_RESULT, getFileResultHanlder);
			client.addEventListener(DropboxEvent.GET_FILE_FAULT, getFileFaultHanlder);
			var url:URLLoader = client.getFile(path, "", ROOT_LOCATION);
		}
		
		public function createFolder(folderName:String):void
		{
			client.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, onResultCreateFolderFileHandler);
			client.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT, onFaultCreateFolderFileHandler);
			var url:URLLoader = client.fileCreateFolder(folderName, ROOT_LOCATION);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function setConfigDropBox():void
		{
			config = new DropboxConfig(APP_KEY, APP_SECRET);
			
			getToken();
		}
		
		private function getToken():void
		{
			client = new DropboxClient(config);
			
			client.addEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, onResultRequestTokenHandler);
			client.addEventListener(DropboxEvent.REQUEST_TOKEN_FAULT, onFaultRequestTokenHandler);
			
			client.requestToken();
		}
		
		private function onResultRequestTokenHandler(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, onResultRequestTokenHandler);
			config.requestTokenKey = event.resultObject.key;
			config.requestTokenSecret = event.resultObject.secret;
			
			client.dispatchEvent(new DataEvent("urlDropBox", false, false, client.authorizationUrl));
		}
		
		private function onFaultRequestTokenHandler(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.REQUEST_TOKEN_FAULT, onFaultRequestTokenHandler);
			trace("Error Request Token");
		}
		
		private function onResultAccessTokenHandler(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, onResultAccessTokenHandler);

			config.accessTokenKey = event.resultObject.key;
			config.accessTokenSecret = event.resultObject.secret;
			
			client.dispatchEvent(new Event("DropBoxAccess"));
		}
		
		private function onFaultAccessTokenHandler(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.ACCESS_TOKEN_FAULT, onFaultAccessTokenHandler);
			trace("Error Access Token");
		}
		
		private function onResultCreateFolderFileHandler(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, onResultCreateFolderFileHandler);
			trace("OK CreateFolder");
		}
		
		private function onFaultCreateFolderFileHandler(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT, onFaultCreateFolderFileHandler);
			trace("Error CreateFolder");
		}
		
		private function getFileResultHanlder(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.GET_FILE_RESULT, getFileResultHanlder);
			trace("ok get file");
			var byteData:ByteArray = event.resultObject as ByteArray;
			byteData.position = 0;
			var res:String = byteData.readUTFBytes(byteData.length);
			client.dispatchEvent(new DataEvent("getFileResult", false, false, res));
		}
		
		private function getFileFaultHanlder(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.GET_FILE_FAULT, getFileFaultHanlder);
			trace("Error get file");
		}
		
		private function putFileResultHanlder(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.PUT_FILE_RESULT, putFileResultHanlder);
			trace("ok put file");
		}
		
		private function putFileFaultHanlder(event:DropboxEvent):void
		{
			client.removeEventListener(DropboxEvent.PUT_FILE_FAULT, putFileFaultHanlder);
			trace("Error put file");
		}
	}
}