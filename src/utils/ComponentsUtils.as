package utils
{
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	
	import spark.primitives.Rect;

	public class ComponentsUtils
	{
		public static function backgroundRect():Rect
		{
			var color1:GradientEntry = new GradientEntry(0x385D9C, 0.2);
			var color2:GradientEntry = new GradientEntry(0X98A2B3, 0.7);
			var color3:GradientEntry = new GradientEntry(0XB2C9DB, 0.95, 0.8);
			
			var linearGradient:LinearGradient = new LinearGradient();
			linearGradient.entries = [color1, color2, color3];
			linearGradient.rotation = 90;
			
			var rect:Rect = new Rect();
			rect.percentHeight = 100;
			rect.percentWidth = 100;
			rect.fill = linearGradient;
			
			return rect;
		}
	}
}