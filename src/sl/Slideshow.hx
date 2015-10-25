package sl;
import js.Browser;
import js.html.Element;
import js.JQuery;
import js.JQuery.JqEvent;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */
class Slideshow
{

	public var html:JQuery;
	
	
	public var graphicImgs:JQuery;
	public var graphicMsg:JQuery;
	public var graphicThumbs:JQuery;
	
	
	public var current:Int = 0;
	public var allSlides:Array<Slide>;
	public var filteredSlides:Array<Int>;
	
	public function new(slElmt:Element) {
		
		html = new JQuery(slElmt);
		html.prepend("<div></div>");
		html.prepend("<div></div>");
		html.prepend("<div></div>");
		
		graphicThumbs = new JQuery(html.find("div")[2]);
		graphicMsg = new JQuery(html.find("div")[1]);
		graphicImgs = new JQuery(html.find("div")[0]);
		
		allSlides = [];
		filteredSlides = [];
		html.find(">li").each(function(id:Int, elmt:Element) {
			
			var id = allSlides.length;
			
			addSlide(id);
			var slide = new Slide(elmt);
			allSlides.push(slide);
			graphicImgs.append(slide.img.html);
			graphicMsg.append(slide.text.html);
			
			/*var thumb = new JQuery("<a href=\"#\"></a>");
			thumb.append(slide.thumb);
			thumb.click(function() { go(id); return true; } );
			graphicThumbs.append(thumb);*/
			
			var thumb = slide.thumb;
			thumb.css("zIndex", "1");
			thumb.css("position", "relative");
			thumb.css("verticalAlign", "middle");
			thumb.css("margin", "8px 0");
			thumb.css("transition", "border 0.5s, margin 0.5s");
			
			thumb.click(function() { go(id); return true; } );
			thumb.hover(function(evt:JqEvent) { 
				
					thumb.css("borderBottom", "8px solid black");
					thumb.css("borderTop", "8px solid black");
					thumb.css("margin", "0");
					thumb.css("cursor", "pointer");
					
				} , function(evt:JqEvent) {
				
					thumb.css("borderBottom", "0px solid black");
					thumb.css("borderTop", "0px solid black");
					thumb.css("margin", "8px 0");
					thumb.css("cursor", "inherit");
			} );
			
			graphicThumbs.append(thumb);
			
		});
		html.find(">li").each(function(id:Int, elmt:Element) {
			new JQuery(elmt).remove();
		});
		
		go(current);
		//resizeAll();
		
		new JQuery(Browser.window).resize(onResize);
		html.resize(onResize);
	}
	
	public function addSlide(id:Int) {
		filteredSlides.push(id);
	}
	
	public function go(id:Int) {
		
		var slide:Slide;
		
		if (id != current) {
			slide = allSlides[current];
			slide.hide();
			current = id;
		}
		
		slide = allSlides[current];
		slide.show();
		resizeSlide(slide);
	}
	
	public function onResize(?evt:js.JqEvent) {
		
		resizeSlide();
	}
	
	public function resizeSlide(slide:Slide = null, w:Int = -1, h:Int = -1, p:Float = 0) {
		
		if (slide == null) {
			slide = allSlides[current];
		}
		
		if (w == -1 || h == -1 || p == 0) {
			w = html.width();
			h = html.height();
			p = w / h;
		}
		
		var prop = slide.img.html.width() / slide.img.html.height();
		var elmt = slide.img.html;
		
		if (prop > p) {
			
			elmt.width(w);
			elmt.height(Math.round(w / prop));
			elmt.css("left", "0");
			elmt.css("top", Math.round((h - elmt.height()) / 2) + "px");
			
		} else {
			
			elmt.height(h);
			elmt.width(Math.round(h * prop));
			elmt.css("left", Math.round((w - elmt.width()) / 2) + "px");
			elmt.css("top", "0");
		}
		
		elmt.load(onResize);
	}
	
	/*public function resizeAll() {
		
		var w = html.width();
		var h = html.height();
		var p = w / h;
		
		for (slide in allSlides) {
			resizeSlide(slide, w, h, p);
		}
	}*/
}