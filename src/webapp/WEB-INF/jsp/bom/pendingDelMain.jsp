<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TBC Pending Management</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style type="text/css">
	.onMs{background-color:#FFFA94;}
	input[type=text] {text-transform: uppercase;}
	table.searchArea3 {
		position: relative;
		margin-top: 1px;
		margin-bottom: 1px;
		border-left: 1px solid #d6ddee;
		border-right: 1px solid #d6ddee;
		border-bottom: 1px solid #d6ddee;
		border-collapse: collapse;
	}
	table.searchArea3 th {
		font-size: 11px;
		height: 20px;
		line-height: 14px;
		color: #324877;
		padding: 0;
		border-left: 1px solid #d6ddee;
		background: url(../images/main/sc_bg.gif) repeat-x left top #FFE0CE;
	}
	
	table.searchArea3 td {
		font-size: 11px;
		height: 20px;
		padding: 5px 0 5px 10px;
		border-left: 1px solid #d6ddee;
		background: url(../images/main/sc_bg.gif) repeat-x left top #FFE0CE;
		letter-spacing: -0.05em;
		text-align: left;
	}
	
	.searchArea3 input[type=text] {
		border: 1px solid #9cc2df;
		height: 20px;
		font-family: '돋움';
		text-transform: uppercase;
	}
	
	.searchArea3 input[type=file] {
		border: 1px solid #9cc2df;
		height: 20px;
		background: #fff;
		font-family: '돋움';
	}
	
	.searchArea3 input[type=checkbox] {
		border:  0;
		height: 20px;
		vertical-align: middle;
	}
	
	.searchArea3 input[type=radio] {
		border: 0;
		height: 20px;
		vertical-align: middle;
	}
	
	.subMesageArea{
		position:relative; 
		width:290px; 
		float:left; 
		margin:0 6px 4px 0px; 
		font-weight:bold; 
		color:red; 
		text-align:left;
	}	
	.header .searchArea .seriesChk{width:100%; height:36px;}
</style>
</head>
<body>
<form id="application_form" name="application_form"  >
	<input type="hidden" name="p_nowpage" value="1" />	
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" name="pageYn" value="" />
	<input type="hidden" id="p_col_name" name="p_col_name"/>
	<input type="hidden" id="p_data_name" name="p_data_name"/>
	<input type="hidden" name="p_master_no" value="<c:out value="${p_master_no}"/>" />
	<input type="hidden" name="p_arrDistinct" value="${p_arrDistinct}" />
	<input type="hidden" name="p_ng_flag" value="${p_ng_flag}" />
	<input type="hidden" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />" />
	<input type="hidden" name="p_ischeck" value="${p_ischeck}" />
	<input type="hidden" name="p_chk_series" value="${p_chk_series}" />
	
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			TBC Pending Manager - DELETE
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea2 conSearch">
		<col width="100"/>
		<col width="100"/>
		<col width="*"/>
			<tr>
				<th>Master</th>
				<td>
					<input type="text" class="required" name="p_project_no" alt="Project"  style="width:70px;" value="${p_master_no}"  readonly="readonly" />
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_blue2" value="Close" id="btnClose"/>
					</div>
				</td>
			</tr>
		</table>
		
		<table class="searchArea">
			<tr>
				<td>
					<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
				</td>
			</tr>
		</table>
		
		<table class="searchArea2">
		<col width="300"/>
		<col width="*"/>
			<tr>
				<td>
					<div>
						<!-- <input type="button" class="btn_blue2" value="DWG" id="btnDwg"/>
						<input type="button" class="btn_blue2" value="IMPORT" id="btnWkImport"/>
						<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/> -->
						<input type="button" class="btn_blue2" value="DELETE" id="btnDel"/>
					</div>	
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_red2" value="APPLY" id="btnApply"/>
					</div>	
				</td>
			</tr>
		</table>
		
		<div id="divList" class="content" style="position:relative; float: left; width: 48%;">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
		<div id="divNext" class="centerCon" style="text-align: center; height:600px; margin-left: 5px; position:relative; float: left; width: 3%;">
			<div style="width:80%; display:inline-block; margin-top: 270px; "> 
				<input type="button" class="btn_blue2" value="NEXT" id="btnNext"/>
			</div>
		</div>
		<div id="divList1" class="content" style="position:relative; float: right; width: 48%;">
			<table id="pendingDetail"></table>
			<div id="bottomPendingDetail"></div>
		</div>

		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" src="/js/getGridColModelPENDING.js" charset='utf-8'></script>
<script type="text/javascript" charset='utf-8'>
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var win = null;
	var arr_dwg_no = "";
	
	var jqGridObj = $("#jqGridMainList");

	//달력 셋팅
	$(function() {
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
	  	
	  	var form = fn_getFormData('#application_form');
		//getAjaxTextPost(null, "pendingAutoCompleteDwgNoList.do", form, getdwgnoCallback);
		//getAjaxTextPost(null, "getAutoCompleteJobCatalogInfo.do", form, getJobCatalogCallback);
		
	});
	
	
	///js/getGridColModel.js에서 그리드의 colomn을 받아온다.
	var addGridColModel = getAddGridColModel();
	var addDetailGridColModel = getAddDetailGridColModel();
	
	$(document).ready(function(){
		
		var vAble = "";
		
		//시리즈 호선 받기		
		//getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+$("input[name=p_ischeck]").val()+"&p_chk_series="+$("input[name=p_chk_series]").val(), null);
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_able="+vAble, null, getDeliverySeriesCallback);
		
		//기술 기획일 경우 부서 선택 기능
		if(typeof($("#p_sel_dept").val()) !== 'undefined'){
			getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
		}
		
		// /js/getGridColModel.js에서 그리드의 colomn을 받아온다.
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'pendingDelList.do',
            mtype : 'POST',
            postData : fn_getFormData('#application_form'),
            colModel: addGridColModel,
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit: false,
            height: 550,
            pager: '#bottomJqGridMainList',
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
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  
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
			gridComplete: function () {
				
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				
			}
    	}); //end of jqGrid
    	
    	
    	$("#pendingDetail").jqGrid({
            datatype	: 'json', 
            url      : '',
            mtype    : '',
            postData   : '',
            colModel: addDetailGridColModel,
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: false,
            shrinkToFit: false,
            height: 230,
            pager: '#bottomPendingDetail',
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
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
			}
    	}); //end of jqGrid
    	
    	
    	//grid resize
	    fn_insideGridresize( $(window), $("#divList"), $("#jqGridMainList"), -350, .47);
	    fn_insideGridresize( $(window), $("#divList1"), $("#pendingDetail"), -350, .47);
		
	    $("#btnDel").click(function(){
	    	
	    	
	    	jqGridObj.saveCell(kRow, idCol );
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
	    	
			var row_len = row_id.length;					
			
			for(var i=0; i<row_len; i++){
				jqGridObj.jqGrid('delRowData',row_id[0]);
			}
			
	    });
	    
		//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
		$("#btnNext").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
 			
			//Body에 ProjectNo가 있으면 시리즈 Validation 제외
			
			//시리즈 체크 유무 판단.
			if(isSeriesChecked() == false){
				return false;
			}
		    
			var formData = fn_getFormData('#application_form');
			
			var changeRows = [];
			var rtn = true;
			getGridChangedData(jqGridObj,function(data) {
				changeRows = data;
				
				if (changeRows.length == 0) {
					alert("내용이 없습니다.");
					return;
				}
				
				//시리즈 체크 유무 판단.
				if(isSeriesChecked() == false){
					return false;
				}
				
				//시리즈 배열 받음
				var ar_series = new Array();
				for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
					ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);

				$("input[name=p_isPaging]").val("Y");
			
				getJsonAjaxFrom("pendingDelWorkInsert.do?p_check_series="+ar_series, parameters, null, callback_next);
				
			});
			
		});
		
		//Apply 클릭
		$("#btnApply").click(function(){
			$("#pendingDetail").saveCell(kRow, idCol );
			
			var arr = (''+$("#pendingDetail").jqGrid("getDataIDs")).split(',');
			
			
			//프로세스가 NO 이면 진행 불가
			if(!chkgridProcess()){
				return false;
			}
			
			var formData = fn_getFormData('#application_form');
			
			//승인 로직
			if(confirm('적용하시겠습니까?')){
				
				$.post("pendingDelApplyAction.do", formData, function(data){
					alert(data.resultMsg);
				},"json").error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
					$("#btnClose").click();
				} );
				
			}
			 
		});
		
	    
	  	//Close 버튼 클릭
		$("#btnClose").click(function(){
			history.go(-1);
		});
	  	
		$(document).keydown(function (e) { 
			if (e.keyCode == 27) { 
				e.preventDefault();
			} // esc 막기
			if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA"){
				if(e.keyCode == 8) {
					return false;
				}
			}
		}); 
		
	});
	
    function getDeliverySeriesCallback(){
    	$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
			var deliverySeries = data;
    		for(var i=0; i<$("input[name=p_series]").length; i++){
    			var id = $("input[name=p_series]")[i].id;
    			for(var j=0; j<deliverySeries.length; j++){
    				if($("input[name=p_series]")[i].id == "p_series_"+deliverySeries[j].project_no){
    					$("#" + id).attr("disabled", true); 
        				$("input:checkbox[id='"+id+"']").prop("checked", false);
        				break;
    				}
    				else{
    					$("#" + id).attr("disabled", false);
        				$("input:checkbox[id='"+id+"']").prop("checked", true);
    				}
    			}
    		}	
		},"json");
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
	
	function textUpperCase() {
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
	}
	
	//Series 체크 유무 validation
	var isSeriesChecked = function(){
		if($(".chkSeries:checked").length == 0){
			alert("적용 할 시리즈를 체크하십시오.");
			return false;
		}else{
			return true;
		}
	}
	
	//CallBack Next 이후 버튼 상태 변경
	var callback_next = function(json){
		
		var sUrl = "pendingDelNextAction.do";
		$("#pendingDetail").jqGrid( "clearGridData" );
		$("#pendingDetail").jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
		
	}
	
	//Process 필드가 NO인 것이 있으면 진행불가.
	var chkgridProcess = function(){
		
		var processData = $.grep($("#pendingDetail").jqGrid('getRowData'), function(obj) { 
			return obj.process == 'NG'; 
		});	
		
		if(processData.length > 0){
			alert("올바르지 않은 데이터가 있습니다. \n데이터를 확인하십시오.");
			return false;
		}else{
			return true;		
		}
	}
	
</script>
</body>

</html>