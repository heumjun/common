<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Quantity</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
	<div class= "subtitle">
	Paint Quantity
	<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>

	<input type="hidden"  name="pageYn"  	 value="N"/>
	<input type="hidden"  name="block_code"  value=""/>
	<input type="hidden"  name="area_code" 	 value=""/>
	<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	

				<table class="searchArea conSearch" >
					<col width="110">
					<col width="210">
					<col width="130">
					<col width="150">
					<col width="210">
					<col width="*" style="min-width:270px;">

					<tr>
						<th>PROJECT NO</th>
						<td>
						<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
						<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
						<input type="button" id="btnProjNo" value="검색" class="btn_gray2">
						</td>
					
					<td>
						<fieldset style="border:none;">
							<input type="radio"	 name="season_code" value="S" checked="checked">Summer 
							<input type="radio"  name="season_code" value="W">Winter
						</fieldset>
					</td>

					<td>
						<fieldset style="border:none;">
							<input type="radio"	 name="search_gbn" value="">ALL 
							<input type="radio"	 name="search_gbn" value="BLOCK" checked="checked">BLOCK 
							<input type="radio"  name="search_gbn" value="AREA">AREA
						</fieldset>
					</td>

					<td>
						<fieldset style="border:none;">			
							<input type="checkbox" id="chkBlock" name="chkBlock" value="Y">Block
							<input type="checkbox" id="chkPrePE" name="chkPrePE" value="Y">Pre PE
							<input type="checkbox" id="chkPE" 	 name="chkPE" 	 value="Y">PE
							<input type="checkbox" id="chkDock"  name="chkDock"  value="Y">Dock
							<input type="checkbox" id="chkQuay"  name="chkQuay"  value="Y">Quay
						</fieldset>
					</td>

					

					<td class="bdl_no" colspan="2">
					<div class="button endbox">
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" id="btnSearch"			value="조회"			class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" id="btnSave"			value="확정"			class="btn_gray" disabled />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">	
						<input type="button" id="btnUndefined"		value="확정해제"		class="btn_gray" disabled />
						</c:if>
						<c:if test="${userRole.attribute5 == 'Y'}">
						<input type="button" id="btnExcelExport"	value="Excel출력"	class="btn_blue" />
						</c:if>
						
						
						
					</div>
					</td>
					</tr>
					
					</table>
					<table class="searchArea2" >
					<tr>
					<td colspan="6">
					<ul class="ul_inline">
					<li><input type="checkbox"  id="chkPrePeHalf"	name="chkPrePeHalf" onclick="fn_checkBox(this,event)" value="Y" class="check1 ">PE → Pre PE 50%</li>
					<li><input type="checkbox"  id="chkPrePeAll"	name="chkPrePeAll"  onclick="fn_checkBox(this,event)" value="Y" class="check1">PE → Pre PE 100%</li>
					<li><input type="checkbox"  id="chkDockAll"		name="chkDockAll"   onclick="fn_checkBox(this,event)" value="Y" class="check1">PE → DOCK 100%</li>
					<li>						
						<input type="checkbox"  id="chkBlockAll"	name="chkBlockAll"  onclick="fn_checkBox(this,event)" value="Y" class="check1">PE → BLOCK 100%
						<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button"    id="btnTransfer" 	value="이 관"	 disabled  class="btn_gray"/>
						</c:if>
					</li>
					
					<li>					
						 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button"    id="btnAutoTransfer" 	value="자동 이관"	 disabled  class="btn_gray"/>
						</c:if>
					</li>					
					</ul>
					</td>
					
					</tr>
				</table>
