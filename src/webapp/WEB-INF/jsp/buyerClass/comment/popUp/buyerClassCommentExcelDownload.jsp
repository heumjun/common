<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 메인 헤더 엑셀 다운로드
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementExcelDownload.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLDecoder"%>

<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %> 
<%  // 웹페이지의 내용을 엑셀로 변환하기 위한 구문
	response.setHeader("Content-Disposition", "attachment; filename=ExcelDownload.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 
	request.setCharacterEncoding("euc-kr");
%>

<%--========================== JSP =========================================--%>
<%
	String sProject = StringUtil.setEmptyExt(request.getParameter("project"));
	String sOwnerClass = StringUtil.setEmptyExt(request.getParameter("ownerClass"));
	String sFromDate = StringUtil.setEmptyExt(request.getParameter("fromDate"));
	String sToDate = StringUtil.setEmptyExt(request.getParameter("toDate"));
	String sRevNo = StringUtil.setEmptyExt(request.getParameter("revNo"));
	String sSubject = StringUtil.setEmptyExt(request.getParameter("subject"));
	String sReceiveDept = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("receiveDept")),"UTF-8");
	String sRefDept = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("refDept")),"UTF-8");
	String sDesignReceiveFlag = StringUtil.setEmptyExt(request.getParameter("designReceiveFlag"));
	String sDesignReceiveFromDate = StringUtil.setEmptyExt(request.getParameter("designReceiveFromDate"));
	String sDesignReceiveToDate = StringUtil.setEmptyExt(request.getParameter("designReceiveToDate"));
	String sReceivePerson = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("receivePerson")),"UTF-8");
	String sProcessDept = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("processDept")),"UTF-8");
	String sProcessPerson = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("processPerson")),"UTF-8");
	String sDesignProcessFromDate = StringUtil.setEmptyExt(request.getParameter("designProcessFromDate"));
	String sDesignProcessToDate = StringUtil.setEmptyExt(request.getParameter("designProcessToDate"));
	String sStatus = StringUtil.setEmptyExt(request.getParameter("status"));
	String mode = StringUtil.setEmptyExt(request.getParameter("mode"));


	if("All".equals(sOwnerClass)) sOwnerClass = "";
	if("All".equals(sDesignReceiveFlag)) sDesignReceiveFlag = "";
	if("All".equals(sStatus)) sStatus = "";

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
<head>
<meta http-equiv="Content-Type" contentType="text/html; charset=euc-kr"/>
</head>
<body>
<form name="commentBodyForm">
	<table border="1">
		<tr bgcolor="#CACACA">
			<td>Project
			</td>
			<td>대상
			</td>
			<td>문서 종류
			</td>
			<td>선주/선급 발송일자
			</td>
			<td>접수 NO.
			</td>
			<td>제목
			</td>
			<td>수신부서
			</td>
			<td>참조부서
			</td>
			<td>설계접수
			</td>
			<td>접수일
			</td>
			<td>접수자
			</td>
			<td>담당부서
			</td>
			<td>담당자
			</td>
			<td>담당자사번
			</td>
			<td>발송문서 NO.
			</td>
			<td>실적등록일
			</td>
			<td>Comments
			</td>
			<td>Reply
			</td>
			<td>Short Notice
			</td>
			<td>STATUS
			</td>
			<td>종료일
			</td>
			<td>경과일
			</td>
		</tr>
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

		 %>
			<tr>
				<td><%=project%>
				</td>
				<td><%=owner_class_type%>
				</td>
				<td><%=doc_type%>
				</td>
				<td><%=send_receive_date%>
				</td>
				<td><%=rev_no%>
				</td>
				<td><%=subject%>
				</td>
				<td><%=send_receive_dept%>	
				</td>
				<td><%=ref_dept%>
				</td>
				<td><%=design_receive_flag_desc%>
				</td>
				<td><%=design_receive_date%>
				</td>
				<td><%=design_receive_person_name%>				    
				</td>
				<td><%=design_process_dept%>	
				</td>
				<td><%=design_process_person_name%>				    
				</td>
				<td><%=design_process_person%>				    
				</td>
				<td><%=send_ref_no%>						
				</td>
				<td><%=design_process_date%>
				</td>
				<td><%=comment_count%>
				</td>
				<td><%=reply_count%>
				</td>
				<td><%=short_notice_count%>
				</td>
				<td><%=status%>
				</td>
				<td><%=design_close_date%>
				</td>
				<td><%=progress_day%>
				</td>
			</tr>
		 <%
			 }
		 %>					

	</table>
</form>
</body>
</html>