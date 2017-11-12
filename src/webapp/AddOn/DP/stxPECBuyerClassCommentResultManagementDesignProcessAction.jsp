<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적 등록 처리
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignProcessAction.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@page import="java.io.*"%>
<%@page import="org.apache.commons.net.ftp.*"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%@ page import="stxship.dis.common.util.DisMessageUtil" %>

<%@ include file = "stxPECGetParameter_Include.inc" %>
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

    try 
	{
		conn = DBConnect.getDBConnection("SDPS");

		boolean completeFalg = false;
		if(comment_count.equals(reply_count))
		{
			completeFalg = true;
		}

		StringBuffer queryStr = new StringBuffer();
		queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
		queryStr.append("   SET DESIGN_PROCESS_DATE = SYSDATE                                        \n");      //실적 등록 일자
		queryStr.append("      ,COMMENT_COUNT = '" +  comment_count + "'                             \n");      //Commnents 건수
		queryStr.append("      ,REPLY_COUNT = '" + reply_count + "'                                  \n");      //Reply 건수
		queryStr.append("      ,SHORT_NOTICE_COUNT = '" + short_notice_count + "'                    \n");      //Short Notice 건수
		queryStr.append("      ,SEND_REF_NO = '" + send_ref_no + "'                                  \n");      //관련 Ref No.
		queryStr.append("      ,PROCESS_FILE_NAME = '" + fileName + "'                               \n");      //실적등록 첨부 문서명
	if(completeFalg)
	{
		queryStr.append("      ,STATUS = 'Closed'                                                    \n");      //STATUS : Closed
		queryStr.append("      ,DESIGN_CLOSE_DATE = SYSDATE                                          \n");      //종료일자
	} else {
		queryStr.append("      ,STATUS = 'Progress'                                                  \n");      //STATUS : Progress
	}
		queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no +"'                                     \n");      

		stmt = conn.createStatement();
		stmt.executeUpdate(queryStr.toString());

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

		saveFileName = sSelect_rev_no  +"_" + sSelect_seq_no+fileType;

		//System.out.println("saveFileName = " + saveFileName);
		
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
