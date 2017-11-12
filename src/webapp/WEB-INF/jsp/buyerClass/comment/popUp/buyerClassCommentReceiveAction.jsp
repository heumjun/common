<%--  
��DESCRIPTION: ���Ź��� ���� �� ���� ���� - �������� ó��
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECBuyerClassCommentReceiveAction.jsp
��CHANGING HISTORY: 
��    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    System.out.println("loginUser ="+loginUser);
   // String loginID = SessionUtils.getUserId();
    String loginID = (String)loginUser.get("user_id");
    String loginMail = (String)loginUser.get("ep_mail");
    
	String sSelect_seq_no = StringUtil.setEmptyExt(request.getParameter("select_seq_no"));
	String select_rev_no = StringUtil.setEmptyExt(request.getParameter("select_rev_no"));
	String sWorkUser = StringUtil.setEmptyExt(request.getParameter("workUser"));
	String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("userName")),"UTF-8");
	String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("teamName")),"UTF-8");
	String sProcessFlag = StringUtil.setEmptyExt(request.getParameter("processFlag"));
	String sProcessPerson = StringUtil.setEmptyExt(request.getParameter("processPerson"));
	String sRevNoDeptList = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("revNoDeptList")),"UTF-8");
	String sCommentMsg = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("commentMsg")),"UTF-8");

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
		selectQuery.append("SELECT PROJECT,                                                                     \n");   // ȣ��
		selectQuery.append("       OWNER_CLASS_TYPE,                                                            \n");   // Owner / Class
		selectQuery.append("       DOC_TYPE,                                                                    \n");   // ��������
		selectQuery.append("       TO_CHAR(SEND_RECEIVE_DATE,'YYYY-MM-DD')  AS SEND_RECEIVE_DATE,               \n");   // ���Ź��� ��������
		selectQuery.append("       REV_NO,                                                                      \n");   // ���Ź��� ������ȣ
		selectQuery.append("       SUBJECT,                                                                     \n");   // ���Ź��� ����
		selectQuery.append("       SEND_RECEIVE_DEPT                                                            \n");   // ���źμ�
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

		// ��������
		if("1".equals(sProcessFlag))
		{
			conn2 = DBConnect.getDBConnection("ERP_APPS");

			ArrayList toList = new ArrayList();

			String mailSub = "";
			String mailMsg = "";
			String mailMsgTop = "";
			String mailMsgMiddle = "";
			String mailMsgBottom = "";

			mailSub = " [���Ź��� ������� ��û] "+selectProject+" ,  ������ȣ : "+select_rev_no;

			mailMsgTop += "<br><p><font color='red'><strong>[���Ź��� ���� ��Ȳ]</strong></font></p>";				

			mailMsgTop += "<table width='100%' border=1 bordercolor=black align=center style='border-collapse: collapse;'>";
			mailMsgTop += "   <tr height=30 bgcolor='#cccccc'> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>ȣ��</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>���</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
			mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
			mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>����No.</td> ";
			mailMsgTop += "       <td width=300 style='color:#336699; font-weight: bold;' align=center>����</td> ";
			mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>���źμ�</td> ";
			mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>������</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>������</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>�����</td> ";
			mailMsgTop += "   </tr> ";

			mailMsgBottom += "</table> ";
			mailMsgBottom += "<br>�� �׸� ���� �����Ǿ����� ȸ�� �� ������� �ٶ��ϴ�.";
			mailMsgBottom += "<br> (��� : PLM -> Actions -> Engineering -> Buyer/Class -> COMMENT RESULT MANAGEMENT)";

			String thisDate = "";

			Calendar cal_today = Calendar.getInstance(); 
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
			thisDate = sdf.format(cal_today.getTime()); 
			
			StringBuffer queryStr2 = new StringBuffer();
			queryStr2.append("SELECT INSA.USER_NAME,                                          \n");         // ó������ڸ�
			queryStr2.append("       INSA.DEPT_NAME,                                          \n");         // ó������ںμ�
			queryStr2.append("       INSA.EP_MAIL || '@onestx.com' AS EMAIL,                  \n");         // ó������� EMAIL
			queryStr2.append("      (SELECT INSA2.EP_MAIL || '@onestx.com'                    \n");         // ó������� ��Ʈ�� EMAIL
			queryStr2.append("         FROM STX_COM_INSA_USER INSA2                           \n");
			queryStr2.append("        WHERE INSA2.DEPT_CODE=INSA.DEPT_CODE                    \n");
			queryStr2.append("          AND INSA2.DEL_DATE IS NULL                            \n");
			queryStr2.append("          AND INSA2.JOB_NAM='��Ʈ��') AS PARTJANG_EMAIL         \n");
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

				while (rset2.next())
				{
					tempProcessPersonName = rset2.getString(1) == null ? "" : rset2.getString(1);       // ó������ڸ�
					tempProcessDept = rset2.getString(2) == null ? "" : rset2.getString(2);             // ó������ںμ�
					String tempEmail = rset2.getString(3) == null ? "" : rset2.getString(3);            // ó������� EMAIL
					String tempPartjangEmail = rset2.getString(4) == null ? "" : rset2.getString(4);    // ó������� ��Ʈ�� EMAIL

					if (!"".equals(tempEmail) && !toList.contains(tempEmail))
					{
						toList.add(tempEmail);
					}
					if (!"".equals(tempPartjangEmail) && !toList.contains(tempPartjangEmail))
					{
						toList.add(tempPartjangEmail);
					}
				}

				// ó�� ����ڴ� ���� ���Ź����� �ֱ⿡ UPDATE�ϰ�, ������ ����ڴ� �߰��� INSERT����.
				if(i==0)
				{
					StringBuffer queryStr = new StringBuffer();
					queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
					queryStr.append("   SET DESIGN_RECEIVE_FLAG = 'Y'                                            \n");      //����FLAG     
					queryStr.append("      ,DESIGN_RECEIVE_ACTION = '��������'                                   \n");      //���� ��ġ���� (��������)
					queryStr.append("      ,DESIGN_RECEIVE_DATE = SYSDATE                                        \n");      //������������
					queryStr.append("      ,DESIGN_RECEIVE_PERSON = '" +  sWorkUser + "'                         \n");      //����������
					queryStr.append("      ,DESIGN_RECEIVE_PERSON_NAME = '" +  sUserName + "'                    \n");      //���������ڸ�
					queryStr.append("      ,DESIGN_PROCESS_PERSON = '" +  tempProcessPerson + "'                 \n");      //ó�������
					queryStr.append("      ,DESIGN_PROCESS_PERSON_NAME = '" + tempProcessPersonName + "'         \n");      //ó������ڸ�
					queryStr.append("      ,DESIGN_PROCESS_DEPT = '" + tempProcessDept + "'                      \n");      //ó�����μ�
					queryStr.append("      ,STATUS = 'Open'                                                      \n");      //STATUS : Open
					queryStr.append("      ,COMMENT_MESSAGE = '" + sCommentMsg +"'                               \n");      //Comment
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

				} else {

					// SEQ_NO ���� :  STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL		
					String nextSequence = "";

					StringBuffer selectSeqQuery = new StringBuffer();
					selectSeqQuery.append("SELECT STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL  \n");
					selectSeqQuery.append("  FROM DUAL                               \n");

					rset = stmt1.executeQuery(selectSeqQuery.toString());
					if (rset.next()) nextSequence = rset.getString(1);

					StringBuffer insertQuery = new StringBuffer();
					insertQuery.append("INSERT INTO STX_OC_RECEIVE_DOCUMENT(               \n");
					insertQuery.append("	SEQ_NO,                                        \n");
					insertQuery.append("	PROJECT,                                       \n");
					insertQuery.append("	OWNER_CLASS_TYPE,                              \n");
					insertQuery.append("	SEND_RECEIVE_TYPE,                             \n");
					insertQuery.append("	DOC_TYPE,                                      \n");
					insertQuery.append("	REF_NO,                                        \n");
					insertQuery.append("	REV_NO,                                        \n");
					insertQuery.append("	SUBJECT,                                       \n");
					insertQuery.append("	SENDER,                                        \n");
					insertQuery.append("	SENDER_NO,                                     \n");
					insertQuery.append("	SEND_RECEIVE_DATE,                             \n");
					insertQuery.append("	SEND_RECEIVE_DEPT,                             \n");
					insertQuery.append("	REF_DEPT,                                      \n");
					insertQuery.append("	DESIGN_RECEIVE_FLAG,                           \n");
					insertQuery.append("	DESIGN_RECEIVE_DATE,                           \n");

					insertQuery.append("	STATUS,                                        \n");
					insertQuery.append("	DESIGN_RECEIVE_PERSON,                         \n");
					insertQuery.append("	DESIGN_PROCESS_PERSON,                         \n");

	
					insertQuery.append("	COMMENT_MESSAGE,                               \n");
					insertQuery.append("	DESIGN_PROCESS_DEPT,                           \n");
					insertQuery.append("	DESIGN_PROCESS_PERSON_NAME,                    \n");
					insertQuery.append("	DESIGN_RECEIVE_PERSON_NAME,                    \n");
					insertQuery.append("	DESIGN_RECEIVE_ACTION)                         \n");
					insertQuery.append("SELECT                                             \n");
					insertQuery.append("   '" + nextSequence + "',                         \n");     // SEQ_NO       
					insertQuery.append("	PROJECT,                                       \n");     // project
					insertQuery.append("	OWNER_CLASS_TYPE,                              \n");     // owner_class_type
					insertQuery.append("	SEND_RECEIVE_TYPE,                             \n");     // send_receive_type
					insertQuery.append("	DOC_TYPE,                                      \n");     // doc_type
					insertQuery.append("	REF_NO,                                        \n");     // ref_no
					insertQuery.append("	REV_NO,                                        \n");     // rev_no
					insertQuery.append("	SUBJECT,                                       \n");     // subject
					insertQuery.append("	SENDER,                                        \n");     // sender
					insertQuery.append("	SENDER_NO,                                     \n");     // SENDER_NO
					insertQuery.append("	SEND_RECEIVE_DATE,                             \n");     // SEND_RECEIVE_DATE
					insertQuery.append("	SEND_RECEIVE_DEPT,                             \n");     // SEND_RECEIVE_DEPT
					insertQuery.append("	REF_DEPT,                                      \n");     // REF_DEPT
					insertQuery.append("	'Y',                                           \n");     // DESIGN_RECEIVE_FLAG
					insertQuery.append("	SYSDATE,                                       \n");     // DESIGN_RECEIVE_DATE�� �ֽų�¥�� ����		
					insertQuery.append("	'Open',                                        \n");     // STATUS   :  'Open'
					insertQuery.append("	'" +  sWorkUser + "' ,                         \n");     // DESIGN_RECEIVE_PERSON
					insertQuery.append("	'" +  tempProcessPerson + "',                  \n");     // DESIGN_PROCESS_PERSON	
					insertQuery.append("	'" + sCommentMsg +"',                          \n");     // COMMENT_MESSAGE
					insertQuery.append("	'" + tempProcessDept + "',                     \n");     // DESIGN_PROCESS_DEPT
					insertQuery.append("	'" + tempProcessPersonName + "',               \n");     // DESIGN_PROCESS_PERSON_NAME
					insertQuery.append("	'" +  sUserName + "',                          \n");     // DESIGN_RECEIVE_PERSON_NAME
					insertQuery.append("	'��������'                                     \n");     //���� ��ġ���� (��������)
					insertQuery.append("FROM STX_OC_RECEIVE_DOCUMENT                       \n");  
					insertQuery.append("WHERE SEQ_NO = '" + sSelect_seq_no +"'             \n");   

					stmt.executeUpdate(insertQuery.toString());

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

			//��������
	        /*** test	
			ArrayList toList1 = new ArrayList();

			String toUser = "hanss@onestx.com";
			String toUser1 = "mg.oh@onestx.com";

			toList1.add(toUser);
			toList1.add(toUser1);
			***/

			// (��Ʈ��/ �����) �������� ���� ����
			if(toList.size()>0)
			{
				HashMap argsMap = new HashMap();
				argsMap.put("toList", toList);
				////argsMap.put("toList", toList1);	
				argsMap.put("fromList", loginMail);			

				mailMsg += mailMsgTop;  
				mailMsg += mailMsgMiddle;  
				mailMsg += mailMsgBottom;  

				argsMap.put("subject",mailSub);
				argsMap.put("message",mailMsg);

				//���� �κ� ��ü �ʿ�
				//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));
				com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );

			} else {
				throw new Exception("No Mail Receiver !!");
			}


		}
		// ȸ�� ���ʿ�
		else if("2".equals(sProcessFlag))
		{
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
			queryStr.append("   SET DESIGN_RECEIVE_FLAG = 'Y'                                            \n");      //����FLAG     
			queryStr.append("      ,DESIGN_RECEIVE_ACTION = 'ȸ��/ó�� ���ʿ�'                           \n");      //���� ��ġ���� (ȸ��/ó�� ���ʿ�)
			queryStr.append("      ,DESIGN_RECEIVE_DATE = SYSDATE                                        \n");      //������������
			queryStr.append("      ,DESIGN_RECEIVE_PERSON = '" +  sWorkUser + "'                         \n");      //����������
			queryStr.append("      ,DESIGN_RECEIVE_PERSON_NAME = '" +  sUserName + "'                    \n");      //���������ڸ�
			queryStr.append("      ,DESIGN_CLOSE_DATE = SYSDATE                                          \n");      //Closed ����
			queryStr.append("      ,STATUS = 'Closed'                                                    \n");      //STATUS : Closed
			queryStr.append("      ,COMMENT_MESSAGE = '" + sCommentMsg +"'                               \n");      //Comment
			queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no +"'                                     \n");   

			stmt = conn.createStatement();
			stmt.executeUpdate(queryStr.toString());


		}
		// �ݼ�
		else if("3".equals(sProcessFlag))
		{
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
			queryStr.append("   SET DESIGN_RECEIVE_FLAG = 'Y'                                            \n");      //����FLAG      
			queryStr.append("      ,DESIGN_RECEIVE_ACTION = '�ݼ�'                                       \n");      //���� ��ġ���� (�ݼ�)
			queryStr.append("      ,DESIGN_RECEIVE_DATE = SYSDATE                                        \n");      //������������
			queryStr.append("      ,DESIGN_RECEIVE_PERSON = '" +  sWorkUser + "'                         \n");      //����������
			queryStr.append("      ,DESIGN_RECEIVE_PERSON_NAME = '" +  sUserName + "'                    \n");      //���������ڸ�
			queryStr.append("      ,DESIGN_CLOSE_DATE = SYSDATE                                          \n");      //Closed ����
			queryStr.append("      ,STATUS = 'Closed'                                                    \n");      //STATUS : Closed
			queryStr.append("      ,COMMENT_MESSAGE = '" + sCommentMsg +"'                               \n");      //Comment
			queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no +"'                                     \n");   

			stmt = conn.createStatement();
			stmt.executeUpdate(queryStr.toString());

			// �����ȹ ���Ź��� ���� �����(�ǿ���)���� �ݼ� ���� ����
			ArrayList toList = new ArrayList();
			
			String toUser = "ddeoki@onestx.com";  // �����ȹ ���Ź��� upload ����� (����� ����)

			//toUser = "ksj0107@onestx.com";
			//String toUser1 = "yunjaelee@onestx.com";

			toList.add(toUser);
			//toList.add(toUser1);
			
			// �����ȹ �ο� ���� ������ �߰�
			String toUser1 = "khhan@onestx.com";  // �Ѱ��� ����
			String toUser2 = "kimjunho@onestx.com";  // ����ȣ ����
			toList.add(toUser1);
			toList.add(toUser2);

			HashMap argsMap = new HashMap();
			argsMap.put("toList", toList);
			argsMap.put("fromList", loginMail);	

			String mailSub = "";
			String mailMsg = "";

			mailSub = " [���Ź��� �ݼ�] "+selectProject+" ,  ������ȣ : "+select_rev_no;

			mailMsg += "<br><p><font color='red'><strong>[���Ź��� �ݼ� ��Ȳ]</strong></font></p>";

			mailMsg += "<table width='100%' border=1 bordercolor=black align=center style='border-collapse: collapse;'>";
			mailMsg += "   <tr height=30 bgcolor='#cccccc'> ";
			mailMsg += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>ȣ��</td> ";
			mailMsg += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>���</td> ";
			mailMsg += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
			mailMsg += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
			mailMsg += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>����No.</td> ";
			mailMsg += "       <td width=300 style='color:#336699; font-weight: bold;' align=center>����</td> ";
			mailMsg += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>���źμ�</td> ";
			mailMsg += "   </tr> ";
			mailMsg += "   <tr height=30 bgcolor='#f5f5f5'> ";
			mailMsg += "       <td width=60  align=center>"+selectProject+"</td> ";
			mailMsg += "       <td width=60  align=center>"+selectOwnerClass+"</td> ";
			mailMsg += "       <td width=60  align=center>"+selectDocType+"</td> ";
			mailMsg += "       <td width=120  align=center>"+selectReceiveDate+"</td> ";
			mailMsg += "       <td width=120  align=center>"+selectRevNo+"</td> ";
			mailMsg += "       <td width=300  align=center>"+selectSubject+"</td> ";
			mailMsg += "       <td width=100  align=center>"+selectReceiveDept+"</td> ";
			mailMsg += "   </tr> ";
			mailMsg += "</table> ";

			mailMsg += "<br>�� �׸� ���� �ݼ۵Ǿ����ϴ�.";

			mailMsg += "<br><br><br><font color='blue'><strong>[Comments ����] : </strong></font>"+sCommentMsg;


			argsMap.put("subject",mailSub);
			argsMap.put("message",mailMsg);

			//���� �κ� ��ü �ʿ�
			//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));
			com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );

		}
		// Ÿ�μ� �߰� ����
		
		else if("4".equals(sProcessFlag))
		{
			if(true)
			{
				conn2 = DBConnect.getDBConnection("ERP_APPS");

				ArrayList toList = new ArrayList();

				String mailSub = "";
				String mailMsg = "";
				String mailMsgTop = "";
				String mailMsgMiddle = "";
				String mailMsgBottom = "";

				mailSub = " [���Ź��� ������� ��û] "+selectProject+" ,  ������ȣ : "+select_rev_no;

				mailMsgTop += "<br><p><font color='red'><strong>[���Ź��� ���� ��Ȳ]</strong></font></p>";				

				mailMsgTop += "<table width='100%' border=1 bordercolor=black align=center style='border-collapse: collapse;'>";
				mailMsgTop += "   <tr height=30 bgcolor='#cccccc'> ";
				mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>ȣ��</td> ";
				mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>���</td> ";
				mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
				mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
				mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>����No.</td> ";
				mailMsgTop += "       <td width=300 style='color:#336699; font-weight: bold;' align=center>����</td> ";
				mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>���źμ�</td> ";
				mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>������</td> ";
				mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>������</td> ";
				mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>�����</td> ";
				mailMsgTop += "   </tr> ";

				mailMsgBottom += "</table> ";
				mailMsgBottom += "<br>�� �׸� ���� �����Ǿ����� ȸ�� �� ������� �ٶ��ϴ�.";
				mailMsgBottom += "<br> (��� : PLM -> Actions -> Engineering -> Buyer/Class -> COMMENT RESULT MANAGEMENT)";

				String thisDate = "";

				Calendar cal_today = Calendar.getInstance(); 
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
				thisDate = sdf.format(cal_today.getTime()); 
				
				StringBuffer queryStr2 = new StringBuffer();
				queryStr2.append("SELECT INSA.USER_NAME,                                          \n");         // ó������ڸ�
				queryStr2.append("       INSA.DEPT_NAME,                                          \n");         // ó������ںμ�
				queryStr2.append("       INSA.EP_MAIL || '@onestx.com' AS EMAIL,                  \n");         // ó������� EMAIL
				queryStr2.append("      (SELECT INSA2.EP_MAIL || '@onestx.com'                    \n");         // ó������� ��Ʈ�� EMAIL
				queryStr2.append("         FROM STX_COM_INSA_USER INSA2                           \n");
				queryStr2.append("        WHERE INSA2.DEPT_CODE=INSA.DEPT_CODE                    \n");
				queryStr2.append("          AND INSA2.DEL_DATE IS NULL                            \n");
				queryStr2.append("          AND INSA2.JOB_NAM='��Ʈ��') AS PARTJANG_EMAIL         \n");
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

					while (rset2.next())
					{
						tempProcessPersonName = rset2.getString(1) == null ? "" : rset2.getString(1);       // ó������ڸ�
						tempProcessDept = rset2.getString(2) == null ? "" : rset2.getString(2);             // ó������ںμ�
						String tempEmail = rset2.getString(3) == null ? "" : rset2.getString(3);            // ó������� EMAIL
						String tempPartjangEmail = rset2.getString(4) == null ? "" : rset2.getString(4);    // ó������� ��Ʈ�� EMAIL

						if (!"".equals(tempEmail) && !toList.contains(tempEmail))
						{
							toList.add(tempEmail);
						}
						if (!"".equals(tempPartjangEmail) && !toList.contains(tempPartjangEmail))
						{
							toList.add(tempPartjangEmail);
						}
					}

					// ó�� ����ڴ� ���� ���Ź����� �ֱ⿡ UPDATE�ϰ�, ������ ����ڴ� �߰��� INSERT����.
					if(i==0)
					{
						StringBuffer queryStr = new StringBuffer();
						queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
						queryStr.append("   SET DESIGN_RECEIVE_FLAG = 'Y'                                            \n");      //����FLAG     
						queryStr.append("      ,DESIGN_RECEIVE_ACTION = '��������'                                   \n");      //���� ��ġ���� (��������)
						queryStr.append("      ,DESIGN_RECEIVE_DATE = SYSDATE                                        \n");      //������������
						queryStr.append("      ,DESIGN_RECEIVE_PERSON = '" +  sWorkUser + "'                         \n");      //����������
						queryStr.append("      ,DESIGN_RECEIVE_PERSON_NAME = '" +  sUserName + "'                    \n");      //���������ڸ�
						queryStr.append("      ,DESIGN_PROCESS_PERSON = '" +  tempProcessPerson + "'                 \n");      //ó�������
						queryStr.append("      ,DESIGN_PROCESS_PERSON_NAME = '" + tempProcessPersonName + "'         \n");      //ó������ڸ�
						queryStr.append("      ,DESIGN_PROCESS_DEPT = '" + tempProcessDept + "'                      \n");      //ó�����μ�
						queryStr.append("      ,STATUS = 'Open'                                                      \n");      //STATUS : Open
						queryStr.append("      ,COMMENT_MESSAGE = '" + sCommentMsg +"'                               \n");      //Comment
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

					} else {

						// SEQ_NO ���� :  STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL		
						String nextSequence = "";

						StringBuffer selectSeqQuery = new StringBuffer();
						selectSeqQuery.append("SELECT STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL  \n");
						selectSeqQuery.append("  FROM DUAL                               \n");

						rset = stmt1.executeQuery(selectSeqQuery.toString());
						if (rset.next()) nextSequence = rset.getString(1);

						StringBuffer insertQuery = new StringBuffer();
						insertQuery.append("INSERT INTO STX_OC_RECEIVE_DOCUMENT(               \n");
						insertQuery.append("	SEQ_NO,                                        \n");
						insertQuery.append("	PROJECT,                                       \n");
						insertQuery.append("	OWNER_CLASS_TYPE,                              \n");
						insertQuery.append("	SEND_RECEIVE_TYPE,                             \n");
						insertQuery.append("	DOC_TYPE,                                      \n");
						insertQuery.append("	REF_NO,                                        \n");
						insertQuery.append("	REV_NO,                                        \n");
						insertQuery.append("	SUBJECT,                                       \n");
						insertQuery.append("	SENDER,                                        \n");
						insertQuery.append("	SENDER_NO,                                     \n");
						insertQuery.append("	SEND_RECEIVE_DATE,                             \n");
						insertQuery.append("	SEND_RECEIVE_DEPT,                             \n");
						insertQuery.append("	REF_DEPT,                                      \n");
						insertQuery.append("	DESIGN_RECEIVE_FLAG,                           \n");
						insertQuery.append("	DESIGN_RECEIVE_DATE,                           \n");

						insertQuery.append("	STATUS,                                        \n");
						insertQuery.append("	DESIGN_RECEIVE_PERSON,                         \n");
						insertQuery.append("	DESIGN_PROCESS_PERSON,                         \n");

		
						insertQuery.append("	COMMENT_MESSAGE,                               \n");
						insertQuery.append("	DESIGN_PROCESS_DEPT,                           \n");
						insertQuery.append("	DESIGN_PROCESS_PERSON_NAME,                    \n");
						insertQuery.append("	DESIGN_RECEIVE_PERSON_NAME,                    \n");
						insertQuery.append("	DESIGN_RECEIVE_ACTION)                         \n");
						insertQuery.append("SELECT                                             \n");
						insertQuery.append("   '" + nextSequence + "',                         \n");     // SEQ_NO       
						insertQuery.append("	PROJECT,                                       \n");     // project
						insertQuery.append("	OWNER_CLASS_TYPE,                              \n");     // owner_class_type
						insertQuery.append("	SEND_RECEIVE_TYPE,                             \n");     // send_receive_type
						insertQuery.append("	DOC_TYPE,                                      \n");     // doc_type
						insertQuery.append("	REF_NO,                                        \n");     // ref_no
						insertQuery.append("	REV_NO,                                        \n");     // rev_no
						insertQuery.append("	SUBJECT,                                       \n");     // subject
						insertQuery.append("	SENDER,                                        \n");     // sender
						insertQuery.append("	SENDER_NO,                                     \n");     // SENDER_NO
						insertQuery.append("	SEND_RECEIVE_DATE,                             \n");     // SEND_RECEIVE_DATE
						insertQuery.append("	SEND_RECEIVE_DEPT,                             \n");     // SEND_RECEIVE_DEPT
						insertQuery.append("	REF_DEPT,                                      \n");     // REF_DEPT
						insertQuery.append("	'Y',                                           \n");     // DESIGN_RECEIVE_FLAG
						insertQuery.append("	SYSDATE,                                       \n");     // DESIGN_RECEIVE_DATE�� �ֽų�¥�� ����		
						insertQuery.append("	'Open',                                        \n");     // STATUS   :  'Open'
						insertQuery.append("	'" +  sWorkUser + "' ,                         \n");     // DESIGN_RECEIVE_PERSON
						insertQuery.append("	'" +  tempProcessPerson + "',                  \n");     // DESIGN_PROCESS_PERSON	
						insertQuery.append("	'" + sCommentMsg +"',                          \n");     // COMMENT_MESSAGE
						insertQuery.append("	'" + tempProcessDept + "',                     \n");     // DESIGN_PROCESS_DEPT
						insertQuery.append("	'" + tempProcessPersonName + "',               \n");     // DESIGN_PROCESS_PERSON_NAME
						insertQuery.append("	'" +  sUserName + "',                          \n");     // DESIGN_RECEIVE_PERSON_NAME
						insertQuery.append("	'��������'                                     \n");     //���� ��ġ���� (��������)
						insertQuery.append("FROM STX_OC_RECEIVE_DOCUMENT                       \n");  
						insertQuery.append("WHERE SEQ_NO = '" + sSelect_seq_no +"'             \n");   

						stmt.executeUpdate(insertQuery.toString());

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

				//��������
				/*** test
				ArrayList toList1 = new ArrayList();

				String toUser = "hanss@onestx.com";
				String toUser1 = "mg.oh@onestx.com";

				toList1.add(toUser);
				toList1.add(toUser1);
				***/
				// (��Ʈ��/ �����) �������� ���� ����
				if(toList.size()>0)
				{
					HashMap argsMap = new HashMap();
					argsMap.put("toList", toList);
					////argsMap.put("toList", toList1);
					argsMap.put("fromList", loginMail);

					mailMsg += mailMsgTop;  
					mailMsg += mailMsgMiddle;  
					mailMsg += mailMsgBottom;  

					argsMap.put("subject",mailSub);
					argsMap.put("message",mailMsg);

					//���� �κ� ��ü �ʿ�
					//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));
					com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );	

				} else {
					throw new Exception("No Mail Receiver !!");
				}
			}
			// // (��Ʈ��/ �����) ���������Ϸ� ���� ���ۿϷ�

            // �����ȹ ���� ����ڿ��Դ� �ݼ۸��� �뺸
			if(true)
			{

				// ���źμ������� �ڱ�μ�+Ÿ�μ�
				String allReceiveDept = selectReceiveDept+", "+sRevNoDeptList;

				ArrayList toList = new ArrayList();

				String toUser = "ddeoki@onestx.com";  // �����ȹ ���Ź��� upload ����� (����� ����)

				toList.add(toUser);
				
				// �����ȹ �ο� ���� ������ �߰�
				String toUser1 = "khhan@onestx.com";  // �Ѱ��� ����
				String toUser2 = "kimjunho@onestx.com";  // ����ȣ ����
				toList.add(toUser1);
				toList.add(toUser2);

				HashMap argsMap = new HashMap();
				argsMap.put("toList", toList);
				argsMap.put("fromList", loginMail);

				String mailSub = "";
				String mailMsg = "";

				mailSub = " [Ÿ�μ� �߰����� ���] "+selectProject+" ,  ������ȣ : "+select_rev_no;

				//mailMsg += "<br><p><font color='red'><strong>[Ÿ�μ� �߰����� ���]  "+selectProject+" ,  ������ȣ : "+select_rev_no+"</strong></font></p><br><br>";
				mailMsg += "<br><p><font color='red'><strong>[���Ź��� Ÿ�μ� ���� ��� ��Ȳ]</strong></font></p>";

				mailMsg += "<table width='100%' border=1 bordercolor=black align=center style='border-collapse: collapse;'>";
				mailMsg += "   <tr height=30 bgcolor='#cccccc'> ";
				mailMsg += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>ȣ��</td> ";
				mailMsg += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>���</td> ";
				mailMsg += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
				mailMsg += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>��������</td> ";
				mailMsg += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>����No.</td> ";
				mailMsg += "       <td width=300 style='color:#336699; font-weight: bold;' align=center>����</td> ";
				mailMsg += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>���źμ�</td> ";
				mailMsg += "   </tr> ";
				mailMsg += "   <tr height=30 bgcolor='#f5f5f5'> ";
				mailMsg += "       <td width=60  align=center>"+selectProject+"</td> ";
				mailMsg += "       <td width=60  align=center>"+selectOwnerClass+"</td> ";
				mailMsg += "       <td width=60  align=center>"+selectDocType+"</td> ";
				mailMsg += "       <td width=120  align=center>"+selectReceiveDate+"</td> ";
				mailMsg += "       <td width=120  align=center>"+selectRevNo+"</td> ";
				mailMsg += "       <td width=300  align=center>"+selectSubject+"</td> ";
				mailMsg += "       <td width=100  align=center>"+allReceiveDept+"</td> ";
				mailMsg += "   </tr> ";
				mailMsg += "</table> ";

				mailMsg += "<br>�� �׸� ���� �����Ͽ����� �Ʒ� Comments ���׿� ���� Ȯ�� �ٶ��ϴ�.";

				mailMsg += "<br><br><br><font color='blue'><strong>[Comments ����] : </strong></font>"+sCommentMsg;


				argsMap.put("subject",mailSub);
				argsMap.put("message",mailMsg);

				//���� �κ� ��ü �ʿ�
				//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));
				com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );

			}
			// �����ȹ ���� ����ڿ��Դ� �ݼ۸��� �뺸 �Ϸ�

		}
		


		DBConnect.commitJDBCTransaction(conn);

		resultMsg = "SUCCESS";




	}
    catch (Exception e) {
		DBConnect.rollbackJDBCTransaction(conn);
		e.printStackTrace();
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

<%
if(resultMsg.equals("SUCCESS")){%>
<script type="text/javascript">
window.returnValue = "SUCCESS";
self.close();
</script>
<%}%>