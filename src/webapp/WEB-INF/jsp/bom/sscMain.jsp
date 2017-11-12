<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>SSC Management</title>
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
	<input type="hidden" id="p_item_type_cd" name="p_item_type_cd" value="<c:out value="${p_item_type_cd}"/>" />		
	<input type="hidden" name="p_dg_project" value="" />	
	<input type="hidden" name="p_filename" value="" />	
	<input type="hidden" name="p_nowpage" value="1" />	
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" name="p_bom_type" value="" />
	<input type="hidden" name="pageYn" value="" />	
	<input type="hidden" name="temp_project_no" value="" />
	<input type="hidden" name="p_check_series" value="${p_chk_series}" />
	<input type="hidden" name="page_flag" value="${page_flag}" />
	<input type="hidden" name="p_ischeck" value="${p_ischeck}" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	<input type="hidden" id="p_arrDistinct" name="p_arrDistinct"/>
	<!-- ALL BOM ECO 번호 -->
	<input type="hidden" name="p_input_eco_no" value="" />
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		SSC
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="1200"/>
			<col width="*"/>
			<tr>
			<td class="sscType" style="border-right:none;"> 
				PROJECT
				<input type="text" class = "required"  name="p_project_no" alt="Project"  style="width:50px;" value="${p_project_no }" onkeyup="javascript:getDwgNos();" /> &nbsp;
				DWG NO.
				<input type="text" id="p_dwg_no" name="p_dwg_no" class = "required" style="width:60px;" value="${p_dwg_no}" alt="DWG NO." onkeypress="javascript:getDwgNos();" /> &nbsp;
				
				<c:choose>
					<c:when test="${p_item_type_cd != 'PA'}">
						BLOCK
						<input type="text" class="commonInput" name="p_block_no" style="width:40px;" value="" /> &nbsp;
					</c:when>
				</c:choose>
					
				<c:choose>
					<c:when test="${p_item_type_cd == 'CA'}">
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();" /> &nbsp;
						CIRCUIT
						<input type="text" class="commonInput" name="p_attr1" style="width:60px;" value="" /> &nbsp;
						TYPE
						<input type="text" class="commonInput" name="p_attr2"  style="width:60px;"  value="" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'SU'}">
						STAGE
						<input type="text" class="commonInput" name="p_stage_no" style="width:50px;" value="" /> &nbsp;
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();"  /> &nbsp;
						SUP NO.
						<input type="text" class="commonInput" name="p_attr5" style="width:70px;" value="" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'GE'}">
						STAGE
						<input type="text" class="commonInput" name="p_stage_no" style="width:50px;"  value="" /> &nbsp;
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();"  /> &nbsp;
						DESCRIPTION
						<input type="text" class="bigInput" name="p_item_desc" style="width:70px;" value="" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'PI'}">
						STAGE
						<input type="text" class="commonInput" name="p_stage_no" style="width:50px;"  value="" /> &nbsp;
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();"  /> &nbsp;
						PIECE
						<input type="text" class="commonInput" name="p_piece_no" style="width:70px;" value="" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'OU'}">
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();" /> &nbsp;
						MARK NO.
						<input type="text" class="commonInput" name="p_attr1" value="" style="width:60px;" /> &nbsp;
						DETAIL
						<input type="text" class="commonInput bigInput" name="p_desc_detail" value="" style="width:70px;" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'SE'}">
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();" /> &nbsp;
						SEAT NO.
						<input type="text" class="commonInput" name="p_key_no" style="width:60px;" value=""  /> &nbsp;
						DETAIL
						<input type="text" class="commonInput bigInput" name="p_bom_item_detail" style="width:70px;" value="" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'TR'}">
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();" /> &nbsp;
						TRAY NO.
						<input type="text" class="commonInput" name="p_key_no" style="width:60px;" value=""  /> &nbsp;
						DETAIL
						<input type="text" class="commonInput bigInput" name="p_bom_item_detail" style="width:70px;" value="" /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'VA'}">
						STAGE
						<input type="text" class="commonInput" name="p_stage_no" style="width:50px;"  value="" /> &nbsp;
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();" /> &nbsp;
						VALVE NO.
						<input type="text" class="commonInput" name="p_key_no" style="width:70px;" value=""  /> &nbsp;
					</c:when>
					<c:when test="${p_item_type_cd == 'EQ'}">
						STAGE
						<input type="text" class="commonInput" name="p_stage_no" style="width:50px;"  value="" /> &nbsp;
						STR
						<input type="text" class="commonInput" name="p_str_flag" style="width:26px;" value=""  /> &nbsp;
						TYPE
						<input type="text" class="commonInput" id="p_usc_job_type" name="p_usc_job_type" style="width:40px;" value="" onkeypress="javascript:getUscJobType();" /> &nbsp;
					</c:when>
				</c:choose>
				ECO NO.
				<input type="text" class="commonInput" name="p_eco_no" value="" style="width:70px;"  /> &nbsp;
				
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
				<input type="text" class="disableInput" name="p_user" style=" width:45px;" value="<c:out value="${loginUser.user_name}" />" readonly="readonly"/> &nbsp;
				P/CNT
				<input type="text" id="p_page_cnt" name="p_page_cnt" class="commonInput" style="width:30px;" value="${p_page_cnt}" alt="P/CNT" /> &nbsp;
			</td>
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
					<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
					<input type="button" class="btn_blue2" value="MODIFY" id="btnModify"/>
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
				STATE
				<select name="p_state_flag" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="A" >A</option>
					<option value="D" >D</option>
					<option value="C" >C</option>
