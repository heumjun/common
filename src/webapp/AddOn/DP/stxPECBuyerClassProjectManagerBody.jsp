<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "java.util.StringTokenizer" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%--========================== SCRIPT ======================================--%>

<%@page import="com.stx.common.interfaces.DBConnect"%>
<script language="JavaScript">
	function clearList()
	{
		document.projectReceiveListForm.drawingType.value = "";
		document.projectReceiveListForm.refType.value = "";
		document.projectReceiveListForm.workRank.value = "";
		document.projectReceiveListForm.mailList.value = "";
		document.projectReceiveListForm.position.value = "";
		document.projectReceiveListForm.companyName.value = "";
		document.projectReceiveListForm.address.value = "";
		document.projectReceiveListForm.faxNum.value = "";
		document.projectReceiveListForm.eMailAddr.value = "";
		document.projectReceiveListForm.phoneNum.value = "";
		document.projectReceiveListForm.mailListFlag.value = "";
		document.projectReceiveListForm.companyNameFlag.value = "";
		document.projectReceiveListForm.addressFlag.value = "";
		document.projectReceiveListForm.faxNumFlag.value = "";
		document.projectReceiveListForm.department.value = "";
		document.projectReceiveListForm.refBasis.value = "";
		
	}
	
	function saveList()
	{
		var project			= document.projectReceiveListForm.project.value;
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= document.projectReceiveListForm.drawingType.value;
		var refType 		= document.projectReceiveListForm.refType.value;
		var workRank 		= document.projectReceiveListForm.workRank.value;
		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		
		var mailList 		= document.projectReceiveListForm.mailList.value;
		var position 		= document.projectReceiveListForm.position.value;
		var companyName 	= document.projectReceiveListForm.companyName.value;
		var address 		= document.projectReceiveListForm.address.value;
		var faxNum 			= document.projectReceiveListForm.faxNum.value;
		var eMailAddr 		= document.projectReceiveListForm.eMailAddr.value;
		var phoneNum 		= document.projectReceiveListForm.phoneNum.value;
		var mailListFlag 	= document.projectReceiveListForm.mailListFlag.value;
		var companyNameFlag = document.projectReceiveListForm.companyNameFlag.value;
		var addressFlag 	= document.projectReceiveListForm.addressFlag.value;
		var faxNumFlag 		= document.projectReceiveListForm.faxNumFlag.value;
		var department 		= document.projectReceiveListForm.department.value;
		var refBasis 		= document.projectReceiveListForm.refBasis.value;
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "save");
		
	}
	
	function addList()
	{
		var project			= document.projectReceiveListForm.project.value;
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= document.projectReceiveListForm.drawingType.value;
		var refType 		= document.projectReceiveListForm.refType.value;
		var workRank 		= document.projectReceiveListForm.workRank.value;
		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		
		var mailList 		= document.projectReceiveListForm.mailList.value;
		var position 		= document.projectReceiveListForm.position.value;
		var companyName 	= document.projectReceiveListForm.companyName.value;
		var address 		= document.projectReceiveListForm.address.value;
		var faxNum 			= document.projectReceiveListForm.faxNum.value;
		var eMailAddr 		= document.projectReceiveListForm.eMailAddr.value;
		var phoneNum 		= document.projectReceiveListForm.phoneNum.value;
		var mailListFlag 	= document.projectReceiveListForm.mailListFlag.value;
		var companyNameFlag = document.projectReceiveListForm.companyNameFlag.value;
		var addressFlag 	= document.projectReceiveListForm.addressFlag.value;
		var faxNumFlag 		= document.projectReceiveListForm.faxNumFlag.value;
		var department 		= document.projectReceiveListForm.department.value;
		var refBasis 		= document.projectReceiveListForm.refBasis.value;
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "add");
	}
	
	function delList()
	{
		var project			= document.projectReceiveListForm.project.value;
		
		if(project == ""){
			alert("Please select project !");
			return;
		}
		
		var drawingType 	= document.projectReceiveListForm.drawingType.value;
		var refType 		= document.projectReceiveListForm.refType.value;
		var workRank 		= document.projectReceiveListForm.workRank.value;
		
		if(drawingType == ""){
			alert("도면 구분을 입력해 주십시오.");
			return;
		}
		if(refType == ""){
			alert("수신 구분을 입력해 주십시오.");
			return;
		}
		if(workRank == ""){
			alert("우선순위를 입력해 주십시오.");
			return;
		}
		
		var mailList 		= document.projectReceiveListForm.mailList.value;
		var position 		= document.projectReceiveListForm.position.value;
		var companyName 	= document.projectReceiveListForm.companyName.value;
		var address 		= document.projectReceiveListForm.address.value;
		var faxNum 			= document.projectReceiveListForm.faxNum.value;
		var eMailAddr 		= document.projectReceiveListForm.eMailAddr.value;
		var phoneNum 		= document.projectReceiveListForm.phoneNum.value;
		var mailListFlag 	= document.projectReceiveListForm.mailListFlag.value;
		var companyNameFlag = document.projectReceiveListForm.companyNameFlag.value;
		var addressFlag 	= document.projectReceiveListForm.addressFlag.value;
		var faxNumFlag 		= document.projectReceiveListForm.faxNumFlag.value;
		var department 		= document.projectReceiveListForm.department.value;
		var refBasis 		= document.projectReceiveListForm.refBasis.value;
		
		dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , "del");
	}
	
	var xmlHttp;
    function dataProcess(project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , processType) {
		if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassProjectManagerProcess.jsp"
                + "?project="+project
                + "&drawingType="+drawingType
                + "&refType="+refType
                + "&workRank="+workRank
                + "&mailList="+mailList
                + "&position="+position
                + "&companyName="+companyName
                + "&address="+address
                + "&faxNum="+faxNum.replace("+","%2B")
                + "&eMailAddr="+eMailAddr
                + "&phoneNum="+phoneNum.replace("+","%2B")
                + "&mailListFlag="+mailListFlag
                + "&companyNameFlag="+companyNameFlag
                + "&addressFlag="+addressFlag
                + "&faxNumFlag="+faxNumFlag
                + "&department="+department
                + "&refBasis="+refBasis
                + "&processType="+processType
                ;
        
        xmlHttp.open("GET", url, false);
        xmlHttp.onreadystatechange = callback;
        xmlHttp.send(null);
        
        var url2 = "stxPECBuyerClassProjectManagerBody.jsp?selectProject="+project;
        
        //document.projectReceiveListForm.action = fnEncode(url2);
		document.projectReceiveListForm.action = encodeURI(url2);
        document.projectReceiveListForm.submit();
    }
    
    function callback() {
    	if (xmlHttp.readyState == 4) {
        	if (xmlHttp.status == 200) {
        		//var result = xmlHttp.responseText;
	            //result = result.replace(/\s/g, ""); // 공백제거
	            //alert(result);
	            //setNames2(result);
	            
            } else{// if (xmlHttp.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
    
    function selectDrawing(count)
    {
    	document.projectReceiveListForm.drawingType.value 		= document.projectReceiveListForm.elements["drawingType"+count].value;
		document.projectReceiveListForm.refType.value 			= document.projectReceiveListForm.elements["receiveType"+count].value;
		document.projectReceiveListForm.workRank.value 			= document.projectReceiveListForm.elements["priority"+count].value;
		document.projectReceiveListForm.mailList.value 			= document.projectReceiveListForm.elements["receiver"+count].value;
		document.projectReceiveListForm.position.value 			= document.projectReceiveListForm.elements["position"+count].value;
		document.projectReceiveListForm.companyName.value 		= document.projectReceiveListForm.elements["company"+count].value;
		document.projectReceiveListForm.address.value 			= document.projectReceiveListForm.elements["address"+count].value;
		document.projectReceiveListForm.faxNum.value 			= document.projectReceiveListForm.elements["fax"+count].value;
		document.projectReceiveListForm.eMailAddr.value 		= document.projectReceiveListForm.elements["eMail"+count].value;
		document.projectReceiveListForm.phoneNum.value 			= document.projectReceiveListForm.elements["phone"+count].value;
		document.projectReceiveListForm.mailListFlag.value 		= document.projectReceiveListForm.elements["receiverFlag"+count].value;
		document.projectReceiveListForm.companyNameFlag.value 	= document.projectReceiveListForm.elements["companyFlag"+count].value;
		document.projectReceiveListForm.addressFlag.value 		= document.projectReceiveListForm.elements["addressFlag"+count].value;
		document.projectReceiveListForm.faxNumFlag.value 		= document.projectReceiveListForm.elements["faxFlag"+count].value;
		document.projectReceiveListForm.department.value 		= document.projectReceiveListForm.elements["department"+count].value;
		document.projectReceiveListForm.refBasis.value 			= document.projectReceiveListForm.elements["basis"+count].value;
    }
    
    function changeFlag(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "N")
    		obj.value = "Y";
    	else if(objValue == "Y")
    		obj.value = "N";
    }
    
    function changeDwgType(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "비도면")
    		obj.value = "도면";
    	else if(objValue == "도면")
    		obj.value = "비도면";
    }
    
    function changeRefType(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "참조")
    		obj.value = "수신";
    	else if(objValue == "수신")
    		obj.value = "참조";
    }
