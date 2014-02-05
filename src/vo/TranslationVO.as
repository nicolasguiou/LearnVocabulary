package vo
{
	public class TranslationVO
	{
		public var id:String;
		public var word1:WordVO;
		public var word2:WordVO;
		public var category:String;
		public var isNew:Boolean;
		public var dateCreated:Date;
		
		public function TranslationVO(object:Object=null)
		{
			if (object)
			{
				this.id = object.id;
				this.word1 = new WordVO(object.word1);
				this.word2 = new WordVO(object.word2);
				this.category = object.category;
				this.isNew = object.isNew;
				this.dateCreated = object.dateCreated;
			}
		}
		
	}
	
}