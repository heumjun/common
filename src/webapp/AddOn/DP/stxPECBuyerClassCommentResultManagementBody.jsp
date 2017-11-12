<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 메인 바디
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementBody.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>


<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.CallableStatement"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.text.*"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%

String sProject = StringUtil.setEmptyExt(emxGetParameter(request, "project"));
String sOwnerClass = StringUtil.setEmptyExt(emxGetParameter(request, "ownerClass"));
String sFromDate = StringUtil.setEmptyExt(emxGetParameter(request, "fromDate"));
String sToDate = StringUtil.setEmptyExt(emxGetParameter(request, "toDate"));
String sRevNo = StringUtil.setEmptyExt(emxGetParameter(request, "revNo"));
String sSubject = StringUtil.setEmptyExt(emxGetParameter(request, "subject"));
String sReceiveDept = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "receiveDept")),"UTF-8");
String sRefDept = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "refDept")),"UTF-8");
String sDesignReceiveFlag = StringUtil.setEmptyExt(emxGetParameter(request, "designReceiveFlag"));
String sDesignReceiveFromDate = StringUtil.setEmptyExt(emxGetParameter(request, "designReceiveFromDate"));
String sDesignReceiveToDate = StringUtil.setEmptyExt(emxGetParameter(request, "designReceiveToDate"));
String sReceivePerson = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "receivePerson")),"UTF-8");
String sProcessDept = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "processDept")),"UTF-8");
String sProcessPerson = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "processPerson")),"UTF-8");
String sDesignProcessFromDate = StringUtil.setEmptyExt(emxGetParameter(request, "designProcessFromDate"));
String sDesignProcessToDate = StringUtil.setEmptyExt(emxGetParameter(request, "designProcessToDate"));
String sStatus = StringUtil.setEmptyExt(emxGetParameter(request, "status"));
String mode = StringUtil.setEmptyExt(emxGetParameter(request, "mode"));



/*
System.out.println("##  sProject  =  "+sProject);
System.out.println("##  sOwnerClass  =  "+sOwnerClass);
System.out.println("##  sFromDate  =  "+sFromDate);
System.out.println("##  sToDate  =  "+sToDate);
System.out.println("##  sRevNo  =  "+sRevNo);
System.out.println("##  sSubject  =  "+sSubject);
System.out.println("##  sReceiveDept  =  "+sReceiveDept);
System.out.println("##  sRefDept  =  "+sRefDept);
System.out.println("##  sDesignReceiveFlag  =  "+sDesignReceiveFlag);
System.out.println("##  sDesignReceiveFromDate  =  "+sDesignReceiveFromDate);
System.out.println("##  sDesignReceiveToDate  =  "+sDesignReceiveToDate);
System.out.println("##  sProcessDept  =  "+sProcessDept);
System.out.println("##  sProcessPerson  =  "+sProcessPerson);
System.out.println("##  sDesignProcessFromDate  =  "+sDesignProcessFromDate);
System.out.println("##  sDesignProcessToDate  =  "+sDesignProcessToDate);
System.out.println("##  sStatus  =  "+sStatus);

System.out.println("##  mode  =  "+mode);
*/

