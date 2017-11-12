<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>SSC History Main</title>
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

<form id="application_form" name="application_form"  >
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
	<input type="hidden" id="p_arrDistinct" name="p_arrDistinct"/>
	<!-- ALL BOM ECO 번호 -->
	<input type="hidden" name="p_input_eco_no" value="" />
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		SSC History
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
				<input type="text" class="required"  name="p_project_no" alt="PROJECT"  style="width:50px;" value="${p_project_no}" onkeyup="javascript:getDwgNos();" /> &nbsp;
				ITEM CODE
				<input type="text" class="required" name="p_item_code" alt="PROJECT" value="" style="width:90px;" /> &nbsp;
				DWG NO.
				<input type="text" id="p_dwg_no" name="p_dwg_no" style="width:60px;" value="${p_dwg_no}" alt="DWG NO." onkeypress="javascript:getDwgNos();" /> &nbsp;
				STATE
				<select name="p_state_flag" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="A" >A</option>
					<option value="D" >D</option>
					<option value="C" >C</option>
<!-- 					<option value="Act" >Act</option> -->
				</select> &nbsp;
				PENDING
				<input type="text" class="commonInput bigInput" name="p_mother_code" value="" style="width:90px;" /> &nbsp;
				생성일자
				<input type="text" name="p_start_date" id="p_start_date" class="commonInput" style="width:60px;" value=""/>
				~
				<input type="text" name="p_end_date" id="p_end_date" class="commonInput" style="width:60px;" value=""/> &nbsp;
				ECO NO.
				<input type="text" class="commonInput" name="p_eco_no" value="" style="width:70px;"  /> &nbsp;
<%-- 				<c:choose> --%>
<%-- 					<c:when test="${loginUser.gr_code=='M1'}"> --%>
<!-- 						DEPT. -->
<!-- 						<select name="p_sel_dept" id="p_sel_dept" style="width:130px;" onchange="javascript:DeptOnChange(this);" > -->
<!-- 						</select> -->
<%-- 						<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  /> --%>
<%-- 						<input type="hidden" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  /> &nbsp; --%>
<%-- 					</c:when> --%>
<%-- 					<c:otherwise> --%>
<!-- 						DEPT. -->
<%-- 						<input type="text" name="p_dept_name" class="disableInput" value="<c:out value="${loginUser.dwg_dept_name}" />" style="width:110px;" readonly="readonly" /> --%>
<%-- 						<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  /> &nbsp; --%>
<%-- 					</c:otherwise> --%>
<%-- 				</c:choose> --%>
			</td>
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
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
// 	if(typeof($("#p_sel_dept").val()) !== 'undefined'){
// 		getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
// 	}
	
	//달력 셋팅
	$(function() {
		
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
	
	function getMainGridColModel(){

		var gridColModel = new Array();
		
		gridColModel.push({label:'ITEM TYPE', name:'item_type_cd', width:35, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'STATE', name:'state_flag', width:35, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:40, align:'center', sortable:true, title:false, hidden:true} );
		//gridColModel.push({label:'MASTER', name:'master_ship', width:50, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'PROJECT', name:'project_no', width:50, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'DWG NO.', name:'dwg_no', width:65, align:'center', sortable:true, title:false} );
		//gridColModel.push({label:'BLOCK', name:'block_no', width:40, align:'center', sortable:true, title:false} );
		//gridColModel.push({label:'STAGE', name:'stage_no', width:40, align:'center', sortable:true, title:false, hidden:false} );
		//gridColModel.push({label:'STR', name:'str_flag', width:30, align:'center', sortable:true, title:false} );
		//gridColModel.push({label:'TYPE', name:'usc_job_type', width:50, align:'center', sortable:true, title:false} );
		//gridColModel.push({label:'JOB ITEM', name:'job_cd', width:80, align:'center', sortable:true, title:false, hidden:false} );
		//gridColModel.push({label:'BUY-BUY FLAG', name:'buy_buy_flag', width:50, align:'center', sortable:true, title:false,  hidden:true} );
		//gridColModel.push({label:'RAW_LEVEL_FLAG', name:'raw_level_flag', width:50, align:'center', sortable:true, title:false, hidden:true} );
		gridColModel.push({label:'PENDING', name:'mother_code', width:80, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'ITEM CODE', name:'item_code', width:100, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'ITEM_CATALOG', name:'item_catalog', width:60, align:'center', sortable:true, title:false, hidden:true } );
		gridColModel.push({label:'EA', name:'bom_qty', width:30, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'MOVE', name:'move_log', width:200, align:'center', sortable:true, title:false} );
		//gridColModel.push({label:'WEIGHT', name:'item_weight', width:45, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'DEPART', name:'dept_name', width:80, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'USER', name:'user_name', width:40, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'작업일', name:'create_date', width:90, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'ECO NO.', name:'eco_no', width:65, align:'center', sortable:true, title:false, formatter: ecoFormatter, unformat:unFormatter} );
		gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden:true} );
		return gridColModel;
	}
	
	var vItemTypeCd = $("input[name=p_item_type_cd]").val();
	
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
             multiselect: false,
             shrinkToFit: true,
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
				
			},
			
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 20);
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
			
		}
	}
	
	function fn_search() {
		
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
		
		var sUrl = "sscHistoryMainList.do?p_chk_series="+ar_series;
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