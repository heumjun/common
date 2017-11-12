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

public class TbcTestDao implements Idao{
	

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	
    	String p_item_type_cd = rBox.getString("p_item_type_cd");
    	TBCCommonValidation commonValidation = new TBCCommonValidation();
        try 
        { 
            int tot_ea = 0;
            float tot_item_weight = 0;
            
        	list = new ArrayList();
            query  = getQuery(qryExp,rBox);           

			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
            while ( ls.next() ){ 
                dbox = ls.getDataBox();
                if(ls.getInt("raw_lv") < 2){
	                tot_ea += ls.getInt("ea");
	                tot_item_weight += (ls.getInt("ea") * ls.getFloat("item_weight"));
                }
                list.add(dbox);
            }
            DecimalFormat format = new DecimalFormat("#.##");
            
            rBox.put("tot_ea", Integer.toString(tot_ea));
            rBox.put("tot_item_weight", format.format(tot_item_weight));
            
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
		String p_dwgno = box.getString("p_dwgno");
		String p_blockno = box.getString("p_blockno");
		String p_stageno = box.getString("p_stageno");
		String p_dept = box.getString("p_dept");
		String p_user = box.getString("p_user");
		String p_state = box.getString("p_state");
		String p_mothercode = box.getString("p_mothercode");
		String p_itemcode = box.getString("p_itemcode");
		String p_bom2 = box.getString("p_bom2");
		String p_description = box.getString("p_description");
		String p_desc_detail = box.getString("p_desc_detail");
		String p_item_desc_detail = box.getString("p_item_desc_detail");
		String p_econo = box.getString("p_econo");
		String p_release = box.getString("p_release");
		String p_selrev = box.getString("p_selrev");
		String p_ship = box.getString("p_ship");
		String p_attr1 = box.getString("p_attr1");
		String p_attr2 = box.getString("p_attr2");
		String p_attr3 = box.getString("p_attr3");
		String p_attr4 = box.getString("p_attr4");
		String p_attr5 = box.getString("p_attr5");
		String p_attr6 = box.getString("p_attr6");
		String p_attr7 = box.getString("p_attr7");
		String p_attr8 = box.getString("p_attr8");
		String p_attr9 = box.getString("p_attr9");
		String p_attr10 = box.getString("p_attr10");
		String p_attr11 = box.getString("p_attr11");
		String p_attr12 = box.getString("p_attr12");
		String p_attr13 = box.getString("p_attr13");
		String p_attr14 = box.getString("p_attr14");
		String p_attr15 = box.getString("p_attr15");
		String p_item_type_cd = box.getString("p_item_type_cd");
		String p_rawmaterial = box.getString("p_rawmaterial");
		
		try
		{
			if(qryExp.equals("mainList")){
				String mainTable = "";
				String isHistory = "N";
				if(p_selrev.equals("Final") || p_selrev.equals("")){
					mainTable = "STX_TBC_SSC_HEAD";
					isHistory = "N";
				}else{
					mainTable = "STX_TBC_SSC_HEAD_HISTORY";
					isHistory = "Y";
				}
				
				
				if(p_rawmaterial.equals("") && !p_item_type_cd.equals("VA")){
					query.append("SELECT \n");
					query.append("  A.STATE_FLAG \n");
					query.append(", B.DELEGATE_PROJECT_NO AS DELEGATEPROJECTNO \n");
					query.append(", A.PROJECT_NO \n");
					query.append(", A.DWG_NO \n");
					query.append(", A.BLOCK_NO \n");
					query.append(", A.STR_FLAG \n");
					query.append(", A.STAGE_NO \n");
					query.append(", A.MOTHER_CODE \n");
					query.append(", A.ITEM_CODE \n");
					query.append(", A.BOM2 \n");
					query.append(", A.BOM7 \n");
					query.append(", C.ITEM_CATALOG \n");
					//TR?? ??? ???? ???????? ??????? ????? CATALOG ??????? ?????? ????? ????.
					if(p_item_type_cd.equals("TR")){
						query.append(", DECODE((SELECT CASE \n");
						query.append("                    WHEN SUBSTR(A.ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(A.ATTRIBUTE_CODE, 0) \n");
						query.append("                    ELSE A.ATTRIBUTE_CODE \n");
						query.append("                 END ATTRBUTE_CODE \n");
						query.append("            FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" A \n");
						query.append("           WHERE A.ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("             AND A.CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("             AND (A.ATTRIBUTE_NAME = 'MATERIAL' OR A.ATTRIBUTE_NAME = 'MATERIAL1' OR A.ATTRIBUTE_NAME = 'MATERIAL2') \n");
						query.append("             AND ROWNUM = 1 \n");
						query.append("          ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("           , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("           , '' \n");
						query.append("   ) AS TR_MATERIAL \n");
						query.append(", CASE WHEN SUBSTR(ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN \n");
						query.append("           DECODE((SELECT CASE \n");
						query.append("                            WHEN SUBSTR(A.ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(A.ATTRIBUTE_CODE, 0) \n");
						query.append("                            ELSE A.ATTRIBUTE_CODE \n");
						query.append("                          END ATTRBUTE_CODE \n");
						query.append("                     FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" A \n");
						query.append("                    WHERE A.ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("                      AND A.CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("                      AND A.ATTRIBUTE_NAME = 'OUT_SIDE COATING' \n");
						query.append("                  ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("                   , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("                   , '') \n");
						query.append("        ELSE PAINT_CODE3 \n");
						query.append("  END AS TR_PAINT \n");
						query.append(", CASE WHEN SUBSTR(ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN C.ITEM_OLDCODE \n");
						query.append("       ELSE C.ATTR1 \n");
						query.append("  END AS TR_DESCRIPTION \n");
						
					//SE?? ??? ???? ???????? ??????? ????? CATALOG ??????? ?????? ????? ????.
					}else if(p_item_type_cd.equals("SE")){
						query.append(", CASE WHEN SUBSTR(ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN A.BOM2 \n");
						query.append("       ELSE C.ATTR1 \n");
						query.append("  END AS SE_SEATNO \n");
						query.append(", DECODE(( \n");
						query.append("         SELECT CASE \n");
						query.append("                   WHEN SUBSTR(ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(ATTRIBUTE_CODE, 0) \n");
						query.append("                   ELSE ATTRIBUTE_CODE \n");
						query.append("                 END ATTRBUTE_CODE \n");
						query.append("            FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" \n");
						query.append("           WHERE ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("             AND CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("             AND (ATTRIBUTE_NAME = 'MATERIAL' OR ATTRIBUTE_NAME = 'MATERIAL1' OR ATTRIBUTE_NAME = 'MATERIAL2') \n");
						query.append("             AND ROWNUM = 1 \n");
						query.append("          ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("           , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("           , '' \n");
						query.append("   ) AS SE_MATERIAL \n");
						query.append(", DECODE((SELECT CASE \n");
						query.append("                   WHEN SUBSTR(A.ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(A.ATTRIBUTE_CODE, 0) \n");
						query.append("                   ELSE A.ATTRIBUTE_CODE \n");
						query.append("                 END ATTRBUTE_CODE \n");
						query.append("            FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" A \n");
						query.append("           WHERE A.ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("             AND A.CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("             AND A.ATTRIBUTE_NAME = 'TYPE' \n");
						query.append("          ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("           , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("           , '' \n");
						query.append("   ) AS SE_TYPE \n");
						query.append(", CASE WHEN SUBSTR(ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN \n");
						query.append("           DECODE((SELECT CASE \n");
						query.append("                            WHEN SUBSTR(A.ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(A.ATTRIBUTE_CODE, 0) \n");
						query.append("                            ELSE A.ATTRIBUTE_CODE \n");
						query.append("                          END ATTRBUTE_CODE \n");
						query.append("                     FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" A \n");
						query.append("                    WHERE A.ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("                      AND A.CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("                      AND A.ATTRIBUTE_NAME = 'OUT_SIDE COATING' \n");
						query.append("                  ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("                   , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("                   , '') \n");
						query.append("        ELSE PAINT_CODE3 \n");
						query.append("  END AS SE_PAINT \n");
					}
					
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
					query.append(", CASE WHEN SUBSTR(ITEM_CODE,0,1) = 'Z' THEN 'N' ELSE 'Y' END AS ISSTANDARD \n");
					query.append(", C.ITEM_DESC \n");				
					query.append(", C.ITEM_DESC_DETAIL \n");
					query.append(", C.ITEM_OLDCODE \n");
					query.append(", A.SSC_SUB_ID \n");
					query.append(", D.COLUMN10 \n");
					query.append(", D.COLUMN20 \n");
					query.append(", D.COLUMN30 \n");
					query.append(", D.COLUMN40 \n");
					query.append(", D.COLUMN50 \n");
					query.append(", D.COLUMN60 \n");
					query.append(", D.COLUMN70 \n");
					query.append(", D.COLUMN80 \n");
					query.append(", D.COLUMN90 \n");
					query.append(", D.COLUMN100 \n");
					query.append(", D.COLUMN110 \n");
					query.append(", D.COLUMN120 \n");
					query.append(", D.COLUMN130 \n");
					query.append(", D.COLUMN140 \n");
					query.append(", D.COLUMN150 \n");
					query.append(", D.COLUMN160 \n");
					query.append(", D.COLUMN170 \n");
					query.append(", A.BOM_QTY AS EA \n");
					query.append(", C.ITEM_WEIGHT \n");
					query.append(", A.REV_NO \n");
					query.append(", A.PAINT_CODE3 \n");
					query.append(", A.PAINT_CODE4 \n");
					query.append(", A.DEPT_NAME \n");
					query.append(", A.DEPT_CODE \n");
					query.append(", A.USER_NAME \n");
					query.append(", A.USER_ID \n");
					query.append(", A.RAW_LV \n");
					query.append(", TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE  \n");
					query.append(", A.ECO_NO \n");
					query.append(", TO_CHAR(E.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE  \n");
					query.append(", (CASE WHEN NVL(F.DWG_NO_CONCAT,' ') > ' ' THEN 'Y' WHEN NVL(F.DWG_NO_CONCAT,' ') <= ' ' THEN 'N' END) DWG_CHECK \n");
					query.append(", A.REMARK \n");
					query.append(", A.ITEM_TYPE_CD \n");
					query.append(", A.BOM_ITEM_DETAIL \n");
					query.append(", A.KEY_NO \n");
					query.append(", '"+isHistory+"' AS ISHISTORY \n");
					query.append("FROM "+mainTable+" A \n");
					query.append("INNER JOIN STX_DIS_BOM_SCHEDULE_V B ON A.PROJECT_NO = B.PROJECT_NO \n");
					query.append("INNER JOIN STX_TBC_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
					query.append("LEFT JOIN ( \n");
					query.append("    SELECT SSC_SUB_ID \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '10', ELEMENT_VALUE)) AS COLUMN10                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '20', ELEMENT_VALUE)) AS COLUMN20                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '30', ELEMENT_VALUE)) AS COLUMN30                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '40', ELEMENT_VALUE)) AS COLUMN40                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '50', ELEMENT_VALUE)) AS COLUMN50                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '60', ELEMENT_VALUE)) AS COLUMN60                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '70', ELEMENT_VALUE)) AS COLUMN70                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '80', ELEMENT_VALUE)) AS COLUMN80                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE,  '90', ELEMENT_VALUE)) AS COLUMN90                \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '100', ELEMENT_VALUE)) AS COLUMN100               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '110', ELEMENT_VALUE)) AS COLUMN110               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '120', ELEMENT_VALUE)) AS COLUMN120               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '130', ELEMENT_VALUE)) AS COLUMN130               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '140', ELEMENT_VALUE)) AS COLUMN140               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '150', ELEMENT_VALUE)) AS COLUMN150               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '160', ELEMENT_VALUE)) AS COLUMN160               \n");
					query.append("        , MIN(DECODE(ELEMENT_SEQUENCE, '170', ELEMENT_VALUE)) AS COLUMN170               \n");
					query.append("    FROM( \n");
					query.append("        SELECT SSC_SUB_ID \n");
					query.append("        , ELEMENT_NAME \n");
					query.append("        , ELEMENT_VALUE \n");
					query.append("        , A.ELEMENT_SEQUENCE \n");
					query.append("        FROM STX_TBC_SSC_SUB_DESCRIPTION A \n");
					query.append("        INNER JOIN STX_TBC_SSC_SUB B ON A.ELEMENT_SEQUENCE = B.ELEMENT_SEQUENCE \n");
					query.append("    ) \n");
					query.append("    GROUP BY SSC_SUB_ID \n");
					query.append(") D ON A.SSC_SUB_ID = D.SSC_SUB_ID \n");
					query.append("LEFT JOIN STX_TBC_ECO E ON A.ECO_NO = E.ECO_NO \n");
					query.append("LEFT JOIN STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" F ON A.DWG_NO = F.DWG_NO_CONCAT \n");
					query.append("WHERE 1=1 \n");
					query.append("AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				}else{
					query.append(" SELECT * FROM ( \n");
					query.append("          SELECT A.STATE_FLAG \n");
					query.append("               , B.DELEGATE_PROJECT_NO AS DELEGATEPROJECTNO \n");
					query.append("               , A.PROJECT_NO \n");
					query.append("               , A.DWG_NO \n");
					query.append("               , A.BLOCK_NO \n");
					query.append("               , A.STR_FLAG \n");
					query.append("               , A.STAGE_NO \n");
					query.append("               , A.MOTHER_CODE \n");
					query.append("               , A.ITEM_CODE \n");
					query.append("               , A.ITEM_CODE AS LAW_CODE \n");
					query.append("				 , A.BOM7 \n");
					query.append("               , ROW_NUMBER() OVER(PARTITION BY A.KEY_NO, A.BLOCK_NO, A.STAGE_NO ORDER BY A.KEY_NO, A.BLOCK_NO, A.STAGE_NO, A.RAW_LV) AS CHILD_NUM \n");
					query.append("               , C.ATTR1 \n");
					query.append("               , C.ATTR2 \n");
					query.append("               , C.ATTR3 \n");
					query.append("               , C.ATTR4 \n");
					query.append("               , C.ATTR5 \n");
					query.append("               , C.ATTR6 \n");
					query.append("               , C.ATTR7 \n");
					query.append("               , C.ATTR8 \n");
					query.append("               , C.ATTR9 \n");
					query.append("               , C.ATTR10 \n");
					query.append("               , C.ATTR11 \n");
					query.append("               , C.ATTR12 \n");
					query.append("               , C.ATTR13 \n");
					query.append("               , C.ATTR14 \n");
					query.append("               , C.ATTR15 \n");
					query.append("               , C.ITEM_DESC \n");
					query.append("               , C.ITEM_DESC_DETAIL \n");
					query.append("               , C.ITEM_OLDCODE \n");
					query.append("               , A.KEY_NO \n");
					query.append("				 , A.SSC_SUB_ID \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '10', D.ELEMENT_VALUE)) AS COLUMN10 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '20', D.ELEMENT_VALUE)) AS COLUMN20 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '30', D.ELEMENT_VALUE)) AS COLUMN30 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '40', D.ELEMENT_VALUE)) AS COLUMN40 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '50', D.ELEMENT_VALUE)) AS COLUMN50 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '60', D.ELEMENT_VALUE)) AS COLUMN60 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '70', D.ELEMENT_VALUE)) AS COLUMN70 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '80', D.ELEMENT_VALUE)) AS COLUMN80 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE,  '90', D.ELEMENT_VALUE)) AS COLUMN90 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '100', D.ELEMENT_VALUE)) AS COLUMN100 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '110', D.ELEMENT_VALUE)) AS COLUMN110 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '120', D.ELEMENT_VALUE)) AS COLUMN120 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '130', D.ELEMENT_VALUE)) AS COLUMN130 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '140', D.ELEMENT_VALUE)) AS COLUMN140 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '150', D.ELEMENT_VALUE)) AS COLUMN150 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '160', D.ELEMENT_VALUE)) AS COLUMN160 \n");
					query.append("               , MIN(DECODE(D.ELEMENT_SEQUENCE, '170', D.ELEMENT_VALUE)) AS COLUMN170 \n");
					query.append("               , A.BOM_QTY AS EA \n");
					query.append("               , C.ITEM_WEIGHT \n");
					query.append("               , A.REV_NO \n");
					query.append("               , A.PAINT_CODE3 \n");
					query.append("               , A.PAINT_CODE4 \n");
					query.append("               , A.DEPT_NAME \n");
					query.append("               , A.DEPT_CODE \n");
					query.append("               , A.USER_NAME \n");
					query.append("               , A.USER_ID \n");
					query.append("               , A.RAW_LV \n");
					query.append("               , TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
					query.append("               , A.ECO_NO \n");
					query.append("               , TO_CHAR(E.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE \n");
					query.append("               , (CASE WHEN NVL(F.DWG_NO_CONCAT,' ') > ' ' THEN 'Y' WHEN NVL(F.DWG_NO_CONCAT,' ') <= ' ' THEN 'N' END) DWG_CHECK \n");
					query.append("               , A.REMARK \n");
					query.append("               , A.ITEM_TYPE_CD \n");
					query.append("               , 'N' AS ISHISTORY \n");
					query.append("               , 1                AS ORDER_BY \n");
					query.append("             FROM STX_TBC_SSC_HEAD            A \n");
					query.append("                 ,STX_DIS_BOM_SCHEDULE_V   B \n");
					query.append("                 ,STX_TBC_ITEM                C \n");
					query.append("                 ,STX_TBC_SSC_SUB             D \n");
					query.append("                 ,STX_TBC_ECO                 E \n");
					query.append("                 ,STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" F \n");
					query.append("            WHERE A.PROJECT_NO    = B.PROJECT_NO \n");
					query.append("              AND A.ITEM_CODE     = C.ITEM_CODE \n");
					query.append("              AND A.SSC_SUB_ID    = D.SSC_SUB_ID(+) \n");
					query.append("              AND A.ECO_NO        = E.ECO_NO(+) \n");
					query.append("              AND A.DWG_NO        = F.DWG_NO_CONCAT(+) \n");
					query.append("              AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
				}
				
				if(p_ship.equals("master")){
					if(!p_project.equals("")){
						p_project = p_project.replaceAll("[*]","%");
						query.append("AND B.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");
					}	
				}else{
					if(!p_project.equals("")){
						p_project = p_project.replaceAll("[*]","%");
						query.append("AND A.PROJECT_NO LIKE '"+p_project+"' ");
					}
				}
				if(!p_dwgno.equals("")){
					p_dwgno = p_dwgno.replaceAll("[*]","%");
					query.append("AND A.DWG_NO LIKE '"+p_dwgno+"' ");
				}
				if(!p_blockno.equals("")){
					p_blockno = p_blockno.replaceAll("[*]","%");
					query.append("AND A.BLOCK_NO LIKE '"+p_blockno+"' ");
				}
				if(!p_stageno.equals("")){
					p_stageno = p_stageno.replaceAll("[*]","%");
					query.append("AND A.STAGE_NO LIKE '"+p_stageno+"' ");
				}
				if(!p_description.equals("")){
					p_description = p_description.replaceAll("[*]","%");
					query.append("AND C.ITEM_DESC LIKE '"+p_description+"' ");
				}
				if(!p_desc_detail.equals("")){
					p_desc_detail = p_desc_detail.replaceAll("[*]","%");
					query.append("AND C.ITEM_DESC_DETAIL LIKE '"+p_desc_detail+"' ");
				}
				if(!p_mothercode.equals("")){
					p_mothercode = p_mothercode.replaceAll("[*]","%");
					query.append("AND A.MOTHER_CODE LIKE '"+p_mothercode+"' ");
				}
				if(!p_itemcode.equals("")){
					p_itemcode = p_itemcode.replaceAll("[*]","%");
					query.append("AND A.ITEM_CODE LIKE '"+p_itemcode+"' ");
				}
				
				if(!p_state.equals("ALL") && !p_state.equals("") && !p_state.equals("Act") ){
					query.append("AND A.STATE_FLAG LIKE '"+p_state+"' ");
				}
				
				if(p_state.equals("Act") ){
					query.append("AND (A.ECO_NO IS NULL) ");
				}
				
				if(p_release.equals("Y") ){
					query.append("AND (A.ECO_NO IS NOT NULL) ");
				} else if(p_release.equals("N") ){
					query.append("AND (A.ECO_NO IS NULL) ");
				}
				
				if(!p_bom2.equals("")){
					p_bom2 = p_bom2.replaceAll("[*]","%");
					query.append("AND A.BOM2 LIKE '"+p_bom2+"' ");
				}
				if(!p_attr1.equals("")){
					p_attr1 = p_attr1.replaceAll("[*]","%");
					query.append("AND C.ATTR1 LIKE '"+p_attr1+"' ");
				}
				
				if(!p_attr2.equals("")){
					p_attr2 = p_attr2.replaceAll("[*]","%");
					query.append("AND C.ATTR2 LIKE '"+p_attr2+"' ");
				}
				if(!p_attr3.equals("")){
					p_attr3 = p_attr3.replaceAll("[*]","%");
					query.append("AND C.ATTR3 LIKE '"+p_attr3+"' ");
				}
				if(!p_attr4.equals("")){
					p_attr4 = p_attr4.replaceAll("[*]","%");
					query.append("AND C.ATTR4 LIKE '"+p_attr4+"' ");
				}
				if(!p_attr5.equals("")){
					p_attr5 = p_attr5.replaceAll("[*]","%");
					query.append("AND C.ATTR5 LIKE '"+p_attr5+"' ");
				}
				if(!p_attr6.equals("")){
					p_attr6 = p_attr6.replaceAll("[*]","%");
					query.append("AND C.ATTR6 LIKE '"+p_attr6+"' ");
				}
				if(!p_attr7.equals("")){
					p_attr7 = p_attr7.replaceAll("[*]","%");
					query.append("AND C.ATTR7 LIKE '"+p_attr7+"' ");
				}
				if(!p_attr8.equals("")){
					p_attr8 = p_attr8.replaceAll("[*]","%");
					query.append("AND C.ATTR8 LIKE '"+p_attr8+"' ");
				}
				if(!p_attr9.equals("")){
					p_attr9 = p_attr9.replaceAll("[*]","%");
					query.append("AND C.ATTR9 LIKE '"+p_attr9+"' ");
				}
				if(!p_attr10.equals("")){
					p_attr10 = p_attr10.replaceAll("[*]","%");
					query.append("AND C.ATTR10 LIKE '"+p_attr10+"' ");
				}
				if(!p_attr11.equals("")){
					p_attr11 = p_attr11.replaceAll("[*]","%");
					query.append("AND C.ATTR11 LIKE '"+p_attr11+"' ");
				}
				if(!p_attr12.equals("")){
					p_attr12 = p_attr12.replaceAll("[*]","%");
					query.append("AND C.ATTR12 LIKE '"+p_attr12+"' ");
				}
				if(!p_attr13.equals("")){
					p_attr13 = p_attr13.replaceAll("[*]","%");
					query.append("AND C.ATTR13 LIKE '"+p_attr13+"' ");
				}
				if(!p_attr14.equals("")){
					p_attr14 = p_attr14.replaceAll("[*]","%");
					query.append("AND C.ATTR14 LIKE '"+p_attr14+"' ");
				}
				if(!p_attr15.equals("")){
					p_attr15 = p_attr15.replaceAll("[*]","%");
					query.append("AND C.ATTR15 LIKE '"+p_attr15+"' ");
				}
				
				if(!p_econo.equals("")){
					p_econo = p_econo.replaceAll("[*]","%");
					query.append("AND A.ECO_NO LIKE '"+p_econo+"' ");
				}
				
				
				if(!p_selrev.equals("Final") && !p_selrev.equals("")){
					query.append("AND A.REV_NO LIKE '"+p_selrev+"' ");
				}
				if(!p_release.equals("ALL") && !p_selrev.equals("")){
					if(p_release.equals("Y")){
						query.append("AND E.RELEASE_DATE IS NOT NULL \n");
					}else{
						query.append("AND E.RELEASE_DATE IS NULL \n");
					}
				}
				
				if(p_rawmaterial.equals("") && !p_item_type_cd.equals("VA")){
					query.append("ORDER BY A.PROJECT_NO ,A.BLOCK_NO, A.STAGE_NO, A.STR_FLAG, A.ITEM_CODE ");
					if(p_item_type_cd.equals("SU")){
						query.append(", C.ATTR5");
					}
				}else{

					query.append("              GROUP BY A.PROJECT_NO \n");
					query.append("                     , A.ITEM_CODE \n");
					query.append("                     , A.ITEM_CODE \n");
					query.append("                     , A.STATE_FLAG \n");
					query.append("                     , B.DELEGATE_PROJECT_NO \n");
					query.append("                     , A.PROJECT_NO \n");
					query.append("                     , A.DWG_NO \n");
					query.append("                     , A.BLOCK_NO \n");
					query.append("                     , A.STR_FLAG \n");
					query.append("                     , A.STAGE_NO \n");
					query.append("                     , A.MOTHER_CODE \n");
					query.append("                     , A.ITEM_CODE \n");
					query.append("				 	   , A.BOM7 \n");
					query.append("                     , C.ATTR1 \n");
					query.append("                     , C.ATTR2 \n");
					query.append("                     , C.ATTR3 \n");
					query.append("                     , C.ATTR4 \n");
					query.append("                     , C.ATTR5 \n");
					query.append("                     , C.ATTR6 \n");
					query.append("                     , C.ATTR7 \n");
					query.append("                     , C.ATTR8 \n");
					query.append("                     , C.ATTR9 \n");
					query.append("                     , C.ATTR10 \n");
					query.append("                     , C.ATTR11 \n");
					query.append("                     , C.ATTR12 \n");
					query.append("                     , C.ATTR13 \n");
					query.append("                     , C.ATTR14 \n");
					query.append("                     , C.ATTR15 \n");
					query.append("                     , C.ITEM_DESC \n");
					query.append("                     , C.ITEM_DESC_DETAIL \n");
					query.append("                     , C.ITEM_OLDCODE \n");
					query.append("                     , A.KEY_NO \n");
					query.append("					   , A.SSC_SUB_ID \n");
					query.append("                     , A.PROJECT_NO \n");
					query.append("                     , A.ITEM_CODE \n");
					query.append("                     , A.BOM_QTY \n");
					query.append("                     , C.ITEM_WEIGHT \n");
					query.append("                     , A.REV_NO \n");
					query.append("                     , A.PAINT_CODE3 \n");
					query.append("                     , A.PAINT_CODE4 \n");
					query.append("                     , A.DEPT_NAME \n");
					query.append("                     , A.DEPT_CODE \n");
					query.append("                     , A.USER_NAME \n");
					query.append("                     , A.USER_ID \n");
					query.append("                     , A.RAW_LV \n");
					query.append("                     , TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') \n");
					query.append("                     , A.ECO_NO \n");
					query.append("                     , TO_CHAR(E.RELEASE_DATE, 'YYYY-MM-DD') \n");
					query.append("                     , (CASE WHEN NVL(F.DWG_NO_CONCAT,' ') > ' ' THEN 'Y' WHEN NVL(F.DWG_NO_CONCAT,' ') <= ' ' THEN 'N' END) \n");
					query.append("                     , A.REMARK \n");
					query.append("                     , A.ITEM_TYPE_CD \n");
					query.append("           UNION ALL \n");
					query.append("           SELECT  '' AS STATE_FLAG \n");
					query.append("                 , B.DELEGATE_PROJECT_NO AS DELEGATEPROJECTNO \n");
					query.append("                 , A.PROJECT_NO \n");
					query.append("                 , A.DWG_NO \n");
					query.append("                 , A.BLOCK_NO \n");
					query.append("                 , A.STR_FLAG \n");
					query.append("                 , A.STAGE_NO \n");
					query.append("                 , AA.MOTHER_CODE \n");
					query.append("                 , AA.ITEM_CODE \n");
					query.append("                 , AA.MOTHER_CODE AS LAW_CODE \n");
					query.append("				   , '' AS BOM7 \n");
					query.append("                 , ROW_NUMBER() OVER(PARTITION BY A.KEY_NO, A.BLOCK_NO, A.STAGE_NO ORDER BY A.PROJECT_NO, A.BLOCK_NO, A.STAGE_NO, A.RAW_LV) AS CHILD_NUM  \n");
					query.append("                 , C.ATTR1 \n");
					query.append("                 , C.ATTR2 \n");
					query.append("                 , C.ATTR3 \n");
					query.append("                 , C.ATTR4 \n");
					query.append("                 , C.ATTR5 \n");
					query.append("                 , C.ATTR6 \n");
					query.append("                 , C.ATTR7 \n");
					query.append("                 , C.ATTR8 \n");
					query.append("                 , C.ATTR9 \n");
					query.append("                 , C.ATTR10 \n");
					query.append("                 , C.ATTR11 \n");
					query.append("                 , C.ATTR12 \n");
					query.append("                 , C.ATTR13 \n");
					query.append("                 , C.ATTR14 \n");
					query.append("                 , C.ATTR15 \n");
					query.append("                 , C.ITEM_DESC \n");
					query.append("                 , C.ITEM_DESC_DETAIL \n");
					query.append("                 , C.ITEM_OLDCODE \n");
					query.append("                 , A.KEY_NO \n");
					query.append("                 , A.SSC_SUB_ID \n");
					query.append("                 , '' AS COLUMN10 \n");
					query.append("                 , '' AS COLUMN20 \n");
					query.append("                 , '' AS COLUMN30 \n");
					query.append("                 , '' AS COLUMN40 \n");
					query.append("                 , '' AS COLUMN50 \n");
					query.append("                 , '' AS COLUMN60 \n");
					query.append("                 , '' AS COLUMN70 \n");
					query.append("                 , '' AS COLUMN80 \n");
					query.append("                 , '' AS COLUMN90 \n");
					query.append("                 , '' AS COLUMN100 \n");
					query.append("                 , '' AS COLUMN110 \n");
					query.append("                 , '' AS COLUMN120 \n");
					query.append("                 , '' AS COLUMN130 \n");
					query.append("                 , '' AS COLUMN140 \n");
					query.append("                 , '' AS COLUMN150 \n");
					query.append("                 , '' AS COLUMN160 \n");
					query.append("                 , '' AS COLUMN170 \n");
					query.append("                 , AA.BOM_QTY AS EA \n");
					query.append("                 , C.ITEM_WEIGHT \n");
					query.append("                 , '' AS REV_NO \n");
					query.append("                 , '' AS PAINT_CODE3 \n");
					query.append("                 , '' AS PAINT_CODE4 \n");
					//query.append("                 , '' AS DEPT_NAME \n");
					query.append("                 , (SELECT DDDC.DWGDEPTNM \n");
					query.append("						FROM STX_COM_INSA_USER@STXUTF SCIU \n"); 
					query.append("			      INNER JOIN DCC_DEPTCODE@STXDP DDC ON SCIU.DEPT_CODE = DDC.DEPTCODE \n"); 
					query.append("                INNER JOIN DCC_DWGDEPTCODE@STXDP DDDC ON DDC.DWGDEPTCODE = DDDC.DWGDEPTCODE \n"); 
					query.append("                     WHERE SCIU.EMP_NO = AA.USER_ID) AS DEPT_NAME \n");
					query.append("                 , '' AS DEPT_CODE \n");
					query.append("                 , AA.USER_NAME AS USER_NAME \n");
					query.append("                 , AA.USER_ID AS USER_ID \n");
					query.append("                 , 2 AS RAW_LV \n");
					query.append("                 , TO_CHAR(AA.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
					query.append("                 , '' AS ECO_NO \n");
					query.append("                 , '' AS RELEASE_DATE \n");
					query.append("                 , '' AS DWG_CHECK \n");
					query.append("                 , '' AS REMARK \n");
					query.append("                 , '' AS ITEM_TYPE_CD \n");
					query.append("                 , 'N' AS ISHISTORY \n");
					query.append("                 , 2  AS ORDER_BY \n");
					query.append("             FROM STX_TBC_RAWLEVEL AA \n");
					query.append("                 ,STX_TBC_SSC_HEAD A \n");
					query.append("                 ,STX_DIS_BOM_SCHEDULE_V   B \n");
					query.append("                 ,STX_TBC_ITEM C \n");
					query.append("                 ,STX_TBC_ITEM D \n");
					query.append("            WHERE A.ITEM_CODE = AA.MOTHER_CODE \n");
					query.append("              AND AA.ITEM_CODE   = C.ITEM_CODE \n");
					query.append("              AND AA.MOTHER_CODE   = D.ITEM_CODE \n");
					query.append("              AND A.PROJECT_NO    = B.PROJECT_NO \n");
					
					if(p_ship.equals("master")){
						if(!p_project.equals("")){
							p_project = p_project.replaceAll("[*]","%");
							query.append("AND B.DELEGATE_PROJECT_NO LIKE '"+p_project+"' ");
						}	
					}else{
						if(!p_project.equals("")){
							p_project = p_project.replaceAll("[*]","%");
							query.append("AND A.PROJECT_NO LIKE '"+p_project+"' ");
						}
					}
					if(!p_dwgno.equals("")){
						p_dwgno = p_dwgno.replaceAll("[*]","%");
						query.append("AND A.DWG_NO LIKE '"+p_dwgno+"' ");
					}
					if(!p_blockno.equals("")){
						p_blockno = p_blockno.replaceAll("[*]","%");
						query.append("AND A.BLOCK_NO LIKE '"+p_blockno+"' ");
					}
					if(!p_stageno.equals("")){
						p_stageno = p_stageno.replaceAll("[*]","%");
						query.append("AND A.STAGE_NO LIKE '"+p_stageno+"' ");
					}
					if(!p_description.equals("")){
						p_description = p_description.replaceAll("[*]","%");
						query.append("AND C.ITEM_DESC LIKE '"+p_description+"' ");
					}
					if(!p_desc_detail.equals("")){
						p_desc_detail = p_desc_detail.replaceAll("[*]","%");
						query.append("AND C.ITEM_DESC_DETAIL LIKE '"+p_desc_detail+"' ");
					}
					if(!p_mothercode.equals("")){
						p_mothercode = p_mothercode.replaceAll("[*]","%");
						query.append("AND A.MOTHER_CODE LIKE '"+p_mothercode+"' ");
					}
					if(!p_itemcode.equals("")){
						p_itemcode = p_itemcode.replaceAll("[*]","%");
						query.append("AND A.ITEM_CODE LIKE '"+p_itemcode+"' ");
					}
					
					if(!p_state.equals("ALL") && !p_state.equals("") && !p_state.equals("Act") ){
						query.append("AND A.STATE_FLAG LIKE '"+p_state+"' ");
					}

					if(p_state.equals("Act") ){
						query.append("AND (A.ECO_NO IS NULL) ");
					}
					
					if(p_release.equals("Y") ){
						query.append("AND (A.ECO_NO IS NOT NULL) ");
					} else if(p_release.equals("N") ){
						query.append("AND (A.ECO_NO IS NULL) ");
					}
					
					if(!p_attr1.equals("")){
						p_attr1 = p_attr1.replaceAll("[*]","%");
						query.append("AND D.ATTR1 LIKE '"+p_attr1+"' ");
					}
					
					if(!p_attr2.equals("")){
						p_attr2 = p_attr2.replaceAll("[*]","%");
						query.append("AND D.ATTR2 LIKE '"+p_attr2+"' ");
					}
					if(!p_attr3.equals("")){
						p_attr3 = p_attr3.replaceAll("[*]","%");
						query.append("AND D.ATTR3 LIKE '"+p_attr3+"' ");
					}
					if(!p_attr4.equals("")){
						p_attr4 = p_attr4.replaceAll("[*]","%");
						query.append("AND D.ATTR4 LIKE '"+p_attr4+"' ");
					}
					if(!p_attr5.equals("")){
						p_attr5 = p_attr5.replaceAll("[*]","%");
						query.append("AND D.ATTR5 LIKE '"+p_attr5+"' ");
					}
					if(!p_attr6.equals("")){
						p_attr6 = p_attr6.replaceAll("[*]","%");
						query.append("AND D.ATTR6 LIKE '"+p_attr6+"' ");
					}
					if(!p_attr7.equals("")){
						p_attr7 = p_attr7.replaceAll("[*]","%");
						query.append("AND D.ATTR7 LIKE '"+p_attr7+"' ");
					}
					if(!p_attr8.equals("")){
						p_attr8 = p_attr8.replaceAll("[*]","%");
						query.append("AND D.ATTR8 LIKE '"+p_attr8+"' ");
					}
					if(!p_attr9.equals("")){
						p_attr9 = p_attr9.replaceAll("[*]","%");
						query.append("AND D.ATTR9 LIKE '"+p_attr9+"' ");
					}
					if(!p_attr10.equals("")){
						p_attr10 = p_attr10.replaceAll("[*]","%");
						query.append("AND D.ATTR10 LIKE '"+p_attr10+"' ");
					}
					if(!p_attr11.equals("")){
						p_attr11 = p_attr11.replaceAll("[*]","%");
						query.append("AND D.ATTR11 LIKE '"+p_attr11+"' ");
					}
					if(!p_attr12.equals("")){
						p_attr12 = p_attr12.replaceAll("[*]","%");
						query.append("AND D.ATTR12 LIKE '"+p_attr12+"' ");
					}
					if(!p_attr13.equals("")){
						p_attr13 = p_attr13.replaceAll("[*]","%");
						query.append("AND D.ATTR13 LIKE '"+p_attr13+"' ");
					}
					if(!p_attr14.equals("")){
						p_attr14 = p_attr14.replaceAll("[*]","%");
						query.append("AND D.ATTR14 LIKE '"+p_attr14+"' ");
					}
					if(!p_attr15.equals("")){
						p_attr15 = p_attr15.replaceAll("[*]","%");
						query.append("AND D.ATTR15 LIKE '"+p_attr15+"' ");
					}
					
					if(!p_econo.equals("")){
						p_econo = p_econo.replaceAll("[*]","%");
						query.append("AND A.ECO_NO LIKE '"+p_econo+"' ");
					}
					
					
					if(!p_selrev.equals("Final") && !p_selrev.equals("")){
						query.append("AND A.REV_NO LIKE '"+p_selrev+"' ");
					}
					if(!p_release.equals("ALL") && !p_selrev.equals("")){
						if(p_release.equals("Y")){
							query.append("AND E.RELEASE_DATE IS NOT NULL \n");
						}else{
							query.append("AND E.RELEASE_DATE IS NULL \n");
						}
					}
					
					query.append("       ) ZZ \n");
					query.append("  ORDER BY PROJECT_NO, BLOCK_NO, STAGE_NO, STR_FLAG, LAW_CODE, CHILD_NUM, ORDER_BY \n");
					
				}
			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}		
		return query.toString();
	}
	
	
	public int getAttrNum(String p_item_code, String p_element_name) throws Exception {
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int vAttrNum = 0;
        
    	try 
        { 
        	query.append("SELECT A.ELE_SEQ \n");
        	query.append("  FROM ( \n");
        	query.append("          SELECT MICG.SEGMENT1                                                            AS CATALOG_NO \n");
        	query.append("                ,RANK() OVER (PARTITION BY MICG.SEGMENT1  ORDER BY  MDE.ELEMENT_SEQUENCE) AS ELE_SEQ \n");
        	query.append("                ,MDE.ELEMENT_NAME                                                         AS ELEMENT_NAME \n");
        	query.append("            FROM MTL_ITEM_CATALOG_GROUPS_B@"+ERP_DB+" MICG \n");
        	query.append("                ,MTL_DESCRIPTIVE_ELEMENTS@"+ERP_DB+"  MDE \n");
        	query.append("            WHERE MICG.ITEM_CATALOG_GROUP_ID = MDE.ITEM_CATALOG_GROUP_ID \n");
        	query.append("       ) A \n");
        	query.append(" WHERE A.CATALOG_NO = SUBSTR('"+p_item_code+"',0,INSTR('"+p_item_code+"', '-')-1) \n");
        	query.append("   AND A.ELEMENT_NAME = '"+p_element_name+"' \n");
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	vAttrNum = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return vAttrNum;
	}
	
}