// 최초 로딩 시 수신일자 최근 2주, 수신부서는 담당자 팀명으로 자동 설정
if("".equals(mode))
{
	if("".equals(sFromDate) || "".equals(sToDate))
	{
		Calendar cal_today = Calendar.getInstance(); 
		Calendar cal_fromday = Calendar.getInstance(); 
		cal_today.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR) +1);
		cal_fromday.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR) - 14);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  

		sToDate = sdf.format(cal_today.getTime());  // today+1
		sFromDate = sdf.format(cal_fromday.getTime());  // today - 14 (2Week)
	}

	if("".equals(sReceiveDept))
	{

		//String workUser = context.getUser();
	    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	   // String loginID = SessionUtils.getUserId();
	    String workUser = (String)loginUser.get("user_id");		

		String userName = "";
		String teamName = "";
		String teamCode = "";
		String partCode = "";

		java.sql.Connection conn1 = null;
		java.sql.Statement stmt1 = null;
		java.sql.ResultSet rset1 = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn1 = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.NAME AS USER_NAME ,                                                  \n");
			queryStr.append("       A.DEPT_CODE AS PART_CODE ,                                             \n");
			queryStr.append("       (SELECT D.DWGDEPTNM                                                    \n");
			queryStr.append("          FROM DCC_DEPTCODE B ,                                               \n");
			queryStr.append("               DCC_DWGDEPTCODE C ,                                            \n");
			queryStr.append("               DCC_DWGDEPTCODE D                                              \n");
			queryStr.append("         WHERE A.DEPT_CODE = B.DEPTCODE                                       \n");
			queryStr.append("           AND B.DWGDEPTCODE = C.DWGDEPTCODE                                  \n");
			queryStr.append("           AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE) AS TEAM_NAME ,             \n");
			queryStr.append("       (SELECT D.DWGDEPTCODE                                                  \n");
			queryStr.append("          FROM DCC_DEPTCODE B ,                                               \n");
			queryStr.append("               DCC_DWGDEPTCODE C ,                                            \n");
			queryStr.append("               DCC_DWGDEPTCODE D                                              \n");
			queryStr.append("         WHERE A.DEPT_CODE = B.DEPTCODE                                       \n");
			queryStr.append("           AND B.DWGDEPTCODE = C.DWGDEPTCODE                                  \n");
			queryStr.append("           AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE) as TEAM_CODE               \n");
			queryStr.append("  FROM CCC_SAWON A                                                            \n");
			queryStr.append("  WHERE A.EMPLOYEE_NUM = '"+workUser+"'                                       \n");

			stmt1 = conn1.createStatement();
			rset1 = stmt1.executeQuery(queryStr.toString());

			while (rset1.next()) {
				userName = rset1.getString(1);
				partCode = rset1.getString(2);
				teamName = rset1.getString(3);
				teamCode = rset1.getString(4);
			}
		}
		finally {
			if (rset1 != null) rset1.close();
			if (stmt1 != null) stmt1.close();
			DBConnect.closeConnection(conn1);
		}

		sReceiveDept = teamName;

	}
}
// END : 최초 로딩 시 수신일자 최근 2주, 수신부서는 담당자 팀명으로 자동 설정
//System.out.println("##  sReceiveDept  =  "+sReceiveDept);
//System.out.println("##  sFromDate  =  "+sFromDate);
//System.out.println("##  sToDate  =  "+sToDate);


// 기술기획에서 엑셀로 수신문서 upload 시에 '팀' 자를 생략하고 올리는 경우가 많음.. (예:기술기획팀인데 기술기획까지만)
String tempReceiveDept = "";
String tempRefDept = "";
String tempProcessDept = "";
try {
	if(sReceiveDept.lastIndexOf("팀") > -1)
	{
		tempReceiveDept = sReceiveDept.substring(0, sReceiveDept.lastIndexOf("팀"));
	} else {
		tempReceiveDept = sReceiveDept;
	}
	if(sRefDept.lastIndexOf("팀") > -1)
	{
		tempRefDept = sRefDept.substring(0, sRefDept.lastIndexOf("팀"));
	} else {
		tempRefDept = sRefDept;
	}
	if(sProcessDept.lastIndexOf("팀") > -1)
	{
		tempProcessDept = sProcessDept.substring(0, sProcessDept.lastIndexOf("팀"));
	} else {
		tempProcessDept = sProcessDept;
	}
}catch(Exception ee) {
	ee.printStackTrace();
}

%>

