<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Print Paint</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<div id="mainDiv" class="mainDiv">
<form name="listForm" id="listForm"  method="get">
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	<div class= "subtitle">
	PLAN 도면조회/출력
	<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
		<input type="hidden"  name="pageYn"  	 	value="N"/>
		<input type="hidden"  name="selected_tab"  	value="blockPaintPlan"/>
		<input type="hidden"  name="paint_gbn"   	value=""/>
		<input type="hidden"  name="code_list"   	value=""/>
		<input type="hidden"  name="searchGbn"   	value=""/>
		<input type="hidden"  name="src" 	     	value=""/>
		<input type="hidden"  name="param" 	     	value=""/>
			
		
		
		<table class="searchArea conSearch" >
			<col width="110">
			<col width="210">

		<tr>
			<th>PROJECT NO</th>
			<td>
				<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
				<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
				<input type="button" id="btnProjNo"  value="검색"  class="btn_gray2">
			</td>

		<td class="bdl_no" colspan="2">
		<div class="button endbox">
				<c:if test="${userRole.attribute1 == 'Y'}">
				<input type="button" value="조회" 	  id="btnSearch"  class="btn_blue"				/>
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">
				<!--  <input type="button" value="저 장" 	  disabled id="btnSave"       	/> -->
				</c:if>
				<c:if test="${userRole.attribute5 == 'Y'}">	
				<input type="button" value="출력"  id="btnExcelExport"  class="btn_blue"/>
				</c:if> 
		</div>
		</td>
		</tr>
		</table>
		
		<div class="content" id = "center" style="margin-top:10px;">
			<div id="tabs" >
				<ul class="tabmenu">
					<li><a href="#tabs-1">BLOCK</a></li>  
					<li><a href="#tabs-2">PE</a></li>
					<li><a href="#tabs-3">HULL</a></li>
					<li><a href="#tabs-4">QUAY</a></li>
				</ul>
				<div id="tabs-1" >   
					<iframe id="blockPaintPlan" name="blockPaintPlan" 	src="paintPrintTabBlock.do?menu_id=${menu_id}" frameborder=0 marginwidth=0 marginheight=0  scrolling=no width=100% style="border-width:0px; border-color:white;"></iframe>
				</div>
				<div id="tabs-2">   
					<iframe id="pePaintPlan" 	name="pePaintPlan" 		src="paintPrintTabPe.do?menu_id=${menu_id}" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width="100%" style="border-width:0px;  border-color:white;"></iframe> 
				</div>
				<div id="tabs-3">   
					<iframe id="hullPaintPlan"  name="hullPaintPlan" 	src="paintPrintTabHull.do?menu_id=${menu_id}" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width=100% style="border-width:0px;  border-color:white;"></iframe>
				</div>
				<div id="tabs-4">   
					<iframe id="quayPaintPlan" 	name="quayPaintPlan" 	src="paintPrintTabQuay.do?menu_id=${menu_id}" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width="100%" style="border-width:0px;  border-color:white;"></iframe> 
				</div>
		
			</div>
		</div>
	</div>	
</form>

</body>

<script type="text/javascript">
var selected_tab_name 	 = "#tabs-1";
var tableId	   			 = "#";
var deleteData 			 = [];

var searchIndex 		 = 0;
var lodingBox; 
var win;	

var isLastRev			 = "N";
var isExistProjNo		 = "N";					
var sState				 = "";	
var search_flag				= "N";

var preProject_no		 = "";
var preRevision			 = "";

var change_item_row 	= 0;
var change_item_row_num = 0;
var change_item_col  	= 0;
var objectHeight = $(window).height()-200;

$(document).ready(function(){
	
	$(window).bind('resize', function() {
		$("#blockPaintPlan").css("height",$(window).height()-205);
		$("#pePaintPlan").css("height",$(window).height()-205);
		$("#hullPaintPlan").css("height",$(window).height()-205);
		$("#quayPaintPlan").css("height",$(window).height()-205);
	}).trigger('resize');
	
	//$("#center").css({'height':  $(window).height()});
	 
	
	// 탭이동시 호출하는 이벶트
	$( "#tabs" ).tabs( {
		activate : function( event, ui ) {
			
			selected_tab_name = ui.newPanel.selector;
			
			$("input[name=selected_tab]").val(fn_searchIfraId());
			
			fn_tabSearchCodeList();
		}
	} );
	
	// 조회 버튼
	$("#btnSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_getCodeList();
			
			if (!$.jgrid.isEmpty( $("input[name=code_list]").val())) fn_search();
		}
	});
	
	// 엑셀 Export
	$("#btnExcelExport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_getCodeList();
			
			if (!$.jgrid.isEmpty( $("input[name=code_list]").val()))  fn_excelDownload();	
		}
	});
	
	// 프로젝트 조회
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	fn_searchLastRevision("INIT");

	if($("#txtProjectNo").val() != ""){
		searchProjectNo();
	}
	
});  //end of ready Function 	

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Input Text입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// Revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	searchProjectNo();
	//fn_searchLastRevision();	
}

// 폼데이터를 Json Arry로 직렬화
function fn_getParam() {
	return fn_getFormData("#listForm");
}

//프로젝트 필수여부, 최종revision, 상태 체크하는 함수
function fn_ProjectNoCheck(isLastCheck) {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		alert("Project No is required");
		$("input[name=project_no]").focus();		
		return false;
	}
	
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
		alert("Revision is required");
		$("input[name=revision]").focus();
		return false;
	}
	
	
	return true;
}

