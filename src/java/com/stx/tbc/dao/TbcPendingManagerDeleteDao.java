package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcPendingManagerDeleteDao implements Idao{

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
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
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
    	int 				isAllOk    = 0;
    	String				query   = "";
    	String				vErrMsg = "Fail";
        try 
        { 
        	ArrayList chklist = rBox.getArrayList("p_chkItem");
        	
        	String eco_no = "";
        	String mother_code = "";
        	String listKey = "";
        	int vIsValidation = 0;
        	for(int i=0; i<chklist.size(); i++){
        		listKey = chklist.get(i).toString().split(",",3)[0].trim();
        		eco_no = chklist.get(i).toString().split(",",3)[1].trim();
        		mother_code = chklist.get(i).toString().split(",",3)[2].trim();
        		if(validationEndItemExist(conn, mother_code)){
	        		if(!eco_no.equals("")){	
	        			query  = getQuery("DValueAction",rBox);
	    	        }else{	    	        	
    	        		query  = getQuery("DeleteAction",rBox);	    	        	
	    	        }
	        		
	        		pstmt = conn.prepareStatement(query.toString());
	            	pstmt.setString(1, listKey);
	        		isOk = pstmt.executeUpdate();
	        		
	        		if(isOk > 0){
	        			isAllOk++;
	        		}
        		}else{
        			vIsValidation = -1;
        		}
        	}
        	
        	if(isAllOk == chklist.size()){
        		conn.commit();
        		rBox.put("successMsg", "Success");
        		rtn = true;
        	}else{
        		if(vIsValidation != 0){
        			vErrMsg = "하위 ITEM이 존재하는 Pending Item이 있습니다.";
        		}
        		conn.rollback();
        		rBox.put("errorMsg", vErrMsg);
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
		
		try
		{
			if(qryExp.equals("DeleteAction")){
				
  				query.append("DELETE STX_DIS_PENDING \n");
				query.append(" WHERE JOB_CD || MOTHER_CODE = ? \n");
				
			} else if(qryExp.equals("DValueAction")){
				query.append("UPDATE STX_DIS_PENDING \n");
				query.append("SET STATE_FLAG = 'D' \n");
				query.append("  , ECO_NO = '' \n");
				query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
				
			} 
			
			
		}catch (Exception e) 
		{
			// TODO: handle exception
		}
		return query.toString();
	}
	
	
	/** 신규 : j.h.BAEK 2014/06/23
	 * 하위 아이템이 달려 있는지 판단.
	 * Param : Connection, RequestBox
	 * Return : end Itme 이 있으면 False / 없으면 True
	 * Comm : True시 삭제 가능. */
	public boolean validationEndItemExist(Connection conn, String mother_code) throws Exception {
		
		conn = DBConnect.getDBConnection("DIS");
		
        ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query 		= new StringBuffer();
    	int					vEndCnt		= 0;
    	boolean				vRtn		= true;
        try 
        { 
        	query.append("SELECT SUM(QTY) ENDCNT \n");
        	query.append("    FROM ( \n");
        	query.append("          SELECT CASE \n");
        	query.append("              WHEN B.ECO_NO IS NOT NULL AND (B.STATE_FLAG = 'A' OR B.STATE_FLAG = 'C') THEN B.BOM_QTY \n");
        	query.append("              WHEN B.ECO_NO IS NULL AND (B.STATE_FLAG = 'D' OR B.STATE_FLAG = 'C') THEN \n");
        	query.append("                   (SELECT SUM(BOM_QTY) FROM \n");
        	query.append("                         (SELECT ROW_NUMBER() OVER (PARTITION BY ITEM_CODE ORDER BY HISTORY_UPDATE_DATE DESC) AS CNT \n");
        	query.append("                               , MOTHER_CODE \n");
        	query.append("                               , ITEM_CODE \n");
        	query.append("                               , BOM_QTY \n");
        	query.append("                            FROM STX_DIS_SSC_HEAD_HISTORY \n");
        	query.append("                           WHERE ECO_NO IS NOT NULL \n");
        	query.append("                    )DD \n");
        	query.append("                    WHERE CNT = 1 \n");
        	query.append("                      AND MOTHER_CODE = B.MOTHER_CODE \n");
        	query.append("                    GROUP BY MOTHER_CODE ) \n");
        	query.append("              ELSE 0 \n");
        	query.append("            END AS QTY \n");
        	query.append("            , MOTHER_CODE \n");
        	query.append("          FROM STX_DIS_SSC_HEAD B \n");
        	query.append("         WHERE B.MOTHER_CODE = '"+mother_code+"' \n");
        	query.append("   ) T  \n");
               
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	//0보다 크면 false
            	if(ls.getInt(1) > 0){
                	vRtn = false;
                }
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
        return vRtn;
	}
}