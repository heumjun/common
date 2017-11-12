package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Map;
import java.util.StringTokenizer;

import javax.swing.text.html.HTMLDocument.Iterator;

import oracle.jdbc.driver.OracleTypes;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.JsonUtil;
import com.stx.tbc.dao.factory.Idao;

public class TbcDwgPopUpViewDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		
		ArrayList	list = null;
		if(rBox.getString("VIEWMODE").equals("dwgView")){
			//단일 도면 선택 시
			list = procedureDwgViewSEQ(qryExp,rBox);
			
		}else if(rBox.getString("VIEWMODE").equals("dwgChkView")){
			//multiselect 도면 선택 시
			list = procedureCheckDWGViewSEQ(qryExp,rBox);
			
		}else if(qryExp.equals("preViewFileList")){
			list = preViewFileList(qryExp,rBox);
		}
		
		
        return list;
	}
	
	public boolean deleteDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean insertDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}
	
	public ArrayList preViewFileList(String qryExp,RequestBox rBox) throws Exception{
		Connection conn = null;
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
		PreparedStatement pstmt = null;
		String				query		= null;
		
		//java.util.List requiredDWGList = JsonUtil.toList(rBox.get("chmResultList"));
		try
		{
			conn = DBConnect.getDBConnection("PLM");
			list =getFileNameList(conn,rBox);
			conn.commit();
		}
		catch(Exception e)
		{
			if(conn != null)conn.rollback();
			e.printStackTrace();
		}finally{
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		}
		return list;
	}
	
	public ArrayList getFileNameList(Connection conn,RequestBox rBox) throws Exception{
		ArrayList list = null;
		ListSet             ls      	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        String				query		= "";
        PreparedStatement	pstmt		= null;
        
        
        list = new ArrayList();
        query  = getQuery("fileNameList",rBox);           
        
        
		pstmt = conn.prepareStatement(query.toString());
		
		
        ls = new ListSet(conn);
	    ls.run(pstmt);
	    
        while ( ls.next() ){ 
        	resultList = ls.getDataMap();
            list.add(resultList);
        }
        
		return list;
	}
	
	//단일 도면 보기 시 print_seq 가져오기
	public ArrayList procedureDwgViewSEQ(String qryExp, RequestBox rBox) throws Exception{
		StringBuffer sbXml = new StringBuffer();
		Connection conn = null;
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
		CallableStatement cs1 = null;
		CallableStatement cs2 = null;
		PreparedStatement ps = null;
		String sResult = "";
		try
		{
			
			conn = DBConnect.getDBConnection("PLM");	
			conn.setAutoCommit(false);

			cs1 = conn.prepareCall("{call  stx_dwg_plm_view_insert_proc@"+ERP_DB+" (?, ?, ?, ?, ?)}");
			
			cs1.setString(1, rBox.getString("vEmpNo"));
			cs1.setString(2, rBox.getString("P_FILE_NAME")); 
			cs1.registerOutParameter(3, java.sql.Types.INTEGER);
			cs1.registerOutParameter(4, java.sql.Types.VARCHAR);
			cs1.registerOutParameter(5, java.sql.Types.VARCHAR);
			
			cs1.execute();
			
			String sErrCode = cs1.getString(5);
			if (sErrCode != null && !sErrCode.equals("")) 
				sResult = "E";
			else
			{
				int iSeq = cs1.getInt(3);

				cs2 = conn.prepareCall("{call  stx_dwg_pm_scm_view_proc@"+ERP_DB+" (?, ?, ?)}");
				
				cs2.setInt(1, iSeq); 
				cs2.registerOutParameter(2, java.sql.Types.VARCHAR);
				cs2.registerOutParameter(3, java.sql.Types.VARCHAR);
				
				cs2.execute();
				
				String sResult2 = cs2.getString(2);
				if(sResult2!= null && sResult2.equals("S"))
				{
					StringBuffer sbSql = new StringBuffer();
					sbSql.append(" select PML_CODE from STX_DWG_SCM_PRINT_INFO@"+ERP_DB+" \n");
					sbSql.append(" where PRINT_SEQ = "+iSeq+"\n");
					sbSql.append(" order by ROW_SEQ\n");

					ps = conn.prepareStatement(sbSql.toString()); 
					
					
					ls = new ListSet(conn);
				    ls.run(ps);
				    
		            while ( ls.next() ){ 
		            	resultList = ls.getDataMap();
		                list.add(resultList);
		            }
					
					
				}
			}
			conn.commit();
		}
		catch(Exception e)
		{
			if(conn != null)conn.rollback();
			e.printStackTrace();
		}finally{
			if(cs1 != null)cs1.close();
			if(cs2 != null)cs2.close();
			if(ps != null)ps.close();
			if(conn != null)conn.close();
		}
		return list;
	}
	

	
	
	
	//multyselect 도면 보기 시 도면 print_seq 추출
	public ArrayList procedureCheckDWGViewSEQ(String qryExp, RequestBox rBox) throws Exception{
		StringBuffer sbXml = new StringBuffer();
		java.sql.Connection conn = null;
		CallableStatement cs1 = null;
		CallableStatement cs2 = null;
		CallableStatement cs3 = null;
		PreparedStatement ps = null;
		String sResult = "";
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        
		try
		{
			
			conn = DBConnect.getDBConnection("PLM");			
			conn.setAutoCommit(false);

			// 도면 Print Seq 추출
			cs1 = conn.prepareCall("{call  stx_dwg_plm_multi_view_h_proc@"+ERP_DB+" (?, ?, ?, ?)}");
			
			cs1.setString(1, rBox.getString("vEmpNo"));
			cs1.registerOutParameter(2, java.sql.Types.INTEGER);     // P_PRINT_SEQ
			cs1.registerOutParameter(3, java.sql.Types.VARCHAR);     // P_ERROR_MSG
			cs1.registerOutParameter(4, java.sql.Types.VARCHAR);     // P_ERROR_CODE
			
			cs1.execute();
			
			String sErrCode = "";
			sErrCode = cs1.getString(4);

			if (sErrCode != null && !sErrCode.equals("")) 
			{
				sResult = "E";
				throw new Exception(sResult);	
			}
			else
			{
				int iSeq = cs1.getInt(2);

				// 도면 Print table에 Print Seq 별 선택된 도면파일명 저장
				cs2 = conn.prepareCall("{call  stx_dwg_plm_multi_view_d_proc@"+ERP_DB+" (?, ?, ?, ?)}");
				
				// ex: S3027-M1727S01-COV-0010-05.PDF|S3027-M1727S01-COV-0010-06.PDF|S3027-M1727S01-COV-0010-07.PDF
				StringTokenizer st = new StringTokenizer(rBox.getString("P_FILE_NAME"), "|");
				while(st.hasMoreTokens())
				{
					String checkFileName = st.nextToken();
					cs2.setInt(1, iSeq); 
					cs2.setString(2, checkFileName); 
					cs2.registerOutParameter(3, java.sql.Types.VARCHAR);           // P_ERROR_MSG
					cs2.registerOutParameter(4, java.sql.Types.VARCHAR);           // P_ERROR_CODE
					cs2.execute();	
					
					sErrCode = cs2.getString(4);
					
					if (sErrCode != null && !sErrCode.equals("")) 
					{
						sResult = "E";
						throw new Exception(sResult);	
					}					
					
				}		
				
				// DS View 화면 출력 내용 받아오기
				cs3 = conn.prepareCall("{call  stx_dwg_plm_multi_view_proc@"+ERP_DB+" (?, ?, ?)}");
				
				cs3.setInt(1, iSeq);                                          // P_PRINT_SEQ
				cs3.registerOutParameter(2, java.sql.Types.VARCHAR);          // P_PRINT_FLAG
				cs3.registerOutParameter(3, java.sql.Types.VARCHAR);          // P_PRINT_RESULT
				
				cs3.execute();
				
				String sResult2 = cs3.getString(2);
				if(sResult2!= null && sResult2.equals("S"))
				{
					StringBuffer sbSql = new StringBuffer();
					sbSql.append(" select PML_CODE from STX_DWG_SCM_PRINT_INFO@"+ERP_DB+" \n");
					sbSql.append(" where PRINT_SEQ = "+iSeq+"\n");
					sbSql.append(" order by ROW_SEQ\n");

					ps = conn.prepareStatement(sbSql.toString()); 
					
					ls = new ListSet(conn);
				    ls.run(ps);
				    
		            while ( ls.next() ){ 
		            	resultList = ls.getDataMap();
		                list.add(resultList);
		            }				
				}	
			}
			conn.commit();
		}
		catch(Exception e)
		{
			if(conn != null)conn.rollback();
			e.printStackTrace();
		}finally{
			if(cs1 != null)cs1.close();
			if(cs2 != null)cs2.close();
			if(cs3 != null)cs3.close();
			if(ps != null)ps.close();
			if(conn != null)conn.close();
		}
		return list;
	}
	
	private String getQuery(String qryExp, RequestBox box){
		String fromDate = box.getString("fromDate") == null ? "" : box.getString("fromDate").toString();
		String toDate	= box.getString("ToDate") == null	? "" : box.getString("ToDate").toString();
		String shipNo	= box.getString("shipNo") == null	? "" : box.getString("shipNo").toString();
		String dwgNo	= box.getString("dwgNo") == null	? "" : box.getString("dwgNo").toString();
		String blockNo	= box.getString("blockNo") == null	? "" : box.getString("blockNo").toString();
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("list")){
				
			}
			else if(qryExp.equals("fileNameList")){
				query.append("select t3.file_name \n");
				query.append("  from stx_tbc_dwg_trans         t1 \n");
				query.append("      ,stx_tbc_dwg_trans_detail  t2 \n");
				query.append("      ,STX_DWG_DW302TBL@"+ERP_DB+"   t3 \n");
				query.append(" where 1=1 \n");
				query.append("   and t1.req_seq = t2.req_seq \n");
				query.append("   and t2.req_dwg_seq_id = t3.dwg_seq_id \n");
				query.append("   and t1.req_seq = '"+box.get("req_seq")+"' \n");

			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
}