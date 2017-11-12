//체크박스 선택 한 ROW 색 변경
var chkSeleteColor = function(obj){
	if($(obj).is(":checked")){
		$(obj).parent().parent().removeClass("even").addClass("checkedTr");
	}else{
		if($(obj).parent().parent().is("tr:even")){
			$(obj).parent().parent().removeClass("checkedTr").not(".rawTr").addClass("even");
		}else{
			$(obj).parent().parent().removeClass("checkedTr");
		}
	}
}
//체크박스 선택 한 ROW 색 변경
//전체 체크 선택, 해제
var allchkSeleteColor = function(obj){
	var objTr = $(obj).parent().parent().parent().parent();
	if($(obj).is(":checked")){
		$(objTr).find("tr:even").removeClass("even");
		$(objTr).find("tr").addClass("checkedTr");
	}else{
		$(objTr).find("tr:even").not(".rawTr").addClass("even");
		$(objTr).find("tr").removeClass("checkedTr");		
	}
}
//ODD로 설정. SSC Main에 사용.
//체크박스 선택 한 ROW 색 변경
var chkSeleteColorOdd = function(obj){
	if($(obj).is(":checked")){
		$(obj).parent().parent().removeClass("even").addClass("checkedTr");
	}else{
		if($(obj).parent().parent().is("tr:odd")){
			$(obj).parent().parent().removeClass("checkedTr").not(".rawTr").addClass("even");
		}else{
			$(obj).parent().parent().removeClass("checkedTr");
		}
	}
}
//ODD로 설정. SSC Main에 사용.
//체크박스 선택 한 ROW 색 변경
//전체 체크 선택, 해제
var allchkSeleteColorOdd = function(obj){
	var objTr = $(obj).parent().parent().parent().parent();
	if($(obj).is(":checked")){
		$(objTr).find("tr:odd").removeClass("even");
		$(objTr).find("tr").addClass("checkedTr");
	}else{
		$(objTr).find("tr").removeClass("checkedTr");
		$(objTr).find("tr:odd").not(".rawTr").addClass("even");
	}
}

//체크박스 선택 한 ROW 색 변경
//전체 체크 선택, 해제
//헤더와 table content가 다를경우
var allchkTargetSeleteColor = function(obj, target){
	if($(obj).is(":checked")){
		$(target).find("tr:odd").removeClass("even");
		$(target).find("tr").addClass("checkedTr");
	}else{
		$(target).find("tr").removeClass("checkedTr");
		$(target).find("tr:odd").not(".rawTr").addClass("even");
	}
}