<!--
		<div class = "topMain" style="line-height:45px">
			<div class = "conSearch">
				<span class = "spanMargin">
					PROJECT NO  <input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:120px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
								<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:right; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="return numbersonly(event, false);" />
								<input type="button" id="btnProjNo"    style="height:24px;width:24px;" value="...">
				</span>
			</div>
			<div class = "conSearch">
				<fieldset style="width: 130px; display: inline; height:20px; line-height:20px">
					<input type="radio"	 name="season_code" value="S" checked="checked">Summer 
					<input type="radio"  name="season_code" value="W">Winter
				</fieldset>
				<fieldset style="width: 170px; display: inline; height:20px; line-height:20px">
					<input type="radio"	 name="search_gbn" value="">ALL 
					<input type="radio"	 name="search_gbn" value="BLOCK" checked="checked">BLOCK 
					<input type="radio"  name="search_gbn" value="AREA">AREA
				</fieldset>
				
				<fieldset style="width: 260px; display: inline; height:20px; line-height:20px">			
					<input type="checkbox" id="chkBlock" name="chkBlock" value="Y">Block
					<input type="checkbox" id="chkPE" 	 name="chkPE" 	 value="Y">PE
					<input type="checkbox" id="chkPrePE" name="chkPrePE" value="Y">Pre PE
					<input type="checkbox" id="chkDock"  name="chkDock"  value="Y">Dock
					<input type="checkbox" id="chkQuay"  name="chkQuay"  value="Y">Quay
				</fieldset>
			</div>
			
			<div class = "button">
				<input type="button" value="조  회" 	  id="btnSearch"  				/>
				<input type="button" value="확 정" 	  disabled id="btnSave"       	/>
				<input type="button" value="확정해제"    disabled id="btnUndefined"  	/>
				<input type="button" value="Excel출력"  id="btnExcelExport"  			/>	
			</div>
			
			
		</div>
		
		<div class = "topMain" style="border: 0px;">
			<div class = "button">
				<input type="checkbox"  id="chkPrePeHalf"	name="chkPrePeHalf" onclick="fn_checkBox(this,event)" value="Y" class="check1">PE → Pre PE 50%  <br>
				<input type="checkbox"  id="chkPrePeAll"	name="chkPrePeAll"  onclick="fn_checkBox(this,event)" value="Y" class="check1">PE → Pre PE 100% 
				<input type="button"    id="btnTransfer" 	value="이 관"	 disabled /> <br>
				<input type="checkbox"  id="chkDockAll"		name="chkDockAll"   onclick="fn_checkBox(this,event)" value="Y" class="check1">PE → DOCK 100% 	
			</div>
		</div>
		
		-->
		<iframe id="ifAllQuantity" name="ifAllQuantity" src="paintAllQuantity.do" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width=100% height=100% style="width:100%; height:100%; border-width:0px;  border-color:white;"></iframe>
		<!--<div id = "center" >
		
			<div id="tabs">
			
				 <ul>
					<li><a href="#tabs-1">전체 QUANTITY</a></li>    
					<li><a href="#tabs-2">수정된 QUANTITY</a></li>
				</ul>
				<div id="tabs-1">   
					<iframe id="ifAllQuantity" name="ifAllQuantity" src="paintAllQuantity.do" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width=100% height=650 style="border-width:0px;  border-color:white;"></iframe>
				</div>
				<div id="tabs-2">   
					<iframe id="ifEditQuantity" name="ifEditQuantity" src="paintEditQuantity.do" frameborder=0 marginwidth=0 marginheight=0 scrolling=no width="100%" height=650 style="border-width:0px;  border-color:white;"></iframe> 
				</div> 
			</div>
		</div>-->
	
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

var preProject_no;
var preRevision;
var objectWindow = $(window);
var objectHeight = $(window).height()-150;
$(document).ready(function(){
	$(window).bind('resize', function() {
		$("#ifAllQuantity").css({'height':  $(window).height()-150});
	}).trigger('resize');
	
	/* $("#ifEditQuantity").css({'height':  $(window).height()-160}); */
	// 탭이동
	$( "#tabs" ).tabs( {
		activate : function( event, ui ) {
			selected_tab_name = ui.newPanel.selector;
		}
	} );
	
	// 확정 해제 버튼	
	$( "#btnUndefined" ).click(function() {
		//if (fn_ProjectNoCheck(false)) {
			fn_planQuantityUndefined();
		//}
	});	
		
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	//이관 버튼
	$("#btnTransfer").click(function() {
		
		fn_transfer();
	});
	
	//이관 버튼
	$("#btnAutoTransfer").click(function() {
		
		fn_autoTransfer();
	});	
	
	//조회 버튼
	$("#btnSearch").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_search();
		}
	});
	
	//엑셀 Import	
	$("#btnExcelImport").click(function() {
		fn_excelUpload();	
	});
	
	//엑셀 Export
	$("#btnExcelExport").click(function() {
		if (fn_ProjectNoCheck(false)) {
			fn_downloadStart();
			fn_excelDownload();	
		}
	});
	
	// 프로젝트 조회 버튼
	$("#btnProjNo").click(function() {
		searchProjectNo();
	});
	
	fn_searchLastRevision();
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Input Text입력시 대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
	searchProjectNo();
}

