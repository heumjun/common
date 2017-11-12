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
<title>호선 검색</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<div id="dataListDiv" style="width: 40%; float: left;">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
			<div id="buttonArray" style="width: 20%; float: left; margin-top:10%; text-align: center;">
           		<input type="button" class="btn_blue" value="추가 >>" onclick="fn_addProject('dataList','saveList');"><br/><br/>
          		<input type="button" class="btn_blue" value="삭제 &lt;&lt;" onclick="fn_delProject('dataList','saveList');">
			</div>
			<form id="application_form1" name="application_form1" method="post">
				<input type="hidden" name="employee_id" value='<c:out value="${employee_id }"/>'/>
				<div id="saveListDiv" style="width: 40%; float: left;">
					<table id="saveList"></table>
					<div id="sDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="확인"  id="btnOk" class="btn_blue" onclick="fn_selectedProjectList('saveList');"/>
			<input type="button" value="취소"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
	
	<script type="text/javascript">
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var kRow = 0;
		$(document).ready( function() {
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
			$( "#dataList" ).jqGrid( {
				url:'popUpInputProjectSearchItem.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['전체호선','호선'],
				colModel : [{name : 'projectno_dp', index : 'projectno_dp', width: 220, align : "center" },
				            {name : 'projectno', index : 'projectno', width: 220, align : "center", hidden:true}],
	            gridview : true,
	           	cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "전체 호선",
				autowidth : true,
				height : objectHeight,
				//shrinkToFit : false,
				multiselect: true,
				hidegrid: false,
				rowNum : -1,
				emptyrecords : '데이터가 존재하지 않습니다.',
				pager : jQuery('#pDataList'),
				cellEdit : false, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				imgpath : 'themes/basic/images',
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records"
				},
				ondblClickRow : function(rowId) {
					var rowData = jQuery(this).getRowData(rowId);
					var projectno = rowData['projectno'];
					var savedGrid = $("#saveList").jqGrid('getDataIDs');
					var checkValue = false;
					
					for(var i= 0; i < savedGrid.length; i++){
						if(projectno == $("#saveList").getRowData( savedGrid[i] ).projectno)
						{
							checkValue = true;	
							break;
						} 
					}
					if(!checkValue)
					{	
						var addData = {"projectno" : rowData['projectno_dp'],
										"projectno_dp" : rowData['projectno_dp'],
								"gubun" : "SELECTED",
								"oper" : "U"};
						$("#saveList").jqGrid('addRowData',$.jgrid.randId(),addData,'last');
					}
					$("#saveList").jqGrid('resetSelection');
				},
				loadComplete: function (data) {
				},
				gridComplete : function() {
					var rows = $( "#dataList" ).getDataIDs();
					for(var i=0; i<rows.length; i++){
						var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
						 if((rowData.projectno).substring(0,1) == "Z"){
							$('#dataList').jqGrid('setCell',rows[i], 'projectno_dp', rowData.projectno);
							$('#dataList').jqGrid('setCell',rows[i], 'projectno', rowData.projectno.substring(1));
						} else {
							$('#dataList').jqGrid('setCell',rows[i], 'projectno_dp', rowData.projectno);
						}
					}
				}
			});
			
			$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} );
			fn_insideGridresize($(window), $("#dataListDiv"), $("#dataList"));
		});
	</script>
	<script type="text/javascript">
		$(document).ready( function() {
			
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
			$( "#saveList" ).jqGrid( {
				url:'popUpInputProjectSelectedNInvaildItem.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form1" ),
				colNames : ['선택호선','호선','구분','oper'],
				colModel : [{name : 'projectno_dp', index : 'projectno_dp', width: 220, align : "center" },
				            {name : 'projectno', index : 'projectno', width: 220, align : "center", hidden:true},
							{name : 'gubun', index : 'gubun', width: 220, align : "center", hidden:true},
							{name : 'oper', index : 'oper', width: 220, align : "center", hidden:true}],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				caption : '선택호선',
				autowidth : true, //autowidth: true,
				height : objectHeight,
				multiselect: true,
				rowNum : -1,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery('#sDataList'),
				cellEdit : false, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				imgpath : 'themes/basic/images',
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records"
				},
				ondblClickRow : function(rowId) {
					$('#saveList').jqGrid('delRowData',rowId);
				},
				gridComplete : function() {
					var rows = $( "#saveList" ).getDataIDs();

					for(var i=0; i<rows.length; i++){
						var rowData = $('#saveList').jqGrid('getRowData', rows[i]);
						 if((rowData.projectno).substring(0,1) == "Z"){
							$('#saveList').jqGrid('setCell',rows[i], 'projectno_dp', rowData.projectno);
							$('#saveList').jqGrid('setCell',rows[i], 'projectno', rowData.projectno.substring(1));
						} else {
							if(rowData.projectno == rowData.projectno_dp){
								$('#saveList').jqGrid('setCell',rows[i], 'projectno_dp', rowData.projectno);
							} else if(rowData.projectno_dp == "") {
								$('#saveList').jqGrid('setCell',rows[i], 'projectno_dp', rowData.projectno);
							}
						}
					}
				}
			} );
			fn_insideGridresize( $(window), $( "#saveListDiv" ),$("#saveList") );
		} ); //end of ready Function 
	</script>
	<script type="text/javascript">
		
		function fn_addProject(listGrid,saveGrid){
			var selectedGrid = $("#"+listGrid).jqGrid('getGridParam','selarrrow');
			var savedGrid = $("#"+saveGrid).jqGrid('getDataIDs');
			
			for(var c=0; c < selectedGrid.length; c++)
			{
				var checkValue = false;
				for(var i =0; i < savedGrid.length; i++){
					if($("#"+listGrid).getRowData( selectedGrid[c] ).projectno == $("#"+saveGrid).getRowData( savedGrid[i] ).projectno)
					{
						checkValue = true;	
						break;
					} 
				}
				if(!checkValue)
				{
					var addData = {
									"projectno_dp" : $("#"+listGrid).getRowData( selectedGrid[c] ).projectno_dp,
									"projectno" : $("#"+listGrid).getRowData( selectedGrid[c] ).projectno,
									"gubun" : "SELECTED",
									"oper" :"U"
								};
					$("#"+saveGrid).jqGrid('addRowData',$.jgrid.randId(),addData,'last');
				}
			}
			 $("#"+listGrid).jqGrid('resetSelection');
		}
		function fn_delProject(listGrid,saveGrid){
			var savedGrid = $("#"+saveGrid).jqGrid('getGridParam','selarrrow');
			for(var c=savedGrid.length; c > 0; c--)
			{
				$("#"+saveGrid).jqGrid('delRowData',savedGrid[c-1]);
			}
		}
		 // 모달 창을 닫으면서 '선택된 호선' 목록을 리턴
	    function fn_selectedProjectList(saveGrid)
	    {
	    	var savedGrid = $("#"+saveGrid).jqGrid('getDataIDs');
	    	var returnData = "";
	    	
	    	for(var i =0; i< savedGrid.length; i++){
	    		var rowData = $('#saveList').jqGrid('getRowData', savedGrid[i]);
	    		if(rowData.projectno == null || rowData.projectno == undefined || rowData.projectno == '') continue;
	    		if(rowData.gubun == "INVALID") {
	    			alert("유효하지 않은 호선(: 붉은색 바탕으로 표시)이 있습니다. 해당 항목을 삭제한 후 진행하십시오.");
					return;
	    		}
	    		
	    		returnData += $("#"+saveGrid).getRowData( savedGrid[i] ).projectno_dp;
	    		if(i != (savedGrid.length-1)){
	    			returnData += ",";
	    		}
	    	}
	    	var loadingBox  = new ajaxLoader( $( '#mainDiv' ));
			var formData = fn_getFormData('#application_form1');
			
			getGridChangedData($( "#"+saveGrid ),function(data) {
				changeRows = data;
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);
			
				$.post("popUpInputProjectSelectedNInvaildItemSave.do",parameters ,function(data){
					window.returnValue = returnData;
			        window.close();
				},"json").error( function() {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
					loadingBox.remove();
				} );
			});
	    }
	</script>
</body>
</html>