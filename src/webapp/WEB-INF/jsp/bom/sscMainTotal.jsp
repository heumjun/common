<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC TOTAL SEARCH</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	/* .header .searchArea {position:relative; width:1100px; float:left; height:60px; margin:0;}
	.header .searchArea .searchDetail {padding:3px 0 0 0; float:left; height:30px; margin:0 8px 0 0; font-weight:bold;}
	.header .searchArea .shipType {width:140px; text-align:center; border:1px solid #999; height:24px;}	
	.header .searchArea .uniqInput {background-color:#FFE0C0; width:55px; text-transform: uppercase;}
	.header .searchArea .commonInput {width:55px; text-transform: uppercase;}	
	.header .searchArea .bigInput {width:90px; text-transform: uppercase;}	
	.disableInput {background-color:#dedede}
	.header .buttonArea {position:relative; width:370px; float:right; height:60px; padding:4px 0px 0px 10px; text-align:right;}
	.header .buttonArea input { width:70px; height:24px; cursor:pointer; margin-bottom:8px; }
	.dwgnoArea{position:absolute; overflow-y:auto; min-width:70px; max-height:200px; margin-left:62px; background-color:white; border:1px solid #ccc; line-height:1.6; display:none; cursor:pointer; z-index:1; }
	.onMs{background-color:#FFFA94;}
	input[type=text] {text-transform: uppercase;}
	.SSCMainPagingArea{width:100%; text-align:center; margin-top:10px;} */
	
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
	<input type="hidden" name="p_isexcel" value="" />
	<input type="hidden" name="p_filename" value="TBC_SSC_LIST" />
	<input type="hidden" name="pageYn" value="N" />
	<input type="hidden" name="temp_project_no" value="" />
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		Total Search
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
		<table class="searchArea conSearch">
		<col width="1100"/>
		<col width="*"/>
			<tr>
			<td class="sscType" style="border-right:none;"> 
			PROJECT
			<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:50px;" value="" onkeyup="javascript:getDwgNos();" /> &nbsp;
			DWG NO.
				<input type="text" id="p_dwg_no" id="p_dwg_no" name="p_dwg_no" class="required" style="width:60px;" value="${p_dwg_no}" alt="DWG NO." /> &nbsp;
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
					<input type="button" class="btn_blue2" value="SAVE" id="btnSave"/>
					<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				</div>
			</td>
			
			</tr>
		</table>
		<table class="searchArea2">
		<col width="1200"/>
		<col width="*"/>
			<tr>
			<td class="sscType">
			TYPE
				<select name="p_item_type_cd" id="p_item_type_cd" style="width:130px;" >
				</select> &nbsp;
			ECO NO.
				<input type="text" name="p_eco_no" id="p_eco_no" class="commonInput" style="width:80px;" /> &nbsp;
			생성일자
				<input type="text" name="p_start_date" id="p_start_date" class="commonInput" style="width:60px;" value=""/>
				~
				<input type="text" name="p_end_date" id="p_end_date" class="commonInput" style="width:60px;" value=""/> &nbsp;
			ECO
				<select name="p_is_eco" id="p_is_eco" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select> &nbsp;
			RELEASE
				<select name="p_release" id="p_release" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
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
<!-- 						<option value="D" >Diff</option> -->
				</select> &nbsp;
				
			
			<c:choose>
				<c:when test="${loginUser.gr_code=='M1'}">
					DEPT.
					<select name="p_sel_dept" id="p_sel_dept" style="width:130px;" onchange="javascript:DeptOnChange(this);" >
					</select>
					<input type="hidden" name="p_dept_code" id="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
					<input type="hidden" name="p_dept_name" id="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  /> &nbsp;
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
				
			<%-- DEPT.
				<input type="text" name="p_dept_name" id="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />" class="disableInput" style="width:100px;" readonly="readonly"/> &nbsp;
				<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
			USER
				<input type="text" name="p_user" id="p_user" class="disableInput" value="<c:out value="${loginUser.user_name}" />" style="width:80px;" readonly="readonly"/> &nbsp;
			 --%>				
				
			</td>
			
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_red2" value="EXPORT" id="btnExcel"/>
				</div>
			</td>
			
			
			</tr>
		</table>
		
		<%-- <div class="header">
			<div class="searchArea">
				<div class="searchDetail">
					<select name="p_ship" id="p_ship" >
						<option value="master" <c:if test="${requestbox.p_ship=='master'}">selected="selected"</c:if> >Master</option>
						<option value="project" <c:if test="${requestbox.p_ship=='project'}">selected="selected"</c:if> >Project</option>
					</select>
					<input type="text" class="commonInput uniqInput" name="p_project_no" alt="Project" value="" onblur="javascript:getDwgNos();"   />
				</div>
				<div class="searchDetail">
					DWG No.
					<input type="text" id="p_dwg_no" name="p_dwg_no" class="uniqInput commonInput" value="" style="width:80px;" alt="DWG NO." onfocus=""/>
				</div>
				<div class="searchDetail">
					Block <input type="text" class="commonInput" name="p_block_no" value="" style="width:40px;" />
				</div>
				<div class="searchDetail">
					Stage <input type="text" class="commonInput" name="p_stage_no" style="width:40px;"  value="" />
				</div>
				<div class="searchDetail">
					STR <input type="text" class="commonInput" name="p_str_flag" style="width:40px;" value=""  />
				</div>
				<div class="searchDetail">
					Mother <input type="text" class="commonInput" name="p_mother_code" style="width:80px;" value=""  />
				</div>
				<div class="searchDetail">
					ITEM <input type="text" class="commonInput" name="p_item_code" style="width:80px;" value=""  />
				</div>
				<div class="searchDetail">
					Description <input type="text" class="commonInput" name="p_item_desc" style="width:100px;" value=""  />
				</div>
				<div class="searchDetail"  style="clear:both">
					Type <select name="p_item_type_cd" id="p_item_type_cd" style="width:130px;" ></select>
				</div>
				<div class="searchDetail">
					ECO No. <input type="text" class="commonInput" name="p_eco_no" value="" style="width:70px;"  />
				</div>
				<div class="searchDetail">
					ECO 
					<select name="p_is_eco" class="commonInput">
						<option value="ALL" selected="selected" >ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
						<option value="R" >Release</option>
					</select>
				</div>
				<div class="searchDetail">
					Job <input type="text" class="commonInput" name="p_job_cd" value="" style="width:70px;"  />
				</div>
				<div class="searchDetail">
					W/P <input type="text" class="commonInput" name="p_work_package_code" value="" style="width:70px;"  />
				</div>
				<div class="searchDetail">
					State 
					<select name="p_state" class="commonInput">
						<option value="ALL" selected="selected">ALL</option>
						<option value="A" >A</option>
						<option value="D" >D</option>
						<option value="C" >C</option>
					</select>
				</div>
				<!-- 
				<div class="searchDetail">
					ERP Only
					<input type="checkbox" name="chk_view_erp" />
					<input type="hidden" name="p_view_erp"/>
				</div>
				 -->
				<div class="searchDetail">
					ERP 
					<select name="p_exist_erp" class="commonInput">
						<option value="ALL" selected="selected" >ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
						<option value="D" >Diff</option>
					</select>
				</div>
				
				<div class="searchDetail">
					Dept. <input type="text" class="disableInput" name="p_dept" value="<c:out value="${DeptName}" />" style="width:75px;"  readonly="readonly" />
				</div>
				<div class="searchDetail">
					User <input type="text" class="disableInput" name="p_user" style="margin-right:20px; width:55px;" value="<c:out value="${UserName}" />" readonly="readonly"/>
				</div>
			</div>
			<div class="buttonArea">
				<input type="button" value="Search" id="btnSearch"/>
				<input type="button" value="Export" id="btnExcel"/>
				<input type="button" value="Save" id="btnSave"/>
				<input type="button" value="Close" id="btnClose"/>
			</div>
		</div> 
			
			<div class="content">
				<table id="jqGridMainTotalList"></table>
				<div id="bottomJqGridMainTotalList"></div>
			</div>	--%>
			
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
				<table id="jqGridMainTotalList"></table>
				<div id="bottomJqGridMainTotalList"></div>
			</div>
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" >

	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var menuId = '';
	
	var jqGridObj = $("#jqGridMainTotalList");

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
		