// Revsion이 변경된 경우 호출되는 함수
function changedRevistion(obj) {
	fn_searchLastRevision();	
}

// Check Box가 하나만 체크되도록 한다
function fn_checkBox(obj, e) {
	
	var chkBox = $("#"+obj.id);
	
	var isChecked = false;
	if(chkBox.is(":checked")){
		isChecked = true;
	}
	
	$(".check1").prop("checked", false);
	chkBox.prop("checked", isChecked);
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// grid resize 이벤트를 바인딩 한다.
function resizeIframe(obj) {
	 var iframeHeight=(obj).contentWindow.document.body.scrollHeight;
    (obj).height=iframeHeight+21;
}

// 프로젝트 리비젼에 따라 버튼 enable설정하는 함수
function fn_setButtionEnable() {
	
	if ("Y" == isLastRev && sState != "D") {
		$( "#btnSave" ).removeAttr( "disabled" );
		$( "#btnSave" ).removeClass("btn_gray");
		$( "#btnSave" ).addClass("btn_blue");
		
// 		$( "#btnSend").removeAttr( "disabled" );
		$( "#btnTransfer").removeAttr( "disabled" );
		$( "#btnTransfer" ).removeClass("btn_gray");
		$( "#btnTransfer" ).addClass("btn_blue");
		
		$( "#btnAutoTransfer").removeAttr( "disabled" );
		$( "#btnAutoTransfer" ).removeClass("btn_gray");
		$( "#btnAutoTransfer" ).addClass("btn_blue");		
		
		$( "#btnUndefined").removeAttr( "disabled" );
		$( "#btnUndefined" ).removeClass("btn_gray");
		$( "#btnUndefined" ).addClass("btn_blue");
		
	} else {
		$( "#btnSave" ).attr( "disabled", true );
		$( "#btnSave" ).removeClass( "btn_blue" );
		$( "#btnSave" ).addClass( "btn_gray" );
// 		$( "#btnSend" ).attr( "disabled", true );
		$( "#btnTransfer" ).attr( "disabled", true );
		$( "#btnTransfer" ).removeClass( "btn_blue" );
		$( "#btnTransfer" ).addClass( "btn_gray" );
		
		$( "#btnAutoTransfer" ).attr( "disabled", true );
		$( "#btnAutoTransfer" ).removeClass( "btn_blue" );
		$( "#btnAutoTransfer" ).addClass( "btn_gray" );		
		
		$( "#btnUndefined").attr( "disabled", true );
		$( "#btnUndefined" ).removeClass( "btn_blue" );
		$( "#btnUndefined" ).addClass( "btn_gray" );
	}
}

// 프로젝트 필수여부, 최종revision, 상태 체크하는 함수
function fn_ProjectNoCheck(isLastCheck) {
	
	if ($.jgrid.isEmpty( $("input[name=project_no]").val())) {
		alert("Project No is required");
		setTimeout('$("input[name=project_no]").focus()',200);	
		return false;
	}
	
	if ($.jgrid.isEmpty( $("input[name=revision]").val())) {
		alert("Revision is required");
		setTimeout('$("input[name=revision]").focus()',200);	
		return false;
	}
	
	if (isExistProjNo == "N" && isLastCheck == true) {
		alert("Project No does not exist");
		return false;
	}
	
	if (sState == "D" && isLastCheck == true) {
		alert("State of the revision is released");
		return false;
	}
	
	if ( isLastRev == "N" && isLastCheck == true) {
		alert("PaintPlan Revision is not the end");
		return false;
	}
	
	return true;
}

// 폼데이터를 Json Arry로 직렬화
function fn_getParam() {
	return fn_getFormData("#listForm");
}

// 그리드에 변경된 데이터Validation체크하는 함수
function fn_checkPaintQuantityValidate() {
	var result   = true;
	var message  = "";
	
	var ifra = document.getElementById('ifAllQuantity').contentWindow;
	
	if (!fn_ProjectNoCheck(false)) {
		result  = false;
		return result;	
	}
	
	if ( ifra.getReccount() == 0 ) {
		result  = false;
		message = "조회된 내용이 없습니다.";		
	}
		
	if (result 
		&& !$("#chkBlock").is(":checked") 
		&& !$("#chkPE").is(":checked")
		&& !$("#chkPrePE").is(":checked")
		&& !$("#chkDock").is(":checked")
		&& !$("#chkQuay").is(":checked")) 
	{
		result  = false;
		message = "확정FLAG가 선택되지 않았습니다.";		
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// PaintQuantity이관시 Validation체크하는 함수
function fn_checkPaintQuantityTransferValidate() {
	
	var result   = true;
	var message  = "";
	var ifra = document.getElementById('ifAllQuantity').contentWindow;
	
	if (!fn_ProjectNoCheck(false)) {
		result  = false;
		return result;	
	}
	
	if ( ifra.getReccount() == 0 ) {
		result  = false;
		message = "조회된 내용이 없습니다.";		
	}
		
	if (result 
		&& !$("#chkPrePeHalf").is(":checked") 
		&& !$("#chkPrePeAll").is(":checked")
		&& !$("#chkDockAll").is(":checked")
		&& !$("#chkBlockAll").is(":checked"))
	{
		result  = false;
		message = "이관대상이 선택되지 않았습니다.";		
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 프로젝트번호 조회하는 화면 호출 
function searchProjectNo() {
	
	var args = {project_no : $("input[name=project_no]").val()};
			   //,revision   : $("input[name=revision]").val()};
		
	var rs	=	window.showModalDialog("popupPaintPlanProjectNo.do",args,"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
		
	if (rs != null) {
		$("input[name=project_no]").val(rs[0]);
		$("input[name=revision]").val(rs[1]);
	}
	
	fn_searchLastRevision();
}

// 프로젝트 최종 리비젼 조회하는 함수
function fn_searchLastRevision() {
	
	var url		   = "paintPlanProjectNoCheck.do";
 	var parameters = {project_no : $("input[name=project_no]").val()
			   		 ,revision   : $("input[name=revision]").val()};
						
	$.post(url, parameters, function(data) {		
		if(data !=null && data != ""){
			isExistProjNo  = "Y";
	  		if(data.state != null && data.state != 'undefined') sState = data.state;
	  		else sState = "";
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
	  			  			  		
	  		preProject_no =  $("input[name=project_no]").val();
	  		preRevision	  =  $("input[name=revision]").val();
	  	}
	  		  	
	  	fn_setButtionEnable();
	});  	

}

// 계산된 Paint Quantity 리스트 조회 
function fn_search() {
	var args = {
				project_no	: $("input[name=project_no]").val(),
				revision	: $("input[name=revision]").val()
			};
			
	var sSearchGbn = $(':radio[name="search_gbn"]:checked').val();

	var sUrl = "";
	if ( sSearchGbn == "BLOCK") {
		sUrl += "popupQuantityBlockCode.do";
	} else if ( sSearchGbn == "AREA") {
		sUrl += "popupQuantityAreaCode.do";
	}

	var bSearch = true;
	
	// BLOCK / AREA 선택 시 BLOCK 및 AREA 코드 선택 화면 팝업
	if ( sSearchGbn == "BLOCK" || sSearchGbn == "AREA" ) {
		
		var rs = window.showModalDialog(sUrl,args,"dialogWidth:800px; dialogHeight:880px; center:on; scroll:off; status:off; location:no;resizable:yes");
		
		if (rs != null) {
			
			if (rs[0] == "ALL") {
				$("input[name=block_code]").val("");
				$("input[name=area_code]").val("");
			} else {
				
				if ( $(':radio[name="search_gbn"]:checked').val() == "BLOCK") {
					$("input[name=block_code]").val(rs[0]);
					$("input[name=area_code]").val();
				} else if ( $(':radio[name="search_gbn"]:checked').val() == "AREA") {
					$("input[name=block_code]").val("");
					$("input[name=area_code]").val(rs[0]);
				}
			}
			
		} else {
			bSearch = false;
			$("input[name=block_code]").val("");
			$("input[name=area_code]").val("");
		}
		
	} else {
		$("input[name=block_code]").val("");
		$("input[name=area_code]").val("");
	}
				
	var ifra;
	
	if (selected_tab_name == "#tabs-1") {
		ifra = document.getElementById('ifAllQuantity').contentWindow;
   			
	} else if (selected_tab_name == "#tabs-2") {
		ifra = document.getElementById('ifEditQuantity').contentWindow;
	}
	
	if (bSearch) ifra.fn_search(); 
}

// 엑셀다운로드 화면 호출
function fn_excelDownload() {
		
	var f    = document.listForm;
	
	f.action = "allQuantityExcelExport.do";
	f.method = "post";
	f.submit();
	
}

// 조회 조건에 해당는 Paint Item Quantity 물량 확정 한다.
function fn_save() {
	
	if (confirm('확정 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
	if (!fn_checkPaintQuantityValidate()) { 
		lodingBox.remove();
		return;	
	}
	
	var url			= "savePaintQuantity.do";
	var parameters  = fn_getFormData('#listForm');
	
	$.post(url, parameters, function(data) {
		
			alert(data.resultMsg);
			
			if (data.result == "success") {
			 	
			 	var ifra;
				
				if (selected_tab_name == "#tabs-1") {
					ifra = document.getElementById('ifAllQuantity').contentWindow;			   			
				} else if (selected_tab_name == "#tabs-2") {
					ifra = document.getElementById('ifEditQuantity').contentWindow;
				}
				
				ifra.fn_search(); 
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
}

// PE Quantity물량을 Pre PE, Dock물량으로 이관
function fn_transfer() {
	
	if (confirm('이관 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	if (!fn_checkPaintQuantityTransferValidate()) { 
		lodingBox.remove();
		return;	
	}

	var url			= "savePaintQuantityTransfer.do";
	var parameters  = fn_getFormData('#listForm');
	
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			
			if (data.result == "success") {
			 	
			 	var ifra;
				
				if (selected_tab_name == "#tabs-1") {
					ifra = document.getElementById('ifAllQuantity').contentWindow;			   			
				} else if (selected_tab_name == "#tabs-2") {
					ifra = document.getElementById('ifEditQuantity').contentWindow;
				}
				
				ifra.fn_search(); 
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
	
}


// PE Quantity물량을 Pre PE, Dock, Quay 물량으로 자동 이관 (DIS or Mig 호선에 따라 로직은 다름)
function fn_autoTransfer() {
	
	if (confirm('자동 이관 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	/* 일단 제거
	if (!fn_checkPaintQuantityTransferValidate()) { 
		lodingBox.remove();
		return;	
	}
	*/

	var url			= "savePaintQuantityAutoTransfer.do";
	var parameters  = fn_getFormData('#listForm');
	
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			
			if (data.result == "success") {
			 	
			 	var ifra;
				
				if (selected_tab_name == "#tabs-1") {
					ifra = document.getElementById('ifAllQuantity').contentWindow;			   			
				} else if (selected_tab_name == "#tabs-2") {
					ifra = document.getElementById('ifEditQuantity').contentWindow;
				}
				
				ifra.fn_search(); 
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
	
}

// 조회 조건에 해당는 Paint Item Quantity 물량 확정 해제 한다.
function fn_planQuantityUndefined() {
	
	if (confirm('확정 해제 하시겠습니까?') == 0 ) {
		return;
	}
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
	if (!fn_checkPaintQuantityValidate()) { 
		lodingBox.remove();
		return;	
	}
	
	var url			= "undefinePaintQuantity.do";
	var parameters  = fn_getFormData('#listForm');
	
	$.post(url, parameters, function(data) {
			
		    alert(data.resultMsg);
		    
			if (data.result == "success") {
			 	
			 	var ifra;
				
				if (selected_tab_name == "#tabs-1") {
					ifra = document.getElementById('ifAllQuantity').contentWindow;			   			
				} else if (selected_tab_name == "#tabs-2") {
					ifra = document.getElementById('ifEditQuantity').contentWindow;
				}
				
				ifra.fn_search(); 
			}
			
		}).fail(function(){
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		}).always(function() {
	    	lodingBox.remove();	
		});
	
}

</script>
</html>