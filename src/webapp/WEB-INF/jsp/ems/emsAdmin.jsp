<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Admin</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.totalEaArea {position:relative; 
				margin-left:10px; 
				margin-right:0px; 
				padding:4px 4px 6px 4px; 
				font-weight:bold; 
				border:1px solid #ccc; 
				background-color:#D7E4BC; 
				vertical-align:middle; 
				}
	.onMs{background-color:#FFFA94;}
	.sscType {color:#324877;
			font-weight:bold; 
			 }
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>
	<form id="application_form" name="application_form" >

		<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
		<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
		<input type="hidden" name="pageYn" id="pageYn" value="N" />
		<input type="hidden" name="p_daoName" id="p_daoName" value=/>
		<input type="hidden" name="p_queryType" id="p_queryType" value=""/>
		<input type="hidden" name="p_process" id="p_process" value=""/>
		<input type="hidden" name="p_filename" id="p_filename" value=""/>
		<input type="hidden" name="list_type" id="list_type" />
		<input type="hidden" name="list_type_desc" id="list_type_desc" />
		<!-- <input type="hidden" name="p_Master" id="p_Master" value=""/> -->
		<input type="hidden" name="p_pjt" id="p_pjt" value=""/>
		<input type="hidden" name="p_dwg_no" id="p_dwg_no" value=""/>
		<input type="hidden" name="p_flag" id="p_flag" value=""/>
		<input type="hidden" name="p_Pr_state" id="p_Pr_state" value=""/>
		<input type="hidden" name="p_ems_pur_no" id="p_ems_pur_no" value=""/>
		<input type="hidden" name="p_filename" id="p_filename" value=""/>
		<input type="hidden" name="p_isexcel" id="p_isexcel" value=""/>
		<input type="hidden" id="p_col_name" name="p_col_name" value="" />
		<input type="hidden" id="p_data_name" name="p_data_name" value="" />
		<input type="hidden" id="page" name="page" value="" />
		<input type="hidden" id="rows" name="rows" value="" />
		
<div id="mainDiv" class="mainDiv">
<div class= "subtitle">
Admin
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
	<table class="searchArea conSearch">
		<col width="1250">
		<col width="*">
		<tr>
		<td class="sscType" style="border-right:none;"> 
			MASTER
			<input type="text" class="required" id="p_master" maxlength="10" name="p_master" style="width:50px; ime-mode:disabled; text-transform: uppercase;"  onkeyup="javascript:getDwgNos();" onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			PROJECT
			<input type="text" id="p_project" maxlength="10" name="p_project" style="width:50px; ime-mode:disabled; text-transform: uppercase;"  onkeyup="javascript:getDwgNos();" onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			DWG NO.
			<input type="text" id="p_dwg_no1" maxlength="10" name="p_dwg_no1" style="width:60px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			DWG DESCRIPTION 
			<input type="text" id="p_desc" name="p_desc" style="width:200px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			ITEM CODE
			<input type="text" id="p_item_code" maxlength="20" name="p_item_code" style="width:90px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;	
					
			DEPT.
			<select name="p_dept" id="p_dept" style="width:230px;" onchange="javascript:DeptOnChange(this);" >
			</select>
			<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.insa_dept_code}" />"  />
			<input type="hidden" name="p_dept_name" value="<c:out value="${loginUser.insa_dept_name}" />"  />		
				
			&nbsp;			
			USER
			<input type="text" class="notdisabled only_eco" id="p_user" maxlength="10" name="p_user" value="${loginUser.user_name}" style="width:75px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
		</td>
		<td style="border-left:none;">
			<div class="button endbox">
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="CONFIRM" id="btnApprove"  class="btn_blue2" />
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="RETURN" id="btnRefuse"  class="btn_blue2" />
				</c:if>
				<c:if test="${userRole.attribute1 == 'Y'}">
					<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
				</c:if>
			</div>
		</td>						
		</tr>
		
	</table>
	
	<table class="searchArea2">
		<col width="1000">
		<col width="*">
		<tr>
		<td class="sscType" style="border-right:none;"> 
			STATE
			<select name="p_status" id="p_status" style="width:100px;" >
				<option value="">ALL</option>
				<option value="A">A : 추가</option>
				<option value="R">R : 요청</option>
				<option value="S">S : 결재</option>
				<option value="D">D : 삭제</option>
				<option value="DR">DR : 삭제요청</option>									
				<option value="DS">DS : 삭제완료</option>
			</select>
			&nbsp;
			PR NO
			<input type="text" id="p_pr_no" name="p_pr_no" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
