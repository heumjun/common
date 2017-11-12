package com.stx.common.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.tbc.dao.factory.Idao;

public class TBCCommonCRUD implements TBCCommonDataBaseInterface 
{	
	/**
	 * STX_TBC_ITEM INSERT 
	 * @param DataBox
	 * @param Connection
	 * @return boolean
	 * @throws Exception
	 */
	public boolean insertItem(DataBox dBox) throws Exception {
		// TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	PreparedStatement 	pstmt 	= null;
    	StringBuffer		query   = new StringBuffer();
        try 
        { 
        	//SSC ITEM INSERT
        	query.append("INSERT INTO STX_TBC_ITEM (        \n");
        	query.append("  ITEM_CODE                       \n");
        	query.append(", ITEM_CATALOG                    \n");
        	query.append(", ITEM_CATEGORY                   \n");
        	query.append(", ITEM_DESC                       \n");
        	query.append(", ITEM_DESC_DETAIL                \n");
        	query.append(", ITEM_WEIGHT                     \n");
        	query.append(", ATTR1                           \n");
        	query.append(", ATTR2                           \n");
        	query.append(", ATTR3                           \n");
        	query.append(", ATTR4                           \n");
        	query.append(", ATTR5                           \n");
        	query.append(", ATTR6                           \n");
        	query.append(", ATTR7                           \n");
        	query.append(", ATTR8                           \n");
        	query.append(", ATTR9                           \n");
        	query.append(", ATTR10                          \n");
        	query.append(", ATTR11                          \n");
        	query.append(", ATTR12                          \n");
        	query.append(", ATTR13                          \n");
        	query.append(", ATTR14                          \n");
        	query.append(", ATTR15                          \n");
        	query.append(", ITEM_MATERIAL1                  \n");
        	query.append(", ITEM_MATERIAL2                  \n");
        	query.append(", ITEM_MATERIAL3                  \n");
        	query.append(", ITEM_MATERIAL4                  \n");
        	query.append(", ITEM_MATERIAL5                  \n");
        	query.append(", PAINT_CODE1                     \n");
        	query.append(", PAINT_CODE2                     \n");
        	query.append(", CODE_TYPE                       \n");
        	query.append(", UOM                             \n");
        	query.append(", SHIP_PATTERN                    \n");
        	query.append(", ITEM_OLDCODE                    \n");
        	query.append(", CABLE_LENGTH                    \n");
        	query.append(", CABLE_TYPE                      \n");
        	query.append(", CABLE_OUTDIA                    \n");
        	query.append(", USER_ID                         \n");
        	query.append(", USER_NAME                       \n");
        	query.append(", CREATE_DATE                     \n");
        	query.append(") VALUES (                        \n");
        	query.append("  ? ,? ,? ,? ,? ,? ,?, ? ,? ,?    \n");
        	query.append(", ? ,? ,? ,? ,? ,?, ? ,? ,? ,?    \n");
        	query.append(", ? ,? ,? ,? ,? ,?, ? ,? ,? ,?    \n");
        	query.append(", ? ,? ,? ,? ,? ,?, ?, sysdate    \n");
        	query.append(" )                                \n");
			
        	pstmt = conn.prepareStatement(query.toString());

			//기존에 ITEM Table에 있는지 없는지 확인 후 실행.
			int item_cnt =  getUniqItemCount(conn, dBox.getString("d_item_code"));
			if(item_cnt < 1){
				int idx = 0;
				pstmt.setString(++idx, dBox.getString("d_item_code"));	//ITEM_CODE
				pstmt.setString(++idx, dBox.getString("d_item_catalog"));	//ITEM_CATALOG
				pstmt.setString(++idx, dBox.getString("d_item_category"));	//ITEM_CATEGORY     		
				pstmt.setString(++idx, dBox.getString("d_item_desc"));	//item_desc
				pstmt.setString(++idx, dBox.getString("d_item_desc_detail"));	//item_desc_detail
				pstmt.setFloat (++idx, Float.parseFloat(dBox.getString("d_item_weight")));	//item_weight
				pstmt.setString(++idx, dBox.getString("d_attr1"));	//attr1				        		
				pstmt.setString(++idx, dBox.getString("d_attr2"));	//attr2
				pstmt.setString(++idx, dBox.getString("d_attr3"));	//attr3
				pstmt.setString(++idx, dBox.getString("d_attr4"));	//attr4
				pstmt.setString(++idx, dBox.getString("d_attr5"));	//attr5
				pstmt.setString(++idx, dBox.getString("d_attr6"));	//attr6
				pstmt.setString(++idx, dBox.getString("d_attr7"));	//attr7
				pstmt.setString(++idx, dBox.getString("d_attr8"));	//attr8
				pstmt.setString(++idx, dBox.getString("d_attr9"));	//attr9
				pstmt.setString(++idx, dBox.getString("d_attr10"));	//attr10
				pstmt.setString(++idx, dBox.getString("d_attr11"));	//attr11
				pstmt.setString(++idx, dBox.getString("d_attr12"));	//attr12
				pstmt.setString(++idx, dBox.getString("d_attr13"));	//attr13
				pstmt.setString(++idx, dBox.getString("d_attr14"));	//attr14
				pstmt.setString(++idx, dBox.getString("d_attr15"));	//attr15
				pstmt.setString(++idx, dBox.getString("d_item_material1"));	//item_material1
				pstmt.setString(++idx, dBox.getString("d_item_material2"));	//item_material2
				pstmt.setString(++idx, dBox.getString("d_item_material3"));	//item_material3
				pstmt.setString(++idx, dBox.getString("d_item_material4"));	//item_material4
				pstmt.setString(++idx, dBox.getString("d_item_material5"));	//item_material5
				pstmt.setString(++idx, dBox.getString("d_paint_code1"));	//paint_code1
				pstmt.setString(++idx, dBox.getString("d_paint_code2"));	//paint_code2
				pstmt.setString(++idx, dBox.getString("d_code_type"));	//code_type
				pstmt.setString(++idx, dBox.getString("d_uom"));	//uom
				pstmt.setString(++idx, dBox.getString("d_ship_pattern"));	//ship_pattern
				pstmt.setString(++idx, dBox.getString("d_item_oldcode"));	//item_oldcode
				pstmt.setString(++idx, dBox.getString("d_cable_length"));	//cable_length
				pstmt.setString(++idx, dBox.getString("d_cable_type"));	//cable_type
				pstmt.setString(++idx, dBox.getString("d_cable_outdia"));	//cable_outdia
				pstmt.setString(++idx, dBox.getString("d_user_id"));	//user_id
				pstmt.setString(++idx, dBox.getString("d_user_name"));	//user_name
	        	
	        	isOk = pstmt.executeUpdate();	
			}
			
        	if(isOk > 0){
        		rtn = true;
        	}else{
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        	if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}
	
	/**
	 * STX_TBC_RAWLEVEL INSERT 
	 * @param DataBox
	 * @return boolean
	 * @throws Exception
	 */
	public boolean insertRawMaterial(DataBox dBox, Connection conn) throws Exception {
		// TODO Auto-generated method stub		
		
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	PreparedStatement 	pstmt 	= null;
    	StringBuffer		query   = new StringBuffer();
        try 
        { 
        	 
        	  
        	query.append("INSERT INTO STX_TBC_RAWLEVEL( \n");
        	//query.append("            ITEM_TYPE_CD \n");
        	query.append("            MOTHER_CODE \n");
        	query.append("          , ITEM_CODE \n");
        	query.append("          , BOM_QTY \n");
        	query.append("          , USER_ID \n");
        	query.append("          , USER_NAME \n");
        	query.append("          , CREATE_DATE \n");
        	query.append("          , TYPE \n");
        	query.append("          , STATE_FLAG \n");
        	query.append(") VALUES( \n");
//        	query.append("            ? \n");
        	query.append("            ? \n");
        	query.append("          , ? \n");
        	query.append("          , ? \n");
        	query.append("          , ? \n");
        	query.append("          , ? \n");
        	query.append("          , SYSDATE \n");
        	query.append("          , 'RAWMTR' \n");
        	query.append("          , 'A' \n");
        	query.append(") \n");
			
        	pstmt = conn.prepareStatement(query.toString());

			//기존에 ITEM Table에 있는지 없는지 확인 후 실행.
			int item_cnt =  getUniqRawLevelCount(conn, dBox.getString("d_item_code"), dBox.getString("d_mother_code"));
			if(item_cnt < 1){
				int idx = 0;
//				pstmt.setString(++idx, dBox.getString("d_item_type_cd"));	//ITEM_TYPE_CD
				pstmt.setString(++idx, dBox.getString("d_mother_code"));	//MOTHER_CODE
				pstmt.setString(++idx, dBox.getString("d_item_code"));		//ITEM_CODE     		
				pstmt.setString(++idx, dBox.getString("d_bom_qty"));		//BOM_QTY
				pstmt.setString(++idx, dBox.getString("d_user_id"));		//USER_ID
				pstmt.setString(++idx, dBox.getString("d_user_name"));		//USER_NAME
				
	        	isOk = pstmt.executeUpdate();	
			}
			
			System.out.println(isOk);
        	if(isOk > 0){
        		rtn = true;
        	}else{
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	rtn = false;
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}
	
	/**
	 * STX_TBC_ITEM UNIQUE VALIDATION 
	 * @param DataBox
	 * @return boolean
	 * @throws Exception
	 */
	public int getUniqItemCount(Connection conn, String p_item_code) throws Exception {
        
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int v_sub_ssc_id = 0;
        
    	try 
        { 
        	query.append("SELECT COUNT(*) AS ITEMCNT FROM STX_TBC_ITEM  \n");
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
	
	/**
	 * STX_TBC_RAWLEVEL UNIQUE VALIDATION 
	 * @param DataBox
	 * @return boolean
	 * @throws Exception
	 */
	public int getUniqRawLevelCount(Connection conn, String p_item_code, String p_mother_code) throws Exception {
        
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int v_sub_ssc_id = 0;
        
    	try 
        { 
        	query.append("SELECT COUNT(*) AS ITEMCNT  \n");
        	query.append("  FROM STX_TBC_RAWLEVEL  \n");
        	query.append(" WHERE ITEM_CODE = '"+p_item_code+"' \n");
        	query.append("   AND MOTHER_CODE = '"+p_mother_code+"' \n");
        	
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
}
