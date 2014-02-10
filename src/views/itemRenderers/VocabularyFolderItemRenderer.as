package views.itemRenderers {
import core.CommunicationDataBase;

import events.VocabularyEvent;

import flash.events.MouseEvent;

import mx.core.IDataRenderer;
import mx.graphics.SolidColor;

import spark.components.Group;
import spark.components.Label;
import spark.components.supportClasses.ItemRenderer;
import spark.primitives.BitmapImage;
import spark.primitives.Rect;

import utils.Constants;
import utils.EmbedAssets;


public class VocabularyFolderItemRenderer extends ItemRenderer implements IDataRenderer {

    //--------------------------------------------------------------------------
    //  Constants
    //--------------------------------------------------------------------------
    private static const HEIGHT:int = 80;


    //--------------------------------------------------------------------------
    //  Properties
    //--------------------------------------------------------------------------
    private var word1:Label = new Label();
    private var grp:Group = new Group();
    private var communicationDataBase:CommunicationDataBase;


    private var _item:Object;
    private var _itemDirty:Boolean;

    public function get item():Object {
        return _item;
    }

    public function set item(value:Object):void {
        if (_item == value) return;

        _item = value;
        _itemDirty = true;
        invalidateProperties()
    }


    //--------------------------------------------------------------------------
    //  Constructor
    //--------------------------------------------------------------------------
    public function VocabularyFolderItemRenderer() {
        super();

        this.addEventListener(MouseEvent.CLICK, onItemClickedHandler);
    }


    //--------------------------------------------------------------------------
    //  Overridden methods
    //--------------------------------------------------------------------------
    override public function set data(value:Object):void {
        if (value && value is Object) {
            super.data = value;
            item = value as Object;
        }
    }

    override protected function createChildren():void {
        super.createChildren();

        var img:BitmapImage = new BitmapImage();
        img.source = EmbedAssets.FOLDER;
        img.x = 10;
        img.y = 20;

        word1.width = Constants.DEVICE_WIDTH / 2 - 10;
        word1.height = HEIGHT;
        word1.maxDisplayedLines = 1;
        word1.x = 50;
        word1.setStyle("verticalAlign", "middle");

        // left line
        var rect2:Rect = drawLine(false, HEIGHT - 2);
        rect2.x = 1;
        rect2.y = 1;

        // top line
        var rect3:Rect = drawLine(true, Constants.DEVICE_WIDTH - 2);
        rect3.x = 1;
        rect3.y = 1;

        // bottom line
        var rect4:Rect = drawLine(true, Constants.DEVICE_WIDTH - 2);
        rect4.x = 1;
        rect4.y = HEIGHT - 1;

        // right line
        var rect5:Rect = drawLine(false, HEIGHT - 2);
        rect5.x = Constants.DEVICE_WIDTH - 2;
        rect5.y = 1;

        grp.addElement(img);
        grp.addElement(word1);
        grp.addElement(rect2);
        grp.addElement(rect3);
        grp.addElement(rect4);
        grp.addElement(rect5);

        this.width = Constants.DEVICE_WIDTH;
        this.height = HEIGHT;
        this.autoDrawBackground = true;
        this.addElement(grp);
    }

    private function drawLine(isHorizontal:Boolean, size:int):Rect {
        var rect:Rect = new Rect();

        if (isHorizontal) {
            rect.height = 1;
            rect.width = size;
        }
        else {
            rect.width = 1;
            rect.height = size;
        }

        rect.fill = new SolidColor(0x000000);

        return rect;
    }

    override protected function commitProperties():void {
        super.commitProperties();

        if (_itemDirty && word1) {

            communicationDataBase = new CommunicationDataBase();
            var categoryLen:int = communicationDataBase.getCategory(item as String).length;

            word1.text = item as String;
            word1.text += " (";
            word1.text += categoryLen.toString();
            word1.text += ")";

            _itemDirty = false;
        }
    }


    //--------------------------------------------------------------------------
    //  Public methods
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //  Private methods
    //--------------------------------------------------------------------------
    private function onItemClickedHandler(event:MouseEvent):void {
        dispatchEvent(new VocabularyEvent(VocabularyEvent.DISPLAY_FOLDER, this.item, true));
    }

}
}