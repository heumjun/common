<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
		<title>Related ECOs</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
			<input type="hidden" name="main_name" id="main_name" />
			<input type="hidden" name="main_code" id="main_code" />
			<input type="hidden" name="states_desc" id="states_desc" />
			<input type="hidden" name="states_code" id="states_code" />
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
			<div id="relatedECOsListDiv" style="margin-top: 10px;" >
				<table id="relatedECOsList"></table>
				<div id="prelatedECOsList"></div>
			</div>
		</form>
		<script type="text/javascript">
			var main_code = window.parent.$("#main_code").val();
			var main_name = window.parent.$("#ref_main_name").val();
			var states_desc = window.parent.$("#states_desc").val();
			var eng_change_based_on = window.parent.$("#eng_change_based_on").val();
			
			var resultData = [];
			var idCol = 0;
			var kRow = 0;
			
			
			$( "#main_code" ).val( main_code );
			$( "#main_name" ).val( main_name );
			$( "#states_desc" ).val( states_desc );
			
			$(document).ready( function() {
				$( "#relatedECOsList" ).jqGrid( {
					url:'',
					datatype: "json",
					mtype: '',
					postData : fn_getFormData("#application_form"),
					colNames : [ '선택', 'ECO Name', 'States', 'Description', 'eng_rel_code' ],
					colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
					             { name : 'main_name', index : 'main_name', width : 85, editable : false, align : "center" },
					             { name : 'states_desc', index : 'states_desc', width : 60, editable : false, align : "center" },
					             { name : 'main_description', index : 'main_description', width : 500, editable : false, align : "left" },
					             { name : 'eng_rel_code', index : 'eng_rel_code', width : 60, editable : false, align : "center", hidden : true } ],
				   	rowNum:100,
				   	cmTemplate: { title: false },
				   	rowList:[100,500,1000],
				   	pager: '#prelatedECOsList',
				   	sortname: 'main_name',
				    viewrecords: true,
				    sortorder: "desc",
				    caption : "Related ECOs",
				    hidegrid: false,
				    //shrinkToFit:false,
				   	autowidth : true,
				   	height : parent.objectHeight-135,
				    cellEdit : true, // grid edit mode 1
					cellsubmit : 'clientArray', // grid edit mode 2
					emptyrecords : '데이터가 존재하지 않습니다.',
					imgpath : 'themes/basic/images',
					jsonReader : {
						root : "rows",
						page : "page",
						total : "total",
						records : "records",
						repeatitems : false,
					},
					beforeEditCell : function( rowid, cellname, value, iRow, iCol) {
						idRow = rowid;
						idCol = iCol;
						kRow = iRow;
					},
					afterSaveCell : chmResultEditEnd,
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
				
				
				$( "#relatedECOsList" ).jqGrid( 'navGrid', "#prelatedECOsList", {
					refresh : false,
					search : false,
					edit : false,
					add : false,
					del : false
				} );

				$( "#relatedECOsList" ).navButtonAdd( "#prelatedECOsList", {
					caption : "",
					buttonicon : "ui-icon-refresh",
					onClickButton : function() {
						fn_search();
					},
					position : "first",
					title : "Refresh",
					cursor : "pointer"
				} );
				
				
				$("#relatedECOsList").navButtonAdd( '#prelatedECOsList', {
					caption : "", 
					buttonicon:"ui-icon-minus", 
					onClickButton: deleteRow,
					position: "first", 
					title:"Del", 
					cursor: "pointer"
				} );
				
			 	$("#relatedECOsList").navButtonAdd( '#prelatedECOsList', {
			 		caption:"", 
					buttonicon:"ui-icon-plus", 
					onClickButton: addRow,
					position: "first", 
					title:"Add", 
					cursor: "pointer"
				} );
			 	
// 			 	//Del 버튼
				function deleteRow() {
					if( !confirm('삭제 하시겠습니까?') ) {
						return;
					}
	
					$( '#relatedECOsList' ).saveCell( kRow, idCol );
					
					var chmResultRows = [];
					getChangedChmResultData( function( data ) {
						chmResultRows = data;
						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
						
						var url = 'deleteRelatedECOs.do';
						var formData = fn_getFormData( '#application_form' );
						var parameters = $.extend( {}, dataList, formData );
						
						$.post( url, parameters, function( data ) {
							
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								fn_search();
							}
						}, "json" );
					} );	
				}
				
			 	//Add 버튼 
				function addRow() {
					eng_change_based_on = window.parent.$("#eng_change_based_on").val();
					if( $("#states_code").val() == "PLAN_ECO" ) {
			 			var rs = window.showModalDialog( "popUpEcrToEcoRelated.do?main_code=" + $("#main_code").val() + "&loginid=" + $( "#loginid" ).val() + "&eng_change_based_on=" + eng_change_based_on,
			 					window,
								"dialogWidth:1200px; dialogHeight:450px; center:on; scroll:off; status:off" );
			 			/* var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5",
								window,
								"dialogWidth:1300px; dialogHeight:460px; center:on; scroll:off; states:off" ); */
						
			 			if(rs != null) {
			 				fn_search();
			 			}
			 		} else {
			 			alert( "Plan ECO 일때 ECO 연계 할 수 있습니다." );
			 			return;
			 		}
			 		
				};
				fn_gridresize( parent.objectWindow,  $( "#relatedECOsList" ) ,-100,0.5 );
				//fn_jqGridsetHeight( $( "#divCloseFlag" ).val(), "relatedECOsList", screen.height );
				
				if( main_name == "" ) {
					$("#relatedECOsList").jqGrid( "setCaption", 'Related ECOs' );
				} else {
					$("#relatedECOsList").jqGrid( "setCaption", 'Related ECOs - ' + main_name );
				}
				
				
				//afterSaveCell oper 값 지정
				function chmResultEditEnd( irow, cellName ) {
					var item = $('#relatedECOsList').jqGrid( 'getRowData',irow );
					if ( item.oper != 'I' )
						item.oper = 'U';
					
					$('#relatedECOsList').jqGrid( "setRowData", irow, item );
					$("input.editable,select.editable", this).attr( "editable", "0" );
				}
				
			} ); //$(document).ready( function() {
			
			function fn_search() {
				if(window.parent.$("#main_code").val() == "") {
					alert('ECR 선택후 조회 바랍니다.');
				} else {
					$("#states_code").val(window.parent.$("#states_code").val());
					$("#states_desc").val(window.parent.$("#states_desc").val());
					$("#main_code").val(window.parent.$("#main_code").val());
					$("#relatedECOsList").jqGrid("setCaption", 'Related ECOs - ' + window.parent.$("#ref_main_name").val());
					var sUrl = "ecrRelatedECOsList.do";
					$( "#relatedECOsList" ).jqGrid( "clearGridData" );
					$( "#relatedECOsList" ).jqGrid( 'setGridParam', {
						mtype: 'POST',
						url : sUrl,
						datatype : 'json',
						page : 1,
						postData : fn_getFormData( "#application_form" )
					} ).trigger( "reloadGrid" );
				}
			}
			
// 			function fn_jqGridsetHeight( divCloseFlag ){
// 				if( divCloseFlag == "true" ) {
// 					fn_setHeight( "relatedECOsList", screen.height * 0.48 );
// 			    }else{
// 			    	fn_setHeight( "relatedECOsList", screen.height * 0.08 );
// 			    }
// 			}
			
			function getChangedChmResultData( callback ) {
				var changedData = $.grep( $( "#relatedECOsList" ).jqGrid( 'getRowData' ), function( obj ) {
					return obj.enable_flag == 'Y';
				} );
				
				callback.apply( this, [ changedData.concat(resultData) ] );
			}
		</script>
	</body>
</html>
