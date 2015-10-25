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
}