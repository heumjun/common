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

public class TbcCommonDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;

        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
        try 
        { 
            list = new ArrayList();
            query  = getQuery(qryExp,rBox);
            conn = DBConnect.getDBConnection("DIS");
    		
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
		
		
		try
		{
			
			if(qryExp.equals("getMasterList")){
				
				String p_project = box.getString("p_project");
				String p_dwgno = box.getString("p_dwgno");
				String p_blockno = box.getString("p_blockno");
				String p_stageno = box.getString("p_stageno");
				String p_mothercode = box.getString("p_mothercode");
				String p_itemcode = box.getString("p_itemcode");
				
				query.append("SELECT * FROM STX_DIS_SSC_HEAD ");
				query.append("WHERE 1=1 ");
				
				if(!p_project.equals("")){
					p_project = p_project.replaceAll("[*]","%");
					query.append("AND PROJECT_NO LIKE '"+p_project+"' ");
				}
				if(!p_dwgno.equals("")){
					p_dwgno = p_dwgno.replaceAll("[*]","%");
					query.append("AND DWG_NO LIKE '"+p_dwgno+"' ");
				}
				if(!p_blockno.equals("")){
					p_blockno = p_blockno.replaceAll("[*]","%");
					query.append("AND BLOCK_NO LIKE '"+p_blockno+"' ");
				}
				if(!p_stageno.equals("")){
					p_stageno = p_stageno.replaceAll("[*]","%");
					query.append("AND STAGE_NO LIKE '"+p_stageno+"' ");
				}
				if(!p_mothercode.equals("")){
					p_mothercode = p_mothercode.replaceAll("[*]","%");
					query.append("AND MOTHER_CODE LIKE '"+p_mothercode+"' ");
				}
				if(!p_itemcode.equals("")){
					p_itemcode = p_itemcode.replaceAll("[*]","%");
					query.append("AND ITEM_CODE LIKE '"+p_itemcode+"' ");
				}
			}else if(qryExp.equals("SeriesCheckbox")){
				
				String p_project = box.getString("p_project");
				
				query.append("SELECT A.PROJECT_NO \n");
				query.append("FROM STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" A  \n");
				query.append("WHERE A.DELEGATE_PROJECT_NO = (SELECT DELEGATE_PROJECT_NO FROM STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" WHERE PROJECT_NO = '"+p_project+"') \n");
				query.append("AND LENGTH(A.PROJECT_NO) = 5 \n");
				
				query.append("ORDER BY PROJECT_NO ASC  \n");
				
			}else if(qryExp.equals("getMaster")){
				
				String p_project = box.getString("p_project");
				
				query.append("SELECT DELEGATE_PROJECT_NO AS DELEGATEPROJECTNO \n");
				query.append("FROM STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+"   \n");
				query.append("WHERE PROJECT_NO = '"+p_project+"' \n");
				
			}else if(qryExp.equals("getDwgRev")){
				
				String p_master = box.getString("p_master");
				String p_dwgno = box.getString("p_dwgno");
				String p_item_type_cd = box.getString("p_item_type_cd");
				
				query.append("  SELECT REV_NO \n");
				query.append("  FROM( \n");
				query.append("  	SELECT \n");
				query.append("  	    DISTINCT A.REV_NO \n");
				query.append("  	FROM STX_DIS_SSC_HEAD_HISTORY A \n");
				query.append("  	INNER JOIN STX_DIS_ECO_V B ON A.ECO_NO = B.ECO_NO AND B.RELEASE_DATE IS NOT NULL \n");
				query.append("  	WHERE A.DWG_NO = '"+p_dwgno+"' \n");
				query.append("  	  AND A.MASTER_SHIP = '"+p_master+"' \n");
				query.append("  	  AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				query.append("  	UNION \n");
				query.append("  	SELECT \n");
				query.append("  	    CASE \n");
				query.append("  	         WHEN LENGTH(MAX(A.REV_NO)+1) = 1 THEN '0' || TO_CHAR(MAX(A.REV_NO)+1) \n");
				query.append("  	         ELSE TO_CHAR(MAX(A.REV_NO) + 1) \n");
				query.append("  	    END \n");
				query.append("  	FROM STX_DIS_SSC_HEAD_HISTORY A \n");
				query.append("  	INNER JOIN STX_DIS_ECO_V B ON A.ECO_NO = B.ECO_NO AND B.RELEASE_DATE IS NOT NULL \n");
				query.append("  	WHERE A.DWG_NO = '"+p_dwgno+"' \n");
				query.append("  	  AND A.MASTER_SHIP = '"+p_master+"' \n");
				query.append("  	  AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				query.append("  	GROUP BY A.REV_NO \n");
				query.append("  ) \n");
				query.append("  ORDER BY REV_NO DESC \n");

				
			}else if(qryExp.equals("getTextDwgRev")){
				
				String p_master = box.getString("p_master");
				String p_dwgno = box.getString("p_dwgno");
				String p_item_type_cd = box.getString("p_item_type_cd");
				
				
				query.append("  	SELECT \n");
				query.append("  	    NVL( CASE \n");
				query.append("  	         WHEN LENGTH(MAX(A.REV_NO)+1) = 1 THEN '0' || TO_CHAR(MAX(A.REV_NO)+1) \n");
				query.append("  	         ELSE TO_CHAR(MAX(A.REV_NO) + 1) \n");
				query.append("  	    END, '00' ) \n");
				query.append("  	    AS REV_NO\n");
				query.append("  	FROM STX_DIS_SSC_HEAD_HISTORY A \n");
				query.append("  	INNER JOIN STX_DIS_ECO_V B ON A.ECO_NO = B.ECO_NO AND B.RELEASE_DATE IS NOT NULL \n");
				query.append("  	WHERE A.DWG_NO = '"+p_dwgno+"' \n");
				query.append("  	  AND A.MASTER_SHIP = '"+p_master+"' \n");
				query.append("  	  AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				
			}else if(qryExp.equals("getMainRev")){

				String p_project = box.getString("p_project");
				String p_dwgno = box.getString("p_dwgno");
				String p_ship = box.getString("p_ship");
				String p_item_type_cd = box.getString("p_item_type_cd");
				
				query.append("SELECT DISTINCT\n");				
				query.append("  A.REV_NO \n");				
				query.append("FROM STX_DIS_SSC_HEAD_HISTORY A \n");
				query.append("INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" B ON A.PROJECT_NO = B.PROJECT_NO \n");
				query.append("LEFT JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
				query.append("LEFT JOIN ( \n");
				query.append("    SELECT SSC_SUB_ID \n");
				query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '170', ELEMENT_VALUE)) AS COLUMN170 \n");
				query.append("    FROM( \n");
				query.append("        SELECT SSC_SUB_ID \n");
				query.append("        , ELEMENT_NAME \n");
				query.append("        , ELEMENT_VALUE \n");
				query.append("        , A.ELEMENT_SEQUENCE \n");
				query.append("        FROM STX_DIS_SSC_SUB_DESCRIPTION A \n");
				query.append("        INNER JOIN STX_DIS_SSC_SUB B ON A.ELEMENT_SEQUENCE = B.ELEMENT_SEQUENCE \n");
				query.append("    ) \n");
				query.append("    GROUP BY SSC_SUB_ID \n");
				query.append(") D ON A.SSC_SUB_ID = D.SSC_SUB_ID \n");
				query.append("WHERE 1=1 \n");
				query.append("  AND A.REV_NO IS NOT NULL \n");
				query.append("  AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				
				
				//필수 S
				if(p_ship.equals("Master")){
					p_project = p_project.replaceAll("[*]","%");
					query.append("AND B.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");			
				}else{
					p_project = p_project.replaceAll("[*]","%");
					query.append("AND A.PROJECT_NO LIKE '"+p_project+"' ");
				}	
				if(!p_dwgno.equals("")){
					p_dwgno = p_dwgno.replaceAll("[*]","%");
					query.append("AND A.DWG_NO LIKE '"+p_dwgno+"' ");
				}
				//필수 D
				
				query.append("UNION  \n");
				query.append("SELECT 'Final' AS REV_NO FROM DUAL \n");
				if(!box.getString("p_selrev").equals("")){
					query.append("UNION  \n");
					query.append("SELECT '"+box.getString("p_selrev")+"' AS REV_NO FROM DUAL \n");
				}
				query.append("ORDER BY REV_NO DESC\n");	
				
			}else if(qryExp.equals("getDwgNo")){
				
				//String ss_dwgdeptcode = box.getSession("DwgDeptCode");
				String p_project = box.getString("p_project");
				String p_dwgno = box.getString("p_dwgno");
				String p_dwgdeptcode = box.getString("p_dwgdeptcode");
				String p_deptcode = box.getString("p_deptcode");
				String vDeptCode = box.getSession("DeptCode");
				
				if(!p_dwgdeptcode.equals("")){
					vDeptCode = box.getString("p_dwgdeptcode");
				}
				
				if(!p_deptcode.equals("")){
					vDeptCode = box.getString("p_deptcode");
				}
				
				query.append("SELECT DISTINCT SUBSTR(A.ACTIVITYCODE, 0, 8) AS OBJECT \n");
				query.append("  FROM DPM_ACTIVITY@"+DP_DB+" A \n");
				query.append(" WHERE 1=1 \n");
				query.append("   AND A.DWGDEPTCODE = '"+vDeptCode+"' \n");
				query.append("   AND A.WORKTYPE = 'DW' \n");
				query.append("   AND A.CASENO = '1' \n");
				
				if(!p_project.equals("")){
					query.append("   AND A.PROJECTNO LIKE '"+p_project+"' \n");
				}
				/*
				if(!p_dwgno.equals("")){
					query.append("   AND ACTIVITYCODE LIKE '"+p_dwgno+"%' \n");
				}
				*/
				query.append(" ORDER BY OBJECT \n");

			}else if(qryExp.equals("getMoveBlockInfo")){
				
				String p_project = box.getString("p_project");
				String p_dwgno = box.getString("p_dwgno");
				String p_ship = box.getString("p_ship");
				
				query.append("SELECT DISTINCT STP.BLOCK_NO AS SB_NAME \n");
				query.append("	   , STP.BLOCK_NO AS SB_VALUE \n");
				query.append("  FROM STX_DIS_PENDING STP\n");
				query.append(" INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" SSBS ON STP.PROJECT_NO = SSBS.PROJECT_NO \n");
				query.append(" WHERE 1=1 \n");
				if(!p_project.equals("")){
					p_project = p_project.replaceAll("[*]","%");
					if(p_ship.equals("master")){
						query.append("AND SSBS.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");	
					}else{
						query.append("AND STP.PROJECT_NO LIKE '"+p_project+"' ");
					}
				}
				query.append("   AND STP.DWG_NO = '"+p_dwgno+"' \n");
				query.append(" ORDER BY STP.BLOCK_NO \n");
				
			}else if(qryExp.equals("getMoveStageInfo")){
				
				String p_project = box.getString("p_project");
				String p_dwgno = box.getString("p_dwgno");
				String p_block = box.getString("p_block");
				String p_ship = box.getString("p_ship");
				
				
				query.append("SELECT DISTINCT STP.STAGE_NO AS SB_NAME \n");
				query.append("	   , STP.STAGE_NO AS SB_VALUE \n");
				query.append("  FROM STX_DIS_PENDING STP\n");
				query.append(" INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" SSBS ON STP.PROJECT_NO = SSBS.PROJECT_NO \n");
				query.append(" WHERE 1=1 \n");
				if(!p_project.equals("")){
					p_project = p_project.replaceAll("[*]","%");
					if(p_ship.equals("master")){
						query.append("AND SSBS.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");	
					}else{
						query.append("AND STP.PROJECT_NO LIKE '"+p_project+"' ");
					}
				}
				query.append("   AND STP.BLOCK_NO = '"+p_block+"' \n");
				query.append("   AND STP.DWG_NO = '"+p_dwgno+"' \n");
				query.append(" ORDER BY STP.STAGE_NO \n");
				
			}else if(qryExp.equals("getMoveStrInfo")){
				
				String p_dwgno = box.getString("p_dwgno");
				String p_block = box.getString("p_block");
				String p_project = box.getString("p_project");
				String p_ship = box.getString("p_ship");
				

				query.append("SELECT DISTINCT STP.STR_FLAG AS SB_NAME \n");
				query.append("	   , STP.STR_FLAG AS SB_VALUE \n");
				query.append("  FROM STX_DIS_PENDING STP\n");
				query.append(" INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" SSBS ON STP.PROJECT_NO = SSBS.PROJECT_NO \n");
				query.append(" WHERE 1=1 \n");
				if(!p_project.equals("")){
					p_project = p_project.replaceAll("[*]","%");
					if(p_ship.equals("master")){
						query.append("AND SSBS.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");	
					}else{
						query.append("AND STP.PROJECT_NO LIKE '"+p_project+"' ");
					}
				}
				query.append("   AND STP.BLOCK_NO = '"+p_block+"' \n");
				query.append("   AND STP.DWG_NO = '"+p_dwgno+"' \n");
				query.append(" ORDER BY STP.STR_FLAG \n");
				
			}else if(qryExp.equals("getMoveJobInfo")){
				
				String p_dwgno = box.getString("p_dwgno");
				String p_block = box.getString("p_block");
				String p_stage = box.getString("p_stage");
				String p_str = box.getString("p_str");
				String p_project = box.getString("p_project");
				String p_ship = box.getString("p_ship");
				

				query.append("SELECT DISTINCT STP.JOB_CD AS SB_NAME \n");
				query.append("	   , STP.JOB_CD AS SB_VALUE \n");
				query.append("  FROM STX_DIS_PENDING STP \n");
				query.append(" INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" SSBS ON STP.PROJECT_NO = SSBS.PROJECT_NO \n");
				query.append(" INNER JOIN STX_DIS_ECO_V STE ON STP.ECO_NO = STE.ECO_NO \n");
				query.append(" WHERE 1=1 \n");
				if(!p_project.equals("")){
					p_project = p_project.replaceAll("[*]","%");
					if(p_ship.equals("master")){
						query.append("AND SSBS.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");	
					}else{
						query.append("AND STP.PROJECT_NO LIKE '"+p_project+"' ");
					}
				}
				query.append("   AND STP.BLOCK_NO = '"+p_block+"' \n");
				if(!p_stage.equals("")){
					query.append("   AND STP.STAGE_NO = '"+p_stage+"' \n");
				}else{
					query.append("   AND STP.STAGE_NO IS NULL \n");
				}
				
				query.append("   AND STP.STR_FLAG = '"+p_str+"' \n");				
				query.append("   AND STP.DWG_NO = '"+p_dwgno+"' \n");
				query.append("   AND STP.ECO_NO IS NOT NULL \n");
				query.append("   AND STE.RELEASE_DATE IS NOT NULL \n");
				query.append(" ORDER BY STP.JOB_CD \n");
				
			}else if(qryExp.equals("getJobCatalogInfo")){
				
				query.append("SELECT CATALOG_CODE AS SB_VALUE \n");
				query.append(", CATALOG_CODE AS SB_NAME \n");
				query.append("FROM STX_STD_SD_CATALOG@"+ERP_DB+"  \n");
				query.append("WHERE JOB_FLAG = 'Y' \n");
				
			}else if(qryExp.equals("getAutoCompleteJobCatalogInfo")){
				
				query.append("SELECT CATALOG_CODE AS OBJECT \n");
				query.append("FROM STX_STD_SD_CATALOG@"+ERP_DB+"  \n");
				query.append("WHERE JOB_FLAG = 'Y' \n");
				
			}else if(qryExp.equals("getPendingDwgNo")){
				
				String p_project = box.getString("p_project");
				String p_ship = box.getString("p_ship");
				String ss_deptCode = box.getSession("DeptCode");
				
				query.append("SELECT DISTINCT SUBSTR(A.ACTIVITYCODE, 1, 8) AS SB_NAME \n");
				query.append("     , SUBSTR(A.ACTIVITYCODE, 1, 8) AS SB_VALUE \n");
				query.append("FROM DPM_ACTIVITY@"+DP_DB+" A \n");
				query.append("INNER JOIN STX_STD_SD_BOM_SCHEDULE@"+ERP_DB+" B ON A.PROJECTNO = B.PROJECT_NO \n");
				query.append("WHERE A.WORKTYPE = 'DW' \n");
				query.append("AND A.CASENO = '1' \n");
				if(p_ship.equals("project")){
					query.append("AND A.PROJECTNO = '"+p_project+"' \n");
				}else if(p_ship.equals("master")){
					query.append("AND B.DELEGATE_PROJECT_NO = '"+p_project+"' \n");
				}
				if(!ss_deptCode.equals("")){
					query.append("AND A.DWGDEPTCODE = '"+ss_deptCode+"' \n");
				}else{
					//query.append("AND A.DWGDEPTCODE = '000036' \n");
					
				}
				
			}else if(qryExp.equals("getPendingStr")){
				
				query.append("SELECT DISTINCT \n");
				query.append("       STR_FLAG AS SB_NAME \n");
				query.append("     , STR_FLAG AS SB_VALUE \n");
				query.append("FROM STX_DIS_PENDING \n");
				
			}else if(qryExp.equals("getJobStr")){
				
				query.append("SELECT DISTINCT \n");
				query.append("       ITEM_ATTR3 AS SB_NAME \n");
				query.append("     , ITEM_ATTR3 AS SB_VALUE \n");
				query.append("FROM STX_DIS_JOB_CONFIRM \n");
				
			}else if(qryExp.equals("getManagerDept")){
				
				/*
				 * SB_NAME : Select Box Name
				 * SB_VALUE : Select Box Value
				 * SB_SELECTED :  Select Box Selected
				 * */
				
				String ss_deptcode = box.getSession("DeptCode");
				String p_deptcode = box.getString("p_deptcode");
				
				//Form으로 넘어온 값이 우선으로 체크 되어진다.
				if(!p_deptcode.equals("")){
					ss_deptcode = p_deptcode;
				}
				
				query.append("SELECT AC.DWGDEPTCODE AS SB_VALUE \n");
				query.append("     , AC.DWGDEPTNM AS SB_NAME \n");
				query.append("     , CASE WHEN AC.DWGDEPTCODE = '"+ss_deptcode+"' THEN 'selected=\"selected\"' \n");
				query.append("            ELSE '' \n");
				query.append("        END AS SB_SELECTED \n");
				query.append("  FROM DCC_DWGDEPTCODE@"+DP_DB+" AC \n");
				query.append(" WHERE AC.USERYN      = 'Y' \n");
				query.append(" ORDER BY AC.DWGDEPTNM \n");
				
			}else if(qryExp.equals("getManagerUser")){
				
				/*
				 * SB_NAME : Select Box Name
				 * SB_VALUE : Select Box Value
				 * SB_SELECTED :  Select Box Selected
				 * */
				
				String p_userid = box.getString("p_userid");
				String p_deptcode = box.getString("p_deptcode");
				
				query.append("SELECT SCID.USER_NAME AS SB_NAME \n");
				query.append("     , SCID.EMP_NO AS SB_VALUE \n");
				query.append("     , CASE WHEN SCID.EMP_NO = '"+p_userid+"' THEN 'selected=\"selected\"' \n");
				query.append("            ELSE '' \n");
				query.append("        END AS SB_SELECTED \n");
				query.append("  FROM DCC_DEPTCODE@"+DP_DB+" DDC \n");
				query.append(" INNER JOIN DCC_DWGDEPTCODE@"+DP_DB+" DDDC ON DDC.DWGDEPTCODE = DDDC.DWGDEPTCODE \n");
				query.append(" INNER JOIN STX_COM_INSA_USER@"+ERP_DB+" SCID ON DDC.DEPTCODE = SCID.DEPT_CODE \n");
				query.append(" WHERE DDDC.USERYN = 'Y' \n");
				query.append("   AND DDDC.DWGDEPTCODE = '"+p_deptcode+"' \n");
				query.append("   AND SCID.DEL_DATE IS NULL \n");	
				query.append(" ORDER BY SCID.USER_NAME  \n");
				
			}else if(qryExp.equals("getCatalogInfo")){
				/*
				 * SB_NAME : Select Box Name
				 * SB_VALUE : Select Box Value
				 * SB_SELECTED :  Select Box Selected
				 * */
				
				//UNIT VALUE 'Y'
				query.append("SELECT CATALOG_CODE AS SB_NAME \n");
				query.append("     , CATALOG_CODE AS SB_VALUE \n");
	    		query.append("  FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
	    		query.append(" WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
	    		query.append("   AND SCV.VALUE_CODE  = '09' \n");
	    		query.append("   AND SCV.VALUE_NAME  = 'Y' \n");
	    		query.append("   AND SCV.ENABLE_FLAG = 'Y' \n");
				
			}else if(qryExp.equals("getMotherCode")){
				
				String p_dwgno = box.getString("p_dwgno");
				String p_block = box.getString("p_spBlock");
				String p_project = box.getString("p_project");
				String p_stage = box.getString("p_spStage");
				String p_str = box.getString("p_spStr");
				String p_id = box.getString("p_id");
  
				query.append("SELECT MOTHER_CODE \n");
				query.append("     , '"+p_id+"' AS P_ID \n");
				query.append("     , STX_DIS_JOB_STATUS_FUNC(A.MOTHER_CODE) AS JOB_STATE \n");
	    		query.append("  FROM STX_DIS_PENDING A \n");
	    		query.append(" INNER JOIN STX_DIS_ECO_V B ON A.ECO_NO = B.ECO_NO \n");
	    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
	    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
	    		query.append("   AND BLOCK_NO = '"+p_block+"' \n");
	    		query.append("   AND ECO_STATE = 'R' \n");    		
	    		if(!p_stage.equals("")){
	    			query.append("   AND STAGE_NO = '"+p_stage+"' \n");
	    		}else{
	    			query.append("   AND STAGE_NO IS NULL \n");
	    		}
	    		if(!p_str.equals("")){
	    			query.append("   AND STR_FLAG = '"+p_str+"' \n");
	    		}else{
	    			query.append("   AND STR_FLAG IS NULL \n");
	    		}
			}else if(qryExp.equals("getSeriesInItem")){
					
				String p_item_code = box.getString("p_item_code");
				
				query.append("SELECT DISTINCT PROJECT_NO \n");
				query.append("  FROM STX_DIS_SSC_HEAD \n");
				query.append(" WHERE ITEM_CODE = '"+p_item_code+"' \n");
			}
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
}