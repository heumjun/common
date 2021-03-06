<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적 등록 첨부문서 열기
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignProcessFileOpen.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "org.apache.commons.net.ftp.*" %>

<%@ page import="stxship.dis.common.util.DisMessageUtil" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
	String fileName 	= request.getParameter("fileName");
	
	//String fileDir = "\\COMMENTS";	
	String fileDir = DisMessageUtil.getMessage("letter.fax.ftp.folder.comments");

	
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
    	
    	boolean isExistFile = false;
    	
    	for(int i=0 ; i<ftpFiles.length ; i++){
    		if(ftpFiles[i].getName().startsWith(fileName)){
    			isExistFile = true;
    			fileName = ftpFiles[i].getName();
    		}
    	}
    	
    	if(!isExistFile)
        	throw new Exception(fileName + " File not exist.");
    	
    	java.io.File saveFile = null;
    	FileOutputStream fos = null;
    	
    	try{
    		//saveFile = new java.io.File("D:\\TEMP_FILE\\"+fileName);
    		saveFile = new java.io.File("C:\\DIS_FILE\\"+fileName);
    		
    		fos = new FileOutputStream(saveFile);
    		
    		boolean fileDownFlag = fc.retrieveFile(fileName , fos);
    		
    		if(fileDownFlag){
    			System.out.println("### file download success ### - " + fileName);
    		}else {
    			System.out.println("### file download fail ### - " + fileName);
    		}
    		
    		out.clear();
	        out=pageContext.pushBody();
	        
	        InputStream in = new BufferedInputStream(new FileInputStream(saveFile));
			
	        BufferedOutputStream outBW = new BufferedOutputStream(response.getOutputStream());
	        // String convName =  java.net.URLEncoder.encode(new String(fileName.getBytes("8859_1"), "euc-kr"),"UTF-8"); 
	        String convName = new String(fileName.getBytes("euc-kr"), "8859_1");
	        
	        response.setHeader("Content-Type", "application/octet-stream;");
	        response.setHeader("Content-Disposition", "attachment;filename=" + convName + ";");
			
	        byte[] buffer = new byte[10*1024];
	        int n = 0;
			
	        while ((n = in.read(buffer)) != -1) {
	        	outBW.write(buffer, 0, n);
	            outBW.flush();
			}
			
	        outBW.close();
	        in.close();
	        
    	}catch(Exception e){
    		e.printStackTrace();
    	}finally{
    		if(fos!=null)
    			fos.close();
    		if(saveFile!=null && saveFile.isFile())
    			saveFile.delete();
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

