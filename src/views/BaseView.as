package views
{
	import spark.components.View;
	import spark.components.ViewMenuItem;
	
	import utils.ComponentsUtils;
	
	public class BaseView extends View
	{
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		private var _menus:Array;
		private var _menusDirty:Boolean;
		
		public function set menus(value:Array):void
		{
			if (value && value != menus)
			{
				_menus = value;
				_menusDirty = true;
				invalidateProperties();
			}
		}
		
		public function get menus():Array
		{
			return _menus
		}
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function BaseView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override protected function createChildren():void
		{
			addElement(ComponentsUtils.backgroundRect());
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_menusDirty)
			{
				_menusDirty = false;
				this.viewMenuItems = new Vector.<ViewMenuItem>
				fillMenu();
			}
		}
		
		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function fillMenu():void
		{
			var n:int = menus.length;
			
			for(var i:int = 0 ; i < n ; i++)
				this.viewMenuItems.push(menus[i]);
		}
		
	}
}