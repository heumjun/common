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
<title>호선 다중선택</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="employee_id" value="${employee_id }">
				<div id="dataListDiv">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="확인"  id="btn_ok" class="btn_blue"/>
			<input type="button" value="취소"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_ok").click(function(){
			var idArry = jQuery("#dataList").jqGrid('getGridParam', 'selarrrow');
			
			var projectListStr = "";
		    
		    var deliveryProjectStr = "";   //인도호선 리스트
		    
		    var dwgSeriesProjectNoStr = ""; //대표호선 체크용
		    var dwgSeriesProjectNoConfirmFlag = false;
		    
			for(var i=0; i<idArry.length; i++)
			{
				var rowData = $("#dataList").jqGrid('getRowData',idArry[i]);
				
				var selectProject =rowData.projectno;
	    		if(projectListStr=="")
	    		{
	    			projectListStr = selectProject;
	    		} else {
	    			projectListStr += ","+selectProject;	    		
	    		}
	    		
	    		// 인도호선일 경우 별도로 담아둠
	    		if(selectProject.substring(0, 1)=='Z')
	    		{
	    			if(deliveryProjectStr=="")	
	    			{
	    				deliveryProjectStr = selectProject;
	    			} else {
	    				deliveryProjectStr += ", "+selectProject;	    			
	    			}		
	    		}
	    		
				// 선택된 호선 중 다른 대표호선이 있을 경우 confirm 알림
	    		var dwgSeriesProjectNo = rowData.dwgseriesprojectno;

	    		if(dwgSeriesProjectNoStr == "")
	    		{
	    			dwgSeriesProjectNoStr = dwgSeriesProjectNo;	    			
	    		} else {
	    			if(dwgSeriesProjectNo != dwgSeriesProjectNoStr)
	    			{
	    				dwgSeriesProjectNoConfirmFlag = true;	    				
	    			}
	    		}
				
			}
			if(dwgSeriesProjectNoConfirmFlag)
			{
				if(confirm("시리즈가 아닌 호선이 선택되었습니다.\n\n그대로 진행하시겠습니까?"))
				{
				} else {
					return;
				}	
			}
			
	       	// 인도호선일 경우 알림 메시지 표시       	
	       	if(deliveryProjectStr != "")
	       	 {
	       	 	var ConfirmMsg = "인도호선 ("+deliveryProjectStr+") 에 대한 시수입력 시\n반드시 업무내용란에 사유를 입력하여 주시길 바랍니다.\n\n";
	       	 	ConfirmMsg += "인도시점 및 사유 관련 문의사항은\n기술기획팀 한경훈 과장 (T.3220) 으로 문의바랍니다.\n\n진행하시겠습니까?";
	       	 	
	       	 	if(confirm(ConfirmMsg))
	       	 	{
				    window.returnValue=projectListStr;
				    window.close();		       	 	
	       	 	}
	       	 } else {   
			    window.returnValue=projectListStr;
			    window.close();		
			 }
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
			url:'popUpInputProjectMultiSelectMainGrid.do',
			datatype: "json",
			postData : fn_getFormData( "#application_form" ),
			colNames : ['Project','대표호선'],
			colModel : [{name : 'projectno', index : 'projectno', width: 100, align : "center" },
						{name : 'dwgseriesprojectno', index :'dwgseriesprojectno', width: 50, align : "center"}
			           ],
           gridview : true,
           cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			viewrecords : true,
			autowidth : true,
			height : objectHeight,
			hidegrid: false,
			rowNum : -1,
			emptyrecords : '데이터가 존재하지 않습니다.',
			pager : jQuery('#pDataList'),
			cellEdit : true, // grid edit mode 1
			pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
			cellsubmit : 'clientArray', // grid edit mode 2
			multiselect: true,
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
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.50);
	});
</script>
</body>
</html>