package utils
{
	import spark.transitions.CrossFadeViewTransition;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.ViewTransitionDirection;
	import spark.transitions.ZoomViewTransition;

	public class TransitionUtils
	{
		// it's depracated !!!
		public static function zoomTransition(mode:String="out"):ZoomViewTransition
		{
			var transition:ZoomViewTransition = new ZoomViewTransition();
			transition.mode = mode;
			transition.duration = 300;
			
			return transition;
		}
		
		public static function slideTransition(direction:String="up"):SlideViewTransition
		{
			var transition:SlideViewTransition = new SlideViewTransition();
			transition.direction = direction;
			transition.duration = 300;
			
			return transition;
		}
		
		public static function crossFadeTransition():CrossFadeViewTransition
		{
			var transition:CrossFadeViewTransition = new CrossFadeViewTransition();
			transition.duration = 300;
			
			return transition;
		}
	}
}