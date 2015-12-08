package sl;
import js.html.Element;
import js.JQuery;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */
class TextElmt extends Elmt
{
	public inline function show(t = 500) {
		html.show(t);
	}
	
	public inline function hide(t = 500) {
		html.hide(t);
	}
	
	public function update( num:Int, max:Int ) {
		var t = html.html();
		t = t.split("{{num}}").join(Std.string(num));
		t = t.split("{{max}}").join(Std.string(max));
		html.html(t);
	}
}