package views {
import core.CommunicationDataBase;
import core.CommunicationDropBox;
import core.DataBase;

import events.VocabularyEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.core.ClassFactory;
import mx.events.FlexEvent;
import mx.states.State;
import mx.utils.Base64Decoder;

import spark.components.DropDownList;

import spark.components.Image;
import spark.components.Label;
import spark.components.List;
import spark.components.ViewMenuItem;

import utils.EmbedAssets;
import utils.LocalizationUtils;
import utils.MappingIdString;
import utils.TransitionUtils;

import views.itemRenderers.VocabularyFolderItemRenderer;

import views.itemRenderers.VocabularyItemRenderer;

import vo.TranslationVO;
import vo.WordVO;

[SkinState("normal")]
[SkinState("diaporama")]
[SkinState("disabled")]
public class VocabularyView extends BaseView {

    //--------------------------------------------------------------------------
    //  Skin parts
    //--------------------------------------------------------------------------
    [SkinPart]
    public var listVoc:List;

    [SkinPart]
    public var lbLanguage:Label;

    [SkinPart]
    public var lbLength:Label;

    [SkinPart]
    public var lbWord1:Label;

    [SkinPart]
    public var lbWord2:Label;

    [SkinPart]
    public var imgPlay:Image;

    [SkinPart]
    public var ddlDisplay:DropDownList;


    //--------------------------------------------------------------------------
    //  Properties
    //--------------------------------------------------------------------------
    private var communicationDataBase:CommunicationDataBase;
    private var communicationDropBox:CommunicationDropBox;

    private var timeoutId:uint;


    private var _sourceLanguage:int;
    private var _sourceLanguageDirty:Boolean;

    public function get sourceLanguage():int {
        return _sourceLanguage;
    }

    public function set sourceLanguage(value:int):void {
        _sourceLanguage = value;
        _sourceLanguageDirty = true;
        invalidateProperties();
    }

    private var _sourceVocabulary:int;
    private var _sourceVocabularyDirty:Boolean;

    public function get sourceVocabulary():int {
        return _sourceVocabulary;
    }

    public function set sourceVocabulary(value:int):void {
        _sourceVocabulary = value;
        _sourceVocabularyDirty = true;
        invalidateProperties();
    }

    private var _sourceWord1:String;
    private var _sourceWord1Dirty:Boolean;

    public function get sourceWord1():String {
        return _sourceWord1;
    }

    public function set sourceWord1(value:String):void {
        _sourceWord1 = value;
        _sourceWord1Dirty = true;
        invalidateProperties();
    }

    private var _sourceWord2:String;
    private var _sourceWord2Dirty:Boolean;

    public function get sourceWord2():String {
        return _sourceWord2;
    }

    public function set sourceWord2(value:String):void {
        _sourceWord2 = value;
        _sourceWord2Dirty = true;
        invalidateProperties();
    }

    private var _dpVocabulary:ArrayCollection;
    private var _dpVocabularyDirty:Boolean;

    public function get dpVocabulary():ArrayCollection {
        return _dpVocabulary;
    }

    public function set dpVocabulary(value:ArrayCollection):void {
        if (value && value != _dpVocabulary) {
            _dpVocabulary = value;
            _dpVocabularyDirty = true;
            invalidateProperties();
        }
    }


    //--------------------------------------------------------------------------
    //  Constructor
    //--------------------------------------------------------------------------
    public function VocabularyView() {
        init();
    }


    //--------------------------------------------------------------------------
    //  Overridden methods
    //--------------------------------------------------------------------------
    override protected function commitProperties():void {
        super.commitProperties();

        if (_sourceLanguageDirty && lbLanguage) {
            _sourceLanguageDirty = false;

            lbLanguage.text = MappingIdString.getLanguage(MappingIdString.getCodeId(DataBase.getInstance().db.substr(3, 2)))
            lbLanguage.text += " - ";
            lbLanguage.text += MappingIdString.getLanguage(MappingIdString.getCodeId(DataBase.getInstance().db.substr(6, 2)));
        }

        if (_sourceVocabularyDirty && lbLength) {
            _sourceVocabularyDirty = false;
            lbLength.text = DataBase.getInstance().dbNb.toString();
        }

        if (_sourceWord1Dirty && lbWord1) {
            _sourceWord1Dirty = false;
            lbWord1.text = sourceWord1;
        }

        if (_sourceWord2Dirty && lbWord2) {
            _sourceWord2Dirty = false;
            lbWord2.text = sourceWord2;
        }

        if (_dpVocabularyDirty && listVoc) {
            _dpVocabularyDirty = false;
            listVoc.dataProvider = dpVocabulary;
        }
    }

    override protected function partAdded(partName:String, instance:Object):void {
        super.partAdded(partName, instance);

        switch (instance) {
            case listVoc :
                listVoc.addEventListener(VocabularyEvent.DISPLAY_TRANSLATION, onDisplayTranslationHandler);
                listVoc.addEventListener(VocabularyEvent.DISPLAY_FOLDER, onDisplayFolderHandler);
                break;
            case imgPlay :
                imgPlay.addEventListener(MouseEvent.CLICK, onImgPlayHandler);
                break;
            case ddlDisplay :
                ddlDisplay.addEventListener(FlexEvent.VALUE_COMMIT, onDdlDisplayCommit);
                break;
        }

        invalidateProperties();
    }

    override protected function partRemoved(partName:String, instance:Object):void {
        super.partRemoved(partName, instance);

        switch (instance) {
            case listVoc :
                listVoc.removeEventListener(VocabularyEvent.DISPLAY_TRANSLATION, onDisplayTranslationHandler);
                listVoc.removeEventListener(VocabularyEvent.DISPLAY_FOLDER, onDisplayFolderHandler);
                break;
            case imgPlay :
                imgPlay.removeEventListener(MouseEvent.CLICK, onImgPlayHandler);
                break;
            case ddlDisplay :
                ddlDisplay.removeEventListener(FlexEvent.VALUE_COMMIT, onDdlDisplayCommit);
                break;
        }
    }

    override protected function getCurrentSkinState():String {
        return currentState;
    }

    override public function set currentState(value:String):void {
        super.currentState = value;
        invalidateSkinState();
    }

    //--------------------------------------------------------------------------
    //  Public methods
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //  Private methods
    //--------------------------------------------------------------------------
    private function init():void {
        communicationDataBase = new CommunicationDataBase();

        addStates();

        initUI();
        initMenus();
        initListeners();
        initData();
    }

    private function addStates():void {
        states.push(new State({name: "normal"}));
        states.push(new State({name: "diaporama"}));
        states.push(new State({name: "disabled"}));
    }

    private function initUI():void {
        this.styleName = "vocabularyViewSkin";
        this.title = "VOCABULARY";

        setLanguageVocabulary();
    }

    private function initMenus():void {
        var menuSelectDB:ViewMenuItem = new ViewMenuItem();
        menuSelectDB.id = "selectDB";
        menuSelectDB.label = resourceManager.getString('myResources', 'MENU.DataBase');
        menuSelectDB.addEventListener(MouseEvent.CLICK, menuClickedHanlder);

        var menuExportDB:ViewMenuItem = new ViewMenuItem();
        menuExportDB.id = "exportDB";
        menuExportDB.label = LocalizationUtils.getString("MENU.Export");
        menuExportDB.addEventListener(MouseEvent.CLICK, menuClickedHanlder);

        var menuImporterDB:ViewMenuItem = new ViewMenuItem();
        menuImporterDB.id = "importDB";
        menuImporterDB.label = LocalizationUtils.getString("MENU.Import");
        menuImporterDB.addEventListener(MouseEvent.CLICK, menuClickedHanlder);

        //			var menuSaveDB:ViewMenuItem = new ViewMenuItem();
        //			menuSaveDB.id = "saveDB";
        //			menuSaveDB.label = LocalizationUtils.getString("MENU.Save");
        //			menuSaveDB.addEventListener(MouseEvent.CLICK, menuClickedHanlder);

        this.menus = [menuSelectDB, menuImporterDB, menuExportDB];
    }

    private function initListeners():void {
    }

    private function setLanguageVocabulary():void {
        if (DataBase.getInstance().dictionary) {
            sourceLanguage = DataBase.getInstance().dictionary.language;
            sourceVocabulary = DataBase.getInstance().dictionary.vocabulary;
        }
    }

    private function initData():void {
        dpVocabulary = communicationDataBase.getDataBase();
    }

    private function onDisplayFolderHandler(event:VocabularyEvent):void {
        listVoc.itemRenderer = new ClassFactory(VocabularyItemRenderer);
        listVoc.dataProvider = communicationDataBase.getCategory(event.data);
    }

    private function onDisplayTranslationHandler(event:VocabularyEvent):void {
        navigator.pushView(MenuTranslationEditView, event.data, null, TransitionUtils.crossFadeTransition());
    }

    private function onDdlDisplayCommit(event:FlexEvent):void {

        switch (ddlDisplay.selectedItem.code) {
            case 1 : // All
                listVoc.itemRenderer = new ClassFactory(VocabularyItemRenderer);
                listVoc.dataProvider = communicationDataBase.getDataBase();
                break;
            case 2 : // Folder
                listVoc.itemRenderer = new ClassFactory(VocabularyFolderItemRenderer);
                listVoc.dataProvider = communicationDataBase.getAllCategories();
                break;
//            case 3 : // New
//                listVoc.itemRenderer = new ClassFactory(VocabularyItemRenderer);
//                break;
        }
    }

    private function menuClickedHanlder(event:MouseEvent):void {
        switch (event.currentTarget.id) {
            case "selectDB" :
                navigator.pushView(MenuDictionaryView, DataBase.getInstance().dictionary, null, TransitionUtils.slideTransition());
                break;
            //				case "saveDB" :
            //					saveDB();
            //					break;
            case "exportDB" :
                communicationDataBase.exportCSV();
                break;
            case "importDB" :
                communicationDataBase.importCSV();
                initData();
                (listVoc.dataProvider as ArrayCollection).refresh();
                _sourceVocabularyDirty = true;
                invalidateProperties();
                break;
        }
    }

    private function saveDB():void {
        communicationDropBox = new CommunicationDropBox();
        communicationDropBox.client.addEventListener("urlDropBox", onDropBoxGetToken);
    }

    private function onDropBoxGetToken(event:Event):void {
        var str:String = "test file db in byte array";

        var data:ByteArray = new ByteArray();
        var dec:Base64Decoder = new Base64Decoder();
        dec.decode(str);
        data = dec.toByteArray();

        communicationDropBox.writeFile(".", "testVoc", data);
    }

    private function onImgPlayHandler(event:Event):void {
        if (currentState == "diaporama") {
            currentState = "normal";
            imgPlay.source = EmbedAssets.PLAY;
            clearTimeout(timeoutId);
        }
        else {
            currentState = "diaporama";
            imgPlay.source = EmbedAssets.STOP;
            callLater(diaporama);
        }

    }

    private function diaporama():void {
        var pos:int = Math.floor((Math.random() * dpVocabulary.length));
        var tvo:TranslationVO = dpVocabulary.getItemAt(pos) as TranslationVO;

        if (tvo && tvo.word1 && tvo.word1.word) {
            lbWord1.text = tvo.word1.word;
            lbWord2.text = tvo.word2.word;
            timeoutId = setTimeout(diaporama, 5000);
        }
        else {
            diaporama();
        }
    }

}
}