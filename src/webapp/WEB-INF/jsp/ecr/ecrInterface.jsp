<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>ECR Interface</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="pageYn" name="pageYn" value="N">
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class="subtitle">
					ECR Interface
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				<!--
				<div class="topMain" style="line-height: 45px;">
					<div class="button" style="float:left;">
						<input type="button" class="btn_blue" id="btnInterFace1" name="btnInterFace1" value="Interface un-completed I/F(ECR create)" />
						<input type="button" class="btn_blue" id="btnInterFace2" name="btnInterFace2" value="Remove item completed I/F from screen list" />
						<input type="button" class="btn_blue" id="btnSelect" name="btnSelect" value="조회" />
					</div>
				</div>
				-->

				<table class="searchArea conSearch">
				<tr>
					<td style="border-left:none;">
					<div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" class="btn_blue" id="btnSelect" name="btnSelect" value="조회"/>
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" class="btn_blue" id="btnInterFace1" name="btnInterFace1" value="Interface un-completed I/F(ECR create)" />
						<input type="button" class="btn_blue" id="btnInterFace2" name="btnInterFace2" value="Remove item completed I/F from screen list" />
						</c:if>						
					</div>
					</td>
				</tr>
				</table>

				<div class="content">
					<table id="ecrInterfaceList"></table>
					<div id="pecrInterfaceList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var resultData = [];
		var kRow = 0;
		var idCol = 0;
		
		var lodingBox;
		
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			$( "#ecrInterfaceList" ).jqGrid( {
				url:'',
				datatype: "json",
				mtype: 'POST',
			   	colNames:[ '선택', 'ECR Name', 'FEEDBACK', 'Type', 'Description', 'Owner', 'Process status' ],
			   	colModel:[
			   		{ name : 'enable_flag', index : 'enable_flag', width : 15, align : 'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
			   		{ name : 'ecr_no', index : 'ecr_no', width : 50, align : 'center', classes : "handcursor" },
			   		{ name : 'feedback_no', index : 'feedback_no', width : 50, align : 'left' },
			   		{ name : 'type', index : 'type', width : 50, align : 'center' },
			   		{ name : 'description', index : 'description', width : 300 },
			   		{ name : 'owner', index : 'owner', width:150, align : 'left' },
			   		{ name : 'process_status', index : 'process_status', width : 60, align : 'center' }
			   	],
			   	rowNum:100,
			   	cmTemplate: { title: false },
			   	rowList:[100,500,1000],
			   	pager: '#pecrInterfaceList',
			   	sortname: 'cd_ecr',
			    viewrecords: true,
			    sortorder: "desc",
			    rownumbers:true,
			    autowidth : true,
			   	height : objectHeight,
			   	hidegrid: false,
			   	emptyrecords : '데이터가 존재하지 않습니다.',
			   	gridview : true,
			   	jsonReader : {
			   		root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					var cm = $( "#ecrInterfaceList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $("#ecrInterfaceList").jqGrid( "getRowData", rowid );
					
					if ( colName['index'] == "ecr_no" ) {
                		//ECR Name 더블클릭 시 ECR 상세 팝업 열림
                		var ecrName = item.ecr_no;
                		
                		if( ecrName == "" || ecrName == "-" ) {
                			alert("no ecr name");
                			return;
                		}
                		
                		var sUrl = "ecr.do?ecr_name=" + ecrName+"&popupDiv=Y&checkPopup=Y&ecr_if_flag=Y&menu_id=${menu_id}";
            			
                		var rs = window.showModalDialog( sUrl,
                				window,
								"dialogWidth:1400px; dialogHeight:750px; center:on; scroll:off; status:off" );
                	}
				},
// 				ondblClickRow : function( rowid, iRow, iCol, e ) {
// 					var ret = $("#ecrInterfaceList").jqGrid( "getRowData", rowid );
                	
// 					if( iCol == 2 ) {
//                 		//ECR Name 더블클릭 시 ECR 상세 팝업 열림
//                 		var ecrName = ret.ecr_no;
                		
//                 		if( ecrName == "" || ecrName == "-" ) {
//                 			alert("no ecr name");
//                 			return;
//                 		}
                		
//                 		var sUrl = "./popupEcr.do?ecr_name=" + ecrName;
            			
//                 		var rs = window.showModalDialog( sUrl,
//                 				window,
// 								"dialogWidth:1400px; dialogHeight:750px; center:on; scroll:off; status:off" );
//                 	}
// 				},
				onPaging: function(pgButton) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
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
			
			//grid resize
		    fn_gridresize( $(window), $( "#ecrInterfaceList" ) );
			
			//그리드 모든 버튼 숨김
			$( "#ecrInterfaceList" ).jqGrid( 'navGrid', '#pecrInterfaceList', { 
				refresh : false,
				search : false, 
				edit : false, 
				add : false, 
				del : false 
			} );
			
			//그리드 하단 리플레시 버튼 생성
			$( "#ecrInterfaceList" ).navButtonAdd( "#pecrInterfaceList", {
				caption : "",
				buttonicon : "ui-icon-refresh",
				onClickButton : function() {
					fn_search();
				},
				position : "first",
				title : "Refresh",
				cursor : "pointer"
			} );
			
			//조회
			$("#btnSelect").click( function() {
				fn_search();
			} );
			
			//Execute Interface : Make ECR
			$("#btnInterFace1").click( function() {
				$( '#ecrInterfaceList' ).saveCell( kRow, idCol );
				
				var chmResultRows = [];
				getChangedChmResultData( function( data ) {
					chmResultRows = data;
					if( chmResultRows.length == 0 ) {
						alert( "선택된 항목이 없습니다." );
						return;
					}
					var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
					
					var url = 'saveECRInterface01.do';
					var formData = fn_getFormData( '#application_form' );
					var parameters = $.extend( {}, dataList, formData );
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					$.post( url, parameters, function( data2 ) {
						alert(data2.resultMsg)
						if ( data2.resultMsg == 'success' ) {
							fn_search();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				} );
			} ); //$("#btnInterFace1").click( function() {
			
			//Completed IF List Remove
			$("#btnInterFace2").click( function() {
				$( '#ecrInterfaceList' ).saveCell( kRow, idCol );
				
				var chmResultRows = [];
				getChangedChmResultData( function( data ) {
					chmResultRows = data;
					if( chmResultRows.length == 0 ) {
						alert( "선택된 항목이 없습니다." );
						return;
					}
					var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
					
					var url = 'saveECRInterface02.do';
					var formData = fn_getFormData( '#application_form' );
					var parameters = $.extend( {}, dataList, formData );
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					$.post( url, parameters, function( data2 ) {

						alert(data2.resultMsg);
						if ( data2.resultMsg == 'success' ) {
							fn_search();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				} );
			} ); //$("#btnInterFace2").click( function() {
			
		} ); //$(document).ready( function() {
		
		//선택된 항목만 리턴
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $("#ecrInterfaceList").jqGrid( 'getRowData' ), function( obj ) {
				return obj.enable_flag == 'Y';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		
		//조회
		function fn_search() {
			var sUrl = "ecrInterfaceList.do";
			$( "#ecrInterfaceList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				page : 1,
				datatype: "json",
				postData : fn_getFormData("#application_form")
			} ).trigger( "reloadGrid" );
			
		}
		</script>
	</body>
</html>
