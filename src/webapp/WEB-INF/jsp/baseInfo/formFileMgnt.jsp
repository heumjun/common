<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Form File</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				<input type="hidden" id="form_file_code" name="form_file_code" />
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class= "subtitle">
					Form File
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="./images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				<div class="content">
					<table id="formFileList"></table>
					<div id="pformFileList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var resultData = [];

		var lodingBox;
		
		$(document).ready( function() {
			var objectHeight = gridObjectHeight(1);
			
			$("#formFileList").jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'FormFile.do',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '선택', '코드', '파일명', 'Commentes' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } }, 
				             { name : 'form_file_code', index : 'form_file_code', hidden : true }, 
				             { name : 'filename', states_desc : 'filename', width : 300, editable : false, editoptions : { size : 290 } }, 
				             { name : 'commentes', index : 'commentes', width : 400, editable : false, editoptions : { size : 399 } } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : objectHeight,
				hidegrid : false,
				pager : jQuery('#pformFileList'),
				sortname: 'filename',
				sortorder: "desc",
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function( rowid, cellname, value, iRow, iCol ) {
					if ( value == 2 ) {
						var item = $('#formFileList').jqGrid( 'getRowData', rowid );
						var form_file_code = item.form_file_code;
						$( "#form_file_code" ).val( form_file_code );
						fn_downLoadFile();
					}
				},
				onPaging : function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
				},
				loadComplete : function( data ) {
					var $this = $(this);
					if ( $this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype : 'local',
							data : data.rows,
							pageServer : data.page,
							recordsServer : data.records,
							lastpageServer : data.total
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
							page : $this.jqGrid( 'getGridParam', 'pageServer' ),
							records : $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage : $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						
						this.updatepager( false, true );
					}
				}
			} );

			//grid resize
			fn_gridresize( $(window), $( "#formFileList" ), -50 );
			
			$("#formFileList").jqGrid('navGrid', "#pformFileList", {
				search : false,
				edit : false,
				add : false,
				del : false
			});
			
			<c:if test="${userRole.attribute3 == 'Y'}">
			$("#formFileList").navButtonAdd('#pformFileList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$("#formFileList").navButtonAdd('#pformFileList', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
					
		} ); //end of ready Function 
	
		//Add 버튼 
		function addChmResultRow() {
			var rs = window.showModalDialog( "popUpAddFormFile.do?menu_id=${menu_id}", 
					window,
					"dialogWidth:600px; dialogHeight:180px; center:on; scroll:off; status:off" );
			
			if ( rs != null ) {
				fn_search();
			}
		}
	
		//Del 버튼
		function deleteRow() {
			if ( confirm('삭제 하시겠습니까?') ) {
				var chmResultRows = [];
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'delFormFile.do';
					var formData = fn_getFormData( '#application_form' );
					var parameters = $.extend( {}, dataList, formData );
					$.post( url, parameters, function( data2 ) {
						alert( data2.resultMsg );
						if ( data2.result == 'success' ) {
							fn_search();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						lodingBox.remove();				    		
					} );
				} );
			}
		}

		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData(callback) {
			var changedData = $.grep( $( "#formFileList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.enable_flag == 'Y';
			} );
	
			callback.apply(this, [ changedData.concat(resultData) ]);
		};
	
		function fn_downLoadFile() {
			var sUrl = "downloadFormFile.do";
			var f = document.application_form;
	
			f.action = sUrl;
			f.method = "post";
			f.submit();
		}
	
		function fn_search() {
			var sUrl = "FormFile.do";
			
			jQuery("#formFileList").jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype : 'json',
				postData : fn_getFormData("#application_form")
			} ).trigger("reloadGrid");
		}
		</script>
	</body>
</html>
