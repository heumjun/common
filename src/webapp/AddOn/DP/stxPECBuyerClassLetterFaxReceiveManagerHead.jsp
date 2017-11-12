<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.StringTokenizer" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== SCRIPT ======================================--%>

<script language="JavaScript">
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
		var sURL = "stxPECBuyerClassLetterFaxReceiveManagerExcelUploadDialogFS.jsp";
		var property = "dialogWidth:1100px; dialogHeight:700px; status:no; help:no; center:yes; scroll:no";
		//showModalDialog(sURL, 700, 600);
		window.showModalDialog(sURL , window , property);
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
<%

%>
<form name=receiveManagerForm method="post" action="stxPECBuyerClassLetterFaxReceiveManagerBody.jsp">
	<table>
		<tr align="right">
			<td align="right">
				<table id="buttonTable">
					<tr align="right">
						<td id="createDocTD" width="75" style="border: #000000 1px solid; color:#0000ff">
							<input type="button" style="width:75px;background-color:#D8D8D8;" value="EXCEL" onclick="excelUpload()"/>
						</td>
						<td id="docSaveTD" width="75" style="border: #000000 1px solid; color:#0000ff">
							<input type="button" style="width:75px;background-color:#D8D8D8;" value="SAVE" onclick="docSave()"/>
						</td>
						<td id="closeTD" width="75" style="border: #000000 1px solid; color:#0000ff">
							<input type="button" style="width:75px;background-color:#D8D8D8;" value="CLOSE" onclick="closeDialog()"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-- 상단 수신 문서 등록 시작 -->
		<tr>
			<td style="border: #00bb00 1px solid;">
				<table  cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table>
								<tr>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=6 value="호선">
					            	</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=8 value="선주/선급">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=8 value="수신/발신">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=10 value="수신일자">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=25 value="Ref. No.">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=25 value="Rev. No.">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=41 value="제목">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=20 value="수신부서">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=20 value="참조부서">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8BFD8; color:#000000" size=8 value="문서종류">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<div id="dataDIV" STYLE="width:100%; height:345; overflow:scroll; overflow-x:hidden;"> 
								<table>
									<%
									int count = 0;
									for(int i=0 ; i<30 ; i++){ 
									%>
										<tr>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=6 value="" name="project<%=i%>">
								           	</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=8 value="" name="ownerClassType<%=i%>" onfocus="changeOwnerClassType(this)">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=8 value="" name="sendReceiveType<%=i%>" onfocus="changeSendReceiveType(this)">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=10 value="" name="sendReceiveDate<%=i%>" onfocus="selectReceiveDate(this)">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=25 value="" name="refNo<%=i%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=25 value="" name="revNo<%=i%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=41 value="" name="subject<%=i%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=20 value="" name="sendReceiveDept<%=i%>" onclick="selectDepartment('sendReceiveDept<%=i%>','refDept<%=i%>')">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=20 value="" name="refDept<%=i%>" onclick="selectDepartment('sendReceiveDept<%=i%>','refDept<%=i%>')">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=8 value="" name="docType<%=i%>">
											</td>
										</tr>
									<%
										count++;
									} 
									%>
									<input type="hidden" name="dataCount" value="<%=count%>">
								</table>
							</div>		
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-- 상단 수신 문서 등록 끝 -->
	</table>
</form>
