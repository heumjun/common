<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Purchasing</title>
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
	
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<input type="hidden" name="temp_project_no" id="temp_project_no"  value="" />
	
	<!-- 엑셀출력용 -->
	<input type="hidden" id="p_col_name" name="p_col_name" value="" />
	<input type="hidden" id="p_data_name" name="p_data_name" value="" />
	<input type="hidden" id="p_not_display_col_name" name="p_not_display_col_name" value="" />
	<input type="hidden" id="p_not_display_data_name" name="p_not_display_data_name" value="" />
	
	<div id="mainDiv" class="mainDiv">
	<div class= "subtitle">
	Purchasing
	<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
			 
	<table class="searchArea conSearch">
		<col width="75%">
		<col width="*">
		<tr>
		<td class="sscType" style="border-right:none;"> 
			PROJECT
			<input type="text" class="required" id="p_project_no" maxlength="10" name="p_project_no" style="width:50px; ime-mode:disabled;"  onkeyup="javascript:getDwgNos();" onchange="javascript:this.value=this.value.toUpperCase();" alt="호선정보"/>
			&nbsp;
			DWG NO.
			<input type="text" class="required" id="p_dwg_no" maxlength="10" name="p_dwg_no" style="width:60px; ime-mode:disabled;"  onchange="javascript:this.value=this.value.toUpperCase();" onkeyup="chkAsterisk(this);" alt='도면번호'/>
			&nbsp;
			DWG DESC
			<input type="text" id="p_dwg_desc" name="p_dwg_desc" style="width:150px; ime-mode:disabled;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			ITEM CODE
			<input type="text" id="p_item_code" maxlength="20" name="p_item_code" style="width:90px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			<c:choose>
				<c:when test="${loginUser.gr_code=='M1'}">
					DEPT.
					<select name="p_sel_dept" id="p_sel_dept" style="width:150px;" onchange="javascript:DeptOnChange(this);" >
					</select>
					<input type="hidden" name="p_dp_dept_code" id="p_dp_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
					<input type="hidden" name="p_dp_dept_name" id="p_dp_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  />
				</c:when>
				<c:otherwise>
					DEPT.
					<input type="text" name="p_dp_dept_name"  id="p_dp_dept_name" class="disableInput" value="<c:out value="${loginUser.dwg_dept_name}" />" style="width:150px;" readonly="readonly" />
					<input type="hidden" name="p_dp_dept_code" id="p_dp_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
				</c:otherwise>
			</c:choose>
			&nbsp;
			USER
			<input type="text" class="notdisabled only_eco" id="p_user" maxlength="10" name="p_user" value="${loginUser.user_name}" style="width:75px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			&nbsp;
			승인자
			<select name="p_approved_by" id="p_approved_by" style="width:75px;" >
				<option value="ALL">ALL</option>
			</select>
		</td>
		<td style="border-left:none;">
			<div class="button endbox">
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="DP" id="btnDp"  class="btn_red2" />
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="ADD" id="btnAdd"  class="btn_blue2" />
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="DELETE" id="btnDelete"  class="btn_blue2" />
				</c:if>
				<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" value="MODIFY" id="btnModify"  class="btn_blue2" />
				</c:if>
				<c:if test="${userRole.attribute1 == 'Y'}">
					<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
				</c:if>
			</div>
		</td>						
		</tr>
	</table>
				
		<table class="searchArea2">
			<col width="70%">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 
				STATE
				<select name="p_status" id="p_status" style="width:100px;" >
					<option value="ALL">ALL</option>
					<option value="A">A : 추가</option>
					<option value="R">R : 승인요청</option>
					<option value="S">S : 승인완료</option>
					<option value="D">D : 삭제</option>
					<option value="DR">DR : 삭제요청</option>									
					<option value="DS">DS : 삭제완료</option>
				</select>
				&nbsp;
				PR NO
				<input type="text" id="p_pr_no" name="p_pr_no" style="width:75px; ime-mode:disabled;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				&nbsp;
				PO NO
				<input type="text" id="p_po_no" name="p_po_no" style="width:75px; ime-mode:disabled;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				&nbsp;
				SPEC
				<select name="p_spec_state" id="p_spec_state" style="width:75px;" >
					<option value="ALL">ALL</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				&nbsp;
				BOM
				<select name="p_bom" id="p_bom" style="width:75px;" >
					<option value="ALL">ALL</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				&nbsp;
			</td>
									
			<td style="border-left:none;">
				<div class="button endbox">
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="EXPORT" id="btnExport"  class="btn_red2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="REQUEST" id="btnPRRequire"  class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="　POS　" id="btnPos" class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="SPEC" id="btnSpec"  class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="CLOSED" id="btnClosed"  class="btn_blue2" />
					</c:if>
				</div>
			</td>		
			</tr>
		</table>
		<div class="series"> 
			<table class="searchArea">
				<tr>
					<td>
						<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="content">
			<table id = "jqGridPurchasingList"></table>
			<div   id = "btnjqGridPurchasingList"></div>
		</div>	
	</div>	
