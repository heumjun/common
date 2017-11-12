/***********************************************
*@DESCRIPTION				: Dwg
*@AUTHOR (MODIFIER)			: Kim dong hyoek
*@FILENAME					: TbcDwgMain.java
*@CREATE DATE				: 2014-08-12
***********************************************/
package com.stx.tbc.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;


public class TbcItemTransUploadService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

		PrintWriter out	=	response.getWriter();
		
		String vTempDir = "D:\\ematrix\\stxcentral\\eptemp";
		
		int sizeLimit = 5 * 1024 * 1024;
		String vMsg = "";
		MultipartRequest multi = new MultipartRequest(request, vTempDir, sizeLimit, "euc-kr");
		String user_id = multi.getParameter("user_id");
	    String fileName = multi.getFilesystemName("uploadfile") == null ? "" : multi.getFilesystemName("uploadfile");
	    String fileName1 = multi.getFilesystemName("uploadfile1") == null ? "" : multi.getFilesystemName("uploadfile1");
	    String fileName2 = multi.getFilesystemName("uploadfile2") == null ? "" : multi.getFilesystemName("uploadfile2");
	    String fileName3 = multi.getFilesystemName("uploadfile3") == null ? "" : multi.getFilesystemName("uploadfile3");
	    String fileName4 = multi.getFilesystemName("uploadfile4") == null ? "" : multi.getFilesystemName("uploadfile4");
	    //String fileType = multi.getContentType("uploadfile") == null ? "" : multi.getContentType("uploadfile");
	    String filePath 		 = "";
	    Connection conn 		 = null;
	    Connection connERP 		 = null;
	    PreparedStatement pstmt1 = null;
	    PreparedStatement pstmt2 = null;
	    PreparedStatement pstmt3 = null;
	    PreparedStatement pstmt4 = null;
	    PreparedStatement pstmt5 = null;
	    PreparedStatement pstmt6 = null;
	    PreparedStatement pstmt7 = null;
	    ResultSet			rs   = null;
	    ResultSet			rset = null;
	    ResultSet			rset2= null;
	    FileInputStream		fis	 = null;
	    StringBuffer insertDoc = new StringBuffer();
	    StringBuffer selectDoc = new StringBuffer();
	    OutputStream outstream  = null;
	    FileInputStream finstream  = null;
	    
	    try {
	    	
	    	conn = DBConnect.getDBConnection("PLM");
	    	connERP = DBConnect.getDBConnection("ERP_APPS");
	    	conn.setAutoCommit(false);
	    	connERP.setAutoCommit(false);
	    	
	    	//list_id seq 얻어오기
	    	String list_id = multi.getParameter("list_id") == null ? "" : multi.getParameter("list_id");
	    	String document_id = "";
	    	if(list_id.equals("")){
		    	StringBuffer selectSeq = new StringBuffer();
		    	selectSeq.append("select stx_tbc_info_list_s.nextval as seq from dual	\n");
		    	pstmt6 = conn.prepareStatement(selectSeq.toString());
		    	rs=pstmt6.executeQuery();
		    	while(rs.next()){
		    		list_id=rs.getString("seq");
		    	}
	    	}
	    	if(!fileName.equals("")){
	    		//document_id seq 받아오기
	    		StringBuffer docSeq = new StringBuffer();
	    		docSeq.append("select stx_tbc_info_doc_s.nextval as seq from dual	\n");
		    	pstmt7 = conn.prepareStatement(docSeq.toString());
		    	rs=pstmt7.executeQuery();
		    	while(rs.next()){
		    		document_id=rs.getString("seq");
		    	}
	    		
	    		
	    		filePath = vTempDir + "/" + fileName ; 
	    		File file = new File(filePath); 
		        fis = new FileInputStream(file);
		        int ilen=(int) file.length();
		        
		        if(ilen>sizeLimit){
		        	StringBuffer sb = new StringBuffer(); 
					sb.append("<script type=\"text/javascript\" >");			 
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					out.println(sb);
					out.flush();
		        }else{
			        insertDoc.delete(0, insertDoc.length());
				    insertDoc.append(" INSERT \n");
				    insertDoc.append("   INTO STX_TBC_INFO_DOC \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("                LIST_ID \n");
				    insertDoc.append("              , DOCUMENT_ID \n");
				    insertDoc.append("              , DOCUMENT_NAME \n");
				    insertDoc.append("              , DOCUMENT_DATA \n");
				    insertDoc.append("              , LAST_UPDATE_DATE \n");
				    insertDoc.append("              , LAST_UPDATED_BY \n");
				    insertDoc.append("              , CREATION_DATE \n");
				    insertDoc.append("              , CREATED_BY \n");
				    insertDoc.append("        ) \n");
				    insertDoc.append("        VALUES \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("				  "+list_id+" \n");
				    insertDoc.append("              , "+document_id+" \n");
				    insertDoc.append("              , '"+fileName+"' \n");
				    insertDoc.append("              , EMPTY_BLOB() \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("        ) \n");
				    
				    pstmt1 = conn.prepareStatement(insertDoc.toString());
				    pstmt1.executeUpdate();
				    
				    selectDoc.delete(0, selectDoc.length());
				    selectDoc.append("select DOCUMENT_DATA	\n");
				    selectDoc.append("	from STX_TBC_INFO_DOC	\n");
				    selectDoc.append(" where document_id = "+document_id+"	\n");
				    
				    pstmt2 = conn.prepareStatement(selectDoc.toString());
				    rset=pstmt2.executeQuery();
				    
				    oracle.sql.BLOB blob  = null;
		            if (rset.next()) blob = (oracle.sql.BLOB)rset.getBlob(1);

		            outstream = blob.getBinaryOutputStream();
		            int size = blob.getBufferSize();
		            finstream = new FileInputStream(file);
		            
		            byte[] buffer = new byte[size];
		            int length = -1;
		            while ((length = finstream.read(buffer)) != -1) {
		                outstream.write(buffer, 0, length);
		            }
		            if (finstream != null) finstream.close();               
		            if (outstream != null) outstream.close(); 
				    
		        }
	    	}
	    	if(!fileName1.equals("")){
	    		//document_id seq 받아오기
	    		StringBuffer docSeq = new StringBuffer();
	    		docSeq.append("select stx_tbc_info_doc_s.nextval as seq from dual	\n");
		    	pstmt7 = conn.prepareStatement(docSeq.toString());
		    	rs=pstmt7.executeQuery();
		    	while(rs.next()){
		    		document_id=rs.getString("seq");
		    	}
	    		
	    		
	    		filePath = vTempDir + "/" + fileName ; 
	    		File file = new File(filePath); 
		        fis = new FileInputStream(file);
		        int ilen=(int) file.length();
		        
		        if(ilen>sizeLimit){
		        	StringBuffer sb = new StringBuffer(); 
					sb.append("<script type=\"text/javascript\" >");			 
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					out.println(sb);
					out.flush();
		        }else{
			        insertDoc.delete(0, insertDoc.length());
				    insertDoc.append(" INSERT \n");
				    insertDoc.append("   INTO STX_TBC_INFO_DOC \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("                LIST_ID \n");
				    insertDoc.append("              , DOCUMENT_ID \n");
				    insertDoc.append("              , DOCUMENT_NAME \n");
				    insertDoc.append("              , DOCUMENT_DATA \n");
				    insertDoc.append("              , LAST_UPDATE_DATE \n");
				    insertDoc.append("              , LAST_UPDATED_BY \n");
				    insertDoc.append("              , CREATION_DATE \n");
				    insertDoc.append("              , CREATED_BY \n");
				    insertDoc.append("        ) \n");
				    insertDoc.append("        VALUES \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("				  "+list_id+" \n");
				    insertDoc.append("              , "+document_id+" \n");
				    insertDoc.append("              , '"+fileName+"' \n");
				    insertDoc.append("              , EMPTY_BLOB() \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("        ) \n");
				    
				    pstmt1 = conn.prepareStatement(insertDoc.toString());
				    pstmt1.executeUpdate();
				    
				    selectDoc.delete(0, selectDoc.length());
				    selectDoc.append("select DOCUMENT_DATA	\n");
				    selectDoc.append("	from STX_TBC_INFO_DOC	\n");
				    selectDoc.append(" where document_id = "+document_id+"	\n");
				    
				    pstmt2 = conn.prepareStatement(selectDoc.toString());
				    rset=pstmt2.executeQuery();
				    
				    oracle.sql.BLOB blob  = null;
		            if (rset.next()) blob = (oracle.sql.BLOB)rset.getBlob(1);

		            outstream = blob.getBinaryOutputStream();
		            int size = blob.getBufferSize();
		            finstream = new FileInputStream(file);
		            
		            byte[] buffer = new byte[size];
		            int length = -1;
		            while ((length = finstream.read(buffer)) != -1) {
		                outstream.write(buffer, 0, length);
		            }
		            if (finstream != null) finstream.close();               
		            if (outstream != null) outstream.close(); 
				    
		        }
	    	}
	    	if(!fileName2.equals("")){
	    		//document_id seq 받아오기
	    		StringBuffer docSeq = new StringBuffer();
	    		docSeq.append("select stx_tbc_info_doc_s.nextval as seq from dual	\n");
		    	pstmt7 = conn.prepareStatement(docSeq.toString());
		    	rs=pstmt7.executeQuery();
		    	while(rs.next()){
		    		document_id=rs.getString("seq");
		    	}
	    		
	    		
	    		filePath = vTempDir + "/" + fileName ; 
	    		File file = new File(filePath); 
		        fis = new FileInputStream(file);
		        int ilen=(int) file.length();
		        
		        if(ilen>sizeLimit){
		        	StringBuffer sb = new StringBuffer(); 
					sb.append("<script type=\"text/javascript\" >");			 
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					out.println(sb);
					out.flush();
		        }else{
			        insertDoc.delete(0, insertDoc.length());
				    insertDoc.append(" INSERT \n");
				    insertDoc.append("   INTO STX_TBC_INFO_DOC \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("                LIST_ID \n");
				    insertDoc.append("              , DOCUMENT_ID \n");
				    insertDoc.append("              , DOCUMENT_NAME \n");
				    insertDoc.append("              , DOCUMENT_DATA \n");
				    insertDoc.append("              , LAST_UPDATE_DATE \n");
				    insertDoc.append("              , LAST_UPDATED_BY \n");
				    insertDoc.append("              , CREATION_DATE \n");
				    insertDoc.append("              , CREATED_BY \n");
				    insertDoc.append("        ) \n");
				    insertDoc.append("        VALUES \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("				  "+list_id+" \n");
				    insertDoc.append("              , "+document_id+" \n");
				    insertDoc.append("              , '"+fileName+"' \n");
				    insertDoc.append("              , EMPTY_BLOB() \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("        ) \n");
				    
				    pstmt1 = conn.prepareStatement(insertDoc.toString());
				    pstmt1.executeUpdate();
				    
				    selectDoc.delete(0, selectDoc.length());
				    selectDoc.append("select DOCUMENT_DATA	\n");
				    selectDoc.append("	from STX_TBC_INFO_DOC	\n");
				    selectDoc.append(" where document_id = "+document_id+"	\n");
				    
				    pstmt2 = conn.prepareStatement(selectDoc.toString());
				    rset=pstmt2.executeQuery();
				    
				    oracle.sql.BLOB blob  = null;
		            if (rset.next()) blob = (oracle.sql.BLOB)rset.getBlob(1);

		            outstream = blob.getBinaryOutputStream();
		            int size = blob.getBufferSize();
		            finstream = new FileInputStream(file);
		            
		            byte[] buffer = new byte[size];
		            int length = -1;
		            while ((length = finstream.read(buffer)) != -1) {
		                outstream.write(buffer, 0, length);
		            }
		            if (finstream != null) finstream.close();               
		            if (outstream != null) outstream.close(); 
				    
		        }
	    	}
	    	if(!fileName3.equals("")){
	    		//document_id seq 받아오기
	    		StringBuffer docSeq = new StringBuffer();
	    		docSeq.append("select stx_tbc_info_doc_s.nextval as seq from dual	\n");
		    	pstmt7 = conn.prepareStatement(docSeq.toString());
		    	rs=pstmt7.executeQuery();
		    	while(rs.next()){
		    		document_id=rs.getString("seq");
		    	}
	    		
	    		
	    		filePath = vTempDir + "/" + fileName ; 
	    		File file = new File(filePath); 
		        fis = new FileInputStream(file);
		        int ilen=(int) file.length();
		        
		        if(ilen>sizeLimit){
		        	StringBuffer sb = new StringBuffer(); 
					sb.append("<script type=\"text/javascript\" >");			 
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					out.println(sb);
					out.flush();
		        }else{
			        insertDoc.delete(0, insertDoc.length());
				    insertDoc.append(" INSERT \n");
				    insertDoc.append("   INTO STX_TBC_INFO_DOC \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("                LIST_ID \n");
				    insertDoc.append("              , DOCUMENT_ID \n");
				    insertDoc.append("              , DOCUMENT_NAME \n");
				    insertDoc.append("              , DOCUMENT_DATA \n");
				    insertDoc.append("              , LAST_UPDATE_DATE \n");
				    insertDoc.append("              , LAST_UPDATED_BY \n");
				    insertDoc.append("              , CREATION_DATE \n");
				    insertDoc.append("              , CREATED_BY \n");
				    insertDoc.append("        ) \n");
				    insertDoc.append("        VALUES \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("				  "+list_id+" \n");
				    insertDoc.append("              , "+document_id+" \n");
				    insertDoc.append("              , '"+fileName+"' \n");
				    insertDoc.append("              , EMPTY_BLOB() \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("        ) \n");
				    
				    pstmt1 = conn.prepareStatement(insertDoc.toString());
				    pstmt1.executeUpdate();
				    
				    selectDoc.delete(0, selectDoc.length());
				    selectDoc.append("select DOCUMENT_DATA	\n");
				    selectDoc.append("	from STX_TBC_INFO_DOC	\n");
				    selectDoc.append(" where document_id = "+document_id+"	\n");
				    
				    pstmt2 = conn.prepareStatement(selectDoc.toString());
				    rset=pstmt2.executeQuery();
				    
				    oracle.sql.BLOB blob  = null;
		            if (rset.next()) blob = (oracle.sql.BLOB)rset.getBlob(1);

		            outstream = blob.getBinaryOutputStream();
		            int size = blob.getBufferSize();
		            finstream = new FileInputStream(file);
		            
		            byte[] buffer = new byte[size];
		            int length = -1;
		            while ((length = finstream.read(buffer)) != -1) {
		                outstream.write(buffer, 0, length);
		            }
		            if (finstream != null) finstream.close();               
		            if (outstream != null) outstream.close(); 
				    
		        }
	    	}
	    	if(!fileName4.equals("")){
	    		//document_id seq 받아오기
	    		StringBuffer docSeq = new StringBuffer();
	    		docSeq.append("select stx_tbc_info_doc_s.nextval as seq from dual	\n");
		    	pstmt7 = conn.prepareStatement(docSeq.toString());
		    	rs=pstmt7.executeQuery();
		    	while(rs.next()){
		    		document_id=rs.getString("seq");
		    	}
	    		
	    		
	    		filePath = vTempDir + "/" + fileName ; 
	    		File file = new File(filePath); 
		        fis = new FileInputStream(file);
		        int ilen=(int) file.length();
		        
		        if(ilen>sizeLimit){
		        	StringBuffer sb = new StringBuffer(); 
					sb.append("<script type=\"text/javascript\" >");			 
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					out.println(sb);
					out.flush();
		        }else{
			        insertDoc.delete(0, insertDoc.length());
				    insertDoc.append(" INSERT \n");
				    insertDoc.append("   INTO STX_TBC_INFO_DOC \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("                LIST_ID \n");
				    insertDoc.append("              , DOCUMENT_ID \n");
				    insertDoc.append("              , DOCUMENT_NAME \n");
				    insertDoc.append("              , DOCUMENT_DATA \n");
				    insertDoc.append("              , LAST_UPDATE_DATE \n");
				    insertDoc.append("              , LAST_UPDATED_BY \n");
				    insertDoc.append("              , CREATION_DATE \n");
				    insertDoc.append("              , CREATED_BY \n");
				    insertDoc.append("        ) \n");
				    insertDoc.append("        VALUES \n");
				    insertDoc.append("        ( \n");
				    insertDoc.append("				  "+list_id+" \n");
				    insertDoc.append("              , "+document_id+" \n");
				    insertDoc.append("              , '"+fileName+"' \n");
				    insertDoc.append("              , EMPTY_BLOB() \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("              , SYSDATE \n");
				    insertDoc.append("              , '"+user_id+"' \n");
				    insertDoc.append("        ) \n");
				    
				    pstmt1 = conn.prepareStatement(insertDoc.toString());
				    pstmt1.executeUpdate();
				    
				    selectDoc.delete(0, selectDoc.length());
				    selectDoc.append("select DOCUMENT_DATA	\n");
				    selectDoc.append("	from STX_TBC_INFO_DOC	\n");
				    selectDoc.append(" where document_id = "+document_id+"	\n");
				    
				    pstmt2 = conn.prepareStatement(selectDoc.toString());
				    rset=pstmt2.executeQuery();
				    
				    oracle.sql.BLOB blob  = null;
		            if (rset.next()) blob = (oracle.sql.BLOB)rset.getBlob(1);

		            outstream = blob.getBinaryOutputStream();
		            int size = blob.getBufferSize();
		            finstream = new FileInputStream(file);
		            
		            byte[] buffer = new byte[size];
		            int length = -1;
		            while ((length = finstream.read(buffer)) != -1) {
		                outstream.write(buffer, 0, length);
		            }
		            if (finstream != null) finstream.close();               
		            if (outstream != null) outstream.close(); 
				    
		        }
	    	}
		    
		    
		    conn.commit();
		    connERP.commit();
		    StringBuffer sb = new StringBuffer(); 
			sb.append("<script type=\"text/javascript\" >");			 
			sb.append("opener.fn_setListId("+list_id+");");
			sb.append("self.close();");
			sb.append("</script>");
			out.println(sb);
			out.flush();
			
		} catch (Exception e) {
			conn.rollback();
			e.printStackTrace();
			StringBuffer sb = new StringBuffer(); 
			sb.append("<script type=\"text/javascript\" >");			 
			sb.append("alert('업로드 실패');");
			sb.append("self.close();");
			sb.append("</script>");
			out.println(sb);
			out.flush();
			//conn.rollback();
			// TODO: handle exception
		} finally{
			if (pstmt1 != null) {try {pstmt1.close();} catch (Exception e) {}}
			if (pstmt2 != null) {try {pstmt2.close();} catch (Exception e) {}}
			if (pstmt3 != null) {try {pstmt3.close();} catch (Exception e) {}}
			if (pstmt4 != null) {try {pstmt4.close();} catch (Exception e) {}}
			if (pstmt5 != null) {try {pstmt5.close();} catch (Exception e) {}}
			if (pstmt6 != null) {try {pstmt6.close();} catch (Exception e) {}}
			if (rs 	   != null) {try {rs.close();} 	   catch (Exception e) {}}
			if (conn   != null) {try {conn.close();}   catch (Exception e) {}}
			if (fis    != null) {try {fis.close();}    catch (Exception e) {}}
		}
		
	    
		ServiceForward forward = new ServiceForward();
		forward.setRedirect(false);
        forward.setForward(false);
		
		return forward;
	}
}