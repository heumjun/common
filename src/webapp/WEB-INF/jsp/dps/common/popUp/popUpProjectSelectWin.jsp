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
<title>호선 지정</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="loginID" value='<c:out value="${loginID }"/>'/>
				<input type="hidden" name="category" value='<c:out value="${category }"/>'/>
				<div id="dataListDiv" style="width: 40%; float: left;">
					<table id="dataList"></table>
					<div id="pDataList"></div>
					<input type="checkbox" name="motherProjectOnly" onclick="fn_showMotherProjectOnly('dataList',this);" /><font color="#0000ff">대표호선만 표시</font><br>
				</div>
			</form>
			<div id="buttonArray" style="width: 20%; float: left; margin-top:10%; text-align: center;">
				<input type="button" class="btn_blue" value="저장" onclick="fn_saveProject('saveList');"><br/><br/>
           		<input type="button" class="btn_blue" value="추가 >>" onclick="fn_addProject('dataList','saveList');"><br/><br/>
          		<input type="button" class="btn_blue" value="삭제 &lt;&lt;" onclick="fn_delProject('dataList','saveList');">
			</div>
			<form id="application_form1" name="application_form1" method="post">
				<input type="hidden" name="loginID" value='<c:out value="${loginID }"/>'/>
				<input type="hidden" name="category" value='<c:out value="${category }"/>'/>
				<input type="hidden" name="selectedProjectList" value='<c:out value="${selectedProjects }"/>'/>
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
				url:'projectSearchItem.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['전체호선','state','s_no'],
				colModel : [{name : 'projectno', index : 'projectno', width: 220, align : "center" },
							{name : 'state', index : 'state', width: 120, align : "center", hidden:true},
							{name : 's_no', index : 's_no', width: 120, align : "center", hidden:true}
				           ],
	           gridview : true,
	           cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "전체 호선",
				autowidth : true,
				height : objectHeight,
				multiselect: true,
				hidegrid: false,
				pgbuttons: false,     // disable page control like next, back button
			    pgtext: null,
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
				onPaging: function(pgButton) {
				},
				ondblClickRow : function(rowId) {
					fn_addProject("dataList","saveList");
					var rowData = jQuery(this).getRowData(rowId);
					var projectno = rowData['projectno'];
					var savedGrid = $("#saveList").jqGrid('getDataIDs');
					var checkValue = false;
					
					for(var i =0; i < savedGrid.length; i++){
						if(projectno == $("#saveList").getRowData( savedGrid[i] ).project)
						{
							checkValue = true;	
							break;
						} 
					}
					if(!checkValue)
					{
						var addData = {"project" : projectno,
										"userid" : '<c:out value="${loginID}"/>',
										"oper" : 'I'};
						$("#saveList").jqGrid('addRowData',$.jgrid.randId(),addData,'last');
					}
				},
				loadComplete: function (data) {
					var rowCnt = $("#dataList").getGridParam("reccount");
	             	
	             	if (rowCnt == 0) {
	             		//self.close();	
	             	} else if (rowCnt == 1) {
	             		var rowData = jQuery(this).getRowData(1);		
			
	             		var returnValue = new Array();
	             		returnValue[0] = rowData['projectno'];
		    			returnValue[1] = rowData['state'];
		    			returnValue[2] = rowData['s_no'];
		      			window.returnValue = returnValue;
		      			self.close();
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
				datatype : 'json',
				url:'projectSavedSearchItem.do',
				postData : fn_getFormData("#application_form1"),
				colNames : ['선택호선','userid','oper'],
				colModel : [{name : 'project', index : 'project', width: 120, align : "center"},
				            {name : 'userid', index : 'userid', width: 120, align : "center" , hidden:true},
				            {name : 'oper', index : 'oper', width : 25, align : "center", hidden : true}
							],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				caption : '선택 호선',
				autowidth : true, //autowidth: true,
				height : objectHeight,
				multiselect: true,
				rowNum : -1,
				pgbuttons: false,     // disable page control like next, back button
			    pgtext: null,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery('#sDataList'),
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
				imgpath : 'themes/basic/images'
			} );
			//grid resize
			$( "#saveList" ).jqGrid( 'navGrid', "#sDataList", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} );
			fn_insideGridresize( $(window), $( "#saveListDiv" ),$("#saveList") );
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
				if($("#"+selectedGrid[c]).css("display") == 'none'){
					continue;
				}
				for(var i =0; i < savedGrid.length; i++){
					if($("#"+listGrid).getRowData( selectedGrid[c] ).projectno == $("#"+saveGrid).getRowData( savedGrid[i] ).project)
					{
						checkValue = true;	
						break;
					} 
				}
				if(!checkValue)
				{
					var addData = {"project" : $("#"+listGrid).getRowData( selectedGrid[c] ).projectno,
									"userid" : '<c:out value="${loginID}"/>',
									"oper" : 'I'};
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
		function fn_saveProject(saveGrid){
			var savedGrid = $("#"+saveGrid).jqGrid( 'getRowData' );
			if(savedGrid.length == 0){
				alert("저장 가능한 항목이 없습니다.");
				return;
			}
			var resultData = [];
			var savedRows = savedGrid.concat(resultData);
			
			var url = 'saveProjectSearchItem.do';
			var dataList = { chmResultList : JSON.stringify( savedRows ) };
			var formData = fn_getFormData( '#application_form1' );
			var parameters = $.extend( {}, dataList, formData );
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				if ( data.result == 'success' ) {
					alert('저장 완료');
				}
			}, 'json' ).error( function() {
				alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
			} ).always( function() {
				lodingBox.remove();
			} );
		}
		
		 // 모달 창을 닫으면서 '선택된 호선' 목록을 리턴
	    function fn_selectedProjectList(saveGrid)
	    {
	    	var savedGrid = $("#"+saveGrid).jqGrid('getDataIDs');
	    	var returnData = "";
	    	
	    	for(var i =0; i< savedGrid.length; i++){
	    		returnData += $("#"+saveGrid).getRowData( savedGrid[i] ).project;
	    		if(i != (savedGrid.length-1)){
	    			returnData += ",";
	    		}
	    	}
	        window.returnValue = returnData;
	        window.close();
	    }
		 
	    // 대표호선만 표시 여부를 반영
	    function fn_showMotherProjectOnly(listGrid,obj)
	    {	    	
	    	var gridRowIdArray = $("#"+listGrid).jqGrid('getDataIDs');
	    	var checkYN = $(obj).is(":checked");
	    	for(var i =0; i< gridRowIdArray.length; i++){
	    		var checkValue = $("#"+listGrid).getRowData( gridRowIdArray[i] ).s_no;	    		
	    		if(checkValue != "0" && checkYN == true){
	    			$("#"+listGrid+">tbody").children("tr:eq("+(i+1)+")").hide();
	    		} else {
	    			$("#"+listGrid+">tbody").children("tr:eq("+(i+1)+")").show();
	    		}
	    	}
	    }
	</script>
</body>
</html>