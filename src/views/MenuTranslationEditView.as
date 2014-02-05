package views
{
	import core.CommunicationDataBase;
	import core.DataBase;
	
	import events.DataBaseEvent;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.ToggleSwitch;
	
	import utils.MappingIdString;
	import utils.TransitionUtils;
	
	import vo.TranslationVO;
	
	public class MenuTranslationEditView extends BaseView
	{
		//--------------------------------------------------------------------------
		//  Skin parts
		//--------------------------------------------------------------------------
		[SkinPart]
		public var lbLanguage:Label;
		
		[SkinPart]
		public var lbVocabulary:Label;
		
		[SkinPart]
		public var tiLanguage:TextInput;
		
		[SkinPart]
		public var tiVocabulary:TextInput;
		
		[SkinPart]
		public var tiCategory:TextInput;
		
		[SkinPart]
		public var tsIsNew:ToggleSwitch;
		
		[SkinPart]
		public var btCancel:Button;
		
		[SkinPart]
		public var btDelete:Button;
		
		[SkinPart]
		public var btSave:Button;
		
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		private var communicationDataBase:CommunicationDataBase;

		private var _item:TranslationVO;
		private var _itemDirty:Boolean;
		
		public function get item():TranslationVO
		{
			return _item;
		}
		
		public function set item(value:TranslationVO):void
		{
			if (value && value != _item)
			{
				_item = value;
				_itemDirty = true;
				invalidateProperties();
			}
		}
		
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
		public function MenuTranslationEditView()
		{
			init();
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override public function set data(value:Object):void
		{
			if (value && value is TranslationVO)
			{
				super.data = value;
				item = value as TranslationVO;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_itemDirty 
				&& tiCategory && tsIsNew
				&& tiLanguage && tiVocabulary)
			{
				_itemDirty = false;
				
				tiLanguage.text = item.word1.word;
				tiVocabulary.text = item.word2.word;
				tiCategory.text = item.category;
				tsIsNew.selected = item.isNew;
			}
			
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
			
			if (instance == btCancel)
				btCancel.addEventListener(MouseEvent.CLICK, onBtCancelClickHandler);
			else if (instance == btDelete)
				btDelete.addEventListener(MouseEvent.CLICK, onBtDeleteClickHandler);
			else if (instance == btSave)
				btSave.addEventListener(MouseEvent.CLICK, onBtSaveClickHandler);
			
			invalidateProperties();
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == btCancel)
				btCancel.removeEventListener(MouseEvent.CLICK, onBtCancelClickHandler);
			else if (instance == btDelete)
				btDelete.removeEventListener(MouseEvent.CLICK, onBtDeleteClickHandler);
			else if (instance == btSave)
				btSave.removeEventListener(MouseEvent.CLICK, onBtSaveClickHandler);
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
			
			setLanguageVocabulary();
		}
		
		private function initUI():void
		{
			this.styleName = "menuTranslationEditViewSkin";
			this.title = "EDIT";
		}
		
		private function onBtCancelClickHandler(event:MouseEvent):void
		{
			onExitView(null);
		}
		
		private function onBtDeleteClickHandler(event:MouseEvent):void
		{
			communicationDataBase.addEventListener(DataBaseEvent.TRANSLATION_DELETED, onExitView);
			communicationDataBase.deleteTranslation(item);
		}
		
		private function onBtSaveClickHandler(event:MouseEvent):void
		{
			item.word1.word = tiLanguage.text;
			item.word2.word = tiVocabulary.text;
			item.category = tiCategory.text; 
			item.isNew = tsIsNew.selected;
			
			communicationDataBase.addEventListener(DataBaseEvent.TRANSLATION_EDITED, onExitView);
			communicationDataBase.editTranslation(item);
		}
		
		private function onExitView(event:DataBaseEvent):void
		{
			if (communicationDataBase.hasEventListener(DataBaseEvent.TRANSLATION_EDITED))
				communicationDataBase.removeEventListener(DataBaseEvent.TRANSLATION_EDITED, onExitView);

			if (communicationDataBase.hasEventListener(DataBaseEvent.TRANSLATION_DELETED))
				communicationDataBase.removeEventListener(DataBaseEvent.TRANSLATION_DELETED, onExitView);

			navigator.popView(TransitionUtils.crossFadeTransition());
		}
		
		private function setLanguageVocabulary():void
		{
			if (DataBase.getInstance().dictionary)
			{
				sourceLanguage = DataBase.getInstance().dictionary.language;
				sourceVocabulary = DataBase.getInstance().dictionary.vocabulary;
			}
		}
		
	}
}