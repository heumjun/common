<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>DOCUMENT</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		
		<div id="wrap">
			<form id="application_form" name="application_form" enctype="multipart/form-data">
				<%
					String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString();
				%>
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				<input type="hidden" id="sType" name="sType" value="ecoAddEcrRink" />
				<input type="hidden" name="document_code" id="document_code" />
				<input type="hidden" name="main_name" id="main_name" />
				<input type="hidden" name="main_code" id="main_code" />
				<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag%>" />
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
				<div style="margin:10px 0 0 10px;">
					<span style="font-size:15px;font-weight: bold; color:white; background:red;">작성자 Promote 전 문서첨부를 해주세요.</span>
				</div>
				<div id="docListDiv" style="margin-top: 10px;" >
					<table id="docList"></table>
					<div id="pdocList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var tableId = '';
		var resultData = [];
		var enable_flag = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var cmtypedesc;
		var kRow = 0;
		var kCol = 0;
		var maincode = window.parent.$( "#main_code" ).val();
		var main_name = window.parent.$( "#ref_main_name" ).val();

		var states_desc = window.parent.$( "#states_desc" ).val();
		var locker_by = window.parent.$( "#locker_by" ).val();

		var item_code = window.parent.$( "#item_code" ).val();
		var rev_no = window.parent.$( "#rev_no" ).val();
		var states_desc = window.parent.$( "#states_desc" ).val();

		$( "#main_code" ).val( maincode );
		$( "#main_name" ).val( main_name );

		$(document).ready( function() {
			$( "#docList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'docList.do',
				postData : fn_getFormData("#application_form"),
				colNames : [ '선택', '코드', '파일명', 'Commentes', 'oper' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } }, 
				             { name : 'document_code', index : 'document_code', hidden : true }, 
				             { name : 'filename', states_desc : 'filename', width : 300, editable : false, editoptions : { size : 290 } }, 
				             { name : 'commentes', index : 'commentes', width : 400, editable : false, editoptions : { size : 399 } }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : parent.objectHeight-168,
				caption : "Supporting Documents",
				hidegrid : false,
				pager : $('#pdocList'),
				sortname : 'filename',
				sortorder : "desc",
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				beforeSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				ondblClickRow : function( rowid, cellname, value, iRow, iCol ) {
					//document  값 넣기
					if( value == 2 ) {
						var item = $( '#docList' ).jqGrid( 'getRowData', rowid );
						var document_code = item.document_code;
						$( "#document_code" ).val( document_code );
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
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
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

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
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

			//fn_jqGridsetHeight( $( "#divCloseFlag" ).val(), "docList", screen.height );

			if( item_code != undefined ) {
				var titles = "Supporting Documents - " + item_code;

				if( rev_no != "" )
					titles += " (" + rev_no + ")";

				if( states_desc != "" )
					titles += " (" + states_desc + ")";

				$( "#docList" ).jqGrid( "setCaption", titles );
			} else if( main_name != undefined) {
				$( "#docList" ).jqGrid( "setCaption", 'Supporting Documents - ' + main_name );
			} else {
				$( "#docList" ).jqGrid( "setCaption", 'Supporting Documents' );
			}

			$( "#docList" ).jqGrid( 'navGrid', "#pdocList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			$( "#docList" ).navButtonAdd( "#pdocList", {
				caption : "",
				buttonicon : "ui-icon-refresh",
				onClickButton : function() {
					fn_search();
				},
				position : "first",
				title : "Refresh",
				cursor : "pointer"
			} );
			
			$( "#docList" ).navButtonAdd( '#pdocList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "Del",
				cursor : "pointer",
				id: "del_doc"
			} );
			
			$( "#docList" ).navButtonAdd( '#pdocList', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "Add",
				cursor : "pointer",
				id: "add_doc"
			} );
			funcButtonSet();
			
// 			$( '#btnAdd' ).click( function() {
// 				var maincode = parent.document.getElementById( "main_code" ).value;

// 				if( maincode == "" ) {
// 					alert( "조회 후 추가해주세요." );
// 					return;
// 				}

// 				window.showModalDialog( "docPopupAdd.do?cmd=popupDocAdd&maincode=" + maincode, 
// 						window,
// 						"dialogWidth:800px; dialogHeight:460px; center:on; scroll:off; status:off" );
// 			} );
			fn_gridresize( parent.objectWindow,  $( "#docList" ) ,-70,0.5 );
		} ); //end of ready Function 
		function funcButtonSet(){
			
			if(( states_desc == "Create" || states_desc == "Approved" ) && locker_by == $( "#loginid" ).val() ) {
				$('#del_doc').show();
				$('#add_doc').show();
			} else {
				$('#del_doc').hide();
				$('#add_doc').hide();
			}
		}
		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
			var item = $( '#docList' ).jqGrid( 'getRowData', irowId );

			if( item.oper != 'I' )
				item.oper = 'U';

			$( '#docList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}
		
		//Add 버튼 
		function addChmResultRow() {
			var maincode = parent.document.getElementById( "main_code" ).value;

			if (maincode == "") {
				alert("조회 후 추가해주세요.");
				return;
			}

			var rs = window.showModalDialog( "popUpDocAdd.do?maincode=" + maincode, 
					window,
					"dialogWidth:800px; dialogHeight:460px; center:on; scroll:off; status:off" );

			if( rs != null ) {
				fn_search();
			}
		}

		//Del 버튼
		function deleteRow() {
			if( !( ( "Create" == states_desc || "Approved" == states_desc ) && locker_by == $( "#loginid" ).val() ) ) {
				alert( "삭제할 권한이 없습니다." );
			} else {
				var quest = confirm('삭제 하시겠습니까?');

				if ( quest ) {
					// 예를 선택하실 경우;;
					$( '#docList' ).saveCell( kRow, idCol );

					var chmResultRows = [];
					getChangedChmResultData( function( data ) {
						
						if( data.length == 0 ) {
							alert("삭제할 문서를 선택해주세요.");
							return;
						}
						
						chmResultRows = data;

						var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

						var url = 'delDoc.do';
						var formData = fn_getFormData( '#application_form' );
						var parameters = $.extend( {}, dataList, formData );
						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								fn_search();
							}
						}, "json").error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
					    	//lodingBox.remove();	
						} );
					} );
				}
			}
		}

		function getChangedChmResultData( callback ) {
			//가져온 배열중에서 필요한 배열만 골라내기 
			var changedData = $.grep( $( "#docList" ).jqGrid( 'getRowData' ), function(obj) {
				return obj.enable_flag == "Y";
			} );

			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		function fn_downLoadFile() {
			var sUrl = "docDownloadFile.do";
			var f = document.application_form;
			
			f.action = sUrl;
			f.method = "post";
			f.submit();
		}
		
		function fn_search() {
			var sUrl = "docList.do";
			
			maincode = window.parent.$( "#main_code" ).val();
			main_name = window.parent.$( "#ref_main_name" ).val();
			states_desc = window.parent.$( "#states_desc" ).val();
			locker_by = window.parent.$( "#locker_by" ).val();
			item_code = window.parent.$( "#item_code" ).val();
			rev_no = window.parent.$( "#rev_no" ).val();
			states_desc = window.parent.$( "#states_desc" ).val();
			
			$( "#main_code" ).val( maincode );
			$( "#main_name" ).val( main_name );
			funcButtonSet();
			$( "#docList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		</script>
	</body>
</html>