</form>
</body>
<script>

var idRow;
var idCol;
var kRow;
var kCol;
var asteric = false;
var searchDwgNo = "";
var deleteWorkKey = "";

var jqGridObj = $("#jqGridPurchasingList");

var DeptOnChange = function(obj){
	//타부서 선택시 버튼 비 활성화 및 Action불가
	if("${loginUser.dwg_dept_code}" != $(obj).find("option:selected").val())$(".button.endbox").find("input[type=button]").attr("class","btn_disable").attr("disabled",true);
	else{
		$(".button.endbox").find("input[type=button]").attr("class","btn_blue2").attr("disabled",false);
		$(".button.endbox").find("input[type=button][id=btnExport],[id=btnDp]").attr("class","btn_red2").attr("disabled",false);
	}
	$("input[name=p_dp_dept_code]").val($(obj).find("option:selected").val());
	$("input[name=p_dp_dept_name]").val($(obj).find("option:selected").text());
	$("#btnSearch").attr("class","btn_blue2").attr("disabled",false);
}



//Get User List
var getUserList = function(vDeptCode){
	getAjaxHtml($("#p_approved_by"),"emsNewApprovedBoxDataList.do?p_dept_code="+vDeptCode, null, null);
}

getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);

var getDwgNos = function(){
	if($("input[name=p_project_no]").val() != ""){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		$.ajaxSetup({async: false});
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		getAjaxTextPost(null, "emsNewAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
		$.ajaxSetup({async: true});
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

function chkAsterisk(obj){
	if(typeof($("#p_sel_dept").val()) !== 'undefined' && "${loginUser.dwg_dept_code}" != $("#p_sel_dept").find("option:selected").val()){
		return false;
	}
	if(obj.value.indexOf("*") > -1){
		$(".button.endbox").find("input[type=button]").attr("class","btn_disable").attr("disabled",true);
		$(".button.endbox").find("input[type=button][id=btnSearch]").attr("class","btn_blue2").attr("disabled",false);
		$(".button.endbox").find("input[type=button][id=btnExport],[id=btnDp]").attr("class","btn_red2").attr("disabled",false);
		if(!asteric)alert("'*'사용시 검색 기능만 허용됩니다.");
		asteric = true;
	} else {
		$(".button.endbox").find("input[type=button]").attr("class","btn_blue2").attr("disabled",false);
		$(".button.endbox").find("input[type=button][id=btnExport],[id=btnDp]").attr("class","btn_red2").attr("disabled",false);
		asteric = false;
	}
}

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />' , name:'ems_pur_no' , index:'ems_pur_no' ,width:20 ,align:'center', formatter:formatOpt1, sortable:false});
	gridColModel.push({label:'STATE' ,name:'status' , index:'status' ,width:40 ,align:'center', sortable:false});
	gridColModel.push({label:'MASTER' ,name:'master' , index:'master' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'PROJECT' ,name:'project' , index:'project' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'DWG NO.' ,name:'dwg_no' , index:'dwg_no' ,width:60 ,align:'center', sortable:false});
	gridColModel.push({label:'DWG DESCRIPTION' ,name:'dwg_desc' , index:'dwg_desc' ,width:200 ,align:'left', sortable:false});
	gridColModel.push({label:'ITEM CODE' ,name:'item_code' , index:'item_code' ,width:100 ,align:'center', sortable:false});
	gridColModel.push({label:'ITEM DESCRIPTION' ,name:'item_desc' , index:'item_desc' ,width:200 ,align:'left', sortable:false});
	gridColModel.push({label:'EA' ,name:'ea' , index:'ea' ,width:20 ,align:'center', formatter:'integer', sortable:false});
	gridColModel.push({label:'DP부서' ,name:'dp_dept_name' , index:'dp_dept_name' ,width:130 ,align:'center', sortable:false});
	gridColModel.push({label:'DP담당자' ,name:'dp_user_name' , index:'dp_user_name' ,width:55 ,align:'center', sortable:false});
	gridColModel.push({label:'DP담당자ID' ,name:'dp_user_id' , index:'dp_user_id' ,width:60 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'실제작업자ID' ,name:'create_user_id' , index:'create_user_id' ,width:60 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'결재자' ,name:'approved_by' , index:'approved_by' ,width:40 ,align:'center', sortable:false});
	gridColModel.push({label:'POS' ,name:'pos' , index:'pos' ,width:30 ,align:'center', formatter:formatOpt2, sortable:false, title:false});
	gridColModel.push({label:'POS_TYPE' ,name:'pos_type' , index:'pos_type' ,width:80 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'PR_NO' ,name:'pr_no' , index:'pr_no' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'SPEC' ,name:'spec_state' , index:'spec_state' ,width:30 ,align:'center', sortable:false});
	gridColModel.push({label:'조달담당자' ,name:'obtain_by' , index:'obtain_by' ,width:60 ,align:'center', sortable:false});
	gridColModel.push({label:'PO_NO' ,name:'po_state' , index:'po_state' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'BOM' ,name:'bom_state' , index:'bom_state' ,width:35 ,align:'center', sortable:false});
	gridColModel.push({label:'BOM_EA' ,name:'bom_ea' , index:'bom_ea' ,width:30 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'EMS_EA' ,name:'ems_ea' , index:'ems_ea' ,width:30 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'DATE' ,name:'creation_date' , index:'creation_date' ,width:50 ,align:'center', sortable:false});
	gridColModel.push({label:'FILEID' ,name:'file_id' , index:'file_id' ,width:80 ,align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'POS_REV' ,name:'pos_rev' , index:'pos_rev' ,width:80 ,align:'center', sortable:false, hidden:true});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
		
	var rowid = options.rowId;
	
	//var item = $('#jqGridPurchasingList').jqGrid('getRowData',rowid);
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

//필수 항목 Validation
var uniqeValidation = function(){
	var rnt = true;
	$(".required").each(function(){
		if($(this).val() == ""){
			$(this).focus();
			alert($(this).attr("alt")+ "가 누락되었습니다.");
			rnt = false;
			return false;
		}
	});
	return rnt;
}

//header checkbox action 
function checkBoxHeader(e) {
	e = e || event;/* get IE event ( not passed ) */
	e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if (($("#chkHeader").is(":checked"))) {
		$(".chkboxItem").prop("checked", true);
	} else {
		$("input.chkboxItem").prop("checked", false);
	}
}

function dwgNoChk(){
	if(searchDwgNo.indexOf("*") > -1){
		alert("'*'로 검색했던 결과입니다.\n다시 조회하신 후 작업을 진행해주세요");
		return false;
	}
	
	var pos_no = document.getElementsByName("chkbox");
	var stt = "";
	var dwg_no = "";
	var dwg_no_eq = "Y"; //도면번호 여러개인지 확인
	
	for(var i = 0; i < pos_no.length; i++) {
		var idx = i+1;
		
		if(($("#check_"+(i+1))).is(":checked")) {
			stt = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).status;
			dwg_no = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).dwg_no;
			
			//상태 'S' 삭제 시 한 종류의 도면만 수정 가능하도록
			if(dwg_no != "" && dwg_no != $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).dwg_no){
				dwg_no_eq = "N";
			}
		}
	}
	if(dwg_no_eq == "N"){
		alert("결재상태('"+stt+"')는 한 종류의 도면번호만 가능합니다.");
		return false;
	} else {
		return true;
	}
}

