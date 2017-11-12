package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcItemDiffCheckDao implements Idao{
	

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
		// TODO Auto-generated method stub
		return false;
	}

	public boolean insertDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	ArrayList ar_AllItem = rBox.getArrayList("p_AllItem");
        	ArrayList ar_mail_flag = rBox.getArrayList("p_mail_flag");
        	
        	query  = getQuery(qryExp,rBox);
        	
        	for(int i=0; i<ar_AllItem.size(); i++){
        		pstmt = conn.prepareStatement(query.toString());
        		
        		pstmt.setString(1, ar_mail_flag.get(i).toString());
        		pstmt.setString(2, ar_AllItem.get(i).toString());
        		
            	isOk = pstmt.executeUpdate();
        	}
        	        	
        	if(isOk > 0){
        		conn.commit();
        		rBox.put("successMsg", "Success");
        		rtn = true;
        	}else{
        		conn.rollback();
        		rBox.put("errorMsg", "Fail");
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Fail");
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}

	private String getQuery(String qryExp, RequestBox box)
	{//URLDecoder.decode(box.getString("p_course"),"UTF-8")
		StringBuffer query = new StringBuffer();
		
		String p_project = box.getString("p_project");		
		String p_blockno = box.getString("p_blockno");
				
		int p_nowpage = box.getInt("p_nowpage");
		int p_printlow = box.getInt("p_printlow");
		
		int StartNum = (p_nowpage-1) * p_printlow;
		int EndNum = ((p_nowpage-1) * p_printlow) + p_printlow;
		
		
		try
		{
			if(qryExp.equals("diffCheckList")){
				
				query.append("SELECT * FROM ( \n");
				query.append("  SELECT STP.PROJECT_NO \n");
				query.append("       , STP.BLOCK_NO \n");
				query.append("       , STJC.ACTIVITY_CD \n");
				query.append("       , STP.JOB_CD \n");
				query.append("       , STP.MOTHER_CODE \n");
				query.append("       , '' AS ITEM_CODE \n");
				query.append("    FROM STX_TBC_PENDING STP \n");
				query.append("   INNER JOIN STX_TBC_JOB_CONFIRM STJC ON STP.JOB_CD = CASE WHEN STJC.JOB_CD2 IS NOT NULL THEN STJC.JOB_CD2 ELSE STJC.JOB_CD1 END \n");
				query.append("  UNION ALL \n");
				query.append("  SELECT STP.PROJECT_NO \n");
				query.append("       , STP.BLOCK_NO \n");
				query.append("       , STJC.ACTIVITY_CD \n");
				query.append("       , STP.JOB_CD \n");
				query.append("       , STP.MOTHER_CODE \n");
				query.append("       , STSH.ITEM_CODE \n");
				query.append("    FROM STX_TBC_SSC_HEAD STSH \n");
				query.append("   INNER JOIN STX_TBC_PENDING STP ON STSH.MOTHER_CODE = STP.MOTHER_CODE \n");
				query.append("   INNER JOIN STX_TBC_JOB_CONFIRM STJC ON STP.JOB_CD = CASE WHEN STJC.JOB_CD2 IS NOT NULL THEN STJC.JOB_CD2 ELSE STJC.JOB_CD1 END \n");
				query.append(") \n");
				query.append("WHERE 1=1 \n");
				query.append("ORDER BY PROJECT_NO, BLOCK_NO, ACTIVITY_CD, JOB_CD, MOTHER_CODE \n");
				if(!p_project.equals("")){
					query.append("  AND PROJECT_NO = '"+p_project+"'\n");	
				}
				
				
			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
}