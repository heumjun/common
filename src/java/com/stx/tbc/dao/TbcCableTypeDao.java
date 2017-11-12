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

public class TbcCableTypeDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		
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
		conn = DBConnect.getDBConnection("PLM");
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	
        try 
        { 
        	query  = getQuery(qryExp,rBox);
        	pstmt = conn.prepareStatement(query.toString());
        	
        	isOk = pstmt.executeUpdate();
        		
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
        	conn.rollback();
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
		try
		{
			if(qryExp.equals("selectCableType")){
				
				String type_abbr = box.getString("p_type_abbr");
				
				query.append("SELECT TYPE_ABBR \n");
				query.append("     , TYPE_SPEC \n");
				query.append("     , TYPE_TYPE \n");
				query.append("     , TYPE_WEIGHT \n");
				query.append("     , TYPE_AREA \n");
				query.append("     , OUT_DIA \n");
				query.append("     , INSERT_BLOCK \n");
				query.append("     , DRUM_LEN \n");
				query.append("     , UOM \n");
				query.append("     , LOC_CLASS \n");
				query.append("     , BIND_GROUP \n");
				query.append("     , CREATE_DATE \n");
				query.append("     , CREATE_USER \n");
				query.append("     , LAST_UPDATE_DATE \n");
				query.append("     , LAST_UPDATE_USER \n");
				query.append("  FROM STX_TBC_CABLE_TYPE \n");
				query.append(" WHERE TYPE_ABBR LIKE '%"+type_abbr+"%' \n");
				
			}
		}catch (Exception e) 
		{
			// TODO: handle exception
		}
		return query.toString();
	}
}
