package core {
import com.as3xls.xls.ExcelFile;
import com.as3xls.xls.Sheet;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FileListEvent;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.URLLoader;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.utils.UIDUtil;

import events.DataBaseEvent;

import utils.Constants;
import utils.MappingIdString;

import vo.DictionaryVO;
import vo.ExerciceSettingsVO;
import vo.TranslationVO;
import vo.WordVO;

//--------------------------------------------------------------------------
//  Events
//--------------------------------------------------------------------------
[Event(name="translationAdded", type="events.DataBaseEvent")]
[Event(name="translationDeleted", type="events.DataBaseEvent")]
[Event(name="translationEdited", type="events.DataBaseEvent")]
public class CommunicationDataBase extends EventDispatcher {

    //--------------------------------------------------------------------------
    //  Properties
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //  Constructor
    //--------------------------------------------------------------------------
    public function CommunicationDataBase() {
    }


    //--------------------------------------------------------------------------
    //  Public methods
    //--------------------------------------------------------------------------
    //		public function importOldDB():void
    //		{
    //			var file:File = File.userDirectory;
    //			var isfile:Array = File.userDirectory.getDirectoryListing();
    //			var file:File = File.documentsDirectory.isDirectory("/data/");
    //			//		var myFile:File = File.documentsDirectory.resolvePath("Test Folder/test.txt");
    //
    //			var fileStream:FileStream = new FileStream();
    //			fileStream.open(file, FileMode.READ);
    //			var obj:Object = fileStream.readObject();
    //			fileStream.close();
    //		}
    private var loader:URLLoader;

    function directoryListingHandler(event:FileListEvent):void {
        var list:Array = event.files;
        for (var i:uint = 0; i < list.length; i++) {
            trace(list[i].nativePath);
        }
    }

    public function importOldDB():void {
        //			var dir:String = "/data/data/air.LearnVocabularyMobile/";
        ////			var dir:String = "/data/data/air.LearnVocabularyMobile/LearnVocabularyMobile/";
        ////			var dir:String = "/data/data/air.LearnVocabularyMobile/LearnVocabularyMobile/Local Store/";
        //			var file:File = new File(dir);
        ////			var file:File = File.userDirectory.resolvePath(dir);
        //			var bool:Boolean = file.isDirectory;
        //			var arr:Array = file.getDirectoryListing();
        //			file.getDirectoryListingAsync();
        //			file.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);

        //			var obj:SharedObject = SharedObject.getLocal("FXAppCache");
        //			var myDataBase:ArrayCollection = (obj.data.DB_en_fr as ArrayCollection);
        //			var obj:* = SharedObject.getLocal("db_en_fr", "/data/data/air.LearnVocabularyMobile/LearnVocabularyMobile/");

        //			var fileStream:FileStream = new FileStream();
        //			fileStream.open(file, FileMode.READ);
        //			var obj:Object = fileStream.readObject();
        //			fileStream.close();


        var myDataBase:ArrayCollection = new ArrayCollection();
        //
        //			// get the DataBase
        myDataBase = (DataBase.getInstance().getProperty("DB_en_fr") as ArrayCollection);
        //
        if (myDataBase) {

            DataBase.getInstance().dbLength = myDataBase.length;

        }

        //						loader = new URLLoader();
        //						configureListeners(loader);
        //
        //						var request:URLRequest = new URLRequest("/mnt/sdcard/DCIM");
        ////						var request:URLRequest = new URLRequest("/÷data/data/app.LearnVoc/DB_en_fr");
        //						try {
        //							loader.load(request);
        ////							loader.
        //						} catch (error:Error) {
        //							trace("Unable to load requested document.");
        //						}
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.COMPLETE, completeHandler);
        dispatcher.addEventListener(Event.OPEN, openHandler);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }

    private function completeHandler(event:Event):void {
        var loader:URLLoader = URLLoader(event.target);
        trace("completeHandler: " + loader.data);
    }

    private function openHandler(event:Event):void {
        trace("openHandler: " + event);
    }

    private function progressHandler(event:ProgressEvent):void {
        trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("securityErrorHandler: " + event);
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        trace("httpStatusHandler: " + event);
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        trace("ioErrorHandler: " + event);
    }

    public function selectDataBase(codeLanguage:int, codeVocabulary:int):void {
        DataBase.getInstance().db = getDataBaseKey(codeLanguage, codeVocabulary);
    }

    public function getDictionary():DictionaryVO {
        var obj:Object = DataBase.getInstance().getProperty('dictionary');

        if (obj)
            return new DictionaryVO(obj);
        else
            return null;
    }

    public function setDictionary(dictionary:DictionaryVO):void {
        DataBase.getInstance().dictionary = dictionary;

        DataBase.getInstance().setProperty('dictionary', dictionary);
    }

    public function getExerciceSetting():ExerciceSettingsVO {
        var obj:Object = DataBase.getInstance().getProperty('exerciceSettings');

        if (obj)
            return new ExerciceSettingsVO(obj);
        else
            return null;
    }

    public function setExerciceSetting(exerciceSettings:ExerciceSettingsVO):void {
        DataBase.getInstance().setProperty('exerciceSettings', exerciceSettings);
    }

    public function getDataBase():ArrayCollection {
        selectDataBase(DataBase.getInstance().dictionary.language, DataBase.getInstance().dictionary.vocabulary);

        var myDataBase:ArrayCollection = new ArrayCollection();
        var myResult:ArrayCollection = new ArrayCollection();

        // get the DataBase
        myDataBase = ArrayCollection(DataBase.getInstance().getProperty(DataBase.getInstance().db));
        myDataBase = (myDataBase) ? myDataBase : new ArrayCollection();

        DataBase.getInstance().dbNb = myDataBase.length.toString();

        var n:int = myDataBase.length;
        var translationVO:TranslationVO;

        for (var i:int = 0; i < n; i++) {
            translationVO = new TranslationVO(myDataBase[i]);
            myResult.addItem(translationVO);
        }

        return myResult;
    }

    public function addTranslation(translationVO:TranslationVO):void {
        var myDataBase:ArrayCollection;
        myDataBase = getDataBase();
        myDataBase.addItem(translationVO);

        // set the DataBase
        DataBase.getInstance().setProperty(DataBase.getInstance().db, myDataBase);

        dispatchEvent(new DataBaseEvent(DataBaseEvent.TRANSLATION_ADDED));
    }

    public function deleteTranslation(translationVO:TranslationVO):void {
        var myDataBase:ArrayCollection;
        myDataBase = getDataBase();

        var n:int = myDataBase.length;
        for (var i:int = 0; i < n; i++) {
            if (TranslationVO(myDataBase.getItemAt(i)).id == translationVO.id) {
                myDataBase.removeItemAt(i);
                break;
            }
        }

        // set the DataBase
        DataBase.getInstance().setProperty(DataBase.getInstance().db, myDataBase);

        dispatchEvent(new DataBaseEvent(DataBaseEvent.TRANSLATION_DELETED));
    }

    public function editTranslation(translationVO:TranslationVO):void {
        var myDataBase:ArrayCollection;
        myDataBase = getDataBase();

        var n:int = myDataBase.length;
        for (var i:int = 0; i < n; i++) {
            if (TranslationVO(myDataBase.getItemAt(i)).id == translationVO.id) {
                myDataBase.setItemAt(translationVO, i);
                break;
            }
        }

        // set the DataBase
        DataBase.getInstance().setProperty(DataBase.getInstance().db, myDataBase);

        dispatchEvent(new DataBaseEvent(DataBaseEvent.TRANSLATION_EDITED));
    }

    public function getCategory(category:String, onlyNew:Boolean = false):ArrayCollection {
        var result:ArrayCollection = new ArrayCollection();
        var db:ArrayCollection = getDataBase();
        var n:int = db.length;
        var translation:TranslationVO;
        var tmpCategory:String;

        for (var i:int = 0; i < n; i++) {
            translation = new TranslationVO(db.getItemAt(i));
            tmpCategory = translation.category;

            if (tmpCategory.indexOf(" ") != -1) {
                var tmpArrayOfCategory:Array = tmpCategory.split(" ");

                for (var j:int = 0; j < tmpArrayOfCategory.length; j++) {
                    if (tmpArrayOfCategory[j] == category) {
                        if (!onlyNew || (onlyNew && translation.isNew)) {
                            result.addItem(translation);
                        }
                    }
                }
            }
            else if (tmpCategory == category) {
                if (!onlyNew || (onlyNew && translation.isNew)) {
                    result.addItem(translation);
                }
            }
        }

        return result;
    }

    public function getAllCategories():ArrayCollection {
        var result:ArrayCollection = new ArrayCollection();
        var db:ArrayCollection = getDataBase();
        var n:int = db.length;
        var translation:TranslationVO;
        var tmpCategory:String;

        for (var i:int = 0; i < n; i++) {
            translation = new TranslationVO(db.getItemAt(i));
            tmpCategory = translation.category;

            if (tmpCategory.indexOf(" ") != -1) {
                var tmpArrayOfCategory:Array = tmpCategory.split(" ");

                for (var j:int = 0; j < tmpArrayOfCategory.length; j++) {
                    if (result.contains(tmpArrayOfCategory[j]) == false)
                        result.addItem(tmpArrayOfCategory[j]);
                }
            }
            else if (result.contains(tmpCategory) == false) {
                result.addItem(tmpCategory);
            }
        }

        return result;
    }


    //--------------------------------------------------------------------------
    //  new public methods
    //--------------------------------------------------------------------------
    public function exportExcel():void {
        //			var numRow:int = 3;
        //			var sheet:Sheet = new Sheet();
        //			// dimensions: rows, columns
        //			sheet.resize(10, 10);
        //			// row, column, value
        //			sheet.setCell(0, 0, "First");
        //			sheet.setCell(0, 1, "Last");
        //
        ////			sheet.setCell(1, 0, "Bob");
        ////			sheet.setCell(1, 1, "Smith");
        ////
        ////			sheet.setCell(2, 0, "Alfred");
        ////			sheet.setCell(2, 1, "Hitchcock");
        //
        //			// now create the file object and add our sheet on it
        //			var xls:ExcelFile = new ExcelFile();
        //			xls.sheets.addItem(sheet);
        //			var bytes:ByteArray = xls.saveToByteArray();


        var sheet:Sheet = new Sheet();
        sheet.resize(10, 10);

        sheet.setCell(1, 2, "oooool");
        sheet.setCell(1, 1, "21");

        sheet.setCell(2, 3, "Bob");
        sheet.setCell(2, 5, "tres");

        var xls:ExcelFile = new ExcelFile();
        xls.sheets.addItem(sheet);
        var bytes:ByteArray = xls.saveToByteArray();

        // create the actual file
        var xlsFile:File = File.documentsDirectory.resolvePath("_learnVoc");
        xlsFile.nativePath += ".xls";

        // write the data to the file
        var fs:FileStream = new FileStream();
        fs.open(xlsFile, FileMode.WRITE);
        if (bytes) {
            fs.writeBytes(bytes);
        }
        fs.close();
    }

    public function importCSV():void {
        var xlsFile:File = File.documentsDirectory.resolvePath(Constants.FILE_NAME_EXPORT);
        xlsFile.nativePath += ".csv";

        var fs:FileStream = new FileStream();
        fs.open(xlsFile, FileMode.READ);
        var strCSV:String = fs.readUTFBytes(fs.bytesAvailable);
        fs.close();

        var myDataBase:ArrayCollection;
        myDataBase = fromCSVtoArrayCollection(strCSV);

        // check if correct database
        if (DataBase.getInstance().db == getTargetDBinFileCSV(strCSV)) {
            // set the DataBase
            DataBase.getInstance().setProperty(DataBase.getInstance().db, myDataBase);
        }
    }

//		public function importCSV():void
//		{
//			var txtFilter:FileFilter = new FileFilter("Text", "*.xls;*.csv;");
//			var dir:File = File.documentsDirectory;
//			dir.browse();
//			dir.addEventListener(Event.SELECT, onDirSelect);
//		}
//		private function onDirSelect(event:Event):void
//		{
//			var fs:FileStream = new FileStream();
//			fs.open( event.currentTarget as File, FileMode.READ);
//			var strCSV:String = fs.readUTF();
//			fs.close();
//			
//			var myDataBase:ArrayCollection;
//			myDataBase = fromCSVtoArrayCollection(strCSV);
//			
//			// check if correct database
//			if (DataBase.getInstance().db == getTargetDBinFileCSV(strCSV))
//			{
//				// set the DataBase
//				DataBase.getInstance().setProperty(DataBase.getInstance().db, myDataBase);
//			}
//		}

    public function exportCSV():void {
        var xlsFile:File = File.documentsDirectory.resolvePath(Constants.FILE_NAME_EXPORT);
        xlsFile.nativePath += ".csv";

        var fs:FileStream = new FileStream();
        fs.open(xlsFile, FileMode.WRITE);
        fs.writeUTF(fromArrayCollectionToCSV(getDataBase()));
        fs.close();
    }


    //--------------------------------------------------------------------------
    //  Private methods
    //--------------------------------------------------------------------------
    private function fromArrayCollectionToCSV(array:ArrayCollection):String {
        var result:String = "";
        var n:int = array.length;

        if (n > 0) {
            var translation:TranslationVO;

            // headers
            translation = (array.getItemAt(0)) as TranslationVO;
            result += MappingIdString.getLanguage(translation.word1.language);
            result += ",";
            result += MappingIdString.getLanguage(translation.word2.language);
            result += ",";
            result += "Category";
            result += ",";
            result += "New";
            result += "\n";

            // cells
            for (var i:int = 0; i < n; i++) {
                translation = (array.getItemAt(i)) as TranslationVO;

                result += translation.word1.word;
                result += ",";
                result += translation.word2.word;
                result += ",";
                result += translation.category;
                result += ",";
                result += translation.isNew;
                result += "\n";
            }
        }

        return result;
    }

    private function fromCSVtoArrayCollection(csv:String):ArrayCollection {
        var result:ArrayCollection = new ArrayCollection();
        var translation:TranslationVO;
        var rows:Array = csv.split("\n");
        var n:int = rows.length;
        var langage1:String = "el";
        var langage2:String = "fr";
        var lines:Array;
        var j:int;

        // ignore the first one (c.f. header)
        for (var i:int = 1; i < n; i++) {
            lines = rows[i].split(",");
            j = 0;

            translation = new TranslationVO();
            translation.id = UIDUtil.createUID();
            translation.dateCreated = new Date();

            //first word
            translation.word1 = new WordVO();
            translation.word1.id = UIDUtil.createUID();
            translation.word1.language = MappingIdString.getId(langage1);
            translation.word1.word = String(lines[j]);

            //second word
            translation.word2 = new WordVO();
            translation.word2.id = UIDUtil.createUID();
            translation.word2.language = MappingIdString.getId(langage2);
            translation.word2.word = String(lines[j + 1]);

            //category translation
            translation.category = String(lines[j + 2]);
            //isNew translation
            translation.isNew = (String(lines[j + 3]).toLowerCase() == "true") ? true : false;

            result.addItem(translation);
        }

        return result;
    }

    private function getTargetDBinFileCSV(csv:String):String {
        var firstRow:String = csv.substr(0, csv.search("\n"));
        var pos:int = firstRow.search(",");
        var firstCell:String = firstRow.substr(0, pos);
        var secondCell:String = firstRow.substr(pos + 1);
        secondCell = secondCell.substr(0, secondCell.search(","));

        return getDataBaseKey(MappingIdString.getId(firstCell), MappingIdString.getId(secondCell));
    }

    private function getDataBaseKey(codeLanguage:int, codeVocabulary:int):String {
        var result:String;

        result = "DB_"
        result += MappingIdString.getCodeLanguage(codeLanguage);
        result += "_"
        result += MappingIdString.getCodeLanguage(codeVocabulary);

        return result;
    }

}
}