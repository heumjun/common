<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Act Catalog</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<%
			//String sCatalogType = StringUtil.nullString( request.getParameter( "catalog_type" ) );
			//String sMultiSelect = StringUtil.nullString( request.getParameter( "multi_select" ) );
			%>
			<input type="hidden" id="p_chk_series" name="p_chk_series" value="${p_chk_series}" />
			
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<div class="topMain" style="margin:0px; line-height: 45px;">
				<div class="conSearch">
					<span class="pop_tit">PROJECT</span>
					<input type="text" id="p_project_no" name="p_project_no" value="" style="width: 50px; height:25px;text-transform:uppercase;" />
					<span class="pop_tit">MASTER</span>
					<input type="text" id="p_master" name="p_master" value="" style="width: 50px; height:25px;text-transform:uppercase;" />
				</div>
				<div class="button">
					<input type="button" id="btnfind" value="SEARCH"  class="btn_blue2"/>
					<input type="button" id="btnapply" value="APPLY" class="btn_blue2"/>					
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
		var aaa = 0;
		
		$(document).ready(function() {
			fn_all_text_upper();
			//엔터 버튼 클릭
			$("*").keypress(function(event) {
			  if (event.which == 13) {			  
			      event.preventDefault();
			      $('#btnfind').click();
			  }
			});
			
			$( "#catalogCodeList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : '',
				postData : fn_getFormData( "#application_form" ),
				editUrl : 'clientArray',
				colNames : [ 'PROJECT', 'MASTER', 'SHIPTYPE', 'SHIPSIZE', 'OWNER' ],
				colModel : [ { name : 'project_no', index : 'project_no', width : 60, sortable : false }, 
				             { name : 'master', index : 'master', width : 60, sortable : false },
				             { name : 'ship_type', index : 'ship_type', width : 60, sortable : false },
				             { name : 'ship_size', index : 'ship_size', width : 60, sortable : false },
				             { name : 'owner', index : 'owner', width : 150, sortable : false }
				             ],
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
			
			$( '#btnapply' ).click( function() {
				fn_apply();
			} );			

			$('#btnfind').click(function() {
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				
				var sUrl = "popUpPartListCopyList.do";
				$( "#catalogCodeList" ).jqGrid( 'setGridParam', {
					url : sUrl,
					page : 1,
					datatype : 'json',
					mtype : 'POST',
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
			} );
		} );
		
		
		function fn_apply() {
			var row_id = $( "#catalogCodeList" ).jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return;
			}
			
			var ar_series = [];
			for(var i=0; i<row_id.length; i++) {
				var item = $( "#catalogCodeList" ).jqGrid( 'getRowData', row_id[i]);
				ar_series.push(item.project_no);
			}
			
			var args = window.dialogArguments;
			var jsonGridData = [];
			var opener_row_id = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');
			for(var i=0; i<opener_row_id.length; i++) {
				var item = args.jqGridObj.jqGrid( 'getRowData', opener_row_id[i]);
				jsonGridData.push({project_no : item.project_no
		              , dwg_no : item.dwg_no
		              , maker : item.maker
		              , maker_no : item.maker_no
		              , maker_desc : item.maker_desc
		              , partlist_type : item.partlist_type
		              , item_code : item.item_code
		              , ea : item.ea
		              , weight : item.weight
		              , comments : item.comments
		              , part_list_s : item.part_list_s});
			}	
			
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

			var dataList = { chmResultList : JSON.stringify( jsonGridData ) };
			var url = 'savePartListCopy.do?chk_series='+ar_series;
			var formData = fn_getFormData('#application_form');
			//객체를 합치기. dataList를 기준으로 formData를 합친다.
			var parameters = $.extend( {}, dataList, formData); 
			
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					args.fn_search();
					self.close();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			}).always( function() {
		    	lodingBox.remove();	
			});
		}			
		
		</script>
	</body>
</html>
