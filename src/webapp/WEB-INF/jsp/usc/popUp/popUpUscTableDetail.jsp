<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body onLoad='window.focus();'>
		<form id="application_form" name="application_form">
			<input type="hidden" id="project_no" name="project_no" value="${p_project_no}" />
			<input type="hidden" id="area" name="area" value="${p_area}" />
			<input type="hidden" id="block_no" name="block_no" value="${p_block_no}" />
			<input type="hidden" id="block_catalog" name="block_catalog" value="${p_block_catalog}" />
			<input type="hidden" id="str_flag" name="str_flag" value="${p_str_flag}" />
			<input type="hidden" id="act_catalog" name="act_catalog" value="${p_act_catalog}" />

			<div class="content">
				<table id="catalogCodeList"></table>
				<div id="pcatalogCodeList"></div>
			</div>
		</form>
		<script type="text/javascript">
		
		var resultData = [];
		var aaa = 0;
		
		$(document).ready(function() {
			fn_all_text_upper();
						
			$( "#catalogCodeList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'uscTableDetailList.do',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ 'JOB', 'RELEASE', 'ITEM CODE', 'STR' ],
				colModel : [ { name : 'job_catalog', index : 'job_catalog', width : 40, sortable : false, align : 'center' }, 
				             { name : 'release_yn', index : 'release_yn', width : 60, sortable : false, align : 'center' },
				             { name : 'item_code', index : 'item_code', width : 100, sortable : false, align : 'center' },
				             { name : 'str_flag', index : 'str_flag', width : 40, sortable : false, align : 'center' }],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				multiselect: false,
				autowidth : true,
				viewrecords : true,
				emptyrecords : '데이터가 존재하지 않습니다.',
				height : 100,
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				pager : jQuery( '#pcatalogCodeList' ),
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
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
						} );
						this.updatepager(false, true);
					}
				},
				gridComplete: function(data){
					var row = $("#catalogCodeList").getDataIDs();
				}
			} );			
		} );	
		
		function resizeWin()
	    {
	        var conW = $(".content").innerWidth(); //컨텐트 사이즈
	        var conH = $(".content").innerHeight();
	    
	        var winOuterW = window.outerWidth; //브라우저 전체 사이즈
	        var winOuterH = window.outerHeight;
	        
	        var winInnerW = window.innerWidth; //스크롤 포함한 body영역
	        var winInnerH = window.innerHeight;
	        
	        var winOffSetW = window.document.body.offsetWidth; //스크롤 제외한 body영역
	        var winOffSetH = window.document.body.offsetHeight;
	        
	        var borderW = winOuterW - winInnerW;
	        var borderH = winOuterH - winInnerH;
	        
	        winResizeW = conW + borderW;
	        winResizeH = conH + borderH - 50;
	        
	        window.resizeTo(winResizeW,winResizeH); 
	    }

		</script>
	</body>
</html>
