<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>

<%--========================== JSP =========================================--%>
<%!
	public static String isNullString(String checkString){
		if(checkString==null || "null".equalsIgnoreCase(checkString) || "".equals(checkString) || "undefined".equals(checkString)){
			return "";
		}else{
			return checkString;
		}
	}
%>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
try{
	String project 				= isNullString(request.getParameter("project"));
	String sendReceiveType 		= isNullString(request.getParameter("sendReceiveType"));
	String docType 				= isNullString(request.getParameter("docType"));
	String refNo 				= isNullString(request.getParameter("refNo"));
	String revNo 				= isNullString(request.getParameter("revNo"));
	String subject 				= isNullString(request.getParameter("subject"));
	String sender 				= isNullString(request.getParameter("sender"));	
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String senderNo = (String)loginUser.get("user_id");		
	String sendReceiveDate		= isNullString(request.getParameter("sendReceiveDate"));
	String sendReceiveDept		= isNullString(request.getParameter("sendReceiveDept"));
	String refDept				= isNullString(request.getParameter("refDept"));
	String keyword				= isNullString(request.getParameter("keyword"));
	String viewAccess			= isNullString(request.getParameter("viewAccess"));
	
	String objectType			= isNullString(request.getParameter("objectType"));
	String objectNo				= isNullString(request.getParameter("objectNo"));
	String objectComment		= isNullString(request.getParameter("objectComment"));
	
	String mode 				= isNullString(request.getParameter("mode"));
	
	String dwgAppSubmit			= isNullString(request.getParameter("dwgAppSubmit"));
	String ownerClassType		= isNullString(request.getParameter("ownerClassType"));
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	conn.setAutoCommit(false);

	if("doc".equals(mode)){
		StringBuffer docInsertQuery = new StringBuffer();
		docInsertQuery.append("insert into stx_oc_document_list( ");
		docInsertQuery.append("	project, ");
		docInsertQuery.append("	owner_class_type, ");
		docInsertQuery.append("	send_receive_type, ");
		docInsertQuery.append("	doc_type, ");
		docInsertQuery.append("	ref_no, ");
		docInsertQuery.append("	rev_no, ");
		docInsertQuery.append("	subject, ");
		docInsertQuery.append("	sender, ");
		docInsertQuery.append("	sender_no, ");
		docInsertQuery.append("	send_receive_date, ");
		docInsertQuery.append("	send_receive_dept, ");
		docInsertQuery.append("	ref_dept, ");
		docInsertQuery.append("	keyword, ");
		docInsertQuery.append("	view_access)");
		docInsertQuery.append("VALUES (");
		docInsertQuery.append("	'"+project+"', "); 
		docInsertQuery.append("	'"+ownerClassType+"', ");
		docInsertQuery.append("	'"+sendReceiveType+"', ");
		docInsertQuery.append("	'"+docType+"', ");
		docInsertQuery.append("	'"+refNo+"', ");
		docInsertQuery.append("	'"+revNo+"', ");
		docInsertQuery.append("	?, ");
		docInsertQuery.append("	'"+sender+"', ");
		docInsertQuery.append("	'"+senderNo+"', ");
		docInsertQuery.append("	sysdate, ");
		docInsertQuery.append("	'"+sendReceiveDept+"', ");
		docInsertQuery.append("	'"+refDept+"', ");
		docInsertQuery.append("	?, ");
		docInsertQuery.append("	'"+viewAccess+"' ) ");
		
		java.sql.CallableStatement docInsertCstmt = conn.prepareCall(docInsertQuery.toString());
      	
		docInsertCstmt.setString(1, subject);
		docInsertCstmt.setString(2, keyword);
      	
		docInsertCstmt.executeUpdate();
		
		//Statement stmt = conn.createStatement();
		//stmt.executeQuery(docInsertQuery.toString());
		
		conn.commit();
		
		if(docInsertCstmt!=null)
			docInsertCstmt.close();
		if(conn!=null)
			conn.close();
	}else if("receivemanagerdoc".equals(mode)){

	 
		StringBuffer docInsertQuery = new StringBuffer();
		StringBuffer docInsertQuery1 = new StringBuffer();

		// 2012-08-13 Kang seonjung : 수신문서 저장 table 수정
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
		docInsertQuery.append("	sender_no, ");
		docInsertQuery.append("	send_receive_date, ");
		docInsertQuery.append("	send_receive_dept, ");
		docInsertQuery.append("	ref_dept, ");
		docInsertQuery.append("	keyword, ");
		docInsertQuery.append("	view_access)");
		docInsertQuery.append("VALUES (");
		docInsertQuery.append("	STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL, "); 
		docInsertQuery.append("	'"+project+"', "); 
		docInsertQuery.append("	'"+ownerClassType+"', ");
		docInsertQuery.append("	'"+sendReceiveType+"', ");
		docInsertQuery.append("	'"+docType+"', ");
		docInsertQuery.append("	'"+refNo+"', ");
		docInsertQuery.append("	'"+revNo+"', ");
		docInsertQuery.append("	?, ");
		docInsertQuery.append("	'"+sender+"', ");
		docInsertQuery.append("	'"+senderNo+"', ");
		docInsertQuery.append("	to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), ");
		docInsertQuery.append("	?, ");
		docInsertQuery.append("	'"+refDept+"', ");
		docInsertQuery.append("	?, ");
		docInsertQuery.append("	'"+viewAccess+"' ) ");


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
		docInsertQuery1.append("	sender_no, ");
		docInsertQuery1.append("	send_receive_date, ");
		docInsertQuery1.append("	send_receive_dept, ");
		docInsertQuery1.append("	ref_dept, ");
		docInsertQuery1.append("	keyword, ");
		docInsertQuery1.append("	view_access)");
		docInsertQuery1.append("VALUES (");
		docInsertQuery1.append("	'"+project+"', ");                                     // project             
		docInsertQuery1.append("	'"+ownerClassType+"', ");							   // owner_class_type    
		docInsertQuery1.append("	'"+sendReceiveType+"', ");							   // send_receive_type   
		docInsertQuery1.append("	'"+docType+"', ");									   // doc_type            
		docInsertQuery1.append("	'"+refNo+"', ");									   // ref_no              
		docInsertQuery1.append("	'"+revNo+"', ");									   // rev_no              
		docInsertQuery1.append("	?, ");												   // subject             
		docInsertQuery1.append("	'"+sender+"', ");									   // sender              
		docInsertQuery1.append("	'"+senderNo+"', ");									   // senderNo
		docInsertQuery1.append("	to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), ");	   // send_receive_date   
		docInsertQuery1.append("	?, ");												   // send_receive_dept   
		docInsertQuery1.append("	'"+refDept+"', ");									   // ref_dept            
		docInsertQuery1.append("	?, ");												   // keyword             
		docInsertQuery1.append("	'"+viewAccess+"' ) ");								   // view_access        

		
		java.sql.PreparedStatement docInsertCstmt = conn.prepareStatement(docInsertQuery.toString());
		java.sql.PreparedStatement docInsertCstmt1 = conn.prepareStatement(docInsertQuery1.toString());

		//System.out.println("########  sendReceiveDept  =  "+sendReceiveDept);

		// 2012-08-18 Kang seonjung : 수신부서가 여러개일 경우 부서별로 나눠서 insert해줌.
		StringTokenizer sToken = new StringTokenizer(sendReceiveDept,",");
		while(sToken.hasMoreTokens()){
			String tempSendReceiveDept = sToken.nextToken();
			String tempSendReceiveDeptTrim = tempSendReceiveDept.trim();

			if("".equals(tempSendReceiveDeptTrim)) continue;
      	
			docInsertCstmt.setString(1, subject);
			docInsertCstmt.setString(2, tempSendReceiveDeptTrim);
			docInsertCstmt.setString(3, keyword);
			
			docInsertCstmt.executeUpdate();
		}


		// 기존 수발신 문서 저장 table에도 수신문서 저장해줌..		
		docInsertCstmt1.setString(1, subject);
		docInsertCstmt1.setString(2, sendReceiveDept);
		docInsertCstmt1.setString(3, keyword);
		
		docInsertCstmt1.executeUpdate();

		conn.commit();
		
		if(docInsertCstmt!=null)
			docInsertCstmt.close();
		if(docInsertCstmt1!=null)
			docInsertCstmt1.close();
		if(conn!=null)
			conn.close();
	}else if("refdoc".equals(mode)){
		StringBuffer docInsertQuery = new StringBuffer();
		docInsertQuery.append("insert into stx_oc_ref_object( ");
		docInsertQuery.append("	project, ");
		docInsertQuery.append("	ref_no, ");
		docInsertQuery.append("	object_type, ");
		docInsertQuery.append("	object_no, ");
		docInsertQuery.append("	object_comment)");
		docInsertQuery.append("VALUES (");
		docInsertQuery.append("	'"+project+"', "); 
		if("receive".equals(sendReceiveType)){
			docInsertQuery.append("	'"+revNo+"', ");
		}else{
			docInsertQuery.append("	'"+refNo+"', ");
		}
		docInsertQuery.append("	'"+objectType+"', ");
		docInsertQuery.append("	'"+objectNo+"', ");
		docInsertQuery.append("	'"+objectComment+"') ");
		
		//System.out.println(docInsertQuery.toString());
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(docInsertQuery.toString());
		
		conn.commit();

		//System.out.println("objectType = "+objectType);
		//System.out.println("dwgAppSubmit = "+dwgAppSubmit);
		//System.out.println("ownerClassType = "+ownerClassType);
		// 관련도면등록이고 App. Submit 값이 있고 checked인 경우(Letter/Fax Status Input 화면에서 Call 된 경우만 해당됨) DP공정실적을 업데이트
		if ("drawing".equals(objectType) && "true".equals(dwgAppSubmit))
        {
            StringBuffer sbSql = new StringBuffer();
            // 선주승인 발송문서 등록인 경우 - 기본도: 선주승인발송(OW Start) / Maker도면: 선주승인발송(CL Start)
            if ("owner".equals(ownerClassType))
            {
            	sbSql.append("UPDATE PLM_ACTIVITY \n");
            	if(sendReceiveDate != null && !sendReceiveDate.equals("") && !sendReceiveDate.equals("null") && !sendReceiveDate.equals("undefine"))
           		{
           			sbSql.append("   SET ACTUALSTARTDATE = to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), \n");
           		} else {
           			sbSql.append("   SET ACTUALSTARTDATE = TRUNC(SYSDATE), \n");
           		}
            	sbSql.append("       ATTRIBUTE4 = 'LETTER/FAX' \n");
            	sbSql.append(" WHERE 1 = 1   \n");
            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
            	sbSql.append("   AND (    (DWGCATEGORY = 'B' AND DWGTYPE <> 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'OW') OR \n");
            	sbSql.append("            (DWGCATEGORY = 'B' AND DWGTYPE = 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'CL') \n");
            	sbSql.append("       ) \n");
            	sbSql.append("   AND ACTUALSTARTDATE IS NULL   \n");
            }
            else if ("class".equals(ownerClassType))
            {
            	sbSql.append("UPDATE PLM_ACTIVITY \n");
            	if(sendReceiveDate != null && !sendReceiveDate.equals("") && !sendReceiveDate.equals("null") && !sendReceiveDate.equals("undefine"))
           		{
           			sbSql.append("   SET ACTUALSTARTDATE = to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), \n");
           		} else {
           			sbSql.append("   SET ACTUALSTARTDATE = TRUNC(SYSDATE), \n");
           		}
            	sbSql.append("       ATTRIBUTE4 = 'LETTER/FAX' \n");
            	sbSql.append(" WHERE 1 = 1 \n");
            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
            	sbSql.append("   AND DWGCATEGORY = 'B' \n");
            	sbSql.append("   AND DWGTYPE <> 'V' \n");
            	sbSql.append("   AND ACTIVITYCODE = '" + objectNo + "' || 'CL' \n");
            	sbSql.append("   AND ACTUALSTARTDATE IS NULL \n");
            }
			
			java.sql.Statement stmt2 = null;
			try 
            {
				stmt2 = conn.createStatement();
				stmt2.executeUpdate(sbSql.toString());				
				conn.commit();
			} 
            finally 
            {
				if (stmt2 != null) stmt2.close();
			}
		}
		
		if(stmt!=null)
			stmt.close();
		if(conn!=null)
			conn.close();
		
	}else if("keyword".equals(mode)){
		StringBuffer docUpdateQuery = new StringBuffer();
		docUpdateQuery.append("update stx_oc_document_list ");
		docUpdateQuery.append("	  set keyword = '"+keyword+"' ");
		if("send".equals(sendReceiveType)){
			docUpdateQuery.append("	where ref_no = '"+refNo+"' ");
		}else if("receive".equals(sendReceiveType)){
			docUpdateQuery.append("	where rev_no = '"+revNo+"' ");
		}else{
			docUpdateQuery.append("	where 1=2 ");
		}
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(docUpdateQuery.toString());
		
		conn.commit();
		
		if(stmt!=null)
			stmt.close();
		if(conn!=null)
			conn.close();
	}else if("subject".equals(mode)){
		StringBuffer docUpdateQuery = new StringBuffer();
		docUpdateQuery.append("update stx_oc_document_list ");
		docUpdateQuery.append("	  set subject = '"+subject+"' ");
		if("send".equals(sendReceiveType)){
			docUpdateQuery.append("	where ref_no = '"+refNo+"' ");
		}else if("receive".equals(sendReceiveType)){
			docUpdateQuery.append("	where rev_no = '"+revNo+"' ");
		}else{
			docUpdateQuery.append("	where 1=2 ");
		}
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(docUpdateQuery.toString());
		
		conn.commit();
		
		if(stmt!=null)
			stmt.close();
		if(conn!=null)
			conn.close();
	}else if("deleteObject".equals(mode)){
		StringBuffer objDeleteQuery = new StringBuffer();
		objDeleteQuery.append("delete ");
		objDeleteQuery.append("	 from stx_oc_ref_object ");
		
		boolean isDelete = false;
		
		if("send".equals(sendReceiveType)){
			objDeleteQuery.append("	where ref_no = '"+refNo+"' ");
			isDelete = true;
		}else if("receive".equals(sendReceiveType)){
			objDeleteQuery.append("	where rev_no = '"+revNo+"' ");
			isDelete = true;
		}else{
			objDeleteQuery.append("	where 1=2 ");
		}
		objDeleteQuery.append("	  and object_no = '"+objectNo+"' ");
		
		
		Statement stmt = null;
		Statement stmt2 = null;
		try{
			stmt = conn.createStatement();
			stmt.executeQuery(objDeleteQuery.toString());
			
			if ("drawing".equals(objectType) && isDelete)
	        {
	            StringBuffer sbSql = new StringBuffer();
	            // 선주승인 발송문서 등록인 경우 - 기본도: 선주승인발송(OW Start) / Maker도면: 선주승인발송(CL Start)
	            if ("owner".equals(ownerClassType))
	            {
	            	sbSql.append("UPDATE PLM_ACTIVITY T\n");
	            	sbSql.append("   SET ACTUALSTARTDATE = '', \n");
	            	sbSql.append("       ATTRIBUTE4 = '' \n");
	            	sbSql.append(" WHERE 1 = 1   \n");
	            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
	            	sbSql.append("   AND (    (DWGCATEGORY = 'B' AND DWGTYPE <> 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'OW') OR \n");
	            	sbSql.append("            (DWGCATEGORY = 'B' AND DWGTYPE = 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'CL') \n");
	            	sbSql.append("       ) \n");
	            	sbSql.append("	 AND PROJECTNO not in (SELECT SORO2.Project\n");
	            	sbSql.append("	         				 FROM STX_OC_REF_OBJECT SORO2 \n");
	            	sbSql.append("	         				WHERE SORO2.PROJECT = T.PROJECTNO \n");
	            	sbSql.append("	          				  AND SUBSTR(T.ACTIVITYCODE,1,8) = SORO2.OBJECT_NO )\n");
	            	stmt2 = conn.createStatement();
					stmt2.executeUpdate(sbSql.toString());	
	            }
	            else if ("class".equals(ownerClassType))
	            {
	            	sbSql.append("UPDATE PLM_ACTIVITY T\n");
	            	sbSql.append("   SET ACTUALSTARTDATE = '', \n");
	            	sbSql.append("       ATTRIBUTE4 = '' \n");
	            	sbSql.append(" WHERE 1 = 1 \n");
	            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
	            	sbSql.append("   AND DWGCATEGORY = 'B' \n");
	            	sbSql.append("   AND DWGTYPE <> 'V' \n");
	            	sbSql.append("   AND ACTIVITYCODE = '" + objectNo + "' || 'CL' \n");
	            	sbSql.append("	 AND PROJECTNO not in (SELECT SORO2.Project\n");
	            	sbSql.append("	         				 FROM STX_OC_REF_OBJECT SORO2 \n");
	            	sbSql.append("	         				WHERE SORO2.PROJECT = T.PROJECTNO \n");
	            	sbSql.append("	          				  AND SUBSTR(T.ACTIVITYCODE,1,8) = SORO2.OBJECT_NO )\n");
	            	stmt2 = conn.createStatement();
					stmt2.executeUpdate(sbSql.toString());	
	            }
			}
			conn.commit();
		} catch (Exception e)
		{
			e.printStackTrace();
			conn.rollback();
		} finally {
			if(stmt!=null)
				stmt.close();
			if(stmt2!=null)
				stmt2.close();
			if(conn!=null)
				conn.close();
		}
	}else if("modDoc".equals(mode)){
		StringBuffer docUpdateQuery = new StringBuffer();
		docUpdateQuery.append("update stx_oc_document_list ");
		
		if("send".equals(sendReceiveType)){
			//Subject
			docUpdateQuery.append("	  set subject = '"+subject+"' ");
			docUpdateQuery.append("	where ref_no = '"+refNo+"' ");
			
		}else if("receive".equals(sendReceiveType)){
			//Ref No , Subject , SendReceiveDept , RefDept
			docUpdateQuery.append("	  set subject = '"+subject+"' ");
			docUpdateQuery.append("	    , ref_no = '"+refNo+"' ");
			docUpdateQuery.append("	    , send_receive_dept = '"+sendReceiveDept+"' ");
			docUpdateQuery.append("	    , ref_dept = '"+refDept+"' ");
			docUpdateQuery.append("	where rev_no = '"+revNo+"' ");
			
		}
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(docUpdateQuery.toString());
		
		conn.commit();
		
		if(stmt!=null)
			stmt.close();
		if(conn!=null)
			conn.close();
	}
}catch(Exception e){
	e.printStackTrace();
	throw e;
}
	%>
	
	<%="SUCCESS"%>
	
	