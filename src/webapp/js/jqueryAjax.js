
function getAjaxHtml(target,url,lodingBar,callback)
{  
	$.ajax({
		url:url,
		cache:false,
		dataType:"html",
		beforeSend:function(x){
			if(typeof(target)!= 'undefined' && target!= null){
				target.empty();
			}
			if(lodingBar != 'undefined' && lodingBar != null && lodingBar != ""){
				lodingBar.html('<img src="/ematrix/TBC/images/ajax-loader-1.gif"/>');
	     		lodingBar.show();
	     	}
   		},
		success:function(innerhtml){
			var Ca = /\+/g;
			var deHtml = decodeURIComponent( innerhtml.replace(Ca, " ") ); 
			if(target != 'undefined' && target != null){
				$(target).html(deHtml);
			}
			if(lodingBar != 'undefined' && lodingBar != null){
				lodingBar.html('');
	     		lodingBar.hide();
	     	}
	     	if(callback != 'undefined' && callback != null){	     		
	     		if(typeof(target)!= 'undefined' && target!= null){
		     		callback(deHtml, target);
		     	}else{
		     		callback(deHtml);
		     	}
	     	}
	     	
		},
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			$(target).html(jxhr.responseText);
		}  
	});
}


function getAjaxHtmlAsync(target,url)
{  
	$.ajax({
		async: true,
		url:url,
		cache:false,
		dataType:"html",
		success:function(innerhtml){
			if($(target)!= 'undefined' && $(target)!= null)
			{
				$(target).html(innerhtml);				
			}
		}
	});
}


function getAjaxHtmlPost(target,url,data,lodingBar, targetArea, callback)
{  
	$.ajax({
		url:url,		
		cache:false,
		async:true,
		data:data,
		dataType:"html",
		headers: { "cache-control": "no-cache","pragma": "no-cache" },
		type:'POST',
		beforeSend:function(x){
			if(typeof(lodingBar) != 'undefined' && lodingBar != null && lodingBar != ""){
				if(typeof(target) != 'undefined' && target != null){
					target.empty();
				}
				lodingBar.html('<img src="/ematrix/TBC/images/ajax-loader-1.gif"/>');
	     		lodingBar.show();
	     	}
	     	
	     	//$("#btnSearch").unbind("click");
   		},
		success:function(innerhtml){
			if(typeof(target) != 'undefined' && target != null){
				$(target).html(innerhtml);
			}
			if(typeof(lodingBar)!= 'undefined' && lodingBar != null){
				lodingBar.html('');
	     		lodingBar.hide();
	     	}
	     	if(typeof(targetArea) != 'undefined' && targetArea != null){
	     		targetArea.show();
	     	}
	     	if(typeof(callback) != 'undefined' && callback != null){
	     		callback(innerhtml);
	     	}
	     	//$("#btnSearch").bind("click", function(){SearchClick()});
		},
		
		error:function(jxhr,textStatus,error)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if($(target)!= 'undefined' && $(target)!= null){
				$(target).html(jxhr.responseText);
			}		
		}  
	});

}


function getAjaxHtmlPost_Cache(target,url,data,lodingBar, targetArea, callback)
{  

	$.ajax({
		url:url,
		cache:true,
		data:data,
		dataType:"html",
		type:'POST',
		beforeSend:function(x){
			target.empty();
			if(lodingBar != 'undefined' && lodingBar != null && lodingBar != ""){
				lodingBar.html('<img src="/ematrix/TBC/images/ajax-loader-1.gif"/>');
	     		lodingBar.show();
	     	}
   		},
		success:function(innerhtml){
			if($(target)!= 'undefined' && $(target)!= null){
				$(target).html(innerhtml);
			}
			if(lodingBar != 'undefined' && lodingBar != null){
				lodingBar.html('');
	     		lodingBar.hide();
	     	}
	     	if(targetArea != 'undefined' && targetArea != null){
	     		targetArea.show();
	     	}
	     	if(callback != 'undefined' && callback != null){
	     		callback(innerhtml);
	     	}
			
		},
		
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			$(target).html(jxhr.responseText);
		}  
	});

}


function getAjaxTextPost(target,url,data,callback)
{  

	$.ajax({
		url:url,
		cache:true,
		data:data,
		dataType:"html",
		type:'POST',
		beforeSend:function(x){
		
   		},
		success:function(innerhtml){
	     	if(callback != 'undefined' && callback != null){
	     		callback(innerhtml);
	     	}
		},
		
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			$(target).text(jxhr.responseText);
		}  
	});

}


function getJsonAjaxFrom(url,data,lodingBar,callback)
{  
	$.ajax({
		url:url,
		cache:false,
		data:data,
		dataType:"json",
		type:'POST',
		beforeSend:function(x){
			if(lodingBar != 'undefined' && lodingBar != null && lodingBar != ""){
				lodingBar.html('<img src="/ematrix/TBC/images/ajax-loader-1.gif"/>');
	     		lodingBar.show();
	     	}
   		},
		success:function(jsonObj){
			
			if(lodingBar != 'undefined' && lodingBar != null){
				lodingBar.html('');
	     		lodingBar.hide();
	     	}
	     	callback(jsonObj);
		},
		
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			alert(jxhr.responseText);
		}  
	});
}


