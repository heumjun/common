<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Pending SSC Bom List</title>
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	<style type="text/css">
		.content {
			width: 100%;
			margin: 10px 0 0 10px;
		}
	</style>
</head>
<body>

	<form id="application_form" name="application_form">
		<input type="hidden" id="p_project_no" name="p_project_no" value="<c:out value="${p_project_no}"/>" />
		<input type="hidden" id="p_mother_code" name="p_mother_code" value="<c:out value="${p_mother_code}"/>" />
		
		<table class="searchArea conSearch">
		<col width="100"/>
		<col width="120"/>
		<col width="100"/>
		<col width="80"/>
		<col width="*"/>
		<tr>
		
			<th>ITEM_CODE</th>
			<td>
				<input type="text" class="commonInput" name="p_item_code" value="" style="width:100px;" />
			</td>
			
			<th>REALESE</th>
			<td>
				<select name="p_release_type" class="commonInput">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select>
			</td>
			
			<td class=""  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				</div>
			</td>
		
		</tr>
		</table>
		
		<div class="content">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
		
	</form>
	<script type="text/javascript" src="/js/getGridColModelPENDING.js" charset='utf-8'></script>
	<script type="text/javascript">
		//그리드 사용 전역 변수
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var row_selected = 0;
		
		var gridColModel = getSSCBomGridColModel();
		var jqGridObj = $("#jqGridMainList");
		
		$(document).ready(function() {
			
			jqGridObj.jqGrid({ 
	            datatype: 'json',
	            url:'popupPendingWorkList.do',
	            mtype : 'POST',
	            postData : fn_getFormData('#application_form'),
	            colModel: gridColModel,
	            gridview: true,
	            viewrecords: true,
	            autowidth: true,
	            cellEdit : true,
	            cellsubmit : 'clientArray', // grid edit mode 2
				scrollOffset : 17,
	            multiselect: false,
	            shrinkToFit: false,
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
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					jqGridObj.saveCell(kRow, idCol );
					row_selected = rowid;
				}
	    	}); //end of jqGrid
	    	
	    	fn_gridresize( $(window), jqGridObj, -70);
	    	
	    	
	    	$( '#btnSearch' ).click( function() {
	    		//모두 대문자로 변환
	    		$("input[type=text]").each(function(){
	    			$(this).val($(this).val().toUpperCase());
	    		});
	    		
    			var sUrl = "popupPendingWorkList.do";
    			jqGridObj.jqGrid( "clearGridData" );
    			jqGridObj.jqGrid( 'setGridParam', {
    				url : sUrl,
    				mtype : 'POST',
    				datatype : 'json',
    				page : 1,
    				postData : fn_getFormData( "#application_form" )
    			} ).trigger( "reloadGrid" );
			});
	    	
		});
	</script>
</body>
</html>