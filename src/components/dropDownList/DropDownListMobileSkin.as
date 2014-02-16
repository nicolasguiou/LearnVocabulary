package components.dropDownList {
import flash.display.Sprite;
import flash.text.TextLineMetrics;

import spark.components.Button;
import spark.components.DataGroup;
import spark.components.Group;
import spark.components.IItemRenderer;
import spark.components.Label;
import spark.components.PopUpAnchor;
import spark.components.PopUpPosition;
import spark.components.Scroller;
import spark.layouts.VerticalLayout;
import spark.skins.mobile.ButtonSkin;
import spark.skins.mobile.supportClasses.MobileSkin;

public class DropDownListMobileSkin extends MobileSkin {
    public function DropDownListMobileSkin() {
        super();
    }

    private var _hostComponent:DropDownList;

    public function get hostComponent():DropDownList {
        return _hostComponent;
    }

    public function set hostComponent(value:DropDownList):void {
        _hostComponent = value;
    }

    protected var openButtonSkin:Class = null;

    public var popUp:PopUpAnchor;

    public var dropDown:Group;

    public var scroller:Scroller;

    public var dataGroup:DataGroup;

    public var openButton:Button;

    public var labelDisplay:Label;

    public var separationLine:Sprite;

    override protected function commitCurrentState():void {
        super.commitCurrentState();

        alpha = currentState.indexOf("disabled") == -1 ? 1 : 0.5;

        if (this.currentState == 'open') {
            if (this.popUp)
                this.popUp.displayPopUp = true;

            this.invalidateDisplayList();
        } else {
            if (this.popUp)
                this.popUp.displayPopUp = false;

            this.invalidateDisplayList();
        }
    }

    override protected function createChildren():void {
        super.createChildren();

        if (!this.openButton) {
            this.openButton = new Button();
            this.openButton.focusEnabled = false;
            this.openButton.right = 0;
            this.openButton.top = 0;
            this.openButton.bottom = 0;
            this.openButton.setStyle('skinClass', openButtonSkin);
            this.addChild(this.openButton);
        }

        if (!this.labelDisplay) {
            this.labelDisplay = new Label();
            this.labelDisplay.setStyle('verticalAlign', 'middle');
            this.labelDisplay.maxDisplayedLines = 1;
            this.labelDisplay.mouseEnabled = false;
            this.labelDisplay.mouseChildren = false;
            this.labelDisplay.left = 7;
            this.labelDisplay.right = 30;
            this.labelDisplay.top = 2;
            this.labelDisplay.bottom = 2;
            this.labelDisplay.verticalCenter = 1;
            this.addChild(this.labelDisplay);
        }

        if (!this.popUp) {
            this.popUp = new PopUpAnchor();
            this.popUp.left = 0;
            this.popUp.right = 0;
            this.popUp.top = 0;
            this.popUp.bottom = 0;
            this.popUp.setStyle('itemDestructionPolicy', 'auto');
            this.popUp.popUpPosition = PopUpPosition.TOP_LEFT;
            this.popUp.popUpWidthMatchesAnchorWidth = true;
            this.popUp.depth = 100;
        }

        if (!this.dropDown)
            this.dropDown = new Group();

        if (!this.scroller) {
            this.scroller = new Scroller();
            this.scroller.left = 0;
            this.scroller.top = 0;
            this.scroller.right = 0;
            this.scroller.bottom = 0;
            this.scroller.hasFocusableChildren = false;
            this.scroller.minViewportInset = 1;
        }

        if (!this.dataGroup) {
            this.dataGroup = new DataGroup();
            var dgLayout:VerticalLayout = new VerticalLayout();
            dgLayout.gap = 0;
            dgLayout.horizontalAlign = 'contentJustify';
            dgLayout.requestedRowCount = this.getStyle('requestedRowCount');
            this.dataGroup.layout = dgLayout;

            if (this.scroller)
                this.scroller.viewport = this.dataGroup;
        }


        if (this.dropDown) {
            this.dropDown.addElement(this.scroller);

            if (this.popUp)
                this.popUp.popUp = this.dropDown;
        }

        if ((this.popUp) && (!this.popUp.parent)) {
            this.addChild(this.popUp);
        }

        if (!this.separationLine) {
            this.separationLine = new Sprite();
            this.addChild(this.separationLine);
        }
    }

    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
        super.drawBackground(unscaledWidth, unscaledHeight);

        if (this.popUp) {
            this.popUp.graphics.clear();
            this.dropDown.graphics.clear();
            if (this.popUp.displayPopUp == true) {
                var borderWidth:int = getStyle("borderVisible") ? 1 : 0;

                this.popUp.graphics.beginFill(getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
                this.popUp.graphics.drawRect(borderWidth, borderWidth, this.popUp.width - 2 * borderWidth, this.popUp.height - 2 * borderWidth);
                this.popUp.graphics.endFill();

                this.dropDown.graphics.beginFill(getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
                this.dropDown.graphics.drawRect(borderWidth, borderWidth, this.popUp.width - 2 * borderWidth, this.popUp.height - 2 * borderWidth);
                this.dropDown.graphics.endFill();

                if (getStyle("borderVisible")) {
                    this.dropDown.graphics.lineStyle(1, getStyle("borderColor"), getStyle("borderAlpha"), true);
                    this.dropDown.graphics.drawRect(0, 0, this.popUp.width - 1, this.popUp.height - 1);
                }
            }
        }
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
        super.layoutContents(unscaledWidth, unscaledHeight);

        var downArrowHeight:int = unscaledHeight;

        var openButtonSkin:ButtonSkin = this.openButton.skin as ButtonSkin;
        this.openButton.setStyle('downArrowWidth', downArrowHeight);
        this.openButton.setStyle('downArrowHeight', downArrowHeight);

        this.setElementSize(this.openButton, unscaledWidth, unscaledHeight);
        this.setElementPosition(this.openButton, 0, 0);

        this.setElementPosition(this.separationLine, unscaledWidth - downArrowHeight - 1, 1);
        this.separationLine.graphics.clear();
        this.separationLine.graphics.lineStyle(1, 0x000000);
        this.separationLine.graphics.beginFill(0x000000);
        this.separationLine.graphics.drawRect(0, 0, 1, unscaledHeight);
        this.separationLine.graphics.endFill();
        this.setElementSize(this.separationLine, 1, unscaledHeight - 2);

        this.setElementSize(this.labelDisplay, unscaledWidth - downArrowHeight - this.separationLine.width - 1 - 7 - 1, unscaledHeight);
        this.setElementPosition(this.labelDisplay, 7, 2);

        if (this.popUp) {
            this.popUp.width = unscaledWidth;

            var firstRenderer:IItemRenderer = this.dataGroup.getElementAt(0) as IItemRenderer;
            if (firstRenderer) {
                var singleItemHeight:int = firstRenderer.height;
                var requestedRowCount:int = (this.dataGroup.layout as VerticalLayout).requestedRowCount;

                var popUpHeight:int = (singleItemHeight * requestedRowCount) + 2;
                if (this.hostComponent.dataProvider.length < requestedRowCount)
                    popUpHeight = singleItemHeight * this.hostComponent.dataProvider.length + 2;

                this.popUp.height = popUpHeight;

            }
            this.popUp.y = this.labelDisplay.y + this.labelDisplay.height;
        }
    }

    override protected function measure():void {
        super.measure();

        this.measuredHeight = Math.max(this.openButton.getExplicitOrMeasuredHeight(), this.labelDisplay.getExplicitOrMeasuredHeight());

        var labelDisplayWidth:int = this.labelDisplay.getExplicitOrMeasuredWidth();
        if (labelDisplayWidth <= 0) {

            var _typicalItem:Object = this.hostComponent.typicalItem;
            if (!_typicalItem) {
                if ((this.hostComponent.dataProvider) && (this.hostComponent.dataProvider.length > 0))
                    _typicalItem = this.hostComponent.dataProvider.getItemAt(0);
            }
            if (_typicalItem) {
                var typicalItemLbel:String = this.hostComponent.itemToLabel(_typicalItem);
                var itemLabelMetrics:TextLineMetrics = this.measureText(typicalItemLbel);
                labelDisplayWidth = itemLabelMetrics.width;
            } else
                labelDisplayWidth = 100;
        }

        this.measuredWidth = this.openButton.getExplicitOrMeasuredWidth() + labelDisplayWidth;
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
        if (getStyle("borderVisible") == false) {
            if (scroller)
                scroller.minViewportInset = 0;
        }
        else {
            if (scroller)
                scroller.minViewportInset = 1;
        }

        super.updateDisplayList(unscaledWidth, unscaledHeight);
    }

}
}