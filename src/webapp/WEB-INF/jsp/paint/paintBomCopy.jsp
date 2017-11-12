<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>호선 COPY</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}" />
			<input type="hidden" id="p_project_no" name="p_project_no"/>
			<input type="hidden" id="p_delegate_project_no" name="p_delegate_project_no"/>
			
			<input type="hidden" id="n_level" name="n_level" value="-1"/>
			<input type="hidden" id="nodeid" name="nodeid"/>
			
			<div class="subtitle">
				BOM Copy
				<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include> 
				<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
			</div>
			<table class="searchArea conSearch">
					<col width="110">
					<col width="210">
					<col width="*">
					<tr>
						<th width="80px">ECO NO.</th>
						<td width="280px"><input type="text" id="p_eng_change_order_code" name="p_eng_change_order_code" style="width: 100px;" /> 
						<c:if
							test="${userRole.attribute2 == 'Y'}">
							<input type="button" id="btnCreateEco" value="ECO 추가" style="" class="btn_blue" />
						</c:if>
						</td>
						<th width="80px">원본 호선</th>
						<td style="width:150px">
							<input type="text" id="txtFromProjectNo" class="required" maxlength="10" name="from_project_no" value=""
							style="text-align: center; width: 100px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							<input type="button" id="btnFromProjNo" value="검색"class="btn_gray2">
						</td>
						<th width="80px">대상 호선</th>
						<td style="width:150px">
							<input type="text" id="txtToProjectNo" class="required" maxlength="10" name="to_project_no" value=""
							style="text-align: center;width: 100px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" /> 
							<input type="button" id="btnToProjNo" value="검색" class="btn_gray2">
						</td>
						<td>
							<div class="button">
								<c:if test="${userRole.attribute4 == 'Y'}">
									<input type="button" value="복사" id="btnConfirm" disabled class="btn_gray" />
								</c:if>
							</div>
						</td>
					</tr>
					</table>
			<div class="content"  style="position:relative; float: left; width: 100%;">
				<fieldset style="border:none;position:relative; float:left; width: 49%;">
				<table class="searchArea2" ></table>
					<div  id="grdFromListDiv">
						<table id="grdFromList"></table>
						<div id="pgrdFromList"></div>
					</div>
				</fieldset>
				
				<fieldset style="border:none;position:relative; float:right; width: 49%;">
				<table class="searchArea2" ></table>
					<div  id="grdToListDiv">
						<table id="grdToList"></table>
						<div id="pgrdToList"></div>
					</div>
				</fieldset>
			</div>
		</form>
	</div>
	<script type="text/javascript">
		var row_selected;
		var tableId = "#peGrid";
		var deleteData = [];

		var searchIndex = 0;
		var lodingBox;
		var win;

		var isLastRev = "N";
		var isExistProjNo = "N";
		var sState = "";

		var preFromProject_no, preToProject_no;
		var preFromRevision, preToRevision;

		$(document).ready(
				function() {

					$("#grdFromList").jqGrid({
						url: '',
						treedatatype: "json",
						mtype: "",
						postData : fn_getFormData("#application_form"),
						colNames : [ 'LV', 'MOTHER CODE', 'ITEM CODE',
						             'BOM TYPE', 'CATALOG', 'DESCRIPTION', 'UOM', 'QTY', 'Creator', 'ECO NO', 'ECO Creator', 'LEAF', 'FOLD', 'BOM10', 'BOM11', '상태','현황','',''],
						colModel : [ { name : 'lev', index : 'lev', width : 80, align : "left", hidden : true },
						             { name : 'mother_code', index : 'mother_code', width : 80, align : "left", hidden : true, sortable : false },
						             { name : 'item_code', index : 'item_code', width: 280, align : "left", sortable : false},
						             { name : 'bom_type', index : 'bom_type', width : 80, align : "center", hidden : true }, 
						             { name : 'item_catalog', index : 'item_catalog', width : 80, align : "center", hidden : true },
						             { name : 'item_desc', index : 'item_desc', width : 280, align : "left"}, 
						             { name : 'uom', index : 'uom', width : 40, align : "center", hidden : true }, 
						             { name : 'qty', index : 'qty', width : 40, align : "right", hidden : true }, 
						             { name : 'emp_no', index : 'emp_no', width : 150, align : "center", hidden : true }, 
						             { name : 'eco_no', index : 'eco_no', width : 80, align : "center"}, 
						             { name : 'created_by', index : 'created_by', width : 150, align : "center", hidden : true },
						             { name : 'leaf', index : 'leaf', width : 80, align : "left", hidden : true },
						             { name : 'fold', index : 'fold', width : 80, align : "left", hidden : true },
						             { name : 'bom10', index : 'bom10', width : 80, align : "left", hidden : true },
						             { name : 'bom11', index : 'bom11', width : 80, align : "left", hidden : true },
						             { name : 'item_states_desc', index : 'item_states_desc', width : 120, align : "center" , hidden : true},
						             { name : 'states_flag_desc', index : 'states_flag_desc', width : 80, align: "center"},
						             { name : 'select_id', index : 'select_id', width : 40, align: "center", hidden : true, key : true },
						             { name : 'parent_select_id', index : 'parent_select_id', width : 40, align: "center", hidden : true}
						           ],
					   	autowidth : true,
					   	cmTemplate: { title: false },
					   	treeGridModel: 'adjacency',
					   	width		: $(window).width()  * 0.40,
						height : $(window).height()-250,
					    treeGrid: true,
					    caption : "원본 호선",
					    hidegrid : false,
						ExpandColumn : 'item_code',
						jsonReader: {
			                repeatitems: false,
			                id : "lev",
			                page: function(obj) { return 1; },
			                total: function(obj) { return 1; },
			            },
			            treeReader: {
			                level_field:        "lev",
			                parent_id_field:    "parent_select_id",
			                leaf_field:            "leaf",
			                expanded_field:        "fold"
			            },
			            gridComplete : function() {
							var rows = $( "#grdFromList" ).getDataIDs();
							if(rows.length == 0) {
								$("#btnConfirm").attr("disabled", true);
								$("#btnConfirm").removeClass("btn_blue");
								$("#btnConfirm").addClass("btn_gray");
							}
							for ( var i = 0; i < rows.length; i++ ) {
								//수정 및 결재 가능한 리스트 색상 변경
								var leaf = $( "#grdFromList" ).getCell( rows[i], "leaf" );
								if( leaf != "true" && leaf != "0"  ) {
									$( "#grdFromList" ).jqGrid( 'setCell', rows[i], 'item_code', '', { background : '#afc2fa' } );
								}
							}
							
						},
						onCellSelect : function( rowid, iCol, cellcontent, e ) {
							
						}
					});			

					/* $("#grdFromList").jqGrid('filterToolbar', {
						stringResult : true,
						searchOnEnter : false
					}); */

					$("#grdToList").jqGrid({
						url: '',
						treedatatype: "json",
						mtype: "",
						postData : fn_getFormData("#application_form"),
						colNames : [ 'LV', 'MOTHER CODE', 'ITEM CODE',
						             'BOM TYPE', 'CATALOG', 'DESCRIPTION', 'UOM', 'QTY', 'Creator', 'ECO NO', 'ECO Creator', 'LEAF', 'FOLD', 'BOM10', 'BOM11', '상태','현황','',''],
			             colModel : [ { name : 'lev', index : 'lev', width : 80, align : "left", hidden : true },
							             { name : 'mother_code', index : 'mother_code', width : 80, align : "left", hidden : true, sortable : false },
							             { name : 'item_code', index : 'item_code', width: 280, align : "left", sortable : false},
							             { name : 'bom_type', index : 'bom_type', width : 80, align : "center", hidden : true }, 
							             { name : 'item_catalog', index : 'item_catalog', width : 80, align : "center", hidden : true },
							             { name : 'item_desc', index : 'item_desc', width : 280, align : "left"}, 
							             { name : 'uom', index : 'uom', width : 40, align : "center", hidden : true }, 
							             { name : 'qty', index : 'qty', width : 40, align : "right", hidden : true }, 
							             { name : 'emp_no', index : 'emp_no', width : 150, align : "center", hidden : true }, 
							             { name : 'eco_no', index : 'eco_no', width : 80, align : "center"}, 
							             { name : 'created_by', index : 'created_by', width : 150, align : "center", hidden : true },
							             { name : 'leaf', index : 'leaf', width : 80, align : "left", hidden : true },
							             { name : 'fold', index : 'fold', width : 80, align : "left", hidden : true },
							             { name : 'bom10', index : 'bom10', width : 80, align : "left", hidden : true },
							             { name : 'bom11', index : 'bom11', width : 80, align : "left", hidden : true },
							             { name : 'item_states_desc', index : 'item_states_desc', width : 120, align : "center" , hidden : true},
							             { name : 'states_flag_desc', index : 'states_flag_desc', width : 80, align: "center"},
							             { name : 'select_id', index : 'select_id', width : 40, align: "center", hidden : true, key : true },
							             { name : 'parent_select_id', index : 'parent_select_id', width : 40, align: "center", hidden : true}
						           ],
					   	autowidth : true,
					   	cmTemplate: { title: false },
					   	treeGridModel: 'adjacency',
					   	width		: $(window).width()  * 0.40,
						height : $(window).height()-250,
						caption : "대상 호선",
						hidegrid : false,
					    treeGrid: true,
						ExpandColumn : 'item_code',
						jsonReader: {
			                repeatitems: false,
			                id : "lev",
			                page: function(obj) { return 1; },
			                total: function(obj) { return 1; },
			            },
			            treeReader: {
			                level_field:        "lev",
			                parent_id_field:    "parent_select_id",
			                leaf_field:            "leaf",
			                expanded_field:        "fold"
			            },
			            gridComplete : function() {
							var rows = $( "#grdToList" ).getDataIDs();
							var rows2 = $( "#grdFromList" ).getDataIDs();
							if(rows2.length != 0) {
								$("#btnConfirm").removeAttr("disabled");
								$("#btnConfirm").removeClass("btn_gray");
								$("#btnConfirm").addClass("btn_blue");
							} else {
								$("#btnConfirm").attr("disabled", true);
								$("#btnConfirm").removeClass("btn_blue");
								$("#btnConfirm").addClass("btn_gray");
							}
								
							for ( var i = 0; i < rows.length; i++ ) {
								//수정 및 결재 가능한 리스트 색상 변경
								var leaf = $( "#grdToList" ).getCell( rows[i], "leaf" );
								if( leaf != "true" && leaf != "0"  ) {
									$( "#grdToList" ).jqGrid( 'setCell', rows[i], 'item_code', '', { background : '#afc2fa' } );
								}
							}
							
						},
						onCellSelect : function( rowid, iCol, cellcontent, e ) {
						}
					});		

					//ECO 추가
					$( "#btnCreateEco" ).click( function() {
						var dialog = $( '<p>ECO를 연결합니다.</p>' ).dialog( {
							buttons : {
								"SEARCH" : function() {
									//var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupECORelated&save=bomAddEco&ecotype=5&menu_id=${menu_id}",
									var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
											window,
											"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off" );

									if( rs != null ) {
										$( "input[name=p_eng_change_order_code]" ).val( rs[0] );
										/* $( "#eco_main_name" ).val( rs[1] ); */
										//$( "#eco_states_desc" ).val( rs[2] );
									}

									dialog.dialog( 'close' );
								},
//			 					"생성" : function() {
									
//			 						var sUrl = "eco.do?popupDiv=bomAddEco&popup_type=PAINT&menu_id=M00036";

//			 						var rs = window.showModalDialog(sUrl,
//			 								window,
//			 								"dialogWidth:1200px; dialogHeight:500px; center:on; scroll:off; states:off");
//			 						if( rs != null ) {
//			 							$( "input[name=p_eco_no]" ).val( rs[0] );
//			 							/* $( "#eco_main_name" ).val( rs[0] ); */
//			 						}
//			 						dialog.dialog( 'close' );
//			 					},
								"CREATE" : function() {
									var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=&mainType=ECO",
											"ECONO",
											"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
									if( rs != null ) {
										$( "input[name=p_eng_change_order_code]" ).val( rs[0] );
									}
									dialog.dialog( 'close' );
								},
								"CANCEL" : function() {
									dialog.dialog( 'close' );
								}
							}
						} );
					});

					// 화정 버튼
					$('#btnConfirm').click(function() {
						fn_cofirm();
					});

					// 항목 추가 버튼			
					$("#btnEntryAdd").click(function() {
						var lastId = 1;

						var selData = $("#grdFromList").jqGrid('getGridParam', 'selarrrow');
						var desData = $("#grdToList").jqGrid('getDataIDs');

						if (desData.length == 0) {

							// 변경된 체크 박스가 있는지 체크한다.
							for (var i = 0; i < selData.length; i++) {

								var item = $('#grdFromList').jqGrid('getRowData', selData[i]);

								if ($("#grdToList").getDataIDs().length > 0) {
									lastId = $.jgrid.randId();
								}
								item.oper = "I";
								$("#grdToList").jqGrid("addRowData", lastId, item, "first");
							}

						} else {

							for (var i = 0; i < selData.length; i++) {

								var isExist = false;
								var existgbn = "";
								var existcode = "";

								var item = $('#grdFromList').jqGrid('getRowData', selData[i]);
								var item2 = null;

								for (var j = 0; j < desData.length + 1; j++) {
									item2 = $('#grdToList').jqGrid('getRowData', desData[j]);

									if (item2.gbn == item.gbn && item2.code == item.code) {
										isExist = true;
										existgbn = item.gbn;
										existcode = item.code;
										break;
									}

								}

								if (isExist) {
									alert("선택한 ROW : " + existgbn + "의 " + existcode + "은 이미 추가되어있습니다.");
								} else {
									if ($("#grdToList").getDataIDs().length > 0) {
										lastId = $.jgrid.randId();
									}
									item.oper = "I";
									$("#grdToList").jqGrid("addRowData", lastId, item, "first");
								}

							}
						}

						$('#grdFromList').resetSelection();

					});

					// 항목 삭제 버튼	
					$("#btnEntryDel").click(function() {

						var selData = $("#grdToList").jqGrid('getGridParam', 'selarrrow');

						for (var i = selData.length - 1; 0 <= i; i--) {
							var item = $('#grdToList').jqGrid('getRowData', selData[i]);
							if( item.oper == "I") {
								$("#grdToList").jqGrid('delRowData', selData[i]);
							}
						}

						$('#grdToList').resetSelection();

					});

					// 원본 프로젝트 조회 버튼
					$("#btnFromProjNo").click(function() {
						searchProjectNo("FROM");
					});

					// 대상 프로젝트 조회 버튼
					$("#btnToProjNo").click(function() {
						searchProjectNo("TO");
					});

					//nav button area set width 0 
					//$("#pgrdEmpList_left").css("width", 0);
					
					//grid resize
					fn_insideGridresize($(window),$("#grdFromListDiv"),$("#grdFromList"),10);
					//grid resize
					fn_insideGridresize($(window),$("#grdToListDiv"),$("#grdToList"),10);
					//fn_gridresize($(window),$("#entryDiv"));
					
				});
		
		/***********************************************************************************************																
		 * 이벤트 함수 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/
		// 대상 프로젝트의 Revsion이 변경된 경우 호출되는 함수			
		/* function changedRevistion(obj) {
			fn_searchLastRevision("TO");
		} */

		// header checkbox action 
		function fromCheckBoxHeader(e) {
			e = e || event;/* get IE event ( not passed ) */
			e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if (($("#fromChkHeader").is(":checked"))) {
				$(".chkboxFromItem").prop("checked", true);
			} else {
				$("input.chkboxFromItem").prop("checked", false);
			}
		}

		// header checkbox action 
		function toCheckBoxHeader(e) {
			e = e || event;/* get IE event ( not passed ) */
			e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if (($("#toChkHeader").is(":checked"))) {
				$(".chkboxToItem").prop("checked", true);
			} else {
				$("input.chkboxToItem").prop("checked", false);
			}
		}

		/***********************************************************************************************																
		 * 기능 함수 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/
		//그리드  checkbox 생성
		function formatOpt1(cellvalue, options, rowObject) {
			var rowid = options.rowId;

			return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxFromItem' value="+rowid+" />";
		}

		//그리드  checkbox 생성
		function formatOpt2(cellvalue, options, rowObject) {
			var rowid = options.rowId;

			return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxToItem' value="+rowid+" />";
		}

		// 삭제 데이터가 저장된 array내용 삭제하는 함수			
		function deleteArrayClear() {
			if (deleteData.length > 0)
				deleteData.splice(0, deleteData.length);
		}

		// Input Text입력시 대문자로 변환하는 함수
		function onlyUpperCase(obj) {

			obj.value = obj.value.toUpperCase();

			if (obj.id == "txtFromProjectNo") {
				searchProjectNo("FROM");
			} else {
				searchProjectNo("TO");
			}
		}

		// 그리드의 변경된 Row만 가져오는 함수
		function getChangedGridInfo(gridId) {
			var changedData = $.grep($(gridId).jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I';
			});

			return changedData;
		}

		// 프로젝트 리비젼에 따라 버튼 enable설정하는 함수
		/* function fn_setButtionEnable() {

			if ("Y" == isLastRev && sState != "D") {
				$("#btnConfirm").removeAttr("disabled");
				$("#btnConfirm").removeClass("btn_gray");
				$("#btnConfirm").addClass("btn_blue");
			} else {
				$("#btnConfirm").attr("disabled", true);
				$("#btnConfirm").removeClass("btn_blue");
				$("#btnConfirm").addClass("btn_gray");
			}
		} */

		// 폼데이터를 Json Arry로 직렬화
		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}

		// 프로젝트 필수여부, 최종revision, 상태 체크하는 함수
		function fn_ProjectNoCheck(buttonId, isLastCheck) {

			if (buttonId == "FROM") {

				if ($.jgrid.isEmpty($("input[name=from_project_no]").val())) {
					$("input[name=from_project_no]").focus();
					alert("원본 Project No is required");
					return false;
				}

				if ($.jgrid.isEmpty($("input[name=from_revision]").val())) {
					$("input[name=from_revision]").focus();
					alert("원본 Revision is required");
					return false;
				}

			} else {

				if ($.jgrid.isEmpty($("input[name=to_project_no]").val())) {
					$("input[name=to_project_no]").focus();
					alert("대상 Project No is required");
					return false;
				}

				if ($.jgrid.isEmpty($("input[name=to_revision]").val())) {
					$("input[name=to_revision]").focus();
					alert("대상 Revision is required");
					return false;
				}

				if (isExistProjNo == "N" && isLastCheck == true) {
					alert("Project No does not exist");
					return false;
				}

				if (sState == "D" && isLastCheck == true) {
					alert("State of the revision is released");
					return false;
				}

				if (isLastRev == "N" && isLastCheck == true) {
					alert("PaintPlan Revision is not the end");
					return false;
				}

			}

			return true;
		}

		/***********************************************************************************************																
		 * 서비스 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/
		function fn_search(){
			if (fn_ProjectNoCheck("FROM", false)) {
				if (fn_ProjectNoCheck("TO", false)) {
					fn_from_search();
					fn_to_search();
				}
			}
		}
		 
		// 원본 프로젝트의 copy 목록 조회
		function fn_from_search() {
			$("#nodeid").val($("input[name=from_project_no]").val());
			var sUrl = "infoBomTree.do";
			jQuery("#grdFromList").jqGrid('setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype : "json",
				postData : getFormData("#application_form")
			}).trigger("reloadGrid");
			
		}
		// 대상 프로젝트의 copy 목록 조회
		function fn_to_search() {
			$("#nodeid").val($("input[name=to_project_no]").val());
			var sUrl = "infoBomTree.do";
			jQuery("#grdToList").jqGrid('setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype : "json",
				postData : getFormData("#application_form")
			}).trigger("reloadGrid");
		}

		// 프로젝트번호 조회하는 화면 호출 
		function searchProjectNo(buttonId) {

			var p_delegate_project_no;
			var searchType;
			if (buttonId == "FROM") {
				$("#p_project_no").val($("input[name=from_project_no]").val());
				$("#p_delegate_project_no").val("none");
				searchType = "none";
			} else {
				$("#p_project_no").val($("input[name=to_project_no]").val());
				$("#p_delegate_project_no").val($("input[name=to_project_no]").val());
				searchType = "PAINT"
			}

			var rs = window.showModalDialog("popUpProjectNo.do?searchType="+searchType, window,
					"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {

				if (buttonId == "FROM") {
					$("input[name=from_project_no]").val(rs[0]);
					fn_from_search();
					$("input[name=to_project_no]").val("");
					$("#grdFromList").clearGridData(true);
				} else {
					$("input[name=to_project_no]").val(rs[0]);
					fn_to_search();
				}
			}

			if (buttonId == "FROM") {
				if (preFromProject_no != $("input[name=from_project_no]").val()) {
					$("#grdFromList").clearGridData(true);
					preFromProject_no = $("input[name=from_project_no]").val();
				}
			}
		}

		// 원본 프로젝트의 목록를 대상 프로젝트로 복사 저장
		function fn_cofirm() {
			
			if (confirm('복사 하시겠습니까?') == 0) {
				return;
			}

			lodingBox = new ajaxLoader($('#mainDiv'), {
				classOveride : 'blue-loader',
				bgColor : '#000',
				opacity : '0.3'
			});
			
			var url = "saveBomCopy.do";

			var formData = getFormData('#application_form');

			$.post(url,
					formData,
					function(data) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								fn_to_search();
							}

					}).fail(function() {
				alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			}).always(function() {
				lodingBox.remove();
			});
		}
		
	</script>
</body>
</html>
