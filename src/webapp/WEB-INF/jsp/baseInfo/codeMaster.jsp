<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>CODE MASTER</title>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>
				
				<div class="subtitle">
					CodeMaster
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="./images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>

				<table class="searchArea conSearch">
					<col width="50px">
					<col width="270px">
					<col width="50px">
					<col width="130px">
					<col width="100px">
					<col width="130px">
					<col width="60px">
					<col width="50px">
					<col width="*" style="min-width:200px">


					<tr>
					<th class="first">TYPE</th>
					<td>
						<input type="text" class="required" id="cmtype" name="cmtype" onchange="javascript:this.value=this.value.toUpperCase();" />&nbsp;
						<input type="text" style="margin-left:-5px;" class="notdisabled" id="cmtypedesc" name="cmtypedesc" readonly onchange="javascript:this.value=this.value.toUpperCase();" />&nbsp;
						<input type="button" id="btnmain" name="btnmain" value="검색" class="btn_gray2" onchange="javascript:this.value=this.value.toUpperCase();" />
					</td>

					<th>CODE</th>
					<td><input type="text" class="toUpper wid180" id="cmcode" name="cmcode" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
					<th>DESCRIPTION</th>
					<td><input type="text" class="toUpper wid180" id="cmdescription" name="cmdescription" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
					<th>사용유무</th>
					<td style="border-right:none;">
						<select name="cmuseone" id="cmuseone">
								<option value="all">ALL</option>
								<option value="Y">사용</option>
								<option value="N">미사용</option>
						</select>
					</td>
					<td  class="end" style="border-left:none">
						<div class="button endbox">

							<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
							</c:if>
							
							<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
							</c:if>
							
							<c:if test="${userRole.attribute5 == 'Y'}">
								<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
							</c:if>
						</div>
					</td>
					</tr>
				</table>


				<div class="content" >
					<table id="codeMasterList"></table>
					<div id="pcodeMasterList"></div>
				</div>
				
	

