package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import javax.mail.Session;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.JsonUtil;
import com.stx.tbc.dao.factory.Idao;

public class TbcDwgCompleteDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		
		Connection conn     = null;
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	
//    	조회 list
    	if(qryExp.equals("list")){
			String cnt=(String) dwgCompleteTotalRecord(rBox);
			rBox.put("listRowCnt", cnt);
    	}
        try 
        { 
            list = new ArrayList();
            query  = getQuery(qryExp,rBox);           
            
            conn = DBConnect.getDBConnection("PLM");
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
	
	public String dwgCompleteTotalRecord(RequestBox rBox) throws Exception {
		Connection conn     = null;
		
		
        ListSet             ls      	= null;
        ArrayList           list    	= null; 
        DataBox             dbox    	= null;
        Map					resultMap	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	String				cnt			= "";
    	ResultSet			rs 			= null;
        try 
        {
            list = new ArrayList();
            query  = getQuery("selectTotalRecord",rBox);           
            
            conn = DBConnect.getDBConnection("PLM");
            
			pstmt = conn.prepareStatement(query.toString());
			//rs		= pstmt.execute();
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){
            	resultList = ls.getDataMap();
            	cnt=resultList.get("cnt").toString();
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
		boolean result = false;

		if(qryExp.equals("return")){ //도면 반려 시 
			result=tbcDwgReturn(qryExp,rBox);
		}else if(qryExp.equals("approve")){	//도면 승인 시 
			result=tbcDwgApprove(qryExp,rBox);
		}
		return result;
	}
	public boolean tbcDwgApprove(String qryExp, RequestBox rBox) throws Exception{
		ArrayList  ar = null;
		int		insertRow	= 0;
		int 	updateRow	= 0;
		int		updatePLM	= 0;
		int		listSize	= 0;
		int		updateTransDetail = 0;
		ArrayList reqMailList = new ArrayList();
		Map	   mapAdd = new HashMap();
		String DESCRIPTION = "";
		String shp_no = "";
		String dwg_no = "";  
		String ep_mail = "";
		String conContent = "";
		String body = "";
		String from = "";
		String to 	= "";
		StringBuffer pro_no = new StringBuffer();
		boolean	result = false;
		
		//승인할 도면 list 가져오기
		java.util.List requiredDWGList = JsonUtil.toList(rBox.get("chmResultList"));
		
		String dwg_url = "http://mfgdoc.stxship.co.kr/dwg/DwgPdfView.asp?DwgFile=";
		ArrayList mailReceiverList = null;
		ArrayList list	= null;
		
		
		Connection conn 	= null;
		Connection connPLM	= null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		connPLM = DBConnect.getDBConnection("PLM");
		conn.setAutoCommit(false);
		connPLM.setAutoCommit(false);
		
		try{
			//요청번호 따기
			Map mailSendSeq = getDwgMailSendSeq(connPLM,rBox);
			String mailSendFrontSeq = mailSendSeq.get("seq").toString();
			String dwgMailSendSeq 	= mailSendFrontSeq;
			
			//승인자 메일 구하기
			Map eMail = select_grantor_epMail(conn,rBox);
			from = eMail.get("ep_mail")+"@onestx.com";
			to = "";
			
			for(int i=0;i<requiredDWGList.size();i++)//	Map<String, Object> rowData : requiredDWGList)
			{
				Map rowData = (Map)requiredDWGList.get(i);
				reqMailList.add(rowData.get("ep_mail")+"@onestx.com");
				rowData.put("dwgMailSendSeq", dwgMailSendSeq);
				
				//mailReceiverList 가져오기
				rowData.put("REV_NO", rowData.get("dwg_rev"));
				rowData.put("DWG_NO", rowData.get("dwg_no"));
				mailReceiverList=selectDWG_RECEIVER_USER(rowData);
				String req_seq = (String)rowData.get("req_seq");
				ep_mail = (String)rowData.get("ep_mail");
				
				//승인시 . STX_DWG_DW302TBL trnas_plm  = Y -> update 를 하기 위한 도면 list 가져오기
				list = selectDwgRequestList(rowData);
				listSize = listSize + list.size();
				for(int j=0;j<list.size();j++)//	
				{
					Map rowData2 = (Map) list.get(j);
					//STX_DWG_DW303TBL_PLM insert할 list 가져오기
					Map mapParam = selectDWG_Approve_302List(rowData2);
					mapParam.put("req_seq", req_seq);
					mapParam.put("dwg_url", dwg_url+mapParam.get("file_name"));
					mapParam.put("dwg_no", (String)mapParam.get("shp_no")+"-"+mapParam.get("dwg_no"));
					//승인시 . STX_DWG_DW303TBL_PLM(key =stx_dis_dwg_trans의 req_seq('YYMMDD0001')  -> insert
					insertRow =insertRow+ insertSTX_DWG_DW303TBL_PLM(conn,mapParam);
					
					//302 update trans_plm = 'Y' 
					updateRow =updateRow+ updateSTX_DWG_DW302TBL(conn,rowData2);
					//trans_detail update dwg_mail_send_seq
					updateTransDetail += updateDwgReturnTransDetail(connPLM,rowData);
				}
				//승인시 . stx_dis_dwg_trans 승인자 ,    - > update
				updatePLM=updatePLM+updateSTX_TBC_DWG_TRANS(connPLM,rowData);
				
				//mail_receiver != Y  && mailReceiverList.size>0 메일날리기 
				/*if(!rowData.get("mail_receiver").equals("Y") && mailReceiverList.size()>0){
					for(int j=0;j<mailReceiverList.size();j++){
						Map map=(Map)mailReceiverList.get(j);
						to = (String) map.get("email");
						stxTbcDwgReceiverMailing(conn,(String)rowData.get("req_seq"),(String)rowData.get("shp_no"),(String)rowData.get("dwg_no"),(String)rowData.get("REV_NO"),from,to);
							
					}
					
				}*/
				
			}//end of for
			
			//중복된 요청자 제거
			reqMailList=removeOverlappedData(reqMailList);
			
			
			
			
			
			
			if((listSize == insertRow) && (listSize  == updateRow) && (requiredDWGList.size() == updatePLM)){
				//승인자에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,"approve",from,from);
				//양동협 대리에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,"approve",from,"donghyupyang@onestx.com");
				//요청자 수만큼 메일
				for(int i=0;i<reqMailList.size();i++){
					to = (String)reqMailList.get(i);
					stxTbcDwgMailing(connPLM,dwgMailSendSeq,"approveReq",from,to);
				}
				
				conn.commit();
				connPLM.commit();
				result= true;
			}else{
				conn.rollback();
				connPLM.rollback();
			}
			
		}catch(Exception e){
			conn.rollback();
			connPLM.rollback();
			System.out.println(e.getMessage());
		}
		
		return result;
	}
	
	public int updateSTX_TBC_DWG_TRANS(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update stx_tbc_dwg_trans \n");
		query.append("set req_state = 'Y' , dwg_mail_send_seq = '"+rowData.get("dwgMailSendSeq")+"' \n");
		query.append(",res_sabun = '"+rowData.get("res_sabun")+"' \n");
		query.append(",res_date  = sysdate \n");
		query.append(",mail_check = 'Y' \n");
		query.append(",erp_trans = 'Y' \n");
		query.append(",last_updated_by = '"+rowData.get("res_sabun")+"' \n");
		query.append(",last_update_date = sysdate \n");
		query.append("where req_seq = '"+rowData.get("req_seq")+"' \n");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	int					result		= 0;
        try 
        { 
            //list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			
			result=+pstmt.executeUpdate();
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
		return result;
	}
	
	public int updateSTX_DWG_DW302TBL(Connection conn,Map rowData2) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update STX_DWG_DW302TBL \n");
		query.append("set trans_plm = 'Y' \n");
		query.append("where 1=1 \n");
		query.append("and dwg_seq_id = "+rowData2.get("req_dwg_seq_id")+" \n");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	int					result		= 0;
        try 
        { 
            //list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			
			result=+pstmt.executeUpdate();
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
		return result;
	}
	
	public int insertSTX_DWG_DW303TBL_PLM(Connection conn,Map mapParam) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("INSERT INTO STX_DWG_DW303TBL_PLM \n");
		query.append("( \n");
		query.append("DOC_GB        \n");
		query.append(",ACTION \n");
		query.append(",PRO_NO \n");
		query.append(",DOC_CATEGORY \n");
		query.append(",ECO_NO \n");
		query.append(",DWG_TYPE \n");
		query.append(",DWG_NO \n");
		query.append(",DWG_RV               \n");
		query.append(",DWG_DSC           \n");
		query.append(",DWG_URL         \n");
		query.append(",ORG_ID \n");
		query.append(",ITM_NO \n");
		query.append(",ITM_RV \n");
		query.append(",SHT_NO \n");
		query.append(",FINISH_IF \n");
		query.append(",PRI_SET \n");
		query.append(",PRN_DT \n");
		query.append(",INP_DT \n");
		query.append(",INP_OWNER \n");
		query.append(",IF_ERP_ST \n");
		query.append(",IF_ERP_DT \n");
		query.append(",IF_LEGACY_ST \n");
		query.append(",IF_LEGACY_DT \n");
		query.append(") \n");
		query.append("VALUES \n");
		query.append("( \n");
		query.append("'C' \n");
		query.append(",'INSERT' \n");
		query.append(",'"+mapParam.get("shp_no")+"' \n");
		query.append(",'' \n");
		query.append(",'"+mapParam.get("req_seq")+"' \n");
		query.append(",5 \n");
		query.append(",'"+mapParam.get("dwg_no")+"' \n");
		query.append(",'"+mapParam.get("dwg_rev")+"' \n");
		query.append(",'"+quoteReplace(mapParam.get("text_des").toString())+"' \n");
		query.append(",'"+mapParam.get("dwg_url")+"' \n");
		query.append(",0 \n");
		query.append(",'-1' \n");
		query.append(",0 \n");
		query.append(",'"+mapParam.get("file_name")+"' \n");
		query.append(",'F' \n");
		query.append(",'"+mapParam.get("pri_set")+"' \n");
		query.append(",sysdate \n");
		query.append(",SYSDATE \n");
		query.append(",'User Agent' \n");
		query.append(",0 \n");
		query.append(",'' \n");
		query.append(",0 \n");
		query.append(",'' \n");
		query.append(") \n");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	int					result		= 0;
        try 
        { 
            //list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			
			result=+pstmt.executeUpdate();
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
		return result;
	}
	public Map selectDWG_Approve_302List(Map rowData2) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("select  \n");
		query.append("DDT.trans_plm \n");
		query.append(",DDT.shp_no \n");
		query.append(",DDT.dwg_no \n");
		query.append(",sdcm.description as text_des \n");
		query.append(",DDT.dwg_sq \n");
		query.append(",DDT.dwg_rev \n");
		query.append(",DDT.pri_set \n");
		query.append(",DDT.trans_plm \n");
		query.append(",CIU.user_name \n");
		query.append(",DDT.emp_no \n");
		query.append(",CIU.dept_name \n");
		query.append(",to_char(DDT.inp_date,'YYYY-MM-DD HH24:mm') as inp_date \n");
		query.append(",DDT.file_name \n");
		query.append(",DDT.pcs_no \n");
		query.append(",DDT.form_type \n");
		query.append(",DDT.form_name \n");
		query.append(",DDT.paint_code \n");
		query.append(",DDT.dwg_seq_id \n");
		query.append("from \n");
		query.append("STX_DWG_DW302TBL   DDT \n");
		query.append(",STX_COM_INSA_USER  CIU \n");
		query.append(",stx_dwg_category_masters sdcm \n");
		query.append("where  1=1 \n");
		query.append("and  DDT.emp_no = CIU.emp_no(+) \n");
		query.append("and  substr(ddt.dwg_no,1,5) = sdcm.dwg_no_concat  \n");
		query.append("and  DDT.dwg_seq_id = "+rowData2.get("req_dwg_seq_id")+" \n");
		query.append("order by  DDT.dwg_no, DDT.dwg_sq, DDT.dwg_rev \n");
		
		Connection conn     = null;
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	
        try 
        { 
            //list = new ArrayList();
            
            conn = DBConnect.getDBConnection("ERP");
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){ 
            	resultList = ls.getDataMap();
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
		
		return	resultList;
	}
	
	public ArrayList selectDWG_RECEIVER_USER(Map rowData) throws Exception{
		String DWG_PROJECT_NO = rowData.get("DWG_PROJECT_NO") == null ? "" : rowData.get("DWG_PROJECT_NO").toString();
		String shp_no	= rowData.get("shp_no") == null	? "" : rowData.get("shp_no").toString();
		String shipNo	= rowData.get("shipNo") == null	? "" : rowData.get("shipNo").toString();
		
		StringBuffer query = new StringBuffer();
		query.append("SELECT MASTER_PROJECT_NO DWG_PROJECT_NO \n");
		query.append(",PROJECT_NO PROJECT_NO \n");
		query.append(",SDERU.RECEIVER_EMPNO PRINT_USER_ID \n");
		query.append(",SDERU.RECEIVER_NAME PRINT_USER_NAME \n");
		query.append(",SDERU.RECEIVER_DEPT PRINT_DEPT_ID \n");
		query.append(",SDD.DEPT_NAME PRINT_DEPT_NAME \n");
		query.append(",'' PRINT_DATE \n");
		query.append(",EMAIL_ADRESS EMAIL \n");
		query.append(",RECEIVER_TYPE USER_TYPE \n");
		query.append(",'TRUE' CHECKED \n");
		query.append(",(SELECT SDERD.MAIL_SEND_FLAG \n");
		query.append("FROM STX_DWG_ECO_REBUILD_MAIL_HE SDERH \n");
		query.append(",STX_DWG_ECO_REBUILD_MAIL_DE SDERD \n");
		query.append("WHERE SDERH.HEAD_ID = SDERD.HEAD_ID \n");
		query.append("AND SDERH.ECO_NO = SDER.ECO_NO \n");
		query.append("AND SDERD.EMAIL_ADDRESS = sderu.email_adress \n");
		query.append("AND SDERH.PROJECT_NO = SDERU.PROJECT_NO \n");
		query.append("and rownum = 1) MAIL_SEND_FLAG \n");
		query.append(",to_char((SELECT SDERD.Last_Update_Date \n");
		query.append("FROM STX_DWG_ECO_REBUILD_MAIL_HE SDERH \n");
		query.append(",STX_DWG_ECO_REBUILD_MAIL_DE SDERD \n");
		query.append("WHERE SDERH.HEAD_ID = SDERD.HEAD_ID \n");
		query.append("AND SDERH.ECO_NO = SDER.ECO_NO \n");
		query.append("AND SDERD.EMAIL_ADDRESS = sderu.email_adress \n");
		query.append("AND SDERH.PROJECT_NO = SDERU.PROJECT_NO \n");
		query.append("and rownum = 1),'YYYY-MM-DD HH24:mm') MAIL_SEND_DATE \n");
		query.append("FROM STX_DWG_ECO_RECEIVER_USER SDERU \n");
		query.append(",STX_DWG_ECO_RECEIVER      SDER \n");
		query.append(",STX_DWG_DEPT_MANAGER      SDD \n");
		query.append("WHERE SDERU.RECEIVER_ID = SDER.RECEIVER_ID \n");
		if( !DWG_PROJECT_NO.equals("") ){
			query.append("AND SDER.MASTER_PROJECT_NO = '"+rowData.get("DWG_PROJECT_NO")+"' \n");
		}
		if( !shp_no.equals("") ){
			query.append("AND SDER.MASTER_PROJECT_NO = '"+rowData.get("shp_no")+"' \n");
		}
		query.append("AND SDER.DWG_NO = '"+rowData.get("DWG_NO")+"' \n");
		query.append("AND SDER.REV_NO = '"+rowData.get("REV_NO")+"' \n");
		query.append("AND SDD.DEPT_ID = SDERU.RECEIVER_DEPT \n");
		if( !shipNo.equals("") ){
			query.append("AND SDERU.PROJECT_NO = '"+rowData.get("shipNo")+"' \n");
		}
		
		
		Connection conn     = null;
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	
        try 
        { 
            list = new ArrayList();
            
            conn = DBConnect.getDBConnection("ERP");
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
	
	public boolean tbcDwgReturn(String qryExp, RequestBox rBox) throws Exception{
		ArrayList  ar 		= null;
		boolean result 		= false;
		String ep_mail		= "";
		String DESCRIPTION 	= "";
		StringBuffer pro_no = new StringBuffer();
		int		updateERP 	= 0;
		int		updatePLM 	= 0;
		int		listSize	= 0;
		int 	updateTransDetail = 0;
	
		ArrayList list		= null;
		ArrayList dwgList 	= null;
		ArrayList reqMailList = new ArrayList();
		Connection conn 	= null;
		Connection connPLM	= null;
		conn = DBConnect.getDBConnection("ERP");
		connPLM = DBConnect.getDBConnection("PLM");
		conn.setAutoCommit(false);
		connPLM.setAutoCommit(false);
		
		
		//반려할 도면 list 가져오기
		java.util.List requiredDWGList = JsonUtil.toList(rBox.get("chmResultList"));
		try{
			
			//액션 번호 가져오기
			Map mailSendSeq = getDwgMailSendSeq(connPLM,rBox);
			String mailSendFrontSeq = mailSendSeq.get("seq").toString();
			String dwgMailSendSeq 	= mailSendFrontSeq;
			
			
			for(int i=0;i<requiredDWGList.size();i++) 
			{
				dwgList		= new ArrayList();
				Map rowData = (Map) requiredDWGList.get(i);
				reqMailList.add(rowData.get("ep_mail")+"@onestx.com");
				rowData.put("dwgMailSendSeq", dwgMailSendSeq);
				list = selectDwgRequestList(rowData);
				for(int k=0;k<list.size();k++){
					Map trans_detail =(Map) list.get(k);
					Map DwgDetail =getDwgInfo(trans_detail);
					dwgList.add(DwgDetail);
				}
				listSize =listSize+ list.size();
				for(int j=0;j<dwgList.size();j++){	
					Map rowData2 = (Map) dwgList.get(j);
					ep_mail = (String)rowData.get("ep_mail");
					pro_no.append(rowData.get("shp_no")+"-"+rowData.get("dwg_no")+",");
					//반려시 . STX_DWG_DW302TBL trnas_plm  = R -> update
					updateERP =updateERP+ updateDwgReturn(conn,rowData2);
					//반려시 . STX_TBC_DWG_TRANS_DETAIL DWG_MAIL_SEND_SEQ = dwgMailSendSeq UPDATE
					updateTransDetail += updateDwgReturnTransDetail(connPLM,rowData);
				}
				//반려시 . stx_dis_dwg_trans  req_state = R    - > update
				updatePLM =updatePLM+ updateDwgReturnTrans(connPLM,rowData);
				
				//지정된 메일 리시버에 eco_no 제거
				updateEcoReceiverNull(conn,rowData);
			}
			//중복된 요청자 제거
			reqMailList=removeOverlappedData(reqMailList);
			//승인자 메일 구하기
			Map eMail = select_grantor_epMail(conn,rBox);
			String from = eMail.get("ep_mail")+"@onestx.com";
			//from = "ehdgurl223@onestx.com";
			String to = "";
			

			
			
			if((requiredDWGList.size()==updatePLM) && (listSize==updateERP)){
				//반려자에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,"return",from,from);
				//양동협 대리에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,"return",from,"donghyupyang@onestx.com");
				
				//요청자 수만큼 메일
				for(int i=0;i<reqMailList.size();i++){
					to = (String)reqMailList.get(i);
					stxTbcDwgMailing(connPLM,dwgMailSendSeq,"returnReq",from,to);
				}
				
				conn.commit();
				connPLM.commit();
				
				
				result = true;
			}else{
				conn.rollback();
				connPLM.rollback();
			}
			
		}
		catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
       
		return result;
	}
	
	//중복 문자열 제거
	private ArrayList removeOverlappedData(ArrayList list) {
		return new ArrayList(new HashSet(list)); 
	} 

	
public Map select_grantor_epMail(Connection conn,RequestBox rBox) throws Exception{
		
		StringBuffer query = new StringBuffer();
		query.append("select  \n");
		query.append("ep_mail \n");
		query.append("from  \n");
		query.append("STX_COM_INSA_USER \n");
		query.append("where 1=1 \n");
		query.append("and     emp_no = '"+rBox.get("p_userId")+"' \n");


		
		ListSet             ls      	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
		try 
        { 
			pstmt = conn.prepareStatement(query.toString());
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){ 
            	resultList = ls.getDataMap();
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
	
//	시퀀스 따기(YYMMDD9SEQ(1406109001))
	public Map getDwgMailSendSeq(Connection conn,RequestBox rBox) throws Exception{
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	Map					resultList	= null;
    	  try 
          {
    		  
              query  = getQuery("getDwgMailSendSeq",rBox);           
              pstmt = conn.prepareStatement(query.toString());
				
	          ls = new ListSet(conn);
			  ls.run(pstmt);
			  
	          while ( ls.next() ){
	        	  	resultList = ls.getDataMap();
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
	
	public void stxTbcDwgReceiverMailing(Connection conn,String dwgMailSendSeq,String shipNo,String dwgNo,String revNo,String from,String to) throws Exception{
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		cs1 = conn.prepareCall("{call  STX_TBC_DWG_RECEIVER_MAILING@"+PLM_DB+" (?, ?, ?, ?, ?, ?,?,?)}");
		
		cs1.setString(i++, dwgMailSendSeq);
		cs1.setString(i++, shipNo);
		cs1.setString(i++, dwgNo);
		cs1.setString(i++, revNo);
		cs1.setString(i++, from);
		cs1.setString(i++, to);
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.INTEGER);
		
		cs1.execute();
	}
	
	public void stxTbcDwgMailing(Connection conn,String dwgMailSendSeq,String condition,String from,String to) throws Exception{
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		cs1 = conn.prepareCall("{call  STX_TBC_DWG_MAILING (?, ?, ?, ?, ?, ?)}");
		
		cs1.setString(i++, dwgMailSendSeq);
		cs1.setString(i++, condition);
		cs1.setString(i++, from);
		cs1.setString(i++, to);
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.INTEGER);
		
		cs1.execute();
	}
	public int updateEcoReceiverNull(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update stx_dwg_eco_receiver	 							\n");
		query.append("set eco_no 				= '' 							\n");
		query.append("where master_project_no 	= '"+rowData.get("shp_no")+"' 	\n");
		query.append("  and dwg_no 				= '"+rowData.get("dwg_no")+"' 	\n");
		query.append("  and rev_no 				= '"+rowData.get("dwg_rev")+"' 	\n");
		
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
        int					result		= 0;
        try 
        {
            list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			result =+ pstmt.executeUpdate();
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
		
		return result;
	}
	
	
	public int updateDwgReturnTransDetail(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update stx_tbc_dwg_trans_detail \n");
		query.append("set dwg_mail_send_seq = '"+rowData.get("dwgMailSendSeq")+"' \n");
		query.append("where req_seq = '"+rowData.get("req_seq")+"' \n");

        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
        int					result		= 0;
        try 
        {
            list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			result =+ pstmt.executeUpdate();
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
		
		return result;
	}
	
	public int updateDwgReturnTrans(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update stx_tbc_dwg_trans \n");
		query.append("set req_state = 'R' , dwg_mail_send_seq = '"+rowData.get("dwgMailSendSeq")+"' \n");
		query.append(",res_sabun = '"+rowData.get("res_sabun")+"' \n");
		query.append(",res_date  = sysdate \n");
		query.append(",mail_check = 'N' \n");
		query.append(",erp_trans = 'N' \n");
		query.append(",last_updated_by = '"+rowData.get("res_sabun")+"' \n");
		query.append(",last_update_date = sysdate \n");
		query.append("where req_seq = '"+rowData.get("req_seq")+"' \n");

        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
        int					result		= 0;
        try 
        {
            list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			result =+ pstmt.executeUpdate();
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
		
		return result;
	}
	public int updateDwgReturn(Connection conn,Map rowData2) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update STX_DWG_DW302TBL \n");
		query.append("set trans_plm = 'R' \n");
		query.append("where 1=1 \n");
		query.append("and dwg_seq_id = "+rowData2.get("dwg_seq_id")+" \n");
		
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
        int					result		= 0;
        try 
        {
            list = new ArrayList();
            
			pstmt = conn.prepareStatement(query.toString());
			result = pstmt.executeUpdate();
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
        return result;

	}
	public Map getDwgInfo(Map trans_detail) throws Exception{
		String dwg_seq_id = "";
		Map		map 	  = null;
		Connection conn     = null;
        ListSet             ls      	= null;
        ArrayList           result    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
        StringBuffer query				= null;
		
        	try 
        	{
				query = new StringBuffer();
				query.append("select t1.*,t2.description \n");
				query.append("    from STX_DWG_DW302TBL                 t1 \n");
				query.append("         ,stx_dwg_category_masters        t2 \n");
				query.append("   where 1=1 \n");
				query.append("     and substr(t1.dwg_no,1,5) = t2.dwg_no_concat \n");
				query.append("     and dwg_seq_id = "+trans_detail.get("req_dwg_seq_id")+" \n");
					
	         
	        	result = new ArrayList();
	            
	            conn = DBConnect.getDBConnection("ERP");
				pstmt = conn.prepareStatement(query.toString());
				
	            ls = new ListSet(conn);
			    ls.run(pstmt);
			    
	            while ( ls.next() ){ 
	            	resultList = ls.getDataMap();
	            	result.add(resultList);
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
	public ArrayList selectDwgRequestList(Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("select *  \n");
		query.append("from stx_tbc_dwg_trans_detail  \n");
		query.append("where req_seq = '"+rowData.get("req_seq")+"' \n");
		
		Connection conn     = null;
        ListSet             ls      	= null;
        ArrayList           list    	= null;
        DataBox             dbox    	= null;
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	
        try 
        { 
            list = new ArrayList();
            
            conn = DBConnect.getDBConnection("PLM");
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

	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	private String getQuery(String qryExp, RequestBox box){
		String fromDate = box.getString("fromDate") == null ? "" : box.getString("fromDate").toString();
		String toDate	= box.getString("ToDate") == null	? "" : box.getString("ToDate").toString();
		String shipNo	= box.getString("shipNo") == null	? "" : box.getString("shipNo").toString();
		String dwgNo	= box.getString("dwgNo") == null	? "" : box.getString("dwgNo").toString();
		String blockNo	= box.getString("blockNo") == null	? "" : box.getString("blockNo").toString();
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("list")){
				if(box.getString("permissionFlag").equals("Y"))
				{
					query.append("select t2.* 																					\n");
					query.append("from (   																						\n");
					query.append("select t1.*  																					\n");
					query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page 								\n");
					query.append("from 																							\n");
					query.append("(  																							\n");
					query.append("select      																					\n");
					query.append("		distinct  																				\n");
					query.append("      case when t1.req_state='Y' then 'Release'  												\n");
					query.append("           when t1.req_state='S' then 'Request'  												\n");
					query.append("           when t1.req_state='R' then 'Return'  												\n");
					query.append("           else 'Preliminary'  																\n");
					query.append("       end as trans_plm  																		\n");
					query.append("      ,t3.shp_no as shp_no  																	\n");
					query.append("      ,t3.dwg_no as dwg_no  																	\n");
					query.append("      ,t5.description as text_des  															\n");
					query.append("      ,t3.dwg_rev as dwg_rev  																\n");
					query.append("      ,t4.user_name as user_name  															\n");
					query.append("      ,t1.req_sabun as req_sabun  															\n");
					query.append("      ,t4.dept_name as dept_name  															\n");
					query.append("      ,to_char(t1.REQ_DATE,'YYYY-MM-DD HH24:mi') as req_date   								\n");
					query.append("      ,t1.res_sabun as res_sabun  															\n");
					query.append("      ,(select user_name   																	\n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  													\n");
					query.append("         where emp_no = t1.res_sabun) as res_user_name  										\n");
					query.append("      ,to_char(t1.res_date,'YYYY-MM-DD HH24:mi') as res_date  								\n");
					query.append("      ,(select dept_name  																	\n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  													\n");
					query.append("         where emp_no = t1.res_sabun) as res_dept_name  										\n");
					query.append("      ,t1.req_seq as req_seq  																\n");
					query.append("      ,t4.ep_mail as ep_mail  																\n");
					query.append("      ,t1.MAIL_RECEIVER AS mail_receiver 														\n");
					query.append("from stx_tbc_dwg_trans                t1 														\n");
					query.append("     ,stx_tbc_dwg_trans_detail        t2 														\n");
					query.append("     ,STX_DWG_DW302TBL@"+ERP_DB+"         t3 													\n");
					query.append("     ,STX_COM_INSA_USER@"+ERP_DB+"        t4 													\n");
					query.append("     ,stx_dwg_category_masters@"+ERP_DB+" t5 													\n");
					query.append("     ,stx_com_insa_dept@"+ERP_DB+"        t6 													\n");
					query.append("where 1=1 																					\n");
					query.append("  and t1.req_seq = t2.req_seq   																\n");
					query.append("  and t2.req_dwg_seq_id = t3.dwg_seq_id 														\n");
					query.append("  and t1.req_sabun = t4.emp_no 																\n");
					query.append("  and substr(t3.dwg_no,1,5) = t5.dwg_no_concat 												\n");
					query.append("  and t4.dept_code = t6.dept_code 															\n");
					if(box.getSession("GrCode").equals("M1")){
					}
					else{
						query.append("  and t1.req_dept = '"+box.getString("dept")+"' 											\n");
						query.append("	and t1.res_sabun = '"+box.getString("p_userId")+"' 										\n");
					}
					//query.append("	and t1.res_sabun = 'P03089' \n");
					if(Integer.parseInt(box.getString("btnRadio"))==0){
						query.append("and  t1.req_state = 'S' 																	\n");	
					}
					if( !fromDate.equals("") ){
						query.append("and  to_char(t1.req_date,'YYYYMMDD') >= '"+box.getString("fromDate") +"' 					\n");
					}
					if( !toDate.equals("")	 ){
						//query.append("and  sddt.req_date <![CDATA[<=]]> #{ToDate} \n");
						query.append("and  to_char(t1.req_date,'YYYYMMDD') <= '"+box.getString("ToDate")+"' 					\n");
					}
					if(!shipNo.equals("") 	){
						query.append("and  t3.shp_no = '"+box.getString("shipNo")+"' 											\n");
					}
					if(!dwgNo.equals("") ){
						query.append("and  substr(t3.dwg_no,1,5) like '"+box.getString("dwgNo")+"%' 							\n");
					}
					if(!blockNo.equals("") ){
						query.append("and  substr(t3.dwg_no,6,8) like '"+box.getString("blockNo")+"%' 							\n");
					}
					query.append("order by shp_no,dwg_no,dwg_rev desc,req_date desc												\n");
					query.append(") t1 																							\n");
					query.append(") t2 																							\n");
					query.append("where page = "+box.getString("page")+" 														\n");
				}
				else{
					query.append("select t2.* 																					\n");
					query.append("from (   																						\n");
					query.append("select t1.*  																					\n");
					query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page 								\n");
					query.append("from 																							\n");
					query.append("(  																							\n");
					query.append("select      																					\n");
					query.append("		distinct  																				\n");
					query.append("      case when t1.req_state='Y' then 'Release'  												\n");
					query.append("           when t1.req_state='S' then 'Request'  												\n");
					query.append("           when t1.req_state='R' then 'Return'  												\n");
					query.append("           else 'Preliminary'  																\n");
					query.append("       end as trans_plm  																		\n");
					query.append("      ,t3.shp_no as shp_no  																	\n");
					query.append("      ,t3.dwg_no as dwg_no  																	\n");
					query.append("      ,t5.description as text_des  															\n");
					query.append("      ,t3.dwg_rev as dwg_rev  																\n");
					query.append("      ,t4.user_name as user_name  															\n");
					query.append("      ,t1.req_sabun as req_sabun  															\n");
					query.append("      ,t4.dept_name as dept_name  															\n");
					query.append("      ,to_char(t1.REQ_DATE,'YYYY-MM-DD HH24:mi') as req_date   								\n");
					query.append("      ,t1.res_sabun as res_sabun  															\n");
					query.append("      ,(select user_name   																	\n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  													\n");
					query.append("         where emp_no = t1.res_sabun) as res_user_name  										\n");
					query.append("      ,to_char(t1.res_date,'YYYY-MM-DD HH24:mi') as res_date  								\n");
					query.append("      ,(select dept_name  																	\n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  													\n");
					query.append("         where emp_no = t1.res_sabun) as res_dept_name  										\n");
					query.append("      ,t1.req_seq as req_seq  																\n");
					query.append("      ,t4.ep_mail as ep_mail  																\n");
					query.append("      ,t1.MAIL_RECEIVER AS mail_receiver 														\n");
					query.append("from stx_tbc_dwg_trans                t1 														\n");
					query.append("     ,stx_tbc_dwg_trans_detail        t2 														\n");
					query.append("     ,STX_DWG_DW302TBL@"+ERP_DB+"         t3 													\n");
					query.append("     ,STX_COM_INSA_USER@"+ERP_DB+"        t4 													\n");
					query.append("     ,stx_dwg_category_masters@"+ERP_DB+" t5 													\n");
					query.append("     ,stx_com_insa_dept@"+ERP_DB+"        t6 													\n");
					query.append("where 1=1 																					\n");
					query.append("  and t1.req_seq = t2.req_seq   																\n");
					query.append("  and t2.req_dwg_seq_id = t3.dwg_seq_id 														\n");
					query.append("  and t1.req_sabun = t4.emp_no 																\n");
					query.append("  and substr(t3.dwg_no,1,5) = t5.dwg_no_concat 												\n");
					query.append("  and t4.dept_code = t6.dept_code 															\n");
					query.append("	and t1.req_sabun = '"+box.getString("p_userId")+"' 											\n");
					//query.append("	and t1.req_sabun = 'P03089' 															\n");
					if(Integer.parseInt(box.getString("btnRadio"))==0){
						query.append("and  t1.req_state = 'S' 																	\n");	
					}
					if( !fromDate.equals("") ){
						query.append("and  to_char(t1.req_date,'YYYYMMDD') >= '"+box.getString("fromDate") +"' 					\n");
					}
					if( !toDate.equals("")	 ){
						//query.append("and  sddt.req_date <![CDATA[<=]]> #{ToDate} \n");
						query.append("and  to_char(t1.req_date,'YYYYMMDD') <= '"+box.getString("ToDate")+"' 					\n");
					}
					if(!shipNo.equals("") 	){
						query.append("and  t3.shp_no = '"+box.getString("shipNo")+"' 											\n");
					}
					if(!dwgNo.equals("") ){
						query.append("and  substr(t3.dwg_no,1,5) like '"+box.getString("dwgNo")+"%' 							\n");
					}
					if(!blockNo.equals("") ){
						query.append("and  substr(t3.dwg_no,6,8) like '"+box.getString("blockNo")+"%' 							\n");
					}
					query.append("order by shp_no,dwg_no,dwg_rev desc,req_date desc												\n");
					query.append(") t1 																							\n");
					query.append(") t2 																							\n");
					query.append("where page = "+box.getString("page")+" 														\n");
				}
			}
			else if(qryExp.equals("selectTotalRecord")){
				/*String fromDate = box.getString("fromDate") == null ? "" : box.getString("fromDate").toString();
				String toDate	= box.getString("ToDate") == null	? "" : box.getString("ToDate").toString();
				String shipNo	= box.getString("shipNo") == null	? "" : box.getString("shipNo").toString();
				String dwgNo	= box.getString("dwgNo") == null	? "" : box.getString("dwgNo").toString();
				String blockNo	= box.getString("blockNo") == null	? "" : box.getString("blockNo").toString();*/
				if(box.getString("permissionFlag").equals("Y"))
				{
					query.append("select \n");
					query.append("count(*) as cnt  \n");
					query.append("from  \n");
					query.append("(  \n");
					query.append("select      \n");
					query.append("		distinct  \n");
					query.append("      case when t1.req_state='Y' then 'Release'  \n");
					query.append("           when t1.req_state='S' then 'Request'  \n");
					query.append("           when t1.req_state='R' then 'Return'  \n");
					query.append("           else 'Preliminary'  \n");
					query.append("       end as trans_plm  \n");
					query.append("      ,t3.shp_no as shp_no  \n");
					query.append("      ,t3.dwg_no as dwg_no  \n");
					query.append("      ,t5.description as text_des  \n");
					query.append("      ,t3.dwg_rev as dwg_rev  \n");
					query.append("      ,t4.user_name as user_name  \n");
					query.append("      ,t1.req_sabun as req_sabun  \n");
					query.append("      ,t4.dept_name as dept_name  \n");
					query.append("      ,to_char(t1.REQ_DATE,'YYYY-MM-DD HH24:mi') as req_date   \n");
					query.append("      ,t1.res_sabun as res_sabun  \n");
					query.append("      ,(select user_name   \n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  \n");
					query.append("         where emp_no = t1.res_sabun) as res_user_name  \n");
					query.append("      ,to_char(t1.res_date,'YYYY-MM-DD HH24:mi') as res_date  \n");
					query.append("      ,(select dept_name  \n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  \n");
					query.append("         where emp_no = t1.res_sabun) as res_dept_name  \n");
					query.append("      ,t1.req_seq as req_seq  \n");
					query.append("      ,t4.ep_mail as ep_mail  \n");
					query.append("      ,t1.MAIL_RECEIVER AS mail_receiver \n");
					query.append("from stx_tbc_dwg_trans                t1 \n");
					query.append("     ,stx_tbc_dwg_trans_detail        t2 \n");
					query.append("     ,STX_DWG_DW302TBL@"+ERP_DB+"         t3 \n");
					query.append("     ,STX_COM_INSA_USER@"+ERP_DB+"        t4 \n");
					query.append("     ,stx_dwg_category_masters@"+ERP_DB+" t5 \n");
					query.append("     ,stx_com_insa_dept@"+ERP_DB+"        t6 \n");
					query.append("where 1=1 \n");
					query.append("  and t1.req_seq = t2.req_seq   \n");
					query.append("  and t2.req_dwg_seq_id = t3.dwg_seq_id \n");
					query.append("  and t1.req_sabun = t4.emp_no \n");
					query.append("  and substr(t3.dwg_no,1,5) = t5.dwg_no_concat \n");
					query.append("  and t4.dept_code = t6.dept_code \n");
					if(box.getSession("GrCode").equals("M1")){
					}
					else{
						query.append("  and t1.req_dept = '"+box.getString("dept")+"' 											\n");
						query.append("	and t1.res_sabun = '"+box.getString("p_userId")+"' 										\n");
					}
					if(Integer.parseInt(box.getString("btnRadio"))==0){
						query.append("and  t1.req_state = 'S' \n");	
					}
					if( !fromDate.equals("") ){
						query.append("and  to_char(t1.req_date,'YYYYMMDD') >= '"+box.getString("fromDate") +"' \n");
					}
					if( !toDate.equals("")	 ){
						//query.append("and  sddt.req_date <![CDATA[<=]]> #{ToDate} \n");
						query.append("and  to_char(t1.req_date,'YYYYMMDD') <= '"+box.getString("ToDate")+"' \n");
					}
					if(!shipNo.equals("") 	){
						query.append("and  t3.shp_no = '"+box.getString("shipNo")+"' \n");
					}
					if(!dwgNo.equals("") ){
						query.append("and  substr(t3.dwg_no,1,5) like '"+box.getString("dwgNo")+"%' \n");
					}
					if(!blockNo.equals("") ){
						query.append("and  substr(t3.dwg_no,6,8) like '"+box.getString("blockNo")+"%' \n");
					}
					query.append("order by shp_no,dwg_no,dwg_rev desc,req_date desc	\n");
					query.append(") \n");
				}
				else{
					query.append("select \n");
					query.append("count(*) as cnt  \n");
					query.append("from  \n");
					query.append("(  \n");
					query.append("select      \n");
					query.append("		distinct  \n");
					query.append("      case when t1.req_state='Y' then 'Release'  \n");
					query.append("           when t1.req_state='S' then 'Request'  \n");
					query.append("           when t1.req_state='R' then 'Return'  \n");
					query.append("           else 'Preliminary'  \n");
					query.append("       end as trans_plm  \n");
					query.append("      ,t3.shp_no as shp_no  \n");
					query.append("      ,t3.dwg_no as dwg_no  \n");
					query.append("      ,t5.description as text_des  \n");
					query.append("      ,t3.dwg_rev as dwg_rev  \n");
					query.append("      ,t4.user_name as user_name  \n");
					query.append("      ,t1.req_sabun as req_sabun  \n");
					query.append("      ,t4.dept_name as dept_name  \n");
					query.append("      ,to_char(t1.REQ_DATE,'YYYY-MM-DD HH24:mi') as req_date   \n");
					query.append("      ,t1.res_sabun as res_sabun  \n");
					query.append("      ,(select user_name   \n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  \n");
					query.append("         where emp_no = t1.res_sabun) as res_user_name  \n");
					query.append("      ,to_char(t1.res_date,'YYYY-MM-DD HH24:mi') as res_date  \n");
					query.append("      ,(select dept_name  \n");
					query.append("          from STX_COM_INSA_USER@"+ERP_DB+"  \n");
					query.append("         where emp_no = t1.res_sabun) as res_dept_name  \n");
					query.append("      ,t1.req_seq as req_seq  \n");
					query.append("      ,t4.ep_mail as ep_mail  \n");
					query.append("      ,t1.MAIL_RECEIVER AS mail_receiver \n");
					query.append("from stx_tbc_dwg_trans                t1 \n");
					query.append("     ,stx_tbc_dwg_trans_detail        t2 \n");
					query.append("     ,STX_DWG_DW302TBL@"+ERP_DB+"         t3 \n");
					query.append("     ,STX_COM_INSA_USER@"+ERP_DB+"        t4 \n");
					query.append("     ,stx_dwg_category_masters@"+ERP_DB+" t5 \n");
					query.append("     ,stx_com_insa_dept@"+ERP_DB+"        t6 \n");
					query.append("where 1=1 \n");
					query.append("  and t1.req_seq = t2.req_seq   \n");
					query.append("  and t2.req_dwg_seq_id = t3.dwg_seq_id \n");
					query.append("  and t1.req_sabun = t4.emp_no \n");
					query.append("  and substr(t3.dwg_no,1,5) = t5.dwg_no_concat \n");
					query.append("  and t4.dept_code = t6.dept_code \n");
					query.append("	and t1.req_sabun = '"+box.getString("p_userId")+"' 							\n");
					//query.append("	and t1.req_sabun = 'P03089' \n");
					if(Integer.parseInt(box.getString("btnRadio"))==0){
						query.append("and  t1.req_state = 'S' \n");	
					}
					if( !fromDate.equals("") ){
						query.append("and  to_char(t1.req_date,'YYYYMMDD') >= '"+box.getString("fromDate") +"' \n");
					}
					if( !toDate.equals("")	 ){
						//query.append("and  sddt.req_date <![CDATA[<=]]> #{ToDate} \n");
						query.append("and  to_char(t1.req_date,'YYYYMMDD') <= '"+box.getString("ToDate")+"' \n");
					}
					if(!shipNo.equals("") 	){
						query.append("and  t3.shp_no = '"+box.getString("shipNo")+"' \n");
					}
					if(!dwgNo.equals("") ){
						query.append("and  substr(t3.dwg_no,1,5) like '"+box.getString("dwgNo")+"%' \n");
					}
					if(!blockNo.equals("") ){
						query.append("and  substr(t3.dwg_no,6,8) like '"+box.getString("blockNo")+"%' \n");
					}
					query.append("order by shp_no,dwg_no,dwg_rev desc,req_date desc	\n");
					query.append(") \n");
				}
			}else if(qryExp.equals("getDwgMailSendSeq")){
				query.append("select to_char(STX_TBC_DWG_MAIL_SEND_SQ.nextval) as seq	\n");
				query.append("  from dual 												\n");
			}else if(qryExp.equals("getPermission")){
				query.append("select	*											\n");
				query.append("  from	stx_dwg_mail_confirm_user_v@"+ERP_DB+"					\n");
				query.append(" where	emp_no=	'"+box.getString("p_userId")+"'		\n");
				//query.append(" where	emp_no=	'P03089'		\n");
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