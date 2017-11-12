<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%--========================== JSP =========================================--%>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="scripts/emxUIModal.js"></script>	
<script language="JavaScript">
	$(function() {
		$(window).bind('resize', function() {
			$('#list_body').css('height', $(window).height()-200);
		}).trigger('resize');
	});
	function searchDoc()
	{
		var docNum = document.attachHeadForm.docNum.value;
		
		if(docNum == ""){
			alert("문서번호를 입력하세요.");
			
			document.attachHeadForm.docNum.focus();
			
			return;
		}
		
		var url = "buyerClassLetterFaxAttach.do"
			    + "?docNum=" + docNum 
			    + "&mode=search"
			    ;
        
        //document.attachHeadForm.action = fnEncode(url);
        document.attachHeadForm.action = encodeURI(url);
        document.attachHeadForm.submit(); 
        
        return;
	}
	
	function attachDoc(refNo)
	{
		//alert(refNo);
		
    	var attURL = "buyerClassLetterFaxAttachFileUpload.do";
	    attURL += "?refNo=" + refNo.replace("&","%26");
	    attURL += "&mode=doc";
	    
	    var sProperties = 'dialogHeight:100px; dialogWidth:550px;scroll=no;center:yes;resizable=no;status=no;';
	    var rs = showModalDialog (attURL,window,sProperties);	
	    searchDoc();
		//showModalDialog(attURL, 700, 200);
		
	}
	
	function attachRefDoc(refNo)
	{
		//alert(refNo);
		
    	var attURL = "buyerClassLetterFaxAttachFileUpload.do";
	    attURL += "?refNo=" + refNo.replace("&","%26");
	    attURL += "&mode=ref";
	    
	    var sProperties = 'dialogHeight:350px;dialogWidth:550px;scroll=no;center:yes;resizable=no;status=no;';
	    showModalDialog (attURL,"",sProperties);	
	    searchDoc();
		//showModalDialog(attURL, 700, 400);
		
	}
</script>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<%
//Search Condition
//String searchProject 		= request.getParameter("project");
//String searchSeries 		= request.getParameter("includeSeries");
//String searchRefNoType		= request.getParameter("refNoType");
String searchRefNo 			= request.getParameter("docNum")==null?"":request.getParameter("docNum");
//String searchRevNo 			= request.getParameter("revNo");
//String searchSubject 		= request.getParameter("subject");
String searchOriginator 	= request.getParameter("originator");
String searchTeam 			= request.getParameter("team");
//String searchFromDate 		= request.getParameter("fromDate");
//String searchToDate 		= request.getParameter("toDate");
//String searchDeptType 		= request.getParameter("departmentType");
//String searchDepartment		= request.getParameter("department");
//String searchOwnerClass 	= request.getParameter("ownerClass");
//String searchSendReceive 	= request.getParameter("sendReceive");

//String searchReceiveCheck 	= request.getParameter("receiveCheck");
//String searchSendCheck 		= request.getParameter("sendCheck");
//String searchOwnerCheck 	= request.getParameter("ownerCheck");
//String searchClassCheck 	= request.getParameter("classCheck");
//String searchAndCheck 		= request.getParameter("andCheck");
//String searchOrCheck 		= request.getParameter("orCheck");
//String searchExSubject		= request.getParameter("exSubject");
//String searchDetailDate		= request.getParameter("detailDate");
//String searchSubjectType	= request.getParameter("subjectType");
//String searchKeyWord		= request.getParameter("keyWord");
//String searchDwgNo			= request.getParameter("dwgNo");

String mode					= request.getParameter("mode");

//System.out.println(searchProject);
//System.out.println(searchRefNo);
//System.out.println(searchRevNo);
//System.out.println(searchSubject);
//System.out.println(searchOriginator);
//System.out.println(searchTeam);
//System.out.println(searchFromDate);
//System.out.println(searchToDate);
//System.out.println(searchReceiveDept);
//System.out.println(searchRefDept);
//System.out.println(searchOwnerClass);
//System.out.println(searchSendReceive);

