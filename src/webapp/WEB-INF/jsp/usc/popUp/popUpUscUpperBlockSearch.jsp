<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>U_Blk</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<%
			//String sCatalogType = StringUtil.nullString( request.getParameter( "catalog_type" ) );
			//String sMultiSelect = StringUtil.nullString( request.getParameter( "multi_select" ) );
			%>
			<input type="hidden" id="p_project_no" name="p_project_no" value="${p_project_no}" />
						
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<div class="topMain" style="margin:0px; line-height: 45px;">
				<div class="button">
					<input type="button" id="btncancle" value="CLOSE"  class="btn_blue2"/>
				</div>
			</div>
			<div class="content">
				<table id="catalogCodeList"></table>
				<div id="pcatalogCodeList"></div>
			</div>
		</form>
		<script type="text/javascript">
		
		var resultData = [];
		
		$(document).ready(function() {
			fn_all_text_upper();
			
			$( "#catalogCodeList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'infoUscUpperBlockCode.do',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : ['Block Code'],
				colModel : [ { name : 'block_no', index : 'block_no', width : 50, sortable : false } ],
				gridview : true,
				pgbuttons 	: false,
				pgtext 	: false,
				pginput 	: false,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				autowidth : true,
				viewrecords : true,
				recordtext: '전체 {2}',
				emptyrecords : '데이터가 존재하지 않습니다.',
				height : 310,
				rowNum:999999, 
				pager : jQuery( '#pcatalogCodeList' ),
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					if( $( "#multi_select" ).val() != "true" ) {
						var rowData = jQuery(this).jqGrid( 'getRowData', rowid );
	
						window.returnValue = rowData.block_no;
						self.close();
					}
				},
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
				}
			} );

			$( '#btncancle' ).click( function() {
				self.close();
			} );
		} );
		</script>
	</body>
</html>
