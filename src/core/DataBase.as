package core
{
	import spark.managers.PersistenceManager;
	
	import vo.DictionaryVO;
	
	[Bindable]
	public class DataBase extends PersistenceManager
	{
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		private static var instance:DataBase;
		
		public var dbNb:String;
		public var db:String;
		public var dbLength:int;
		public var dictionary:DictionaryVO;
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function DataBase(enforcer:SingletonEnforcer)
		{
			if(enforcer == null)
				throw new Error( "You Can Only Have One DataBase" );
		}
		
		
		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public static function getInstance():DataBase
		{
			if(instance == null)
				instance = new DataBase(new SingletonEnforcer);
			
			return instance;
		}
		
	}
}

// Utility Class to Deny Access to Constructor
class SingletonEnforcer {}