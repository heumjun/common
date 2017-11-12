<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Job Catalog</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<%
			//String sCatalogType = StringUtil.nullString( request.getParameter( "catalog_type" ) );
			//String sMultiSelect = StringUtil.nullString( request.getParameter( "multi_select" ) );
			%>
			<input type="hidden" id="sType" name="sType" value="catalog_code" />
			<input type="hidden" id="catalog_type" name="catalog_type" value="${catalog_type}" />
			<input type="hidden" id="multi_select" name="multi_select" value="${multi_select}" />
			<input type="hidden" id="mother_catalog" name="mother_catalog" value="${mother_catalog}" />
			<input type="hidden" id="area" name="area" value="${area}" />
			<input type="hidden" id="block_catalog" name="block_catalog" value="${block_catalog}" />
			<input type="hidden" id="block_str_flag" name="block_str_flag" value="${block_str_flag}" />
			<input type="hidden" id="activity_catalog" name="activity_catalog" value="${activity_catalog}" />
			<input type="hidden" id="level_no" name="level_no" value="2" />
			
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<div class="topMain" style="margin:0px; line-height: 45px;">
				<div class="conSearch">
					<span class="pop_tit">JOB CATA</span>
					<input type="text" id="p_catalog_code" name="p_catalog_code" value="${p_catalog_code}" style="width: 50px; height:25px;text-transform:uppercase;" />
				</div>
				<div class="button">					
					<input type="button" id="btnfind" value="SEARCH"  class="btn_blue2"/>
					<input type="button" id="btnsend" value="APPLY" class="btn_blue2"/>
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
				url : 'infoUscActivityJobCatalogCode.do',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ 'JOB CATA', 'JOB CATA DESC.', 'JOB STR', 'JOB TYPE', 'ACTIVITY AREA', 'ACTIVITY TYPE' ],
				colModel : [ { name : 'job_catalog'  , index : 'job_catalog'  , width : 80 }, 
				             { name : 'catalog_desc' , index : 'catalog_desc' , width : 200 },
				             { name : 'str_flag'	 , index : 'str_flag'     ,	width : 100 },
				             { name : 'usc_job_type' , index : 'usc_job_type' , width : 100 },
				             { name : 'activity_area', index : 'activity_area', width : 100 },
				             { name : 'activity_type', index : 'activity_type', width : 100 }],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				multiselect: true,
				autowidth : true,
				viewrecords : true,
				emptyrecords : '데이터가 존재하지 않습니다.',
				height : 310,
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
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					if( $( "#multi_select" ).val() != "true" ) {
						var rowData = jQuery(this).jqGrid( 'getRowData', rowid );
	
						var returnValue = new Array();
						returnValue[0] = rowData.job_catalog;
						returnValue[1] = rowData.str_flag;
						returnValue[2] = rowData.usc_job_type;
						returnValue[3] = rowData.activity_area;
						returnValue[4] = rowData.activity_type;
						window.returnValue = returnValue;
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
			
			
			$( '#btnsend' ).click( function() {
				fn_send();
			} );
			

			$('#btnfind').click(function() {
				var sUrl = "infoUscActivityJobCatalogCode.do";
				$( "#catalogCodeList" ).jqGrid( 'setGridParam', {
					url : sUrl,
					page : 1,
					datatype : 'json',
					mtype : 'POST',
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
			} );
		} );
		
		
		function fn_send() {
			var row_id = $( "#catalogCodeList" ).jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return;
			}	
			
			var Separate = ", ";
			var is_first = true;
			var return_value = "";var return_value1 = "";var return_value2 = "";var return_value3 = "";var return_value4 = "";
			
			for(var i = 0; i < row_id.length; i++) {
				var item = $( "#catalogCodeList" ).jqGrid( 'getRowData', row_id[i]);
				
				if( is_first ) {
					is_first = false;
					return_value += item.job_catalog;
					return_value1 += item.str_flag;
					return_value2 += item.usc_job_type;
					return_value3 += item.activity_area;
					return_value4 += item.activity_type;
				} else {
					return_value += Separate + item.job_catalog;
					return_value1 += Separate + item.str_flag;
					return_value2 += Separate + item.usc_job_type;
					return_value3 += Separate + item.activity_area;
					return_value4 += Separate + item.activity_type;
				}
			}
			
			var returnValue = new Array();
			returnValue[0] = return_value;
			returnValue[1] = return_value1;
			returnValue[2] = return_value2;
			returnValue[3] = return_value3;
			returnValue[4] = return_value4;
			window.returnValue = returnValue;
			self.close();
			
		}
		</script>
	</body>
</html>
