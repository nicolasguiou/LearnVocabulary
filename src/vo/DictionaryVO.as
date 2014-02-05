package vo
{
	public class DictionaryVO
	{
		public var language:int;
		public var vocabulary:int;
		
		public function DictionaryVO(object:Object=null)
		{
			if (object)
			{
				this.language = object.language;
				this.vocabulary = object.vocabulary;
			}
		}
		
	}
}