<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>조회가능호선관리</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="loginID" value='<c:out value="${loginID }"/>'/>
				<input type="hidden" name="category" value='<c:out value="${category }"/>'/>
				<div id="dataListDiv">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="확인"  id="btnOk" class="btn_blue" onclick="fn_saveProject('dataList');"/>
			<input type="button" value="취소"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
	
	<script type="text/javascript">
		$(document).ready( function() {
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
			$( "#dataList" ).jqGrid( {
				url:'projectSearchAbleItem.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['호선','기본도','생설도','s_no','state_hidden','oper'],
				colModel : [{name : 'projectno', index : 'projectno', width: 220, align : "center" },
							{name : 'bBasic_state', index : 'bBasic_state', width: 120, align : "center"},
							{name : 'pBasic_state', index : 'pBasic_state', width: 120, align : "center"},
							{name : 's_no', index : 's_no', width: 120, align : "center", hidden:true},
							{name : 'state_hidden', index : 'state_hidden', width: 120, align : "center", hidden:true},
							{name : 'oper', index : 's_no', width: 120, align : "center", hidden:true}
				           ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				caption : '선택 호선',
				autowidth : true, //autowidth: true,
				height : objectHeight,
				rowNum : -1,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery('#pDataList'),
				cellEdit : false, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
				},
				jsonReader : {
					//id : "item_code",
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
				},
				ondblClickRow : function(rowId,irow,icol,e) {
					var rowData = jQuery(this).getRowData(rowId);
					var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
					var colName = cm[icol].name;
					var projectno = rowData['projectno'];
					var bBasic_state = rowData['bBasic_state'];
					var pBasic_state = rowData['pBasic_state'];
					var hiddenValue = "";
					
					var oper = rowData['oper'];
					if(colName == "bBasic_state"){
						bBasic_state = bBasic_state == "OPEN" ? "CLOSED" : "OPEN";
						$( "#dataList" ).jqGrid( 'setCell', rowId, colName,bBasic_state);
					}
					if(colName == "pBasic_state"){
						pBasic_state = pBasic_state == "OPEN" ? "CLOSED" : "OPEN";
						$( "#dataList" ).jqGrid( 'setCell', rowId, colName, pBasic_state);
					}
					
					if (bBasic_state == "OPEN") hiddenValue = "B";
			        if (pBasic_state == "OPEN") hiddenValue += "P";
			        if (hiddenValue == "") hiddenValue = "CLOSED";
			        else if (hiddenValue == "BP") hiddenValue = "ALL";
					
					$( "#dataList" ).jqGrid( 'setCell', rowId, 'state_hidden', hiddenValue);
					$( "#dataList" ).jqGrid( 'setCell', rowId, 'oper', 'U');
				},
				gridComplete : function() {
					var rows = $( "#dataList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						var state = $( "#dataList" ).getCell( rows[i], "state_hidden" );
						var projectno = $( "#dataList" ).getCell( rows[i], "projectno" );
						
						var bDwgSearchable = (state.indexOf("B") >= 0) ? "OPEN" : "CLOSED";
		                var pDwgSearchable = (state.indexOf("P") >= 0) ? "OPEN" : "CLOSED";
		                if (state == "ALL") { bDwgSearchable = "OPEN"; pDwgSearchable = "OPEN"; }
		                
		                var bColorStr = "#ffffff";
		                var pColorStr = "#ffffff";
		                
		                if (bDwgSearchable == "CLOSED") bColorStr = "#fff0f5";
		                if (pDwgSearchable == "CLOSED") pColorStr = "#fff0f5";
		                
		                $( "#dataList" ).jqGrid( 'setCell', rows[i], 'bBasic_state', bDwgSearchable, { color : 'black', background : bColorStr } );
		                $( "#dataList" ).jqGrid( 'setCell', rows[i], 'pBasic_state', pDwgSearchable, { color : 'black', background : pColorStr } );
					}
				}
			});
			//grid resize
			$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} );
			fn_insideGridresize($(window), $("#dataListDiv"), $("#dataList"));
			
		});
		function fn_saveProject(saveGrid){
			var loadingBox  = new ajaxLoader( $( '#mainDiv' ));
			var formData = fn_getFormData('#application_form');
			
			getGridChangedData($( "#"+saveGrid ),function(data) {
				changeRows = data;
				
				if (changeRows.length == 0) {
					var rows = $( "#dataList" ).getDataIDs();
					
					var returnV = "";
					for(var i=0; i<rows.length; i++){
						var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
						returnV += rowData.projectno +"|"+rowData.state_hidden;
						returnV += ",";
					}
					window.returnValue = returnV;
					window.close();
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);
			
				if(confirm('저장하시겠습니까?')){
					
					$.post("projectSaveSearchAbleItem.do",parameters ,function(data){
						alert("저장완료하였습니다");
						
						var rows = $( "#dataList" ).getDataIDs();
						var returnV = "";
						for(var i=0; i<rows.length; i++){
							var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
							returnV += rowData.projectno +"|"+rowData.state_hidden;
							returnV += ",";
						}
						window.returnValue = returnV;
						window.close();
					},"json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				}
			});
		}
	</script>
</body>
</html>