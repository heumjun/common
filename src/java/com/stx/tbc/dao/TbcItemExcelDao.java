package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcItemExcelDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("TPI_TRIBON");
		
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
			
			pstmt.setString(1, rBox.getStringDefault("p_project", "S1597AC"));
			pstmt.setString(2, rBox.getStringDefault("p_block", "903"));
            
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
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("TPI_TRIBON");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 		= null;
        int 				isOk 		= 0;
        int 				isAllOk 	= 1;
        boolean				rtn			= true;
        String 				query 		= "";
        try {
        	
        	
        	query  = getQuery(qryExp,rBox);
  			ArrayList list = (ArrayList)rBox.getObject("ExcelList");
  			HashMap dbox = null;
  			
        	for(int i = 0; i < list.size(); i++){        		
        		dbox = (HashMap)list.get(i);        		
        		pstmt = conn.prepareStatement(query.toString());
        		
        		pstmt.setString(1, (String)dbox.get("test1"));
        		pstmt.setString(2, (String)dbox.get("test2"));
        		pstmt.setString(3, (String)dbox.get("test3"));
        		pstmt.setString(4, (String)dbox.get("test4"));
        		pstmt.setString(5, (String)dbox.get("test5"));
        		pstmt.setString(6, (String)dbox.get("test6"));
        		pstmt.setString(7, (String)dbox.get("test7"));
        		
    		    isOk  = pstmt.executeUpdate();
    		    
    		    //한개라도 실패한다면 실패
    		    if(isOk < 0){
    		    	isAllOk = 0;
    		    }
        	}
        	
		    //결과 성공 여부 결정
		    if(isAllOk != 1){
		    	rBox.put("errorMsg", "Data Error!");
		    	rtn = false;
		    	conn.rollback();
		    }else{
		    	rBox.put("successMsg", "Success Data Insert!");
		    	rtn = true;
		    	conn.commit();
			}
        }
        catch ( Exception ex ) { 
        	rtn = false;
        	ex.printStackTrace();
        }
        finally {
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		
		return rtn;
	}
	
	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	private String getQuery(String qryExp, RequestBox box)
	{//URLDecoder.decode(box.getString("p_course"),"UTF-8")
		StringBuffer query = new StringBuffer();
		
		try
		{
			if(qryExp.equals("list")){
				query.append("select rowid , a.* ");
				query.append("  from ELEC_CABLE_LIST a ");
				query.append(" where mast_project_no = ? ");
				query.append("   and block_no = ? ");
				query.append("   and (item_state is null or item_state in ('A','D','C')) ");
	  			query.append(" order by cable_name , revision desc ");
			} else if(qryExp.equals("addExcelInsert")){

	        	query.append("insert into elec_cable_list( ");
	  			query.append("	PROJECT_NO, ");
	  			query.append("	BLOCK_NO, ");
	  			query.append("	CABLE_NAME, ");
	  			query.append("	COMP_NAME, ");
	  			query.append("	POR_LENGTH, ");
	  			query.append("	WEIGHT, ");
	  			query.append("	REVISION)");
	  			query.append("VALUES (");
	  			query.append("	?, "); 
	  			query.append("	?, ");
	  			query.append("	?, ");
	  			query.append("	?, ");
	  			query.append("	?, ");
	  			query.append("	?, ");
	  			query.append("	? ) ");
			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
}