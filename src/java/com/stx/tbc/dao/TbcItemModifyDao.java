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

public class TbcItemModifyDao implements Idao{
	
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
        	
        	if(qryExp.equals("itemModifyCheck")){
        		boolean rtn = itemModifyCheckTempInsert(rBox);
        		if(!rtn){
        			throw new Exception("Temp Insert Error");
        		}
        	}
        	
            list = new ArrayList();
            query  = getQuery(qryExp,rBox);           

			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
		    int tot_ea = 0;		    
            while ( ls.next() ){
                dbox = ls.getDataBox();
                tot_ea += ls.getInt("ea");
                list.add(dbox);
            }
            
            rBox.put("tot_ea", Integer.toString(tot_ea));
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
		
//        PreparedStatement 	pstmt 	= null;
		CallableStatement cstmt = null;
    	
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	
    	String				query   = "";
        try 
        {	
        	query  = getQuery(qryExp,rBox);
        	
        	
        	cstmt = conn.prepareCall(query.toString());
    		
    		
    		cstmt.setString(1, rBox.getSession("UserId"));
    		cstmt.setString(2, rBox.getSession("UserName"));
    		cstmt.setString(3, rBox.getSession("DeptCode"));
    		cstmt.setString(4, rBox.getSession("DeptName"));
    		cstmt.registerOutParameter(5, Types.NUMERIC);
    		cstmt.registerOutParameter(6, Types.VARCHAR);
    		
    		cstmt.executeQuery();
    		isOk = cstmt.getInt(5);
    		String msg = cstmt.getString(6);
    		
    		System.out.println("isOk : "+isOk);
    		System.out.println("msg : "+msg);
    		
        	if(isOk > 0){
        		conn.commit();
        		//Common Validation 상위정보가 변경 되었을 때 Confirm 필드에 추가해준다.
//            	for(int i = 0; i < ar_state_business.size(); i++){
//    	        	if(commonValidation.getUppChangeFlag(ar_mother_code.get(i).toString(), ar_item_code.get(i).toString())){
//    					dao.updateDB("ConfirmAction", rBox);
//    				}
//            	}
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
            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}

	private String getQuery(String qryExp, RequestBox box)
	{//URLDecoder.decode(box.getString("p_course"),"UTF-8")
		StringBuffer query = new StringBuffer();
		
		try
		{
			if(qryExp.equals("modifyList")){
				 
	  			ArrayList chklist = box.getArrayList("p_chkItem");
	  			
//	  			query.append("SELECT \n");
//				query.append("  A.STATE_FLAG \n");
//				query.append(", B.DELEGATE_PROJECT_NO AS DELEGATEPROJECTNO \n");
//				query.append(", A.PROJECT_NO \n");
//				query.append(", A.DWG_NO \n");
//				query.append(", STP.BLOCK_NO \n");
//				query.append(", STP.STR_FLAG \n");
//				query.append(", STP.STAGE_NO \n");
//				query.append(", A.MOTHER_CODE \n");
//				query.append(", A.ITEM_CODE \n");
//				query.append(", A.BOM1 \n");
//				query.append(", A.BOM2 \n");
//				query.append(", A.BOM3 \n");
//				query.append(", A.BOM4 \n");
//				query.append(", A.BOM5 \n");
//				query.append(", A.BOM6 \n");
//				query.append(", A.BOM7 \n");
//				query.append(", A.BOM8 \n");
//				query.append(", A.BOM9 \n");
//				query.append(", A.BOM10 \n");
//				query.append(", A.BOM11 \n");
//				query.append(", A.BOM12 \n");
//				query.append(", A.BOM13 \n");
//				query.append(", A.BOM14 \n");
//				query.append(", A.BOM15 \n");
//				query.append(", C.ATTR1 \n");
//				query.append(", C.ATTR2 \n");
//				query.append(", C.ATTR3 \n");
//				query.append(", C.ATTR4 \n");
//				query.append(", C.ATTR5 \n");
//				query.append(", C.ATTR6 \n");
//				query.append(", C.ATTR7 \n");
//				query.append(", C.ATTR8 \n");
//				query.append(", C.ATTR9 \n");
//				query.append(", C.ATTR10 \n");
//				query.append(", C.ATTR11 \n");
//				query.append(", C.ATTR12 \n");
//				query.append(", C.ATTR13 \n");
//				query.append(", C.ATTR14 \n");
//				query.append(", C.ATTR15 \n");
//				query.append(", A.SSC_SUB_ID \n");
//				query.append(", A.BOM_QTY AS EA \n");
//				query.append(", C.ITEM_DESC \n");
//				query.append(", C.ITEM_DESC_DETAIL \n");
//				query.append(", C.ITEM_WEIGHT \n");
//				query.append(", A.REV_NO \n");
//				query.append(", A.DEPT_NAME \n");
//				query.append(", A.DEPT_CODE \n");
//				query.append(", A.USER_NAME \n");
//				query.append(", A.USER_ID \n");
//				query.append(", A.CREATE_DATE \n");
//				query.append(", A.ECO_NO \n");
//				query.append(", A.KEY_NO \n");
//				query.append(", A.REMARK \n");
//				query.append(", A.ITEM_TYPE_CD \n");
//				query.append(", C.PAINT_CODE1 AS PAINT_CODE \n");
//				query.append(", C.PAINT_CODE2 AS PAINT_CODE2 \n");
//				query.append(", A.BOM_ITEM_DETAIL \n");
//				query.append("FROM STX_DIS_SSC_HEAD A \n");
//				query.append("INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" B ON A.PROJECT_NO = B.PROJECT_NO \n");
//				query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
//				query.append("LEFT JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
//				query.append("WHERE 1=1 \n");
//				query.append("AND ( \n");
//				for(int i = 0; i < chklist.size(); i++){
//					if(i != 0) query.append(" OR ");
//					query.append("A.PROJECT_NO || A.ITEM_TYPE_CD || A.DWG_NO || A.MOTHER_CODE || A.ITEM_CODE || A.SSC_SUB_ID = '"+chklist.get(i)+"' \n");
//	  		    }
//				query.append(") \n");
//				query.append("ORDER BY A.PROJECT_NO ,A.ITEM_CODE ");
//				
				

				query.append("SELECT /*+ USE_NL(A G C D)*/ \n");
				query.append("  A.STATE_FLAG \n");
				query.append(", A.MASTER_SHIP \n");
				query.append(", A.PROJECT_NO \n");
				query.append(", A.DWG_NO \n");
				query.append(", G.BLOCK_NO \n");
				query.append(", G.STR_FLAG \n");
				query.append(", G.STAGE_NO \n");
				query.append(", A.MOTHER_CODE \n");
				query.append(", A.ITEM_CODE \n");
				query.append(", A.BOM1 \n");
				query.append(", A.BOM2 \n");
				query.append(", A.BOM3 \n");
				query.append(", A.BOM4 \n");
				query.append(", A.BOM5 \n");
				query.append(", A.BOM6 \n");
				query.append(", A.BOM7 \n");
				query.append(", A.BOM8 \n");
				query.append(", A.BOM9 \n");
				query.append(", A.BOM10 \n");
				query.append(", A.BOM11 \n");
				query.append(", A.BOM12 \n");
				query.append(", A.BOM13 \n");
				query.append(", A.BOM14 \n");
				query.append(", A.BOM15 \n");
				query.append(", C.ATTR1 \n");
				query.append(", C.ATTR2 \n");
				query.append(", C.ATTR3 \n");
				query.append(", C.ATTR4 \n");
				query.append(", C.ATTR5 \n");
				query.append(", C.ATTR6 \n");
				query.append(", C.ATTR7 \n");
				query.append(", C.ATTR8 \n");
				query.append(", C.ATTR9 \n");
				query.append(", C.ATTR10 \n");
				query.append(", C.ATTR11 \n");
				query.append(", C.ATTR12 \n");
				query.append(", C.ATTR13 \n");
				query.append(", C.ATTR14 \n");
				query.append(", C.ATTR15 \n");
				query.append(", A.SSC_SUB_ID \n");
				query.append(", TO_CHAR(A.BOM_QTY) AS EA \n");
				query.append(", C.ITEM_WEIGHT \n");
				query.append(", A.REV_NO \n");
				query.append(", A.KEY_NO \n");
				query.append(", A.DEPT_NAME \n");
				query.append(", A.DEPT_CODE \n");
				query.append(", A.USER_NAME \n");
				query.append(", A.USER_ID \n");
				query.append(", A.CREATE_DATE \n");
				query.append(", A.ECO_NO \n");
				query.append(", A.REMARK \n");
				query.append(", A.ITEM_TYPE_CD \n");
				query.append(", A.BOM_ITEM_DETAIL \n");
				query.append(", C.PAINT_CODE1 AS PAINT_CODE \n");
				query.append(", C.PAINT_CODE2 AS PAINT_CODE2 \n");
				query.append("FROM STX_DIS_SSC_HEAD A \n");
				query.append("    ,STX_DIS_PENDING G \n");
				query.append("    ,STX_DIS_ITEM C \n");
				query.append("WHERE 1=1 \n");
				query.append("AND A.MOTHER_CODE = G.MOTHER_CODE \n");
				query.append("AND A.ITEM_CODE = C.ITEM_CODE \n");
				query.append("AND ( \n");
				for(int i = 0; i < chklist.size(); i++){
					if(i != 0) query.append(" OR ");
					query.append("A.SSC_SUB_ID = '"+chklist.get(i)+"' \n");
	  		    }
				
				query.append(") \n");
				query.append("ORDER BY A.PROJECT_NO ,A.ITEM_CODE \n");
				
				
			} else if(qryExp.equals("itemModifyCheck")){
				query.append("SELECT DISTINCT\n");
				query.append("  TEMP1  AS STATE \n");
				query.append(", TEMP2  AS STATE_BUSINESS \n");
				query.append(", TEMP3  AS STATE_FLAG \n");
				query.append(", TEMP4  AS DELEGATEPROJECTNO \n");
				query.append(", TEMP5  AS PROJECT_NO \n");
				query.append(", TEMP6  AS DWG_NO \n");
				query.append(", TEMP7  AS BLOCK_NO \n");
				query.append(", TEMP8  AS STR_FLAG \n");
				query.append(", TEMP9  AS STAGE_NO \n");
				query.append(", TEMP10 AS MOTHER_CODE \n");
				query.append(", TEMP11 AS ERROR_MOTHER_CODE \n");
				query.append(", TEMP12 AS ITEM_CODE \n");
				query.append(", TEMP13 AS BOM1 \n");
				query.append(", TEMP14 AS BOM2 \n");
				query.append(", TEMP15 AS BOM3 \n");
				query.append(", TEMP16 AS BOM4 \n");
				query.append(", TEMP17 AS BOM5 \n");
				query.append(", TEMP18 AS BOM6 \n");
				query.append(", TEMP19 AS BOM7 \n");
				query.append(", TEMP20 AS BOM8 \n");
				query.append(", TEMP21 AS BOM9 \n");
				query.append(", TEMP22 AS BOM10 \n");
				query.append(", TEMP23 AS BOM11 \n");
				query.append(", TEMP24 AS BOM12 \n");
				query.append(", TEMP25 AS BOM13 \n");
				query.append(", TEMP26 AS BOM14 \n");
				query.append(", TEMP27 AS BOM15 \n");
				query.append(", TEMP28 AS ATTR1 \n");
				query.append(", TEMP29 AS ATTR2 \n");
				query.append(", TEMP30 AS ATTR3 \n");
				query.append(", TEMP31 AS ATTR4 \n");
				query.append(", TEMP32 AS ATTR5 \n");
				query.append(", TEMP33 AS ATTR6 \n");
				query.append(", TEMP34 AS ATTR7 \n");
				query.append(", TEMP35 AS ATTR8 \n");
				query.append(", TEMP36 AS ATTR9 \n");
				query.append(", TEMP37 AS ATTR10 \n");
				query.append(", TEMP38 AS ATTR11 \n");
				query.append(", TEMP39 AS ATTR12 \n");
				query.append(", TEMP40 AS ATTR13 \n");
				query.append(", TEMP41 AS ATTR14 \n");
				query.append(", TEMP42 AS ATTR15 \n");
				query.append(", TEMP43 AS SSC_SUB_ID \n");
				query.append(", TEMP44 AS EA \n");
				query.append(", TEMP45 AS KEY_NO \n");
				query.append(", TEMP46 AS MODIFY_EA \n");
				query.append(", TEMP47 AS MODIFY_KEY \n");
				query.append(", TEMP48 AS ITEM_DESC \n");
				query.append(", TEMP49 AS ITEM_DESC_DETAIL \n");
				query.append(", TO_NUMBER(TEMP50) AS ITEM_WEIGHT \n");
				query.append(", TEMP51 AS REV_NO \n");
				query.append(", TEMP52 AS DEPT_NAME \n");
				query.append(", TEMP53 AS DEPT_CODE \n");
				query.append(", TEMP54 AS USER_NAME \n");
				query.append(", TEMP55 AS USER_ID \n");
				query.append(", TEMP56 AS CREATE_DATE \n");
				query.append(", TEMP57 AS ECO_NO \n");
				query.append(", TEMP58 AS REMARK \n");
				query.append(", TEMP59 AS ITEM_TYPE_CD \n");
				query.append(", TEMP60 AS BOM_ITEM_DETAIL \n");
				query.append(", TEMP61 AS ERRORCODE \n");
				query.append(", TEMP62 AS PROCESS \n");
				query.append(", TEMP63 AS MOVE_SSC_DATE \n");
				query.append(" FROM STX_DIS_TEMP \n");
				query.append("WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append("ORDER BY TEMP5, TEMP12, TEMP1, TEMP2, TEMP10 \n");
				
			}else if(qryExp.equals("itemUpdateAction")){
			
				query.append("UPDATE STX_DIS_SSC_HEAD A\n");
				query.append("SET BOM_QTY = ? \n");
				query.append("  , STATE_FLAG = ? \n");
				query.append("  , REV_NO = ? \n");
				query.append("  , BOM2 = ? \n"); //TRAY BOM2 : TRAY_NO
				query.append("  , BOM5 = MOTHER_CODE \n"); 
				query.append("  , BOM_ITEM_DETAIL = ? \n");
				query.append("  , ECO_NO = '' \n");
				query.append("  , MOVE_CODE = MOTHER_CODE \n");
				query.append("  , MOVE_EA = BOM_QTY \n");
				query.append("  , MOVE_JOB = JOB \n");				
				query.append("  , MOVE_SSC_DATE = (SELECT B.SSC_BOM_DATE FROM STX_DIS_PENDING B WHERE A.MOTHER_CODE = B.MOTHER_CODE AND A.JOB = B.JOB_CD) \n");
				query.append("WHERE PROJECT_NO = ? \n");
				query.append("  AND ITEM_TYPE_CD = ? \n");
				query.append("  AND DWG_NO = ? \n");
				query.append("  AND MOTHER_CODE = ? \n");
				query.append("  AND ITEM_CODE = ? \n");
				query.append("  AND SSC_SUB_ID = ? \n");
				
			}else if(qryExp.equals("itemUpdateDvalueAction")){
			
				query.append("UPDATE STX_DIS_SSC_HEAD A\n");
				query.append("SET STATE_FLAG = 'D' \n");
				query.append("  , ECO_NO = '' \n");
				query.append("WHERE PROJECT_NO = ? \n");
				query.append("  AND ITEM_TYPE_CD = ? \n");
				query.append("  AND DWG_NO = ? \n");
				query.append("  AND MOTHER_CODE = ? \n");
				query.append("  AND ITEM_CODE = ? \n");
				query.append("  AND SSC_SUB_ID = ? \n");
//				
				
			}else if(qryExp.equals("itemDeleteHeadAction")){
				
//				String p_lstage_no = box.getString("p_lstage_no");
//				String p_lstr_flag = box.getString("p_lstr_flag");
				
				query.append("DELETE STX_DIS_SSC_HEAD \n");
				query.append("WHERE PROJECT_NO = ? \n");
				query.append("  AND ITEM_TYPE_CD = ? \n");
				query.append("  AND DWG_NO = ? \n");
				query.append("  AND MOTHER_CODE = ? \n");
				query.append("  AND ITEM_CODE = ? \n");
				query.append("  AND SSC_SUB_ID = ? \n");
//				query.append("  AND BLOCK_NO = ? \n");
//				if(!p_lstage_no.equals("")){
//					query.append("  AND STAGE_NO = ? \n");
//				}else{
//					query.append("  AND STAGE_NO IS NULL \n");
//				}
//				if(!p_lstr_flag.equals("")){
//					query.append("  AND STR_FLAG = ? \n");
//				}
//				
				
			}else if(qryExp.equals("itemAddHeadAction")){
				query.append(" INSERT INTO STX_DIS_SSC_HEAD ( ");
				query.append("   PROJECT_NO ");
				query.append(" , ITEM_TYPE_CD ");
				query.append(" , DWG_NO ");
				query.append(" , MOTHER_CODE ");
				query.append(" , ITEM_CODE ");
				query.append(" , SSC_SUB_ID ");
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
				query.append(" , BOM_ITEM_DETAIL ");
				query.append(" , MOVE_SSC_DATE ");
				query.append(" ) \n");
				query.append("SELECT ");
				query.append("   PROJECT_NO ");
				query.append(" , ITEM_TYPE_CD ");
				query.append(" , DWG_NO ");
				query.append(" , ? "); //MOTHER_CODE
				query.append(" , ITEM_CODE ");
				query.append(" , STXPLMLIVE.STX_DIS_SSC_SUB_ID_SQ.NEXTVAL "); //SSC_SUB_ID
				query.append(" , ? "); //REV_NO
				query.append(" , BOM1 ");
				query.append(" , ? "); //BOM2 : TRAY 사용.
				query.append(" , BOM3 ");
				query.append(" , BOM4 ");
				query.append(" , MOTHER_CODE "); //BOM5 기존 MOTHER_CODE
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
				query.append(" , ( SELECT D.BLOCK_DIV_CD \n");
				query.append("       FROM STX_DIS_PENDING B \n");
				query.append(" INNER JOIN STX_DIS_JOB_CONFIRM C ON B.JOB_CD = CASE WHEN C.JOB_CD2 IS NULL THEN C.JOB_CD1 ELSE C.JOB_CD2 END \n");
				query.append(" INNER JOIN STX_DIS_ACTIVITY_CONFIRM D ON C.ACTIVITY_CD = D.ACTIVITY_CD \n");
				query.append("      WHERE MOTHER_CODE = ? ) \n"); //BLOCK_DIV
				query.append(" , BLOCK_CHG_DATE ");
				query.append(" , (SELECT B.JOB_CD FROM STX_DIS_PENDING B WHERE B.MOTHER_CODE = ?) \n"); //JOB
				query.append(" , JOB_CHG_DATE ");
				query.append(" , UPP_CHG_FLAG ");
				query.append(" , UPP_CHG_DATE ");
				query.append(" , ? "); //DEPT_CODE
				query.append(" , ? "); //DEPT_NAME
				query.append(" , DWG_CHECK ");
				query.append(" , ? "); //BOM_QTY
				query.append(" , '' ");
				query.append(" , MASTER_SHIP ");
				query.append(" , MOTHER_CODE "); //MOVE_CODE
				query.append(" , BOM_QTY "); //MOVE_EA
				query.append(" , JOB "); //MOVE_JOB
				query.append(" , PAINT_CODE3 ");
				query.append(" , PAINT_CODE4 ");
				query.append(" , PAINT_CODE5 ");
				query.append(" , RAW_LV ");
				query.append(" , REMARK ");				
				query.append(" , ? "); //STATE_FLAG
				query.append(" , KEY_NO ");
				query.append(" , ? "); //USER_ID
				query.append(" , ? "); //USER_NAME
				query.append(" , SYSDATE "); //CREATE_DATE
				query.append(" , ? "); //BOM_ITEM_DETAIL
				query.append(" , (SELECT B.SSC_BOM_DATE FROM STX_DIS_PENDING B WHERE A.MOTHER_CODE = B.MOTHER_CODE AND A.JOB = B.JOB_CD) "); //BOM_ITEM_DETAIL
				query.append("FROM STX_DIS_SSC_HEAD A \n");
				query.append("WHERE PROJECT_NO = ? \n");
				query.append("  AND ITEM_CODE = ? \n");
				query.append("  AND DWG_NO = ? \n");
				query.append("  AND SSC_SUB_ID = ? \n");
				
			} else if(qryExp.equals("itemAddSubAction")){
				
				query.append("INSERT INTO STX_DIS_SSC_SUB( SSC_SUB_ID, ELEMENT_SEQUENCE, ELEMENT_VALUE )   \n");
				query.append("SELECT \n");
				query.append("   STXDIS.STX_DIS_SSC_SUB_ID_SQ.CURRVAL \n");
				query.append(" , ELEMENT_SEQUENCE \n");
				query.append(" , ELEMENT_VALUE \n");
				query.append(" FROM STX_DIS_SSC_SUB \n");
				query.append("WHERE SSC_SUB_ID = ? \n");
				
			} else if(qryExp.equals("itemDeleteSubAction")){
				
				query.append("DELETE STX_DIS_SSC_SUB\n");
				query.append("WHERE SSC_SUB_ID = ? \n");
				
			} else if(qryExp.equals("ModifyAction")){
				query.append("{call STX_DIS_SSC_MODIFY_ACTION_PROC(?, ?, ?, ?, ?, ?)} ");
			} 
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	private int getIsItemCount(String p_series, String p_item_code, String p_block, String p_stage, String p_str, String p_dwgno, String p_mother_code, String p_key_val) throws Exception {
        Connection conn = null;
        conn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int v_isItemCnt= 0;
        
    	try 
        { 
        	query.append("SELECT \n");
        	query.append("COUNT(*) AS CNT \n");
			query.append("FROM STX_DIS_SSC_HEAD STSH \n");
			query.append("INNER JOIN STX_DIS_PENDING STP ON STSH.MOTHER_CODE = STP.MOTHER_CODE\n");
			query.append("WHERE STSH.PROJECT_NO = '"+p_series+"' \n");
			query.append("  AND STP.BLOCK_NO = '"+p_block+"' \n");
			query.append("  AND STSH.ITEM_CODE = '"+p_item_code+"' \n");
			query.append("  AND STSH.DWG_NO = '"+p_dwgno+"' \n");
			//query.append("  AND MOTHER_CODE = '"+p_mother_code+"' \n");
			
			if(!p_stage.equals("")){
				query.append("  AND STP.STAGE_NO = '"+p_stage+"' \n");
			}else{
				query.append("  AND STP.STAGE_NO IS NULL \n");
			}
			if(!p_str.equals("")){
				query.append("  AND STP.STR_FLAG = '"+p_str+"' \n");
			}
			
			if(!p_key_val.toString().equals("")){
				query.append("  AND STSH.KEY_NO = '"+p_key_val+"' \n");
			}
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	v_isItemCnt = ls.getInt(1);
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
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
        }
        return v_isItemCnt;
	}
	
	private int ModifyAddModule(RequestBox rBox, Connection conn, String p_mother_code, String p_block_no, String p_stage_no, 
			String p_str, String p_bom_qty, String p_project_no, String p_item_code, String p_dwg_no, String p_ssc_sub_id, 
			String p_state, String p_selrev, String p_modify_key, String p_bom_item_detail) throws Exception {
		// TODO Auto-generated method stub		
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        
    	
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	int 				isOk2    = 0;
    	
    	String				query   = "";
        try 
        { 
        	String ss_userid = rBox.getSession("UserId");
        	String ss_username = rBox.getSession("UserName");
        	String ss_deptcode = rBox.getSession("DeptCode");
        	String ss_deptname = rBox.getSession("DeptName");
        	
        	//Head 입력
        	query  = getQuery("itemAddHeadAction",rBox);
        	pstmt = conn.prepareStatement(query.toString());
        	
        	int idx = 0;
        	pstmt.setString(++idx, p_mother_code);
//        	pstmt.setString(++idx, p_block_no);
//        	pstmt.setString(++idx, p_stage_no);
//        	pstmt.setString(++idx, p_str);
        	pstmt.setString(++idx, p_selrev);
        	pstmt.setString(++idx, p_modify_key);
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, ss_deptcode);
        	pstmt.setString(++idx, ss_deptname);
        	pstmt.setString(++idx, p_bom_qty);
        	pstmt.setString(++idx, p_state);
        	pstmt.setString(++idx, ss_userid);
        	pstmt.setString(++idx, ss_username);
        	pstmt.setString(++idx, p_bom_item_detail);
        	pstmt.setString(++idx, p_project_no);
        	pstmt.setString(++idx, p_item_code);
        	pstmt.setString(++idx, p_dwg_no);
        	pstmt.setString(++idx, p_ssc_sub_id);
        	
        	isOk = pstmt.executeUpdate();
        	if(isOk > 0){
        		int idx2 = 0;
        		query  = getQuery("itemAddSubAction",rBox);
        		
        		pstmt2 = conn.prepareStatement(query.toString());
        		pstmt2.setString(++idx2, p_ssc_sub_id);
            	
            	isOk2 = pstmt2.executeUpdate();            	
        	}
        	if(isOk > 0){
        		isOkRtn = 1;
        	}else{
        		isOkRtn = 0;
        	}

        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
        }        
		return isOkRtn;
	}
	private int ModifyModifyModule(RequestBox rBox, Connection conn, String p_project_no, String p_item_type_cd, 
			String p_dwg_no, String p_mother_code, String p_item_code, String p_ssc_sub_id, String p_lblock_no, 
			String p_lstage_no, String p_lstr_flag, String p_state, String p_bom_qty, String p_selrev, String p_modifyKey, String p_bom_item_detail) throws Exception {
		// TODO Auto-generated method stub		
		
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        
    	
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	
    	String				query   = "";
        try 
        { 
        	//Head 입력
        	
			rBox.remove("p_lstage_no");
			rBox.remove("p_lstr_flag");
			rBox.put("p_lstage_no", p_lstage_no);
			rBox.put("p_lstr_flag", p_lstr_flag);
			
			//Modify
			query  = getQuery("itemUpdateAction",rBox);
			pstmt = conn.prepareStatement(query.toString());
			
			int idx = 0;
        	pstmt.setString(++idx, p_bom_qty);
        	pstmt.setString(++idx, p_state);
        	pstmt.setString(++idx, p_selrev);
        	pstmt.setString(++idx, p_modifyKey);
        	pstmt.setString(++idx, p_bom_item_detail);
        	pstmt.setString(++idx, p_project_no);
        	pstmt.setString(++idx, p_item_type_cd);
        	pstmt.setString(++idx, p_dwg_no);
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, p_item_code);
        	pstmt.setString(++idx, p_ssc_sub_id);

        	isOk = pstmt.executeUpdate();
        	
        	if(isOk > 0 ){
        		isOkRtn = 1;
        	}else{
        		isOkRtn = 0;
        	}

        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
        }        
		return isOkRtn;
	}
	private int ModifyModifyDvalueModule(RequestBox rBox, Connection conn, String p_project_no, String p_item_type_cd, 
			String p_dwg_no, String p_mother_code, String p_item_code, String p_ssc_sub_id, String p_lblock_no, 
			String p_lstage_no, String p_lstr_flag, String p_state, String p_bom_qty, String p_selrev, String p_modifyKey, String p_bom_item_detail) throws Exception {
		// TODO Auto-generated method stub		
		
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        
    	
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	
    	String				query   = "";
        try 
        { 
        	//Head 입력
        	
			rBox.remove("p_lstage_no");
			rBox.remove("p_lstr_flag");
			rBox.put("p_lstage_no", p_lstage_no);
			rBox.put("p_lstr_flag", p_lstr_flag);
			
			//Delete
			query  = getQuery("itemUpdateDvalueAction",rBox);
			pstmt = conn.prepareStatement(query.toString());
			
			int idx = 0;
			
        	pstmt.setString(++idx, p_project_no);
        	pstmt.setString(++idx, p_item_type_cd);
        	pstmt.setString(++idx, p_dwg_no);
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, p_item_code);
        	pstmt.setString(++idx, p_ssc_sub_id);

        	isOk = pstmt.executeUpdate();
        	
        	if(isOk > 0 ){
        		isOkRtn = 1;
        	}else{
        		isOkRtn = 0;
        	}

        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
        }        
		return isOkRtn;
	}
	private int ModifyDeleteModule(RequestBox rBox, Connection conn, String p_project_no, String p_item_type_cd, 
			String p_dwg_no, String p_mother_code, String p_item_code, String p_ssc_sub_id, String p_lblock_no, 
			String p_lstage_no, String p_lstr_flag, String p_state) throws Exception {
		// TODO Auto-generated method stub		
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        
    	
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	int 				isOk2    = 1;
    	
    	String				query   = "";
        try 
        { 
        	//Head 입력
        	query  = getQuery("itemDeleteHeadAction",rBox);
			pstmt = conn.prepareStatement(query.toString());

			int idx = 0;
        	pstmt.setString(++idx, p_project_no);
        	pstmt.setString(++idx, p_item_type_cd);
        	pstmt.setString(++idx, p_dwg_no);
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, p_item_code);
        	pstmt.setString(++idx, p_ssc_sub_id);
//        	pstmt.setString(++idx, p_lblock_no);
//        	if(!p_lstage_no.equals("")){
//        		pstmt.setString(++idx, p_lstage_no);
//        	}
//        	if(!p_lstr_flag.equals("")){
//        		pstmt.setString(++idx, p_lstr_flag);
//        	}
        	
        	
        	isOk = pstmt.executeUpdate();
        	
        	if(isOk > 0){
        		//Sub 삭제 로직 
        		//int idx2 = 0;
        		//query  = getQuery("itemDeleteSubAction",rBox);
        		
        		//pstmt2 = conn.prepareStatement(query.toString());
        		//pstmt2.setString(++idx2, p_ssc_sub_id);
            	
            	//isOk2 = pstmt2.executeUpdate();            	
        	}
        	
        	if(isOk > 0 && isOk2 > 0 ){
        		isOkRtn = 1;
        	}else{
        		isOkRtn = 0;
        	}

        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
        }        
		return isOkRtn;
	}
	
	
	private boolean itemModifyCheckTempInsert(RequestBox box) throws Exception {
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
			
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        {         	
        	String ssUserid = box.getSession("UserId");
  			String p_block = box.getString("p_block");
  			String p_stage = box.getString("p_stage");
  			String p_str = box.getString("p_str");
  			String p_job_cd = box.getString("p_job_cd");
  			String p_selrev = box.getString("p_selrev");
  			String p_item_type_cd = box.getString("p_item_type_cd");
  			String p_dwgno = box.getString("p_dwgno");
			
  			int v_seriesFlag = 0;
  			int v_errorCode = 0;
			String v_process = "OK";
			

			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_itemcode = box.getArrayList("p_item_code");
			ArrayList ar_modifyEA = box.getArrayList("p_modifyEA");
			ArrayList ar_modifyKey = box.getArrayList("p_modifyKey");
			ArrayList ar_modifyDetail = box.getArrayList("p_modifyDetail");
			ArrayList ar_modifySupply = box.getArrayList("p_modifySupply");
			
			ArrayList ar_mother_code = box.getArrayList("p_mother_code");
			ArrayList ar_ea = box.getArrayList("p_ea");
			//key 용도 : Tray의 경우 Tray No의 ','로 구분된 수와 해당 아이템의 EA가 같음을 확인하는 Key로 활용.
			ArrayList ar_key = box.getArrayList("p_key");
			//key_no 용도 : Valve의 경우 같은 Mother에 같은 ItemCode가 존재하기 때문에 key No를 이용하여 구분한다.(key_no가 다르면 다른아이템이라고 판단)
			ArrayList ar_key_no = box.getArrayList("p_key_no");
			
			ArrayList ar_lproject_no = box.getArrayList("p_lproject_no");
			ArrayList ar_lblock_no = box.getArrayList("p_lblock_no");
			ArrayList ar_lstr_flag = box.getArrayList("p_lstr_flag");
			ArrayList ar_lstage_no = box.getArrayList("p_lstage_no");
			
//			//시리즈 선택이 없을 경우 해당 Project만 수행 한다.
//			if(ar_series.size() == 0){
//				v_seriesFlag = 1;
//				for(int i=0; i<ar_lproject_no.size(); i++){
//					boolean path = true;
//					if(i != 0){
//						for(int j=0; j<ar_series.size(); j++){
//							if(ar_series.get(j).equals(ar_lproject_no.get(i))){
//								path = false;
//								break;
//							}
//						}
//					}
//					if(path){
//						ar_series.add(ar_lproject_no.get(i));
//					}
//				}
//			}
			
			String v_itemcode = "";
			String v_modifyEA = "";
			String v_EA = "";
			String v_modifyKey = "";
			String v_key = "";
			String v_modifyDetail = "";
			String v_detail = "";
			String v_modifySupply = "";
			
			//TEMP DATA 삭제
			query = "DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'";
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP 삭제
			
  			//MOVE 정보가 모두  비었으면 수량 변경 로직 수행.
  			if(p_block.equals("") && p_stage.equals("") && p_str.equals("")){
  				
				//query.append("SELECT * FROM ( \n");
				
				for(int j=0; j<ar_itemcode.size(); j++){
					
					v_itemcode = ar_itemcode.get(j).toString().trim();
					
					if(ar_modifyEA != null && ar_modifyEA.size() > 0){
						v_modifyEA = ar_modifyEA.get(j).toString().trim();
					}else{
						v_modifyEA = ar_ea.get(j).toString();
					}
					
					if(ar_modifyKey != null && ar_modifyKey.size() > 0){
						v_modifyKey = ar_modifyKey.get(j).toString().trim();
					}
					
					if(ar_modifySupply != null && ar_modifySupply.size() > 0){
						v_modifySupply = ar_modifySupply.get(j).toString().trim();
					}
					
					if(ar_series.size() > 0){
						for(int i=0; i<ar_series.size(); i++){
							query = getQueryChangeEa(ar_series.size(), ar_lstr_flag.get(j).toString(), ar_lstage_no.get(j).toString());
							
				        	pstmt = conn.prepareStatement(query.toString());
				        	int idx = 0;
				        	pstmt.setString(++idx, ssUserid);
				        	pstmt.setString(++idx, v_modifySupply);
				        	pstmt.setString(++idx, v_modifyEA);
				        	pstmt.setString(++idx, v_modifyKey);
				        	pstmt.setString(++idx, p_selrev);
				        	pstmt.setInt   (++idx, v_errorCode);
				        	pstmt.setString(++idx, v_process);
				        	pstmt.setString(++idx, ar_series.get(i).toString());
				        	pstmt.setString(++idx, v_itemcode);
				        	pstmt.setString(++idx, ar_lblock_no.get(j).toString());
				        	pstmt.setString(++idx, ar_ea.get(j).toString());				   
				        	pstmt.setString(++idx, p_dwgno);
				        	
				        	isOk += pstmt.executeUpdate();
						}
					}else{
						query = getQueryChangeEa(ar_series.size(), ar_lstr_flag.get(j).toString(), ar_lstage_no.get(j).toString());
						
			        	pstmt = conn.prepareStatement(query.toString());
			        	int idx = 0;
			        	pstmt.setString(++idx, ssUserid);
			        	pstmt.setString(++idx, v_modifySupply);
			        	pstmt.setString(++idx, v_modifyEA);
			        	pstmt.setString(++idx, v_modifyKey);
			        	pstmt.setString(++idx, p_selrev);
			        	pstmt.setInt   (++idx, v_errorCode);
			        	pstmt.setString(++idx, v_process);
			        	pstmt.setString(++idx, ar_lproject_no.get(j).toString());
			        	pstmt.setString(++idx, v_itemcode);
			        	pstmt.setString(++idx, ar_lblock_no.get(j).toString());
			        	pstmt.setString(++idx, ar_ea.get(j).toString());
			        	pstmt.setString(++idx, p_dwgno);    	
		        		pstmt.setString(++idx, ar_mother_code.get(j).toString());
		        		
			        	isOk += pstmt.executeUpdate();
					}
				}
				
				//query.append(") CHK_TABLE ORDER BY PROJECT_NO, ITEM_CODE, STATE_FLAG \n");
				
  			}else{  				
  				//아이템 무브 로직 수행.
				
				for(int j=0; j<ar_itemcode.size(); j++){
					if(ar_modifyEA.size() == 0){
						v_modifyEA = "1";
					}else{
						v_modifyEA = ar_modifyEA.get(j).toString().trim();
					}
					if(ar_ea.size() == 0){
						v_EA = "1";
					}else{
						v_EA = ar_ea.get(j).toString();
					}
					if(ar_modifyDetail.size() > 0){
						v_modifyDetail = ar_modifyDetail.get(j).toString().trim();
					}
					
					if(ar_modifySupply != null && ar_modifySupply.size() > 0){
						v_modifySupply = ar_modifySupply.get(j).toString().trim();
					}
					
					v_itemcode = ar_itemcode.get(j).toString().trim();
					
					String RemainKey = "";
					//Tray Logic 변경 시 Tray No를 뒤져 같은 Tray no는 삭제. 
					if(ar_modifyKey != null && ar_key != null && ar_modifyKey.size() > 0 && ar_key.size() > 0){
						v_key = ar_key.get(j).toString().trim();	
						v_modifyKey = ar_modifyKey.get(j).toString().trim();
												
						String[] StringArrayKey = v_key.split(",");
						String[] StringArrayModifyKey = v_modifyKey.split(",");
						//Key를 나누어 LOOP를 돌린다.
						for(int k=0; k < StringArrayKey.length; k++){
							//이동할 Key를 나누어 이중FOR로 구현.
							boolean isKeyOk = true;
							for(int n=0; n < StringArrayModifyKey.length; n++){
//								System.out.println("StringArrayKey[k] : " + StringArrayKey[k]);
//								System.out.println("StringArrayModifyKey[n] : " + StringArrayModifyKey[n]);
								//Key의 값이 같이 않아야 저장. 
								if(StringArrayKey[k].equals(StringArrayModifyKey[n])){
									isKeyOk = false;
									break;
								}
							}
							if(isKeyOk){
								if(!RemainKey.equals("")) RemainKey += ",";
								RemainKey += StringArrayKey[k];
							}
						}
					}
					
					
					String vKeyNo = "";
					if(ar_key_no != null && ar_key_no.size() > 0 ){
						vKeyNo = ar_key_no.get(j).toString().trim();
					}
					
					String vKey = "";
					if(ar_key != null && ar_key.size() > 0 ){
						vKey = ar_key.get(j).toString().trim();
					}
					
//						System.out.println("ar_series.size() : "+ar_series.size());
					//시리즈 체크를 했을 경우. 시리즈로 루프 돌림
					
					if(ar_series.size() > 0){
						for(int i=0; i<ar_series.size(); i++){							
							int isItemCnt = getIsItemCount(ar_series.get(i).toString(), v_itemcode, p_block, p_stage, p_str , p_dwgno, ar_mother_code.get(j).toString(), vKeyNo);
							
							query = getQueryMove(ar_series.size(), v_modifyEA, isItemCnt, ar_lstr_flag.get(j).toString(), ar_lstage_no.get(j).toString(), vKey, vKeyNo, v_modifyKey, p_stage, p_str);
							
							pstmt = conn.prepareStatement(query.toString());
							int idx =0;
							pstmt.setString(++idx, ssUserid);
							pstmt.setString(++idx, v_modifySupply);
							pstmt.setString(++idx, RemainKey);
							pstmt.setString(++idx, p_selrev);								
							pstmt.setInt   (++idx, v_errorCode);
							pstmt.setString(++idx, v_process);
							pstmt.setString(++idx, ar_series.get(i).toString());
							pstmt.setString(++idx, v_itemcode);
							pstmt.setString(++idx, ar_lblock_no.get(j).toString());
							//pstmt.setString(++idx, ar_mother_code.get(j).toString());
							pstmt.setString(++idx, p_dwgno);
							pstmt.setString(++idx, v_EA);
							
							
							//옮기는 곳에 있는 경우.
							if(isItemCnt > 0){
								pstmt.setString(++idx, ssUserid);
								pstmt.setString(++idx, v_modifySupply);
								pstmt.setString(++idx, p_selrev);
								pstmt.setString(++idx, v_modifyDetail);
								pstmt.setInt   (++idx, v_errorCode);
								pstmt.setString(++idx, v_process);
								pstmt.setString(++idx, ar_series.get(i).toString());
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, v_itemcode);
								pstmt.setString(++idx, p_dwgno);
								
							
								
							}else{ //옮기는 곳에 없는 경우.
								
								TBCCommonValidation common_validation = new TBCCommonValidation();
								//String mother_code = common_validation.getMotherCode(ar_series.get(i).toString(), p_dwgno, p_block, p_stage, p_str);
								
								pstmt.setString(++idx, ssUserid);							
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, p_str);
								pstmt.setString(++idx, p_stage);
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, p_stage);
								pstmt.setString(++idx, p_str);
								pstmt.setString(++idx, p_job_cd);
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, p_stage);
								pstmt.setString(++idx, p_str);
								pstmt.setString(++idx, p_job_cd);
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, p_stage);
								pstmt.setString(++idx, p_str);
								pstmt.setString(++idx, p_job_cd);
								pstmt.setString(++idx, v_itemcode);
								pstmt.setString(++idx, v_modifySupply);
								pstmt.setString(++idx, p_selrev);
								pstmt.setString(++idx, v_modifyDetail);
								pstmt.setInt   (++idx, v_errorCode);
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, p_stage);
								pstmt.setString(++idx, p_str);
								pstmt.setString(++idx, p_job_cd);
								pstmt.setString(++idx, p_block);
								pstmt.setString(++idx, p_stage);
								pstmt.setString(++idx, p_str);
								pstmt.setString(++idx, p_job_cd);
								pstmt.setString(++idx, ar_series.get(i).toString());
								pstmt.setString(++idx, v_itemcode);
								pstmt.setString(++idx, p_dwgno);
								pstmt.setString(++idx, v_EA);
								pstmt.setString(++idx, ar_lblock_no.get(j).toString());
								
							}

