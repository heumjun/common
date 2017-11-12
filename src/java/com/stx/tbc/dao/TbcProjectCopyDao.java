package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcProjectCopyDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
        try 
        { 
            list = new ArrayList();
            query  = getQuery(qryExp,rBox);           

			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){ 
                dbox = ls.getDataBox();
                list.add(dbox);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return list;
	}
	
	public boolean deleteDB(String qryExp, RequestBox rBox) throws Exception {
		//TODO Auto-generated method stub
		return false;
	}

	public boolean insertDB(String qryExp, RequestBox rBox) throws Exception {
//		 TODO Auto-generated method stub
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	CallableStatement cstmt = null;
    	
    	ArrayList ar_series = rBox.getArrayList("p_series");
    	
    	
        try 
        { 
        	query  = getQuery(qryExp,rBox);
        	cstmt = conn.prepareCall(query.toString());
       	            
        	String msg = "";
        	int ssc_cnt = 0;
        	String ssc_msg = "";
        	
        	for(int i=0; i < ar_series.size(); i++){
        		
	        	cstmt.setString(1, rBox.getString("p_item_type_cd"));
	        	cstmt.setString(2, rBox.getString("p_project_no"));
	        	cstmt.setString(3, ar_series.get(i).toString());
	        	cstmt.setString(4, rBox.getString("p_dwg_no"));
	        	cstmt.setString(5, rBox.getString("p_block_no"));
	        	cstmt.setString(6, rBox.getString("p_stage_no"));
	        	cstmt.setString(7, rBox.getString("p_str_flag"));
	        	cstmt.setString(8, rBox.getSession("DeptCode"));
	    		cstmt.setString(9, rBox.getSession("DeptName"));
	    		cstmt.setString(10, rBox.getSession("UserId"));
	    		cstmt.setString(11, rBox.getSession("UserName"));    		
	    		cstmt.registerOutParameter(12, Types.NUMERIC);
	    		cstmt.registerOutParameter(13, Types.VARCHAR);
	    		cstmt.registerOutParameter(14, Types.NUMERIC);	    		
	    		
	    		cstmt.executeQuery();
	    		isOk += cstmt.getInt(12);
	    		msg = cstmt.getString(13);
	    		ssc_cnt = cstmt.getInt(14);
	    		
//	    		System.out.println("isOk : "+isOk);
//	    		System.out.println("msg : "+msg);
	    		ssc_msg += ar_series.get(i).toString() + " : " + ssc_cnt + "�� �Ϸ� \\n";
	    		
        	}
        	
//        	System.out.println(isOk);
        	if(isOk == ar_series.size()){
        		conn.commit();
        		rBox.put("successMsg", "�� SUCCESS �� \\n" + ssc_msg);
        		rtn = true;
        	}else{
        		conn.rollback();
        		if(!msg.equals("")){
        			rBox.put("errorMsg", "Fail : " +msg);
        		}else{
        			rBox.put("errorMsg", "Fail");
        		}
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Fail");
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {		
		return false;
	}

	private String getQuery(String qryExp, RequestBox box)
	{//URLDecoder.decode(box.getString("p_course"),"UTF-8")
		StringBuffer query = new StringBuffer();
		try
		{
			if(qryExp.equals("selectCopyList")){
				String p_item_type_cd = box.getString("p_item_type_cd");
				String p_project_no = box.getString("p_project_no");
				String p_dwg_no = box.getString("p_dwg_no");
				String p_block_no = box.getString("p_block_no");
				String p_stage_no = box.getString("p_stage_no");
				String p_str_flag = box.getString("p_str_flag");
				String p_dept_code = box.getString("p_dept_code");
				
				query.append("SELECT STSH.ITEM_TYPE_CD \n");
				query.append("     , STSH.PROJECT_NO \n");
				query.append("     , STSH.DWG_NO \n");
				query.append("     , STP.BLOCK_NO \n");
				query.append("     , STP.STAGE_NO \n");
				query.append("     , STP.STR_FLAG \n");
				query.append("     , STP.MOTHER_CODE \n");
				query.append("     , COUNT(STSH.ITEM_CODE) AS LINE_CNT \n");
				query.append("     , SUM(STSH.BOM_QTY) AS TOTAL_EA \n");
				query.append("     , SUM(STI.ITEM_WEIGHT) AS TOTAL_WEIGHT \n");
				query.append("     , (SELECT PA.DWGTITLE \n");
				query.append("          FROM DPM_ACTIVITY@"+DP_DB+" PA \n");
				query.append("         WHERE PA.CASENO = '1' \n");
				query.append("           AND PA.ACTIVITYCODE LIKE STSH.DWG_NO || '%' \n");
				query.append("           AND PROJECTNO = STSH.MASTER_SHIP \n");
				query.append("           AND ROWNUM = 1 ) AS DWG_DESC \n");
				query.append("  FROM STX_DIS_SSC_HEAD STSH \n");
				query.append(" INNER JOIN STX_DIS_PENDING STP ON STSH.MOTHER_CODE = STP.MOTHER_CODE \n");
				query.append(" INNER JOIN STX_DIS_ITEM STI ON STSH.ITEM_CODE = STI.ITEM_CODE \n");
				query.append(" WHERE STSH.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				query.append("   AND STSH.PROJECT_NO = '"+p_project_no+"' \n");
				query.append("   AND STSH.STATE_FLAG IN ('A', 'C') \n");
				
				if(!p_dwg_no.equals("")){
					query.append("   AND STSH.DWG_NO = '"+p_dwg_no+"' \n");	
				}
				if(!p_block_no.equals("")){
					query.append("   AND STP.BLOCK_NO = '"+p_block_no+"' \n");	
				}
				if(!p_stage_no.equals("")){
					query.append("   AND STP.STAGE_NO = '"+p_stage_no+"' \n");
				}else{
					if(!p_str_flag.equals("")){
						query.append("   AND STP.STAGE_NO IS NULL \n");
					}
				}
				if(!p_str_flag.equals("")){
					query.append("   AND STP.STR_FLAG = '"+p_str_flag+"' \n");	
				}
				
				if(!p_dept_code.equals("")){
					query.append("   AND STSH.DEPT_CODE = '"+p_dept_code+"' \n");	
				}
				
				query.append(" GROUP BY STSH.ITEM_TYPE_CD \n");
				query.append("        , STSH.PROJECT_NO \n");
				query.append("        , STSH.DWG_NO \n");
				query.append("        , STP.BLOCK_NO \n");
				query.append("        , STP.STAGE_NO \n");
				query.append("        , STP.STR_FLAG \n");
				query.append("        , STP.MOTHER_CODE \n");
				query.append("        , STSH.MASTER_SHIP  \n");
				query.append(" ORDER BY DWG_NO, BLOCK_NO, STAGE_NO, STR_FLAG \n");
				
			} else if(qryExp.equals("insertCopyAction")){
				
				query.append("{call STX_DIS_PROJECT_COPY_PROC(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ");
				
			} 
			
			System.out.println(query);
			
		}catch (Exception e) 
		{
			// TODO: handle exception
		}
		return query.toString();
	}
	
	public int isEco(Connection conn, RequestBox box) throws Exception {
        
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int isEcoCnt = 0;
        
    	try 
        { 
    		ArrayList list = box.getArrayList("p_chkItem");
    		
        	query.append("SELECT COUNT(ECO_NO) AS ITEMCNT FROM STX_DIS_SSC_HEAD  \n");
        	query.append("WHERE SSC_SUB_ID IN ( ");
			for(int i = 0; i < list.size(); i++){
				if(i != 0) query.append(",");
				query.append("'"+list.get(i)+"'");
  		    }
			query.append(" ) ");
			query.append("  AND ECO_NO IS NOT NULL");
			pstmt = conn.prepareStatement(query.toString());
			//System.out.println(query);
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	isEcoCnt = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return isEcoCnt;
	}
}