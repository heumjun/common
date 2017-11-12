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
<title>도면 개정 HISTORY</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<span>도면:${dwgNo }(호선:${projectNo})</span>
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="dwgNo" value='<c:out value="${dwgNo }"/>'/>
				<input type="hidden" name="projectNo" value='<c:out value="${projectNo }"/>'/>
				<div id="dataListDiv">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="닫기"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
	
	<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		$(document).ready( function() {
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
			
			$( "#dataList" ).jqGrid( {
				url:'popUpProgressDwgRevisionHistory.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['REV','출도일자','ECO NO.','의뢰자사번','의뢰자','출도원인','출도부서','출도시기','비고'],
				colModel : [{name : 'deploy_rev', index : 'deploy_rev', width: 120, align : "center"},
							{name : 'deploy_date', index :'deploy_date', width: 220, align : "center"},
							{name : 'eco_no', index : 'eco_no', width: 120, align : "center", hidden:true},
							{name : 'employee_no', index : 'employee_no', width: 120, align : "center", hidden:true},
							{name : 'employee_name', index : 'employee_name', width: 120, align : "center"},
							{name : 'reason_code', index : 'reason_code', width: 120, align : "center"},
							{name : 'cause_depart', index : 'cause_depart', width: 120, align : "center"},
							{name : 'rev_timing', index : 'rev_timing', width: 120, align : "center"},
							{name : 'deploy_desc', index : 'deploy_desc', width: 120, align : "center"}
				           ],
				gridview : true,
				cmTemplate: { title: false,sortable: false},
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				autowidth : true, //autowidth: true,
				height : objectHeight,
				rowNum : -1,
				rownumbers: true,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery('#pDataList'),
				pgbuttons: false,     // disable page control like next, back button
			    pgtext: null,
				cellEdit : false, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				jsonReader : {
					//id : "item_code",
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
				},
				gridComplete : function() {
					var rows = $( "#dataList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						var rowData = $("#dataList").jqGrid('getRowData',rows[i]);
						/* $( "#dataList" ).jqGrid( 'setCell', rows[i], 'lock_date', '', { background : "#ffffe0" } ); */
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
		//숫자 정수 체크
		function numCheck(obj){
			 var num_check=/^[+-]?[0-9]*$/;
				if(!num_check.test(obj)){
				return false;
	 		}
			return true;
		}
	</script>
</body>
</html>