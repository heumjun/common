<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "org.apache.commons.net.ftp.*" %>
<%@ page import="stxship.dis.common.util.DisMessageUtil" %>

<%@ page contentType="text/html; charset=utf-8" %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>

<%    
	//파라미터
	String refNo = request.getParameter("refNo");
	String fileName = request.getParameter("fileName");

    String errMsg = "";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

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
    	//fc.changeWorkingDirectory("\\BUYERFAX");
    	fc.changeWorkingDirectory(DisMessageUtil.getMessage("letter.fax.ftp.folder.buyerfax"));
    	
    	String ftpFileName = fileName;
    	FTPFile[] files = fc.listFiles();

    	//fileName 파라미터가 NULL 값으로 가져왔을 때
    	if(ftpFileName==null || "".equals(ftpFileName))
        	throw new Exception("해당 파일이 존재하지 않습니다. 파일서버를 확인해주세요.");
    	
    	java.io.File saveFile = null;
    	java.io.File saveFileDocx = null;
    	java.io.File saveFileDoc = null;
    	FileOutputStream fos = null;
    	
    	try{
    		//해당 파일의 확장자가 .doc, .docx 중 있는지 확인 
    		saveFileDocx = new java.io.File("C:\\"+fileName+".docx");
    		fos = new FileOutputStream(saveFileDocx);
    		boolean fileDownFlagDocx = fc.retrieveFile(ftpFileName+".docx" , fos);
    		
    		saveFileDoc = new java.io.File("C:\\"+fileName+".doc");
    		fos = new FileOutputStream(saveFileDoc);
    		boolean fileDownFlagDoc = fc.retrieveFile(ftpFileName+".doc" , fos);
    		
    		//확장자가 .docx 일 경우
    		if(fileDownFlagDocx){
    			System.out.println("### file download success ### - "+ftpFileName+".docx");
    			saveFile = saveFileDocx;
    			fileName = refNo+".docx";
    		}
    		//확장자가 .doc 일 경우
    		else if(fileDownFlagDoc){
    			System.out.println("### file download success ### - "+ftpFileName+".doc");
    			saveFile = saveFileDoc;
    			fileName = refNo+".doc";
    		}
    		//해당 문서가 서버에 존재하지 않는 경우
    		else {
    			System.out.println("### file download fail ###");
    		}
    		
			////////////////////////////////////////////////////////////////////////////////////////////
    		
            out.clear();
            out=pageContext.pushBody();
            
            //InputStream in = blob.getBinaryStream();
            InputStream in = new BufferedInputStream(new FileInputStream(saveFile));
            BufferedOutputStream outBW = new BufferedOutputStream(response.getOutputStream());
           // String convName =  java.net.URLEncoder.encode(new String(fileName.getBytes("8859_1"), "euc-kr"),"UTF-8"); 
            String convName = new String(fileName.getBytes("euc-kr"), "8859_1");       
            //System.out.println("~~ convName = "+convName);
            response.setHeader("Content-Type", "application/octet-stream;");
            response.setHeader("Content-Disposition", "attachment;filename=" + convName + ";");

            byte[] buffer = new byte[10*1024];
            int n = 0;

            while ((n = in.read(buffer)) != -1) {
            	//System.out.println("a");
                outBW.write(buffer, 0, n);
                outBW.flush();
            }

            outBW.close();
            in.close();
   		
    		////////////////////////////////////////////////////////////////////////////////////////////
    		
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
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        DBConnect.closeConnection(conn);
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

