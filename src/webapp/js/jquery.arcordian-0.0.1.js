/*
*일자:   2013.01.04
*작성자: 백재호
*설명:   jquery 를 이용한 이미지 아코디언동작 구현
*/

(function($)
{
	var extending = function(idx){
		data=$(this).data('data');
		var obj = data.self.children().children();
		var fadeobj = data.self.children().children().children();
		var expender = obj.eq(idx);

		var wmax = data.settings.wgrow;
		var hmax = data.settings.hgrow;
		var wmin = data.settings.width - data.settings.wgrow;
		var hmin = data.settings.height - data.settings.hgrow;
				
		if(data.settings.fade){
			if(fadeobj != undefined){
				fadeobj.eq(idx).hide();
			}
		}

		var x = 0;
		var y = 0;
		var v_width = 0;
		var v_height = 0;

		for(var i=0; i<obj.length; i++){
			x = obj.eq(i).attr('x');
			y = obj.eq(i).attr('y');
			if(i == idx){
				obj.eq(i).animate({width:wmax, height:hmax},{queue:data.settings.queue, duration:data.settings.duration, easing: data.settings.easing});	
			}else{
				if(x == obj.eq(idx).attr('x')){
					v_width = wmax;
				}else{
					v_width = wmin;					
				}
				if(y == obj.eq(idx).attr('y')){
					v_height = hmax;
				}else{
					v_height = hmin;
				}
				obj.eq(i).animate({width:v_width, height:v_height},{queue:data.settings.queue, duration:data.settings.duration, easing: data.settings.easing});	
			}
		}
	};
	var extending_abs = function(idx){
		data=$(this).data('data');

		var obj = data.self.children().children();
		var fadeobj = data.self.children().children().children();
		var expender = obj.eq(idx);

		var wmax = data.settings.wgrow;
		var hmax = data.settings.hgrow;
		var wmin = data.settings.width - data.settings.wgrow;
		var hmin = data.settings.height - data.settings.hgrow;
				
		if(data.settings.fade){
			if(fadeobj != undefined){
				fadeobj.eq(idx).fadeOut({duration:data.settings.fadedura, queue:data.settings.queue});
			}
		}

		var x = 0;
		var y = 0;
		var v_width = 0;
		var v_height = 0;
		var v_top = 0;
		var v_left = 0;

		for(var i=0; i<obj.length; i++){
			x = obj.eq(i).attr('x');
			y = obj.eq(i).attr('y');
			
			if(i == idx){
				if(x == 0){
					v_left = 0;
				}else{
					v_left = wmin;					
				}
				if(y == 0){
					v_top = 0;
				}else{
					v_top = hmin;
				}

				obj.eq(i).animate({width:wmax, height:hmax, top:v_top , left:v_left },{queue:data.settings.queue, duration:data.settings.duration, easing: data.settings.easing});	
			}else{
				if(x == obj.eq(idx).attr('x')){
					if(x==0){
						v_left = 0;
					}else{
						v_left = wmax;
					}
				}else{
					v_left = wmax;
				}
				if(y == obj.eq(idx).attr('y')){
					v_top = 0;
				}else{
					v_top = hmax;
				}

				if(x == obj.eq(idx).attr('x')){
					v_width = wmax;
				}else{
					v_width = wmin;					
				}
				if(y == obj.eq(idx).attr('y')){
					v_height = hmax;
				}else{
					v_height = hmin;
				}
				obj.eq(i).animate({width:v_width, height:v_height, top:v_top , left:v_left},{queue:data.settings.queue, duration:data.settings.duration, easing: data.settings.easing});	
			}
		}
	};
	
	var revert = function(){
		data=$(this).data('data');
		var fadeobj = data.self.children().children().children();
		var defaultwidth  = data.settings.width/2;
		var defaultheight = data.settings.height/2;

		for(var i = 0; i < data.self.children().children().length; i++ ){
			if(data.self.children().children().eq(i) != undefined)	{
				data.self.children().children().eq(i).animate({width:defaultwidth, height:defaultheight},{queue:data.settings.queue, duration:data.settings.duration, easing: data.settings.easing});
			}
		}

		if(data.settings.fade){
			if(fadeobj != undefined){
				fadeobj.show();
				fadeobj.attr('style', 'filter:alpha(opacity=70); opacity: 0.7;-moz-opacity:0.3;');
			}
		}
	};

	
	$.fn.arcordian = function( method ) 
	{
		
		var methods = {
			init : function(options) {
				defaults={timer:undefined, effect:'arcordian', left:0, top:0, position:'relative', auto:false, interval:3000, opacity:false, queue:false, duration:600, easing:'easeInOutExpo', fade:false, fadedura:0};
				data=$(this).data('data');

				if(!data) {
					$(this).data('data', {
						self:$(this),
						settings:defaults
					});
					data=$(this).data('data');
				}
				$.extend(data.settings, options);
				return this.each(function() {
					$(this).css('width', data.settings.width);
					$(this).css('height', data.settings.height);
					$(this).css('wgrow', data.settings.wgrow);
					$(this).css('hgrow', data.settings.hgrow);
					$(this).css('top', data.settings.top);
					$(this).css('left', data.settings.left);
					$(this).css('position', data.settings.position);
					$(this).css('overflow','hidden');

				});
			},
			
			extending : extending,
			revert    : revert,
			extending_abs : extending_abs
		};
	
		
    	
    	if ( methods[method] ) {			
			return methods[ method ].apply( this, Array.prototype.slice.call(arguments, 1 ));
		} 
		else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		}
		else {
			$.error( 'Method ' +  method + ' 는 지원하지 않음...' );
			return this;
    	}    	
  	};

({})})(jQuery)