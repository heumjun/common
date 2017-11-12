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
	
	//String file_id = request.getParameter("fildId");
	String fileName = request.getParameter("fileName");
	String project = request.getParameter("project");
	String drawingFlag = request.getParameter("drawingFlag");
	String silCode = request.getParameter("silCode");

	//System.out.println("~~~~ fileName = "+fileName);
	//System.out.println("~~~~ project = "+project);
	//System.out.println("~~~~ drawingFlag = "+drawingFlag);
	//System.out.println("~~~~ silCode = "+silCode);
	
    String errMsg = "";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try
    {
        // DB Connection
        conn = DBConnect.getDBConnection("SDPS");

        StringBuffer sSql = new StringBuffer();
        sSql.append("select DOC_PROJECT     			");
        sSql.append("  from stx_oc_project_send_number  ");
        sSql.append(" where project = '"+project+"'     ");
		
        stmt = conn.createStatement(); 
        rs = stmt.executeQuery(sSql.toString());
        
        //System.out.println("Project === "+project);
        
        if (rs.next()) {
            project = (String)rs.getString(1);
        }
        
        //System.out.println("Master Project === "+project);
        
        if(project==null || "".equals(project))
        	throw new Exception("Master Project is null. Please check project info.");
        
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
    	
    	String ftpFileName = "";
    	FTPFile[] files = fc.listFiles();
    	
    	for (int i = 0; i < files.length ; i++) {
    	    //System.out.println(files[i].getName()+" 파일 - 사이즈"  + files[i].getSize());
    	    //drawingFlag : drawing(A) , noDrawing(B)
    	    if(files[i].getName().startsWith(project+"-"+silCode+"-"+("drawing".equals(drawingFlag)?"A.":"B."))){				
				ftpFileName = files[i].getName();
        	    break;
    	    }
    	}
    	//System.out.println("FTP File Name === "+ftpFileName);
    	
    	if(ftpFileName==null || "".equals(ftpFileName))
        	throw new Exception("File not exist. Please check File Server.");
    	
    	java.io.File saveFile = null;
    	FileOutputStream fos = null;
    	
    	try{
    		saveFile = new java.io.File("C:\\DIS_FILE\\"+fileName);
    		
    		fos = new FileOutputStream(saveFile);
    		
    		boolean fileDownFlag = fc.retrieveFile(ftpFileName , fos);
    		
    		if(fileDownFlag){
    			System.out.println("### file download success ### - "+ftpFileName);
    		}else {
    			System.out.println("### file download fail ### - "+ftpFileName);
    		}
    		
    		//java.io.File openFile = new java.io.File("D:\\D01.log");
    		
    		/////////////////////////////////////////////////////////
    		
    		//String fileName = "";
	        //oracle.sql.BLOB blob = null;
	        //if (rs.next()) {
	            //fileName = (String)rs.getString(2);
	            //blob = (oracle.sql.BLOB)rs.getBlob(3);
				
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
	                outBW.write(buffer, 0, n);
	                outBW.flush();
	            }
	
	            outBW.close();
	            in.close();
	        //} else {
	         //   errMsg = "소급 Data이거나 첨부 Spec을 찾을 수 없습니다.";
	        //}
    		
    		/////////////////////////////////////////////////////////
    		
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