<!-- 					<option value="Act" >Act</option> -->
				</select> &nbsp;
				JOB ITEM
				<input type="text" class="commonInput" name="p_job_cd" style="width:90px;" value="" /> &nbsp;
				PENDING
				<input type="text" class="commonInput bigInput" name="p_mother_code" value="" style="width:90px;" /> &nbsp;
				ITEM CODE
				<input type="text" class="commonInput bigInput" name="p_item_code" value="" style="width:90px;" /> &nbsp;
				생성일자
				<input type="text" name="p_start_date" id="p_start_date" class="commonInput" style="width:60px;" value=""/>
				~
				<input type="text" name="p_end_date" id="p_end_date" class="commonInput" style="width:60px;" value=""/> &nbsp;
				ECO
				<select name="p_is_eco" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select> &nbsp;
				RELEASE
				<select name="p_release" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select> &nbsp;
				상위조치
				<select name="p_upperaction" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select> &nbsp;
				JOB 상태
				<select name="p_job_status" class="commonInput" style="width:90px;" >
					<option value="ALL" selected="selected">ALL</option>
					<option value="1" >릴리즈 안됨</option>
					<option value="3" >릴리즈 됨</option>
					<option value="4" >완료</option>
				</select> &nbsp;
			</td>
			<td style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue2" value="BOM" id="btnBom"/>
				<input type="button" class="btn_blue2" value="ALLBOM" id="btnAllBom"/>
				<input type="button" class="btn_blue2" value="RESTORE" id="btnRestore"/>
				<input type="button" class="btn_blue2" value="CANCEL" id="btnCancel"/>
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
		
<%-- 		<c:choose> --%>
<%-- 			<c:when test="${p_item_type_cd != 'VA'}"> --%>
				<table class="searchArea2">
					<col width="700"/>
					<col width="*"/>
					<col width="300"/>
					<tr>
						<td class="bdl_no" style="padding-top:2px; border-left:none;">
							※ 전체 : 
							<label id="totalCnt" name="totalCnt" style="color: blue; font:bold; font-size:15px;" ></label>건 / 선택 : <label id="selCnt" name="selCnt" style="color: red; font:bold; font-size:15px;" ></label>건
							<span class="totalEaArea">
								Total EA <input type="text" id="totalEa" name="totalEa" style="width:70px; height:15px;" readonly="readonly" value="<c:out value="${totalEa}"/>" />
							</span>
							<span class="totalEaArea">
								Total WEIGHT
								<input type="text" id="totalWeight" name="totalWeight" style="width:70px; height:15px;" readonly="readonly" value="<c:out value="${totalWeight}"/>" />
							</span>
							<c:choose>
								<c:when test="${p_item_type_cd == 'CA'}">
									<span class="totalEaArea">
										Total LENGTH
										<input type="text" id="totalLength" name="totalLength" style="width:70px; height:15px;" readonly="readonly" value="<c:out value="${totalLength}"/>" />
									</span>
								</c:when>
							</c:choose>
						</td>
						<td style="border-left:none;">
							<div class="button endbox" >
								<c:choose>
									<c:when test="${p_item_type_cd == 'OU'}">
										<input type="button" class="btn_red2" value="S-CODE" id="btnStructure" />
									</c:when>
									<c:when test="${p_item_type_cd == 'CA'}">
				 						<input type="button" class="btn_red2" value="CA-TYPE" id="btnCableType" /> 
									</c:when>
								</c:choose>
								<input type="button" class="btn_red2" value="PENDING" id="btnPending"/>
								<input type="button" class="btn_red2" value="EXPORT" id="btnExcel"/>
								<c:choose>
									<c:when test="${p_item_type_cd != 'PA'}">
										<input type="button" class="btn_red2" value="DTS" id="btnDts"/>
									</c:when>
								</c:choose>
							</div>
						</td>
					</tr>
				</table>
