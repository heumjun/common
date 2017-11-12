<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%--========================== PAGE DIRECTIVES START =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "java.util.StringTokenizer" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<%--========================== PAGE DIRECTIVES END   =============================--%>
<%
	String selectProject 	= request.getParameter("selectProject");
	String selectDocProject = request.getParameter("selectDocProject");
	String seriesFlag 		= request.getParameter("seriesFlag");
	String noDocProjectFlag = request.getParameter("noDocProjectFlag");
	String noSendFlag 		= request.getParameter("noSendFlag");
	if(seriesFlag==null || "null".equals(seriesFlag))
		seriesFlag = "true";
	
	%>
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

	function searchProject()
    {
    	var project = document.projectManagerForm.project.value;
    	var docProject = document.projectManagerForm.docProject.value;
    	
    	var series = document.projectManagerForm.includeSeries.checked;
    	var noSend = document.projectManagerForm.noSendProject.value;
    	var noDoc = document.projectManagerForm.noDocProject.checked;
    	
        var url = "buyerClassProjectMgnt.do"
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
	var projectCount;
    function saveProject()
    {
    	projectCount = document.projectManagerForm.projectCount.value;
    	
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
    	
    	
    }
    var xmlHttp;
    var resultCnt = 0;
    function updateRowData(tempProjectNo , tempDocProjectNo , tempSendYN , tempOwnerSendCount , tempOwnerReturnCount , tempClassSendCount , tempClassReturnCount) {
		/* if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp = new XMLHttpRequest();     
        } */
        var url = "buyerClassProjectUpdateProcess.do"
        		+ "?projectNo="+tempProjectNo
        		+ "&docProjectNo="+tempDocProjectNo
        		+ "&sendYN="+tempSendYN
        		+ "&ownerSendCount="+tempOwnerSendCount
        		+ "&ownerReturnCount="+tempOwnerReturnCount
        		+ "&classSendCount="+tempClassSendCount
        		+ "&classReturnCount="+tempClassReturnCount
        		;
        $.post( url, "", function( data ) {
        	resultCnt++;
        	if(projectCount == resultCnt) {
        		alert(data.resultMsg);
        		searchProject();
        	}
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        /* xmlHttp.open("GET", url, false); 
        xmlHttp.onreadystatechange = callback;
        xmlHttp.send(null); */
    }
    
    /* function callback() {
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
    } */
    function selectProject(obj)
    {	
    	var selectProject = obj.value;
    
    	var url = "buyerClassProjectMgntBody.do?selectProject="+selectProject;
    	$("#buyerClassProjectMgntBody").attr("src",url);
        //parent.frames[1].document.projectReceiveListForm.action = fnEncode(url);
        //parent.frames[1].document.projectReceiveListForm.action = encodeURI(url);
        //parent.frames[1].document.projectReceiveListForm.submit();
    }
    
    /* function closeDialog(){
    	top.parent.window.close();
    } */
    
    function changeFlag(obj)
    {
    	var objValue = obj.value;
    	
    	if(objValue == "" || objValue == "N")
    		obj.value = "Y";
    	else if(objValue == "Y")
    		obj.value = "N";
    }
    /* var lodingBox;
    $(function() {
    	lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );	
    });
    $(document).ready(function() {
    	lodingBox.remove();
		
	}); */
    
	$(function() {
		$(window).bind('resize', function() {
			$('#list_body').css('height', $(window).height()-400);
		}).trigger('resize');
		
	});
</script>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<div id="mainDiv" class="mainDiv">
<form name=projectManagerForm method="post" action="">
	<div class="subtitle">
		호선 관리
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<table class="searchArea conSearch">
		<col width="100">
		<col width="140">
		<col width="100">
		<col width="140">
		<col width="310">
		<col width="*">
		<tr>
			<th>대표호선</th>
			<td>
				<input type="text" name="project" size="5" value="<%=selectProject!=null?selectProject:""%>">
			</td>
			<th>문서호선</th>
			<td>
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
				<div  id="buttonTable" class="button endbox">
					<input type="button" class="btn_blue" value="조회" onclick="searchProject()"/>
					<input type="button" class="btn_blue" value="저장" onclick="saveProject()"/>
				</div>
			</td>
		</tr>
	</table>
	<div style="border: #00bb00 1px solid;padding:5px;margin-top:10px;">
		<div id="list_head" style="overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<tr>
					<th width="5%">호선</th>
					<th width="5%">대표호선</th>
					<th width="5%">문서호선</th>
					<th width="3%">차수</th>
					<th width="3%">선종</th>
					<th width="5%">선형</th>
					<th width="7%">도크번호</th>
					<th width="7%">선주</th>
					<th width="5%">선급</th>
					<th width="5%">계약일</th>
					<th width="5%">DS</th>
					<th width="5%">SC</th>
					<th width="5%">KL</th>
					<th width="5%">LC</th>
					<th width="5%">DL</th>
					<th width="5%">SEND</th>
					<th width="5%">선주발송</th>
					<th width="5%">RETURN</th>
					<th width="5%">선급발송</th>
					<th width="5%">RETURN</th>
				</tr>
			</table>
		</div>
		<div id="list_body" style="height:500px;overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<%
				
				int count = 0 ;
				if(request.getParameter("menu_id") == null) {
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
							<td width="5%">
								<input type="text" style="color:blue;" size=7 name="projectNo<%=count%>" value="<%=projectNo%>" onclick="selectProject(this)">
	                              </td>
							<td width="5%">
								<input class="input_noBorder" style="" size=7 value="<%=masterProjectNo%>">
							</td>
							<td width="5%">
								<input  type="text" style="" size=7 value="<%=docProject%>" name="docProjectNo<%=count%>">
							</td>
							<td width="3%">
								<input class="input_noBorder" style="" size=3 value="<%=serialNo%>">
							</td>
							<td width="3%">
								<input class="input_noBorder" style="" size=3 value="<%=shipType%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=shipSize%>">
							</td>
							<td width="7%">
								<input class="input_noBorder" style="" size=10 value="<%=dockNo%>">
							</td>
							<td width="7%">
								<input class="input_noBorder" style="" size=14 value="<%=ownerCode%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=4 value="<%=classCode%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=ct%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=ds%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=sc%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=kl%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=lc%>">
							</td>
							<td width="5%">
								<input class="input_noBorder" style="" size=10 value="<%=dl%>">
							</td>
							<td width="5%">
								<input  type="text" style="color:blue;" name="sendYN<%=count%>" size=4 value="<%=sendFlag%>" onclick="changeFlag(this)">
							</td>
							<td width="5%">
								<input  type="text" style="" name="ownerSendCount<%=count%>" size=7 value="<%=ownerSend%>">
							</td>
							<td width="5%">
								<input  type="text" style="" name="ownerReturnCount<%=count%>" size=7 value="<%=ownerReturn%>">
							</td>
							<td width="5%">
								<input  type="text" style="" name="classSendCount<%=count%>" size=7 value="<%=classSend%>">
							</td>
							<td width="5%">
								<input  type="text" style="" name="classReturnCount<%=count%>" size=7 value="<%=classReturn%>">
							</td>
							
						</tr>
						<%
						count++;
					}
				}
				%>
			</table>
			<input type="hidden" name="projectCount" value="<%=count%>">
		</div>
	</div>
</form>
	<iframe id="buyerClassProjectMgntBody" name="buyerClassProjectMgntBody" src="buyerClassProjectMgntBody.do" frameborder=0
			marginwidth=0 marginheight=0 scrolling=no width=100% style="margin-top: 10px; width: 100%; height: 230px;"></iframe>
</div>
</html>

