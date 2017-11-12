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

public class TbcAfterPopupDao implements Idao{
	

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	

    	TBCCommonValidation commonValidation = new TBCCommonValidation();
        try 
        { 
            int tot_ea = 0;
            float tot_item_weight = 0;
            
        	list = new ArrayList();
            query  = getQuery(qryExp,rBox);           
            if (!"".equals(query)) {
            	pstmt = conn.prepareStatement(query.toString());
            	
            	ls = new ListSet(conn);
            	ls.run(pstmt);
            	while ( ls.next() ){ 
            		dbox = ls.getDataBox();
            		
            		list.add(dbox);
            	}
            	DecimalFormat format = new DecimalFormat("#.##");
            	
            	rBox.put("tot_ea", Integer.toString(tot_ea));
            	rBox.put("tot_item_weight", format.format(tot_item_weight));
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
		
		String p_project = box.getString("p_project");
		String p_mothercode = box.getString("p_mother_code");
		String p_itemcode = box.getString("p_item_code");
		String p_item_type_cd = box.getString("p_item_type_cd");
		
		try
		{
			if(qryExp.equals("designList")){
				query.append("SELECT \n");
				query.append("  '"+p_item_type_cd+" as TESTDEG' AS DELEGATEPROJECTNO \n");
				query.append(", '"+p_item_type_cd+" as TEST' AS PROJECT_NO \n");
				query.append(", 'M5B71601' DWG_NO \n");
				query.append(", 'TEST_BLK' AS BLOCK_NO \n");
				query.append(", 'TEST_SCR' STR_FLAG \n");
				query.append(", 'TEST_STG' STAGE_NO \n");
				query.append(", 'V2GA-5009674' MOTHER_CODE \n");
				query.append(", 'ZCB02-1215155' ITEM_CODE \n");
				query.append(", 'TEST_SUB_NO' ATTR5 \n");
				query.append(", '1' AS EA \n");
				query.append(", 'TE' ITEM_WEIGHT \n");
				query.append("FROM DUAL \n");
				
				
			}else if(qryExp.equals("produceList")){
				
				query.append("SELECT SIB.WIP_ENTITY_NAME         --JOB NAME\n");
				//query.append("	   , SIB.DEPARTMENT_NAME         --작업부서\n");
				query.append("	   , SIB.JOB_STATUS_DSP          --JOB 상태\n");
				query.append("	   , SIB.REQUIRED_QUANTITY       --요구수량\n");
				query.append("	   , SIB.QUANTITY_ISSUED         --출고수량\n");
				query.append("	   , SIB.JOB_ITEM_CODE\n");
				query.append("	   , SIB.WRO_ITEM_CODE  \n");
				query.append("	   , SIB.PROJECT_NO\n");
				query.append("  FROM STX_TBC_WIP_V@"+ERP_DB+" SIB \n");
				query.append(" WHERE SIB.ORGANIZATION_ID  = 82\n");
				query.append(" 	 AND SIB.JOB_ITEM_CODE   ='"+p_mothercode+"' \n");
				query.append("	 AND SIB.WRO_ITEM_CODE   ='"+p_itemcode+"'\n");
				query.append("	 AND SIB.PROJECT_NO      ='"+p_project+"'\n");
				
			}else if(qryExp.equals("orderList")){
				
				query.append("SELECT SIB.PO_LINE_ID AS PR_NO		--PR_NO \n");
				query.append("     , 'MORE DATE' AS PR_DATE			--PR_DATE....? \n");
				query.append("     , SIB.PO_NO						--PO_NO \n");
				query.append("     , SIB.BUYER_NAME AS CHARGER		--구매자 \n");
				query.append("     , SIB.APPROVED_DATE AS APPROVAL_DATE	--승인 날짜 \n");
				query.append("     , SIB.VENDOR_SITE_DISP AS  MAKER	--공급사 \n");
				query.append("     , SIB.NEED_BY_DATE AS DEADLINES	--납기일 \n");
				query.append("     , 'MORE DATE' AS RELEASEDATE		--출고일......? \n");
				query.append("     , SIB.QUANTITY_ORDERED			--수량 \n");
				query.append("     , SIB.PROJECT_NO \n");
				query.append("     , SIB.ASSY_ITEM_NO \n");
				query.append("     , SIB.ITEM_CODE \n");
				query.append("  FROM STX_TBC_PO_V@STXUTF SIB \n");
				query.append(" WHERE SIB.ORGANIZATION_ID = 82 \n");
				query.append(" 	 AND SIB.PROJECT_NO     ='"+p_project+"' \n");
				query.append(" 	 AND SIB.ASSY_ITEM_NO   ='"+p_mothercode+"' \n");
				query.append("	 AND SIB.ITEM_CODE      ='"+p_itemcode+"' \n");
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