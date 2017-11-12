<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<title>프로그램관리</title>
<!-- 		<link rel="stylesheet" type="text/css" href="http://api.typolink.co.kr/css?family=Poiret One:400" /> -->
</head>
<body>
	<div class="mainDiv" id="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
			<div class="subtitle">프로그램관리 <span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span></div>

			<table class="searchArea conSearch">
				<colgroup>
					<col width="180">
					<col width="180">
					<col width="*">
				</colgroup>
				<tr>
					<th>프로그램명</th>
					<td><input type="text" class="toUpper wid180" id="p_pgm_name" name="p_pgm_name" style="text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
					<td class="end" style="border-left: none">
						<div class="button endbox">
								<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
								<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
						</div>
					</td>
				</tr>
			</table>

			<div class="content">
				<table id="dataList"></table>
				<div id="pDataList"></div>
			</div>

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
		var cmtypedesc;
		var lodingBox;
		var lastsel;

		$(document).ready(
			function() {
				fn_all_text_upper();

				var objectHeight = gridObjectHeight(1);

				$("#dataList")
						.jqGrid(
								{
									datatype : 'json',
									mtype : 'POST',
									url : 'programList.do',
									postData : fn_getFormData("#application_form"),
									colNames : ['프로그램ID', '프로그램명', 'URL', 'Description', '상위URL', 'attribute2', 'attribute3', 'attribute4', 'attribute5', 'enable_flag_changed', 'crud'],
									colModel : [
											{name : 'pgm_id', index : 'pgm_id', width : 160, editable : true, editrules : {required : true}},
											{name : 'pgm_name', index : 'pgm_name', width : 160, editable : true},
											{name : 'file_url', index : 'file_url', width : 250, editable : true},
											{name : 'description', index : 'description', width : 250, editable : true},
											{name : 'attribute1', index : 'attribute1', width : 80,  editable : true},
											{name : 'attribute2', index : 'attribute2', width : 25, hidden : true},
											{name : 'attribute3', index : 'attribute3', width : 25, hidden : true},
											{name : 'attribute4', index : 'attribute4', width : 25, hidden : true},
											{name : 'attribute5', index : 'attribute5', width : 25, hidden : true},
											{name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : true},
											{name : 'oper', index : 'oper', width : 25, hidden : true}
									],
									gridview : true,
									toolbar : [ false, "bottom" ],
									viewrecords : true,
									autowidth : true,
									height : objectHeight,
									pager : $('#pDataList'),
									cellEdit : true, // grid edit mode 1
									cellsubmit : 'clientArray', // grid edit mode 2
									rowList : [ 100, 500, 1000 ],
									rowNum : 1000,
									rownumbers : true,
									beforeEditCell : function(
											rowid, cellname, value,
											iRow, iCol) {
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
									onPaging : function(pgButton) {
										/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
										 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
										 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
										 */
										$(this).jqGrid("clearGridData");

										/* this is to make the grid to fetch data from server on page click*/
										$(this).setGridParam({
											datatype : 'json',
											postData : {
												pageYn : 'Y'
											}
										}).triggerHandler("reloadGrid");
									},
									onCellSelect : function( rowid, iCol, cellcontent, e ) {
										var ret = $( "#dataList" ).getRowData( rowid );
										var oper = ret.oper;
										if( oper != "I" ) {
											$( "#dataList" ).jqGrid( 'setCell', rowid, 'pgm_id', '', 'not-editable-cell' );
										}
										
									},
									loadComplete : function(data) {
										var $this = $(this);
										if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
											// because one use repeatitems: false option and uses no
											// jsonmap in the colModel the setting of data parameter
											// is very easy. We can set data parameter to data.rows:
											$this.jqGrid('setGridParam', {
													datatype : 'local',
													data : data.rows,
													pageServer : data.page,
													recordsServer : data.records,
													lastpageServer : data.total
												}
											);

											// because we changed the value of the data parameter
											// we need update internal _index parameter:
											this.refreshIndex();

											if ($this.jqGrid('getGridParam', 'sortname') !== '') {
												// we need reload grid only if we use sortname parameter,
												// but the server return unsorted data
												$this.triggerHandler('reloadGrid');
											}
										} else {
											$this.jqGrid('setGridParam',{
													page : $this.jqGrid('getGridParam', 'pageServer'),
													records : $this.jqGrid('getGridParam', 'recordsServer'),
													lastpage : $this.jqGrid('getGridParam', 'lastpageServer')
												}
											);

											this.updatepager(false, true);
										}
										var rows = $( "#dataList" ).getDataIDs();

										for ( var i = 0; i < rows.length; i++ ) {
											//수정 및 결재 가능한 리스트 색상 변경
											var oper = $( "#dataList" ).getCell( rows[i], "oper" );
											
											if( oper == "" ) {
												$( "#dataList" ).jqGrid( 'setCell', rows[i], 'pgm_id', '', { color : 'black', background : '#DADADA' } );
											}
										}
									},
									editurl : "saveProgram.do",
									afterInsertRow : function(rowid, rowdata, rowelem){
										jQuery("#"+rowid).css("background", "#0AC9FF");
							        }
								});

				//grid resize
				fn_gridresize($(window), $("#dataList"));
				
				//그리드 버튼 숨김
				$("#dataList").jqGrid('navGrid', "#pDataList", {
						refresh : false,
						search : false,
						edit : false,
						add : false,
						del : false,								
					}
				);

				//Refresh
				$("#dataList").navButtonAdd('#pDataList', {
					caption : "",
					buttonicon : "ui-icon-refresh",
					onClickButton : function() {
						fn_search();
					},
					position : "first",
					title : "Refresh",
					cursor : "pointer"
				});
				
				//Del 버튼
				$("#dataList").navButtonAdd('#pDataList', {
					caption : "",
					buttonicon : "ui-icon-minus",
					onClickButton : deleteRow,
					position : "first",
					title : "Del",
					cursor : "pointer"
				});

				//Add 버튼
				$("#dataList").navButtonAdd('#pDataList', {
					caption : "",
					buttonicon : "ui-icon-plus",
					onClickButton : addChmResultRow,
					position : "first",
					title : "Add",
					cursor : "pointer"
				});

				//조회 버튼
				$("#btnSearch").click(function() {
					fn_search();
				});

				//저장버튼
				$("#btnSave").click(function() {
					fn_save();
				});
			}
		); //end of ready Function
						
		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#dataList").jqGrid('getRowData'),
					function(obj) {
						return obj.oper == 'I' || obj.oper == 'U'
								|| obj.oper == 'D';
					});

			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		//조회
		function fn_search() {

			$("#dataList").jqGrid("clearGridData");
			
			var sUrl = "programList.do";
			$("#dataList").jqGrid('setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData("#application_form")
			}).trigger("reloadGrid");
		}

		//저장
		function fn_save() {
			$('#dataList').saveCell(kRow, idCol);

			var changedData = $("#dataList").jqGrid('getRowData');

			// 변경된 체크 박스가 있는지 체크한다.
			/* for (var i = 1; i < changedData.length + 1; i++) {
				var item = $('#dataList').jqGrid('getRowData', i);

				if (item.oper != 'I' && item.oper != 'U') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}

					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#dataList').jqGrid("setRowData", i, item);
					}
				}
			} */

			if (!fn_checkValidate()) {
				return;
			}

			if (confirm('변경된 데이터를 저장하시겠습니까?') != 0) {
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData(function(data) {
					lodingBox = new ajaxLoader($('#mainDiv'), {
						classOveride : 'blue-loader',
						bgColor : '#000',
						opacity : '0.3'
					});

					chmResultRows = data;
					var dataList = {
						chmResultList : JSON.stringify(chmResultRows)
					};
					var url = 'saveProgram.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend({}, dataList, formData);

					$.post(url, parameters, function(data) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						}
					}, "json").error(function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
						lodingBox.remove();
					});
				});
			}
		}

		//필수입력 체크
		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $("#dataList").jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {
				var oper = $("#dataList").jqGrid('getCell', ids[i], 'oper');

				if (oper == 'I' || oper == 'U' || oper == 'D') {
					nChangedCnt++;

					var val1 = $("#dataList").jqGrid('getCell', ids[i], 'pgm_id');

					if ($.jgrid.isEmpty(val1)) {
						result = false;
						message = "프로그램ID Field is required";

						setErrorFocus("#dataList", ids[i], 0, 'pgm_id');
						break;
					}
				}
			}

			if (nChangedCnt == 0) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}

			if (!result) {
				alert(message);
			}

			return result;
		}

		//Del 버튼
		function deleteRow() {
			$('#dataList').saveCell(kRow, kCol);

			var selrow = $('#dataList').jqGrid('getGridParam', 'selrow');
			var item = $('#dataList').jqGrid('getRowData', selrow);
			
			if (item.oper == 'I') {
				$('#dataList').jqGrid('delRowData', selrow);
			} else {
				item.oper = 'D';

				$('#dataList').jqGrid("setRowData", selrow, item);
				var colModel = $( '#dataList' ).jqGrid( 'getGridParam', 'colModel' );
				for( var i in colModel ) {
					$( '#dataList' ).jqGrid( 'setCell', selrow, colModel[i].name,'', {background : '#FF7E9D' } );
				}
			}

			$('#dataList').resetSelection();
		}

		//Add 버튼 
		function addChmResultRow() {

			$('#dataList').saveCell(kRow, idCol);

			var item = {};
			var colModel = $('#dataList').jqGrid('getGridParam', 'colModel');

			for ( var i in colModel)
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.enable_flag = 'Y';
			item.pgm_name = $("#pgm_name").val();

			$('#dataList').resetSelection();
			$('#dataList')
					.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
			tableId = '#dataList';
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $('#dataList').jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';

			$('#dataList').jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");
		}

		//필수입력 표시
		function setErrorFocus(gridId, rowId, colId, colName) {
			$("#" + rowId + "_" + colName).focus();
			$(gridId).jqGrid('editCell', rowId, colId, true);
		}

		function cUpper(cObj) {
			cObj.value = cObj.value.toUpperCase();
		}
	</script>
</body>
</html>
