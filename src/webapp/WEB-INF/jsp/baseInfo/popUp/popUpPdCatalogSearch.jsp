<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Catalog</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<%
			String sCatalogType = request.getParameter( "catalog_type" ) ;
			String sMultiSelect = request.getParameter( "multi_select" ) ;
			%>
			<input type="hidden" id="sType" name="sType" value="catalog_code" />
			<input type="hidden" id="catalog_type" name="catalog_type" value="<%=sCatalogType %>" />
			<input type="hidden" id="multi_select" name="multi_select" value="<%=sMultiSelect %>" />
			<input type="hidden" id="mother_catalog" name="mother_catalog" value="${mother_catalog}" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<div class="topMain" style="margin:0px; line-height: 45px;">
				<div class="conSearch">
					<span class="pop_tit">Catalog Code</span>
					<input type="text" id="catalog_code" name="catalog_code" style="width: 50px; height:25px;text-transform:uppercase;" />
				</div>
				<div class="button">
					<input type="button" id="btnsend" value="확인" class="btn_blue"/>
					<input type="button" id="btnfind" value="조회"  class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
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
				url : 'infoCatalogSearch.do',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ '선택', 'Catalog Code', 'Catalog Desc' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 25, editable : true, edittype : 'checkbox', formatter : 'checkbox', editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				             { name : 'catalog_code', index : 'catalog_code', width : 80, sortable : false }, 
				             { name : 'catalog_desc', index : 'catalog_desc', width : 200, sortable : false } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
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
						returnValue[0] = rowData.catalog_code;
						returnValue[1] = rowData.catalog_desc;
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
			
			//nav button area set width 0 
			$( "#pcatalogCodeList_left" ).css( "width", 0 );
			
			if( $( "#multi_select" ).val() != "true" ) {
				$( "#btnsend" ).hide();
			}

			$( '#btncancle' ).click( function() {
				self.close();
			} );
			
			
			$( '#btnsend' ).click( function() {
				fn_send();
			} );
			

			$('#btnfind').click(function() {
				var sUrl = "infoCatalogSearch.do";
				$( "#catalogCodeList" ).jqGrid( 'setGridParam', {
					url : sUrl,
					page : 1,
					datatype : 'json',
					mtype : 'POST',
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
			} );
			
			if( $( "#multi_select" ).val() != "true" ) {
				$( "#catalogCodeList" ).jqGrid( 'hideCol', 'enable_flag' ).trigger('reloadGrid');
				$( "#catalogCodeList" ).jqGrid( 'setGridWidth', $(window).width(), true );
			}
		} );
		
		
		function fn_send() {
			getChangedChmResultData( function( data ) {
				var Separate = ", ";
				var is_first = true;
				var return_value = "";
				
				for( var i = 0; i < data.length; i++ ) {
					if( is_first ) {
						is_first = false;
						return_value += data[i].catalog_code;
					} else {
						return_value += Separate + data[i].catalog_code;
					}
				}
				
				var returnValue = new Array();
				returnValue[0] = return_value;
				window.returnValue = returnValue;
				self.close();
			} );
		}
		
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#catalogCodeList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.enable_flag == 'Y';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		</script>
	</body>
</html>
