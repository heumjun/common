<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적 추가 등록 처리
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignProcessAdditionAction.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@page import="java.io.*"%>
<%@page import="org.apache.commons.net.ftp.*"%>
<%@page import="java.io.File"  %>

<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%@ page import="stxship.dis.common.util.DisMessageUtil" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%!
private static final String SERVER_IP 	= "172.16.2.90";
private static final int 	PORT 		= 21;
private static final String LOGIN_ID 	= "dcruser";
private static final String LOGIN_PW 	= "dcr123";

private FTPClient ftpClient = new FTPClient();

private void connect() throws Exception{
	try{
		ftpClient.connect(SERVER_IP , PORT);
		
		if(!FTPReply.isPositiveCompletion(ftpClient.getReplyCode())){
			ftpClient.disconnect();
			throw new Exception("Connect Error!");
		}
	}catch(Exception e){
		if(ftpClient.isConnected()){
			try{
				ftpClient.disconnect();
			}catch(Exception ex){
				
			}
		}
		e.printStackTrace();
		throw e;
	}
	
}

private boolean login() throws Exception{
	try{
		connect();
		return ftpClient.login(LOGIN_ID , LOGIN_PW);
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
}

private boolean logout() throws Exception{
	try{
		return ftpClient.logout();
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
}

private boolean put(File localFile , String targetName) throws Exception{
	boolean flag = false;
	InputStream input = null;
	
	try{
		input = new FileInputStream(localFile);
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
	
	try{
		if(ftpClient.storeFile(targetName , input)){
			flag = true;
		}
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
	return flag;
}

private void cd(String path) throws Exception{
	try{
		ftpClient.changeWorkingDirectory(path);
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
}

private void disconnect() throws Exception{
	try{
		ftpClient.disconnect();
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
}

private void setFileType(int iFileType) throws Exception{
	try{
		ftpClient.setFileType(iFileType);
	}catch(Exception e){
		e.printStackTrace();
		throw e;
	}
}

private String getSerialNo(String docNo) throws Exception{
	String serialNo = "";
	
	FTPFile[] ftpFiles = ftpClient.listFiles();
	
	int maxNum = 1;
	
	for(int i=0 ; i<ftpFiles.length ; i++){
		if(ftpFiles[i].getName().startsWith(docNo)){
			int tempSerialNo = 0;
			try{
				tempSerialNo = Integer.parseInt(ftpFiles[i].getName().substring(docNo.length()+1 , docNo.length()+3));
			}catch(Exception e){
				
			}
			tempSerialNo++;
			if(maxNum<tempSerialNo)
				maxNum = tempSerialNo;
		}
	}
	
	if(maxNum<10)
		serialNo = "0"+maxNum;
	else
		serialNo = ""+maxNum;
	
	return serialNo;
}

public static String isNullString(String checkString){
	if(checkString==null || "null".equalsIgnoreCase(checkString) || "".equals(checkString) || "undefined".equals(checkString)){
		return "";
	}else{
		return checkString;
	}
}
%>


<%
	//String sTempDir = context.createWorkspace();
    String sTempDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가		
    java.io.File tmpDir = new java.io.File(sTempDir);
    java.io.File[] files = tmpDir.listFiles();
	for(int i= 0; i< files.length; i++) {
    	files[i].delete();
	}
	MultipartRequest multi = new MultipartRequest(request, sTempDir, max_byte, "euc-kr");

	String sSelect_seq_no = StringUtil.setEmptyExt(multi.getParameter("select_seq_no"));
	String sSelect_rev_no = StringUtil.setEmptyExt(multi.getParameter("select_rev_no"));

	String send_ref_no = StringUtil.setEmptyExt(multi.getParameter("send_ref_no"));
	String comment_count = StringUtil.setEmptyExt(multi.getParameter("comment_count"));
	String reply_count = StringUtil.setEmptyExt(multi.getParameter("reply_count"));
	String short_notice_count = StringUtil.setEmptyExt(multi.getParameter("short_notice_count"));

	String fileName = multi.getFilesystemName("fileName") == null ? "" : multi.getFilesystemName("fileName");

	String resultMsg = "";

    java.sql.Connection conn = null;
    java.sql.PreparedStatement pstmt = null;
    java.sql.Statement stmt  = null;
    java.sql.ResultSet rset = null;	

	String nextSequence = "";

    try 
	{
		conn = DBConnect.getDBConnection("SDPS");

		// 기존 실적은 Closed 처리
		StringBuffer queryStr = new StringBuffer();
		queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
		queryStr.append("   SET STATUS = 'Closed'                                                    \n");      //STATUS : Closed
		queryStr.append("      ,DESIGN_CLOSE_DATE = SYSDATE                                          \n");      //종료일자
		queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no +"'                                     \n");      

		stmt = conn.createStatement();
		stmt.executeUpdate(queryStr.toString());

		DBConnect.commitJDBCTransaction(conn);

		boolean completeFalg = false;
		if(comment_count.equals(reply_count))
		{
			completeFalg = true;
		}
		
		// SEQ_NO 추출 :  STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL		

		StringBuffer selectSeqQuery = new StringBuffer();
		selectSeqQuery.append("SELECT STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL  \n");
		selectSeqQuery.append("  FROM DUAL                               \n");

		rset = stmt.executeQuery(selectSeqQuery.toString());
		if (rset.next()) nextSequence = rset.getString(1);

		// 신규 실적은 새로 insert	
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
		insertQuery.append("	DESIGN_PROCESS_DATE,                           \n");
		insertQuery.append("	DESIGN_CLOSE_DATE,                             \n");
		insertQuery.append("	STATUS,                                        \n");
		insertQuery.append("	DESIGN_RECEIVE_PERSON,                         \n");
		insertQuery.append("	DESIGN_PROCESS_PERSON,                         \n");
		insertQuery.append("	SEND_REF_NO,                                   \n");
		insertQuery.append("	PROCESS_FILE_NAME,                             \n");
		insertQuery.append("	COMMENT_COUNT,                                 \n");
		insertQuery.append("	REPLY_COUNT,                                   \n");
		insertQuery.append("	SHORT_NOTICE_COUNT,                            \n");		
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
		insertQuery.append("	DESIGN_RECEIVE_FLAG,                           \n");     // DESIGN_RECEIVE_FLAG
		insertQuery.append("	SYSDATE,                                       \n");     // DESIGN_RECEIVE_DATE는 최신날짜로 변경
		insertQuery.append("	SYSDATE,                                       \n");     // DESIGN_PROCESS_DATE
if(completeFalg)
{
		insertQuery.append("	SYSDATE,                                       \n");     // DESIGN_CLOSE_DATE
		insertQuery.append("	'Closed',                                      \n");     // STATUS   :  'Closed'
} else {
		insertQuery.append("	NULL,                                          \n");     // DESIGN_CLOSE_DATE
		insertQuery.append("	'Progress',                                    \n");     // STATUS   :  'Progress'
}
		insertQuery.append("	DESIGN_RECEIVE_PERSON,                         \n");     // DESIGN_RECEIVE_PERSON
		insertQuery.append("	DESIGN_PROCESS_PERSON,                         \n");     // DESIGN_PROCESS_PERSON
		insertQuery.append("	'" + send_ref_no + "',                         \n");     // SEND_REF_NO
		insertQuery.append("	'" + fileName + "',                            \n");     // PROCESS_FILE_NAME
		insertQuery.append("    '" + comment_count + "',                       \n");     // COMMENT_COUNT
		insertQuery.append("    '" + reply_count + "',                         \n");     // REPLY_COUNT
		insertQuery.append("    '" + short_notice_count + "',                  \n");     // SHORT_NOTICE_COUNT		
		insertQuery.append("	COMMENT_MESSAGE,                               \n");     // COMMENT_MESSAGE
		insertQuery.append("	DESIGN_PROCESS_DEPT,                           \n");     // DESIGN_PROCESS_DEPT
		insertQuery.append("	DESIGN_PROCESS_PERSON_NAME,                    \n");     // DESIGN_PROCESS_PERSON_NAME
		insertQuery.append("	DESIGN_RECEIVE_PERSON_NAME,                    \n");     // DESIGN_RECEIVE_PERSON_NAME
		insertQuery.append("	DESIGN_RECEIVE_ACTION                          \n");
		insertQuery.append("FROM STX_OC_RECEIVE_DOCUMENT                       \n");  
		insertQuery.append("WHERE SEQ_NO = '" + sSelect_seq_no +"'             \n");   

		stmt.executeUpdate(insertQuery.toString());

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
            if ( pstmt != null ) pstmt.close();   
            DBConnect.closeConnection( conn );
        } catch( Exception ex ) { }
    } 

	if(!"".equals(fileName))
	{

		File file = new File(sTempDir +  java.io.File.separator + fileName);
		
		String fileType = fileName.substring(fileName.lastIndexOf("."),fileName.length());

		// 실적등록 첨부 문서는 FTP 서버에 COMMNETS 폴더에 접수번호+SEQ_NO+파일형 형태로 저장됨. 예) 20120905001_100.xls
		String saveFileName = "";
		saveFileName = sSelect_rev_no  +"_" + nextSequence + fileType;
		
		try{
			//FTP Login
			login();
			//System.out.println("FTP Login Success.");
			
			//Change Directory
			//cd("\\COMMENTS");
			cd(DisMessageUtil.getMessage("letter.fax.ftp.folder.comments"));

			//System.out.println("FTP Folder Change Success.");

			
			//File Type Setting
			setFileType(FTP.BINARY_FILE_TYPE);
			//System.out.println("FTP File Type Setting Success.");
			
			//File Upload
			put(file , saveFileName);
			//put(selectFile , "TEST.DOC");
			//System.out.println("FTP File Upload Success. - "+fileName);			

			
		}catch(Exception e){
			resultMsg = "ERROR  :  "+e.toString();   
			e.printStackTrace();
			throw e;
		}finally{
			//FTP Logout
			logout();
			//System.out.println("FTP Logout Success.");
			
			//FTP Disconnect
			disconnect();
			//System.out.println("FTP Disconnect Success.");
		}
	}

%>


<script language="javascript">


		// 접수 처리 후 Page Reload
		var parentHeadForm = parent.window.opener.document.commentHeadForm;

		var reloadproject                = parentHeadForm.project.value;
		var reloadownerClass             = parentHeadForm.ownerClass.value;
		var reloadfromDate               = parentHeadForm.fromDate.value;
		var reloadtoDate                 = parentHeadForm.toDate.value;
		var reloadrevNo                  = parentHeadForm.revNo.value;
		var reloadsubject                = parentHeadForm.subject.value;
		var reloadreceiveDept            = parentHeadForm.receiveDept.value;
		var reloadrefDept                = parentHeadForm.refDept.value;
		var reloaddesignReceiveFlag      = parentHeadForm.designReceiveFlag.value;
		var reloaddesignReceiveFromDate  = parentHeadForm.designReceiveFromDate.value;
		var reloaddesignReceiveToDate    = parentHeadForm.designReceiveToDate.value;
		var reloadprocessDept            = parentHeadForm.processDept.value;
		var reloadprocessPerson          = parentHeadForm.processPerson.value;
		var reloaddesignProcessFromDate  = parentHeadForm.designProcessFromDate.value;
		var reloaddesignProcessToDate    = parentHeadForm.designProcessToDate.value;
		var reloadstatus                 = parentHeadForm.status.value;

		if(reloadownerClass=="All") reloadownerClass = "";
		if(reloaddesignReceiveFlag=="All") reloaddesignReceiveFlag = "";
		if(reloadstatus=="All") reloadstatus = "";

        var urlStr = "stxPECBuyerClassCommentResultManagementBody.jsp"
		           + "?project=" + reloadproject
				   + "&ownerClass=" + reloadownerClass
				   + "&fromDate=" + reloadfromDate
				   + "&toDate=" + reloadtoDate
				   + "&revNo=" + reloadrevNo
				   + "&subject=" + reloadsubject
				   + "&receiveDept=" + escape(encodeURIComponent(reloadreceiveDept))
				   + "&refDept=" + escape(encodeURIComponent(reloadrefDept))
				   + "&designReceiveFlag=" + reloaddesignReceiveFlag
				   + "&designReceiveFromDate=" + reloaddesignReceiveFromDate
				   + "&designReceiveToDate=" + reloaddesignReceiveToDate
				   + "&processDept=" + escape(encodeURIComponent(reloadprocessDept))
				   + "&processPerson=" + escape(encodeURIComponent(reloadprocessPerson))
				   + "&designProcessFromDate=" + reloaddesignProcessFromDate
				   + "&designProcessToDate=" + reloaddesignProcessToDate
				   + "&status=" + reloadstatus
				   + "&mode=search";

		alert("<%=resultMsg%>");
		window.close();
        
        opener.parent.COMMENT_RESULT_MANAGEMENT_BODY.location = urlStr;

</script>