<%  // Data 추출
	java.sql.Connection conn = null;
	java.sql.Statement stmt = null;
	java.sql.ResultSet rset = null;

	ArrayList resultArrayList = new ArrayList();

	try {
		conn = DBConnect.getDBConnection("SDPS");

		StringBuffer queryStr = new StringBuffer();

		//예로 DESIGN_RECEIVE_DATE <= TO_DATE('2012-08-26','YYYY-MM-DD') 조건에서 DESIGN_RECEIVE_DATE, DESIGN_PROCESS_DATE 시분초를 가지고 있어서 하루를 더해줘야 오늘날짜를 포함한다.
		queryStr.append("SELECT SEQ_NO,                                                                      \n");
		queryStr.append("       PROJECT,                                                                     \n");
		queryStr.append("       OWNER_CLASS_TYPE,                                                            \n");
		queryStr.append("       DOC_TYPE,                                                                    \n");
		queryStr.append("       TO_CHAR(SEND_RECEIVE_DATE,'YYYY-MM-DD')  AS SEND_RECEIVE_DATE,               \n");
		queryStr.append("       REV_NO,                                                                      \n");
		queryStr.append("       SUBJECT,                                                                     \n");
		queryStr.append("       SEND_RECEIVE_DEPT,                                                           \n");
		queryStr.append("       REF_DEPT,                                                                    \n");
		queryStr.append("       DESIGN_RECEIVE_FLAG,                                                         \n");
		queryStr.append("       TO_CHAR(DESIGN_RECEIVE_DATE,'YYYY-MM-DD')  AS DESIGN_RECEIVE_DATE,           \n");
		queryStr.append("       DESIGN_PROCESS_DEPT,                                                         \n");
		queryStr.append("       DESIGN_PROCESS_PERSON,                                                       \n");
		queryStr.append("       (SELECT NAME                                                                 \n");
		queryStr.append("          FROM CCC_SAWON                                                            \n");
		queryStr.append("         WHERE EMPLOYEE_NUM = DESIGN_PROCESS_PERSON) AS DESIGN_PROCESS_PERSON_NAME, \n");
		queryStr.append("       SEND_REF_NO,                                                                 \n");
		queryStr.append("       TO_CHAR(DESIGN_PROCESS_DATE,'YYYY-MM-DD')  AS DESIGN_PROCESS_DATE,           \n");
		queryStr.append("       COMMENT_COUNT,                                                               \n");
		queryStr.append("       REPLY_COUNT,                                                                 \n");
		queryStr.append("       SHORT_NOTICE_COUNT,                                                          \n");
		queryStr.append("       STATUS,                                                                      \n");
		queryStr.append("       TO_CHAR(DESIGN_CLOSE_DATE,'YYYY-MM-DD')  AS DESIGN_CLOSE_DATE,               \n");
		queryStr.append("       (CASE WHEN STATUS = 'Open' THEN STX_OC_RECEIVE_DOCUMENT_WORK_F(DESIGN_RECEIVE_DATE,SYSDATE)                   \n");
		queryStr.append("             WHEN STATUS = 'Progress' THEN STX_OC_RECEIVE_DOCUMENT_WORK_F(DESIGN_RECEIVE_DATE,SYSDATE)               \n");
		queryStr.append("             WHEN STATUS = 'Closed' THEN STX_OC_RECEIVE_DOCUMENT_WORK_F(DESIGN_RECEIVE_DATE,DESIGN_CLOSE_DATE)       \n");
		queryStr.append("             WHEN STATUS = 'Closed(F)' THEN STX_OC_RECEIVE_DOCUMENT_WORK_F(DESIGN_RECEIVE_DATE,DESIGN_CLOSE_DATE)    \n");
		queryStr.append("             ELSE NULL                                                                                               \n");
		queryStr.append("         END) AS PROGRESS_DAY,                                                                                        \n");
		queryStr.append("       DESIGN_RECEIVE_PERSON_NAME                                                   \n");
		queryStr.append("  FROM STX_OC_RECEIVE_DOCUMENT                                                      \n");
		queryStr.append(" WHERE 1=1                                                                          \n");
		queryStr.append("   AND SEND_RECEIVE_DATE >= TO_DATE('"+sFromDate+"','YYYY-MM-DD')                   \n");
		queryStr.append("   AND SEND_RECEIVE_DATE <= TO_DATE('"+sToDate+"','YYYY-MM-DD')                     \n");
	if(!"".equals(tempReceiveDept))
		queryStr.append("   AND SEND_RECEIVE_DEPT LIKE '"+tempReceiveDept+"%'                                \n");
	if(!"".equals(sProject))
		queryStr.append("   AND PROJECT = '"+sProject+"'                                                     \n");
	if(!"".equals(sOwnerClass))
		queryStr.append("   AND OWNER_CLASS_TYPE = '"+sOwnerClass+"'                                         \n");
	if(!"".equals(sRevNo))
		queryStr.append("   AND REV_NO = '"+sRevNo+"'                                                        \n");
	if(!"".equals(sSubject))
		queryStr.append("   AND SUBJECT LIKE '%"+sSubject+"%'                                                \n");
	if(!"".equals(tempRefDept))
		queryStr.append("   AND REF_DEPT LIKE '%"+tempRefDept+"%'                                            \n");
	if(!"".equals(sDesignReceiveFlag))
		queryStr.append("   AND DESIGN_RECEIVE_FLAG = '"+sDesignReceiveFlag+"'                               \n");
	if(!"".equals(sDesignReceiveFromDate))
		queryStr.append("   AND DESIGN_RECEIVE_DATE >= TO_DATE('"+sDesignReceiveFromDate+"','YYYY-MM-DD')    \n");
	if(!"".equals(sDesignReceiveToDate))
		queryStr.append("   AND DESIGN_RECEIVE_DATE <= (TO_DATE('"+sDesignReceiveToDate+"','YYYY-MM-DD')+1)  \n");
	if(!"".equals(sReceivePerson))
		queryStr.append("   AND DESIGN_RECEIVE_PERSON_NAME = '"+sReceivePerson+"'                            \n");
	if(!"".equals(tempProcessDept))
		queryStr.append("   AND DESIGN_PROCESS_DEPT LIKE '"+tempProcessDept+"%'                              \n");
	if(!"".equals(sProcessPerson))
		queryStr.append("   AND DESIGN_PROCESS_PERSON_NAME = '"+sProcessPerson+"'                            \n");
	if(!"".equals(sDesignProcessFromDate))
		queryStr.append("   AND DESIGN_PROCESS_DATE >= TO_DATE('"+sDesignProcessFromDate+"','YYYY-MM-DD')    \n");
	if(!"".equals(sDesignProcessToDate))
		queryStr.append("   AND DESIGN_PROCESS_DATE <= (TO_DATE('"+sDesignProcessToDate+"','YYYY-MM-DD')+1)  \n");
	if(!"".equals(sStatus))
		queryStr.append("   AND STATUS ='"+sStatus+"'                                                        \n");

		queryStr.append(" ORDER BY REV_NO, SEND_RECEIVE_DEPT ,SEQ_NO                                         \n");

		//System.out.println("queryStr  =  "+queryStr.toString());

		stmt = conn.createStatement();
		rset = stmt.executeQuery(queryStr.toString());

		while (rset.next()) {
			HashMap resultMap = new HashMap();
			resultMap.put("SEQ_NO", rset.getString(1) == null ? "" : rset.getString(1));
			resultMap.put("PROJECT", rset.getString(2) == null ? "" : rset.getString(2));
			resultMap.put("OWNER_CLASS_TYPE", rset.getString(3) == null ? "" : rset.getString(3));
			resultMap.put("DOC_TYPE", rset.getString(4) == null ? "" : rset.getString(4));
			resultMap.put("SEND_RECEIVE_DATE", rset.getString(5) == null ? "" : rset.getString(5));
			resultMap.put("REV_NO", rset.getString(6) == null ? "" : rset.getString(6));
			resultMap.put("SUBJECT", rset.getString(7) == null ? "" : rset.getString(7));			
			resultMap.put("SEND_RECEIVE_DEPT", rset.getString(8) == null ? "" : rset.getString(8));
			resultMap.put("REF_DEPT", rset.getString(9) == null ? "" : rset.getString(9));
			resultMap.put("DESIGN_RECEIVE_FLAG", rset.getString(10) == null ? "" : rset.getString(10));
			resultMap.put("DESIGN_RECEIVE_DATE", rset.getString(11) == null ? "" : rset.getString(11));
			resultMap.put("DESIGN_PROCESS_DEPT", rset.getString(12) == null ? "" : rset.getString(12));
			resultMap.put("DESIGN_PROCESS_PERSON", rset.getString(13) == null ? "" : rset.getString(13));
			resultMap.put("DESIGN_PROCESS_PERSON_NAME", rset.getString(14) == null ? "" : rset.getString(14));
			resultMap.put("SEND_REF_NO", rset.getString(15) == null ? "" : rset.getString(15));
			resultMap.put("DESIGN_PROCESS_DATE", rset.getString(16) == null ? "" : rset.getString(16));
			resultMap.put("COMMENT_COUNT", rset.getString(17) == null ? "" : rset.getString(17));
			resultMap.put("REPLY_COUNT", rset.getString(18) == null ? "" : rset.getString(18));
			resultMap.put("SHORT_NOTICE_COUNT", rset.getString(19) == null ? "" : rset.getString(19));
			resultMap.put("STATUS", rset.getString(20) == null ? "" : rset.getString(20));
			resultMap.put("DESIGN_CLOSE_DATE", rset.getString(21) == null ? "" : rset.getString(21));
			resultMap.put("PROGRESS_DAY", rset.getString(22) == null ? "" : rset.getString(22));
			resultMap.put("DESIGN_RECEIVE_PERSON_NAME", rset.getString(23) == null ? "" : rset.getString(23));

			resultArrayList.add(resultMap);
		}
	}
	finally {
		if (rset != null) rset.close();
		if (stmt != null) stmt.close();
		DBConnect.closeConnection(conn);
	}

	//System.out.println("~~~ resultArrayList  =  "+resultArrayList.toString());
