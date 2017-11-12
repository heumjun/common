<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>사용자 검색</title>
<%-- <jsp:include page="./tbc_Style.jsp" flush="false"></jsp:include> --%>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id="mainDiv">
	<form id="application_form" name="application_form">
	<input type="hidden" name = "userId" id = "userId" value="<c:out value="${loginUser.user_id}" />" />
	<input type="hidden" name="p_daoName" value="" />
	<input type="hidden" name="p_queryType" value="" />
	<input type="hidden" name="p_process" value="" />
	
	<table class="searchArea conSearch">
		<tr>
			<th>사용자명
			</th>
			<td><input type="text" name="userName" id="userName" value="<c:out value="${p_code_find}" />" style="width: 50px;"/>
			</td>
			<th>부서명
			</th>
			<td><input type="text" name="deptName" id="deptName" value="" style="width: 100px;"/>
			</td>
			<td>
				<div class="button endbox">
					<input class="btn_blue" type="button" name="btnSearch" id="btnSearch" value="조회" style="margin-left: 50px;"/>
					<input class="btn_blue" type="button" name="btnCancle" id="btnCancle" value="취소" />
				</div>
			</td>
		</tr>
	</table>
	
	<div>
		<table id="selectUserList"></table>
	</div>
		
	</form>
</div>
<script type="text/javascript">

$(document).ready(function(){
	$("#selectUserList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             postData : $("#application_form").serialize(),
             editUrl: 'clientArray',
             colNames:['사번','이름','부서','인사부서','이메일','dept_id'],
                colModel:[
                    {name:'print_user_id',index:'print_user_id' 	,width: 60	,align:'center' },                    
                    {name:'print_user_name',index:'print_user_name'	,width: 50  ,align:'center' },
                    {name:'print_dept_name',index:'print_dept_name'	,width: 100 },
                    {name:'insa_dept_name',index:'insa_dept_name'	,width: 150 },
                    {name:'email',index:'email'						,width:	150 ,hidden:true},
                    {name:'print_dept_id',index:'print_dept_id',hidden:true} 
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 400,
             pgbuttons: false,
             rowNum: -1,
			 pgtext: false,
			 pginput:false,
			 loadonce:true,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow : function(rowId) {
					var rowData = jQuery(this).getRowData(rowId);
					var sd_code = rowData['print_user_id'];
					var sd_desc = rowData['print_user_name'];

					var returnValue = new Array();
					returnValue[0] = sd_code;
					returnValue[1] = sd_desc;
					window.returnValue = returnValue;
					self.close();
			 },
             
    });
});
	$("#btnSearch").click(function(){
		fn_search();
	});
	
	$("#btnCancle").click(function(){
		self.close();
	});
	
	$("#userName").keydown(function (e) {
	   if (e.which == 13){
	   	   fn_search();
	   }
	});
	
	$("#deptName").keydown(function (e) {
	   if (e.which == 13){
	   	   fn_search();
	   }
	});
	
	function fn_search(){
		var userName = $("#userName").val();
		var deptName =$("#deptName").val();
		if((userName==null || userName=="") && (deptName==null || deptName=="") ){
			alert('검색조건을 입력하세요');
			return;
		}else{
			$("input[name=p_daoName]").val("TBC_ITEMTRANS");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("userSearchList");
			var sUrl = "standardInfoTransDbList.do";
			jQuery("#selectUserList").jqGrid('setGridParam',{url:sUrl,page:1,datatype: 'json',postData: $("#application_form").serialize()}).trigger("reloadGrid");
		}
	}
</script>
</body>
</html>