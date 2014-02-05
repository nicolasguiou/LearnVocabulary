package events
{
	import flash.events.Event;
	
	public class DataBaseEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		public static const TRANSLATION_DELETED:String = "translationDeleted";
		public static const TRANSLATION_ADDED:String = "translationAdded";
		public static const TRANSLATION_EDITED:String = "translationEdited";
		
		public var data:*;
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function DataBaseEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.data = data;
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new DataBaseEvent(type, data, bubbles);
		}
		
	}
}