//System.out.println(searchReceiveCheck);
//System.out.println(searchSendCheck);
//System.out.println(searchOwnerCheck);
//System.out.println(searchClassCheck);
//System.out.println(searchAndCheck);
//System.out.println(searchOrCheck);
//System.out.println(searchExSubject);
//System.out.println(searchDetailDate);
//System.out.println(searchSubjectType);
//System.out.println(searchKeyWord);
//System.out.println(searchDwgNo);

//System.out.println(mode);
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    System.out.println("loginUser"+loginUser);
    String loginID = (String)loginUser.get("user_id");
    String loginUserName = (String)loginUser.get("user_name");
    
%>
<div id="mainDiv" class="mainDiv">
	<div class="subtitle">
		공문서 첨부
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	<form name=attachHeadForm method="post" action="stxPECBuyerClassLetterFaxAttachHead.jsp">
		<!-- 상단 검색 조건 시작 -->
		<table class="searchArea conSearch">
			<tr>
				<th width="50px">작성자</th>
				<td width="50px">
					<input type="radio" name="originator" >
				</td>
				<th width="50px">소속팀</th>
				<td width="50px">
					<input type="radio" name="team">
				</td>
				<th width="50px">문서번호</th>
				<td width="120px">
					<input type="text" name="docNum" value="<%=searchRefNo%>">
				</td>
				<td>
					<div  id="buttonTable" class="button endbox">
						<input type="button" class="btn_blue" value="조회" onclick="searchDoc()"/>
					</div>
				</td>
			</tr>
		</table>
		<!-- 상단 검색 조건 끝 -->
		<!-- 하단 검색 결과 시작 -->
		<div style="border: #00bb00 1px solid;padding:5px;margin-top:10px;">
			<div id="list_head" style="overflow-y:scroll;overflow-x:hidden;">
				<table class="insertArea">
					<tr>
						<th width="4%">호선번호</th>
						<th width="14%">문서번호</th>
						<th width="4%">구분</th>
						<th width="4%">수발신</th>
						<th width="30%">제목</th>
						<th width="9%">발신일</th>
						<th width="9%">부서</th>
						<th width="4%">발신자</th>
						<th width="4%">공문</th>
						<th width="4%">첨부</th>
						<th width="4%">첨부자</th>
						<th width="10%">일자</th>
					</tr>
				</table>
			</div>
			<div id="list_body" style="height:600px;overflow-y:scroll;overflow-x:hidden;">
				<table class="insertArea">
					<%
					java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
					
					StringBuffer selectDataSQL = new StringBuffer();
					selectDataSQL.append("select sodl.PROJECT ");
					selectDataSQL.append("     , sodl.OWNER_CLASS_TYPE ");
					selectDataSQL.append("     , sodl.SEND_RECEIVE_TYPE ");
					selectDataSQL.append("     , sodl.DOC_TYPE ");
					selectDataSQL.append("     , sodl.REF_NO ");
					selectDataSQL.append("     , sodl.REV_NO ");
					selectDataSQL.append("     , sodl.SUBJECT ");
					selectDataSQL.append("     , sodl.SENDER ");
					selectDataSQL.append("     , TO_CHAR(sodl.SEND_RECEIVE_DATE, 'YYYY-MM-DD') ");
					selectDataSQL.append("     , sodl.SEND_RECEIVE_DEPT ");
					selectDataSQL.append("     , sodl.REF_DEPT ");
					selectDataSQL.append("     , sodl.KEYWORD ");
					selectDataSQL.append("     , sodl.VIEW_ACCESS ");
					selectDataSQL.append("     , sodl.ATTACH_USER ");
					selectDataSQL.append("     , sodl.ATTACH_DATE ");
					selectDataSQL.append("  from stx_oc_document_list sodl ");
					selectDataSQL.append(" where SEND_RECEIVE_TYPE = 'send' ");
					
					if(mode!=null && "search".equals(mode)){
						String whereSQL = "";
						
						if(searchRefNo!=null && !"".equals(searchRefNo)){
							whereSQL += (whereSQL.equals("")?"":" and ") + " REF_NO like '%"+searchRefNo+"%'";
						}
						if(searchOriginator!=null && !"".equals(searchOriginator)){
							
						}
						if(searchTeam!=null && !"".equals(searchTeam)){
							
						}
						
						if(!whereSQL.equals("")){
							selectDataSQL.append(" and "+whereSQL);
						}
					}else{
						selectDataSQL.append(" and 1=2 ");
					}
					
					selectDataSQL.append(" order by REF_NO ");
					
					//System.out.println(selectDataSQL.toString());
					
					//StringBuffer selectRefDataSQL = new StringBuffer();
					//selectRefDataSQL.append("select soro.PROJECT ");
					//selectRefDataSQL.append("     , soro.OBJECT_NO ");
					//selectRefDataSQL.append("     , soro.OBJECT_COMMENT ");
					//selectRefDataSQL.append("  from stx_oc_ref_object soro ");
					//selectRefDataSQL.append(" where soro.PROJECT = ? ");
					//selectRefDataSQL.append("   and soro.REF_NO = ? ");
					//selectRefDataSQL.append("   and soro.OBJECT_TYPE = ? ");
					//selectRefDataSQL.append(" order by object_no ");
					
					//CallableStatement cstmt = conn.prepareCall(selectRefDataSQL.toString());
					
					java.sql.Statement stmt = conn.createStatement();
					java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDataSQL.toString());
					
					int count = 0 ;
					while(selectDateRset.next()){
						
						String projectNo 		= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
						String ownerClassType 	= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
						String sendReceiveType	= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
						String docType			= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
						String refNo			= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
						String revNo			= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
						String subject			= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
						String sender			= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
						String sendReceiveDate	= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
						String sendReceiveDept	= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
						String refDept			= selectDateRset.getString(11)==null?"":selectDateRset.getString(11);
						String keyword			= selectDateRset.getString(12)==null?"":selectDateRset.getString(12);
						String viewAccess		= selectDateRset.getString(13)==null?"":selectDateRset.getString(13);
						String attachUser		= selectDateRset.getString(14)==null?"":selectDateRset.getString(14);
						String attachDate		= selectDateRset.getString(15)==null?"":selectDateRset.getString(15);
						
						try{
							//attachUser = MqlUtil.mqlCommand(context , "print bus Person "+attachUser+" - select attribute[First Name] dump");
							attachUser = loginUserName;
						}catch(Exception exex){
							
						}
						
						String bgColor = "";
						if("receive".equals(sendReceiveType)){
							bgColor = "#FFFFFF";
						}else if("send".equals(sendReceiveType)){
							bgColor = "#D8BFD8";
						}
						
						%>
					<tr style="background-color:<%=bgColor%>">
						<td width="4%">
							<%=projectNo%>
						</td>
						<td width="14%">
							<%=refNo%>
						</td>
						<td width="4%">
							<%=ownerClassType%>
						</td>
						<td width="4%">
							<%=sendReceiveType%>
						</td>
						<td width="30%">
							<%=subject%>
						</td>
						<td width="9%">
							<%=sendReceiveDate%>
						</td>
						<td width="9%">
							<%=sendReceiveDept%>
						</td>
						<td width="4%">
							<%=sender%>
						</td>
						<td width="4%">
							<input  type="button" class="btn_gray2" value="첨부" onclick="attachDoc('<%=refNo%>')">
						</td>
						<td width="4%">
							<input  type="button" class="btn_gray2" value="첨부" onclick="attachRefDoc('<%=refNo%>')">
						</td>
						<td width="4%">
							<%=attachUser%>
						</td>
						<td width="10%">
							<%=attachDate%>
						</td>
					</tr>
					<%
						count++;
					}
					%>
				</table>
			</div>
		</div>
		<!-- 하단 검색결과 끝 -->
	</form>
</div>