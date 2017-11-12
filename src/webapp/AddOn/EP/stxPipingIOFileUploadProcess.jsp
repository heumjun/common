<%@page import="org.jdom.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.util.StringUtil"%>
<%@page import="java.sql.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%request.setCharacterEncoding("euc-kr");%>


<%!
	public String insertPLMFileTbl(Connection conn,String USER,String PIPING_IO_ID,String PROJECT,String FILENAME) throws Exception
	{
		Map mapUpdate = new HashMap();
		String FILEID = selectCurrentSeq(conn,"STX_PIPING_IO_FILE_SQ");
		mapUpdate.put("FILEID",FILEID);
		mapUpdate.put("PIPING_IO_ID",PIPING_IO_ID);
		mapUpdate.put("PROJECT",PROJECT);
		mapUpdate.put("CREATED_BY",USER);
		mapUpdate.put("FILENAME",FILENAME);
		mapUpdate.put("CREATED_DATE",getToDayWithTime());
		insertTableSimple(conn,"STX_PIPING_IO_FILE",mapUpdate);
		return FILEID;
	}

	public void updateFile(Connection conn,String FILEID, File file) throws Exception
	{
		
		StringBuffer sbSql = new StringBuffer();
		sbSql.append("UPDATE STX_PIPING_IO_FILE SET ATTACHMENT = EMPTY_BLOB()\n");
		sbSql.append(" WHERE FILEID = ?                                  \n"); 
		
		PreparedStatement pstmt = conn.prepareStatement(sbSql.toString());
		
		pstmt.setString(1, FILEID);
		pstmt.executeUpdate();
		
		sbSql = new StringBuffer();
		sbSql.append("SELECT ATTACHMENT                           \n");
		sbSql.append("  FROM STX_PIPING_IO_FILE                            \n");
		sbSql.append(" WHERE FILEID = ?                         \n");
		
		pstmt = conn.prepareStatement(sbSql.toString());
        pstmt.setString(1, FILEID);
        ResultSet rset = pstmt.executeQuery();
        
        oracle.sql.BLOB blob  = null;
        OutputStream outstream = null;
        FileInputStream finstream = null;
        
        try{
        if (rset.next()) blob = (oracle.sql.BLOB)rset.getBlob(1);

        outstream = blob.getBinaryOutputStream();
        int size = blob.getBufferSize();
        finstream = new FileInputStream(file);
        
        byte[] buffer = new byte[size];
        int length = -1;
        while ((length = finstream.read(buffer)) != -1) {
            outstream.write(buffer, 0, length);
        }
        } catch (Exception e)
        {
        	e.printStackTrace();
        	throw e;
        } finally {
        	if (finstream != null) finstream.close();               
            if (outstream != null) outstream.close(); 
        }
	}
	
	public String uploadFile(String USER,File file,String PIPING_IO_ID,String PROJECT) throws Exception 
	{
		if(PIPING_IO_ID == null || PROJECT == null)
		{
			return "Piping IO Data에 문제가 있습니다.";
		}
		
		String sErrorMsg = "";
		Connection conn = null;
		try{
			conn = DBConnect.getDBConnection("PLM");
			String FILEID = insertPLMFileTbl(conn,USER,PIPING_IO_ID,PROJECT,file.getName());
			updateFile(conn,FILEID,file);
			conn.commit();
		} catch (Exception e)
		{
			e.printStackTrace();
			sErrorMsg = "Some Error!";
		}
		return sErrorMsg;
	}
%>
<%
	String sReturn = "";
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");	
		
    String sWorkDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가	
	ArrayList slDelFile = new ArrayList();
	try{
		MultipartRequest multi = new MultipartRequest(request, sWorkDir, max_byte, "EUC-KR");
		
		String PIPING_IO_ID	= multi.getParameter("PIPING_IO_ID");
		String PROJECT		= multi.getParameter("PROJECT");
		
		File file = multi.getFile("uploadfile");
		if(file != null && file.length()>4096000)
		{
			throw new Exception("첨부파일 크기는  4M로 제한 되어있습니다.");
		}
		
		sReturn = uploadFile(USER,file,PIPING_IO_ID,PROJECT);
	} catch (Exception e)
	{
			e.printStackTrace();
			sReturn = e.toString();
	} finally{
	}
	
	boolean saveDone = false;
	if(sReturn.equals(""))
	{
		sReturn = "저장 되었습니다.";
		saveDone = true;
	}
%>
<%@page import="java.io.*"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<%@page import="org.apache.poi.hssf.usermodel.HSSFDateUtil"%>
<script type="text/javascript">
	alert("<%=sReturn%>")
	parent.fnSearch();
	parent.fnProgressOff();
</script>