<!-- 			PO NO -->
<!-- 			<input type="text" id="p_po_no" name="p_po_no" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/> -->
<!-- 			&nbsp; -->
			BOM
			<select name="p_bom" id="p_bom" style="width:75px;" >
				<option value="">ALL</option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select>
			&nbsp;
			PR
			<select name="p_pr_state" id="p_pr_state" style="width:75px;" >
				<option value="">ALL</option>
				<option value="R">승인요청</option>
				<option value="C">승인완료</option>
			</select>
			&nbsp;
			사양
			<select name="p_spec_state" id="p_spec_state" style="width:75px;" >
				<option value="">ALL</option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select>
			&nbsp;
			PO
			<select name="p_po_state" id="p_po_state" style="width:75px;" >
				<option value="">ALL</option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select>
			&nbsp;
		</td>
								
		<td style="border-left:none;">
			<div class="button endbox">
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="SPEC" id="btnSpec"  class="btn_blue2" />
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="DP" id="btnDp"  class="btn_blue2" />
				</c:if>
			</div>
		</td>		
		</tr>
	</table>
	
	<!-- <div class="series"> 
		<table class="searchArea">
			<tr>
				<td>
					<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
				</td>
			</tr>
		</table>
	</div> -->
	
	<div class="content">
		<table id = "jqGridAdminList"></table>
		<div   id = "btnjqGridAdminList"></div>
	</div>	
</div>	
</form>

<script type="text/javascript">

//시리즈 정보
$(function() {
	$("#totalCnt").text(0);
	$("#selCnt").text(0);
	
	if($("#init_flag").val() == 'first') {
		
		if($("input[name=p_check_series]").val() == '') {
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project]").val(), null);
		} else {
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO"
					+"&p_project_no="+$("input[name=p_project_no]").val()
					+"&p_ischeck="+$("input[name=p_ischeck]").val()
					+"&p_chk_series="+$("input[name=p_check_series]").val(), null);
		} 
		
	} else {
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO"
				+"&p_project_no="+$("input[name=p_project]").val()
				+"&p_ischeck="+$("input[name=p_ischeck]").val()
				+"&p_chk_series="+$("input[name=p_check_series]").val(), null);
		
	}
});

var getDwgNos = function(){
	if($("input[name=p_project]").val() != ""){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project]").val(), null);
		getAjaxTextPost(null, "sscAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
	}
}

//도면번호 받아온 후
var getdwgnoCallback = function(txt){
	var arr_txt = txt.split("|");
    $("#p_dwg_no").autocomplete({
		source: arr_txt,
		minLength:1,
		matchContains: true, 
		max: 30,
		autoFocus: true,
		selectFirst: true,
		open: function () {
			$(this).removeClass( 'ui-corner-all' ).addClass( 'ui-corner-top' );
		},
		close: function () {
			$(this).removeClass( 'ui-corner-top' ).addClass( 'ui-corner-all' );
	    }
    });
}


