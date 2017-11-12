<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자 검색</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv">
	<form id="application_form" name="application_form">
	<input type="hidden" name = "userId" id = "userId" value="<c:out value="${UserId}" />" />
	
		<div class="topMain" style="margin: 0px;line-height: 45px;">
			<div class="conSearch">
				<span class="pop_tit">구분</span>
				<select id = "inout">
					<option value="in">사내</option>
					<option value="out">사외</option>
				</select>
				<span class="pop_tit">
				사용자명
				</span>
				<input type="text" name="userName" id="userName" value="" style="width: 50px;"/>
				<span class="pop_tit">부서명</span>
				<input type="text" name="deptName" id="deptName" value="" style="width: 100px;"/>
			</div>
			<div class="button">
				<input type="button" name="btnSearch" id="btnSearch" value="조회" class="btn_blue"/>
				<input type="button" name="btnAdd" id="btnAdd" value="추가" class="btn_blue" />
				<input type="button" name="btnCancle" id="btnCancle" value="취소" class="btn_blue" />
				
<!-- 				<input type="button" name="btnDel" id="btnDel" value="Group 삭제" class="btn_blue" /> -->
<!-- 				<input type="button" name="btnAdd" id="btnAdd" value="추가" class="btn_blue" /> -->
<!-- 				<input type="button" name="btnCancle" id="btnCancle" value="취소" class="btn_blue" /> -->
			</div>
		</div>
		<div class="content">
			<table id="selectUserList"></table>
		</div>
	
	
	
	
	
	
	
	
	
	
	
<!-- 	<div> -->
<!-- 		구분 -->
<!-- 		<span style="margin-left:10px; "> -->
<!-- 		<select id = "inout"> -->
<!-- 			<option value="in">사내</option> -->
<!-- 			<option value="out">사외</option> -->
<!-- 		</select> -->
<!-- 		</span> -->
<!-- 		<span style="margin-left:10px; "> -->
<!-- 		사용자명 -->
<!-- 		</span> -->
<!-- 		<input type="text" name="userName" id="userName" value="" style="width: 50px;"/> -->
		
<!-- 		부서명 -->
<!-- 		<input type="text" name="deptName" id="deptName" value="" style="width: 100px;"/> -->
		
<!-- 		<input type="button" name="btnSearch" id="btnSearch" value="조회" style="margin-left: 50px;"/> -->
<!-- 		<input type="button" name="btnAdd" id="btnAdd" value="추가" /> -->
<!-- 		<input type="button" name="btnCancle" id="btnCancle" value="취소" /> -->
<!-- 	</div> -->
<!-- 	<br/> -->
<!-- 	<div> -->
<!-- 		<table id="selectUserList"></table> -->
<!-- 	</div> -->
		
	</form>
</div>
<script type="text/javascript">

$(document).ready(function(){
	$("#selectUserList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             postData : $("#application_form").serialize(),
             editUrl: 'clientArray',
             colNames:['구분','사번','이름','부서','인사부서','이메일','dept_id'],
                colModel:[
                    {name:'user_type',index:'user_type'				,width: 50	,align:'center' },
                    {name:'print_user_id',index:'print_user_id' 	,width: 60	,align:'center' },                    
                    {name:'print_user_name',index:'print_user_name'	,width: 50  ,align:'center' },
                    {name:'print_dept_name',index:'print_dept_name'	,width: 100 },
                    {name:'insa_dept_name',index:'insa_dept_name'	,width: 150 },
                    {name:'email',index:'email'						,width:	150 },
                    {name:'print_dept_id',index:'print_dept_id',hidden:true}
                ],
             multiselect: true,
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 460,
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
    });
});
	$("#btnSearch").click(function(){
		fn_search();
	});
	$("#btnAdd").click(function(){
		var selrow = $('#selectUserList').jqGrid('getGridParam', 'selarrrow');
		if(selrow.length==0){
			alert('대상을 선택해 주십시요');
			return;
		}
		for(var i=0;i<selrow.length;i++){
			var selDatas = $("#selectUserList").jqGrid('getRowData', selrow[i]);
			opener.insertRow(selDatas);
		}
		$('#selectUserList').resetSelection();
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
		var inout = $("#inout").val();
		if((userName==null || userName=="") && (deptName==null || deptName=="") ){
			alert('검색조건을 입력하세요');
			return;
		}else{
			var sUrl = "selectERPUserInOutUserList.do?inout="+inout;
			jQuery("#selectUserList").jqGrid('setGridParam',{url:sUrl,page:1,datatype: 'json',postData: $("#application_form").serialize()}).trigger("reloadGrid");
		}
	}
</script>
</body>
</html>