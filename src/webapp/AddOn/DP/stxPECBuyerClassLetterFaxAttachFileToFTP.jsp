<%@page import="java.io.*"%>
<%@page import="org.apache.commons.net.ftp.*"%>
<%@page import="java.io.File"  %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.util.*" %>
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

    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");
    
	String refNo = request.getParameter("refNo");
	String mode = request.getParameter("mode");
	
	//System.out.println("refNo === "+refNo);
	//System.out.println("mode === "+mode);
    String sTempDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가	
/****
	String sTempDir = context.createWorkspace();
    java.io.File tmpDir = new java.io.File(sTempDir);
    java.io.File[] files = tmpDir.listFiles();
	for(int i= 0; i< files.length; i++) {
    	files[i].delete();
	}
****/
	MultipartRequest multi = new MultipartRequest(request, sTempDir, max_byte);
	
	Enumeration multiFiles = multi.getFileNames();
	
	while(multiFiles.hasMoreElements()){
		java.io.File fileObj1 = multi.getFile((String) multiFiles.nextElement());
		
		if(fileObj1==null)
			continue;
		
		//System.out.println(fileObj1.getName());
		
		String saveDocName = "";
		saveDocName = refNo.replace('/','-');
		
		//System.out.println(fileObj1.getName());
		String fileType = fileObj1.getName().substring(fileObj1.getName().lastIndexOf("."),fileObj1.getName().length());
		//System.out.println(fileType);
		
		//System.out.println(saveDocName+fileType);
		
		try{
			//FTP Login
			login();
			//System.out.println("FTP Login Success.");
			
			//Change Directory
			//cd("\\SEND");
			cd(DisMessageUtil.getMessage("letter.fax.ftp.folder.send"));
			//System.out.println("FTP Folder Change Success.");
			
			String fileName = "";
			
			if("doc".equals(mode)){
				fileName = saveDocName+fileType;
			}else if("ref".equals(mode)){
				String serialNo = getSerialNo(saveDocName);
				fileName = saveDocName+"-"+serialNo+fileType;
			}
			
			//File selectFile = new File("D://STX-CLP-B5002Z.DOC");
			
			//File Type Setting
			setFileType(FTP.BINARY_FILE_TYPE);
			//System.out.println("FTP File Type Setting Success.");
			
			//File Upload
			put(fileObj1 , fileName);
			put(fileObj1 , fileName);
			put(fileObj1 , fileName);
			put(fileObj1 , fileName);
			put(fileObj1 , fileName);
			//put(selectFile , "TEST.DOC");
			//System.out.println("FTP File Upload Success. - "+fileName);
			
			//refNo , context.getUser() , sysdate
			
			String updateAttachInfoSQL =  "update STX_OC_DOCUMENT_LIST " + 
										  "   set ATTACH_USER = '"+loginID+"' " + 
										  " 	 ,ATTACH_DATE = sysdate " + 
										  " where REF_NO = '"+refNo+"' ";
			
			java.sql.Connection conn = null;
			java.sql.Statement stmt = null;
			try {
				conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
				stmt = conn.createStatement();
				stmt.executeUpdate(updateAttachInfoSQL);
				
				conn.commit();
			} finally {
				if (conn != null) conn.close();
				if (stmt != null) stmt.close();
			}
			
		}catch(Exception e){
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
FTP UPLOAD SUCCESS.