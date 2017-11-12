package com.stx.common.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
public class SessionUtil implements TBCCommonDataBaseInterface
{
	public static void setUserSession(RequestBox box) throws Exception { 
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		
        ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query 		= new StringBuffer();
    	
    	String ss_user = "";
    	
    	//ss_user = SessionUtils.getUserId();
    	ss_user = box.getString("DidSsUserId");
    	
    	//세션 삭제;
    	box.sessionClear("UserId");
    	box.sessionClear("UserName");
    	box.sessionClear("UserEngName");
    	box.sessionClear("InsaDeptCode");
    	box.sessionClear("InsaDeptName");
    	box.sessionClear("DeptName");
    	box.sessionClear("DeptCode");
    	box.sessionClear("GrCode");
    	box.sessionClear("DpGubun");
    	box.sessionClear("ts_dwgdeptcode");
    	
        try 
        {	
        	query.append("SELECT A.EMP_NO \n");
        	query.append("     , A.USER_NAME \n");
        	query.append("     , A.USER_ENG_NAME \n");
//        	query.append("     , CASE WHEN B.DEPTNM IS NOT NULL THEN SUBSTR(B.DEPTNM, INSTR( B.DEPTNM,'-')+1) \n");
//        	query.append("            ELSE C.DWGDEPTNM  \n");
//        	query.append("       END AS DWGDEPTNM \n");
        	query.append("     , C.DWGDEPTNM \n");
        	query.append("     , A.DEPT_CODE  \n");
        	query.append("     , A.DEPT_NAME  \n");
        	query.append("     , B.DWGDEPTCODE \n");
        	query.append("     , CASE WHEN B.DEPTCODE LIKE '440%' OR B.DEPTCODE LIKE '202000' THEN 'M1'\n");
        	query.append("            ELSE 'U1' \n");
        	query.append("       END AS GRCODE \n");
        	query.append("     , 'N' AS DP_GUBUN \n");
        	query.append("     , (SELECT BB.DWGDEPTCODE \n");
        	query.append("          FROM STX_COM_INSA_USER@"+ERP_DB+" AA \n");
        	query.append("              ,DCC_DEPTCODE@"+DPSP_DB+"     BB \n");
        	query.append("              ,DCC_DWGDEPTCODE@"+DPSP_DB+"  CC \n");
        	query.append("         WHERE AA.DEPT_CODE = BB.DEPTCODE  \n");
        	query.append("           AND BB.DWGDEPTCODE = CC.DWGDEPTCODE  \n");
        	query.append("           AND AA.EMP_NO = '"+ss_user+"'  \n");
        	query.append("           AND CC.USERYN  = 'Y' \n");
        	query.append("         ) AS TS_DWGDEPTCODE      \n");
        	query.append("  FROM STX_COM_INSA_USER@"+ERP_DB+" A \n");
        	query.append(" LEFT JOIN DCC_DEPTCODE@"+DP_DB+" B ON A.DEPT_CODE = B.DEPTCODE \n");
        	query.append(" LEFT JOIN DCC_DWGDEPTCODE@"+DP_DB+" C ON B.DWGDEPTCODE = C.DWGDEPTCODE \n");
        	query.append(" WHERE A.EMP_NO = '"+ss_user+"' \n");
        	query.append("   AND 'S' =  (select nvl((select 'N' from stx_com_insa_user@"+ERP_DB+"  sciu where sciu.emp_no = '"+ss_user+"'  and sciu.dept_name like '%특수선%' ),'S') from dual )\n");
        	
            	//query.append("   AND C.USERYN = 'Y' \n");
        	query.append("UNION ALL \n"); 
        	query.append("SELECT A.EMP_NO \n");
        	query.append("     , A.USER_NAME \n");
        	query.append("     , A.USER_ENG_NAME \n");
//        	query.append("     , CASE WHEN B.DEPTNM IS NOT NULL THEN SUBSTR(B.DEPTNM, INSTR( B.DEPTNM,'-')+1) \n");
//        	query.append("            ELSE C.DWGDEPTNM  \n");
//        	query.append("       END AS DWGDEPTNM \n");
        	query.append("     , C.DWGDEPTNM \n");
        	query.append("     , A.DEPT_CODE  \n");
        	query.append("     , A.DEPT_NAME  \n");
        	query.append("     , B.DWGDEPTCODE \n");
        	query.append("     , CASE WHEN B.DEPTCODE LIKE '568900' THEN 'M1'\n");
        	query.append("            ELSE 'U1'\n");
        	query.append("       END AS GRCODE\n");
        	query.append("     , 'Y' AS DP_GUBUN \n");
        	query.append("     , ''  AS TS_DWGDEPTCODE \n");
        	query.append("  FROM STX_COM_INSA_USER@"+ERP_DB+" A \n");
        	query.append(" LEFT JOIN DCC_DEPTCODE@"+DPSP_DB+" B ON A.DEPT_CODE = B.DEPTCODE \n");
        	query.append(" LEFT JOIN DCC_DWGDEPTCODE@"+DPSP_DB+" C ON B.DWGDEPTCODE = C.DWGDEPTCODE \n");
        	query.append(" WHERE A.EMP_NO = '"+ss_user+"' \n");
        	//query.append("   AND C.USERYN = 'Y' \n");
        	query.append("   AND C.DWGDEPTNM  LIKE '%특수%' \n"); 
        	query.append("   AND 'N' =  (select nvl((select 'N' from stx_com_insa_user@"+ERP_DB+"  sciu where sciu.emp_no = '"+ss_user+"'  and sciu.dept_name like '%특수선%' ),'S') from dual )\n");
        	
        	
        	
//        	System.out.println(query);
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            if( ls.next() ){ 
                box.setSession("UserId", ls.getString("emp_no"));
                box.setSession("UserName", ls.getString("user_name"));
                box.setSession("UserEngName", ls.getString("user_eng_name"));
                box.setSession("InsaDeptCode", ls.getString("dept_code"));
                box.setSession("InsaDeptName", ls.getString("dept_name"));
                box.setSession("DeptName", ls.getString("dwgdeptnm"));
                box.setSession("DeptCode", ls.getString("dwgdeptcode"));
                box.setSession("GrCode", ls.getString("grcode"));
                box.setSession("DpGubun", ls.getString("dp_gubun"));
                box.setSession("ts_dwgdeptcode", ls.getString("ts_dwgdeptcode"));   //상선 인원 중 특수선 DP에도 등록된 대상
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
}
