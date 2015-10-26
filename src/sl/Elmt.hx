package sl;
import js.html.Element;
import js.JQuery;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */
class Elmt
{
	public var html:JQuery;
	
	public function new(elmt:Element) 
	{
		html = new JQuery(elmt);
		html.css("position", "absolute");
		//html.css("zIndex", "-1");
	}
	
}