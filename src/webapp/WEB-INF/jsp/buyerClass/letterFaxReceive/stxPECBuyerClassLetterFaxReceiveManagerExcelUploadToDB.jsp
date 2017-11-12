
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "javax.activation.MimetypesFileTypeMap" %>
<%@ page import="java.io.*, java.text.SimpleDateFormat, java.sql.*"  %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.stx.migration.*" %>


<%@ page contentType="text/html; charset=euc-kr" %>


<%

    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");
    String loginMail = (String)loginUser.get("ep_mail");
    
	String PROJECT 		= "PROJECT";
	String OWNERCLASS 	= "OWNER/CLASS";
	String SENDRECEIVE 	= "SEND/RECEIVE";
	String RECEIVEDATE 	= "RECEIVE_DATE";
	String REFNO 		= "REF_NO";
	String REVNO 		= "REV_NO";
	String SUBJECT 		= "SUBJECT";
	String RECEIVEDEPT 	= "RECEIVE_DEPT";
	String CCDEPT 		= "CC_DEPT";
	String DOCTYPE 		= "DOC_TYPE";
	
    String sTempDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가

	MultipartRequest multi = new MultipartRequest(request, sTempDir, max_byte);	
	java.io.File fileObj1 = multi.getFile((String) multi.getFileNames().nextElement());

	String sDataFile = sTempDir + java.io.File.separator + fileObj1.getName();

	FKLDataMigrationCommonFileManager fileManager = null;
	ArrayList ArrayList = new ArrayList();
	
	try{
		fileManager = new FKLDataMigrationCommonFileManager(sDataFile, ".xls");
		FKLDataMigrationExcelLoader excelLoader = new FKLDataMigrationExcelLoader(fileManager);
		excelLoader.setTitleRowNum(1);
		excelLoader.setDataRowStartNum(2);
		
		File file = excelLoader.getFileAt(0);
		excelLoader.openWorkbook(file);
		try {
				// 모든 row (data)들을 읽어 중간 단계의 산출물인 Spec. 객체들을 생성한다.
				int startNum = excelLoader.getDataRowStartNum();
				int idx = 0;
				int i = 0;
				////System.out.println(excelLoader.getDataRowCount(i));
				for (int j = startNum; j < excelLoader.getDataRowCount(i) + startNum; j++) {
				// 해당 Row에 대한 Legacy Data를 읽어
					HashMap dataMap = excelLoader.getData(i, j);

					String itemCode = (String) dataMap.get(PROJECT);
                   	if(itemCode.equals("")){
						break; 
					} else {
						ArrayList.add(idx, dataMap);
                   		idx++;
					}
				}


		//System.out.println(ArrayList);
		}catch(Exception e) {
			//System.out.println("e = " + e);
		}
		finally {
			//excelLoader.closeWorkbook();
		}
	}catch(Exception e) {
		//System.out.println("e = " + e);
	}

	%>
