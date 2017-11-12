function fnProgressOff(id)
{
	if(!id)id = "imgProgressDiv";
	document.getElementById(id).style.display="none";
}

function fnProgressOn(id)
{
	if(!id)id = "imgProgressDiv";
	document.getElementById(id).style.display="";
}

function fnBtnEvent(obj,strType) 
{
	switch(strType) {
		case "mouseover":
			emxUICore.addClass(obj, "button-hover"); 
			break;
		case "mouseout":
			emxUICore.removeClass(obj, "button-hover");
			emxUICore.removeClass(obj, "button-active");
			break;
		case "mousedown":
			emxUICore.removeClass(obj, "button-hover");
			emxUICore.addClass(obj, "button-active");
			break;
		case "mouseup":
			emxUICore.removeClass(obj, "button-active");
			break; 
	}
	obj = null;
	strType = null; 
}