<%-- 			</c:when> --%>
<%-- 		</c:choose> --%>
		
		<div class="content" id="jqGridMainListDiv">
			
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" src="/js/getGridColModel${p_item_type_cd}.js" charset='utf-8'></script>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var menuId = '';
	
	var jqGridObj = $("#jqGridMainList");
	
	var deliverySeries;
	
	//기술 기획일 경우 부서 선택 기능
	if(typeof($("#p_sel_dept").val()) !== 'undefined'){
		getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
	}
	
	//달력 셋팅
	$(function() {
		
		$("#totalCnt").text(0);
		$("#selCnt").text(0);
		
		if($("#init_flag").val() == 'first') {
			
			if($("input[name=p_check_series]").val() == '') {
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			} else {
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()
						+"&p_project_no="+$("input[name=p_project_no]").val()
						+"&p_ischeck="+$("input[name=p_ischeck]").val()
						+"&p_chk_series="+$("input[name=p_check_series]").val(), null);
			} 
			
		} else {
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()
					+"&p_project_no="+$("input[name=p_project_no]").val()
					+"&p_ischeck="+$("input[name=p_ischeck]").val()
					+"&p_chk_series="+$("input[name=p_check_series]").val(), null);
			
		}
		
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
	});
	
	var getUscJobType = function(){
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			
			getAjaxTextPost(null, "sscAutoCompleteUscJobTypeList.do", form.serialize(), getUscJobTypeCallback);
		}
	}
	var getUscJobTypeCallback = function(txt){
		var arr_txt = txt.split("|");
	    $("#p_usc_job_type").autocomplete({
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
	
	var getDwgNos = function(){
		if($("input[name=p_project_no]").val() != ""){
			
			var chk_project_no = $("input[name=p_project_no]").val();
			if(chk_project_no.length != 5)
			{
				return;
			}
			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
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
	
	var vItemTypeCd = $("input[name=p_item_type_cd]").val();
	
	///js/getGridColModel.js에서 그리드의 colomn을 받아온다.
	var gridColModel = getMainGridColModel();
	var pageCnt = 0;
		
	$(document).ready(function(){
		
	    $("#p_rawmaterial").change(function(){
	        if($("#p_rawmaterial").is(":checked")){
				$("#p_tribon_flag").val("Y");
	        }else{
				$("#p_tribon_flag").val("N");
	        }
	    });
		
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : 'POST',
             postData : fn_getFormData('#application_form'),
             colModel: gridColModel,
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
             toolbar : [ false, "bottom" ],
			 scrollOffset : 17,
             multiselect: true,
             shrinkToFit: false,
             height: 460,
             pager: $("#bottomJqGridMainList"),
             rowList: [100,500,1000],
             rowNum: 100, 
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
 	   			else if(pgButton == 'next_bottomJqGridMainList'){
 	   				pages = currentPageIndex+1;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			} 
 	   			else if(pgButton == 'last_bottomJqGridMainList'){
 	   				pages = lastPageX;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'prev_bottomJqGridMainList'){
 	   				pages = currentPageIndex-1;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
 	   			else if(pgButton == 'first_bottomJqGridMainList'){
 	   				pages = 1;
 	   			rowNum = $('.ui-pg-selbox option:selected').val();
 	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
 	   			//$(this).jqGrid("clearGridData");
 	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");

			},
			onSelectAll: function(aRowids,status) {  
				if($("#cb_jqGridMainList").is(":checked") == true){
					var rows = $(this).getDataIDs();
					for(var i=0; i<rows.length; i++){
		    			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
		    			for(var j=0; j<deliverySeries.length; j++){
		    				if(item.project_no == deliverySeries[j].project_no){
		    					jqGridObj.jqGrid("setSelection", i+1);
		    					break;
		    				}
		    			}
		    		}	
					$("#cb_jqGridMainList").prop("checked", true);
				}
				else{
					jqGridObj.jqGrid("resetSelection");
				}
				
				var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				if(row_id.length > 0) {
					$("#selCnt").text(row_id.length);
				} else {
					$("#selCnt").text(0);
				}

				
			},
			 onSelectRow: function(aRowids,status) {     
				var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				if(row_id.length > 0) {
					$("#selCnt").text(row_id.length);
				} else {
					$("#selCnt").text(0);
				}
				  	
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
				        lastpageServer: data.total,
				    });

				    $("#totalEa").val(data.totalEa);
				    $("#totalWeight").val(data.totalWeight);
				    $("#totalLength").val(data.totalLength);
				    if(data.totalCnt > 0) {
				    	$("#totalCnt").text(data.totalCnt);
					} else {
						$("#totalCnt").text(0);
					}
				    $("#selCnt").text(0);
				    
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
					
					//그리드 툴팁 설정 (job상태, eco상태)
					$(this).setCell (rows[i], 'job_cd','', '', {title : item.job_status_desc});
					$(this).setCell (rows[i], 'eco_no','', '', {title : item.eco_states_code});
					
					
					//USC 끊어진 데이터는 붉게 처리
					if(item.upperaction == 'N') {
						$(this).setRowData(rows[i], false, {background: '#FF9999'});
					}
					
					//EMS_EXISTS_FLAG
					if($("#p_item_type_cd").val() == 'EQ') {
						if(item.ems_exists_flag == 'N') {
							$(this).setRowData(rows[i], false, {background: '#C98B68'});
						}
					}

					//부모 자식 관계 색깔 표시
					if(item.buy_buy_flag == 'Y') {
						jqGridObj.setRowData(rows[i], false, {background : "#ccddff"});
					}
					if(item.raw_level_flag == 'Y') {
						jqGridObj.setRowData(rows[i], false, {background : "#99bbff"});
					}
					
					//Raw/Material 체크시 음영
					if($("#p_tribon_flag").val() == "Y"){
						if(item.tribon_flag == 'Y') {
							jqGridObj.setRowData(rows[i], false, {background : "#dfdfdf"});
							var cbsdis = $("tr#"+rows[i]+".jqgrow > td > input.cbox");
							cbsdis.prop('disabled',true);
						}
					}
				}
				
				//그리드 리스트에서 딜리버리 호선 체크박스 숨김
				$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
					deliverySeries = data;
		    		for(var i=0; i<rows.length; i++){
		    			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
		    			for(var j=0; j<deliverySeries.length; j++){
		    				if(item.project_no == deliverySeries[j].project_no){
		    					$("#jqg_jqGridMainList_"+(i+1)).hide();
		    					//$("#jqg_jqGridMainList_"+(i+1)).prop("disabled", true);
		    					break;
		    				}else{
		    					$("#jqg_jqGridMainList_"+(i+1)).show();
		    					//$("#jqg_jqGridMainList_"+(i+1)).prop("disabled", false);
		    				}
		    			}
		    		}	
				},"json");
				
			},
			gridComplete : function() {
				var rows = jqGridObj.getDataIDs();

				for( var i = 0; i < rows.length; i++ ) {
					jqGridObj.jqGrid( 'setCell', rows[i], 'after_info	', '', { cursor : 'pointer'} );
					//jqGridObj.jqGrid( 'setCell', rows[i], 'eco_no', '', { cursor : 'pointer'} );
					jqGridObj.jqGrid( 'setCell', rows[i], 'dwg_check', '', { cursor : 'pointer'} );
					//jqGridObj.jqGrid( 'setCell', rows[i], 'job_cd', '', { cursor : 'pointer'} );
					//jqGridObj.jqGrid( 'setCell', rows[i], 'mother_code', '', { cursor : 'pointer'} );
					//jqGridObj.jqGrid( 'setCell', rows[i], 'item_code', '', { cursor : 'pointer'} );
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				/* 
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj.getRowData(rowid);
					if(item.tribon_flag != 'Y') {
						afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
					}
				}
				
				if(cm[iCol].name == 'dwg_check'){
					var item = jqGridObj.getRowData(rowid);
					if(item.tribon_flag != 'Y') {
						dwgView(item.dwg_file_name);
					}
				}
				
				//ECO 화면 팝업창
				if(cm[iCol].name == 'eco_no'){
					var item = jqGridObj.getRowData(rowid);
					if(item.tribon_flag != 'Y') {
						ecoNoClick(item.eco_no);
					}
				} */
				
				/* if(cm[iCol].name == 'job_cd'){
					var item = jqGridObj.getRowData(rowid);
					if(item.tribon_flag != 'Y') {
						motherCodeView(item.project_no , '', item.job_cd);
					}
				} */
				
				/* if(cm[iCol].name == 'mother_code'){
					var item = jqGridObj.getRowData(rowid);
					if(item.tribon_flag != 'Y') {
						motherCodeView(item.project_no, item.job_cd, item.mother_code);
					}
				} */
				
				/* if(cm[iCol].name == 'item_code'){
					var item = jqGridObj.getRowData(rowid);
					if(item.tribon_flag != 'Y') {
						motherCodeView(item.project_no ,item.mother_code, item.item_code);
					}
				} */
				
			},
			ondblClickRow : function( rowid, iCol, cellcontent, e ) {
				
				jqGridObj.saveCell(kRow, idCol );
				
				var rowData = jqGridObj.getRowData(rowid);
				var ssc_sub_id = rowData['ssc_sub_id'];
				var level = rowData['level'];
				var item_code = rowData['item_code'];
				var tribon_flag = rowData['tribon_flag'];
				var dwg_file_name = rowData['dwg_file_name'];
				
				var p_item_type_cd = $("input[name=p_item_type_cd]").val();

				if(p_item_type_cd == "PI") {
					if (cellcontent == 37) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 38) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "SU") {
					if (cellcontent == 28) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 29) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "VA") {
					if (cellcontent == 25) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 26) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "OU") {
					if (cellcontent == 26) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 27) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "CA") {
					if (cellcontent == 27) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 28) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "SE") {
					if (cellcontent == 30) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 31) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "TR") {
					if (cellcontent == 28) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 29) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "GE") {
					if (cellcontent == 24) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 25) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				} else if(p_item_type_cd == "EQ") {
					if (cellcontent == 25) {
						if(tribon_flag != 'Y') {
							dwgView(dwg_file_name);
						}
					}
					if (cellcontent == 26) {
						afterInfoClick(ssc_sub_id, level, item_code);
					}
				}
				
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 70);
     	//resizeJqGridWidth($(window),jqGridObj, $("#jqGridMainListDiv"),0.48);
		
		//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			if(uniqeValidation()){
			
				fn_search();
			}
		});
		
		//Add 버튼 클릭 시 
		$("#btnAdd").click(function(){
			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			
			//도면 번호 체크
			var rtn = fn_dwg_validataion();
			
			if(!rtn){
				return false;
			}
			
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			$("input[name=p_ischeck]").val(p_ischeck);
			
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			$("input[name=p_check_series]").val(ar_series);
			
			if(uniqeValidation()){
				
				var p_arr = new Array();
				var p_arrDistinct = new Array();
				var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				
				for(var i=0; i<selarrrow.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
					
					if(item.usc_job_type == "") {
						item.usc_job_type = "NULL";
					}
					
					p_arr.push(item.master_ship + "@" + item.dwg_no + "@" + item.block_no + "@" + item.stage_no + "@" + item.str_flag + "@" + item.usc_job_type);
				}
				
				$(p_arr).each(function(index, item) {
					if($.inArray(item, p_arrDistinct) == -1) {
						p_arrDistinct.push(item);
					}
				});
				
				$("#p_arrDistinct").val(p_arr);
				
				form = $('#application_form');
				
				form.attr("action", "sscAddMain.do");
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			}
		});
		
		//Bom 버튼 클릭 시 
		$("#btnBom").click(function(){			
			
			var rtn = true;
			
		
			//행을 읽어서 키를 뽑아낸다.
			var ssc_sub_id = new Array();
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}

			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				if(item.eco_no != ""){
					
					alert("이미 ECO가 연계되어 있는 대상입니다.");					
					//alert("이미 ECO가 연계되어 있는 대상이 있습니다.");			
					rtn = false;
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			if(!rtn){
				return false;
			}
			
			form = $('#application_form');
			form.attr("action", "sscBomMain.do?p_ssc_sub_id="+ssc_sub_id);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		//All BOM 버튼 클릭 시 
		$("#btnAllBom").click(function(){
			
			var row_id = jqGridObj.jqGrid('getDataIDs');
			var ssc_sub_id = new Array();
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				ssc_sub_id.push(item.ssc_sub_id);
			}
			

			if(confirm("검색된 모든 ITEM을 일괄 BOM연계 하시겠습니까?")){
				
				//시리즈 배열 받음
				var ar_series = new Array();
				for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
					ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
				}				
				window.showModalDialog( "popUpSscAllBom.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val() 
						                               + "&p_chk_series="+ar_series
						                               + "&p_dwg_no="+$("input[name=p_dwg_no]").val()
						                               + "&p_block_no="+$("input[name=p_block_no]").val()
						                               + "&p_stage_no="+$("input[name=p_stage_no]").val()
						                               + "&p_str_flag="+$("input[name=p_str_flag]").val()
						                               + "&p_attr1="+$("input[name=p_attr1]").val()
						                               + "&p_attr2="+$("input[name=p_attr2]").val()
						                               + "&p_attr5="+$("input[name=p_attr5]").val()
						                               + "&p_desc_detail="+$("input[name=p_desc_detail]").val()
						                               + "&p_dept_code="+$("input[name=p_dept_code]").val()
						                               + "&p_mother_code="+$("input[name=p_mother_code]").val()
						                               + "&p_item_code="+$("input[name=p_item_code]").val()
						                               + "&p_start_date="+$("input[name=p_start_date]").val()
						                               + "&p_end_date="+$("input[name=p_end_date]").val()
						                               + "&p_state_flag="+$("select[name=p_state_flag]").val()
						                               + "&p_is_eco="+$("select[name=p_is_eco]").val()
						                               + "&p_release="+$("select[name=p_release]").val()
						                               + "&p_upperaction="+$("select[name=p_upperaction]").val()
						                               + "&p_piece_no="+$("input[name=p_piece_no]").val()
						                               + "&p_job_status="+$("select[name=p_job_status]").val(),
						window,
						"dialogWidth:500px; dialogHeight:200px; center:on; scroll:off; status:off" );
				
				//window.showModalDialog( "popUpSscAllBom.do",window,"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
			}
			
		});
		
		
		//Delete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			$("input[name=p_ischeck]").val(p_ischeck);
			
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				if(item.state_flag == "D"){
					alert("선택한 Data는 Delete 대상이 아닙니다.");			
					rtn = false;
					return false;
				}
				
				if(item.eco_states_code == 'REVIEW') {
					alert('선택한 Data는 Delete 대상이 아닙니다.');
					return false;
				}
				
				/* if(item.release == 'N' && item.eco_states_code != 'CREATE') {
					alert("선택한 Data는 Delete 대상이 아닙니다.");
					return false;
				} */
				
				if(item.tribon_flag == 'Y') {
					alert("선택한 Data 중에 R/M 항목이 존재합니다.");
					return false;
				}
				
				//2017-03-21 양동협대리 요청으로 job 완료도 삭제가능하도록
				//JOB STATUS 완료인 것 BOM작업 불가 			
