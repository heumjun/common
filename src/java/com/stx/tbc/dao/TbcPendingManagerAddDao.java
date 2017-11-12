package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;


import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonValidation;
import com.stx.tbc.dao.factory.Idao;

public class TbcPendingManagerAddDao implements Idao{
	

	public ArrayList<DataBox> selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
        ListSet             ls      	= null;
        ArrayList<DataBox>           list    	= null;
        DataBox             dbox    	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
        try 
        { 
        	list = new ArrayList<DataBox>();
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
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	int 				rtnVal    = 0;
    	String				query   = "";
    	
    	String err_msg = "";
    	String suc_msg = "";
		
        try 
        { 
        	//Pending ??? Insert
        	if(qryExp.equals("PendingInsert")){
        		
        		rtnVal = PendingInsert(qryExp, rBox);
        		if(rtnVal > 0){
	        		//query  = getQuery("PendingTransDataDelete",rBox);
	    			//pstmt = conn.prepareStatement(query.toString());
	            	//isOk = pstmt.executeUpdate();
        			isOk = 1;
        		}else{
        			isOk = 0;
        		}
        	}else if(qryExp.equals("PendingJobTempInsert")){
        		
        	    ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
        		String p_dwgno = rBox.getString("p_dwgno");
        		String p_stage = rBox.getString("p_stageno");
        		 
        		String[] ar_stage = p_stage.split(",");
        		String job_cd = "";
        		
        		
        		for(int i=0; i<ar_chkItem.size(); i++){
        			
        			job_cd = ar_chkItem.get(i).toString().split("\\^")[0].trim();
        			String[] use_project = ar_chkItem.get(i).toString().split("\\^")[1].trim().split(",");
        			
        			for(int j=0; j<ar_stage.length; j++){
        				//Pending?? ???? Stage?? ????????? ???? ???.
        				for(int k=0; k<use_project.length; k++){
        					err_msg = isUniqStage(conn, job_cd, p_dwgno, ar_stage[j].toString().trim(), use_project[k].toString().trim());		
        					if(!err_msg.equals("")){
            	        		break;
            	        	}
        				}
        				if(!err_msg.equals("")){
        	        		break;
        	        	}
        			}
        			if(!err_msg.equals("")){
        				break;
        			}
        		}
        		if(err_msg.equals("")){        		
        			//pending Temp Insert Ŀ????? ???? : ????? ?????.
        			isOk = PendingTempInsert(qryExp, rBox);
        			rtnVal = isOk;
        		}
        	}else if(qryExp.equals("PendingManagerAddWorkExcelImport")){
        		ArrayList list = rBox.getArrayList("insertList");
        		query  = getQuery(qryExp,rBox);
        		String ss_userid = rBox.getSession("UserId");
        		
//        		????? ??? S.
//        		String p_userid = rBox.getString("p_userid");
//        		
//        		if(!p_userid.equals("")){
//        			ss_userid = p_userid;
//        		}
//        		????? ??? E.
        		
        		// list ????
        		// MASTER : column0
        		// PROJECT : column1
        		
        		String vStage = "";
        		String vJobCd = "";
        		String vDwgNo = "";
        		String vProject = "";
        		String vCatalog = "";
        		String vDeptCode = rBox.getSession("DeptCode");
        		boolean validationFlag = true;
        		//????? ???
        		String p_deptcode = rBox.getString("p_deptcode");
        		
        		if(!p_deptcode.equals("")){
        			vDeptCode = p_deptcode;
        		}
        		
        		ArrayList<HashMap<String, String>> alist = new ArrayList<HashMap<String, String>>();
        		
        		for(int i=0;i<list.size();i++){
        			HashMap hm = (HashMap)list.get(i);
        			
        			HashMap<String, String> hm2 = new HashMap<String, String>();
        			hm2.put("project", hm.get("column1").toString());
        			hm2.put("jobcd", hm.get("column5").toString());
        			hm2.put("dwgno", hm.get("column6").toString());
        			hm2.put("stage", hm.get("column7").toString());
        			alist.add(hm2);
        		}
        		
        		//Pending?? ???? Stage?? ????????? ???? ???.
    			err_msg = getUniqStage(conn, alist);
    			
        		if(err_msg.equals("")){
	        		for(int i=0;i<list.size();i++){
	        			HashMap hm = (HashMap)list.get(i);
	        			vProject = hm.get("column1").toString();
	        			vJobCd = hm.get("column5").toString();
	        			vDwgNo = hm.get("column6").toString();
	        			vStage = hm.get("column7").toString();
	        			
	        			validationFlag = true;
	        			
	        			//Catalog?? ?????? ????
	        			vCatalog = isCatalog(conn, vDwgNo);	        			
	        			if(vCatalog.equals("")){
	        				err_msg += "Catalog?? ?????? ???????.["+vDwgNo+"]\\n";
	        				validationFlag = false;
	        			}
	        			
	        			//???????? DP??????? ??? ???? ?????? ????.
	        			if(isExcelDpList(conn, vDwgNo, vDeptCode, vProject) == 0){
	        				err_msg += "DP LIst ??????.["+vDwgNo+"/"+vProject+"]\\n";
	        				validationFlag = false;
	        			}
	        			
	        			//???? ?????? ???.
	        			if(validationFlag){
	        				//Stage?? ?????? 9999????
		        			if(vStage.equals("")){
		        				vStage = "9999";
		        			}
		        			
		        			int idx = 0;
		                	pstmt = conn.prepareStatement(query.toString());
		                
		                	pstmt.setString(++idx, vCatalog);
		                	pstmt.setString(++idx, vDwgNo); 
		                	pstmt.setString(++idx, vStage);
		                	pstmt.setString(++idx, ss_userid);
		                	pstmt.setString(++idx, vJobCd);
		                	pstmt.setString(++idx, vJobCd);
		                	pstmt.setString(++idx, vDwgNo);
		                	pstmt.setString(++idx, vStage);
		                	
		                	isOk += pstmt.executeUpdate();
	        			}
	        		}
        		}else{
        			isOk = 0;
        		}
        		rtnVal = isOk;
        	}else{
        		query  = getQuery(qryExp,rBox);
            	pstmt = conn.prepareStatement(query.toString());
            	isOk = pstmt.executeUpdate();
        	}
        	if(isOk > 0){
        		conn.commit();
        		if(rtnVal == 0){
//        			if(!suc_msg.equals("")){
//            			rBox.put("successMsg", "[Success] "+suc_msg);
//            		}else{
//            			rBox.put("successMsg", "Success");
//            		}
        			rBox.put("successMsg", "Success \\n" + err_msg);
        		}else{
            		rBox.put("successMsg", "Success : "+rtnVal+"?? \\n" + err_msg);
        		}
        		rtn = true;
        	}else{
        		conn.rollback();
//        		if(!err_msg.equals("")){
        			rBox.put("errorMsg", "Fail \\n" + err_msg);
//        		}else{
//        			rBox.put("errorMsg", );
//        		}
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
        }        
		return rtn;
	}


	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
//		 TODO Auto-generated method stub		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
    	
    	ListSet             ls      = null;
    	String 				err_msg = "";
    	
        try 
        { 
        	if(qryExp.equals("PendingJobTempModify")){
	        	//Pending Table?? ??????? Error ????? ???.
	        	ArrayList ar_ljob_cd = rBox.getArrayList("p_ljob_cd");
				ArrayList ar_ldwg_no = rBox.getArrayList("p_ldwg_no");
				ArrayList ar_lstage_no = rBox.getArrayList("p_lstage_no");
				ArrayList ar_luse_project = rBox.getArrayList("p_luse_project");
				ArrayList ar_item_catalog = rBox.getArrayList("p_item_catalog");
				//Validation1. : Stage Check
				for(int i=0; i < ar_ljob_cd.size(); i++){
					String[] use_project = ar_luse_project.get(i).toString().trim().split(",");
					for(int j=0;j<use_project.length;j++){
						err_msg = isUniqStage(conn, ar_ljob_cd.get(i).toString(), ar_ldwg_no.get(i).toString(), ar_lstage_no.get(i).toString().trim(), use_project[j]);					
			        	if(!err_msg.equals("")){
			        		break;
			        	}
					}
					if(!err_msg.equals("")){
						break;
					}
				}
				
	    		//Validation1. : Catalog Check
	    		for(int i=0; i<ar_item_catalog.size();i++){
	    			if(ar_item_catalog.get(i).equals("")){
	    				err_msg = "???[Catalog]?? ???????????.";
	    				break;
	    			}
	    		}
	
	        	//Pending Table?? ??????? Error ????? ???.
	        	if(err_msg.equals("")){
		        	//??????? ???? ??????? ???? ??????? ???????.
			    	query  = getQuery("PendingJobTempDelete",rBox);
	            	pstmt = conn.prepareStatement(query.toString());
	            	isOk = pstmt.executeUpdate();
	            	
		        	if(ar_ljob_cd.size() == 0){
		        		//??????? ?????? 0??? ??????
		        		isOk = 1;
		        	}else{
			        	query  = getQuery(qryExp,rBox);
			        	pstmt = conn.prepareStatement(query.toString());
			        	isOk = pstmt.executeUpdate();
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
        		if(!err_msg.equals("")){
        			rBox.put("errorMsg", err_msg);
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
        	if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }        
		return rtn;
	}

	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		
		try
		{
			if(qryExp.equals("pendingAddList")){
				
				String ss_dwgdeptCode = box.getSession("DwgDeptCode");
				
				String p_project = box.getString("p_project").trim();
				String p_ship = box.getString("p_ship").trim();
				String p_blockno = box.getString("p_blockno").trim();
				String p_str = box.getString("p_str").trim();
				String p_job_catalog = box.getString("p_job_catalog").trim();
				//String p_isdwg = box.getString("p_isdwg").trim();
				String p_description = box.getString("p_description").trim();
				String p_wkCnt = box.getString("p_wkCnt");
				String p_pdCnt = box.getString("p_pdCnt");
								
				
				query.append("SELECT    USE_PROJECT \n");
				query.append("        , JOB_CD \n");
				query.append("        , ACTION_FLAG \n");
				query.append("        , STR_FLAG \n");
				query.append("        , ITEM_DESC \n");
				query.append("        , BLOCK_NO \n");
				query.append("        , ACTIVITY_CD \n");
				query.append("        , JOB_CATALOG \n");
				query.append("        , DELEGATE_PROJECT_NO AS DELEGATEPROJECTNO \n");
				query.append("        , (SELECT COUNT(*) FROM STX_DIS_PENDING_WORK WHERE A.JOB_CD = JOB_CD) AS WK_CNT \n");
				query.append("        , (SELECT COUNT(*) FROM STX_DIS_PENDING WHERE A.JOB_CD = JOB_CD) AS PD_CNT \n");
				query.append("  FROM (SELECT \n");
				query.append("               CASE \n");
				query.append("                 WHEN LENGTH(USE_PROJECT) - LENGTH(REPLACE(USE_PROJECT, ',', '')) > 0 \n");
				query.append("                 THEN SUBSTR(USE_PROJECT, 0, INSTR(USE_PROJECT, ',')-1) \n");
				query.append("                 ELSE USE_PROJECT \n");
				query.append("               END FIRST_PROJECT \n");
				query.append("             , USE_PROJECT \n");
				query.append("             , (CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END) JOB_CD \n");
				query.append("             , (CASE WHEN JOB_CATALOG2 IS NULL THEN JOB_CATALOG1 ELSE JOB_CATALOG2 END) JOB_CATALOG \n");
				query.append("             , ACTION_FLAG \n");
				query.append("             , ITEM_ATTR3 AS STR_FLAG \n");
				query.append("             , STI.ITEM_DESC \n");
				query.append("             , ITEM_ATTR1 AS BLOCK_NO \n");
				query.append("             , ACTIVITY_CD \n");
				query.append("          FROM STX_DIS_JOB_CONFIRM STJC \n");
				query.append("          LEFT JOIN STX_DIS_ITEM STI ON STI.ITEM_CODE = (CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END) \n");
				query.append("          ) A \n");
				query.append(" INNER JOIN STX_DIS_BOM_SCHEDULE_V B ON A.FIRST_PROJECT = B.PROJECT_NO \n");
				query.append(" WHERE 1=1 \n");
				if(p_ship.equals("project")){
					query.append("AND INSTR(USE_PROJECT, '"+p_project+"') > 0 \n");
				}else if(p_ship.equals("master")){
					query.append("AND DELEGATE_PROJECT_NO = '"+p_project+"' \n");
				}
				/*
				if(!p_isdwg.equals("") && !p_isdwg.equals("ALL")){
					if(p_isdwg.equals("Y")){
						query.append("AND ( SELECT COUNT(*) FROM STX_DIS_PENDING_WORK B WHERE A.JOB_CD = B.JOB_CD ) > 0\n");
					}else{
						query.append("AND ( SELECT COUNT(*) FROM STX_DIS_PENDING_WORK B WHERE A.JOB_CD = B.JOB_CD ) = 0\n");
					}
				}
				*/
				if(!p_blockno.equals("")){
					p_blockno = p_blockno.replaceAll("[*]","%");
					query.append("AND BLOCK_NO LIKE '"+p_blockno+"' \n");
				}
				
				if(!p_job_catalog.equals("")){
					p_job_catalog = p_job_catalog.replaceAll("[*]","%");
					query.append("AND JOB_CATALOG LIKE '"+p_job_catalog+"' \n");
				}
				
				if(!p_str.equals("")){
					query.append("AND STR_FLAG = '"+p_str+"' \n");
				}
				
				if(!p_description.equals("")){
					p_description = p_description.replaceAll("[*]","%");
					query.append("AND ITEM_DESC LIKE '"+p_description+"' \n");
				}
				
				if(!p_wkCnt.equals("") && !p_wkCnt.equals("ALL")){
					if(p_wkCnt.equals("Y")){
						query.append("AND ( SELECT COUNT(*) FROM STX_DIS_PENDING_WORK B WHERE A.JOB_CD = B.JOB_CD ) > 0\n");
					}else{
						query.append("AND ( SELECT COUNT(*) FROM STX_DIS_PENDING_WORK B WHERE A.JOB_CD = B.JOB_CD ) = 0\n");
					}
				}
				

				if(!p_pdCnt.equals("") && !p_pdCnt.equals("ALL")){
					if(p_pdCnt.equals("Y")){
						query.append("AND ( SELECT COUNT(*) FROM STX_DIS_PENDING B WHERE A.JOB_CD = B.JOB_CD ) > 0\n");
					}else{
						query.append("AND ( SELECT COUNT(*) FROM STX_DIS_PENDING B WHERE A.JOB_CD = B.JOB_CD ) = 0\n");
					}
				}
				
				query.append(" ORDER BY USE_PROJECT, JOB_CD \n");

				
				
			}else if(qryExp.equals("PendingManagerAddMainBodyDetail")){
				String p_job_cd = box.getString("p_job_cd");
				String p_project = box.getString("p_project");
				
				query.append("	 SELECT A.ITEM_CATALOG \n");
				query.append("	      , (SELECT PA.DWGTITLE \n");
				query.append("	           FROM DPM_ACTIVITY@"+DP_DB+" PA \n");
				query.append("	          WHERE PA.CASENO = '1' \n");
				query.append("	            AND PA.ACTIVITYCODE LIKE A.DWG_NO || '%' \n");
				query.append("	            AND PA.PROJECTNO = '"+p_project+"' \n");				
				query.append("	            AND ROWNUM = 1 ) AS ITEM_DESC \n");
				query.append("	      , A.DWG_NO  \n");
				query.append("	      , A.STAGE_NO  \n");
				query.append("	      , A.MAIL_FLAG  \n");
				query.append("	      , A.JOB_CD  \n");
				query.append("	      , A.USE_PROJECT  \n");
				query.append("	      , A.BLOCK_NO  \n");
				query.append("	      , A.STR_FLAG  \n");
				query.append("	      , 'Y' AS WORK_FLAG  \n");
				query.append("	      , (SELECT USER_NAME FROM STX_COM_INSA_USER@"+ERP_DB+" WHERE EMP_NO = A.USER_ID) USER_NAME \n");				
				query.append("	   FROM STX_DIS_PENDING_WORK A \n");
				query.append("	  WHERE A.JOB_CD = '"+p_job_cd+"' \n");
				query.append("	 ORDER BY A.DWG_NO, A.STAGE_NO \n");
				
			}else if(qryExp.equals("PendingManagerAddMainBodyDetail2")){
				String p_job_cd = box.getString("p_job_cd");
				query.append("	 SELECT A.ITEM_CATALOG \n");
				query.append("	      , (SELECT PA.DWGTITLE \n");
				query.append("	           FROM DPM_ACTIVITY@"+DP_DB+" PA \n");
				query.append("	          WHERE PA.CASENO = '1' \n");
				query.append("	            AND PA.ACTIVITYCODE LIKE A.DWG_NO || '%' \n");
				query.append("	            AND PA.PROJECTNO = A.PROJECT_NO \n");
				query.append("	            AND ROWNUM = 1 ) AS ITEM_DESC \n");
				query.append("	      , A.DWG_NO  \n");
				query.append("	      , A.STAGE_NO  \n");
				query.append("	      , A.MAIL_FLAG  \n");
				query.append("	      , A.JOB_CD  \n");
				query.append("	      , A.PROJECT_NO  \n");
				query.append("	      , A.BLOCK_NO  \n");
				query.append("	      , A.STR_FLAG  \n");
				query.append("	      , A.MOTHER_CODE  \n");
				query.append("	      , 'N' AS WORK_FLAG  \n");
				query.append("	   FROM STX_DIS_PENDING A \n");
				query.append("	  WHERE A.JOB_CD = '"+p_job_cd+"' \n");
				query.append("	 ORDER BY A.DWG_NO, A.STAGE_NO, A.PROJECT_NO \n");
				
			}else if(qryExp.equals("PendingJobTempModify")){
				
				ArrayList ar_ljob_cd = box.getArrayList("p_ljob_cd");
				ArrayList ar_luse_project = box.getArrayList("p_luse_project");
				ArrayList ar_ldwg_no = box.getArrayList("p_ldwg_no");
				ArrayList ar_item_catalog = box.getArrayList("p_item_catalog");
				ArrayList ar_lmail_flag = box.getArrayList("p_lmail_flag");
				ArrayList ar_lstage_no = box.getArrayList("p_lstage_no");
				ArrayList ar_lstr_flag = box.getArrayList("p_lstr_flag");
				ArrayList ar_lblock_no = box.getArrayList("p_lblock_no");
				
				
				String ss_userid = box.getSession("UserId");
				
				query.append("INSERT \n");
				query.append("  INTO STX_DIS_PENDING_WORK( \n");
				query.append("       JOB_CD \n");
				query.append("     , USE_PROJECT \n");
				query.append("     , ITEM_CATALOG \n");
				query.append("     , DWG_NO \n");
				query.append("     , BLOCK_NO \n");
				query.append("     , STAGE_NO \n");
				query.append("     , STR_FLAG \n");
				query.append("     , MAIL_FLAG \n");
				query.append("     , USER_ID \n");
				query.append("     , CREATE_DATE ) \n");
				
				for(int i=0; i<ar_ljob_cd.size(); i++){
					if(i != 0){
						query.append("UNION \n");
					}
					query.append("SELECT \n");
					query.append("       '"+ar_ljob_cd.get(i).toString().trim()+"' \n");
					query.append("     , '"+ar_luse_project.get(i).toString().trim()+"' \n");
					query.append("     , '"+ar_item_catalog.get(i).toString().trim()+"' \n"); //Item_Catalog
					query.append("     , '"+ar_ldwg_no.get(i).toString().trim()+"' \n");
					query.append("     , '"+ar_lblock_no.get(i).toString().trim()+"' \n");  //BLOCK_NO
					if(ar_lstage_no.get(i).toString().trim().equals("")){
						query.append("     , '9999' \n");
					}else{
						query.append("     , '"+ar_lstage_no.get(i).toString().trim()+"' \n");
					}
					query.append("     , '"+ar_lstr_flag.get(i).toString().trim()+"' \n"); //STR_FLAG
					query.append("     , '"+ar_lmail_flag.get(i).toString().trim()+"' \n");
					query.append("     , '"+ss_userid+"' \n");
					query.append("     , SYSDATE \n");
					query.append(" FROM DUAL \n");
				}
				
			}else if(qryExp.equals("PendingJobTempDelete")){
				String p_hid_job_cd = box.getString("p_hid_job_cd");
				String ss_userid = box.getSession("UserId");
				
				query.append("DELETE STX_DIS_PENDING_WORK \n");
				query.append("WHERE JOB_CD = '"+p_hid_job_cd+"' \n");
				query.append("  AND USER_ID = '"+ss_userid+"' \n");
				
			}else if(qryExp.equals("PendingGetDwgno")){
				
				String p_project = box.getString("p_project");
				String p_ship = box.getString("p_ship");
				
				String p_dwgno = box.getString("p_dwgno");
				String p_deptcode = box.getString("p_deptcode");
				String vDeptCode = box.getSession("DeptCode");
				
				if(!p_deptcode.equals("")){
					vDeptCode = box.getString("p_deptcode");
				}
				query.append("SELECT DISTINCT SUBSTR(A.ACTIVITYCODE, 1, 8) AS DWG_NO \n");
				query.append("     , A.DWGTITLE AS ITEM_DESC \n");
				query.append("     , C.TBC_CATALOG_NO AS ITEM_CATALOG \n"); 
				query.append("FROM DPM_ACTIVITY@"+DP_DB+" A \n");
				query.append("INNER JOIN STX_DIS_BOM_SCHEDULE_V B ON A.PROJECTNO = B.PROJECT_NO \n");
				query.append("LEFT JOIN STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" C ON SUBSTR(A.ACTIVITYCODE, 1, 5) = C.DWG_NO_CONCAT \n");
				query.append("WHERE A.WORKTYPE = 'DW' \n");
				query.append("AND A.CASENO = '1' \n");
				if(p_ship.equals("project")){
					query.append("AND A.PROJECTNO = '"+p_project+"' \n");
				}else if(p_ship.equals("master")){
					query.append("AND B.DELEGATE_PROJECT_NO = '"+p_project+"' \n");
				}
				if(!vDeptCode.equals("")){
					query.append("AND A.DWGDEPTCODE = '"+vDeptCode+"' \n");
				}else{
					//query.append("AND A.DWGDEPTCODE = '000036' \n");
				}
				
				if(!p_dwgno.equals("")){
					query.append("AND A.ACTIVITYCODE LIKE '"+p_dwgno+"%' \n");
				}
				
			}else if(qryExp.equals("TransferDwgList")){
				
				ArrayList ar_chkDwgItem = box.getArrayList("p_chkDwgItem");
				String p_job_cd = box.getString("p_job_cd");				
				String p_project = box.getString("p_project");
				String ss_dwgdeptCode = box.getSession("DeptCode");
				
//				????? ???
        		String p_deptcode = box.getString("p_deptcode");
        		
        		if(!p_deptcode.equals("")){
        			ss_dwgdeptCode = p_deptcode;
        		}
        		
				if(ss_dwgdeptCode.equals("")){
					//ss_dwgdeptCode = "000036";
				}
				
				
				String dwg_no = "";
				String item_catalog= "";
				String item_desc= "";
				
				
				query.append("SELECT \n");
				query.append("       B.DWG_NO \n");
				query.append("     , B.ITEM_DESC \n");
				query.append("     , USE_PROJECT \n");
				query.append("     , CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END AS JOB_CD \n");
				query.append("     , '' AS STAGE_NO \n");
				query.append("     , B.ITEM_CATALOG \n");
				query.append("     , A.ITEM_ATTR1 AS BLOCK_NO \n");
				query.append("     , A.ITEM_ATTR3 AS STR_FLAG \n");
				query.append(" FROM STX_DIS_JOB_CONFIRM A \n");
				query.append(" INNER JOIN ( SELECT DISTINCT SUBSTR(A.ACTIVITYCODE, 1, 8) AS DWG_NO \n");
				query.append("                   , A.DWGTITLE AS ITEM_DESC \n");
				query.append("                   , C.TBC_CATALOG_NO AS ITEM_CATALOG \n");
				query.append("              FROM DPM_ACTIVITY@"+DP_DB+" A \n");
				query.append("              INNER JOIN STX_DIS_BOM_SCHEDULE_V B ON A.PROJECTNO = B.PROJECT_NO \n");
				query.append("              LEFT JOIN STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" C ON SUBSTR(A.ACTIVITYCODE, 1, 5) = C.DWG_NO_CONCAT \n");
				query.append("              WHERE A.WORKTYPE = 'DW' \n");
				query.append("              AND A.CASENO = '1' \n");
				query.append("              AND B.DELEGATE_PROJECT_NO = '"+p_project+"' \n");
				query.append("              AND A.DWGDEPTCODE = '"+ss_dwgdeptCode+"' \n");
				
				query.append("              ) B ON (\n");
				for(int i=0; i<ar_chkDwgItem.size(); i++){
					if(i != 0){
						query.append("          OR ");
					}
					query.append("              B.DWG_NO = '"+ar_chkDwgItem.get(i).toString().trim()+"' \n");
				}				
				query.append("      ) ");
				query.append("WHERE (CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END)  = '"+p_job_cd+"' \n");
				
			}else if(qryExp.equals("PendingTransDataDelete")){
				
				ArrayList ar_chkItem = box.getArrayList("p_chkItem");
				String ss_userid = box.getSession("UserId");
				
				//????? ??? S.
//				String p_userid = box.getString("p_userid");
//				
//				if(!p_userid.equals("")){
//					ss_userid = p_userid;
//				}
				//????? ??? E.
				String vJobCd = "";
				
				query.append(" DELETE STX_DIS_PENDING_WORK  \n");
				query.append(" WHERE 1=1  AND (");
				for(int i=0; i<ar_chkItem.size(); i++){
					vJobCd = ar_chkItem.get(i).toString().split("\\^")[0].trim();
					if(i != 0){
						query.append(" OR");
					}
					query.append(" JOB_CD = '"+vJobCd+"' ");
				}
				query.append(") \n");
				query.append("   AND USER_ID = '"+ss_userid+"' \n");
				
			} else if(qryExp.equals("PendingGetPendingDwgno")){
				
				String p_project = box.getString("p_project");
				String p_ship = box.getString("p_ship");
				String p_dwgno = box.getString("p_dwgno");
				String p_isPendingCount = box.getString("p_isPendingCount");
				
				String vDeptCode = box.getSession("DeptCode");
				String p_deptcode = box.getString("p_deptcode");
				
				if(!p_deptcode.equals("")){
					vDeptCode = box.getString("p_deptcode");
				}
				
				query.append("SELECT * FROM( \n");
				query.append("SELECT SUBSTR(A.ACTIVITYCODE, 1, 8) AS DWG_NO \n");
				query.append("     , A.DWGTITLE AS ITEM_DESC \n");
				query.append("     , C.TBC_CATALOG_NO AS ITEM_CATALOG \n");
				query.append("     , COUNT(SDP.MOTHER_CODE) AS PENDING_CNT \n");
				query.append("FROM DPM_ACTIVITY@"+DP_DB+" A \n");
				query.append("INNER JOIN STX_DIS_BOM_SCHEDULE_V B ON A.PROJECTNO = B.PROJECT_NO \n");
				query.append("LEFT JOIN STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" C ON SUBSTR(A.ACTIVITYCODE, 1, 5) = C.DWG_NO_CONCAT \n");
				query.append("LEFT JOIN STX_DIS_PENDING SDP ON SUBSTR(A.ACTIVITYCODE, 1, 8) = SDP.DWG_NO AND  A.PROJECTNO = SDP.PROJECT_NO\n");
				query.append("WHERE A.WORKTYPE = 'DW' \n");
				query.append("AND A.CASENO = '1' \n");
				
				if(p_ship.equals("project")){
					query.append("AND A.PROJECTNO = '"+p_project+"' \n");
				}else if(p_ship.equals("master")){
					query.append("AND B.DELEGATE_PROJECT_NO = '"+p_project+"' \n");
				}
				if(!vDeptCode.equals("")){
					query.append("AND A.DWGDEPTCODE = '"+vDeptCode+"' \n");
				}else{
					//query.append("AND A.DWGDEPTCODE = '000036' \n");
				}
				
				if(!p_dwgno.equals("")){
					query.append("AND A.ACTIVITYCODE LIKE '"+p_dwgno+"%' \n");
				}
				query.append("GROUP BY A.ACTIVITYCODE \n");
				query.append("       , A.DWGTITLE \n");
				query.append("       , C.TBC_CATALOG_NO \n");
				query.append(")  \n");
				query.append("WHERE 1=1  \n");

				if(!p_isPendingCount.equals("ALL")){
					if(p_isPendingCount.equals("Y")){
						query.append("AND PENDING_CNT > 0 \n");
					}else{
						query.append("AND PENDING_CNT = 0 \n");
					}
				}
				
			}else if(qryExp.equals("PendingManagerAddWorkExcelImport")){
				
				query.append("INSERT \n");
				query.append("  INTO STX_DIS_PENDING_WORK( \n");
				query.append("       JOB_CD \n");
				query.append("     , USE_PROJECT \n");
				query.append("     , ITEM_CATALOG \n");
				query.append("     , DWG_NO \n");
				query.append("     , BLOCK_NO \n");
				query.append("     , STAGE_NO \n");
				query.append("     , STR_FLAG \n");
				query.append("     , MAIL_FLAG \n");
				query.append("     , USER_ID \n");
				query.append("     , CREATE_DATE \n");
				query.append("     ) \n");
				query.append("  SELECT  (CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END) JOB_CD \n");
				query.append("        , USE_PROJECT \n");
				query.append("        , ? \n");  //catalog
				//query.append("        , ?\n"); //TEST ?? 
				query.append("        , ? \n"); //DWG_NO
				query.append("        , ITEM_ATTR1 AS BLOCK_NO \n");
				query.append("        , ? \n"); //STAGE
				query.append("        , ITEM_ATTR3 AS STR_FLAG \n");
				query.append("        , 'Y' \n");
				query.append("        , ? \n"); // USERID
				query.append("        , SYSDATE \n");
				query.append("     FROM STX_DIS_JOB_CONFIRM \n");
				query.append("   WHERE (CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END)  = ? \n"); //JOB_CD
				query.append("     AND NOT EXISTS ( \n");
				query.append("             SELECT * \n");
				query.append("               FROM STX_DIS_PENDING_WORK B \n");
				query.append("              WHERE JOB_CD = ? \n");
				query.append("                AND DWG_NO = ? \n");
				query.append("                AND STAGE_NO = ? ) \n");
			}			
//			System.out.println(query);			
		}catch (Exception ex) 
		{
			ex.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	
	public int PendingInsert(String qryExp, RequestBox rBox) throws Exception {
		//TODO Auto-generated method stub
		
		Connection conn = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
		ListSet             ls      = null;
        PreparedStatement 	pstmt1 	= null;
        PreparedStatement 	pstmt2 	= null;
        PreparedStatement 	pstmt4 	= null;
        CallableStatement  	cstmt	= null;
        
        int 				rtn 	= 0;
	    int 				isOk    = 0;
	    
	    StringBuffer query1 = new StringBuffer();
	    StringBuffer query2 = new StringBuffer();
	    StringBuffer query4 = new StringBuffer();
	    
//	    Context	context = null;
//		context	= Framework.getFrameContext(rBox.getHttpSession());
		
        try 
        { 
        	String vProject_no = "";
        	String vMother_temp = "";
        	String vDwg_no = "";
        	String vStage_no = "";
        	String vStr_flag = "";
        	String vBlock_no = "";
        	String vMother_code = "";
        	String vCatalog = "";
        	String vCategory = "";
        	String vProjectShipPattern = "";
//        	String vMasterNo = "";
        	String vDescription = "";
        	String vJobCd = "";
        	String vShipType = ""; 
        	String vErrMsg = "";
		    String vErrCd = "";
		    
			String ss_userid = rBox.getSession("UserId");
			String ss_deptcode = rBox.getSession("DeptCode");
			String ss_username = rBox.getSession("UserName");
        	//????? ??? S
//        	String ss_userid = rBox.getString("p_userid");
//			String ss_deptcode = rBox.getString("p_deptcode");
//			String ss_username = rBox.getString("p_user");
//        	
//			if(ss_userid.equals("")){
//				ss_userid = rBox.getSession("UserId");
//			}
//			if(ss_deptcode.equals("")){
//				ss_deptcode = rBox.getSession("DeptCode");
//			}
//			if(ss_username.equals("")){
//				ss_username = rBox.getSession("UserName");
//			}
			//????? ??? E
//			ArrayList ar_real_ljob_cd = rBox.getArrayList("p_real_ljob_cd");
			ArrayList ar_chkItem = rBox.getArrayList("p_chkItem");
			ArrayList ar_real_master_no = rBox.getArrayList("p_real_master_no");
			
			query1.delete(0, query1.length());
			query1.append("SELECT \n");
			query1.append("STX_STD_SD_ITEM_F@"+ERP_DB+"(COLUMN_VALUE, B.ITEM_CATALOG \n");
			query1.append("                         , (SELECT SSSM.SHIP_TYPE \n");
			query1.append("                              FROM STX_STD_SD_MODEL@"+ERP_DB+"        SSSM \n");
			query1.append("                                 , STX_DIS_BOM_SCHEDULE_V SSSP \n");
			query1.append("                             WHERE SSSP.MODEL_NO   = SSSM.MODEL_NO \n");
			query1.append("                               AND SSSP.PROJECT_NO = COLUMN_VALUE) \n");
			query1.append("                        ) AS MOTHER_TEMP \n");
			query1.append(", COLUMN_VALUE AS PROJECT_NO \n");
			query1.append(", DWG_NO \n");
			query1.append(", STAGE_NO \n");
			query1.append(", STR_FLAG \n");
			query1.append(", BLOCK_NO \n");
			query1.append(", C.CATALOG_CODE \n");
			query1.append(", C.CATEGORY_CODE \n");
			query1.append(", C.ITEM_DESC \n");
			query1.append(", (SELECT SHIP_TYPE \n");
        	query1.append("     FROM STX_DIS_BOM_SCHEDULE_V A \n");
        	query1.append("         ,STX_STD_SD_MODEL@"+ERP_DB+"  B \n");
        	query1.append("    WHERE A.MODEL_NO = B.MODEL_NO \n");
        	query1.append("      AND A.PROJECT_NO = (SELECT DELEGATE_PROJECT_NO FROM STX_DIS_BOM_SCHEDULE_V WHERE PROJECT_NO = COLUMN_VALUE) ) AS SHIP_TYPE \n"); //MASTER ??? a??.
			query1.append("FROM TABLE(STX_FN_SPLIT( \n");
			query1.append("    (SELECT USE_PROJECT \n");
			query1.append("       FROM STX_DIS_JOB_CONFIRM \n");
			query1.append("      WHERE (CASE WHEN JOB_CD2 IS NULL THEN JOB_CD1 ELSE JOB_CD2 END) = ? ) \n");
			query1.append("    ) \n");
			query1.append(") A \n");
			query1.append(", (SELECT ITEM_CATALOG, DWG_NO, STAGE_NO, BLOCK_NO, STR_FLAG \n");
			query1.append("     FROM STX_DIS_PENDING_WORK \n");
			query1.append("    WHERE JOB_CD = ? ) B \n");
			query1.append(", ( SELECT DWG_NO_CONCAT \n");
			query1.append("          ,SSSC.CATALOG_CODE                                                          AS CATALOG_CODE --???α? \n");
			query1.append("          ,SSCA.CATEGORY_CODE1||'.'||SSCA.CATEGORY_CODE2 ||'.' || SSCA.CATEGORY_CODE3 AS CATEGORY_CODE--???? \n");
			query1.append("          ,SSSC.CATALOG_DESC    					                              		 AS ITEM_DESC \n");
			query1.append("      FROM STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" SDCM \n");
			query1.append("          ,STX_STD_SD_CATALOG@"+ERP_DB+"       SSSC \n");
			query1.append("          ,STX_STD_SD_CATEGORY@"+ERP_DB+"      SSCA \n");
			query1.append("     WHERE SDCM.TBC_CATALOG_NO = SSSC.CATALOG_CODE \n");
			query1.append("       AND SSSC.CATEGORY_ID    = SSCA.CATEGORY_ID ) C \n");
			query1.append(" WHERE C.DWG_NO_CONCAT    = SUBSTR(B.DWG_NO, 0, 5) \n");
			
			pstmt1 = conn.prepareStatement(query1.toString());
			
			for(int i=0; i<ar_chkItem.size(); i++){
				
				ArrayList<HashMap<String, String>> ar_tempData = new ArrayList<HashMap<String, String>>();
				pstmt1.clearParameters();
				vJobCd = ar_chkItem.get(i).toString().split("\\^")[0].trim();
				
				pstmt1.setString(1, vJobCd);
				pstmt1.setString(2, vJobCd);
				
			    ls = new ListSet(conn);
			    ls.run(pstmt1);
			    
			    while ( ls.next() ){
			    	HashMap<String, String> hm = new HashMap<String, String>();
			    	hm.put("mother_temp",  ls.getString("mother_temp"));
			    	hm.put("project_no",  ls.getString("project_no"));
			    	hm.put("dwg_no",  ls.getString("dwg_no"));
			    	hm.put("stage_no",  ls.getString("stage_no"));
			    	hm.put("block_no",  ls.getString("block_no"));
			    	hm.put("str_flag",  ls.getString("str_flag"));
			    	hm.put("catalog_code",  ls.getString("catalog_code"));
			    	hm.put("category_code",  ls.getString("category_code"));
			    	hm.put("item_desc",  ls.getString("item_desc"));
			    	hm.put("ship_type",  ls.getString("ship_type"));
			    	
			    	ar_tempData.add(hm);
			    }
			    
			    
//			    vProjectShipPattern = MqlUtil.mqlCommand(context , "print bus 'Product Configuration' "+ar_real_master_no.get(i)+" - select relationship[Product Configuration].from.relationship[Products].from.name dump");
				
			    if(ar_tempData.size() > 0){
			    	query2.delete(0, query2.length());
			    	query2.append("INSERT \n");
			    	query2.append("  INTO STX_DIS_PENDING( \n");
			    	query2.append("       JOB_CD \n");
			    	query2.append("     , MOTHER_CODE \n");
			    	query2.append("     , PROJECT_NO \n");
			    	query2.append("     , ITEM_CATALOG \n");
			    	query2.append("     , DWG_NO \n");
			    	query2.append("     , BLOCK_NO \n");
			    	query2.append("     , STAGE_NO \n");
			    	query2.append("     , STR_FLAG \n");
			    	query2.append("     , MAIL_FLAG \n");
			    	query2.append("     , STATE_FLAG \n");
			    	query2.append("     , USER_ID \n");
			    	query2.append("     , DEPT_CODE \n");
			    	query2.append("     , CREATE_DATE ) \n");
					
					
					int     SuccessCnt = 0;
					for(int j=0; j < ar_tempData.size(); j++){
						
						HashMap hm = ar_tempData.get(j);
						
						vMother_temp = hm.get("mother_temp").toString();
						vProject_no = hm.get("project_no").toString();
						vDwg_no = hm.get("dwg_no").toString();
						vStage_no = hm.get("stage_no").toString();
						vStr_flag = hm.get("str_flag").toString();
						vBlock_no = hm.get("block_no").toString();
						vCatalog = hm.get("catalog_code").toString();
						vCategory = hm.get("category_code").toString();
						vShipType = hm.get("ship_type").toString();
						
						vDescription = hm.get("item_desc").toString() + " " + vStage_no.replaceAll("9999", "");
						//-----?????? a?? S------//
						
						if(vMother_temp.lastIndexOf(",999999")>-1){
							vMother_temp = vMother_temp.substring(0 , vMother_temp.lastIndexOf(","));
														
			            	StringBuffer sp_query = new StringBuffer();
			            	
			            	sp_query.append("call stx_dis_item_pkg.stx_dis_main_proc( \n");
			            	sp_query.append("     p_catalog_code => ? \n");
			            	sp_query.append("	, p_ship_type => ? \n");
			            	sp_query.append("	, p_weight => '0' \n");
			            	sp_query.append("	, p_loginid => ? \n");
			            	sp_query.append("	, p_err_msg => ? \n");
			            	sp_query.append("	, p_err_code => ? \n");
			            	sp_query.append("	, p_item_code => ? ) \n");
			            	
			            	//GET ITEM CODE
			            	cstmt = conn.prepareCall(sp_query.toString());
			    		
			    		    int idx = 0;
			    			cstmt.setString(++idx, vCatalog);
			            	cstmt.setString(++idx, vShipType);
			            	cstmt.setString(++idx, rBox.getSession("UserId"));
			            	
			            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
			            	int p_err_msg_idx = idx;
			            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
			            	int p_err_cd_idx = idx;
			            	cstmt.registerOutParameter(++idx, java.sql.Types.VARCHAR);
			            	int p_item_code_idx = idx;
			            	
			    		    cstmt.execute();

			    		    vErrMsg = cstmt.getString(p_err_msg_idx);
			    		    vErrCd = cstmt.getString(p_err_cd_idx);
			    		    vMother_code = cstmt.getString(p_item_code_idx);
			    		    
			            	System.out.println("p_err_msg : " + vErrMsg);
			            	System.out.println("p_err_cd : " + vErrCd);
			            	System.out.println("p_item_code : " + vMother_code);
							
						}
						//ITEM ??? ???? ??
						//Pending Table?? ???
						if(vErrCd.equals("S")){
							
							//???? ???, ???? ???? ???? stage?? ?????? ???. 
							//true ??? ???.
							if(getIsPending(vJobCd, vProject_no, vDwg_no, vStage_no, vBlock_no, vStr_flag)){
								
								if(SuccessCnt != 0){
									query2.append("UNION \n");
								}
								
								query2.append("SELECT \n");
								query2.append("      A.JOB_CD \n");
								query2.append("    , '"+vMother_code+"' AS MOTHER_CODE \n");
								query2.append("    , '"+vProject_no+"' AS PROJECT_NO \n");
								query2.append("    , A.ITEM_CATALOG \n");
								query2.append("    , A.DWG_NO \n");
								query2.append("    , A.BLOCK_NO \n");
								query2.append("    , CASE WHEN A.STAGE_NO = '9999' THEN '' ELSE A.STAGE_NO END AS STAGE_NO \n");
								query2.append("    , A.STR_FLAG \n");
								query2.append("    , A.MAIL_FLAG \n");
								query2.append("    , 'A' \n"); 
								query2.append("    , '"+ss_userid+"' \n");
								query2.append("    , '"+ss_deptcode+"' \n");
								query2.append("    , SYSDATE \n");
								query2.append("    FROM STX_DIS_PENDING_WORK A \n");
								query2.append("    WHERE A.JOB_CD = '"+vJobCd+"' \n");
								query2.append("      AND A.DWG_NO = '"+vDwg_no+"' \n");
								query2.append("      AND A.STAGE_NO = '"+vStage_no+"' \n");
								query2.append("      AND A.USER_ID = '"+ss_userid+"' \n");
								SuccessCnt++;	
							}
						}
					}
					
					//TBC Item Master Insert
					int subisOk = 0;
					int WkDelOk = 0;
//					System.out.println(query2);
					pstmt2 = conn.prepareStatement(query2.toString());
					subisOk = pstmt2.executeUpdate();
					
			    	if(subisOk > 0){
			    		//????? ?? ????
			    		query4.delete(0, query4.length());
						query4.append(" DELETE STX_DIS_PENDING_WORK  \n");
						query4.append("  WHERE JOB_CD = '"+vJobCd+"' \n");
						query4.append("    AND USER_ID = '"+ss_userid+"'\n");
		    			pstmt4 = conn.prepareStatement(query4.toString());
		    			WkDelOk = pstmt4.executeUpdate();
			    	}
			    	
			    	if(subisOk > 0 && WkDelOk > 0){
			    		isOk += SuccessCnt;
			    		conn.commit();
			    	}else{
			    		conn.rollback();
			    	}
			    	if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
		            if ( pstmt4 != null ) { try { pstmt4.close(); } catch ( Exception e ) { } }    
		            if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
		            
			    }
			}
			
        } catch ( Exception ex ){
        	conn.rollback();
        	ex.printStackTrace();
        	isOk = 0;
        }
        finally 
        { 
           if ( pstmt1 != null ) { try { pstmt1.close(); } catch ( Exception e ) { } }
           if ( pstmt2 != null ) { try { pstmt2.close(); } catch ( Exception e ) { } }
           if ( pstmt4 != null ) { try { pstmt4.close(); } catch ( Exception e ) { } }
           if ( cstmt != null ) { try { cstmt.close(); } catch ( Exception e ) { } }
           if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
           if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
        }        
		return isOk;
	}

	public int PendingTempInsert(String qryExp, RequestBox box) throws Exception {
		//TODO Auto-generated method stub
		
		Connection conn = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		
        PreparedStatement 	pstmt 	= null;
        
        StringBuffer query = new StringBuffer();
        
	    int 				isOk    = 0;
	    int 				isAllOk    = 0;
	    
	    ArrayList ar_chkItem = box.getArrayList("p_chkItem");
		
		String p_dwgno = box.getString("p_dwgno");
		String p_stage = box.getString("p_stageno");
		String ss_userid = box.getSession("UserId");
		
//		????? ??? S.
//		String p_userid = box.getString("p_userid");
//		
//		if(!p_userid.equals("")){
//			ss_userid = p_userid;
//		}
//		????? ??? E.
		
		String[] ar_stage = p_stage.split(",");
		String job_cd = "";
		String use_project= "";
		String block_no= "";
		String str_flag= "";
		String msg = "";
		int cnt = 0;
		TBCCommonValidation commonVal = new TBCCommonValidation();		

		try{
//			???α?? ????? Validation	
			String vCatalog = isCatalog(conn, p_dwgno);
			if(vCatalog.equals("")){
				isAllOk = -20;
			}else{
				for(int i=0; i<ar_chkItem.size(); i++){	
					job_cd = ar_chkItem.get(i).toString().split("\\^")[0].trim();
					use_project = ar_chkItem.get(i).toString().split("\\^")[1].trim();
					block_no = ar_chkItem.get(i).toString().split("\\^")[2].trim();
					str_flag = ar_chkItem.get(i).toString().split("\\^")[3].trim();
					
					query.delete(0, query.length());
					query.append("INSERT \n");
					query.append("  INTO STX_DIS_PENDING_WORK( \n");
					query.append("       JOB_CD \n");
					query.append("     , USE_PROJECT \n");
					query.append("     , ITEM_CATALOG \n");
					query.append("     , DWG_NO \n");
					query.append("     , BLOCK_NO \n");
					query.append("     , STAGE_NO \n");
					query.append("     , STR_FLAG \n");
					query.append("     , MAIL_FLAG \n");
					query.append("     , USER_ID \n");
					query.append("     , CREATE_DATE ) \n");
					query.append("SELECT \n");
					query.append("       JOB_CD \n");
					query.append("     , USE_PROJECT \n");
					query.append("     , ITEM_CATALOG \n");
					query.append("     , DWG_NO \n");
					query.append("     , BLOCK_NO \n");
					query.append("     , STAGE_NO \n");
					query.append("     , STR_FLAG \n");
					query.append("     , MAIL_FLAG \n");
					query.append("     , USER_ID \n");
					query.append("     , CREATE_DATE \n");
					query.append(" FROM ( \n");
					
					if(ar_stage.length > 0){
						cnt = 0;
						for(int j=0; j<ar_stage.length; j++){
							if(commonVal.isPendingWork(job_cd, p_dwgno, ar_stage[j].toString().trim()) == 0){
								if(cnt != 0){
									query.append("UNION  \n");
								}
								query.append("SELECT \n");
								query.append("       '"+job_cd+"' AS JOB_CD\n");
								query.append("     , '"+use_project+"' AS USE_PROJECT \n");
								query.append("     , '"+vCatalog+"' AS ITEM_CATALOG \n"); //Item_Catalog
								query.append("     , '"+p_dwgno+"' AS DWG_NO\n");
								query.append("     , '"+block_no+"' AS BLOCK_NO\n");  //BLOCK_NO
								if(ar_stage[j].toString().trim().equals("")){
									query.append("     , '9999' AS STAGE_NO\n");
								}else{
									query.append("     , '"+ar_stage[j].toString().trim()+"' AS STAGE_NO\n");
								}
								query.append("     , '"+str_flag+"' AS STR_FLAG\n"); //STR_FLAG
								query.append("     , 'Y' AS MAIL_FLAG\n");
								query.append("     , '"+ss_userid+"' AS USER_ID\n");
								query.append("     , SYSDATE AS CREATE_DATE \n");
								query.append(" FROM DUAL \n");
								//MAXIMUM ???? ????. ????? ???.
								cnt++;
							}else{
								if(msg.equals("")){
									msg = "??? Stage?? ???????  Skip???????.";
								}else{
									msg += ", ";
								}
								msg += "[" + job_cd + "/" + ar_stage[j].toString().trim() + "]";
							}
						}
					}else{
						if(commonVal.isPendingWork(job_cd, p_dwgno, "9999") == 0){
							query.append("SELECT \n");
							query.append("       '"+job_cd+"' AS JOB_CD\n");
							query.append("     , '"+use_project+"' AS USE_PROJECT \n");
							query.append("     , '"+vCatalog+"' AS ITEM_CATALOG \n"); //Item_Catalog
							query.append("     , '"+p_dwgno+"' AS DWG_NO\n");
							query.append("     , '"+block_no+"' AS BLOCK_NO\n");  //BLOCK_NO
							query.append("     , '9999' AS STAGE_NO\n");
							query.append("     , '"+str_flag+"' AS STR_FLAG\n"); //STR_FLAG
							query.append("     , 'Y' AS MAIL_FLAG\n");
							query.append("     , '"+ss_userid+"' AS USER_ID\n");
							query.append("     , SYSDATE AS CREATE_DATE \n");
							query.append(" FROM DUAL \n");
							cnt++;
						}
					}
					query.append(") A \n");
	//				System.out.println(query);
					
			    	pstmt = conn.prepareStatement(query.toString());
			    	if(cnt > 0){
				    	isOk = pstmt.executeUpdate();
					}
			    	if(isOk > 0 ){
			    		isAllOk++;
			    		conn.commit();
			    	}else{
			    		conn.rollback();
			    	}
				}
			}

        } catch ( Exception ex ){
        	conn.rollback();
        	ex.printStackTrace();
        	isAllOk = 0;
        }
        finally 
        { 
           if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
           if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
        }        
		return isAllOk;
	}
	public boolean getIsPending(String p_job_code, String p_project, String p_dwgno, String p_stage_no, String p_block_no, String p_str_flag) throws Exception {
		//TODO Auto-generated method stub
		
		//???? Pending?? ????? ???.
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("DIS");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {    		

    		query.append("SELECT COUNT(*) \n");
    		query.append("  FROM STX_DIS_PENDING \n");
    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND BLOCK_NO = '"+p_block_no+"' \n");
    		query.append("   AND STAGE_NO = '"+p_stage_no+"' \n");
    		query.append("   AND STR_FLAG = '"+p_str_flag+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND JOB_CD = '"+p_job_code+"' \n");
    		
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
            if ( ls.next() ){
//            	true?? ???
            	if(ls.getInt(1) > 0){
           		 	rtn = false;
                }else{
               	 	rtn = true;
                }
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
        return rtn;
	}
	
	//???? Pending?? ????? ???. list????. (??? ????)
	public String getUniqStage(Connection conn, ArrayList<HashMap<String, String>> p_list) throws Exception {
		//TODO Auto-generated method stub
		
		String rtn = "";		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
        StringBuffer selQuery = new StringBuffer();
    	
    	String vJobCd = "";
    	String vDwgNo = "";
    	String vStage = "";
    	String vProject = "";
    	
    	try 
        {
        	//???? JOB_CD, DWG_NO?? STAGE?? ????? ??? 
        	
        	selQuery.append("SELECT SDP.JOB_CD \n");
        	selQuery.append("     , SDP.DWG_NO \n");
        	selQuery.append("     , SDP.STAGE_NO \n");
    		selQuery.append("  FROM STX_DIS_PENDING SDP \n");
    		selQuery.append(" WHERE SDP.PROJECT_NO || SDP.JOB_CD || SDP.DWG_NO || SDP.STAGE_NO IN ( \n");
    		
    		
    		for(int i=0;i<p_list.size();i++){
    			HashMap hm = p_list.get(i);
    			vProject = hm.get("project").toString();
    			vJobCd = hm.get("jobcd").toString();
    			vDwgNo = hm.get("dwgno").toString();
    			vStage = hm.get("stage").toString();
    			if(vStage.equals("9999")){
    				vStage = "";
    	    	}
    			if(i > 0){
    				selQuery.append(",");
    			}
    			selQuery.append("'" + vProject + vJobCd + vDwgNo + vStage + "'");
    			
    		}
    		selQuery.append(" ) \n");
    		ls = new ListSet(conn);
    		System.out.println(selQuery.toString());
        	pstmt = conn.prepareStatement(selQuery.toString());
        	
		    ls.run(pstmt);
		    
		    while(ls.next()){
		    	rtn += "???? Stage["+ls.getString("stage_no")+"]?? ????????.("+ls.getString("job_cd")+"/"+ls.getString("dwg_no")+")\\n";
		    }
        }
        catch ( Exception ex ) 
        {
        	rtn = ex.getLocalizedMessage().replaceAll("\"", "'");
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	

	//Excel???ε? ?? DP??????? ????? ???.
	public int isExcelDpList(Connection conn, String p_dwgno, String p_dwgdeptcode, String p_project) throws Exception {
		//TODO Auto-generated method stub
		
		String rtn = "";		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
        StringBuffer query = new StringBuffer();
    	int getUnqCnt = 0;
    	
    	String vProject[] = p_project.split(",");  
    	
    	try 
        {
        	//???? JOB_CD, DWG_NO?? STAGE?? ????? ??? 

    		//String ss_dwgdeptcode = box.getSession("DwgDeptCode");
    		
    		query.append("SELECT COUNT(*) AS CNT \n");
    		query.append("  FROM DPM_ACTIVITY@"+DP_DB+" A \n");
    		query.append(" WHERE 1=1 \n");
    		query.append("   AND A.DWGDEPTCODE = '"+p_dwgdeptcode+"' \n");
    		query.append("   AND A.WORKTYPE = 'DW' \n");
    		query.append("   AND A.CASENO = '1' \n");
    		query.append("   AND SUBSTR(A.ACTIVITYCODE, 0, 8) = '"+p_dwgno+"' \n");
    		query.append("   AND ( \n");
    		
    		for(int i=0; i<vProject.length; i++){
    			if(i!=0){
    				query.append(" OR ");
    			}
    			query.append(" A.PROJECTNO = '"+vProject[i]+"' ");
    		}
    		query.append("   ) \n");
    		
    		ls = new ListSet(conn);        		
        	pstmt = conn.prepareStatement(query.toString());
        	
		    ls.run(pstmt);
		    if(ls.next()){
		    	getUnqCnt = ls.getInt("cnt");
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
        return getUnqCnt;
	}
	
//	???? Pending?? ????? ???.
	public String isUniqStage(Connection conn, String p_job_cd, String p_dwg_no, String p_stage_no, String p_project_no) throws Exception {
		//TODO Auto-generated method stub
		
		String rtn = "";		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
        StringBuffer selQuery = new StringBuffer();
    	int getUnqCnt = 0;
    	
    	if(p_stage_no.equals("9999")){
    		p_stage_no = "";
    	}
    	
    	try 
        {
        	//???? JOB_CD, DWG_NO?? STAGE?? ????? ??? 
        	
        	selQuery.append("SELECT COUNT(*) AS CNT \n");
    		selQuery.append("  FROM STX_DIS_PENDING SDP \n");
    		selQuery.append(" WHERE SDP.JOB_CD = ? \n");
    		selQuery.append("   AND SDP.DWG_NO = ? \n");
    		selQuery.append("   AND SDP.PROJECT_NO = ? ");
    		
    		if(p_stage_no.equals("")){
    			selQuery.append("   AND SDP.STAGE_NO IS NULL \n");
    		}else{
    			selQuery.append("   AND SDP.STAGE_NO = ? \n");
    		}
    		ls = new ListSet(conn);
    		
    		int idx = 0;        		
        	pstmt = conn.prepareStatement(selQuery.toString());
        	pstmt.setString(++idx, p_job_cd);
        	pstmt.setString(++idx, p_dwg_no);
        	pstmt.setString(++idx, p_project_no);
        	if(!p_stage_no.equals("")){
        		pstmt.setString(++idx, p_stage_no);
        	}
		    ls.run(pstmt);
		    
		    if(ls.next()){
		    	getUnqCnt = ls.getInt("cnt");
		    }
		    if(getUnqCnt != 0){
		    	rtn = "???? Stage["+p_stage_no+"]?? ????????.("+p_job_cd+"/"+p_dwg_no+")";
		    }
        }
        catch ( Exception ex ) 
        {
        	rtn = "System Error";
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
//	???? Pending?? ????? ???.
	public String isCatalog(Connection conn, String p_dwgno) throws Exception {
		
		//TODO Auto-generated method stub
			
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
        StringBuffer query = new StringBuffer();
    	String vCatalog = "";
    	
    	try 
        {	
    		query.append("SELECT SDCM.TBC_CATALOG_NO \n");
    		query.append("  FROM STX_DWG_CATEGORY_MASTERS@"+ERP_DB+" SDCM \n");
    		query.append(" WHERE DWG_NO_CONCAT = ? \n");
    		
    		ls = new ListSet(conn);
    		   		
        	pstmt = conn.prepareStatement(query.toString());
        	pstmt.setString(1, p_dwgno.substring(0, 5));
        	
		    ls.run(pstmt);
		    
		    if(ls.next()){
		    	vCatalog = ls.getString(1);
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
        return vCatalog;
	}

}