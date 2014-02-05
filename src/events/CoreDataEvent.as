package events
{
	import flash.events.Event;
	
	public class CoreDataEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		public static const ADDED_RESULT:String = "addedResult";
		public static const TRANSLATE_RESULT:String = "translateResult";

		public var data:*;
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function CoreDataEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.data = data;
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override public function clone():Event
		{
		 	return new CoreDataEvent(type, data, bubbles);
		}
		
	}
}