<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Related Project</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="wrap">
			<form id="application_form" name="application_form">
				<%
					String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString();
				%>
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				<input type="hidden" id="save" name="save" value="<%=request.getParameter("save")%>" />
				<input type="hidden" id="sType" name="sType" value="ECO" />
				<input type="hidden" id="main_type" name="main_type" value="ECO" />
				<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="eco" />
				<input type="hidden" name="eng_type" id="eng_type" value="PROJECT">
				<input type="hidden" name="eng_sub_type" id="eng_sub_type" value="PROJECT">
				<input type="hidden" name="eng_small_type" id="eng_small_type" value="RPRO">
				<input type="hidden" name="eco_no" id="eco_no">
				<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag%>" />
				<input type="hidden" name="created_by" id="created_by">
				<input type="hidden" name="curPageNo" id="curPageNo" value="1">
				<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
				<div id="ecoRelatedProjectsListDiv" style=" margin-top: 10px;" >
					<table id="ecoRelatedProjectsList"></table>
					<div id="pecoRelatedProjectsList"></div>
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
		var jqgHeight = $(window).height() * 0.6;
		var main_name = window.parent.$("#ref_main_name").val();
		var states_desc = parent.document.getElementById("states_desc").value;
		var locker_by = parent.document.getElementById("locker_by").value;
		var loginId = parent.document.getElementById("loginid").value;

		$('#eco_no').val(main_name);

		$(document).ready(function() {
			$("#ecoRelatedProjectsList").jqGrid({
				datatype : 'json',
				mtype : '',
				url : '',
				postData : $("#application_form").serialize(),
				colNames : [ '선택', '', 'Name', 'Model', 'flag', 'buyer', 'Description', '작성자', '' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, hidden : true }, 
				             { name : 'main_code', index : 'main_code', width : 70, hidden : true }, 
				             { name : 'project_no', index : 'project_no', align : "center", width : 80 }, 
				             { name : 'model', index : 'model', align : "center", width : 80 }, 
				             { name : 'flag', index : 'flag', width : 100 }, 
				             { name : 'buyer', index : 'buyer', width : 100 }, 
				             { name : 'main_description', index : 'main_description', width : 200 }, 
				             { name : 'modify_by', index : 'modify_by', width : 100 }, 
				             { name : 'oper', index : 'oper', width : 25, hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : parent.objectHeight-135,
				caption : "Related Projects",
				hidegrid : false,
				pager : $('#pecoRelatedProjectsList'),
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
				//afterSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images'
			});

			$("#ecoRelatedProjectsList").jqGrid('navGrid', "#pecoRelatedProjectsList", {
				search : false,
				edit : false,
				add : false,
				del : false
			});
			
			//fn_jqGridsetHeight($("#divCloseFlag").val(), "ecoRelatedProjectsList", screen.height);
			
			if (main_name == "") {
				$("#ecoRelatedProjectsList").jqGrid("setCaption",
						'Related Projects');
			} else {
				$("#ecoRelatedProjectsList").jqGrid("setCaption",
						'Related Projects - ' + main_name);
			}
			fn_gridresize( parent.objectWindow,$( "#ecoRelatedProjectsList" ),-100,0.5 );
		}); //end of ready Function 

		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $('#ecoRelatedProjectsList').jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';
			$('#ecoRelatedProjectsList').jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");
		}

		//폼데이터를 Json Arry로 직렬화
		/* 황경호 function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		} */

		/* 황경호 function getChangedChmResultData(callback) {
			//가져온 배열중에서 필요한 배열만 골라내기 
			var changedData = $.grep($("#ecoRelatedProjectsList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		} */
		
		
		function fn_search() {
			if(window.parent.$("#main_code").val() == "") {
				alert('ECO 선택후 조회 바랍니다.');
			} else {
				$('#eco_no').val(parent.document.getElementById("main_code").value);
				$("#ecoRelatedProjectsList").jqGrid("setCaption", 'Related Projects - ' + window.parent.$("#ref_main_name").val());
				var sUrl = 'infoEcoProjectList.do';
				jQuery("#ecoRelatedProjectsList").jqGrid('setGridParam',{url:sUrl
																 ,mtype: 'POST'
																 ,page:1
																 ,datatype: 'json',
																 postData: fn_getFormData( "#application_form" )}).trigger("reloadGrid");
			}
		}
		</script>
	</body>
</html>
