


//CheckBox All Check
var CommonChkInputAllClick = function(header, body){
	if((header.is(":checked"))){
		body.attr("checked", true);
	}else{
		body.attr("checked", false);
	}
}

//Body 체크박스 클릭시 Header 체크박스 해제
var CommonChkBodyClick = function(header){	
	parent.attr("checked", false);
}
