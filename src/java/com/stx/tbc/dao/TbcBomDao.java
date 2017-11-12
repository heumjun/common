package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;

public class TbcBomDao implements Idao{

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
		
//		Context context = null;
//		context = Framework.getFrameContext(rBox.getHttpSession());
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	String 				rtnstr  = "Ok";
		
        try 
        { 
        	ArrayList chklist = rBox.getArrayList("p_chkItem");
			ArrayList ar_state_flag = rBox.getArrayList("p_state_flag");
			ArrayList ar_mother_code = rBox.getArrayList("p_mother_code");
			ArrayList ar_item_code = rBox.getArrayList("p_item_code");
			
			String p_eco_no = rBox.getString("p_eco_no");
			String ss_userid = rBox.getSession("UserId");
			String ss_username = rBox.getSession("UserName");
			String p_item_type_cd = rBox.getString("p_item_type_cd");
			
			String itemId = "";
			
			if(rtnstr.equals("Ok")){

				for(int i = 0; i < ar_state_flag.size(); i++){
					
					conn = DBConnect.getDBConnection("DIS");
					
					query  = getQuery("bomUpdateAction",rBox);
					
					pstmt = conn.prepareStatement(query.toString());
					int idx = 0;
					pstmt.setString(++idx, ar_mother_code.get(i).toString());
					pstmt.setString(++idx, chklist.get(i).toString());
					
					isOk += pstmt.executeUpdate();
					if(isOk > 0){
						//Commit 
						conn.commit();							
					}else{
						conn.rollback();															
					}
					
					pstmt.close();
					conn.close();
				}
			}
			String ecortn = "";
			if(rtnstr.equals("Ok")){
				//ECO  
//				ecortn = ecoInsert(context, p_eco_no, ss_userid, ss_username);
			}
        	if(isOk > 0){
        		rBox.put("successMsg", "Success");
        		rtn = true;
        	}else{
        		if(!rtnstr.equals("")){
        			rBox.put("errorMsg", rtnstr);
        		}else{
        			rBox.put("errorMsg", "Fail");
        		}
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
	
	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("bomList")){
				ArrayList chklist = box.getArrayList("p_chkItem");

				query.append("SELECT /*+ USE_NL(A G C)*/ \n");
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
				query.append(", A.BOM_QTY AS EA \n");
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
				
				
			} else if(qryExp.equals("bomUpdateAction")){
				String p_eco_no = box.getString("p_eco_no");
	        	
	  			query.append("UPDATE STX_DIS_SSC_HEAD \n");
	  			query.append("   SET ECO_NO = '"+p_eco_no+"' \n");
	  			query.append(" WHERE MOTHER_CODE = ? \n");
	  			query.append("   AND SSC_SUB_ID = ? \n");
	  			query.append("   AND ECO_NO IS NULL \n");
	  			
			} else if(qryExp.equals("bomDeleteAction")){
	  			query.append("DELETE STX_DIS_SSC_HEAD \n");
				query.append(" WHERE SSC_SUB_ID = ? \n");
			} else if(qryExp.equals("bomDeleteHistoryEcoUpdateAction")){
				String p_eco_no = box.getString("p_eco_no");
	  			query.append("UPDATE STX_DIS_SSC_HEAD_HISTORY \n");
	  			query.append("   SET ECO_NO = '"+p_eco_no+"' \n");
				query.append(" WHERE SSC_SUB_ID = ? \n");
				query.append("   AND USER_ID = ? \n");
				query.append("   AND STATE_FLAG = 'DD' \n");
			}
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
//	
//	public String reviseECOCheck(Context context , String objectName , String ecoName) throws Exception{
//		
//		String rtn_massage = "Ok";
//		String objectRev = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" 0 select last.revision dump");
//		//object ?
//		String objectState = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" "+objectRev+" select current dump");
//		
//		if(objectState.equals("Approved")){
//			// ECO  ?
//			String relECOState = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" "+objectRev+" select relationship[New Part / Part Revision,STX DL ECO Part,STX JK ECO Part].from.current dump;");
//			if(relECOState.indexOf("Design Work")>-1 || relECOState.indexOf("Review")>-1){
//				//o?
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
//				// ECO ?, ECO  ECO ? . 
//				if(!bfEco.equals("") && !bfEco.equals(ecoName)){
//					MqlUtil.mqlCommand(context , "disconnect bus "+parentId+" rel '"+relType+"' from ECO "+bfEco+" -;");
//				}
//				// ECO  ECO ? .
//				if(!bfEco.equals(ecoName)){
//					MqlUtil.mqlCommand(context , "connect bus "+parentId+" rel '"+relType+"' from ECO "+ecoName+" -;");
//				}
//			}catch (Exception e1) {
//				//e1.printStackTrace();
//				//? ECO   痢�   Pass
//				//throw e1;	
//			} finally {
//				ContextUtil.popContext(context);
//			}
//			
//		}else if(objectState.equals("Release")){
//			//Release  ?  ? .
//			String ecoSite = MqlUtil.mqlCommand(context , "print bus ECO "+ecoName+" - select attribute[STX Site] dump");
//			String relType = com.fujitsu.PLMCommon.getSiteInfo(context , ecoSite , "Global ECO Part");
//			
//			//rtn_massage += "Related ECO is not state work. ["+objectName+" "+objectRev+"] \n"  ;
//			String workUser = context.getUser();
//				ContextUtil.pushContext(context);
//				try{
//					//Parent Revise
//					String parentId = MqlUtil.mqlCommand(context , "print bus Part "+objectName+" 0 select last.id dump");
//					//Revision 
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
//			//o?
//			rtn_massage += "Parent Item is not state work. ["+objectName+ " : "+objectState+"] \n";
//		}
//		return rtn_massage;
//	}
	
	public DataBox getRelationShipInfo(String chklist, Connection conn) throws Exception {
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox dbox = null;
    	try 
        { 
    		
    		query.append("SELECT \n");
    		query.append("  A.BOM1 \n");
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
			query.append(", A.ITEM_CODE \n");
			query.append(", A.BOM_QTY \n");
			query.append("FROM STX_DIS_SSC_HEAD A \n");
			query.append("WHERE A.SSC_SUB_ID = '"+chklist+"'");
			
			
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	dbox = ls.getDataBox();
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
        return dbox;
	}
	
	
	public String ecoInsert( String eco_no,  String userid, String username) throws Exception {
		
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
    		query.append("SELECT COUNT(*) CNT FROM STX_DIS_ECO\n");
    		query.append("WHERE ECO_NO = ? \n");
    		
			pstmt = conn.prepareStatement(query.toString());
			pstmt.setString(1, eco_no);
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	resultCnt = ls.getInt("cnt");
            }   
            
            if(resultCnt == 0){
            	query.delete(0, query.length());
            	query.append("INSERT INTO STX_DIS_ECO ( \n");
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
        		
    			pstmt.setString(++idx, eco_no);
    			pstmt.setString(++idx, "P");
    			pstmt.setString(++idx, "");
//    			pstmt.setString(++idx, ECOMap.get(DomainObject.SELECT_DESCRIPTION).toString());
//    			pstmt.setString(++idx, CategoryOfChange);
//    			pstmt.setString(++idx, CategoryDescription);
    			pstmt.setString(++idx, "");
    			pstmt.setString(++idx, userid);
    			pstmt.setString(++idx, username);
    			
				isOk = pstmt.executeUpdate();
				
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
	

	public boolean updateEcoNoRawMaterial(String vEcoNo, String vMotherCode, String vItemCode) throws Exception {
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;        
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	StringBuffer		query   = new StringBuffer();
        try 
        { 
        	query.append("UPDATE STX_DIS_RAWLEVEL \n");
        	query.append("   SET ECO_NO = ? \n");
        	query.append(" WHERE MOTHER_CODE = ? \n");
        	query.append("   AND ITEM_CODE = ? \n");
        	
        	pstmt = conn.prepareStatement(query.toString());
        	
        	pstmt.setString(1, vEcoNo);
        	pstmt.setString(2, vMotherCode);
        	pstmt.setString(3, vItemCode);
        	
        	isOk = pstmt.executeUpdate();
    	  	
        	if(isOk > 0){
        		conn.commit();
        	}else{
        		conn.rollback();
        	}
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();        	
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}

	
}