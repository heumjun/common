<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<title>공지사항관리</title>
<!-- 		<link rel="stylesheet" type="text/css" href="http://api.typolink.co.kr/css?family=Poiret One:400" /> -->
</head>
<body>
	<div class="mainDiv" id="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
			
			<div class="subtitle">공지사항관리 <span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span></div>

			<table class="searchArea conSearch">
				<colgroup>
					<col width="*">
				</colgroup>
				<tr>
					<td class="end" style="border-left: none">
						<div class="button endbox">
							<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
							<input type="button" class="btnAct btn_blue" id="btnRegister" name="btnRegister" value="등록" />
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

				$("#dataList").jqGrid(
								{
									datatype : 'json',
									mtype : 'POST',
									url : 'noticeList.do',
									postData : fn_getFormData("#application_form"),
									colNames : ['SEQ', '제목', '내용', '조회수', '시작일', '종료일', '등록자', '등록일자', '<input type="checkbox" id="chkNotify_yn" onclick="checkBoxHeader(event, this)"/> 공지여부', '첨부파일', '파일', 'enable_flag_changed', 'crud'],
									colModel : [
											{name : 'seq', index : 'seq', width : 25, hidden : true},
											{name : 'subject', index : 'subject', width : 200, hidden : false, editable : true, editrules : { required : true }, editoptions:{size:100}},
											{name : 'contents', index : 'contents', width : 260, editable : true, editrules : { required : true }, edittype : "textarea", editoptions:{rows:"10",cols:"87"}},
											{name : 'read_count', index : 'read_count', width : 60, editable : false, align : "center"},
											{ name: 'start_date', index: 'start_date', width: 60, editable: true, align : "center",
												editoptions: { 
													dataInit: function(el) { 
														$(el).datepicker({
													    	dateFormat: 'yy-mm-dd',
													    	prevText: '이전 달',
														    nextText: '다음 달',
														    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
														    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
														    dayNames: ['일','월','화','수','목','금','토'],
														    dayNamesShort: ['일','월','화','수','목','금','토'],
														    dayNamesMin: ['일','월','화','수','목','금','토'],
														    showMonthAfterYear: true,
														    yearSuffix: '년',
														    onSelect: function () {
							                                    $("#dataList").jqGrid("saveCell", idRow, idCol);
							                                }
											  			}); 
													} 
												} 
											},
											{ name: 'end_date', index: 'end_date', width: 60, editable: true, align : "center",
												editoptions: { 
													dataInit: function(el) { 
														$(el).datepicker({
													    	dateFormat: 'yy-mm-dd',
													    	prevText: '이전 달',
														    nextText: '다음 달',
														    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
														    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
														    dayNames: ['일','월','화','수','목','금','토'],
														    dayNamesShort: ['일','월','화','수','목','금','토'],
														    dayNamesMin: ['일','월','화','수','목','금','토'],
														    showMonthAfterYear: true,
														    yearSuffix: '년'	,
													    	onSelect: function () {
							                                    $("#dataList").jqGrid("saveCell", idRow, idCol);
							                                }
											  			}); 
													} 
												},
												editrules: { date: true } 
											},
											{name : 'create_by_name', index : 'create_by_name', width : 60, editable : false, align : "center"},
											{name : 'create_date', index : 'create_date', width : 60, editable : false, align : "center"},
											{name : 'notify_yn', index : 'notify_yn', width : 60, align: 'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }},
											{name : 'filename', index : 'filename', width:150, align:'center', sortable:true, title:false, formatter: fileFormatter },
											{name : 'attach', index : 'attach', width : 50, align:'center', sortable:true, title:false, formatter: uploadFormatter},
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
									beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
										idRow = rowid;
										idCol = iCol;
										kRow = iRow;
										kCol = iCol;
									},
									beforeSaveCell : chmResultEditEnd,
									afterEditCell: function (rowid, cellname, value, iRow, iCol) {
										idRow = iRow;
										idCol = iCol;
								    },
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
									},
									editurl : "saveNotice.do",
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
				/* $("#dataList").navButtonAdd('#pDataList', {
					caption : "",
					buttonicon : "ui-icon-plus",
					onClickButton : addChmResultRow,
					position : "first",
					title : "Add",
					cursor : "pointer"
				}); */

				//조회 버튼
				$("#btnSearch").click(function() {
					fn_search();
				});
				
				//조회 버튼
				$("#btnRegister").click(function() {
					fn_register();
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
			
			var sUrl = "noticeList.do";
			$("#dataList").jqGrid('setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData("#application_form")
			}).trigger("reloadGrid");
		}
		
		//등록
		function fn_register() {

			var left = (screen.weight/2)-(600/2);
			var top = (screen.height/2)-(480/2);
			
			window.open('noticeRegister.do','NoticeRegister','toolbar=no, location=no,directories=no, status=no, menubar=no, scrollbars=no, resizable=no,copyhistory=no,'
	    		    + 'width=600, height=540, top='+top+', left='+left).focus();
		}

		//저장
		function fn_save() {
			$('#dataList').saveCell(kRow, idCol);

			var changedData = $("#dataList").jqGrid('getRowData');

			// 변경된 체크 박스가 있는지 체크한다.
			for (var i = 1; i < changedData.length + 1; i++) {
				var item = $('#dataList').jqGrid('getRowData', i);
				
				if (item.oper != 'I' && item.oper != 'U' && item.oper != 'D') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}

					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#dataList').jqGrid("setRowData", i, item);
					}
				}
			}

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
					var url = 'saveNotice.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend({}, dataList, formData);

					$.post(url, parameters, function(data) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						}
					}, "json").error(function() {
						alert("시스템 오류입니다.\n전산공지사항에게 문의해주세요.");
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

					var subject = $("#dataList").jqGrid('getCell', ids[i], 'subject');
					var contents = $("#dataList").jqGrid('getCell', ids[i], 'contents');
					var start_date = $("#dataList").jqGrid('getCell', ids[i], 'start_date');
					var end_date = $("#dataList").jqGrid('getCell', ids[i], 'end_date');

					if ($.jgrid.isEmpty(subject)) {
						result = false;
						message = "제목 Field is required";

						setErrorFocus("#dataList", ids[i], 0, 'subject');
						break;
					}
					if ($.jgrid.isEmpty(contents)) {
						result = false;
						message = "내용 Field is required";

						setErrorFocus("#dataList", ids[i], 0, 'contents');
						break;
					}
					
					//시작일 종료일 Validation				
					if(!$.jgrid.isEmpty(start_date) && !$.jgrid.isEmpty(end_date)) {
						
						var startDateArr = start_date.split('-');
						var endDateArr = end_date.split('-');
						
						var startDateCompare = new Date(startDateArr[0], startDateArr[1], startDateArr[2]);
				        var endDateCompare = new Date(endDateArr[0], endDateArr[1], endDateArr[2]);
				        
				        if(startDateCompare.getTime() > endDateCompare.getTime()) {
				        	result = false;
				        	message = "종료일은 시작일보다  이후 날짜로 선택하세요.";
				        	setErrorFocus("#dataList", ids[i], 0, 'start_date');
				        	break;
				        }
						
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
			item.notify_yn = 'Y';

			$('#dataList').resetSelection();
			$('#dataList').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
			tableId = '#dataList';
			
			//jQuery("#dataList").jqGrid('editGridRow', "new", {width:560, height:360, reloadAfterSubmit : false});
		}
		
		//Add 버튼 
		function editChmResultRow() {
			var gr = jQuery("#dataList").jqGrid('getGridParam','selrow');
			if( gr != null ) jQuery("#dataList").jqGrid('editGridRow', gr, {width:560, height:360, reloadAfterSubmit:false});
			else alert("Please Select Row");
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
		
		function checkBoxHeader(e, tObj) {
	  		e = e||event;/* get IE event ( not passed ) */
	  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	  		
	  		var isChk = $("input[id="+tObj.id+"]").is(":checked");
	  		var cellName = tObj.id.toLowerCase().replace("chk", "");
	  		
	  		if(isChk){
	  			$("#dataList").jqGrid('resetSelection');
	            var ids = $("#dataList").jqGrid('getDataIDs');
	            for (var i=0, il=ids.length; i < il; i++) {
	                $("#dataList").jqGrid('setCell',ids[i], cellName, "Y");
	            }
	  		} else {
	  			$("#dataList").jqGrid('resetSelection');
	            var ids = $("#dataList").jqGrid('getDataIDs');
	            for (var i=0, il=ids.length; i < il; i++) {
	                $("#dataList").jqGrid('setCell',ids[i], cellName, "N");
	            }
	  		}
		}
		
		function uploadFormatter(cellvalue, options, rowObject ) {
			return "<img src=\"./images/icon_upload.png\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"go_Add('"+rowObject.seq+"','" + rowObject.oper +"')\">";
		}
		
		function go_Add(seq, oper)
		{
		    var url = "popUpNoticeAttachAdd.do?";
		    url += "p_seq="+seq;
		    
		    if(oper == 'undefined' || oper == null) {
				window.open(url,"","width=520px,height=120px,top=300,left=400,resizable=no,scrollbars=auto,status=no");    
		    } else {
		    	alert("저장 후 등록 가능합니다.");
		    	return false;
		    }
		}
		
		function fileFormatter(cellvalue, options, rowObject ) {
			
			if(cellvalue == null) {
				return '';		
			} else {
				return "<a href=\"#none\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"fileView('"+rowObject.seq+"');\">" + cellvalue + "</a>";					
			}
		}
		
		function fileView(seq ) {
			var attURL = "noticeFileView.do?";
		    attURL += "p_seq="+seq;
		
		    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
		
		    //window.showModalDialog(attURL,"",sProperties);
		    window.open(attURL,"",sProperties);
		    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
		}
	</script>
</body>
</html>