// 				if(item.job_status == "4"){
// 					alert("선택한 Data 중 JOB완료 항목이 있습니다.");			
// 					rtn = false;
// 					return false;
// 				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			$("input[name=p_check_series]").val(ar_series);
			
			form = $('#application_form');
			form.attr("action", "sscDeleteMain.do?p_ssc_sub_id="+ssc_sub_id+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		//Move 버튼 클릭 시 
		$("#btnModify").click(function(){

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				//BUY-BUY 아이템 체크
				if(item.buy_buy_flag == "Y"){
					alert("Buy-Buy품목은 Modify 대상이 아닙니다.");			
					rtn = false;
					return false;
				}
				
				//아이템 체크 Validation				
				if(item.state_flag == "D"){
					alert("상태값이 'D'인 Data는 Modify 대상이 아닙니다.");			
					rtn = false;
					return false;
				}
				
				if(item.eco_states_code == 'REVIEW') {
					alert('선택한 Data는 Modify 대상이 아닙니다.');
					return false;
				}
				
				/* if(item.release == 'N' && item.eco_states_code != 'CREATE') {
					alert("선택한 Data는 Modify 대상이 아닙니다.");
					return false;
				} */
				
				//2017-03-21 양동협대리 요청으로 job 완료도 삭제가능하도록
				//JOB STATUS 완료인 것 BOM작업 불가 			
// 				if(item.job_status == "4"){
// 					alert("선택한 Data 중 JOB완료 항목이 있습니다.");			
// 					rtn = false;
// 					return false;
// 				}
				
				if(item.tribon_flag == 'Y') {
					alert("선택한 Data 중에 R/M 항목이 존재합니다.");
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			$("input[name=p_ischeck]").val(p_ischeck);
			
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			$("input[name=p_check_series]").val(ar_series);
			
			form = $('#application_form');
			form.attr("action", "sscModifyMain.do?p_ssc_sub_id="+ssc_sub_id);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		//Pending 버틀 클릭 시
		$("#btnPending").click(function(){
			
			//메뉴ID를 가져오는 공통함수 
			getMenuId("pendingMain.do", callback_MenuId);
			
			//팝업으로 대체!
			var sURL = "/pendingMain.do?menu_id="+menuId+"&up_link=bom&p_project_no="+$("input[name=p_project_no]").val();
			var popOptions = "width=1500, height=700, resizable=yes, scrollbars=yes, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		//Restore 버튼 클릭 시 
		$("#btnRestore").click(function(){

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			var rtn = true;
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				if(item.eco_no != "") {
					alert("선택한 Data는 Restore 대상이 아닙니다.");
					return false;
				}
				
				if( item.release == 'Y' ) {
					alert("선택한 Data는 Restore 대상이 아닙니다.");
					return false;
				}
				
				if(item.tribon_flag == 'Y') {
					alert("선택한 Data 중에 R/M 항목이 존재합니다.");
					return false;
				}
				
				//아이템 체크 Validation				
				//if(item.state_flag == "A" && item.eco_no == "" ){
				if(item.state_flag == "" ){
					alert("선택한 Data는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
				
				//JOB STATUS 완료인 것 BOM작업 불가 			
// 				if(item.job_status == "4"){
// 					alert("선택한 Data 중 JOB완료 항목이 있습니다.");			
// 					rtn = false;
// 					return false;
// 				}
				
				//ECO STATUS REVIEW인 것 BOM작업 불가 			
				if(item.eco_states_code == "REVIEW"){
					alert("선택한 Data 중 ECO REVIEW 항목이 있습니다.");			
					rtn = false;
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			if(!rtn){
				return false;
			}
			
			if(confirm("Restore 하시겠습니까?")){
				var form = $('#application_form');
				$(".loadingBoxArea").show();
				$.post("sscRestoreAction.do?p_ssc_sub_id="+ssc_sub_id,form.serialize(),function(json)
				{	
					alert(json.resultMsg);
					$(".loadingBoxArea").hide();
					fn_search();
				},"json");
			}
		});
		
		//Cancel 버튼 클릭 시 
		$("#btnCancel").click(function(){

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var ssc_sub_id = new Array();
			var rtn = true;
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				if(item.state_flag == "" && item.eco_no == "" ){
					alert("선택한 Data는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
				
				if(item.release_desc != 'CREATE') {
					alert("ECO CANCEL 대상이 없습니다.");
					return false;
				}
				
				if(item.tribon_flag == 'Y') {
					alert("선택한 Data 중에 R/M 항목이 존재합니다.");
					return false;
				}
				
				ssc_sub_id.push(item.ssc_sub_id);
			}
			
			if(!rtn){
				return false;
			}
			
			if(confirm("Cancel 하시겠습니까?")){
				var form = $('#application_form');
				$(".loadingBoxArea").show();
				$.post("sscCancelAction.do?p_ssc_sub_id="+ssc_sub_id,form.serialize(),function(json)
				{	
					alert(json.resultMsg);
					$(".loadingBoxArea").hide();
					fn_search();
				},"json");
			}
		});
		
		//Save 버튼 클릭 시 
		$("#btnSave").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(confirm("Save 하시겠습니까?")){
				
				var changeResultRows =  getChangedGridInfo("#jqGridMainList");
				
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
					fn_search();
				});

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
			
			for(var i=0; i<gridColModel.length; i++ ){
				if(gridColModel[i].hidden != true){
					colName.push(gridColModel[i].label);
					dataName.push(gridColModel[i].name);
				}
			}
			
			form = $('#application_form');

			$("input[name=p_is_excel]").val("Y");
			//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
			form.attr("action", "sscMainExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName+"&p_chk_series="+ar_series);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
		});
		
		//Cable Type Manager
		$("#btnCableType").click(function(){
			var sURL = "sscCableTypeMain.do";
			var popOptions = "width=1410, height=700, resizable=yes, scrollbars=yes, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		//Structure Name
		$("#btnStructure").click(function(){
			var sURL = "sscStructureMain.do";
			var popOptions = "width=800, height=730, resizable=yes, scrollbars=no, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		//Row Material 정보 출력
		$("#p_rawmaterial").click(function(){
			$("#btnSearch").click();
		});
		
		$("#btnDts").click(function(){
			var str = $("input[name=p_dwg_no]").val();
			var dwgNo = "";
			var blockNo = "";
			for(var i=0; i<str.length; i++){
				if(i<5) dwgNo += str[i];
				else blockNo += str[i];
			}
			
			//메뉴ID를 가져오는 공통함수 
			getMenuId("dwgSystem.do", callback_MenuId);
			
			var sURL = "dwgSystem.do?menu_id=" + menuId + "&up_link=dwg&shipNo="
				+ $("input[name=p_project_no]").val() + "&dwgNo=" + dwgNo + "&blockNo=" +blockNo;
			var popOptions = "width=1500, height=730, resizable=yes, scrollbars=no, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		//window resize시 테이블 사이즈 조정.
		$( window ).resize(function() {
			fnTableResize();
		});
		
		//key evant 
		$(".commonInput").keypress(function(event) {
		  if (event.which == 13) {
		        event.preventDefault();
		        fn_search();
		        //$('#btnSearch').click();
		    }
		});
	});
	
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
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	

	function fn_search() {
		
		//history.go에서 시리즈 파라미터 유지를 위하여 값을 first에서 next로 조절
		$("#init_flag").val("next");
		
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});

		$("input[name=p_is_excel]").val("N");
		$("input[name=pageYn]").val("N");
		
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		if($("input[name=page_flag]").val() == '') {
			if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
		}
		
		if($("input[name=p_page_cnt]").val() != ''){
			pageCnt = $("#p_page_cnt").val();
		} else {
			pageCnt = $('.ui-pg-selbox option:selected').val();
		}
		
		$("input[name=p_check_series]").val(ar_series);

		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
		
		var sUrl = "sscMainList.do?p_chk_series="+ar_series;
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			rowNum : pageCnt,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		printCheckSelectCnt();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		printCheckSelectCnt();
	}
	
	
	//체크 유무 validation
	var isChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}

	//메시지 Call
	var afterDBTran = function(json)
	{
	 	var msg = "";
		for(var keys in json)
		{
			for(var key in json[keys])
			{
				if(key=='Result_Msg')
				{
					msg=json[keys][key];
				}
			}
		}
		alert(msg);		
		$("#btnSearch").click();
	}

	// 상태에 따른 진행 Validation 
	// stateval : 허용 상태. 
	// msg : 실패시 메시지.
	var isNotProcessState = function(stateval, msg){
		var rtn = true;
		$("input[name=p_chkItem]").each(function(){
			if($(this).is(":checked")){
				if(stateval.indexOf($(this).parent().parent().find("td").eq(1).text()) < 0){
					alert(msg);
					rtn = false;
					return false;
				}	
			}
		})	
		return rtn;
	}
	
	//상태에 따라서 Display 조정
	var onLoadDisplayState  = function(){
		if($("input[name=p_hd_selrev]").val() == "Final" || $("input[name=p_hd_selrev]").val() == "" ){
			ActionDisplayOk();
		}else{
			ActionDisplayNone();			
		}
	}
	
	//Display 일괄 적용
	var ActionDisplayNone = function(){
		$("#btnDelete").attr("disabled", "disabled");
		$("#btnModify").attr("disabled", "disabled");
		$("#btnAdd").attr("disabled", "disabled");
		$("#btnBom").attr("disabled", "disabled");
		$("#btnSave").attr("disabled", "disabled");
		$("#btnRestore").attr("disabled", "disabled");		
	}
	
	var ActionDisplayOk = function(){
		$(".buttonArea input").attr("disabled", false);
	}
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".required").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return;
			}
		});
		return rnt;
	}

	//rev_no Check Event
	var RevNoCheck = function(obj){
		var obj_val = $(obj).val();
		if(obj_val.length == 1){
			$(obj).val("0"+obj_val);
		}
	}
	
	//After Info 버튼 클릭 시 		
	var afterInfoClick = function (p_ssc_sub_id, level, buyItemCode){
		
		var sURL = "sscAfterInfoMain.do?p_ssc_sub_id="+p_ssc_sub_id+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_level="+level+"&p_buy_item_code="+buyItemCode;
		var popOptions = "width=1200, height=700, resizable=yes, scrollbars=yes, status=yes";
		
		var popupWin = window.open(sURL, "afterInfoPopup", popOptions);
		
		setTimeout(function(){
			popupWin.focus();
		 }, 500);
	    
	}
	
	function jobCdFormatter(cellvalue, options, rowObject ) {
		if(cellvalue == null) {
			return '';
		} else {
			return "<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"',"+"'','"+rowObject.job_cd+"')\">"+cellvalue+"</a>";
		}
	}
	
	function motherCodeFormatter(cellvalue, options, rowObject ) {
		if(cellvalue == null) {
			return '';
		} else {
			return "<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"','"+rowObject.job_cd+"','"+cellvalue+"')\">"+cellvalue+"</a>";
		}
	}
	
	function itemCodeFormatter(cellvalue, options, rowObject ) {
		
		if(cellvalue == null) {
			return '';
		} else {
			return "<a ondblclick=\"javascript:itemCodeView('"+cellvalue+"','"+rowObject.item_catalog+"')\">"+cellvalue+"</a>";
		}
	}
	
	function ecoFormatter(cellvalue, options, rowObject ) {
		
		if(cellvalue == null) {
			return '';		
		} else {
			return "<a ondblclick=\"javascript:ecoNoClick('"+cellvalue+"')\">"+cellvalue+"</a>";
		}
	}
	
	function unFormatter(cellvalue, options, rowObject ) {
		return cellvalue;
	}
	
	//Eco No. 버튼 클릭 시 		
	var ecoNoClick = function (eco_no){
		
		//메뉴ID를 가져오는 공통함수 
		getMenuId("eco.do", callback_MenuId);
		
		var sURL = "eco.do?ecoName="+eco_no+"&menu_id=" + menuId + "&popupDiv=Y&checkPopup=Y";
		var popOptions = "width=1200, height=700, resizable=yes, scrollbars=yes, status=yes";
		var win = window.open(sURL, "", popOptions); 
	    
		setTimeout(function(){
			win.focus();
		 }, 500);
	}
	
	//motherCodeView 버튼 클릭 시 		
	var motherCodeView = function (projectNo, motherCode, itemCode) {
		
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
	
	//motherCodeView 버튼 클릭 시 		
	var itemCodeView = function (itemCode, itemCatalog){
		
		/* var sURL = "sscBomStatus.do?menu_id=M00181&up_link=bom&project_no="
			+ projectNo + "&mother_code=" + motherCode + "&item_code=" +itemCode;
		var popOptions = "width=1200, height=730, resizable=yes, scrollbars=no, status=yes"; 
		var win = window.open(sURL, "bomStatus", popOptions); 
		
		setTimeout(function(){
			win.focus();
		 }, 1000); */
		
		var sURL = "popUpItemDetail.do?p_item_code="+itemCode+"&p_item_catalog="+itemCatalog;
		var popOptions = "width=800, height=810, resizable=no, scrollbars=no, status=no";
		var popupWin = window.open(sURL, "popUpItemDetail", popOptions);
		setTimeout(function(){
			popupWin.focus();
		 }, 100);
		
		
	}

	//Search 이후 페이징 기능 호출
	var SearchCallback = function(){
		//페이징 기능  Laoding 		
		$("#SSCMainPagingArea").load("./TBC/tbc_CommonPaging.jsp",{
		    printrow: $("input[name=p_printrow]").val(),
		    rowcnt: $("input[name=p_pd_cnt]").val(),
		    nowpage : $("input[name=p_nowpage]").val()
		}, function( response, status, xhr ) {
			if(typeof($("input[name=p_pd_cnt]").val()) != 'undefined'){
				$("#tCnt").text(Number($("input[name=p_pd_cnt]").val().toString()));
			}else{
				$("#tCnt").text("0");
			}
		});
		
		//테이블 사이즈 조정	
		if($('#MainArea').html() != ""){
		    fnTableResize();
	    }
	}
	
	var fnTableResize = function(){
		 var Cheight = $(window).height()-244;
	    $('.commonListBody').css({'height':Cheight+'px'});
	}

	//Page Click
	var go_page = function(pageno, printrow){

		$("input[name=p_nowpage]").val(pageno);
	
		//Uniqe Validation
		if(uniqeValidation()){
			form = $('#application_form');
			//모두 대문자로 변환
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			
			//필수 파라미터 S	
			$("input[name=p_daoName]").val("TBC_MAIN");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("mainList");
			$("input[name=p_is_excel]").val("N");
			//필수 파라미터 E	
			getAjaxHtmlPost($("#MainArea"),"/bom/sscMainTotalList.do",form.serialize(),null, null, SearchCallback);
		}
	}
	
	var printCheckSelectCnt = function(){
		$("#tSelCnt").text(Number($("input[name=p_chkItem]:checked").length));
	}
    
    var DeptOnChange = function(obj){
    	$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
    	$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
    }
    
    //도면번호 바르게 입력하였는지 판단
    var fn_dwg_validataion = function(){
    	if( (" "+$("#p_dwg_no").val()).indexOf("*") > 0){
    		alert("도면 번호를 '*'를 제외한 정확한 번호로 입력하십시오.");
    		$("#p_dwg_no").focus();
    		return false;
    	}
    	return true;
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
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
	
</script>
</body>

</html>