%>
<%--========================== SCRIPT ======================================--%>

<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<body style="background-color:#ffffff">
<form name="commentBodyForm" method="post" action="stxPECBuyerClassCommentResultManagementBody.jsp">
	<table width="100%" cellSpacing="0" border="1" align="center">
		<tr>
			<td style="border: #00bb00 1px solid;">			

				<table width="1550" border="0" cellpadding="0" cellspacing="1" style="table-layout:fixed;" bgcolor="#cccccc">
					<tr align="center" height="28" bgcolor="#e5e5e5">
						<td width="30" class="td_timeselect" >							   
						</td>
						<td width="50" class="td_timeselect">Project
						</td>
						<td width="50" class="td_timeselect">대상
						</td>
						<td width="50" class="td_timeselect">문서<br>종류
						</td>
						<td width="80" class="td_timeselect">선주/선급<br>발송일자
						</td>
						<td width="90" class="td_timeselect">접수 NO.
						</td>
						<td width="260" class="td_timeselect">제목
						</td>
						<td width="70" class="td_timeselect">수신부서
						</td>
						<td width="60" class="td_timeselect">참조부서
						</td>
						<td width="60" class="td_timeselect">설계접수
						</td>
						<td width="70" class="td_timeselect">접수일
						</td>
						<td width="50" class="td_timeselect">접수자
						</td>
						<td width="70" class="td_timeselect">담당부서
						</td>
						<td width="50" class="td_timeselect">담당자
						</td>
						<td width="130" class="td_timeselect">발송문서 NO.
						</td>
						<td width="70" class="td_timeselect">실적등록일
						</td>
						<td width="70" class="td_timeselect">Comments
						</td>
						<td width="50" class="td_timeselect">Reply
						</td>
						<td width="60" class="td_timeselect">Short<br>Notice
						</td>
						<td width="70" class="td_timeselect">STATUS
						</td>
						<td width="70" class="td_timeselect">종료일
						</td>
						<td width="50" class="td_timeselect">경과일
						</td>
					</tr>
				 </table>
			 <div style="width:1567; height:500; overflow-y:auto; position:relative;">
				 <table width="1550" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
				 <% for(int i=0; i<resultArrayList.size(); i++)
					{
						Map tempResultMap = (Map)resultArrayList.get(i);
						String seq_no = (String)tempResultMap.get("SEQ_NO");
						String project = (String)tempResultMap.get("PROJECT");
						String owner_class_type = (String)tempResultMap.get("OWNER_CLASS_TYPE");
						String doc_type = (String)tempResultMap.get("DOC_TYPE");
						String send_receive_date = (String)tempResultMap.get("SEND_RECEIVE_DATE");
						String rev_no = (String)tempResultMap.get("REV_NO");
						String subject = (String)tempResultMap.get("SUBJECT");
						String send_receive_dept = (String)tempResultMap.get("SEND_RECEIVE_DEPT");
						String ref_dept = (String)tempResultMap.get("REF_DEPT");
						String design_receive_flag = (String)tempResultMap.get("DESIGN_RECEIVE_FLAG");						
						String design_receive_date = (String)tempResultMap.get("DESIGN_RECEIVE_DATE");
						String design_process_dept = (String)tempResultMap.get("DESIGN_PROCESS_DEPT");
						String design_process_person = (String)tempResultMap.get("DESIGN_PROCESS_PERSON");
						String design_process_person_name = (String)tempResultMap.get("DESIGN_PROCESS_PERSON_NAME");
						String send_ref_no = (String)tempResultMap.get("SEND_REF_NO");
						String design_process_date = (String)tempResultMap.get("DESIGN_PROCESS_DATE");
						String comment_count = (String)tempResultMap.get("COMMENT_COUNT");
						String reply_count = (String)tempResultMap.get("REPLY_COUNT");
						String short_notice_count = (String)tempResultMap.get("SHORT_NOTICE_COUNT");
						String status = (String)tempResultMap.get("STATUS");
						String design_close_date = (String)tempResultMap.get("DESIGN_CLOSE_DATE");
						String progress_day = (String)tempResultMap.get("PROGRESS_DAY");
						String design_receive_person_name = (String)tempResultMap.get("DESIGN_RECEIVE_PERSON_NAME");	
						

						String design_receive_flag_desc = "";

						if("Y".equals(design_receive_flag))
						{
							design_receive_flag_desc = "접수";
						} else {
							design_receive_flag_desc = "미접수";
						}

						String designProcessFile = "";  // 실적 첨부 문서 열기
						designProcessFile = rev_no+"_"+seq_no;

						
						String disabledFlag = "";
						if("Closed".equals(status) || "Closed(F)".equals(status)) disabledFlag = "disabled";

				 %>
					<tr bgcolor="#ffffff">
						<td width="30" class="td_standard">
							<input type="checkbox" name="checkbox<%=i%>" value="<%=i%>" <%=disabledFlag%>>
							<input type="hidden" name="seq_no<%=i%>" value="<%=seq_no%>">							
						</td>
						<td width="50" class="td_standard"><%=project%>
						</td>
						<td width="50" class="td_standard"><%=owner_class_type%>
						</td>
						<td width="50" class="td_standard"><%=doc_type%>
						</td>
						<td width="80" class="td_standard"><%=send_receive_date%>
						</td>
						<td width="90" class="td_standard" style="cursor:hand;" onclick="viewRevNo('<%=rev_no%>')"><%=rev_no%>
							<input type="hidden" name="rev_no<%=i%>" value="<%=rev_no%>">
						</td>
						<td width="260" class="td_standardLeft"><%=subject%>
						</td>
						<td width="70" class="td_standard"><%=send_receive_dept%>
							<input type="hidden" name="send_receive_dept<%=i%>" value="<%=send_receive_dept%>">
						</td>
						<td width="60" class="td_standard"><%=ref_dept%>
						</td>
						<td width="60" class="td_standard"><%=design_receive_flag_desc%>
							<input type="hidden" name="design_receive_flag<%=i%>" value="<%=design_receive_flag%>">
						</td>
						<td width="70" class="td_standard"><%=design_receive_date%>
						</td>
						<td width="50" class="td_standard"><%=design_receive_person_name%>
						</td>
						<td width="70" class="td_standard"><%=design_process_dept%>
							<input type="hidden" name="design_process_dept<%=i%>" value="<%=design_process_dept%>">
						</td>
						<td width="50" class="td_standard"><%=design_process_person_name%>
						    <input type="hidden" name="design_process_person<%=i%>" value="<%=design_process_person%>">
						    <input type="hidden" name="design_process_person_name<%=i%>" value="<%=design_process_person_name%>">						    
						</td>
					<% if(!"".equals(send_ref_no))
						{  %>
							<td width="130" class="td_standard" style="cursor:hand;" onclick="viewProcessFile('<%=designProcessFile%>')"><%=send_ref_no%>						
							</td>
					<%   } else { %>
							<td width="130" class="td_standard">					
							</td>
					<%   }  %>

						<td width="70" class="td_standard"><%=design_process_date%>
						    <input type="hidden" name="design_process_date<%=i%>" value="<%=design_process_date%>">
						</td>
						<td width="70" class="td_standard"><%=comment_count%>
						</td>
						<td width="50" class="td_standard"><%=reply_count%>
						</td>
						<td width="60" class="td_standard"><%=short_notice_count%>
						</td>
						<td width="70" class="td_standard"><%=status%>
							<input type="hidden" name="status<%=i%>" value="<%=status%>">
						</td>
						<td width="70" class="td_standard"><%=design_close_date%>
						</td>
						<td width="50" class="td_standard"><%=progress_day%>
						</td>
					</tr>
				 <%
					 }
				 %>
					
				 </table>
			</div>

			</td>
		</tr>
	</table>
</form>
</body>
</html>
<%--========================== SCRIPT ======================================--%>
<script language="javascript">

	function viewRevNo(revNo)
	{
		if(confirm("접수 문서 ("+revNo+") 를 열어보시겠습니까?"))
		{
			if(revNo.value == ""){
				alert("Rev. No. 가 없습니다.");
				return;
			}
			
			var attURL = "stxPECBuyerClassLetterFaxViewFileOpen.jsp";
			attURL += "?revNo=" + revNo;
		
			var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
		
			//window.showModalDialog(attURL,"",sProperties);
			window.open(attURL,"",sProperties);
		}
		return;
	}

	// 실적 첨부 문서 파일 열기
	function viewProcessFile(fileName)
	{

		if(confirm("실적 첨부 문서를 열어보시겠습니까?"))
		{
		
			var attURL = "stxPECBuyerClassCommentResultManagementDesignProcessFileOpen.jsp";
			attURL += "?fileName=" + fileName;
		
			var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
		
			//window.showModalDialog(attURL,"",sProperties);
			window.open(attURL,"",sProperties);
		}
		return;
	}
	
</script>
