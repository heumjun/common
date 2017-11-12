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
<title>시수 입력 LOCK 관리</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<div id="dataListDiv">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="저장"  id="btn_save" class="btn_blue"/>
			<input type="button" value="취소"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_save").click(function(){
			var loadingBox  = new ajaxLoader( $( '#mainDiv' ));
			var formData = fn_getFormData('#application_form');
			
			getGridChangedData($( "#dataList"),function(data) {
				changeRows = data;
				
				if (changeRows.length == 0) {
					alert("내용이 없습니다.");
					return;
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);
			
				if(confirm('저장하시겠습니까?')){
					
					$.post("popUpDesignApprovalViewMainGridSave.do",parameters ,function(data){
						alert("저장완료");
						$("#btnClose").click();
					},"json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				}
			});
		});
	});
</script>
<script type="text/javascript">
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			url:'popUpInputLockControlViewMainGrid.do',
			datatype: "json",
			postData : fn_getFormData( "#application_form" ),
			colNames : ['부서코드','부서명','입력유효일자','oper'],
			colModel : [{name : 'dept_code', index : 'dept_code', width: 50, align : "center" },
						{name : 'dept_name', index :'dept_name', width: 100, align : "center"},
						{name : 'lock_date', index : 'lock_date', width: 50, align : "center", editable:true, formatter:'date',
							formatoptions:{srcformat:"Y-m-d",newformat:"Y-m-d"},
							editoptions: 
							{ 
								dataInit: function (element) {
									$(element).datepicker( {
										prevText: '이전 달',
										nextText: '다음 달',
										monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
										monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
										dayNames: ['일','월','화','수','목','금','토'],
										dayNamesShort: ['일','월','화','수','목','금','토'],
										dayNamesMin: ['일','월','화','수','목','금','토'],
										dateFormat: 'yy-mm-dd',
										showMonthAfterYear: true,
										yearSuffix: '년',
										changeYear:true,
										changeMonth:true,
										onSelect: function( selectedDate,i) {
											var rowData = $('#dataList').jqGrid('getRowData', kRow);
											if(selectedDate != i.lastVal && rowData.oper == 'R'){
												$('#dataList').jqGrid('setCell',kRow,'oper','U');
												$('#dataList').jqGrid('setCell',kRow,'lock_date','',{ background : '#fff0f5' });
											}
											$('#dataList').saveCell(kRow, idCol);
										}
									} );
								}
							}
						},
						{name : 'oper', index :'oper', width: 100, align : "center", hidden:true}
			           ],
           gridview : true,
           cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			viewrecords : true,
			autowidth : true,
			height : objectHeight,
			hidegrid: false,
			rowNum : -1,
			rownumbers: true,
			emptyrecords : '데이터가 존재하지 않습니다.',
			pager : jQuery('#pDataList'),
			cellEdit : true, // grid edit mode 1
			pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
			cellsubmit : 'clientArray', // grid edit mode 2
			imgpath : 'themes/basic/images',
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records"
			},
			loadComplete: function (data) {
			},
			onSelectRow : function (rowid,status,e){
			},
			onCellSelect : function(rowid,iCol,cellContent,e){
				kRow = rowid;
				idCol = iCol;
			}
		});
		
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		$("#dataList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.70);
	});
</script>
</body>
</html>