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

public class TbcPendingManagerRestoreDao implements Idao{

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
    	
    	ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        
        try 
        { 
           
            
        	int isEcoCnt = isEco(conn, rBox); 
        	
        	//ECO가 존재하면 복구 실패
        	if(isEcoCnt > 0){
        		isOk = -2;
        	}else{
        		String listKey = "";
        		for(int i = 0; i < ar_chkItem.size(); i++){
        			listKey = ar_chkItem.get(i).toString().split(",",3)[0].trim();
        			
		        	query  = getQuery(qryExp,rBox);
		        	
		        	pstmt = conn.prepareStatement(query.toString());
		        	pstmt.setString(1, listKey);
		        	
		        	isOk += pstmt.executeUpdate();
        		}
        	}  	
        	if(isOk > 0){
        		conn.commit();
        		rBox.put("successMsg", "Success");
        		rtn = true;
        	}else if(isOk == -2){
        		conn.rollback();
        		rBox.put("errorMsg", "BOM 작업 중으로 복구 불가한 Data가 존재합니다.");
        		rtn = false;
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
			if(qryExp.equals("RestoreUpdateAction")){
				
	  			query.append(" MERGE INTO STX_TBC_PENDING A \n");
	  			query.append(" USING ( \n");
	  			query.append("     SELECT * FROM ( \n");
	  			query.append("     SELECT JOB_CD \n");
	  			query.append("			, MOTHER_CODE \n");
	  			query.append("			, PROJECT_NO \n");
	  			query.append("			, ITEM_CATALOG \n");
	  			query.append("			, DWG_NO \n");
	  			query.append("			, STAGE_NO \n");
	  			query.append("			, STR_FLAG \n");
	  			query.append("			, MAIL_FLAG \n");
	  			query.append("			, STATE_FLAG \n");
	  			query.append("			, ACT_FLAG \n");
	  			query.append("			, ECO_NO \n");
	  			query.append("			, USER_ID \n");
	  			query.append("			, CREATE_DATE \n");
	  			query.append("			, TERMINATION_DATE \n");
	  			query.append("			, ACT_CODE \n");
	  			query.append("			, ACT_STARTDATE \n");
	  			query.append("			, ACT_BF_CODE \n");
	  			query.append("			, ACT_BF_STARTDATE \n");
	  			query.append("			, USC_CHG_FLAG \n");
	  			query.append("			, USC_CHG_DATE \n");
	  			query.append("			, DEPT_CODE \n");
	  			query.append("			, SSC_BOM_FLAG \n");
	  			query.append("			, BLOCK_NO \n");
	  			query.append("			, SSC_BOM_DATE \n");
	  			query.append("          , ROW_NUMBER() OVER (ORDER BY HISTORY_UPDATE_DATE DESC) AS CNT \n");
	  			query.append("   FROM STX_TBC_PENDING_HISTORY \n");
	  			query.append("  WHERE JOB_CD || MOTHER_CODE = ? \n");
	  			query.append("    AND ECO_NO IS NOT NULL \n");
	  			query.append("   ) C WHERE C.CNT = 1 \n");
	  			query.append(" ) B \n");
	  			query.append(" ON ( A.JOB_CD = B.JOB_CD \n");
	  			query.append("  AND A.MOTHER_CODE = B.MOTHER_CODE \n");
	  			query.append(" ) \n");
	  			query.append(" WHEN MATCHED THEN \n");
	  			query.append("     UPDATE SET \n");	  			
	  			query.append("			  A.PROJECT_NO             = B.PROJECT_NO \n");
	  			query.append("			, A.ITEM_CATALOG           = B.ITEM_CATALOG \n");
	  			query.append("			, A.DWG_NO                 = B.DWG_NO \n");
	  			query.append("			, A.STAGE_NO               = B.STAGE_NO \n");
	  			query.append("			, A.STR_FLAG               = B.STR_FLAG \n");
	  			query.append("			, A.MAIL_FLAG              = B.MAIL_FLAG \n");
	  			query.append("			, A.STATE_FLAG             = B.STATE_FLAG \n");
	  			query.append("			, A.ACT_FLAG               = B.ACT_FLAG \n");
	  			query.append("			, A.ECO_NO                 = B.ECO_NO \n");
	  			query.append("			, A.USER_ID                = B.USER_ID \n");
	  			query.append("			, A.CREATE_DATE            = B.CREATE_DATE \n");
	  			query.append("			, A.TERMINATION_DATE       = B.TERMINATION_DATE \n");
	  			query.append("			, A.ACT_CODE               = B.ACT_CODE \n");
	  			query.append("			, A.ACT_STARTDATE          = B.ACT_STARTDATE \n");
	  			query.append("			, A.ACT_BF_CODE            = B.ACT_BF_CODE \n");
	  			query.append("			, A.ACT_BF_STARTDATE       = B.ACT_BF_STARTDATE \n");
	  			query.append("			, A.USC_CHG_FLAG           = B.USC_CHG_FLAG \n");
	  			query.append("			, A.USC_CHG_DATE           = B.USC_CHG_DATE \n");
	  			query.append("			, A.DEPT_CODE              = B.DEPT_CODE \n");
	  			query.append("			, A.SSC_BOM_FLAG           = B.SSC_BOM_FLAG \n");
	  			query.append("			, A.BLOCK_NO               = B.BLOCK_NO \n");
	  			query.append("			, A.SSC_BOM_DATE           = B.SSC_BOM_DATE \n");
	  			query.append(" WHEN NOT MATCHED THEN \n");
	  			query.append(" INSERT (   A.JOB_CD \n");
	  			query.append("			, A.MOTHER_CODE \n");
	  			query.append("			, A.PROJECT_NO \n");
	  			query.append("			, A.ITEM_CATALOG \n");
	  			query.append("			, A.DWG_NO \n");
	  			query.append("			, A.STAGE_NO \n");
	  			query.append("			, A.STR_FLAG \n");
	  			query.append("			, A.MAIL_FLAG \n");
	  			query.append("			, A.STATE_FLAG \n");
	  			query.append("			, A.ACT_FLAG \n");
	  			query.append("			, A.ECO_NO \n");
	  			query.append("			, A.USER_ID \n");
	  			query.append("			, A.CREATE_DATE \n");
	  			query.append("			, A.TERMINATION_DATE \n");
	  			query.append("			, A.ACT_CODE \n");
	  			query.append("			, A.ACT_STARTDATE \n");
	  			query.append("			, A.ACT_BF_CODE \n");
	  			query.append("			, A.ACT_BF_STARTDATE \n");
	  			query.append("			, A.USC_CHG_FLAG \n");
	  			query.append("			, A.USC_CHG_DATE \n");
	  			query.append("			, A.DEPT_CODE \n");
	  			query.append("			, A.SSC_BOM_FLAG \n");
	  			query.append("			, A.BLOCK_NO \n");
	  			query.append("			, A.SSC_BOM_DATE \n");
	  			query.append("        ) VALUES ( \n");
	  			query.append("			  B.JOB_CD \n");
	  			query.append("			, B.MOTHER_CODE \n");
	  			query.append("			, B.PROJECT_NO \n");
	  			query.append("			, B.ITEM_CATALOG \n");
	  			query.append("			, B.DWG_NO \n");
	  			query.append("			, B.STAGE_NO \n");
	  			query.append("			, B.STR_FLAG \n");
	  			query.append("			, B.MAIL_FLAG \n");
	  			query.append("			, B.STATE_FLAG \n");
	  			query.append("			, B.ACT_FLAG \n");
	  			query.append("			, B.ECO_NO \n");
	  			query.append("			, B.USER_ID \n");
	  			query.append("			, B.CREATE_DATE \n");
	  			query.append("			, B.TERMINATION_DATE \n");
	  			query.append("			, B.ACT_CODE \n");
	  			query.append("			, B.ACT_STARTDATE \n");
	  			query.append("			, B.ACT_BF_CODE \n");
	  			query.append("			, B.ACT_BF_STARTDATE \n");
	  			query.append("			, B.USC_CHG_FLAG \n");
	  			query.append("			, B.USC_CHG_DATE \n");
	  			query.append("			, B.DEPT_CODE \n");
	  			query.append("			, B.SSC_BOM_FLAG \n");
	  			query.append("			, B.BLOCK_NO \n");
	  			query.append("			, B.SSC_BOM_DATE \n");
	  			query.append("         ) \n");
			} 
			
//			System.out.println(query);
			
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
    		
        	query.append("SELECT COUNT(ECO_NO) AS ITEMCNT FROM STX_TBC_PENDING  \n");
        	query.append("WHERE JOB_CD || MOTHER_CODE IN ( ");
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