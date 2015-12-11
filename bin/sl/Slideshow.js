(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
var sl_Elmt = function(elmt) {
	this.html = js.JQuery(elmt);
	this.html.css("position","absolute");
};
sl_Elmt.__name__ = true;
var sl_GraphicElmt = function(elmt) {
	sl_Elmt.call(this,elmt);
	this.type = this.html.get(0).nodeName.toLowerCase();
	if(this.type == "img") this.src = this.html.attr("src"); else if(this.type == "video") this.src = this.html.filter("source").attr("src");
};
sl_GraphicElmt.__name__ = true;
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
sl_Main.__name__ = true;
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
sl_Slide.__name__ = true;
sl_Slide.prototype = {
	show: function(t) {
		if(t == null) t = 1000;
		this.img.show(t);
		this.text.html.css("opacity","1");
	}
	,hide: function(t) {
		if(t == null) t = 1000;
		this.img.hide(t);
		this.text.html.css("opacity","0");
	}
};
var sl_Slideshow = function(slElmt) {
	this.infosOpen = true;
	this.current = 0;
	var _g = this;
	this.html = js.JQuery(slElmt);
	this.html.prepend("<div></div>");
	this.html.prepend("<div></div>");
	this.html.prepend("<div></div>");
	this.html.prepend("<div></div>");
	this.graphicImgs = js.JQuery(this.html.find("div")[0]);
	this.graphicMsg = js.JQuery(this.html.find("div")[1]);
	this.graphicMenu = js.JQuery(this.html.find("div")[2]);
	this.graphicThumbs = js.JQuery(this.html.find("div")[3]);
	this.graphicMsg.addClass("msgs");
	this.graphicThumbs.addClass("thumbs");
	this.graphicThumbs.click(function() {
		_g.graphicThumbs.fadeOut(500);
		return true;
	});
	this.graphicThumbs.css("display","none");
	this.allSlides = [];
	this.filteredSlides = [];
	var max = this.html.find(">li").length;
	this.html.find(">li").each(function(id,elmt) {
		var id1 = _g.allSlides.length;
		_g.addSlide(id1);
		var slide = new sl_Slide(elmt);
		slide.text.update(id1 + 1,max);
		_g.allSlides.push(slide);
		_g.graphicImgs.append(slide.img.html);
		_g.graphicMsg.append(slide.text.html);
		var close1 = js.JQuery("<a></a>");
		close1.addClass("slClose");
		close1.click(function() {
			_g.infosOpen = false;
			_g.graphicMsg.fadeOut(500);
			_g.html.find(".slInfo").fadeIn(500);
			return true;
		});
		slide.text.html.prepend(close1);
		var thumb = slide.thumb;
		thumb.attr("id","slThumb" + id1);
		thumb.addClass("thumb");
		thumb.click(function() {
			_g.go(id1);
			return true;
		});
		thumb.load(function(evt) {
			_g.resizeThumb(thumb);
		});
		_g.graphicThumbs.append(thumb);
	});
	this.html.find(">li").each(function(id2,elmt1) {
		js.JQuery(elmt1).remove();
	});
	var close = js.JQuery("<a></a>");
	close.addClass("slClose");
	close.click(function() {
		_g.graphicThumbs.fadeOut(500);
		return true;
	});
	this.graphicThumbs.append(close);
	if(!this.checkHash()) this.go(this.current);
	this.play(false);
	this.initMenu();
	this.initKeys();
	js.JQuery(window).resize($bind(this,this.onResize));
	this.html.resize($bind(this,this.onResize));
	js.JQuery(window).bind("hashchange",function(e) {
		_g.checkHash();
	});
};
sl_Slideshow.__name__ = true;
sl_Slideshow.prototype = {
	checkHash: function() {
		var hash = window.location.hash.substring(1);
		if(hash == "" || Std["int"](parseFloat(hash)) == this.current + 1) return false;
		this.go(Std["int"](parseFloat(hash)) - 1);
		return true;
	}
	,play: function(changeImg) {
		if(changeImg == null) changeImg = true;
		if(changeImg) this.go(this.current + 1);
		window.clearTimeout(this.playing);
		this.playing = window.setTimeout($bind(this,this.play),5000);
		this.html.find(".slPlay").css("display","none");
		this.html.find(".slPause").css("display","block");
	}
	,pause: function() {
		window.clearTimeout(this.playing);
		this.playing = -1;
		this.html.find(".slPlay").css("display","block");
		this.html.find(".slPause").css("display","none");
	}
	,resizeThumb: function(thumb) {
		var wMax = 100;
		var hMax = 100;
		var pMax = wMax / hMax;
		var w = thumb.width();
		var h = thumb.height();
		var p = w / h;
		var getNum = function(s) {
			return Std.parseFloat(s.split("px").join(""));
		};
		if(w + getNum(thumb.css("marginLeft")) + getNum(thumb.css("marginRight")) == wMax && h + getNum(thumb.css("marginTop")) + getNum(thumb.css("marginBottom")) == hMax) return;
		if(p > pMax) {
			thumb.width(wMax);
			thumb.height(Math.round(wMax / p));
			thumb.css("margin",Math.round((hMax - thumb.height()) / 2) + "px 0");
		} else {
			thumb.height(hMax);
			thumb.width(Math.round(hMax * p));
			thumb.css("margin","0 " + Math.round((wMax - thumb.width()) / 2) + "px");
		}
	}
	,initKeys: function() {
		var _g1 = this;
		js.JQuery(window.document.documentElement).keydown(function(e) {
			var _g = e.which;
			switch(_g) {
			case 37:
				_g1.pause();
				_g1.go(_g1.current - 1);
				break;
			case 39:
				_g1.pause();
				_g1.go(_g1.current + 1);
				break;
			case 38:
				var f = _g1.html.find(".slFullscreen");
				var w = _g1.html.find(".slWindowed");
				if(Screenfull.isFullscreen) {
					Screenfull.exit();
					f.css("display","block");
					w.css("display","none");
				} else {
					Screenfull.request(_g1.html.get(0));
					w.css("display","block");
					f.css("display","none");
				}
				break;
			case 40:
				var i = _g1.html.find(".slInfo");
				_g1.infosOpen = !_g1.infosOpen;
				if(_g1.infosOpen) {
					_g1.graphicMsg.fadeIn(500);
					i.fadeOut(500);
				} else {
					_g1.graphicMsg.fadeOut(500);
					i.fadeIn(500);
				}
				break;
			case 13:
				if(_g1.playing > -1) _g1.pause(); else _g1.play();
				break;
			}
			e.preventDefault();
		});
	}
	,initMenu: function() {
		var _g = this;
		this.graphicMenu.prepend("<div></div>");
		var menu = js.JQuery(this.graphicMenu.find("div")[0]);
		menu.addClass("menu");
		menu.css("position","absolute");
		var i = js.JQuery("<a></a>");
		i.addClass("slInfo");
		i.css("display",this.infosOpen?"none":"block");
		i.click(function() {
			_g.infosOpen = true;
			_g.graphicMsg.fadeIn(500);
			i.fadeOut(500);
			return true;
		});
		menu.append(i);
		var left = js.JQuery("<a></a>");
		left.addClass("slLeft");
		left.click(function() {
			_g.pause();
			_g.go(_g.current - 1);
			return true;
		});
		menu.append(left);
		var playUI = js.JQuery("<a></a>");
		playUI.addClass("slPlay");
		playUI.click(function() {
			_g.play();
			return true;
		});
		menu.append(playUI);
		var pauseUI = js.JQuery("<a></a>");
		pauseUI.addClass("slPause");
		pauseUI.click(function() {
			_g.pause();
			return true;
		});
		menu.append(pauseUI);
		pauseUI.css("display","none");
		var right = js.JQuery("<a></a>");
		right.addClass("slRight");
		right.click(function() {
			_g.pause();
			_g.go(_g.current + 1);
			return true;
		});
		menu.append(right);
		var M = js.JQuery("<a></a>");
		M.addClass("slMenu");
		M.click(function() {
			_g.pause();
			_g.graphicThumbs.fadeIn(500);
			_g.graphicThumbs.find("img").each(function(id,elmt) {
				_g.resizeThumb(js.JQuery(elmt));
			});
			return true;
		});
		menu.append(M);
		if(Screenfull.enabled) {
			var f = js.JQuery("<a></a>");
			var w = js.JQuery("<a></a>");
			f.addClass("slFullscreen");
			w.addClass("slWindowed");
			f.click(function() {
				Screenfull.request(_g.html.get(0));
				w.css("display","block");
				f.css("display","none");
				return true;
			});
			menu.append(f);
			w.click(function() {
				Screenfull.exit();
				f.css("display","block");
				w.css("display","none");
				return true;
			});
			menu.append(w);
			w.css("display","none");
		}
	}
	,addSlide: function(id) {
		this.filteredSlides.push(id);
	}
	,go: function(id) {
		var slide;
		if(id < 0) id = this.allSlides.length - 1; else if(id >= this.allSlides.length) id = 0; else id = id;
		if(id != this.current) {
			this.graphicThumbs.find("#slThumb" + this.current).removeClass("selected");
			slide = this.allSlides[this.current];
			slide.hide();
			this.current = id;
		}
		this.graphicThumbs.find("#slThumb" + this.current).addClass("selected");
		slide = this.allSlides[this.current];
		slide.show();
		this.resizeSlide(slide);
		window.location.href = "#" + Std.string(this.current + 1);
	}
	,onResize: function(evt) {
		var w = this.html.width();
		var h = this.html.height();
		this.graphicImgs.css("width",w + "px");
		this.graphicImgs.css("height",h + "px");
		this.graphicMsg.css("width",w + "px");
		this.graphicMsg.css("height",h + "px");
		this.graphicThumbs.css("width",w + "px");
		this.graphicThumbs.css("height",h + "px");
		this.graphicMenu.css("width",w + "px");
		this.graphicMenu.css("height",h + "px");
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
sl_TextElmt.__name__ = true;
sl_TextElmt.__super__ = sl_Elmt;
sl_TextElmt.prototype = $extend(sl_Elmt.prototype,{
	show: function(t) {
		if(t == null) t = 500;
		this.html.css("opacity","1");
	}
	,hide: function(t) {
		if(t == null) t = 500;
		this.html.css("opacity","0");
	}
	,update: function(num,max) {
		var t = this.html.html();
		t = t.split("{{num}}").join(num == null?"null":"" + num);
		t = t.split("{{max}}").join(max == null?"null":"" + max);
		this.html.html(t);
	}
});
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.__name__ = true;
Array.__name__ = true;
var q = window.jQuery;
var js = js || {}
js.JQuery = q;
sl_Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
