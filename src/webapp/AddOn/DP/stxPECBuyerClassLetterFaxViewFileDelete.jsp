<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "org.apache.commons.net.ftp.*" %>
<%@ page import="stxship.dis.common.util.DisMessageUtil" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
	String fileName 	= request.getParameter("fileName");
	
	//String fileDir = "\\SEND";
	String fileDir = DisMessageUtil.getMessage("letter.fax.ftp.folder.send");
	
	String errMsg = "";

    try
    {
        //int LOCAL_SIZE = 16384;
    	String server = "172.16.2.90";
    	//int port = 21;
    	String id = "dcruser";
    	String password = "dcr123"; 
    	FTPClient fc = new FTPClient();
    	
    	//connect server
    	fc.connect(server);
    	
    	//login server
    	fc.login(id , password);
    	
    	//go directory
    	fc.changeWorkingDirectory(fileDir);
    	
		FTPFile[] ftpFiles = fc.listFiles();
		
		for(int i=0 ; i<ftpFiles.length ; i++){
			if(ftpFiles[i].getName().startsWith(fileName)){
				boolean deleteFlag = fc.deleteFile(ftpFiles[i].getName());
				if(deleteFlag)
					System.out.println("FTP File Delete Success. - "+ftpFiles[i].getName());
				else
					System.out.println("FTP File Delete Fail. - "+ftpFiles[i].getName());
			}
		}
    	
    	fc.logout();
    	
    	if(fc!=null && fc.isConnected()){
    		fc.disconnect();     
    	}
        
    } 
    catch (Exception e)
    {
        errMsg = e.toString();
        System.out.println(errMsg);
    } 
    finally 
    {
        
    }
	 
%>
<%--========================== SCRIPT ======================================--%>
<script language="javascript">
<%
    if(!"".equals(errMsg))
    {
%>
        alert("<%=errMsg%>");
<%
    }
%>
    window.close();
</script>

