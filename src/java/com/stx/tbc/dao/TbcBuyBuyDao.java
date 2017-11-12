package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcBuyBuyDao implements Idao{
	

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		
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
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	
        	if(qryExp.equals("deleteBuyBuy")){
        		
        		ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        		String vMotherCode = rBox.getString("p_mother_code");
        		
        		for(int i=0; i<ar_chkItem.size(); i++){
	        		String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
	        		String vItemCode = vChkItem[0];
	        		String vBomQty = vChkItem[1];
	        		String vStateFlag = vChkItem[2];
	        		String vSupply = "";
	        		if(vChkItem.length > 3){
	        			vSupply = vChkItem[3];
	        		}
	        		String vEcoNo = "";
	        		if(vChkItem.length > 4){
	        			vEcoNo = vChkItem[4];
	        		}
	        		
	        		String vProcess = "";
	        		//ECO가 없는 상태이면 완전 삭제 : 아니면 D값 입력
	        		if(vEcoNo.equals("")){
	        			vProcess = "deleteBuyBuy";	
	        		}else{
	        			vProcess = "dValueBuyBuy";
	        		}
	        		
	        		query  = getQuery(vProcess,rBox);
	        		pstmt = conn.prepareStatement(query.toString());
	        		int idx = 0;
	        		pstmt.setString(++idx, vMotherCode);
	        		pstmt.setString(++idx, vItemCode);
	        		
		        	isOk += pstmt.executeUpdate();
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        		}
        		
        		if(isOk != ar_chkItem.size()){
        			isOk = 0;
        		}
        		
        	}else{
	        	query  = getQuery(qryExp,rBox);
	        	pstmt = conn.prepareStatement(query.toString());
	        	isOk = pstmt.executeUpdate();
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
        }        
		return rtn;
	}

	public boolean insertDB(String qryExp, RequestBox rBox) throws Exception {
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	if(qryExp.equals("insertBuyBuy")){
        		
        		query  = getQuery(qryExp,rBox);
        		
        		String vMotherCode = rBox.getString("p_mother_code");
        		String vInputItemCode = "";
        		ArrayList ar_input_itemcode = rBox.getArrayList("p_input_itemcode");
        		ArrayList ar_bomqty = rBox.getArrayList("p_bomqty");
        		ArrayList ar_supply = rBox.getArrayList("p_supply");
        		ArrayList ar_remark = rBox.getArrayList("p_remark");
        		
        		for(int i = 0; i < ar_input_itemcode.size(); i++ ){
        			
        			vInputItemCode = ar_input_itemcode.get(i).toString().trim();
        			if(!vInputItemCode.equals("")){
			        	pstmt = conn.prepareStatement(query.toString());
			        	int idx = 0;
			        	pstmt.setString(++idx, vMotherCode);
			        	pstmt.setString(++idx, ar_input_itemcode.get(i).toString().trim());
			        	pstmt.setString(++idx, ar_bomqty.get(i).toString().trim());	        	
			        	pstmt.setString(++idx, rBox.getSession("UserId"));
			        	pstmt.setString(++idx, rBox.getSession("UserName"));
			        	pstmt.setString(++idx, ar_supply.get(i).toString().trim());
			        	pstmt.setString(++idx, ar_remark.get(i).toString().trim());
			        	
			        	isOk += pstmt.executeUpdate();
			        	
			        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        			}
        		}
        	}else{
	        	query  = getQuery(qryExp,rBox);
	        	pstmt = conn.prepareStatement(query.toString());
	        	isOk = pstmt.executeUpdate();
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
        }        
		return rtn;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	String 				rtnstr = "Ok";
        try 
        { 
        	
        	ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        	String ss_userid = rBox.getSession("UserId");
			String ss_username = rBox.getSession("UserName");
			String vMotherCode = rBox.getString("p_mother_code");
    		String p_eco_no = rBox.getString("p_eco_no");
    	
        	if(qryExp.equals("bomAction")){
        		
        		if(rtnstr.equals("Ok")){
	        		for(int i=0; i<ar_chkItem.size(); i++){
		        		String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
		        		String vItemCode = vChkItem[0];
		        		String vBomQty = vChkItem[1];
		        		String vStateFlag = vChkItem[2];		        		
		        		String vSupply = "";
		        		String vEco = "";
		        		
		        		if(vChkItem.length > 3){
		        			vSupply = vChkItem[3];
		        		}
		        		String vEcoNo = "";
		        		if(vChkItem.length > 4){
		        			vEcoNo = vChkItem[4];
		        		}
		        		
						String vBusineesStateFlag = "";
						//ECO - MotherCode 연계
						if(rtnstr.equals("Ok")){
							
							query  = getQuery("bomUpdateAction",rBox);
							
							pstmt = conn.prepareStatement(query.toString());
							int idx = 0;
							pstmt.setString(++idx, p_eco_no);
							pstmt.setString(++idx, vMotherCode);
							pstmt.setString(++idx, vItemCode);
							
							isOk += pstmt.executeUpdate();
							
							//완전 삭제의 경우. ECO NO를 History에 넣어준다. 시작
//							if(isOk > 0){
//								if(ar_state_flag.get(i).toString().equals("D")){
//									query  = getQuery("bomDeleteHistoryEcoUpdateAction",rBox);
//									
//									pstmt = conn.prepareStatement(query.toString());
//									int idx2 = 0;
//									pstmt.setString(++idx2, chklist.get(i).toString());
//									pstmt.setString(++idx2, ss_userid);							
//									pstmt.executeUpdate();
//								}
//							}
							//완전 삭제의 경우. ECO NO를 History에 넣어준다. 끝
//							System.out.println(isOk);
							if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
						}else{
							break;
						}
					
	        		}
        		}
        		
        	}else if(qryExp.equals("restoreAction")){ //Restore 기능 
        		for(int i=0; i<ar_chkItem.size(); i++){
	        		String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
	        		String vItemCode = vChkItem[0];
	        		
		        	query  = getQuery(qryExp,rBox);
		        	pstmt = conn.prepareStatement(query.toString());
		        	
		        	pstmt.setString(1, vItemCode);
		        	pstmt.setString(2, vMotherCode);
		        	
		        	isOk = pstmt.executeUpdate();
		        	pstmt.close();
        		}
        	}else if(qryExp.equals("updateBuyBuyEaModify")){ //Modify Update 기능
        		ArrayList ar_item_code = rBox.getArrayList("p_litem_code");
        		ArrayList ar_mother_code = rBox.getArrayList("p_lmother_code");
        		ArrayList ar_Bom7 = rBox.getArrayList("p_supply");
        		ArrayList ar_Ea = rBox.getArrayList("p_bomqty");
        		
        		query  = getQuery(qryExp,rBox);
        		
        		for(int i=0; i<ar_item_code.size(); i++){
        			
        			pstmt = conn.prepareStatement(query.toString());
        			
        			
        			pstmt.setString(1, ar_Ea.get(i).toString());
		        	pstmt.setString(2, ar_Bom7.get(i).toString());
		        	pstmt.setString(3, ar_mother_code.get(i).toString());
		        	pstmt.setString(4, ar_item_code.get(i).toString());
		        	
		        	isOk += pstmt.executeUpdate();
		        	pstmt.close();
		        	
        		}
        		
        		if(isOk != ar_item_code.size()){
        			isOk = 0;
        		}
        		
        	}else{
	        	query  = getQuery(qryExp,rBox);
	        	pstmt = conn.prepareStatement(query.toString());
	        	isOk = pstmt.executeUpdate();
        	}
        	
        	
        	if(isOk > 0){
        		conn.commit();
        		rBox.put("successMsg", "Success");
        		rtn = true;
        	}else{
        		conn.rollback();
        		if(!rtnstr.equals("Ok")){
        			rBox.put("errorMsg", rtnstr);
        		}else{
        			rBox.put("errorMsg", "Fail");
        		}        		
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

	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		
		try
		{
			if(qryExp.equals("BuyBuyList")){
				
				query.append("SELECT STR.STATE_FLAG \n");
				query.append("     , STI.ITEM_CATALOG \n");
				query.append("     , STR.ITEM_CODE \n");
				query.append("     , STI.ITEM_DESC \n");
				query.append("     , STR.BOM_QTY \n");
				query.append("     , STI.ITEM_WEIGHT \n");
				query.append("     , TO_CHAR(STR.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE  \n");
				query.append("     , STR.ECO_NO \n");
				query.append("     , STE.RELEASE_DATE \n");
				query.append("     , STR.BOM7 AS SUPPLY \n");
				query.append("     , STR.REMARK \n");
				query.append("     , STR.USER_NAME \n");
				query.append("  FROM STX_TBC_RAWLEVEL STR \n");
				query.append(" INNER JOIN STX_TBC_ITEM STI ON STR.ITEM_CODE = STI.ITEM_CODE \n");
				query.append("  LEFT JOIN STX_TBC_ECO STE ON STR.ECO_NO = STE.ECO_NO \n");
				query.append(" WHERE STR.MOTHER_CODE = '"+box.getString("p_mother_code")+"' \n");
				query.append("   AND TYPE = 'BUYBUY' \n");
				query.append(" ORDER BY ITEM_CODE \n");
				
			}else if(qryExp.equals("BuyBuyAutoCompleteList")){
				
				query.append("SELECT ITEM_CODE AS LABEL, ITEM_CODE AS VALUE \n");
				query.append("  FROM STX_TBC_ITEM \n");
				query.append(" WHERE ITEM_CODE LIKE '"+box.getString("term")+"%' \n");
				query.append("   AND ROWNUM < 100 \n");
				query.append(" ORDER BY ITEM_CODE \n");
				
			}else if(qryExp.equals("BuyBuyAutoCompleteObject")){
				query.append("SELECT ITEM_CATALOG \n");
				query.append("     , ITEM_DESC \n");
				query.append("     , ITEM_WEIGHT \n");
				query.append("   FROM STX_TBC_ITEM \n");
				query.append(" WHERE ITEM_CODE = '"+box.getString("p_input_itemcode")+"' \n");
				
			}else if(qryExp.equals("insertBuyBuy")){
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
	        	query.append("          , REMARK \n");
				query.append(") VALUES( \n");
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
			}else if(qryExp.equals("deleteBuyBuy")){
				
				query.append("DELETE STX_TBC_RAWLEVEL \n");
				query.append(" WHERE MOTHER_CODE = ? \n");
				query.append("   AND ITEM_CODE = ? \n");
				query.append("   AND TYPE = 'BUYBUY' \n");
				
			}else if(qryExp.equals("dValueBuyBuy")){
				
				query.append("UPDATE STX_TBC_RAWLEVEL \n");
				query.append("   SET STATE_FLAG = 'D' \n");
				query.append("     , ECO_NO = '' \n");
				query.append(" WHERE MOTHER_CODE = ? \n");
				query.append("   AND ITEM_CODE = ? \n");
				query.append("   AND TYPE = 'BUYBUY' \n");
				
			} else if(qryExp.equals("bomUpdateAction")){
	  			query.append("UPDATE STX_TBC_RAWLEVEL \n");
	  			query.append("   SET ECO_NO = ? \n");
	  			query.append(" WHERE MOTHER_CODE = ? \n");
	  			query.append("   AND ITEM_CODE = ? \n");
	  			query.append("   AND TYPE = 'BUYBUY' \n");
	  			query.append("   AND ECO_NO IS NULL \n");
	  			
			} else if(qryExp.equals("restoreAction")){
				
				query.append("MERGE INTO STX_TBC_RAWLEVEL A \n");
				query.append("USING ( \n");
				query.append("  SELECT * FROM ( \n");
				query.append("    SELECT STRH.MOTHER_CODE \n");
				query.append("         , STRH.ITEM_CODE \n");
				query.append("         , STRH.BOM_QTY \n");
				query.append("         , STRH.USER_ID \n");
				query.append("         , STRH.USER_NAME \n");
				query.append("         , STRH.CREATE_DATE \n");
				query.append("         , STRH.TYPE \n");
				query.append("         , STRH.ECO_NO \n");
				query.append("         , STRH.STATE_FLAG \n");
				query.append("         , ROW_NUMBER() OVER (ORDER BY STRH.HISTORY_UPDATE_DATE DESC) AS CNT \n");
				query.append("         , STRH.REMARK \n");
				query.append("         , STRH.BOM1 \n");
				query.append("         , STRH.BOM2 \n");
				query.append("         , STRH.BOM3 \n");
				query.append("         , STRH.BOM4 \n");
				query.append("         , STRH.BOM5 \n");
				query.append("         , STRH.BOM6 \n");
				query.append("         , STRH.BOM7 \n");
				query.append("         , STRH.BOM8 \n");
				query.append("         , STRH.BOM9 \n");
				query.append("         , STRH.BOM10 \n");
				query.append("         , STRH.BOM11 \n");
				query.append("         , STRH.BOM12 \n");
				query.append("         , STRH.BOM13 \n");
				query.append("         , STRH.BOM14 \n");
				query.append("         , STRH.BOM15 \n");
				query.append("      FROM STX_TBC_RAWLEVEL_HISTORY STRH \n");
				query.append("     WHERE STRH.ITEM_CODE = ? \n");
				query.append("       AND STRH.MOTHER_CODE = ? \n");
				query.append("       AND STRH.ECO_NO IS NOT NULL \n");
				query.append("  ) C WHERE C.CNT = 1 ) B \n");
				query.append("  ON (A.MOTHER_CODE = B.MOTHER_CODE \n");
				query.append(" AND  A.ITEM_CODE = B.ITEM_CODE) \n");
				query.append("WHEN MATCHED THEN \n");
				query.append("   UPDATE SET A.BOM_QTY          = B.BOM_QTY \n");
				query.append("            , A.USER_ID          = B.USER_ID \n");
				query.append("            , A.USER_NAME        = B.USER_NAME \n");
				query.append("            , A.CREATE_DATE      = B.CREATE_DATE \n");
				query.append("            , A.TYPE             = B.TYPE \n");
				query.append("            , A.ECO_NO           = B.ECO_NO \n");
				query.append("            , A.STATE_FLAG       = B.STATE_FLAG \n");
				query.append("            , A.BOM1	  		   = B.BOM1 \n");
				query.append("            , A.BOM2	  		   = B.BOM2 \n");
				query.append("            , A.BOM3	  		   = B.BOM3 \n");
				query.append("            , A.BOM4	  		   = B.BOM4 \n");
				query.append("            , A.BOM5	  		   = B.BOM5 \n");
				query.append("            , A.BOM6	  		   = B.BOM6 \n");
				query.append("            , A.BOM7	  		   = B.BOM7 \n");
				query.append("            , A.BOM8	  		   = B.BOM8 \n");
				query.append("            , A.BOM9	  		   = B.BOM9 \n");
				query.append("            , A.BOM10	  		   = B.BOM10 \n");
				query.append("            , A.BOM11	  		   = B.BOM11 \n");
				query.append("            , A.BOM12	  		   = B.BOM12 \n");
				query.append("            , A.BOM13	  		   = B.BOM13 \n");
				query.append("            , A.BOM14	  		   = B.BOM14 \n");
				query.append("            , A.BOM15	  		   = B.BOM15 \n");
				query.append("            , A.REMARK	       = B.REMARK \n");
				query.append("WHEN NOT MATCHED THEN \n");
				query.append("    INSERT ( A.MOTHER_CODE \n");
				query.append("           , A.ITEM_CODE \n");
				query.append("           , A.BOM_QTY \n");
				query.append("           , A.USER_ID \n");
				query.append("           , A.USER_NAME \n");
				query.append("           , A.CREATE_DATE \n");
				query.append("           , A.TYPE \n");
				query.append("           , A.ECO_NO \n");
				query.append("           , A.STATE_FLAG \n");				
				query.append("           , A.BOM1 \n");
				query.append("           , A.BOM2 \n");
				query.append("           , A.BOM3 \n");
				query.append("           , A.BOM4 \n");
				query.append("           , A.BOM5 \n");
				query.append("           , A.BOM6 \n");
				query.append("           , A.BOM7 \n");
				query.append("           , A.BOM8 \n");
				query.append("           , A.BOM9 \n");
				query.append("           , A.BOM10 \n");
				query.append("           , A.BOM11 \n");
				query.append("           , A.BOM12\n");
				query.append("           , A.BOM13 \n");
				query.append("           , A.BOM14 \n");
				query.append("           , A.BOM15 \n");
				query.append("           , A.REMARK \n");
				query.append("           ) \n");
				query.append("    VALUES ( B.MOTHER_CODE \n");
				query.append("           , B.ITEM_CODE \n");
				query.append("           , B.BOM_QTY \n");
				query.append("           , B.USER_ID \n");
				query.append("           , B.USER_NAME \n");
				query.append("           , B.CREATE_DATE \n");
				query.append("           , B.TYPE \n");
				query.append("           , B.ECO_NO \n");
				query.append("           , B.STATE_FLAG \n");
				query.append("           , B.BOM1 \n");
				query.append("           , B.BOM2 \n");
				query.append("           , B.BOM3 \n");
				query.append("           , B.BOM4 \n");
				query.append("           , B.BOM5 \n");
				query.append("           , B.BOM6 \n");
				query.append("           , B.BOM7 \n");
				query.append("           , B.BOM8 \n");
				query.append("           , B.BOM9 \n");
				query.append("           , B.BOM10 \n");
				query.append("           , B.BOM11 \n");
				query.append("           , B.BOM12\n");
				query.append("           , B.BOM13 \n");
				query.append("           , B.BOM14 \n");
				query.append("           , B.BOM15 \n");
				query.append("           , B.REMARK \n");
				query.append("           ) \n");
			} else if(qryExp.equals("itemSearchValidation")){
				query.append("SELECT ITEM_DESC \n");
				query.append("     , NVL((SELECT VALUE_NAME \n");
				query.append("          FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
				query.append("         WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
				query.append("           AND SCV.VALUE_CODE  = '10' \n");
				query.append("           AND SCV.ENABLE_FLAG = 'Y' \n");
				query.append("           AND CATALOG_CODE = STI.ITEM_CATALOG), 'N') AS ISBUYBUY \n");
				query.append("  FROM STX_TBC_ITEM STI \n");
				query.append(" WHERE ITEM_CODE = '"+box.getString("p_mother_code")+"' \n");
			} else if(qryExp.equals("selectBuyBuyEaModifyList")){			

	        	ArrayList ar_chkItem = box.getArrayList("p_chkItem");
	        	String vMotherCode = box.getString("p_mother_code");
	        	
				query.append("SELECT STR.STATE_FLAG \n");
				query.append("     , STI.ITEM_CATALOG \n");
				query.append("     , STR.ITEM_CODE \n");
				query.append("     , STR.MOTHER_CODE \n");
				query.append("     , STI.ITEM_DESC \n");
				query.append("     , STR.BOM_QTY \n");
				query.append("     , STI.ITEM_WEIGHT \n");
				query.append("     , TO_CHAR(STR.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE  \n");
				query.append("     , STR.ECO_NO \n");
				query.append("     , STE.RELEASE_DATE \n");
				query.append("     , STR.BOM7 AS SUPPLY \n");
				query.append("     , STR.REMARK \n");
				query.append("     , STR.USER_NAME \n");
				query.append("  FROM STX_TBC_RAWLEVEL STR \n");
				query.append(" INNER JOIN STX_TBC_ITEM STI ON STR.ITEM_CODE = STI.ITEM_CODE \n");
				query.append("  LEFT JOIN STX_TBC_ECO STE ON STR.ECO_NO = STE.ECO_NO \n");
				query.append(" WHERE STR.MOTHER_CODE = '"+vMotherCode+"' \n");
				query.append("   AND TYPE = 'BUYBUY' \n");
				query.append("   AND ( \n");				
				for(int i=0; i<ar_chkItem.size(); i++){
	        		String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
	        		String vItemCode = vChkItem[0];
	        		if(i > 0){
	        			query.append(" OR ");
	        		}
	        		query.append(" STR.ITEM_CODE = '"+vItemCode+"' \n");
	        	}
				query.append("   	  )\n");
				query.append(" ORDER BY ITEM_CODE \n");
				
				
			} else if(qryExp.equals("updateBuyBuyEaModify")){
				query.append("UPDATE STX_tbc_rawlevel \n");
				query.append("   SET BOM_QTY = ? \n");
				query.append("     , BOM7    = ? \n");
				query.append("     , ECO_NO  = '' \n");
				query.append("     , STATE_FLAG = CASE WHEN ECO_NO IS NULL \n");
				query.append("                         THEN STATE_FLAG \n");
				query.append("                         ELSE 'C' \n");
				query.append("                     END \n");
				query.append(" WHERE MOTHER_CODE = ? \n");
				query.append("   AND ITEM_CODE   = ? \n");
				query.append("   AND TYPE = 'BUYBUY' \n");
			} 
			
			
			
			
		}catch (Exception ex) 
		{
			ex.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	

}