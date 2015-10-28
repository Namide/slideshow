package;
import js.html.Element;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */
extern class Screenfull
{
	public function new():Void;

	public static var enabled:Bool;
    public static var isFullscreen:Bool;
    public static var element:Element;
    //public function request():Void;
    public static function request(?target:Element):Void;
    public static function toggle(?target:Element):Void;
    public static function exit():Void;
    /*public function hide():Void;
    public function show():Void;
    public var visible(default,null):Bool;*/
	
}


/*package ;
extern class screenfull {
    public function new(id:String):Void;
    public function hide():Void;
    public function show():Void;
    public var visible(default,null):Bool;
}*/