$(document).ready(function(){
	
	if(typeof($("#p_dept").val()) !== 'undefined'){
		getAjaxHtml($("#p_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getDwgDeptRelInsaDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
	}	
        
	loadDatas('');
	
	var mst = $("#p_master").val();
	
	searchKeyEvent(mst);	
	
	//key evant 
	$("body").keypress(function(event) {				  
	    if (event.which == 13) {
	        event.preventDefault();
	        $('#btnSearch').click();
	    }
	});

});	

//######## 조회 버튼 클릭 시 ########//
$("#btnSearch").click(function(){				
	search();
});			

//########  승인버튼 ########//
$("#btnApprove").click(function(){

	var pos_no = document.getElementsByName("chkbox");				
	var mst = "";
	var dwgno = "";
	var master = "";
	var dwg_no = "";
	var reason = "";
	var approved_by = "";
	
	if(pos_no.length == 0|| $(".chkboxItem:checked").length == 0) {
		alert("항목을 선택하여 주십시오.");
		return;
	}
	var dwg_no = "";
	var pr_state = "";
	
	for(var i = 0; i < pos_no.length; i++) {
		if(($("#check_"+(i+1))).is(":checked")) {
			var pr_state = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).status;
			
			if(pr_state != "R" && pr_state != "DR") {
				alert("PR승인 완료 데이터는 승인할 수 없습니다.");
				return;
			}
			
			approved_by = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).approved_by;
			if(approved_by != $("#user_id").val()){
				alert("해당 항목 중 승인권한이 없는 항목이 있습니다.\n결재자를 확인해 주세요.");
				return;
			}
			
			mst = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).master;
			dwgno = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).dwg_no;						
			pr_state = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).status;

			master = mst;
			dwg_no = dwg_no + dwgno + ",";
			reason = reason + $('#'+(i+1)+'_remark').val() + " ";	
		}
	}

	dwg_no = dwg_no + ",";

	//추가 승인 프로세스
	if(confirm("PR 생성 및 삭제 승인은 몇 분의 시간이 소요될 수 있습니다.\n\n'확인' 버튼을 누른 후 잠시 기다려주십시오!")) {
		$("input[name=p_process]").val("mod_flag");
		
		$("input[name=p_Master]").val(master);
		$("input[name=p_dwg_no]").val(dwg_no);
		$("input[name=p_Reason]").val(reason);
		$("input[name=p_flag]").val("S");
		$("input[name=p_Pr_state]").val("C");
		
		var sUrl="emsAdminApprove.do";

		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post(sUrl,$("#application_form").serialize(),function(json)
		{
			alert(json.resultMsg);
			loadingBox.remove();
			search();
			$(".loadingBoxArea").hide();
		},"json");
	}			

});

//########  반려버튼 ########//
$("#btnRefuse").click(function(){
	var pos_no = document.getElementsByName("chkbox");				
	var mst = "";
	var dwgno = "";
	var master = "";
	var dwg_no = "";
	var reason = "";
	var approved_by = "";
	
	if(pos_no.length == 0|| $(".chkboxItem:checked").length == 0) {
		alert("항목을 선택하여 주십시오.");
		return;
	}
	
	for(var i = 0; i < pos_no.length; i++) {
		if(($("#check_"+(i+1))).is(":checked")) {
			var pr_state = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).status;
			
			if(pr_state != "R") {
				alert("PR승인 완료 데이터는 승인할 수 없습니다.");
				return;
			}
			
			approved_by = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).approved_by;
			if(approved_by != $("#user_id").val()){
				alert("해당 항목 중 승인권한이 없는 항목이 있습니다.\n결재자를 확인해 주세요.");
				return;
			}
			
			mst = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).master;
			dwgno = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).dwg_no;						
			pr_state = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).status;

			master = mst;
			dwg_no = dwg_no + dwgno + ",";
			reason = reason + $('#'+(i+1)+'_remark').val() + " ";	
		}
	}
	
	dwg_no = dwg_no + ",";
	
	if(confirm("PR 반려하시겠습니까?")) {
		//필수 파라미터 S
		$("input[name=p_daoName]").val("EMS_PURCHASING");
		$("input[name=p_queryType]").val("update");
		$("input[name=p_process]").val("mod_flag");
		
		$("input[name=p_Master]").val(master);
		$("input[name=p_dwg_no]").val(dwg_no);
		$("input[name=p_Reason]").val(reason);
		
		var sUrl="emsAdminRefuse.do";

		loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post(sUrl,$("#application_form").serialize(),function(json)
		{
			alert(json.resultMsg);
			search();
			loadingBox.remove();
		},"json");
	}				
});

