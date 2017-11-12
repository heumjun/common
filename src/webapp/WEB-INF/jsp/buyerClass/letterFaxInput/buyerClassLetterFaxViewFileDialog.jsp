<%@page import="java.io.*"%>
<%@page import="org.apache.commons.net.ftp.*"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@ page import="stxship.dis.common.util.DisMessageUtil" %>
<%@ page contentType="text/html; charset=utf-8" %>

<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
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

public static String isNullString(String checkString){
	if(checkString==null || "null".equalsIgnoreCase(checkString) || "".equals(checkString) || "undefined".equals(checkString)){
		return "";
	}else{
		return checkString;
	}
}
%>

<% 
	String languageStr 	= request.getHeader("Accept-Language");
	String refNo 		= request.getParameter("refNo");
	refNo = refNo.replace('/','-');
	
	//System.out.println(refNo);
	
	ArrayList fileList = new ArrayList();
	
	try{
		//FTP Login
		login();
		//System.out.println("FTP Login Success.");
		
		//Change Directory
		//cd("\\SEND");
		cd(DisMessageUtil.getMessage("letter.fax.ftp.folder.send"));

		//System.out.println("FTP Folder Change Success.");
		
		FTPFile[] ftpFiles = ftpClient.listFiles();
		for(int i=0 ; i<ftpFiles.length ; i++){
			if(ftpFiles[i].getName().startsWith(refNo+"-")){
				//System.out.println(ftpFiles[i].getName());
				fileList.add(ftpFiles[i].getName());
			}
		}
		
		//fileList.sort();
		
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
%>	


<script language="javascript">
	function closeDialog(){
		top.parent.window.close();
	}
	
	function viewFile(fileName){
		var attURL = "buyerClassLetterFaxViewFileOpen.do";
	    attURL += "?fileName=" + fileName;
	
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	    //window.showModalDialog(attURL,"",sProperties);
	    showModalDialog(attURL,"",sProperties);
	}
	
	function deleteFile(fileName){
		var attURL = "buyerClassLetterFaxViewFileDelete.do";
	    attURL += "?fileName=" + fileName;
	
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	    //window.showModalDialog(attURL,"",sProperties);
	    var rs = showModalDialog(attURL,"",sProperties);
	    window.location.reload();
	    
	}
	
	function closeDialog(){
		top.parent.window.close();
	}
</script>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<div class="subtitle">
	View <%=refNo%> Document.
</div>
<table class="searchArea conSearch">
	<tr>
		<td>
			<div  id="buttonTable" class="button endbox">
				<input type="button" name="btn_Close" class="btn_blue" value="CLOSE" onClick="javascript:closeDialog();">
			</div>
		</td>
	</tr>
</table>
<!--
<form name="importForm" method="post" action="stxUploadToDB.jsp" target="UpdateLower" onsubmit="javascript:checkInput(); return false"  enctype="multipart/form-data">
-->
<form name="importForm" method="post" action="" target="" onsubmit=""  enctype="multipart/form-data">
	<table class="insertArea">
		<%if(fileList!=null){
			for(int i=0 ; i<fileList.size() ; i++){
				String tempFileName = (String)fileList.get(i);
		%>
				<tr>
					<td class="inputField">
						<input type="text" size="40" value="<%=tempFileName %>" style="border:0" readonly="readonly">
						<input type="button" class="btn_gray2" value="VIEW" onclick="viewFile('<%=tempFileName %>')">
						<input type="button" class="btn_gray2" value="DELETE" onclick="deleteFile('<%=tempFileName %>')">
					</td>
				</tr>
		<%
			}
		} 
		%>
		
	</table>
</form>



