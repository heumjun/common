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
				colNames : ['호선','조회가능','s_no','state_hidden','oper'],
				colModel : [{name : 'projectno', index : 'projectno', width: 220, align : "center" },
							{name : 'state', index : 'state', width: 120, align : "center"},
							{name : 's_no', index : 's_no', width: 120, align : "center", hidden:true},
							{name : 'state_hidden', index : 's_no', width: 120, align : "center", hidden:true},
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
				ondblClickRow : function(rowId) {
					var rowData = jQuery(this).getRowData(rowId);
					var projectno = rowData['projectno'];
					var state = rowData['state'];
					var oper = rowData['oper'];
					
					if(state == "OPEN"){
						$( "#dataList" ).jqGrid( 'setCell', rowId, 'state', 'CLOSED', { color : 'black', background : '#DADADA' } );
						$( "#dataList" ).jqGrid( 'setCell', rowId, 'state_hidden', 'CLOSED');
						$( "#dataList" ).jqGrid( 'setCell', rowId, 'projectno', projectno, { color : 'black', background : '#DADADA' } );
					} else {
						$( "#dataList" ).jqGrid( 'setCell', rowId, 'state', 'OPEN', { color : 'black', background : '#ffffff' } );
						$( "#dataList" ).jqGrid( 'setCell', rowId, 'state_hidden', 'ALL');
						$( "#dataList" ).jqGrid( 'setCell', rowId, 'projectno', projectno, { color : 'black', background : '#ffffff' } );
					}
					$( "#dataList" ).jqGrid( 'setCell', rowId, 'oper', 'U');
				},
				gridComplete : function() {
					var rows = $( "#dataList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						var state = $( "#dataList" ).getCell( rows[i], "state" );
						var projectno = $( "#dataList" ).getCell( rows[i], "projectno" );

						if( state == "CLOSED" ) {
							$( "#dataList" ).jqGrid( 'setCell', rows[i], 'state', state, { color : 'black', background : '#DADADA' } );
							$( "#dataList" ).jqGrid( 'setCell', rows[i], 'projectno', projectno, { color : 'black', background : '#DADADA' } );
						} else {							
							$( "#dataList" ).jqGrid( 'setCell', rows[i], 'state', 'OPEN', { color : 'black', background : '#ffffff' } );
							$( "#dataList" ).jqGrid( 'setCell', rows[i], 'projectno', projectno, { color : 'black', background : '#ffffff' } );
						}
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
					alert("내용이 없습니다.");
					return;
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);
			
				if(confirm('저장하시겠습니까?')){
					
					$.post("projectSaveSearchAbleItem.do",parameters ,function(data){
						$("#btnClose").click();
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