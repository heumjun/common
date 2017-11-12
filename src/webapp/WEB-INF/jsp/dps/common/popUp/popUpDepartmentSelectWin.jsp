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
<title>부서 선택</title>
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
				<input type="hidden" name="selectedDepartmentList" value='<c:out value="${selectedDepartments }"/>'/>
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
				url:'projectDepartmentSearchItem.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['부서명','부서코드'],
				colModel : [{name : 'dept_name', index : 'dept_name', width: 220, align : "center" },
				            {name : 'dept_code', index : 'dept_code', width: 220, align : "center", hidden:true}],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				caption : '전체부서',
				autowidth : true, //autowidth: true,
				height : objectHeight,
				multiselect: true,
				rowNum : -1,
				emptyrecords : '데이터가 존재하지 않습니다. ',
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
					var dept_code = rowData['dept_code'];
					var savedGrid = $("#saveList").jqGrid('getDataIDs');
					var checkValue = false;
					
					for(var i =0; i < savedGrid.length; i++){
						if(dept_code == $("#saveList").getRowData( savedGrid[i] ).dept_code)
						{
							checkValue = true;	
							break;
						} 
					}
					if(!checkValue)
					{
						var addData = {"dept_code" :  rowData.dept_code,
								"dept_name" :  rowData.dept_name};
						$("#saveList").jqGrid('addRowData',$.jgrid.randId(),addData,'last');
					}
				},
				loadComplete: function (data) {
				},
				gridComplete: function(){
					var rows = $( "#dataList" ).getDataIDs();
					
					$.each(rows,function(rows,rowId){
						var rowData = $("#dataList").getRowData(rowId);
						var dept_name = rowData.dept_name;
						var dept_code = rowData.dept_code;
						
						$('#dataList').jqGrid('setCell',rowId, 'dept_name', dept_code+": "+dept_name);
					});
					
					var selectedDepartment = application_form1.selectedDepartmentList.value;
					var selectedDepartmentAry = selectedDepartment.split(",");
					var selectedDepartmentGrid = [];
					for(var i = 0; i < selectedDepartmentAry.length; i++){
						if(selectedDepartmentAry[i] != '')
						{
							for( var c = 0; c < rows.length; c++ ) {
								var rowData = $( "#dataList" ).jqGrid('getRowData', rows[c]);
								if(rowData.dept_code == selectedDepartmentAry[i]){
									var temp = {};
									temp['dept_code'] = rowData.dept_code;
									temp['dept_name'] = rowData.dept_name;
									jQuery("#saveList").jqGrid('addRowData',c+1,temp);
								}
							}
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
			//fn_insideGridresize($(window), $("#dataListDiv"), $("#dataList"));
			resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"));
		});
	</script>
	<script type="text/javascript">
		$(document).ready( function() {
			
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
			
			
			$( "#saveList" ).jqGrid( {
				datatype : 'local',
				colNames : ['부서명','부서코드'],
				colModel : [{name : 'dept_name', index : 'dept_name', width: 220, align : "center" },
				            {name : 'dept_code', index : 'dept_code', width: 220, align : "center", hidden:true}],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				caption : '선택부서',
				autowidth : true, //autowidth: true,
				height : objectHeight,
				multiselect: true
			} );
			//fn_insideGridresize( $(window), $( "#saveListDiv" ),$("#saveList") );
			resizeJqGridWidth($(window),$("#saveList"), $( "#saveListDiv" ));
		} ); //end of ready Function 
	</script>
	<script type="text/javascript">
		var lodingBox;
		
		function fn_addProject(listGrid,saveGrid){
			var selectedGrid = $("#"+listGrid).jqGrid('getGridParam','selarrrow');
			var savedGrid = $("#"+saveGrid).jqGrid('getDataIDs');
			
			for(var c=0; c < selectedGrid.length; c++)
			{
				var checkValue = false;
				for(var i =0; i < savedGrid.length; i++){
					if($("#"+listGrid).getRowData( selectedGrid[c] ).dept_code == $("#"+saveGrid).getRowData( savedGrid[i] ).dept_code)
					{
						checkValue = true;	
						break;
					} 
				}
				if(!checkValue)
				{
					var addData = {"dept_code" : $("#"+listGrid).getRowData( selectedGrid[c] ).dept_code ,
									"dept_name" : $("#"+listGrid).getRowData( selectedGrid[c] ).dept_name };
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
	    	var temp_code = [];
	    	var temp_name = [];

	    	for(var i =0; i< savedGrid.length; i++){
	    		temp_code.push($("#"+saveGrid).getRowData( savedGrid[i] ).dept_code);
	    		temp_name.push($("#"+saveGrid).getRowData( savedGrid[i] ).dept_name); 
	    	}
	    	var returnStr = temp_code.join(",") +"|"+temp_name.join(",");
	        window.returnValue = returnStr;
	        window.close();
	    }
	</script>
</body>
</html>