function initTarget(target)
{
	if(target!= 'undefined' && target!= null)
	{
		for (var i=target.childNodes.length; i>0; i--) 
		{
	
		 	target.removeChild(target.childNodes[i-1]);
	
		}
	}
}
function getAjaxJsonAsyncForTarget(targetname,url,callback)
{  
	var jsonObj;

	$.ajax({ 
		async: true,
		url:url, 
		data:jsonObj,
		dataType:'json',
		type:'GET', 
		success:function(jsonObj)
		{
			callback(targetname,jsonObj);
		}, 
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if(textStatus=="parsererror") 
				callback(targetname,eval(jxhr.responseText));
		}  
	}); 
}

function getAjaxJsonForTarget(url,targetname,callback)
{  
	var jsonObj;

	$.ajax({ 
		async: false,
		url:url, 
		data:jsonObj,
		dataType:'json',
		type:'GET', 
		success:function(jsonObj)
		{
			callback(targetname,jsonObj);
		}, 
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if(textStatus=="parsererror") 
				callback(targetname,eval(jxhr.responseText));
		}  
	}); 
}
function getAjaxJsonFormAsyncForTarget(url,form,callback)
{ 
	var jsonObj;

	form.ajaxForm(//ajax 를 이용해  multipart/form 넘김....
	{
		url:url,		
		data:jsonObj,
		dataType : 'json',
		success:function(jsonObj)
		{
			callback(jsonObj);
		},
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if(textStatus=="parsererror") {
				callback(eval(jxhr.responseText));
			}
		}
	});		
}

function getAjaxHtmlFormAsyncForTarget(url,form,callback)
{  
	var jsonObj;

	form.ajaxForm(//ajax 를 이용해  multipart/form 넘김....
	{
		url:url,
		data:jsonObj,
		dataType : 'html', 
		success:function(htmlObj)
		{
			callback(htmlObj)
		},
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if(textStatus=="parsererror") 
				callback(eval(jxhr.responseText));
		}
	});		
}
function getAjaxJsonAsync(url,callback)
{  
	var jsonObj;

	$.ajax({ 
		async: true,
		url:url, 
		data:jsonObj,
		dataType:'json',
		type:'GET', 
		success:function(jsonObj)
		{
			callback(jsonObj);
		}, 
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if(textStatus=="parsererror") 
				callback(eval(jxhr.responseText));
		}  
	});  
		
}

function getAjaxJson(url,callback)
{  
	var jsonObj;

	$.ajax({ 
		async: false,
		url:url, 
		data:jsonObj,
		dataType:'json',
		type:'GET', 
		success:function(jsonObj)
		{
			callback(jsonObj);
		}, 
		error:function(jxhr,textStatus)
		{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
			if(textStatus=="parsererror") {
				callback(eval(jxhr.responseText));
			}
		}  
	});  
}

function getAjaxFormHtml(form, url, lodingBar, target, callback){
	form.ajaxForm({
		url : url,
	    beforeSend: function() {
	        target.empty();
	        if($(lodingBar)!= 'undefined' && $(lodingBar)!= null){
	        	lodingBar.show();
	        	lodingBar.html('<img src="/ematrix/TBC/images/ajax-loader-1.gif"/>');
	        }
	    },
	    success: function() {
	        if($(lodingBar)!= 'undefined' && $(lodingBar)!= null){
	        	lodingBar.hide();
	        	lodingBar.html('');
	        }
	    },
		complete: function(xhr) {
			target.html(xhr.responseText);
			if(callback!= 'undefined' && callback != null){
				callback();
			}
		}
	}); 
}

function getAjaxFormMessage(form, url){
	form.ajaxForm({
		url:url,
	    beforeSend: function() {
	        
	    },
	    success: function() {
	        
	    },
		complete: function(json) {
			tafterDBTran(json);
		}
	}); 
}

var afterDBTran = function(json){
 	var msg = "";
	for(var keys in json){
		for(var key in json[keys]){
			if(key=='Result_Msg'){
				msg=json[keys][key];
			}
		}
	}
	alert(msg);
 }


// Ajax 파일 다운로드
jQuery.download = function(url, data, method, target){
    // url과 data를 입력받음
    var inputs = '';    
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
    };
	
	if(typeof(target) == 'undefined'){
		target = "_self";
	}
    // request를 보낸다.
    jQuery('<form action="'+ url +'" method="'+ (method||'post') +'" target="'+target+'" accept-charset="UTF-8" onsubmit="emulAcceptCharset(this)">'+inputs+'</form>').appendTo('body').submit().remove();
};

function emulAcceptCharset(app_form) {
    if (app_form.canHaveHTML) { // detect IE
        document.charset = app_form.acceptCharset;
    }
    return true;
}

function getMenuId(fileUrl, callback) {
	$.ajax({ 
		url:"menuId.do?fileUrl=" + fileUrl,
		async: false,
		dataType:'json',
		type:'post',
		success:function(data)
		{
			callback(data.menu_id);
		}, 
		error:function(jxhr,textStatus)
		{ 
			//에러인경우 Json Text 를  Json Object 변경해 보낸다.
			alert('해당 메뉴ID가 존재하지 않습니다.');
		}  
	});
}
