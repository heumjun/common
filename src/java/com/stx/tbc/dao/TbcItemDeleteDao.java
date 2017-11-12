package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;

public class TbcItemDeleteDao implements Idao{

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
        	
        	if(qryExp.equals("itemDeleteCheck")){
        		boolean rtn = itemDeleteCheckTempInsert(rBox);
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
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	query  = getQuery(qryExp,rBox);
        	pstmt = conn.prepareStatement(query.toString());
        	isOk = pstmt.executeUpdate();
        	        	
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
		// TODO Auto-generated method stub
		return false;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
//		 TODO Auto-generated method stub
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
//        PreparedStatement 	pstmt 	= null;
        CallableStatement cstmt = null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	
//        	ArrayList ar_eco_no = rBox.getArrayList("p_eco_no");
//        	ArrayList list = rBox.getArrayList("p_chkItem");
//        	ArrayList ar_selrev = rBox.getArrayList("p_selrev");
//        	ArrayList ar_mother_code = rBox.getArrayList("p_mother_code");
//        	ArrayList ar_item_code = rBox.getArrayList("p_item_code");
//        	
//        	TBCCommonValidation commonValidation = new TBCCommonValidation();
//        	Idao dao = new TbcConfirmDao();
//        	
//        	for(int i=0; i<ar_eco_no.size(); i++){
//        		if(!ar_eco_no.get(i).toString().equals("")){	
//        			query  = getQuery("DValueAction",rBox);
//                	pstmt = conn.prepareStatement(query.toString());                	
//    	        	pstmt.setString(1, ar_selrev.get(i).toString());
//    	        	pstmt.setString(2, list.get(i).toString());
//    	        }else{
//    	        	query  = getQuery("DeleteAction",rBox);
//                	pstmt = conn.prepareStatement(query.toString());
//    	        	pstmt.setString(1, list.get(i).toString());
//    	        }
//        		
//        		isOk = pstmt.executeUpdate();
//        		if(isOk > 0){
//        			isAllOk++;
//        		}
//        		if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
//        	}
        	

        	query  = getQuery(qryExp,rBox);
        	
        	
        	cstmt = conn.prepareCall(query.toString());

    		cstmt.setString(1, rBox.getSession("UserId"));
    		cstmt.registerOutParameter(2, Types.NUMERIC);
    		cstmt.registerOutParameter(3, Types.VARCHAR);
    		
    		cstmt.executeQuery();
    		isOk = cstmt.getInt(2);
    		String msg = cstmt.getString(3);
    		
    		if(isOk > 0){
        		conn.commit();
        		
        		//Common Validation 상위정보가 변경 되었을 때 Confirm 필드에 추가해준다.
//            	for(int i = 0; i < ar_eco_no.size(); i++){
//    	        	if(commonValidation.getUppChangeFlag(ar_mother_code.get(i).toString(), ar_item_code.get(i).toString())){
//    					dao.updateDB("ConfirmAction", rBox);
//    				}
//            	}
            	
        		rBox.put("successMsg", "Success");
        		rtn = true;
        	}else{
        		conn.rollback();
        		rBox.put("errorMsg", msg);
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
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
			if(qryExp.equals("deleteList")){
				ArrayList chklist = box.getArrayList("p_chkItem");
				
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
				
				
			} else if(qryExp.equals("itemDeleteCheck")){
				query.append("SELECT DISTINCT\n");
				query.append("	  TEMP1  AS STATE \n");
				query.append("	, TEMP2  AS STATE_FLAG \n");
				query.append("	, TEMP3  AS DELEGATEPROJECTNO \n");
				query.append("	, TEMP4  AS PROJECT_NO \n");
				query.append("	, TEMP5  AS DWG_NO \n");
				query.append("	, TEMP6  AS BLOCK_NO \n");
				query.append("	, TEMP7  AS STR_FLAG \n");
				query.append("	, TEMP8  AS STAGE_NO \n");
				query.append("	, TEMP9  AS MOTHER_CODE \n");
				query.append("	, TEMP10 AS ITEM_CODE \n");
				query.append("	, TEMP11 AS BOM1 \n");
				query.append("	, TEMP12 AS BOM2 \n");
				query.append("	, TEMP13 AS BOM3 \n");
				query.append("	, TEMP14 AS BOM4 \n");
				query.append("	, TEMP15 AS BOM5 \n");
				query.append("	, TEMP16 AS BOM6 \n");
				query.append("	, TEMP17 AS BOM7 \n");
				query.append("	, TEMP18 AS BOM8 \n");
				query.append("	, TEMP19 AS BOM9 \n");
				query.append("	, TEMP20 AS BOM10 \n");
				query.append("	, TEMP21 AS BOM11 \n");
				query.append("	, TEMP22 AS BOM12 \n");
				query.append("	, TEMP23 AS BOM13 \n");
				query.append("	, TEMP24 AS BOM14 \n");
				query.append("	, TEMP25 AS BOM15 \n");
				query.append("	, TEMP26 AS ATTR1 \n");
				query.append("	, TEMP27 AS ATTR2 \n");
				query.append("	, TEMP28 AS ATTR3 \n");
				query.append("	, TEMP29 AS ATTR4 \n");
				query.append("	, TEMP30 AS ATTR5 \n");
				query.append("	, TEMP31 AS ATTR6 \n");
				query.append("	, TEMP32 AS ATTR7 \n");
				query.append("	, TEMP33 AS ATTR8 \n");
				query.append("	, TEMP34 AS ATTR9 \n");
				query.append("	, TEMP35 AS ATTR10 \n");
				query.append("	, TEMP36 AS ATTR11 \n");
				query.append("	, TEMP37 AS ATTR12 \n");
				query.append("	, TEMP38 AS ATTR13 \n");
				query.append("	, TEMP39 AS ATTR14 \n");
				query.append("	, TEMP40 AS ATTR15 \n");
				query.append("	, TEMP41 AS SSC_SUB_ID \n");
				query.append("	, TEMP42 AS EA \n");
				query.append("	, TEMP43 AS ITEM_WEIGHT \n");
				query.append("	, TEMP44 AS ITEM_DESC \n");
				query.append("	, TEMP62 AS REV_NO \n");
				query.append("	, TEMP63 AS DEPT_NAME \n");
				query.append("	, TEMP64 AS DEPT_CODE \n");
				query.append("	, TEMP65 AS USER_NAME \n");
				query.append("	, TEMP66 AS USER_ID \n");
				query.append("	, TEMP67 AS CREATE_DATE \n");
				query.append("	, TEMP68 AS ECO_NO \n");
				query.append("	, TEMP69 AS KEY_NO \n");
				query.append("	, TEMP70 AS REMARK \n");
				query.append("	, TEMP71 AS ITEM_TYPE_CD \n");
				query.append("	, TEMP72 AS ERRORCODE \n");
				query.append("	, TEMP73 AS PROCESS \n");
				query.append(" FROM STX_DIS_TEMP \n");
				query.append("WHERE USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append("ORDER BY TEMP4, TEMP8, TEMP7 \n");
				
			} else if(qryExp.equals("DeleteAction")){

				query.append("{call STX_DIS_SSC_DELETE_ACTION_PROC(?, ?, ?)} ");
				
			} else if(qryExp.equals("DValueAction")){
				//안씀
				query.append("UPDATE STX_DIS_SSC_HEAD \n");
				query.append("SET STATE_FLAG = 'D' \n");
				query.append("  , ECO_NO = '' \n");
				query.append("  , REV_NO = ? \n");
				query.append("WHERE PROJECT_NO || ITEM_TYPE_CD || DWG_NO || MOTHER_CODE || ITEM_CODE || SSC_SUB_ID = ? ");
				
			} 
			
			
			
			
//			System.out.println(query);
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	

	public boolean itemDeleteCheckTempInsert(RequestBox box) throws Exception {
		// TODO Auto-generated method stub
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	StringBuffer		query   = new StringBuffer();
        try 
        {
			int v_errorCode = 0;
			int v_seriesFlag = 0;
			
			String v_process = "OK";
			String v_selrev = box.getString("p_selrev");
			String v_dwgno = box.getString("p_dwgno");
			String ssUserid = box.getSession("UserId");
			
			ArrayList ar_series = box.getArrayList("p_series");
			ArrayList ar_itemcode = box.getArrayList("p_item_code");
			ArrayList ar_mother_code = box.getArrayList("p_mother_code");
			ArrayList ar_lproject_no = box.getArrayList("p_lproject_no");
			ArrayList ar_lstage_no = box.getArrayList("p_lstage_no");
			ArrayList ar_ea = box.getArrayList("p_ea");
			ArrayList ar_block_no = box.getArrayList("p_lblock_no");
			ArrayList ar_str_flag = box.getArrayList("p_lstr_flag");
			
			
			String v_itemcode = "";
			
			//key_no 용도 : Valve의 경우 같은 Mother에 같은 ItemCode가 존재하기 때문에 key No를 이용하여 구분한다.(key_no가 다르면 다른아이템이라고 판단)
			ArrayList ar_key_no = box.getArrayList("p_key_no");
			
			
			//시리즈 선택이 없을 경우 해당 Project만 수행 한다.
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

			//TEMP DATA 삭제
			query.append("DELETE STX_DIS_TEMP WHERE USER_ID = '"+ssUserid+"'");
			pstmt = conn.prepareStatement(query.toString());
			pstmt.executeUpdate();
			//TEMP 삭제
			
			
			//query.append("SELECT * FROM ( \n");
			
			for(int j=0; j<ar_itemcode.size(); j++){
				v_itemcode = ar_itemcode.get(j).toString().trim();
				
				
				
				
				if(ar_series.size() > 0){ //시리즈 기준.
					for(int i=0; i<ar_series.size(); i++){

						query.delete(0, query.length());
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
						query.append("  	      , TEMP62 \n");
						query.append("  	      , TEMP63 \n");
						query.append("  	      , TEMP64 \n");
						query.append("  	      , TEMP65 \n");
						query.append("  	      , TEMP66 \n");
						query.append("  	      , TEMP67 \n");
						query.append("  	      , TEMP68 \n");
						query.append("  	      , TEMP69 \n");
						query.append("  	      , TEMP70 \n");
						query.append("  	      , TEMP71 \n");
						query.append("  	      , TEMP72 \n");
						query.append("  	      , TEMP73 \n");
						query.append("  	      , TEMP74 \n");
						query.append("  	      ) \n");
						query.append("SELECT DISTINCT\n");
						query.append("  '"+ssUserid+"' \n");
						query.append(", 'D' AS STATE \n");
						query.append(", A.STATE_FLAG \n");
						query.append(", A.MASTER_SHIP \n");
						query.append(", A.PROJECT_NO \n");
						query.append(", A.DWG_NO \n");
						query.append(", STP.BLOCK_NO \n");
						query.append(", STP.STR_FLAG \n");
						query.append(", STP.STAGE_NO \n");
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
						query.append(", A.BOM_QTY \n");
						query.append(", C.ITEM_WEIGHT \n");
						query.append(", C.ITEM_DESC \n");
						query.append(", '"+v_selrev+"' AS REV_NO \n");
						query.append(", A.DEPT_NAME \n");
						query.append(", A.DEPT_CODE \n");
						query.append(", A.USER_NAME \n");
						query.append(", A.USER_ID \n");
						query.append(", A.CREATE_DATE \n");
						query.append(", A.ECO_NO \n");
						query.append(", A.KEY_NO \n");
						query.append(", A.REMARK \n");
						query.append(", A.ITEM_TYPE_CD \n");
						query.append(", '"+v_errorCode+"' AS ERRORCODE \n");
						query.append(", '"+v_process+"' AS PROCESS \n");
						query.append(", A.UPP_CONFIRM_DATE \n");
						query.append("FROM STX_DIS_SSC_HEAD A \n");
						query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
						query.append("INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
						query.append("WHERE A.PROJECT_NO = ? \n");
						query.append("  AND A.DWG_NO = '"+v_dwgno+"' \n");
						query.append("  AND A.STATE_FLAG <> 'D' \n");
						query.append("  AND A.ITEM_CODE = '"+v_itemcode+"' \n");
						if(ar_ea != null && ar_ea.size() > 0 && !ar_ea.get(j).toString().equals("")){
							query.append("  AND A.BOM_QTY = '"+  ar_ea.get(j).toString().trim()+"' \n");
						}
						if(ar_lstage_no != null && ar_lstage_no.size() > 0){
							if(ar_lstage_no.get(j).toString().equals("")){
								query.append("  AND STP.STAGE_NO IS NULL \n");
							}else{
								query.append("  AND STP.STAGE_NO = '"+ar_lstage_no.get(j).toString()+"' \n");
							}
						}
						if(ar_block_no != null && ar_block_no.size() > 0){
							query.append("  AND STP.BLOCK_NO = '"+ar_block_no.get(j).toString()+"' \n");
						}						
						if(ar_str_flag != null && ar_str_flag.size() > 0){
							query.append("  AND STP.STR_FLAG = '"+ar_str_flag.get(j).toString()+"' \n");
						}
						if(ar_key_no != null && ar_key_no.size() > 0 && !ar_key_no.get(j).toString().equals("")){
							query.append("  AND A.KEY_NO = '"+ar_key_no.get(j).toString()+"' \n");
						}
						pstmt = conn.prepareStatement(query.toString());
						pstmt.setString(1,ar_series.get(i).toString().trim());
						
			        	isOk += pstmt.executeUpdate();
			        	
			        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
					}
				}else{ //행 기준.
					query.delete(0, query.length());
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
					query.append("  	      , TEMP62 \n");
					query.append("  	      , TEMP63 \n");
					query.append("  	      , TEMP64 \n");
					query.append("  	      , TEMP65 \n");
					query.append("  	      , TEMP66 \n");
					query.append("  	      , TEMP67 \n");
					query.append("  	      , TEMP68 \n");
					query.append("  	      , TEMP69 \n");
					query.append("  	      , TEMP70 \n");
					query.append("  	      , TEMP71 \n");
					query.append("  	      , TEMP72 \n");
					query.append("  	      , TEMP73 \n");
					query.append("  	      , TEMP74 \n");
					query.append("  	      ) \n");
					query.append("SELECT DISTINCT\n");
					query.append("  '"+ssUserid+"' \n");
					query.append(", 'D' AS STATE \n");
					query.append(", A.STATE_FLAG \n");
					query.append(", A.MASTER_SHIP \n");
					query.append(", A.PROJECT_NO \n");
					query.append(", A.DWG_NO \n");
					query.append(", STP.BLOCK_NO \n");
					query.append(", STP.STR_FLAG \n");
					query.append(", STP.STAGE_NO \n");
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
					query.append(", A.BOM_QTY \n");
					query.append(", C.ITEM_WEIGHT \n");
					query.append(", C.ITEM_DESC \n");
					query.append(", '"+v_selrev+"' AS REV_NO \n");
					query.append(", A.DEPT_NAME \n");
					query.append(", A.DEPT_CODE \n");
					query.append(", A.USER_NAME \n");
					query.append(", A.USER_ID \n");
					query.append(", A.CREATE_DATE \n");
					query.append(", A.ECO_NO \n");
					query.append(", A.KEY_NO \n");
					query.append(", A.REMARK \n");
					query.append(", A.ITEM_TYPE_CD \n");
					query.append(", '"+v_errorCode+"' AS ERRORCODE \n");
					query.append(", '"+v_process+"' AS PROCESS \n");
					query.append(", A.UPP_CONFIRM_DATE \n");
					query.append("FROM STX_DIS_SSC_HEAD A \n");
					query.append("INNER JOIN STX_DIS_PENDING STP ON A.MOTHER_CODE = STP.MOTHER_CODE \n");
					query.append("INNER JOIN STX_DIS_ITEM C ON A.ITEM_CODE = C.ITEM_CODE \n");
					query.append("WHERE A.PROJECT_NO = ? \n");
					query.append("  AND A.DWG_NO = '"+v_dwgno+"' \n");
					query.append("  AND A.STATE_FLAG <> 'D' \n");
					query.append("  AND A.ITEM_CODE = '"+v_itemcode+"' \n");
					query.append("  AND A.MOTHER_CODE = '"+ar_mother_code.get(j).toString()+"' \n");
					
					if(ar_ea != null && ar_ea.size() > 0 && !ar_ea.get(j).toString().equals("")){
						query.append("  AND A.BOM_QTY = '"+  ar_ea.get(j).toString().trim()+"' \n");
					}
					if(ar_lstage_no != null && ar_lstage_no.size() > 0){
						if(ar_lstage_no.get(j).toString().equals("")){
							query.append("  AND STP.STAGE_NO IS NULL \n");
						}else{
							query.append("  AND STP.STAGE_NO = '"+ar_lstage_no.get(j).toString()+"' \n");
						}
					}
					if(ar_block_no != null && ar_block_no.size() > 0){
						query.append("  AND STP.BLOCK_NO = '"+ar_block_no.get(j).toString()+"' \n");
					}						
					if(ar_str_flag != null && ar_str_flag.size() > 0){
						query.append("  AND STP.STR_FLAG = '"+ar_str_flag.get(j).toString()+"' \n");
					}
					if(ar_key_no != null && ar_key_no.size() > 0 && !ar_key_no.get(j).toString().equals("")){
						query.append("  AND A.KEY_NO = '"+ar_key_no.get(j).toString()+"' \n");
					}
					
					pstmt = conn.prepareStatement(query.toString());
					pstmt.setString(1,ar_lproject_no.get(j).toString().trim());
					
					isOk += pstmt.executeUpdate();
		        	
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
				}
//				System.out.println(j);
			}
			
			
//			query.append(") CHK_TABLE ORDER BY PROJECT_NO, BLOCK_NO, STAGE_NO, STR_FLAG \n");
			
			        	
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
}