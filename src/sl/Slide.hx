package sl;
import js.html.Element;
import js.JQuery;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */
class Slide
{

	//public var html:JQuery;
	public var img:GraphicElmt;
	public var thumb:JQuery;
	public var text:TextElmt;
	
	public function new(elmt:Element)
	{
		var html = new JQuery(elmt);
		
		html.find(">figure>*").each(function(i:Int, e:Element) {
			
			if ( e.nodeName.toLowerCase() == "img" || e.nodeName.toLowerCase() == "video" )
				img = new GraphicElmt(e);
			else if ( e.nodeName.toLowerCase() == "figcaption" )
				text = new TextElmt(e);
			else
				trace("Unscheduled element: " + e.nodeName);
			
		});
		//html.remove();
		
		thumb = new JQuery("<img>");
		thumb.attr("src", img.html.attr("data-thumb"));
		img.html.attr("data-thumb", "");
		
		hide(0);
	}
	
	public function show(t = 1000) {
		img.show(t);
		text.show(t);
		//img.html.fadeIn(t);
		//text.html.show(t);
	}
	
	public function hide(t = 1000) {
		img.hide(t);
		text.hide(t);
		//img.html.fadeOut(t);
		//text.html.hide(t);
	}
}