package views
{
   import com.greensock.TweenMax;
   
   import core.CommunicationBingAPI;
   import core.CommunicationDataBase;
   import core.DataBase;
   
   import events.CoreDataEvent;
   import events.DataBaseEvent;
   
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   import mx.events.FlexEvent;
   import mx.utils.UIDUtil;
   
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.components.VGroup;
   import spark.components.ViewMenuItem;
   
   import utils.MappingIdString;
   import utils.TransitionUtils;
   
   import vo.DictionaryVO;
   import vo.TranslationVO;
   import vo.WordVO;
   
   public class HomeView extends BaseView
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
      public var tiCategory:TextInput;
      
      [SkinPart]
      public var chCategory:CheckBox;
      
      [SkinPart]
      public var chNewWord:CheckBox;
      
      [SkinPart]
      public var btAdd:Button;
      
      [SkinPart]
      public var btTranslate:Button;
      
      [SkinPart]
      public var imgDeleteWord1:Image;
      
      [SkinPart]
      public var imgDeleteWord2:Image;
      
      [SkinPart]
      public var imgDeleteCategory:Image;
      
      [SkinPart]
      public var imgSettings:Image;
      
      [SkinPart]
      public var grpSettings:VGroup;
      
      
      //--------------------------------------------------------------------------
      //  Properties
      //--------------------------------------------------------------------------
      private var communicationDataBase:CommunicationDataBase;
      private var communicationBingAPI:CommunicationBingAPI;
      
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
      
      private var _isSettingsVisible:Boolean;
      private var _isSettingsVisibleDirty:Boolean;
      
      public function get isSettingsVisible():Boolean
      {
         return _isSettingsVisible;
      }
      
      public function set isSettingsVisible(value:Boolean):void
      {
         _isSettingsVisible = value;
         _isSettingsVisibleDirty = true;
         invalidateProperties();
      }
      
      //--------------------------------------------------------------------------
      //  Constructor
      //--------------------------------------------------------------------------
      public function HomeView()
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
         
         if (_isSettingsVisibleDirty && grpSettings)
         {
            _isSettingsVisibleDirty = false;
            grpSettings.visible = isSettingsVisible;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object):void
      {
         super.partAdded(partName, instance);
         
         switch (instance)
         {
            case btAdd :
               btAdd.addEventListener(MouseEvent.CLICK, onBtAddClickHandler);
               break;
            case btTranslate :
               btTranslate.addEventListener(MouseEvent.CLICK, onBtTranslateClickHandler);
               break;
            case imgDeleteWord1 :
               imgDeleteWord1.addEventListener(MouseEvent.CLICK, onImgDeleteWordClickHandler);
               break;
            case imgDeleteWord2 :
               imgDeleteWord2.addEventListener(MouseEvent.CLICK, onImgDeleteWordClickHandler);
               break;
            case imgDeleteCategory :
               imgDeleteCategory.addEventListener(MouseEvent.CLICK, onImgDeleteWordClickHandler);
               break;
            case imgSettings :
               imgSettings.addEventListener(MouseEvent.CLICK, onImgSettingsClickHandler);
               break;
         }
         
         invalidateProperties();
      }
	  
      override protected function partRemoved(partName:String, instance:Object):void
      {
         super.partRemoved(partName, instance);
         
         switch (instance)
         {
            case btAdd :
               btAdd.removeEventListener(MouseEvent.CLICK, onBtAddClickHandler);
               break;
            case btTranslate :
               btTranslate.removeEventListener(MouseEvent.CLICK, onBtTranslateClickHandler);
               break;
            case imgDeleteWord1 :
               imgDeleteWord1.removeEventListener(MouseEvent.CLICK, onImgDeleteWordClickHandler);
               break;
            case imgDeleteWord2 :
               imgDeleteWord2.removeEventListener(MouseEvent.CLICK, onImgDeleteWordClickHandler);
               break;
            case imgDeleteCategory :
               imgDeleteCategory.removeEventListener(MouseEvent.CLICK, onImgDeleteWordClickHandler);
               break;
            case imgSettings :
               imgSettings.removeEventListener(MouseEvent.CLICK, onImgSettingsClickHandler);
               break;
         }   
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
         communicationBingAPI = new CommunicationBingAPI();
         
		 communicationDataBase.importOldDB();
		 
         initUI();
         initMenus();
         initListeners();
      }
      
      private function initUI():void
      {
         this.styleName = "homeViewSkin";
         this.title = "HOME";
         
         setLanguageVocabulary();
         
         isSettingsVisible = false;
      }
      
      private function initMenus():void
      {
         var menuDictionary:ViewMenuItem = new ViewMenuItem();
         menuDictionary.id = "dictionary";
         menuDictionary.label = "Dictionary";
         menuDictionary.addEventListener(MouseEvent.CLICK, menuClickedHanlder);
         
         this.menus = [menuDictionary];
      }
      
      private function menuClickedHanlder(event:MouseEvent):void 
      {
         switch (event.currentTarget.id) 
         { 
            case "dictionary" : 
               navigator.pushView(MenuDictionaryView, DataBase.getInstance().dictionary, null, TransitionUtils.slideTransition()); 
               break; 
         }
      }
      
      private function initListeners():void
      {
         this.addEventListener(FlexEvent.CREATION_COMPLETE, checkIsFirstInit);
      }
      
      private function initTiWords():void
      {
         tiWord1.text = "";
         tiWord2.text = "";			
      }
      
      private function setLanguageVocabulary():void
      {
         if (DataBase.getInstance().dictionary)
         {
            sourceLanguage = DataBase.getInstance().dictionary.language;
            sourceVocabulary = DataBase.getInstance().dictionary.vocabulary;
         }
      }
      
      private function checkIsFirstInit(event:FlexEvent):void
      {
         this.removeEventListener(FlexEvent.CREATION_COMPLETE, checkIsFirstInit);
         
         DataBase.getInstance().dictionary = communicationDataBase.getDictionary();
         
         var dictionary:DictionaryVO = DataBase.getInstance().dictionary;
         
         if (!dictionary)
            navigator.pushView(MenuDictionaryView);
         else
         {
            sourceLanguage = dictionary.language;
            sourceVocabulary = dictionary.vocabulary;
         }
      }
	  
      private function onBtTranslateClickHandler(event:MouseEvent):void
      {
         if (tiWord1.text || tiWord2.text)
         {
            displayInfo("Translating ...");
			
            communicationBingAPI.addEventListener(CoreDataEvent.TRANSLATE_RESULT, onTranslateResultHandler);
            
            var dictionary:DictionaryVO = DataBase.getInstance().dictionary;
            var vocabulary:String = MappingIdString.getCodeLanguage(dictionary.vocabulary);
            var language:String = MappingIdString.getCodeLanguage(dictionary.language);
            
            if (!tiWord1.text)
               communicationBingAPI.translate(tiWord2.text, vocabulary, language);
            else
               communicationBingAPI.translate(tiWord1.text, language, vocabulary);
         }
      }
      
      private function onBtAddClickHandler(event:MouseEvent):void
      {
         if (tiWord1.text && tiWord2.text)
         {
            communicationDataBase.addEventListener(DataBaseEvent.TRANSLATION_ADDED, onAddedResultHandler);
			communicationDataBase.addTranslation(createTranslationVO());
         }
      }
      
      private function onImgDeleteWordClickHandler(event:MouseEvent):void
      {
         if (event.currentTarget is Image 
            && (event.currentTarget as Image).id == "imgDeleteWord1")
            tiWord1.text = "";
         else if (event.currentTarget is Image 
            && (event.currentTarget as Image).id == "imgDeleteWord2")
            tiWord2.text = "";
         else if (event.currentTarget is Image 
            && (event.currentTarget as Image).id == "imgDeleteCategory")
            tiCategory.text = "";
      }
      
      private function onImgSettingsClickHandler(event:MouseEvent):void
      {
         isSettingsVisible = !isSettingsVisible;
      }
      
      private function onTranslateResultHandler(event:CoreDataEvent):void
      {
         communicationBingAPI.removeEventListener(CoreDataEvent.TRANSLATE_RESULT, onTranslateResultHandler);
         
		 hideInfo();
		 
         var result : XML = new XML(event.data);
         
         if (!tiWord1.text)
            tiWord1.text = result;
         else
            tiWord2.text = result;
      }
      
      private function onAddedResultHandler(event:DataBaseEvent):void
      {
		 communicationDataBase.removeEventListener(DataBaseEvent.TRANSLATION_ADDED, onAddedResultHandler);

		 displayInfo("Word Added");
		 setTimeout(hideInfo, 3000);
		 
         initTiWords();
      }
      
      private function createTranslationVO():TranslationVO
      {
         var word1:WordVO = new WordVO();
         word1.id = UIDUtil.createUID();
         word1.word = tiWord1.text;
         word1.language = DataBase.getInstance().dictionary.language;
         
         var word2:WordVO = new WordVO();
         word2.id = UIDUtil.createUID();
         word2.word = tiWord2.text;
         word2.language = DataBase.getInstance().dictionary.vocabulary;
         
         var translationVO:TranslationVO = new TranslationVO();
         translationVO.id = UIDUtil.createUID();
         translationVO.word1 = word1;
         translationVO.word2 = word2;
         translationVO.isNew = true;
         translationVO.category = (chCategory.selected) ? tiCategory.text : "-";
         translationVO.dateCreated = new Date();
         
         return translationVO;
      }
      
      private function hideInfo():void
      {
		 TweenMax.to(lbInfo, 1, {autoAlpha:0});
      }
	  
	  private function displayInfo(str:String):void
	  {
		  lbInfo.alpha = 0
		  lbInfo.text = str;
		  
		  TweenMax.to(lbInfo, 1, {autoAlpha:1});
	  }
   }
}