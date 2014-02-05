package views
{
	import core.CommunicationDataBase;
	import core.DataBase;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	import spark.components.SpinnerList;
	import spark.components.ToggleSwitch;
	
	import utils.MappingIdString;
	import utils.TransitionUtils;
	
	import vo.ExerciceSettingsVO;
	import vo.TranslationVO;
	
	public class MenuExerciceSettingsView extends BaseView
	{
		//--------------------------------------------------------------------------
		//  Skin parts
		//--------------------------------------------------------------------------
		[SkinPart]
		public var slQuestion:SpinnerList;
		
		[SkinPart]
		public var slCategory:SpinnerList;
		
		[SkinPart]
		public var btValid:Button;
		
		[SkinPart]
		public var tsOnlyNew:ToggleSwitch;
		
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		private var communicationDataBase:CommunicationDataBase;
		
		
		private var _dpQuestion:ArrayCollection;
		private var _dpQuestionDirty:Boolean;
		
		public function get dpQuestion():ArrayCollection
		{
			return _dpQuestion;
		}
		
		public function set dpQuestion(value:ArrayCollection):void
		{
			if (value && value != _dpQuestion)
			{
				_dpQuestion = value;
				_dpQuestionDirty = true;
				invalidateProperties();
			}
		}
		
		
		private var _dpCategory:ArrayCollection;
		private var _dpCategoryDirty:Boolean;
		
		public function get dpCategory():ArrayCollection
		{
			return _dpCategory;
		}
		
		public function set dpCategory(value:ArrayCollection):void
		{
			if (value && value != _dpCategory)
			{
				_dpCategory = value;
				_dpCategoryDirty = true;
				invalidateProperties();
			}
		}
		
		private var _selectIndexCategory:int;
		private var _selectIndexCategoryDirty:Boolean;
		
		public function get selectIndexCategory():int
		{
			return _selectIndexCategory;
		}
		
		public function set selectIndexCategory(value:int):void
		{
			if (value && value != _selectIndexCategory)
			{
				_selectIndexCategory = value;
				_selectIndexCategoryDirty = true;
				invalidateProperties();
			}
		}
		
		private var _selectIndexQuestion:int;
		private var _selectIndexQuestionDirty:Boolean;
		
		public function get selectIndexQuestion():int
		{
			return _selectIndexQuestion;
		}
		
		public function set selectIndexQuestion(value:int):void
		{
			if (value && value != _selectIndexQuestion)
			{
				_selectIndexQuestion = value;
				_selectIndexQuestionDirty = true;
				invalidateProperties();
			}
		}
		
		private var _selectOnlyNew:Boolean;
		private var _selectOnlyNewDirty:Boolean;
		
		public function get selectOnlyNew():Boolean
		{
			return _selectOnlyNew;
		}
		
		public function set selectOnlyNew(value:Boolean):void
		{
			if (value && value != _selectOnlyNew)
			{
				_selectOnlyNew = value;
				_selectOnlyNewDirty = true;
				invalidateProperties();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function MenuExerciceSettingsView()
		{
			init();
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_dpQuestionDirty && slQuestion)
			{
				_dpQuestionDirty = false;
				slQuestion.dataProvider = dpQuestion;
			}
			
			if (_dpCategoryDirty && slCategory)
			{
				_dpCategoryDirty = false;
				slCategory.dataProvider = dpCategory;
			}
			
			if (_selectIndexCategoryDirty && slCategory)
			{
				_selectIndexCategoryDirty = false;
				slCategory.selectedIndex = selectIndexCategory;
			}
			
			if (_selectIndexQuestionDirty && slQuestion)
			{
				_selectIndexQuestionDirty = false;
				slQuestion.selectedIndex = selectIndexQuestion;
			}
			
			if (_selectOnlyNewDirty && tsOnlyNew)
			{
				_selectOnlyNewDirty = false;
				tsOnlyNew.selected = selectOnlyNew;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == btValid)
				btValid.addEventListener(MouseEvent.CLICK, onBtValidClickHandler);
			
			invalidateProperties();
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == btValid)
				btValid.removeEventListener(MouseEvent.CLICK, onBtValidClickHandler);
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
			
			initData();
		}
		
		private function initUI():void
		{
			this.styleName = "menuExerciceSettingsViewSkin";
			this.title = "EXERCICE SETTINGS";
		}
		
		private function onBtValidClickHandler(event:MouseEvent):void
		{
			var exerciceSettings:ExerciceSettingsVO = new ExerciceSettingsVO();
			
			exerciceSettings.questionType = slQuestion.selectedItem.data; // 1=language | 2=vocabulary | -1=random
			exerciceSettings.category = slCategory.selectedItem;
			exerciceSettings.isOnlyNew = tsOnlyNew.selected;
			
			communicationDataBase.setExerciceSetting(exerciceSettings);
			navigator.popView(TransitionUtils.slideTransition("down"));
		}
		
		private function initData():void
		{
			if (DataBase.getInstance().dictionary)
			{
				var language:int = DataBase.getInstance().dictionary.language;
				var vocabulary:int = DataBase.getInstance().dictionary.vocabulary;
				
				dpQuestion = new ArrayCollection([
					{type:"Only " + MappingIdString.getLanguage(language), data:language}, 
					{type:"Only " + MappingIdString.getLanguage(vocabulary), data:vocabulary}, 
					{type:"Random", data:-1}]);
				
				dpCategory = getAllCategories();
				
				var exerciceSettings:ExerciceSettingsVO;
				exerciceSettings = communicationDataBase.getExerciceSetting();
				
				if (exerciceSettings)
				{
					selectIndexCategory = dpCategory.getItemIndex(exerciceSettings.category);
					
					if (exerciceSettings.questionType == -1)
						selectIndexQuestion = 2;
					else if (exerciceSettings.questionType == language)
						selectIndexQuestion = 0;
					else if (exerciceSettings.questionType == vocabulary)
						selectIndexQuestion = 1;
					
					selectOnlyNew = exerciceSettings.isOnlyNew;
				}
			}
		}
		
		private function getAllCategories():ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			var db:ArrayCollection = communicationDataBase.getDataBase();
			var n:int = db.length;
			var translation:TranslationVO;
			var tmpCategory:String;
			
			for (var i:int = 0 ; i < n ; i++)
			{
				translation = new TranslationVO(db.getItemAt(i));
				tmpCategory = translation.category;
				
				if (tmpCategory.indexOf(" ") != -1)
				{
					var tmpArrayOfCategory:Array = tmpCategory.split(" ");
					
					for (var j:int = 0; j < tmpArrayOfCategory.length; j++) 
					{
						if (result.contains(tmpArrayOfCategory[j]) == false)
							result.addItem(tmpArrayOfCategory[j]);
					}
					
				}
				else if (result.contains(tmpCategory) == false)
				{
					result.addItem(tmpCategory);
				}
			}
			
			return result;
		}
		
	}
}