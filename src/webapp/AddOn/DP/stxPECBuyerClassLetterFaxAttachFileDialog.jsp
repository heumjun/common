<%@page import="java.io.*"%>
<%@page import="org.apache.commons.net.ftp.*"%>
<%@ page import="stxship.dis.common.util.DisMessageUtil" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
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
	
	public static String isNullString(String checkString){
		if(checkString==null || "null".equalsIgnoreCase(checkString) || "".equals(checkString) || "undefined".equals(checkString)){
			return "";
		}else{
			return checkString;
		}
	}
%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>
<%
	String refNo 				= isNullString(request.getParameter("refNo"));
	//System.out.println("refNo === "+refNo);
	
	try{
		//FTP Login
		login();
		
		//Change Directory
		//cd("\\SEND");
		cd(DisMessageUtil.getMessage("letter.fax.ftp.folder.send"));
		
		File selectFile = new File("D://STX-CLP-B5002Z.DOC");
		
		//File Upload
		put(selectFile , "TEST.DOC");
		
		//FTP Logout
		logout();
		
		//FTP Disconnect
		disconnect();
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<body>
	<form>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="border: #00bb00 1px solid;">
					문서번호
				</td>
				<td style="border: #00bb00 1px solid;">
					<%=refNo %>
				</td>
				<td style="border: #00bb00 1px solid;">
					<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" value="..." onclick="attachDoc('refDoc','<%=refNo%>')">
				</td>
			</tr>
			<tr>
				<td style="border: #00bb00 1px solid;">
					UPLOAD
				</td>
				<td style="border: #00bb00 1px solid;">
					공문
				</td>
				<td style="border: #00bb00 1px solid;">
					<input class="input_noBorder" style="background-color:#D8D8D8; color:#000000" value="..." onclick="attachDoc('refDoc','<%=refNo%>')">
				</td>
			</tr>
		</table>
	</form>
</body>
	
	
<script language="javascript">

	//var attURL = "stxPECAttachedFileTest.jsp?fildId=<%//=file_id%>";
	//attURL += "?prId="+prId;
	
	//var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	//window.showModalDialog(attURL,"",sProperties);
	//window.open(attURL,"",sProperties);
	    
	//window.close();
	    
	</script>
	<%//="SUCCESS"%>
	
	