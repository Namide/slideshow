package sl;
import js.html.Element;
import js.JQuery;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */
class GraphicElmt extends Elmt
{
	var src:String;
	var type:String;
	var visible:Bool;
	
	public function new(elmt:Element) 
	{
		super(elmt);
		//html = new JQuery(elmt);
		//html.css("position", "absolute");
		
		type = html.get(0).nodeName.toLowerCase();
		
		if (type == "img")
			src = html.attr("src");
		else if (type == "video")
			src = html.filter("source").attr("src");
	}
	
	public function show(t = 500) {
		visible = true;
		addSrc();
		html.fadeIn(t);
	}
	
	public function hide(t = 500) {
		visible = false;
		html.fadeOut(t, removeSrc);
	}
	
	function addSrc() {
		
		if (!visible)
			return;
		
		if (type == "img")
			html.attr("src", src);
		else if (type == "video")
			html.filter("source").attr("src", src);
	}
	
	function removeSrc() {
		
		if (visible)
			return;
		
		if (type == "img")
			html.attr("src", "");
		else if (type == "video")
			html.filter("source").attr("src", src);
	}
}