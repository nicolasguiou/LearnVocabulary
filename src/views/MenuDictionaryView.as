////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Hooplo Media
//  All Rights Reserved.
//
//  @author nguiou
//  @date Mar 11, 2013
//
//  NOTICE: This is a notice for anyone reading the source code
//
////////////////////////////////////////////////////////////////////////////////

package views
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.SpinnerList;
	
	import core.CommunicationDataBase;
	
	import utils.TransitionUtils;
	
	import vo.DictionaryVO;
	
	
	public class MenuDictionaryView extends BaseView
	{
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		[SkinPart]
		public var slLanguage:SpinnerList;
		
		[SkinPart]
		public var slVocabulary:SpinnerList;
		
		[SkinPart]
		public var btValid:Button;
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var controller:CommunicationDataBase;
		
		private var _item:DictionaryVO;
		private var _itemDirty:Boolean;
		
		public function get item():DictionaryVO
		{
			return _item;
		}
		
		public function set item(value:DictionaryVO):void
		{
			if (value && value != _item)
			{
				_item = value;
				_itemDirty = true;
				invalidateProperties();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function MenuDictionaryView()
		{
			init();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function set data(value:Object):void
		{
			if (value && value is DictionaryVO)
			{
				super.data = value;
				item = value as DictionaryVO;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_itemDirty 
				&& slLanguage && slVocabulary)
			{
				_itemDirty = false;
				
				slLanguage.selectedIndex = item.language;
				slVocabulary.selectedIndex = item.vocabulary;
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
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function init():void
		{
			controller = new CommunicationDataBase();
			
			initUI();
		}
		
		private function initUI():void
		{
			this.styleName = "menuDictionaryViewSkin";
			this.title = "DICTIONARY";
		}
		
		private function onBtValidClickHandler(event:MouseEvent):void
		{
			if (slLanguage.selectedIndex != slVocabulary.selectedIndex)
			{
				if (!item)
					item = new DictionaryVO();
				
				item.language = slLanguage.selectedIndex;
				item.vocabulary = slVocabulary.selectedIndex;
				
				controller.setDictionary(item);
				navigator.popView(TransitionUtils.slideTransition("down"));
			}
		}
	}
}