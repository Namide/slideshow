package sl;

import js.html.Element;
import js.JQuery;
import js.Lib;

/**
 * ...
 * @author Namide (Damien Doussaud)
 */

class Main 
{
	static var MAIN:Main;
	static function main() {
		new JQuery (js.Browser.window).ready(function(evt) {
			Main.MAIN = new Main();
		});
	}
	
	var slideshows:Array<Slideshow>;
	
	public function new() {
		slideshows = [];
		new JQuery(".sl").each(initSlideshow);
	}
	
	public function initSlideshow( id:Int, elmt:Element ) {
		slideshows.push(new Slideshow(elmt));
	}
	
}