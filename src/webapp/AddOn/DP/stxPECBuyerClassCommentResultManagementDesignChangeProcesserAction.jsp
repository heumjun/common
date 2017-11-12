<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 설계접수 처리
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignReceiveAction.jsp
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
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");
    String loginMail = (String)loginUser.get("ep_mail");
    
	String sSelect_seq_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_seq_no"));
	String select_rev_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_rev_no"));
	String sWorkUser = StringUtil.setEmptyExt(emxGetParameter(request, "workUser"));
	String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "userName")),"UTF-8");
	String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "teamName")),"UTF-8");
	String sProcessPerson = StringUtil.setEmptyExt(emxGetParameter(request, "processPerson"));


	ArrayList processPersonList = new ArrayList();

	StringTokenizer sToken = new StringTokenizer(sProcessPerson, ",");

	while(sToken.hasMoreTokens()){
		processPersonList.add(sToken.nextToken());
	}


	String resultMsg = "";

    java.sql.Connection conn = null;
    java.sql.PreparedStatement pstmt = null;
    java.sql.Statement stmt  = null;
	java.sql.Statement stmt1  = null;
    java.sql.ResultSet rset = null;

	java.sql.Connection conn2 = null;
	java.sql.Statement stmt2  = null;
	java.sql.ResultSet rset2 = null;

	String selectProject = "";
	String selectOwnerClass = "";
	String selectDocType = "";
	String selectReceiveDate = "";
	String selectRevNo = "";
	String selectSubject = "";
	String selectReceiveDept = "";
	String selectDesignReceivePerson = "";
	String selectDesignReceivePersonName = "";
	String selectDesignProcessPerson = "";
	String selectDesignProcessPersonName = "";


    try 
	{
		conn = DBConnect.getDBConnection("SDPS");

		StringBuffer selectQuery = new StringBuffer();
		selectQuery.append("SELECT PROJECT,                                                                     \n");   // 호선
		selectQuery.append("       OWNER_CLASS_TYPE,                                                            \n");   // Owner / Class
		selectQuery.append("       DOC_TYPE,                                                                    \n");   // 문서종류
		selectQuery.append("       TO_CHAR(SEND_RECEIVE_DATE,'YYYY-MM-DD')  AS SEND_RECEIVE_DATE,               \n");   // 수신문서 수신일자
		selectQuery.append("       REV_NO,                                                                      \n");   // 수신문서 접수번호
		selectQuery.append("       SUBJECT,                                                                     \n");   // 수신문서 제목
		selectQuery.append("       SEND_RECEIVE_DEPT                                                            \n");   // 수신부서
		selectQuery.append("  FROM STX_OC_RECEIVE_DOCUMENT                                                      \n");
		selectQuery.append(" WHERE SEQ_NO = '" + sSelect_seq_no +"'                                             \n");   

		stmt1 = conn.createStatement();
		rset = stmt1.executeQuery(selectQuery.toString());

		if(rset.next()) {
			selectProject =  rset.getString(1) == null ? "" : rset.getString(1);
			selectOwnerClass =  rset.getString(2) == null ? "" : rset.getString(2);
			selectDocType =  rset.getString(3) == null ? "" : rset.getString(3);
			selectReceiveDate =  rset.getString(4) == null ? "" : rset.getString(4);
			selectRevNo =  rset.getString(5) == null ? "" : rset.getString(5);
			selectSubject =  rset.getString(6) == null ? "" : rset.getString(6);
			selectReceiveDept =  rset.getString(7) == null ? "" : rset.getString(7);
		}

		// 설계접수
		
			conn2 = DBConnect.getDBConnection("ERP_APPS");

			ArrayList toList = new ArrayList();

			String mailSub = "";
			String mailMsg = "";
			String mailMsgTop = "";
			String mailMsgMiddle = "";
			String mailMsgBottom = "";

			mailSub = " [수신문서 실적등록 요청] "+selectProject+" ,  문서번호 : "+select_rev_no;

			mailMsgTop += "<br><p><font color='red'><strong>[수신문서 접수 현황]</strong></font></p>";				

			mailMsgTop += "<table width='100%' border=1 bordercolor=black align=center style='border-collapse: collapse;'>";
			mailMsgTop += "   <tr height=30 bgcolor='#cccccc'> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>호선</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>대상</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>문서종류</td> ";
			mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>수신일자</td> ";
			mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>접수No.</td> ";
			mailMsgTop += "       <td width=300 style='color:#336699; font-weight: bold;' align=center>제목</td> ";
			mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>수신부서</td> ";
			mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>접수일</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>접수자</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>담당자</td> ";
			mailMsgTop += "   </tr> ";

			mailMsgBottom += "</table> ";
			mailMsgBottom += "<br>위 항목에 대해 접수되었으니 회신 및 실적등록 바랍니다.";
			mailMsgBottom += "<br> (경로 : PLM -> Actions -> Engineering -> Buyer/Class -> COMMENT RESULT MANAGEMENT)";

			String thisDate = "";

			Calendar cal_today = Calendar.getInstance(); 
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
			thisDate = sdf.format(cal_today.getTime()); 
			

			StringBuffer queryStr2 = new StringBuffer();
			queryStr2.append("SELECT INSA.USER_NAME,                                          \n");         // 처리담당자명
			queryStr2.append("       INSA.DEPT_NAME,                                          \n");         // 처리담당자부서
			queryStr2.append("       INSA.EP_MAIL || '@onestx.com' AS EMAIL,                  \n");         // 처리담당자 EMAIL
			queryStr2.append("      (SELECT INSA2.EP_MAIL || '@onestx.com'                    \n");         // 처리담당자 파트장 EMAIL
			queryStr2.append("         FROM STX_COM_INSA_USER INSA2                           \n");
			queryStr2.append("        WHERE INSA2.DEPT_CODE=INSA.DEPT_CODE                    \n");
			queryStr2.append("          AND INSA2.DEL_DATE IS NULL                            \n");
			queryStr2.append("          AND INSA2.JOB_NAM='파트장') AS PARTJANG_EMAIL         \n");
			queryStr2.append("  FROM STX_COM_INSA_USER INSA,                                  \n");
			queryStr2.append("       STX_COM_INSA_DEPT DEPT                                   \n");
			queryStr2.append(" WHERE INSA.DEPT_CODE = DEPT.DEPT_CODE                          \n");
			queryStr2.append("   AND INSA.DEL_DATE IS NULL                                    \n");
			queryStr2.append("   AND INSA.EMP_NO = ?                                          \n");

			pstmt = conn2.prepareStatement(queryStr2.toString());


			for(int i=0; i < processPersonList.size(); i++)
			{
				String tempProcessPerson = (String)processPersonList.get(i);
				String tempProcessPersonName = "";
				String tempProcessDept = "";

				pstmt.setString(1, tempProcessPerson);
				rset2 = pstmt.executeQuery();

				if (rset2.next())
				{
					tempProcessPersonName = rset2.getString(1) == null ? "" : rset2.getString(1);       // 처리담당자명
					tempProcessDept = rset2.getString(2) == null ? "" : rset2.getString(2);             // 처리담당자부서
					String tempEmail = rset2.getString(3) == null ? "" : rset2.getString(3);            // 처리담당자 EMAIL
					String tempPartjangEmail = rset2.getString(4) == null ? "" : rset2.getString(4);    // 처리담당자 파트장 EMAIL

					toList.add(tempEmail);
					if(!toList.contains(tempPartjangEmail))
					{
						toList.add(tempPartjangEmail);
					}
				}

				if(i==0)
				{
					StringBuffer queryStr = new StringBuffer();
					queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
					queryStr.append("   SET DESIGN_RECEIVE_DATE = SYSDATE                                        \n");      //설계접수일자
					queryStr.append("      ,DESIGN_RECEIVE_PERSON = '" +  sWorkUser + "'                         \n");      //설계접수자
					queryStr.append("      ,DESIGN_RECEIVE_PERSON_NAME = '" +  sUserName + "'                    \n");      //설계접수자명
					queryStr.append("      ,DESIGN_PROCESS_PERSON = '" +  tempProcessPerson + "'                 \n");      //처리담당자
					queryStr.append("      ,DESIGN_PROCESS_PERSON_NAME = '" + tempProcessPersonName + "'         \n");      //처리담당자명
					queryStr.append("      ,DESIGN_PROCESS_DEPT = '" + tempProcessDept + "'                      \n");      //처리담당부서
					queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no +"'                                     \n");      

					stmt = conn.createStatement();
					stmt.executeUpdate(queryStr.toString());

					mailMsgMiddle += "   <tr height=30 bgcolor='#f5f5f5'> ";
					mailMsgMiddle += "       <td width=60  align=center>"+selectProject+"</td> ";
					mailMsgMiddle += "       <td width=60  align=center>"+selectOwnerClass+"</td> ";
					mailMsgMiddle += "       <td width=60  align=center>"+selectDocType+"</td> ";
					mailMsgMiddle += "       <td width=120  align=center>"+selectReceiveDate+"</td> ";
					mailMsgMiddle += "       <td width=120  align=center>"+selectRevNo+"</td> ";
					mailMsgMiddle += "       <td width=300  align=center>"+selectSubject+"</td> ";
					mailMsgMiddle += "       <td width=100  align=center>"+selectReceiveDept+"</td> ";
					mailMsgMiddle += "       <td width=100  align=center>"+thisDate+"</td> ";
					mailMsgMiddle += "       <td width=60  align=center>"+sUserName+"</td> ";
					mailMsgMiddle += "       <td width=60  align=center>"+tempProcessPersonName+"</td> ";
					mailMsgMiddle += "   </tr> ";

				} 
			}

			//메일전송
