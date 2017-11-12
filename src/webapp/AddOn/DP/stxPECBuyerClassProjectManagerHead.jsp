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


	function searchProject()
    {
    	var project = document.projectManagerForm.project.value;
    	var docProject = document.projectManagerForm.docProject.value;
    	
    	var series = document.projectManagerForm.includeSeries.checked;
    	var noSend = document.projectManagerForm.noSendProject.value;
    	var noDoc = document.projectManagerForm.noDocProject.checked;
    	
        var url = "stxPECBuyerClassProjectManagerHead.jsp"
        		+ "?selectProject=" + project 
        		+ "&selectDocProject=" + docProject 
        		+ "&seriesFlag=" + series 
        		+ "&noSendFlag=" + noSend 
        		+ "&noDocProjectFlag=" + noDoc;
        
        document.projectManagerForm.action = encodeURI(url);
        //document.projectManagerForm.action = fnEncode(url);
        document.projectManagerForm.submit(); 
        return;
    }
    
    function saveProject()
    {
    	var projectCount = document.projectManagerForm.projectCount.value;
    	
    	for(var i=0 ; i<projectCount ; i++){
    		var tempProjectNo			= document.projectManagerForm.elements["projectNo"+i].value;
    		var tempDocProjectNo		= document.projectManagerForm.elements["docProjectNo"+i].value;
    		var tempSendYN 				= document.projectManagerForm.elements["sendYN"+i].value;
    		var tempOwnerSendCount 		= document.projectManagerForm.elements["ownerSendCount"+i].value;
    		var tempOwnerReturnCount 	= document.projectManagerForm.elements["ownerReturnCount"+i].value;
    		var tempClassSendCount 		= document.projectManagerForm.elements["classSendCount"+i].value;
    		var tempClassReturnCount 	= document.projectManagerForm.elements["classReturnCount"+i].value;
    		
			updateRowData(tempProjectNo , tempDocProjectNo , tempSendYN , tempOwnerSendCount , tempOwnerReturnCount , tempClassSendCount , tempClassReturnCount);
    	}
    	
    	searchProject();
    }
    var xmlHttp;
    function updateRowData(tempProjectNo , tempDocProjectNo , tempSendYN , tempOwnerSendCount , tempOwnerReturnCount , tempClassSendCount , tempClassReturnCount) {
		if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassProjectUpdateProcess.jsp"
        		+ "?projectNo="+tempProjectNo
        		+ "&docProjectNo="+tempDocProjectNo
        		+ "&sendYN="+tempSendYN
        		+ "&ownerSendCount="+tempOwnerSendCount
        		+ "&ownerReturnCount="+tempOwnerReturnCount
        		+ "&classSendCount="+tempClassSendCount
        		+ "&classReturnCount="+tempClassReturnCount
        		;
        
        xmlHttp.open("GET", url, false); 
        xmlHttp.onreadystatechange = callback;
        xmlHttp.send(null);
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
    function selectProject(obj)
    {	
    	var selectProject = obj.value;
    
    	var url = "stxPECBuyerClassProjectManagerBody.jsp?selectProject="+selectProject;
        
        //parent.frames[1].document.projectReceiveListForm.action = fnEncode(url);
        parent.frames[1].document.projectReceiveListForm.action = encodeURI(url);
        parent.frames[1].document.projectReceiveListForm.submit();
    }
    
    function closeDialog(){
    	top.parent.window.close();
    }
    
    function changeFlag(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "N")
    		obj.value = "Y";
    	else if(objValue == "Y")
    		obj.value = "N";
    }
</script>

<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<%
String selectProject 	= request.getParameter("selectProject");
String selectDocProject = request.getParameter("selectDocProject");
String seriesFlag 		= request.getParameter("seriesFlag");
String noDocProjectFlag = request.getParameter("noDocProjectFlag");
String noSendFlag 		= request.getParameter("noSendFlag");

if(seriesFlag==null || "null".equals(seriesFlag))
	seriesFlag = "true";

