package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.DecimalFormat;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcMainDao implements Idao{
	
	
	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	
    	String p_item_type_cd = rBox.getString("p_item_type_cd");    	
        try 
        { 
            //int tot_ea = 0;
        	float tot_ea = 0;
            float tot_item_weight = 0;
            
            int tot_f = 0;
            int tot_a = 0;
            int tot_p = 0;
            
        	list = new ArrayList();
            query  = getQuery(qryExp,rBox);           

			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
            while ( ls.next() ){ 
                dbox = ls.getDataBox();
                if(ls.getInt("raw_lv") < 2){
	                tot_ea += ls.getFloat("ea");
	                tot_item_weight += (ls.getFloat("ea") * ls.getFloat("item_weight"));
	                if(p_item_type_cd.equals("PI")){
	                	if(ls.getString("attr6").equals("F")){
	                		tot_f += 1;
	                	}else if(ls.getString("attr6").equals("A")){
	                		tot_a += 1;
	                	}else if(ls.getString("attr6").equals("P")){
	                		tot_p += 1;
	                	}
	                }
                }
                list.add(dbox);
            }
            DecimalFormat format = new DecimalFormat("#.##");
            
            rBox.put("tot_ea", format.format(tot_ea));
            rBox.put("tot_item_weight", format.format(tot_item_weight));
            rBox.put("tot_f", Integer.toString(tot_f));
            rBox.put("tot_a", Integer.toString(tot_a));
            rBox.put("tot_p", Integer.toString(tot_p));
            
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
		String p_strflag = box.getString("p_strflag");
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
		String p_upperaction = box.getString("p_upperaction");
		String p_bom_item_detail = box.getString("p_bom_item_detail");
		String p_key_no = box.getString("p_key_no");
		String p_iseco = box.getString("p_iseco");
		
		String p_isexcel = box.getString("p_isexcel");
		
		//Paging ó��  ���� S
		int p_nowpage = box.getInt("p_nowpage");
		int p_printrow = box.getInt("p_printrow");
		
		int StartNum = (p_nowpage-1) * p_printrow;
		int EndNum = ((p_nowpage-1) * p_printrow) + p_printrow;
		//Paging ó��  ���� E
		
		//���� �ڸ� ũ�� ���� : 20 byte 
		String vSubStrCnt = "20";
		
		try
		{
			if(qryExp.equals("mainList")){
				String mainTable = "";
				String isHistory = "N";
				if(p_selrev.equals("Final") || p_selrev.equals("")){
					mainTable = "STX_DIS_SSC_HEAD";
					isHistory = "N";
				}else{
					mainTable = "STX_DIS_SSC_HEAD_HISTORY";
					isHistory = "Y";
				}
				
				
				//Excel ����̸� ��� ���. - Paging ��� ���
				if(!p_isexcel.equals("Y")){
					query.append("SELECT * FROM ( \n");
					query.append("SELECT ROWNUM AS RNUM, XX.* FROM ( \n");
				}
				
				if(isHistory.equals("Y")){
					query.append("SELECT * FROM ( \n");
				}
				
				query.append("     SELECT COUNT(*) OVER () AS PD_CNT, ZZ.*  FROM ( \n");
				if(p_rawmaterial.equals("") && !p_item_type_cd.equals("VA")&& !p_item_type_cd.equals("GE") && !p_item_type_cd.equals("OU")){
					
					query.append("SELECT \n");
					query.append("  A.STATE_FLAG \n");
					query.append(", A.MASTER_SHIP \n");
					query.append(", A.PROJECT_NO \n");
					query.append(", G.DWG_NO \n");
					query.append(", G.BLOCK_NO \n");
					query.append(", G.STR_FLAG \n");
					query.append(", G.STAGE_NO \n");
					query.append(", A.MOTHER_CODE \n");
					query.append(", A.ITEM_CODE \n");
					query.append(", A.BOM2 \n");
					query.append(", A.BOM7 \n");
					query.append(", C.ITEM_CATALOG \n");
					//TR�� ��� ǥ��ǰ ��ǥ��ǰ�� �Ӽ����� ��ġ�� CATALOG �Ŵ����� ������ ���ͼ� ����.
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
						query.append("           , '', C.ITEM_MATERIAL1 \n");
						query.append("   ) AS TR_MATERIAL \n");
						query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) <> 'Z' \n");
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
						query.append("        ELSE PAINT_CODE1 \n");
						query.append("  END AS TR_PAINT \n");
						query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN A.BOM2 \n");
						query.append("       ELSE C.ATTR1 \n");
						query.append("  END AS TR_TRAYNO \n");
//						query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) <> 'Z' \n");
//						query.append("       THEN C.ITEM_OLDCODE \n");
//						query.append("       ELSE C.ITEM_DESC_DETAIL \n");
//						query.append("  END AS TR_DESCRIPTION \n");
						
						
					//SE�� ��� ǥ��ǰ ��ǥ��ǰ�� �Ӽ����� ��ġ�� CATALOG �Ŵ����� ������ ���ͼ� ����.
					}else if(p_item_type_cd.equals("SE")){
						query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN A.BOM2 \n");
						query.append("       ELSE C.ATTR1 \n");
						query.append("  END AS SE_SEATNO \n");
						query.append(" ,DECODE(( SELECT CASE \n");
						query.append("                      WHEN SUBSTR(ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(ATTRIBUTE_CODE, 0) \n");
						query.append("                      ELSE ATTRIBUTE_CODE \n");
						query.append("                      END ATTRBUTE_CODE \n");
						query.append("             FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" \n");
						query.append("            WHERE ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("              AND CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("              AND (ATTRIBUTE_NAME = 'MATERIAL' OR ATTRIBUTE_NAME = 'MATERIAL1' OR ATTRIBUTE_NAME = 'MATERIAL2') \n");
						query.append("              AND ROWNUM = 1 \n");
						query.append("          ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("           , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("           , '', C.ITEM_MATERIAL1 ) \n");
						query.append("  AS SE_MATERIAL \n");
						query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) <> 'Z' \n");
						query.append("       THEN \n");
						query.append("            DECODE((SELECT CASE \n");
						query.append("                           WHEN SUBSTR(A.ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(A.ATTRIBUTE_CODE, 0) \n");
						query.append("                           ELSE A.ATTRIBUTE_CODE \n");
						query.append("                           END ATTRBUTE_CODE \n");
						query.append("                      FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" A \n");
						query.append("                     WHERE A.ATTRIBUTE_TYPE = 'ITEM' \n");
						query.append("                       AND A.CATALOG_CODE = C.ITEM_CATALOG \n");
						query.append("                       AND A.ATTRIBUTE_NAME = 'TYPE' \n");
						query.append("                    ), '1', C.ATTR1, '2', C.ATTR2, '3', C.ATTR3, '4', C.ATTR4, '5', C.ATTR5, '6', C.ATTR6, '7', C.ATTR7, '8', C.ATTR8 \n");
						query.append("                     , '9', C.ATTR9, '10', C.ATTR10, '11', C.ATTR11, '12', C.ATTR12, '13', C.ATTR13, '14', C.ATTR14, '15', C.ATTR15 \n");
						query.append("                     , '' )\n");
						query.append("        ELSE C.ATTR2 \n");
						query.append("  END AS SE_TYPE \n");
						query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) <> 'Z' \n");
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
						query.append("        ELSE PAINT_CODE1 \n");
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
					query.append(", CASE WHEN SUBSTR(A.ITEM_CODE,0,1) = 'Z' THEN 'N' ELSE 'Y' END AS ISSTANDARD \n");
					query.append(", C.ITEM_DESC \n");				
					query.append(", C.ITEM_DESC_DETAIL \n");
					query.append(", CASE WHEN LENGTH(C.ITEM_DESC) > "+vSubStrCnt+" THEN SUBSTR(C.ITEM_DESC,0,"+vSubStrCnt+") || '...' ELSE C.ITEM_DESC END AS ITEM_DESC_SUBSTR \n");
					query.append(", C.ITEM_OLDCODE \n");
					query.append(", A.SSC_SUB_ID \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '10') AS COLUMN10 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '20') AS COLUMN20 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '30') AS COLUMN30 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '40') AS COLUMN40 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '50') AS COLUMN50 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '60') AS COLUMN60 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '70') AS COLUMN70 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '80') AS COLUMN80 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '90') AS COLUMN90 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '100') AS COLUMN100 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '110') AS COLUMN110 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '120') AS COLUMN120 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '130') AS COLUMN130 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '140') AS COLUMN140 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '150') AS COLUMN150 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '160') AS COLUMN160 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '170') AS COLUMN170 \n");
					query.append(", TO_CHAR(A.BOM_QTY) AS EA \n");
					query.append(", C.ITEM_WEIGHT \n");
					query.append(", A.REV_NO \n");
					query.append(", C.PAINT_CODE1 \n");
					query.append(", C.PAINT_CODE2 \n");
					query.append(", A.PAINT_CODE3 \n");
					query.append(", A.PAINT_CODE4 \n");
					query.append(", A.PAINT_CODE5 \n");
					query.append(", A.DEPT_NAME \n");
					query.append(", A.DEPT_CODE \n");
					query.append(", A.USER_NAME \n");
					query.append(", A.USER_ID \n");
					query.append(", A.RAW_LV \n");
					query.append(", TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE  \n");
					query.append(", A.ECO_NO \n");
					query.append(", TO_CHAR(E.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE  \n");
					query.append(", STX_DIS_GET_DWG_YN_F(A.PROJECT_NO, A.DWG_NO, A.ITEM_CODE) AS DWG_CHECK \n");
					query.append(", A.REMARK \n");
					query.append(", A.ITEM_TYPE_CD \n");
					query.append(", A.BOM_ITEM_DETAIL \n");
					query.append(", A.JOB \n");
					query.append(", STX_DIS_SUPPLM_QUERY_FUNC(A.PROJECT_NO,A.JOB, A.ITEM_CODE) AS AFTER_INFO \n");
					if(!isHistory.equals("Y")){
						query.append(", CASE WHEN G.USC_CHG_FLAG = 'Y' AND (G.USC_CHG_DATE > A.UPP_CONFIRM_DATE OR A.UPP_CONFIRM_DATE IS NULL)  \n");
						query.append("       THEN 'Y'    \n");
						query.append("       ELSE 'N'    \n");
						query.append("   END AS ISUSCCHG    \n");	
					}
					query.append(", '"+isHistory+"' AS ISHISTORY \n");
					if(isHistory.equals("Y")){
						query.append(", ROW_NUMBER() OVER (PARTITION BY A.SSC_SUB_ID, A.REV_NO ORDER BY A.HISTORY_UPDATE_DATE DESC) AS HIST_CNT \n");
					}
					query.append("FROM "+mainTable+" A \n");
					query.append("INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
					query.append("INNER JOIN STX_DIS_PENDING G ON A.MOTHER_CODE = G.MOTHER_CODE \n");
					query.append("LEFT JOIN STX_DIS_ECO_V E ON A.ECO_NO = E.ECO_NO \n");
					query.append("WHERE 1=1 \n");
					query.append("AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
					if(isHistory.equals("Y")){
						query.append("AND A.ECO_NO IS NOT NULL \n");
					}
					
					
				//rawMeterial
				}else{
					query.append("          SELECT A.STATE_FLAG \n");
					query.append("               , A.MASTER_SHIP \n");
					query.append("               , A.PROJECT_NO \n");
					query.append("               , A.DWG_NO \n");
					query.append("               , G.BLOCK_NO \n");
					query.append("               , G.STR_FLAG \n");
					query.append("               , G.STAGE_NO \n");
					query.append("               , A.MOTHER_CODE \n");
					query.append("               , A.ITEM_CODE \n");
					query.append("               , A.ITEM_CODE AS LAW_CODE \n");
					query.append("				 , A.BOM7 \n");
					query.append("               , ROW_NUMBER() OVER(PARTITION BY A.KEY_NO, G.BLOCK_NO, G.STAGE_NO ORDER BY A.KEY_NO, G.BLOCK_NO, G.STAGE_NO, A.RAW_LV) AS CHILD_NUM \n");
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
					query.append("               , CASE WHEN SUBSTR(A.ITEM_CODE,0,1) = 'Z' THEN 'N' ELSE 'Y' END AS ISSTANDARD \n");
					query.append("               , C.ITEM_DESC \n");
					query.append("               , C.ITEM_DESC_DETAIL \n");
					query.append("               , CASE WHEN LENGTH(C.ITEM_DESC) > "+vSubStrCnt+" THEN SUBSTR(C.ITEM_DESC,0,"+vSubStrCnt+") || '...' ELSE C.ITEM_DESC END AS ITEM_DESC_SUBSTR \n");
					query.append("               , C.ITEM_OLDCODE \n");
					query.append("               , A.KEY_NO \n");
					query.append("				 , A.SSC_SUB_ID \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '10') AS COLUMN10 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '20') AS COLUMN20 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '30') AS COLUMN30 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '40') AS COLUMN40 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '50') AS COLUMN50 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '60') AS COLUMN60 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '70') AS COLUMN70 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '80') AS COLUMN80 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '90') AS COLUMN90 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '100') AS COLUMN100 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '110') AS COLUMN110 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '120') AS COLUMN120 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '130') AS COLUMN130 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '140') AS COLUMN140 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '150') AS COLUMN150 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '160') AS COLUMN160 \n");
					query.append(", (SELECT ELEMENT_VALUE FROM STX_DIS_SSC_SUB STSS WHERE STSS.SSC_SUB_ID = A.SSC_SUB_ID AND STSS.ELEMENT_SEQUENCE = '170') AS COLUMN170 \n");
					query.append("               , TO_CHAR(A.BOM_QTY) AS EA \n");
					query.append("               , C.ITEM_WEIGHT \n");
					query.append("               , A.REV_NO \n");
					query.append("               , C.PAINT_CODE1 \n");
					query.append("               , C.PAINT_CODE2 \n");
					query.append("               , A.PAINT_CODE3 \n");
					query.append("               , A.PAINT_CODE4 \n");
					query.append("               , A.PAINT_CODE5 \n");
					query.append("               , A.DEPT_NAME \n");
					query.append("               , A.DEPT_CODE \n");
					query.append("               , A.USER_NAME \n");
					query.append("               , A.USER_ID \n");
					query.append("               , A.RAW_LV \n");
					query.append("               , TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
					query.append("               , A.ECO_NO \n");
					query.append("               , TO_CHAR(E.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE \n");
					query.append("               , STX_DIS_GET_DWG_YN_F(A.PROJECT_NO, A.DWG_NO, A.ITEM_CODE) AS DWG_CHECK \n");
					query.append("               , A.REMARK \n");
					query.append("               , A.ITEM_TYPE_CD \n");
					query.append("				 , A.BOM_ITEM_DETAIL \n");
					query.append("				 , A.JOB \n");
					query.append("			     , A.BLOCK_DIV \n");
					query.append("               , STX_DIS_SUPPLM_QUERY_FUNC(A.PROJECT_NO,A.JOB, A.ITEM_CODE) AS AFTER_INFO\n");
					if(!isHistory.equals("Y")){
						query.append(", CASE WHEN G.USC_CHG_FLAG = 'Y' AND (G.USC_CHG_DATE > A.UPP_CONFIRM_DATE OR A.UPP_CONFIRM_DATE IS NULL)  \n");
						query.append("       THEN 'Y'    \n");
						query.append("       ELSE 'N'    \n");
						query.append("   END AS ISUSCCHG    \n");	
					}
					query.append("				 , '"+isHistory+"' AS ISHISTORY \n");
					query.append("               , 1  AS ORDER_BY \n");
					if(isHistory.equals("Y")){
						query.append(", ROW_NUMBER() OVER (PARTITION BY A.SSC_SUB_ID, A.REV_NO ORDER BY A.HISTORY_UPDATE_DATE DESC) AS HIST_CNT \n");
					}
					query.append("FROM "+mainTable+" A \n");
					query.append("INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
					query.append("INNER JOIN STX_DIS_PENDING G ON A.MOTHER_CODE = G.MOTHER_CODE \n");
					query.append("LEFT JOIN STX_DIS_ECO_V E ON A.ECO_NO = E.ECO_NO \n");
					query.append("WHERE 1=1 \n");
					query.append("AND A.ITEM_TYPE_CD = '"+p_item_type_cd+"' \n");
					if(isHistory.equals("Y")){
						query.append("AND A.ECO_NO IS NOT NULL \n");
					}
				}
				if(!p_project.equals("")){
					p_project = p_project.replaceAll("[*]","%");
					if(p_ship.equals("master")){
						query.append("AND A.MASTER_SHIP LIKE '"+p_project+"' \n");	
					}else{
						query.append("AND A.PROJECT_NO LIKE '"+p_project+"' \n");
					}
				}
				if(!p_dwgno.equals("")){
					p_dwgno = p_dwgno.replaceAll("[*]","%");
					query.append("AND A.DWG_NO LIKE '"+p_dwgno+"' \n");
				}
				if(!p_blockno.equals("")){
					p_blockno = p_blockno.replaceAll("[*]","%");
					query.append("AND G.BLOCK_NO LIKE '"+p_blockno+"' \n");
				}
				if(!p_stageno.equals("")){
					p_stageno = p_stageno.replaceAll("[*]","%");
					query.append("AND G.STAGE_NO LIKE '"+p_stageno+"' \n");
				}
				if(!p_strflag.equals("")){
					p_strflag = p_strflag.replaceAll("[*]","%");
					query.append("AND G.STR_FLAG LIKE '"+p_strflag+"' \n");
				}
				if(!p_description.equals("")){
					p_description = p_description.replaceAll("[*]","%");
					query.append("AND C.ITEM_DESC LIKE '"+p_description+"' \n");
				}
				if(!p_desc_detail.equals("")){
					p_desc_detail = p_desc_detail.replaceAll("[*]","%");
					query.append("AND C.ITEM_DESC_DETAIL LIKE '"+p_desc_detail+"' \n");
				}
				if(!p_mothercode.equals("")){
					p_mothercode = p_mothercode.replaceAll("[*]","%");
					query.append("AND A.MOTHER_CODE LIKE '"+p_mothercode+"' \n");
				}
				if(!p_itemcode.equals("")){
					p_itemcode = p_itemcode.replaceAll("[*]","%");
					query.append("AND A.ITEM_CODE LIKE '"+p_itemcode+"' \n");
				}
				
				if(!p_state.equals("ALL") && !p_state.equals("") && !p_state.equals("Act") ){
					query.append("AND A.STATE_FLAG LIKE '"+p_state+"' \n");
				}
				
				if(p_state.equals("Act") ){
					query.append("AND (A.ECO_NO IS NULL) \n");
				}
				
				if(!p_bom2.equals("")){
					p_bom2 = p_bom2.replaceAll("[*]","%");
					query.append("AND A.BOM2 LIKE '"+p_bom2+"' \n");
				}
				if(!p_attr1.equals("")){
					p_attr1 = p_attr1.replaceAll("[*]","%");
					query.append("AND C.ATTR1 LIKE '"+p_attr1+"' \n");
				}
				
				if(!p_attr2.equals("")){
					p_attr2 = p_attr2.replaceAll("[*]","%");
					query.append("AND C.ATTR2 LIKE '"+p_attr2+"' \n");
				}
				if(!p_attr3.equals("")){
					p_attr3 = p_attr3.replaceAll("[*]","%");
					query.append("AND C.ATTR3 LIKE '"+p_attr3+"' \n");
				}
				if(!p_attr4.equals("")){
					p_attr4 = p_attr4.replaceAll("[*]","%");
					query.append("AND C.ATTR4 LIKE '"+p_attr4+"' \n");
				}
				if(!p_attr5.equals("")){
					p_attr5 = p_attr5.replaceAll("[*]","%");
					query.append("AND C.ATTR5 LIKE '"+p_attr5+"' \n");
				}
				if(!p_attr6.equals("")){
					p_attr6 = p_attr6.replaceAll("[*]","%");
					query.append("AND C.ATTR6 LIKE '"+p_attr6+"' \n");
				}
				if(!p_attr7.equals("")){
					p_attr7 = p_attr7.replaceAll("[*]","%");
					query.append("AND C.ATTR7 LIKE '"+p_attr7+"' \n");
				}
				if(!p_attr8.equals("")){
					p_attr8 = p_attr8.replaceAll("[*]","%");
					query.append("AND C.ATTR8 LIKE '"+p_attr8+"' \n");
				}
				if(!p_attr9.equals("")){
					p_attr9 = p_attr9.replaceAll("[*]","%");
					query.append("AND C.ATTR9 LIKE '"+p_attr9+"' \n");
				}
				if(!p_attr10.equals("")){
					p_attr10 = p_attr10.replaceAll("[*]","%");
					query.append("AND C.ATTR10 LIKE '"+p_attr10+"' \n");
				}
				if(!p_attr11.equals("")){
					p_attr11 = p_attr11.replaceAll("[*]","%");
					query.append("AND C.ATTR11 LIKE '"+p_attr11+"' \n");
				}
				if(!p_attr12.equals("")){
					p_attr12 = p_attr12.replaceAll("[*]","%");
					query.append("AND C.ATTR12 LIKE '"+p_attr12+"' \n");
				}
				if(!p_attr13.equals("")){
					p_attr13 = p_attr13.replaceAll("[*]","%");
					query.append("AND C.ATTR13 LIKE '"+p_attr13+"' \n");
				}
				if(!p_attr14.equals("")){
					p_attr14 = p_attr14.replaceAll("[*]","%");
					query.append("AND C.ATTR14 LIKE '"+p_attr14+"' \n");
				}
				if(!p_attr15.equals("")){
					p_attr15 = p_attr15.replaceAll("[*]","%");
					query.append("AND C.ATTR15 LIKE '"+p_attr15+"' \n");
				}
				
				if(!p_bom_item_detail.equals("")){
					p_bom_item_detail = p_bom_item_detail.replaceAll("[*]","%");
					query.append("AND A.BOM_ITEM_DETAIL LIKE '"+p_bom_item_detail+"' \n");
				}
				
				if(!p_econo.equals("")){
					p_econo = p_econo.replaceAll("[*]","%");
					query.append("AND A.ECO_NO LIKE '"+p_econo+"' \n");
				}
				if(!p_selrev.equals("Final") && !p_selrev.equals("")){
					query.append("AND A.REV_NO LIKE '"+p_selrev+"' \n");
				}
				
				if(!p_release.equals("ALL") && !p_selrev.equals("")){
					if(p_release.equals("Y")){
						query.append("AND E.RELEASE_DATE IS NOT NULL \n");
					}else{
						query.append("AND E.RELEASE_DATE IS NULL \n");
					}
				}
				if(!p_upperaction.equals("ALL") && !p_upperaction.equals("")){
					if(p_upperaction.equals("Y")){ 
						query.append("AND G.USC_CHG_FLAG = 'Y' AND (G.USC_CHG_DATE > A.UPP_CONFIRM_DATE OR A.UPP_CONFIRM_DATE IS NULL) \n");
					}else if(p_upperaction.equals("N")){
						query.append("AND (G.USC_CHG_FLAG IS NULL OR G.USC_CHG_FLAG = 'N' OR (G.USC_CHG_FLAG = 'Y' AND G.USC_CHG_DATE < A.UPP_CONFIRM_DATE)) \n");
					}
				}
				if(!p_key_no.equals("")){
					p_key_no = p_key_no.replaceAll("[*]","%");
					query.append("AND A.KEY_NO LIKE '"+p_key_no+"' \n");
				}
				
				if(!p_iseco.equals("ALL") && !p_iseco.equals("")){
					if(p_iseco.equals("Y")){
						query.append("AND A.ECO_NO IS NOT NULL \n");
					}else{
						query.append("AND A.ECO_NO IS NULL \n");
					}
				}
				
				
				if(p_rawmaterial.equals("") && !p_item_type_cd.equals("VA") && !p_item_type_cd.equals("GE") && !p_item_type_cd.equals("OU")){
					query.append(") ZZ \n");
					query.append("ORDER BY PROJECT_NO ,BLOCK_NO, STAGE_NO, STR_FLAG, ITEM_CODE ");
					if(p_item_type_cd.equals("SU")){
						query.append(", ATTR5 ");
					}
				//Pipe Piece Raw Meterail ������ Tribon���� �޾ƿ´�.
				}else if(!p_rawmaterial.equals("") && p_item_type_cd.equals("PI")){
					
					query.append("           UNION ALL \n");
					query.append("           SELECT DISTINCT '' AS STATE_FLAG \n");
					query.append("                 , A.MASTER_SHIP\n");
					query.append("                 , A.PROJECT_NO \n");
					query.append("                 , A.DWG_NO \n");
					query.append("                 , G.BLOCK_NO \n");
					query.append("                 , G.STR_FLAG \n");
					query.append("                 , G.STAGE_NO \n");
					query.append("                 , AA.PIECE_ITEMCODE AS MOTHER_CODE\n");
					query.append("                 , AA.RAW_ITEMCODE AS ITEM_CODE\n");
					query.append("                 , AA.PIECE_ITEMCODE AS LAW_CODE \n");
					query.append("				   , '' AS BOM7 \n");
					query.append("                 , 0 AS CHILD_NUM  \n");
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
					query.append("                 , CASE WHEN SUBSTR(C.ITEM_CODE,0,1) = 'Z' THEN 'N' ELSE 'Y' END AS ISSTANDARD \n");
					query.append("                 , C.ITEM_DESC \n");
					query.append("                 , C.ITEM_DESC_DETAIL \n");
					query.append("                 , CASE WHEN LENGTH(C.ITEM_DESC) > "+vSubStrCnt+" THEN SUBSTR(C.ITEM_DESC,0,"+vSubStrCnt+") || '...' ELSE C.ITEM_DESC END AS ITEM_DESC_SUBSTR \n");
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
					query.append("                 , TO_CHAR(AA.RAW_QTY) AS EA \n");
					query.append("                 , AA.UNIT_WEIGHT AS ITEM_WEIGHT \n");
					query.append("                 , '' AS REV_NO \n");
					query.append("                 , '' AS PAINT_CODE1 \n");
					query.append("                 , '' AS PAINT_CODE2 \n");
					query.append("                 , '' AS PAINT_CODE3 \n");
					query.append("                 , '' AS PAINT_CODE4 \n");
					query.append("                 , '' AS PAINT_CODE5 \n");
					//query.append("                 , '' AS DEPT_NAME \n");
					query.append("                 , (SELECT DDDC.DWGDEPTNM \n");
					query.append("						FROM STX_COM_INSA_USER@"+ERP_DB+" SCIU \n"); 
					query.append("			      INNER JOIN DCC_DEPTCODE@"+DP_DB+" DDC ON SCIU.DEPT_CODE = DDC.DEPTCODE \n"); 
					query.append("                INNER JOIN DCC_DWGDEPTCODE@"+DP_DB+" DDDC ON DDC.DWGDEPTCODE = DDDC.DWGDEPTCODE \n"); 
					query.append("                     WHERE SCIU.EMP_NO = C.USER_ID) AS DEPT_NAME \n");
					query.append("                 , '' AS DEPT_CODE \n");
					query.append("                 , C.USER_NAME AS USER_NAME \n");
					query.append("                 , C.USER_ID AS USER_ID \n");
					query.append("                 , 2 AS RAW_LV \n");
					query.append("                 , TO_CHAR(C.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
					query.append("                 , '' AS ECO_NO \n");
					query.append("                 , '' AS RELEASE_DATE \n");
					query.append("                 , '' AS DWG_CHECK \n");
					query.append("                 , '' AS REMARK \n");
					query.append("                 , '' AS ITEM_TYPE_CD \n");
					query.append("				   , '' AS BOM_ITEM_DETAIL \n");
					query.append("				   , '' AS JOB \n");
					query.append("				   , '' AS BLOCK_DIV \n");
					query.append("				   , '' AS AFTER_INFO \n");
					if(!isHistory.equals("Y")){
						query.append("                 , 'N'  AS ISUSCCHG \n");
					}
					query.append("                 , 'N' AS ISHISTORY \n");
					query.append("                 , 2  AS ORDER_BY \n");
					
					if(isHistory.equals("Y")){
						query.append("             , 1 AS HIST_CNT \n");
					}
					query.append("             FROM PIPE_RAW_MATERIALS@"+TRIBON_DB+" AA \n");
					query.append("                 ,"+mainTable+" A \n");
					query.append("                 ,STX_DIS_ITEM C \n");
					query.append("                 ,STX_DIS_ITEM D \n");
					query.append("                 ,STX_DIS_PENDING G \n");
					query.append("            WHERE A.ITEM_CODE     = AA.PIECE_ITEMCODE \n");
					query.append("              AND AA.RAW_ITEMCODE    = C.ITEM_CODE \n");
					query.append("              AND AA.PIECE_ITEMCODE  = D.ITEM_CODE \n");
					query.append("              AND A.MOTHER_CODE   = G.MOTHER_CODE \n");					
					query.append("              AND A.ITEM_TYPE_CD  = '"+p_item_type_cd+"' \n");
					query.append("              AND AA.SHIP_NO   = A.MASTER_SHIP \n");
					if(isHistory.equals("Y")){
						query.append("AND A.ECO_NO IS NOT NULL \n");
					}
					if(p_ship.equals("master")){
						if(!p_project.equals("")){
							p_project = p_project.replaceAll("[*]","%");
							query.append("AND A.MASTER_SHIP LIKE '"+p_project+"' ");
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
						query.append("AND G.BLOCK_NO LIKE '"+p_blockno+"' ");
					}
					if(!p_stageno.equals("")){
						p_stageno = p_stageno.replaceAll("[*]","%");
						query.append("AND G.STAGE_NO LIKE '"+p_stageno+"' ");
					}
					if(!p_strflag.equals("")){
						p_strflag = p_strflag.replaceAll("[*]","%");
						query.append("AND G.STR_FLAG LIKE '"+p_strflag+"' \n");
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
					if(!p_bom_item_detail.equals("")){
						p_bom_item_detail = p_bom_item_detail.replaceAll("[*]","%");
						query.append("AND A.BOM_ITEM_DETAIL LIKE '"+p_bom_item_detail+"' ");
					}
					if(!p_econo.equals("")){
						p_econo = p_econo.replaceAll("[*]","%");
						query.append("AND A.ECO_NO LIKE '"+p_econo+"' ");
					}
					if(!p_selrev.equals("Final") && !p_selrev.equals("")){
						query.append("AND A.REV_NO LIKE '"+p_selrev+"' ");
					}
					
					if(!p_key_no.equals("")){
						p_key_no = p_key_no.replaceAll("[*]","%");
						query.append("AND A.KEY_NO LIKE '"+p_key_no+"' \n");
					}
					
					query.append("       ) ZZ \n");
					query.append("  ORDER BY PROJECT_NO, BLOCK_NO, STAGE_NO, STR_FLAG, LAW_CODE, ORDER_BY, CHILD_NUM  \n");
					
				//�� �� Raw Material ���� 
				}else{
					
					query.append("           UNION ALL \n");
					query.append("           SELECT DISTINCT AA.STATE_FLAG \n");
					query.append("                 , A.MASTER_SHIP\n");
					query.append("                 , A.PROJECT_NO \n");
					query.append("                 , A.DWG_NO \n");
					query.append("                 , G.BLOCK_NO \n");
					query.append("                 , G.STR_FLAG \n");
					query.append("                 , G.STAGE_NO \n");
					query.append("                 , AA.MOTHER_CODE \n");
					query.append("                 , AA.ITEM_CODE \n");
					query.append("                 , AA.MOTHER_CODE AS LAW_CODE \n");
					query.append("				   , AA.BOM7 AS BOM7 \n");
					query.append("                 , 0 AS CHILD_NUM  \n");
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
					query.append("				   , CASE WHEN SUBSTR(C.ITEM_CODE,0,1) = 'Z' THEN 'N' ELSE 'Y' END AS ISSTANDARD \n");
					query.append("                 , C.ITEM_DESC \n");
					query.append("                 , C.ITEM_DESC_DETAIL \n");
					query.append("                 , CASE WHEN LENGTH(C.ITEM_DESC) > "+vSubStrCnt+" THEN SUBSTR(C.ITEM_DESC,0,"+vSubStrCnt+") || '...' ELSE C.ITEM_DESC END AS ITEM_DESC_SUBSTR \n");
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
					query.append("                 , AA.COAT_IN AS COLUMN100 \n");
					query.append("                 , AA.COAT_OUT AS COLUMN110 \n");
					query.append("                 , AA.LETTER_NAMEPLATE AS COLUMN120 \n");
					query.append("                 , AA.TYPE1 AS COLUMN130 \n");
					query.append("                 , AA.TYPE2 AS COLUMN140 \n");
					query.append("                 , AA.POSITION AS COLUMN150 \n");
					query.append("                 , '' AS COLUMN160 \n");
					query.append("                 , '' AS COLUMN170 \n");
					query.append("                 , TO_CHAR(AA.BOM_QTY) AS EA \n");
					query.append("                 , C.ITEM_WEIGHT \n");
					query.append("                 , A.REV_NO \n");
					query.append("                 , C.PAINT_CODE1 AS PAINT_CODE1 \n");
					query.append("                 , C.PAINT_CODE2 AS PAINT_CODE2 \n");
					query.append("                 , '' AS PAINT_CODE3 \n");
					query.append("                 , '' AS PAINT_CODE4 \n");
					query.append("                 , '' AS PAINT_CODE5 \n");
					//query.append("                 , '' AS DEPT_NAME \n");
					query.append("                 , (SELECT DDDC.DWGDEPTNM \n");
					query.append("						FROM STX_COM_INSA_USER@"+ERP_DB+" SCIU \n"); 
					query.append("			      INNER JOIN DCC_DEPTCODE@"+DP_DB+" DDC ON SCIU.DEPT_CODE = DDC.DEPTCODE \n"); 
					query.append("                INNER JOIN DCC_DWGDEPTCODE@"+DP_DB+" DDDC ON DDC.DWGDEPTCODE = DDDC.DWGDEPTCODE \n"); 
					query.append("                     WHERE SCIU.EMP_NO = AA.USER_ID) AS DEPT_NAME \n");
					query.append("                 , '' AS DEPT_CODE \n");
					query.append("                 , AA.USER_NAME AS USER_NAME \n");
					query.append("                 , AA.USER_ID AS USER_ID \n");
					query.append("                 , 2 AS RAW_LV \n");
					query.append("                 , TO_CHAR(AA.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
					query.append("                 , AA.ECO_NO AS ECO_NO \n");
					query.append("                 , TO_CHAR(H.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE \n");
					query.append("                 , '' AS DWG_CHECK \n");
					query.append("                 , AA.REMARK AS REMARK \n");
					query.append("                 , '' AS ITEM_TYPE_CD \n");
					query.append("				   , AA.BOM_ITEM_DETAIL AS BOM_ITEM_DETAIL \n");
					query.append("				   , A.JOB \n");
					query.append("				   , A.BLOCK_DIV \n");
					query.append("                 , STX_DIS_SUPPLM_QUERY_FUNC(A.PROJECT_NO,A.JOB, A.ITEM_CODE) AS AFTER_INFO\n");
					if(!isHistory.equals("Y")){
						query.append("                 , 'N'  AS ISUSCCHG \n");
					}
					query.append("                 , 'N' AS ISHISTORY \n");
					query.append("                 , 2  AS ORDER_BY \n");
					
					if(isHistory.equals("Y")){
						query.append("             , 1 AS HIST_CNT \n");
					}
					query.append("             FROM STX_DIS_RAWLEVEL AA \n");
					query.append("                 ,"+mainTable+" A \n");
					query.append("                 ,STX_DIS_ITEM C \n");
					query.append("                 ,STX_DIS_ITEM D \n");
					query.append("                 ,STX_DIS_PENDING G \n");
					query.append("                 ,STX_DIS_ECO_V H \n");
					query.append("            WHERE A.ITEM_CODE     = AA.MOTHER_CODE \n");
					query.append("              AND AA.ITEM_CODE    = C.ITEM_CODE \n");
					query.append("              AND AA.MOTHER_CODE  = D.ITEM_CODE \n");
					query.append("              AND A.MOTHER_CODE   = G.MOTHER_CODE \n");
					query.append("              AND AA.ECO_NO   	= H.ECO_NO(+) \n");					
					query.append("              AND A.ITEM_TYPE_CD  = '"+p_item_type_cd+"' \n");
					
					if(p_item_type_cd.equals("GE") || p_item_type_cd.equals("OU")){
						query.append("              AND AA.TYPE = 'BUYBUY' \n");
//						query.append("              AND ((AA.ECO_NO IS NULL AND AA.STATE_FLAG = 'D') OR (AA.ECO_NO IS NOT NULL AND AA.STATE_FLAG = 'A')) \n");
					}
					
					if(isHistory.equals("Y")){
						query.append("AND A.ECO_NO IS NOT NULL \n");
					}
					if(p_ship.equals("master")){
						if(!p_project.equals("")){
							p_project = p_project.replaceAll("[*]","%");
							query.append("AND A.MASTER_SHIP LIKE '"+p_project+"' ");
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
						query.append("AND G.BLOCK_NO LIKE '"+p_blockno+"' ");
					}
					if(!p_stageno.equals("")){
						p_stageno = p_stageno.replaceAll("[*]","%");
						query.append("AND G.STAGE_NO LIKE '"+p_stageno+"' ");
					}

					if(!p_strflag.equals("")){
						p_strflag = p_strflag.replaceAll("[*]","%");
						query.append("AND G.STR_FLAG LIKE '"+p_strflag+"' \n");
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
					if(!p_bom_item_detail.equals("")){
						p_bom_item_detail = p_bom_item_detail.replaceAll("[*]","%");
						query.append("AND A.BOM_ITEM_DETAIL LIKE '"+p_bom_item_detail+"' ");
					}
					if(!p_econo.equals("")){
						p_econo = p_econo.replaceAll("[*]","%");
						query.append("AND A.ECO_NO LIKE '"+p_econo+"' ");
					}
					if(!p_selrev.equals("Final") && !p_selrev.equals("")){
						query.append("AND A.REV_NO LIKE '"+p_selrev+"' ");
					}
					
					if(!p_key_no.equals("")){
						p_key_no = p_key_no.replaceAll("[*]","%");
						query.append("AND A.KEY_NO LIKE '"+p_key_no+"' \n");
					}
					
					query.append("       ) ZZ \n");
					query.append("  ORDER BY PROJECT_NO, BLOCK_NO, STAGE_NO, STR_FLAG, LAW_CODE, ORDER_BY, CHILD_NUM  \n");
					
				}
				
				if(isHistory.equals("Y")){
					query.append(") TT WHERE HIST_CNT = 1 \n");
				}
				
				//Excel ����̸� ��� ���. - Paging ��� ���
				if(!p_isexcel.equals("Y")){
					query.append(") XX WHERE ROWNUM <= "+EndNum+" \n");
					query.append(") WHERE RNUM > "+StartNum+" \n");
				}
				
			}
			
			
			System.out.println(query);
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}	
		//System.out.println(query);
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