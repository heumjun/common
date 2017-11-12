package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcItemMasterInterfaceDao implements Idao{
	
	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		
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
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        PreparedStatement 	pstmt3 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	int 				isOk2    = 0;
    	StringBuffer		query   = new StringBuffer();
    	String query2 = "";
    	String query3 = "";
        try 
        {
        	//ITEM Table 삭제 후 추가
        	String itemCode = rBox.getString("p_itemcode");
        	String itemCatalog = rBox.getString("p_itemcatalog");
			String s_itemCode[] = itemCode.split(",");
        	query.append("DELETE STX_TBC_ITEM \n");
        	query.append(" WHERE 1 = 1 \n");
        	if(!itemCode.equals("")){
				query.append("   AND ITEM_CODE IN (  ");
				query.append("select msi.segment1 \n");
				query.append("  from mtl_system_items_b@"+ERP_DB+"         msi \n");
				query.append("      ,mtl_item_catalog_groups_b@"+ERP_DB+"  micg \n");
				query.append("      ,mtl_item_categories@"+ERP_DB+"        mic \n");
				query.append("      ,mtl_categories_b@"+ERP_DB+"           mc \n");
				query.append("      ,stx_com_insa_user@"+ERP_DB+"          sciu \n");
				query.append("      ,bom_inventory_components@"+ERP_DB+"   bic \n");
				query.append("      ,bom_bill_of_materials@"+ERP_DB+"      bbom \n");
				query.append("      ,mtl_system_items_b@"+ERP_DB+"         msi_assy \n");
				query.append("  where msi.organization_id       = msi_assy.organization_id \n");
				query.append("    and msi.item_catalog_group_id = micg.item_catalog_group_id \n");
				query.append("    and msi.organization_id       = mic.organization_id \n");
				query.append("    and msi.inventory_item_id     = mic.inventory_item_id \n");
				query.append("    and mic.category_set_id       = 1 \n");
				query.append("    and mic.category_id           = mc.category_id \n");
				query.append("    and msi.attribute2            = sciu.emp_no(+) \n");
				query.append("    and msi.inventory_item_id     = bic.component_item_id \n");
				query.append("    and bic.bill_sequence_id      = bbom.bill_sequence_id \n");
				query.append("    and bbom.organization_id      = msi_assy.organization_id \n");
				query.append("    and bbom.assembly_item_id     = msi_assy.inventory_item_id \n");
				query.append("    and msi_assy.organization_id  = 82 \n");
				query.append("    and bic.IMPLEMENTATION_DATE       is not null \n");
				query.append("    and bic.DISABLE_DATE              is null \n");
				query.append("    and bbom.ALTERNATE_BOM_DESIGNATOR is null \n");
				
				query.append("    and  ( \n");
					for(int i=0; i < s_itemCode.length; i++  ){
						if(i != 0){
							query.append("         OR ");
						}
						query.append("         msi_assy.segment1 = '"+s_itemCode[i].trim()+"' \n");
					}
					query.append("        ) \n");	
				
				for(int i=0; i < s_itemCode.length; i++  ){
					query.append("UNION ALL SELECT '"+s_itemCode[i].trim()+"' FROM DUAL \n");
				}
				query.append(") \n");
        	}
        	
			if(!itemCatalog.equals("")){
				query.append("    and item_catalog = '"+itemCatalog+"' \n");
			}
			
        	
        	System.out.println(query);
        	//삭제 실행
        	pstmt = conn.prepareStatement(query.toString());
        	isOk = pstmt.executeUpdate();
        	System.out.println("삭제 성공" + isOk);
        	
        	//추가 실행.
        	query2  = getQuery(qryExp,rBox);
        	pstmt2 = conn.prepareStatement(query2.toString());
        	isOk = pstmt2.executeUpdate();
        	System.out.println("추가 성공" + isOk);
        	
        	//RAW ITEM 추가 실행.
        	query3  = getQuery("rawItemInterface",rBox);
        	pstmt3 = conn.prepareStatement(query3.toString());
        	isOk2 = pstmt3.executeUpdate();
        	System.out.println("isOk2 : " + isOk2);        	
        	
        	
        	if(isOk2 > 0){
	        	if(!itemCode.equals("")){
					for(int i=0; i < s_itemCode.length; i++  ){
			        	CallableStatement cs = conn.prepareCall("{call stx_tbc_material_insert@"+PLM_DB+"(?,?,?)}");  
		        	    cs.setString(1,s_itemCode[i].trim());  
		        	    cs.registerOutParameter(2, java.sql.Types.VARCHAR);  
		        	    cs.registerOutParameter(3, java.sql.Types.VARCHAR);  
		        	    cs.execute();
					}
	        	}
        	}
        	
        	
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
        	conn.rollback();
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Fail");
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
            if ( pstmt3 != null ) { try { pstmt3.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}

	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		
		String itemCatalog = box.getString("p_itemcatalog");
		String itemCode = box.getString("p_itemcode");

		String s_itemCode[] = itemCode.split(",");
		
		try {
			
			if(qryExp.equals("itemInterface")){
				
				query.append("INSERT INTO STX_TBC_ITEM \n");
				query.append("( item_code \n");
				query.append(", item_catalog \n");
				query.append(", item_category \n");
				query.append(", item_desc \n");
				query.append(", item_desc_detail \n");
				query.append(", item_weight \n");
				query.append(", attr1 \n");
				query.append(", attr2 \n");
				query.append(", attr3 \n");
				query.append(", attr4 \n");
				query.append(", attr5 \n");
				query.append(", attr6 \n");
				query.append(", attr7 \n");
				query.append(", attr8 \n");
				query.append(", attr9 \n");
				query.append(", attr10 \n");
				query.append(", attr11 \n");
				query.append(", attr12 \n");
				query.append(", attr13 \n");
				query.append(", attr14 \n");
				query.append(", attr15 \n");
				query.append(", item_material1 \n");
				query.append(", item_material2 \n");
				query.append(", item_material3 \n");
				query.append(", item_material4 \n");
				query.append(", item_material5 \n");
				query.append(", paint_code1 \n");
				query.append(", paint_code2 \n");
				query.append(", code_type \n");
				query.append(", uom \n");
				query.append(", ship_pattern \n");
				query.append(", item_oldcode \n");
				query.append(", cable_length \n");
				query.append(", cable_type \n");
				query.append(", cable_outdia \n");
				query.append(", user_id \n");
				query.append(", user_name \n");
				query.append(", create_date ) \n");
				
				
				
				query.append("select aa.part_no \n");
				query.append("      ,aa.item_catalog \n");
				query.append("      ,aa.item_category \n");
				query.append("      ,aa.part_desc \n");
				query.append("      ,'' \n");
				query.append("      ,aa.unit_weight \n");
				query.append("      ,max(case when aa.ele_seq = 1 then aa.element_value else null end) as ele_value_1 \n");
				query.append("      ,max(case when aa.ele_seq = 2 then aa.element_value else null end) as ele_value_2 \n");
				query.append("      ,max(case when aa.ele_seq = 3 then aa.element_value else null end) as ele_value_3 \n");
				query.append("      ,max(case when aa.ele_seq = 4 then aa.element_value else null end) as ele_value_4 \n");
				query.append("      ,max(case when aa.ele_seq = 5 then aa.element_value else null end) as ele_value_5 \n");
				query.append("      ,max(case when aa.ele_seq = 6 then aa.element_value else null end) as ele_value_6 \n");
				query.append("      ,max(case when aa.ele_seq = 7 then aa.element_value else null end) as ele_value_7 \n");
				query.append("      ,max(case when aa.ele_seq = 8 then aa.element_value else null end) as ele_value_8 \n");
				query.append("      ,max(case when aa.ele_seq = 9 then aa.element_value else null end) as ele_value_9 \n");
				query.append("      ,max(case when aa.ele_seq =10 then aa.element_value else null end) as ele_value_10 \n");
				query.append("      ,max(case when aa.ele_seq =11 then aa.element_value else null end) as ele_value_11 \n");
				query.append("      ,max(case when aa.ele_seq =12 then aa.element_value else null end) as ele_value_12 \n");
				query.append("      ,max(case when aa.ele_seq =13 then aa.element_value else null end) as ele_value_13 \n");
				query.append("      ,max(case when aa.ele_seq =14 then aa.element_value else null end) as ele_value_14 \n");
				query.append("      ,max(case when aa.ele_seq =15 then aa.element_value else null end) as ele_value_15 \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				//Paint Code1의 값은 Catalog Manager에서 Paint ATTR이라는 값을 참고해서 몇번 속성의 값인지 판단 후 넣는다. 
				query.append("      , CASE WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 1 \n");
				query.append("             THEN max(case when aa.ele_seq = 1 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 2 \n");
				query.append("             THEN max(case when aa.ele_seq = 2 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 3 \n");
				query.append("             THEN max(case when aa.ele_seq = 3 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 4 \n");
				query.append("             THEN max(case when aa.ele_seq = 4 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 5 \n");
				query.append("             THEN max(case when aa.ele_seq = 5 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 6 \n");
				query.append("             THEN max(case when aa.ele_seq = 6 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 7 \n");
				query.append("             THEN max(case when aa.ele_seq = 7 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 8 \n");
				query.append("             THEN max(case when aa.ele_seq = 8 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 9 \n");
				query.append("             THEN max(case when aa.ele_seq = 9 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 10 \n");
				query.append("             THEN max(case when aa.ele_seq = 10 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 11 \n");
				query.append("             THEN max(case when aa.ele_seq = 11 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 12 \n");
				query.append("             THEN max(case when aa.ele_seq = 12 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 13 \n");
				query.append("             THEN max(case when aa.ele_seq = 13 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 14 \n");
				query.append("             THEN max(case when aa.ele_seq = 14 then aa.element_value else null end) \n");
				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 15 \n");
				query.append("             THEN max(case when aa.ele_seq = 15 then aa.element_value else null end) \n");
				query.append("             ELSE NULL \n");
				query.append("        END AS PAINT_CODE1 \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      ,aa.uom \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      , '' \n");
				query.append("      ,aa.emp_no                                                         as emp_no \n");
				query.append("      ,aa.user_name                                                      as user_name \n");
				query.append("      ,aa.creation_date                                                  as creation_date \n");
				query.append("  from (select /*+ LEADING(MICG)  */ \n");
				query.append("               MSI.SEGMENT1                                           as part_no \n");
				query.append("              ,msi.description                                        as part_desc \n");
				query.append("              ,micg.segment1                                          as item_catalog \n");
				query.append("              ,mc.segment1 ||'.' || mc.segment2 ||'.' || mc.segment3  as item_category \n");
				query.append("              ,msi.primary_uom_code                                   as uom \n");
				query.append("              ,msi.unit_weight                                        as unit_weight \n");
				query.append("              ,RANK() OVER (PARTITION BY MSI.SEGMENT1 ORDER BY  mdev.element_sequence) as ele_seq \n");
				query.append("              ,mdev.element_value                                     as element_value \n");
				query.append("              ,sciu.emp_no                                            as emp_no \n");
				query.append("              ,sciu.user_name                                         as user_name \n");
				query.append("              ,msi.creation_date                                      as creation_date \n");
				query.append("          from mtl_system_items_b@"+ERP_DB+" msi \n");
				query.append("              ,Mtl_Item_Catalog_Groups_b@"+ERP_DB+" micg \n");
				query.append("              ,mtl_item_categories@"+ERP_DB+"       mic \n");
				query.append("              ,mtl_categories_b@"+ERP_DB+"          mc \n");
				query.append("              ,mtl_descr_element_values@"+ERP_DB+"  mdev \n");
				query.append("              ,stx_com_insa_user@"+ERP_DB+"         sciu \n");
				query.append("          where msi.organization_id       = 82 \n");
				
				if(!itemCode.equals("")){
					query.append("        and (  ");
					for(int i=0; i < s_itemCode.length; i++  ){
						if(i != 0){
							query.append("         OR ");
						}
						query.append("         msi.segment1 = '"+s_itemCode[i].trim()+"' \n");
					}
					query.append("        ) \n");
				}
				
				if(!itemCatalog.equals("")){
					query.append("            and micg.segment1 = '"+itemCatalog+"' \n");
				}
				
				
				query.append("            and msi.item_catalog_group_id = micg.item_catalog_group_id \n");
				query.append("            and msi.organization_id       = mic.organization_id \n");
				query.append("            and msi.inventory_item_id     = mic.inventory_item_id \n");
				query.append("            and mic.category_set_id       = 1 \n");
				query.append("            and mic.category_id           = mc.category_id \n");
				query.append("            AND msi.inventory_item_id     = mdev.inventory_item_id(+) \n");
				query.append("            and msi.attribute2            = sciu.emp_no(+) \n");
//				query.append("            and not exists (select 1 from stx_tbc_item sti where msi.segment1 = sti.item_code ) \n");
				query.append("         ) aa \n");
				query.append("group by aa.part_no \n");
				query.append("        ,aa.part_desc \n");
				query.append("        ,aa.item_catalog \n");
				query.append("        ,aa.item_category \n");
				query.append("        ,aa.uom \n");
				query.append("        ,aa.unit_weight \n");
				query.append("        ,aa.emp_no \n");
				query.append("        ,aa.user_name \n");
				query.append("        ,aa.creation_date \n");
				
			}else if(qryExp.equals("rawItemInterface")){
				
				query.append("INSERT INTO STX_TBC_ITEM \n");
				query.append("( item_code \n");
				query.append(", item_catalog \n");
				query.append(", item_category \n");
				query.append(", item_desc \n");
				query.append(", item_desc_detail \n");
				query.append(", item_weight \n");
				query.append(", attr1 \n");
				query.append(", attr2 \n");
				query.append(", attr3 \n");
				query.append(", attr4 \n");
				query.append(", attr5 \n");
				query.append(", attr6 \n");
				query.append(", attr7 \n");
				query.append(", attr8 \n");
				query.append(", attr9 \n");
				query.append(", attr10 \n");
				query.append(", attr11 \n");
				query.append(", attr12 \n");
				query.append(", attr13 \n");
				query.append(", attr14 \n");
				query.append(", attr15 \n");
				query.append(", item_material1 \n");
				query.append(", item_material2 \n");
				query.append(", item_material3 \n");
				query.append(", item_material4 \n");
				query.append(", item_material5 \n");
				query.append(", paint_code1 \n");
				query.append(", paint_code2 \n");
				query.append(", code_type \n");
				query.append(", uom \n");
				query.append(", ship_pattern \n");
				query.append(", item_oldcode \n");
				query.append(", cable_length \n");
				query.append(", cable_type \n");
				query.append(", cable_outdia \n");
				query.append(", user_id \n");
				query.append(", user_name \n");
				query.append(", create_date ) \n");
				
				query.append("select distinct \n");
				query.append("       aa.part_no \n");
				query.append("      ,aa.item_catalog \n");
				query.append("      ,aa.item_category \n");
				query.append("      ,aa.part_desc \n");
				query.append("      ,'' AS ITEM_DESC_DETAIL \n");
				query.append("      ,aa.unit_weight \n");
				query.append("      ,max(case when aa.ele_seq = 1 then aa.element_value else null end) as ele_value_1 \n");
				query.append("      ,max(case when aa.ele_seq = 2 then aa.element_value else null end) as ele_value_2 \n");
				query.append("      ,max(case when aa.ele_seq = 3 then aa.element_value else null end) as ele_value_3 \n");
				query.append("      ,max(case when aa.ele_seq = 4 then aa.element_value else null end) as ele_value_4 \n");
				query.append("      ,max(case when aa.ele_seq = 5 then aa.element_value else null end) as ele_value_5 \n");
				query.append("      ,max(case when aa.ele_seq = 6 then aa.element_value else null end) as ele_value_6 \n");
				query.append("      ,max(case when aa.ele_seq = 7 then aa.element_value else null end) as ele_value_7 \n");
				query.append("      ,max(case when aa.ele_seq = 8 then aa.element_value else null end) as ele_value_8 \n");
				query.append("      ,max(case when aa.ele_seq = 9 then aa.element_value else null end) as ele_value_9 \n");
				query.append("      ,max(case when aa.ele_seq =10 then aa.element_value else null end) as ele_value_10 \n");
				query.append("      ,max(case when aa.ele_seq =11 then aa.element_value else null end) as ele_value_11 \n");
				query.append("      ,max(case when aa.ele_seq =12 then aa.element_value else null end) as ele_value_12 \n");
				query.append("      ,max(case when aa.ele_seq =13 then aa.element_value else null end) as ele_value_13 \n");
				query.append("      ,max(case when aa.ele_seq =14 then aa.element_value else null end) as ele_value_14 \n");
				query.append("      ,max(case when aa.ele_seq =15 then aa.element_value else null end) as ele_value_15 \n");
				query.append("      , '' AS ITEM_MATERIAL1 \n");
				query.append("      , '' AS ITEM_MATERIAL2 \n");
				query.append("      , '' AS ITEM_MATERIAL3 \n");
				query.append("      , '' AS ITEM_MATERIAL4 \n");
				query.append("      , '' AS ITEM_MATERIAL5 \n");
				query.append("      , CASE WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 1 \n");
				query.append("           THEN max(case when aa.ele_seq = 1 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 2 \n");
				query.append("           THEN max(case when aa.ele_seq = 2 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 3 \n");
				query.append("           THEN max(case when aa.ele_seq = 3 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 4 \n");
				query.append("           THEN max(case when aa.ele_seq = 4 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 5 \n");
				query.append("           THEN max(case when aa.ele_seq = 5 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 6 \n");
				query.append("           THEN max(case when aa.ele_seq = 6 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 7 \n");
				query.append("           THEN max(case when aa.ele_seq = 7 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 8 \n");
				query.append("           THEN max(case when aa.ele_seq = 8 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 9 \n");
				query.append("           THEN max(case when aa.ele_seq = 9 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 10 \n");
				query.append("           THEN max(case when aa.ele_seq = 10 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 11 \n");
				query.append("           THEN max(case when aa.ele_seq = 11 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 12 \n");
				query.append("           THEN max(case when aa.ele_seq = 12 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 13 \n");
				query.append("           THEN max(case when aa.ele_seq = 13 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 14 \n");
				query.append("           THEN max(case when aa.ele_seq = 14 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 15 \n");
				query.append("           THEN max(case when aa.ele_seq = 15 then aa.element_value else null end) \n");
				query.append("           ELSE NULL \n");
				query.append("      END AS PAINT_CODE1 \n");
				query.append("      , '' AS PAINT_CODE2 \n");
				query.append("      , '' AS CODE_TYPE \n");
				query.append("      ,aa.uom \n");
				query.append("      , '' AS SHIP_PATTERN \n");
				query.append("      , '' AS ITEM_OLDCODE \n");
				query.append("      , '' AS CABLE_LENGTH \n");
				query.append("      , '' AS CABLE_TYPE \n");
				query.append("      , '' AS CABLE_OUTDIA \n");
				query.append("      ,aa.emp_no                                                         as emp_no \n");
				query.append("      ,aa.user_name                                                      as user_name \n");
				query.append("      ,aa.creation_date                                                  as creation_date \n");				
				query.append("  from (select msi.segment1                                           as part_no \n");
				query.append("              ,msi.description                                        as part_desc \n");
				query.append("              ,micg.segment1                                          as item_catalog \n");
				query.append("              ,mc.segment1 ||'.' || mc.segment2 ||'.' || mc.segment3  as item_category \n");
				query.append("              ,msi.primary_uom_code                                   as uom \n");
				query.append("              ,msi.unit_weight                                        as unit_weight \n");
				query.append("              ,rank() over (partition by msi.segment1 order by  mdev.element_sequence) as ele_seq \n");
				query.append("              ,mdev.element_value                                     as element_value \n");
				query.append("              ,sciu.emp_no                                            as emp_no \n");
				query.append("              ,sciu.user_name                                         as user_name \n");
				query.append("              ,msi.creation_date                                      as creation_date \n");
				query.append("              ,msi_assy.segment1                                      as parent_no \n");
				query.append("          from mtl_system_items_b@"+ERP_DB+"         msi \n");
				query.append("              ,mtl_item_catalog_groups_b@"+ERP_DB+"  micg \n");
				query.append("              ,mtl_item_categories@"+ERP_DB+"        mic \n");
				query.append("              ,mtl_categories_b@"+ERP_DB+"           mc \n");
				query.append("              ,mtl_descr_element_values@"+ERP_DB+"   mdev \n");
				query.append("              ,stx_com_insa_user@"+ERP_DB+"          sciu \n");
				query.append("              ,bom_inventory_components@"+ERP_DB+"   bic \n");
				query.append("              ,bom_bill_of_materials@"+ERP_DB+"      bbom \n");
				query.append("              ,mtl_system_items_b@"+ERP_DB+"         msi_assy \n");
				query.append("              ,mtl_item_catalog_groups_b@"+ERP_DB+"  micg_assy \n");
				query.append("          where msi.organization_id       = msi_assy.organization_id \n");
				query.append("            and msi.item_catalog_group_id = micg.item_catalog_group_id \n");
				query.append("            and msi.organization_id       = mic.organization_id \n");
				query.append("            and msi.inventory_item_id     = mic.inventory_item_id \n");
				query.append("            and mic.category_set_id       = 1 \n");
				query.append("            and mic.category_id           = mc.category_id \n");
				query.append("            and msi.inventory_item_id     = mdev.inventory_item_id(+) \n");
				query.append("            and msi.attribute2            = sciu.emp_no(+) \n");
				query.append("            and msi.inventory_item_id     = bic.component_item_id \n");
				query.append("            and bic.bill_sequence_id      = bbom.bill_sequence_id \n");
				query.append("            and bbom.organization_id      = msi_assy.organization_id \n");
				query.append("            and bbom.assembly_item_id     = msi_assy.inventory_item_id \n");
				query.append("            and msi_assy.item_catalog_group_id = micg_assy.item_catalog_group_id \n");
				query.append("            and msi_assy.organization_id  = 82 \n");
				query.append("            and bic.IMPLEMENTATION_DATE is not null \n");
				query.append("            and bic.DISABLE_DATE is null \n");
				

				if(!itemCode.equals("")){
					query.append("        and (  ");
					for(int i=0; i < s_itemCode.length; i++  ){
						if(i != 0){
							query.append("         OR ");
						}
						query.append("         msi_assy.segment1 = '"+s_itemCode[i].trim()+"' \n");
					}
					query.append("        ) \n");
				}
				
				if(!itemCatalog.equals("")){
					query.append("            and micg_assy.segment1 = '"+itemCatalog+"' \n");
				}
										
				//query.append("        and (msi_assy.segment1 = 'ZRBC-00797' OR msi_assy.segment1 = 'ZRBC-00796') \n");
				
				
				query.append("         ) aa \n");
				query.append("group by aa.part_no \n");
				query.append("        ,aa.part_desc \n");
				query.append("        ,aa.item_catalog \n");
				query.append("        ,aa.item_category \n");
				query.append("        ,aa.uom \n");
				query.append("        ,aa.unit_weight \n");
				query.append("        ,aa.emp_no \n");
				query.append("        ,aa.user_name \n");
				query.append("        ,aa.creation_date \n");
				query.append("        ,aa.parent_no \n");
				
				System.out.println(query);
				
			}else if(qryExp.equals("itemInterfaceBody")){
				
//				query.append("select aa.part_no \n");
//				query.append("      ,aa.item_catalog \n");
//				query.append("      ,aa.item_category \n");
//				query.append("      ,aa.part_desc \n");
//				query.append("      ,'' \n");
//				query.append("      ,aa.unit_weight \n");
//				query.append("      ,max(case when aa.ele_seq = 1 then aa.element_value else null end) as ele_value_1 \n");
//				query.append("      ,max(case when aa.ele_seq = 2 then aa.element_value else null end) as ele_value_2 \n");
//				query.append("      ,max(case when aa.ele_seq = 3 then aa.element_value else null end) as ele_value_3 \n");
//				query.append("      ,max(case when aa.ele_seq = 4 then aa.element_value else null end) as ele_value_4 \n");
//				query.append("      ,max(case when aa.ele_seq = 5 then aa.element_value else null end) as ele_value_5 \n");
//				query.append("      ,max(case when aa.ele_seq = 6 then aa.element_value else null end) as ele_value_6 \n");
//				query.append("      ,max(case when aa.ele_seq = 7 then aa.element_value else null end) as ele_value_7 \n");
//				query.append("      ,max(case when aa.ele_seq = 8 then aa.element_value else null end) as ele_value_8 \n");
//				query.append("      ,max(case when aa.ele_seq = 9 then aa.element_value else null end) as ele_value_9 \n");
//				query.append("      ,max(case when aa.ele_seq =10 then aa.element_value else null end) as ele_value_10 \n");
//				query.append("      ,max(case when aa.ele_seq =11 then aa.element_value else null end) as ele_value_11 \n");
//				query.append("      ,max(case when aa.ele_seq =12 then aa.element_value else null end) as ele_value_12 \n");
//				query.append("      ,max(case when aa.ele_seq =13 then aa.element_value else null end) as ele_value_13 \n");
//				query.append("      ,max(case when aa.ele_seq =14 then aa.element_value else null end) as ele_value_14 \n");
//				query.append("      ,max(case when aa.ele_seq =15 then aa.element_value else null end) as ele_value_15 \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				//Paint Code1의 값은 Catalog Manager에서 Paint ATTR이라는 값을 참고해서 몇번 속성의 값인지 판단 후 넣는다. 
//				query.append("      , CASE WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 1 \n");
//				query.append("             THEN max(case when aa.ele_seq = 1 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 2 \n");
//				query.append("             THEN max(case when aa.ele_seq = 2 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 3 \n");
//				query.append("             THEN max(case when aa.ele_seq = 3 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 4 \n");
//				query.append("             THEN max(case when aa.ele_seq = 4 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 5 \n");
//				query.append("             THEN max(case when aa.ele_seq = 5 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 6 \n");
//				query.append("             THEN max(case when aa.ele_seq = 6 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 7 \n");
//				query.append("             THEN max(case when aa.ele_seq = 7 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 8 \n");
//				query.append("             THEN max(case when aa.ele_seq = 8 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 9 \n");
//				query.append("             THEN max(case when aa.ele_seq = 9 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 10 \n");
//				query.append("             THEN max(case when aa.ele_seq = 10 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 11 \n");
//				query.append("             THEN max(case when aa.ele_seq = 11 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 12 \n");
//				query.append("             THEN max(case when aa.ele_seq = 12 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 13 \n");
//				query.append("             THEN max(case when aa.ele_seq = 13 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 14 \n");
//				query.append("             THEN max(case when aa.ele_seq = 14 then aa.element_value else null end) \n");
//				query.append("             WHEN (SELECT SCV.VALUE_NAME \n");
//				query.append("                     FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
//				query.append("                    WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
//				query.append("                      AND SCV.VALUE_CODE  = '09' \n");
//				query.append("                      AND SCV.ENABLE_FLAG = 'Y' \n");
//				query.append("                      AND SCV.CATALOG_CODE = aa.item_catalog ) = 15 \n");
//				query.append("             THEN max(case when aa.ele_seq = 15 then aa.element_value else null end) \n");
//				query.append("             ELSE NULL \n");
//				query.append("        END AS PAINT_CODE1 \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      ,aa.uom \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      , '' \n");
//				query.append("      ,aa.emp_no                                                         as emp_no \n");
//				query.append("      ,aa.user_name                                                      as user_name \n");
//				query.append("      ,aa.creation_date                                                  as creation_date \n");
//				query.append("  from (select /*+ LEADING(MICG)  */ \n");
//				query.append("               MSI.SEGMENT1                                           as part_no \n");
//				query.append("              ,msi.description                                        as part_desc \n");
//				query.append("              ,micg.segment1                                          as item_catalog \n");
//				query.append("              ,mc.segment1 ||'.' || mc.segment2 ||'.' || mc.segment3  as item_category \n");
//				query.append("              ,msi.primary_uom_code                                   as uom \n");
//				query.append("              ,msi.unit_weight                                        as unit_weight \n");
//				query.append("              ,RANK() OVER (PARTITION BY MSI.SEGMENT1 ORDER BY  mdev.element_sequence) as ele_seq \n");
//				query.append("              ,mdev.element_value                                     as element_value \n");
//				query.append("              ,sciu.emp_no                                            as emp_no \n");
//				query.append("              ,sciu.user_name                                         as user_name \n");
//				query.append("              ,msi.creation_date                                      as creation_date \n");
//				query.append("          from mtl_system_items_b@"+ERP_DB+" msi \n");
//				query.append("              ,Mtl_Item_Catalog_Groups_b@"+ERP_DB+" micg \n");
//				query.append("              ,mtl_item_categories@"+ERP_DB+"       mic \n");
//				query.append("              ,mtl_categories_b@"+ERP_DB+"          mc \n");
//				query.append("              ,mtl_descr_element_values@"+ERP_DB+"  mdev \n");
//				query.append("              ,stx_com_insa_user@"+ERP_DB+"         sciu \n");
//				query.append("          where msi.organization_id       = 82 \n");
//				
//				if(!itemCode.equals("")){
//					query.append("        and (  ");
//					for(int i=0; i < s_itemCode.length; i++  ){
//						if(i != 0){
//							query.append("         OR ");
//						}
//						query.append("         msi.segment1 = '"+s_itemCode[i].trim()+"' \n");
//					}
//					query.append("        ) \n");
//				}
//				
//				if(!itemCatalog.equals("")){
//					query.append("            and micg.segment1 IN('"+itemCatalog+"') \n");
//				}
//				
//				query.append("            and msi.item_catalog_group_id = micg.item_catalog_group_id \n");
//				query.append("            and msi.organization_id       = mic.organization_id \n");
//				query.append("            and msi.inventory_item_id     = mic.inventory_item_id \n");
//				query.append("            and mic.category_set_id       = 1 \n");
//				query.append("            and mic.category_id           = mc.category_id \n");
//				query.append("            AND msi.inventory_item_id     = mdev.inventory_item_id(+) \n");
//				query.append("            and msi.attribute2            = sciu.emp_no(+) \n");
//				//query.append("            and not exists (select 1 from stx_tbc_item sti where msi.segment1 = sti.item_code ) \n");
//				query.append("         ) aa \n");
//				query.append("group by aa.part_no \n");
//				query.append("        ,aa.part_desc \n");
//				query.append("        ,aa.item_catalog \n");
//				query.append("        ,aa.item_category \n");
//				query.append("        ,aa.uom \n");
//				query.append("        ,aa.unit_weight \n");
//				query.append("        ,aa.emp_no \n");
//				query.append("        ,aa.user_name \n");
//				query.append("        ,aa.creation_date \n");
//				
//				
//				
				
				
				
				query.append("SELECT * FROM ( \n");
				query.append("select '0' AS PARENT_NO \n");
				query.append("      ,aa.part_no \n");
				query.append("      ,aa.item_catalog \n");
				query.append("      ,aa.item_category \n");
				query.append("      ,aa.part_desc \n");
				query.append("      ,'' AS ITEM_DESC_DETAIL \n");
				query.append("      ,aa.unit_weight \n");
				query.append("      ,max(case when aa.ele_seq = 1 then aa.element_value else null end) as ele_value_1 \n");
				query.append("      ,max(case when aa.ele_seq = 2 then aa.element_value else null end) as ele_value_2 \n");
				query.append("      ,max(case when aa.ele_seq = 3 then aa.element_value else null end) as ele_value_3 \n");
				query.append("      ,max(case when aa.ele_seq = 4 then aa.element_value else null end) as ele_value_4 \n");
				query.append("      ,max(case when aa.ele_seq = 5 then aa.element_value else null end) as ele_value_5 \n");
				query.append("      ,max(case when aa.ele_seq = 6 then aa.element_value else null end) as ele_value_6 \n");
				query.append("      ,max(case when aa.ele_seq = 7 then aa.element_value else null end) as ele_value_7 \n");
				query.append("      ,max(case when aa.ele_seq = 8 then aa.element_value else null end) as ele_value_8 \n");
				query.append("      ,max(case when aa.ele_seq = 9 then aa.element_value else null end) as ele_value_9 \n");
				query.append("      ,max(case when aa.ele_seq =10 then aa.element_value else null end) as ele_value_10 \n");
				query.append("      ,max(case when aa.ele_seq =11 then aa.element_value else null end) as ele_value_11 \n");
				query.append("      ,max(case when aa.ele_seq =12 then aa.element_value else null end) as ele_value_12 \n");
				query.append("      ,max(case when aa.ele_seq =13 then aa.element_value else null end) as ele_value_13 \n");
				query.append("      ,max(case when aa.ele_seq =14 then aa.element_value else null end) as ele_value_14 \n");
				query.append("      ,max(case when aa.ele_seq =15 then aa.element_value else null end) as ele_value_15 \n");
				query.append("      , '' AS ITEM_MATERIAL1 \n");
				query.append("      , '' AS ITEM_MATERIAL2 \n");
				query.append("      , '' AS ITEM_MATERIAL3 \n");
				query.append("      , '' AS ITEM_MATERIAL4 \n");
				query.append("      , '' AS ITEM_MATERIAL5 \n");
				query.append("      , CASE WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 1 \n");
				query.append("           THEN max(case when aa.ele_seq = 1 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 2 \n");
				query.append("           THEN max(case when aa.ele_seq = 2 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 3 \n");
				query.append("           THEN max(case when aa.ele_seq = 3 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 4 \n");
				query.append("           THEN max(case when aa.ele_seq = 4 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 5 \n");
				query.append("           THEN max(case when aa.ele_seq = 5 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 6 \n");
				query.append("           THEN max(case when aa.ele_seq = 6 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 7 \n");
				query.append("           THEN max(case when aa.ele_seq = 7 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 8 \n");
				query.append("           THEN max(case when aa.ele_seq = 8 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 9 \n");
				query.append("           THEN max(case when aa.ele_seq = 9 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 10 \n");
				query.append("           THEN max(case when aa.ele_seq = 10 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 11 \n");
				query.append("           THEN max(case when aa.ele_seq = 11 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 12 \n");
				query.append("           THEN max(case when aa.ele_seq = 12 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 13 \n");
				query.append("           THEN max(case when aa.ele_seq = 13 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 14 \n");
				query.append("           THEN max(case when aa.ele_seq = 14 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 15 \n");
				query.append("           THEN max(case when aa.ele_seq = 15 then aa.element_value else null end) \n");
				query.append("           ELSE NULL \n");
				query.append("      END AS PAINT_CODE1 \n");
				query.append("      , '' AS PAINT_CODE2 \n");
				query.append("      , '' AS CODE_TYPE \n");
				query.append("      ,aa.uom \n");
				query.append("      , '' AS SHIP_PATTERN \n");
				query.append("      , '' AS ITEM_OLDCODE \n");
				query.append("      , '' AS CABLE_LENGTH \n");
				query.append("      , '' AS CABLE_TYPE \n");
				query.append("      , '' AS CABLE_OUTDIA \n");
				query.append("      ,aa.emp_no                                                         as emp_no \n");
				query.append("      ,aa.user_name                                                      as user_name \n");
				query.append("      ,aa.creation_date                                                  as creation_date \n");
				query.append("      ,'1' AS LV \n");
				query.append("      ,(select CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END from stx_tbc_item sti where aa.part_no = sti.item_code ) AS TBC_EXIST \n");
				
				query.append("  from (select msi.segment1                                           as part_no \n");
				query.append("              ,msi.description                                        as part_desc \n");
				query.append("              ,micg.segment1                                          as item_catalog \n");
				query.append("              ,mc.segment1 ||'.' || mc.segment2 ||'.' || mc.segment3  as item_category \n");
				query.append("              ,msi.primary_uom_code                                   as uom \n");
				query.append("              ,msi.unit_weight                                        as unit_weight \n");
				query.append("              ,rank() over (partition by msi.segment1 order by  mdev.element_sequence) as ele_seq \n");
				query.append("              ,mdev.element_value                                     as element_value \n");
				query.append("              ,sciu.emp_no                                            as emp_no \n");
				query.append("              ,sciu.user_name                                         as user_name \n");
				query.append("              ,msi.creation_date                                      as creation_date \n");
				query.append("          from mtl_system_items_b@"+ERP_DB+"         msi \n");
				query.append("              ,mtl_item_catalog_groups_b@"+ERP_DB+"  micg \n");
				query.append("              ,mtl_item_categories@"+ERP_DB+"        mic \n");
				query.append("              ,mtl_categories_b@"+ERP_DB+"           mc \n");
				query.append("              ,mtl_descr_element_values@"+ERP_DB+"   mdev \n");
				query.append("              ,stx_com_insa_user@"+ERP_DB+"          sciu \n");
				query.append("          where msi.organization_id       = 82 \n");
				query.append("            and msi.item_catalog_group_id = micg.item_catalog_group_id \n");
				query.append("            and msi.organization_id       = mic.organization_id \n");
				query.append("            and msi.inventory_item_id     = mic.inventory_item_id \n");
				query.append("            and mic.category_set_id       = 1 \n");
				query.append("            and mic.category_id           = mc.category_id \n");
				query.append("            and msi.inventory_item_id     = mdev.inventory_item_id(+) \n");
				query.append("            and msi.attribute2            = sciu.emp_no(+) \n");
				//query.append("            and msi.segment1              in ('Z6604-0000065', 'ZRBC-00797') \n");
				//query.append("            and not exists (select 1 from stx_tbc_item sti where msi.segment1 = sti.item_code ) \n");
				if(!itemCode.equals("")){
					query.append("        and (  ");
					for(int i=0; i < s_itemCode.length; i++  ){
						if(i != 0){
							query.append("         OR ");
						}
						query.append("         msi.segment1 = '"+s_itemCode[i].trim()+"' \n");
					}
					query.append("        ) \n");
				}
				
				if(!itemCatalog.equals("")){
					query.append("            and micg.segment1 = '"+itemCatalog+"' \n");
				}
				query.append("         ) aa \n");
				query.append("group by aa.part_no \n");
				query.append("        ,aa.part_desc \n");
				query.append("        ,aa.item_catalog \n");
				query.append("        ,aa.item_category \n");
				query.append("        ,aa.uom \n");
				query.append("        ,aa.unit_weight \n");
				query.append("        ,aa.emp_no \n");
				query.append("        ,aa.user_name \n");
				query.append("        ,aa.creation_date \n");
				query.append(" \n");
				query.append("union all \n");
				query.append("select aa.parent_no AS PARENT_NO \n");
				query.append("      ,aa.part_no \n");
				query.append("      ,aa.item_catalog \n");
				query.append("      ,aa.item_category \n");
				query.append("      ,aa.part_desc \n");
				query.append("      ,'' AS ITEM_DESC_DETAIL \n");
				query.append("      ,aa.unit_weight \n");
				query.append("      ,max(case when aa.ele_seq = 1 then aa.element_value else null end) as ele_value_1 \n");
				query.append("      ,max(case when aa.ele_seq = 2 then aa.element_value else null end) as ele_value_2 \n");
				query.append("      ,max(case when aa.ele_seq = 3 then aa.element_value else null end) as ele_value_3 \n");
				query.append("      ,max(case when aa.ele_seq = 4 then aa.element_value else null end) as ele_value_4 \n");
				query.append("      ,max(case when aa.ele_seq = 5 then aa.element_value else null end) as ele_value_5 \n");
				query.append("      ,max(case when aa.ele_seq = 6 then aa.element_value else null end) as ele_value_6 \n");
				query.append("      ,max(case when aa.ele_seq = 7 then aa.element_value else null end) as ele_value_7 \n");
				query.append("      ,max(case when aa.ele_seq = 8 then aa.element_value else null end) as ele_value_8 \n");
				query.append("      ,max(case when aa.ele_seq = 9 then aa.element_value else null end) as ele_value_9 \n");
				query.append("      ,max(case when aa.ele_seq =10 then aa.element_value else null end) as ele_value_10 \n");
				query.append("      ,max(case when aa.ele_seq =11 then aa.element_value else null end) as ele_value_11 \n");
				query.append("      ,max(case when aa.ele_seq =12 then aa.element_value else null end) as ele_value_12 \n");
				query.append("      ,max(case when aa.ele_seq =13 then aa.element_value else null end) as ele_value_13 \n");
				query.append("      ,max(case when aa.ele_seq =14 then aa.element_value else null end) as ele_value_14 \n");
				query.append("      ,max(case when aa.ele_seq =15 then aa.element_value else null end) as ele_value_15 \n");
				query.append("      , '' AS ITEM_MATERIAL1 \n");
				query.append("      , '' AS ITEM_MATERIAL2 \n");
				query.append("      , '' AS ITEM_MATERIAL3 \n");
				query.append("      , '' AS ITEM_MATERIAL4 \n");
				query.append("      , '' AS ITEM_MATERIAL5 \n");
				query.append("      , CASE WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 1 \n");
				query.append("           THEN max(case when aa.ele_seq = 1 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 2 \n");
				query.append("           THEN max(case when aa.ele_seq = 2 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 3 \n");
				query.append("           THEN max(case when aa.ele_seq = 3 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 4 \n");
				query.append("           THEN max(case when aa.ele_seq = 4 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 5 \n");
				query.append("           THEN max(case when aa.ele_seq = 5 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 6 \n");
				query.append("           THEN max(case when aa.ele_seq = 6 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 7 \n");
				query.append("           THEN max(case when aa.ele_seq = 7 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 8 \n");
				query.append("           THEN max(case when aa.ele_seq = 8 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 9 \n");
				query.append("           THEN max(case when aa.ele_seq = 9 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 10 \n");
				query.append("           THEN max(case when aa.ele_seq = 10 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 11 \n");
				query.append("           THEN max(case when aa.ele_seq = 11 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 12 \n");
				query.append("           THEN max(case when aa.ele_seq = 12 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 13 \n");
				query.append("           THEN max(case when aa.ele_seq = 13 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 14 \n");
				query.append("           THEN max(case when aa.ele_seq = 14 then aa.element_value else null end) \n");
				query.append("           WHEN (SELECT SCV.VALUE_NAME \n");
				query.append("                   FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("                  WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("                    AND SCV.VALUE_CODE  = '09' \n");
				query.append("                    AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("                    AND SCV.CATALOG_CODE = aa.item_catalog ) = 15 \n");
				query.append("           THEN max(case when aa.ele_seq = 15 then aa.element_value else null end) \n");
				query.append("           ELSE NULL \n");
				query.append("      END AS PAINT_CODE1 \n");
				query.append("      , '' AS PAINT_CODE2 \n");
				query.append("      , '' AS CODE_TYPE \n");
				query.append("      ,aa.uom \n");
				query.append("      , '' AS SHIP_PATTERN \n");
				query.append("      , '' AS ITEM_OLDCODE \n");
				query.append("      , '' AS CABLE_LENGTH \n");
				query.append("      , '' AS CABLE_TYPE \n");
				query.append("      , '' AS CABLE_OUTDIA \n");
				query.append("      ,aa.emp_no                                                         as emp_no \n");
				query.append("      ,aa.user_name                                                      as user_name \n");
				query.append("      ,aa.creation_date                                                  as creation_date \n");
				query.append("      ,'2' AS LV \n");
				query.append("      ,(select CASE WHEN COUNT(*) > 1 THEN 'Y' ELSE 'N' END from stx_tbc_item sti where aa.part_no = sti.item_code ) AS TBC_EXIST \n");
				query.append("  from (select msi.segment1                                           as part_no \n");
				query.append("              ,msi.description                                        as part_desc \n");
				query.append("              ,micg.segment1                                          as item_catalog \n");
				query.append("              ,mc.segment1 ||'.' || mc.segment2 ||'.' || mc.segment3  as item_category \n");
				query.append("              ,msi.primary_uom_code                                   as uom \n");
				query.append("              ,msi.unit_weight                                        as unit_weight \n");
				query.append("              ,rank() over (partition by msi.segment1 order by  mdev.element_sequence) as ele_seq \n");
				query.append("              ,mdev.element_value                                     as element_value \n");
				query.append("              ,sciu.emp_no                                            as emp_no \n");
				query.append("              ,sciu.user_name                                         as user_name \n");
				query.append("              ,msi.creation_date                                      as creation_date \n");
				query.append("              ,msi_assy.segment1                                      as parent_no \n");
				query.append("          from mtl_system_items_b@"+ERP_DB+"         msi \n");
				query.append("              ,mtl_item_catalog_groups_b@"+ERP_DB+"  micg \n");
				query.append("              ,mtl_item_categories@"+ERP_DB+"        mic \n");
				query.append("              ,mtl_categories_b@"+ERP_DB+"           mc \n");
				query.append("              ,mtl_descr_element_values@"+ERP_DB+"   mdev \n");
				query.append("              ,stx_com_insa_user@"+ERP_DB+"          sciu \n");
				query.append("              ,bom_inventory_components@"+ERP_DB+"   bic \n");
				query.append("              ,bom_bill_of_materials@"+ERP_DB+"      bbom \n");
				query.append("              ,mtl_system_items_b@"+ERP_DB+"         msi_assy \n");
				query.append("          where msi.organization_id       = msi_assy.organization_id \n");
				query.append("            and msi.item_catalog_group_id = micg.item_catalog_group_id \n");
				query.append("            and msi.organization_id       = mic.organization_id \n");
				query.append("            and msi.inventory_item_id     = mic.inventory_item_id \n");
				query.append("            and mic.category_set_id       = 1 \n");
				query.append("            and mic.category_id           = mc.category_id \n");
				query.append("            and msi.inventory_item_id     = mdev.inventory_item_id(+) \n");
				query.append("            and msi.attribute2            = sciu.emp_no(+) \n");
				query.append("            and msi.inventory_item_id     = bic.component_item_id \n");
				query.append("            and bic.bill_sequence_id      = bbom.bill_sequence_id \n");
				query.append("            and bbom.organization_id      = msi_assy.organization_id \n");
				query.append("            and bbom.assembly_item_id     = msi_assy.inventory_item_id \n");
				query.append("            and msi_assy.organization_id  = 82 \n");
				query.append("            and bic.IMPLEMENTATION_DATE is not null \n");
				query.append("            and bic.DISABLE_DATE is null \n");
				

				if(!itemCode.equals("")){
					query.append("        and (  ");
					for(int i=0; i < s_itemCode.length; i++  ){
						if(i != 0){
							query.append("         OR ");
						}
						query.append("         msi_assy.segment1 = '"+s_itemCode[i].trim()+"' \n");
					}
					query.append("        ) \n");
				}
				
				if(!itemCatalog.equals("")){
					query.append("            and micg.segment1 = '"+itemCatalog+"' \n");
				}
				
				//query.append("            and msi_assy.segment1         in ('Z6604-0000065', 'ZRBC-00797') \n");
				//query.append("            --and bbom.alternate_bom_designator= 'S1397' \n");
				//query.append("            --and not exists (select 1 from stx_tbc_item sti where msi.segment1 = sti.item_code ) \n");
				
				
				query.append("         ) aa \n");
				query.append("group by aa.part_no \n");
				query.append("        ,aa.part_desc \n");
				query.append("        ,aa.item_catalog \n");
				query.append("        ,aa.item_category \n");
				query.append("        ,aa.uom \n");
				query.append("        ,aa.unit_weight \n");
				query.append("        ,aa.emp_no \n");
				query.append("        ,aa.user_name \n");
				query.append("        ,aa.creation_date \n");
				query.append("        ,aa.parent_no \n");
				query.append(") A \n");
				query.append("START WITH PARENT_NO = '0' \n");
				query.append("CONNECT BY PRIOR  PART_NO = PARENT_NO \n");
				
				
			}
			
			//System.out.println(query);
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
}