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
			<div class="subtitle">
				Project Copy
				<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include> 
				<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
			</div>
			
				<table class="searchArea conSearch">
					<col width="110">
					<col width="100">
					<col width="">
					<tr>
						<th style="width:110px">구분</th>
						<td style="width:100px">  
							<select name="sel_condition" id="sel_condition" onchange="fn_search()">
									<option value="all" selected="selected">ALL</option>
									<option value="block">BLOCK</option>
									<option value="pe">PE</option>
									<option value="pattern">PATTERN</option>
									<option value="zone">ZONE</option>
									<option value="outfitting">OUTFITING</option>
									<option value="cosmetic">COSMETIC</option>
							</select>
						</td>
						<td>
							<div class="button">
								<c:if test="${userRole.attribute4 == 'Y'}">
									<input type="button" value="확정" id="btnConfirm" disabled class="btn_gray" />
								</c:if>
							</div>
						</td>
					</tr>
					</table>
			
			
			<div class="content"  style="position:relative; float: left; width: 100%;">
				<fieldset style="border:none;position:relative; float:left; width: 47%;">
				<legend class="sc_tit sc_tit2">원본 PROJECT</legend>
				<table class="searchArea2" >
					<tr>
						<td style="width:250px">
							<input type="text" id="txtFromProjectNo" class="required" maxlength="10" name="from_project_no" value=""
							style="text-align: center; width: 100px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							<input type="text" id="txtFromRevision" class="required" maxlength="2" name="from_revision" value=""
							style="width: 40px; text-align: center; ime-mode: disabled; text-transform: uppercase;"
							onKeyPress="return numbersonly(event, false);" /> 
							<input type="button" id="btnFromProjNo" value="검색"class="btn_gray2">
							<span style="float:right;margin-right:10px">
							<input type="text" class="" id="txtCondition" name="txtCondition"
							style="text-transform: uppercase; width: 100px;" /> <input type="button" id="btnfilter" value="필터"
							class="btn_blue " />
						</span>
						</td>
					</tr>
					
				</table>
					<div  id="grdFromListDiv">
						<table id="grdFromList"></table>
						<div id="pgrdFromList"></div>
					</div>
				</fieldset>
				
				<fieldset  id="entryDiv" style="padding:250px 0 0 0; border:0;position:relative; float: left; width: 4%;">
					<table>
					<tr>
					<td width="100%-15px">
					</td>
					<td width="30px">
					<input type="button" id="btnEntryAdd" value="&gt;&gt;" title="추가" class="btn_gray2 wid30" /> <br /> <br /> <input
						type="button" id="btnEntryDel" value="&lt;&lt;" title="제외" class="btn_gray2 wid30" />
					</td>
					<td width="100%-15px">
					</td>
					</tr>
					</table>
					
				</fieldset>
				
				<fieldset style="border:none;position:relative; float:right; width: 47%;">
				<legend class="sc_tit sc_tit2">대상 PROJECT</legend>
				<table class="searchArea2" >
					<tr>
						<td style="width:250px">
							<input type="text" id="txtToProjectNo" class="required" maxlength="10" name="to_project_no" value=""
							style="text-align: center;width: 100px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" /> <input
							type="text" id="txtToRevision" class="required" maxlength="2" name="to_revision" value=""
							style="width: 40px; text-align: center; ime-mode: disabled; text-transform: uppercase;"
							onchange="changedRevistion();" onKeyPress="return numbersonly(event, false);" /> <input type="button"
							id="btnToProjNo" value="검색" class="btn_gray2">
						</td>
					</tr>
					
				</table>
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
						datatype : 'json',
						mtype : '',
						url : '',
						editUrl : 'clientArray',
						//cellSubmit: 'clientArray',
						colNames : [ '구분', 'LIST', '', '' ],
						colModel : [
									//{ name : 'chk',    index : 'chk',  width : 12, align:'center',  sortable : false, formatter: formatOpt1},
					            	{ name : 'gbn',    		index : 'gbn',  width : 40, editable : true, sortable : false, align : "center", editrules : { required : true }, editoptions : { size : 5 } },
					            	{ name : 'code',   		index : 'code', width : 50, editable : true, sortable : false, align : "center", editoptions : { size : 11 } },
					            	{ name : 'team_count',  index : 'team_count', width : 25, hidden:true},
					            	{ name : 'oper',   		index : 'oper', 	  width : 25, hidden:true} ],
						gridview : true,
						cmTemplate: { title: false },
						toolbar : [ false, "bottom" ],
						viewrecords : true,
						multiselect : true,
						autowidth 	: true,
						width : $(window).width()  * 0.40,
						height : $(window).height()-250,
						//rowList		: [10,1000,5000],
						pager : $('#pgrdFromList'),
						rowNum : 99999,

						pgbuttons : false,
						pgtext : false,
						pginput : false,

						jsonReader : {
							root : "rows",
							page : "page",
							total : "total",
							records : "records",
							repeatitems : false,
						},
						imgpath : 'themes/basic/images',
						ondblClickRow : function(rowId) {

						},
						onSelectRow : function(row_id) {
							if (row_id != null) {
								row_selected = row_id;
							}
						},
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
									pageYn : 'Y',
									filters : ""
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
									page : $this.jqGrid('getGridParam', 'pageServer'),
									records : $this.jqGrid('getGridParam', 'recordsServer'),
									lastpage : $this.jqGrid('getGridParam', 'lastpageServer')
								});
								this.updatepager(false, true);
							}
						}
					});

					/* $("#grdFromList").jqGrid('filterToolbar', {
						stringResult : true,
						searchOnEnter : false
					}); */

					$("#grdToList").jqGrid({
						datatype : 'json',
						mtype : '',
						postData : getFormData("#application_form"),
						url : '',
						colNames : [ '구분', 'LIST', '', '' ],
						colModel : [
						//{ name : 'chk',    index : 'chk',  width : 12, align:'center',  sortable : false, formatter: formatOpt2},
						{
							name : 'gbn',
							index : 'gbn',
							width : 40,
							editable : true,
							sortable : false,
							align : "center",
							editrules : {
								required : true
							},
							editoptions : {
								size : 5
							}
						}, {
							name : 'code',
							index : 'code',
							width : 50,
							editable : true,
							sortable : false,
							align : "center",
							editoptions : {
								size : 11
							}
						}, {
							name : 'team_count',
							index : 'team_count',
							width : 25,
							hidden : true
						}, {
							name : 'oper',
							index : 'oper',
							width : 25,
							hidden : true
						} ],
						
						gridview : true,
						cmTemplate: { title: false },
						toolbar : [ false, "bottom" ],
						viewrecords : true,
						multiselect : true,
						autowidth   : true,
						width		: $(window).width()  * 0.40,
						height : $(window).height()-250,
						pager : $('#pgrdToList'),
						rowNum : 99999,
						pgbuttons : false,
						pgtext : false,
						pginput : false,
						afterInsertRow : function(rowid, rowdata, rowelem){
							jQuery("#"+rowid).css("background", "#0AC9FF");
				        },
						imgpath : 'themes/basic/images'
					}).jqGrid('sortableRows');

					$('#btnfilter').click(function() {

						var $grid = $("#grdFromList");

						var groups = [], groups2 = [];
						var val = $("input[name=txtCondition]").val();

						if (!$.jgrid.isEmpty(val)) {

							var arrVal = val.split(",");

							for (var i = 0; i < arrVal.length; i++) {

								var arrBetween = arrVal[i].split("-");

								if (arrBetween.length == 2) {
									groups2.push({
										field : "code",
										op : "ge",
										data : arrBetween[0]
									});
									groups2.push({
										field : "code",
										op : "le",
										data : arrBetween[1]
									});
								} else {
									groups.push({
										field : "code",
										op : "bw",
										data : arrVal[i]
									});
								}
							}
						}

						$.extend($grid.jqGrid("getGridParam", "postData"), {
							filters : JSON.stringify({
								"groupOp" : "OR",
								"rules" : [],
								"groups" : [ {
									"groupOp" : "OR",
									"rules" : groups
								}, {
									"groupOp" : "AND",
									"rules" : groups2
								} ]

							})
						});

						$grid.jqGrid("setGridParam", {
							search : true
						}).trigger('reloadGrid', [ {
							current : true,
							page : 1
						} ]);

					});
					
					/* // 조회 버튼
					$('#btnSearch').click(function() {
						if (fn_ProjectNoCheck("FROM", false)) {
							if (fn_ProjectNoCheck("TO", false)) {
								fn_search();	
							}
						}
					}); */

					// 화정 버튼
					$('#btnConfirm').click(
							function() {

								if ($("input[name=from_project_no]").val() == $("input[name=to_project_no]").val()
										&& $("input[name=from_revision]").val() == $("input[name=to_revision]").val()) {
									alert("원번 PROJECT와 대상 PROJECT가 동일합니다.");
									return;
								}

								var rowCnt = $("#grdToList").getGridParam("reccount");

								if (rowCnt == 0) {
									alert("변경된 내용이 없습니다.");
									return;
								}

								if (!fn_ProjectNoCheck("FROM", false)) {
									return;
								}

								if (!fn_ProjectNoCheck("TO", true)) {
									return;
								}

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
					fn_insideGridresize($(window),$("#grdFromListDiv"),$("#grdFromList"),60);
					//grid resize
					fn_insideGridresize($(window),$("#grdToListDiv"),$("#grdToList"),60);
					//fn_gridresize($(window),$("#entryDiv"));
					
				});
		
		/***********************************************************************************************																
		 * 이벤트 함수 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/
		// 대상 프로젝트의 Revsion이 변경된 경우 호출되는 함수			
		function changedRevistion(obj) {
			fn_searchLastRevision("TO");
		}

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
		function fn_setButtionEnable() {

			if ("Y" == isLastRev && sState != "D") {
				$("#btnConfirm").removeAttr("disabled");
				$("#btnConfirm").removeClass("btn_gray");
				$("#btnConfirm").addClass("btn_blue");
			} else {
				$("#btnConfirm").attr("disabled", true);
				$("#btnConfirm").removeClass("btn_blue");
				$("#btnConfirm").addClass("btn_gray");
			}
		}

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
			var sUrl = "searchFromCopyList.do";
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
			
			var sUrl = "searchToCopyList.do";
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

			var args;
			if (buttonId == "FROM") {
				args = {
					project_no : $("input[name=from_project_no]").val()
				};
			} else {
				args = {
					project_no : $("input[name=to_project_no]").val()
				};
			}

			var rs = window.showModalDialog("popupPaintPlanProjectNo.do?sessionFlag=no", args,
					"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {

				if (buttonId == "FROM") {
					$("input[name=from_project_no]").val(rs[0]);
					$("input[name=from_revision]").val(rs[1]);
					fn_from_search();
				} else {
					$("input[name=to_project_no]").val(rs[0]);
					$("input[name=to_revision]").val(rs[1]);
					fn_to_search();
				}
			}

			if (buttonId == "TO") {
				fn_searchLastRevision(buttonId);
			} else {

				if (preFromProject_no != $("input[name=from_project_no]").val()
						|| preFromRevision != $("input[name=from_revision]").val()) {
					$("#grdFromList").clearGridData(true);

					preFromProject_no = $("input[name=from_project_no]").val();
					preFromRevision = $("input[name=from_revision]").val();
				}
			}
		}

		// 프로젝트 최종 리비젼 조회하는 함수
		function fn_searchLastRevision(buttonId) {

			var url = "paintPlanProjectNoCheck.do";
			var parameters = {
				project_no : $("input[name=to_project_no]").val(),
				revision : $("input[name=to_revision]").val()
			};

			$.post(url, parameters, function(data) {

				if (data != null) {
			  		isExistProjNo  = "Y";
			  		sState		   = data.state;
			  		
			  		if (data.last_revision_yn == "Y") isLastRev = "Y";
			  		else isLastRev = "N";
			  	} else {
			  		isExistProjNo = "N";
			  		isLastRev 	  = "N";  
			  		sState		  = "";	
			  	}

				if (preToProject_no != $("input[name=to_project_no]").val()
						|| preToRevision != $("input[name=to_revision]").val()) {

					//$("#blockCodeList").clearGridData(true);
					//deleteArrayClear();

					preToProject_no = $("input[name=to_project_no]").val();
					preToRevision = $("input[name=to_revision]").val();
				}

				fn_setButtionEnable();
			});
		}

		// 원본 프로젝트의 목록를 대상 프로젝트로 복사 저장
		function fn_cofirm() {
			if(!fn_checkValidate()){
				return;
			}
			
			var copyData = getChangedGridInfo("#grdToList");
			
			if (confirm('확정 하시겠습니까?') == 0) {
				return;
			}

			lodingBox = new ajaxLoader($('#mainDiv'), {
				classOveride : 'blue-loader',
				bgColor : '#000',
				opacity : '0.3'
			});
			
			var dataList = {
					chmResultList : JSON.stringify(copyData)
				};
			var url = "saveProjectCopyConfirm.do";

			var formData = getFormData('#application_form');

			var parameters = $.extend({}, dataList, formData);

			$.post(url,
					parameters,
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
		//필수입력 체크
		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $("#grdToList").jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {
				var oper = $("#grdToList").jqGrid('getCell', ids[i], 'oper');

				if (oper == 'I') {
					nChangedCnt++;
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
		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#grdToList").jqGrid('getRowData'),
					function(obj) {
						return obj.oper == 'I' || obj.oper == 'U'
								|| obj.oper == 'D';
					});

			callback.apply(this, [ changedData.concat(resultData) ]);
		}
	</script>
</body>
</html>
