package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;


import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;

public class TbcBuyBuyModifyDao implements Idao{
	
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
        	
        	if(qryExp.equals("buybuyModifyCheck")){
        		boolean rtn = buybuyModifyCheckTempInsert(rBox);
        		if(!rtn){
        			throw new Exception("Temp Insert Error");
        		}
        	}
        	
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
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	int 				isOkAll    = 0;
    	String				query   = "";
        try 
        { 
        	
        	String p_item_type_cd = rBox.getString("p_item_type_cd");
        	
        	ArrayList ar_state = rBox.getArrayList("p_state");
        	ArrayList ar_state_business = rBox.getArrayList("p_state_business");
        	
			ArrayList ar_bom_qty = rBox.getArrayList("p_modifyEA");
			ArrayList ar_project_no = rBox.getArrayList("p_lproject_no");
			ArrayList ar_dwg_no = rBox.getArrayList("p_dwg_no");
			ArrayList ar_mother_code = rBox.getArrayList("p_lmother_code");
			ArrayList ar_item_code = rBox.getArrayList("p_litem_code");
			ArrayList ar_ssc_sub_id = rBox.getArrayList("p_ssc_sub_id");
			ArrayList ar_eco_no = rBox.getArrayList("p_eco_no");
			ArrayList ar_lblock_no = rBox.getArrayList("p_lblock_no");
			ArrayList ar_lstage_no = rBox.getArrayList("p_lstage_no");
			ArrayList ar_lstr_flag = rBox.getArrayList("p_lstr_flag");
			ArrayList ar_modifyDetail = rBox.getArrayList("p_modifyDetail");
			ArrayList ar_modifySupply = rBox.getArrayList("p_modifySupply");
			ArrayList ar_rev_no = rBox.getArrayList("p_rev_no");
		
			String p_state_val = "";
			String p_modifyDetail = "";
			String p_bom_qty = "";
			
			TBCCommonValidation commonValidation = new TBCCommonValidation();
			Idao dao = new TbcConfirmDao();
        	
			for(int i = 0; i < ar_state_business.size(); i++){
				
				if(ar_modifyDetail != null && ar_modifyDetail.size() > 0){
					p_modifyDetail = ar_modifyDetail.get(i).toString().trim();
				}
				
				p_state_val = ar_state_business.get(i).toString();
				p_bom_qty  = ar_bom_qty.get(i).toString();
				
				System.out.println("p_state_val : "+p_state_val);
				
				System.out.println("ar_mother_code.get(i).toString()" + ar_mother_code.get(i).toString());
				System.out.println("ar_item_code.get(i).toString()" + ar_item_code.get(i).toString());
				
				if(p_state_val.equals("A")){
					//ADD
					isOk = ModifyAddModule(rBox, conn, ar_mother_code.get(i).toString()
							, p_bom_qty, ar_item_code.get(i).toString(), ar_modifySupply.get(i).toString(), p_modifyDetail); 
				}else if(p_state_val.equals("C")){
					
					//Change					
		        	isOk = ModifyModifyModule(rBox, conn, ar_mother_code.get(i).toString()
		        			, ar_item_code.get(i).toString(), ar_state.get(i).toString(), p_bom_qty, p_modifyDetail, ar_modifySupply.get(i).toString());
		        	
				}else if(p_state_val.equals("D")){
					System.out.println("ar_eco_no : " + ar_eco_no.get(i).toString());
					System.out.println("ar_ssc_sub_id : " + ar_ssc_sub_id.get(i).toString());
					if(ar_eco_no.get(i).toString().equals("")){
						//Delete : ���� ����
						isOk = ModifyDeleteModule(rBox, conn
								, ar_ssc_sub_id.get(i).toString());
					}else{
						//Update : D�� �Է�
						isOk = ModifyModifyModule(rBox, conn 
								, ar_mother_code.get(i).toString()
								, ar_item_code.get(i).toString()								
								, ar_state.get(i).toString()
								, p_bom_qty, p_modifyDetail
								, ar_modifySupply.get(i).toString());			        	
					}
				}
				System.out.println("isOk : "+isOk);
				if(isOk > 0){
					isOkAll++;
				}
			}
			
        	if(isOkAll == ar_state_business.size()){
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
        }        
		return rtn;
	}

