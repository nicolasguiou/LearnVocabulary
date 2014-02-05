package utils
{
   public class EmbedAssets
   {
      [Embed( source = "/assets/settings.png" )]
      public static var SETTINGS:Class;
	  
	  [Embed( source = "/assets/close.png" )]
	  public static var CLOSE:Class;
	  
	  [Embed( source = "/assets/play.png" )]
	  public static var PLAY:Class;
	  
	  [Embed( source = "/assets/stop.png" )]
	  public static var STOP:Class;
      
   }
}