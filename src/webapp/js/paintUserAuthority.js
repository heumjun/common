// 사번이 208037,212329,PD0005 경우만 저장가능
function fn_buttonDisabledUser(userid, arrObj){
	if (userid == "208037" || userid == "212329" || userid == "PD0005" || userid == "211055") {
		
		for(var i=0; i < arrObj.length; i++) {	
			$(arrObj[i]).removeAttr( "disabled" );
			$(arrObj[i]).removeClass("btn_gray");
			$(arrObj[i]).addClass("btn_blue");
		}
		
	} else {
		for(var i=0; i < arrObj.length; i++) {	
			$(arrObj[i]).attr( "disabled", true );
			$(arrObj[i]).removeClass("btn_blue");
			$(arrObj[i]).addClass("btn_gray");
		}
	}
}