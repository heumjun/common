//영구 ECO 체크 : 뒤에서 4번째 숫자가 7이면 잠정, 5면 영구
var ecoCheck = function(obj, ecoType){
	if(ecoType == "5"){
		var msg = "영구 ECO만 가능합니다."	
	}else if(ecoType == "7"){
		var msg = "잠정 ECO만 가능합니다."	
	}
	var econo = $(obj).val();
	if(econo.length == 10){
		if(econo.substr(6,1) != ecoType){
			alert(msg);
			$(obj).focus();
			return false;
		}else{
			return true;
		}
	}else{
		alert("ECO가 잘못되었습니다.");
		return false;
	}
}