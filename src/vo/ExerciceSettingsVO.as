package vo
{
	public class ExerciceSettingsVO
	{
		public var questionType:int;
		public var category:String;
		public var isOnlyNew:Boolean;
		
		public function ExerciceSettingsVO(object:Object=null)
		{
			if (object)
			{
				this.questionType = object.questionType;
				this.category = object.category;
				this.isOnlyNew = object.isOnlyNew;
			}
		}
	}
}