	private String getQuery(String qryExp, RequestBox box)
	{//URLDecoder.decode(box.getString("p_course"),"UTF-8")
		StringBuffer query = new StringBuffer();
		
		try
		{
			if(qryExp.equals("buybuyModifyCheck")){
				query.append("SELECT DISTINCT \n");
				query.append("  TEMP1  AS STATE \n");
				query.append(", TEMP2  AS STATE_BUSINESS \n");
				query.append(", TEMP3  AS STATE_FLAG \n");
				query.append(", TEMP4  AS MASTER_SHIP \n");
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
				query.append(", TEMP43 AS EA \n");
				query.append(", TEMP44 AS MODIFY_EA \n");
				query.append(", TEMP45 AS ITEM_DESC \n");
				query.append(", TEMP46 AS ITEM_DESC_DETAIL \n");
				query.append(", TEMP47 AS ITEM_WEIGHT \n");
				query.append(", TEMP48 AS REV_NO \n");
				query.append(", TEMP49 AS USER_NAME \n");
				query.append(", TEMP50 AS USER_ID \n");
				query.append(", TEMP51 AS CREATE_DATE \n");
				query.append(", TEMP52 AS ECO_NO \n");
				query.append(", TEMP53 AS REMARK \n");
				query.append(", TEMP54 AS BOM_ITEM_DETAIL \n");
				query.append(", TEMP55 AS ERRORCODE \n");
				query.append(", TEMP56 AS PROCESS \n");
				query.append(", TEMP57 AS SSC_BOM_DATE \n");
				query.append(", TEMP58 AS MODIFY_SUPPLY \n");
				query.append(", TEMP59 AS SSC_SUB_ID \n");
				query.append(" FROM STX_TBC_TEMP \n");
				query.append("WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append("ORDER BY TEMP5, TEMP12, TEMP1, TEMP10 \n");
				
			}else if(qryExp.equals("itemUpdateAction")){
				
				query.append("UPDATE STX_TBC_SSC_HEAD A \n");
				query.append("SET BOM_QTY = ? \n");
				query.append("  , STATE_FLAG = ? \n");				
				query.append("  , BOM5 = MOTHER_CODE \n");
				query.append("  , BOM7 = ? \n");
				query.append("  , BOM_ITEM_DETAIL = ? \n");
				query.append("  , ECO_NO = '' \n");
				query.append("WHERE MOTHER_CODE = ? \n");
				query.append("  AND ITEM_CODE = ? \n");
				
			}else if(qryExp.equals("itemDeleteHeadAction")){
				
				query.append("DELETE STX_TBC_SSC_HEAD \n");
				query.append("WHERE SSC_SUB_ID = ? \n");
				
			}else if(qryExp.equals("itemAddHeadAction")){
				query.append("INSERT INTO STX_TBC_RAWLEVEL ( \n");
				query.append("            MOTHER_CODE \n");
				query.append("          , ITEM_CODE \n");
				query.append("          , BOM_QTY \n");
				query.append("          , USER_ID \n");
				query.append("          , USER_NAME \n");
				query.append("          , CREATE_DATE \n");
				query.append("          , TYPE \n");
				query.append("          , STATE_FLAG \n");
				query.append("          , BOM7 \n");
				query.append("          , BOM_ITEM_DETAIL \n");
				query.append(") VALUES ( \n");
				query.append("  ? \n");
				query.append(", ? \n");
				query.append(", ? \n");
				query.append(", ? \n");
				query.append(", ? \n");
				query.append(", SYSDATE \n");
				query.append(", 'BUYBUY' \n");
				query.append(", 'A' \n");
				query.append(", ? \n");
				query.append(", ? \n");
				query.append(") \n");
			}  else if(qryExp.equals("itemDeleteSubAction")){
				
				query.append("DELETE STX_TBC_SSC_SUB\n");
				query.append("WHERE SSC_SUB_ID = ? \n");
			} 
			
			
			
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	private int getIsItemCount(String p_item_code, String p_mother_code) throws Exception {
        Connection conn = null;
        conn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   = new StringBuffer();
    	
        int v_isItemCnt= 0;
        
    	try 
        { 
        	query.append("SELECT COUNT(*) AS CNT \n");
			query.append("  FROM STX_TBC_RAWLEVEL STR \n");
			query.append(" WHERE STR.MOTHER_CODE = '"+p_mother_code+"' \n");
			query.append("   AND STR.ITEM_CODE = '"+p_item_code+"' \n");
			
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
	
	private int ModifyAddModule(RequestBox rBox, Connection conn, String p_mother_code, String p_bom_qty, String p_item_code, String p_supply, String p_bom_item_detail) throws Exception {
		// TODO Auto-generated method stub		
		
        PreparedStatement 	pstmt 	= null;
        
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	
    	String				query   = "";
        try 
        { 
        	String ss_userid = rBox.getSession("UserId");
        	String ss_username = rBox.getSession("UserName");
        	
        	//Head �Է�
        	query  = getQuery("itemAddHeadAction",rBox);
        	pstmt = conn.prepareStatement(query.toString());
        	
			
        	int idx = 0;
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, p_item_code);
        	pstmt.setString(++idx, p_bom_qty);
        	pstmt.setString(++idx, ss_userid);
        	pstmt.setString(++idx, ss_username);
        	pstmt.setString(++idx, p_supply);        	
        	pstmt.setString(++idx, p_bom_item_detail);
        	
        	isOk = pstmt.executeUpdate();
        	
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
        }        
		return isOkRtn;
	}
	private int ModifyModifyModule(RequestBox rBox, Connection conn, String p_mother_code, String p_item_code,  String p_state, String p_bom_qty, String p_bom_item_detail, String p_supply) throws Exception {
		// TODO Auto-generated method stub		
		
        PreparedStatement 	pstmt 	= null;
        
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	
    	String				query   = "";
        try 
        { 
			//Modify
			query  = getQuery("itemUpdateAction",rBox);
			pstmt = conn.prepareStatement(query.toString());			
			int idx = 0;
        	pstmt.setString(++idx, p_bom_qty);
        	pstmt.setString(++idx, p_state);        	
        	pstmt.setString(++idx, p_supply);
        	pstmt.setString(++idx, p_bom_item_detail);        	
        	pstmt.setString(++idx, p_mother_code);
        	pstmt.setString(++idx, p_item_code);
        	
        	isOk = pstmt.executeUpdate();
        	System.out.println("delisOk"+isOk);
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
        }        
		return isOkRtn;
	}
	private int ModifyDeleteModule(RequestBox rBox, Connection conn, String p_ssc_sub_id) throws Exception {
		// TODO Auto-generated method stub		
		
        PreparedStatement 	pstmt 	= null;
        
    	int 				isOkRtn    = 0;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	//Head �Է�
        	query  = getQuery("itemDeleteHeadAction",rBox);
			pstmt = conn.prepareStatement(query.toString());

			int idx = 0;
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
        }        
		return isOkRtn;
	}
	
	
	private boolean buybuyModifyCheckTempInsert(RequestBox box) throws Exception {
		
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
  			String p_selrev = box.getString("p_selrev");
  			String p_dwgno = box.getString("p_dwgno");
			String p_mother_code = box.getString("p_mother_code");
			
  			int v_errorCode = 0;
			String v_process = "OK";
			

			ArrayList ar_itemcode = box.getArrayList("p_item_code");
			ArrayList ar_modifyEA = box.getArrayList("p_modifyEA");
			ArrayList ar_modifyDetail = box.getArrayList("p_modifyDetail");
			ArrayList ar_modifySupply = box.getArrayList("p_modifySupply");
			ArrayList ar_ea = box.getArrayList("p_ea");
			
			ArrayList ar_lproject_no = box.getArrayList("p_lproject_no");
			ArrayList ar_lblock_no = box.getArrayList("p_lblock_no");
			
			String v_itemcode = "";
			String v_modifyEA = "";
			String v_EA = "";
			String v_modifyDetail = "";
			
			//TEMP DATA ����
			query = "DELETE STX_TBC_TEMP WHERE USER_ID = '"+ssUserid+"'";
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP ����
				
			
  			//������ ���� ���� ����.
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
				v_itemcode = ar_itemcode.get(j).toString().trim();
				
				//���� �޷��ִ��� �Ǵ�.
				int isItemCnt = getIsItemCount(v_itemcode, p_mother_code);
				
				//���� ���� ���� �޾ƿ�.
					query = getQueryMove(v_modifyEA, isItemCnt, p_mother_code);
 
					pstmt = conn.prepareStatement(query.toString());
					int idx =0;
					
					pstmt.setString(++idx, ssUserid);
					pstmt.setString(++idx, p_selrev);
					pstmt.setInt   (++idx, v_errorCode);
					pstmt.setString(++idx, v_process);
					pstmt.setString(++idx, ar_lproject_no.get(j).toString());
					pstmt.setString(++idx, v_itemcode);
					pstmt.setString(++idx, ar_lblock_no.get(j).toString());
					pstmt.setString(++idx, p_dwgno);
					pstmt.setString(++idx, v_EA);
					
					//�ű�� ���� �ִ� ���.
				if(isItemCnt > 0){
					pstmt.setString(++idx, ssUserid);
					pstmt.setString(++idx, p_selrev);
					pstmt.setString(++idx, v_modifyDetail);
					pstmt.setInt   (++idx, v_errorCode);
					pstmt.setString(++idx, v_process);
					pstmt.setString(++idx, ar_modifySupply.get(j).toString());
					pstmt.setString(++idx, ar_lproject_no.get(j).toString());
					pstmt.setString(++idx, p_block);
					pstmt.setString(++idx, v_itemcode);
					pstmt.setString(++idx, p_dwgno);
					
				
					
				}else{ //�ű�� ���� ��� ���.
					
					if(p_mother_code.equals("")){
						v_process = "NO";							
					}
					
					pstmt.setString(++idx, ssUserid);
					pstmt.setString(++idx, p_mother_code);
					if(p_mother_code.equals("")){				
						pstmt.setString(++idx, "e");
					}else{
						pstmt.setString(++idx, "");
					}
					pstmt.setString(++idx, v_itemcode);
					pstmt.setString(++idx, p_selrev);
					pstmt.setString(++idx, v_modifyDetail);
					pstmt.setInt   (++idx, v_errorCode);
					pstmt.setString(++idx, v_process);
					pstmt.setString(++idx, ar_modifySupply.get(j).toString());
					pstmt.setString(++idx, ar_lproject_no.get(j).toString());
					pstmt.setString(++idx, v_itemcode);
					pstmt.setString(++idx, p_dwgno);
					pstmt.setString(++idx, v_EA);
					pstmt.setString(++idx, ar_lblock_no.get(j).toString());
					
				}

				isOk += pstmt.executeUpdate();
	        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				
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
	
	private String getQueryMove(String v_modifyEA, int isItemCnt, String vMotherCode) throws Exception {
		//TODO GET QUERY MOVE
		
		StringBuffer query = new StringBuffer();		
		
		query.append("  INSERT INTO STX_TBC_TEMP( \n");
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
		query.append("  ) \n");
		//�Ű����� ��� ������ ����.
		query.append("SELECT \n");
		query.append(" ? \n");
		query.append(", CASE WHEN A.BOM_QTY - '"+v_modifyEA+"' <= 0 THEN 'D' \n");
		query.append("       ELSE CASE WHEN A.ECO_NO IS NULL THEN A.STATE_FLAG  \n");
		query.append("                 ELSE 'C' \n");
		query.append("            END \n");
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
		query.append(", A.BOM_QTY AS EA \n");		
		query.append(", TO_CHAR(A.BOM_QTY - '"+v_modifyEA+"') AS MODIFY_EA \n");
		query.append(", C.ITEM_DESC \n");
		query.append(", C.ITEM_DESC_DETAIL \n");
		query.append(", C.ITEM_WEIGHT \n");
		query.append(", ? AS REV_NO \n");
		query.append(", A.USER_NAME \n");
		query.append(", A.USER_ID \n");
		query.append(", A.CREATE_DATE \n");
		query.append(", A.ECO_NO \n");
		query.append(", A.REMARK \n");
		query.append(", A.BOM_ITEM_DETAIL \n");
		query.append(", ? AS ERRORCODE \n");
		query.append(", ? AS PROCESS \n");
		query.append(", STP.SSC_BOM_DATE \n");
		query.append(", BOM7 AS MODIFY_SUPPLY \n");
		query.append(", A.SSC_SUB_ID \n");
		query.append("FROM STX_TBC_SSC_HEAD A \n");		
		query.append("INNER JOIN STX_TBC_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
		query.append("LEFT JOIN STX_TBC_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
		query.append("WHERE A.PROJECT_NO = ? \n");
		query.append("  AND A.ITEM_CODE = ? \n");
		query.append("  AND STP.BLOCK_NO = ? \n");
		query.append("  AND A.DWG_NO = ? \n");	
		query.append("  AND A.BOM_QTY = ? \n");
		query.append("  AND A.STATE_FLAG <> 'D' \n");
		
		query.append("UNION \n");
		
		if(isItemCnt > 0){
			//�ű�� ���� �ִ� ���.
			query.append("SELECT \n");
			query.append(" ? \n");
			query.append(", CASE WHEN A.ECO_NO IS NULL THEN A.STATE_FLAG \n");
			query.append("    ELSE 'C' \n");
			query.append("  END AS STATE \n");
			query.append(", 'C' AS STATE_BUSINESS \n");
			query.append(", A.STATE_FLAG \n");
			query.append(", STSH.MASTER_SHIP \n");
			query.append(", STSH.PROJECT_NO \n");
			query.append(", STSH.DWG_NO \n");
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
			query.append(", A.BOM_QTY AS EA \n");
			query.append(", TO_CHAR(A.BOM_QTY + "+v_modifyEA+") AS MODIFY_EA \n");
			query.append(", C.ITEM_DESC \n");
			query.append(", C.ITEM_DESC_DETAIL \n");
			query.append(", C.ITEM_WEIGHT \n");
			query.append(", ? AS REV_NO \n");
			query.append(", A.USER_NAME \n");
			query.append(", A.USER_ID \n");
			query.append(", A.CREATE_DATE \n");
			query.append(", A.ECO_NO \n");
			query.append(", A.REMARK \n");
			query.append(", ? AS BOM_ITEM_DETAIL \n");
			query.append(", ? AS ERRORCODE \n");
			query.append(", ? AS PROCESS \n");
			query.append(", STP.SSC_BOM_DATE \n");
			query.append(", ? AS MODIFY_SUPPLY \n");
			query.append(", A.SSC_SUB_ID \n");
			query.append("FROM STX_TBC_RAWLEVEL A \n");
			query.append("INNER JOIN STX_TBC_SSC_HEAD STSH ON A.MOTHER_CODE = STSH.ITEM_CODE \n");
			query.append("INNER JOIN STX_TBC_PENDING  STP  ON STSH.MOTHER_CODE = STP.MOTHER_CODE \n");
			query.append(" LEFT JOIN STX_TBC_ITEM     C    ON A.ITEM_CODE = C.ITEM_CODE \n");
			query.append("WHERE STSH.PROJECT_NO = ? \n");
			query.append("  AND STP.BLOCK_NO    = ? \n");
			query.append("  AND A.ITEM_CODE     = ? \n");
			query.append("  AND STSH.DWG_NO     = ? \n");
			query.append("  AND A.TYPE          = 'BUYBUY' \n");
			
			
		}else{
			
			//�ű�� ���� ��� ���...�߰� ����
			query.append("SELECT \n");
			query.append(" ? \n");
			query.append(", 'A' AS STATE \n");
			query.append(", 'A' AS STATE_BUSINESS \n");
			query.append(", A.STATE_FLAG \n");
			query.append(", A.MASTER_SHIP \n");
			query.append(", A.PROJECT_NO \n");
			query.append(", A.DWG_NO \n");
			query.append(", STP.BLOCK_NO AS BLOCK_NO \n");
			query.append(", STP.STR_FLAG AS STR_FLAG \n");
			query.append(", STP.STAGE_NO AS STAGE_NO \n");
			query.append(", ? AS MOTHER_CODE \n");
			query.append(", ? AS ERROR_MOTHER_CODE \n");
			query.append(", ? AS ITEM_CODE \n");
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
			query.append(", A.BOM_QTY AS EA \n");			
			query.append(", '"+v_modifyEA+"' AS MODIFY_EA \n");
			query.append(", C.ITEM_DESC \n");
			query.append(", C.ITEM_DESC_DETAIL \n");
			query.append(", C.ITEM_WEIGHT \n");
			query.append(", ? AS REV_NO \n");
			query.append(", A.USER_NAME \n");
			query.append(", A.USER_ID \n");
			query.append(", A.CREATE_DATE \n");
			query.append(", A.ECO_NO \n");
			query.append(", A.REMARK \n");
			query.append(", ? AS BOM_ITEM_DETAIL \n");
			query.append(", ? AS ERRORCODE \n");
			query.append(", ? AS PROCESS \n");
			query.append(", STP.SSC_BOM_DATE \n");
			query.append(", ? AS MODIFY_SUPPLY \n");
			query.append(", A.SSC_SUB_ID \n");
			query.append("FROM STX_TBC_SSC_HEAD A \n");
			query.append("INNER JOIN STX_TBC_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
			query.append("LEFT JOIN STX_TBC_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
			query.append("WHERE A.PROJECT_NO = ? \n");
			query.append("  AND A.ITEM_CODE = ? \n");
			query.append("  AND A.DWG_NO = ? \n");
			query.append("  AND A.BOM_QTY = ? \n");
			query.append("  AND STP.BLOCK_NO = ? \n");
		}
		return query.toString();
	}
}