<form name="tempForm" method="post" enctype="multipart/form-data">
	<Table border=\"0\">
	<tr height=30 bgcolor='#cccccc'>
		<td style='color:#336699; font-weight: bold;' align=center>PROJECT</td>
		<td style='color:#336699; font-weight: bold;' align=center>OWNERCLASS</td>
		<td style='color:#336699; font-weight: bold;' align=center>SENDRECEIVE</td>
		<td style='color:#336699; font-weight: bold;' align=center>RECEIVEDATE</td>
		<td style='color:#336699; font-weight: bold;' align=center>REFNO</td>
		<td style='color:#336699; font-weight: bold;' align=center>REVNO</td>
		<td style='color:#336699; font-weight: bold;' align=center>SUBJECT</td>
		<td style='color:#336699; font-weight: bold;' align=center>RECEIVEDEPT</td>
		<td style='color:#336699; font-weight: bold;' align=center>CCDEPT</td>
		<td style='color:#336699; font-weight: bold;' align=center>DOCTYPE</td>
		<td style='color:#336699; font-weight: bold;' align=center>STATUS</td>
	</tr>
	<%
	String errMsg = "";
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	Connection conn1 = com.stx.common.interfaces.DBConnect.getDBConnection("ERP_APPS");
	java.sql.PreparedStatement docInsertPstmt = null;
	java.sql.PreparedStatement docInsertPstmt1 = null;

	java.sql.Statement stmt = null;
	java.sql.PreparedStatement pstmt = null;
	java.sql.PreparedStatement pstmt1 = null;
	java.sql.ResultSet rset = null;
	java.sql.ResultSet rset1 = null;
	
	conn.setAutoCommit(false);
	try 
	{

		StringBuffer selectQuery = new StringBuffer();
		selectQuery.append("SELECT STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL FROM DUAL  \n");

		stmt = conn.createStatement();
		rset = stmt.executeQuery(selectQuery.toString());

		// UPLOAD 수신문서 저장 후에 저장된 대상을 부서별로 그룹지어 팀장/파트장에게 메일 보내기 위함. 이번에 저장된 리스트만 뽑기위한 SEQ_NO
		String searchSeqNo = "";  
		if(rset.next())
		{
			searchSeqNo = rset.getString(1);

		}
		rset.close();		

		StringBuffer docInsertQuery = new StringBuffer();
		StringBuffer docInsertQuery1 = new StringBuffer();

		// 수신문서 접수 및 실적관리 테이블에 수신 문서 저장
		docInsertQuery.append("insert into STX_OC_RECEIVE_DOCUMENT( ");
		docInsertQuery.append("	SEQ_NO, ");
		docInsertQuery.append("	project, ");
		docInsertQuery.append("	owner_class_type, ");
		docInsertQuery.append("	send_receive_type, ");
		docInsertQuery.append("	doc_type, ");
		docInsertQuery.append("	ref_no, ");
		docInsertQuery.append("	rev_no, ");
		docInsertQuery.append("	subject, ");
		docInsertQuery.append("	sender, ");
		docInsertQuery.append("	send_receive_date, ");
		docInsertQuery.append("	send_receive_dept, ");
		docInsertQuery.append("	ref_dept, ");
		docInsertQuery.append("	keyword, ");
		docInsertQuery.append("	view_access)");
		docInsertQuery.append("VALUES (");
		docInsertQuery.append("	STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL, ");           // SEQ_NO       
		docInsertQuery.append("	?, ");                                           // project
		docInsertQuery.append("	?, ");                                           // owner_class_type
		docInsertQuery.append("	?, ");                                           // send_receive_type
		docInsertQuery.append("	?, ");                                           // doc_type
		docInsertQuery.append("	?, ");                                           // ref_no
		docInsertQuery.append("	?, ");                                           // rev_no
		docInsertQuery.append("	?, ");                                           // subject
		docInsertQuery.append("	'', ");                                          // sender
		docInsertQuery.append("	to_date(? , 'yyyy-mm-dd'), ");                   // send_receive_date
		docInsertQuery.append("	?, ");                                           // send_receive_dept
		docInsertQuery.append("	?, ");                                           // ref_dept
		docInsertQuery.append("	'', ");                                          // keyword
		docInsertQuery.append("	'' ) ");                                         // view_access


		// 기존 수발신 문서 저장 table에도 수신문서 저장해줌..
		docInsertQuery1.append("insert into stx_oc_document_list( ");
		docInsertQuery1.append("	project, ");
		docInsertQuery1.append("	owner_class_type, ");
		docInsertQuery1.append("	send_receive_type, ");
		docInsertQuery1.append("	doc_type, ");
		docInsertQuery1.append("	ref_no, ");
		docInsertQuery1.append("	rev_no, ");
		docInsertQuery1.append("	subject, ");
		docInsertQuery1.append("	sender, ");
		docInsertQuery1.append("	send_receive_date, ");
		docInsertQuery1.append("	send_receive_dept, ");
		docInsertQuery1.append("	ref_dept, ");
		docInsertQuery1.append("	keyword, ");
		docInsertQuery1.append("	view_access)");
		docInsertQuery1.append("VALUES (");
		docInsertQuery1.append("	?, ");                                           // project
		docInsertQuery1.append("	?, ");                                           // owner_class_type
		docInsertQuery1.append("	?, ");                                           // send_receive_type
		docInsertQuery1.append("	?, ");                                           // doc_type
		docInsertQuery1.append("	?, ");                                           // ref_no
		docInsertQuery1.append("	?, ");                                           // rev_no
		docInsertQuery1.append("	?, ");                                           // subject
		docInsertQuery1.append("	'', ");                                          // sender
		docInsertQuery1.append("	to_date(? , 'yyyy-mm-dd'), ");                   // send_receive_date
		docInsertQuery1.append("	?, ");                                           // send_receive_dept
		docInsertQuery1.append("	?, ");                                           // ref_dept
		docInsertQuery1.append("	'', ");                                          // keyword
		docInsertQuery1.append("	'' ) ");                                         // view_access


		StringBuffer teamCheckQuery = new StringBuffer();
		teamCheckQuery.append("SELECT DISTINCT TEAM_NAME                              \n");
		teamCheckQuery.append("  FROM STX_COM_INSA_DEPT                               \n");
		teamCheckQuery.append(" WHERE USE_YN='Y'                                      \n");
		teamCheckQuery.append("   AND TEAM_NAME = ?                                   \n");
		teamCheckQuery.append("UNION ALL                                              \n");
		teamCheckQuery.append("SELECT DISTINCT DEPT_NAME                              \n");
		teamCheckQuery.append("  FROM STX_COM_INSA_DEPT                               \n");
		teamCheckQuery.append(" WHERE USE_YN='Y'                                      \n");
		teamCheckQuery.append("   AND DEPT_NAME = ?                                   \n");		


		docInsertPstmt = conn.prepareStatement(docInsertQuery.toString());
		docInsertPstmt1 = conn.prepareStatement(docInsertQuery1.toString());
		pstmt1 = conn1.prepareStatement(teamCheckQuery.toString());
		
		for(int i = 0; i< ArrayList.size(); i++){
			HashMap table = (HashMap) ArrayList.get(i);	

			String sProject 		= (String)table.get(PROJECT);
			String sOwnerClass 		= (String)table.get(OWNERCLASS);
			String sSendReceive 	= (String)table.get(SENDRECEIVE);
			String sReceiveDate 	= (String)table.get(RECEIVEDATE);
			String sRefNo 			= (String)table.get(REFNO);
			String sRevNo 			= (String)table.get(REVNO);
			String sSubject 		= (String)table.get(SUBJECT);
			String sReceiveDept 	= (String)table.get(RECEIVEDEPT);
			String sCCDept 			= (String)table.get(CCDEPT);
			String sDocType 		= (String)table.get(DOCTYPE);
			String sStatus			= "SUCCESS";
			
			sProject = sProject.toUpperCase();   // 호선명 대문자로 치환

			// 2012-08-18 Kang seonjung : 신규 수신문서관리 테이블에 저장시는 수신부서가 여러개일 경우 부서별로 나눠서 insert해줌.
			boolean teamCheckError = false;
			StringTokenizer sToken = new StringTokenizer(sReceiveDept,",");

			while(sToken.hasMoreTokens())
			{
				String tempReceiveDept = sToken.nextToken();
				String tempReceiveDeptTrim = tempReceiveDept.trim();

				if("".equals(tempReceiveDeptTrim)) continue;	
				
				//기술기획에서 엑셀로 수신문서 upload 시에 '팀' 자를 생략하고 올리는 경우가 많아서 없으면 팀자 붙여서 저장.. (예:기술기획팀인데 기술기획까지만)
				//본부 - 팀 - 파트가 일반적이나, 본부 - 파트로 구성된 경우를 위해 P로 등록되면 P로 처리
				if("P".equals(tempReceiveDeptTrim.substring(tempReceiveDeptTrim.length()-1)))
				{
					tempReceiveDeptTrim = tempReceiveDeptTrim;
				}else if(!"팀".equals(tempReceiveDeptTrim.substring(tempReceiveDeptTrim.length()-1)))
				{
					tempReceiveDeptTrim += "팀";
				}
				
				// 2015-08-21 : 기술전략센터는 특이하게 팀인데 팀으로 안 끝나서 하드코딩.
				if(tempReceiveDeptTrim.lastIndexOf("기술전략센터") > -1)
				{
					tempReceiveDeptTrim = "기술전략센터";
				}
				
				// 2016-01-21 : 기술지원센터는 특이하게 팀인데 팀으로 안 끝나서 하드코딩.
				if(tempReceiveDeptTrim.lastIndexOf("기술지원센터") > -1)
				{
					tempReceiveDeptTrim = "기술지원센터";
				}				

				pstmt1.setString(1, tempReceiveDeptTrim);
				pstmt1.setString(2, tempReceiveDeptTrim);
				rset1 = pstmt1.executeQuery();
				if(!rset1.next())
				{
					teamCheckError = true;
					break;                        
				}

				docInsertPstmt.setString(1, sProject);
				docInsertPstmt.setString(2, sOwnerClass);
				docInsertPstmt.setString(3, sSendReceive);
				docInsertPstmt.setString(4, sDocType);
				docInsertPstmt.setString(5, sRefNo);
				docInsertPstmt.setString(6, sRevNo);
				docInsertPstmt.setString(7, sSubject);
				docInsertPstmt.setString(8, sReceiveDate);
				docInsertPstmt.setString(9, tempReceiveDeptTrim);
				docInsertPstmt.setString(10, sCCDept);

				try{
					docInsertPstmt.executeUpdate();

				}catch(Exception e) {
					e.printStackTrace();
					sStatus = e.getMessage();
				}
			}

			if(teamCheckError)
			{
				sStatus = "ERROR : TEAM NAME ERROR.. ";
				conn.rollback();
			} else {
				// 기존 수발신 문서 저장 table에도 수신문서 저장해줌..
				docInsertPstmt1.setString(1, sProject);
				docInsertPstmt1.setString(2, sOwnerClass);
				docInsertPstmt1.setString(3, sSendReceive);
				docInsertPstmt1.setString(4, sDocType);
				docInsertPstmt1.setString(5, sRefNo);
				docInsertPstmt1.setString(6, sRevNo);
				docInsertPstmt1.setString(7, sSubject);
				docInsertPstmt1.setString(8, sReceiveDate);
				docInsertPstmt1.setString(9, sReceiveDept);
				docInsertPstmt1.setString(10, sCCDept);

				try{
					docInsertPstmt1.executeUpdate();

					conn.commit();
				}catch(Exception e) {
					e.printStackTrace();
					sStatus = e.getMessage();
				}
			}

			String strBgcolor = "";

			if(!"SUCCESS".equals(sStatus))
			{
				strBgcolor = "red";
			}				
			
			%>
			<TR bgcolor="<%=strBgcolor%>">
				<TD> <%=sProject%> 	&nbsp; </TD>    
				<TD> <%=sOwnerClass%> 	&nbsp; </TD> 
				<TD> <%=sSendReceive%> 	&nbsp; </TD>
				<TD> <%=sReceiveDate%> 	&nbsp; </TD>
				<TD> <%=sRefNo%> 	&nbsp; </TD>      
				<TD> <%=sRevNo%> 	&nbsp; </TD>      
				<TD> <%=sSubject%> 	&nbsp; </TD>    
				<TD> <%=sReceiveDept%> 	&nbsp; </TD>
				<TD> <%=sCCDept%> 	&nbsp; </TD>     
				<TD> <%=sDocType%> 	&nbsp; </TD>
				<TD> <%=sStatus%> 	&nbsp; </TD>
			</TR>
			<%
			
		}//End of For


		/////// UPLOAD된 수신문서를 팀별로 묶어서 팀장,파트장에게 메일 보내기 시작

		// 대상 추출
		StringBuffer selectQuery1 = new StringBuffer();
		selectQuery1.append("SELECT PROJECT,                                                                     \n");   // 호선
		selectQuery1.append("       OWNER_CLASS_TYPE,                                                            \n");   // Owner / Class
		selectQuery1.append("       DOC_TYPE,                                                                    \n");   // 문서종류
		selectQuery1.append("       TO_CHAR(SEND_RECEIVE_DATE,'YYYY-MM-DD')  AS SEND_RECEIVE_DATE,               \n");   // 수신문서 수신일자
		selectQuery1.append("       REV_NO,                                                                      \n");   // 수신문서 접수번호
		selectQuery1.append("       SUBJECT,                                                                     \n");   // 수신문서 제목
		selectQuery1.append("       SEND_RECEIVE_DEPT                                                            \n");   // 수신부서
		selectQuery1.append("  FROM STX_OC_RECEIVE_DOCUMENT                                                      \n");
		selectQuery1.append(" WHERE SEQ_NO >= '" + searchSeqNo +"'                                               \n");   
		selectQuery1.append(" ORDER BY SEND_RECEIVE_DEPT, PROJECT, REV_NO                                        \n");   

		StringBuffer selectQuery2 = new StringBuffer();
		selectQuery2.append("SELECT INSA.EP_MAIL || '@onestx.com' AS EMAIL                                       \n");
		selectQuery2.append("  FROM STX_COM_INSA_USER INSA,                                                      \n");
		selectQuery2.append("       STX_COM_INSA_DEPT DEPT                                                       \n");
		selectQuery2.append(" WHERE INSA.DEPT_CODE = DEPT.DEPT_CODE                                              \n");
		selectQuery2.append("    AND INSA.DEL_DATE IS NULL                                                       \n");
		selectQuery2.append("    AND INSA.JOB_NAM IN ('팀장','파트장')                                           \n");
		selectQuery2.append("    AND DEPT.TEAM_NAME = ?                                                          \n");
		selectQuery2.append("UNION ALL                                                                           \n");
		selectQuery2.append("SELECT INSA.EP_MAIL || '@onestx.com' AS EMAIL                                       \n");
		selectQuery2.append("  FROM STX_COM_INSA_USER INSA,                                                      \n");
		selectQuery2.append("       STX_COM_INSA_DEPT DEPT                                                       \n");
		selectQuery2.append(" WHERE INSA.DEPT_CODE = DEPT.DEPT_CODE                                              \n");
		selectQuery2.append("    AND INSA.DEL_DATE IS NULL                                                       \n");
		selectQuery2.append("    AND INSA.JOB_NAM IN ('팀장','파트장')                                           \n");
		selectQuery2.append("    AND DEPT.DEPT_NAME = ?                                                          \n");		
		
		rset = stmt.executeQuery(selectQuery1.toString());

		ArrayList resultArrayList = new ArrayList();
		
		while(rset.next())
		{
			HashMap resultMap = new HashMap();
			resultMap.put("PROJECT", rset.getString(1) == null ? "" : rset.getString(1));
			resultMap.put("OWNER_CLASS_TYPE", rset.getString(2) == null ? "" : rset.getString(2));
			resultMap.put("DOC_TYPE", rset.getString(3) == null ? "" : rset.getString(3));
			resultMap.put("SEND_RECEIVE_DATE", rset.getString(4) == null ? "" : rset.getString(4));
			resultMap.put("REV_NO", rset.getString(5) == null ? "" : rset.getString(5));
			resultMap.put("SUBJECT", rset.getString(6) == null ? "" : rset.getString(6));
			resultMap.put("SEND_RECEIVE_DEPT", rset.getString(7) == null ? "" : rset.getString(7));
			resultArrayList.add(resultMap);
		}

		rset.close();

		pstmt = conn1.prepareStatement(selectQuery2.toString());

		if(resultArrayList.size() > 0)
		{
			String lastTeamName = "";

			String mailSub = "   [수신문서 배포현황 및 접수 요청] ";
			String mailMsg = "";
			String mailMsgTop = "";
			String mailMsgMiddle = "";
			String mailMsgBottom = "";

			mailMsgTop += "<br><p><font color='red'><strong>[수신문서 배포 현황]</strong></font></p>";	
			mailMsgTop += "<table width='100%' border=1 bordercolor=black align=center style='border-collapse: collapse;'>";
			mailMsgTop += "   <tr height=30 bgcolor='#cccccc'> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>호선</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>대상</td> ";
			mailMsgTop += "       <td width=60 style='color:#336699; font-weight: bold;' align=center>문서종류</td> ";
			mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>수신일자</td> ";
			mailMsgTop += "       <td width=120 style='color:#336699; font-weight: bold;' align=center>접수No.</td> ";
			mailMsgTop += "       <td width=300 style='color:#336699; font-weight: bold;' align=center>제목</td> ";
			mailMsgTop += "       <td width=100 style='color:#336699; font-weight: bold;' align=center>수신부서</td> ";
			mailMsgTop += "   </tr> ";

			mailMsgBottom += "</table> ";
			mailMsgBottom += "<br>위 항목에 대해 배포되었으니 확인 후 접수 조치 바랍니다.";
			mailMsgBottom += "<br> (경로 : PLM -> Actions -> Engineering -> Buyer/Class -> COMMENT RESULT MANAGEMENT)";


			for(int k=0; k < resultArrayList.size(); k++)
			{
                Map tempResultMap = (Map)resultArrayList.get(k);
                String tempproject = (String)tempResultMap.get("PROJECT");
                String tempowner_class_type = (String)tempResultMap.get("OWNER_CLASS_TYPE");                
                String tempdoc_type = (String)tempResultMap.get("DOC_TYPE");
                String tempsend_receive_date = (String)tempResultMap.get("SEND_RECEIVE_DATE");
                String temprev_no = (String)tempResultMap.get("REV_NO");                
                String tempsubject = (String)tempResultMap.get("SUBJECT");
				String tempsend_receive_dept = (String)tempResultMap.get("SEND_RECEIVE_DEPT");

				if(k==0)
				{
					lastTeamName = tempsend_receive_dept;
				} else if(!lastTeamName.equals(tempsend_receive_dept))
				{
					// 부서가 변경이 된 경우 메일 전송
					mailMsg += mailMsgTop;  
					mailMsg += mailMsgMiddle;  
					mailMsg += mailMsgBottom;  

					ArrayList toList = new ArrayList();

                    pstmt.setString(1, lastTeamName);
                    pstmt.setString(2, lastTeamName);
                    rset = pstmt.executeQuery();

					while (rset.next())
					{
						toList.add(rset.getString(1) == null ? "" : rset.getString(1));
					}


					// 담당자, 파트장 메일주소 추출 완료

					/*** TEST
					ArrayList toList1 = new ArrayList();

					String toUser = "ksj0107@onestx.com";
					String toUser1 = "yunjaelee@onestx.com";

					toList1.add(toUser);
					toList1.add(toUser1); 
					***/

					HashMap argsMap = new HashMap();
					argsMap.put("toList", toList);
					//argsMap.put("toList", toList1);
					argsMap.put("fromList", loginMail);
					argsMap.put("subject",mailSub);
					argsMap.put("message",mailMsg);

					// DIS-ERROR : 메일 부분 대체 필요
					//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));					
					com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );					

					// 메일 전송 후 내용 초기화
					mailMsg = "";
					mailMsgMiddle = "";

					lastTeamName = tempsend_receive_dept;

				}

				mailMsgMiddle += "   <tr height=30 bgcolor='#f5f5f5'> ";
				mailMsgMiddle += "       <td width=60  align=center>"+tempproject+"</td> ";
				mailMsgMiddle += "       <td width=60  align=center>"+tempowner_class_type+"</td> ";
				mailMsgMiddle += "       <td width=60  align=center>"+tempdoc_type+"</td> ";
				mailMsgMiddle += "       <td width=120  align=center>"+tempsend_receive_date+"</td> ";
				mailMsgMiddle += "       <td width=120  align=center>"+temprev_no+"</td> ";
				mailMsgMiddle += "       <td width=300  align=center>"+tempsubject+"</td> ";
				mailMsgMiddle += "       <td width=100  align=center>"+tempsend_receive_dept+"</td> ";
				mailMsgMiddle += "   </tr> ";				

				//대상이 한 건 뿐인 경우나 마지막의 대상 건의 경우 처리안되는 문제 해결
				if((k+1) == resultArrayList.size())
				{
					// 부서가 변경이 된 경우 메일 전송

					mailMsg += mailMsgTop;  
					mailMsg += mailMsgMiddle;  
					mailMsg += mailMsgBottom;  

					ArrayList toList = new ArrayList();

                    pstmt.setString(1, lastTeamName);
                    pstmt.setString(2, lastTeamName);
                    rset = pstmt.executeQuery();

					while (rset.next())
					{
						toList.add(rset.getString(1) == null ? "" : rset.getString(1));
					}

					// 담당자, 파트장 메일주소 추출 완료

					/*** TEST 
					ArrayList toList1 = new ArrayList();

					String toUser = "ksj0107@onestx.com";
					String toUser1 = "yunjaelee@onestx.com";

					toList1.add(toUser);
					toList1.add(toUser1);
					***/

					HashMap argsMap = new HashMap();
					argsMap.put("toList", toList);
					argsMap.put("fromList", loginMail);
					//argsMap.put("toList", toList1);
					argsMap.put("subject",mailSub);
					argsMap.put("message",mailMsg);

					// DIS-ERROR : 메일 부분 대체 필요
					//JPO.invoke(context, "emxMailUtil", null, "sendEmailWithFullAddress", JPO.packArgs(argsMap));					
					com.stxdis.util.util.MailAction.sendEmailWithFullAddress( argsMap );					
					// 메일 전송 후 내용 초기화
					mailMsg = "";
					mailMsgMiddle = "";

					lastTeamName = tempsend_receive_dept;

				}
			}		

		}
		DBConnect.commitJDBCTransaction(conn);

		
	}catch(Exception ex) {
		errMsg = ex.getMessage();
		ex.printStackTrace();
		out.println("Exception ocuured B!!");
		out.println("Exception e = " + ex + "<br>");
	} finally {		
		if(rset!=null)
			rset.close();
		if(rset1!=null)
			rset1.close();		
		if(stmt!=null)
			stmt.close();
		if(pstmt!=null)
			pstmt.close();	
		if(pstmt1!=null)
			pstmt1.close();			
		if(docInsertPstmt!=null)
			docInsertPstmt.close();
		if(docInsertPstmt1!=null)
			docInsertPstmt1.close();
		if(conn!=null)
			conn.close();
		if(conn1!=null)
			conn1.close();
	}// End of Try

%>
	</TABLE>
</form>

<script language="javascript">
	<%if(!"".equals(errMsg)){%>
		alert("<%=errMsg%>");
	<%}else{%>
		alert("UPLOAD FINISHED!");
	<%}%>
</script>

