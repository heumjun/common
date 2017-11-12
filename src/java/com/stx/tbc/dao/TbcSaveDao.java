package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcSaveDao implements Idao{

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
		// TODO Auto-generated method stub
		return false;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
//		 TODO Auto-generated method stub
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	ArrayList ar_AllItem = rBox.getArrayList("p_AllItem");  			
  			ArrayList ar_rev_no = rBox.getArrayList("p_rev_no");
  			ArrayList ar_remark = rBox.getArrayList("p_remark");
  			
        	query  = getQuery(qryExp,rBox);
    		pstmt = conn.prepareStatement(query.toString());
    		
        	for(int i = 0; i < ar_AllItem.size(); i++){
        		
        		int idx = 0;
        		pstmt.setString(++idx, ar_remark.get(i).toString());
        		pstmt.setString(++idx, ar_rev_no.get(i).toString());
        		pstmt.setString(++idx, ar_AllItem.get(i).toString());
        		
        		isOk += pstmt.executeUpdate();
        	}
        	
        	
        	if(isOk == ar_AllItem.size()){        		
        		conn.commit();
        		rBox.put("successMsg", "Data Save Success");
        		rtn = true;
        	}else{
        		conn.rollback();
        		rBox.put("errorMsg", "Data Save Fail");
        		rtn = false;
        	}
        	
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Data Process Fail");
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
		try
		{
			if(qryExp.equals("SaveUpdateAction")){
	  			
	  			query.append("UPDATE STX_DIS_SSC_HEAD \n");
	  			query.append("SET REMARK = ? \n");
	  			query.append("  , REV_NO = ? \n");
	  			query.append("WHERE PROJECT_NO || ITEM_TYPE_CD || DWG_NO || MOTHER_CODE || ITEM_CODE || SSC_SUB_ID = ? \n");
			}
			
		}catch (Exception e) 
		{
			// TODO: handle exception
		}
		return query.toString();
	}
}