package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;

import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;

public class Tbc_GE_ItemAddDao implements Idao{
	
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
        	
        	String p_isPaging = rBox.getString("p_isPaging");
        	
        	if(qryExp.equals("ValidationCheckList") && !p_isPaging.equals("Y")){
        		boolean rtn = itemAddCheckTempInsert(rBox);
        		if(!rtn){
        			throw new Exception("Temp Insert Error");
        		}
        	}else if(qryExp.equals("GetItemCodeList")){        		
        		qryExp = "ValidationCheckList";        		
        	}else if(qryExp.equals("AddStageSSCInsert")){ //Stage별 물량 연계 
        		boolean rtn = itemAddCheckStageTempInsert(rBox);
        		qryExp = "ValidationCheckList";
        		if(!rtn){
        			throw new Exception("Temp Insert Error");
        		}
        	}
        	
        	rBox.put("p_itemSize", Integer.toString(rBox.getArrayList("p_block").size()));
			
        	
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
//		 TODO Auto-generated method stub		
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
        		rBox.put("successMsg", "Data Delete Success!!");
        		rtn = true;
        	}else{
        		conn.rollback();
        		rBox.put("errorMsg", "Data Delete Fail!!");
        		rtn = false;
        	}
        	
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Data Delete Fail!!");
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
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
        boolean 			rtn 	= false;
    	String 				rtnMsg 	= "";
    	boolean 			rtn2 	= false;
    	int 				isOk    = 0;
    	int					sCount  = 0;
    	String				query   = "";
    	
        try 
        { 
        	if(qryExp.equals("AddInputSSCInsert")){
        		//SSC Head Insert
        		rtnMsg = insertSSCHead(rBox, conn);
        		//SSC Sub Insert
        		rtn2 = true;
        		
        	}else if(qryExp.equals("AddSearchSSCInsert")){
        		//SSC Head Insert - SearchMode 
        		//rtn1 = insertSSCHead_SearchMode("AddSearchSSCInsert", rBox, conn);
        		//SSC Sub Insert - SearchMode 
        		rtn2 = true;
        	}
        	
        	
        	if(rtnMsg.equals("Success") && rtn2){
        		conn.commit();
        		rBox.put("successMsg", rtnMsg);
        		rtn = true;
        	}else{
        		conn.rollback();
        		rBox.put("errorMsg", rtnMsg);
        		rtn = false;
        	}
        	
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Data Delete Fail!!");
        }
        finally 
        { 
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
			if(qryExp.equals("ManagerInputList")){
				String p_project = box.getString("p_project");
				String p_dwgno = box.getString("p_dwgno");
				String p_block = box.getString("p_block");
				String p_stage = box.getString("p_stage");
				String p_str = box.getString("p_str");
				String p_item_type_cd = box.getString("p_item_type_cd");
				
				query.append("SELECT  \n");
				query.append("   AA.PROJECT_NO    \n");
				query.append(" , AA.ITEM_TYPE_CD  \n");
				query.append(" , AA.CAD_SUB_ID  \n");
				query.append(" , AA.ITEM_OLDCODE  \n");
				query.append(" , AA.ITEM_CODE  \n");
				query.append(" , AA.REV_NO        \n");
				query.append(" , AA.KEY_NO        \n");
				query.append(" , AA.DWG_NO        \n");
				query.append(" , AA.BLOCK_NO      \n");
				query.append(" , AA.STAGE_NO      \n");
				query.append(" , AA.STR_FLAG      \n");
				query.append(" , AA.ATTR1         \n");
				query.append(" , AA.ATTR2         \n");
				query.append(" , AA.ATTR4         \n");
				query.append(" , AA.ATTR5         \n");
				query.append(" , AA.PROJECT_NO || '-' || AA.BLOCK_NO || '-' || AA.STAGE_NO || '-' || AA.ATTR5 AS STRUCTURE_NAME         \n");
				query.append(" , AA.BOM_QTY       \n");
				query.append(" , AA.ITEM_DESC     \n");
				query.append(" , AA.ITEM_WEIGHT   \n");
				query.append(" , AA.USER_ID       \n");
				query.append(" , AA.PAINT_CODE1   \n");
				query.append(" , AA.PAINT_CODE2   \n");
				query.append(" , TO_CHAR(AA.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE     \n");
				query.append(" , (SELECT USER_NAME FROM STX_COM_INSA_USER@"+ERP_DB+" WHERE AA.USER_ID = EMP_NO) AS USER_NAME \n");
				query.append(" , AA.USER_ID \n");
				query.append("FROM STX_DIS_SSC_INPUT_HEAD AA                                                           \n");
				query.append("WHERE 1=1								                                                   \n");
				query.append("AND AA.ITEM_TYPE_CD = '"+p_item_type_cd+"'                                               \n");
				query.append("AND (SELECT MAX(BB.REV_NO) \n");
				query.append("           FROM STX_DIS_SSC_INPUT_HEAD BB \n");
				query.append("           WHERE AA.PROJECT_NO = BB.PROJECT_NO \n");
				query.append("             AND AA.ITEM_TYPE_CD = BB.ITEM_TYPE_CD \n");
				query.append("             AND AA.ITEM_CODE = BB.ITEM_CODE \n");
				query.append("             AND AA.BLOCK_NO || AA.STAGE_NO = BB.BLOCK_NO || BB.STAGE_NO \n");
				query.append("             AND AA.KEY_NO = BB.KEY_NO \n");
				query.append("         ) = REV_NO \n");
				query.append("AND INTERFACE_FLAG = 'N' \n");
				
				if(!p_project.equals("")){
					query.append("AND PROJECT_NO = '" + p_project + "'");
				}
				if(!p_block.equals("")){
					p_block = p_block.replaceAll("[*]","%");
					query.append("AND BLOCK_NO LIKE '" + p_block + "'");
				}
				if(!p_str.equals("")){
					p_str = p_str.replaceAll("[*]","%");
					query.append("AND STR_FLAG LIKE '" + p_str + "'");
				}
				if(!p_stage.equals("")){
					p_stage = p_stage.replaceAll("[*]","%");
					query.append("AND STAGE_NO LIKE '" + p_stage + "'");
				}
				
			} else if(qryExp.equals("AddInputSSCHeadInsert")){
				
				query.append(" INSERT INTO STX_DIS_SSC_HEAD ( ");
				query.append("   PROJECT_NO ");
				query.append(" , ITEM_TYPE_CD ");
				query.append(" , DWG_NO ");
				query.append(" , MOTHER_CODE ");
				query.append(" , ITEM_CODE ");
				query.append(" , SSC_SUB_ID ");
//				query.append(" , BLOCK_NO ");
//				query.append(" , STAGE_NO ");
//				query.append(" , STR_FLAG ");
				query.append(" , REV_NO ");
				query.append(" , BOM1 ");
				query.append(" , BOM2 ");
				query.append(" , BOM3 ");
				query.append(" , BOM4 ");
				query.append(" , BOM5 ");
				query.append(" , BOM6 ");
				query.append(" , BOM7 ");
				query.append(" , BOM8 ");
				query.append(" , BOM9 ");
				query.append(" , BOM10 ");
				query.append(" , BOM11 ");
				query.append(" , BOM12 ");
				query.append(" , BOM13 ");
				query.append(" , BOM14 ");
				query.append(" , BOM15 ");
				query.append(" , SUPPLY_TYPE ");
				query.append(" , BLOCK_DIV ");
				query.append(" , BLOCK_CHG_DATE ");
				query.append(" , JOB ");
				query.append(" , JOB_CHG_DATE ");
				query.append(" , UPP_CHG_FLAG ");
				query.append(" , UPP_CHG_DATE ");
				query.append(" , DEPT_CODE ");
				query.append(" , DEPT_NAME ");
				query.append(" , DWG_CHECK ");
				query.append(" , BOM_QTY ");
				query.append(" , ECO_NO ");
				query.append(" , MASTER_SHIP ");
				query.append(" , MOVE_CODE ");
				query.append(" , MOVE_EA ");
				query.append(" , MOVE_JOB ");
				query.append(" , PAINT_CODE3 ");
				query.append(" , PAINT_CODE4 ");
				query.append(" , PAINT_CODE5 ");
				query.append(" , RAW_LV ");
				query.append(" , REMARK ");				
				query.append(" , STATE_FLAG ");
				query.append(" , KEY_NO ");
				query.append(" , USER_ID ");
				query.append(" , USER_NAME ");
				query.append(" , CREATE_DATE ");
				query.append(" ) VALUES ( ");
				query.append("   ?, ?, ?, ?, ?, STXDIS.STX_DIS_SSC_SUB_ID_SQ.NEXTVAL, ? "); //, ?, ?, ? 
				query.append(" , ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ");
				query.append(" , ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ");
				query.append(" , ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ");
				query.append(" , ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ");
				query.append(" , sysdate ");
				query.append(" ) ");	
				
			} else if(qryExp.equals("AddInputSSCItemInsert")){
				
				query.append("INSERT INTO STX_DIS_ITEM (        ");
				query.append("  ITEM_CODE                       ");
				query.append(", ITEM_CATALOG                    ");
				query.append(", ITEM_CATEGORY                   ");
				query.append(", ITEM_DESC                       ");
				query.append(", ITEM_WEIGHT                     ");
				query.append(", ATTR1                           ");
				query.append(", ATTR2                           ");
				query.append(", ATTR3                           ");
				query.append(", ATTR4                           ");
				query.append(", ATTR5                           ");
				query.append(", ATTR6                           ");
				query.append(", ATTR7                           ");
				query.append(", ATTR8                           ");
				query.append(", ATTR9                           ");
				query.append(", ATTR10                          ");
				query.append(", ATTR11                          ");
				query.append(", ATTR12                          ");
				query.append(", ATTR13                          ");
				query.append(", ATTR14                          ");
				query.append(", ATTR15                          ");
				query.append(", ITEM_MATERIAL1                  ");
				query.append(", ITEM_MATERIAL2                  ");
				query.append(", ITEM_MATERIAL3                  ");
				query.append(", ITEM_MATERIAL4                  ");
				query.append(", ITEM_MATERIAL5                  ");
				query.append(", PAINT_CODE1                     ");
				query.append(", PAINT_CODE2                     ");
				query.append(", CODE_TYPE                       ");
				query.append(", UOM                             ");
				query.append(", SHIP_PATTERN                    ");
				query.append(", ITEM_OLDCODE                    ");
				query.append(", CABLE_LENGTH                    ");
				query.append(", CABLE_TYPE                      ");
				query.append(", CABLE_OUTDIA                    ");
				query.append(", USER_ID                         ");
				query.append(", USER_NAME                       ");
				query.append(", CREATE_DATE                     ");
				query.append(") VALUES (                        ");
				query.append("  ? ,? ,? ,? ,? ,?, ? ,? ,? ,?    ");
				query.append(", ? ,? ,? ,? ,? ,?, ? ,? ,? ,?    ");
				query.append(", ? ,? ,? ,? ,? ,?, ? ,? ,? ,?    ");
				query.append(", ? ,? ,? ,? ,? ,?, sysdate       ");
				query.append(" )                                ");
				
			} else if(qryExp.equals("AddInputDelete")){
				
				ArrayList list = box.getArrayList("p_chkItem");
				query.append("DELETE STX_DIS_SSC_INPUT_HEAD WHERE 1=1\n");
				query.append("AND ( \n");
				for(int i = 0; i < list.size(); i++){
					if(i != 0) query.append(" OR ");
					query.append("CAD_SUB_ID = '"+list.get(i)+"' \n");
	  		    }
				query.append(") \n");
				
			} else if(qryExp.equals("TransferItemList")){

				String p_master = box.getString("p_master");
				String p_item_type_cd = box.getString("p_item_type_cd");
				String p_dwgno = box.getString("p_dwgno");
				String p_str = box.getString("p_str");
				
				ArrayList list = box.getArrayList("p_chkItem");
				//*****************키 수정 및 STR , DWG_NO 정보 받아서 넣음.
				query.append("SELECT \n");
				query.append("  AA.PROJECT_NO \n");
				query.append(", AA.ITEM_TYPE_CD \n");
				query.append(", AA.ATTR1 \n");
				query.append(", AA.ATTR2 \n");
				query.append(", AA.ATTR3 \n");
				query.append(", AA.ATTR4 \n");
				query.append(", AA.ATTR5 \n");
				query.append(", AA.ATTR6 \n");
				query.append(", AA.ATTR7 \n");
				query.append(", AA.ATTR8 \n");
				query.append(", AA.ATTR9 \n");
				query.append(", AA.ATTR10 \n");
				query.append(", AA.ATTR11 \n");
				query.append(", AA.ATTR12 \n");
				query.append(", AA.ATTR13 \n");
				query.append(", AA.ATTR14 \n");
				query.append(", AA.ATTR15 \n");
				query.append(", '"+p_str+"' AS STR_FLAG \n");
				query.append(", AA.STAGE_NO \n");
				query.append(", AA.BLOCK_NO \n");
				query.append(", '"+p_dwgno+"' AS DWG_NO \n");
				query.append(", AA.ITEM_CODE \n");
				query.append(", AA.ITEM_OLDCODE \n");
				query.append(", AA.BOM_QTY \n");
				query.append(", AA.MOTHER_CODE \n");
				query.append(", AA.ITEM_WEIGHT \n");
				query.append(", AA.PAINT_CODE3 \n");
				query.append(", AA.PAINT_CODE4 \n");
				query.append(", AA.PAINT_CODE5 \n");
				query.append(", AA.ITEM_WEIGHT \n");
				query.append(", AA.CAD_SUB_ID \n");
				query.append(", AA.ITEM_DESC \n");
				query.append(", '"+p_master+"' AS MASTER \n");
				query.append("FROM STX_DIS_SSC_INPUT_HEAD AA \n");
				query.append("WHERE 1=1");
				query.append("AND ( \n");
				for(int i = 0; i < list.size(); i++){
					if(i != 0) query.append(" OR ");
					query.append("CAD_SUB_ID = '"+list.get(i)+"' \n");
	  		    }
				query.append(") \n");
				
				
			} else if(qryExp.equals("ValidationCheckList")){
				
				//Paging 처리  변수 S
				int p_nowpage = box.getInt("p_nowpage");
				int p_printrow = box.getInt("p_printrow");
				
				int StartNum = (p_nowpage-1) * p_printrow;
				int EndNum = ((p_nowpage-1) * p_printrow) + p_printrow;
				//Paging 처리  변수 E
				

				
				query.append("SELECT * FROM ( \n");
				query.append("SELECT ROWNUM AS RNUM, XX.* FROM ( \n");
				query.append("SELECT COUNT(*) OVER () AS ROW_CNT, ZZ.* FROM ( \n");
				query.append("SELECT USER_ID \n");
				query.append("     , TEMP1  AS SERIESSIZE \n");
				query.append("     , TEMP2  AS ERROR_EA \n");
				query.append("     , TEMP3  AS ERROR_BLOCK \n");
				query.append("     , TEMP4  AS ERROR_STR \n");
				query.append("     , TEMP5  AS ERROR_MOTHER_CODE \n");
				query.append("     , TEMP6  AS MASTER \n");
				query.append("     , TEMP7  AS PROJECT \n");
				query.append("     , TEMP8  AS DWGNO \n");
				query.append("     , TEMP9  AS BLOCK \n");
				query.append("     , TEMP10 AS STAGE_NO \n");
				query.append("     , TEMP11 AS STR \n");
				query.append("     , TEMP12 AS ITEMGROUP \n");
				query.append("     , TEMP13 AS EA \n");
				query.append("     , TEMP14 AS ERROR_ITEM_CODE \n");
				query.append("     , TEMP15 AS ITEMCODE \n");
				query.append("     , TEMP16 AS MOTHERCODE \n");
				query.append("     , TEMP17 AS ITEM_DESC \n");
				query.append("     , TEMP18 AS WEIGHT \n");
				query.append("     , TEMP19 AS REV_NO \n");
				query.append("     , TEMP20 AS ITEM_OLDCODE \n");
				query.append("     , TEMP21 AS SHIPPATTERN \n");
				query.append("     , TEMP22 AS ISRAW \n");
				query.append("     , CASE WHEN TEMP2 IS NULL AND TEMP3 IS NULL AND TEMP4 IS NULL AND TEMP5 IS NULL AND TEMP14 IS NULL THEN 'OK' ELSE 'NO' END AS PROCESS \n");
				query.append("  FROM STX_DIS_TEMP \n");
				query.append(" WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append(" ORDER BY PROCESS ASC \n");
				query.append(") ZZ \n");
				query.append(") XX WHERE ROWNUM <= "+EndNum+" \n");
				query.append(") WHERE RNUM > "+StartNum+" \n");
				query.append(" ORDER BY PROJECT, BLOCK, STAGE_NO, STR \n");
				
			}else if(qryExp.equals("AddSearchSSCInsert")){			//Search 모드 SSC Head Insert, 현재 사용안함
				ArrayList list = box.getArrayList("p_chkItem");
				
				query.append("INSERT INTO STX_DIS_SSC_HEAD( \n");
				query.append("  PROJECT_NO \n");
				query.append(", ITEM_TYPE_CD \n");
				query.append(", DWG_NO \n");
				query.append(", MOTHER_CODE \n");
				query.append(", ITEM_CODE \n");
				query.append(", CAD_SUB_ID \n");
				query.append(") \n");
				query.append("SELECT \n");
				query.append("  PROJECT_NO \n");
				query.append(", ITEM_TYPE_CD \n");
				query.append(", DWG_NO \n");
				query.append(", NVL(MOTHER_CODE, '2') \n");
				query.append(", NVL(ITEM_CODE, '2') \n");
				query.append(", NVL(CAD_SUB_ID, '2') \n");
				query.append("FROM STX_DIS_SSC_INPUT_HEAD \n");
				query.append("WHERE PROJECT_NO || ITEM_TYPE_CD || DWG_NO || ITEM_OLDCODE IN ( ");
				for(int i = 0; i < list.size(); i++){
					if(i != 0) query.append(",");
					query.append("'"+list.get(i)+"'");
	  		    }
				query.append(" ) ");
			}else if(qryExp.equals("AddTempSSCInsert")){
				query.append(" INSERT INTO STX_DIS_SSC_HEAD ( \n");
				query.append("             PROJECT_NO \n");
				query.append("           , ITEM_TYPE_CD \n");
				query.append("           , DWG_NO \n");
				query.append("           , MOTHER_CODE \n");
				query.append("           , ITEM_CODE \n");
				query.append("           , SSC_SUB_ID \n");
				query.append("           , REV_NO \n");
				query.append("           , BOM1 \n");
				query.append("           , BOM2 \n");
				query.append("           , BOM3 \n");
				query.append("           , BOM4 \n");
				query.append("           , BOM5 \n");
				query.append("           , BOM6 \n");
				query.append("           , BOM7 \n");
				query.append("           , BOM8 \n");
				query.append("           , BOM9 \n");
				query.append("           , BOM10 \n");
				query.append("           , BOM11 \n");
				query.append("           , BOM12 \n");
				query.append("           , BOM13 \n");
				query.append("           , BOM14 \n");
				query.append("           , BOM15 \n");
				query.append("           , SUPPLY_TYPE \n");
				query.append("           , BLOCK_DIV \n");
				query.append("           , BLOCK_CHG_DATE \n");
				query.append("           , JOB \n");
				query.append("           , JOB_CHG_DATE \n");
				query.append("           , UPP_CHG_FLAG \n");
				query.append("           , UPP_CHG_DATE \n");
				query.append("           , DEPT_CODE \n");
				query.append("           , DEPT_NAME \n");
				query.append("           , DWG_CHECK \n");
				query.append("           , BOM_QTY \n");
				query.append("           , ECO_NO \n");
				query.append("           , MASTER_SHIP \n");
				query.append("           , MOVE_CODE \n");
				query.append("           , MOVE_EA \n");
				query.append("           , MOVE_JOB \n");
				query.append("           , PAINT_CODE3 \n");
				query.append("           , PAINT_CODE4 \n");
				query.append("           , PAINT_CODE5 \n");
				query.append("           , RAW_LV \n");
				query.append("           , REMARK \n");
				query.append("           , STATE_FLAG \n");
				query.append("           , KEY_NO \n");
				query.append("           , USER_ID \n");
				query.append("           , USER_NAME \n");
				query.append("           , CREATE_DATE ) \n");
				query.append("      SELECT TEMP7 AS PROJECT \n");
				query.append("           , ? --ITEM_TYPE_CD \n");
				query.append("           , TEMP8  AS DWGNO \n");
				query.append("           , TEMP16 AS MOTHERCODE \n");
				query.append("           , TEMP15 AS ITEMCODE \n");
				query.append("           , STXDIS.STX_DIS_SSC_SUB_ID_SQ.NEXTVAL \n");
				query.append("           , TEMP19 AS REV_NO --REV_NO \n");
				query.append("           , '' -- BOM1 \n");
				query.append("           , '' -- BOM2 \n");
				query.append("           , '' -- BOM3 \n");
				query.append("           , '' -- BOM4 \n");
				query.append("           , '' -- BOM5 \n");
				query.append("           , '' -- BOM6 \n");
				query.append("           , '' -- BOM7 \n");
				query.append("           , '' -- BOM8 \n");
				query.append("           , '' -- BOM9 \n");
				query.append("           , '' -- BOM10 \n");
				query.append("           , '' -- BOM11 \n");
				query.append("           , '' -- BOM12 \n");
				query.append("           , '' -- BOM13 \n");
				query.append("           , '' -- BOM14 \n");
				query.append("           , '' -- BOM15 \n");
				query.append("           , '' --SUPPLY_TYPE \n");
//				query.append("           , (SELECT STAC.BLOCK_DIV_CD \n");
//				query.append("                FROM STX_DIS_JOB_CONFIRM      STJC \n");
//				query.append("                    ,STX_DIS_ACTIVITY_CONFIRM STAC \n");
//				query.append("               WHERE (CASE WHEN STJC.JOB_CD2 IS NOT NULL THEN STJC.JOB_CD2 ELSE STJC.JOB_CD1 END)  = (SELECT JOB_CD FROM STX_DIS_PENDING WHERE MOTHER_CODE = TEMP16) \n");
//				query.append("                 AND STAC.ACTIVITY_CD                                                              = STJC.ACTIVITY_CD \n");
//				query.append("              ) AS BLOCK_DIV \n");
				query.append("           , '' AS BLOCK_DIV \n");
				query.append("           , '' -- AS BLOCK_CHG_DATE \n");
				query.append("           , (SELECT JOB_CD FROM STX_DIS_PENDING WHERE MOTHER_CODE = TEMP16) AS JOB \n");
				query.append("           , '' --JOB_CHG_DATE \n");
				query.append("           , '' --UPP_CHG_FLAG \n");
				query.append("           , '' --UPP_CHG_DATE \n");
				query.append("           , ? --DEPT_CODE \n");
				query.append("           , ? --DEPT_NAME \n");
				query.append("           , '' --DWG_CHECK \n");
				query.append("           , TEMP13 AS BOM_QTY \n");
				query.append("           , '' -- ECO_NO \n");
				query.append("           , TEMP6 AS MASTER_SHIP \n");
				query.append("           , '' --MOVE_CODE \n");
				query.append("           , '' --MOVE_EA \n");
				query.append("           , '' --MOVE_JOB \n");
				query.append("           , '' --PAINT_CODE3 \n");
				query.append("           , '' --PAINT_CODE4 \n");
				query.append("           , '' --PAINT_CODE5 \n");
				query.append("           , '1' --RAW_LV \n");
				query.append("           , '' --REMARK \n");
				query.append("           , 'A' --STATE_FLAG \n");
				query.append("           , ''--KEY_NO \n");
				query.append("           , ? --USER_ID \n");
				query.append("           , ? --USER_NAME \n");
				query.append("           , SYSDATE \n");
				query.append("        FROM STX_DIS_TEMP \n");
				query.append("       WHERE USER_ID = ? \n");
			}else if(qryExp.equals("ItemAddBackList")){
				
				query.append("SELECT DISTINCT \n");
				query.append("       TEMP6  AS MASTER \n");
				query.append("     , TEMP8  AS DWGNO \n");
				query.append("     , TEMP24  AS JOB_CD \n");
				query.append("     , CASE WHEN TEMP23 = 'Y' THEN '' ELSE TEMP9 END AS BLOCK \n");
				query.append("     , CASE WHEN TEMP23 = 'Y' THEN '' ELSE TEMP10 END AS STAGE \n");
				query.append("     , CASE WHEN TEMP23 = 'Y' THEN '' ELSE TEMP11 END AS STR \n");
//				query.append("     , TEMP9  AS BLOCK \n");
//				query.append("     , TEMP10 AS STAGE_NO \n");
//				query.append("     , TEMP11 AS STR \n");
				query.append("     , TEMP12 AS ITEMGROUP \n");
				query.append("     , TEMP13 AS EA \n");				
				query.append("     , TEMP15 AS ITEMCODE \n");
				query.append("     , TEMP19 AS REV_NO \n");
				query.append("     , TEMP20 AS ITEM_OLDCODE \n");				
				query.append("     , TEMP22 AS ISRAW \n");
				query.append("  FROM STX_DIS_TEMP \n");
				query.append(" WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
			}
//			System.out.println(query);
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	
	public String insertSSCHead(RequestBox rBox, Connection conn) throws Exception {
		// TODO Auto-generated method stub		
		
    	String 				rtn 	= "";    	
    	String				query   = "";
    	int 				isOk    = 0;
    	PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        PreparedStatement 	pstmt3 	= null;

        try 
        { 
        	
			String p_item_type_cd = rBox.getString("p_item_type_cd");
			String p_selrev = rBox.getString("p_selrev");
			String p_userid = rBox.getSession("UserId");
			String p_username = rBox.getSession("UserName");
			String p_deptname = rBox.getSession("DeptName");
			String p_deptcode = rBox.getSession("DeptCode");
			
	    	//SSC TEMP INSERT
	    	query  = getQuery("AddTempSSCInsert",rBox);
        	pstmt = conn.prepareStatement(query.toString());
        	int idx = 0;
        	
        	pstmt.setString(++idx, p_item_type_cd); //item_type_cd
        	pstmt.setString(++idx, p_deptcode); //deptCode
        	pstmt.setString(++idx, p_deptname); //deptName
        	pstmt.setString(++idx, p_userid); //Userid
        	pstmt.setString(++idx, p_username); //UserName
        	pstmt.setString(++idx, p_userid); //Userid
        	
        	isOk = pstmt.executeUpdate();
        	
        	if(isOk > 0){
        		rtn = "Success";
        	}else{
        		rtn = "Fail";
        	}
        	
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        	rtn = "Fail";
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
        	if ( pstmt3 != null ) { try { pstmt3.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}
	
	
	public int getUniqItemCount(Connection conn, String p_item_code) throws Exception { //tbc_item에 item 존재유무
        
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int v_sub_ssc_id = 0;
        
    	try 
        { 
        	query.append("SELECT COUNT(*) AS ITEMCNT FROM STX_DIS_ITEM  \n");
        	query.append("WHERE ITEM_CODE = '"+p_item_code+"' \n");
        	
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	v_sub_ssc_id = ls.getInt(1);
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
        return v_sub_ssc_id;
	}
	
	public DataBox getItemInfo(String p_item_code) throws Exception {
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox 			dbox 		= null;
        
    	try 
        { 
    		query.append("SELECT   \n");
    		query.append("    NVL(ITEM_OLDCODE, '') AS ITEM_OLDCODE \n");
    		query.append("  , NVL(ITEM_DESC, '') AS ITEM_DESC \n");
    		query.append("  , NVL(ITEM_WEIGHT, 0) AS WEIGHT \n");
    		
    		query.append("FROM STX_DIS_ITEM \n");
    		query.append("WHERE ITEM_CODE = '"+p_item_code+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	dbox = ls.getDataBox();
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
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return dbox;
	}
	

	/* Item Check 시 Temp에 넣고 조회 
	 * 
	 */
	private boolean itemAddCheckTempInsert(RequestBox box) throws Exception {
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
			
        PreparedStatement 	pstmt 	= null;
        CallableStatement   cstmt   = null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	StringBuffer		query   = new StringBuffer();
        try 
        {         	
        	String ssUserid = box.getSession("UserId");
        	
        	//TEMP DATA 삭제
			query.append("DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'");
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP 삭제
			
			
			String p_master = box.getString("p_master");
			String p_dwgno = box.getString("p_dwgno");
			String p_selrev = box.getString("p_selrev");		
			
			String v_itemcode = "";
			String v_hidState = box.getString("p_hidstate");
			
			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_block = box.getArrayList("p_block");
			ArrayList ar_stage = box.getArrayList("p_stage");
			ArrayList ar_str = box.getArrayList("p_str");
			ArrayList ar_itemcode = box.getArrayList("p_itemCode");
			ArrayList ar_ea = box.getArrayList("p_ea");
			ArrayList ar_isRaw = box.getArrayList("p_isRaw");
			ArrayList ar_job_cd = box.getArrayList("p_job_cd");
			
			String projectShipPattern = "";
			
//			query.append("WITH CHK_TABLE AS (\n");
			for(int j=0; j<ar_block.size(); j++){
				v_itemcode = ar_itemcode.get(j).toString().trim();
				
				for(int i=0; i<ar_series.size(); i++){		
					
					query.delete(0, query.length());
					query.append("  INSERT INTO STX_DIS_TEMP( \n");
					query.append("  	        USER_ID \n");
					query.append("  	      , TEMP1 \n");
					query.append("  	      , TEMP2 \n");
					query.append("  	      , TEMP3 \n");
					query.append("  	      , TEMP4 \n");
					query.append("  	      , TEMP5 \n");
					query.append("  	      , TEMP6 \n");
					query.append("  	      , TEMP7 \n");
					query.append("  	      , TEMP8 \n");
					query.append("  	      , TEMP9 \n");
					query.append("  	      , TEMP10 \n");
					query.append("  	      , TEMP11 \n");
					query.append("  	      , TEMP12 \n");
					query.append("  	      , TEMP13 \n");
					query.append("  	      , TEMP14 \n");
					query.append("  	      , TEMP15 \n");
					query.append("  	      , TEMP16 \n");
					query.append("  	      , TEMP17 \n");
					query.append("  	      , TEMP18 \n");
					query.append("  	      , TEMP19 \n");
					query.append("  	      , TEMP20 \n");
					query.append("  	      , TEMP21 \n");
					query.append("  	      , TEMP22 \n");
					query.append("  	      , TEMP23 \n");
					query.append("  	      , TEMP24 \n");
					query.append("  	      ) \n");
					query.append("SELECT \n");
					query.append("	'"+ssUserid+"' AS USER_ID \n");
					query.append(",	'"+ar_series.size()+"' AS seriessize \n");
					query.append(",	'' AS ERROR_EA \n");					
					query.append(",	'' AS ERROR_BLOCK \n");
					query.append(",	'' AS ERROR_STR \n");
			    	query.append(",	'' AS ERROR_MOTHER_CODE \n");
					query.append(",	'" + p_master.trim() + "' AS MASTER \n");
					query.append(",	'" + ar_series.get(i) + "' AS PROJECT \n");
					query.append(",	'" + p_dwgno.trim() + "' AS DWGNO \n");
					query.append(",	'" + ar_block.get(j).toString().trim() + "' AS BLOCK \n");
					query.append(",	'" + ar_stage.get(j).toString().trim() + "' AS STAGE_NO \n");
					query.append(",	'" + ar_str.get(j).toString().trim() + "' AS STR \n");
					query.append(",	'" + j + "' AS ITEMGROUP \n");
					query.append(",	'" + ar_ea.get(j).toString().trim() + "' AS EA \n");
					query.append(",	'' AS ERROR_ITEM_CODE \n");
					query.append(",	'" + v_itemcode + "' AS ITEMCODE \n");
					query.append(", '' AS MOTHER_CODE \n");
					query.append(",	'' ITEM_DESC \n");
					query.append(",	'' WEIGHT \n");
					query.append(",	'"+p_selrev+"' rev_no \n");
					query.append(",	'' ITEM_OLDCODE \n");
					query.append(",	'"+projectShipPattern+"' SHIPPATTERN  \n");
					query.append(",	'"+ar_isRaw.get(j).toString().trim()+"' ISRAW \n");
					query.append(",	'N' AS STAGEPROCESS_FLAG \n");
					query.append(",	'"+ar_job_cd.get(j).toString().trim()+"' JOB_CD \n");
					
					query.append("FROM DUAL A \n");
					
					pstmt = conn.prepareStatement(query.toString());
		        	isOk = pstmt.executeUpdate();
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
			}
			
			
			cstmt = conn.prepareCall("{call STX_DIS_SSC_ADD_VALIDATION_GE(?, ?, ?)}");
    		
    		cstmt.setString(1, box.getSession("UserId"));
    		cstmt.registerOutParameter(2, Types.NUMERIC);
    		cstmt.registerOutParameter(3, Types.VARCHAR);
    		
    		cstmt.executeQuery();
    		isOk = cstmt.getInt(2);
    		String msg = cstmt.getString(3);
			
        	        	
        	if(isOk > 0){
        		conn.commit();        		
        		rtn = true;
        	}else{
        		conn.rollback();
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
            
        }        
		
		return rtn;
	}
	

	private boolean itemAddCheckStageTempInsert(RequestBox box) throws Exception {
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
			
        PreparedStatement 	pstmt 	= null;
        CallableStatement   cstmt   = null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	StringBuffer		query   = new StringBuffer();
        try 
        {         	
        	String ssUserid = box.getSession("UserId");
        	
        	//TEMP DATA 삭제
			query.append("DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'");
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP 삭제
			
			String p_master = box.getString("p_master");
			String p_dwgno = box.getString("p_dwgno");
			String p_selrev = box.getString("p_selrev");	
			
			String v_itemcode = "";
			
			
			ArrayList ar_series = box.getArrayList("p_series");
			
			ArrayList ar_spBlock = box.getArrayList("p_spBlock");
			ArrayList ar_spStage = box.getArrayList("p_spStage");
			ArrayList ar_spStr = box.getArrayList("p_spStr");
			ArrayList ar_stageMotherCode = box.getArrayList("p_stageMotherCode");
			ArrayList ar_stageProjectNo = box.getArrayList("p_stageProjectNo");
			ArrayList ar_itemcode = box.getArrayList("p_itemCode");
			ArrayList ar_ea = box.getArrayList("p_ea");
			ArrayList ar_isRaw = box.getArrayList("p_isRaw");
			
			String projectShipPattern = "";
			
//			query.append("WITH CHK_TABLE AS (\n");
			for(int i=0; i<ar_stageProjectNo.size(); i++){
				for(int j=0; j<ar_itemcode.size(); j++){		
					v_itemcode = ar_itemcode.get(j).toString().trim();
					query.delete(0, query.length());
					query.append("  INSERT INTO STX_DIS_TEMP( \n");
					query.append("  	        USER_ID \n");
					query.append("  	      , TEMP1 \n");
					query.append("  	      , TEMP2 \n");
					query.append("  	      , TEMP3 \n");
					query.append("  	      , TEMP4 \n");
					query.append("  	      , TEMP5 \n");
					query.append("  	      , TEMP6 \n");
					query.append("  	      , TEMP7 \n");
					query.append("  	      , TEMP8 \n");
					query.append("  	      , TEMP9 \n");
					query.append("  	      , TEMP10 \n");
					query.append("  	      , TEMP11 \n");
					query.append("  	      , TEMP12 \n");
					query.append("  	      , TEMP13 \n");
					query.append("  	      , TEMP14 \n");
					query.append("  	      , TEMP15 \n");
					query.append("  	      , TEMP16 \n");
					query.append("  	      , TEMP17 \n");
					query.append("  	      , TEMP18 \n");
					query.append("  	      , TEMP19 \n");
					query.append("  	      , TEMP20 \n");
					query.append("  	      , TEMP21 \n");
					query.append("  	      , TEMP22 \n");
					query.append("  	      , TEMP23 \n");
					query.append("  	      ) \n");
					query.append("SELECT \n");
					query.append("	'"+ssUserid+"' AS USER_ID \n");
					query.append(",	'"+ar_stageProjectNo.size()+"' AS seriessize \n");
					query.append(",	'' AS ERROR_EA \n");					
					query.append(",	'' AS ERROR_BLOCK \n");
					query.append(",	'' AS ERROR_STR \n");
			    	query.append(",	'' AS ERROR_MOTHER_CODE \n");
					query.append(",	'" + p_master.trim() + "' AS MASTER \n");
					query.append(",	'" + ar_stageProjectNo.get(i).toString().trim() + "' AS PROJECT \n");
					query.append(",	'" + p_dwgno.trim() + "' AS DWGNO \n");
					query.append(",	'" + ar_spBlock.get(i).toString().trim() + "' AS BLOCK \n");
					query.append(",	'" + ar_spStage.get(i).toString().trim() + "' AS STAGE \n");
					query.append(",	'" + ar_spStr.get(i).toString().trim() + "' AS STR \n");
					query.append(",	'" + j + "' AS ITEMGROUP \n");
					query.append(",	'" + ar_ea.get(j).toString().trim() + "' AS EA \n");
					query.append(",	'' AS ERROR_ITEM_CODE \n");
					query.append(",	'" + v_itemcode + "' AS ITEMCODE \n");
					query.append(", '" + ar_stageMotherCode.get(i).toString().trim() + "' AS MOTHER_CODE \n");
					query.append(",	'' ITEM_DESC \n");
					query.append(",	'' WEIGHT \n");
					query.append(",	'"+p_selrev+"' rev_no \n");
					query.append(",	'' ITEM_OLDCODE \n");
					query.append(",	'"+projectShipPattern+"' SHIPPATTERN  \n");
					query.append(",	'"+ar_isRaw.get(j).toString().trim()+"' ISRAW \n");
					query.append(",	'Y' AS STAGEPROCESS_FLAG \n");
					query.append("FROM DUAL A \n");
					
					pstmt = conn.prepareStatement(query.toString());
		        	isOk = pstmt.executeUpdate();
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
			}
			
			
			cstmt = conn.prepareCall("{call STX_DIS_SSC_ADD_VALIDATION_GE(?, ?, ?)}");
    		
    		cstmt.setString(1, box.getSession("UserId"));
    		cstmt.registerOutParameter(2, Types.NUMERIC);
    		cstmt.registerOutParameter(3, Types.VARCHAR);
    		
    		cstmt.executeQuery();
    		isOk = cstmt.getInt(2);
    		String msg = cstmt.getString(3);
			
        	        	
        	if(isOk > 0){
        		conn.commit();        		
        		rtn = true;
        	}else{
        		conn.rollback();
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
            
        }        
		
		return rtn;
	}
}