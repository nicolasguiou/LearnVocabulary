package vo
{
	public class WordVO
	{
		public var id:String;
		public var language:int;
		public var word:String;
		
		public function WordVO(object:Object=null)
		{
			if (object)
			{
				this.id = object.id;
				this.language = object.language;
				this.word = object.word;
			}
		}
	}
}