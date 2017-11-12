<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.StringTokenizer" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>

<%--========================== JSP =========================================--%>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<%--========================== SCRIPT ======================================--%>
<script language="JavaScript">
	
	function doneMethod() {		
		parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
		parent.window.close();
	}

	function cancelMethod(){
		parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
		parent.window.close();
	}
	var xmlHttp;
	
	function closeDialog()
	{
		top.parent.window.close();
	}
	
	function docSave()
	{
		var dataCount = document.receiveManagerForm.dataCount.value;
		
		//alert(dataCount);
		
		if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    else if (window.XMLHttpRequest) {
	      	xmlHttp = new XMLHttpRequest();     
	    }
		
		for(var i=0 ; i<dataCount ; i++){
			var tempProject 			= document.receiveManagerForm.elements["project"+i].value;
			var tempOwnerClassType 		= document.receiveManagerForm.elements["ownerClassType"+i].value;
			var tempSendReceiveType 	= document.receiveManagerForm.elements["sendReceiveType"+i].value;
			var tempSendReceiveDate 	= document.receiveManagerForm.elements["sendReceiveDate"+i].value;
			var tempRefNo 				= document.receiveManagerForm.elements["refNo"+i].value;
			var tempRevNo 				= document.receiveManagerForm.elements["revNo"+i].value;
			var tempSubject 			= document.receiveManagerForm.elements["subject"+i].value;
			var tempSendReceiveDept 	= document.receiveManagerForm.elements["sendReceiveDept"+i].value;
			var tempRefDept 			= document.receiveManagerForm.elements["refDept"+i].value;
			var tempDocType 			= document.receiveManagerForm.elements["docType"+i].value;
			
			if(tempProject == "" 
			 &&tempOwnerClassType == "" 	
			 &&tempSendReceiveType == ""
			 &&tempSendReceiveDate == ""
			 //&&tempRefNo == ""
			 &&tempRevNo == ""
			 &&tempSubject == ""
			 &&tempSendReceiveDept == ""
			 //&&tempRefDept == ""
			 &&tempDocType == ""){
				continue;
			}
			
			//alert(tempProject);
			
	        var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
	        		+ "?project=" + tempProject
					+ "&onwerClassType=" + tempOwnerClassType
					+ "&sendReceiveType=" + tempSendReceiveType
					+ "&docType=" + tempDocType
					+ "&refNo=" + tempRefNo.replace("&","%26")
					+ "&revNo=" + tempRevNo.replace("&","%26")
					+ "&subject=" + tempSubject
					+ "&sender=" 
					+ "&sendReceiveDate=" + tempSendReceiveDate
					+ "&sendReceiveDept=" + tempSendReceiveDept
					+ "&refDept=" + tempRefDept
					+ "&keyword="
					+ "&viewAccess="
					+ "&mode=receivemanagerdoc"
					;
	        
	        xmlHttp.open("GET", url, false);
	        xmlHttp.onreadystatechange = callbackDocSave;
	        xmlHttp.send(null);
		}
		
		alert("저장되었습니다.");
	}
	
	function callbackDocSave() {
    	if (xmlHttp.readyState == 4) {
        	if (xmlHttp.status == 200) {
        		var result = xmlHttp.responseText;
        		
	            //alert(result);
	            //setDocumentData(result);
            } else{// if (xmlHttp.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
	
	function excelUpload()
	{
		var sURL = "/buyerClassLetterFaxReceiveExcelUpload.do";
		var property = "dialogWidth:1100px; dialogHeight:700px; status:no; help:no; center:yes; scroll:no";
		//showModalDialog(sURL, 700, 600);
		/* window.showModalDialog(sURL , window , property); */
		window.open(sURL,"",property);
	}
	
	function changeOwnerClassType(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "owner")
    		obj.value = "class";
    	else if(objValue == "class")
    		obj.value = "owner";
    }
    
    function changeSendReceiveType(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "send")
    		obj.value = "receive";
    	else if(objValue == "receive")
    		obj.value = "send";
    }
    
    function selectReceiveDate(obj)
    {
    	var todayDate = new Date();
		
		var todayYear = todayDate.getYear();
		var todayMonth = todayDate.getMonth()+1;
		var todayDay = todayDate.getDate();
		
		if((todayMonth + "").length < 2){
    		todayMonth = "0" + todayMonth;
		}  
   		if((todayDay + "").length < 2){
	    	todayDay = "0" + todayDay;
   		}
   				
		var today = todayYear+"-"+todayMonth+"-"+todayDay;
		
		obj.value = today;
    }
    
    function selectDepartment(field1 , field2)
    {
    	//////var url = "stxPECBuyerClassLetterFaxDepartmentSelect.jsp?formName=receiveManagerForm&fieldName="+field1+"&fieldName2="+field2;
    	/////showModalDialog(url,670,300);
    	
	    var url = "stxPECBuyerClassLetterFaxDepartmentSelect.jsp?formName=receiveManagerForm&fieldName="+field1+"&fieldName2="+field2;
	
	    var nwidth = 700;
	    var nheight = 500;
	    var LeftPosition = (screen.availWidth-nwidth)/2;
	    var TopPosition = (screen.availHeight-nheight)/2;
	
	    var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;
	
	    window.open(url,"",sProperties);    	
    }
	
</script>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<div id="mainDiv" class="mainDiv">
<div class="subtitle">
	수신 문서등록
	<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
</div>
<form name=receiveManagerForm method="post" action="stxPECBuyerClassLetterFaxReceiveManagerBody.jsp">
	
	<table class="searchArea conSearch">
		<tr>
			<td>
				<div  id="buttonTable" class="button endbox">
					<input type="button" class="btn_blue" value="EXCEL" onclick="excelUpload()"/>
					<input type="button" class="btn_blue" value="SAVE" onclick="docSave()"/>
					<input type="button" class="btn_blue" value="CLOSE" onclick="closeDialog()"/>
				</div>
			</td>
		</tr>
	</table>
	<div style="border: #00bb00 1px solid;padding:5px;margin-top:10px;">
		<div id="list_head" style="overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<tr>
					<th width="8%">호선</th>
					<th width="8%">선주<br>선급</th>
					<th width="8%">수신<br>발신</th>
					<th width="8%">수신<br>일자</th>
					<th width="10%">Ref. No.</th>
					<th width="10%">Rev. No.</th>
					<th width="20%">제목</th>
					<th width="10%">수신부서</th>
					<th width="10%">참조부서</th>
					<th width="8%">문서<br>종류</th>
				</tr>
			</table>
		</div>
		<div id="list_body" style="height:600px;overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<%
			int count = 0;
			for(int i=0 ; i<30 ; i++){ 
			%>
				<tr>
					<td width="8%">
						<input  style="border:0;width:100%" value="" name="project<%=i%>">
		           	</td>
					<td width="8%">
						<input  style="border:0;width:100%" value="" name="ownerClassType<%=i%>" onfocus="changeOwnerClassType(this)">
					</td>
					<td width="8%">
						<input  style="border:0;width:100%" value="" name="sendReceiveType<%=i%>" onfocus="changeSendReceiveType(this)">
					</td>
					<td width="8%">
						<input  style="border:0;width:100%" value="" name="sendReceiveDate<%=i%>" onfocus="selectReceiveDate(this)">
					</td>
					<td width="10%">
						<input  style="border:0;width:100%" value="" name="refNo<%=i%>">
					</td>
					<td width="10%">
						<input  style="border:0;width:100%" value="" name="revNo<%=i%>">
					</td>
					<td width="20%">
						<input  style="border:0;width:100%" value="" name="subject<%=i%>">
					</td>
					<td width="10%">
						<input  style="border:0;width:100%" value="" name="sendReceiveDept<%=i%>" onclick="selectDepartment('sendReceiveDept<%=i%>','refDept<%=i%>')">
					</td>
					<td width="10%">
						<input  style="border:0;width:100%" value="" name="refDept<%=i%>" onclick="selectDepartment('sendReceiveDept<%=i%>','refDept<%=i%>')">
					</td>
					<td width="8%">
						<input  style="border:0;width:100%" value="" name="docType<%=i%>">
					</td>
				</tr>
			<%
				count++;
			} 
			%>
			<input type="hidden" name="dataCount" value="<%=count%>">
			</table>
		</div>
	</div>
</form>
</div>
</html>