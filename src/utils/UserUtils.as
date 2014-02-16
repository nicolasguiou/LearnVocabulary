package utils {

import mx.collections.ArrayCollection;

import spark.managers.PersistenceManager;

[Bindable]
public class UserUtils extends PersistenceManager {

    //--------------------------------------------------------------------------
    //  Properties
    //--------------------------------------------------------------------------
    private static var instance:UserUtils;

    public var vocabularyViewTabSelected:int = 0; // tab selected by the user for the display
    public var vocabularyViewDpDisplayed:ArrayCollection;

    //--------------------------------------------------------------------------
    //  Constructor
    //--------------------------------------------------------------------------
    public function UserUtils(enforcer:SingletonEnforcer) {
        if (enforcer == null)
            throw new Error("You Can Only Have One UserUtils");
    }


    //--------------------------------------------------------------------------
    //  Public methods
    //--------------------------------------------------------------------------
    public static function getInstance():UserUtils {
        if (instance == null)
            instance = new UserUtils(new SingletonEnforcer);

        return instance;
    }

}
}

// Utility Class to Deny Access to Constructor
class SingletonEnforcer {
}