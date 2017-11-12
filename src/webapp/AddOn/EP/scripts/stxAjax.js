
function stxAjax(vUrl, vCallBack, vIsPost)
{
	if (window.ActiveXObject)
	{
		this.objXmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
	} else if (window.XMLHttpRequest) 
	{
		this.objXmlHttpReq = new XMLHttpRequest();
	}
	this.url 		= vUrl;
	this.isPost		= vIsPost;
	this.callBack 	= vCallBack;
	vUrl = null;
	vIsPost = null;
	vCallBack = null;
}

stxAjax.prototype = {
	getUrl: function () 
	{
		return this.url;
	},
	getCallBack: function () 
	{
		return this.callBack;
	},
	setUrl: function(vUrl)
	{
		if(vUrl)
		{
			this.url = vUrl;
		}
		vUrl = null;
	},
	setCallBack: function(vCallBack)
	{
		if(vCallBack)
		{
			this.callBack = vCallBack;
		}
		vCallBack == null;
	},
	setPost: function()
	{
		this.isPost = true;
	},
	executeAnSync: function(isXMLOut,vParam)
	{
		var vGetPost = "GET";
		if(this.isPost)
		{
			vGetPost = "POST";
		}
		
		if(!this.url || this.url == '')
		{
			alert("AjaxError:Url is null or Empty");
			return;
		}
		
		if(!this.callBack || this.callBack == '')
		{
			alert("AjaxError:CallBack Function is null or Empty");
			return;
		}
		
		var vXmlHttpReq = this.objXmlHttpReq;
		var vCallBack = this.callBack;
		vXmlHttpReq.open(vGetPost, this.url, true);
		vXmlHttpReq.onreadystatechange = function() {
			if(vXmlHttpReq.readyState == 4)
			{
				if(vXmlHttpReq.status == 200)
				{
					var vReturn = vXmlHttpReq.responseText;
					if(isXMLOut)
			        {
			        	vReturn = vReturn.replace(/(^\s*)|(\s*$)/g, "");
			        	vReturn = fnParseXmlFromText(vReturn)
			        } else {
			        	vReturn = vReturn.replace(/(^\s*)|(\s*$)/g, "");
			        }
	        		eval(vCallBack+"(vReturn,vParam)");
	        		vGetPost = null;
        			vCallBack = null;
        			vXmlHttpReq = null;
        			vReturn = null;
				} else if(vXmlHttpReq.status == 204) {
				} else {
					alert('Ajax Error'+vXmlHttpReq.status)
					vGetPost = null;
        			vCallBack = null;
        			vXmlHttpReq = null;
				}
			}
        }
        vXmlHttpReq.send(null);
	},
	executeSync: function(isXMLOut,vParam)
	{
		try{
			if(!this.url || this.url == '')
			{
				alert("AjaxError:Url is null or Empty");
				return;
			}
			var vGetPost = "GET";
			var vXmlHttpReq = this.objXmlHttpReq;
			if(this.isPost)
			{
				vGetPost = "POST";
			}
			vXmlHttpReq.open(vGetPost, this.url, false);
			if(this.isPost)
			{
				vXmlHttpReq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); 
			}
	        vXmlHttpReq.send(vParam);
	        if(isXMLOut)
	        {
	        	return fnParseXmlFromText(this.trim(vXmlHttpReq.responseText))
	        } else {
	        	return this.trim(vXmlHttpReq.responseText);
	        }
        } catch(e) {
        	alert(e);
        } finally {
        	vGetPost = null;
        	isXMLOut = null;
        	vXmlHttpReq = null;
        } 
	},
	trim: function(vText) 
	{ 
		return vText.replace(/(^\s*)|(\s*$)/g, ""); 
	},
	parseXML: function(vText) 
	{ 
		var vReturnDoc = new ActiveXObject("Msxml2.DOMDocument"); 
		vReturnDoc.loadXML(vText);
		return vReturnDoc;
	}
}

function fnParseXmlFromText(vText)
{
	try{
		var vReturnDoc = new ActiveXObject("Msxml2.DOMDocument"); 
		vReturnDoc.loadXML(vText);
		return vReturnDoc;
	} finally {
		vReturnDoc = null;
		vText = null;
	}
}

function fnGetformParam(oForm)
{
	try{
		var vParam = "";
		var elForm;
		for(var index=0;index<oForm.elements.length;index++)
		{
			elForm = oForm.elements[index];
			switch(elForm.type)
			{
				case 'text':
					vParam += elForm.name + '=' + elForm.value + '&'
					break;
				case 'hidden':
					vParam += elForm.name + '=' + elForm.value + '&'
					break;
				case 'password':
				case 'textarea':
				case 'select-one':
					vParam += elForm.name + '=' + elForm.value + '&'
					break;
				case 'radio':
					if(elForm.checked) {
						vParam += elForm.name + '=' + elForm.value + '&'
					}
					break;
				case 'checkbox':
					break;
			}
		}
		return vParam;
	} finally {
		oForm = null;
		vParam = null;
		elForm = null;
	}
}

String.prototype.encodeURI = function() 
{ 
	return encodeURIComponent(this);
}