							isOk += pstmt.executeUpdate();
				        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
						
						}
					}else{ // 시리즈 정보가 없는 경우 레코드 기준.

						TBCCommonValidation common_validation = new TBCCommonValidation();
//							String mother_code = common_validation.getMotherCode(ar_lproject_no.get(j).toString(), p_dwgno, p_block, p_stage, p_str);
						
//							private String getQueryMove(int v_modifyEA, int isItemCnt, String vLstr_flag, String vLstage_no
//			                  , String vKey, String vKeyNo, String vModifyKey, String vStage, String vStr, String vMotherCode
//	) 
						int isItemCnt = getIsItemCount(ar_lproject_no.get(j).toString(), v_itemcode, p_block, p_stage, p_str , p_dwgno, ar_mother_code.get(j).toString(), vKeyNo);
						
						
						query = getQueryMove(ar_series.size(), v_modifyEA, isItemCnt, ar_lstr_flag.get(j).toString(), ar_lstage_no.get(j).toString(), vKey, vKeyNo, v_modifyKey, p_stage, p_str);
						
						pstmt = conn.prepareStatement(query.toString());
						int idx =0;
						
						pstmt.setString(++idx, ssUserid);
						pstmt.setString(++idx, RemainKey);
						pstmt.setString(++idx, p_selrev);
						pstmt.setInt   (++idx, v_errorCode);
						pstmt.setString(++idx, v_process);
						pstmt.setString(++idx, ar_lproject_no.get(j).toString());
						pstmt.setString(++idx, v_itemcode);
						pstmt.setString(++idx, ar_lblock_no.get(j).toString());
						pstmt.setString(++idx, p_dwgno);
						pstmt.setString(++idx, v_EA);
						pstmt.setString(++idx, ar_mother_code.get(j).toString());
						
						//옮기는 곳에 있는 경우.
						if(isItemCnt > 0){
							pstmt.setString(++idx, ssUserid);
							pstmt.setString(++idx, v_modifySupply);
							pstmt.setString(++idx, p_selrev);
							pstmt.setString(++idx, v_modifyDetail);
							pstmt.setInt   (++idx, v_errorCode);
							pstmt.setString(++idx, v_process);
							pstmt.setString(++idx, ar_lproject_no.get(j).toString());
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, v_itemcode);
							pstmt.setString(++idx, p_dwgno);
							
						
							
						}else{ //옮기는 곳에 없는 경우.
							
//								if(mother_code.equals("")){
//									v_process = "NO";							
//								}
							
							pstmt.setString(++idx, ssUserid);							
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, p_str);
							pstmt.setString(++idx, p_stage);
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, p_stage);
							pstmt.setString(++idx, p_str);
							pstmt.setString(++idx, p_job_cd);
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, p_stage);
							pstmt.setString(++idx, p_str);
							pstmt.setString(++idx, p_job_cd);
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, p_stage);
							pstmt.setString(++idx, p_str);
							pstmt.setString(++idx, p_job_cd);
							pstmt.setString(++idx, v_itemcode);
							pstmt.setString(++idx, v_modifySupply);
							pstmt.setString(++idx, p_selrev);
							pstmt.setString(++idx, v_modifyDetail);
							pstmt.setInt   (++idx, v_errorCode);
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, p_stage);
							pstmt.setString(++idx, p_str);
							pstmt.setString(++idx, p_job_cd);
							pstmt.setString(++idx, p_block);
							pstmt.setString(++idx, p_stage);
							pstmt.setString(++idx, p_str);
							pstmt.setString(++idx, p_job_cd);
							pstmt.setString(++idx, ar_lproject_no.get(j).toString());
							pstmt.setString(++idx, v_itemcode);
							pstmt.setString(++idx, p_dwgno);
							pstmt.setString(++idx, v_EA);
							pstmt.setString(++idx, ar_lblock_no.get(j).toString());
							
						}

						isOk += pstmt.executeUpdate();
			        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
					}	
				}
			}
  			
        	if(isOk > 0){
        		conn.commit();
        		box.put("successMsg", "Success");
        		rtn = true;
        	}else{
        		conn.rollback();
        		box.put("errorMsg", "Fail");
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();
        	box.put("errorMsg", "Fail");
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }        
		
		return rtn;
	}
	
	private String getQueryChangeEa(int vSeriesSize, String vLstr_flag, String vLstage_no) throws Exception {
		// TODO Auto-generated method stub		
		
    	StringBuffer query = new StringBuffer();
        
    	
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
		query.append("  	      , TEMP34 \n");
		query.append("  	      , TEMP35 \n");
		query.append("  	      , TEMP36 \n");
		query.append("  	      , TEMP37 \n");
		query.append("  	      , TEMP38 \n");
		query.append("  	      , TEMP39 \n");
		query.append("  	      , TEMP40 \n");
		query.append("  	      , TEMP41 \n");
		query.append("  	      , TEMP42 \n");
		query.append("  	      , TEMP43 \n");
		query.append("  	      , TEMP44 \n");
		query.append("  	      , TEMP45 \n");
		query.append("  	      , TEMP46 \n");
		query.append("  	      , TEMP47 \n");
		query.append("  	      , TEMP48 \n");
		query.append("  	      , TEMP49 \n");
		query.append("  	      , TEMP50 \n");
		query.append("  	      , TEMP51 \n");
		query.append("  	      , TEMP52 \n");
		query.append("  	      , TEMP53 \n");
		query.append("  	      , TEMP54 \n");
		query.append("  	      , TEMP55 \n");
		query.append("  	      , TEMP56 \n");
		query.append("  	      , TEMP57 \n");
		query.append("  	      , TEMP58 \n");
		query.append("  	      , TEMP59 \n");
		query.append("  	      , TEMP60 \n");
		query.append("  	      , TEMP61 \n");
		query.append("  	      , TEMP62 \n");
		query.append("  	      , TEMP63 \n");
		query.append("  	      , TEMP64 \n");
		query.append("  	      ) \n");
		query.append("SELECT \n");
		query.append("  ? \n");
		query.append(", CASE WHEN A.ECO_NO IS NULL THEN A.STATE_FLAG \n");
		query.append("    ELSE 'C' \n");
		query.append("  END AS STATE \n");
		query.append(", 'C_EA' AS STATE_BUSINESS \n");
		query.append(", A.STATE_FLAG \n");
		query.append(", A.MASTER_SHIP \n");
		query.append(", A.PROJECT_NO \n");
		query.append(", A.DWG_NO \n");
		query.append(", STP.BLOCK_NO \n");
		query.append(", STP.STR_FLAG \n");
		query.append(", STP.STAGE_NO \n");
		query.append(", A.MOTHER_CODE \n");
		query.append(", '' AS ERROR_MOTHER_CODE \n");
		query.append(", A.ITEM_CODE \n");
		query.append(", A.BOM1 \n");
		query.append(", A.BOM2 \n");
		query.append(", A.BOM3 \n");
		query.append(", A.BOM4 \n");
		query.append(", A.BOM5 \n");
		query.append(", A.BOM6 \n");
		query.append(", NVL(?, A.BOM7) AS MODIFY_SUPPLY \n");
		query.append(", A.BOM8 \n");
		query.append(", A.BOM9 \n");
		query.append(", A.BOM10 \n");
		query.append(", A.BOM11 \n");
		query.append(", A.BOM12 \n");
		query.append(", A.BOM13 \n");
		query.append(", A.BOM14 \n");
		query.append(", A.BOM15 \n");
		query.append(", C.ATTR1 \n");
		query.append(", C.ATTR2 \n");
		query.append(", C.ATTR3 \n");
		query.append(", C.ATTR4 \n");
		query.append(", C.ATTR5 \n");
		query.append(", C.ATTR6 \n");
		query.append(", C.ATTR7 \n");
		query.append(", C.ATTR8 \n");
		query.append(", C.ATTR9 \n");
		query.append(", C.ATTR10 \n");
		query.append(", C.ATTR11 \n");
		query.append(", C.ATTR12 \n");
		query.append(", C.ATTR13 \n");
		query.append(", C.ATTR14 \n");
		query.append(", C.ATTR15 \n");
		query.append(", A.SSC_SUB_ID \n");
		query.append(", A.BOM_QTY AS EA \n");
		query.append(", A.KEY_NO \n");
		query.append(", ? AS MODIFY_EA \n");
		query.append(", ? AS MODIFY_KEY \n");
		query.append(", C.ITEM_DESC \n");
		query.append(", C.ITEM_DESC_DETAIL \n");
		query.append(", C.ITEM_WEIGHT \n");
		query.append(", ? AS REV_NO \n");
		query.append(", A.DEPT_NAME \n");
		query.append(", A.DEPT_CODE \n");
		query.append(", A.USER_NAME \n");
		query.append(", A.USER_ID \n");
		query.append(", A.CREATE_DATE \n");
		query.append(", A.ECO_NO \n");
		query.append(", A.REMARK \n");
		query.append(", A.ITEM_TYPE_CD \n");
		query.append(", A.BOM_ITEM_DETAIL \n");
		query.append(", ? AS ERRORCODE \n");
		query.append(", ? AS PROCESS \n");
		query.append(", STP.SSC_BOM_DATE \n");
		query.append(", A.UPP_CONFIRM_DATE \n");
		query.append("FROM STX_DIS_SSC_HEAD A \n");
		query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
		query.append("LEFT JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
		query.append("WHERE A.PROJECT_NO = ? \n");
		query.append("  AND A.ITEM_CODE = ? \n");
		query.append("  AND STP.BLOCK_NO = ? \n");
		query.append("  AND A.BOM_QTY = ? \n");
		query.append("  AND A.DWG_NO = ? \n");	
		query.append("  AND A.STATE_FLAG <> 'D' \n");
		if(vSeriesSize == 0){
			query.append("  AND A.MOTHER_CODE = ? \n");
		}

		if(!vLstr_flag.equals("")){
			query.append("  AND STP.STR_FLAG = '"+vLstr_flag+"' \n");
		}
		if(!vLstage_no.equals("")){
			query.append("  AND STP.STAGE_NO = '"+vLstage_no+"' \n");
		}else{
			query.append("  AND STP.STAGE_NO IS NULL \n");
		} 
		return query.toString();
	} 
	
	private String getQueryMove(int vSeriesSize, String v_modifyEA, int isItemCnt, String vLstr_flag, String vLstage_no
			                  , String vKey, String vKeyNo, String vModifyKey, String vStage, String vStr
	) throws Exception {
		//TODO GET QUERY MOVE
		
		
		StringBuffer query = new StringBuffer();		
		
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
		query.append("  	      , TEMP34 \n");
		query.append("  	      , TEMP35 \n");
		query.append("  	      , TEMP36 \n");
		query.append("  	      , TEMP37 \n");
		query.append("  	      , TEMP38 \n");
		query.append("  	      , TEMP39 \n");
		query.append("  	      , TEMP40 \n");
		query.append("  	      , TEMP41 \n");
		query.append("  	      , TEMP42 \n");
		query.append("  	      , TEMP43 \n");
		query.append("  	      , TEMP44 \n");
		query.append("  	      , TEMP45 \n");
		query.append("  	      , TEMP46 \n");
		query.append("  	      , TEMP47 \n");
		query.append("  	      , TEMP48 \n");
		query.append("  	      , TEMP49 \n");
		query.append("  	      , TEMP50 \n");
		query.append("  	      , TEMP51 \n");
		query.append("  	      , TEMP52 \n");
		query.append("  	      , TEMP53 \n");
		query.append("  	      , TEMP54 \n");
		query.append("  	      , TEMP55 \n");
		query.append("  	      , TEMP56 \n");
		query.append("  	      , TEMP57 \n");
		query.append("  	      , TEMP58 \n");
		query.append("  	      , TEMP59 \n");
		query.append("  	      , TEMP60 \n");
		query.append("  	      , TEMP61 \n");
		query.append("  	      , TEMP62 \n");
		query.append("  	      , TEMP63 \n");
		query.append("  	      , TEMP64 \n");
		
		
		query.append("  	      ) \n");
		//옮겨지는 대상 데이터 받음.
		query.append("SELECT \n");
		query.append(" ?\n");
		query.append(", CASE WHEN A.BOM_QTY - '"+v_modifyEA+"' <= 0 THEN 'D' \n");
		query.append("       ELSE CASE WHEN A.ECO_NO IS NULL THEN A.STATE_FLAG  \n");
		query.append("            ELSE 'C' \n");
		query.append("       END \n");
		query.append("  END AS STATE \n");
		query.append(", CASE WHEN A.BOM_QTY - '"+v_modifyEA+"' <= 0 THEN 'D' \n");
		query.append("       ELSE 'C' \n");
		query.append("  END  AS STATE_BUSINESS  \n");
		query.append(", A.STATE_FLAG \n");
		query.append(", A.MASTER_SHIP \n");
		query.append(", A.PROJECT_NO \n");
		query.append(", A.DWG_NO \n");
		query.append(", STP.BLOCK_NO \n");
		query.append(", STP.STR_FLAG \n");
		query.append(", STP.STAGE_NO \n");
		query.append(", A.MOTHER_CODE \n");
		query.append(", '' AS ERROR_MOTHER_CODE \n");
		query.append(", A.ITEM_CODE \n");
		query.append(", A.BOM1 \n");
		query.append(", A.BOM2 \n");
		query.append(", A.BOM3 \n");
		query.append(", A.BOM4 \n");
		query.append(", A.BOM5 \n");
		query.append(", A.BOM6 \n");
		query.append(", A.BOM7 AS MODIFY_SUPPLY \n");
		query.append(", A.BOM8 \n");
		query.append(", A.BOM9 \n");
		query.append(", A.BOM10 \n");
		query.append(", A.BOM11 \n");
		query.append(", A.BOM12 \n");
		query.append(", A.BOM13 \n");
		query.append(", A.BOM14 \n");
		query.append(", A.BOM15 \n");
		query.append(", C.ATTR1 \n");
		query.append(", C.ATTR2 \n");
		query.append(", C.ATTR3 \n");
		query.append(", C.ATTR4 \n");
		query.append(", C.ATTR5 \n");
		query.append(", C.ATTR6 \n");
		query.append(", C.ATTR7 \n");
		query.append(", C.ATTR8 \n");
		query.append(", C.ATTR9 \n");
		query.append(", C.ATTR10 \n");
		query.append(", C.ATTR11 \n");
		query.append(", C.ATTR12 \n");
		query.append(", C.ATTR13 \n");
		query.append(", C.ATTR14 \n");
		query.append(", C.ATTR15 \n");
		query.append(", A.SSC_SUB_ID \n");
		query.append(", A.BOM_QTY AS EA \n");
		query.append(", A.KEY_NO \n");
		query.append(", TO_CHAR(A.BOM_QTY - '"+v_modifyEA+"') AS MODIFY_EA \n");
		query.append(", ? AS MODIFY_KEY \n");
		query.append(", C.ITEM_DESC \n");
		query.append(", C.ITEM_DESC_DETAIL \n");
		query.append(", C.ITEM_WEIGHT \n");
		query.append(", ? AS REV_NO \n");
		query.append(", A.DEPT_NAME \n");
		query.append(", A.DEPT_CODE \n");
		query.append(", A.USER_NAME \n");
		query.append(", A.USER_ID \n");
		query.append(", A.CREATE_DATE \n");
		query.append(", A.ECO_NO \n");
		query.append(", A.REMARK \n");
		query.append(", A.ITEM_TYPE_CD \n");
		query.append(", A.BOM_ITEM_DETAIL \n");
		query.append(", ? AS ERRORCODE \n");
		query.append(", ? AS PROCESS \n");
		query.append(", STP.SSC_BOM_DATE \n");
		query.append(", A.UPP_CONFIRM_DATE \n");
		query.append("FROM STX_DIS_SSC_HEAD A \n");
		query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
		query.append("INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
		query.append("WHERE A.PROJECT_NO = ? \n");
		query.append("  AND A.ITEM_CODE = ? \n");
		query.append("  AND STP.BLOCK_NO = ? \n");
		query.append("  AND A.DWG_NO = ? \n");	
		query.append("  AND A.BOM_QTY = ? \n");
		query.append("  AND A.STATE_FLAG <> 'D' \n");
		
		if(vSeriesSize == 0){
			query.append("  AND A.MOTHER_CODE = ? \n");
		}
		if(!vLstr_flag.equals("")){
			query.append("  AND STP.STR_FLAG = '"+vLstr_flag+"' \n");
		}
		if(!vLstage_no.equals("")){
			query.append("  AND STP.STAGE_NO = '"+vLstage_no+"' \n");
		}else{
			query.append("  AND STP.STAGE_NO IS NULL \n");
		} 
		
		if(vKey != null && !vKey.equals("")){
			query.append("  AND A.BOM2 = '"+vKey+"' \n");
		}
		if(vKeyNo != null && !vKeyNo.equals("")){
			query.append("  AND A.KEY_NO = '"+vKeyNo+"' \n");
		}
		query.append("UNION \n");
		
		if(isItemCnt > 0){
			//옮기는 곳에 있는 경우.
			query.append("SELECT \n");
			query.append(" ?\n");
			query.append(", CASE WHEN A.ECO_NO IS NULL THEN A.STATE_FLAG \n");
			query.append("    ELSE 'C' \n");
			query.append("  END AS STATE \n");
			query.append(", 'C' AS STATE_BUSINESS \n");
			query.append(", A.STATE_FLAG \n");
			query.append(", A.MASTER_SHIP AS DELEGATEPROJECTNO \n");
			query.append(", A.PROJECT_NO \n");
			query.append(", A.DWG_NO \n");
			query.append(", STP.BLOCK_NO \n");
			query.append(", STP.STR_FLAG \n");
			query.append(", STP.STAGE_NO \n");
			query.append(", A.MOTHER_CODE \n");
			query.append(", '' AS ERROR_MOTHER_CODE \n");
			query.append(", A.ITEM_CODE \n");
			query.append(", A.BOM1 \n");
			query.append(", A.BOM2 \n");
			query.append(", A.BOM3 \n");
			query.append(", A.BOM4 \n");
			query.append(", A.BOM5 \n");
			query.append(", A.BOM6 \n");
			query.append(", NVL(?, A.BOM7) AS MODIFY_SUPPLY \n");
			query.append(", A.BOM8 \n");
			query.append(", A.BOM9 \n");
			query.append(", A.BOM10 \n");
			query.append(", A.BOM11 \n");
			query.append(", A.BOM12 \n");
			query.append(", A.BOM13 \n");
			query.append(", A.BOM14 \n");
			query.append(", A.BOM15 \n");
			query.append(", C.ATTR1 \n");
			query.append(", C.ATTR2 \n");
			query.append(", C.ATTR3 \n");
			query.append(", C.ATTR4 \n");
			query.append(", C.ATTR5 \n");
			query.append(", C.ATTR6 \n");
			query.append(", C.ATTR7 \n");
			query.append(", C.ATTR8 \n");
			query.append(", C.ATTR9 \n");
			query.append(", C.ATTR10 \n");
			query.append(", C.ATTR11 \n");
			query.append(", C.ATTR12 \n");
			query.append(", C.ATTR13 \n");
			query.append(", C.ATTR14 \n");
			query.append(", C.ATTR15 \n");
			query.append(", A.SSC_SUB_ID \n");
			query.append(", A.BOM_QTY AS EA \n");
			query.append(", A.KEY_NO \n");
			query.append(", TO_CHAR(A.BOM_QTY + "+v_modifyEA+") AS MODIFY_EA \n");
			query.append(", A.BOM2 || ',"+vModifyKey+"' AS MODIFY_KEY \n");
			query.append(", C.ITEM_DESC \n");
			query.append(", C.ITEM_DESC_DETAIL \n");
			query.append(", C.ITEM_WEIGHT \n");
			query.append(", ? AS REV_NO \n");
			query.append(", A.DEPT_NAME \n");
			query.append(", A.DEPT_CODE \n");
			query.append(", A.USER_NAME \n");
			query.append(", A.USER_ID \n");
			query.append(", A.CREATE_DATE \n");
			query.append(", A.ECO_NO \n");
			query.append(", A.REMARK \n");
			query.append(", A.ITEM_TYPE_CD \n");
			query.append(", ? AS BOM_ITEM_DETAIL \n");
			query.append(", CASE WHEN A.STATE_FLAG = 'D' THEN -1 ELSE ? END AS ERRORCODE \n");
			query.append(", CASE WHEN A.STATE_FLAG = 'D' THEN 'NO' ELSE ? END  AS PROCESS \n");
			query.append(", STP.SSC_BOM_DATE \n");
			query.append(", A.UPP_CONFIRM_DATE \n");
			query.append("FROM STX_DIS_SSC_HEAD A \n");
			query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
			query.append("INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
			query.append("WHERE A.PROJECT_NO = ? \n");
			query.append("  AND STP.BLOCK_NO = ? \n");
			query.append("  AND A.ITEM_CODE = ? \n");
			query.append("  AND A.DWG_NO = ? \n");
			//query.append("  AND A.BOM_QTY = '"+ar_ea.get(j).toString()+"' \n");
			//query.append("  AND A.MOTHER_CODE = '"+ar_mother_code.get(j).toString()+"' \n");
			
			if(!vStage.equals("")){
				query.append("  AND STP.STAGE_NO = '"+vStage+"' \n");
			}else{
				query.append("  AND STP.STAGE_NO IS NULL \n");
			}
			if(!vStr.equals("")){
				query.append("  AND STP.STR_FLAG = '"+vStr+"' \n");
			}
			
			if(vKeyNo != null && !vKeyNo.equals("")){
				query.append("  AND A.KEY_NO = '"+vKeyNo+"' \n");
			}
			
		}else{
			
			//옮기는 곳에 없는 경우...추가 로직
			query.append("SELECT \n");
			query.append(" ? \n");
			query.append(", 'A' AS STATE \n");
			query.append(", 'A' AS STATE_BUSINESS \n");
			query.append(", A.STATE_FLAG \n");
			query.append(", A.MASTER_SHIP \n");
			query.append(", A.PROJECT_NO \n");
			query.append(", A.DWG_NO \n");
			query.append(", ? AS BLOCK_NO \n");
			query.append(", ? AS STR_FLAG \n");
			query.append(", ? AS STAGE_NO \n");
			query.append(", STX_DIS_GET_MOTHERCODE_F(A.PROJECT_NO, A.DWG_NO, ?, ?, ?, ?) AS MOTHER_CODE \n");
			query.append(", CASE \n");
			query.append("      WHEN STX_DIS_GET_MOTHERCODE_F(A.PROJECT_NO, A.DWG_NO, ?, ?, ?, ?) IS NULL \n");
			query.append("        OR STX_DIS_GET_MOTHERCODE_F(A.PROJECT_NO, A.DWG_NO, ?, ?, ?, ?) = 'duplicate' \n");
			query.append("      THEN 'e' \n");
			query.append("      ELSE '' \n");
			query.append("   END AS ERROR_MOTHER_CODE \n");
			query.append(", ? AS ITEM_CODE \n");
			query.append(", A.BOM1 \n");
			query.append(", A.BOM2 \n");
			query.append(", A.BOM3 \n");
			query.append(", A.BOM4 \n");
			query.append(", A.BOM5 \n");
			query.append(", A.BOM6 \n");
			query.append(", NVL(?, A.BOM7) AS MODIFY_SUPPLY \n");
			query.append(", A.BOM8 \n");
			query.append(", A.BOM9 \n");
			query.append(", A.BOM10 \n");
			query.append(", A.BOM11 \n");
			query.append(", A.BOM12 \n");
			query.append(", A.BOM13 \n");
			query.append(", A.BOM14 \n");
			query.append(", A.BOM15 \n");
			query.append(", C.ATTR1 \n");
			query.append(", C.ATTR2 \n");
			query.append(", C.ATTR3 \n");
			query.append(", C.ATTR4 \n");
			//서포트의 경우 ATTR5가 Sup NO임. Validation 체크 해야함.--
			int valiCnt = 0; 
//			if(p_item_type_cd.equals("SU")){
//				//valiCnt = isSupportNo
//			}
			query.append(", C.ATTR5 \n");
			//---------------------------
			query.append(", C.ATTR6 \n");
			query.append(", C.ATTR7 \n");
			query.append(", C.ATTR8 \n");
			query.append(", C.ATTR9 \n");
			query.append(", C.ATTR10 \n");
			query.append(", C.ATTR11 \n");
			query.append(", C.ATTR12 \n");
			query.append(", C.ATTR13 \n");
			query.append(", C.ATTR14 \n");
			query.append(", C.ATTR15 \n");
			query.append(", A.SSC_SUB_ID \n");
			query.append(", A.BOM_QTY AS EA \n");
			query.append(", A.KEY_NO \n");
			query.append(", '"+v_modifyEA+"' AS MODIFY_EA \n");
			query.append(", '"+vModifyKey+"' AS MODIFY_KEY \n");
			query.append(", C.ITEM_DESC \n");
			query.append(", C.ITEM_DESC_DETAIL \n");
			query.append(", C.ITEM_WEIGHT \n");
			query.append(", ? AS REV_NO \n");
			query.append(", A.DEPT_NAME \n");
			query.append(", A.DEPT_CODE \n");
			query.append(", A.USER_NAME \n");
			query.append(", A.USER_ID \n");
			query.append(", A.CREATE_DATE \n");
			query.append(", A.ECO_NO \n");
			query.append(", A.REMARK \n");
			query.append(", A.ITEM_TYPE_CD \n");
			query.append(", ? AS BOM_ITEM_DETAIL \n");
			query.append(", ? AS ERRORCODE \n");
			query.append(", CASE \n");
			query.append("      WHEN STX_DIS_GET_MOTHERCODE_F(A.PROJECT_NO, A.DWG_NO, ?, ?, ?, ?) IS NULL \n");
			query.append("        OR STX_DIS_GET_MOTHERCODE_F(A.PROJECT_NO, A.DWG_NO, ?, ?, ?, ?) = 'duplicate' \n");
			query.append("      THEN 'NO' \n");
			query.append("      ELSE 'OK' \n");
			query.append("   END AS PROCESS \n");
			query.append(", STP.SSC_BOM_DATE \n");
			query.append(", A.UPP_CONFIRM_DATE \n");
			query.append("FROM STX_DIS_SSC_HEAD A \n");
			query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
			query.append("INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" B ON A.PROJECT_NO = B.PROJECT_NO \n");
			query.append("LEFT JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
			query.append("WHERE A.PROJECT_NO = ? \n");
			query.append("  AND A.ITEM_CODE = ? \n");
			query.append("  AND A.DWG_NO = ? \n");
			query.append("  AND A.BOM_QTY = ? \n");
			query.append("  AND STP.BLOCK_NO = ? \n");

			if(!vLstr_flag.equals("")){
				query.append("  AND STP.STR_FLAG = '"+vLstr_flag+"' \n");
			}
			if(!vLstage_no.equals("")){
				query.append("  AND STP.STAGE_NO = '"+vLstage_no+"' \n");
			}else{
				query.append("  AND STP.STAGE_NO IS NULL \n");
			} 
			
			if(vKeyNo != null && !vKeyNo.equals("")){
				query.append("  AND A.KEY_NO = '"+vKeyNo+"' \n");
			}			
			if(vKey != null && !vKey.equals("")){
				query.append("  AND A.BOM2 = '"+vKey+"' \n");
			}			
		}
		return query.toString();
	}
}