/***********************************************
*@DESCRIPTION				: Dwg
*@AUTHOR (MODIFIER)			: Kim dong hyoek
*@FILENAME					: TbcDwgMain.java
*@CREATE DATE				: 2014-08-12
***********************************************/
package com.stx.tbc.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;


public class TbcItemTransDownloadService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		
		String errMsg = "";

	    Connection conn = null;
	    Statement stmt = null;
	    ResultSet rs = null;

	    try
	    {
	        String document_id = request.getParameter("document_id");

	        // DB Connection
	        conn = DBConnect.getDBConnection("PLM");

	        StringBuffer sSql = new StringBuffer();
	        sSql.append("select document_name,document_data						\n");
	        sSql.append("	from STX_TBC_INFO_DOC								\n");
	        sSql.append(" where document_id = "+document_id+"					\n");

	        stmt = conn.createStatement(); 
	        rs = stmt.executeQuery(sSql.toString());

	        String fileName = "";
	        oracle.sql.BLOB blob = null;
	        if (rs.next()) {
	            fileName = (String)rs.getString(1);
	            blob = (oracle.sql.BLOB)rs.getBlob(2);

	            //out.clear();
	            //out=pageContext.pushBody();
	            InputStream in = blob.getBinaryStream();           

	            BufferedOutputStream outBW = new BufferedOutputStream(response.getOutputStream());
	            //String convName =  java.net.URLEncoder.encode(new String(fileName.getBytes("8859_1"), "euc-kr"),"UTF-8"); 
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
	        } else {
	            errMsg = "소급 Data이거나 요청 문서를 찾을 수 없습니다.";
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
	    
		ServiceForward forward = new ServiceForward();
		forward.setRedirect(false);
        forward.setForward(false);
		
		return forward;
	}
}