<!-------------------------------------------------------------------------------
<style type="text/css">
dl.dis_search {float:left; width:100%; border:1px solid #000;}
dl.dis_search dt{float:left; padding:10px 0; border:1px solid #000; width:100px;}
dl.dis_search dd{float:left; padding:10px 0; border:1px solid #000; width:*;}
</style>

<dl class="dis_search">
	<dt>TYPE</dt>
	<dd>1</dd>
	<dt>CODE</dt>
	<dd><1/dd>
	<dt>Description</dt>
	<dd>1</dd>
	<dt>사용유무</dt>
	<dd>1</dd>
	<dt>저장.버튼</dt>
	<dd>1</dd>
</dl>


------->


			
		</form>
		</div>
		<script type="text/javascript">
		var tableId = '';
		var resultData = [];
		var fv_catalog_code = "";
		var kRow = 0;
		var kCol = 0;
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var row_selected = 0;
		var lodingBox;
		var menuDesc;
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			$( "#codeMasterList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : '',
				colNames : [ 'TYPE', 'TYPE DESC', 'CODE', 'Description', '의미', '사용유무', 'Attr1', 'Attr2', 'Attr3', 'Attr4', 'Attr5','ORDER BY', 'enable_flag_changed', 'crud' ],
				colModel : [ { name : 'sd_type', index : 'sd_type', width : 60, editable : false, editrules : { required : true } }, 
				             { name : 'sd_type_desc', index : 'sd_type_desc', width : 60, editable : false }, 
				             { name : 'sd_code', index : 'sd_code', width : 80, editable : true, editrules : { required : true } }, 
				             { name : 'sd_desc', index : 'sd_desc', width : 100, editable : true }, 
				             { name : 'sd_meaning', index : 'sd_meaning', width : 40, editable : true }, 
				             { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } }, 
				             { name : 'attribute1', index : 'attribute1', width : 60, editable : true }, 
				             { name : 'attribute2', index : 'attribute2', width : 60, editable : true }, 
				             { name : 'attribute3', index : 'attribute3', width : 60, editable : true }, 
				             { name : 'attribute4', index : 'attribute4', width : 60, editable : true }, 
				             { name : 'attribute5', index : 'attribute5', width : 60, editable : true },
				             { name : 'order_by', index : 'order_by', width : 30, editable : true },
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : true }, 
				             { name : 'oper', index : 'oper', width : 25, hidden : true }, ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : objectHeight,
				pager : $( '#pcodeMasterList' ),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				rownumbers : true,
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
					
					if(menuDesc[2] != null && menuDesc[2] != "") {
						$('#codeMasterList').jqGrid('setLabel', "attribute1", menuDesc[2]);	
					} else {
						$('#codeMasterList').jqGrid('setLabel', "attribute1", "Attr1");	
					}
					if(menuDesc[3] != null && menuDesc[3] != "") {
						$('#codeMasterList').jqGrid('setLabel', "attribute2", menuDesc[3]);
					} else {
						$('#codeMasterList').jqGrid('setLabel', "attribute2", "Attr2");
					}
					if(menuDesc[4] != null && menuDesc[4] != "") {
						$('#codeMasterList').jqGrid('setLabel', "attribute3", menuDesc[4]);
					} else {
						$('#codeMasterList').jqGrid('setLabel', "attribute3", "Attr3");
					}
					if(menuDesc[5] != null && menuDesc[5] != "") {
						$('#codeMasterList').jqGrid('setLabel', "attribute4", menuDesc[5]);
					} else {
						$('#codeMasterList').jqGrid('setLabel', "attribute4", "Attr4");
					}
					if(menuDesc[6] != null && menuDesc[6] != "") {
						$('#codeMasterList').jqGrid('setLabel', "attribute5", menuDesc[6]);
					} else {
						$('#codeMasterList').jqGrid('setLabel', "attribute5", "Attr5");
					}
					
					
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
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

						if( $this.jqGrid( 'getGridParam', 'sortname') !== '' ) {
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
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					row_selected = rowid;
				
					if( rowid != null ) {
						var ret = $( "#codeMasterList" ).getRowData( rowid );

						if ( ret.oper == "" ) {
							$( "#codeMasterList" ).jqGrid( 'setCell', rowid, 'sd_code', '', 'not-editable-cell' );
							//$( "#codeMasterList" ).jqGrid( 'setCell', rowid, 'sd_desc', '', 'not-editable-cell' );
							//$( "#codeMasterList" ).jqGrid( 'setCell', rowid, 'sd_meaning', '', 'not-editable-cell');
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#codeMasterList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#codeMasterList" ).getCell( rows[i], "oper" );

						if( oper == "" ) {
							$( "#codeMasterList" ).jqGrid( 'setCell', rows[i], 'sd_type', '', { color : 'black', background : '#DADADA' } );
							$( "#codeMasterList" ).jqGrid( 'setCell', rows[i], 'sd_type_desc', '', { color : 'black', background : '#DADADA' } );
							$( "#codeMasterList" ).jqGrid( 'setCell', rows[i], 'sd_code', '', { color : 'black', background : '#DADADA' } );
							//$( "#codeMasterList" ).jqGrid( 'setCell', rows[i], 'sd_desc', '', { color : 'black', background : '#DADADA' } );
							//$( "#codeMasterList" ).jqGrid( 'setCell', rows[i], 'sd_meaning', '', { color : 'black', background : '#DADADA' } );
						}
					}

					//미입력 영역 회색 표시
					$( "#codeMasterList .disables" ).css( "background", "#DADADA" );
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );

			//grid resize
			fn_gridresize( $(window), $( "#codeMasterList" ) );

			//그리드 버튼 숨김
			$( "#codeMasterList" ).jqGrid( 'navGrid', "#pcodeMasterList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			

			<c:if test="${userRole.attribute1 == 'Y'}">
			//Refresh
			$( "#codeMasterList" ).navButtonAdd( '#pcodeMasterList', {
				caption : "",
				buttonicon : "ui-icon-refresh",
				onClickButton : function() {
					fn_search();
				},
				position : "first",
				title : "Refresh",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute3 == 'Y'}">
			//Del 버튼
			$( "#codeMasterList" ).navButtonAdd( '#pcodeMasterList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "Del",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			//Add 버튼
			$( "#codeMasterList" ).navButtonAdd( '#pcodeMasterList', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "Add",
				cursor : "pointer"
			});
			</c:if>
			
			//조회 버튼
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );
			
			//저장버튼
			$( "#btnSave" ).click( function() {
				fn_save();
			} );

			//엑셀 export 버튼
			$("#btnExcelExport").click(function() {
				fn_downloadStart();
				fn_excelDownload();	
			});
			
			//... 버튼
			$( "#btnmain" ).click( function() {
				var cmtype = document.application_form.cmtype.value;
				var cmtypedesc = document.application_form.cmtypedesc.value;
				var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoMainSdCode.do&cmtype=" + cmtype + "&cmtypedesc=" + encodeURI(encodeURIComponent(cmtypedesc)),
						window,
						"dialogWidth:540px; dialogHeight:450px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#cmtype" ).val( rs[0] );
					$( "#cmtypedesc" ).val( rs[1] );
					menuDesc = rs; 
				}
			} );
			/* 2015-11-27 황경호 삭제 */
			/* $( "#cmtype" ).keydown( function( e ) {
				if( e.which == 9 ) {
					var rs = popupBaseInfo();
	
					if ( rs != null ) {
						$( "#cmtype" ).val( rs[0] );
						$( "#cmtypedesc" ).val( rs[1] );
						$( "#cmcode" ).focus();
					}
				}
			} ); */
		} ); //end of ready Function 

		/* 2015-11-27 황경호 삭제 */
		/* function popupBaseInfo() {
			var cmtype = $( "#cmtype" ).val();
			var rs = window.showModalDialog( "popUpCodeMaster.do?cmd=codeMasterType&cmtype=" + cmtype,
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
			
			return rs;
		} */
		/* 2015-11-27 황경호 삭제 */
		/* function searchCodeMasterType( obj, nCode, nData, nRow, nCol ) {
			searchIndex = $(obj).closest( 'tr' ).get(0).id;
			$(tableId).saveCell( nRow, nCol );

			var item = $(tableId).jqGrid( 'getRowData', searchIndex );
			var oper = item.oper;
			if( oper != 'I' ) {
				return;
			}
			
			var cmtype = item.sd_code;
			var rs = window.showModalDialog( "popUpCodeMaster.do?cmd=codeMasterType&cmtype=" + cmtype, 
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

			if( rs != null ) {
				$(tableId).setCell( searchIndex, 'sd_code', rs[0] );
				$(tableId).setCell( searchIndex, 'sd_desc', rs[1] );
			}
		} */

		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#codeMasterList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}

		//조회
		function fn_search() {
			var cmType = $( "input[name=cmtype]" ).val();
			
			if ( cmType == "" ) {
				alert( "TYPE을 입력해주세요." );
				return;
			}

			$( "#codeMasterList" ).jqGrid( "clearGridData" );
			
			var sUrl = "codeMasterList.do";
			$( "#codeMasterList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//저장
		function fn_save() {
			$( '#codeMasterList' ).saveCell( kRow, idCol );
			
			var changedData = $( "#codeMasterList" ).jqGrid( 'getRowData' );
			
			// 변경된 체크 박스가 있는지 체크한다.
			for( var i = 1; i < changedData.length + 1; i++ ) {
				var item = $( '#codeMasterList' ).jqGrid( 'getRowData', i );
				
				if ( item.oper != 'I' && item.oper != 'U' ) {
					if ( item.enable_flag_changed != item.enable_flag ) {
						item.oper = 'U';
					}
					
					if ( item.oper == 'U' ) {
						// apply the data which was entered.
						$('#codeMasterList').jqGrid( "setRowData", i, item );
					}
				}
			}
			
			if ( !fn_checkValidate() ) {
				return;
			}
			
			if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveCodeMaster.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
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

		//필수입력 체크
		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#codeMasterList" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#codeMasterList" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					nChangedCnt++;

					var val1 = $( "#codeMasterList" ).jqGrid( 'getCell', ids[i], 'sd_type' );

					if ( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "CodeMaster Type Field is required";

						setErrorFocus( "#codeMasterList", ids[i], 0, 'sd_type' );
						break;
					}
				}
			}

			if ( nChangedCnt == 0 ) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}

			if ( !result ) {
				alert( message );
			}

			return result;
		}
		
		//Del 버튼
		function deleteRow() {
			if( row_selected == 0 ) {
				return;
			}
			
			$( '#codeMasterList' ).saveCell( kRow, kCol );

			var selrow = $( '#codeMasterList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#codeMasterList' ).jqGrid( 'getRowData', selrow );

			if ( item.oper == 'I' ) {
				$( '#codeMasterList' ).jqGrid( 'delRowData', selrow );
			} else {
				alert( '저장된 데이터는 삭제할 수 없습니다.' );
			}
			
			$( '#codeMasterList' ).resetSelection();
		}

		//Add 버튼 
		function addChmResultRow() {
			if ( $( "#cmtype" ).val() == '' ) {
				alert( '조회 후 입력해주세요' );
				$( "#cmtype" ).focus();
				return;
			}
			
			$( '#codeMasterList' ).saveCell( kRow, idCol );

			var item = {};
			var colModel = $( '#codeMasterList' ).jqGrid( 'getGridParam', 'colModel' );

			for( var i in colModel )
				item[colModel[i].name] = '';
			
			item.oper = 'I';
			item.enable_flag = 'Y';
			item.sd_type = $("#cmtype").val();
			item.sd_type_desc = $("#cmtypedesc").val();
			
			$( '#codeMasterList' ).resetSelection();
			$( '#codeMasterList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
			tableId = '#codeMasterList';
		}
		
		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
			var item = $( '#codeMasterList' ).jqGrid( 'getRowData', irowId );
			if( item.oper != 'I' ){
				item.oper = 'U';
				$( '#codeMasterList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			}
			$( '#codeMasterList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
			
			
		}

		//필수입력 표시
		function setErrorFocus( gridId, rowId, colId, colName ) {
			$( "#" + rowId + "_" + colName ).focus();
			$(gridId).jqGrid( 'editCell', rowId, colId, true );
		}

		function cUpper( cObj ) {
			cObj.value = cObj.value.toUpperCase();
		}
		
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#codeMasterList" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#codeMasterList" ).jqGrid( "getGridParam", "colModel" );
			for(var i=1; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
					colName.push(cn[i]);
					dataName.push(cm[i]['index']);	
				}
			}
			$( '#p_col_name' ).val(colName);
			$( '#p_data_name' ).val(dataName);
			var f    = document.application_form;
			f.action = "codeMasterExcelExport.do";
			f.method = "post";
			f.submit();
		}
		</script>
	</body>
</html>
