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
	public var graphicMenu:JQuery;
	
	
	public var current:Int = 0;
	public var infosOpen:Bool = true;
	public var allSlides:Array<Slide>;
	public var filteredSlides:Array<Int>;
	
	public function new(slElmt:Element) {
		
		html = new JQuery(slElmt);
		html.prepend("<div></div>");
		html.prepend("<div></div>");
		html.prepend("<div></div>");
		html.prepend("<div></div>");
		
		graphicImgs = new JQuery(html.find("div")[0]);
		graphicMsg = new JQuery(html.find("div")[1]);
		graphicMenu = new JQuery(html.find("div")[2]);
		graphicThumbs = new JQuery(html.find("div")[3]);
		
		graphicThumbs.css("padding", "24px");
		graphicThumbs.css("width", "100%");
		graphicThumbs.css("height", "100%");
		graphicThumbs.css("overflow", "auto");
		graphicThumbs.css("boxSizing", "border-box");
		graphicThumbs.css("textAlign", "center");
		graphicThumbs.css("position", "relative");
		graphicThumbs.css("backgroundColor", "rgba(0,0,0,0.95)");
		graphicThumbs.click(function() { graphicThumbs.fadeOut(500); return true; } );
		graphicThumbs.css("display", "none");
		
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
			thumb.attr("id", "slThumb" + id);
			thumb.css("display", "inline-block");
			thumb.css("position", "relative");
			//thumb.css("float", "center");
			thumb.css("border", "8px solid black");
			//thumb.css("margin", "8px");
			thumb.css("transition", "border 0.5s, margin 0.5s");
			
			thumb.click(function() { go(id); return true; } );
			thumb.hover(function(evt:JqEvent) { 
				
					thumb.css("border", "8px solid white");
					thumb.css("cursor", "pointer");
					
				} , function(evt:JqEvent) {
				
					thumb.css("border", "8px solid black");
					thumb.css("cursor", "inherit");
			} );
			
			
			thumb.load(function (evt:JqEvent) {
				resizeThumb(thumb);
			});
			
			
			graphicThumbs.append(thumb);
			
		});
		html.find(">li").each(function(id:Int, elmt:Element) {
			new JQuery(elmt).remove();
		});
		
		
		initMenu();
		
		
		go(current);
		//resizeAll();
		
		
		new JQuery(Browser.window).resize(onResize);
		html.resize(onResize);
	}
	
	public function resizeThumb(thumb:JQuery) {
		
		var wMax = 100;
		var hMax = 100;
		var pMax = wMax / hMax;
		
		var w = thumb.width();
		var h = thumb.height();
		var p = w / h;
		
		
		// check if it's already resized
		var getNum = function(s:String) { return Std.parseFloat( s.split("px").join("") ); };
		if ( w + getNum(thumb.css("marginLeft")) + getNum(thumb.css("marginRight")) == wMax &&
			 h + getNum(thumb.css("marginTop")) + getNum(thumb.css("marginBottom")) == hMax ) {
			
			return;
		}
		
		
		if (p > pMax) {
	
			thumb.width(wMax);
			thumb.height(Math.round(wMax / p));
			thumb.css("margin", Math.round((hMax - thumb.height()) / 2) + "px 0");
			
		} else {
			
			thumb.height(hMax);
			thumb.width(Math.round(hMax * p));
			thumb.css("margin", "0 " + Math.round((wMax - thumb.width()) / 2) + "px");
		}
	}
	
	public function initMenu() {
		
		graphicMenu.prepend("<div></div>");
		
		var menu = new JQuery(graphicMenu.find("div")[0]);
		menu.addClass("menu");
		menu.css("position", "absolute");
		
		// i
		var i = new JQuery("<a href=\"#\">&nbsp;i&nbsp;</a>");
		i.css("textDecoration", (infosOpen) ? "line-through" : "none" );
		i.click(function() {
			
			infosOpen = !infosOpen;
			
			if (infosOpen)
				graphicMsg.fadeIn(500);
			else
				graphicMsg.fadeOut(500);
			
			i.css("textDecoration", (infosOpen) ? "line-through" : "none" );
			
			return true;
		} );
		menu.append(i);
		
		// M
		var M = new JQuery("<a href=\"#\">M</a>");
		M.click(function() {
			graphicThumbs.find("#slThumb" + current).css("borderColor", "#FFF");
			graphicThumbs.fadeIn(500);
			graphicThumbs.find("img").each(function(id:Int, elmt:Element) {
				resizeThumb(new JQuery(elmt));
			} );
			return true;
			
		} );
		menu.append(M);
		
		// ►◄≡‖  ■□●װ<>
	}
	
	public function addSlide(id:Int) {
		filteredSlides.push(id);
	}
	
	public function go(id:Int) {
		
		var slide:Slide;
		
		if (id != current) {
			graphicThumbs.find("#slThumb" + current).css("borderColor", "#000");
			slide = allSlides[current];
			slide.hide();
			current = id;
		}
		
		graphicThumbs.find("#slThumb" + current).css("borderColor", "#FFF");
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