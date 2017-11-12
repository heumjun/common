<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
	<title>Structure Name 조회</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>		
		<style>			
			.uniqInput {width:85px; margin-right:2px;}
			.buttonInput{float:right; margin-right:4px;}
			/*.content {position:relative; margin-left:4px; width:100%; height:700px; text-align:center; overflow-x:auto; }*/
			.td_keyEvent {font-size: 8pt; font-family: 굴림, 돋움, Verdana, Arial, Helvetica; vertical-align: bottom;}0
		</style>
	</head>
		
	<body>
		<form id="application_form" name="application_form" >
			<input type="hidden" name="p_board_id"   id="p_board_id" value=""/>
			<input type="hidden" name="pageYn"   id="pageYn" value=""/>
			
			<div class="mainDiv" id="mainDiv">							
				<div class="subtitle">Structure Name 조회</div>
				<table class="searchArea conSearch">
					<tr>
						<td>
							STRUCTURE NAME <input type="text" name="p_structure_name" />&nbsp;
							CATALOG <input type="text" name="p_catalog" />&nbsp;
							DESCRIPTION <input type="text" name="p_description" />
							<input type="button" class="btn_blue buttonInput" value="CLOSE" id="btnClose"/>
							<input type="button" class="btn_blue buttonInput" value="SEARCH" id="btnSearch"/>
						</td>
					</tr>
				</table>
				<div class="content">
					<table id="jqGridStructureList"></table>
					<div id="bottomJqGridStructurList"></div>
				</div>
				<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
			</div>
		</form>
		
		<script type="text/javascript" >
			var idRow;
			var idCol;
			var kRow;
			var kCol;
			var lastSelection;
			var jqGridObj = $("#jqGridStructureList");
			
			$(document).ready(function(){		
				jqGridObj.jqGrid({ 
		             datatype: 'json', 
		             url:'sscStructureList.do',
		             postData : fn_getFormData('#application_form'),		             
	                 colModel:[
	                 	{label:'STRUCTURE NAME', name:'structure_name', width:100, align:'left', sortable:false, title:false},
						{label:'CATALOG', name:'catalog_name', width:80, align:'left', sortable:false, title:false},
						{label:'CATALOG DESC', name:'catalog_desc', width:250, align:'left', sortable:false, title:false},
	                 ],	                 
		             gridview: true,
		             toolbar: [false, "bottom"],
		             viewrecords: true,
		             autowidth: true,
		             scrollOffset : 18,	             
		             //multiselect: true,
		             pager: jQuery('#bottomJqGridStructurList'),
		             height: 550,
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
					        });
					        this.updatepager(false, true);
					    }
					 }
				}); //end of jqGrid
				
				//jqGrid 크기 동적화
	         	fn_gridresize( $(window), jqGridObj, -40 );
		     	
				//######## 닫기버튼  ########//
				$("#btnClose").click(function(){
					window.close();					
				});	
				
				//######## 검색버튼  ########//
				$("#btnSearch").click(function(){
					jqGridReload();					
				});
			});
			
			function jqGridReload (){
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				
				$("input[name=pageYn]").val("N");
				
				var sUrl = "sscStructureList.do";
				jqGridObj.jqGrid( "clearGridData" );
				jqGridObj.jqGrid( 'setGridParam', {
					url : sUrl,
					mtype : 'POST',
					datatype : 'json',
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
				
			}
			
			
		</script>
	</body>
</html>