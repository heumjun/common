package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.omg.PortableInterceptor.SUCCESSFUL;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonValidation;

import com.stx.tbc.dao.factory.Idao;

public class TbcUnitManagerDao implements Idao{
	

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
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	
        	if(qryExp.equals("unitDelete")){
        		
        		ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        		
        		for(int i=0; i<ar_chkItem.size(); i++){
        			String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
	        		String vActCode = vChkItem[0];
	        		String vUnitName = vChkItem[1];
	        		
	        		query  = getQuery(qryExp,rBox);
	        		
	        		pstmt = conn.prepareStatement(query.toString());
	        		int idx = 0;
	        		
	        		pstmt.setString(++idx, vActCode);
	        		pstmt.setString(++idx, vUnitName);
	        		
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
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	String				query2   = "";
    	ListSet             ls      = null;
        try 
        { 
        	
        	String vUserId = rBox.getSession("UserId");
        	String vUserName = rBox.getSession("UserName");
        	String vDeptCd = rBox.getSession("DeptCode");
        	String vDeptName = rBox.getSession("DeptName");
        	String vStr = "UN";
        	String vDescript = "";
        	String vItemCode = "";
        	String vCategoryCode = "";
        	
        	String p_catalog = rBox.getString("p_catalog");
    		String p_unit_name = rBox.getString("p_unit_name");
    		String p_master = rBox.getString("p_master");

        	
        	if(qryExp.equals("UnitExcelTempImport")){

        		//Temp Insert 
        		query  = getQuery(qryExp,rBox);
        		ArrayList insertList = rBox.getArrayList("insertList");
        		
        		for(int i = 0; i < insertList.size(); i++ ){
        			HashMap dbox2 = (HashMap)insertList.get(i);
        			
//		        	GET ITEM_CODE, DESCRIPTION
		        	query2  = getQuery("getItemCodeDesc", rBox);

		        	pstmt2 = conn.prepareStatement(query2.toString());
		        	
		        	System.out.println("MASTER : " + dbox2.get("column0").toString());
		        	
		        	pstmt2.setString(1, dbox2.get("column0").toString()); //MASTER_NO
		        	pstmt2.setString(2, dbox2.get("column6").toString()); //CATALOG
	    			
	                ls = new ListSet(conn);
	    		    ls.run(pstmt2);
	    		    
	                if ( ls.next() ){
	                	vDescript = ls.getString("catalog_desc");
	                	vItemCode = ls.getString("item_code");
	                	vCategoryCode = ls.getString("category_code");
	                }
	                
	                pstmt = conn.prepareStatement(query.toString());
		        	int idx = 0;
		        	
		        	pstmt.setString(++idx, dbox2.get("column3").toString()); //BLOCK_DIV_CD
		        	pstmt.setString(++idx, dbox2.get("column4").toString()); //ACTIVITY_CD
		        	pstmt.setString(++idx, dbox2.get("column0").toString()); //DELEGATE_PROJECT
		        	pstmt.setString(++idx, dbox2.get("column1").toString()); //USE_PROJECT
		        	pstmt.setString(++idx, dbox2.get("column2").toString()); //BLOCK_NO
		        	pstmt.setString(++idx, dbox2.get("column5").toString()); //ITEM_DESC
		        	pstmt.setString(++idx, vItemCode); //미채번값으로 고정 값
		        	pstmt.setString(++idx, vDescript); //Description 고정값
		        	pstmt.setString(++idx, dbox2.get("column7").toString()); //Unit Name
		        	pstmt.setString(++idx, vStr); //STR 고정값
		        	pstmt.setString(++idx, vDeptName);
		        	pstmt.setString(++idx, vDeptCd);
		        	pstmt.setString(++idx, vUserName);
		        	pstmt.setString(++idx, vUserId);
		        	pstmt.setString(++idx, vCategoryCode);
		        	pstmt.setString(++idx, dbox2.get("column6").toString()); //CATALOG
		        	
		        	
		        	isOk = pstmt.executeUpdate();
		        	if(isOk == 0){
	            		throw new Exception("UnitExcelTempImport 실패");
	            	}
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
    			
        		}        		
        		
        		//qryExp = "unitActivityList";
        		
        	}else if(qryExp.equals("unitAddInsert")){
        		
        		//GET ITEM_CODE, DESCRIPTION
            	query  = getQuery("getItemCodeDesc", rBox);

            	pstmt = conn.prepareStatement(query.toString());
    			pstmt.setString(1, p_master);
    			pstmt.setString(2, p_catalog);
    			
                ls = new ListSet(conn);
    		    ls.run(pstmt);
    		    
                if ( ls.next() ){
                	vDescript = ls.getString("catalog_desc");
                	vItemCode = ls.getString("item_code");
                	vCategoryCode = ls.getString("category_code");
                }
            	
        		String vActCode = "";
        		//String vUnitName = "";
        		ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        		for(int i=0; i < ar_chkItem.size(); i++){
        			
        			String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
        			
	        		vActCode = vChkItem[0];
	        		//vUnitName = vChkItem[1];
        			
        			query  = getQuery(qryExp,rBox);
    	        	pstmt = conn.prepareStatement(query.toString());
    	        	
		        	int idx = 0;
		        	
		        	pstmt.setString(++idx, vItemCode); //미채번값으로 고정 값
		        	pstmt.setString(++idx, vDescript); //Description 고정값
		        	pstmt.setString(++idx, p_unit_name); //Unit Name
		        	pstmt.setString(++idx, vStr); //STR 고정값 
		        	pstmt.setString(++idx, vDeptName); 
		        	pstmt.setString(++idx, vDeptCd);
		        	pstmt.setString(++idx, vUserName);
		        	pstmt.setString(++idx, vUserId);
		        	pstmt.setString(++idx, vCategoryCode);
		        	pstmt.setString(++idx, p_catalog);
		        	pstmt.setString(++idx, vActCode); 
		        	pstmt.setString(++idx, p_master);
		        	
		        	isOk = pstmt.executeUpdate();
		        	if(isOk == 0){
	            		throw new Exception("unitAddInsert 실패");
	            	}
		        	if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
		        	
        		}
        		//qryExp = "unitActivityList";        		
        		
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
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
        PreparedStatement 	pstmt2 	= null;
        PreparedStatement 	pstmt3 	= null;
        PreparedStatement 	pstmt4 	= null;
        
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	String				query2  = "";
    	String				query3  = "";
    	ListSet             ls 		= null;
    	String 				rtnstr  = "Ok";
        try 
        { 
        	
        	ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        	String ss_userid = rBox.getSession("UserId");
			String ss_username = rBox.getSession("UserName");
//			String vMotherCode = rBox.getString("p_mother_code");
    		String p_eco_no = rBox.getString("p_eco_no");
    		String p_master = rBox.getString("p_master");
    		String p_catalog = rBox.getString("p_catalog");
        	if(qryExp.equals("bomAction")){
//        		Context context = null;
//        		context = Framework.getFrameContext(rBox.getHttpSession());
//        		
//        		DomainObject itemObj = new DomainObject();
//    			
//    			String ecoKind = MqlUtil.mqlCommand(context , "print bus ECO "+p_eco_no+" - select attribute[Kind Of ECO] dump");
//        		if("DEV".equals(ecoKind)){
//        			rtnstr = "ERROR[plm-01] : 영구 ECO가 아닙니다.";
//        		}
//        		
//        		if(rtnstr.equals("Ok")){
//    	    		String ecoState = MqlUtil.mqlCommand(context , "print bus ECO "+p_eco_no+" - select current dump");
//    	    		if("Release".equals(ecoState)){
//    	    			rtnstr = "ERROR[plm-02] : ECO의 상태가 Release 입니다.";
//    	    		}
//        		}
//        		/*
//        		String ecoType = MqlUtil.mqlCommand(context , "print bus ECO "+p_eco_no+" - select attribute[STX TBC ECO] dump");
//        		if(!"Y".equals(ecoType)){
//        			rtnstr = "ERROR[plm-03] : TBC ECO가 아닙니다.";
//        		}
//        		*/
//        		if(rtnstr.equals("Ok")){
//	        		for(int i=0; i<ar_chkItem.size(); i++){
//		        		String[] vChkItem = ar_chkItem.get(i).toString().split("\\^");
//		        		String vActCode = vChkItem[0];
//		        		String vUnitName = vChkItem[1];
//		        		
////		        		채번 대상을 찾음.
//		                query2 = getQuery("getUnitInfo",rBox);
//		    			pstmt2 = conn.prepareStatement(query2.toString());
//		    			
//		    			int idx3 = 0;
//		            	pstmt2.setString(++idx3, vActCode);
//		            	pstmt2.setString(++idx3, vUnitName);
//		            				
//		                ls = new ListSet(conn);
//		    		    ls.run(pstmt2);
//
//		    		    if(ls.next()){
//		    		    	
//			        		//Item 채번
//			        		String projectShipPattern = "";
//			    			//채번 시 Ship Pattern을 가져온다.
//			    			projectShipPattern = MqlUtil.mqlCommand(context , "print bus 'Product Configuration' "+p_master.trim()+" - select relationship[Product Configuration].from.relationship[Products].from.name dump");
//			    			
//			        		String vItemCode = com.stx.pec.part.STXpartUtilRev2.getNextNum(context , ls.getString("make_code")+"B", "" , "" , 1);
//			        		
//			        		BusinessObject itemObject = new BusinessObject("Part", vItemCode, "0", context.getVault().getName());
//		    				itemObject.create(context, "EC Part");
//		    				itemObj = new DomainObject(itemObject);
//		    				String itemId = itemObj.getId();
//		    				//String projectShipPattern = MqlUtil.mqlCommand(context , "print bus 'Product Configuration' "+ar_project.get(i).toString().trim()+" - select relationship[Product Configuration].from.relationship[Products].from.name dump");
//		    				String catalog = ls.getString("catalog_code");
//		    				String category = ls.getString("category_code");
//		    				String item_desc = ls.getString("unit_desc");
//		    			
//		    				
//		    			    ContextUtil.pushContext(context);
//		    			    try {
//		    					itemObj.setDescription(context , item_desc);
//		    					itemObj.setAttributeValue(context , "ItemCategory" , catalog);
//		    					itemObj.setAttributeValue(context , "ItemCatalogGroup" , category);
//		    					itemObj.setAttributeValue(context , "ShipPattern" , projectShipPattern);
//		    					itemObj.setAttributeValue(context , "Attr0"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr1"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr2"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr3"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr4"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr5"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr6"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr7"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr8"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr9"  , "" );
//		    					itemObj.setAttributeValue(context , "Attr10" , "" );
//		    					itemObj.setAttributeValue(context , "Attr11" , "" );
//		    					itemObj.setAttributeValue(context , "Attr12" , "" );
//		    					itemObj.setAttributeValue(context , "Attr13" , "" );
//		    					itemObj.setAttributeValue(context , "Attr14" , "" );
//		    					itemObj.setAttributeValue(context , "Weight" , "0");
//		    					itemObj.setAttributeValue(context , "Unit of Measure" , "EA");
//		    					itemObj.setAttributeValue(context , "ItemOldNumber" , "");
//		    					itemObj.setAttributeValue(context , "Originator" , ss_userid);
//		    					itemObj.setAttributeValue(context , "STX TBC ITEM" , "Y");
//		    					itemObj.setAttributeValue(context , "InterfaceORG" , "JH");
//		    					itemObj.setState(context , "Approved");
//	
//		    					String itemID = itemObj.getId();
//	
//		    					String[] itemIDParam = new String[] { itemID };
//		    					
//		    					//ERP ITEM INTERFACE
//		    					//int retCode = matrix.db.JPO.invoke(context, "MERPPutItemJPO", null, "mxMain",zcb02ObjIDParam);
//		    				}
//		    				finally
//		    				{
//		    					ContextUtil.popContext(context);
//		    				}
//
//		                	//TBC ITEM INSERT --------------------------------------
//		                	query3  = getQuery("AddTBCItemInsert",rBox);
//		                	pstmt3 = conn.prepareStatement(query3.toString());
//		                	
//		                	int idx2 = 0;
//		                	pstmt3.setString(++idx2, vItemCode);
//		                	pstmt3.setString(++idx2, catalog);
//		                	pstmt3.setString(++idx2, category);
//		                	pstmt3.setString(++idx2, item_desc);		                	
//		                	pstmt3.setString(++idx2, ss_userid);
//		                	pstmt3.setString(++idx2, ss_username);
//		                	pstmt3.setString(++idx2, vActCode);
//			            	pstmt3.setString(++idx2, vUnitName);
//			            				
//			            	isOk = pstmt3.executeUpdate();
//		                	
//			            	if(isOk == 0){
//			            		throw new Exception("AddTBCItemInsert 실패");
//			            	}
//			            	
//		                	//TBC ITEM INSERT --------------------------------------
//			        		//아이템 채번 끝.
//		                	
//							String vBusineesStateFlag = "";
//							rtnstr = reviseECOCheck(context , vActCode , p_eco_no);
//							//ECO - MotherCode 연계
//							if(rtnstr.equals("Ok")){
//								
//								//bom 추가 로직
//								itemId = MqlUtil.mqlCommand(context , "print bus Part "+vItemCode+" 0 select last.id dump");
//								itemObj = new DomainObject(itemId);
//								
//								//Mother - item 연계
//								String motherId = MqlUtil.mqlCommand(context , "print bus Part "+vActCode+" 0 select last.id dump");
//								DomainObject motherObj = new DomainObject(motherId);
//								
//								String BOMFindNumber = STXUtil.getMaxFindNumber(context , "EBOM,DBOM" , motherId);
//								BOMFindNumber = STXUtil.getFindNumberNext(context , BOMFindNumber);
//								try{
//									//RelationShip 생성
//									DomainRelationship RelObj = motherObj.connectTo(context , "EBOM" , itemObj);
//									ContextUtil.pushContext(context);
//									
//								
//									RelObj.setAttributeValue(context , "Find Number" , BOMFindNumber);
//									RelObj.setAttributeValue(context , "Quantity" , "1");
//									RelObj.setAttributeValue(context , "ATTRIBUTE1" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE2" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE3" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE4" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE5" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE6" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE7" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE8" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE9" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE10" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE11" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE12" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE13" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE14" , "");
//									RelObj.setAttributeValue(context , "ATTRIBUTE15" , "");
//									RelObj.setAttributeValue(context , "Component Location" , "");
//								}
//								finally
//								{
//									ContextUtil.popContext(context);
//								}
//								
//							
//								
//								//WORK TABLE UPDATE	
//								query  = getQuery("workTableUpdateAction",rBox);
//								
//								pstmt = conn.prepareStatement(query.toString());
//								int idx = 0;
//								pstmt.setString(++idx, vItemCode);
//								pstmt.setString(++idx, vActCode);
//								pstmt.setString(++idx, vUnitName);
//								
//								isOk = pstmt.executeUpdate();
//								
//								if(isOk == 0){
//				            		throw new Exception("workTableUpdateAction 실패");
//				            	}
//								
//								//JOB CONFIRM TABLE INSERT
//								query  = getQuery("jobTableInsertAction",rBox);
//								
//								pstmt4 = conn.prepareStatement(query.toString());
//								int idx4 = 0;
//								pstmt4.setString(++idx4, catalog);
//								pstmt4.setString(++idx4, p_eco_no);
//								pstmt4.setString(++idx4, ss_userid);
//								pstmt4.setString(++idx4, ss_userid);
//								pstmt4.setString(++idx4, vActCode);
//								pstmt4.setString(++idx4, vUnitName);
//								
//								isOk = pstmt4.executeUpdate();
//								
//								if(isOk > 0){
//									conn.commit();									
//				            	}else{
//				            		throw new Exception("jobTableInsertAction 실패");
//				            	}
//								
//								//완전 삭제의 경우. ECO NO를 History에 넣어준다. 시작
//	//							if(isOk > 0){
//	//								if(ar_state_flag.get(i).toString().equals("D")){
//	//									query  = getQuery("bomDeleteHistoryEcoUpdateAction",rBox);
//	//									
//	//									pstmt = conn.prepareStatement(query.toString());
//	//									int idx2 = 0;
//	//									pstmt.setString(++idx2, chklist.get(i).toString());
//	//									pstmt.setString(++idx2, ss_userid);							
//	//									pstmt.executeUpdate();
//	//								}
//	//							}
//								//완전 삭제의 경우. ECO NO를 History에 넣어준다. 끝
//	//							System.out.println(isOk);
//								
//								if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
//					            if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
//					            if ( pstmt3 != null ) { try { pstmt3.close(); } catch ( Exception e ) { } }
//					            if ( pstmt4 != null ) { try { pstmt4.close(); } catch ( Exception e ) { } }
//							}else{
//								break;
//							}
//						
//		        		}
//	        		}
//        	    }
//        		if(rtnstr.equals("Ok")){
//    				//ECO 생성 
//    				ecoInsert(context, p_eco_no, ss_userid, ss_username);
//    			}
        		
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
        	rBox.put("errorMsg", ex.getLocalizedMessage().replaceAll("\"", "'"));
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
            if ( pstmt3 != null ) { try { pstmt3.close(); } catch ( Exception e ) { } }
            if ( pstmt4 != null ) { try { pstmt4.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}

	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		
		try
		{
			if(qryExp.equals("unitActivityList")){
				String p_master = box.getString("p_master");
				String p_activity_code = box.getString("p_activity_code");
				String p_block_no = box.getString("p_block_no");
				String ssUserId = box.getSession("UserId");
				query.append("SELECT STAC.DELEGATE_PROJECT \n");
				query.append("     , STAC.USE_PROJECT \n");
				query.append("     , STI.ATTR1 \n");
				query.append("     , STAC.BLOCK_DIV_CD \n");
				query.append("     , STAC.ACTIVITY_CD \n");
				query.append("     , STI.ITEM_DESC \n");
				query.append("     , STUW.UNIT_CODE \n");
				query.append("     , STUW.UNIT_DESC \n");
				query.append("     , STUW.UNIT_NAME \n");
				query.append("     , STUW.STR_FLAG \n");
				query.append("     , STUW.DEPT_NAME \n");
				query.append("     , STUW.DEPT_CODE \n");
				query.append("     , STUW.USER_NAME \n");
				query.append("     , TO_CHAR(STUW.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
				query.append("     , STUW.USER_ID \n");
				query.append("     , STJC.ECO_NO \n");
				query.append("     , TO_CHAR(STE.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE \n");
				query.append("  FROM STX_TBC_ACTIVITY_CONFIRM STAC \n");
				query.append(" INNER JOIN STX_TBC_ITEM STI ON STAC.BLOCK_DIV_CD = STI.ITEM_CODE \n");
				query.append("  LEFT JOIN STX_TBC_UNIT_WORK STUW ON STAC.ACTIVITY_CD  = STUW.ACTIVITY_CD AND STAC.BLOCK_DIV_CD = STUW.BLOCK_DIV_CD AND STUW.USER_ID = '"+box.getSession("UserId")+"' \n");
				query.append("  LEFT JOIN STX_TBC_JOB_CONFIRM STJC ON STJC.ACTIVITY_CD = STAC.ACTIVITY_CD AND STJC.JOB_CD1 = STUW.UNIT_CODE \n");
				query.append("  LEFT JOIN STX_TBC_ECO STE ON STJC.ECO_NO = STE.ECO_NO \n");				
				query.append(" WHERE STAC.DELEGATE_PROJECT = '"+p_master+"' \n");
				
				if(!p_block_no.equals("")){
					p_block_no = p_block_no.replaceAll("[*]","%");
					query.append("   AND STI.ATTR1 like '"+p_block_no+"' \n");
				}
				if(!p_activity_code.equals("")){
					p_activity_code = p_activity_code.replaceAll("[*]","%");
					query.append("   AND STAC.ACTIVITY_CD like '"+p_activity_code+"' \n");
				}
				query.append(" ORDER BY STAC.BLOCK_DIV_CD, STAC.DELEGATE_PROJECT, STAC.ACTIVITY_CD  \n");
				
			} else if(qryExp.equals("UnitExcelTempImport")){
				
				query.append("INSERT \n");
				query.append("  INTO STX_TBC_UNIT_WORK( \n");
				query.append("		  BLOCK_DIV_CD \n");
				query.append("		, ACTIVITY_CD \n");
				query.append("		, DELEGATE_PROJECT \n");
				query.append("		, USE_PROJECT \n");
				query.append("		, BLOCK_NO \n");
				query.append("		, ITEM_DESC \n");
				query.append("		, UNIT_CODE \n");
				query.append("		, UNIT_DESC \n");
				query.append("		, UNIT_NAME \n");
				query.append("		, STR_FLAG \n");
				query.append("		, DEPT_NAME \n");
				query.append("		, DEPT_CODE \n");
				query.append("		, USER_NAME \n");
				query.append("		, USER_ID \n");
				query.append("		, CREATE_DATE \n");
				query.append("		, CATEGORY_CODE \n");
				query.append("     ) \n");
				query.append(" VALUES( \n");
				query.append("       ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , SYSDATE \n");
				query.append("     , ? \n");
				query.append(" ) \n");
				
			}  else if(qryExp.equals("unitAddInsert")){
				query.append("INSERT \n");
				query.append("  INTO STX_TBC_UNIT_WORK( \n");
				query.append("		  BLOCK_DIV_CD \n");
				query.append("		, ACTIVITY_CD \n");
				query.append("		, DELEGATE_PROJECT \n");
				query.append("		, USE_PROJECT \n");
				query.append("		, BLOCK_NO \n");
				query.append("		, ITEM_DESC \n");
				query.append("		, UNIT_CODE \n");
				query.append("		, UNIT_DESC \n");
				query.append("		, UNIT_NAME \n");
				query.append("		, STR_FLAG \n");
				query.append("		, DEPT_NAME \n");
				query.append("		, DEPT_CODE \n");
				query.append("		, USER_NAME \n");
				query.append("		, USER_ID \n");
				query.append("		, CREATE_DATE \n");
				query.append("		, CATEGORY_CODE \n");
				query.append("		, CATALOG_CODE \n");
				query.append("     ) \n");
				query.append("SELECT  \n");
				query.append("       STAC.BLOCK_DIV_CD \n");
				query.append("     , STAC.ACTIVITY_CD \n");
				query.append("     , STAC.DELEGATE_PROJECT \n");
				query.append("     , STAC.USE_PROJECT \n");
				query.append("     , STI.ATTR1 \n");
				query.append("     , STI.ITEM_DESC \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , SYSDATE \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("  FROM STX_TBC_ACTIVITY_CONFIRM STAC \n");
				query.append(" INNER JOIN STX_TBC_ITEM STI ON STAC.BLOCK_DIV_CD = STI.ITEM_CODE \n");
				query.append(" WHERE STAC.ACTIVITY_CD = ? \n");
				query.append("   AND STAC.DELEGATE_PROJECT = ? \n");
			}else if(qryExp.equals("getUnitInfo")){
				
				query.append("SELECT  BLOCK_DIV_CD \n");
				query.append("     , ACTIVITY_CD \n");
				query.append("     , DELEGATE_PROJECT \n");
				query.append("     , USE_PROJECT \n");
				query.append("     , BLOCK_NO \n");
				query.append("     , ITEM_DESC \n");
				query.append("     , UNIT_CODE \n");
				query.append("     , UNIT_DESC \n");
				query.append("     , UNIT_NAME \n");
				query.append("     , STR_FLAG \n");
				query.append("     , DEPT_NAME \n");
				query.append("     , DEPT_CODE \n");
				query.append("     , USER_NAME \n");
				query.append("     , USER_ID  \n");
				query.append("     , CREATE_DATE \n");
				query.append("     , SUBSTR(UNIT_CODE,0,INSTR(UNIT_CODE, '-')) AS MAKE_CODE \n");	
				query.append("     , CATEGORY_CODE \n");
				query.append("	   , CATALOG_CODE \n");
				query.append("  FROM STX_TBC_UNIT_WORK \n");
				query.append(" WHERE ACTIVITY_CD = ? \n");
				query.append("   AND UNIT_NAME = ? \n");			
			}else if(qryExp.equals("AddTBCItemInsert")){
				
					query.append("INSERT INTO STX_TBC_ITEM ( \n");
					query.append("  ITEM_CODE \n");
					query.append(", ITEM_CATALOG \n");
					query.append(", ITEM_CATEGORY \n");
					query.append(", ITEM_DESC \n");
					query.append(", ITEM_WEIGHT \n");
					query.append(", ATTR1 \n");
					query.append(", ATTR2 \n");
					query.append(", ATTR3 \n");
					query.append(", ATTR4 \n");
					query.append(", ATTR5 \n");
					query.append(", ATTR6 \n");
					query.append(", ATTR7 \n");
					query.append(", ATTR8 \n");
					query.append(", ATTR9 \n");
					query.append(", ATTR10 \n");
					query.append(", ATTR11 \n");
					query.append(", ATTR12 \n");
					query.append(", ATTR13 \n");
					query.append(", ATTR14 \n");
					query.append(", ATTR15 \n");
					query.append(", ITEM_MATERIAL1 \n");
					query.append(", ITEM_MATERIAL2 \n");
					query.append(", ITEM_MATERIAL3 \n");
					query.append(", ITEM_MATERIAL4 \n");
					query.append(", ITEM_MATERIAL5 \n");
					query.append(", PAINT_CODE1 \n");
					query.append(", PAINT_CODE2 \n");
					query.append(", CODE_TYPE \n");
					query.append(", UOM \n");
					query.append(", SHIP_PATTERN \n");
					query.append(", ITEM_OLDCODE \n");
					query.append(", CABLE_LENGTH \n");
					query.append(", CABLE_TYPE \n");
					query.append(", CABLE_OUTDIA \n");
					query.append(", USER_ID \n");
					query.append(", USER_NAME \n");
					query.append(", CREATE_DATE \n");
					query.append(")    \n");
					query.append("SELECT ? AS ITEM_CODE\n");
					query.append("     , ? AS ITEM_CATALOG \n");
					query.append("     , ? AS ITEM_CATEGORY \n");
					query.append("     , ? AS ITEM_DESC \n");
					query.append("     , '0' AS WEIGHT \n");
					query.append("     , '' AS ATTR1 \n");
					query.append("     , '' AS ATTR2 \n");
					query.append("     , '' AS ATTR3 \n");
					query.append("     , '' AS ATTR4 \n");
					query.append("     , '' AS ATTR5 \n");
					query.append("     , '' AS ATTR6 \n");
					query.append("     , '' AS ATTR7 \n");
					query.append("     , '' AS ATTR8 \n");
					query.append("     , '' AS ATTR9 \n");
					query.append("     , '' AS ATTR10 \n");
					query.append("     , '' AS ATTR11 \n");
					query.append("     , '' AS ATTR12 \n");
					query.append("     , '' AS ATTR13 \n");
					query.append("     , '' AS ATTR14 \n");
					query.append("     , '' AS ATTR15 \n");
					query.append("     , '' AS ITEM_MATERIAL1 \n");
					query.append("     , '' AS ITEM_MATERIAL2 \n");
					query.append("     , '' AS ITEM_MATERIAL3 \n");
					query.append("     , '' AS ITEM_MATERIAL4 \n");
					query.append("     , '' AS ITEM_MATERIAL5 \n");
					query.append("     , '' AS PAINT_CODE1 \n");
					query.append("     , '' AS PAINT_CODE2 \n");
					query.append("     , '' AS CODE_TYPE \n");
					query.append("     , 'EA' AS UOM \n");
					query.append("     , '' AS SHIP_PATTERN \n");
					query.append("     , '' AS ITEM_OLDCODE \n");
					query.append("     , '' AS CABLE_LENGTH \n");
					query.append("     , '' AS CABLE_TYPE \n");
					query.append("     , '' AS CABLE_OUTDIA \n");
					query.append("     , ? AS USER_ID \n");
					query.append("     , ? AS USER_NAME \n");
					query.append("     , SYSDATE \n");
					query.append("  FROM STX_TBC_UNIT_WORK \n");
					query.append(" WHERE ACTIVITY_CD = ? \n");
					query.append("   AND UNIT_NAME = ? \n");
			}else if(qryExp.equals("workTableUpdateAction")){
				query.append("UPDATE STX_TBC_UNIT_WORK \n");
				query.append("   SET UNIT_CODE = ? \n");
				query.append(" WHERE ACTIVITY_CD = ? \n");
				query.append("   AND UNIT_NAME = ? \n");
			}else if(qryExp.equals("jobTableInsertAction")){
			
				query.append("INSERT \n");
				query.append("  INTO STX_TBC_JOB_CONFIRM ( \n");
				query.append("        ACTIVITY_CD \n");
				query.append("      , JOB_CD1 \n");
				query.append("      , JOB_CD2 \n");
				query.append("      , ITEM_ATTR1 \n");
				query.append("      , ITEM_ATTR2 \n");
				query.append("      , ITEM_ATTR3 \n");
				query.append("      , JOB_CATALOG1 \n");
				query.append("      , JOB_CATALOG2 \n");
				query.append("      , USE_PROJECT \n");
				query.append("      , BOM_ATTR10 \n");
				query.append("      , BOM_ATTR11 \n");
				query.append("      , BOM_ATTR12 \n");
				query.append("      , BOM_ATTR13 \n");
				query.append("      , BOM_ATTR14 \n");
				query.append("      , ACTION_FLAG \n");
				query.append("      , ECO_NO \n");
				query.append("      , USER_ID \n");
				query.append("      , CREATE_DATE \n");
				query.append("      , LAST_USER_ID \n");
				query.append("      , LAST_DATE \n");
				query.append(") \n");
				query.append("SELECT ACTIVITY_CD \n");
				query.append("     , UNIT_CODE \n");
				query.append("     , '' \n");
				query.append("     , BLOCK_NO \n");
				query.append("     , '' \n");
				query.append("     , STR_FLAG \n");
				query.append("     , ? \n"); // --JOB_CATALOG1 
				query.append("     , '' \n");
				query.append("     , USE_PROJECT \n");
				query.append("     , '' \n");
				query.append("     , '' \n");
				query.append("     , '' \n");
				query.append("     , '' \n");
				query.append("     , '' \n");
				query.append("     , 'NEW' \n");
				query.append("     , ? \n");
				query.append("     , ? \n");
				query.append("     , SYSDATE \n");
				query.append("     , ? \n");
				query.append("     , SYSDATE \n");
				query.append("  FROM STX_TBC_UNIT_WORK \n");
				query.append(" WHERE ACTIVITY_CD = ? \n");
				query.append("   AND UNIT_NAME = ? \n");
				
			}else if(qryExp.equals("getItemCodeDesc")){
			
				query.append("SELECT 'Z' \n");
	        	query.append("       || B.CATEGORY_CODE2 \n");
	        	query.append("       || (SELECT SHIP_TYPE \n");
	        	query.append("             FROM STX_STD_SD_BOM_SCHEDULE A \n");
	        	query.append("                 ,STX_STD_SD_MODEL  B \n");
	        	query.append("            WHERE A.MODEL_NO = B.MODEL_NO \n");
	        	query.append("              AND A.PROJECT_NO = ?) \n");
	        	query.append("       || '-,9999999' AS ITEM_CODE \n");
	        	query.append("     , CATALOG_DESC \n");
	        	query.append("     , B.CATEGORY_CODE1 || '.'  ||  B.CATEGORY_CODE2 || '.' ||  B.CATEGORY_CODE3 AS CATEGORY_CODE \n");
	        	query.append("  FROM STX_STD_SD_CATALOG@"+ERP_DB+" A \n");
	        	query.append(" INNER JOIN STX_STD_SD_CATEGORY@"+ERP_DB+" B ON A.CATEGORY_ID = B.CATEGORY_ID \n");
	        	query.append(" WHERE A.CATALOG_CODE = ? \n");

			}else if(qryExp.equals("unitDelete")){
			
				query.append("DELETE STX_TBC_UNIT_WORK \n");
				query.append("WHERE ACTIVITY_CD = ? \n");
				query.append("  AND UNIT_NAME = ? \n");
			
			}
		}catch (Exception ex) 
		{
			ex.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	

//	public String reviseECOCheck(Context context , String objectName , String ecoName) throws Exception{
//		
//		String rtn_massage = "Ok";
//		String objectRev = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" 0 select last.revision dump");
//		//object 상태확인
//		String objectState = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" "+objectRev+" select current dump");
//		
//		if(objectState.equals("Approved")){
//			//연계 ECO의 상태 확인
//			String relECOState = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" "+objectRev+" select relationship[New Part / Part Revision,STX DL ECO Part,STX JK ECO Part].from.current dump;");
//			if(relECOState.indexOf("Design Work")>-1 || relECOState.indexOf("Review")>-1){
//				//처리불가
//				rtn_massage += "Related ECO is not state work.["+objectName+" "+objectRev+", "+relECOState+"] \n";
//			}else{
//				
//			}
//			
//			try{
//				ContextUtil.pushContext(context);
//
//				String parentId = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" 0 select last.id dump");
//				
//				String ecoSite = MqlUtil.mqlCommand(context , "print bus ECO "+ecoName+" - select attribute[STX Site] dump");
//				String relType = com.fujitsu.PLMCommon.getSiteInfo(context , ecoSite , "Global ECO Part");
//				
//				String bfEco = MqlUtil.mqlCommand(context , "print bus "+parentId+" select relationship["+relType+"].from.name dump |;");
//				//기존 ECO가 있고, 기존ECO와 현재 ECO가 다르면 끊음. 
//				if(!bfEco.equals("") && !bfEco.equals(ecoName)){
//					MqlUtil.mqlCommand(context , "disconnect bus "+parentId+" rel '"+relType+"' from ECO "+bfEco+" -;");
//				}
//				//기존 ECO와 현재 ECO가 다르면 붙임.
//				if(!bfEco.equals(ecoName)){
//					MqlUtil.mqlCommand(context , "connect bus "+parentId+" rel '"+relType+"' from ECO "+ecoName+" -;");
//				}
//			}catch (Exception e1) {
//				//e1.printStackTrace();
//				//이미 ECO와 연계되어 있을 경우를 고려하여 에러가 나도 Pass
//				//throw e1;	
//			} finally {
//				ContextUtil.popContext(context);
//			}
//			
//		}else if(objectState.equals("Release")){
//			//Release면 아이템 코드의 리비전을 증가시켜서 연동.
//			String ecoSite = MqlUtil.mqlCommand(context , "print bus ECO "+ecoName+" - select attribute[STX Site] dump");
//			String relType = com.fujitsu.PLMCommon.getSiteInfo(context , ecoSite , "Global ECO Part");
//			
//			//rtn_massage += "Related ECO is not state work. ["+objectName+" "+objectRev+"] \n"  ;
//			String workUser = context.getUser();
//				ContextUtil.pushContext(context);
//				try{
//					//Parent Revise
//					String parentId = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" 0 select last.id dump");
//					//Revision 증가
//					MqlUtil.mqlCommand(context, "revise bus "+parentId);
//					parentId = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" 0 select last.id dump");
//					
//					MqlUtil.mqlCommand(context , "mod bus "+parentId+" Originator '"+workUser+"' ");
//					MqlUtil.mqlCommand(context , "connect bus "+parentId+" rel '"+relType+"' from ECO "+ecoName+" -;");
//					
//				}catch (Exception e1) {
//					e1.printStackTrace();
//					throw e1;	
//				} finally {
//					ContextUtil.popContext(context);			
//				}
//			
//		}else{
//			//처리불가
//			rtn_massage += "Parent Item is not state work. ["+objectName+ " : "+objectState+"] \n";
//		}
//		return rtn_massage;
//	}

	public String ecoInsert(String eco_no,  String userid, String username) throws Exception {
		
		String rtn = "NO";
		Connection conn = null;
		conn = DBConnect.getDBConnection("DIS");
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox dbox = null;
    	int resultCnt = 0;
    	int isOk = 0;
    	try 
        { 
    		query.append("SELECT COUNT(*) CNT FROM STX_TBC_ECO\n");
    		query.append("WHERE ECO_NO = ? \n");
    		
			pstmt = conn.prepareStatement(query.toString());
			pstmt.setString(1, eco_no);
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	resultCnt = ls.getInt("cnt");
            }   
            
            if(resultCnt == 0){
            	//ECO가 없으면 입력	
            	query.delete(0, query.length());
            	query.append("INSERT INTO STX_TBC_ECO ( \n");
            	query.append("      ECO_NO \n");
            	query.append("    , ECO_STATE \n");
            	query.append("    , RELEASE_DATE \n");
            	query.append("    , ECO_DESCRIPTION \n");
            	query.append("    , ECO_CATEGORY \n");
            	query.append("    , ECO_CATEGORY_DESC \n");
            	query.append("    , RELATION_ECO \n");
            	query.append("    , USER_ID \n");
            	query.append("    , USER_NAME \n");
            	query.append("    , CREATE_DATE \n");
            	query.append(") VALUES ( \n");
            	query.append("      ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , ? \n");
            	query.append("    , sysdate \n");
            	query.append(") \n");
            	
            	pstmt = conn.prepareStatement(query.toString());
            	int idx = 0;

//            	MapList ECOList = new MapList();
//
//        		SelectList resultSelects = new SelectList( 7 );
//        		resultSelects.add( DomainObject.SELECT_ID );
//        		resultSelects.add( DomainObject.SELECT_TYPE );
//        		resultSelects.add( DomainObject.SELECT_NAME );
//        		resultSelects.add( DomainObject.SELECT_REVISION );
//        		resultSelects.add( DomainObject.SELECT_DESCRIPTION );
//        		resultSelects.add( DomainObject.SELECT_CURRENT );
//        		resultSelects.add( DomainObject.SELECT_POLICY );
//        		resultSelects.add( "attribute[Category of Change]" );
//
//        		ECOList =  DomainObject.findObjects(    context,                     // context
//														"ECO",		                 // typePattern
//														eco_no,           			 // namePattern
//														"-",                         // revPattern
//														null,                        // ownerPattern
//														"eService Production",       // vaultPattern
//														null,                        // whereExpression
//														null,                        // queryName
//														true,                        // expandType
//														resultSelects,               // objectSelects
//														( short ) 0 );               // queryLimit (0 : all)
//
//        		Map ECOMap = (Map)ECOList.get(0);
//        		
//        		String CategoryOfChange = ECOMap.get("attribute[Category of Change]").toString();
//        		String CategoryDescription = "";
//        		
//        		if(!CategoryOfChange.equals("")){
//        			CategoryDescription = MqlUtil.mqlCommand(context , "print bus 'STX ECO Category' "+CategoryOfChange+" - select Description dump");
//        		}
//        		
//    			pstmt.setString(++idx, eco_no);
//    			pstmt.setString(++idx, "P");
//    			pstmt.setString(++idx, "");
//    			pstmt.setString(++idx, ECOMap.get(DomainObject.SELECT_DESCRIPTION).toString());
//    			pstmt.setString(++idx, CategoryOfChange);
//    			pstmt.setString(++idx, CategoryDescription);
//    			pstmt.setString(++idx, "");
//    			pstmt.setString(++idx, userid);
//    			pstmt.setString(++idx, username);
//    			
//				isOk = pstmt.executeUpdate();
				
				if(isOk > 0){
					rtn = "Ok";
				}else{
					rtn = "NO";
				}
            }else{
            	rtn = "Ok";
            }
        }
        catch ( Exception ex ) 
        { 
        	rtn = "NO";
        	ex.printStackTrace();
        }
        finally 
        { 
        	if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
}