//########  사양 버튼 ########//
$("#btnSpec").click(function(){
	var chkbox = document.getElementsByName("chkbox");
	var mst = "";
	var dwgno = "";
	var master = "";
	var dwg_no = "";
	
	if(chkbox.length == 0 || $(".chkboxItem:checked").length == 0) {
		alert("항목을 선택하여 주십시오.");
		return;
	}
	
	for(var i = 0; i < chkbox.length; i++) {
		mst = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).master;
		dwgno = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).dwg_no;
		
		if(($("#check_"+(i+1))).is(":checked")) {
			master = mst;
			dwg_no = dwg_no + dwgno + ",";
		}					
	}
	dwg_no = dwg_no + ",";
	
	/* 중복 문자열 삭제 */
	var dwgNoArray = dwg_no.replace(",,", "").split(",");
	dwg_no = "";
	dwgNoArray = unique(dwgNoArray);
	for(var i=0; i<dwgNoArray.length; i++) {
		if(i!=0) dwg_no = dwg_no + ",";
		dwg_no = dwg_no + dwgNoArray[i];
	}
	
	var url = "popUpAdminSpec.do?p_master="+master+"&p_dwg_no="+dwg_no;					

	var nwidth = 1110;
	var nheight = 440;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	window.open(url,"",sProperties).focus();
});

//########  DP 버튼 ########//
$("#btnDp").click(function(){
	var pos_no = document.getElementsByName("chkbox");
	var mst = "";
	var dwgno = "";
	var pjt = "";
	var master = "";
	var dwg_no = "";
	var project = "";
	
	if(pos_no.length == 0 || $(".chkboxItem:checked").length == 0) {
		alert("항목을 선택하여 주십시오.");
		return;
	}
	
	for(var i = 0; i < pos_no.length; i++) {
		mst = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).master;
		dwgno = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).dwg_no;
		pjt = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).project;					
		
		if(($("#check_"+(i+1))).is(":checked")) {
			
			if(master!=""){
				dwg_no = dwg_no + ",";
				project = project + ",";
			}
			master = mst;
			dwg_no = dwg_no + dwgno;
			project = project + pjt;
		}					
	}
	
	/* 중복 문자열 삭제 */
	var dwgNoArray = dwg_no.split(",");
	var projectArray = project.split(",");
	dwg_no = "";
	project = "";
	dwgNoArray = unique(dwgNoArray);
	projectArray = unique(projectArray);
	for(var i=0; i<dwgNoArray.length; i++) {
		if(i!=0) dwg_no = dwg_no + ",";
		dwg_no = dwg_no + dwgNoArray[i];
	}
	for(var i=0; i<projectArray.length; i++) {
		if(i!=0) project = project + ",";
		project = project + projectArray[i];
	}
	

	var url = "popUpPurchasingDp.do?p_master="+master+"&p_dwg_nos="+dwg_no+"&p_projects="+project;					

	var nwidth = 1530;
	var nheight = 470;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	window.open(url,"",sProperties).focus();
});


//######## 메시지 Call ########//
var aftersearch = function(json){
	var msg = "";
	
	for(var keys in json)
	{
		for(var key in json[keys])
		{
			msg=json[keys][key];
			if(key == 'd_ct') $("#keyeventCT").val(msg);
			else if(key == 'd_sc') $("#keyeventSC").val(msg);
			else if(key == 'd_kl') $("#keyeventKL").val(msg);
			else if(key == 'd_lc') $("#keyeventLC").val(msg);
			else if(key == 'd_dl') $("#keyeventDL").val(msg);
		}
	}
	$(".loadingBoxArea").hide();
}

var afterDBTran = function(json){
	$(".loadingBoxArea").hide();
 	var msg = "";

	alert(json.resultMsg);
	
	if(msg.indexOf('정상적') > -1) {					
		search();
	}
}

