package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;

public class TbcAfterInfoDao implements Idao{
	

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
		return false;
	}

	public boolean insertDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	private String getQuery(String qryExp, RequestBox box)
	{//URLDecoder.decode(box.getString("p_course"),"UTF-8")
		StringBuffer query = new StringBuffer();
		
		String p_ssc_sub_id = box.getString("p_ssc_sub_id");
		String p_project_no = box.getString("p_project_no");
		String p_job_cd     = box.getString("p_job_cd");
		
		
		try
		{
			if(qryExp.equals("selectSscList")){
				query.append("SELECT A.PROJECT_NO \n");
				query.append("     , A.DWG_NO \n");
				query.append("     , B.BLOCK_NO \n");
				query.append("     , B.STAGE_NO \n");
				query.append("     , B.STR_FLAG \n");
				query.append("     , A.MOTHER_CODE \n");
				query.append("     , A.ITEM_CODE \n");
				query.append("     , A.KEY_NO \n");
				query.append("     , A.BOM_QTY \n");
				query.append("     , C.ITEM_WEIGHT \n");
				query.append("  FROM STX_DIS_SSC_HEAD A \n");
				query.append(" INNER JOIN STX_DIS_PENDING B ON A.MOTHER_CODE = B.MOTHER_CODE \n");
				query.append(" INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
				query.append(" WHERE SSC_SUB_ID = '"+p_ssc_sub_id+"' \n");
				
			}else if(qryExp.equals("selectProduceList")){
//				query.append("SELECT  /*+ LEADING(STSH) USE_NL(STSH STP STJC ASTI JSTI) */ \n");
//				query.append("       STJC.ACTIVITY_CD \n");
//				query.append("     , STP.ACT_CODE \n");
//				query.append("     , ASTI.ITEM_DESC AS ACT_DESC \n");
//				query.append("     , STP.JOB_CD \n");
//				query.append("     , JSTI.ITEM_DESC AS JOB_DESC \n");
//				query.append("     , STSH.USER_NAME \n");
//				query.append("  FROM STX_DIS_SSC_HEAD    STSH \n");
//				query.append("      ,STX_DIS_PENDING     STP \n");
//				query.append("      ,stx_DIS_job_confirm STJC \n");
//				query.append("      ,STX_DIS_ITEM        ASTI \n");
//				query.append("      ,STX_DIS_ITEM        JSTI \n");
//				query.append(" WHERE STP.MOTHER_CODE = STSH.MOTHER_CODE \n");
//				query.append("   AND STP.job_cd      = STJC.job_cd2 \n");
//				query.append("   AND ASTI.ITEM_CODE  = STJC.ACTIVITY_CD \n");
//				query.append("   AND JSTI.ITEM_CODE = STP.JOB_CD \n");
//				query.append("   AND STSH.SSC_SUB_ID = '"+p_ssc_sub_id+"' \n");
//				query.append("   AND STSH.PROJECT_NO = '"+p_project_no+"' \n");
//				query.append("UNION ALL \n");
//				query.append("SELECT  /*+ LEADING(STSH) USE_NL(STSH STP STJC ASTI JSTI) */ \n");
//				query.append("       STJC.ACTIVITY_CD \n");
//				query.append("     , STP.ACT_CODE \n");
//				query.append("     , ASTI.ITEM_DESC AS ACT_DESC \n");
//				query.append("     , STP.JOB_CD \n");
//				query.append("     , JSTI.ITEM_DESC AS JOB_DESC \n");
//				query.append("     , STSH.USER_NAME \n");
//				query.append("  FROM STX_DIS_SSC_HEAD    STSH \n");
//				query.append("      ,STX_DIS_PENDING     STP \n");
//				query.append("      ,stx_DIS_job_confirm STJC \n");
//				query.append("      ,STX_DIS_ITEM        ASTI \n");
//				query.append("      ,STX_DIS_ITEM        JSTI \n");
//				query.append(" WHERE STP.MOTHER_CODE = STSH.MOTHER_CODE \n");
//				query.append("   AND STP.job_cd      = STJC.job_cd1 \n");
//				query.append("   AND STJC.JOB_CD2 IS NULL \n");
//				query.append("   AND ASTI.ITEM_CODE  = STJC.ACTIVITY_CD \n");
//				query.append("   AND JSTI.ITEM_CODE  = STP.JOB_CD \n");
//				query.append("   AND STSH.SSC_SUB_ID = '"+p_ssc_sub_id+"' \n");
//				query.append("   AND STSH.PROJECT_NO = '"+p_project_no+"' \n");
				
				query.append("SELECT TO_CHAR(SISV.rcv_transaction_date, 'YY-MM-DD')             AS TRAN_DATE \n");
				query.append("      ,SISV.rcv_created_by_disp                 					AS TRAN_USER \n");
				query.append("      ,SISV.wip_department_disp                 					AS WORK_DEPT \n");
				query.append("      ,TO_CHAR(SISV.wip_sch_start_date, 'YY-MM-DD') 				AS WORK_START_DATE \n");
				query.append("      ,TO_CHAR(SISV.wip_sch_completion_date, 'YY-MM-DD') 			AS WORK_END_DATE \n");
				query.append("      ,SISV.wip_status_disp                     					AS WORK_STATUS \n");
				query.append("      ,SISV.wip_required_quantity               					AS REQUIRED_EA \n");
				query.append("      ,TO_CHAR(SISV.req_required_date, 'YY-MM-DD') 				AS REQUIRED_DATE \n");
				query.append("  FROM STX_DIS_SSC_HEAD STSH \n");
				query.append(" INNER JOIN STX_INV_SUPPLYMANAGEMENT_V@"+ERP_DB+" SISV \n");
				query.append("         ON STSH.PROJECT_NO = SISV.PROJECT_NO \n");
				query.append("        AND CASE WHEN (SELECT ITEM_CATALOG FROM STX_DIS_ITEM WHERE ITEM_CODE = STSH.JOB) = 'V21' \n");
				query.append("                 THEN (SELECT ACTIVITY_CD FROM STX_DIS_JOB_CONFIRM WHERE CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END = STSH.JOB) \n");
				query.append("                 ELSE STSH.JOB \n");
				query.append("            END = SISV.PRIMARY_ITEM_CODE \n");
				query.append("        AND STSH.ITEM_CODE = SISV.ITEM_CODE \n");
				query.append(" WHERE STSH.PROJECT_NO = '"+p_project_no+"' \n");
				//query.append("   AND STSH.JOB = '"+p_job_cd+"' \n");
				query.append("   AND STSH.SSC_SUB_ID = '"+p_ssc_sub_id+"' \n");
				
			}else if(qryExp.equals("selectOrderList")){
				
				query.append("SELECT SISV.WIP_CLASS_DISP                              AS CLASS \n");
				query.append("      ,SISV.PR_NO                                       AS PR_NO \n");
				query.append("      ,SISV.PR_QUANTITY                                 AS PR_EA \n");
				query.append("      ,TO_CHAR(SISV.PR_APPROVED_DATE, 'YY-MM-DD')       AS PR_DATE \n");
				query.append("      ,SISV.PO_NO                                       AS PO_NO \n");
				query.append("      ,SISV.PO_QUANTITY_ORDERED-SISV.PO_QUANTITY_CANCELLED AS PO_EA \n");
				query.append("      ,TO_CHAR(NVL(SISV.PO_NEED_BY_DATE,SISV.PR_NEED_BY_DATE), 'YY-MM-DD')      AS NEED_BY_DATE \n");
				query.append("      ,SISV.PO_AGENT_DISP                               AS AGENT_USER \n");
				query.append("      ,SISV.PO_VENDOR_SITE_CODE_ALT                     AS VENDER \n");
				query.append("      ,SISV.PO_QUANTITY_DELIVERED                       AS DELIVERED_DATE \n");
				query.append("  FROM STX_DIS_SSC_HEAD STSH \n");
				query.append(" INNER JOIN STX_INV_SUPPLYMANAGEMENT_V@"+ERP_DB+" SISV \n");
				query.append("         ON STSH.PROJECT_NO = SISV.PROJECT_NO \n");
				query.append("        AND CASE WHEN (SELECT ITEM_CATALOG FROM STX_DIS_ITEM WHERE ITEM_CODE = STSH.JOB) = 'V21' \n");
				query.append("                 THEN (SELECT ACTIVITY_CD FROM STX_DIS_JOB_CONFIRM WHERE CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END = STSH.JOB) \n");
				query.append("                 ELSE STSH.JOB \n");
				query.append("            END = SISV.PRIMARY_ITEM_CODE \n");
				query.append("        AND STSH.ITEM_CODE = SISV.ITEM_CODE \n");
				query.append(" WHERE STSH.PROJECT_NO = '"+p_project_no+"' \n");
				//query.append("   AND STSH.JOB = '"+p_job_cd+"' \n");
				query.append("   AND STSH.SSC_SUB_ID = '"+p_ssc_sub_id+"' \n");

			}
			System.out.println(query);
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}		
		return query.toString();
	}
}