/*
			ArrayList toList1 = new ArrayList();

			String toUser = "clever@onestx.com";
			toList1.add(toUser);
*/

			// (파트장/ 담당자) 문서접수 메일 전송
			if(toList.size()>0)
			{
				HashMap argsMap = new HashMap();
				argsMap.put("toList", toList);
				//argsMap.put("toList", toList1);		
				argsMap.put("fromList", loginMail);		

				mailMsg += mailMsgTop;  
				mailMsg += mailMsgMiddle;  
				mailMsg += mailMsgBottom;  

				argsMap.put("subject",mailSub);
				argsMap.put("message",mailMsg);

				// 메일 부분 대체 필요
				//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));
				com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );

			} else {
				throw new Exception("No Mail Receiver !!");
			}


		DBConnect.commitJDBCTransaction(conn);

		resultMsg = "SUCCESS";




	}
    catch (Exception e) {
		DBConnect.rollbackJDBCTransaction(conn);
        resultMsg = "ERROR  :  "+e.toString();    
    }

    finally{
        try {
            if ( rset != null ) rset.close();
            if ( stmt != null ) stmt.close();
			if ( stmt1 != null ) stmt1.close();
            if ( pstmt != null ) pstmt.close();   
            DBConnect.closeConnection( conn );
			if (rset2 != null) rset2.close();
			if (stmt2 != null) stmt2.close();
			DBConnect.closeConnection(conn2);
        } catch( Exception ex ) { }
    } 
	
//System.out.println("##  resultMsg  =  "+resultMsg);
%>

<%=resultMsg%>