function search() {
	var mst = "";
	var pjt = "";
	mst = $("#p_master").val();
	pjt = $("#p_project").val();

	if(mst == '') {
		alert("MASTER를 선택하여 주십시오.");
		return;
	}				
	
	if(pjt != '' && pjt.length != 5) {					
		alert("호선 정보를 5자리로 정확히 입력하여 주십시오.");
		return;
	} else {
		$("#jqGridAdminList").jqGrid("clearGridData");								
		$("input[name=p_daoName]").val("EMS_PURCHASING");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("list");
		$("input[name=p_isexcel]").val("N");
		
// 		var sUrl = "emsAdminList.do";
// 		jQuery("#jqGridAdminList").jqGrid("GridUnload");
// 		loadDatas(sUrl);
		
		if(mst != '' || pjt != '') {				
			//필수 파라미터 S
			$("input[name=p_daoName]").val("EMS_PURCHASING");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("list_key");
			
			if(pjt != '') {
				$("input[name=p_pjt]").val(pjt);
			} else {
				$("input[name=p_pjt]").val(mst);
			}	
			
			$("#jqGridAdminList").jqGrid("clearGridData");

			var sUrl = "emsAdminList.do";
			jQuery("#jqGridAdminList").jqGrid("GridUnload");
			loadDatas(sUrl,'POST');
		}
	}
}

//######## Input text 부분 숫자만 입력 ########//
function onlyNumber(event) {
    var key = window.event ? event.keyCode : event.which;    

    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
    || key  == 8  || key  == 46 ) // del, back space
    ) {
        return true;
    }else {
        return false;
    }    
};

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
		
	var rowid = options.rowId;
	
	//var item = $('#jqGridAdminList').jqGrid('getRowData',rowid);
	//alert(rowObject.dwg_no);
	var ems_pur_no = rowObject.ems_pur_no;
	var master = rowObject.master;
	var dwg_no = rowObject.dwg_no;
	 
		//var str ="<input type=\"checkbox\" name=\"chkbox\" id=\"check_"+rowid+"\" class=\"chkboxItem\" value=\""+ems_pur_no+"\" onclick=\"checkMulti('"+rowid+"','"+master+"','"+dwg_no+"');\"/>";
		var str ="<input type=\"checkbox\" name=\"chkbox\" id=\"check_"+rowid+"\" class=\"chkboxItem\" value=\""+ems_pur_no+"\"/>";
	         
	 	return str;
	 
}

function formatOpt2(cellvalue, options, rowObject){
	
	var master = rowObject.master;
	var dwg_no = rowObject.dwg_no;
	var file_id = rowObject.file_id;
		//var str = "<img src=\"TBC/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+dwg_no+"','"+rev+"');\"/>&nbsp;&nbsp"+txt;
		//var str = "<img src=\"/ematrix/TBC/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileUpload('"+master+"','"+dwg_no+"');\"/>&nbsp;&nbsp;<a href=\"javascript:fileView("+file_id+")\">"+cellvalue+"</a>";
		var str = "<a href=\"javascript:fileView("+file_id+")\">"+cellvalue+"</a>";
		return str;		 	 
}

function formatOpt3(cellvalue, options, rowObject){
	
	var str = "";
	if(cellvalue == 'R') {
		str = "승인 요청";
	} else if(cellvalue == 'C') {
		str = "승인 완료("+rowObject.pr_no+")";
	}
		
		return str;		 	 
}

//header checkbox action 
function checkBoxHeader(e) {
		e = e||event;/* get IE event ( not passed ) */
		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
}

function fileView(file_id) {
	//alert(dwgno+"___"+rev);
	if(file_id == 0){
		alert("파일이 등록되지 않았습니다.");
		return;
	}
	url = "/ematrix/emsAdminDownload.tbc?file_id="+file_id;

	var nwidth = 800;
	var nheight = 700;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	window.open(url,"",sProperties).focus();
}

function fileUpload(mst, dwgno) {
	url = "/ematrix/emsAdminUploadPopup.tbc?master="+mst+"&dwg_no="+dwgno;				

	var nwidth = 570;
	var nheight = 100;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";

	window.open(url,"",sProperties).focus();
}

function checkMulti(row_id, master, dwg_no) {
	
	var mst = "";
	var dwgno = "";
	var no = document.getElementsByName("chkbox");
	
	for(var i = 0; i < no.length; i++) {
		mst = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).master;
		dwgno = $('#jqGridAdminList').jqGrid('getRowData',(i+1)).dwg_no;
		
		if(master == mst && dwg_no == dwgno) {
			if(($("#check_"+row_id)).is(":checked")) {
				$("#check_"+(i+1)).prop("checked", true);
			} else {
				$("#check_"+(i+1)).prop("checked", false);
			}
		}
	}				
}

