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
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;
import java.lang.String;

public class Tbc_OU_ItemAddDao implements Idao{
	
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
				String p_block = box.getString("p_block");
				String p_attr1 = box.getString("p_attr1");
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
				
				if(!p_attr1.equals("")){
					p_attr1 = p_attr1.replaceAll("[*]","%");
					query.append("AND AA.ATTR1 LIKE '" + p_attr1 + "'");
				}
				
				
//				System.out.println(query);
				
				
				
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
				query.append("      SELECT TEMP12 AS PROJECT \n");
				query.append("           , ? --ITEM_TYPE_CD \n");
				query.append("           , TEMP13  AS DWGNO \n");
				query.append("           , TEMP17 AS MOTHERCODE \n");
				query.append("           , TEMP19 AS ITEMCODE \n");
				query.append("           , STXDIS.STX_DIS_SSC_SUB_ID_SQ.NEXTVAL \n");
				query.append("     	  	 , TEMP32 AS CAD_SUB_ID \n");
				query.append("           , TEMP24 AS REV_NO --REV_NO \n");
				query.append("           , '' AS BOM1 \n");
				query.append("           , CASE WHEN TEMP31 = 'Y' THEN TEMP20 ELSE '' END AS BOM2 \n");
				query.append("           , '' AS BOM3 \n");
				query.append("           , '' AS BOM4 \n");
				query.append("           , '' AS BOM5 \n");
				query.append("           , '' AS BOM6 \n");
				query.append("           , '' AS BOM7 \n");
				query.append("           , '' AS BOM8 \n");
				query.append("           , '' AS BOM9 \n");
				query.append("           , '' AS BOM10 \n");
				query.append("           , '' AS BOM11 \n");
				query.append("           , '' AS BOM12 \n");
				query.append("           , '' AS BOM13 \n");
				query.append("           , '' AS BOM14 \n");
				query.append("           , '' AS BOM15 \n");
				query.append("           , '' AS SUPPLY_TYPE \n");
//				query.append("           , (SELECT STAC.BLOCK_DIV_CD \n");
//				query.append("                FROM STX_DIS_JOB_CONFIRM      STJC \n");
//				query.append("                    ,STX_DIS_ACTIVITY_CONFIRM STAC \n");
//				query.append("               WHERE (CASE WHEN STJC.JOB_CD2 IS NOT NULL THEN STJC.JOB_CD2 ELSE STJC.JOB_CD1 END)  = (SELECT JOB_CD FROM STX_DIS_PENDING WHERE MOTHER_CODE = TEMP16) \n");
//				query.append("                 AND STAC.ACTIVITY_CD                                                              = STJC.ACTIVITY_CD \n");
//				query.append("              ) AS BLOCK_DIV \n");
				query.append("           , '' AS BLOCK_DIV \n");
				query.append("           , '' -- AS BLOCK_CHG_DATE \n");
				query.append("           , (SELECT JOB_CD FROM STX_DIS_PENDING WHERE MOTHER_CODE = TEMP17) AS JOB \n");
				query.append("           , '' AS JOB_CHG_DATE \n");
				query.append("           , '' AS UPP_CHG_FLAG \n");
				query.append("           , '' AS UPP_CHG_DATE \n");
				query.append("           , ? --DEPT_CODE \n");
				query.append("           , ? --DEPT_NAME \n");
				query.append("           , '' AS DWG_CHECK \n");
				query.append("           , TEMP18 AS BOM_QTY \n");
				query.append("           , '' AS ECO_NO \n");
				query.append("           , TEMP11 AS MASTER_SHIP \n");
				query.append("           , '' AS MOVE_CODE \n");
				query.append("           , '' AS MOVE_EA \n");
				query.append("           , '' AS MOVE_JOB \n");
				query.append("           , '' AS PAINT_CODE3 \n");
				query.append("           , '' AS PAINT_CODE4 \n");
				query.append("           , '' AS PAINT_CODE5 \n");
				query.append("           , '1' AS RAW_LV \n");
				query.append("           , '' AS REMARK \n");
				query.append("           , 'A' AS STATE_FLAG \n");
				query.append("           , TEMP20 AS KEY_NO \n");
				query.append("           , ? --USER_ID \n");
				query.append("           , ? --USER_NAME \n");
				query.append("           , SYSDATE \n");
				query.append("           , TEMP23 AS BOM_ITEM_DETAIL \n");
				query.append("        FROM STX_DIS_TEMP \n");
				query.append("       WHERE USER_ID = ? \n");
				
				
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
				String p_keyin_paint_code = box.getString("p_keyin_paint_code");
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
				query.append(", '"+p_keyin_paint_code+"' AS KEYIN_PAINT_CODE \n");
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
//				Paging ó��  ���� S
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
				query.append("		, TEMP2  AS ERROR_EA \n");
				query.append("		, TEMP3  AS ERROR_BLOCK \n");
				query.append("		, TEMP4  AS ERROR_STR \n");
				query.append("		, TEMP5  AS ERROR_MOTHER_CODE \n");
				query.append("		, TEMP6  AS ERROR_ITEM_CODE \n");
				query.append("		, TEMP7  AS ERROR_MARK_NO \n");
				query.append("		, TEMP8  AS ERROR_MARK_NO_V \n");
				query.append("		, TEMP9  AS ERROR_WEIGHT \n");
				query.append("		, TEMP10 AS ERROR_DETAIL \n");
				query.append("		, TEMP11 AS MASTER \n");
				query.append("		, TEMP12 AS PROJECT \n");
				query.append("		, TEMP13 AS DWGNO \n");
				query.append("		, TEMP14 AS BLOCK \n");
				query.append("		, TEMP15 AS STR \n");
				query.append("		, TEMP16 AS ITEMGROUP \n");
				query.append("		, TEMP17 AS MOTHERCODE \n");
				query.append("		, TEMP18 AS EA \n");
				query.append("		, TEMP19 AS ITEMCODE \n");
				query.append("		, TEMP20 AS ATTR1 \n");
				query.append("		, TEMP21 AS WEIGHT \n");
				query.append("		, TEMP22 AS PAINT \n");
				query.append("		, TEMP23 AS ITEM_DESC_DETAIL \n");
				query.append("		, TEMP24 AS REV_NO \n");
				query.append("		, TEMP25 AS ITEM_OLDCODE \n");
				query.append("		, TEMP26 AS SHIPPATTERN \n");
				query.append("		, TEMP30 AS PAINT2 \n");
				query.append("    	, TEMP32 AS CAD_SUB_ID \n");
				query.append("		, TEMP33 AS ERROR_PAINT1 \n");
				query.append("  	, TEMP35 AS STAGE \n");
				query.append("  	, TEMP37 AS ERROR_PAINT2 \n");
				query.append("      , CASE WHEN TEMP2  IS NULL \n");
				query.append("              AND TEMP3  IS NULL \n");
				query.append("              AND TEMP4  IS NULL \n");
				query.append("              AND TEMP5  IS NULL \n");
				query.append("              AND TEMP6  IS NULL \n");
				query.append("              AND TEMP7  IS NULL \n");
				query.append("              AND TEMP8  IS NULL \n");
				query.append("              AND TEMP9  IS NULL \n");
				query.append("              AND TEMP10 IS NULL \n");
				query.append("              AND TEMP33 IS NULL \n");
				query.append("              AND TEMP37 IS NULL \n");
				query.append("         THEN 'OK' ELSE 'NO' END AS PROCESS \n");
				query.append("  FROM STX_DIS_TEMP \n");
				query.append(" WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append(" ORDER BY PROCESS ASC, TEMP12, TEMP14, TEMP15, TEMP20 \n");
				query.append(") ZZ \n");
				query.append(") XX WHERE ROWNUM <= "+EndNum+" \n");
				query.append(") WHERE RNUM > "+StartNum+" \n");
				query.append(" ORDER BY PROJECT, BLOCK, STR, ATTR1 \n");
				
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
			} else if(qryExp.equals("ItemAddBackList")){
				
				query.append("SELECT  DISTINCT \n");
				query.append("		  TEMP11 AS MASTER \n");
				query.append("		, TEMP13 AS DWGNO \n");
				query.append("      , CASE WHEN TEMP36 = 'Y' THEN '' ELSE TEMP14 END AS BLOCK \n");
				query.append("      , CASE WHEN TEMP36 = 'Y' THEN '' ELSE TEMP35 END AS STAGE \n");
				query.append("      , CASE WHEN TEMP36 = 'Y' THEN '' ELSE TEMP15 END AS STR \n");
//				query.append("		, TEMP14 AS BLOCK \n");
//				query.append("		, TEMP15 AS STR \n");
				query.append("		, TEMP16 AS ITEMGROUP \n");
				query.append("		, TEMP18 AS EA \n");
				query.append("		, TEMP19 AS ITEMCODE \n");
				query.append("		, TEMP20 AS ATTR1 \n");
				query.append("		, TEMP21 AS WEIGHT \n");
				query.append("		, TEMP22 AS PAINT \n");
				query.append("		, TEMP23 AS ITEM_DESC_DETAIL \n");
				query.append("		, TEMP24 AS REV_NO \n");
				query.append("		, TEMP25 AS ITEM_OLDCODE \n");				
				query.append("		, TEMP30 AS PAINT2 \n");
				query.append("    	, TEMP32 AS CAD_SUB_ID \n");
//				query.append("  	, TEMP35 AS STAGE \n");
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
		// TODO Auto-generated method stub		
		
		String 				rtn 	= "";
		String				query   = "";
    	int 				isOk    = 0;
    	
    	PreparedStatement 	pstmt 	= null;
        
        try 
        { 
        	
			String p_item_type_cd = rBox.getString("p_item_type_cd");
			String p_selrev = rBox.getString("p_selrev");
			String p_userid = rBox.getSession("UserId");
			String p_username = rBox.getSession("UserName");
			String p_deptname = rBox.getSession("DeptName");
			String p_deptcode = rBox.getSession("DeptCode");
			
			
			//SSC HEAD INSERT-----------------------------------
			query  = getQuery("AddInputSSCHeadInsert",rBox);
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
        	rtn = "Fail";
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
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
	
	public DataBox getOutfittingInfo(String p_item_code) throws Exception {
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
    		query.append("  , NVL(ITEM_DESC_DETAIL, '') AS ITEM_DESC_DETAIL \n");
    		query.append("  , NVL(PAINT_CODE1, '') AS PAINT_CODE1 \n");
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
	
	//ȣ��, DWGNO, BLOCK �� ���� MARK NO �� �ִ��� �Ǵ�.
	public boolean getIsMarkno(String p_project, String p_dwgno, String p_markno, String p_item_code) throws Exception {
		
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
			query.append(" INNER JOIN STX_DIS_ITEM B ON A.ITEM_CODE = B.ITEM_CODE \n");
			query.append(" INNER JOIN STX_DIS_PENDING C ON A.MOTHER_CODE = C.MOTHER_CODE \n");
			query.append(" WHERE A.PROJECT_NO = '"+p_project+"' \n");
			query.append("   AND A.DWG_NO = '"+p_dwgno+"' \n");
			//query.append("   AND C.BLOCK_NO = '"+p_block_no+"' \n");
			query.append("   AND B.ATTR1 = '"+p_markno+"' \n");
			query.append("   AND NOT (A.STATE_FLAG = 'D' AND A.ECO_NO IS NOT NULL) \n");
			if(!p_item_code.equals("")){
				query.append("   AND A.ITEM_CODE = '"+p_item_code+"' \n");	
			}
			//query.append("   AND A.MOTHER_CODE = '"+p_mother_code+"' \n");
			
    		System.out.println(query);
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
	
	
	public DataBox getCatalogInfo(String p_structure) throws Exception {
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox 			dbox1 		= null;
        
    	try 
        { 
    		query.append("SELECT \n");
    		query.append("    NVL(SSSC.CATALOG_CODE, '')            AS CATALOG_NAME \n");
    		query.append("  , NVL(SSSC.CATALOG_DESC , '')           AS CATALOG_DESC \n");
    		query.append("  , SSCE.CATEGORY_CODE1 ||'.' || SSCE.CATEGORY_CODE2 ||'.' || SSCE.CATEGORY_CODE3 AS CATEGORY_CODE \n");
    		query.append(" FROM STX_STD_EQUIP_OUTFIT_STRUCTURE@"+ERP_DB+" SSEOS \n");
    		query.append(" ,MTL_ITEM_CATALOG_GROUPS@"+ERP_DB+"      MICG  \n");
    		query.append(" ,STX_STD_EQUIP_OUTFIT_GROUP@"+ERP_DB+"   SSEOG \n");
    		query.append(" ,STX_STD_SD_CATALOG@"+ERP_DB+"           SSSC  \n");
    		query.append(" ,STX_STD_SD_CATEGORY@"+ERP_DB+"          SSCE  \n");
    		query.append(" WHERE SSEOS.ITEM_CATALOG_GROUP_ID = MICG.ITEM_CATALOG_GROUP_ID \n");
    		query.append(" AND SSEOS.STRUCTURE_NAME = '"+p_structure+"' \n");
    		query.append(" AND SSEOS.GROUP_ID       = SSEOG.GROUP_ID \n");
    		query.append(" AND MICG.SEGMENT1        = SSSC.CATALOG_CODE \n");
    		query.append(" AND SSSC.CATEGORY_ID     = SSCE.CATEGORY_ID \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
//			System.out.println(query);
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

			String v_isStandard = "";
			
			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_block = box.getArrayList("p_block");
			ArrayList ar_stage = box.getArrayList("p_stage");
			ArrayList ar_str = box.getArrayList("p_str");
			ArrayList ar_itemcode = box.getArrayList("p_itemCode");
			ArrayList ar_attr1 = box.getArrayList("p_attr1");
			ArrayList ar_ea = box.getArrayList("p_ea");
			ArrayList ar_weight = box.getArrayList("p_weight");
			ArrayList ar_item_desc_detail = box.getArrayList("p_item_desc_detail");
			ArrayList ar_paint = box.getArrayList("p_paint");
			ArrayList ar_paint2 = box.getArrayList("p_paint2");
			ArrayList ar_cad_sub_id = box.getArrayList("p_cad_sub_id");
			
			String projectShipPattern = "";
			
			for(int j=0; j<ar_block.size(); j++){
				
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
					query.append("  	      , TEMP30 \n");
					query.append("  	      , TEMP31 \n");
					query.append("  	      , TEMP32 \n");
					query.append("  	      , TEMP33 \n");
					query.append("  	      , TEMP34 \n");
					query.append("  	      , TEMP35 \n");
					query.append("  	      , TEMP37 \n");
					query.append("  	      ) \n");
					query.append("SELECT \n");
					query.append("	'"+ssUserid+"' AS USER_ID \n");
					query.append(",	'"+ar_series.size()+"' AS SERIESSIZE \n");
					query.append(",	'' AS ERROR_EA \n");
					query.append(",	'' AS ERROR_BLOCK \n");
		    		query.append(",	'' AS ERROR_STR \n");
					query.append(",	'' AS ERROR_MOTHER_CODE \n");
					query.append(",	'' AS ERROR_ITEM_CODE \n");
					query.append(",	'' AS ERROR_MARK_NO \n");
					query.append(",	'' AS ERROR_MARK_NO_V \n");
					query.append(",	'' AS ERROR_WEIGHT \n");
					query.append(",	'' AS ERROR_DETAIL \n");
					query.append(",	'" + p_master.trim() + "' AS MASTER \n");
					query.append(",	'" + ar_series.get(i) + "' AS PROJECT \n");
					query.append(",	'" + p_dwgno.trim() + "' AS DWGNO \n");
					query.append(",	'" + ar_block.get(j).toString().trim() + "' AS BLOCK \n");
					query.append(",	'" + ar_str.get(j).toString().trim() + "' AS STR \n");
					query.append(",	'" + j + "' AS ITEMGROUP \n");
					query.append(",	'' AS MOTHERCODE \n");
					query.append(",	'" + ar_ea.get(j).toString().trim() + "' AS EA \n");
					query.append(",	'" + ar_itemcode.get(j).toString().trim() + "' AS ITEMCODE \n");
					query.append(",	'" + ar_attr1.get(j).toString().trim() + "' AS ATTR1 \n");
					query.append(",	'" + ar_weight.get(j).toString().trim() + "' AS WEIGHT \n");
					query.append(",	'" + ar_paint.get(j).toString().trim() + "' AS PAINT \n");
					query.append(",	'" + ar_item_desc_detail.get(j).toString().trim().replaceAll("[']", "''") + "' AS ITEM_DESC_DETAIL \n");
					query.append(",	'" + p_selrev + "' AS rev_no \n");
					query.append(",	'" + ar_itemcode.get(j).toString().trim() + "' AS ITEM_OLDCODE \n");
					query.append(",	'" + projectShipPattern + "' AS SHIPPATTERN  \n");
					query.append(",	'" + ar_paint2.get(j).toString().trim() + "' AS PAINT2 \n");
					query.append(",	'" + v_isStandard + "' AS ISSTANDARD \n");
					query.append(",	'" + ar_cad_sub_id.get(j).toString().trim() + "' AS CAD_SUB_ID \n");
					query.append(",	'' AS ERROR_PAINT1 \n");
					query.append(", '' AS ERROR_STAGE \n");
		    		query.append(",	'" + ar_stage.get(j).toString().trim() + "' AS STAGE \n");
		    		query.append(",	'' AS ERROR_PAINT2 \n");
					query.append("FROM DUAL A \n");
					pstmt = conn.prepareStatement(query.toString());
		        	isOk = pstmt.executeUpdate();
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
			}
			
        	cstmt = conn.prepareCall("{call STX_DIS_SSC_ADD_VALIDATION_OU(?, ?, ?)}");
    		
    		cstmt.setString(1, box.getSession("UserId"));
    		cstmt.registerOutParameter(2, Types.NUMERIC);
    		cstmt.registerOutParameter(3, Types.VARCHAR);
    		
    		cstmt.executeQuery();
    		isOk = cstmt.getInt(2);
    		String msg = cstmt.getString(3);
    		System.out.println(isOk);
    		System.out.println(msg);
						
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
        	
        	//TEMP DATA ����
			query.append("DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'");
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP ����
			
			
			String p_master = box.getString("p_master");
			String p_dwgno = box.getString("p_dwgno");
			String p_selrev = box.getString("p_selrev");		

			String v_isStandard = "";
			
			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_spBlock = box.getArrayList("p_spBlock");
			ArrayList ar_spStage = box.getArrayList("p_spStage");
			ArrayList ar_spStr = box.getArrayList("p_spStr");
			ArrayList ar_stageMotherCode = box.getArrayList("p_stageMotherCode");
			ArrayList ar_stageProjectNo = box.getArrayList("p_stageProjectNo");
			
			ArrayList ar_itemcode = box.getArrayList("p_itemCode");
			ArrayList ar_attr1 = box.getArrayList("p_attr1");
			ArrayList ar_ea = box.getArrayList("p_ea");
			ArrayList ar_weight = box.getArrayList("p_weight");
			ArrayList ar_item_desc_detail = box.getArrayList("p_item_desc_detail");
			ArrayList ar_paint = box.getArrayList("p_paint");
			ArrayList ar_paint2 = box.getArrayList("p_paint2");
			ArrayList ar_cad_sub_id = box.getArrayList("p_cad_sub_id");
			
			String projectShipPattern = "";
			
			for(int i=0; i<ar_stageProjectNo.size(); i++){
				
				for(int j=0; j<ar_itemcode.size(); j++){
					
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
					query.append("  	      , TEMP30 \n");
					query.append("  	      , TEMP31 \n");
					query.append("  	      , TEMP32 \n");
					query.append("  	      , TEMP33 \n");
					query.append("  	      , TEMP34 \n");
					query.append("  	      , TEMP35 \n");
					query.append("  	      , TEMP36 \n");
					query.append("  	      , TEMP37 \n");
					query.append("  	      ) \n");
					query.append("SELECT \n");
					query.append("	'"+ssUserid+"' AS USER_ID \n");
					query.append(",	'"+ar_stageProjectNo.size()+"' AS SERIESSIZE \n");
					query.append(",	'' AS ERROR_EA \n");
					query.append(",	'' AS ERROR_BLOCK \n");
		    		query.append(",	'' AS ERROR_STR \n");
					query.append(",	'' AS ERROR_MOTHER_CODE \n");
					query.append(",	'' AS ERROR_ITEM_CODE \n");
					query.append(",	'' AS ERROR_MARK_NO \n");
					query.append(",	'' AS ERROR_MARK_NO_V \n");
					query.append(",	'' AS ERROR_WEIGHT \n");
					query.append(",	'' AS ERROR_DETAIL \n");
					query.append(",	'" + p_master.trim() + "' AS MASTER \n");
					query.append(",	'" + ar_stageProjectNo.get(i).toString().trim() + "' AS PROJECT \n");
					query.append(",	'" + p_dwgno.trim() + "' AS DWGNO \n");
					query.append(",	'" + ar_spBlock.get(i).toString().trim() + "' AS BLOCK \n");
					query.append(",	'" + ar_spStr.get(i).toString().trim() + "' AS STR \n");
					query.append(",	'" + j + "' AS ITEMGROUP \n");
					query.append(",	'" + ar_stageMotherCode.get(i).toString().trim() + "' AS MOTHERCODE \n");
					query.append(",	'" + ar_ea.get(j).toString().trim() + "' AS EA \n");
					query.append(",	'" + ar_itemcode.get(j).toString().trim() + "' AS ITEMCODE \n");
					query.append(",	'" + ar_attr1.get(j).toString().trim() + "' AS ATTR1 \n");
					query.append(",	'" + ar_weight.get(j).toString().trim() + "' AS WEIGHT \n");
					query.append(",	'" + ar_paint.get(j).toString().trim() + "' AS PAINT \n");
					query.append(",	'" + ar_item_desc_detail.get(j).toString().trim().replaceAll("[']", "''") + "' AS ITEM_DESC_DETAIL \n");
					query.append(",	'" + p_selrev + "' AS rev_no \n");
					query.append(",	'" + ar_itemcode.get(j).toString().trim() + "' AS ITEM_OLDCODE \n");
					query.append(",	'" + projectShipPattern + "' AS SHIPPATTERN  \n");
					query.append(",	'" + ar_paint2.get(j).toString().trim() + "' AS PAINT2 \n");
					query.append(",	'" + v_isStandard + "' AS ISSTANDARD \n");
					query.append(",	'" + ar_cad_sub_id.get(j).toString().trim() + "' AS CAD_SUB_ID \n");
					query.append(",	'' AS ERROR_PAINT1 \n");
					query.append(", '' AS ERROR_STAGE \n");
					query.append(",	'" + ar_spStage.get(i).toString().trim() + "' AS STAGE \n");
					query.append(",	'Y' AS STAGEPROCESS_FLAG \n");
					query.append(",	'' AS ERROR_PAINT2 \n");
					query.append("FROM DUAL A \n");
					
					pstmt = conn.prepareStatement(query.toString());
		        	isOk = pstmt.executeUpdate();
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
			}
			
        	cstmt = conn.prepareCall("{call STX_DIS_SSC_ADD_VALIDATION_OU(?, ?, ?)}");
    		
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
	
	//Item ä�� Temp�� Update�Ѵ�.
	private boolean itemAddItemCodeGetInsert(RequestBox box) throws Exception {
		boolean rtn = false;	
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      = null;
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        CallableStatement  	cstmt	= null;
        
    	int 				isOk    = 0;
    	StringBuffer		query   = new StringBuffer();
    	StringBuffer		query2   = new StringBuffer();
    	
    	String p_master = box.getString("p_master");
    	
        try 
        {
        	//ä�� ����� ã��.
//            query.append("SELECT DISTINCT TEMP16 AS ITEMGROUP \n"); //ITEMGROUP
        	query.append("SELECT DISTINCT TEMP13 AS DWG_NO \n"); //DWG_NO
            query.append("     , TEMP20 AS MARK_NO \n"); //MARK_NO
            query.append("     , (SELECT SHIP_TYPE \n");
        	query.append("         FROM STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" A \n");
        	query.append("             ,STX_STD_SD_MODEL@"+ERP_DB+"  B \n");
        	query.append("        WHERE A.MODEL_NO = B.MODEL_NO \n");
        	query.append("          AND A.PROJECT_NO = TEMP6) AS SHIP_TYPE \n"); //MASTER_SHIP
        	query.append("     , TEMP21 AS WEIGHT \n");
        	query.append("     , TEMP20 AS ATTR1 \n");
        	query.append("     , TEMP22 AS PAINT_CODE1 \n");
        	query.append("     , TEMP30 AS PAINT_CODE2 \n");
            query.append("  FROM STX_DIS_TEMP \n");
            query.append(" WHERE USER_ID = ? \n");
            query.append("   AND TEMP19 IS NULL \n");  //ITEM CODE
            query.append(" ORDER BY TEMP20 \n");
            
            
			pstmt = conn.prepareStatement(query.toString());
			pstmt.setString(1, box.getSession("UserId"));
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
		    query2.append("UPDATE STX_DIS_TEMP \n");
		    query2.append("   SET TEMP19 = ? \n"); //ITEM_CODE
		    query2.append("     , TEMP27 = ? \n"); //Catalog
		    query2.append("     , TEMP28 = ? \n"); //CatalogDesc
		    query2.append("     , TEMP29 = ? \n"); //Category
		    query2.append("     , TEMP6 = ? \n"); //Error_Item_Code
//		    query2.append(" WHERE TEMP16 = ? \n"); //ITEMGROUP
		    query2.append(" WHERE TEMP13 = ? \n"); //DWG_NO
		    query2.append("   AND TEMP20 = ? \n"); //MARK_NO
		    query2.append("   AND USER_ID = ? \n");
//			Context context = null;
//			context = Framework.getFrameContext(box.getHttpSession());
			
//			String projectShipPattern = "";
//			ä�� �� Ship Pattern�� �����´�.
//			projectShipPattern = MqlUtil.mqlCommand(context , "print bus 'Product Configuration' "+p_master.trim()+" - select relationship[Product Configuration].from.relationship[Products].from.name dump");
			
			String plmItemCode 	= "";
//			String vItemGroup 	= "";
			String vDwgNo 		= "";
			String vCatalog 	= "";
			String vCatalogDesc	= "";
			String vCategory 	= "";
			String vMarkNo 		= "";
			String vStructureNm = "";
			
            while ( ls.next() ){
            	//Temp�� Item ����Ʈ �Ѵ�.
//            	vItemGroup = ls.getString("itemgroup");
            	vDwgNo = ls.getString("dwg_no");
            	vMarkNo = ls.getString("mark_no");

            	vStructureNm = vMarkNo.substring(0, vMarkNo.indexOf("-"));
            	//Structure Name���� Catalog�� ���Ѵ�.
				DataBox dbox1 = getCatalogInfo(vStructureNm);				
				
				if(dbox1 != null){
					vCatalog = dbox1.getString("d_catalog_name");
					vCatalogDesc = dbox1.getString("d_catalog_desc");
					vCategory = dbox1.getString("d_category_code");
				}

				

            	StringBuffer sp_query = new StringBuffer();
            	
            	sp_query.append("call stx_dis_item_pkg.stx_dis_main_proc( \n");
            	sp_query.append("     p_catalog_code => ? \n");
            	sp_query.append("	, p_ship_type => ? \n");
            	sp_query.append("	, p_weight => ? \n");
            	sp_query.append("	, p_loginid => ? \n");
            	sp_query.append("	, p_attr01_desc => ? \n");
            	sp_query.append("	, p_paint_code1 => ? \n");
            	sp_query.append("	, p_paint_code2 => ? \n");
            	sp_query.append("	, p_err_msg => ? \n");
            	sp_query.append("	, p_err_code => ? \n");
            	sp_query.append("	, p_item_code => ? ) \n");
            	
            	//GET ITEM CODE
            	cstmt = conn.prepareCall(sp_query.toString());
            	
    		    int idx = 0;
    			cstmt.setString(++idx, vCatalog);
            	cstmt.setString(++idx, ls.getString("ship_type"));
            	cstmt.setString(++idx, ls.getString("weight"));
            	cstmt.setString(++idx, box.getSession("UserId"));
            	cstmt.setString(++idx, ls.getString("attr1"));
            	cstmt.setString(++idx, ls.getString("paint_code1"));
            	cstmt.setString(++idx, ls.getString("paint_code2"));
            	
            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
            	int p_err_msg_idx = idx;
            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
            	int p_err_cd_idx = idx;
            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
            	int p_item_code_idx = idx;
            	
    		    cstmt.execute();
    		        		    
    		    String p_err_msg = cstmt.getString(p_err_msg_idx);
    		    String p_err_cd = cstmt.getString(p_err_cd_idx);
    		    String p_item_code = cstmt.getString(p_item_code_idx);
    		    
            	System.out.println("p_err_msg : " + p_err_msg);
            	System.out.println("p_err_cd : " + p_err_cd);
            	System.out.println("p_item_code : " + p_item_code);
            	
	                				
				pstmt2 = conn.prepareStatement(query2.toString());
				pstmt2.setString(1, p_item_code);
				pstmt2.setString(2, vCatalog);
				pstmt2.setString(3, vCatalogDesc);
				pstmt2.setString(4, vCategory);
				pstmt2.setString(5, (p_err_cd.equals("S"))?"":p_err_msg);			
				pstmt2.setString(6, vDwgNo);
				pstmt2.setString(7, vMarkNo);				
				pstmt2.setString(8, box.getSession("UserId"));
				
				isOk += pstmt2.executeUpdate();
				
				if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
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
            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
        }    
		return rtn; 
	}	
}

