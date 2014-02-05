package utils
{
	public class MappingIdString
	{
		public static function getCodeLanguage(id:int):String
		{
			switch(id)
			{
				case 0: return "en";
				case 1: return "fr";
				case 2: return "el";
				case 3: return "it";
				case 4: return "es";
				case 5: return "de";
				default : return "";
			}
		}
		
		public static function getCodeId(language:String):int
		{
			switch(language)
			{            
				case "en": return 0;
				case "fr": return 1;
				case "el": return 2;
				case "it": return 3;
				case "es": return 4;
				case "de": return 5;
				default : return 0;
			}
		}
		
		public static function getLanguage(id:int):String
		{
			switch(id)
			{
				case 0: return "English";
				case 1: return "French";
				case 2: return "Greek";
				case 3: return "Italian";
				case 4: return "Spanish";
				case 5: return "Deutsch";
				default : return "";
			}
		}
		
		public static function getId(Langage:String):int
		{
			switch(Langage)
			{
				case "English":	return 0;
				case "French": 	return 1;
				case "Greek": 	return 2;
				case "Italian":	return 3;
				case "Spanish":	return 4;
				case "Deutsch":	return 5;
				default : 		return 0;
			}
		}
	}
}