// 		if($("#p_dept_code").val() != $("select[name=p_sel_dept]").val()){
// 			$("#p_dept_code").val($("select[name=p_sel_dept]").val());
// 		}
		
// 		if($("#p_user_id").val() != $("#p_sel_user option:selected").val()){
// 			$("#p_user_id").val($("#p_sel_user option:selected").val());
// 		}
		
	  	$( "#p_start_date, #p_end_date" ).datepicker({
	    	dateFormat: 'yy-mm-dd',
	    	prevText: '이전 달',
		    nextText: '다음 달',
		    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    dayNames: ['일','월','화','수','목','금','토'],
		    dayNamesShort: ['일','월','화','수','목','금','토'],
		    dayNamesMin: ['일','월','화','수','목','금','토'],
		    showMonthAfterYear: true,
		    yearSuffix: '년'				    	
	  	});
		
		//기술 기획일 경우 부서 선택 기능
		if(typeof($("#p_sel_dept").val()) !== 'undefined'){
			getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
		}
		
		//User 선택할 수 있도록 수정.
		//Select Box User 받아옴.
		getUserList($("input[name=p_dept_code]").val());
		
		//콤보박스 셋팅				
		getAjaxHtml($("#p_item_type_cd"),"commonSelectBoxDataList.do?p_query=getCommonSscType&sb_type=all&p_temp_item_type_cd="+$("#p_temp_item_type_cd").val(), null);
			
		$("#jqGridMainTotalList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             url:'', ///sscMainTotalList.do
             postData : fn_getFormData('#application_form'),
             colModel:[              
					{label:'OPER', name:'oper', width:50, align:'center', sortable:false, title:false, hidden:true},
					{label:'SSC_SUB_ID', name:'ssc_sub_id', width:40, align:'center', sortable:true, title:false, hidden:true},
	               	{label:'TYPE', name:'item_type_cd' , width:30 ,align:'center', sortable:true, title:false},
	               	{label:'STATE', name:'state_flag' , width:40 ,align:'center', sortable:true, title:false},
	               	{label:'PROJECT', name:'project_no' , width:90 ,align:'center', sortable:true, title:false},
	               	{label:'DWG No.', name:'dwg_no' , width:90 ,align:'center', sortable:true, title:false},
	               	{label:'BLOCK', name:'block_no' , width:60 ,align:'center', sortable:true, title:false},
	               	{label:'STAGE', name:'stage_no' , width:60 ,align:'center', sortable:true, title:false},
	               	{label:'STR', name:'str_flag' , width:60 ,align:'center', sortable:true, title:false},
	               	{label:'JOB ITEM', name:'job_cd' , width:100 ,align:'center', sortable:true, title:false, formatter: motherCodeFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';}},
	               	{label:'PENDING MOTHER', name:'mother_code' , width:100 ,align:'center', sortable:true, title:false, formatter: motherCodeFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';}},
	               	{label:'ITEM CODE', name:'item_code' , width:100 ,align:'center', sortable:true, title:false, formatter: itemCodeFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';} },
	               	{label:'DESCRIPTION', name:'item_desc' , width:200 ,align:'left', sortable:true, title:false},
	               	{label:'EA', name:'ea' , width:40 ,align:'center', sortable:true, title:false},
	               	{label:'WEIGHT', name:'item_weight' , width:60 ,align:'center', sortable:true, title:false},
	               	{label:'PAINT', name:'paint_code1' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
	               	{label:'SUPPLY', name:'supply' , width:60 ,align:'center', sortable:false, title:false, editable:true, edittype : "select", editoptions:{value:"Y:Y;N:N"}},
	               	{label:'DEPART', name:'dept_name' , width:100 ,align:'center', sortable:true, title:false},
	               	{label:'USER', name:'user_name' , width:70 ,align:'center', sortable:true, title:false},
	               	{label:'DATE', name:'modify_date' , width:70 ,align:'center', sortable:true, title:false},
	               	{label:'ECO NO.', name:'eco_no' , width:90 ,align:'center', sortable:true, title:false, formatter: ecoFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';} },
	               	{label:'RELEASE', name:'release_desc' , width:100 ,align:'center', sortable:false, title:false},
	               	{label:'DWG.', name:'dwg_check', width:30, align:'center', sortable:true, title:false},
	               	{label:'dwg_file_name', name:'dwg_file_name', title:false, hidden:true},
	               	{label:'KEY', name:'key_no' , width:50 ,align:'center', sortable:true, title:false},
	               	{label:'ERP', name:'exist_erp' , width:50 ,align:'center', sortable:true, title:false},
	               	{label:'PR NO.', name:'pr_no' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
	               	{label:'PO NO.', name:'po_no' , width:60 ,align:'center', sortable:true, title:false, hidden:true},
	               	{label:'COST', name:'cost' , width:50 ,align:'center', sortable:true, title:false, hidden:true},
	               	{label:'BUY-BUY FLAG', name:'buy_buy_flag', width:50, align:'center', sortable:true, title:false,  hidden:true},
	               	{label:'RAW_LEVEL_FLAG', name:'raw_level_flag', width:50, align:'center', sortable:true, title:false, hidden:true}
                ],
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
             multiselect: false,
             height: 600,
             pager: $( '#bottomJqGridMainTotalList' ),
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
 	   			var currentPageIndex  = parseInt($("#jqGridMainTotalList").getGridParam("page"));// 페이지 인덱스
 	   			var lastPageX         = parseInt($("#jqGridMainTotalList").getGridParam("lastpage"));  
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
 	   			}
 	   			else if(pgButton == 'next_bottomJqGridMainTotalList'){
 	   				pages = currentPageIndex+1;
 	   			} 
 	   			else if(pgButton == 'last_bottomJqGridMainTotalList'){
 	   				pages = lastPageX;
 	   			}
 	   			else if(pgButton == 'prev_bottomJqGridMainTotalList'){
 	   				pages = currentPageIndex-1;
 	   			}
 	   			else if(pgButton == 'first_bottomJqGridMainTotalList'){
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
				var rows = $(this).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
				
					//부모 자식 관계 색깔 표시
					if(item.buy_buy_flag == 'Y') {
						jqGridObj.setRowData(rows[i], false, {background : "#ccddff"});
					}
					if(item.raw_level_flag == 'Y') {
						jqGridObj.setRowData(rows[i], false, {background : "#99bbff"});
					}
				}
			},
			gridComplete : function() {
				var rows = jqGridObj.getDataIDs();

				for( var i = 0; i < rows.length; i++ ) {
					
					var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
					if(item.dwg_check == 'Y') {
						jqGridObj.jqGrid( 'setCell', rows[i], 'dwg_check', '', { cursor : 'pointer'} );
					}
				}
			},
			ondblClickRow : function( rowid, iCol, cellcontent, e ) {
				
				jqGridObj.saveCell(kRow, idCol );
				
				var rowData = jqGridObj.getRowData(rowid);
				var dwg_file_name = rowData['dwg_file_name'];

				if(cellcontent == 21 && rowData['dwg_check'] == 'Y') {
					dwgView(dwg_file_name);
				}
				
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
		
		//jqGrid 크기 동적화
        fn_gridresize( $(window), $( "#jqGridMainTotalList" ), 70 );
     	
     	//사용자 입력 방지 필요시 해제
		//$(".ui-pg-input").attr("readonly","readonly");
     	
     	//Save 버튼 클릭 시 
		$("#btnSave").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(confirm("SUPPLY(도사급) 변경사항을 ERP 반영 하시겠습니까?")){
				
				var changeResultRows =  getChangedGridInfo("#jqGridMainTotalList");
				
				var url			= "sscMainSaveAction.do";
				var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
				var formData = fn_getFormData('#application_form');
				var parameters = $.extend({},dataList,formData);
				
				lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
				
				$.post(url, parameters, function(data)
				{	
					var msg = '';
					var result = '';

					for ( var key in data) {
						if (key == 'resultMsg') {
							msg = data[key];
						}
						if (key == 'result') {
							result = data[key];
						}
					}
					
					alert(msg);
					
				},"json").error(function() {
					alert('시스템 오류입니다.\n전산담당자에게 문의해주세요.');
				}).always(function() {
					lodingBox.remove();
					//fn_search();
				});

			}
		});
		
		//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
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
			
			/* if($("input[name=p_series]:checked").size() < 1) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N", null);
			}*/
			
			if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());

			//Uniqe Validation
			if(uniqeValidation()){
				
				var sUrl = "sscMainTotalList.do?p_chk_series="+ar_series;
				$("#jqGridMainTotalList").jqGrid( "clearGridData" );
				$("#jqGridMainTotalList").jqGrid( 'setGridParam', {
					url : sUrl,
					mtype : 'POST',
					datatype : 'json',
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
				
				//검색 시 스크롤 깨짐현상 해결
				$("#jqGridMainTotalList").closest(".ui-jqgrid-bdiv").scrollLeft(0);

			}
		});
		
		//Excel 버튼 클릭 시 
		$("#btnExcel").click(function(){

			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			if($("input[name=p_series]:checked").size() < 1) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var gridColModel = $("#jqGridMainTotalList").jqGrid('getGridParam','colModel');
			for(var i=0; i<gridColModel.length; i++ ){
				if(gridColModel[i].hidden != true){
					colName.push(gridColModel[i].label);
					dataName.push(gridColModel[i].name);
				}
			}
			
			form = $('#application_form');

			$("input[name=p_is_excel]").val("Y");
			//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
			form.attr("action", "sscMainTotalExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName+"&p_chk_series="+ar_series);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		if( $("#p_dept_code").val() == '' ){
			$("#p_dept_code").val("ALL");
			$("#p_user_id").val("ALL");
		}
	});
	
	
	
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
	
	var printCheckSelectCnt = function(){
		$("#tSelCnt").text(Number($("input[name=p_chkItem]:checked").length));
	}
	
	//Plm Item 정보 Popup
	var fn_item_popup = function(vItemCode){	
		getAjaxHtml(null,"/ematrix/tbcGetPlmItemId.tbc?&p_item_code="+vItemCode, null, getPlmItemCallback);
	}
	
	//Plm Eco 정보 Popup
	var fn_eco_popup = function(vEcoNo){
		getAjaxHtml(null,"/ematrix/tbcGetPlmEcoId.tbc?&p_eco_no="+vEcoNo, null, getPlmItemCallback);
	}
	
	var getPlmItemCallback = function(p_id){	
		if(p_id == ""){
			alert("[PLM]해당 Object가  존재하지 않습니다.");
			return false;
		}
		var popOptions = "width=980,height=768, scrollbars=yes, resizable=yes"; 
		var url = '/ematrix/common/emxTree.jsp?emxSuiteDirectory=engineeringcentral&relId=null&parentOID=null&jsTreeID=null&suiteKey=EngineeringCentral&objectId='+p_id;
		var popup = window.open(url, "PlmItemInfoPopup", popOptions);
	}
	
	
	var returnPlmItemLink = function(cellValue, option, rowdata, action){
		return "<a ondblclick=\"javascript:fn_item_popup('" + cellValue + "')\" >"+cellValue+"</a>";
	}
	var returnPlmEcoLink = function(cellValue, option, rowdata, action){
		if( cellValue == null ) {
			return "";
		} else {
			return "<a ondblclick=\"javascript:fn_eco_popup('" + cellValue + "')\" >"+cellValue+"</a>";
		}
	}
	
	var returnEdit = function(cellValue, option, rowdata, action){
		return "<input type='text' value='"+cellValue+"'>";
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
		
		var sURL = "eco.do?ecoName="+eco_no+"&menu_id=" + menuId;
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
		
		var sURL = "sscBomStatus.do?menu_id=" + menuId + "&up_link=bom&project_no="
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
	
	//그리드의 변경된 row만 가져오는 함수
	function getChangedGridInfo(gridId) {
		var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I' || obj.oper == 'U';
		});
		return changedData;
	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I') {
			item.oper = 'U';
			//jqGridObj.jqGrid('setCell', rowid, cellName, '', { 'background' : '#6DFF6D' } );
		}
		
		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable, select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	//도면 뷰어
	var dwgView = function(file_name){	

		var sURL = "dwgPopupView.do?mode=dwgChkView&p_file_name="+file_name;
		form = $('#application_form');
		form.attr("action", sURL);
		var myWindow = window.open(sURL,"listForm","height=500,width=1200,top=150,left=200,location=no");
			    
		form.attr("target","listForm");
		form.attr("method", "post");	
				
		myWindow.focus();
		form.submit();
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
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
</script>
</body>
</html>