

/*
* Ajax overlay 1.0
* Author: Simon Ilett @ aplusdesign.com.au
* Descrip: Creates and inserts an ajax loader for ajax calls / timed events 
* Date: 03/08/2011 
*/
function ajaxLoader (el, options) {
	//화면넓이
	var cliWidth = $(document).width();

	//화면높이
	var cliHeight = $(document).height();

	//로딩바 넓이
	var loadingBarWidth  = cliWidth;

	//로딩바 높이
	var loadingBarHeight = cliHeight;

	//로딩바 위치 산출
	var iTop = ( cliHeight / 2 ) - ( loadingBarHeight / 2 );
	var iLeft = ( cliWidth / 2 ) - ( loadingBarWidth / 2 );
	
	
	// Becomes this.options
	var defaults = {
		bgColor 		: '#000',
		duration		: 300,
		opacity			: 0.5,
		classOveride 	: 'blue-loader'
	};
	
	this.options 	= jQuery.extend(defaults, options);
	this.container 	= $(el);
	
	this.init = function() {
		
		var container = this.container;
		// Delete any other loaders
		this.remove(); 
		// Create the overlay 
		
		var overlay = $('<div></div>').css({
			    'background-color': this.options.bgColor,
				'opacity':this.options.opacity,
				'width':cliWidth-20,
				'height':cliHeight-50,
				'position':'absolute',
				'top':iTop,
				'left':iLeft,
				'z-index':99999
		}).addClass('ajax_overlay');
		// add an overiding class name to set new loader style 
		if (this.options.classOveride) {
			overlay.addClass(this.options.classOveride);
		}
		// insert overlay and loader into DOM 
		container.append(
			overlay.append(
				$("<div><img src='/images/ajax-loader-5.gif' width='50px' height='50px'/><img src='/images/logo.png' height='50px'/></div>").addClass('ajax_loader')
			).fadeIn(this.options.duration)
		);
    };
	
	this.remove = function(){
		var overlay = this.container.children(".ajax_overlay");
		
		if (overlay.length) {
			overlay.fadeOut(this.options.classOveride, function() {
				overlay.remove();
			});
		}	
	};

    this.init();
}

function uploadAjaxLoader (el, options) {
	//화면넓이
	var cliWidth = $(document).width();

	//화면높이
	var cliHeight = $(document).height();

	//로딩바 넓이
	var loadingBarWidth  = cliWidth;

	//로딩바 높이
	var loadingBarHeight = cliHeight;

	//로딩바 위치 산출
	var iTop = ( cliHeight / 2 ) - ( loadingBarHeight / 2 );
	var iLeft = ( cliWidth / 2 ) - ( loadingBarWidth / 2 );
	
	
	// Becomes this.options
	var defaults = {
		bgColor 		: '#000',
		duration		: 0,
		opacity			: 0.5,
		classOveride 	: 'blue-loader'
	};
	
	this.options 	= jQuery.extend(defaults, options);
	this.container 	= $(el);
	
	this.init = function() {
		
		var container = this.container;
		// Delete any other loaders
		this.remove(); 
		// Create the overlay 
		
		var overlay = $('<div></div>').css({
			    'background-color': this.options.bgColor,
				'opacity':this.options.opacity,
				'width':cliWidth,
				'height':cliHeight,
				'position':'absolute',
				'top':iTop,
				'left':iLeft,
				'z-index':99999
		}).addClass('ajax_overlay');
		// add an overiding class name to set new loader style 
		if (this.options.classOveride) {
			overlay.addClass(this.options.classOveride);
		}
		// insert overlay and loader into DOM 
		container.append(
			overlay.append(
				$("<div><img src='/images/ajax-loader-5.gif' width='50px' height='50px'/><img src='/images/logo.png' height='50px'/></div>").addClass('ajax_loader')
			).fadeIn(this.options.duration)
		);
    };
	
	this.remove = function(){
		var overlay = this.container.children(".ajax_overlay");
		
		if (overlay.length) {
			overlay.fadeOut(this.options.classOveride, function() {
				overlay.remove();
			});
		}	
	};

    this.init();
}