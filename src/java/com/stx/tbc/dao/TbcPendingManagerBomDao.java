package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;


import sun.misc.VM;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;
import com.sun.xml.internal.bind.CycleRecoverable.Context;


public class TbcPendingManagerBomDao implements Idao{

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
		conn = DBConnect.getDBConnection("DIS");
//		Context context = null;
//		context = Framework.getFrameContext(rBox.getHttpSession());
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	ListSet 			ls = null;
    	int 				isOk    = 0;
    	int 				isAllOk = 0;
    	StringBuffer		query   = new StringBuffer();
    	
		
        try 
        { 
        	ArrayList chklist = rBox.getArrayList("p_chkItem");
			ArrayList ar_state_flag = rBox.getArrayList("p_lstate_flag");
			ArrayList ar_mother_code = rBox.getArrayList("p_lmother_code");
			ArrayList ar_project_no = rBox.getArrayList("p_lproject_no");
			ArrayList ar_job_cd = rBox.getArrayList("p_ljob_cd");
			
			String p_eco_no = rBox.getString("p_eco_no");
			String ss_userid = rBox.getSession("UserId");
			String ss_username = rBox.getSession("UserName");
			String p_bomtype = rBox.getString("p_bomtype");
			String errorMsg = "";
			String ecortn = "";
			
			
			//Validation 1. ECO?? ????? ???
//    		String ecoType = MqlUtil.mqlCommand(context , "print bus ECO "+p_eco_no+" - select attribute[STX TBC ECO] dump");
//    		if(!"Y".equals(ecoType)){
//    			errorMsg = "ERROR[plm-03] : TBC ECO?? ?????.";
//    		}
			
//			//Validation 2. ECO?? ???????? ???.
//			String ecoKind = MqlUtil.mqlCommand(context , "print bus ECO "+p_eco_no+" - select attribute[Kind Of ECO] dump");
//    		if(!("DEV".equals(ecoKind))){
//    			errorMsg = "ERROR[plm-01] : ???? ECO?? ?????.";
//    		}
			//Validation 3. ECO ???? u? 
//			String ecoCurrent = MqlUtil.mqlCommand(context , "print bus ECO "+p_eco_no+" - select current dump");
//    		if(!("Create".equals(ecoCurrent))){
//    			errorMsg = "ERROR[plm-02] : ECO["+p_eco_no+"]?? ???°? Create?? ?????.";
//    		}
//
			
    		
			if(errorMsg.equals("")){
				//ALL BOM ????
				if(p_bomtype.equals("all")){
					String p_project = rBox.getString("p_project");
					String p_dwgno = rBox.getString("p_dwgno");
					String p_blockno = rBox.getString("p_blockno");
					String p_stageno = rBox.getString("p_stageno");
					String p_econo = rBox.getString("p_econo");
					String p_str = rBox.getString("p_str");
					String p_ismail = rBox.getString("p_ismail");
					String p_iseco = rBox.getString("p_iseco");
					String p_isrelease = rBox.getString("p_isrelease");
					String p_deptcode = rBox.getString("p_deptcode");
					String p_userid = rBox.getString("p_userid");
					String p_work = rBox.getString("p_work");		
					String p_ship = rBox.getString("p_ship");
					String p_job_code = rBox.getString("p_job_code");
					String p_pending_code = rBox.getString("p_pending_code");
					String p_state = rBox.getString("p_state");
					
					query.append("SELECT COUNT(*) OVER () AS PD_CNT, ZZ.* FROM ( \n");
					query.append("    SELECT A.JOB_CD \n");
					query.append("         , A.MASTER_NO \n");
					query.append("         , A.MOTHER_CODE \n");
					query.append("         , A.PROJECT_NO \n");
					query.append("         , A.ITEM_CATALOG \n");
					query.append("         , A.DWG_NO \n");
					query.append("         , A.BLOCK_NO \n");
					query.append("         , A.STAGE_NO \n");
					query.append("         , A.STR_FLAG \n");
					query.append("         , A.MAIL_FLAG \n");
					query.append("         , TO_CHAR(NVL(( SELECT SUM(QTY) \n");
					query.append("               FROM ( \n");
					query.append("                     SELECT CASE \n");
					query.append("                         WHEN B.ECO_NO IS NOT NULL AND (B.STATE_FLAG = 'A' OR B.STATE_FLAG = 'C') THEN B.BOM_QTY \n");
					query.append("                         WHEN B.ECO_NO IS NULL AND (B.STATE_FLAG = 'D' OR B.STATE_FLAG = 'C') THEN \n");
					query.append("                              (SELECT SUM(BOM_QTY) FROM \n");
					query.append("                                    (SELECT ROW_NUMBER() OVER (PARTITION BY ITEM_CODE ORDER BY HISTORY_UPDATE_DATE DESC) AS CNT \n");
					query.append("                                          , MOTHER_CODE \n");
					query.append("                                          , ITEM_CODE \n");
					query.append("                                          , BOM_QTY \n");
					query.append("                                       FROM STX_DIS_SSC_HEAD_HISTORY \n");
					query.append("                                      WHERE ECO_NO IS NOT NULL \n");
					query.append("                               )DD \n");
					query.append("                               WHERE CNT = 1 \n");
					query.append("                                 AND MOTHER_CODE = B.MOTHER_CODE \n");
					query.append("                               GROUP BY MOTHER_CODE ) \n");
					query.append("                         ELSE 0 \n");
					query.append("                       END AS QTY \n");
					query.append("                       , MOTHER_CODE \n");
					query.append("                     FROM STX_DIS_SSC_HEAD B \n");
					query.append("                ) T \n");
					query.append("             WHERE A.MOTHER_CODE = T.MOTHER_CODE \n");
					query.append("           ),0)) AS EA \n");
					query.append("         , A.USER_ID \n");
					query.append("         , A.ECO_NO \n");
					query.append("         , TO_CHAR(C.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE \n");
					query.append("         , A.STATE_FLAG \n");
					query.append("         , SCIU.USER_NAME \n");
					query.append("         , TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
					query.append("         , (SELECT PA.DWGTITLE \n");
					query.append("              FROM DPM_ACTIVITY@"+DP_DB+" PA \n");
					query.append("             WHERE PA.CASENO = '1' \n");
					query.append("               AND PA.ACTIVITYCODE LIKE A.DWG_NO || '%' \n");
					query.append("               AND ROWNUM = 1 ) AS ITEM_DESC \n");
					query.append("         , (SELECT DDW.DWGDEPTNM \n");
					query.append("              FROM DCC_DEPTCODE@"+DP_DB+" DDP \n");
					query.append("             INNER JOIN DCC_DWGDEPTCODE@"+DP_DB+" DDW ON DDP.DWGDEPTCODE = DDW.DWGDEPTCODE \n");
					query.append("             WHERE DDP.DEPTCODE = A.DEPT_CODE \n");
					query.append("            ) AS DEPT_NAME \n");
					query.append("    FROM ( \n");
					query.append("              SELECT STP.* \n");
					query.append("                   , SBS.DELEGATE_PROJECT_NO AS MASTER_NO \n");
					query.append("                FROM STX_DIS_PENDING STP \n");
					query.append("               INNER JOIN STX_DIS_BOM_SCHEDULE_V SBS ON STP.PROJECT_NO = SBS.PROJECT_NO  \n");
					
					if(p_ship.equals("master")){
						if(!p_project.equals("")){
							p_project = p_project.replaceAll("[*]","%");
							query.append("AND DELEGATE_PROJECT_NO LIKE '"+p_project+"' \n");
						}	
					}else if(p_ship.equals("project")){
						if(!p_project.equals("")){
							p_project = p_project.replaceAll("[*]","%");
							query.append("AND PROJECT_NO LIKE '"+p_project+"' \n");
						}
					}
					query.append("             WHERE 1=1 \n");
					
					
					if(!p_userid.equals("") && !p_userid.equals("ALL") ){
						query.append("             AND USER_ID = '"+p_userid+"' \n");
					}
					if(!p_deptcode.equals("") && !p_deptcode.equals("ALL") ){
						query.append("             AND DEPT_CODE = '"+p_deptcode+"' \n");
					}
					
					//ORDER by 
					query.append("              ORDER BY STP.PROJECT_NO, STP.DWG_NO, STP.BLOCK_NO, STP.STAGE_NO, STP.STR_FLAG \n");
					query.append("    ) A \n");
					query.append("    INNER JOIN STX_COM_INSA_USER@"+ERP_DB+" SCIU ON SCIU.EMP_NO = A.USER_ID \n");
					query.append("    LEFT JOIN STX_DIS_ECO_V C ON A.ECO_NO = C.ECO_NO \n");
					query.append(") ZZ \n");
					
					query.append(" WHERE 1=1 \n");
					 
					if(!p_dwgno.equals("")){
						p_dwgno = p_dwgno.replaceAll("[*]","%");
						query.append("AND DWG_NO LIKE '"+p_dwgno+"' \n");
					}
					if(!p_blockno.equals("")){
						p_blockno = p_blockno.replaceAll("[*]","%");
						query.append("AND BLOCK_NO LIKE '"+p_blockno+"' \n");
					}
					if(!p_stageno.equals("")){
						p_stageno = p_stageno.replaceAll("[*]","%");
						query.append("AND STAGE_NO LIKE '"+p_stageno+"' \n");
					}
					
					if(!p_econo.equals("")){
						p_econo = p_econo.replaceAll("[*]","%");
						query.append("AND ECO_NO LIKE '"+p_econo+"' \n");
					}
					if(!p_pending_code.equals("")){
						p_pending_code = p_pending_code.replaceAll("[*]","%");
						query.append("AND MOTHER_CODE LIKE '"+p_pending_code+"' \n");
					}
					
					if(!p_job_code.equals("")){
						p_job_code = p_job_code.replaceAll("[*]","%");
						query.append("AND JOB_CD LIKE '"+p_job_code+"' \n");
					}
					if(!p_econo.equals("")){
						p_econo = p_econo.replaceAll("[*]","%");
						query.append("AND ECO_NO LIKE '"+p_econo+"' \n");
					}
					
					if(!p_str.equals("")){
						query.append("AND STR_FLAG LIKE '"+p_str+"' \n");
					}
					
					if(!p_ismail.equals("")){
						query.append("AND MAIL_FLAG LIKE '"+p_ismail+"' \n");
					}
					
//					if(!p_iseco.equals("")){
//						if(p_iseco.equals("Y")){
//							query.append("AND ECO_NO IS NOT NULL \n");
//						}else{
							query.append("AND ECO_NO IS NULL \n");
//						}
//					}
					if(!p_isrelease.equals("")){
						
						if(p_isrelease.equals("Y")){
							query.append("AND RELEASE_DATE IS NOT NULL \n");
						}else{
							query.append("AND RELEASE_DATE IS NULL \n");
						}
					}
					if(!p_work.equals("")){
						if(p_work.equals("open")){
							query.append("AND EA = 0 \n");
						}else if(p_work.equals("release")){
							query.append("AND EA <> 0 \n");
						}else{
							
						}
					}
					if(!p_state.equals("")){
						query.append("AND STATE_FLAG = '"+p_state+"' \n");
					}
					
					
					pstmt = conn.prepareStatement(query.toString());
										
		            ls = new ListSet(conn);
				    ls.run(pstmt);
				    
		            while ( ls.next() ){
//		            	//JOB ITEM Release Validation
		            	errorMsg += isJobRelease(ls.getString("job_cd"), p_eco_no);
		            	if(errorMsg.equals("")){
			            	isAllOk += BomProcess(ls.getString("job_cd")
						            			, p_eco_no
						            			, ls.getString("state_flag")
						            			, ls.getString("mother_code")
						            			, ls.getString("project_no")
						            			, ss_username
						            			, ss_userid
						            			, conn);
		            	}
		            }
				}else{  //??? BOM ????
					for(int i = 0; i < chklist.size(); i++){
						//JOB ITEM Release Validation
						errorMsg += isJobRelease(ar_job_cd.get(i).toString(), p_eco_no);

						if(errorMsg.equals("")){
							isAllOk += BomProcess(ar_job_cd.get(i).toString(), p_eco_no, ar_state_flag.get(i).toString(), ar_mother_code.get(i).toString(), ar_project_no.get(i).toString(), ss_username, ss_userid, conn);
						}
					}
					
				}
				// END : ????ECO?? Related Project?? ???? ????? ?????? ????????
				//ECO ??
//				ecortn = ecoInsert(context, p_eco_no, ss_userid, ss_username);
			}
			
        	if(isAllOk > 0){
        		conn.commit();
        		rBox.put("successMsg", "Success["+isAllOk+"??] "+ errorMsg);
        		rtn = true;
        	}else{
        		conn.rollback();
    			if(errorMsg.equals("")){
    				rBox.put("errorMsg", "Fail");
    			}else{
    				rBox.put("errorMsg", errorMsg);
    			}	
        		rtn = false;
        	}
        }
        catch ( Exception ex ) 
        { 
        	conn.rollback();
        	ex.printStackTrace();
        	rBox.put("errorMsg", "Fail");
        	rtn = false;
        }
        finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return rtn;
	}

	
	/* JOBCD?? Release ???????? ???.
	 * 
	 */
	private String isJobRelease(String vJobCode, String vEcoNo ){
		
		String rtnMsg = "";
		String objectRev = "";
		String parentState = "";
		try {
//			objectRev = MqlUtil.mqlCommand(context , "print bus Part "+vJobCode+" 0 select last.revision dump");
//			parentState = MqlUtil.mqlCommand(context , "print bus Part "+vJobCode+" "+objectRev+" select current dump");
//			
//			if(!parentState.equals("Release")){
//				String relECOName = MqlUtil.mqlCommand(context , "print bus Part "+vJobCode+" "+objectRev+" select relationship[New Part / Part Revision,STX DL ECO Part,STX JK ECO Part].from.name dump;");
//				if(!relECOName.equals(vEcoNo)){
//					rtnMsg += "ERROR[plm-99] : JOB ITEM("+vJobCode+")?? Release?? ?????. \n";
//				}
//			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			rtnMsg = "ERROR[plm-98] : PLM ERROR ";
			e.printStackTrace();			
		}
		return rtnMsg;
	}
	
