package sl;
import js.Browser;
import js.html.Element;
import js.JQuery;
import js.JQuery.JqEvent;
import Screenfull;

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
	public var playing:Int;
	
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
		
		graphicMsg.addClass("msgs");
		
		
		graphicThumbs.addClass("thumbs");
		//graphicThumbs.css("position", "relative");
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
			
			
			
			var close = new JQuery("<a href=\"#\"></a>");
			close.addClass("slClose");
			//close.css("zIndex", "1");
			//i.css("textDecoration", (infosOpen) ? "line-through" : "none" );
			close.click(function() {
				
				infosOpen = false;
				graphicMsg.fadeOut(500);
				html.find(".slInfo").fadeIn(500);
				
				return true;
			} );
			slide.text.html.prepend(close);
			
			
			
			
			
			/*var thumb = new JQuery("<a href=\"#\"></a>");
			thumb.append(slide.thumb);
			thumb.click(function() { go(id); return true; } );
			graphicThumbs.append(thumb);*/
			
			var thumb = slide.thumb;
			thumb.attr("id", "slThumb" + id);
			thumb.addClass("thumb");
			/*thumb.css("display", "inline-block");
			thumb.css("position", "relative");
			thumb.css("border", "8px solid black");
			thumb.css("transition", "border 0.5s, margin 0.5s");*/
			
			thumb.click(function() { go(id); return true; } );
			/*thumb.hover(function(evt:JqEvent) { 
				
					thumb.css("border", "8px solid white");
					thumb.css("cursor", "pointer");
					
				} , function(evt:JqEvent) {
				
					thumb.css("border", "8px solid black");
					thumb.css("cursor", "inherit");
			} );*/
			
			
			thumb.load(function (evt:JqEvent) {
				resizeThumb(thumb);
			});
			
			
			graphicThumbs.append(thumb);
			
		});
		
		
		html.find(">li").each(function(id:Int, elmt:Element) {
			new JQuery(elmt).remove();
		});
		
		
		var close = new JQuery("<a href=\"#\"></a>");
		close.addClass("slClose");
		//close.css("zIndex", "5");
		close.click(function() { graphicThumbs.fadeOut(500); return true; } );
		graphicThumbs.append(close);
		
		
		go(current);
		play(false);
		
		
		
		initMenu();
		
		
		//resizeAll();
		
		
		new JQuery(Browser.window).resize(onResize);
		html.resize(onResize);
	}
	
	public function play(changeImg = true) {
		
		if (changeImg)
			go(current + 1);
		
		Browser.window.clearTimeout(playing);
		playing = Browser.window.setTimeout(play, 5000);
		
		html.find(".slPlay").css("display", "none");
		html.find(".slPause").css("display", "block");
		//html.find(".slPlayPause").css("fontSize", (playing > -1)?"150%":"100%");
		
	}
	
	public function pause() {
		
		Browser.window.clearTimeout(playing);
		playing = -1;
		
		html.find(".slPlay").css("display", "block");
		html.find(".slPause").css("display", "none");
		//html.find(".slPlayPause").css("fontSize", (playing > -1)?"150%":"100%");
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
		var i = new JQuery("<a href=\"#\"></a>");
		i.addClass("slInfo");
		i.css("display", (infosOpen) ? "none" : "block" );
		i.click(function() {
			
			infosOpen = true;
			
			/*if (infosOpen)
				graphicMsg.fadeIn(500);
			else*/
			
			graphicMsg.fadeIn(500);
			i.fadeOut(500);
			
			//i.css("textDecoration", (infosOpen) ? "line-through" : "none" );
			//i.css("textDecoration", (infosOpen) ? "line-through" : "none" );
			
			return true;
		} );
		menu.append(i);
		
		// Ӏ<
		var left = new JQuery("<a href=\"#\"></a>");
		left.addClass("slLeft");
		left.click(function() {
			
			pause();
			go (current - 1);
			return true;
			
		} );
		menu.append(left);
		
		// ■ ►
		var playUI = new JQuery("<a href=\"#\"></a>");
		playUI.addClass("slPlay");
		playUI.click(function() {
			
			play();
			return true;
		} );
		menu.append(playUI);
		
		// ■ ►
		var pauseUI = new JQuery("<a href=\"#\"></a>");
		pauseUI.addClass("slPause");
		pauseUI.click(function() {
			
			pause();
			return true;
		} );
		menu.append(pauseUI);
		
		// >Ӏ
		var right = new JQuery("<a href=\"#\"></a>");
		right.addClass("slRight");
		right.click(function() {
			
			pause();
			go (current + 1);
			return true;
			
		} );
		menu.append(right);
		
		
		// M ͏Ξ
		var M = new JQuery("<a href=\"#\"></a>");
		M.addClass("slMenu");
		M.click(function() {
			//graphicThumbs.find("#slThumb" + current).css("borderColor", "#FFF");
			pause();
			graphicThumbs.fadeIn(500);
			graphicThumbs.find("img").each(function(id:Int, elmt:Element) {
				resizeThumb(new JQuery(elmt));
			} );
			return true;
			
		} );
		menu.append(M);
		
		// ►◄≡‖  ■□●װ<>
		
		// ۞ □
		if (Screenfull.enabled) {
			
			var f = new JQuery("<a href=\"#\"></a>");
			var w = new JQuery("<a href=\"#\"></a>");
			
			f.addClass("slFullscreen");
			w.addClass("slWindowed");
			
			f.click(function() {
				
				Screenfull.request(html.get(0));
				w.css("display", "block");
				f.css("display", "none");
				return true;
				
			} );
			menu.append(f);
		
			w.click(function() {
				
				Screenfull.exit();
				f.css("display", "block");
				w.css("display", "none");
				return true;
				
			} );
			menu.append(w);
			
			w.css("display", "none");
		}
	}
	
	public function addSlide(id:Int) {
		filteredSlides.push(id);
	}
	
	public function go(id:Int) {
		
		var slide:Slide;
		
		id = (id < 0) ? (allSlides.length - 1) : (id >= allSlides.length) ? 0 : id;
		
		if (id != current) {
			//graphicThumbs.find("#slThumb" + current).css("borderColor", "#000");
			
			graphicThumbs.find("#slThumb" + current).removeClass("selected");
			//trace(current);
			
			slide = allSlides[current];
			slide.hide();
			current = id;
		}
		
		//graphicThumbs.find("#slThumb" + current).css("borderColor", "#FFF");
		graphicThumbs.find("#slThumb" + current).addClass("selected");
		
		slide = allSlides[current];
		slide.show();
		resizeSlide(slide);
	}
	
	public function onResize(?evt:js.JqEvent) {
		
		var w = html.width();
		var h = html.height();
		
		graphicImgs.css("width", w + "px");
		graphicImgs.css("height", h + "px");
		
		graphicMsg.css("width", w + "px");
		graphicMsg.css("height", h + "px");
		
		graphicThumbs.css("width", w + "px");
		graphicThumbs.css("height", h + "px");
		
		graphicMenu.css("width", w + "px");
		graphicMenu.css("height", h + "px");
		
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