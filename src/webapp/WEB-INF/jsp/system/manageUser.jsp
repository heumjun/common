<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<title>사용자관리</title>
<!-- 		<link rel="stylesheet" type="text/css" href="http://api.typolink.co.kr/css?family=Poiret One:400" /> -->
</head>
<body>
	<div class="mainDiv" id="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
			<div class="subtitle">사용자관리 <span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span></div>

			<table class="searchArea conSearch">
				<colgroup>
					<col width="180">
					<col width="180">
					<col width="180">
					<col width="180">
					<col width="180">
					<col width="180">
					<col width="*">
				</colgroup>
				<tr>
					<th>사용자명</th>
					<td style="text-align: center;"><input type="text" class="toUpper wid180" id="p_user_name" name="p_user_name" style="text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
					<th>부서명</th>
					<td style="text-align: center;"><input type="text" class="toUpper wid200" id="p_dept_name" name="p_dept_name" style="text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
					<th>사용자 권한명</th>
					<td style="text-align: center;"><input type="text" class="toUpper wid180" id="p_author_name" name="p_author_name" style="text-align: center;" onchange="javascript:this.value=this.value.toUpperCase();" /></td>
					<td class="end" style="border-left: none">
						<div class="button endbox">
							<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
							<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
						</div>
					</td>
				</tr>
			</table>

			<div class="content">
				<div style="float:left; width: 85%" id="dataListDiv" >
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
				<div style="float:right; width: 14%" id="roleListDiv">
					<table id='roleListTable'><thead><tr><th>사용자 권한</th></tr></thead><tbody></tbody></table>
				</div>
			</div>
			
			<div id="popLayer" style="text-align: left; background:white; display:none; ">
				<div class="ex_upload">권한 선택</div>
				<table class="searchArea2 conSearch">
					<tr>
						<td>
							<div style="text-align: right;margin-right:5px">
								<input type="button" class="btn_blue" id="roleClose" value="선택완료" />
							</div>		
						</td>
					</tr>
				</table>
				<div id="p_role_code" style="margin:5px 0 5px 5px">
				</div>
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
		var roleList;
		$(document).ready(
			function() {
				fn_all_text_upper();

				var objectHeight = gridObjectHeight(1);

				$("#dataList")
						.jqGrid(
								{
									datatype : 'json',
									mtype : 'POST',
									url : 'manageUserList.do',
									postData : fn_getFormData("#application_form"),
									colNames : ['사번', '이름', '직급', '부서명', '사용유무', '사용유무_changed','제한 ECO 권한 유무','제한 ECO 권한 유무_change', 'ECR 평가자', 'ECR 평가자_change', 'ECR 평가자 SITE', 'GROUP_ID','author_code','권한 그룹','crud'],
									colModel : [
											{name : 'emp_no', index : 'emp_no', width : 25, hidden : true},
											{name : 'name', index : 'name', width : 100, editable : false, align : "center"},
											{name : 'position_name', index : 'position_name', width : 100, editable : false, align : "center"},
											{name : 'dept_name', index : 'dept_name', width : 100, editable : false},
											{name : 'use_yn', index : 'use_yn', width : 40, align: 'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }},
											{name : 'use_yn_changed', index : 'use_yn_changed', width : 25, hidden : true},
											{name : 'eco_author_yn', index : 'eco_author_yn', width : 40, align: 'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }},
											{name : 'eco_author_yn_changed', index : 'eco_author_yn_changed', width : 25, hidden : true},
											{name : 'ecr_evaluator', index : 'ecr_evaluator', width : 40, align: 'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, hidden : true},
											{name : 'ecr_evaluator_changed', index : 'ecr_evaluator_changed', width : 120, editable : false, align : "center", hidden : true},
											{ name : 'ecr_evaluator_site', index : 'ecr_evaluator_site', width : 40, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, hidden : true },
											{name : 'group_id', index : 'cel_no', width : 120, editable : false, align : "center", hidden : true},
											{name : 'author_code', index : 'author_code', width : 60, hidden : true},
											{name : 'author_name', index : 'author_name', width : 40, align : "center"},
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
									rowNum : 100,
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
											var rows = $( "#dataList" ).getDataIDs();

											for ( var i = 0; i < rows.length; i++ ) {
												//수정 및 결재 가능한 리스트 색상 변경
												var oper = $( "#dataList" ).getCell( rows[i], "oper" );
												
												if( oper == "" ) {
													$( "#dataList" ).jqGrid( 'setCell', rows[i], 'name', '', { color : 'black', background : '#DADADA' } );
													$( "#dataList" ).jqGrid( 'setCell', rows[i], 'position_name', '', { color : 'black', background : '#DADADA' } );
													$( "#dataList" ).jqGrid( 'setCell', rows[i], 'dept_name', '', { color : 'black', background : '#DADADA' } );
												}
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
									gridComplete : function(data) {
										var rows = $( "#dataList" ).getDataIDs();
										for ( var i = 0; i < rows.length; i++ ) {
											//수정 및 결재 가능한 리스트 색상 변경
											var oper = $( "#dataList" ).getCell( rows[i], "oper" );
											if( oper == "I" ) {
												$( "#dataList" ).jqGrid( 'setCell', rows[i], 'name', '', { cursor : 'pointer', background : 'pink' } );
											}
											$( "#dataList" ).jqGrid( 'setCell', rows[i], 'author_name', '', { cursor : 'pointer', background : 'pink' } );
											$( "#dataList" ).setRowData(  rows[i], { author_name : "편집" } );
										}
									},
									editurl : "saveManageUser.do",
									onCellSelect : function( rowid, iCol, cellcontent, e ) {
										row_selected = rowid;
										var cm = $( "#dataList" ).jqGrid( "getGridParam", "colModel" );
										var colName = cm[iCol];
										var item = $("#dataList").jqGrid( "getRowData", rowid );
										var authorList = item.author_code.split('|');
										// 신규, 이름이 선택되어졌을때 유저정보리스트를 보여준다.
										if (item.oper == "I" && colName['index'] == "name" ) {
											
											var rs = window.showModalDialog( "popUpUserInfo.do?cmd=infoManageUserList.do", window, "dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
											
											if( rs != null ) {
												item.emp_no = rs[0];
												item.name = rs[1];
												item.dept_name = rs[7];
												/* item.tel_no = rs[2];
												item.cel_no = rs[3];
												item.ep_mail = rs[4];
												item.jik_nam = rs[5]; */
												item.position_name = rs[6];
												
												if(item.oper != "I"){
													item.oper = "U"
												}
												
												$('#dataList').jqGrid("setRowData", rowid, item);
											}
										}	
										// 권한이 선택되어졌을때
										if ( colName['index'] == "author_name" ) {
											// DIS에 설정된 권한과 유저의 권한이 일치하는 경우 체크박스 체크
											for( var i = 0; i < roleList.length; i++ ) {
												$("#roleList"+i).prop("checked", false);
												for( var j = 0; j < authorList.length; j++ ) {
													if(roleList[i].value == authorList[j]){
														$("#roleList"+i).prop("checked", true);
													}
												}
											}

											// 권한정보 선택 팝업
											$.blockUI({message : $('#popLayer')
													  ,css : {width  : '300px'
														  	,cursor:'pointer'}
											})
											$('.blockUI.blockMsg').center();
										}
										
										$("#roleListDiv").empty(); 
										$( "#roleListDiv" ).append("<table id='roleListTable'><thead><tr><th>사용자 권한</th></tr></thead><tbody>");
										for( var i = 0; i < roleList.length; i++ ) {
											for( var j = 0; j < authorList.length; j++ ) {
												if(roleList[i].value == authorList[j]){
													$( "#roleListTable" ).append( "<tr><td>"+roleList[i].text+"</td></tr>" );
												}
											}
										}
										$( "#roleListTable" ).append("</tbody>");
										tableToGrid("#roleListTable", {rownumbers : true});
										fn_insideGridresize($(window), $("#roleListDiv"), $("#roleListTable"),-27);
									},
									afterInsertRow : function(rowid, rowdata, rowelem){
										jQuery("#"+rowid).css("background", "#0AC9FF");
							        }
								});

				$.post( "infoComboCodeMaster.do?sd_type=EVALUATE_SITE", "", function( data ) {
					$( '#dataList' ).setObject( {
						value : 'value',
						text : 'text',
						name : 'ecr_evaluator_site',
						data : data
					} );
				}, "json" );
				
				/* $.post( "infoComboCodeMaster.do?sd_type=DIS_ROLE_GROUP", "", function( data ) {
					$( '#dataList' ).setObject( {
						value : 'value',
						text : 'text',
						name : 'author_code',
						data : data
					} );
				}, "json" ); */
				
				//grid resize
				
				fn_insideGridresize($(window), $("#dataListDiv"), $("#dataList"));
				tableToGrid("#roleListTable", {rownumbers : true});
				fn_insideGridresize($(window), $("#roleListDiv"), $("#roleListTable"),-27);
				
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
				// 권한 정보 리스트 구현
				$.post( "infoComboCodeMaster.do?sd_type=DIS_ROLE_GROUP", "", function( data ) {
					roleList = data;
					for( var i = 0; i < data.length; i++ ) {
						$( "#p_role_code" ).append( "<input id='roleList"+i+"' type='checkbox' value='"+data[i].value+"'> "+data[i].text+"<br>" );
					}
				}, "json" );
				// 권한 팝업에서 선택완료 버튼을 클릭했을때
				$("#roleClose").click(function(){
					// 선택 사용자 권한 리스트
					$("#roleListDiv").empty(); 
					$( "#roleListDiv" ).append("<table id='roleListTable'><thead><tr><th>사용자 권한</th></tr></thead><tbody>");
					var roleCode = "";
					for( var i = 0; i < roleList.length; i++ ) {
						// 체크된 권한 데이터를 취득
						if($( "#roleList"+i).is(":checked")){
							$( "#roleListTable" ).append( "<tr><td>"+roleList[i].text+"</td></tr>" );
							if(roleCode == "") {
								roleCode = roleList[i].value;
							} else {
								roleCode = roleCode +"|"+ roleList[i].value;
							}
						}
					}
					// 권한정보를 그리드에 입력
					$( "#dataList" ).setRowData( row_selected, { author_code : roleCode } );
					var item = $('#dataList').jqGrid('getRowData', row_selected);
					if(item.oper == ""){
						$( "#dataList" ).setRowData( row_selected, { oper : 'U' } );	
					}
					
					$( "#roleListTable" ).append("</tbody>");
					tableToGrid("#roleListTable", {rownumbers : true});
					fn_insideGridresize($(window), $("#roleListDiv"), $("#roleListTable"),-27);
					
				   //모달창 닫기
				   $.unblockUI();
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
			
			var sUrl = "manageUserList.do";
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
			for (var i = 1; i < changedData.length + 1; i++) {
				var item = $('#dataList').jqGrid('getRowData', i);

				if (item.oper != 'I' && item.oper != 'U' && item.oper != 'D') {
					
					if (item.use_yn_changed != item.use_yn) {
						item.oper = 'U';
					}
					
					if (item.ecr_evaluator_changed != item.ecr_evaluator) {
						item.oper = 'U';
					}
					

					if (item.eco_author_yn_changed != item.eco_author_yn) {
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
					var url = 'saveManageUser.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend({}, dataList, formData);

					$.post(url, parameters, function(data) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						}
					}, "json").error(function() {
						alert("시스템 오류입니다.\n전산사용자에게 문의해주세요.");
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

					var val1 = $("#dataList").jqGrid('getCell', ids[i], 'name');

					if ($.jgrid.isEmpty(val1)) {
						result = false;
						message = "이름 Field is required";

						setErrorFocus("#dataList", ids[i], 0, 'name');
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
			item.use_yn = 'Y';

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
		jQuery.fn.center = function () {
		    this.css("position","absolute");
		    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
		    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
		    return this;
		}
	</script>
</body>
</html>
