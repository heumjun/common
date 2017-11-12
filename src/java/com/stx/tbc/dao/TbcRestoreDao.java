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

public class TbcRestoreDao implements Idao{

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
    	
    	ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        
        try 
        { 
           
            
        	int isEcoCnt = isEco(conn, rBox); 
        	
        	//ECO가 존재하면 복구 실패
        	if(isEcoCnt > 0){
        		isOk = -2;
        	}else{
        		for(int i = 0; i < ar_chkItem.size(); i++){
		        	query  = getQuery(qryExp,rBox);
		        	pstmt = conn.prepareStatement(query.toString());
		        	
		        	pstmt.setString(1, ar_chkItem.get(i).toString());
		        	
		        	isOk = pstmt.executeUpdate();
        		}
        	}  	
        	if(isOk > 0){
        		conn.commit();
        		rBox.put("successMsg", "Data Process Success");
        		rtn = true;
        	}else if(isOk == -2){
        		conn.rollback();
        		rBox.put("errorMsg", "BOM 작업 중으로 복구 불가한 Data가 존재합니다.");
        		rtn = false;
        	}else{
        		conn.rollback();
        		rBox.put("errorMsg", "Data Process Fail");
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
			if(qryExp.equals("RestoreUpdateAction")){
				
	  			query.append(" MERGE INTO STX_DIS_SSC_HEAD A \n");
	  			query.append(" USING ( \n");
	  			query.append("     SELECT * FROM ( \n");
	  			query.append("     SELECT  PROJECT_NO \n");
	  			query.append("         , ITEM_TYPE_CD \n");
	  			query.append("         , DWG_NO \n");
	  			query.append("         , MOTHER_CODE \n");
	  			query.append("         , ITEM_CODE \n");
	  			query.append("         , SSC_SUB_ID \n");
	  			query.append("         , CAD_SUB_ID \n");
//	  			query.append("         , BLOCK_NO \n");
//	  			query.append("         , STAGE_NO \n");
//	  			query.append("         , STR_FLAG \n");
	  			query.append("         , REV_NO \n");
	  			query.append("         , BOM1 \n");
	  			query.append("         , BOM2 \n");
	  			query.append("         , BOM3 \n");
	  			query.append("         , BOM4 \n");
	  			query.append("         , BOM5 \n");
	  			query.append("         , BOM6 \n");
	  			query.append("         , BOM7 \n");
	  			query.append("         , BOM8 \n");
	  			query.append("         , BOM9 \n");
	  			query.append("         , BOM10 \n");
	  			query.append("         , BOM11 \n");
	  			query.append("         , BOM12 \n");
	  			query.append("         , BOM13 \n");
	  			query.append("         , BOM14 \n");
	  			query.append("         , BOM15 \n");
	  			query.append("         , SUPPLY_TYPE \n");
	  			query.append("         , BLOCK_DIV \n");
	  			query.append("         , BLOCK_CHG_DATE \n");
	  			query.append("         , JOB \n");
	  			query.append("         , JOB_CHG_DATE \n");
	  			query.append("         , UPP_CHG_FLAG \n");
	  			query.append("         , UPP_CHG_DATE \n");
	  			query.append("         , DEPT_CODE \n");
	  			query.append("         , DEPT_NAME \n");
	  			query.append("         , DWG_CHECK \n");
	  			query.append("         , BOM_QTY \n");
	  			query.append("         , ECO_NO \n");
	  			query.append("         , MASTER_SHIP \n");
	  			query.append("         , MOVE_CODE \n");
	  			query.append("         , MOVE_EA \n");
	  			query.append("         , MOVE_JOB \n");
	  			query.append("         , PAINT_CODE3 \n");
	  			query.append("         , PAINT_CODE4 \n");
	  			query.append("         , PAINT_CODE5 \n");
	  			query.append("         , RAW_LV \n");
	  			query.append("         , REMARK \n");
	  			query.append("         , STATE_FLAG \n");
	  			query.append("         , KEY_NO \n");
	  			query.append("         , USER_ID \n");
	  			query.append("         , USER_NAME \n");
	  			query.append("         , CREATE_DATE \n");
	  			query.append("         , HISTORY_UPDATED_ID \n");
	  			query.append("         , HISTORY_UPDATE_DATE \n");
	  			query.append("         , BOM_ITEM_DETAIL \n");
	  			query.append("         , UPP_CONFIRM_DATE \n");
	  			query.append("         , MOVE_SSC_DATE \n");
	  			query.append("         , ROW_NUMBER() OVER (ORDER BY HISTORY_UPDATE_DATE DESC) AS CNT \n");
	  			query.append("   FROM STX_DIS_SSC_HEAD_HISTORY \n");
	  			query.append("  WHERE SSC_SUB_ID  = ? \n");
	  			query.append("    AND ECO_NO IS NOT NULL \n");
	  			query.append("   ) C WHERE C.CNT = 1 \n");
	  			query.append(" ) B \n");
	  			query.append(" ON ( A.SSC_SUB_ID = B.SSC_SUB_ID \n");
	  			query.append(" AND A.PROJECT_NO = B.PROJECT_NO \n");
	  			query.append(" AND A.ITEM_TYPE_CD = B.ITEM_TYPE_CD \n");
	  			query.append(" AND A.DWG_NO = B.DWG_NO \n");
	  			query.append(" AND A.MOTHER_CODE = B.MOTHER_CODE \n");
	  			query.append(" AND A.ITEM_CODE = B.ITEM_CODE ) \n");
	  			query.append(" \n");
	  			query.append(" WHEN MATCHED THEN \n");
	  			query.append("     UPDATE SET \n");
//	  			query.append("       A.BLOCK_NO       = B.BLOCK_NO \n");
//	  			query.append("     , A.STAGE_NO       = B.STAGE_NO \n");
//	  			query.append("     , A.STR_FLAG       = B.STR_FLAG \n");
	  			query.append("       A.REV_NO         = B.REV_NO \n");
	  			query.append("     , A.BOM1           = B.BOM1 \n");
	  			query.append("     , A.BOM2           = B.BOM2 \n");
	  			query.append("     , A.BOM3           = B.BOM3 \n");
	  			query.append("     , A.BOM4           = B.BOM4 \n");
	  			query.append("     , A.BOM5           = B.BOM5 \n");
	  			query.append("     , A.BOM6           = B.BOM6 \n");
	  			query.append("     , A.BOM7           = B.BOM7 \n");
	  			query.append("     , A.BOM8           = B.BOM8 \n");
	  			query.append("     , A.BOM9           = B.BOM9 \n");
	  			query.append("     , A.BOM10          = B.BOM10 \n");
	  			query.append("     , A.BOM11          = B.BOM11 \n");
	  			query.append("     , A.BOM12          = B.BOM12 \n");
	  			query.append("     , A.BOM13          = B.BOM13 \n");
	  			query.append("     , A.BOM14          = B.BOM14 \n");
	  			query.append("     , A.BOM15          = B.BOM15 \n");
	  			query.append("     , A.SUPPLY_TYPE    = B.SUPPLY_TYPE \n");
	  			query.append("     , A.BLOCK_DIV      = B.BLOCK_DIV \n");
	  			query.append("     , A.BLOCK_CHG_DATE = B.BLOCK_CHG_DATE \n");
	  			query.append("     , A.JOB            = B.JOB \n");
	  			query.append("     , A.JOB_CHG_DATE   = B.JOB_CHG_DATE \n");
	  			query.append("     , A.UPP_CHG_FLAG   = B.UPP_CHG_FLAG \n");
	  			query.append("     , A.UPP_CHG_DATE   = B.UPP_CHG_DATE \n");
	  			query.append("     , A.DEPT_CODE      = B.DEPT_CODE \n");
	  			query.append("     , A.DEPT_NAME      = B.DEPT_NAME \n");
	  			query.append("     , A.DWG_CHECK      = B.DWG_CHECK \n");
	  			query.append("     , A.BOM_QTY        = B.BOM_QTY \n");
	  			query.append("     , A.ECO_NO         = B.ECO_NO \n");
	  			query.append("     , A.MASTER_SHIP    = B.MASTER_SHIP \n");
	  			query.append("     , A.MOVE_CODE      = B.MOVE_CODE \n");
	  			query.append("     , A.MOVE_EA        = B.MOVE_EA \n");
	  			query.append("     , A.MOVE_JOB       = B.MOVE_JOB \n");
	  			query.append("     , A.PAINT_CODE3    = B.PAINT_CODE3 \n");
	  			query.append("     , A.PAINT_CODE4    = B.PAINT_CODE4 \n");
	  			query.append("     , A.PAINT_CODE5    = B.PAINT_CODE5 \n");
	  			query.append("     , A.RAW_LV         = B.RAW_LV \n");
	  			query.append("     , A.REMARK         = B.REMARK \n");
	  			query.append("     , A.STATE_FLAG     = B.STATE_FLAG \n");
	  			query.append("     , A.KEY_NO         = B.KEY_NO \n");
	  			query.append("     , A.USER_ID        = B.USER_ID \n");
	  			query.append("     , A.USER_NAME      = B.USER_NAME \n");
	  			query.append("     , A.CREATE_DATE    = B.CREATE_DATE \n");
	  			query.append("     , A.BOM_ITEM_DETAIL  = B.BOM_ITEM_DETAIL \n");
	  			query.append("     , A.UPP_CONFIRM_DATE = B.UPP_CONFIRM_DATE \n");
	  			query.append("     , A.MOVE_SSC_DATE  = B.MOVE_SSC_DATE \n");
	  			query.append(" WHEN NOT MATCHED THEN \n");
	  			query.append(" INSERT (  A.PROJECT_NO \n");
	  			query.append("         , A.ITEM_TYPE_CD \n");
	  			query.append("         , A.DWG_NO \n");
	  			query.append("         , A.MOTHER_CODE \n");
	  			query.append("         , A.ITEM_CODE \n");
	  			query.append("         , A.SSC_SUB_ID \n");
	  			query.append("         , A.CAD_SUB_ID \n");
//	  			query.append("         , A.BLOCK_NO \n");
//	  			query.append("         , A.STAGE_NO \n");
//	  			query.append("         , A.STR_FLAG \n");
	  			query.append("         , A.REV_NO \n");
	  			query.append("         , A.BOM1 \n");
	  			query.append("         , A.BOM2 \n");
	  			query.append("         , A.BOM3 \n");
	  			query.append("         , A.BOM4 \n");
	  			query.append("         , A.BOM5 \n");
	  			query.append("         , A.BOM6 \n");
	  			query.append("         , A.BOM7 \n");
	  			query.append("         , A.BOM8 \n");
	  			query.append("         , A.BOM9 \n");
	  			query.append("         , A.BOM10 \n");
	  			query.append("         , A.BOM11 \n");
	  			query.append("         , A.BOM12 \n");
	  			query.append("         , A.BOM13 \n");
	  			query.append("         , A.BOM14 \n");
	  			query.append("         , A.BOM15 \n");
	  			query.append("         , A.SUPPLY_TYPE \n");
	  			query.append("         , A.BLOCK_DIV \n");
	  			query.append("         , A.BLOCK_CHG_DATE \n");
	  			query.append("         , A.JOB \n");
	  			query.append("         , A.JOB_CHG_DATE \n");
	  			query.append("         , A.UPP_CHG_FLAG \n");
	  			query.append("         , A.UPP_CHG_DATE \n");
	  			query.append("         , A.DEPT_CODE \n");
	  			query.append("         , A.DEPT_NAME \n");
	  			query.append("         , A.DWG_CHECK \n");
	  			query.append("         , A.BOM_QTY \n");
	  			query.append("         , A.ECO_NO \n");
	  			query.append("         , A.MASTER_SHIP \n");
	  			query.append("         , A.MOVE_CODE \n");
	  			query.append("         , A.MOVE_EA \n");
	  			query.append("         , A.MOVE_JOB \n");
	  			query.append("         , A.PAINT_CODE3 \n");
	  			query.append("         , A.PAINT_CODE4 \n");
	  			query.append("         , A.PAINT_CODE5 \n");
	  			query.append("         , A.RAW_LV \n");
	  			query.append("         , A.REMARK \n");
	  			query.append("         , A.STATE_FLAG \n");
	  			query.append("         , A.KEY_NO \n");
	  			query.append("         , A.USER_ID \n");
	  			query.append("         , A.USER_NAME \n");
	  			query.append("         , A.CREATE_DATE  \n");
	  			query.append("         , A.BOM_ITEM_DETAIL  \n");
	  			query.append("         , A.UPP_CONFIRM_DATE \n");
	  			query.append("         , A.MOVE_SSC_DATE \n");
	  			query.append("        ) VALUES ( \n");
	  			query.append("           B.PROJECT_NO \n");
	  			query.append("         , B.ITEM_TYPE_CD \n");
	  			query.append("         , B.DWG_NO \n");
	  			query.append("         , B.MOTHER_CODE \n");
	  			query.append("         , B.ITEM_CODE \n");
	  			query.append("         , B.SSC_SUB_ID \n");
	  			query.append("         , B.CAD_SUB_ID \n");
//	  			query.append("         , B.BLOCK_NO \n");
//	  			query.append("         , B.STAGE_NO \n");
//	  			query.append("         , B.STR_FLAG \n");
	  			query.append("         , B.REV_NO \n");
	  			query.append("         , B.BOM1 \n");
	  			query.append("         , B.BOM2 \n");
	  			query.append("         , B.BOM3 \n");
	  			query.append("         , B.BOM4 \n");
	  			query.append("         , B.BOM5 \n");
	  			query.append("         , B.BOM6 \n");
	  			query.append("         , B.BOM7 \n");
	  			query.append("         , B.BOM8 \n");
	  			query.append("         , B.BOM9 \n");
	  			query.append("         , B.BOM10 \n");
	  			query.append("         , B.BOM11 \n");
	  			query.append("         , B.BOM12 \n");
	  			query.append("         , B.BOM13 \n");
	  			query.append("         , B.BOM14 \n");
	  			query.append("         , B.BOM15 \n");
	  			query.append("         , B.SUPPLY_TYPE \n");
	  			query.append("         , B.BLOCK_DIV \n");
	  			query.append("         , B.BLOCK_CHG_DATE \n");
	  			query.append("         , B.JOB \n");
	  			query.append("         , B.JOB_CHG_DATE \n");
	  			query.append("         , B.UPP_CHG_FLAG \n");
	  			query.append("         , B.UPP_CHG_DATE \n");
	  			query.append("         , B.DEPT_CODE \n");
	  			query.append("         , B.DEPT_NAME \n");
	  			query.append("         , B.DWG_CHECK \n");
	  			query.append("         , B.BOM_QTY \n");
	  			query.append("         , B.ECO_NO \n");
	  			query.append("         , B.MASTER_SHIP \n");
	  			query.append("         , B.MOVE_CODE \n");
	  			query.append("         , B.MOVE_EA \n");
	  			query.append("         , B.MOVE_JOB \n");
	  			query.append("         , B.PAINT_CODE3 \n");
	  			query.append("         , B.PAINT_CODE4 \n");
	  			query.append("         , B.PAINT_CODE5 \n");
	  			query.append("         , B.RAW_LV \n");
	  			query.append("         , B.REMARK \n");
	  			query.append("         , B.STATE_FLAG \n");
	  			query.append("         , B.KEY_NO \n");
	  			query.append("         , B.USER_ID \n");
	  			query.append("         , B.USER_NAME \n");
	  			query.append("         , B.CREATE_DATE  \n");
	  			query.append("         , B.BOM_ITEM_DETAIL \n");
	  			query.append("         , B.UPP_CONFIRM_DATE \n");
	  			query.append("         , B.MOVE_SSC_DATE \n");
	  			query.append("       ) \n");
			} 
			
			//System.out.println(query);
			
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