function searchKeyEvent(mst) {
	if(mst != '') {				
		//필수 파라미터 S
		$("input[name=p_daoName]").val("EMS_PURCHASING");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("list_key");

		$("input[name=p_pjt]").val(mst);

		var sUrl="/ematrix/emsAdminMain.tbc";

		$.post(sUrl,$("#application_form").serialize(),function(json)
		{
			aftersearch(json);
		},"json");
	}	
}
/*
function listReload(){
	$('#jqGridAdminList').setGridParam({ page: 1, datatype: "json", postData : getFormData('#application_form')}).trigger('reloadGrid');
}*/

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />' , name:'ems_pur_no' , index:'ems_pur_no' ,width:20 ,align:'center', formatter:formatOpt1, sortable:false});
	gridColModel.push({label:'STATE' ,name:'status' , index:'status' ,width:40 ,align:'center', sortable:false});
	gridColModel.push({label:'MASTER' ,name:'master' , index:'master' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'PROJECT' ,name:'project' , index:'project' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'DWG NO.' ,name:'dwg_no' , index:'dwg_no' ,width:60 ,align:'center', sortable:false});
	gridColModel.push({label:'DWG DESCRIPTION' ,name:'dwg_desc' , index:'dwg_desc' ,width:290 ,align:'left', sortable:false});
	gridColModel.push({label:'ITEM CODE' ,name:'item_code' , index:'item_code' ,width:100 ,align:'center', sortable:false});
	gridColModel.push({label:'ITEM DESCRIPTION' ,name:'item_desc' , index:'item_desc' ,width:210 ,align:'left', sortable:false});
	gridColModel.push({label:'EA' ,name:'ea' , index:'ea' ,width:20 ,align:'center', formatter:'integer', sortable:false});
	gridColModel.push({label:'부서' ,name:'dept_name' , index:'dept_name' ,width:130 ,align:'center', sortable:false});
	gridColModel.push({label:'DP담당자' ,name:'dp_user_name' , index:'dp_user_name' ,width:55 ,align:'center', sortable:false});
	gridColModel.push({label:'DP담당자ID' ,name:'dp_user_id' , index:'dp_user_id' ,width:60 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'실제작업자ID' ,name:'create_user_id' , index:'create_user_id' ,width:60 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'결재자' ,name:'approved_name' , index:'approved_name' ,width:40 ,align:'center', sortable:false});
	gridColModel.push({label:'결재자ID' ,name:'approved_by' , index:'approved_by' ,width:40 ,align:'center', sortable:false, hidden: true});
	gridColModel.push({label:'조달담당자' ,name:'obtain_by' , index:'obtain_by' ,width:60 ,align:'center', sortable:false});
	gridColModel.push({label:'PR_NO' ,name:'pr_no' , index:'pr_no' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'사양' ,name:'spec_state' , index:'spec_state' ,width:25 ,align:'center', sortable:false});
	gridColModel.push({label:'PO' ,name:'po_state' , index:'po_state' ,width:20 ,align:'center', sortable:false});
	gridColModel.push({label:'BOM' ,name:'bom_state' , index:'bom_state' ,width:35 ,align:'center', sortable:false});
	gridColModel.push({label:'BOM_EA' ,name:'bom_ea' , index:'bom_ea' ,width:30 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'EMS_EA' ,name:'ems_ea' , index:'ems_ea' ,width:30 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'DATE' ,name:'creation_date' , index:'creation_date' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'POS' ,name:'pos' , index:'pos' ,width:30 ,align:'center', formatter:formatOpt2, sortable:false, title:false});
	gridColModel.push({label:'결재자 사번' ,name:'approved_by' , index:'approved_by' ,width:60 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'FILEID' ,name:'file_id' , index:'file_id' ,width:80 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'POS_TYPE' ,name:'pos_type' , index:'pos_type' ,width:80 ,align:'center', sortable:false, hidden:true});

	return gridColModel;
}

