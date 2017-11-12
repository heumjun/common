<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ecoLifeCycle</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="wrap">
			<form id="application_form" name="application_form"  onsubmit="return false;">
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				<input type="hidden" id="save" name="save" value="<%=request.getParameter("save")%>" />
				<input type="hidden" name="created_by" id="created_by" />
				<input type="hidden" name="states_code" id="states_code" />
				<input type="hidden" name="states_desc" id="states_desc" />
				<input type="hidden" name="searchType" value="True" />
				<input type="hidden" name="main_code" id="main_code" />
				<input type="hidden" name="sTypeName" id="sTypeName" />
				<input type="hidden" name="promote" id="promote" />
				<input type="hidden" name="locker_by" id="locker_by" />
				<input type="hidden" name="design_engineer_reg" id="design_engineer_reg" />
				<input type="hidden" name="manufacturing_engineer_reg" id="manufacturing_engineer_reg" />
				<input type="hidden" name="design_engineer_name_reg" id="design_engineer_name_reg" />
				<input type="hidden" name="manufacturing_engineer_name_reg" id="manufacturing_engineer_name_reg" />
				<input type="hidden" name="design_engineer_mail" id="design_engineer_mail" />
				<input type="hidden" name="manufacturing_engineer_mail" id="manufacturing_engineer_mail" />
				<input type="hidden" name="mail_main_name" id="mail_main_name" />
				<input type="hidden" name="mail_eco_cause" id="mail_eco_cause" />
				<input type="hidden" name="mail_main_desc" id="mail_main_desc" />
				<input type="hidden" name="created_by_name" id="created_by_name /">
				<input type="hidden" name="main_name" id="main_name" />
				<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
				<input type="hidden" id="admin_yn" name="admin_yn" value="${loginUser.admin_yn}" />
				<input type="hidden" name="eco_no" id="eco_no" />
				<%
					String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString();
				%>
				<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag%>" />
				<div id="promotedemmote" style="margin-top:10px;margin-left: 10px; height:50px;">
				<table>
				<col width="600"/>
				<col width="*"/>
					<td>
					<input type="button" class="btn_blue" id="btnDemote" name="btnDemote" value="Demote" />
					<input type="button" class="btn_blue" id="btnPromote" name="btnPromote" value="Promote" />
					<input type="button" class="btn_blue" id="btnCancel" name="btnCancel" value="Cancel" />
					Comments :
					<input type="text" id="notify_msg" name="notify_msg" size="20" style="width:300px;height:20px">
					</td>
					<td id="state_code"></td>	
				</table>		
				</div>
					
				<div id="ecoLifeCycleListDiv" style=" margin-top: 10px;" >
					<table id="ecoLifeCycleList"></table>
					<div id="pecoLifeCycleList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		$("#states_code").val(parent.document.getElementById("states_code").value);
		$("#states_desc").val(parent.document.getElementById("states_desc").value);
		$("#main_code").val(parent.document.getElementById("main_code").value);
		$("#sTypeName").val(parent.document.getElementById("sTypeName").value);
		$("#locker_by").val(parent.document.getElementById("locker_by").value);
		$("#design_engineer_reg").val(parent.document.getElementById("design_engineer_reg").value);
		$("#manufacturing_engineer_reg").val(parent.document.getElementById("manufacturing_engineer_reg").value);
		$("#design_engineer_name_reg").val(parent.document.getElementById("design_engineer_name_reg").value);
		$("#manufacturing_engineer_name_reg").val(parent.document.getElementById("manufacturing_engineer_name_reg").value);
		$("#mail_main_name").val(parent.document.getElementById("mail_main_name").value);
		$("#mail_eco_cause").val(parent.document.getElementById("mail_eco_cause").value);
		$("#mail_main_desc").val(parent.document.getElementById("mail_main_desc").value);
		$("#created_by_name").val(parent.document.getElementById("created_by_name").value);
		$("#rowid").val(parent.document.getElementById("rowid").value);
		$("#loginid").val(parent.document.getElementById("loginid").value);

		var main_name = window.parent.$("#ref_main_name").val();

		$('#eco_no').val(main_name);
		
		var rowid = $("#rowid").val();

		var tableId = '';
		var resultData = [];
		var enable_flag = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var cmtypedesc;
		var kRow = 0;
		var kCol = 0;
		var jqgHeight = $(window).height() * 0.6;

		$(document).ready(function() {
			
			fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
			
			$("#ecoLifeCycleList").jqGrid({
				datatype : 'json',
				mtype : '',
				url : '',
				postData : $("#application_form").serialize(),
				colNames : [ 'User Name', '순서', '결재여부', '결재일', 'Comments' ],
				colModel : [ { name : 'user_name', index : 'user_name', width : 300, editable : false, align : "left" }, 
				             { name : 'position', index : 'position', width : 85, editable : false, align : "center" }, 
				             { name : 'is_approve', index : 'is_approve', width : 90, editable : false, align : "center" }, 
				             { name : 'actualdate', index : 'actualdate', width : 100, editable : false, align : "center" }, 
				             { name : 'comments', index : 'comments', width : 1000, editable : false, edittype : "textarea", editoptions : { rows : "3", cols : "40" } } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : parent.objectHeight-168,
				//shrinkToFit : false,
				caption : "Life Cycle",
				hidegrid : false,
				pager : $('#pecoLifeCycleList'),
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowNum : -1,
				beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
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
			});

			//$("#promotedemmote").hide();

			//fn_jqGridsetHeight($("#divCloseFlag").val(), "ecoLifeCycleList", screen.height);

			if (main_name == "") {
				$("#ecoLifeCycleList").jqGrid("setCaption", 'Life Cycle');
			} else {
				$("#ecoLifeCycleList").jqGrid("setCaption", 'Life Cycle - ' + main_name);
			}

			$("#ecoLifeCycleList").jqGrid('navGrid', "#pecoLifeCycleList", {
				search : false,
				edit : false,
				add : false,
				del : false
			});

			// 승인
			$("#btnPromote").click(function() {
				
				$("#promote").val("PROMOTE");

				if ($("#states_desc").val() == null || $("#states_desc").val() == '') {
					alert("ECO를 선택후에 진행하시기 바랍니다.");
				} else if ($("#states_desc").val() == "Release") {
					alert("이미 Release 상태입니다.");
				}

				var url = 'selectEcoPartCount.do';
				var formData = getFormData('#application_form');
				if (formData.main_code != "") {
					$.post(url, formData, function(data) {
						$.post("infoSelectRelatedEco.do", formData, function(data2) {
							if(data2.records == '0') {
								if (data.cnt == 0) {
									alert("ECO에 등록된 ITEM이 없습니다.");
								} else {
									fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
									fn_LifeCycle();
								}
							} else {
								fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
								fn_LifeCycle();
							}
						}, "json");
					}, "json");
				}
			});

			//반려
			$("#btnDemote").click(function() {
				
				fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
				
				$("#promote").val("DEMOTE");

				if ($("#states_desc").val() == null || $("#states_desc").val() == '') {
					alert("ECO를 선택후에 진행하시기 바랍니다.");
				} else if (!($("#states_desc").val() == "Review")) {
					alert("Review 상태일때만 가능합니다.");
				} else {
					fn_LifeCycle();
				}
			});

			//Cancle
			$("#btnCancel").click(function() {
				
				fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
				
				$("#promote").val("CANCEL");

				if ($("#states_desc").val() == null || $("#states_desc").val() == '') {
					alert("ECO를 선택후에 진행하시기 바랍니다.");
				} else if (!($("#states_desc").val() == "Review" || $("#states_desc").val() == "Create")) {
					alert("Create 또는 Review 상태일때만 가능합니다.");
				} else {
					fn_LifeCycle();
				}
			} );
			fn_gridresize( parent.objectWindow, $( "#ecoLifeCycleList" ) ,-67,0.5 );
		}); //end of ready Function 

		//승인,반려 실행   
		function fn_LifeCycle() {
			
			var promoteCheck = $("#promote").val();
			var colvalue = "";

			var url = "promoteDemote.do";
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({}, formData);
		
			$.post(url, parameters, function(data) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					if (promoteCheck == "PROMOTE") {
						if ($("#states_desc").val() == "Crate") {
							colvalue = "Review";
						} else if ($("#states_desc").val() == "Review") {
							colvalue = "Release";
						}
					} else if (promoteCheck == "DEMOTE") {
						colvalue = "Crate";
					} else {
						colvalue = "Cancle";
					}
					
					//$("#lifecycleDiv").hide();
					window.parent.fn_search("#tabs-2");
					//fn_search();
				}
			}, "json").error(function() {
				alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			});

		}

		//Promote / Demote 가능여부 체크
		function fn_IsAuthApprove() {
			var url = 'infoIsAuthApprove.do';
			var formData = getFormData('#application_form');
			var states_desc = $("#states_desc").val();
			if (formData.main_code != "") {
				$.post(url, formData, function(data) {
					//관리자인 경우 자신이 결재자가 아니라도 결재가 가능하도록 허용
					if( $("#admin_yn").val() == 'Y' ) {
						//$("#promotedemmote").show();
						//$("#ecoLifeCycleList").setGridHeight(262);
						if (states_desc == "Cancel") {
							fn_buttonDisabled([ "#btnDemote", "#btnPromote", "#btnCancel" ]);
						} else {
							//Promote or Demote button enable & disable
							if (states_desc == "Create") {
								fn_buttonDisabled([ "#btnDemote" ]);
								fn_buttonEnable([ "#btnPromote", "#btnCancel" ]);
							} else if (states_desc == "Review") {
								fn_buttonDisabled([ "#btnCancel" ]);
								fn_buttonEnable([ "#btnDemote", "#btnPromote" ]);

							} else if (states_desc == "Release") {
								fn_buttonDisabled([ "#btnDemote", "#btnPromote", "#btnCancel" ]);
							}
						}
					} else {
						
						if (data == undefined || data.is_auth_approve == "N") {
							//$("#promotedemmote").hide();
							//$("#ecoLifeCycleList").setGridHeight(295);
						} else if (data.is_auth_approve == "Y") {
							//$("#promotedemmote").show();
							//$("#ecoLifeCycleList").setGridHeight(262);
							if (states_desc == "Cancel") {
								fn_buttonDisabled([ "#btnDemote", "#btnPromote", "#btnCancel" ]);
							} else {
								//Promote or Demote button enable & disable
								if (states_desc == "Create") {
									fn_buttonDisabled([ "#btnDemote" ]);
									fn_buttonEnable([ "#btnPromote", "#btnCancel" ]);
								} else if (states_desc == "Review") {
									fn_buttonDisabled([ "#btnCancel" ]);
									fn_buttonEnable([ "#btnDemote", "#btnPromote" ]);
	
								} else if (states_desc == "Release") {
									fn_buttonDisabled([ "#btnDemote", "#btnPromote", "#btnCancel" ]);
								}
							}
						}
					}
				}, "json" ).error( function() {
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				} ).always( function() {
					//lodingBox.remove();
				} );
			}
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $('#ecoLifeCycleList').jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';
			$('#ecoLifeCycleList').jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");
		}

		/*황경호 function searchecrType(obj, nCode, nData, nRow, nCol) {
			searchIndex = $(obj).closest('tr').get(0).id;
			var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupBaseInfo",
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");

			$(tableId).saveCell(nRow, nCol);

			if (rs != null) {
				$(tableId).setCell(searchIndex, 'sd_type', rs[0]);
				$(tableId).setCell(searchIndex, nData, rs[1]);
				var item = $(tableId).jqGrid('getRowData', searchIndex);
				if (item.oper != 'I')
					$(tableId).setCell(searchIndex, "oper", "U");
			}
		} */

		//폼데이터를 Json Arry로 직렬화
		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}

		function getChangedChmResultData(callback) {
			//가져온 배열중에서 필요한 배열만 골라내기 
			var changedData = $.grep($("#ecoLifeCycleList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		function fn_search() {
			fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
			if(window.parent.$("#main_code").val() == "") {
				alert('ECO 선택후 조회 바랍니다.');
			} else {
				$("#states_code").val(window.parent.$("#states_code").val());
				$("#states_desc").val(window.parent.$("#states_desc").val());
				$("#main_code").val(window.parent.$("#main_code").val());
				$("#mail_eco_cause").val(window.parent.$("#mail_eco_cause").val());
				$("#mail_main_desc").val(window.parent.$("#mail_main_desc").val());
				$("#design_engineer_mail").val(window.parent.$("#design_engineer_mail").val());
				$("#manufacturing_engineer_mail").val(window.parent.$("#manufacturing_engineer_mail").val());
				
				var stateImg = '';
				if($("#states_code").val() == 'CREATE') {
					stateImg = '<img src=\"/images/eco/create.png\"/>';
				} else if($("#states_code").val() == 'REVIEW') {
					stateImg = '<img src=\"/images/eco/review.png\"/>';
				} else if($("#states_code").val() == 'RELEASE') {
					stateImg = '<img src=\"/images/eco/release.png\"/>';
				} else if($("#states_code").val() == 'CANCEL') {
					stateImg = '<img src=\"/images/eco/cancel.png\"/>';
				}
				$("#state_code").html(stateImg);
				
				$("#ecoLifeCycleList").jqGrid("setCaption", 'Life Cycle - ' + window.parent.$("#ref_main_name").val());
				fn_IsAuthApprove();
				//window.parent.fn_search();
				var sUrl = "infoEcoLifeCycleList.do";
				$("#ecoLifeCycleList").jqGrid('setGridParam', {
					url : sUrl,
					mtype : 'POST',
					page : 1,
					postData : $("#application_form").serialize()
				}).trigger("reloadGrid");

				//재조회 후 promotedemmote 숨김
				//$("#promotedemmote").hide();
				//$("#ecoLifeCycleList").setGridHeight(295);
			}
		}
		</script>
	</body>
</html>
