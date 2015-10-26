(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var sl_Elmt = function(elmt) {
	this.html = js.JQuery(elmt);
	this.html.css("position","absolute");
};
var sl_GraphicElmt = function(elmt) {
	sl_Elmt.call(this,elmt);
	this.type = this.html.get(0).nodeName.toLowerCase();
	if(this.type == "img") this.src = this.html.attr("src"); else if(this.type == "video") this.src = this.html.filter("source").attr("src");
};
sl_GraphicElmt.__super__ = sl_Elmt;
sl_GraphicElmt.prototype = $extend(sl_Elmt.prototype,{
	show: function(t) {
		if(t == null) t = 500;
		this.visible = true;
		this.addSrc();
		this.html.fadeIn(t);
	}
	,hide: function(t) {
		if(t == null) t = 500;
		this.visible = false;
		this.html.fadeOut(t,$bind(this,this.removeSrc));
	}
	,addSrc: function() {
		if(!this.visible) return;
		if(this.type == "img") this.html.attr("src",this.src); else if(this.type == "video") this.html.filter("source").attr("src",this.src);
	}
	,removeSrc: function() {
		if(this.visible) return;
		if(this.type == "img") this.html.attr("src",""); else if(this.type == "video") this.html.filter("source").attr("src",this.src);
	}
});
var sl_Main = function() {
	this.slideshows = [];
	js.JQuery(".sl").each($bind(this,this.initSlideshow));
};
sl_Main.main = function() {
	js.JQuery(window).ready(function(evt) {
		sl_Main.MAIN = new sl_Main();
	});
};
sl_Main.prototype = {
	initSlideshow: function(id,elmt) {
		this.slideshows.push(new sl_Slideshow(elmt));
	}
};
var sl_Slide = function(elmt) {
	var _g = this;
	var html = js.JQuery(elmt);
	html.find(">figure>*").each(function(i,e) {
		if(e.nodeName.toLowerCase() == "img" || e.nodeName.toLowerCase() == "video") _g.img = new sl_GraphicElmt(e); else if(e.nodeName.toLowerCase() == "figcaption") _g.text = new sl_TextElmt(e); else console.log("Unscheduled element: " + e.nodeName);
	});
	this.thumb = js.JQuery("<img>");
	this.thumb.attr("src",this.img.html.attr("data-thumb"));
	this.img.html.attr("data-thumb","");
	this.hide(0);
};
sl_Slide.prototype = {
	show: function(t) {
		if(t == null) t = 500;
		this.img.show(t);
		this.text.html.show(t);
	}
	,hide: function(t) {
		if(t == null) t = 500;
		this.img.hide(t);
		this.text.html.hide(t);
	}
};
var sl_Slideshow = function(slElmt) {
	this.current = 0;
	var _g = this;
	this.html = js.JQuery(slElmt);
	this.html.prepend("<div></div>");
	this.html.prepend("<div></div>");
	this.html.prepend("<div></div>");
	this.html.prepend("<div></div>");
	this.graphicThumbs = js.JQuery(this.html.find("div")[3]);
	this.graphicMenu = js.JQuery(this.html.find("div")[2]);
	this.graphicMsg = js.JQuery(this.html.find("div")[1]);
	this.graphicImgs = js.JQuery(this.html.find("div")[0]);
	this.graphicThumbs.css("padding","24px");
	this.graphicThumbs.css("width","100%");
	this.graphicThumbs.css("height","100%");
	this.graphicThumbs.css("overflow","auto");
	this.graphicThumbs.css("boxSizing","border-box");
	this.graphicThumbs.css("textAlign","center");
	this.graphicThumbs.css("position","relative");
	this.graphicThumbs.css("backgroundColor","rgba(0,0,0,0.75)");
	this.allSlides = [];
	this.filteredSlides = [];
	this.html.find(">li").each(function(id,elmt) {
		var id1 = _g.allSlides.length;
		_g.addSlide(id1);
		var slide = new sl_Slide(elmt);
		_g.allSlides.push(slide);
		_g.graphicImgs.append(slide.img.html);
		_g.graphicMsg.append(slide.text.html);
		var thumb = slide.thumb;
		thumb.css("display","inline-block");
		thumb.css("position","relative");
		thumb.css("border","8px solid black");
		thumb.css("transition","border 0.5s, margin 0.5s");
		thumb.click(function() {
			_g.go(id1);
			return true;
		});
		thumb.hover(function(evt) {
			thumb.css("border","8px solid white");
			thumb.css("cursor","pointer");
		},function(evt1) {
			thumb.css("border","8px solid black");
			thumb.css("cursor","inherit");
		});
		_g.graphicThumbs.append(thumb);
	});
	this.html.find(">li").each(function(id2,elmt1) {
		js.JQuery(elmt1).remove();
	});
	this.go(this.current);
	js.JQuery(window).resize($bind(this,this.onResize));
	this.html.resize($bind(this,this.onResize));
};
sl_Slideshow.prototype = {
	addSlide: function(id) {
		this.filteredSlides.push(id);
	}
	,go: function(id) {
		var slide;
		if(id != this.current) {
			slide = this.allSlides[this.current];
			slide.hide();
			this.current = id;
		}
		slide = this.allSlides[this.current];
		slide.show();
		this.resizeSlide(slide);
	}
	,onResize: function(evt) {
		this.resizeSlide();
	}
	,resizeSlide: function(slide,w,h,p) {
		if(p == null) p = 0;
		if(h == null) h = -1;
		if(w == null) w = -1;
		if(slide == null) slide = this.allSlides[this.current];
		if(w == -1 || h == -1 || p == 0) {
			w = this.html.width();
			h = this.html.height();
			p = w / h;
		}
		var prop = slide.img.html.width() / slide.img.html.height();
		var elmt = slide.img.html;
		if(prop > p) {
			elmt.width(w);
			elmt.height(Math.round(w / prop));
			elmt.css("left","0");
			elmt.css("top",Math.round((h - elmt.height()) / 2) + "px");
		} else {
			elmt.height(h);
			elmt.width(Math.round(h * prop));
			elmt.css("left",Math.round((w - elmt.width()) / 2) + "px");
			elmt.css("top","0");
		}
		elmt.load($bind(this,this.onResize));
	}
};
var sl_TextElmt = function(elmt) {
	sl_Elmt.call(this,elmt);
};
sl_TextElmt.__super__ = sl_Elmt;
sl_TextElmt.prototype = $extend(sl_Elmt.prototype,{
	show: function(t) {
		if(t == null) t = 500;
		this.html.show(t);
	}
	,hide: function(t) {
		if(t == null) t = 500;
		this.html.hide(t);
	}
});
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
var q = window.jQuery;
var js = js || {}
js.JQuery = q;
sl_Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
