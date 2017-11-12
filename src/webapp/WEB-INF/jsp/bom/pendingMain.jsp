<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>Pending Management</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.onMs{background-color:#FFFA94;}
	input[type=text] {text-transform: uppercase;}
	.btn_blue {
		width: 70px;
	}
	.header .searchArea .seriesChk{
		width:100%; 
		height:36px;
	}
	.pendingType {color:#324877;
				font-weight:bold; 
			 	}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<input type="hidden" name="autoSearch" value="<c:out value="${autoSearch}" />" />	
	<input type="hidden" name="p_filename" value="" />	
	<input type="hidden" name="p_nowpage" value="1" />	
	<input type="hidden" name="p_bom_type" value="" />
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" id="pageYn" name="pageYn" value="N" />
	<input type="hidden" id="p_arrDistinct" name="p_arrDistinct"/>
	<input type="hidden" name="p_grcode" value="<c:out value="${loginUser.gr_code}" />" />	
	<input type="hidden" name="login_dept" value="<c:out value="${loginUser.dwg_dept_code}" />" />	
	<input type="hidden" name="temp_project_no" value="" />
	<input type="hidden" name="p_check_series" value="${p_chk_series}" />
	<input type="hidden" name="p_ischeck" value="${p_ischeck}" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	<!-- ALL BOM ECO 번호 -->
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		Pending Manager
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="1200"/>
			<col width="*"/>
			<tr>
				<td class="pendingType" style="border-right:none;">
					PROJECT
					<input type="text" class = "required"  name="p_project_no" alt="Project"  style="width:50px;" value="${p_project_no}"  onblur="javascript:getDwgNos();" /> &nbsp;
					DWG NO.
					<input type="text" id="p_dwg_no" name="p_dwg_no" class="commonInput" style="width:60px;" value="${p_dwg_no}" alt="DWG NO."/> &nbsp;
					BLOCK
					<input type="text" class="commonInput" name="p_block_no" value="" style="width:40px;" /> &nbsp;
					STAGE
					<input type="text" class="commonInput" name="p_stage_no" style="width:50px;" value="" /> &nbsp;
					STR
					<select name="p_str_flag" id="p_str_flag" class="commonInput" style="width:45px;"> &nbsp;
						<option value="ALL" >ALL</option>
					</select>
					TYPE
					<input type="text" class="commonInput" name="p_usc_job_flag" style="width:50px;" value="" /> &nbsp;
					ECO NO.
					<input type="text" class="commonInput" name="p_eco_no" value="" style="width:70px;"  /> &nbsp;
					DEPT
					<c:choose>
						<c:when test="${loginUser.gr_code=='M1'}">
							<select name="p_sel_dept" id="p_sel_dept" style="width:130px;" onchange="javascript:DeptOnChange(this);" >
							</select>
							<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
							<input type="hidden" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  />
						</c:when>
						<c:otherwise>
						    <input type="hidden" name="p_sel_dept" value=""  />
							<input type="text" name="p_dept_name" class="disableInput" value="<c:out value="${loginUser.dwg_dept_name}" />" style="width:130px;" readonly="readonly" />
							<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
						</c:otherwise>
					</c:choose> &nbsp;
					USER
					<select name="p_sel_user" id="p_sel_user" style="width:65px;" onchange="javascript:UserOnChange(this);">
					</select>
					<input type="hidden" id="p_user_id" name="p_user_id" class="commonInput"  value="<c:out value="${loginUser.user_id}" />" />
					<input type="hidden" id="p_user_name" name="p_user_name" class="commonInput"  value="<c:out value="${loginUser.user_name}" />" /> &nbsp;
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<c:if test="${userRole.attribute2 == 'Y'}">
							<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
						</c:if>
						<c:if test="${userRole.attribute3 == 'Y'}">
								<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
						</c:if>
						<input type="button" class="btn_blue2" value="MOVE" id="btnModify"/>
						<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
						</c:if>
					</div>
				</td>
			</tr>
		</table>
		<table class="searchArea2">
			<col width="1220"/><!-- STATE유무 -->
			<col width="*"/>
			<tr>
				<td class="pendingType" >
					STATE
					<select name="p_state_flag" class="commonInput" style="width:45px;">
						<option value="ALL" selected="selected">ALL</option>
						<option value="A" >A</option>
						<option value="D" >D</option>
						<option value="C" >C</option>
<!-- 						<option value="ACT" >Act</option> -->
					</select> &nbsp;
					JOB ITEM
					<input type="text" class="commonInput bigInput" name="p_job_cd" value="" style="width:90px;"  /> &nbsp;
					JOB DESC
					<input type="text" class="commonInput bigInput" name="p_job_desc" value="" style="width:90px;"  /> &nbsp;
					PENDING
					<input type="text" class="commonInput bigInput" name="p_mother_code" value="" style="width:90px;"  /> &nbsp;
					생성일자
					<input type="text" name="p_start_date" id="p_start_date" class="commonInput" style="width:60px;" value=""/>
					~
					<input type="text" name="p_end_date" id="p_end_date" class="commonInput" style="width:60px;" value=""/> &nbsp;
					WORK
					<select name="p_work_flag" class="commonInput" style="width:45px;">
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
					PENDING
					<select name="p_pending_flag" class="commonInput" style="width:45px;">
						<option value="ALL">ALL</option>
						<option value="Y" selected="selected" >Y</option>
						<option value="N" >N</option>
					</select> &nbsp;
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
				</td>	
					
				</td>
				<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="BOM" id="btnBom"/>
					<c:if test="${userRole.attribute3 == 'Y'}">
						<input type="button" class="btn_blue2" value="RESTORE" id="btnRestore"/>
						<input type="button" class="btn_blue2" value="CANCEL" id="btnCancel"/>
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
		
		<table class="searchArea2">
			<col width="*"/>
			<%-- <col width="300"/>
			<col width="300"/> --%>
			<tr>
				<td class="bdl_no" style="font:bold; font-size:15px; border-left:none;">
					※ 전체 : <label id="totalCnt" name="totalCnt" style="color: blue;" ></label>건 / 선택 : <label id="selCnt" name="selCnt" style="color: red;" ></label>건
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_red2" value="JOB" id="btnUnit"/>
						</c:if> 
						<c:if test="${userRole.attribute5 == 'Y'}">
							<input type="button" class="btn_red2" value="EXPORT" id="btnExport"/>
						</c:if>
					</div>
				</td>
			</tr>
		</table>
		
		<div class="content">
			<table id="pendingMainList"></table>
			<div id="ppendingMainList"></div>
		</div>
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" src="/js/getGridColModelPENDING.js" charset='utf-8'></script>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var tableId = '';
	var resultData = [];
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var cmtypedesc;
	var menuId = '';
	
	var deliverySeries;
	
	var jqGridObj = $("#pendingMainList");

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
		
		//getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		
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
	
	//마스터에 따른 시리즈 호선 받기
	/*  var getSeriesCheckBox = function(obj){
		
		var select = $(obj).find("option:selected").val();
		
		if(select == 'M' && $("input[name=p_project_no]").val() != "") {
			//시리즈 호선 받기
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N", null);
			$(".series").show();	
		} else {
			$(".series").hide();
		}
		
	} */ 
	
	//AutoComplete 도면리스트 받기
	var getDwgNos = function(){
		var chk_project_no = $("input[name=p_project_no]").val();		
		if(chk_project_no.length != 5)
		{
			return;
		}
		
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		//getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N", null);
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		/* var select = $("select[name=p_project_type]").find("option:selected").val();
		if(select == 'M' && $("input[name=p_project_no]").val() != "") {
			//모두 대문자로 변환
			
			//시리즈 호선 받기
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N", null);
			$(".series").show();	
			
		} else {
			$(".series").hide();
		} */
		
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			
			getAjaxTextPost(null, "pendingAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
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
	
	var getDetpCodeCallback = function(){
		DeptOnChange();
	} 
	
	///js/getGridColModel.js에서 그리드의 colomn을 받아온다.
	var gridColModel = getMainGridColModel();
	
	$(document).ready(function(){
		
		//기술 기획일 경우 부서 선택 기능
		if(typeof($("#p_sel_dept").val()) !== 'undefined'){
			getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
		}
		
		//User 선택할 수 있도록 수정.
		//Select Box User 받아옴.
		getUserList($("input[name=p_dept_code]").val());
		
		//STR 받기
		getAjaxHtml($("#p_str_flag"),"commonSelectBoxDataList.do?sb_type=all&p_query=getPendingStr", null, null);
		
		var objectHeight = gridObjectHeight(1);
		
		jqGridObj.jqGrid({
            datatype: 'json',
            url:'',
            mtype : 'POST',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            gridview: true,
            cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
            viewrecords: true,
            autowidth: true,
            height : objectHeight,
            pager: $( '#ppendingMainList' ),
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
            rowList:[100,500,1000],
	        rowNum:100,
            multiselect: true,
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
// 		     	$(this).jqGrid( "clearGridData" );
		    	
		    	/* this is to make the grid to fetch data from server on page click*/
// 	 			$(this).setGridParam( { datatype : 'json',  postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
		    	
	            var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt(jqGridObj.getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt(jqGridObj.getGridParam("lastpage"));  
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
	   			else if(pgButton == 'next_ppendingMainList'){
	   				pages = currentPageIndex+1;
	   				rowNum = $('.ui-pg-selbox option:selected').val();
	   			} 
	   			else if(pgButton == 'last_ppendingMainList'){
	   				pages = lastPageX;
	   				rowNum = $('.ui-pg-selbox option:selected').val();
	   			}
	   			else if(pgButton == 'prev_ppendingMainList'){
	   				pages = currentPageIndex-1;
	   				rowNum = $('.ui-pg-selbox option:selected').val();
	   			}
	   			else if(pgButton == 'first_ppendingMainList'){
	   				pages = 1;
	   				rowNum = $('.ui-pg-selbox option:selected').val();
	   			}
	   			else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");
		    	
			 },
			 onSelectAll: function(aRowids,status) {     
				//전체 선택 눌럿을때 딜리버리 호선은 선택 안되도록 함
				if($("#cb_pendingMainList").is(":checked") == true){
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
					$("#cb_pendingMainList").prop("checked", true);
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
			 gridComplete: function () {
				var rows = $( "#pendingMainList" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var work = $( "#pendingMainList" ).getCell( rows[i], "ssc_work_flag" );
					if(work == 'Y') {
						$( "#pendingMainList" ).jqGrid( 'setCell', rows[i], 'ssc_work_flag', '', { cursor : 'pointer' } );
					}
				}
				/* $("td:eq(17)", $("#pendingMainList tr")).mouseover(function(e) {
					$(this).css("text-decoration", "underline");
					$(this).css("cursor", "pointer");
				});
				$("td:eq(17)", $("#pendingMainList tr")).mouseout(function (e) {
					$(this).css("text-decoration", "none");
				}); */
					
			 },
  			 loadComplete: function (data) {
				var $this = $(this);
				
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        //datatype: 'local',
				        data: data.rows,
				        pageServer: data.page,
				        recordsServer: data.records,
				        lastpageServer: data.total
				    });
				    
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
				
				//그리드 툴팁 설정 (job상태, eco상태)
				var rows = $(this).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
					$(this).setCell (rows[i], 'job_start','', '', {title : item.job_status_desc});
					
					//USC 끊어진 데이터는 붉게 처리
					if(item.upperaction == 'N') {
						$(this).setRowData(rows[i], false, {background: '#FF9999'});
					}
				}
				
				//그리드 리스트에서 딜리버리 호선 체크박스 숨김
				$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
					deliverySeries = data;
		    		for(var i=0; i<rows.length; i++){
		    			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
		    			for(var j=0; j<deliverySeries.length; j++){
		    				if(item.project_no == deliverySeries[j].project_no){
		    					$("#jqg_pendingMainList_"+(i+1)).hide();
		    					break;
		    				}else{
		    					$("#jqg_pendingMainList_"+(i+1)).show();
		    				}
		    			}
		    		}	
				},"json");
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				/* jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'ssc_work_flag'){
					var item = jqGridObj.getRowData(rowid);
					if(item.ssc_work_flag == 'Y') {
						workClick(item.temp_mother_code, item.project_no);
					}
				} */
			},
			ondblClickRow : function( rowid, iCol, cellcontent, e ) {
				
				jqGridObj.saveCell(kRow, idCol );
				
				var rowData = jqGridObj.getRowData(rowid);
				var project_no = rowData['project_no'];
				var temp_mother_code = rowData['temp_mother_code'];
				var ssc_work_flag = rowData['ssc_work_flag'];

				if (cellcontent == 18 && ssc_work_flag == "Y") {
					workClick(temp_mother_code, project_no);
				}
				
			},
			afterInsertRow : function(rowid, rowdata, rowelem){
				jQuery("#"+rowid).css("background", "#0AC9FF");
	        }
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 90 );
    	
	  	//그리드 버튼 숨김
		$( "#pendingMainList" ).jqGrid( 'navGrid', "#ppendingMainList", {
			refresh : false,
			search : false,
			edit : false,
			add : false,
			del : false
		} );
	  	
		<c:if test="${userRole.attribute1 == 'Y'}">
		//Refresh
		$( "#pendingMainList" ).navButtonAdd( '#ppendingMainList', {
			caption : "",
			buttonicon : "ui-icon-refresh",
			onClickButton : function() {
				fn_search();
			},
			position : "first",
			title : "Refresh",
			cursor : "pointer"
		} );
		</c:if>
		
		/* <c:if test="${userRole.attribute3 == 'Y'}">
		//Del 버튼
		$( "#pendingMainList" ).navButtonAdd( '#ppendingMainList', {
			caption : "",
			buttonicon : "ui-icon-minus",
			onClickButton : deleteRow,
			position : "first",
			title : "Del",
			cursor : "pointer"
		} );
		</c:if> */
		
		/* <c:if test="${userRole.attribute2 == 'Y'}">
		//Add 버튼
		$( "#pendingMainList" ).navButtonAdd( '#ppendingMainList', {
			caption : "",
			buttonicon : "ui-icon-plus",
			onClickButton : addChmResultRow,
			position : "first",
			title : "Add",
			cursor : "pointer"
		});
		</c:if> */
		
		//조회 버튼
		$( "#btnSearch" ).click( function() {
			fn_search();
		} );
		
		$( "#btnModify" ).click( function() {
			
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			var pending_id = new Array();
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				/* if(item.state_flag == "D"){
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
				if(item.upperaction != 'N') {
					alert("선택한 Data는 Modify 대상이 아닙니다.");
					return false;
				}
				
				
				if(item.release == 'N') {
					alert("선택한 Data는 Modify 대상이 아닙니다.");
					return false;
				}
				
				if(item.mother_code == '') {
					alert("선택한 Data는 Modify 대상이 아닙니다.");
					return false;
				}
				
				//JOB STATUS 완료인 것 BOM작업 불가 			
				if(item.job_status == "4"){
					alert("선택한 Data 중 JOB완료 항목이 있습니다.");			
					rtn = false;
					return false;
				}
				
				/* 
				if(item.tribon_flag == 'Y') {
					alert("선택한 Data 중에 R/M 항목이 존재합니다.");
					return false;
				} */
				
				pending_id.push(item.pending_rowid);
			}
			
			form = $('#application_form');
			form.attr("action", "pendingModifyMain.do?p_pending_id="+encodeURIComponent(pending_id));
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		} );
		
		//Add 버튼 클릭 시 
		$("#btnAdd").click(function(){
			
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			if($("input[name=p_dept_code]").val() == 'ALL') {
				alert("부서를 선택해 주세요.");
				return false;
			}
			
			if(uniqeValidation()){
				
				var p_ischeck = 'N';
				if(($("#SerieschkAll").is(":checked"))){
					p_ischeck = 'Y';
				}
				
				//시리즈 배열 받음
				var ar_series = new Array();
				for(var i=0; i < $("input[name=p_series]").size(); i++ ){
					ar_series[i] = $("input[name=p_series]").eq(i).val();
				}
				
				var p_arr = new Array();
				var p_arrDistinct = new Array();
				var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				
				for(var i=0; i<selarrrow.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
					
					if(item.usc_job_type == "") {
						item.usc_job_type = "NULL";
					}
					
					p_arr.push(item.ship_type + "@" + item.project_no + "@" + item.block_no + "@" + item.str_flag + "@" + item.job_catalog + "@" + item.usc_job_type);
				}
				
				$(p_arr).each(function(index, item) {
					if($.inArray(item, p_arrDistinct) == -1) {
						p_arrDistinct.push(item);
					}
				});
				
				$("#p_arrDistinct").val(p_arrDistinct);
				
				form = $('#application_form');
				form.attr("action", "pendingAddMain.do?p_dept_code="+$("input[name=p_dept_code]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series);
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			}
		});
		
		//btnDelete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			if(uniqeValidation()){
				
				var p_ischeck = 'N';
				/* if(($("#SerieschkAll").is(":checked"))){
					p_ischeck = 'Y';
				} */
				
				//시리즈 배열 받음
				var ar_series = new Array();
				for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
					ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
				}
						
				var p_arr = new Array();
				var p_arrDistinct = new Array();
				var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				
				if(selarrrow == ""){
					alert("행을 선택하십시오.");
					return false;
				}
				
				for(var i=0; i<selarrrow.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
					
					if(item.state_flag == 'A' || item.state_flag == 'D') {
						alert("STATE가 '" + item.state_flag + "'인 항목은 삭제가 불가능 합니다.");
						return false;
					}
					
					if(item.mother_code == null) {
						alert("PENDING 품목이 존재하는것만 선택해주세요.");
						return false;
					}
					
					if(item.ssc_work_flag == 'Y') {
						alert("SSC ITEM이 존재합니다.");
						return false;
					}
					
					if(item.usc_job_type == "") {
						item.usc_job_type = "NULL";
					}
					
					p_arr.push(item.ship_type + "@" + item.project_no + "@" + item.block_no + "@" + item.str_flag + "@" + item.job_catalog + "@" 
							+ item.dwg_no + "@" + item.stage_no + "@" + item.usc_job_type);
				}
				
				$(p_arr).each(function(index, item) {
					if($.inArray(item, p_arrDistinct) == -1) {
						p_arrDistinct.push(item);
					}
				});
				
				$("#p_arrDistinct").val(p_arrDistinct);
				
				form = $('#application_form');

				form.attr("action", "pendingDelMain.do?p_dept_code="+$("input[name=p_dept_code]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series);
				form.attr("target", "_self");	
				form.attr("method", "post");	
				form.submit();
			}
		});
		
		//btnExport 버튼 클릭 시 
		$("#btnExport").click(function(){
			fn_downloadStart();
			fn_excelDownload();	
		});
		
		//Bom 버튼 클릭 시 
		$("#btnBom").click(function(){			
			
			var rtn = true;
		
			//행을 읽어서 키를 뽑아낸다.
			var pending_id = new Array();
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

				pending_id.push(item.pending_rowid);
			}
			
			if(!rtn){
				return false;
			}
			
			form = $('#application_form');
			form.attr("action", "pendingBomMain.do?p_pending_id="+encodeURIComponent(pending_id));
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
			
		});
		
		$("#btnCancel").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_pending_id
			var pending_id = new Array();
			var rtn = true;
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				if(item.state_flag == "" && item.eco_no == "" ){
					alert("선택한 DATA는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
				
				if(item.eco_states_code != 'CREATE') {
					alert("ECO CANCEL 대상이 없습니다.");
					return false;
				}
				
				/* if(item.tribon_flag == 'Y') {
					alert("선택한 Data 중에 R/M 항목이 존재합니다.");
					return false;
				} */
				
				pending_id.push(item.pending_rowid);
			}
			
			if(!rtn){
				return false;
			}
			
			if(confirm("Cancel 하시겠습니까?")){
				var form = $('#application_form');
				$(".loadingBoxArea").show();
				$.post("pendingCancelAction.do?p_pending_id="+pending_id,form.serialize(),function(json)
				{	
					alert(json.resultMsg);
					$(".loadingBoxArea").hide();
					fn_search();
				},"json");
			}
		});
		
		//Restore 버튼 클릭 시 
		$("#btnRestore").click(function(){

			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//p_chk_ssc_sub_id
			var pending_id = new Array();
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
				
				//아이템 체크 Validation				
				//if(item.state_flag == "A" && item.eco_no == "" ){
				if(item.state_flag == "" ){
					alert("선택한 Data는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
				
				//JOB STATUS 완료인 것 BOM작업 불가 			
				if(item.job_status == "4"){
					alert("선택한 Data 중 JOB완료 항목이 있습니다.");			
					rtn = false;
					return false;
				}
				
				//ECO STATUS REVIEW인 것 BOM작업 불가 			
				if(item.eco_states_code == "REVIEW"){
					alert("선택한 Data 중 ECO REVIEW 항목이 있습니다.");			
					rtn = false;
					return false;
				}
				
				pending_id.push(item.pending_rowid);
			}
			
			if(!rtn){
				return false;
			}
			
			if(confirm("Restore 하시겠습니까?")){
				var form = $('#application_form');
				$(".loadingBoxArea").show();
				$.post("pendingRestoreAction.do?p_pending_id="+pending_id,form.serialize(),function(json)
				{	
					alert(json.resultMsg);
					$(".loadingBoxArea").hide();
					fn_search();
				},"json");
			}
		});
		
		$("#btnUnit").click(function(){
			
			//메뉴ID를 가져오는 공통함수 
			getMenuId("uscJobCreate.do", callback_MenuId);
			
			var sURL = "uscJobCreate.do?menu_id=" + menuId + "&up_link=usc";
			var popOptions = "width=1500, height=730, resizable=yes, scrollbars=no, status=yes"; 
			window.open(sURL, "", popOptions);
		});
		
		//key evant 
		$(".commonInput").keypress(function(event) {
		  if (event.which == 13) {
		        event.preventDefault();
		        fn_search();
		        //$('#btnSearch').click();
		    }
		});
		
		//바탕화면 클릭 시 숨김
		$("body").click(function() {
			$("#dwgnoArea").hide();
		});
		
	});
	
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
				return false;
			}
		});
		return rnt;
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
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#pendingMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	function fn_search() {
		
		$("#init_flag").val("next");
		
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
			ar_series[0] = $("input[name=p_project_no]").val();
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
		}
		$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
		
		if($("input[name=p_page_cnt]").val() != ''){
			pageCnt = $("#p_page_cnt").val();
		} else {
			pageCnt = $('.ui-pg-selbox option:selected').val();
		}
		
		$("input[name=p_check_series]").val(ar_series);
		
		if(uniqeValidation()){
			
			var sUrl = "pendingList.do?p_chk_series="+ar_series;
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
	}
	
	//엑셀 다운로드 화면 호출
	function fn_excelDownload() {
		
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
		var colColor = '';
		var dataName = new Array();
		
		for(var i=0; i<gridColModel.length; i++ ){
			if(gridColModel[i].excel == true){
				colName.push(gridColModel[i].label);
				dataName.push(gridColModel[i].name);
				if(gridColModel[i].imp == true) {
					colColor += gridColModel[i].label +",";
				}
			}
		}
		
		/* var formData = fn_getFormData( "#application_form" );
		$.post("pendingExport.do",formData ,function(data){
				alert(data.resultMsg);
		}); */
		
		$("input[name=p_is_excel]").val("Y");
		
		
		/* var f    = document.application_form;
		f.action = "pendingExport.do";
		f.method = "post";
		f.submit(); */
		
		var form = $('#application_form');
		form.attr("action", "pendingExport.do?p_col_name="+colName+"&p_data_name="+dataName+"&p_col_color="+colColor+"&p_chk_series="+ar_series);
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	}
	
	//After Info 버튼 클릭 시 		
	var workClick = function (mother_code, project_no){
		
		var sURL = "popupPendingWorkMain.do?p_mother_code="+mother_code+"&p_project_no="+project_no;
		var popOptions = "width=1250, height=740, resizable=yes, scrollbars=yes, status=yes";
		
		popupWin = window.open(sURL, "workPopup", popOptions);
		popupWin.blur();
		
		setTimeout(function(){
			popupWin.focus();
		 }, 500);
		//setTimeout(popupWin.focus, 0);
	    
	}
	
	var changeTitle = function(cellVal, options, rowObject){
    	return  "title='This is the cell value " + rowObject.job_status_desc + "'";
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
			return "<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"','"+rowObject.mother_code+"','"+cellvalue+"')\">"+cellvalue+"</a>";
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
	
	//TEMP TABLE 비움
	var deleteTemp = function(){
		$.post("pendingDeleteTemp.do",function(json){	

		},"json");
	}
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
</script>
</body>

</html>