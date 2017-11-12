<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>ECR ECO Mapping</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class= "subtitle">
					ECR ECO Mapping
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				<table class="searchArea conSearch">
					<tr>
					<td  class="end" style="border-left:none">
						<div class="button endbox">
							<c:if test="${userRole.attribute5 == 'Y'}">
								<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
							</c:if>
						</div>
					</td>
					</tr>
				</table>
				<div class="content">
					<table id="ecrBasedOnList"></table>
					<div   id="pecrBasedOnList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
			var tableId = '';
			var resultData = [];
			var fv_catalog_code = "";
			var idRow = 0;
			var idCol = 0;
			var nRow = 0;
			var cmtypedesc;
			var kRow = 0;
			var jsonObj;
			
			$(document).ready( function() {
				fn_all_text_upper();
				
				var objectHeight = gridObjectHeight(2);
				
				$( "#ecrBasedOnList" ).jqGrid( {
					datatype : 'json',
					mtype 	 : 'POST',
					url 	 : 'ecrBasedOnList.do',
					postData : fn_getFormData( "#application_form" ),
					editUrl  : 'clientArray',
					colNames : [ 'states_code', 'no', 'ECR BASED ON(원인코드)', 'ECR BASED ON DESCRIPTION', '관련 ECO TYPE', 'ECO 대분류', '소분류', '' ],
					colModel : [ { name : 'states_code', index : 'states_code', width : 85, align : "center", editable : false, hidden : true }, 
					             { name : 'no', index : 'no', width : 85, align : "center", editable : false, hidden : true }, 
					             { name : 'states_var1', index : 'states_var1', width : 250, align : "left", editable : false },
					             { name : 'states_description', index : 'states_description', width : 250, align : "left", editable : false }, 
					             { name : 'related_eco_type', index : 'related_eco_type', width : 100, align : "left", editable : false }, 
					             { name : 'ltype', index : 'ltype', width : 100, align : "left", editable : false }, 
					             { name : 'stype', index : 'stype', width : 250, align : "left", editable : false , classes : "popup"}, 
					             { name : 'action', index : 'action', width : 35, align : "center", editable : false ,hidden : true } ],
					gridview 	 : true,
					cmTemplate: { title: false },
					toolbar 	 : [ false, "bottom" ],
					viewrecords  : true,
					hidegrid	 : false,
					height : objectHeight,
					rowList		 : [100,500,1000],
			 		rowNum		 : 100, 
					autowidth	 : true,
					
					emptyrecords : '데이터가 존재하지 않습니다. ',
					pager 		 : jQuery('#pecrBasedOnList'),
					
					cellEdit 	: true, // grid edit mode 1
					cellsubmit  : 'clientArray', // grid edit mode 2
					jsonReader  : {
						root 	: "rows",
						page 	: "page",
						total 	: "total",
						records : "records",
						repeatitems : false,
					},
					beforeEditCell : function( rowid, cellname, value, iRow, iCol) {
						idRow = rowid;
						idCol = iCol;
						kRow = iRow;
					},
					afterSaveCell : chmResultEditEnd,					
					imgpath : 'themes/basic/images',
					gridComplete : function () {
						$( "#ecrBasedOnList .popup" ).css( "background", "pink" ).css( "cursor", "pointer" );
					},
					
					loadComplete : function (data) {			
						var $this = $(this);
					    if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
					        // because one use repeatitems: false option and uses no
					        // jsonmap in the colModel the setting of data parameter
					        // is very easy. We can set data parameter to data.rows:
					        $this.jqGrid( 'setGridParam', {
					            datatype		: 'local',
					            data			: data.rows,
					            pageServer		: data.page,
					            recordsServer	: data.records,
					            lastpageServer 	: data.total
					        } );
							
					        // because we changed the value of the data parameter
					        // we need update internal _index parameter:
					        this.refreshIndex();
					
					        if ( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
					            // we need reload grid only if we use sortname parameter,
					            // but the server return unsorted data
					            $this.triggerHandler( 'reloadGrid' );
					        }
					       
					    } else {
					        $this.jqGrid( 'setGridParam', {
					            page: $this.jqGrid( 'getGridParam', 'pageServer' ),
					            records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
					            lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
					        } );
					        this.updatepager( false, true );
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
			 			       
					onCellSelect: function( rowId, iCol, content, event) {
						var cm = $("#ecrBasedOnList").jqGrid("getGridParam", "colModel");
						var colName = cm[iCol];
						
						var item = $('#ecrBasedOnList').jqGrid( 'getRowData', rowId );
						
						if ( colName['index'] == "stype" ) {
							var rs = window.showModalDialog( "popUpEcrEcoCodeMapping.do?statesCode="+item.states_code+"&menu_id=${menu_id}",
									window,
									"dialogWidth:800px; dialogHeight:700px; center:on; scroll:off; status:off" );
							if ( rs != null ) {
								if ( rs == "success" ) {
									//조회
									fn_search();
								}
							}
						}
					}
				} );
				
				//grid resize
			    fn_gridresize( $(window), $( "#ecrBasedOnList" ) , 40);
							
				//grid header colspan
				$( "#ecrBasedOnList" ).jqGrid( 'setGroupHeaders', {
					useColSpanStyle : true, 
					groupHeaders : [
										{ startColumnName : 'states_code', numberOfColumns : 5, titleText : 'ECR 원인코드 분류' },
										{ startColumnName : 'ltype', numberOfColumns : 4, titleText : '연계 가능 ECO 원인코드' }
					  				]
				} );
				
				//afterSaveCell oper 값 지정
				function chmResultEditEnd( irow, cellName ) {
					var item = $( '#ecrBasedOnList' ).jqGrid( 'getRowData',irow );
					if ( item.oper != 'I' )
						item.oper = 'U';
					
					$( '#ecrBasedOnList' ).jqGrid( "setRowData", irow, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				}
				
				//엑셀 export 버튼
				$("#btnExcelExport").click(function() {
					fn_downloadStart();
					fn_excelDownload();	
				});
				
			} ); //end of ready Function 
			
			//조회
			function fn_search() {
				var sUrl = "ecrBasedOnList.do";
				
				$("#ecrBasedOnList").jqGrid( 'setGridParam', {
					url 	 : sUrl,
					page 	 : 1,
					datatype : 'json',
					postData : fn_getFormData( '#application_form' )
				} ).trigger("reloadGrid");
			}
			
			//엑셀 다운로드 화면 호출
			function fn_excelDownload() {
				//그리드의 label과 name을 받는다.
				//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
				var colName = new Array();
				var dataName = new Array();
				
				var cn = $( "#ecrBasedOnList" ).jqGrid( "getGridParam", "colNames" );
				var cm = $( "#ecrBasedOnList" ).jqGrid( "getGridParam", "colModel" );
				for(var i=1; i<cm.length; i++ ){
					
					if(cm[i]['hidden'] == false) {
						colName.push(cn[i]);
						dataName.push(cm[i]['index']);	
					}
				}
				$( '#p_col_name' ).val(colName);
				$( '#p_data_name' ).val(dataName);
				var f    = document.application_form;
				f.action = "ecrEcoMappingExcelExport.do";
				f.method = "post";
				f.submit();
			}
		</script>
	</body>
</html>