var gridColModel = getMainGridColModel();

function loadDatas(url,mtype) {				
	$("#jqGridAdminList").jqGrid({ 
         datatype: 'json', 
         mtype: mtype, 
         url:url,
         postData : getFormData('#application_form'),
         colModel:gridColModel,
         gridview: true,
         toolbar: [false, "bottom"],
         viewrecords: true,
         autowidth: true,
         scrollOffset : 17,
         shrinkToFit:true,
         pager: jQuery('#btnjqGridAdminList'),
         rowList:[100,500,1000],
         rowNum:100, 
		 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
         	idRow=rowid;
         	idCol=iCol;
         	kRow = iRow;
         	kCol = iCol;
			 },
		 jsonReader : {
             root: "rows",
             page: "page",
             total: "total",
             records: "records",  
             repeatitems: false,
            },        
         imgpath: 'themes/basic/images',
         onPaging: function(pgButton) {
			$(this).jqGrid("clearGridData");
 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid"); 		
		 },		
			 loadComplete: function (data) {
		    var $this = $(this);
		    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
		        $this.jqGrid('setGridParam', {
		            datatype: 'local',
		            data: data.rows,
		            pageServer: data.page,
		            recordsServer: data.records,
		            lastpageServer: data.total
		        });
		        this.refreshIndex();					
		        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
		            $this.triggerHandler('reloadGrid');
		        }
		    } else {
		        $this.jqGrid('setGridParam', {
		            page: $this.jqGrid('getGridParam', 'pageServer'),
		            records: $this.jqGrid('getGridParam', 'recordsServer'),
		            lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
		        });
		        this.updatepager(false, true);
		    }					    
		 },		           
 	}); //end of jqGrid
 	
 	
 	//jqGrid 크기 동적화
 	fn_gridresize( $(window), $( "#jqGridAdminList" ), 40 );
 	
}		
	
	
	
// 해당이름의 쿠키를 가져온다.
function getCookie(cookie_name) {
    var isCookie = false;
    var start, end;
    var i = 0;

    // cookie 문자열 전체를 검색
    while(i <= document.cookie.length) {
         start = i;
         end = start + cookie_name.length;
         // cookie_name과 동일한 문자가 있다면
         if(document.cookie.substring(start, end) == cookie_name) {
             isCookie = true;
             break;
         }
         i++;
    }

    // cookie_name 문자열을 cookie에서 찾았다면
    if(isCookie) {
        start = end + 1;
        end = document.cookie.indexOf(";", start);
        // 마지막 부분이라는 것을 의미(마지막에는 ";"가 없다)
        if(end < start)
            end = document.cookie.length;
        // cookie_name에 해당하는 value값을 추출하여 리턴한다.
        return document.cookie.substring(start, end);
    }
    // 찾지 못했다면
    return "";
}


function openMsgBox(board_id)
{
    var eventCookie=getCookie("notice_op_"+board_id);
    // 쿠키가 없을 경우에만 (다시 보지 않기를 선택하지 않았을 경우.)
    
    var nwidth = 450;
    var nheight = 550;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;
	
    if (eventCookie != "no" && board_id > 0){
        window.open('/ematrix/tbcMainNoticePopup.tbc?p_daoName=TBC_BOARD_DAO&p_queryType=select&p_process=selectDetail&p_board_id='+board_id,'_blank','width='+nwidth+',height='+nheight+',top='+TopPosition+',left='+LeftPosition);
    }
}

//공지사항이 있는지 확인.
$.post('/ematrix/tbcCommonAction.tbc?p_daoName=TBC_BOARD_DAO&p_queryType=select&p_process=selectIsNoticePopup&p_board_type=EMS', null, function(json)
{
	if(json.rows.length > 0){
		openMsgBox(json.rows[0].d_board_id);
	}
},"json");	

//배열 중복내용 삭제 함수
function unique(list) {
	var result = [];
	$.each(list, function(i, e) {
		if ($.inArray(e, result) == -1) result.push(e);
	});
	return result;
}

var DeptOnChange = function(obj){
	$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
	$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
}

</script>
</body>

</html>