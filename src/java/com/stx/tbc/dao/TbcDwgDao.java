package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Map;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcDwgDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("PLM");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
        try 
        { 
        	if(qryExp.equals("deptList")){
        		String cnt=(String) selectTotalRecord(qryExp,rBox);
				rBox.put("listRowCnt", cnt);
        	}
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
        return list;
	}
	
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
		return false;
	}

	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("list")){
				query.append("select distinct 										\n");
				query.append("		 t1.emp_no										\n");
				query.append("		,t1.user_name									\n");
				query.append("		,t1.dept_code									\n");
				query.append("		,t1.dept_name									\n");
				query.append("		,t1.position_code								\n");
				query.append("		,t1.position_name								\n");
				query.append("		,t1.ep_mail										\n");
				query.append("		,case when t1.emp_no = '"+box.getString("userId")+"' then 1			\n");
				query.append("		 	  else 2									\n");
				query.append("		 end as orderflag  								\n");
		     
				query.append("from STX_COM_INSA_USER@"+ERP_DB+" t1 					\n");
				query.append("	   ,stx_dwg_mail_confirm_user_v@"+ERP_DB+" t2 		\n");
				query.append("where 1=1 											\n");
				query.append("  and t1.dept_code = t2.dept_code 					\n");
				query.append("	and t1.del_date is null								\n");
				if(!box.getString("dept").equals("") || box.getString("dept")!=null){
					query.append("and t2.dwgdeptcode = '"+box.getString("dept")+"'  \n");
				}
				query.append(" order by orderflag,t1.user_name						\n");
			}
			else if(qryExp.equals("shipList")){
				String p_code_find = box.getString("p_code_find") == null ? "" : box.getString("p_code_find").toString();
				String p_dept = box.getString("dept") == null ? "" : box.getString("dept").toString();
				String p_ts_dwgdeptcode = box.getSession("ts_dwgdeptcode") == null ? "" : box.getSession("ts_dwgdeptcode").toString();				
				String p_deptGubun = box.getString("p_deptGubun") == null ? "" : box.getString("p_deptGubun").toString();
				// 상선 부서 인원 중 특수선DP에 등록되어 겸업하는 부서(방식기술, 공법) 가 있어 특수선 정보를 같이 가져와야한다.
				String dpsp_dept = p_dept;
				if(!"".equals(p_ts_dwgdeptcode))
				{
					dpsp_dept = p_ts_dwgdeptcode;
				}	
				
				query.append("SELECT DISTINCT  A.PROJECTNO 											\n");
				query.append("FROM DPM_ACTIVITY@"+DP_DB+" A 										\n");
				query.append("INNER JOIN DCC_DEPTCODE@"+DP_DB+" B ON B.DWGDEPTCODE = A.DWGDEPTCODE 	\n");
				query.append("WHERE  1=1 			                	\n");
				if(!box.getSession("DpGubun").equals("Y") && box.getSession("GrCode").equals("M1")){					
				}
				else{
					query.append("AND  B.dwgdeptcode = '"+p_dept+"' 			                	\n");
				}
				query.append("AND A.WORKTYPE = 'DW' 												\n");
				query.append("AND A.CASENO = '1' 													\n");
				query.append("AND 'S' = '"+p_deptGubun+"'	\n");
				if(!p_code_find.equals("")){
				query.append("AND A.PROJECTNO LIKE  '"+box.getString("p_code_find")+"%' 			\n");
				}
				query.append("UNION ALL												                \n");
				
				query.append("SELECT DISTINCT  A.PROJECTNO 											\n");
				query.append("FROM DPM_ACTIVITY@"+DPSP_DB+" A 										\n");
				query.append("INNER JOIN DCC_DEPTCODE@"+DPSP_DB+" B ON B.DWGDEPTCODE = A.DWGDEPTCODE 	\n");	
				query.append("WHERE  1=1 			                	\n");
				if(box.getSession("DpGubun").equals("Y") && box.getSession("GrCode").equals("M1")){
				}
				else{
					query.append("AND  B.dwgdeptcode = '"+dpsp_dept+"' 				            \n");
				}
				query.append("AND A.WORKTYPE = 'DW' 												\n");
				query.append("AND A.CASENO = '1' 													\n");
				query.append("AND 'N' = '"+p_deptGubun+"'	\n");
				if(!p_code_find.equals("")){
				query.append("AND A.PROJECTNO LIKE  '"+box.getString("p_code_find")+"%' 			\n");
				}				
				query.append("ORDER BY PROJECTNO 													\n");				
			}
			else if(qryExp.equals("grantorList")){
				query.append("select *  										\n");
				query.append("  from stx_dwg_mail_confirm_user_v@"+ERP_DB+" 	\n");
				query.append(" where 1=1 										\n");
				query.append("   and dwgdeptcode = '"+box.getString("dept")+"' 	\n");
				query.append(" order by emp_no									\n");
			}
			else if(qryExp.equals("dpDwgList")){
				String p_dwg_no = box.getString("p_dwg_no") == null ? "" : box.getString("p_dwg_no").toString();
				String p_block_no = box.getString("p_block_no") == null ? "" : box.getString("p_block_no").toString();
				
				String p_dept = box.getString("dept") == null ? "" : box.getString("dept").toString();
				String p_ts_dwgdeptcode = box.getSession("ts_dwgdeptcode") == null ? "" : box.getSession("ts_dwgdeptcode").toString();
				String p_deptGubun = box.getString("p_deptGubun") == null ? "" : box.getString("p_deptGubun").toString();
				
				// 상선 부서 인원 중 특수선DP에 등록되어 겸업하는 부서(방식기술, 공법) 가 있어 특수선 정보를 같이 가져와야한다.
				String dpsp_dept = p_dept;
				if(!"".equals(p_ts_dwgdeptcode))
				{
					dpsp_dept = p_ts_dwgdeptcode;
				}				
				
				query.append("SELECT DISTINCT  SUBSTR(A.ACTIVITYCODE, 0, 8) AS OBJECT \n");
				query.append("FROM DPM_ACTIVITY@"+DP_DB+" A 										\n");
				query.append("INNER JOIN DCC_DEPTCODE@"+DP_DB+" B ON B.DWGDEPTCODE = A.DWGDEPTCODE 	\n");
				query.append("WHERE  1=1 			                	\n");
				if(!box.getSession("DpGubun").equals("Y") && box.getSession("GrCode").equals("M1")){
				}
				else{
					query.append("AND  B.dwgdeptcode = '"+p_dept+"' 			                	\n");
				}
				query.append("AND A.WORKTYPE = 'DW'  \n");
				query.append("AND A.CASENO = '1'  \n");
				query.append("AND 'S' = '"+p_deptGubun+"'	\n");
				query.append("AND A.PROJECTNO LIKE '"+box.getString("shipNo")+"%' \n");
				if(!p_dwg_no.equals("")){
				query.append("AND SUBSTR(A.ACTIVITYCODE, 0, 5) LIKE '"+box.getString("p_dwg_no")+"%' \n");
				}
				if(!p_block_no.equals("")){
				query.append("AND SUBSTR(A.ACTIVITYCODE, 6, 8) LIKE '"+box.getString("p_block_no")+"%' \n");
				}				
				query.append("UNION ALL												                \n");				
				query.append("SELECT DISTINCT  SUBSTR(A.ACTIVITYCODE, 0, 8) AS OBJECT				\n");
				query.append("FROM DPM_ACTIVITY@"+DPSP_DB+" A 										\n");
				query.append("INNER JOIN DCC_DEPTCODE@"+DPSP_DB+" B ON B.DWGDEPTCODE = A.DWGDEPTCODE 	\n");		
				query.append("WHERE  1=1 			                	\n");
				if(box.getSession("DpGubun").equals("Y") && box.getSession("GrCode").equals("M1")){
				}
				else{
					query.append("AND  B.dwgdeptcode = '"+dpsp_dept+"' 				            \n");
				}
				query.append("AND A.WORKTYPE = 'DW' 												\n");
				query.append("AND A.CASENO = '1' 													\n");
				query.append("AND 'N' = '"+p_deptGubun+"'	\n");
				query.append("AND A.PROJECTNO LIKE '"+box.getString("shipNo")+"%' \n");
				if(!p_dwg_no.equals("")){
				query.append("AND SUBSTR(A.ACTIVITYCODE, 0, 5) LIKE '"+box.getString("p_dwg_no")+"%' \n");
				}
				if(!p_block_no.equals("")){
				query.append("AND SUBSTR(A.ACTIVITYCODE, 6, 8) LIKE '"+box.getString("p_block_no")+"%' \n");
				}
				query.append("ORDER BY OBJECT            \n");				
			}
			else if(qryExp.equals("selectTotalRecord")){
				String p_deptName = box.getString("p_deptName") == null ? "" : box.getString("p_deptName").toString();
				query.append("select count(*) as cnt 	\n");
				query.append("  from stx_com_insa_dept \n");
				query.append(" where dept_name like '%"+box.getString("p_deptName")+"%' \n");
				query.append("	 and use_yn = 'Y' \n");
				//query.append("	 and part_code is not null");
				query.append("	 and cost_code is not null \n");
				query.append("	 and team_code is not null \n");
				query.append("	 and attribute2 in ('팀','파트/현장') \n");
				query.append("	 and attribute3 is not null \n");
				query.append("ORDER BY DEPT_CODE \n");
			}
			else if(qryExp.equals("deptList")){
				String p_deptName = box.getString("p_deptName") == null ? "" : box.getString("p_deptName").toString();
				query.append("select t13.* \n");
				query.append("from (  \n");
				query.append("select t12.* \n");
				query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page \n");
				query.append("from \n");
				query.append("( \n");
				query.append("select dept_code 	\n");
				query.append("		,dept_name  \n");
				query.append("  from stx_com_insa_dept@"+ERP_DB+" \n");
				query.append(" where dept_name like '%"+box.getString("p_deptName")+"%' \n");
				query.append("	 and use_yn = 'Y' \n");
				//query.append("	 and part_code is not null");
				query.append("	 and cost_code is not null \n");
				query.append("	 and team_code is not null \n");
				query.append("	 and attribute2 in ('팀','파트/현장') \n");
				query.append("	 and attribute3 is not null \n");
				query.append(") t12 \n");
				query.append(") t13 \n");
				query.append("where page = "+box.getString("page")+" \n");
				query.append("ORDER BY DEPT_CODE \n");
			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
}