package com.stx.tbc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.tbc.dao.factory.Idao;

public class TbcDwgInformationDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null; 
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
        try 
        { 
        	if(qryExp.equals("list")){
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
				boolean result = false;
				 char[] charArray=box.getString("dwg_rev").toCharArray();
				  for (int j=0; j<charArray.length; j++) {

				   if (charArray[j] >= 'A' && charArray[j] <= 'Z' || charArray[j] >= 'a' && charArray[j] <= 'z'){
				    	result = true;
				   }
				  }
				query.append("select t12.* \n");
				query.append("from (   \n");
				query.append("select t11.*  \n");
				query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page \n");
				query.append("from \n");
				query.append("(  \n");
				query.append("select t1.dwg_rev as rev \n");
				query.append("       ,t1.shp_no \n");
				query.append("       ,t1.dwg_no \n");
				query.append("       ,t3.description as text_des \n");
				query.append("       ,t1.dwg_sq \n");
				query.append("       ,t1.dwg_rev \n");
				query.append("       ,t1.pri_set \n");
				query.append("       ,t1.trans_plm \n");
				query.append("       ,t2.user_name \n");
				query.append("       ,t1.emp_no \n");
				query.append("       ,t2.dept_name \n");
				query.append("       ,to_char(t1.inp_date,'yyyy-mm-dd hh24:mi') as inp_date \n");
				query.append("       ,t1.file_name \n");
				query.append("       ,t1.pcs_no \n");
				query.append("       ,t1.form_type \n");
				query.append("       ,t1.form_name \n");
				query.append("       ,t1.paint_code \n");
				query.append("       ,t1.dwg_seq_id \n");
				query.append(" from stx_dwg_dw302tbl        t1 \n");
				query.append("		,stx_com_insa_user        t2	\n");
				query.append("		,stx_dwg_category_masters t3  	\n");
				query.append("where t3.dwg_no_concat   = substr(t1.dwg_no,1,5)  \n");
				query.append("  and t1.emp_no       = t2.emp_no(+)  \n");
				/*query.append("	and t2.dept_code in (				\n");
				query.append("							select distinct dept_code	\n");
				query.append("							  from stx_dwg_mail_confirm_user_v	\n");
				query.append("							 where 1=1	\n");
				//if(box.getSession("GrCode").equals("M1")){
					query.append("	)									\n");*/
				//}
				//else{
				//	query.append("     					   and dwgdeptcode = '"+box.getString("dept")+"') \n");
				//}
				query.append("  and t1.shp_no = '"+box.getString("h_ShipNo")+"' \n");
				query.append("  and t1.dwg_no = '"+box.getString("h_DwgNo")+"' \n");
				query.append("  and t1.dwg_rev <= '"+box.getString("dwg_rev")+"' 												\n");
				if(result==true){
				query.append("	and t1.dwg_rev >= '0A' 																			\n");
				}
				query.append("	and 1 = (case when t1.dwg_rev < '"+box.getString("dwg_rev")+"' and t1.trans_plm = 'Y' then 1 	\n");
				query.append("				  when t1.dwg_rev = '"+box.getString("dwg_rev")+"' 						  then 1	\n");
				query.append("				  else 2 																			\n");
				query.append("			 end) 																					\n");
				if(box.getString("h_returnChk").equals("Y")){
					query.append("	and t1.dwg_rev = (case when t1.dwg_rev = '"+box.getString("dwg_rev")+"' and (t1.trans_plm !='R' or t1.trans_plm is null) then null \n");
					query.append("																								 else t1.dwg_rev 	\n");
					query.append("	end)																					\n");
				}
				if(box.getString("h_state").equals("Request")){
					query.append("  and 1 = (case when t1.dwg_rev = '"+box.getString("dwg_rev")+"' and t1.trans_plm  = 'S' then 1 \n");
					query.append(" 				  when t1.dwg_rev < '"+box.getString("dwg_rev")+"'					     then 1 \n");
					query.append(" 				  else 2 											  \n");
					query.append(" 			end) 													  \n");
				}
				else if(box.getString("h_state").equals("Release")){
					query.append("  and 1 = (case when t1.dwg_rev = '"+box.getString("dwg_rev")+"' and t1.trans_plm  = 'Y' then 1 \n");
					query.append(" 				  when t1.dwg_rev < '"+box.getString("dwg_rev")+"'					     then 1 \n");
					query.append(" 				  else 2 											  \n");
					query.append(" 			end) 													  \n");
				}
				query.append("order by  t1.dwg_no, t1.dwg_sq, t1.dwg_rev  \n");
				query.append(") t11 \n");
				query.append(") t12 \n");
				query.append("where page = "+box.getString("page")+" \n");
			}
			else if(qryExp.equals("selectTotalRecord")){
				boolean result = false;
				 char[] charArray=box.getString("dwg_rev").toCharArray();
				  for (int j=0; j<charArray.length; j++) {

				   if (charArray[j] >= 'A' && charArray[j] <= 'Z' || charArray[j] >= 'a' && charArray[j] <= 'z'){
				    	result = true;
				   }
				  }
				query.append("select count(*) as cnt \n");
				
				query.append(" from stx_dwg_dw302tbl        t1 \n");
				query.append("		,stx_com_insa_user        t2	\n");
				query.append("		,stx_dwg_category_masters t3  	\n");
				query.append("where t3.dwg_no_concat   = substr(t1.dwg_no,1,5)  \n");
				query.append("  and t1.emp_no       = t2.emp_no(+)  \n");
				//query.append("	and t2.dept_code in (				\n");
				//query.append("							select distinct dept_code	\n");
				//query.append("							  from stx_dwg_mail_confirm_user_v	\n");
				//query.append("							 where 1=1	\n");
				//if(box.getSession("GrCode").equals("M1")){
				//	query.append("	)									\n");
				//}
				//else{
				//	query.append("     					   and dwgdeptcode = '"+box.getString("dept")+"') \n");
				//}
				query.append("  and t1.shp_no = '"+box.getString("h_ShipNo")+"' \n");
				query.append("  and t1.dwg_no = '"+box.getString("h_DwgNo")+"' \n");
				query.append("  and t1.dwg_rev <= '"+box.getString("dwg_rev")+"' 												\n");
				if(result==true){
				query.append("	and t1.dwg_rev >= '0A' 																			\n");
				}
				query.append("	and 1 = (case when t1.dwg_rev < '"+box.getString("dwg_rev")+"' and t1.trans_plm = 'Y' then 1 	\n");
				query.append("				  when t1.dwg_rev = '"+box.getString("dwg_rev")+"' 						  then 1	\n");
				query.append("				  else 2 																			\n");
				query.append("			 end) 																					\n");
				if(box.getString("h_returnChk").equals("Y")){
					query.append("	and t1.dwg_rev = (case when t1.dwg_rev = '"+box.getString("dwg_rev")+"' and (t1.trans_plm !='R' or t1.trans_plm is null) then null \n");
					query.append("																								 else t1.dwg_rev 	\n");
					query.append("	end)																					\n");
				}
				if(box.getString("h_state").equals("Request")){
					query.append("  and 1 = (case when t1.dwg_rev = '"+box.getString("dwg_rev")+"' and t1.trans_plm  = 'S' then 1 \n");
					query.append(" 				  when t1.dwg_rev < '"+box.getString("dwg_rev")+"'					     then 1 \n");
					query.append(" 				  else 2 											  \n");
					query.append(" 			end) 													  \n");
				}
				else if(box.getString("h_state").equals("Release")){
					query.append("  and 1 = (case when t1.dwg_rev = '"+box.getString("dwg_rev")+"' and t1.trans_plm  = 'Y' then 1 \n");
					query.append(" 				  when t1.dwg_rev < '"+box.getString("dwg_rev")+"'					     then 1 \n");
					query.append(" 				  else 2 											  \n");
					query.append(" 			end) 													  \n");
				}
				query.append("order by  t1.dwg_no, t1.dwg_sq, t1.dwg_rev  \n");
				
			}
			else if(qryExp.equals("itemList")){
				query.append("select 													\n");
				query.append("			part_no 										\n");
				query.append("  from 													\n");
				query.append("			STX_DWG_DW302TBL_ITEM 							\n");
				query.append(" where 	1=1 											\n");
				query.append("	 and	dwg_seq_id = "+box.getString("dwg_seq_id")+" 	\n");
			}
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	
	
}