<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Excel Import</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.popMainDiv{margin:10px; }
	.popMainDiv .WarningArea{width:490px;  border:1px solid #ccc; padding:8px; margin-bottom:0px; }
	.popMainDiv .WarningArea .tit{font-size:12pt; margin-bottom:6px; color:red; font-weight:bold;}	
</style>
</head>
<body>
<form name="frmDocumentAdd"  method="post">
<input type="hidden" id="p_seq" name="p_seq" value="${p_seq}" />


	<div class="subtitle">Notice File Upload</div>	
	<%-- <div class="popMainDiv">
		<div class="WarningArea">
			<div class="tit" >※ Warning</div>
			<c:if test="${p_option == 'MANUAL'}">
			- 업로드 가능한 파일의 확장자는 <b><u style="font-size: 12px; color: red;">.pdf</u>입니다.<br />
			</c:if>
			<!-- - 업로드 파일의 <b><u>DRM을 꼭 해제한 후</u></b> 업로드 바랍니다. -->
		</div>
	</div> --%>
	<div class = "topMain" style="margin-top: 0px;">
		<table class="searchArea2 conSearch">
			<col width="460"/>
				<tr>
					<th class="only_eco">첨부파일</th>
					<td>
						<input type="file" value="Import" name="fileName" id="fileExl" size="51"/>
					</td>
				</tr>
		</table>
		<br />
		<div class="button">
			<input type="button" value="저장" id="btnExlUp" class="btn_blue" />
			<input type="button" value="닫기" id="btnClose" class="btn_blue"/>
		</div>
	</div>

</form>
<script type="text/javascript" >
$(document).ready(function(){
	//Close 버튼 클릭.
	$("#btnClose").click(function(){
		self.close();
	});
	
	$("#btnExlUp").click(function(){
		
        var frm = document.frmDocumentAdd;
        if(confirm("저장하시겠습니까?"))
        {
        	var file = $("#fileExl").val().toLowerCase();
        	if(!isFile(file)){
				return false;	
			}
        	
            frm.encoding = "multipart/form-data";
            frm.action = "NoticeAddSave.do?p_seq"+$("#p_seq").val();
            
            var file = $("#fileExl").val().toLowerCase();
            frm.submit();    
        }
        
        
//         window.opener.fn_search();
//         window.opener.fn_detailSearch($("#p_pgm_id").val());

        
    });
});	

//파일 유무 체크
var isFile = function(file){
	var args = window.dialogArguments;
	if(file == "" ){
		alert("Enter a file or Check the file format");
		return false;
	}else{
		return true;
	}
}

</script>
</body>
</html>