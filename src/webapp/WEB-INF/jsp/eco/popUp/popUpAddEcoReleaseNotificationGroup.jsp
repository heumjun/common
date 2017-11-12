<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Group List</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv">
	<form id="application_form" name="application_form">
	<input type="hidden" name = "userId" id = "userId" value="${loginUser.user_id}" />
	
	
		<div class="topMain" style="margin: 0px;line-height: 45px;">
			<div class="conSearch">
				<span class="pop_tit">Group</span>
				<select id="groupList" name="groupList"></select>
			</div>
			<div class="button">
				
				<input type="button" name="btnDel" id="btnDel" value="Group 삭제" class="btn_blue" />
				<input type="button" name="btnAdd" id="btnAdd" value=" 추 가 " class="btn_blue" />
				<input type="button" name="btnCancel" id="btnCancel" value=" 닫 기 " class="btn_blue" />
			</div>
		</div>
		<div class="content">
			<table id="selectUserList"></table>
		</div>

	</form>
</div>
<script type="text/javascript">

$(document).ready(function(){
	
	$("#selectUserList").jqGrid({ 
             datatype: 'local', 
             mtype: 'POST', 
             postData : $("#application_form").serialize(),
             editUrl: 'clientArray',
             colNames:['', '사번', '이름', '직급', '부서', 'group_id', 'creation_date'],
             colModel:[
             	{name:'iconremove',index:'iconremove'			,width: 20 	,align:'center'		, formatter: formatopt1},
                 {name:'emp_no',index:'emp_no' ,width: 50	,align:'center'},
                 {name:'user_name',index:'user_name' ,width: 50	},
                 {name:'position_name',index:'position_name', width:50 },
                 {name:'dept_name',index:'dept_name' , width:100},
                 {name:'group_id',index:'group_id',hidden:true },
                 {name:'creation_date',index:'creation_date',hidden:true },
             ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 460,
             pgbuttons: false,
			 pgtext: false,
			 pginput:false,
			 rowNum: -1,
			 loadonce:true,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
    });
    getGroupList();
});
	$("#btnDel").click(function(){
		var url = "delEcoReleaseNotificationGroup.do";
		
		var group_id  = $("#groupList").val();
		if(group_id == "" || group_id == null)
		{
			alert("삭제할 그룹을 선택해주세요.");
			return;
		}
		var parameters ={	GROUP_ID		: group_id};
		if(confirm("선택한 그룹을 삭제하시겠습니까?"))
		{
			$(".loadingBoxArea").show();
			$.post(url, parameters, function(data) {
	
					alert(data.resultMsg);
					
					if (data.result == "success") { 		 	
					 	getGroupList();
					}
				}).fail(function(){
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				}).always(function() {
			    	$(".loadingBoxArea").hide();
				});
		}
	});
	
	$("#btnAdd").click(function(){
		var ids = jQuery("#selectUserList").jqGrid('getDataIDs');
		for (var i = 0; i < ids.length; i++) 
		{
		    var rowId = ids[i];
		    var rowData = jQuery('#selectUserList').jqGrid ('getRowData', rowId);
		    opener.insertRow(rowData);
		}
		$('#selectUserList').resetSelection();
		self.close();
	});
	$("#btnCancel").click(function(){
		self.close();
	});
	
	$("#groupList").change(function(){
		
		var sUrl = "selectEcoReleaseNotificationGroupDetail.do";
		jQuery("#selectUserList").jqGrid('setGridParam',{url:sUrl,datatype:'json',page:1,postData: $("#application_form").serialize()}).trigger("reloadGrid");
	});
	
	function getGroupList(){		
		$("#selectUserList").jqGrid("clearGridData");
		$("#groupList").find("option").remove();
		
		$.post( "selectEcoReleaseNotificationGroupList.do", fn_getFormData( '#application_form' ), function( data ) {
			$("#groupList").append( "<option value=''> ## 목록 ## </option>" );
			for(var i =0; i < data.length; i++){
				 $("#groupList").append( "<option value='"+data[i].value+ "'>" + data[i].display + "</option>" );
			}	
		}, "json" );
		
		
	}
	
	function formatopt1(cellvalue, options, rowObject){
		var rowid = options.rowId;
   		var imagepath = "./images";
   		var fileame = "iconStatusRemoved.gif";
   		var sHTML = "<img src='" + imagepath + "/" + fileame + "' border='0' id='"+rowid+"' onclick='deleteRow("+rowid+")'/>"; 
   	 	return sHTML;
	}
	function deleteRow(rowid){
		$('#selectUserList').jqGrid('delRowData', rowid);
		$('#selectUserList').resetSelection();
	}
</script>
</body>
</html>