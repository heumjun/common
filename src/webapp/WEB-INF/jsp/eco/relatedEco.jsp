<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Related ECOs</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" name="main_name" id="main_name" />
			<input type="hidden" name="main_code" id="main_code" />
			<input type="hidden" name="states_desc" id="states_desc" />
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
			
			<div id="relatedEcoDiv" style="margin-top: 10px;" >
				<table id="relatedEco" style="width: 100%; height: 50%"></table>
				<div id="prelatedEco"></div>
			</div>
		</form>
		<script type="text/javascript">
			var main_code = window.parent.$("#main_code").val();
			var main_name = window.parent.$("#ref_main_name").val();
			var states_desc = window.parent.$("#states_desc").val();
			
			var resultData = [];
			var idCol = 0;
			var kRow = 0;
			
			
			$( "#main_code" ).val( main_code );
			$( "#main_name" ).val( main_name );
			$( "#states_desc" ).val( states_desc );
			
			$(document).ready( function() {
				$( "#relatedEco" ).jqGrid( {
					url:'',
					datatype: "json",
					mtype: '',
					postData : fn_getFormData("#application_form"),
					colNames : [ 'Name', 'Related ECR', 'Type', 'ECO Cause', '생성자', '결재자', '상태', 'Project', 'ECO Description' ],
					colModel : [ { name : 'eco_name', index : 'eco_name', width : 60, align : "center" },
					             { name : 'rel_ecr', index : 'rel_ecr', width : 80, align : "center" },
					             { name : 'permanent_temporary_flag_desc', index : 'permanent_temporary_flag_desc', width : 50, align : "center" },
					             { name : 'cause_desc', index : 'cause_desc', width : 200, align : "left" },
					             { name : 'design_engineer_name', index : 'design_engineer_name', width : 200, align : "left" },
					             { name : 'manufacturing_engineer', index : 'manufacturing_engineer', width : 200, align : "left" },
					             { name : 'states_desc', index : 'states_desc', width : 50, align : "left" },
					             { name : 'eng_eco_project', index : 'eng_eco_project', width : 60, align : "left" },
					             { name : 'main_description', index : 'main_description', width : 300, align : "left" } ],
				   	rowNum:100,
				   	cmTemplate: { title: false },
// 				   	rowList:[100,500,1000],
				   	pager: '#prelatedEco',
				   	sortname: 'main_name',
				    viewrecords: true,
				    sortorder: "desc",
				    caption : "Related ECOs",
				    hidegrid: false,
// 				    shrinkToFit:false,
				   	autowidth : true,
					pgbuttons : false,
					pgtext : false,
					pginput : false,
					height : parent.objectHeight-135,
				    cellEdit : true, // grid edit mode 1
					cellsubmit : 'clientArray', // grid edit mode 2
					//emptyrecords : '데이터가 존재하지 않습니다.',
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
				
				
				$( "#relatedEco" ).jqGrid( 'navGrid', "#prelatedEco", {
					refresh : false,
					search : false,
					edit : false,
					add : false,
					del : false
				} );

// 				$( "#relatedEco" ).navButtonAdd( "#prelatedEco", {
// 					caption : "",
// 					buttonicon : "ui-icon-refresh",
// 					onClickButton : function() {
// 						fn_search();
// 					},
// 					position : "first",
// 					title : "Refresh",
// 					cursor : "pointer"
// 				} );
				
				
// 				$("#relatedEco").navButtonAdd( '#prelatedEco', {
// 					caption : "", 
// 					buttonicon:"ui-icon-minus", 
// 					onClickButton: deleteRow,
// 					position: "first", 
// 					title:"Del", 
// 					cursor: "pointer"
// 				} );
				
// 			 	$("#relatedEco").navButtonAdd( '#prelatedEco', {
// 			 		caption:"", 
// 					buttonicon:"ui-icon-plus", 
// 					onClickButton: addRow,
// 					position: "first", 
// 					title:"Add", 
// 					cursor: "pointer"
// 				} );
			 	
// 			 	//Del 버튼
// 				function deleteRow() {
// 					if( !confirm('삭제 하시겠습니까?') ) {
// 						return;
// 					}
	
// 					$( '#relatedEco' ).saveCell( kRow, idCol );
					
// 					var chmResultRows = [];
// 					getChangedChmResultData( function( data ) {
// 						chmResultRows = data;
// 						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
						
// 						var url = 'deleteRelatedECOs.do';
// 						var formData = fn_getFormData( '#application_form' );
// 						var parameters = $.extend( {}, dataList, formData );
						
// 						$.post( url, parameters, function( data ) {
// 							var msg="";
// 							var result = "";
							
// 							for( var keys in data ) {
// 								for( var key in data[keys] ) {
// 									if( key == 'Result_Msg' ) {
// 										msg=data[keys][key];
// 									}
									
// 									if (key == 'result') {
// 										result = data[keys][key];
// 									}
// 								}
// 							}
// 							alert( msg );
							
// 							if ( result == 'success' ) {
// 								fn_search();
// 							}
// 						}, "json" );
// 					} );	
// 				}
				
			 	//Add 버튼 
// 				function addRow() {
// 			 		if( states_desc == "Plan ECO" ) {
// 			 			var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEcrToEcoRelated&main_code=" + main_code + "&loginid=" + $( "#loginid" ).val(),
// 			 					window,
// 								"dialogWidth:1100px; dialogHeight:420px; center:on; scroll:off; status:off" );
			 			
// 			 			if(rs != null) {
// 			 				fn_search();
// 			 			}
// 			 		} else {
// 			 			alert( "Plan ECO 일때 ECO 연계 할 수 있습니다." );
// 			 			return;
// 			 		}
			 		
// 				};
				
				//fn_jqGridsetHeight( $( "#divCloseFlag" ).val(), "relatedEco", screen.height );
				
				if( main_name == "" ) {
					$("#relatedEco").jqGrid( "setCaption", 'Related ECOs' );
				} else {
					$("#relatedEco").jqGrid( "setCaption", 'Related ECOs - ' + main_name );
				}
				
				
				//afterSaveCell oper 값 지정
				function chmResultEditEnd( irow, cellName ) {
					var item = $('#relatedEco').jqGrid( 'getRowData',irow );
					if ( item.oper != 'I' )
						item.oper = 'U';
					
					$('#relatedEco').jqGrid( "setRowData", irow, item );
					$("input.editable,select.editable", this).attr( "editable", "0" );
				}
				
				fn_gridresize( parent.objectWindow,$( "#relatedEco" ),-100,0.5 );
			} ); //$(document).ready( function() {
			
			function fn_search() {
				if(window.parent.$("#main_code").val() == "") {
					alert('ECO 선택후 조회 바랍니다.');
				} else {
					$("#main_code").val(window.parent.$("#main_code").val());
					$("#relatedEco").jqGrid("setCaption", 'Related ECOs - ' + window.parent.$("#ref_main_name").val());
					var sUrl = "infoSelectRelatedEco.do";
					$( "#relatedEco" ).jqGrid( 'setGridParam', {
						url : sUrl,
						mtype: 'POST',
						datatype : 'json',
						page : 1,
						postData : fn_getFormData( "#application_form" )
					} ).trigger( "reloadGrid" );	
				}				
			}
			
// 			function fn_jqGridsetHeight( divCloseFlag ){
// 				if( divCloseFlag == "true" ) {
// 					fn_setHeight( "relatedEco", screen.height * 0.48 );
// 			    }else{
// 			    	fn_setHeight( "relatedEco", screen.height * 0.08 );
// 			    }
// 			}
			
// 			function getChangedChmResultData( callback ) {
// 				var changedData = $.grep( $( "#relatedEco" ).jqGrid( 'getRowData' ), function( obj ) {
// 					return obj.enable_flag == 'Y';
// 				} );
				
// 				callback.apply( this, [ changedData.concat(resultData) ] );
// 			}
		</script>
	</body>
</html>
