package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.JsonUtil;
import com.stx.tbc.dao.factory.Idao;



public class TbcDwgMailReceiverDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		
		Connection conn     = null;
		
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		if(qryExp.equals("description")){
			conn = DBConnect.getDBConnection("ERP_APPS");
			try 
	        { 
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
	            
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
		}
		else if(qryExp.equals("notRequired")){
			conn = DBConnect.getDBConnection("ERP_APPS");
			try 
	        { 
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
	            
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
		}
    	else if(qryExp.equals("list")){
    		conn = DBConnect.getDBConnection("ERP_APPS");
    		try 
	        { 
    			String cnt=(String) selectTotalRecord(qryExp,rBox);
				rBox.put("listRowCnt", cnt);
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
	            
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
    	}
    	else if(qryExp.equals("modifyView")){
    		conn = DBConnect.getDBConnection("ERP_APPS");
    		String DWG = rBox.getString("h_ShipNo")+"-"+rBox.getString("h_DwgNo");
    		rBox.put("DWG", DWG);
    		try 
	        { 
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
	            
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
    		
    	}
		else if(qryExp.equals("modifyList")){
    		ArrayList mlHistory = selectSTX_DWG_PRINT_SUMMARY_LIST(rBox);
    		ArrayList mlExist	= selectDWG_RECEIVER_USER(rBox);
    		list =getCheckExist(mlHistory,mlExist);
    	}
		else if(qryExp.equals("userSearchList")){
			conn = DBConnect.getDBConnection("ERP_APPS");
			try 
	        { 
	            list = new ArrayList();
	            if(rBox.getString("inout").equals("in")){
	            	query  = getQuery("inUserList",rBox);           
	            }else{
	            	query  = getQuery("outUserList",rBox);
	            }
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
		}
		else if(qryExp.equals("mailReceiverGroupList")){
			conn = DBConnect.getDBConnection("PLM");
			try 
	        { 
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
		}
		else if(qryExp.equals("selectDwgReceiverGroupDetail")){
			conn = DBConnect.getDBConnection("PLM");
			try 
	        { 
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
		}
        return list;
	}
	
//	총 레코드 숫자 구해오기
	public Object selectTotalRecord(String qryExp, RequestBox rBox)	throws Exception {
		// TODO Auto-generated method stub
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		
        ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	String				cnt			= "";
    	ResultSet			rs 			= null;
        try 
        { 
            query  = getQuery("selectTotalRecord",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			rs		= pstmt.executeQuery();
            //ls = new ListSet(conn);
		    //ls.run(pstmt);
		    
            while ( rs.next() ){
            	cnt=rs.getString("cnt");
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
        return cnt;
	}
	
	public ArrayList selectSTX_DWG_PRINT_SUMMARY_LIST(RequestBox rBox) throws Exception{
		ArrayList mlHistory = null;
		Connection conn     = null;
        ListSet             ls      	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		
		conn = DBConnect.getDBConnection("ERP_APPS");
		try 
        {
			mlHistory = new ArrayList();
            query  = getQuery("dwgPrintSummaryList",rBox);
            
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){ 
            	resultList = ls.getDataMap();
            	mlHistory.add(resultList);
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
		return mlHistory;
	}
	
	public ArrayList selectDWG_RECEIVER_USER(RequestBox rBox) throws Exception{
		ArrayList mlExist   = null;
		Connection conn     = null;
        ListSet             ls      	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		
		conn = DBConnect.getDBConnection("ERP_APPS");
		try 
        { 
			mlExist = new ArrayList();
            query  = getQuery("modifyList",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){ 
            	resultList = ls.getDataMap();
            	mlExist.add(resultList);
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
		return mlExist;
	}
	
	public ArrayList getCheckExist(ArrayList mlHistory,ArrayList mlExist){
		if(mlHistory!=null){
			Iterator itrHistory = mlHistory.iterator();
			while(itrHistory.hasNext())
			{
				Map mapHistory = (Map)itrHistory.next();
				String EMAIL = (String)mapHistory.get("email");
				String PROJECT_NO = (String)mapHistory.get("project_no");
				Iterator itrExist = mlExist.iterator();
				mapHistory.put("CHECKED","FALSE");
				while(itrExist.hasNext())
				{
					Map mapExist = (Map)itrExist.next();
					String EMAIL_E = (String)mapExist.get("email");
					String PROJECT_NO_E = (String)mapExist.get("project_no");
					//if(EMAIL_E.equals(EMAIL))
					if(EMAIL_E.equals(EMAIL) && PROJECT_NO.equals(PROJECT_NO_E))
					{
						mlExist.remove(mapExist);
						mapHistory.put("CHECKED","TRUE");
						break;
					}
					
				}
			}
		}
		if(mlExist!=null){
			Iterator itrExist = mlExist.iterator();
			while(itrExist.hasNext())
			{
				Map mapExist = (Map)itrExist.next();
				mlHistory.add(mapExist);
			}
		}
		return mlHistory;
	}
	public boolean deleteDB(String qryExp, RequestBox rBox) throws Exception {
		int deleteHeadRow			= 0;
		int deleteDetailRow			= 0;
		boolean result 			= false;
		Connection conn = null;
		
		if(qryExp.equals("delete_STX_DWG_RECEIVER_GROUP_HEAD")){
			try{
				conn = DBConnect.getDBConnection("PLM");
				conn.setAutoCommit(false);
				
				deleteHeadRow=delete_STX_DWG_RECEIVER_GROUP_HEAD(conn,rBox);
				deleteDetailRow=delete_STX_DWG_RECEIVER_GROUP_DETAIL(conn,rBox);
				
				conn.commit();
				result=true;
			}catch(Exception e){
				conn.rollback();
				System.out.println(e.getMessage());
			}finally 
	        { 
	            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
	        }
		}
		return result;
	}
	
	public int delete_STX_DWG_RECEIVER_GROUP_DETAIL(Connection conn, RequestBox rBox){
		StringBuffer query = new StringBuffer();
		query.append("delete from STX_DWG_RECEIVER_GROUP_DETAIL \n");
		query.append("where group_id = '"+rBox.getString("GROUP_ID")+"' \n");
		
		PreparedStatement 	pstmt 		= null;
    	int					result		= 0;
		try 
        { 
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	public int delete_STX_DWG_RECEIVER_GROUP_HEAD(Connection conn, RequestBox rBox){
		StringBuffer query = new StringBuffer();
		query.append("delete from STX_DWG_RECEIVER_GROUP_HEAD \n");
		query.append("where group_id = '"+rBox.getString("GROUP_ID")+"' \n");
		
		  
		PreparedStatement 	pstmt 		= null;
    	int					result		= 0;
		try 
        { 
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	
	public boolean insertDB(String qryExp, RequestBox rBox) throws Exception {
		int deleteRow 			= 0;
		int updateRow 			= 0;
		int insertRow 			= 0;
		int insertReceiverRow 	= 0;
		boolean result 			= false;
		Connection conn = null;
		if(qryExp.equals("mailReceiverSave")){
			List saveDWGMailReceiverList = JsonUtil.toList(rBox.getString("chmResultList"));
			rBox.put("MASTER_PROJECT_NO",rBox.getString("h_ShipNo"));
			rBox.put("DWG_NO",rBox.getString("h_DwgNo"));
			rBox.put("REV_NO",rBox.getString("dwg_rev"));
			rBox.put("ECO_NO","");
			rBox.put("DESCRIPTION",quoteReplace(rBox.getString("description")));
			rBox.put("CREATED_BY",rBox.getString("userId"));
			rBox.put("LAST_UPDATED_BY",rBox.getString("userId"));
			rBox.put("LAST_UPDATE_LOGIN",rBox.getString("userId"));
			
			rBox.put("WORK_STAGE",rBox.getString("p_work_stage"));
			rBox.put("WORK_TIME",rBox.getString("p_work_time"));
			rBox.put("USER_LIST",rBox.getString("p_user_list"));
			rBox.put("ITEM_ECO_NO",rBox.getString("p_item_eco_no"));
			rBox.put("ECR_NO",rBox.getString("p_ecr_no"));
			rBox.put("ECO_EA",rBox.getString("p_eco_ea"));
			
			try{
				conn = DBConnect.getDBConnection("ERP_APPS");
				conn.setAutoCommit(false);
				
				Map mlID = selectDWG_RECEIVER_ID("getReceiverId",rBox);
				String RECEIVER_ID = String.valueOf(mlID.get("receiver_id"));
				String RECEIVER_ID_EXIST = String.valueOf(mlID.get("receiver_id_exist"));
				rBox.put("RECEIVER_ID",RECEIVER_ID);
				if(RECEIVER_ID_EXIST.equals("null") || RECEIVER_ID_EXIST.equals("0.0")){
					RECEIVER_ID_EXIST="";
				}
				if(!RECEIVER_ID_EXIST.equals("") )
				{
					deleteRow = delSTX_DWG_ECO_RECEIVER_USER(conn,rBox);
					updateRow = updateSTX_DWG_ECO_RECEIVER(conn,rBox);
					
				}else{
					insertRow = addSTX_DWG_ECO_RECEIVER(conn,rBox);
				}
				List saveList=delteDuplicationEmail(saveDWGMailReceiverList);
				for(int i=0;i<saveList.size();i++) 
				{
					Map rowData = (Map) saveList.get(i);
					if(rowData.get("project_no").equals("") || rowData.get("project_no").equals(null)){
						rowData.put("project_no", rBox.getString("chkList"));
					}
					rBox.put("RECEIVER_ID"		,RECEIVER_ID);
					rBox.put("PROJECT_NO"			,rowData.get("project_no"));             
					rBox.put("EMAIL_ADRESS"		,rowData.get("email"));
					rBox.put("AFTER_WORKING_YN"	,"N");
					rBox.put("RECEIVER_NAME"		,rowData.get("print_user_name"));
					rBox.put("RECEIVER_DEPT"		,rowData.get("print_dept_id"));
					rBox.put("RECEIVER_TYPE"		,rowData.get("user_type"));
					rBox.put("RECEIVER_EMPNO"		,rowData.get("print_user_id"));
					rBox.put("CREATED_BY"			,rBox.getString("userId"));
					rBox.put("LAST_UPDATED_BY"	,rBox.getString("userId"));
					rBox.put("LAST_UPDATE_LOGIN"	,rBox.getString("userId"));
					rBox.put("DRAWING_SATAUS"	,rowData.get("drawing_status"));
					insertReceiverRow = addSTX_DWG_ECO_RECEIVER_USER(conn,rBox);
				}
				conn.commit();
				result=true;
			}catch(Exception e){
				conn.rollback();
				System.out.println(e.getMessage());
			}finally 
	        { 
	            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
	        }
		}
		else if(qryExp.equals("mailReceiverGroupSave")){
			int insertHeadRow 	= 0;
			int insertDetailRow = 0;
			List saveMailReceiverGroupList = JsonUtil.toList(rBox.getString("chmResultList"));
			String DESCRIPTION = (String)rBox.getString("groupName");
			rBox.put("seq_Name", "STX_DWG_RECEIVER_GH_SQ");
			rBox.put("db_Name", "");
			
			
			try{
				conn = DBConnect.getDBConnection("PLM");
				conn.setAutoCommit(false);
//				group sequence 따기
				Map seq = getSeqNextVal(conn,rBox);
				
				rBox.put("GROUP_ID",seq.get("nextval"));
				rBox.put("DESCRIPTION",DESCRIPTION);
				
				insertHeadRow=addSTX_DWG_RECEIVER_GROUP_HEAD(conn,rBox);
				
				for(int i=0;i<saveMailReceiverGroupList.size();i++){
					Map rowData = (Map)saveMailReceiverGroupList.get(i);
					rowData.put("GROUP_ID", seq.get("nextval"));
					rowData.put("USER",rBox.getString("userId"));
					insertDetailRow=addSTX_DWG_RECEIVER_GROUP_DETAIL(conn,rowData);
				}
				conn.commit();
				result=true;
			}catch(Exception e){
				conn.rollback();
				System.out.println(e.getMessage());
			}finally 
	        { 
	            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
	        }
		}
		return result;
	}
	
	public List delteDuplicationEmail(List saveDWGMailReceiverList) throws Exception{
		List list = new ArrayList();
		if(saveDWGMailReceiverList!=null){
			for(int i=0;i<saveDWGMailReceiverList.size();i++){
				Map rowData = (Map)saveDWGMailReceiverList.get(i);
				
				String eMail 	  = rowData.get("email").toString();
				String project_no = rowData.get("project_no").toString();
				
				boolean isExist = false;
				for(int j=0;j<list.size();j++){
					Map copyData = (Map)list.get(j);
					
					if (eMail.equals(copyData.get("email")) && project_no.equals(copyData.get("project_no"))) {
						isExist = true;
						break;
					}
				}
				
				if (!isExist) list.add(rowData);
			}
		}
		
		return list;
	}
	
	public int addSTX_DWG_RECEIVER_GROUP_DETAIL(Connection conn, Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("INSERT INTO STX_DWG_RECEIVER_GROUP_DETAIL 	\n");
		query.append("       ( 										\n");
		query.append("         GROUP_ID 							\n");
		query.append("        ,EMAIL_ADRESS 						\n");
		query.append("        ,RECEIVER_NAME 						\n");
		query.append("        ,RECEIVER_DEPT 						\n");
		query.append("        ,RECEIVER_TYPE 						\n");
		query.append("        ,CREATED_BY 							\n");
		query.append("        ,CREATION_DATE 						\n");
		query.append("        ,LAST_UPDATED_BY 						\n");
		query.append("        ,LAST_UPDATE_DATE 					\n");
		query.append("        ,RECEIVER_EMPNO 						\n");
		query.append("       ) 										\n");
		query.append("       VALUES 								\n");
		query.append("       ( 										\n");
		query.append("         "+rowData.get("GROUP_ID")+" 			\n");
		query.append("        ,'"+rowData.get("email")+"' 			\n");
		query.append("        ,'"+rowData.get("print_user_name")+"' \n");
		query.append("        ,'"+rowData.get("print_dept_id")+"' 	\n");
		query.append("        ,'"+rowData.get("user_type")+"' 		\n");
		query.append("        ,'"+rowData.get("USER")+"' 			\n");
		query.append("        ,SYSDATE 								\n");
		query.append("        ,'"+rowData.get("USER")+"' 			\n");
		query.append("        ,SYSDATE 								\n");
		query.append("        ,'"+rowData.get("print_user_id")+"' 	\n");
		query.append("       ) 										\n");

		PreparedStatement 	pstmt 		= null;
    	int					result		= 0;
		try 
        { 
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	
	public int addSTX_DWG_RECEIVER_GROUP_HEAD(Connection conn, RequestBox rBox) throws Exception{
		PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	int					result		= 0;
		try 
        { 
            query  = getQuery("insertMailReceiverGroupHead",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	
	public Map getSeqNextVal(Connection conn,RequestBox rBox) throws Exception{
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		try 
        { 
            list = new ArrayList();
            query  = getQuery("getSeqNextVal",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){ 
            	resultList = ls.getDataMap();
                list.add(resultList);
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
		return resultList;
	}
	
	public int addSTX_DWG_ECO_RECEIVER_USER(Connection conn, RequestBox rBox) throws Exception{
		PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	int					result		= 0;
		try 
        { 
            query  = getQuery("insertECOReceiverUser",rBox);           
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	public int addSTX_DWG_ECO_RECEIVER(Connection conn,RequestBox rBox) throws Exception{
		PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	int					result		= 0;
		try 
        { 
            query  = getQuery("insertECOReceiver",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	public int updateSTX_DWG_ECO_RECEIVER(Connection conn, RequestBox rBox) throws Exception{
		PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	int					result		= 0;
		try 
        { 
            query  = getQuery("updateECOReceiver",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	public int delSTX_DWG_ECO_RECEIVER_USER(Connection conn, RequestBox rBox) throws Exception{
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	int					result		= 0;
		try 
        { 
            query  = getQuery("deleteReceiverUser",rBox);           
            
			pstmt = conn.prepareStatement(query.toString());
			
			result+=pstmt.executeUpdate();
	    }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	
	public Map selectDWG_RECEIVER_ID(String qryExp, RequestBox rBox) throws Exception{
		Connection conn     = null;
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		conn = DBConnect.getDBConnection("ERP_APPS");
			try 
	        { 
	            list = new ArrayList();
	            query  = getQuery(qryExp,rBox);           
	            
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	                list.add(resultList);
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
		return resultList;
	}

	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("description")){
				query.append("select sder.receiver_id  											\n");
				query.append("         ,nvl(sder.description,'')as description 					\n");
				query.append("         ,nvl(sder.causedept,'')as causedept 						\n");
				
				query.append("         ,nvl(sder.work_stage,'')as work_stage 					\n");
				query.append("         ,nvl(sder.work_time,'')as work_time 						\n");
				query.append("         ,nvl(sder.user_list,'')as user_list 						\n");
				query.append("         ,nvl(sder.item_eco_no,'')as item_eco_no 					\n");
				query.append("         ,nvl(sder.ecr_no,'')as ecr_no 							\n");
				query.append("         ,nvl(sder.eco_ea,'')as eco_ea 							\n");
				
				/*query.append(",(select t3.mail_receiver from( \n");
				query.append("       select                       \n");
				query.append("                  t1.mail_receiver \n");
				query.append("                  ,t1.req_date              \n");
				query.append("            from  stx_tbc_dwg_trans@"+PLM_DB+"          t1      \n");
				query.append("                 ,stx_tbc_dwg_trans_detail@"+PLM_DB+"  t2      \n");
				query.append("                 ,stx_dwg_dw302tbl   t3                \n");
				query.append("           where  t1.req_seq = t2.req_seq              \n");
				query.append("             and  t2.req_dwg_seq_id = t3.dwg_seq_id          \n");
				query.append("             and  t3.shp_no = '"+box.getString("h_ShipNo")+"' 	\n");
				query.append("             and  t3.dwg_no = '"+box.getString("h_DwgNo")+"' 		\n");
				query.append("             and  t3.dwg_rev = "+box.getString("dwg_rev")+" 		\n");
				query.append("             order by t1.req_date desc \n");
				query.append("             ) t3 \n");
				query.append("             where 1=1 \n");
				query.append("             and rownum = 1    \n");
				query.append("           )as mail_receiver \n");*/
				query.append("  from stx_dwg_eco_receiver sder 									\n");
				query.append(" where sder.master_project_no = '"+box.getString("h_ShipNo")+"' 	\n");
				query.append("   and sder.dwg_no = '"+box.getString("h_DwgNo")+"' 				\n");
				query.append("   and sder.rev_no = '"+box.getString("dwg_rev")+"' 				\n");
				query.append(" order by sder.last_update_date desc 								\n");
			}
			else if(qryExp.equals("notRequired")){
				query.append("select t3.mail_receiver from(  \n");
				query.append("       select                        \n");
				query.append("                  t1.mail_receiver  \n");
				query.append("                  ,t1.req_date               \n");
				query.append("            from  stx_tbc_dwg_trans@"+PLM_DB+"          t1       \n");
				query.append("                 ,stx_tbc_dwg_trans_detail@"+PLM_DB+"  t2       \n");
				query.append("                 ,stx_dwg_dw302tbl   t3                 \n");
				query.append("           where  t1.req_seq = t2.req_seq               \n");
				query.append("             and  t2.req_dwg_seq_id = t3.dwg_seq_id           \n");
				query.append("             and  t3.shp_no = '"+box.getString("h_ShipNo")+"'  \n");
				query.append("             and  t3.dwg_no = '"+box.getString("h_DwgNo")+"'  \n");
				query.append("             and  t3.dwg_rev = '"+box.getString("dwg_rev")+"'  \n");
				query.append("             order by t1.req_date desc  \n");
				query.append("             ) t3  \n");
				query.append("             where 1=1  \n");
				query.append("             and rownum = 1   \n");

			}
			else if(qryExp.equals("list")){
				String h_ShipNo = box.getString("h_ShipNo") == null ? "" : box.getString("h_ShipNo").toString();
				String shipNo	= box.getString("shipNo")	== null ? "" : box.getString("shipNo").toString();
				
				query.append("select t13.* \n");
				query.append("from (  \n");
				query.append("select t12.* \n");
				query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page \n");
				query.append("from \n");
				query.append("( \n");
				query.append("SELECT  \n");
				query.append("        MASTER_PROJECT_NO DWG_PROJECT_NO \n");
				query.append("       ,PROJECT_NO PROJECT_NO \n");
				query.append("       ,SDERU.RECEIVER_EMPNO PRINT_USER_ID \n");
				query.append("       ,SDERU.RECEIVER_NAME PRINT_USER_NAME \n");
				query.append("       ,SDERU.RECEIVER_DEPT PRINT_DEPT_ID \n");
				query.append("       ,SDD.DEPT_NAME PRINT_DEPT_NAME \n");
				query.append("       ,'' PRINT_DATE \n");
				query.append("       ,EMAIL_ADRESS EMAIL \n");
				query.append("       ,RECEIVER_TYPE USER_TYPE \n");
				query.append("       ,'TRUE' CHECKED \n");
				query.append("       ,(SELECT SDERD.MAIL_SEND_FLAG \n");
				query.append("           FROM STX_DWG_ECO_REBUILD_MAIL_HE SDERH \n");
				query.append("               ,STX_DWG_ECO_REBUILD_MAIL_DE SDERD \n");
				query.append("          WHERE SDERH.HEAD_ID = SDERD.HEAD_ID \n");
				query.append("            AND SDERH.ECO_NO = SDER.ECO_NO \n");
				query.append("            AND SDERD.EMAIL_ADDRESS = sderu.email_adress \n");
				query.append("            AND SDERH.PROJECT_NO = SDERU.PROJECT_NO \n");
				query.append("            AND rownum = 1) MAIL_SEND_FLAG \n");
				query.append("       ,to_char((SELECT SDERD.Last_Update_Date \n");
				query.append("  FROM STX_DWG_ECO_REBUILD_MAIL_HE SDERH \n");
				query.append("      ,STX_DWG_ECO_REBUILD_MAIL_DE SDERD \n");
				query.append(" WHERE SDERH.HEAD_ID = SDERD.HEAD_ID \n");
				query.append("   AND SDERH.ECO_NO = SDER.ECO_NO \n");
				query.append("   AND SDERD.EMAIL_ADDRESS = sderu.email_adress \n");
				query.append("   AND SDERH.PROJECT_NO = SDERU.PROJECT_NO \n");
				query.append("   AND rownum = 1),'YYYY-MM-DD HH24:mm') MAIL_SEND_DATE \n");
				query.append("   ,SDERU.Drwaing_Status								  \n");
				query.append("  FROM STX_DWG_ECO_RECEIVER_USER SDERU \n");
				query.append("      ,STX_DWG_ECO_RECEIVER      SDER \n");
				query.append("      ,STX_DWG_DEPT_MANAGER      SDD \n");
				query.append(" WHERE SDERU.RECEIVER_ID = SDER.RECEIVER_ID \n");
				if( !h_ShipNo.equals("") ){
				query.append("   AND SDER.MASTER_PROJECT_NO = '"+box.getString("h_ShipNo")+"' \n");
				}
				query.append("   AND SDER.DWG_NO = '"+box.getString("h_DwgNo")+"' \n");
				query.append("   AND SDER.REV_NO = '"+box.getString("dwg_rev")+"' \n");
				query.append("   AND SDD.DEPT_ID = SDERU.RECEIVER_DEPT \n");
				if( !shipNo.equals("")){
				query.append("   AND SDERU.PROJECT_NO like '"+box.getString("shipNo")+"%' \n");
				}
				query.append(") t12 \n");
				query.append(") t13 \n");
				query.append("where page = "+box.getString("page")+" \n");
			}
			else if(qryExp.equals("selectTotalRecord")){
				String h_ShipNo = box.getString("h_ShipNo") == null ? "" : box.getString("h_ShipNo").toString();
				String shipNo	= box.getString("shipNo")	== null ? "" : box.getString("shipNo").toString();
				
				query.append("select count(*) as cnt \n");
				query.append("from ( \n");
				query.append("SELECT  \n");
				query.append("        MASTER_PROJECT_NO DWG_PROJECT_NO \n");
				query.append("       ,PROJECT_NO PROJECT_NO \n");
				query.append("       ,SDERU.RECEIVER_EMPNO PRINT_USER_ID \n");
				query.append("       ,SDERU.RECEIVER_NAME PRINT_USER_NAME \n");
				query.append("       ,SDERU.RECEIVER_DEPT PRINT_DEPT_ID \n");
				query.append("       ,SDD.DEPT_NAME PRINT_DEPT_NAME \n");
				query.append("       ,'' PRINT_DATE \n");
				query.append("       ,EMAIL_ADRESS EMAIL \n");
				query.append("       ,RECEIVER_TYPE USER_TYPE \n");
				query.append("       ,'TRUE' CHECKED \n");
				query.append("       ,(SELECT SDERD.MAIL_SEND_FLAG \n");
				query.append("           FROM STX_DWG_ECO_REBUILD_MAIL_HE SDERH \n");
				query.append("               ,STX_DWG_ECO_REBUILD_MAIL_DE SDERD \n");
				query.append("          WHERE SDERH.HEAD_ID = SDERD.HEAD_ID \n");
				query.append("            AND SDERH.ECO_NO = SDER.ECO_NO \n");
				query.append("            AND SDERD.EMAIL_ADDRESS = sderu.email_adress \n");
				query.append("            AND SDERH.PROJECT_NO = SDERU.PROJECT_NO \n");
				query.append("            AND rownum = 1) MAIL_SEND_FLAG \n");
				query.append("       ,to_char((SELECT SDERD.Last_Update_Date \n");
				query.append("  FROM STX_DWG_ECO_REBUILD_MAIL_HE SDERH \n");
				query.append("      ,STX_DWG_ECO_REBUILD_MAIL_DE SDERD \n");
				query.append(" WHERE SDERH.HEAD_ID = SDERD.HEAD_ID \n");
				query.append("   AND SDERH.ECO_NO = SDER.ECO_NO \n");
				query.append("   AND SDERD.EMAIL_ADDRESS = sderu.email_adress \n");
				query.append("   AND SDERH.PROJECT_NO = SDERU.PROJECT_NO \n");
				query.append("   AND rownum = 1),'YYYY-MM-DD HH24:mm') MAIL_SEND_DATE \n");
				query.append("   ,SDERU.Drwaing_Status								  \n");
				query.append("  FROM STX_DWG_ECO_RECEIVER_USER SDERU \n");
				query.append("      ,STX_DWG_ECO_RECEIVER      SDER \n");
				query.append("      ,STX_DWG_DEPT_MANAGER      SDD \n");
				query.append(" WHERE SDERU.RECEIVER_ID = SDER.RECEIVER_ID \n");
				if( !h_ShipNo.equals("") ){
				query.append("   AND SDER.MASTER_PROJECT_NO = '"+box.getString("h_ShipNo")+"' \n");
				}
				query.append("   AND SDER.DWG_NO = '"+box.getString("h_DwgNo")+"' \n");
				query.append("   AND SDER.REV_NO = '"+box.getString("dwg_rev")+"' \n");
				query.append("   AND SDD.DEPT_ID = SDERU.RECEIVER_DEPT \n");
				if( !shipNo.equals("")){
				query.append("   AND SDERU.PROJECT_NO like '"+box.getString("shipNo")+"%' \n");
				}
				query.append(") \n");
			}
			else if(qryExp.equals("dwgPrintSummaryList")){
				query.append("WITH DWG_TMP AS (SELECT SDPSL.PROJECT_NO \n");
				query.append("                        ,SDPSL.DWG_PROJECT_NO \n");
				query.append("                        ,SDPSL.PRINT_USER_ID \n");
				query.append("                        ,SDPSL.PRINT_USER_NAME \n");
				query.append("                        ,SDPSL.PRINT_DEPT_NAME \n");
				query.append("                        ,SDPSL.PRINT_DEPT_ID \n");
				query.append("                        ,MAX(SDPSL.PRINT_DATE) AS PRINT_DATE \n");
				query.append("                        ,SDPSL.DWG_NO \n");
				query.append("                        ,SDD.DWG_REV \n");
				query.append("                    FROM STX_DWG_PRINT_SUMMARY_LIST SDPSL \n");
				query.append("                        ,STX_DWG_DW302TBL           SDD \n");
				query.append("                   WHERE SDPSL.DWG_PROJECT_NO = '"+box.getString("h_ShipNo")+"' \n");
				query.append("                     AND SDPSL.DWG_NO = '"+box.getString("h_DwgNo")+"' \n");
				query.append("                     AND SDPSL.DWG_PROJECT_NO = SDD.SHP_NO \n");
				query.append("                     AND SDPSL.FILE_NAME      = SDD.FILE_NAME \n");
				query.append("                     AND SDPSL.PRINT_DEPT_ID > 0 \n");
				query.append("                   GROUP BY SDPSL.PROJECT_NO \n");
				query.append("                           ,SDPSL.DWG_PROJECT_NO \n");
				query.append("                           ,SDPSL.PRINT_USER_ID \n");
				query.append("                           ,SDPSL.PRINT_USER_NAME \n");
				query.append("                           ,SDPSL.PRINT_DEPT_NAME \n");
				query.append("                           ,SDPSL.PRINT_DEPT_ID \n");
				query.append("                           ,SDPSL.DWG_NO \n");
				query.append("                           ,SDD.DWG_REV \n");
				query.append("              )  \n");
				query.append("  SELECT SDPSL.PROJECT_NO \n");
				query.append("      ,SDPSL.DWG_PROJECT_NO \n");
				query.append("      ,SDPSL.PRINT_USER_ID \n");
				query.append("      ,SDPSL.PRINT_USER_NAME \n");
				query.append("      ,SDPSL.PRINT_DEPT_NAME \n");
				query.append("      ,SDPSL.PRINT_DEPT_ID \n");
				query.append("      ,SDPSL.PRINT_DATE \n");
				query.append("      ,SDPSL.DWG_REV \n");
				query.append("      ,EMPINFO.EMAIL \n");
				query.append("      ,EMPINFO.USER_TYPE \n");
				query.append("		,'RE' as DRAWING_STATUS	\n");  
				query.append("  FROM DWG_TMP SDPSL \n");
				query.append("   ,(SELECT SCIU.EMP_NO AS EMP_NO \n");
				query.append("                      ,SCIU.USER_NAME AS USER_NAME \n");
				query.append("                      ,SCIU.EP_MAIL || '@onestx.com' AS EMAIL \n");
				query.append("                      ,SDD.DEPT_NAME AS DEPT_NAME \n");
				query.append("                      ,SDD.DEPT_ID AS DEPT_ID \n");
				query.append("                      ,'사내' AS USER_TYPE \n");
				query.append("                  FROM STX_COM_INSA_USER    SCIU \n");
				query.append("                      ,STX_DWG_DEPT_MAPPING SDDM \n");
				query.append("                      ,STX_DWG_DEPT_MANAGER SDD \n");
				query.append("                 WHERE SCIU.DEPT_CODE = SDDM.DEPT_CODE \n");
				query.append("                   AND SDDM.DEPT_ID = SDD.DEPT_ID \n");
				query.append("					 AND SCIU.EP_MAIL   IS NOT NULL	\n");
				query.append("					 AND SCIU.DEL_DATE  IS NULL 	\n");
				query.append("                UNION ALL \n");
				query.append("       SELECT SDUM.EMP_NO AS EMP_NO \n");
				query.append("                      ,SDUM.USER_NAME AS USER_NAME \n");
				query.append("                      ,SDUM.EP_MAIL AS EP_MAIL \n");
				query.append("                      ,SDDM.DEPT_NAME AS DEPT_NAME \n");
				query.append("                      ,SDDM.DEPT_ID AS DEPT_ID \n");
				query.append("                      ,'사외' AS USER_TYPE \n");
				query.append("                  FROM STX_DWG_USER_MASTER  SDUM \n");
				query.append("                      ,STX_DWG_DEPT_MANAGER SDDM \n");
				query.append("                 WHERE SDUM.USER_TYPE = 'O' \n");
				query.append("                   AND SDUM.DEPT_CODE = SDDM.DEPT_ID) EMPINFO \n");
				query.append("     WHERE SDPSL.PRINT_USER_ID = EMPINFO.EMP_NO(+) \n");
				query.append("     AND NOT EXISTS (SELECT '0' \n");
				query.append("                       FROM DWG_TMP \n");
				query.append("                      WHERE PRINT_USER_ID   =  SDPSL.PRINT_USER_ID \n");
				query.append("                        AND DWG_REV         >  SDPSL.DWG_REV) \n");
				query.append("     ORDER BY SDPSL.PRINT_DATE \n");
			}
			else if(qryExp.equals("modifyView")){
				query.append("SELECT SDSM.SERIES_PROJECT_NO \n");
				query.append("            ,SDSM.PROJECT_NO \n");
				query.append("            ,SDCM.DWG_NO_CONCAT || SDM.DWG_BLOCK AS DWG_NO \n");
				query.append("        FROM STX_DWG_SERIES_MASTER    SDSM \n");
				query.append("            ,STX_DWG_MASTER           SDM \n");
				query.append("            ,STX_DWG_CATEGORY_MASTERS SDCM \n");
				query.append("       WHERE SDSM.DWG_NO_ID      = SDM.DWG_NO_ID \n");
				query.append("         AND SDM.DWG_CATEGORY_ID = SDCM.DWG_CATEGORY_ID \n");
				query.append("         AND SDSM.SERIES_PROJECT_NO = SUBSTR('"+box.getString("DWG")+"',1,INSTR('"+box.getString("DWG")+"','-',1,1)-1) \n");
				query.append("         AND SDCM.DWG_NO_CONCAT     = SUBSTR('"+box.getString("DWG")+"', INSTR('"+box.getString("DWG")+"','-',1,1)+1,5) \n");
				query.append("         AND SDM.DWG_BLOCK          = SUBSTR('"+box.getString("DWG")+"', INSTR('"+box.getString("DWG")+"','-',1,1)+6,5) \n");
				query.append("         AND SDSM.ENABLE_FLAG = 'Y' \n");
				query.append("     UNION ALL \n");
				query.append("     SELECT  SDSM.SERIES_PROJECT_NO \n");
				query.append("            ,SDSM.SERIES_PROJECT_NO \n");
				query.append("            ,SDCM.DWG_NO_CONCAT || SDM.DWG_BLOCK AS DWG_NO \n");
				query.append("        FROM STX_DWG_SERIES_MASTER    SDSM \n");
				query.append("            ,STX_DWG_MASTER           SDM \n");
				query.append("            ,STX_DWG_CATEGORY_MASTERS SDCM \n");
				query.append("       WHERE SDSM.DWG_NO_ID      = SDM.DWG_NO_ID \n");
				query.append("         AND SDM.DWG_CATEGORY_ID = SDCM.DWG_CATEGORY_ID \n");
				query.append("         AND SDSM.SERIES_PROJECT_NO = SUBSTR('"+box.getString("DWG")+"',1,INSTR('"+box.getString("DWG")+"','-',1,1)-1) \n");
				query.append("         AND SDCM.DWG_NO_CONCAT     = SUBSTR('"+box.getString("DWG")+"', INSTR('"+box.getString("DWG")+"','-',1,1)+1,5) \n");
				query.append("         AND SDM.DWG_BLOCK          = SUBSTR('"+box.getString("DWG")+"', INSTR('"+box.getString("DWG")+"','-',1,1)+6,5) \n");
				query.append("         AND ROWNUM = 1 \n");
				query.append("         AND SDSM.ENABLE_FLAG = 'Y' \n");
				query.append("       ORDER BY PROJECT_NO \n");
			}
			else if(qryExp.equals("inUserList")){
				String deptName = box.getString("deptName") == null ? "" : box.getString("deptName").toString();
				String userName = box.getString("userName") == null ? "" : box.getString("userName").toString();
				
				query.append("SELECT SCIU.EMP_NO AS PRINT_USER_ID \n");
				query.append("      ,SCIU.USER_NAME AS PRINT_USER_NAME \n");
				query.append("      ,SCIU.EP_MAIL || '@onestx.com' AS EMAIL \n");
				query.append("      ,SDD.DEPT_NAME AS PRINT_DEPT_NAME \n");
				query.append("      ,SCIU.DEPT_NAME AS INSA_DEPT_NAME \n");
				query.append("      ,SDD.DEPT_ID AS PRINT_DEPT_ID \n");
				query.append("      ,'사내' AS USER_TYPE \n");
				query.append(" FROM STX_COM_INSA_USER    SCIU \n");
				query.append("     ,STX_DWG_DEPT_MAPPING SDDM \n");
				query.append("     ,STX_DWG_DEPT_MANAGER SDD \n");
				query.append("WHERE SCIU.DEPT_CODE = SDDM.DEPT_CODE \n");
				query.append("  AND SDDM.DEPT_ID = SDD.DEPT_ID \n");
				query.append("  AND SCIU.DEL_DATE IS NULL \n");
				query.append("	AND SCIU.EP_MAIL IS NOT NULL	\n");
				query.append("  AND ROWNUM < 500 \n");
				if( !deptName.equals("") ){
				query.append("  AND SCIU.DEPT_NAME LIKE '%"+box.getString("deptName")+"%' \n");
				}
				
				if( !userName.equals("") ){
				query.append("  AND SCIU.USER_NAME LIKE '%"+box.getString("userName")+"%' \n");
				}
				query.append("ORDER BY SCIU.USER_NAME,SDD.DEPT_NAME \n");

			}
			else if(qryExp.equals("outUserList")){
				String deptName = box.getString("deptName") == null ? "" : box.getString("deptName").toString();
				String userName = box.getString("userName") == null ? "" : box.getString("userName").toString();
				
				query.append("SELECT SDUM.EMP_NO AS PRINT_USER_ID \n");
				query.append("      ,SDUM.USER_NAME AS PRINT_USER_NAME \n");
				query.append("      ,SDUM.EP_MAIL AS EMAIL \n");
				query.append("      ,SDDM.DEPT_NAME AS PRINT_DEPT_NAME \n");
				query.append("      ,'' AS INSA_DEPT_NAME \n");
				query.append("      ,SDDM.DEPT_ID AS PRINT_DEPT_ID \n");
				query.append("      ,'사외' AS USER_TYPE \n");
				query.append("  FROM STX_DWG_USER_MASTER  SDUM \n");
				query.append("      ,STX_DWG_DEPT_MANAGER SDDM \n");
				query.append(" WHERE SDUM.USER_TYPE = 'O' \n");
				query.append("   AND SDUM.DEPT_CODE = SDDM.DEPT_ID \n");
				query.append("	 AND SDUM.EP_MAIL IS NOT NULL		\n");
				query.append("	 AND SDUM.ENABLE_FLAG = 'Y'			\n");
				query.append("   AND ROWNUM < 500 \n");
				if( !deptName.equals("") ){
				query.append("   AND SDDM.DEPT_NAME LIKE '%"+box.getString("deptName")+"%' \n");
				}
				if( !userName.equals("") ){
				query.append("   AND SDUM.USER_NAME LIKE '%"+box.getString("userName")+"%' \n");
				}
				query.append("ORDER BY SDUM.USER_NAME,SDDM.DEPT_NAME \n");
			}
			else if(qryExp.equals("getReceiverId")){
				query.append("SELECT CASE \n");
				query.append("         WHEN T2.RECEIVER_ID IS NULL THEN 		\n");
				query.append(" 				STX_DWG_RECEIVER_ID_S.NEXTVAL 		\n");
				query.append("         ELSE \n");
				query.append(" 				T2.RECEIVER_ID \n");
				query.append("       END  \n");
				query.append("       RECEIVER_ID \n");
				query.append("      ,T2.RECEIVER_ID RECEIVER_ID_EXIST \n");
				query.append("  FROM (SELECT '"+box.getString("MASTER_PROJECT_NO")+"' MASTER_PROJECT_NO FROM DUAL) T1 \n");
				query.append("      ,(SELECT SDER.RECEIVER_ID \n");
				query.append("              ,SDER.MASTER_PROJECT_NO \n");
				query.append("          FROM STX_DWG_ECO_RECEIVER SDER \n");
				query.append("         WHERE SDER.MASTER_PROJECT_NO = '"+box.getString("MASTER_PROJECT_NO")+"' \n");
				query.append("           AND SDER.DWG_NO = '"+box.getString("DWG_NO")+"' \n");
				query.append("           AND SDER.REV_NO = '"+box.getString("REV_NO")+"' \n");
				query.append("           AND SDER.ECO_NO IS NULL) T2 \n");
				query.append(" WHERE T1.MASTER_PROJECT_NO = T2.MASTER_PROJECT_NO(+) \n");

			}
			else if(qryExp.equals("deleteReceiverUser")){
				query.append("DELETE STX_DWG_ECO_RECEIVER_USER	\n");
				query.append("WHERE RECEIVER_ID = "+box.getString("RECEIVER_ID")+"	\n");
			 	 
			}
			else if(qryExp.equals("updateECOReceiver")){
				query.append("UPDATE STX_DWG_ECO_RECEIVER \n");
				query.append("   SET DESCRIPTION       = '"+box.getString("DESCRIPTION")+"' \n");
				query.append("      ,LAST_UPDATED_BY   = '"+box.getString("LAST_UPDATED_BY")+"' \n");
				query.append("      ,LAST_UPDATE_DATE  = SYSDATE \n");
				query.append("      ,CAUSEDEPT  	   = '"+box.getString("causedept")+"' \n");
				
				query.append("      ,WORK_STAGE        = '"+box.getString("p_work_stage")+"'  \n");
				query.append("      ,WORK_TIME         = '"+box.getString("p_work_time")+"'   \n");
				query.append("      ,USER_LIST         = '"+box.getString("p_user_list")+"'   \n");
				query.append("      ,ITEM_ECO_NO       = '"+box.getString("p_item_eco_no")+"' \n");
				query.append("      ,ECR_NO	           = '"+box.getString("p_ecr_no")+"'      \n");
				query.append("      ,ECO_EA            = '"+box.getString("p_eco_ea")+"'      \n");
				
				query.append(" WHERE RECEIVER_ID = "+box.getString("RECEIVER_ID")+" \n");

			}
			else if(qryExp.equals("insertECOReceiver")){
				query.append("INSERT INTO STX_DWG_ECO_RECEIVER 					\n");
				query.append("      ( 											\n");
				query.append("         MASTER_PROJECT_NO        				\n");
				query.append("        ,DWG_NO                   				\n");
				query.append("        ,REV_NO                   				\n");
				query.append("        ,ECO_NO                   				\n");
				query.append("        ,RECEIVER_ID              				\n");
				query.append("        ,DESCRIPTION              				\n");
				query.append("        ,CREATED_BY                				\n");
				query.append("        ,CREATION_DATE               				\n");
				query.append("        ,LAST_UPDATED_BY           				\n");
				query.append("        ,LAST_UPDATE_DATE         				\n");
				query.append("        ,LAST_UPDATE_LOGIN        				\n");
				query.append("        ,CAUSEDEPT		        				\n");
				
				query.append("        ,WORK_STAGE		        				\n");
				query.append("        ,WORK_TIME		        				\n");
				query.append("        ,USER_LIST		        				\n");
				query.append("        ,ITEM_ECO_NO		        				\n");
				query.append("        ,ECR_NO			        				\n");
				query.append("        ,ECO_EA			        				\n");
				
				query.append("      ) 											\n");
				query.append("       VALUES 									\n");
				query.append("      ( 											\n");
				query.append("        '"+box.getString("MASTER_PROJECT_NO")+"'  \n");
				query.append("       ,'"+box.getString("DWG_NO")+"'       		\n");
				query.append("       ,'"+box.getString("REV_NO")+"'    			\n");
				query.append("       ,'"+box.getString("ECO_NO")+"'    			\n");
				query.append("       ,'"+box.getString("RECEIVER_ID")+"'        \n");
				query.append("       ,'"+box.getString("DESCRIPTION")+"'        \n");
				query.append("       ,'"+box.getString("userId")+"'         	\n");
				query.append("       ,SYSDATE        							\n");
				query.append("       ,'"+box.getString("userId")+"' 		    \n");
				query.append("       ,SYSDATE      								\n");
				query.append("       ,-1 							 			\n");
				query.append("       ,'"+box.getString("causedept")+"'  		\n");
				
				query.append("       ,'"+box.getString("p_work_stage")+"'  		\n");
				query.append("       ,'"+box.getString("p_work_time")+"'  		\n");
				query.append("       ,'"+box.getString("p_user_list")+"'  		\n");
				query.append("       ,'"+box.getString("p_item_eco_no")+"'  	\n");
				query.append("       ,'"+box.getString("p_ecr_no")+"'  			\n");
				query.append("       ,'"+box.getString("p_eco_ea")+"'  			\n");
				
				query.append("      ) 											\n");

			}
			else if(qryExp.equals("insertECOReceiverUser")){ 
				query.append("INSERT INTO STX_DWG_ECO_RECEIVER_USER				\n");
				query.append("      ( 											\n");
				query.append("         RECEIVER_ID        						\n");
				query.append("        ,PROJECT_NO                   			\n");
				query.append("        ,EMAIL_ADRESS                   			\n");
				query.append("        ,AFTER_WORKING_YN                   		\n");
				query.append("        ,RECEIVER_NAME              				\n");
				query.append("        ,RECEIVER_DEPT              				\n");
				query.append("        ,RECEIVER_TYPE                			\n");
				query.append("        ,CREATED_BY               				\n");
				query.append("        ,CREATION_DATE           					\n");
				query.append("        ,LAST_UPDATED_BY         					\n");
				query.append("        ,LAST_UPDATE_DATE        					\n");
				query.append("        ,LAST_UPDATE_LOGIN        				\n");
				query.append("        ,RECEIVER_EMPNO        					\n");
				query.append("		  ,DRWAING_STATUS							\n");
				query.append("      ) 											\n");
				query.append("       VALUES 									\n");
				query.append("      ( 											\n");
				query.append("        '"+box.getString("RECEIVER_ID")+"'  		\n");
				query.append("       ,'"+box.getString("PROJECT_NO")+"'       	\n");
				query.append("       ,'"+box.getString("EMAIL_ADRESS")+"'   	\n");
				query.append("       ,'"+box.getString("AFTER_WORKING_YN")+"'   \n");
				query.append("       ,'"+box.getString("RECEIVER_NAME")+"'      \n");
				query.append("       ,'"+box.getString("RECEIVER_DEPT")+"'      \n");
				query.append("       ,'"+box.getString("RECEIVER_TYPE")+"'      \n");
				query.append("       ,'"+box.getString("CREATED_BY")+"'         \n");
				query.append("       ,SYSDATE        							\n");
				query.append("       ,'"+box.getString("LAST_UPDATED_BY")+"'    \n");
				query.append("       ,SYSDATE      								\n");
				query.append("       ,-1  \n");
				query.append("       ,'"+box.getString("RECEIVER_EMPNO")+"'  	\n");
				query.append("       ,'"+box.getString("DRAWING_SATAUS")+"'  	\n");
				query.append("      ) 											\n");
			}
			else if(qryExp.equals("getSeqNextVal")){
				query.append("select "+box.getString("seq_Name")+".nextval from dual \n");
			}
			else if(qryExp.equals("insertMailReceiverGroupHead")){
				query.append("INSERT INTO STX_DWG_RECEIVER_GROUP_HEAD 		\n");
				query.append("       ( 										\n");
				query.append("          GROUP_ID        					\n");
				query.append("         ,DESCRIPTION                   		\n");
				query.append("         ,CREATED_BY                   		\n");
				query.append("         ,CREATION_DATE 						\n");
				query.append("         ,LAST_UPDATED_BY 					\n");
				query.append("         ,LAST_UPDATE_DATE 					\n");
				query.append("       ) 										\n");
				query.append("       VALUES 								\n");
				query.append("       ( 										\n");
				query.append("          "+box.getString("GROUP_ID")+"       \n");
				query.append("         ,'"+box.getString("DESCRIPTION")+"'  \n");
				query.append("         ,'"+box.getString("userId")+"'       \n");
				query.append("         ,SYSDATE                  			\n");
				query.append("         ,'"+box.getString("userId")+"'       \n");
				query.append("         ,SYSDATE 							\n");
				query.append("       ) 										\n");

			}
			else if(qryExp.equals("mailReceiverGroupList")){
				query.append("SELECT  DISTINCT  									\n");
				query.append("        H.GROUP_ID    VALUE 							\n");
				query.append("       ,H.DESCRIPTION DISPLAY 						\n");
				query.append("  FROM STX_DWG_RECEIVER_GROUP_HEAD H 					\n");
				query.append(" WHERE H.CREATED_BY = '"+box.getString("userId")+"' 	\n");

			}
			else if(qryExp.equals("selectDwgReceiverGroupDetail")){
				query.append("SELECT D.GROUP_ID 									\n");
				query.append("      ,D.EMAIL_ADRESS AS EMAIL 						\n");
				query.append("      ,D.RECEIVER_NAME AS PRINT_USER_NAME 			\n");
				query.append("      ,D.RECEIVER_TYPE AS USER_TYPE 					\n");
				query.append("      ,D.RECEIVER_DEPT AS PRINT_DEPT_ID 				\n");
				query.append("      ,D.RECEIVER_EMPNO AS PRINT_USER_ID 				\n");
				query.append("      ,D.CREATED_BY 									\n");
				query.append("      ,SDD.DEPT_NAME AS PRINT_DEPT_NAME 				\n");
				query.append("      ,TO_CHAR(D.CREATION_DATE 						\n");
				query.append("      ,'YYYY-MM-DD') CREATION_DATE 					\n");
				query.append(" FROM  STX_DWG_RECEIVER_GROUP_DETAIL D 				\n");
				query.append("      ,STX_DWG_DEPT_MANAGER@"+ERP_DB+"  SDD 			\n");
				query.append("WHERE D.GROUP_ID = '"+box.getString("groupList")+"'	\n");
				query.append("  AND D.RECEIVER_DEPT = SDD.DEPT_ID(+) 				\n");

			}
			else if(qryExp.equals("modifyList")){
				query.append("select  \n");
				query.append("        master_project_no dwg_project_no \n");
				query.append("       ,project_no project_no \n");
				query.append("		 ,sderu.drwaing_status	as drawing_status \n");
				query.append("       ,sderu.receiver_empno print_user_id \n");
				query.append("       ,sderu.receiver_name print_user_name \n");
				query.append("       ,sderu.receiver_dept print_dept_id \n");
				query.append("       ,sdd.dept_name print_dept_name \n");
				query.append("       ,'' print_date \n");
				query.append("       ,email_adress email \n");
				query.append("       ,receiver_type user_type \n");
				query.append("       ,'true' checked \n");
				query.append("       ,(select sderd.mail_send_flag \n");
				query.append("           from stx_dwg_eco_rebuild_mail_he sderh \n");
				query.append("               ,stx_dwg_eco_rebuild_mail_de sderd \n");
				query.append("          where sderh.head_id = sderd.head_id \n");
				query.append("            and sderh.eco_no = sder.eco_no \n");
				query.append("            and sderd.email_address = sderu.email_adress \n");
				query.append("            and sderh.project_no = sderu.project_no \n");
				query.append("            and rownum = 1) mail_send_flag \n");
				query.append("       ,to_char((select sderd.last_update_date \n");
				query.append("                   from stx_dwg_eco_rebuild_mail_he sderh \n");
				query.append("                       ,stx_dwg_eco_rebuild_mail_de sderd \n");
				query.append("                  where sderh.head_id = sderd.head_id \n");
				query.append("                    and sderh.eco_no = sder.eco_no \n");
				query.append("                    and sderd.email_address = sderu.email_adress \n");
				query.append("                    and sderh.project_no = sderu.project_no \n");
				query.append("                    and rownum = 1),'yyyy-mm-dd hh24:mi') mail_send_date \n");
				query.append("   from stx_dwg_eco_receiver_user sderu \n");
				query.append("       ,stx_dwg_eco_receiver      sder \n");
				query.append("       ,stx_dwg_dept_manager      sdd \n");
				query.append("  where sderu.receiver_id = sder.receiver_id \n");
				if(!box.getString("h_ShipNo").equals("")){
					query.append("    and sder.master_project_no = '"+box.getString("h_ShipNo")+"' \n");		
				}
				if(!box.getString("shp_no").equals("")){
					query.append("    and sder.master_project_no = '"+box.getString("shp_no")+"' \n");
				}
				query.append("    and sder.dwg_no = '"+box.getString("h_DwgNo")+"' \n");
				query.append("    and sder.rev_no = '"+box.getString("dwg_rev")+"' \n");
				query.append("    and sdd.dept_id = sderu.receiver_dept \n");
				if(!box.getString("shipNo").equals("")){
					query.append("    and sderu.project_no = '"+box.getString("shipNo")+"' \n");
				}
				

			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	public String quoteReplace(String str){
		String temp="";
		temp=str.replaceAll("\"", "\\\"");
   	 	//temp=str.replaceAll("'", "\\\\u0027");
   	 	temp=str.replaceAll("'", "''");

		return temp;
	}
}