package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonCRUD;
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;
import java.lang.String;

public class Tbc_VA_ItemAddDao implements Idao{
	
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
        		boolean rtn = itemAddItemCodeGetInsert(rBox);
        		qryExp = "ValidationCheckList";
        		if(!rtn){
        			throw new Exception("ItemCode Get Error");
        		}
        	}else if(qryExp.equals("AddStageSSCInsert")){ //Stage�� ���� ���� 
        		boolean rtn = itemAddCheckStageTempInsert(rBox);
        		qryExp = "ValidationCheckList";
        		if(!rtn){
        			throw new Exception("Temp Insert Error");
        		}
        	}
        	//Item Size
        	ArrayList ar_block = rBox.getArrayList("p_block");
        	rBox.put("p_itemSize", Integer.toString(ar_block.size()) );
    		
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
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
        boolean 			rtn 	= false;
    	boolean 			rtn1 	= false;
    	boolean 			rtn2 	= false;
    	int 				isOk    = 0;
    	int					sCount  = 0;
    	String				query   = "";
    	String 				rtnMsg 	= "";
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
				String p_bom2 = box.getString("p_bom2");
				String p_block = box.getString("p_block");
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
				if(!p_bom2.equals("")){
					p_bom2 = p_bom2.replaceAll("[*]","%");
					query.append("AND AA.BOM2 LIKE '" + p_bom2 + "'");
				}
				
				
				
			} else if(qryExp.equals("AddInputSSCHeadInsert")){
				
				query.append(" INSERT INTO STX_DIS_SSC_HEAD ( \n");
				query.append("             PROJECT_NO \n");
				query.append("           , ITEM_TYPE_CD \n");
				query.append("           , DWG_NO \n");
				query.append("           , MOTHER_CODE \n");
				query.append("           , ITEM_CODE \n");
				query.append("           , SSC_SUB_ID \n");
				query.append("           , CAD_SUB_ID \n");
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
				query.append("           , CREATE_DATE  \n");
				query.append("			 , BOM_ITEM_DETAIL )\n");
				query.append("SELECT TEMP10 AS PROJECT \n");
				query.append("     , ? --ITEM_TYPE_CD \n");
				query.append("     , TEMP11 AS DWGNO \n");
				query.append("     , TEMP16 AS MOTHERCODE \n");
				query.append("     , TEMP17 AS ITEMCODE \n");
				query.append("     , STXDIS.STX_DIS_SSC_SUB_ID_SQ.NEXTVAL \n");
				query.append("     , TEMP37 AS CAD_SUB_ID \n");
				query.append("     , TEMP27 AS REV_NO \n");
				query.append("     , '' AS BOM1 \n");
				query.append("     , '' AS BOM2 \n");
				query.append("     , '' AS BOM3 \n");
				query.append("     , '' AS BOM4 \n");
				query.append("     , '' AS BOM5 \n");
				query.append("     , '' AS BOM6 \n");
				query.append("     , TEMP26 AS BOM7 \n");
				query.append("     , '' AS BOM8 \n");
				query.append("     , '' AS BOM9 \n");
				query.append("     , '' AS BOM10 \n");
				query.append("     , '' AS BOM11 \n");
				query.append("     , '' AS BOM12 \n");
				query.append("     , '' AS BOM13 \n");
				query.append("     , '' AS BOM14 \n");
				query.append("     , '' AS BOM15 \n");
				query.append("     , '' AS SUPPLY_TYPE \n");
//				query.append("           , (SELECT STAC.BLOCK_DIV_CD \n");
//				query.append("                FROM STX_DIS_JOB_CONFIRM      STJC \n");
//				query.append("                    ,STX_DIS_ACTIVITY_CONFIRM STAC \n");
//				query.append("               WHERE (CASE WHEN STJC.JOB_CD2 IS NOT NULL THEN STJC.JOB_CD2 ELSE STJC.JOB_CD1 END)  = (SELECT JOB_CD FROM STX_DIS_PENDING WHERE MOTHER_CODE = TEMP16) \n");
//				query.append("                 AND STAC.ACTIVITY_CD                                                              = STJC.ACTIVITY_CD \n");
//				query.append("              ) AS BLOCK_DIV \n");
				query.append("     , '' AS BLOCK_DIV \n");
				query.append("     , '' -- AS BLOCK_CHG_DATE \n");
				query.append("     , (SELECT JOB_CD FROM STX_DIS_PENDING WHERE MOTHER_CODE = TEMP16) AS JOB \n");
				query.append("     , '' AS JOB_CHG_DATE \n");
				query.append("     , '' AS UPP_CHG_FLAG \n");
				query.append("     , '' AS UPP_CHG_DATE \n");
				query.append("     , ? --DEPT_CODE \n");
				query.append("     , ? --DEPT_NAME \n");
				query.append("     , '' AS DWG_CHECK \n");
				query.append("     , '1' AS BOM_QTY \n");
				query.append("     , '' AS ECO_NO \n");
				query.append("     , TEMP9 AS MASTER_SHIP \n");
				query.append("     , '' AS MOVE_CODE \n");
				query.append("     , '' AS MOVE_EA \n");
				query.append("     , '' AS MOVE_JOB \n");
				query.append("     , '' AS PAINT_CODE3 \n");
				query.append("     , '' AS PAINT_CODE4 \n");
				query.append("     , '' AS PAINT_CODE5 \n");
				query.append("     , '1' AS RAW_LV \n");
				query.append("     , TEMP39 AS REMARK \n");
				query.append("     , 'A' AS STATE_FLAG \n");
				query.append("     , TEMP24 AS KEY_NO \n");
				query.append("     , ? --USER_ID \n");
				query.append("     , ? --USER_NAME \n");
				query.append("     , SYSDATE \n");
				query.append("     , '' AS BOM_ITEM_DETAIL \n");
				query.append("  FROM STX_DIS_TEMP \n");
				query.append(" WHERE USER_ID = ? \n");
				query.append("   AND TEMP32 = ? \n"); //ISRAW 
				
				
			} else if(qryExp.equals("AddInputSSCSUBInsert")){
				
				query.append("INSERT INTO STX_DIS_SSC_SUB (SSC_SUB_ID, ELEMENT_SEQUENCE, ELEMENT_VALUE)   \n");
				query.append("VALUES ( STXDIS.STX_DIS_SSC_SUB_ID_SQ.CURRVAL, ?, ?)                                                           \n");
				
			} else if(qryExp.equals("AddInputDelete")){
				
				ArrayList list = box.getArrayList("p_chkItem");
				query.append("DELETE STX_DIS_SSC_INPUT_HEAD \n");
				query.append("WHERE 1=1");
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
				//*****************Ű ���� �� STR , DWG_NO ���� �޾Ƽ� ����.
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
				//Paging ó��  ���� S
				int p_nowpage = box.getInt("p_nowpage");
				int p_printrow = box.getInt("p_printrow");
				
				int StartNum = (p_nowpage-1) * p_printrow;
				int EndNum = ((p_nowpage-1) * p_printrow) + p_printrow;
				//Paging ó��  ���� E

				
				query.append("SELECT * FROM ( \n");
				query.append("SELECT ROWNUM AS RNUM, XX.* FROM ( \n");
				query.append("SELECT COUNT(*) OVER () AS ROW_CNT, ZZ.* FROM ( \n");
				query.append("SELECT  USER_ID AS USER_ID \n");
				query.append("		, TEMP1  AS SERIESSIZE \n");
				query.append("		, TEMP2  AS ERROR_BLOCK \n");
				query.append("		, TEMP3  AS ERROR_STAGE \n");
				query.append("		, TEMP4  AS ERROR_STR \n");
				query.append("		, TEMP5  AS ERROR_MOTHERCODE \n");
				query.append("		, TEMP6  AS ERROR_ITEMCODE \n");
				query.append("		, TEMP7  AS ERROR_VALVENO \n");
				query.append("		, TEMP8  AS ERROR_SUPPLY \n");
				query.append("		, TEMP9  AS MASTER \n");
				query.append("		, TEMP10 AS PROJECT \n");
				query.append("		, TEMP11 AS DWGNO \n");
				query.append("		, TEMP12 AS BLOCK \n");
				query.append("		, TEMP13 AS STAGE \n");
				query.append("		, TEMP14 AS STR \n");
				query.append("		, TEMP15 AS ITEMGROUP \n");
				query.append("		, TEMP16 AS MOTHERCODE \n");
				query.append("		, TEMP17 AS ITEMCODE \n");
				query.append("		, TEMP18 AS COSTIN \n");
				query.append("		, TEMP19 AS COSTOUT \n");
				query.append("		, TEMP20 AS LNAMEPLATE \n");
				query.append("		, TEMP21 AS TYPE1 \n");
				query.append("		, TEMP22 AS TYPE2 \n");
				query.append("		, TEMP23 AS POSITION \n");
				query.append("		, TEMP24 AS VALVENO \n");
				query.append("		, TEMP25 AS WEIGHT \n");
				query.append("		, TEMP26 AS SUPPLY \n");
				query.append("		, TEMP27 AS REV_NO \n");
				query.append("		, TEMP28 AS ITEM_OLDCODE \n");
				query.append("		, TEMP29 AS KEYIN_ITEM_CODE \n");
				query.append("		, TEMP30 AS SHIPPATTERN \n");
				query.append("		, TEMP31 AS CATALOG \n");
				query.append("		, TEMP32 AS ISRAW \n");
				query.append("		, TEMP37 AS CAD_SUB_ID \n");
				query.append("		, TEMP38 AS ITEM_CREAT_YN \n");
				query.append("		, TEMP39 AS REMARK \n");
				query.append("      , CASE WHEN TEMP2  IS NULL \n");
				query.append("              AND TEMP3  IS NULL \n");
				query.append("              AND TEMP4  IS NULL \n");
				query.append("              AND TEMP5  IS NULL \n");
				query.append("              AND TEMP6  IS NULL \n");
				query.append("              AND TEMP7  IS NULL \n");
				query.append("              AND TEMP8  IS NULL \n");
				query.append("         THEN 'OK' ELSE 'NO' END AS PROCESS \n");
				query.append("  FROM STX_DIS_TEMP \n");
				query.append(" WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append(" ORDER BY PROCESS ASC, TEMP10, TEMP12, TEMP13, TEMP14, TEMP24 \n");
				query.append(") ZZ \n");
				query.append(") XX WHERE ROWNUM <= "+EndNum+" \n");
				query.append(") WHERE RNUM > "+StartNum+" \n");
				query.append(" ORDER BY PROCESS, PROJECT, BLOCK, STAGE, STR, VALVENO \n"); //PROJECT, BLOCK, STAGE, STR, VALVENO 
				
			} else if(qryExp.equals("AddSearchSSCInsert")){			//Search ��� SSC Head Insert
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
			}else if(qryExp.equals("TempRawInsert")){
				query.append("INSERT INTO STX_DIS_RAWLEVEL ( \n");
	        	query.append("       MOTHER_CODE \n");
	        	query.append("     , ITEM_CODE \n");
	        	query.append("     , BOM_QTY \n");
	        	query.append("     , USER_ID \n");
	        	query.append("     , USER_NAME \n");
	        	query.append("     , CREATE_DATE \n");
	        	query.append("     , TYPE \n");
	        	query.append("     , STATE_FLAG \n");
	        	query.append("     , REMARK \n");
	        	query.append("     , BOM7 \n");
	        	query.append("     , COAT_IN \n");
	        	query.append("     , COAT_OUT \n");
	        	query.append("     , LETTER_NAMEPLATE \n");
	        	query.append("     , TYPE1 \n");
	        	query.append("     , TYPE2 \n");
	        	query.append("     , POSITION \n");
	        	query.append(") \n");
	        	query.append("SELECT DISTINCT \n");
	        	query.append("       TEMP16 \n");
	        	query.append("     , TEMP17 \n");
	        	query.append("     , 1 \n");
	        	query.append("     , ? \n");
	        	query.append("     , ? \n");
	        	query.append("     , SYSDATE \n");
	        	query.append("     , 'RAWMTR' \n");
	        	query.append("     , 'A' \n");	        	
	        	query.append("     , TEMP39 \n");
	        	query.append("     , TEMP26 \n");
	        	query.append("     , TEMP18 \n");
	        	query.append("     , TEMP19 \n");
	        	query.append("     , TEMP20 \n");
	        	query.append("     , TEMP21 \n");
	        	query.append("     , TEMP22 \n");
	        	query.append("     , TEMP23 \n");
	        	query.append("  FROM STX_DIS_TEMP \n");
	        	query.append(" WHERE USER_ID = ? \n");
	        	query.append("   AND TEMP32 = ? \n"); //ISRAW 
	        	
			} else if(qryExp.equals("ItemAddBackList")){
				
				query.append("SELECT  DISTINCT \n");
				query.append("		  TEMP9  AS MASTER \n");
				query.append("		, TEMP11 AS DWGNO \n");
				query.append("      , CASE WHEN TEMP40 = 'Y' THEN '' ELSE TEMP12 END AS BLOCK \n");
				query.append("      , CASE WHEN TEMP40 = 'Y' THEN '' ELSE TEMP13 END AS STAGE \n");
				query.append("      , CASE WHEN TEMP40 = 'Y' THEN '' ELSE TEMP14 END AS STR \n");
				query.append("		, TEMP15 AS ITEMGROUP \n");
				query.append("		, TEMP17 AS ITEMCODE \n");
				query.append("		, TEMP18 AS COSTIN \n");
				query.append("		, TEMP19 AS COSTOUT \n");
				query.append("		, TEMP20 AS LNAMEPLATE \n");
				query.append("		, TEMP21 AS TYPE1 \n");
				query.append("		, TEMP22 AS TYPE2 \n");
				query.append("		, TEMP23 AS POSITION \n");
				query.append("		, TEMP24 AS VALVENO \n");
				query.append("		, TEMP25 AS WEIGHT \n");
				query.append("		, TEMP26 AS SUPPLY \n");
				query.append("		, TEMP27 AS REV_NO \n");
				query.append("		, TEMP28 AS ITEM_OLDCODE \n");
				query.append("		, TEMP29 AS KEYIN_ITEM_CODE \n");
				query.append("		, TEMP30 AS SHIPPATTERN \n");
				query.append("		, TEMP31 AS CATALOG \n");
				query.append("		, TEMP32 AS ISRAW \n");
				query.append("		, TEMP37 AS CAD_SUB_ID \n");
				query.append("		, TEMP38 AS ITEM_CREAT_YN \n");
				query.append("		, TEMP39 AS REMARK \n");
				query.append("  FROM STX_DIS_TEMP \n");
				query.append(" WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
			}
				
						
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	
	public String insertSSCHead(RequestBox rBox, Connection conn) throws Exception {
		// TODO Insert SSC Head	
		
		String 				rtn 	= "";
    	
    	int 				isOk    = 0;    	
    	
    	PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt4 	= null;
    	
    	String				query   = "";
    	String				query4   = "";
    	
        try 
        { 
        	
			String p_item_type_cd = rBox.getString("p_item_type_cd");
			String p_userid = rBox.getSession("UserId");
			String p_username = rBox.getSession("UserName");
			String p_deptname = rBox.getSession("DeptName");
			String p_deptcode = rBox.getSession("DeptCode");

			
            //SSC HEAD INSERT
			query  = getQuery("AddInputSSCHeadInsert",rBox);
        	pstmt = conn.prepareStatement(query.toString());
        	
        	int idx = 0;
        	pstmt.setString(++idx, p_item_type_cd); //item_type_cd
        	pstmt.setString(++idx, p_deptcode); //deptCode
        	pstmt.setString(++idx, p_deptname); //deptName
        	pstmt.setString(++idx, p_userid); //Userid
        	pstmt.setString(++idx, p_username); //UserName
        	pstmt.setString(++idx, p_userid); //Userid
        	pstmt.setString(++idx, "N"); //IS_RAW
        	
        	isOk = pstmt.executeUpdate();
        	
        	
        	//SSC RAW MATERIAL
			query4  = getQuery("TempRawInsert",rBox);
        	pstmt4 = conn.prepareStatement(query4.toString());
        	
        	int idx4 = 0;
        	pstmt4.setString(++idx4, p_userid); //Userid
        	pstmt4.setString(++idx4, p_username); //UserName
        	pstmt4.setString(++idx4, p_userid); //Userid
        	pstmt4.setString(++idx4, "Y"); //IS_RAW
        	
        	int isOk2 = pstmt4.executeUpdate();
        	        	
        	if(isOk > 0){
        		rtn = "Success";

        	}else{
        		rtn = "Fail";
        	}
        }
        catch ( Exception ex ) 
        { 
        	rtn = "Fail";
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( pstmt4 != null ) { try { pstmt4.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}
	
	public int getUniqItemCount(Connection conn, String p_item_code) throws Exception {
        
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
    		query.append("SELECT \n");
    		query.append("    NVL(ATTR1, '') AS ATTR1 \n");
    		query.append("  , NVL(ATTR2, '') AS ATTR2 \n");
    		query.append("  , NVL(ATTR3, '') AS ATTR3 \n");
    		query.append("  , NVL(ATTR4, '') AS ATTR4 \n");
    		query.append("  , NVL(ATTR5, '') AS ATTR5 \n");
    		query.append("  , NVL(ATTR6, '') AS ATTR6 \n");
    		query.append("  , NVL(ATTR7, '') AS ATTR7 \n");
    		query.append("  , NVL(ATTR8, '') AS ATTR8 \n");
    		query.append("  , NVL(ATTR9, '') AS ATTR9 \n");
    		query.append("  , NVL(ATTR10, '') AS ATTR10 \n");
    		query.append("  , NVL(ATTR11, '') AS ATTR11 \n");
    		query.append("  , NVL(ATTR12, '') AS ATTR12 \n");
    		query.append("  , NVL(ATTR13, '') AS ATTR13 \n");
    		query.append("  , NVL(ATTR14, '') AS ATTR14 \n");    
    		query.append("  , NVL(ATTR15, '') AS ATTR15 \n");
    		query.append("  , NVL(ITEM_WEIGHT, '') AS ITEM_WEIGHT \n");
    		query.append("  , NVL(ITEM_DESC, '') AS ITEM_DESC \n");
    		query.append("  , NVL(ITEM_OLDCODE, '') AS ITEM_OLDCODE \n");
    		query.append("  , NVL(UOM, '') AS UOM \n");
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
	
	public boolean getIsValveno(String p_project, String p_dwgno, String p_block_no, String p_valveno) throws Exception {
		
		//Tray No�ߺ����� üũ
	
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("DIS");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		query.append("SELECT COUNT(*) CNT \n");
			query.append("  FROM STX_DIS_SSC_HEAD A \n");  
			query.append(" INNER JOIN STX_DIS_PENDING C ON A.MOTHER_CODE = C.MOTHER_CODE \n");
			query.append(" WHERE A.BOM2 = '"+p_valveno+"' \n");
    		query.append("   AND A.PROJECT_NO = '"+p_project+"' \n");
			query.append("   AND C.DWG_NO = '"+p_dwgno+"' \n");
			query.append("   AND C.BLOCK_NO = '"+p_block_no+"' \n");
    		query.append("   AND A.ITEM_TYPE_CD = 'VA' \n");
    			
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
//            	true�� ���
            	if(ls.getInt(1) > 0){
           		 	rtn = false;
                }else{
               	 	rtn = true;
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
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	
	public DataBox getCatalogInfo(String p_catalog_code) throws Exception {
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox 			dbox1 		= null;
        
    	try 
        { 
    		query.append("SELECT SSCE.CATEGORY_CODE1 || '.' || SSCE.CATEGORY_CODE2 || '.' || SSCE.CATEGORY_CODE3 AS CATEGORY_CODE \n");
    		query.append("     , NVL(SSSC.CATALOG_CODE, '')            AS CATALOG_NAME \n");
    		query.append("     , NVL(SSSC.CATALOG_DESC , '')           AS CATALOG_DESC \n");
    		query.append("  FROM STX_STD_SD_CATALOG@"+ERP_DB+"           SSSC \n");
    		query.append("      ,STX_STD_SD_CATEGORY@"+ERP_DB+"          SSCE \n");
    		query.append("WHERE SSSC.CATEGORY_ID  = SSCE.CATEGORY_ID \n");
    		query.append("  AND SSSC.CATALOG_CODE = '"+p_catalog_code+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	dbox1 = ls.getDataBox();
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
        return dbox1;
	}
	/**
	 * Valve No�� �������� üũ
	 * @param p_project
	 * @param p_dwg_no
	 * @param p_item_code
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsUniqValveNo(String p_project, String p_dwg_no, String p_valve_no) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("DIS");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS CNT \n");
    		query.append("  FROM STX_DIS_SSC_HEAD STSH \n");
    		query.append(" INNER JOIN STX_DIS_ITEM STI ON STSH.ITEM_CODE = STI.ITEM_CODE \n");
    		query.append(" WHERE STSH.PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND STSH.DWG_NO = '"+p_dwg_no+"' \n"); 		
    		query.append("   AND KEY_NO = '"+p_valve_no+"' \n");
    		query.append("   AND NOT (STSH.STATE_FLAG = 'D' AND STSH.ECO_NO IS NOT NULL) \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = false;
                }else{
               	 	rtn = true;
                }
            }
            
//            System.out.println("�ߺ� rtn : " + rtn);
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
        return rtn;
	}

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
        	
        	//TEMP DATA ����
			query.append("DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'");
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP ����
			
			String p_master = box.getString("p_master");
			String p_dwgno = box.getString("p_dwgno");
			String p_selrev = box.getString("p_selrev");
			String p_item_type_cd = box.getString("p_item_type_cd");
			
			String v_itemcode = "";
			
			String v_hidState = box.getString("p_hidstate");

			String vItemcode = "";
			String vIsStandard = "";
			String vCatalog = "";
//			String v_hidState = box.getString("p_hidstate");
			
			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_block = box.getArrayList("p_block");
			ArrayList ar_stage = box.getArrayList("p_stage");
			ArrayList ar_str = box.getArrayList("p_str");
			ArrayList ar_itemcode = box.getArrayList("p_itemCode");
			ArrayList ar_valveNo = box.getArrayList("p_valveno");
			ArrayList ar_supply = box.getArrayList("p_supply");
			
			ArrayList ar_costIn = box.getArrayList("p_costIn");
			ArrayList ar_costOut = box.getArrayList("p_costOut");
			ArrayList ar_lNameplate = box.getArrayList("p_lNameplate");
			ArrayList ar_type1 = box.getArrayList("p_type1");
			ArrayList ar_type2 = box.getArrayList("p_type2");
			ArrayList ar_position = box.getArrayList("p_position");
			
			ArrayList ar_cad_sub_id = box.getArrayList("p_cad_sub_id");
			ArrayList ar_remark = box.getArrayList("p_remark");
			
			String projectShipPattern = "";
			
			for(int j=0; j<ar_block.size(); j++){
				vItemcode = ar_itemcode.get(j).toString().trim();

				if(!vItemcode.equals("")){
					if (vItemcode.toString().substring(0, 1).equals("Z")) { //��ǥ��
						vIsStandard = "N";
					} else {
						vIsStandard = "Y";
					}
				}else{
					vIsStandard = "";
				}

				
//				valve No�� �̿���. Mother�� ã�´�. 
				String vMotherCode = "";
				for(int k=0; k<ar_valveNo.size(); k++){
					//Valve No�� ����.
					String itemCode = ar_itemcode.get(k).toString().trim();
					if(ar_valveNo.get(j).toString().trim().equals(ar_valveNo.get(k).toString().trim())){
						if(vIsStandard.equals("Y") && !itemCode.equals(vItemcode)){
							vMotherCode = itemCode;
						}
					}
				}
				
				
				String vFlagRaw = "";


				//Item Code�� �̿��Ͽ� Catalog�� ����.
				if(ar_itemcode.get(j).toString().trim().indexOf("-") != -1){
					vCatalog = ar_itemcode.get(j).toString().trim().substring(0,ar_itemcode.get(j).toString().trim().indexOf("-"));
				}
				
				
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
					query.append("  	      , TEMP25 \n");
					query.append("  	      , TEMP26 \n");
					query.append("  	      , TEMP27 \n");
					query.append("  	      , TEMP28 \n");
					query.append("  	      , TEMP29 \n");
					query.append("  	      , TEMP30 \n");
					query.append("  	      , TEMP31 \n");
					query.append("  	      , TEMP32 \n");
					query.append("  	      , TEMP33 \n");
					query.append("  	      , TEMP37 \n");
					query.append("  	      , TEMP38 \n");
					query.append("  	      , TEMP39 \n");
					query.append("  	      ) \n");
					query.append("SELECT \n");
					query.append("	'"+ssUserid+"' AS USER_ID \n");
					query.append(",	'" + ar_series.size()+ "' AS SERIESSIZE \n");					
		    		query.append(", '' AS error_block \n");
		    		query.append(", '' AS error_stage \n");
		    		query.append(", '' AS error_str \n");
					query.append(",	'' AS error_mothercode \n");
					query.append(",	'' AS error_itemcode \n");					
					query.append(",	'' AS error_valveno \n");
					query.append(",	'' AS error_supply \n");
					query.append(",	'" + p_master.trim() + "' AS MASTER \n");
					query.append(",	'" + ar_series.get(i) + "' AS PROJECT \n");
					query.append(",	'" + p_dwgno.trim() + "' AS DWGNO \n");
					query.append(",	'" + ar_block.get(j).toString().trim() + "' AS BLOCK \n");
					query.append(",	'" + ar_stage.get(j).toString().trim() + "' AS STAGE \n");
					query.append(",	'" + ar_str.get(j).toString().trim() + "' AS STR \n");
					query.append(",	'" + j + "' AS ITEMGROUP \n");
					query.append(",	'" + vMotherCode + "' AS MOTHERCODE \n");
					query.append(",	'" + vItemcode + "' AS ITEMCODE \n");
					query.append(",	'" + ar_costIn.get(j).toString().trim() + "' AS COSTIN \n");
					query.append(",	'" + ar_costOut.get(j).toString().trim() + "' AS COSTOUT \n");
					query.append(",	'" + ar_lNameplate.get(j).toString().trim().replaceAll("'", "''") + "' AS LNAMEPLATE \n");
					query.append(",	'" + ar_type1.get(j).toString().trim() + "' AS TYPE1 \n");
					query.append(",	'" + ar_type2.get(j).toString().trim() + "' AS TYPE2 \n");
					query.append(",	'" + ar_position.get(j).toString().trim().replaceAll("'", "''") + "' AS POSITION \n");
					query.append(",	'" + ar_valveNo.get(j).toString().trim() + "' AS VALVENO \n");
					query.append(",	'' AS WEIGHT \n");
					query.append(",	'" + ar_supply.get(j).toString().trim() + "' AS supply \n");
					query.append(",	'" + p_selrev+"' AS rev_no \n");
					query.append(",	'' AS ITEM_OLDCODE \n");
					query.append(",	'" + ar_itemcode.get(j).toString().trim() + "' AS KEYIN_ITEM_CODE \n");
					query.append(",	'" + projectShipPattern + "' AS SHIPPATTERN  \n");
					query.append(",	'" + vCatalog + "' AS CATALOG  \n");
					query.append(",	'" + vFlagRaw + "' AS ISRAW  \n");
					query.append(",	'" + vIsStandard + "' AS IS_STANDARD  \n");
					query.append(",	'" + ar_cad_sub_id.get(j).toString().trim() + "' AS CAD_SUB_ID \n");
					query.append(",	'' AS ITEM_CREAT_YN \n");
					query.append(",	'" + ar_remark.get(j).toString().trim() + "' AS REMARK \n");					
					query.append("FROM DUAL A \n");
					
					pstmt = conn.prepareStatement(query.toString());
		        	isOk = pstmt.executeUpdate();	
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
			}    
			
			cstmt = conn.prepareCall("{call STX_DIS_SSC_ADD_VALIDATION_VA(?, ?, ?)}");
    		
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
        	rtn = false;
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
        	
        	//TEMP DATA ����
			query.append("DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'");
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP ����
			
			String p_master = box.getString("p_master");
			String p_dwgno = box.getString("p_dwgno");
			String p_selrev = box.getString("p_selrev");

			String vItemcode = "";
			String vIsStandard = "";
			String vCatalog = "";
			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_spBlock = box.getArrayList("p_spBlock");
			ArrayList ar_spStage = box.getArrayList("p_spStage");
			ArrayList ar_spStr = box.getArrayList("p_spStr");
			ArrayList ar_itemcode = box.getArrayList("p_itemCode");
			ArrayList ar_valveNo = box.getArrayList("p_valveno");
			ArrayList ar_supply = box.getArrayList("p_supply");
			
			ArrayList ar_costIn = box.getArrayList("p_costIn");
			ArrayList ar_costOut = box.getArrayList("p_costOut");
			ArrayList ar_lNameplate = box.getArrayList("p_lNameplate");
			ArrayList ar_type1 = box.getArrayList("p_type1");
			ArrayList ar_type2 = box.getArrayList("p_type2");
			ArrayList ar_position = box.getArrayList("p_position");
			
			ArrayList ar_cad_sub_id = box.getArrayList("p_cad_sub_id");
			ArrayList ar_remark = box.getArrayList("p_remark");
			ArrayList ar_stageMotherCode = box.getArrayList("p_stageMotherCode");
			ArrayList ar_stageProjectNo = box.getArrayList("p_stageProjectNo");
			
			String projectShipPattern = "";
			
			for(int i=0; i<ar_stageProjectNo.size(); i++){
				for(int j=0; j<ar_itemcode.size(); j++){
					vItemcode = ar_itemcode.get(j).toString().trim();

					if(!vItemcode.equals("")){
						if (vItemcode.toString().substring(0, 1).equals("Z")) { //��ǥ��
							vIsStandard = "N";
						} else {
							vIsStandard = "Y";
						}
					}else{
						vIsStandard = "";
					}

					String vFlagRaw = "";


					//Item Code�� �̿��Ͽ� Catalog�� ����.
					if(ar_itemcode.get(j).toString().trim().indexOf("-") != -1){
						vCatalog = ar_itemcode.get(j).toString().trim().substring(0,ar_itemcode.get(j).toString().trim().indexOf("-"));
					}
					
//					valve No�� �̿���. Mother�� ã�´�. 
					String vMotherCode = "";
					for(int k=0; k<ar_valveNo.size(); k++){
						//Valve No�� ����.
						String itemCode = ar_itemcode.get(k).toString().trim();
						if(ar_valveNo.get(j).toString().trim().equals(ar_valveNo.get(k).toString().trim())){
							if(vIsStandard.equals("Y") && !itemCode.equals(vItemcode)){
								vMotherCode = itemCode;
							}
						}
					}
					if(vMotherCode.equals("")){
						vMotherCode = ar_stageMotherCode.get(i).toString().trim();
					}
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
					query.append("  	      , TEMP25 \n");
					query.append("  	      , TEMP26 \n");
					query.append("  	      , TEMP27 \n");
					query.append("  	      , TEMP28 \n");
					query.append("  	      , TEMP29 \n");
					query.append("  	      , TEMP30 \n");
					query.append("  	      , TEMP31 \n");
					query.append("  	      , TEMP32 \n");
					query.append("  	      , TEMP33 \n");
					query.append("  	      , TEMP37 \n");
					query.append("  	      , TEMP38 \n");
					query.append("  	      , TEMP39 \n");
					query.append("  	      , TEMP40 \n");
					query.append("  	      ) \n");
					query.append("SELECT \n");
					query.append("	'"+ssUserid+"' AS USER_ID \n");
					query.append(",	'" + ar_stageProjectNo.size()+ "' AS SERIESSIZE \n");					
		    		query.append(", '' AS error_block \n");
		    		query.append(", '' AS error_stage \n");
		    		query.append(", '' AS error_str \n");
					query.append(",	'' AS error_mothercode \n");
					query.append(",	'' AS error_itemcode \n");					
					query.append(",	'' AS error_valveno \n");
					query.append(",	'' AS error_supply \n");
					query.append(",	'" + p_master.trim() + "' AS MASTER \n");
					query.append(",	'" + ar_stageProjectNo.get(i).toString().trim() + "' AS PROJECT \n");
					query.append(",	'" + p_dwgno.trim() + "' AS DWGNO \n");
					query.append(",	'" + ar_spBlock.get(i).toString().trim() + "' AS BLOCK \n");
					query.append(",	'" + ar_spStage.get(i).toString().trim() + "' AS STAGE \n");
					query.append(",	'" + ar_spStr.get(i).toString().trim() + "' AS STR \n");
					query.append(",	'" + j + "' AS ITEMGROUP \n");
					query.append(",	'" + vMotherCode + "' AS MOTHERCODE \n");
					query.append(",	'" + vItemcode + "' AS ITEMCODE \n");
					query.append(",	'" + ar_costIn.get(j).toString().trim() + "' AS COSTIN \n");
					query.append(",	'" + ar_costOut.get(j).toString().trim() + "' AS COSTOUT \n");
					query.append(",	'" + ar_lNameplate.get(j).toString().trim().replaceAll("'", "''") + "' AS LNAMEPLATE \n");
					query.append(",	'" + ar_type1.get(j).toString().trim() + "' AS TYPE1 \n");
					query.append(",	'" + ar_type2.get(j).toString().trim() + "' AS TYPE2 \n");
					query.append(",	'" + ar_position.get(j).toString().trim().replaceAll("'", "''") + "' AS POSITION \n");
					query.append(",	'" + ar_valveNo.get(j).toString().trim() + "' AS VALVENO \n");
					query.append(",	'' AS WEIGHT \n");
					query.append(",	'" + ar_supply.get(j).toString().trim() + "' AS supply \n");
					query.append(",	'" + p_selrev+"' AS rev_no \n");
					query.append(",	'' AS ITEM_OLDCODE \n");
					query.append(",	'" + ar_itemcode.get(j).toString().trim() + "' AS KEYIN_ITEM_CODE \n");
					query.append(",	'" + projectShipPattern + "' AS SHIPPATTERN  \n");
					query.append(",	'" + vCatalog + "' AS CATALOG  \n");
					query.append(",	'" + vFlagRaw + "' AS ISRAW  \n");
					query.append(",	'" + vIsStandard + "' AS IS_STANDARD  \n");
					query.append(",	'" + ar_cad_sub_id.get(j).toString().trim() + "' AS CAD_SUB_ID \n");
					query.append(",	'' AS ITEM_CREAT_YN \n");
					query.append(",	'" + ar_remark.get(j).toString().trim() + "' AS REMARK \n");
					query.append(",	'Y' AS STAGEPROCESS_FLAG \n");
					query.append("FROM DUAL A \n");
					
					pstmt = conn.prepareStatement(query.toString());
		        	isOk = pstmt.executeUpdate();	
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
			}    
			
			cstmt = conn.prepareCall("{call STX_DIS_SSC_ADD_VALIDATION_VA(?, ?, ?)}");
    		
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
        	rtn = false;
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
	
	
//	Item ä�� Temp�� Update�Ѵ�.
	private boolean itemAddItemCodeGetInsert(RequestBox box) throws Exception {
		boolean rtn = false;	
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      = null;
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        PreparedStatement 	pstmt3 	= null;
        CallableStatement  	cstmt	= null;
        
    	int 				isOk    = 0;
    	StringBuffer		query   = new StringBuffer();
    	StringBuffer		query2   = new StringBuffer();
    	StringBuffer		query3   = new StringBuffer();
    	
    	
        try 
        {
        	//ä�� ����� ã��.
            query.append("SELECT DISTINCtbcT TEMP15 \n"); //ITEMGROUP
            query.append("     , TEMP31 \n"); //CATALOG
            query.append("     , TEMP24 \n"); //VALVE_NO
            query.append("     , TEMP33 \n"); //IS_STANDARD
            query.append("     , TEMP17 \n"); //ITEM_CODE
            query.append("     , TEMP32 \n"); //ISRAW
            query.append("     , (SELECT SHIP_TYPE \n");
        	query.append("         FROM STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" A \n");
        	query.append("             ,STX_STD_SD_MODEL@"+ERP_DB+"  B \n");
        	query.append("        WHERE A.MODEL_NO = B.MODEL_NO \n");
        	query.append("          AND A.PROJECT_NO = TEMP9) AS SHIP_TYPE \n"); //MASTER_SHIP
        	query.append("     , (SELECT ITEM_WEIGHT FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1) AS WEIGHT \n");
        	query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('01', TEMP31, TEMP29, TEMP24), (SELECT ATTR1  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR1 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('02', TEMP31, TEMP29, TEMP24), (SELECT ATTR2  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR2 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('03', TEMP31, TEMP29, TEMP24), (SELECT ATTR3  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR3 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('04', TEMP31, TEMP29, TEMP24), (SELECT ATTR4  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR4 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('05', TEMP31, TEMP29, TEMP24), (SELECT ATTR5  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR5 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('06', TEMP31, TEMP29, TEMP24), (SELECT ATTR6  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR6 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('07', TEMP31, TEMP29, TEMP24), (SELECT ATTR7  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR7 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('08', TEMP31, TEMP29, TEMP24), (SELECT ATTR8  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR8 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('09', TEMP31, TEMP29, TEMP24), (SELECT ATTR9  FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR9 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('10', TEMP31, TEMP29, TEMP24), (SELECT ATTR10 FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR10 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('11', TEMP31, TEMP29, TEMP24), (SELECT ATTR11 FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR11 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('12', TEMP31, TEMP29, TEMP24), (SELECT ATTR12 FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR12 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('13', TEMP31, TEMP29, TEMP24), (SELECT ATTR13 FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR13 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('14', TEMP31, TEMP29, TEMP24), (SELECT ATTR14 FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR14 \n");
			query.append("	   , NVL(STX_DIS_GET_VALVE_ATTR_F('15', TEMP31, TEMP29, TEMP24), (SELECT ATTR15 FROM STX_DIS_ITEM WHERE ITEM_CODE LIKE TEMP29||'%' AND ROWNUM = 1)) AS ATTR15 \n");
            query.append("  FROM STX_DIS_TEMP \n");
            query.append(" WHERE USER_ID = ? \n");
            query.append("   AND (TEMP17 IS NULL OR TEMP17 LIKE '%[TEMP]' )\n"); //ITEM_CODE 
            query.append(" ORDER BY TEMP24 \n");
            
            
			pstmt = conn.prepareStatement(query.toString());
			pstmt.setString(1, box.getSession("UserId"));
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
		    query2.append("UPDATE STX_DIS_TEMP \n");
		    query2.append("   SET TEMP17 = ? \n"); //ITEM_CODE
		    query2.append("     , TEMP34 = ? \n"); //CATALOG_DESC
		    query2.append("     , TEMP35 = ? \n"); //CATALOG
		    query2.append("     , TEMP36 = ? \n"); //CATEGORY_CODE
		    query2.append("     , TEMP6 = ? \n"); //ERROR_ITEM_CODE
		    query2.append(" WHERE TEMP15 = ? \n"); //ITEMGROUP
		    query2.append("   AND USER_ID = ? \n");
            
		    
		    query3.append("UPDATE STX_DIS_TEMP \n");
		    query3.append("   SET TEMP16 = ? \n"); //MOTHER_CODE
		    query3.append(" WHERE USER_ID = ? \n"); 
		    query3.append("   AND TEMP16 = ? \n"); //MOTHER_CODE
		    query3.append("   AND TEMP24 = ? \n"); //VALVE_NO
		    
//			Context context = null;
//			context = Framework.getFrameContext(box.getHttpSession());
			
			String p_item_code = "";
			String p_err_cd = "";
			String p_err_msg = "";
			
            while ( ls.next() ){
            	
            	String vCatalog = ls.getString("temp31");
            	String vItemGroup = ls.getString("temp15");
            	String vValveNo = ls.getString("temp24");
            	String isStandard = ls.getString("temp33");
            	String vItemCode = ls.getString("temp17");
            	
            	//ä���� Seat No�� -���ڸ��� catalog, Desc, Category������ 
				DataBox dbox1 = getCatalogInfo(vCatalog.toString());
				
				String v_catalog      	= "";
				String v_catalog_desc 	= "";
				String v_category     	= "";
				
				if(dbox1 != null){
					v_catalog = dbox1.getString("d_catalog_name");
					v_catalog_desc = dbox1.getString("d_catalog_desc");
					v_category = dbox1.getString("d_category_code");
				}else{
					v_catalog = vCatalog.toString();
				}
				
				
//				ä��!!
				if(isStandard.equals("N")){ //��ǥ��ǰ ä�� ����.
					//��ǥ�� : catalog�� �̿��� Item Code ä��
//					plmItemCode = com.stx.pec.part.STXpartUtilRev2.getNextNum(context , v_catalog+"-" , "" , "" , 1);
					//TEMP�� ���ܽ�Ų��.
					//vItemCode = vItemCode.replaceAll("\\[TEMP\\]", "");

					StringBuffer sp_query = new StringBuffer();
	            	
	            	sp_query.append("call stx_dis_item_pkg.stx_dis_main_proc( \n");
	            	sp_query.append("     p_catalog_code => ? \n");
	            	sp_query.append("	, p_ship_type => ? \n");
	            	sp_query.append("	, p_weight => ? \n");
	            	sp_query.append("	, p_loginid => ? \n");
	            	sp_query.append("	, p_attr01_desc => ? \n");
	            	sp_query.append("	, p_attr02_desc => ? \n");
	            	sp_query.append("	, p_attr03_desc => ? \n");
	            	sp_query.append("	, p_attr04_desc => ? \n");
	            	sp_query.append("	, p_attr05_desc => ? \n");
	            	sp_query.append("	, p_attr06_desc => ? \n");
	            	sp_query.append("	, p_attr07_desc => ? \n");
	            	sp_query.append("	, p_attr08_desc => ? \n");
	            	sp_query.append("	, p_attr09_desc => ? \n");
	            	sp_query.append("	, p_attr10_desc => ? \n");
	            	sp_query.append("	, p_attr11_desc => ? \n");
	            	sp_query.append("	, p_attr12_desc => ? \n");
	            	sp_query.append("	, p_attr13_desc => ? \n");
	            	sp_query.append("	, p_attr14_desc => ? \n");
	            	sp_query.append("	, p_attr15_desc => ? \n");
	            	sp_query.append("	, p_err_msg => ? \n");
	            	sp_query.append("	, p_err_code => ? \n");
	            	sp_query.append("	, p_item_code => ? ) \n");
	            	
	            	//GET ITEM CODE
	            	cstmt = conn.prepareCall(sp_query.toString());
	    		
	    		    int idx = 0;
	    			cstmt.setString(++idx, v_catalog);
	            	cstmt.setString(++idx, ls.getString("ship_type"));
	            	cstmt.setString(++idx, ls.getString("weight"));
	            	cstmt.setString(++idx, box.getSession("UserId"));
	            	cstmt.setString(++idx, ls.getString("attr1"));
	            	cstmt.setString(++idx, ls.getString("attr2"));
	            	cstmt.setString(++idx, ls.getString("attr3"));
	            	cstmt.setString(++idx, ls.getString("attr4"));
	            	cstmt.setString(++idx, ls.getString("attr5"));
	            	cstmt.setString(++idx, ls.getString("attr6"));
	            	cstmt.setString(++idx, ls.getString("attr7"));
	            	cstmt.setString(++idx, ls.getString("attr8"));
	            	cstmt.setString(++idx, ls.getString("attr9"));
	            	cstmt.setString(++idx, ls.getString("attr10"));
	            	cstmt.setString(++idx, ls.getString("attr11"));
	            	cstmt.setString(++idx, ls.getString("attr12"));
	            	cstmt.setString(++idx, ls.getString("attr13"));
	            	cstmt.setString(++idx, ls.getString("attr14"));
	            	cstmt.setString(++idx, ls.getString("attr15"));
	            	
	            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
	            	int p_err_msg_idx = idx;
	            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
	            	int p_err_cd_idx = idx;
	            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
	            	int p_item_code_idx = idx;
	            	
	    		    cstmt.execute();
	    		        		    
	    		    p_err_msg = cstmt.getString(p_err_msg_idx);
	    		    p_err_cd = cstmt.getString(p_err_cd_idx);
	    		    p_item_code = cstmt.getString(p_item_code_idx);
	    		    
	            	System.out.println("p_err_msg : " + p_err_msg);
	            	System.out.println("p_err_cd : " + p_err_cd);
	            	System.out.println("p_item_code : " + p_item_code);
	            	
	            	//TEMP�� MOTHER_CODE�� �ٲ��ش�.
					pstmt3 = conn.prepareStatement(query3.toString());
					pstmt3.setString(1, p_item_code);
					pstmt3.setString(2, box.getSession("UserId"));
					pstmt3.setString(3, vItemCode);
					pstmt3.setString(4, vValveNo);
					
					isOk += pstmt3.executeUpdate();
					
				}else{ //ǥ��ǰ ä�� ����.
					//ǥ��ǰ�� Valve NO�� ���Ե� ITEM CODE�� ���� ä��
					p_item_code = vItemCode;
					//�ٸ� �Ӽ����� Valve NO�� �� ITEM CODE���� ����.
					//vItemCode = vItemCode.replaceAll(vValveNo, "");
				}
				
				
				pstmt2 = conn.prepareStatement(query2.toString());
				pstmt2.setString(1, p_item_code);
				pstmt2.setString(2, v_catalog_desc);
				pstmt2.setString(3, v_catalog);
				pstmt2.setString(4, v_category);
				pstmt2.setString(5, (p_err_cd.equals("S"))?"":p_err_msg);
				pstmt2.setString(6, vItemGroup);
				pstmt2.setString(7, box.getSession("UserId"));
				
				isOk += pstmt2.executeUpdate();
				
				if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
				if ( pstmt3 != null ) { try { pstmt3.close(); } catch ( Exception e ) { } }
				if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
            }
    		conn.commit();
    		rtn = true;
        }
        catch ( Exception ex ) 
        { 
        	rtn = false;
        	ex.printStackTrace();
        	box.put("errorMsg", "Fail");
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
            if ( pstmt3 != null ) { try { pstmt3.close(); } catch ( Exception e ) { } }
            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
        }    
		return rtn; 
	}	
}

