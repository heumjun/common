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
<!-- 				<input type="button" id="btncheck" value="확인" class="btn_blue"/> -->
<!-- 				<input type="button" id="btnfind" value="조회" class="btn_blue" /> -->
<!-- 				<input type="button" id="btncancle" value="닫기"  class="btn_blue"/> -->
				
				<input type="button" name="btnDel" id="btnDel" value="Group 삭제" class="btn_blue" />
				<input type="button" name="btnAdd" id="btnAdd" value="추가" class="btn_blue" />
				<input type="button" name="btnCancle" id="btnCancle" value="취소" class="btn_blue" />
			</div>
		</div>
		<div class="content">
			<table id="selectUserList"></table>
		</div>
	
	
	
	
	
	
	
	
	
	
	
	
<!-- 	<div> -->
<!-- 		Group -->
<!-- 		<span style="margin-left:10px; "> -->
<!-- 		<select id="groupList" name="groupList"> -->
<!-- 		</select> -->
<!-- 		</span> -->
<!-- 		<span style="margin-left:10px; "> -->
<!-- 			<input type="button" name="btnDel" id="btnDel" value="Group 삭제" /> -->
<!-- 		</span> -->
<!-- 		<div style="float: right;"> -->
<!-- 		<input type="button" name="btnAdd" id="btnAdd" value="추가" /> -->
<!-- 		<input type="button" name="btnCancle" id="btnCancle" value="취소" /> -->
<!-- 		</div> -->
<!-- 	</div> -->
<!-- 	<br/> -->
<!-- 	<div> -->
<!-- 		<table id="selectUserList"></table> -->
<!-- 	</div> -->
<!-- 	<br/> -->
<%-- 	<jsp:include page="./tbc_CommonLoadingBox.jsp" flush="false"></jsp:include> --%>
	</form>
</div>
<script type="text/javascript">

$(document).ready(function(){
	
	$("#selectUserList").jqGrid({ 
             datatype: 'local', 
             mtype: 'POST', 
             postData : $("#application_form").serialize(),
             editUrl: 'clientArray',
             colNames:['','구분','이름','부서','이메일','emp_no','dept_id','group_id','receiver_emp_no','creation_date'],
                colModel:[
                	{name:'iconremove',index:'iconremove'			,width: 10 	,align:'center'		, formatter: formatopt1},
                    {name:'user_type',index:'user_type'				,width: 20 	,align:'center'},
                    {name:'print_user_name',index:'print_user_name' ,width: 30	,align:'center'},
                    {name:'print_dept_name',index:'print_dept_name' ,width: 100	},
                    {name:'email',index:'email'						,width: 130	},
                    {name:'created_by',index:'created_by',hidden:true },
                    {name:'print_dept_id',index:'print_dept_id',hidden:true },
                    {name:'group_id',index:'group_id',hidden:true },
                    {name:'print_user_id',index:'print_user_id',hidden:true },
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
		var url = "delDWGReceiverGroup.do";
		
		var group_id  = $("#groupList").val();
		var parameters ={	GROUP_ID		: group_id};
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
	$("#btnCancle").click(function(){
		self.close();
	});
	
	$("#groupList").change(function(){
		
		var sUrl = "selectDWGReceiverGroupDetail.do";
		jQuery("#selectUserList").jqGrid('setGridParam',{url:sUrl,datatype:'json',page:1,postData: $("#application_form").serialize()}).trigger("reloadGrid");
	});
	
	function getGroupList(){
		/* var target = $("#groupList");
		var sUrl = "selectGroupList.do";
		getAjaxHtmlPost(target,sUrl,$("#application_form").serialize());  */
		$("#selectUserList").jqGrid("clearGridData");
		
		$.post( "selectGroupList.do", fn_getFormData( '#application_form' ), function( data ) {
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