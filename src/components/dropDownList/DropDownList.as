package components.dropDownList
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.InteractionMode;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.LabelItemRenderer;
	import spark.components.supportClasses.TextBase;
	import spark.events.RendererExistenceEvent;

	use namespace mx_internal;
	

	[Style(name="popUpHeight", type="Number", format="int")]
	[Style(name="popUpWidth", type="Number", format="int")]
	[Style(name="requestedRowCount", type="Number", format="int")]
	public class DropDownList extends spark.components.DropDownList
	{
		public function DropDownList()
		{
			super();
			itemRenderer = new ClassFactory(spark.components.LabelItemRenderer);
		}

		[SkinPart]
		public var closeButton : Button;
		
		[SkinPart]
		public var headerLabelDisplay : TextBase;
		
		override protected function commitProperties():void{
			super.commitProperties();
			
			if(this.labelChanged == true){
				if(this.headerLabelDisplay)
					this.headerLabelDisplay.text = this.label;

				this.labelChanged = false;
			}
			
			if(this.closeButtonLabelChanged == true){
				if(this.closeButton)
					this.closeButton.label = this.closeButtonLabel;

				this.closeButtonLabelChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == dataGroup)
			{
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler_Extended);
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, dataGroup_rendererRemoveHandler_Extended);
			} else if (instance == closeButton){
				this.closeButton.addEventListener(MouseEvent.CLICK,onCloseButtonClick);
				this.closeButton.label = this.closeButtonLabel
			} else if (instance == headerLabelDisplay)
				this.headerLabelDisplay.text = this.label;

		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == dataGroup)
			{
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler_Extended);
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE, dataGroup_rendererRemoveHandler_Extended);
			} else if (instance == closeButton)
				this.closeButton.removeEventListener(MouseEvent.CLICK,onCloseButtonClick);

			super.partRemoved(partName, instance);
		}		
		
		private var _closeButtonLabel : String = 'Cancel';
		protected var closeButtonLabelChanged : Boolean = false;

		[Bindable(event="closeButtonLabelChange")]
		[Inspectable(category="Mobile DropDownList", defaultValue="Cancel",format="String",name="Close Button Label",type="String")]
		public function get closeButtonLabel():String
		{
			return _closeButtonLabel;
		}

		public function set closeButtonLabel(value:String):void
		{
			if( _closeButtonLabel !== value)
			{
				_closeButtonLabel = value;
				dispatchEvent(new Event("closeButtonLabelChange"));
				closeButtonLabelChanged = true;
				this.invalidateProperties();
			}
		}

		private var _label : String;
		protected  var labelChanged : Boolean = false;

		[Inspectable(category="Mobile DropDownList", defaultValue="",format="String",name="Header Text",type="String")]
		[Bindable(event="labelChange")]
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if( _label !== value)
			{
				_label = value;
				dispatchEvent(new Event("labelChange"));
				labelChanged = true;
				this.invalidateProperties();
			}
		}

		protected function dataGroup_rendererAddHandler_Extended(event:RendererExistenceEvent):void
		{
			var index:int = event.index;
			var renderer:IVisualElement = event.renderer;
			
			if (!renderer)
				return;
			
			renderer.addEventListener(MouseEvent.CLICK, item_clickHandler);
		}
		
		protected function dataGroup_rendererRemoveHandler_Extended(event:RendererExistenceEvent):void
		{
			var index:int = event.index;
			var renderer:Object = event.renderer;
			
			if (!renderer)
				return;
			
			renderer.removeEventListener(MouseEvent.CLICK, item_clickHandler);
		}
		
		protected function item_clickHandler(event:MouseEvent):void{
			super.item_mouseDownHandler(event);
			super.mouseUpHandler(event);
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			// do nothing because mouse up and mouse down handlers don't work quite right on mobile devices 
			// rewrote all of this to use the click event 
		}			

		protected function onCloseButtonClick(event:MouseEvent):void{
			closeDropDown(false);
		}
		
		override mx_internal function positionIndexInView(index:int, topOffset:Number = NaN,
														  bottomOffset:Number = NaN, 
														  leftOffset:Number = NaN,
														  rightOffset:Number = NaN):void
		{
			var requestedRowCount : int = this.getStyle('requestedRowCount');
			if((this.dataProvider) && (index >= this.dataProvider.length-requestedRowCount))
				index = this.dataProvider.length-requestedRowCount;

			super.positionIndexInView(index, topOffset, bottomOffset, leftOffset, rightOffset);
			
		}		
	}
}