package views
{
	import com.greensock.TweenMax;
	
	import core.CommunicationDataBase;
	import core.DataBase;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.ViewMenuItem;
	
	import utils.MappingIdString;
	import utils.TransitionUtils;
	
	import vo.DictionaryVO;
	import vo.ExerciceSettingsVO;
	import vo.TranslationVO;
	
	public class ExerciceView extends BaseView
	{
		//--------------------------------------------------------------------------
		//  Skin parts
		//--------------------------------------------------------------------------
		[SkinPart]
		public var lbInfo:Label;
		
		[SkinPart]
		public var lbLanguage:Label;
		
		[SkinPart]
		public var lbVocabulary:Label;
		
		[SkinPart]
		public var tiWord1:TextInput;
		
		[SkinPart]
		public var tiWord2:TextInput;
		
		[SkinPart]
		public var btStartValid:Button;
		
		[SkinPart]
		public var btStop:Button;
		
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		private var communicationDataBase:CommunicationDataBase;
		private var exerciceSettings:ExerciceSettingsVO;
		private var db:ArrayCollection;
		private var dictionary:DictionaryVO;
		private var currentTranslation:TranslationVO;
		private var isStarted:Boolean;
		private var isQuestionForWord1:Boolean;
		private var numAnswers:int;
		private var numCorrectAnswers:int;
		
		
		private var _sourceLanguage:int;
		private var _sourceLanguageDirty:Boolean;
		
		public function get sourceLanguage():int
		{
			return _sourceLanguage;
		}
		
		public function set sourceLanguage(value:int):void
		{
			_sourceLanguage = value;
			_sourceLanguageDirty = true;
			invalidateProperties();
		}
		
		private var _sourceVocabulary:int;
		private var _sourceVocabularyDirty:Boolean;
		
		public function get sourceVocabulary():int
		{
			return _sourceVocabulary;
		}
		
		public function set sourceVocabulary(value:int):void
		{
			_sourceVocabulary = value;
			_sourceVocabularyDirty = true;
			invalidateProperties();
		}
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function ExerciceView()
		{
			init();
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_sourceLanguageDirty && lbLanguage)
			{
				_sourceLanguageDirty = false;
				lbLanguage.text = MappingIdString.getLanguage(sourceLanguage);
			}
			
			if (_sourceVocabularyDirty && lbVocabulary)
			{
				_sourceVocabularyDirty = false;
				lbVocabulary.text = MappingIdString.getLanguage(sourceVocabulary);
			}
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == btStartValid)
				btStartValid.addEventListener(MouseEvent.CLICK, onBtStartValidClickHandler);
			if (instance == btStop)
				btStop.addEventListener(MouseEvent.CLICK, onBtStopClickHandler);
			
			invalidateProperties();
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == btStartValid)
				btStartValid.removeEventListener(MouseEvent.CLICK, onBtStartValidClickHandler);
			if (instance == btStop)
				btStop.removeEventListener(MouseEvent.CLICK, onBtStopClickHandler);
		}	
		
		
		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function init():void
		{
			communicationDataBase = new CommunicationDataBase();
			
			initUI();
			initMenus();
			initListeners();
		}
		
		private function initUI():void
		{
			this.styleName = "exerciceViewSkin";
			this.title = "EXERCICE";
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteHandler);
		}
		
		private function initMenus():void
		{
			var menuDictionary:ViewMenuItem = new ViewMenuItem();
			menuDictionary.id = "dictionary";
			menuDictionary.label = "Dictionary";
			menuDictionary.addEventListener(MouseEvent.CLICK, menuClickedHanlder);
			
			var menuExerciceSettings:ViewMenuItem = new ViewMenuItem();
			menuExerciceSettings.id = "settings";
			menuExerciceSettings.label = "Settings";
			menuExerciceSettings.addEventListener(MouseEvent.CLICK, menuClickedHanlder);
			
			this.menus = [menuDictionary, menuExerciceSettings];
		}
		
		private function initListeners():void
		{
		}
		
		private function onCreationCompleteHandler(event:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteHandler);
			
			initExercice(false);
			setSettings();
		}
		
		private function menuClickedHanlder(event:MouseEvent):void 
		{
			switch (event.currentTarget.id) 
			{ 
				case "dictionary" : 
					navigator.pushView(MenuDictionaryView, DataBase.getInstance().dictionary, null, TransitionUtils.slideTransition()); 
					break; 
				case "settings" : 
					navigator.pushView(MenuExerciceSettingsView, null, null, TransitionUtils.slideTransition()); 
					break; 
			}
		}
		
		private function initTiWords():void
		{
			tiWord1.text = "";
			tiWord2.text = "";			
		}
		
		private function setSettings():void
		{
			setLanguageVocabulary();
			
			exerciceSettings = communicationDataBase.getExerciceSetting();
		}
		
		private function setLanguageVocabulary():void
		{
			if (DataBase.getInstance().dictionary)
			{
				sourceLanguage = DataBase.getInstance().dictionary.language;
				sourceVocabulary = DataBase.getInstance().dictionary.vocabulary;
			}
		}
		
		private function onBtStartValidClickHandler(event:MouseEvent):void
		{
			if (isStarted)
				validAnswer();
			else
				startExercice();
		}
		
		private function startExercice():void
		{
			dictionary = DataBase.getInstance().dictionary;
			db = communicationDataBase.getDataBase();
			var tmpCat:ArrayCollection = new ArrayCollection();
			var tmpNew:ArrayCollection = new ArrayCollection();
				
			tmpCat.addAll(db);
			
			if (exerciceSettings && exerciceSettings.category != "-")
			{
				tmpCat.filterFunction = categoryFilter;
				tmpCat.refresh();
			}
			
			tmpNew.addAll(tmpCat);
					
			if (exerciceSettings && exerciceSettings.isOnlyNew)
			{
				tmpNew.filterFunction = newWordFilter;
				tmpNew.refresh();
			}
			
			db = tmpNew;
			
			if (dictionary && db && db.length > 0)
			{
				initExercice(true);
				getQuestion();
			}
			else
			{
				displayInfo("No word in this library !");
			}
		}
		
		private function validAnswer():void
		{
			numAnswers++;
			
			if ((isQuestionForWord1
				&& tiWord2.text == currentTranslation.word2.word)
				|| (!isQuestionForWord1
					&& tiWord1.text == currentTranslation.word1.word))
			{
				displayInfo("Correct", 0x00FF00, 1000);
				numCorrectAnswers++;
			}
			else
			{
				var info:String;
				info = "Wrong : ";
				info += currentTranslation.word1.word;
				info += " = ";
				info += currentTranslation.word2.word;
				
				displayInfo(info , 0xFF0000, 2000);
			}
			
			getQuestion();
		}
		
		private function onBtStopClickHandler(event:MouseEvent):void
		{
			initExercice(false);
			displayResult();
		}
		
		private function initExercice(value:Boolean):void
		{
			isStarted = value;
			btStop.visible = value;
			btStartValid.label = (value) ? "Valid" : "Start";
			initTiWords();
		}
		
		private function displayResult():void
		{
			var strResult:String = "";
			
			strResult += "Score : ";
			strResult += numCorrectAnswers;
			strResult += "/";
			strResult += numAnswers;
			
			displayInfo(strResult);
		}
		
		private function getQuestion():void
		{
			if(db.length > 0)
			{
				currentTranslation = new TranslationVO();
				currentTranslation = db[Math.round(Math.random() * (db.length-1))];
				
				initTiWords();
				
				if (exerciceSettings)
				{
					// 1=language | 2=vocabulary | -1=random
					
					if (exerciceSettings.questionType == -1) // random
					{
						if (Math.random() > 0.5)
						{
							tiWord1.text = currentTranslation.word1.word;
							isQuestionForWord1 = true;
						}
						else
						{
							tiWord2.text = currentTranslation.word2.word;
							isQuestionForWord1 = false;
						}
					}
					else if (exerciceSettings.questionType == currentTranslation.word2.language)
					{
						tiWord2.text = currentTranslation.word2.word;
						isQuestionForWord1 = false;
					}
					else
					{
						tiWord1.text = currentTranslation.word1.word;
						isQuestionForWord1 = true;
					}
				}
				else
				{
					tiWord1.text = currentTranslation.word1.word;
					isQuestionForWord1 = true;
				}
			}
		}
		
		private function newWordFilter(item:Object):Boolean
		{
			if (item) 
				return item.isNew;
			
			return false;
		}
		
		private function categoryFilter(item:Object):Boolean
		{
			if (item) 
			{
				if ((item.category as String).indexOf(" ") != -1)
				{
					var tmpArrayOfCategory:Array = (item.category as String).split(" ");
					
					for (var j:int = 0; j < tmpArrayOfCategory.length; j++) 
					{
						if (tmpArrayOfCategory[j] == exerciceSettings.category)
							return true;
						else
							return false;
						
					}
				}
				else
					return item.category == exerciceSettings.category;
			}
			
			return false;
		}
		
		private function hideInfo():void
		{
			TweenMax.to(lbInfo, 1, {autoAlpha:0});
		}
		
		private function displayInfo(str:String, color:uint=0xFFFFFF, time:int=3000):void
		{
			lbInfo.setStyle("color", color);
			lbInfo.alpha = 0
			lbInfo.text = str;
			
			TweenMax.to(lbInfo, 1, {autoAlpha:1});
			
			setTimeout(hideInfo, time);
		}
		
	}
}