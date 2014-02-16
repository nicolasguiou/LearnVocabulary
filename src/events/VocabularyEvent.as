package events
{
	import flash.events.Event;
	
	public class VocabularyEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		public static const DISPLAY_TRANSLATION:String = "displayTranslation";
		public static const DISPLAY_FOLDER:String = "displayFolder";
		public static const DISPLAY_BACK:String = "displayBack";

		public var data:*;
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function VocabularyEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.data = data;
		}
		
		
		//--------------------------------------------------------------------------
		//  Overridden methods
		//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new VocabularyEvent(type, data, bubbles);
		}
		
	}
}