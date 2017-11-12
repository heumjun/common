<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>BOM NEEDS</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.sscType {	color:#324877;
				font-weight:bold; 
			 }
	input[type=text] {text-transform: uppercase;}
</style>

</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
	<input type="hidden" id="p_col_name" name="p_col_name"/>
	<input type="hidden" id="p_data_name" name="p_data_name"/>
	<input type="hidden" id="temp_project_no" name="temp_project_no" value="" />
		<div class="subtitle">
			BOM NEEDS
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
		<table class="searchArea conSearch">
		<col width="1100"/>
		<col width="*"/>
			<tr>
				<td class="sscType" style="border-right:none;"> 
				PROJECT
				<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:50px;" value="" onkeypress="javascript:checkItemCode();" onkeyup="javascript:getDwgNos();" /> &nbsp;
				DWG NO.
					<input type="text" id="p_dwg_no" id="p_dwg_no" name="p_dwg_no" class="required" style="width:60px;" value="${p_dwg_no}" alt="DWG NO." onkeypress="javascript:checkItemCode();" /> &nbsp;
				BLOCK
					<input type="text" class="commonInput" name="p_block_no" value="" style="width:40px;" /> &nbsp;
				STAGE
					<input type="text" class="commonInput" name="p_stage_no" style="width:50px;" value="" /> &nbsp;
				STR
					<input type="text" name="p_str_flag" id="p_str_flag" class="commonInput" style="width:26px;" /> &nbsp;
				JOB
					<input type="text" name="p_job_cd" id="p_job_cd" class="commonInput" style="width:100px;" /> &nbsp;
				MOTHER
					<input type="text" name="p_mother_code" id="p_mother_code" class="commonInput" style="width:100px;" /> &nbsp;
				ITEM
					<input type="text" name="p_item_code" id="p_item_code" class="commonInput" alt="item_code" style="width:100px;" /> &nbsp;
				DESCRIPTION
					<input type="text" name="p_item_desc" id="p_item_desc" class="commonInput" style="width:100px;" /> &nbsp;
				
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
<!-- 						<input type="button" class="btn_blue2" value="EXPORT" id="btnExport"/> -->
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
					</div>
				</td>
			</tr>
		</table>
		
		<table class="searchArea2">
		<col width="1300"/>
		<col width="*"/>
			<tr>				
				<td class="sscType">
			TYPE
				<select name="p_item_type_cd" id="p_item_type_cd" style="width:130px;" >
				</select> &nbsp;
			ECO NO.
				<input type="text" name="p_eco_no" id="p_eco_no" class="commonInput" style="width:80px;" /> &nbsp;
			ECO
				<select name="p_is_eco" id="p_is_eco" style="width:80px;" >
					<option value="ALL" selected="selected" >ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
					<option value="R" >Release</option>
				</select> &nbsp;
			<!-- W/P
				<input type="text" name="p_work_package_code" id="p_work_package_code" class="commonInput" style="width:100px;" /> &nbsp; -->
			STATE
				<select name="p_state_flag" id="p_state_flag" style="width:60px;" >
					<option value="ALL" selected="selected">ALL</option>
					<option value="A" >A</option>
					<option value="D" >D</option>
					<option value="C" >C</option>
					<option value="ACT" >완료</option>
				</select> &nbsp;
			ERP
				<select name="p_erp_check_type" id="p_erp_check_type" style="width:60px;" >
					<option value="ALL" selected="selected" >ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select> &nbsp;
			
			<c:choose>
				<c:when test="${loginUser.gr_code=='M1'}">
					DEPT.
					<select name="p_sel_dept" id="p_sel_dept" style="width:130px;" onchange="javascript:DeptOnChange(this);" >
					</select>
					<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
					<input type="hidden" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  /> &nbsp;
				</c:when>
				<c:otherwise>
					DEPT.
					<input type="text" name="p_dept_name" class="disableInput" value="<c:out value="${loginUser.dwg_dept_name}" />" style="width:110px;" readonly="readonly" />
					<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  /> &nbsp;
				</c:otherwise>
			</c:choose>
			USER
					<select name="p_sel_user" id="p_sel_user" style="width:65px;" onchange="javascript:UserOnChange(this);">
					</select>
					<input type="hidden" id="p_user_id" name="p_user_id" class="commonInput"  value="<c:out value="${loginUser.user_id}" />" />
					<input type="hidden" id="p_user_name" name="p_user_name" class="commonInput"  value="<c:out value="${loginUser.user_name}" />" /> &nbsp;
					
			
			<!-- ACTIVITY-->
				<input type="hidden" name="p_activity_no" id="p_activity_no" value="" style="width:120px;" /> &nbsp; 
			JOB NO.
				<input type="text" name="p_job_no" id="p_job_no" class="commonInput" style="width:150px;" />			
			</td>
			
			<td class="bdl_no"  style="border-left:none;">
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
		
		<div id="upperDiv" class="content" style="position:relative; float: left; width: 100%;">			
			<table id="jqGridMainList"></table>
			<div id="jqGridMainListNavi"></div>			
		</div>
		<div id="underDiv" style="position:relative; float: left; width: 100%;">
			<fieldset style="border:none">
			<legend style="width:100%; background-color:#CCC0DA; color:#333333; border:1px solid #999999; height:20px; text-align:center; font-size: 12px; font-weight: bold; padding-top: 5px;">생산 정보</legend>
				<table class="detailArea1" id="jqGridSub2List">
					<tr>
						<th>ACTIVITY</th><th>ACT-시작일</th><th>ACT-종료일</th><th>구분</th><th>JOB NO</th><th>JOB-팀</th>
						<th>JOB-부서</th><th>JOB-반/업체</th><th>JOB-계획시작일</th><th>JOB-계획완료일</th><th>JOB-상태</th>	<th>JOB-RELEASE</th>
					</tr>
					<tr>
						<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
						<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
					</tr>
					<tr>
						<th>JOB-요구수량</th><th>JOB-출고수량</th><th>출고요청-수량</th><th>출고요청-요청일</th><th>출고요청-요구일</th><th>출고지시-NO</th>
						<th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th>
					</tr>
					<tr>
						<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
						<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
					</tr>
				</table>
			</fieldset>
		</div>
		<div id="underDiv" style="position:relative; float: left; width: 100%;">
			
			<fieldset style="border:none; position:relative; float:left; width: 30%;">
				<legend style="width:100%; background-color:#0C66BC; color:#FFFFFF; border:1px solid #999999; height:20px; text-align:center; font-size: 12px; font-weight: bold; padding-top: 5px;">BOM정보</legend>
				<div id="jqGridSubDiv" style="position: relative; float:left; width: 100%;">
					<table id="jqGridSubList"></table>
				</div>
			</fieldset>
			
			<fieldset style="border:none; position:relative; float:right; width: 70%;">
				<legend style="width:100%; background-color:#E6B8B7; color:#333333; border:1px solid #999999; height:20px; text-align:center; font-size: 12px; font-weight: bold; padding-top: 5px;">조달 물류 정보</legend>
				<div id="jqGridSub1div" style="position: relative; float:left; width: 100%;">
					<table class="detailArea1" id="jqGridSub1List">
						<tr>
							<th>PR-NO</th><th>PR-수량</th><th>PO-NO</th><th>PO-수량</th><th>PO-생성일</th><th>PO-구매발주부서</th><th>PO-구매발주자</th><th>PO-공급사</th><th>제작착수계획일</th>						
						</tr>
						<tr>
							<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
						</tr>
						<tr>
							<th>제작착수일</th><th>도장착수일</th><th>입고가능일</th><th>도장사이동일</th><th>PO-입고수량</th><th>입고일</th><th>입고처리일</th><th>입고처리자</th><th>&nbsp;</th>
							<!-- <th>출고지시-NO</th><th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th> -->
						</tr>
						<tr>
							<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
						</tr>
					</table>
				</div>
			</fieldset>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var resultData = [];
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var menuId = '';
	
	var jqGridObj = $("#jqGridMainList");
	var jqGridObj1 = $("#jqGridSubList");
	
	//호선 시리즈 받기
	getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
	
	var getDwgNos = function(){
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			
			form = $('#application_form');
	
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
				$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function () {
			    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
		    }
		});
	}
	
	$(document).ready(function(){	
		
		
		//기술 기획일 경우 부서 선택 기능
		if(typeof($("#p_sel_dept").val()) !== 'undefined'){
			getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
		}
		
		//User 선택할 수 있도록 수정.
		//Select Box User 받아옴.
		getUserList($("input[name=p_dept_code]").val());
		
		//콤보박스 셋팅				
		getAjaxHtml($("#p_item_type_cd"),"commonSelectBoxDataList.do?p_query=getCommonSscType&sb_type=all&p_temp_item_type_cd="+$("#p_temp_item_type_cd").val(), null);
		
		//엔터 버튼 클릭
		$("*").keypress(function(event) {
		  if (event.which == 13) {
		        event.preventDefault();
		        $('#btnSelect').click();
		    }
		});		
		
		jqGridObj.jqGrid({ 
            datatype : 'json',
            url : '',
            mtype : '',
            postData : fn_getFormData('#application_form'),
            colNames : ['SSC_SUB_ID','TYPE','STATE','PROJECT','DWG NO.','BLOCK','STAGE','STR','TYPE','JOB ITEM','PENDING','ITEM CODE','DESCRIPTION','EA','WEIGHT','PAINT','SUPPLY','DEPART','USER','ECO NO.','RELEASE','DWG','dwg_file_name','KEY','ERP','PR NO.','PO NO.','COST','BUY-BUY FLAG','RAW_LEVEL_FLAG','ORGIN_JOB_ITEM_CODE','','','','','','','','','','','','','','','','','','','','','','','',''],
			colModel : [
					{name:'ssc_sub_id', index : 'ssc_sub_id'	,width:40, align:'center', sortable:true, title:false, hidden:true},
					{name:'item_type_cd', index : 'item_type_cd' , width:30 ,align:'center', sortable:true, title:false},
					{name:'state_flag', index : 'state_flag' , width:40 ,align:'center', sortable:true, title:false},
					{name:'project_no', index : 'project_no' , width:90 ,align:'center', sortable:true, title:false},
					{name:'dwg_no', index : 'dwg_no' , width:90 ,align:'center', sortable:true, title:false},
					{name:'block_no', index : 'block_no' , width:60 ,align:'center', sortable:true, title:false},
					{name:'stage_no', index : 'stage_no' , width:60 ,align:'center', sortable:true, title:false},
					{name:'str_flag', index : 'str_flag' , width:60 ,align:'center', sortable:true, title:false},
					{name:'usc_job_type', index : 'usc_job_type' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
					{name:'job_cd', index : 'job_cd' , width:100 ,align:'center', sortable:true, title:false},
					{name:'mother_code', index : 'mother_code' , width:100 ,align:'center', sortable:true, title:false, formatter: motherCodeFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';}},
					{name:'item_code', index : 'item_code' , width:100 ,align:'center', sortable:true, title:false, formatter: itemCodeFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';} },
					{name:'item_desc', index : 'item_desc' , width:200 ,align:'left', sortable:true, title:false},
					{name:'ea', index : 'ea' , width:40 ,align:'center', sortable:true, title:false},
					{name:'item_weight', index : 'item_weight' , width:60 ,align:'center', sortable:true, title:false},
					{name:'paint_code1', index : 'paint_code1' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
					{name:'supply', index : 'supply' , width:60 ,align:'center', sortable:false, title:false, editable:true, edittype : "select", editoptions:{value:"Y:Y;N:N"}},
	               	{name:'dept_name', index : 'dept_name' , width:100 ,align:'center', sortable:true, title:false},
	               	{name:'user_name', index : 'user_name' , width:70 ,align:'center', sortable:true, title:false},
	               	{name:'eco_no', index : 'eco_no' , width:90 ,align:'center', sortable:true, title:false, formatter: ecoFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';} },
	               	{name:'release_desc', index : 'release_desc' , width:100 ,align:'center', sortable:false, title:false},
	               	{name:'dwg_check', index : 'dwg_check', width:30, align:'center', sortable:true, title:false},
	               	{name:'dwg_file_name', index : 'dwg_file_name', title:false, hidden:true},
	               	{name:'key_no', index : 'key_no' , width:50 ,align:'center', sortable:true, title:false},
	               	{name:'exist_erp', index : 'exist_erp' , width:50 ,align:'center', sortable:true, title:false},
	               	{name:'pr_no', index : 'pr_no' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
	               	{name:'po_no', index : 'po_no' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
	               	{name:'cost', index : 'cost' , width:50 ,align:'center', sortable:true, title:false, hidden:true},
	               	{name:'buy_buy_flag', index : 'buy_buy_flag', width:50, align:'center', sortable:true, title:false,  hidden:true},
	               	{name:'raw_level_flag', index : 'raw_level_flag', width:50, align:'center', sortable:true, title:false, hidden:true},
	               	{name:'orgin_job_item_code', index : 'orgin_job_item_code', width:50, align:'center', sortable:true, title:false, hidden:true},
					/* {name : 'project_no'				, index : 'project_no'					, width : 80, editable : false, align : "center"},
					{name : 'dwg_no'					, index : 'dwg_no'						, width : 80, editable : false, align : "center"},
					{name : 'block_no'					, index : 'block_no'					, width : 60, editable : false, align : "center"},	
					{name : 'stage_no'					, index : 'stage_no'					, width : 60, editable : false, align : "center"},
					{name : 'str_flag'					, index : 'str_flag'					, width : 60, editable : false, align : "center"},
					{name : 'usc_job_type'				, index : 'usc_job_type'				, width : 60, editable : false, align : "center"},
					{name : 'job_cd'					, index : 'job_cd'						, width : 100, editable : false, align : "center"},
					{name : 'mother_code'				, index : 'mother_code'					, width : 100, editable : false, align : "center"},
					{name : 'item_code'					, index : 'item_code'					, width : 100, editable : false, align : "center"},
					{name : 'item_desc'					, index : 'item_desc'					, width : 250, editable : false, align : "left"},
					{name : 'ea'						, index : 'ea'							, width : 60, editable : false, align : "center"},
					{name : 'item_weight'				, index : 'item_weight'					, width : 60, editable : false, align : "center"},
					{name : 'eco_no'					, index : 'eco_no'						, width : 80, editable : false, align : "center"},
					{name : 'cause'						, index : 'cause'						, width : 60, editable : false, align : "center"},
					{name : 'eco_dept'					, index : 'eco_dept'					, width : 150, editable : false, align : "center"},
					{name : 'eco_user'					, index : 'eco_user'					, width : 100, editable : false, align : "center"},
					{name : 'ecr_no'					, index : 'ecr_no'						, width : 80, editable : false, align : "center"},
					{name : 'ecr_dept'					, index : 'ecr_dept'					, width : 150, editable : false, align : "center"},
					{name : 'item_mrp_planning'			, index : 'item_mrp_planning'			, width : 50, editable : false, align : "center"}, */
					{name : 'activity_no'				, index : 'activity_no'					, width : 50, editable : false, hidden : true},
					{name : 'activity_sch_start_date'	, index : 'activity_sch_start_date'		, width : 50, editable : false, hidden : true},
					{name : 'activity_sch_finish_date'	, index : 'activity_sch_finish_date'	, width : 50, editable : false, hidden : true},
					{name : 'wip_class_disp'			, index : 'wip_class_disp'				, width : 50, editable : false, hidden : true},
					{name : 'wip_entity_name'			, index : 'wip_entity_name'				, width : 50, editable : false, hidden : true},
					{name : 'wip_department_class_disp'	, index : 'wip_department_class_disp'	, width : 50, editable : false, hidden : true},
					{name : 'wip_department_disp'		, index : 'wip_department_disp'			, width : 50, editable : false, hidden : true},
					{name : 'wip_resource_disp'			, index : 'wip_resource_disp'			, width : 50, editable : false, hidden : true},
					{name : 'wip_sch_start_date'		, index : 'wip_sch_start_date'			, width : 50, editable : false, hidden : true},
					{name : 'wip_sch_completion_date'	, index : 'wip_sch_completion_date'		, width : 50, editable : false, hidden : true},
					{name : 'wip_status_disp'			, index : 'wip_status_disp'				, width : 50, editable : false, hidden : true},
					{name : 'wip_date_released'			, index : 'wip_date_released'			, width : 50, editable : false, hidden : true},
					{name : 'wip_required_quantity'		, index : 'wip_required_quantity'		, width : 50, editable : false, hidden : true},
					{name : 'wip_quantity_issued'		, index : 'wip_quantity_issued'			, width : 50, editable : false, hidden : true},
					{name : 'req_order_quantity'		, index : 'req_order_quantity'			, width : 50, editable : false, hidden : true},
					{name : 'req_requested_date'		, index : 'req_requested_date'			, width : 50, editable : false, hidden : true},
					{name : 'req_required_date'			, index : 'req_required_date'			, width : 50, editable : false, hidden : true},
					{name : 'reqo_issue_order_id'		, index : 'reqo_issue_order_id'			, width : 50, editable : false, hidden : true},
					{name : 'reqo_issueorder_qty'		, index : 'reqo_issueorder_qty'			, width : 50, editable : false, hidden : true},
					{name : 'reqo_director_date'		, index : 'reqo_director_date'			, width : 50, editable : false, hidden : true},
					{name : 'reqo_director_disp'		, index : 'reqo_director_disp'			, width : 50, editable : false, hidden : true},
					{name : 'onhanddb_quantity'			, index : 'onhanddb_quantity'			, width : 50, editable : false, hidden : true},
					{name : 'mmt_transaction_date'		, index : 'mmt_transaction_date'		, width : 50, editable : false, hidden : true},
					{name : 'mmt_created_by_disp'		, index : 'mmt_created_by_disp'			, width : 50, editable : false, hidden : true}
				],
			gridview: true,
			viewrecords: true,
			autowidth: true,
			cmTemplate: { title: false },
			toolbar	: [false, "bottom"],
			//rownumbers : true, 			
			cellEdit : true,
			cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
			multiselect: false,			
			height: $(window).height()/2-180,
			pager: $('#jqGridMainListNavi'),
			rowList:[100,500,1000],
			rowNum:100, 
			recordtext: '내용 {0} - {1}, 전체 {2}',
			emptyrecords:'조회 내역 없음',
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
			         	idRow = rowid;
			         	idCol = iCol;
			         	kRow  = iRow;
			         	kCol  = iCol;
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
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
// 				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
// 	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");
            	var pageIndex         = parseInt($(".ui-pg-input").val());
 	   			var currentPageIndex  = parseInt($("#jqGridMainList").getGridParam("page"));// 페이지 인덱스
 	   			var lastPageX         = parseInt($("#jqGridMainList").getGridParam("lastpage"));  
 	   			var pages = 1;
 	   			var rowNum 			  = 100;

 	   			/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
 	   			* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
 	   			* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
 	   			*/ 
 	   			/* this is to make the grid to fetch data from server on page click*/
 	   			if (pgButton == "user") {
 	   				if (pageIndex > lastPageX) {
 	   			    	pages = lastPageX
 	   			    } else pages = pageIndex;
 	   				
 	   				rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'next_jqGridMainListNavi'){
 	   				pages = currentPageIndex+1;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			} 
 	   			else if(pgButton == 'last_jqGridMainListNavi'){
 	   				pages = lastPageX;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'prev_jqGridMainListNavi'){
 	   				pages = currentPageIndex-1;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'first_jqGridMainListNavi'){
 	   				pages = 1;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
 	   			//$(this).jqGrid("clearGridData");
 	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");
			},
		 	loadComplete: function (data) {
		 		var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        datatype: 'local',
				        data: data.rows,
				        pageServer: data.page,
				        recordsServer: data.records,
				        lastpageServer: data.total
				    });
				
				    // because we changed the value of the data parameter
				    // we need update internal _index parameter:
				    this.refreshIndex();
				
				    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
				        // we need reload grid only if we use sortname parameter,
				        // but the server return unsorted data
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
			gridComplete: function(data){

			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				var item = $(this).jqGrid( 'getRowData', rowid );
				
// 				var activity_no 			  = item.activity_no;		 
// 			    var activity_sch_start_date   = item.activity_sch_start_date;		 
// 			    var activity_sch_finish_date  = item.activity_sch_finish_date;		 
// 			    var wip_class_disp            = item.wip_class_disp;
// 			    var wip_entity_name           = item.wip_entity_name;		 
// 			    var wip_department_class_disp = item.wip_department_class_disp;		 
// 			    var wip_department_disp       = item.wip_department_disp;		 
// 			    var wip_resource_disp         = item.wip_resource_disp;		 
// 			    var wip_sch_start_date        = item.wip_sch_start_date;		 
// 			    var wip_sch_completion_date   = item.wip_sch_completion_date;		 
// 			    var wip_status_disp           = item.wip_status_disp;		 
// 			    var wip_date_released         = item.wip_date_released;		 
// 			    var wip_required_quantity     = item.wip_required_quantity;		 
// 			    var wip_quantity_issued       = item.wip_quantity_issued;		 
// 			    var req_order_quantity        = item.req_order_quantity;		 
// 			    var req_requested_date        = item.req_requested_date;		 
// 			    var req_required_date         = item.req_required_date;		 
// 			    var reqo_issue_order_id       = item.reqo_issue_order_id;		 
// 			    var reqo_issueorder_qty       = item.reqo_issueorder_qty;		 
// 			    var reqo_director_date        = item.reqo_director_date;		 
// 			    var reqo_director_disp        = item.reqo_director_disp;		 
// 			    var onhanddb_quantity         = item.onhanddb_quantity;		 
// 			    var mmt_transaction_date      = item.mmt_transaction_date;		 
// 			    var mmt_created_by_disp       = item.mmt_created_by_disp;
				
				$("#jqGridSub2List tr:not(:first)").remove();
				
				$.post("bomNeedsWipData.do?orgin_job_item_code="+item.orgin_job_item_code+"&project_no="+item.project_no+"&job_cd="+item.job_cd+"&item_code="+item.item_code, "", function( data ) {
					if(data.rows.length > 0) {
						$("#jqGridSub2List").append("<tr>"
		     					+"<td>"+fn_rst_data(data.rows[0].activity_no)+"</td><td>"+fn_rst_data(data.rows[0].activity_sch_start_date)+"</td><td>"+fn_rst_data(data.rows[0].activity_sch_finish_date)+"</td>"
		     					+"<td>"+fn_rst_data(data.rows[0].wip_class_disp)+"</td><td>"+fn_rst_data(data.rows[0].wip_entity_name)+"</td><td>"+fn_rst_data(data.rows[0].wip_department_class_disp)+"</td>"
		     					+"<td>"+fn_rst_data(data.rows[0].wip_department_disp)+"</td><td>"+fn_rst_data(data.rows[0].p_resource_disp)+"</td><td>"+fn_rst_data(data.rows[0].wip_sch_start_date)+"</td>"
		     					+"<td>"+fn_rst_data(data.rows[0].wip_sch_completion_date)+"</td><td>"+fn_rst_data(data.rows[0].wip_status_disp)+"</td><td>"+fn_rst_data(data.rows[0].wip_date_released)+"</td>"
		     					+"</tr>"
				     			+"<tr>"
				     			+"<th>JOB-요구수량</th><th>JOB-출고수량</th><th>출고요청-수량</th><th>출고요청-요청일</th><th>출고요청-요구일</th><th>출고지시-NO</th>"
				     			+"<th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th>"
				     			+"</tr>"
				     			+"<tr>"
				     			+"<td>"+fn_rst_data(data.rows[0].wip_required_quantity)+"</td><td>"+fn_rst_data(data.rows[0].wip_quantity_issued)+"</td><td>"+fn_rst_data(data.rows[0].req_order_quantity)+"</td>"
				     			+"<td>"+fn_rst_data(data.rows[0].req_requested_date)+"</td><td>"+fn_rst_data(data.rows[0].req_required_date)+"</td><td>"+fn_rst_data(data.rows[0].reqo_issue_order_id)+"</td>"
				     			+"<td>"+fn_rst_data(data.rows[0].reqo_issueorder_qty)+"</td><td>"+fn_rst_data(data.rows[0].reqo_director_date)+"</td><td>"+fn_rst_data(data.rows[0].reqo_director_disp)+"</td>"
				     			+"<td>"+fn_rst_data(data.rows[0].onhanddb_quantity)+"</td><td>"+fn_rst_data(data.rows[0].mmt_transaction_date)+"</td><td>"+fn_rst_data(data.rows[0].mmt_created_by_disp)+"</td>"
				     			+"</tr>");	
					} else {
						$("#jqGridSub2List").append("<tr>"
		     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
		     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
		     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
		     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
		     					+"</tr>"
				     			+"<tr>"
				     			+"<th>JOB-요구수량</th><th>JOB-출고수량</th><th>출고요청-수량</th><th>출고요청-요청일</th><th>출고요청-요구일</th><th>출고지시-NO</th>"
				     			+"<th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th>"
				     			+"</tr>"
				     			+"<tr>"
				     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"</tr>");	
					}
				}, "json" ).error( function () {
					$("#jqGridSub2List").append("<tr>"
	     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     					+"</tr>"
			     			+"<tr>"
			     			+"<th>JOB-요구수량</th><th>JOB-출고수량</th><th>출고요청-수량</th><th>출고요청-요청일</th><th>출고요청-요구일</th><th>출고지시-NO</th>"
			     			+"<th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th>"
			     			+"</tr>"
			     			+"<tr>"
			     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"</tr>");	
				});
				
//      			$("#jqGridSub2List").append("<tr>"
//      					+"<td>"+fn_rst_data(activity_no)+"</td><td>"+fn_rst_data(activity_sch_start_date)+"</td><td>"+fn_rst_data(activity_sch_finish_date)+"</td>"
//      					+"<td>"+fn_rst_data(wip_class_disp)+"</td><td>"+fn_rst_data(wip_entity_name)+"</td><td>"+fn_rst_data(wip_department_class_disp)+"</td>"
//      					+"<td>"+fn_rst_data(wip_department_disp)+"</td><td>"+fn_rst_data(wip_resource_disp)+"</td><td>"+fn_rst_data(wip_sch_start_date)+"</td>"
//      					+"<td>"+fn_rst_data(wip_sch_completion_date)+"</td><td>"+fn_rst_data(wip_status_disp)+"</td><td>"+fn_rst_data(wip_date_released)+"</td>"
//      					+"</tr>"
// 		     			+"<tr>"
// 		     			+"<th>JOB-요구수량</th><th>JOB-출고수량</th><th>출고요청-수량</th><th>출고요청-요청일</th><th>출고요청-요구일</th><th>출고지시-NO</th>"
// 		     			+"<th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th>"
// 		     			+"</tr>"
// 		     			+"<tr>"
// 		     			+"<td>"+fn_rst_data(wip_required_quantity)+"</td><td>"+fn_rst_data(wip_quantity_issued)+"</td><td>"+fn_rst_data(req_order_quantity)+"</td>"
// 		     			+"<td>"+fn_rst_data(req_requested_date)+"</td><td>"+fn_rst_data(req_required_date)+"</td><td>"+fn_rst_data(reqo_issue_order_id)+"</td>"
// 		     			+"<td>"+fn_rst_data(reqo_issueorder_qty)+"</td><td>"+fn_rst_data(reqo_director_date)+"</td><td>"+fn_rst_data(reqo_director_disp)+"</td>"
// 		     			+"<td>"+fn_rst_data(onhanddb_quantity)+"</td><td>"+fn_rst_data(mmt_transaction_date)+"</td><td>"+fn_rst_data(mmt_created_by_disp)+"</td>"
// 		     			+"</tr>");	
				
				jqGridObj1.jqGrid( "clearGridData" );
				jqGridObj1.jqGrid( 'setGridParam', {
					url : "bomNeedsBomList.do?project_no="+item.project_no+"&job_cd="+item.job_cd+"&item_code="+item.item_code,
					mtype : 'POST',
					datatype : 'json',
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
				
				$.post("bomNeedsErpData.do?project_no="+item.project_no+"&job_cd="+item.orgin_job_item_code+"&item_code="+item.item_code, "", function( data ) {
					if(data.rows.length > 0) {
						var row = null;
						var data1 = "";
						var data2 = "";
						for(var i = 0; i < data.rows.length; i++) {
							row = data.rows[i];
							data1 += "<tr><td>"+row.pr_no+"</td><td>"+row.pr_quantity+"</td><td>"+row.po_no+"</td><td>"+row.po_quantity_ordered+
										"</td><td>"+row.po_creation_date+"</td><td>"+row.po_agent_dept_disp+"</td><td>"+row.po_agent_disp+
										"</td><td>"+row.po_vendor_site_code_alt+"</td><td>"+row.scm_make_planing_date+"</td></tr>";
							data2 += "<tr><td>"+fn_rst_data(row.scm_make_start_date)+"</td><td>"+fn_rst_data(row.scm_paint_start_date)+"</td><td>"+fn_rst_data(row.scm_deliver_sch_date)+
										"</td><td>"+fn_rst_data(row.painting_move_date)+"</td><td>"+fn_rst_data(row.po_quantity_delivered)+"</td><td>"+fn_rst_data(row.rcv_transaction_date)+
										"</td><td>"+fn_rst_data(row.rcv_creation_date)+"</td><td>"+fn_rst_data(row.rcv_created_by_disp)+"</td><td>&nbsp;</td></tr>";
						}
						
						$("#jqGridSub1List tr:not(:first)").remove();
		     			$("#jqGridSub1List").append(data1 + "<tr>"
			     			+"<th>제작착수일</th><th>도장착수일</th><th>입고가능일</th><th>도장사이동일</th><th>PO-입고수량</th><th>입고일</th><th>입고처리일</th><th>입고처리자</th><th>&nbsp;</th>"
			     			+"</tr>" + data2);						
					} else {
						$("#jqGridSub1List tr:not(:first)").remove();
		     			$("#jqGridSub1List").append("<tr>"
		     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
		     					+"</tr>"
				     			+"<tr>"
		     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"</tr>"
				     			+"<tr>"
				     			+"<th>제작착수일</th><th>도장착수일</th><th>입고가능일</th><th>도장사이동일</th><th>PO-입고수량</th><th>입고일</th><th>입고처리일</th><th>입고처리자</th><th>&nbsp;</th>"
				     			+"</tr>"
				     			+"<tr>"
				     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"</tr>"
				     			+"<tr>"
				     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
				     			+"</tr>");	
					}
				}, "json" ).error( function () {
					$("#jqGridSub1List tr:not(:first)").remove();
	     			$("#jqGridSub1List").append("<tr>"
	     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     					+"</tr>"
			     			+"<tr>"
	     					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"</tr>"
			     			+"<tr>"
			     			+"<th>제작착수일</th><th>도장착수일</th><th>입고가능일</th><th>도장사이동일</th><th>PO-입고수량</th><th>입고일</th><th>입고처리일</th><th>입고처리자</th><th>&nbsp;</th>"
			     			+"</tr>"
			     			+"<tr>"
			     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"</tr>"
			     			+"<tr>"
			     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
			     			+"</tr>");		
				});
			}
     	}); //end of jqGrid
     	
     	jqGridObj1.jqGrid({ 
            datatype: 'json',
            url:'',
            mtype : '',
            postData : fn_getFormData('#application_form'),
            colNames : ['DWG NO.','BLOCK','STAGE','STR','TYPE','PENDING','Q\'TY', '공급타입', '공급유형'],
			colModel : [
					{name : 'dwg_no'			, index : 'dwg_no'			, width : 80, editable : false, align : "center"},
					{name : 'block_no'			, index : 'block_no'		, width : 60, editable : false, align : "center"},	
					{name : 'stage_no'			, index : 'stage_no'		, width : 60, editable : false, align : "center"},
					{name : 'str_flag'			, index : 'str_flag'		, width : 60, editable : false, align : "center"},
					{name : 'usc_job_type'		, index : 'usc_job_type'	, width : 60, editable : false, align : "center"},
					{name : 'item_code'			, index : 'item_code'		, width : 100, editable : false, align : "center"},
					{name : 'ea'				, index : 'ea'				, width : 60, editable : false, align : "center"},		
					{name : 'wip_supply_type'	, index : 'wip_supply_type'	, width : 60, editable : false, align : "center", hidden : true},				
					{name : 'wip_supply_desc'	, index : 'wip_supply_desc'	, width : 60, editable : false, align : "center"}				
				],
			gridview: true,
			viewrecords: true,
			autowidth: true,
			cmTemplate: { title: false },
			toolbar	: [false, "bottom"],
			//rownumbers : true, 			
			cellEdit : true,
			cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
			multiselect: false,			
			height : $(window).height()/2-280,
			rowList:[100,500,1000],
			rowNum:100, 
			recordtext: '내용 {0} - {1}, 전체 {2}',
			emptyrecords:'조회 내역 없음',
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
			         	idRow = rowid;
			         	idCol = iCol;
			         	kRow  = iRow;
			         	kCol  = iCol;
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
			
			},
		 	loadComplete: function (data) {
									
			},
			gridComplete: function(data){

			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				
			}
    	}); //end of jqGrid

    	//STR 선택
     	$.post( "infoStrList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_str_flag").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
     	
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 370 );
	    fn_insideGridresize( $(window), $( "#jqGridSubDiv" ), $( "#jqGridSubList" ) ,-322, 0.01 );
	    //fn_insideGridresize( $(window), $( "#jqGridSub1Div" ), $( "#jqGridSub1List" ) ,-205, 0.15 );
     	
	    //Search 버튼 클릭 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			fn_search(); 
		});
     	
	    //엑셀 export 버튼
		$("#btnExport").click(function() {
			fn_downloadStart();
			fn_excelDownload();	
		});
	});
	
	// 조회 버튼
	function fn_search() {	
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		// TODO
		if(uniqeValidation()){			
			var sUrl = "bomNeedsList.do?p_chk_series="+ar_series;
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj1.jqGrid( "clearGridData" );
			$("#jqGridSub1List tr:not(:first)").remove();
 			$("#jqGridSub1List").append("<tr>"
 					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
 					+"</tr>"
	     			+"<tr>"
 					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     			+"</tr>"
	     			+"<tr>"
	     			+"<th>제작착수일</th><th>도장착수일</th><th>입고가능일</th><th>도장사이동일</th><th>PO-입고수량</th><th>입고일</th><th>입고처리일</th><th>입고처리자</th><th>&nbsp;</th>"
	     			+"</tr>"
	     			+"<tr>"
	     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     			+"</tr>"
	     			+"<tr>"
	     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     			+"</tr>");
 			$("#jqGridSub2List tr:not(:first)").remove();
 			$("#jqGridSub2List").append("<tr>"
 					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
 					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
 					+"</tr>"
	     			+"<tr>"
	     			+"<th>JOB-요구수량</th><th>JOB-출고수량</th><th>출고요청-수량</th><th>출고요청-요청일</th><th>출고요청-요구일</th><th>출고지시-NO</th>"
	     			+"<th>출고지시-수량</th><th>출고지시일</th><th>출고지시자</th><th>출고-수량</th><th>출고일</th><th>출고처리자</th>"
	     			+"</tr>"
	     			+"<tr>"
	     			+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
 					+"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
	     			+"</tr>");	
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
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
	
	//엑셀 다운로드 화면 호출
	function fn_excelDownload() {
		
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		var cn = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colNames" );
		var cm = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colModel" );

		for(var i=1; i<cm.length; i++ ){
			
			if(cm[i]['hidden'] == false) {
				colName.push(cn[i]);
				dataName.push(cm[i]['index']);	
			}
		}
		
		colName.push("ACTIVITY");colName.push("ACT-시작일");colName.push("ACT-종료일");colName.push("구분");
		colName.push("JOB NO");colName.push("JOB-팀");colName.push("JOB-부서");colName.push("JOB-반/업체");
		colName.push("JOB-계획시작일");colName.push("JOB-계획완료일");colName.push("JOB-상태");colName.push("JOB-RELEASE");
		colName.push("JOB-요구수량");colName.push("JOB-출고수량");colName.push("출고요청-수량");colName.push("출고요청-요청일");
		colName.push("출고요청-요구일");
		//colName.push("PR-NO");colName.push("PR-수량");colName.push("PO-NO");
		//colName.push("PO-수량");colName.push("PO-생성일");colName.push("PO-구매발주부서");colName.push("PO-구매발주자");
		//colName.push("PO-공급사");colName.push("제작착수계획일");colName.push("제작착수일");colName.push("도장착수일");
		//colName.push("입고가능일");colName.push("공정상태");colName.push("도장사이동일");colName.push("PO-입고수량");
		//colName.push("입고일");colName.push("입고처리일");colName.push("입고처리자");
		colName.push("출고지시-NO");colName.push("출고지시-수량");colName.push("출고지시일");colName.push("출고지시자");
		colName.push("출고-수량");colName.push("출고일");colName.push("출고처리자");
		
		dataName.push("ACTIVITY_NO");dataName.push("ACTIVITY_SCH_START_DATE");dataName.push("ACTIVITY_SCH_FINISH_DATE");dataName.push("WIP_CLASS_DISP");
		dataName.push("WIP_ENTITY_NAME");dataName.push("WIP_DEPARTMENT_CLASS_DISP");dataName.push("WIP_DEPARTMENT_DISP");dataName.push("WIP_RESOURCE_DISP");
		dataName.push("WIP_SCH_START_DATE");dataName.push("WIP_SCH_COMPLETION_DATE");dataName.push("WIP_STATUS_DISP");dataName.push("WIP_DATE_RELEASED");
		dataName.push("WIP_REQUIRED_QUANTITY");dataName.push("WIP_QUANTITY_ISSUED");dataName.push("REQ_ORDER_QUANTITY");dataName.push("REQ_REQUESTED_DATE");
		dataName.push("REQ_REQUIRED_DATE");
		//dataName.push("PR_NO");dataName.push("PR_QUANTITY");dataName.push("PO_NO");
		//dataName.push("PO_QUANTITY_ORDERED");dataName.push("PO_CREATION_DATE");dataName.push("PO_AGENT_DEPT_DISP");dataName.push("PO_AGENT_DISP");
		//dataName.push("PO_VENDOR_SITE_CODE_ALT");dataName.push("SCM_MAKE_PLANING_DATE");dataName.push("SCM_MAKE_START_DATE");dataName.push("SCM_PAINT_START_DATE");
		//dataName.push("SCM_DELIVER_SCH_DATE");dataName.push("SCM_WORK_STATUS_DISP");dataName.push("PAINTING_MOVE_DATE");dataName.push("PO_QUANTITY_DELIVERED");
		//dataName.push("RCV_TRANSACTION_DATE");dataName.push("RCV_CREATION_DATE");dataName.push("RCV_CREATED_BY_DISP");
		dataName.push("REQO_ISSUE_ORDER_ID");dataName.push("REQO_ISSUEORDER_QTY");dataName.push("REQO_DIRECTOR_DATE");dataName.push("REQO_DIRECTOR_DISP");
		dataName.push("ONHANDDB_QUANTITY");dataName.push("MMT_TRANSACTION_DATE");dataName.push("MMT_CREATED_BY_DISP");
		
		$( '#p_col_name' ).val(colName);
		$( '#p_data_name' ).val(dataName);
		var f    = document.application_form;
		f.action = "bomNeedsExcelList.do?p_chk_series="+ar_series;
		f.method = "post";
		f.submit();
	}
	
	var DeptOnChange = function(obj){
    	$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
    	$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
    }
	
	var UserOnChange = function(obj){
    	$("input[name=p_user_id]").val($(obj).find("option:selected").val());
    	$("input[name=p_user_name]").val($(obj).find("option:selected").text());
    }
	
	var fn_rst_data = function(val){
		if(val+'' != '' && val != undefined) { // +''을 붙여서 number형인 경우 string으로 변경
			return val;
		} else {
			return "&nbsp;";
		}
	}
	
	//Dept Change 
	var DeptOnChange = function(obj){
		
		//기술 기획일 경우 유저 선택 기능				
		var vDeptCode = $(obj).find("option:selected").val();
		getUserList(vDeptCode);
		if(vDeptCode != ""){
			$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
			$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
		}
		
		var grcode = "${loginUser.gr_code}";
		
		if(!grcode == 'M1') {
			if($("input[name=login_dept]").val() != $("input[name=p_dept_code]").val()  ) {
				$("#btnAdd").hide();
				$("#btnDelete").hide();
			} else {
				$("#btnAdd").show();
				$("#btnDelete").show();
			}
		} else {
			UserOnChange();
		}
	}
	
	//User Change 
	var UserOnChange = function(){
		
		$("input[name=p_user_id]").val( $("select[name=p_sel_user]").find("option:selected").val() );
		$("input[name=p_user_name]").val( $("select[name=p_sel_user]").find("option:selected").text() );
		
	}
	
	//Get User List
	var getUserList = function(vDeptCode){
		getAjaxHtml($("#p_sel_user"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerUser&p_user_id="+$("input[name=p_user_id]").val()+"&p_dept_code="+vDeptCode, null, null);
	}
	
	function motherCodeFormatter(cellvalue, options, rowObject ) {
		if(cellvalue == null) {
			return '';
		} else {
			//alert("<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"','"+rowObject.job_cd+"','"+cellvalue+"');\">"+cellvalue+"</a>");
			return "<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"','"+rowObject.job_cd+"','"+cellvalue+"');\">"+cellvalue+"</a>";
		}
	}
	
	function itemCodeFormatter(cellvalue, options, rowObject ) {
		
		if(cellvalue == null) {
			return '';
		} else {
			return "<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"','"+rowObject.mother_code+"','"+cellvalue+"');\">"+cellvalue+"</a>";
		}
	}
	
	function unFormatter(cellvalue, options, rowObject ) {
		return cellvalue;
	}
	
	function ecoFormatter(cellvalue, options, rowObject ) {
		
		if(cellvalue == null) {
			return '';		
		} else {
			return "<a ondblclick=\"javascript:ecoNoClick('"+cellvalue+"')\">"+cellvalue+"</a>";
		}
	}
	
	//Eco No. 버튼 클릭 시 		
	var ecoNoClick = function (eco_no){
		
		//메뉴ID를 가져오는 공통함수 
		getMenuId("eco.do", callback_MenuId);
		
		var sURL = "eco.do?ecoName="+eco_no+"&menu_id="+menuId+"&popupDiv=Y&checkPopup=Y";
		var popOptions = "width=1200, height=700, resizable=yes, scrollbars=yes, status=yes";
		var win = window.open(sURL, "", popOptions); 
	    
		setTimeout(function(){
			win.focus();
		 }, 500);
	}
	
	//After Info 버튼 클릭 시 		
	var motherCodeView = function (projectNo, motherCode, itemCode){
		
		//메뉴ID를 가져오는 공통함수 
		getMenuId("sscBomStatus.do", callback_MenuId);
		
		var sURL = "sscBomStatus.do?menu_id="+menuId+"&up_link=bom&project_no="
			+ projectNo + "&mother_code=" + motherCode + "&item_code=" +itemCode;
		var popOptions = "width=1200, height=730, resizable=yes, scrollbars=no, status=yes"; 
		var win = window.open(sURL, "bomStatus", popOptions); 
		
		setTimeout(function(){
			win.focus();
		 }, 1000);
	}
	
	function checkItemCode() {
		if($("#p_project_no").val() == "*" && $("#p_dwg_no").val() == "*") {
			$("#p_item_code").removeClass();
			$("#p_item_code").addClass("required");
		} else {
			$("#p_item_code").removeClass();
			$("#p_item_code").addClass("commonInput");
		}
		
	}
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
</script>
</body>

</html>