</script>

<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%
String selectProject = request.getParameter("selectProject")==null?"":request.getParameter("selectProject");
//String seriesFlag = request.getParameter("seriesFlag");
//String noSendFlag = request.getParameter("noSendFlag");
%>

<form name=projectReceiveListForm method="post" action="stxPECBuyerClassProjectManagerBody.jsp">
	<table>
		<tr>
			<!-- 하단 (수신처관리) 시작 -->
			<td style="border: #00bb00 1px solid;">
				<table>
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<font size=2>선주수신목록 (<input class="input_noBorder" style="width:40px;background-color:#D8D8D8;" value="<%=selectProject%>" name="project"/>)</font>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr align="right">
						<td>
							<table>
								<tr align="right">
									<td width="75" style="border: #000000 1px solid; color:#0000ff">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="추가" onclick="addList()"/>
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff">
										
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="CLEAR" onclick="clearList()"/>
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="저장" onclick="saveList()"/>
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="삭제" onclick="delList()"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table cellspacing="0" cellpadding="0" border="0" align="left">
								<tr>
									<td style="border: #000000 1px solid; color:#0000ff">
										구분
				                	</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										수신
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										우선순위
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										&nbsp;
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										수신자
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										직책
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										&nbsp;
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										회사명
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										&nbsp;
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										주소
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										&nbsp;
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										팩스
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										이메일
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										전화
									</td><td style="border: #000000 1px solid; color:#0000ff">
										해당부서
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										관련근거
									</td>
								</tr>
								<tr>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=4 name="drawingType" onclick="changeDwgType(this)">
					            	</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=2 name="refType" onclick="changeRefType(this)">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=6 name="workRank">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=2 name="mailListFlag" onclick="changeFlag(this)">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="mailList">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="position">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=2 name="companyNameFlag" onclick="changeFlag(this)">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=14 name="companyName">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=2 name="addressFlag" onclick="changeFlag(this)">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=14 name="address">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=2 name="faxNumFlag" onclick="changeFlag(this)">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="faxNum">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="eMailAddr">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="phoneNum">
									</td><td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="department">
									</td>
									<td style="border: #000000 1px solid; color:#0000ff">
										<input type="text" size=12 name="refBasis" >
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
					<tr>
					<tr>
						<td>
							<table cellspacing="0" cellpadding="0" border="0" align="left">
								
								<%
								if(selectProject!=null && !"null".equals(selectProject)){
									
									java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
									java.sql.Statement stmt = conn.createStatement();
									
									StringBuffer selectDataSQL = new StringBuffer();
									selectDataSQL.append("select * ");
									selectDataSQL.append("  from STX_OC_PROJECT_RECEIVE_LIST ");
									selectDataSQL.append(" where project = '"+selectProject+"' ");
									selectDataSQL.append(" order by PROJECT , DRAWING_TYPE , RECEIVE_TYPE , PRIORITY ");
									
									
									java.sql.ResultSet selectDataRset = stmt.executeQuery(selectDataSQL.toString());
									
									int count = 0 ;
									while(selectDataRset.next()){
										
										String projectNo 		= selectDataRset.getString(1)==null?"":selectDataRset.getString(1);
										String drawingType 		= selectDataRset.getString(2)==null?"":selectDataRset.getString(2);
										String receiveType		= selectDataRset.getString(3)==null?"":selectDataRset.getString(3);
										String priority			= selectDataRset.getString(4)==null?"":selectDataRset.getString(4);
										String receiver			= selectDataRset.getString(5)==null?"":selectDataRset.getString(5);
										String position			= selectDataRset.getString(6)==null?"":selectDataRset.getString(6);
										String company			= selectDataRset.getString(7)==null?"":selectDataRset.getString(7);
										String address			= selectDataRset.getString(8)==null?"":selectDataRset.getString(8);
										String fax				= selectDataRset.getString(9)==null?"":selectDataRset.getString(9);
										String eMail			= selectDataRset.getString(10)==null?"":selectDataRset.getString(10);
										String phone			= selectDataRset.getString(11)==null?"":selectDataRset.getString(11);
										String receiverFlag		= selectDataRset.getString(12)==null?"":selectDataRset.getString(12);
										String companyFlag		= selectDataRset.getString(13)==null?"":selectDataRset.getString(13);
										String addressFlag		= selectDataRset.getString(14)==null?"":selectDataRset.getString(14);
										String faxFlag			= selectDataRset.getString(15)==null?"":selectDataRset.getString(15);
										String department		= selectDataRset.getString(16)==null?"":selectDataRset.getString(16);
										String basis			= selectDataRset.getString(17)==null?"":selectDataRset.getString(17);
										
										if(count==0){
											%>
											<tr>
												<td style="border: #000000 1px solid; color:#0000ff">
													구분
							                    </td>
												<td style="border: #000000 1px solid; color:#0000ff">
													수신
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													우선순위
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													&nbsp;
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													수신자
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													직책
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													&nbsp;
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													회사명
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													&nbsp;
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													주소
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													&nbsp;
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													팩스
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													이메일
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													전화
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													해당부서
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													관련근거
												</td>
											</tr>
											<%
										}
										
										%>
										<tr>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=4 value="<%=drawingType%>" name="drawingType<%=count%>" onclick="selectDrawing('<%=count%>')">
						                    </td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=2 value="<%=receiveType%>" name="receiveType<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=6 value="<%=priority%>" name="priority<%=count%>">
											</td>											
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=2 value="<%=receiverFlag%>" name="receiverFlag<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=receiver%>" name="receiver<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=position%>" name="position<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=2 value="<%=companyFlag%>" name="companyFlag<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=14 value="<%=company%>" name="company<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=2 value="<%=addressFlag%>" name="addressFlag<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=14 value="<%=address%>" name="address<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=2 value="<%=faxFlag%>" name="faxFlag<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=fax%>" name="fax<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=eMail%>" name="eMail<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=phone%>" name="phone<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=department%>" name="department<%=count%>">
											</td>
											<td style="border: #000000 1px solid; color:#0000ff">
												<input type="text" size=12 value="<%=basis%>" name="basis<%=count%>">
											</td>
										</tr>
										<%
										count++;
									}
								}
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<!-- 상단 (호선관리) 끝 -->
		</tr>
	</table>
</form>
