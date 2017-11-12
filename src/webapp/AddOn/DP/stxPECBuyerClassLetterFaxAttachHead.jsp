<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="scripts/emxUIModal.js"></script>	
<script language="JavaScript">
	
	function searchDoc()
	{
		var docNum = document.attachHeadForm.docNum.value;
		
		if(docNum == ""){
			alert("문서번호를 입력하세요.");
			
			document.attachHeadForm.docNum.focus();
			
			return;
		}
		
		var url = "stxPECBuyerClassLetterFaxAttachHead.jsp"
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
		
    	var attURL = "stxPECBuyerClassLetterFaxAttachFileSelectDialogFS.jsp";
	    attURL += "?refNo=" + refNo.replace("&","%26");
	    attURL += "&mode=doc";
	    
		showModalDialog(attURL, 700, 200);
		
	}
	
	function attachRefDoc(refNo)
	{
		//alert(refNo);
		
    	var attURL = "stxPECBuyerClassLetterFaxAttachFileSelectDialogFS.jsp";
	    attURL += "?refNo=" + refNo.replace("&","%26");
	    attURL += "&mode=ref";
	    
		showModalDialog(attURL, 700, 400);
		
	}
</script>

<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<%
//Search Condition
//String searchProject 		= request.getParameter("project");
//String searchSeries 		= request.getParameter("includeSeries");
//String searchRefNoType		= request.getParameter("refNoType");
String searchRefNo 			= request.getParameter("docNum");
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
<form name=attachHeadForm method="post" action="stxPECBuyerClassLetterFaxAttachHead.jsp">
	<table>
		<tr>
			<td>
				공문서 첨부
			</td>
		</tr>
		<tr>
			<td>
				
			</td>
		</tr>
		<!-- 상단 검색 조건 시작 -->
		<tr>
			<td style="border: #00bb00 1px solid;">
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="72">
							<input type="radio" name="originator" >작성자
						</td>
						<td width="72">
							<input type="radio" name="team">소속팀
						</td>
						<td width="72" style="border: #000000 1px solid; color:#0000ff">
							
						</td>
						<td width="72">
							문서번호
						</td>
						<td width="150" style="border: #000000 1px solid; color:#0000ff">
							<input class="input_noBorder" style="width:150px;background-color:#D8D8D8;" name="docNum">
						</td>
						<td width="72" style="border: #000000 1px solid; color:#0000ff">
							
						</td>
						<td width="75" style="border: #000000 1px solid; color:#0000ff" align="right">
							<input type="button" style="width:75px;background-color:#D8D8D8;" value="조회" onclick="searchDoc()"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-- 상단 검색 조건 끝 -->
		<!-- 하단 검색 결과 시작 -->
		<tr>
			<td style="border: #00bb00 1px solid;">
				<table  cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table>
								<tr>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=6 value="호선번호">
					            	</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=30 value="문서번호">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=6 value="구분">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=6 value="수발신">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=50 value="제목">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=10 value="발신일">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=10 value="부서">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=6 value="발신자">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=4 value="공문">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=4 value="첨부">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=6 value="첨부자">
									</td>
									<td style="border: #000000 1px solid;">
										<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" size=10 value="일자">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<div STYLE="width:100%; height:600; overflow:scroll; overflow-x:hidden;"> 
								<table>
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
										<tr>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=projectNo%>">
							            	</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=30 value="<%=refNo%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=ownerClassType%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=sendReceiveType%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=50 value="<%=subject%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=10 value="<%=sendReceiveDate%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=10 value="<%=sendReceiveDept%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=sender%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=4 value="..." onclick="attachDoc('<%=refNo%>')">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=4 value="..." onclick="attachRefDoc('<%=refNo%>')">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=6 value="<%=attachUser%>">
											</td>
											<td style="border: #000000 1px solid;">
												<input class="input_noBorder" style="background-color:<%=bgColor%>; color:#000000" size=10 value="<%=attachDate%>">
											</td>
										</tr>
										<%
										count++;
									}
									%>
								</table>
							</div>		
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-- 하단 검색결과 끝 -->
	</table>
</form>