	/* BOM ???? ???μ???
	 * 
	 */
	private int BomProcess(String vJobCode, String vEcono, String vStateFlag, String vMotherCode, String vProjectNo, 
			                  String ss_username, String ss_userid, Connection conn) throws SQLException{
		
		String errorMsg = "";
		String parentState = "";
		String itemId = "";
		int isOk = 0;
		StringBuffer query = new StringBuffer();
        PreparedStatement pstmt = null;
		
		try { 
		
			
		if(vStateFlag.equals("A")){	
			query.delete(0, query.length());
  			query.append("UPDATE STX_DIS_PENDING \n");
  			query.append("SET ECO_NO = '"+vEcono+"' \n");
  			query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
		}else if(vStateFlag.equals("D")){
			//bom ???? ????
	        query.delete(0, query.length());
	        query.append("DELETE STX_DIS_PENDING \n");
			query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
			
		}
		
		
			//TBC DataBase Execute
			pstmt = conn.prepareStatement(query.toString());
			int idx = 0;
			pstmt.setString(++idx, vJobCode + vMotherCode);
			
			isOk = pstmt.executeUpdate();
			
		
			if(isOk > 0){
				if(vStateFlag.equals("D")){
					//???? ?????? ???. ECO NO?? History?? ??????. ????
					query.delete(0, query.length());
					
		  			query.append("UPDATE STX_DIS_PENDING_HISTORY \n");
		  			query.append("SET ECO_NO = '"+vEcono+"' \n");
					query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
					query.append("  AND USER_ID = ? \n");
					query.append("  AND STATE_FLAG = 'DD' \n");
					
					pstmt = conn.prepareStatement(query.toString());
					int idx2 = 0;
					pstmt.setString(++idx2, vJobCode + vMotherCode);
					pstmt.setString(++idx2, ss_userid);							
					pstmt.executeUpdate();
					//???? ?????? ???. ECO NO?? History?? ??????. ??
				}
				
				conn.commit();
			}else{
				conn.rollback();
			}
			pstmt.close();
		}
        catch ( Exception ex ) 
        { 
        	errorMsg = "ERROR[plm-15] : PLM ERROR";
			conn.rollback();
        	ex.printStackTrace();
        	isOk = 0;
        }
        finally 
        { 
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
		return isOk;
	}

	
	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("pendingBomList")){
				ArrayList chklist = box.getArrayList("p_chkItem");
				String listKey = "";
				  
				query.append("SELECT  JOB_CD \n");
				query.append("      , MOTHER_CODE \n");
				query.append("      , PROJECT_NO \n");
				query.append("      , ITEM_CATALOG \n");
				query.append("      , DWG_NO \n");
				query.append("      , BLOCK_NO \n");
				query.append("      , STAGE_NO \n");
				query.append("      , STR_FLAG \n");
				query.append("      , MAIL_FLAG \n");
				query.append("      , STATE_FLAG \n");
				query.append("      , ECO_NO \n");
				query.append("      , USER_ID \n");
				query.append("      , CREATE_DATE \n");
				query.append("      , (SELECT PA.DWGTITLE \n");
				query.append("           FROM DPM_ACTIVITY@"+DP_DB+" PA \n");
				query.append("          WHERE PA.CASENO = '1' \n");
				query.append("            AND PA.ACTIVITYCODE LIKE A.DWG_NO || '%' \n");
				query.append("            AND ROWNUM = 1 ) AS ITEM_DESC \n");
				query.append("  FROM STX_DIS_PENDING A \n");
				query.append(" WHERE ( \n");
				for(int i = 0; i < chklist.size(); i++){
					listKey = chklist.get(i).toString().split(",")[0];
					if(i != 0) query.append("OR ");
					query.append("JOB_CD || MOTHER_CODE = '"+listKey+"' \n");	
	  		    }
				query.append(" ) \n");
				query.append("ORDER BY PROJECT_NO ,JOB_CD, MOTHER_CODE \n");
				//System.out.println(query);
			} else if(qryExp.equals("bomUpdateAction")){
				String p_eco_no = box.getString("p_eco_no");
	        	
	  			query.append("UPDATE STX_DIS_PENDING \n");
	  			query.append("SET ECO_NO = '"+p_eco_no+"' \n");
	  			query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
	  			
			} else if(qryExp.equals("bomDeleteAction")){
				
	  			query.append("DELETE STX_DIS_PENDING \n");
				query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
				
			} else if(qryExp.equals("bomDeleteHistoryEcoUpdateAction")){
				String p_eco_no = box.getString("p_eco_no");
				
	  			query.append("UPDATE STX_DIS_PENDING_HISTORY \n");
	  			query.append("SET ECO_NO = '"+p_eco_no+"' \n");
				query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
				query.append("  AND USER_ID = ? \n");
				query.append("  AND STATE_FLAG = 'DD' \n");
			}
			
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	/*
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
			query.append("WHERE A.PROJECT_NO || A.ITEM_TYPE_CD || A.DWG_NO || A.MOTHER_CODE || A.ITEM_CODE || A.SSC_SUB_ID = '"+chklist+"'");
			
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
	*/
	public String ecoInsert(Context context, String eco_no,  String userid, String username) throws Exception {
		
		String rtn = "NO";
		Connection conn 				= null;
		conn = DBConnect.getDBConnection("DIS");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	int resultCnt = 0;
    	int isOk = 0;
    	
    	
    	try 
        { 
    		query.append("SELECT COUNT(*) CNT FROM STX_DIS_ECO \n");
    		query.append("WHERE ECO_NO = ? \n");
    		
			pstmt = conn.prepareStatement(query.toString());
			pstmt.setString(1, eco_no);
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){ 
            	resultCnt = ls.getInt("cnt");
            }   
            
            if(resultCnt == 0){
            	//ECO?? ?????? ???	
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
//        		
        		
				
        		
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
					conn.commit();
					rtn = "OK";
				}else{
					conn.rollback();
					rtn = "NO";
				}
            }else{
            	rtn = "OK";
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
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
}