//배열 중복내용 삭제 함수
function distinctAry(list) {
	var result = [];
	$.each(list, function(i, e) {
		if ($.inArray(e, result) == -1) result.push(e);
	});
	return result;
}


function fileView(file_id) {
	//alert(dwgno+"___"+rev);
	if(file_id == 0){
		alert("파일이 등록되지 않았습니다.");
		return;
	}
	url = "popUpPurchasingNewPosDownloadFile.do?p_file_id="+file_id;

	var nwidth = 800;
	var nheight = 700;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	window.open(url,"",sProperties).focus();
}


$(document).ready(function(){	
	//상위 mainTab 항목이 없을 경우 closed버튼을 숨김처리 단 영역은 유지처리
	if(parent.frames['mainTab'] != null){
		$("#btnClosed").css("visibility","hidden");
	}
	//기술 기획일 경우 부서 선택 기능
	if(typeof($("#p_sel_dept").val()) !== 'undefined'){
		getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dp_dept_code]").val(), null, null);	
	}
	getUserList("${loginUser.dwg_dept_code}");
	
	//######## 조회 버튼 클릭 시 ########//
	$("#btnSearch").click(function(){
		
		searchDwgNo =  $("#p_dwg_no").val();
		
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		if(ar_series.length == 0){
			ar_series[0] = $("input[name=p_project_no]").val();
			$("input[name=p_series]").eq(0).prop("checked",true);
		}
		else if(ar_series.length > 0){
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
		}
		
		if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
			ar_series[0] = $("input[name=p_project_no]").val();
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		}
		$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
		
		//Uniqe Validation
		if(uniqeValidation()){
			var sUrl = "emsNewPurchasingList.do?p_chk_series="+ar_series;
			$("#jqGridPurchasingList").jqGrid( "clearGridData" );
			$("#jqGridPurchasingList").jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
			
			//검색 시 스크롤 깨짐현상 해결
			$("#jqGridPurchasingList").closest(".ui-jqgrid-bdiv").scrollLeft(0);
		}
	});	
	/* var sUrl = "; */
	//########  추가버튼 ########//
	$("#btnAdd").click(function(){
		var project = $("#p_project_no").val();
		var dwg_no = $("#p_dwg_no").val();
		var master = "";
		
		if(project.length == 0){ alert("호선을 입력해주십시오."); return;}
		if(dwg_no.length == 0){ alert("도면번호를 입력해주십시오."); return;}
		
		$.ajax({
	    	url:'<c:url value="emsNewPosChk.do"/>',
	    	type:'POST',
	    	async: false,
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"p_project_no" : project,
	    			"p_dwg_no" : dwg_no,
	    			"p_dept_code" : $("#p_dp_dept_code").val()
	    			},
	    	success : function(data){
	    		if(data == "null"){
	    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
	    			return;
	    		}
	    		var jsonData = JSON.parse(data);
	    		master = jsonData.project_no;
	    			    			    		
	    		var url = "popUpPurchasingNewAdd.do?p_master="+master+"&p_dwg_no="+dwg_no

	    		var nwidth = 1050;
	    		var nheight = 800;
	    		var LeftPosition = (screen.availWidth-nwidth)/2;
	    		var TopPosition = (screen.availHeight-nheight)/2;

	    		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	    		window.open(url,"",sProperties).focus();				
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
						
	});
	
	//########  추가버튼 ########//
	$("#btnModify").click(function(){
		if(!dwgNoChk()) return;
		
		var pos_no = document.getElementsByName("chkbox");
		var stt = "";
		var emspurno = 0;
		var ems_pur_no = "";
		var dwg_no = $("#p_dwg_no").val();
		var master = "";
		
		if(pos_no.length == 0 || $(".chkboxItem:checked").length == 0) {
			alert("항목을 선택하여 주십시오.");
			return;
		}
		
		for(var i = 0; i < pos_no.length; i++) {
			var idx = i+1;
			
			emspurno = $("#check_"+(idx)).val();
			
			if(($("#check_"+(i+1))).is(":checked")) {
				stt = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).status;
				ea = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).ea;
				if(stt != 'A' && stt != 'S') {
					alert("선택한 DATA는 DELETE/MODIFY 불가합니다.");
					return;
				}
				ems_pur_no = ems_pur_no + emspurno + ",";
			}
		}
		
		ems_pur_no = ems_pur_no + ',';
		
		$.ajax({
	    	url:'<c:url value="emsNewPosChk.do"/>',
	    	type:'POST',
	    	async: false,
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"p_project_no" : $("#p_project_no").val(),
	    			"p_dwg_no" : dwg_no,
	    			"p_dept_code" : $("#p_dp_dept_code").val()
	    			},
	    	success : function(data){
	    		if(data == "null"){
	    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
	    			return;
	    		}
	    		var jsonData = JSON.parse(data);
	    		master = jsonData.project_no;
	    			    			    		
	    		if(stt == 'S' || stt == 'A') {
	    			var url = "popUpPurchasingNewModify.do?&p_master="+master+"&p_dwg_no="+dwg_no+"&p_work_flag=M&p_ems_pur_no="+ems_pur_no;

	    			var nwidth = 1050;
	    			var nheight = 800;
	    			var LeftPosition = (screen.availWidth-nwidth)/2;
	    			var TopPosition = (screen.availHeight-nheight)/2;

	    			var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
	    			window.open(url,"",sProperties).focus();
	    		} 			
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	});
	
	//########  삭제 버튼 ########//
	$("#btnDelete").click(function(){
		if(!dwgNoChk()) return;
		
		var pos_no = document.getElementsByName("chkbox");
		var stt = "";
		var emspurno = 0;
		var ems_pur_no = "";
		var dwg_no = $("#p_dwg_no").val();
		deleteWorkKey = "";
		
		if(pos_no.length == 0 || $(".chkboxItem:checked").length == 0) {
			alert("항목을 선택하여 주십시오.");
			return;
		}
		
		for(var i = 0; i < pos_no.length; i++) {
			var idx = i+1;
			
			emspurno = $("#check_"+(idx)).val();
			
			if(($("#check_"+(i+1))).is(":checked")) {
				stt = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).status;
				ea = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).ea;
				if(stt != 'A' && stt != 'S') {
					alert("선택한 DATA는 DELETE/MODIFY 불가합니다.");
					return;
				}
				ems_pur_no = ems_pur_no + emspurno + ",";
			}									
		}
		ems_pur_no = ems_pur_no + ',';
		

		if(stt == 'S') {
			$.ajax({
		    	url:'<c:url value="emsNewDeleteChk.do"/>',
		    	type:'POST',
		    	async: false,
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data :  {
		    				"p_ems_pur_no" 	: ems_pur_no,
		    				"p_work_flag" 	: "D"
		    			},
		    	success : function(data){
		    			if(data == "null"){
			    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
			    			return;
			    		}
			    		var jsonData = JSON.parse(data);
			    		
			    		if(jsonData.p_result_flag != "S"){
			    			alert(jsonData.p_result_msg);
			    			return;
			    		}
			    		deleteWorkKey = jsonData.p_work_key;
			    		
			    		var url = "popUpPurchasingNewDelete.do?p_ems_pur_no=" + ems_pur_no +"&p_work_flag=D&p_work_key="+deleteWorkKey
			    				+"&p_dwg_no="+$("#p_dwg_no").val()+"&p_master="+$("#p_project_no").val();
						var nwidth = 1280;
						var nheight = 700;
						var LeftPosition = (screen.availWidth-nwidth)/2;
						var TopPosition = (screen.availHeight-nheight)/2;
						var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
						window.open(url,"",sProperties).focus();
		    	}, 
		    	error : function(e){
		    		alert(e);
		    	}
		    });
		} else if(stt == 'A') {
			if(confirm("삭제하시겠습니까?")) {
				var sUrl="emsPurchasingNewDeleteA.do?&p_ems_pur_no="+ems_pur_no;

				//필수 파라미터 E	
				$(".loadingBoxArea").show();
				$.post(sUrl,$("#application_form").serialize(),function(json)
				{
					alert(json.resultMsg);
					if ( json.result == 'success' ) {
						$("#btnSearch").click();
					}
					$(".loadingBoxArea").hide();
				},"json");
			}
		}
	});
	
	//######## Export 버튼 클릭 시 ########//
	$("#btnExport").click(function(){				
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		for(var i=0; i<gridColModel.length; i++ ){
			if(gridColModel[i].hidden || i==0){
				continue;
			}
			colName.push(gridColModel[i].label);
			dataName.push(gridColModel[i].name);
		}
		
		form = $('#application_form');

		$("input[name=p_is_excel]").val("Y");
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		if(ar_series.length == 0){
			ar_series[0] = $("input[name=p_project_no]").val();
			$("input[name=p_series]").eq(0).prop("checked",true);
		}
		//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.
		$("#p_col_name").val(colName);
		$("#p_data_name").val(dataName); 
		/* $("#rows").val($("#jqGridPurchasingList").getGridParam("rowNum"));
		$("#page").val($("#jqGridPurchasingList").getGridParam("page"));*/
		
		fn_downloadStart();
		form.attr("action", "emsPurchasingNewExcelExport.do?p_chk_series="+ar_series
					+"&curPageNo="+$("#jqGridPurchasingList").getGridParam("page")
					+"&pageSize="+$("#jqGridPurchasingList").getGridParam("rowNum")
					+"&type=Main");
		
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	});	
	
	//########  승인요청 버튼 ########//
	$("#btnPRRequire").click(function(){
		if(!dwgNoChk()) return;
		
		var pos_no = document.getElementsByName("chkbox");				
		var mst = "";
		var dwgno = "";
		var master = "";
		var p_project = "";
		var dwg_no = "";
		var status = "";
		var pos_type = "";
		var file_id = "";
		var p_approved_by = $("#p_approved_by").val();

		if(pos_no.length == 0|| $(".chkboxItem:checked").length == 0) {
			alert("항목을 선택하여 주십시오.");
			return;
		}
		if(p_approved_by == "ALL"){
			alert("결제자 선택 바랍니다.");
			return;
		}
		var chkStatus = "";
		var ems_pur_no = "";
		var chkLen = 0;
		
		//체크 된 row를 찾음.
		for(var i = 0; i < pos_no.length; i++) {
			var reg_id = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).created_by;
			var pr_state = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).pr_state;
			var pos = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).pos;
			var project = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).project;
			status = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).status;
			mst = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).master;
			dwgno = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).dwg_no;
			pos_type = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).pos_type;
			file_id = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).file_id;
			
			
			var idx = i+1;
			
			var emspurno = $("#check_"+(idx)).val();
				
			if(($("#check_"+(i+1))).is(":checked")) {						
				
				if(pos == "N"){
					alert("POS 등록 이후 진행가능합니다.");
					return false;
				}
				
				if(pos_type == "A" && file_id == "0" ){
					alert("본물량인 경우 POS 파일 Upload 이후 진행 가능합니다.");
					return false;
				}
				
				if(status == "R" || status == "S" || status == "DR"  || status == "DS") {
					alert("PR승인 요청 또는 완료 항목은 선택할 수 없습니다.");
					return false;
				}
				
				ems_pur_no = ems_pur_no + emspurno + ",";
			}
		}
		

		if(confirm("PR 요청하시겠습니까?")) {
			var sUrl="/purchasingNewRequestApply.do?ems_pur_no="+ems_pur_no+"&p_request_flag=R"
												+"&p_request_emp_no="+$("#user_id").val()+"&p_receipt_emp_no="+$("#p_approved_by").val()
												+"&p_user_id="+$("#user_id").val();
			var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
			$.post(sUrl,$("#application_form").serialize(),function(json)
			{
				alert(json.resultMsg);
				loadingBox.remove();
				$("#btnSearch").click();
			},"json");
		}
		/* ems_pur_no = ems_pur_no + ',';				 */
		
		/* var url = "popUpPurchasingRequest.do?p_master="+master+"&p_dwg_no="+dwg_no+"&p_project=" + p_project;
							
		var nwidth = 1230;
		var nheight = 700;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";
		window.open(url,"",sProperties).focus(); */
	});
	
	//########  POS버튼 ########//
	$("#btnPos").click(function(){
		var project = $("#p_project_no").val();
		var dwg_no = $("#p_dwg_no").val();
		var master = "";
		
		if(project.length == 0){ alert("호선을 입력해주십시오."); return;}
		if(dwg_no.length == 0){ alert("도면번호를 입력해주십시오."); return;}
		
		$.ajax({
	    	url:'<c:url value="emsNewPosChk.do"/>',
	    	type:'POST',
	    	async: false,
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"p_project_no" : project,
	    			"p_dwg_no" : dwg_no,
	    			"p_dept_code" : $("#p_dp_dept_code").val()
	    			},
	    	success : function(data){
	    		if(data == "null"){
	    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
	    			return;
	    		}
	    		var jsonData = JSON.parse(data);
	    		master = jsonData.project_no;
	    		
	    		var pos_no = document.getElementsByName("chkbox");
	    		var ems_pur_no = "";
	    		var rev_cp = "";
	    		for(var i = 0; i < pos_no.length; i++) {
	    			var idx = i+1;
	    			var emspurno = $("#check_"+(idx)).val();
	    			var stt ="";
	    			var rev ="";
	    			if(($("#check_"+(i+1))).is(":checked")) {
	    				stt = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).status;
	    				rev = $('#jqGridPurchasingList').jqGrid('getRowData',(idx)).pos_rev;
	    				if(stt == 'R' || stt == 'DR' || stt == 'DS') {
	    					alert("선택한 DATA는 POS작업이 불가합니다.");
	    					return;
	    				}
	    				if(rev_cp == "") rev_cp = rev;
	    				else {
	    					if(rev_cp != rev){
	    						alert("선택한 DATA는 상이한 POS가 포함되어 POS 작업이 불가합니다.");
	    						return;
	    					}
	    				}
	    				ems_pur_no = ems_pur_no + emspurno + ",";
	    			}
	    		}
	    			    		
	    		var url = "popUpPurchasingNewPos.do?p_master="+master+"&p_dwg_no="+dwg_no
	    					+"&p_pos_rev="+rev_cp+"&p_ems_pur_no="+ems_pur_no;
	    		
	    		var nwidth = 1050;
	    		var nheight = 800;
	    		var LeftPosition = (screen.availWidth-nwidth)/2;
	    		var TopPosition = (screen.availHeight-nheight)/2;

	    		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	    		window.open(url,"",sProperties).focus();				
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	});
	
	//창 닫기 버튼
	$("#btnClosed").click(function(){
		window.close();
	});

	//########  사양 버튼 ########//
	$("#btnSpec").click(function(){
		if(!dwgNoChk()) return;
		
		var project = $("#p_project_no").val();
		var dwg_no = $("#p_dwg_no").val();
		var master = "";
		
		if(project.length == 0){ alert("호선을 입력해주십시오."); return;}
		if(dwg_no.length == 0){ alert("도면번호를 입력해주십시오."); return;}
		$.ajax({
	    	url:'<c:url value="emsNewPosChk.do"/>',
	    	type:'POST',
	    	async: false,
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"p_project_no" : project,
	    			"p_dwg_no" : dwg_no,
	    			"p_dept_code" : $("#p_dp_dept_code").val()
	    			},
	    	success : function(data){
	    		if(data == "null"){
	    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
	    			return;
	    		}
	    		var jsonData = JSON.parse(data);
	    		master = jsonData.project_no;
	    			    		
	    		var url = "popUpPurchasingNewSpec.do?p_master="+master+"&p_dwg_no="+dwg_no;					

	    		var nwidth = 1050;
	    		var nheight = 800;
	    		var LeftPosition = (screen.availWidth-nwidth)/2;
	    		var TopPosition = (screen.availHeight-nheight)/2;

	    		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	    		window.open(url,"",sProperties).focus();			
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
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
			mst = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).master;
			dwgno = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).dwg_no;
			pjt = $('#jqGridPurchasingList').jqGrid('getRowData',(i+1)).project;					
			
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
		dwgNoArray = distinctAry(dwgNoArray);
		projectArray = distinctAry(projectArray);
		for(var i=0; i<dwgNoArray.length; i++) {
			if(i!=0) dwg_no = dwg_no + ",";
			dwg_no = dwg_no + dwgNoArray[i];
		}
		for(var i=0; i<projectArray.length; i++) {
			if(i!=0) project = project + ",";
			project = project + projectArray[i];
		}
		

		var url = "popUpPurchasingNewDp.do?p_master="+master+"&p_dwg_nos="+dwg_no+"&p_projects="+project;					

		var cw=screen.availWidth;     //화면 넓이
		var ch=screen.availHeight;    //화면 높이
		
		var nwidth = 1530;
		var nheight = 470;

		var LeftPosition = (cw-nwidth)/2;
		var TopPosition = (ch-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

		window.open(url,"",sProperties).focus();
	});
	
	$("#jqGridPurchasingList").jqGrid({ 
        datatype: 'json', 
        mtype: 'POST', 
        url:'',
        postData : fn_getFormData('#application_form'),
        colModel:gridColModel,
        gridview: true,
        toolbar: [false, "bottom"],
        viewrecords: true,
        autowidth: true,
        scrollOffset : 17,
        shrinkToFit:true,
        pager: jQuery('#btnjqGridPurchasingList'),
        rowList:[100,500,1000],
        recordtext: '내용 {0} - {1}, 전체 {2}',
        emptyrecords:'조회 내역 없음',
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
	    	
        		var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt($("#jqGridPurchasingList").getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt($("#jqGridPurchasingList").getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnjqGridPurchasingList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridPurchasingList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridPurchasingList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridPurchasingList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
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
	fn_gridresize( $(window), $( "#jqGridPurchasingList" ), 36 );
	
});



</script>
</html>