// 선택되어있는  iframe객체 id를 리턴하는 함수
function fn_searchIfraId() {
	
	var ifraId;
	switch(selected_tab_name) {
		case "#tabs-1":
			ifraId = "blockPaintPlan";
			break;
		case "#tabs-2":
			ifraId = "pePaintPlan";
			break;
		case "#tabs-3":
			ifraId = "hullPaintPlan";
			break;
		case "#tabs-4":
			ifraId = "quayPaintPlan";
			break;
		case "#tabs-5":
			ifraId = "prePEPaintPlan";
			break;	
	}
	
	return ifraId;
}

// 선택된 Code List를 가져오는 함수
function fn_getCodeList() {
	
	var ifraId = fn_searchIfraId();
	var ifra   = document.getElementById(ifraId).contentWindow;
	
	var sCodeList = ifra.fn_getCodeList();
	
	if (sCodeList == "") {
		
		switch(selected_tab_name) {
			case "#tabs-1":
				alert("선택된 BLOCK이 없습니다.");
				break;
			case "#tabs-2":
				alert("선택된 PE가 없습니다.");
				break;
			case "#tabs-3":
				alert("선택된 HULL이 없습니다.");
				break;
			case "#tabs-4":
				alert("선택된 QUAY이 없습니다.");
				break;
			case "#tabs-5":
				alert("선택된 PRE PE이 없습니다.");
				break;	
		}
		
		$("input[name=code_list]").val("");
	} else {
		$("input[name=code_list]").val(sCodeList);
	}
}

// 선택한 Code의 Item List를 조회는 함수
function fn_search() {
	
	var ifraId = fn_searchIfraId();
	var ifra   = document.getElementById(ifraId).contentWindow;
	
	ifra.fn_search();
}

// 선택된 Code List를 가져오는 함수
function fn_tabSearchCodeList() {
	
	var ifraId = fn_searchIfraId();
	var ifra   = document.getElementById(ifraId).contentWindow;
	
	ifra.resizeJqGridWidth();
	ifra.fn_searchCodeList();
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 프로젝트번호 조회하는 화면 호출
function searchProjectNo() {
	
	var args = {project_no : $("input[name=project_no]").val()
			,revision : $("input[name=revision]").val()
			,viewType   : "MFC_VIEW"};
		
	var rs	=	window.showModalDialog("popupPaintPlanProjectNo.do",args,"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
		
	if (rs != null) {
		$("input[name=project_no]").val(rs[0]);
		$("input[name=revision]").val(rs[1]);
		search_flag = rs[2];
	}
	
	fn_searchLastRevision();
}

// 조회조건에 해당하는 RD파일을 호출한다.
function fn_excelDownload() {

	var param = $("input[name=project_no]").val()+":::";
		param += $("input[name=revision]").val()+":::";
		param += $("input[name=code_list]").val()+":::";
		param += "${loginUser.user_id}";
	
	$("input[name=param]").val(param);
	
	var mrdNm = "";
	
	switch(selected_tab_name) {
		case "#tabs-1":
			mrdNm = "http://172.16.2.13:7777/j2ee/STXDIS/mrd/STXPISBLOCKPAINTPLAN.mrd";
			break;
		case "#tabs-2":
			mrdNm = "http://172.16.2.13:7777/j2ee/STXDIS/mrd/STXPISPEPAINTPLAN.mrd";
			break;
		case "#tabs-3":
			mrdNm = "http://172.16.2.13:7777/j2ee/STXDIS/mrd/STXPISHULLPAINTPLAN.mrd";
			break;
		case "#tabs-4":
			mrdNm = "http://172.16.2.13:7777/j2ee/STXDIS/mrd/STXPISQUAYPAINTPLAN.mrd";
			break;
		case "#tabs-5":
			mrdNm = "http://172.16.2.13:7777/j2ee/STXDIS/mrd/STXPISPREPEPAINTPLAN.mrd";
			break;	
	}
	
	$("input[name=src]").val(mrdNm);
	
	var sUrl  = "http://172.16.2.13:7777/j2ee/STXDIS/WebReport.jsp";
	
	var f = document.listForm;
	
	f.target = "/blank"
	f.action = sUrl;
	f.method = "post";
	f.submit();
}

// 프로젝트번호의 최종 REVSION상태 조회
function fn_searchLastRevision(sInit) {
	
	var url		   = "paintPlanProjectNoCheck.do";
 	var parameters = {project_no : $("input[name=project_no]").val()
			   		 ,revision   : $("input[name=revision]").val()};
				
	$.post(url, parameters, function(data) {
	  		
		if (data != null) {
	  		isExistProjNo  = "Y";
	  		sState		   = data.state;
	  		
	  		if (data.last_revision_yn == "Y") isLastRev = "Y";
	  		else isLastRev = "N";
	  	} else {
	  		isExistProjNo = "N";
	  		isLastRev 	  = "N";  
	  		sState		  = "";	
	  	}
	  	
	  	if (preProject_no != $("input[name=project_no]").val() 
	  		|| preRevision !=  $("input[name=revision]").val()) 
	  	{
	  		
	  		if (sInit != "INIT") fn_tabSearchCodeList();
	  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
		fn_setButtionEnable();
	}).always(function() {
		fn_setButtionEnable();
	}); 	 	
}

//버튼 enable 설정
function fn_setButtionEnable() {
	if(sState == "D" || search_flag =='Y') {
		fn_buttonEnable(["#btnSearch","#btnExcelExport"]);		
	} else {
		fn_buttonDisabled(["#btnSearch","#btnExcelExport"]);		
	}
}
</script>
</html>