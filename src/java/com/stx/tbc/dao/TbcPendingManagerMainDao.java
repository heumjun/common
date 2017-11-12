package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcPendingManagerMainDao implements Idao{
	

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
		
        PreparedStatement 	pstmt 	= null;
    	boolean 			rtn 	= false;
    	int 				isOk    = 0;
    	String				query   = "";
        try 
        { 
        	ArrayList ar_AllItem = rBox.getArrayList("p_AllItem");
        	ArrayList ar_mail_flag = rBox.getArrayList("p_mail_flag");
        	
        	query  = getQuery(qryExp,rBox);
        	
        	for(int i=0; i<ar_AllItem.size(); i++){
        		pstmt = conn.prepareStatement(query.toString());
        		
        		pstmt.setString(1, ar_mail_flag.get(i).toString());
        		pstmt.setString(2, ar_AllItem.get(i).toString());
        		
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
		
		String p_project = box.getString("p_project");
		String p_dwgno = box.getString("p_dwgno");
		String p_blockno = box.getString("p_blockno");
		String p_stageno = box.getString("p_stageno");
		String p_dept = box.getString("p_dept");
		String p_user = box.getString("p_user");
		String p_econo = box.getString("p_econo");
		String p_str = box.getString("p_str");
		String p_ismail = box.getString("p_ismail");
		String p_iseco = box.getString("p_iseco");
		String p_isrelease = box.getString("p_isrelease");
		String ss_depeCode = box.getSession("DeptCode");
		String p_deptcode = box.getString("p_deptcode");
		String p_userid = box.getString("p_userid");
		String p_selUser = box.getString("p_selUser");
		String p_work = box.getString("p_work");		
		String p_ship = box.getString("p_ship");
		String p_job_code = box.getString("p_job_code");
		String p_pending_code = box.getString("p_pending_code");
		String p_state = box.getString("p_state");
		String p_isexcel = box.getString("p_isexcel");
		String p_isact = box.getString("p_isact");
		String p_isChgUpp = box.getString("p_isChgUpp");
		
		//Paging 처리  변수 S
		int p_nowpage = box.getInt("p_nowpage");
		int p_printrow = box.getInt("p_printrow");
		
		int StartNum = (p_nowpage-1) * p_printrow;
		int EndNum = ((p_nowpage-1) * p_printrow) + p_printrow;
		//Paging 처리  변수 E
		
		try
		{
			if(qryExp.equals("PendingManagerMainList")){
				
				//Excel 출력이면 모두 출력. - Paging 기능 숨김
				if(!p_isexcel.equals("Y")){
					query.append("SELECT * FROM ( \n");
					query.append("SELECT ROWNUM AS RNUM, XX.* FROM ( \n");
				}
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
				query.append("                     SELECT \n");
				query.append("                         CASE \n");
				query.append("                             WHEN B.ECO_NO IS NOT NULL AND (B.STATE_FLAG = 'A' OR B.STATE_FLAG = 'C') THEN B.BOM_QTY \n");
				query.append("                             WHEN B.ECO_NO IS NULL AND (B.STATE_FLAG = 'D' OR B.STATE_FLAG = 'C') THEN \n");
				query.append("                              (SELECT SUM(BOM_QTY) FROM \n");
				query.append("                                    (SELECT ROW_NUMBER() OVER (PARTITION BY ITEM_CODE, MOTHER_CODE ORDER BY HISTORY_UPDATE_DATE DESC) AS CNT \n");
				query.append("                                          , MOTHER_CODE \n");
				query.append("                                          , ITEM_CODE \n");
				query.append("                                          , BOM_QTY \n");
				query.append("                                       FROM STX_DIS_SSC_HEAD_HISTORY \n");
				query.append("                                      WHERE ECO_NO IS NOT NULL \n");
				query.append("                                    )DD \n");
				query.append("                                    WHERE CNT = 1 \n");
				query.append("                                      AND MOTHER_CODE = B.MOTHER_CODE \n");
				query.append("                                      AND ITEM_CODE = B.ITEM_CODE \n");
				query.append("                                    GROUP BY MOTHER_CODE ) \n");
				query.append("                             ELSE 0 \n");
				query.append("                         END AS QTY \n");
				query.append("                       , MOTHER_CODE \n");
				query.append("                     FROM STX_DIS_SSC_HEAD B \n");
				query.append("                ) T \n");
				query.append("             WHERE A.MOTHER_CODE = T.MOTHER_CODE \n");
				query.append("           ),0)) AS EA \n");
				query.append("         , A.USER_ID \n");
				query.append("         , A.ECO_NO \n");
				query.append("         , TO_CHAR(C.RELEASE_DATE, 'YYYY-MM-DD') AS RELEASE_DATE \n");
				query.append("         , A.STATE_FLAG \n");
				query.append("         , A.ACT_CODE \n");
				query.append("         , A.USC_CHG_FLAG \n");
				query.append("         , (SELECT USER_NAME FROM STX_COM_INSA_USER@"+ERP_DB+" WHERE EMP_NO = A.USER_ID) AS USER_NAME \n");
				query.append("         , TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') AS CREATE_DATE \n");
				query.append("         , TO_CHAR(A.SSC_BOM_DATE, 'YYYY-MM-DD') AS SSC_BOM_DATE \n");
				query.append("         , (SELECT PA.DWGTITLE \n");
				query.append("              FROM DPM_ACTIVITY@"+DP_DB+" PA \n");
				query.append("             WHERE PA.CASENO = '1' \n");
				query.append("               AND PA.ACTIVITYCODE LIKE A.DWG_NO || '%' \n");
				query.append("               AND PROJECTNO = (SELECT SBS.DELEGATE_PROJECT_NO FROM STX_DIS_BOM_SCHEDULE_V SBS WHERE A.PROJECT_NO = SBS.PROJECT_NO) \n");
				query.append("               AND ROWNUM = 1 ) AS ITEM_DESC \n");
				query.append("         , (SELECT DDW.DWGDEPTNM \n");
				query.append("              FROM DCC_DWGDEPTCODE@"+DP_DB+" DDW  \n");
				query.append("             WHERE DDW.DWGDEPTCODE = A.DEPT_CODE \n");
				query.append("            ) AS DEPT_NAME \n");
				query.append("    FROM ( \n");
				query.append("              SELECT STP.* \n");
				query.append("                   , (SELECT SBS.DELEGATE_PROJECT_NO FROM STX_DIS_BOM_SCHEDULE_V SBS WHERE STP.PROJECT_NO = SBS.PROJECT_NO ) AS MASTER_NO \n");
				query.append("                FROM STX_DIS_PENDING STP \n");
				
				query.append("             WHERE 1=1 \n");
				//User ???????? ?????? ?μ? ??u ???. 
				if(!p_selUser.equals("") && !p_selUser.equals("ALL") ){
					query.append("             AND USER_ID = '"+p_selUser+"' \n");
				}
				//?μ? ?????.
				if(!p_deptcode.equals("") && !p_deptcode.equals("ALL") ){
					query.append("             AND DEPT_CODE = '"+p_deptcode+"' \n");
				}
				
				//ORDER by 
				query.append("              ORDER BY STP.PROJECT_NO, STP.DWG_NO, STP.BLOCK_NO, STP.STAGE_NO, STP.STR_FLAG \n");
				query.append("    ) A \n");
				query.append("    LEFT JOIN STX_DIS_ECO_V C ON A.ECO_NO = C.ECO_NO \n");
				query.append(") ZZ \n");
				query.append(" WHERE 1=1 \n");
				query.append(" AND (USC_CHG_FLAG IS NULL OR EA <> 0) \n"); //???? ??? ?? ??? ??? ea?? 0??? ??? ???? ??´?.
				if(p_ship.equals("master")){
					if(!p_project.equals("")){
						p_project = p_project.replaceAll("[*]","%");
						query.append("AND MASTER_NO LIKE '"+p_project+"' \n");
					}	
				}else{
					if(!p_project.equals("")){
						p_project = p_project.replaceAll("[*]","%");
						query.append("AND PROJECT_NO LIKE '"+p_project+"' \n");
					}
				}

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
				
				if(!p_iseco.equals("")){
					if(p_iseco.equals("Y")){
						query.append("AND ECO_NO IS NOT NULL \n");
					}else{
						query.append("AND ECO_NO IS NULL \n");
					}
				}
				if(!p_isrelease.equals("")){
					
					if(p_isrelease.equals("Y")){
						query.append("AND RELEASE_DATE IS NOT NULL \n");
					}else{
						query.append("AND RELEASE_DATE IS NULL \n");
					}
				}
				
				if(!p_isact.equals("")){
					if(p_isact.equals("Y")){
						query.append("AND ACT_CODE IS NOT NULL \n");
					}else{
						query.append("AND ACT_CODE IS NULL \n");
					}
				}
				
				if(!p_work.equals("")){
					if(p_work.equals("N")){
						query.append("AND EA = 0 \n");
					}else if(p_work.equals("Y")){
						query.append("AND EA <> 0 \n");
					}else{
						
					}
				}

				if(!p_isChgUpp.equals("")){
					if(p_isChgUpp.equals("Y")){
						query.append("AND USC_CHG_FLAG = 'Y' \n");
					}else{
						query.append("AND USC_CHG_FLAG IS NULL \n");
					}
				}
				
				
				if(!p_state.equals("")){
					query.append("AND STATE_FLAG = '"+p_state+"' \n");
				}
				
				//Excel ?????? ??? ???. - Paging ??? ???
				if(!p_isexcel.equals("Y")){
					query.append(") XX WHERE ROWNUM <= "+EndNum+" \n");
					query.append(") WHERE RNUM > "+StartNum+" \n");
				}
				
				
//				System.out.println(query);
				
			}else if(qryExp.equals("PendingManagerUpdateMail")){
				query.append("UPDATE STX_DIS_PENDING \n");
				query.append("   SET MAIL_FLAG = ? \n");
				query.append("WHERE JOB_CD || MOTHER_CODE = ? \n");
				
			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
}