%>
<form name=projectManagerForm method="post" action="stxPECBuyerClassProjectManagerHead.jsp">
	<table>
		<tr>
			<td>
				호선 관리
			</td>
		</tr>
		<tr>
			<!-- 상단 (호선관리) 시작 -->
			<td style="border: #00bb00 1px solid;">
				<table>
					<tr>
						<td>
							<table>
								<tr>
									<td>
										대표호선
										<input type="text" name="project" size="5" value="<%=selectProject!=null?selectProject:""%>">
									</td>
									<td>
										문서호선
										<input type="text" name="docProject" size="5" value="<%=selectDocProject!=null?selectDocProject:""%>">
									</td>
									<td>
										<input type="checkbox" name="includeSeries" <%="true".equals(seriesFlag)?"checked=\"checked\"":""%>>시리즈선 포함&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="noDocProject" <%="true".equals(noDocProjectFlag)?"checked=\"checked\"":""%>>문서호선 미정호선&nbsp;&nbsp;&nbsp;
										SEND&nbsp;
										<select name="noSendProject">
											<option value="ALL">
												ALL
											</option>
											<option value="Y">
												Y
											</option>
											<option value="N">
												N
											</option>
										</select>
									</td>
									<td>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff" align="right">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="조회" onclick="searchProject()"/>
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff" align="right">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="저장" onclick="saveProject()"/>
									</td>
									<td width="75" style="border: #000000 1px solid; color:#0000ff" align="right">
										<input type="button" style="width:75px;background-color:#D8D8D8;" value="CLOSE" onclick="closeDialog()"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="호선">
					                            </td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="대표호선">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="문서호선">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=3 value="차수">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=3 value="선종">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="선형">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="도크번호">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=14 value="선주">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=4 value="선급">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="계약일">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="DS">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="SC">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="KL">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="LC">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=10 value="DL">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=4 value="SEND">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="선주발송">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="RETURN">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="선급발송">
												</td>
												<td style="border: #000000 1px solid; color:#0000ff">
													<input class="input_noBorder" style="background-color:#D8D8D8; color:#0000ff" size=7 value="RETURN">
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<div STYLE="width:100%; height:300; overflow:scroll; overflow-x:hidden;"> 
										<table cellpadding="0" cellspacing="0" border="0">
											<%
											java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
											java.sql.Statement stmt = conn.createStatement();
											
											StringBuffer selectDateSQL = new StringBuffer();
											selectDateSQL.append("select lpn.PROJECTNO ");
											selectDateSQL.append("     , lpn.DWGSERIESPROJECTNO ");
											selectDateSQL.append("     , lpn.DWGSERIESSERIALNO ");
											selectDateSQL.append("     , lpn.SHIPTYPE ");
											selectDateSQL.append("     , lpn.SHIPSIZE ");
											selectDateSQL.append("     , lpn.DOCKNO ");
											selectDateSQL.append("     , lpn.OWNER ");
											selectDateSQL.append("     , lpn.CLASS ");
											selectDateSQL.append("     , TO_CHAR(lpn.CONTRACTDATE, 'YYYY-MM-DD') ");
											selectDateSQL.append("     , TO_CHAR(lpn.DWGSC, 'YYYY-MM-DD') ");
											selectDateSQL.append("     , TO_CHAR(lpn.SC, 'YYYY-MM-DD') ");
											selectDateSQL.append("     , TO_CHAR(lpn.KL, 'YYYY-MM-DD') ");
											selectDateSQL.append("     , TO_CHAR(lpn.LC, 'YYYY-MM-DD') ");
											selectDateSQL.append("     , TO_CHAR(lpn.DL, 'YYYY-MM-DD') ");
											selectDateSQL.append("     , sopsn.doc_project ");
											selectDateSQL.append("     , sopsn.send_flag ");
											selectDateSQL.append("     , sopsn.owner_send_number ");
											selectDateSQL.append("     , sopsn.owner_return_number ");
											selectDateSQL.append("     , sopsn.class_send_number ");
											selectDateSQL.append("     , sopsn.class_return_number ");
											selectDateSQL.append("  from lpm_newproject lpn ");
											selectDateSQL.append("     , stx_oc_project_send_number sopsn ");
											selectDateSQL.append(" where lpn.caseno = '1' ");											
											if(selectProject!=null && !"".equals(selectProject) && !"null".equals(selectProject)){
												if("true".equals(seriesFlag)){
													selectDateSQL.append("   and lpn.DWGSERIESPROJECTNO = (SELECT DWGSERIESPROJECTNO ");
													selectDateSQL.append(" 									 FROM LPM_NEWPROJECT a ");
													selectDateSQL.append(" 							   		WHERE a.CASENO = '1' ");
													selectDateSQL.append(" 								 	  AND a.projectno = '"+selectProject+"') ");
												}else{
													selectDateSQL.append("   and lpn.projectno = '"+selectProject+"' ");
												}
											}
											if(selectDocProject!=null && !"".equals(selectDocProject) && !"null".equals(selectDocProject)){
												selectDateSQL.append("   and sopsn.doc_project = '"+selectDocProject+"' ");
											}
											
											selectDateSQL.append("   and lpn.projectno = sopsn.project(+) ");
											
											if(!"ALL".equals(noSendFlag)){
												if("N".equals(noSendFlag))
													selectDateSQL.append("   and (sopsn.send_flag = 'N' or sopsn.send_flag is null)");
												if("Y".equals(noSendFlag))
													selectDateSQL.append("   and sopsn.send_flag = 'Y' ");
											}
											
											if("true".equals(noDocProjectFlag)){
												selectDateSQL.append("   and (sopsn.doc_project is null)");
											}
											
											java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
											
											int count = 0 ;
											while(selectDateRset.next()){
												
												String projectNo 		= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
												String masterProjectNo 	= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
												String serialNo			= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
												String shipType			= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
												String shipSize			= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
												String dockNo			= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
												String ownerCode		= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
												String classCode		= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
												
												String ct				= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
												String ds				= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
												String sc				= selectDateRset.getString(11)==null?"":selectDateRset.getString(11);
												String kl				= selectDateRset.getString(12)==null?"":selectDateRset.getString(12);
												String lc				= selectDateRset.getString(13)==null?"":selectDateRset.getString(13);
												String dl				= selectDateRset.getString(14)==null?"":selectDateRset.getString(14);
												
												String docProject		= selectDateRset.getString(15)==null?"":selectDateRset.getString(15);
												String sendFlag			= selectDateRset.getString(16)==null?"":selectDateRset.getString(16);
												String ownerSend		= selectDateRset.getString(17)==null?"":selectDateRset.getString(17);
												String ownerReturn		= selectDateRset.getString(18)==null?"":selectDateRset.getString(18);
												String classSend		= selectDateRset.getString(19)==null?"":selectDateRset.getString(19);
												String classReturn		= selectDateRset.getString(20)==null?"":selectDateRset.getString(20);
												
												%>
												<tr>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=7 name="projectNo<%=count%>" value="<%=projectNo%>" onclick="selectProject(this)">
					                                </td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=7 value="<%=masterProjectNo%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#FFFFFF;" size=7 value="<%=docProject%>" name="docProjectNo<%=count%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=3 value="<%=serialNo%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=3 value="<%=shipType%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=shipSize%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=dockNo%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=14 value="<%=ownerCode%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=4 value="<%=classCode%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=ct%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=ds%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=sc%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=kl%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=lc%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#D8D8D8;" size=10 value="<%=dl%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#FFFFFF;" name="sendYN<%=count%>" size=4 value="<%=sendFlag%>" onclick="changeFlag(this)">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#FFFFFF;" name="ownerSendCount<%=count%>" size=7 value="<%=ownerSend%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#FFFFFF;" name="ownerReturnCount<%=count%>" size=7 value="<%=ownerReturn%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#FFFFFF;" name="classSendCount<%=count%>" size=7 value="<%=classSend%>">
													</td>
													<td style="border: #000000 1px solid; color:#0000ff">
														<input class="input_noBorder" style="background-color:#FFFFFF;" name="classReturnCount<%=count%>" size=7 value="<%=classReturn%>">
													</td>
													
												</tr>
												<%
												count++;
											}
											%>
											
										</table>
										</div>
										<input type="hidden" name="projectCount" value="<%=count%>">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<!-- 상단 (호선관리) 끝 -->
		</tr>
	</table>
</form>


