package com.stx.tbc.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;


import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;
import com.stx.common.library.RequestBox;
import com.stx.common.util.JsonUtil;
import com.stx.tbc.dao.factory.Idao;

public class TbcItemTransDao implements Idao {

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {

		Connection conn = null;
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		String query = "";

		// 조회 list
		if (qryExp.equals("list")) {
			 String cnt=(String) itemTransTotalRecord(rBox);
			 rBox.put("listRowCnt", cnt);
		}
		try {
			//임시 저장시
			if(qryExp.equals("temporarystorage")){
				list = tbcTemporaryStorage(qryExp, rBox);
			}
			//접수시
			else if(qryExp.equals("itemreceive")){
				list = itemreceive(qryExp, rBox);
			}
			//승인시
			else if(qryExp.equals("updateInfoList")){
				list = updateInfoList(qryExp, rBox);
			}
			//반려 
			else if(qryExp.equals("updateReturn")){
				list = updateReturn(qryExp, rBox); 
			}
			//철회
			else if(qryExp.equals("updateRetract")){
				list = updateRetract(qryExp, rBox); 
			}
			//취소 버튼 눌렀을 때
			else if(qryExp.equals("btnCancel")){
				list = deleteDoc(qryExp, rBox);
			}
			//첨부 파일 삭제
			else if(qryExp.equals("deleteDocList")){
				list = deleteDocument(qryExp, rBox);
			}
			//관리자가 삭제할 경우
			else if(qryExp.equals("AdminDelete")){
				list = adminDelete(qryExp , rBox);
			}
			else{
				list = new ArrayList();
				query = getQuery(qryExp, rBox);
	
				conn = DBConnect.getDBConnection("DIS");
				pstmt = conn.prepareStatement(query.toString());
	
				ls = new ListSet(conn);
				ls.run(pstmt);
	
				while (ls.next()) {
					resultList = ls.getDataMap();
					list.add(resultList);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (conn != null) {	try {conn.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return list;
	}
	
	public String TotalRecord(RequestBox rBox) throws Exception {
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
            query  = getQuery("TotalRecord",rBox);           
            
            conn = DBConnect.getDBConnection("DIS");
            
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
	
	public String itemTransTotalRecord(RequestBox rBox) throws Exception {
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
            query  = getQuery("itemTransTotalRecord",rBox);           
            
            conn = DBConnect.getDBConnection("DIS");
            
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
		return result;
	}
	
	//관리자가 삭제
	public ArrayList adminDelete(String qryExp, RequestBox rBox)throws Exception{
		ArrayList ar 				= null;
		boolean result				= false;
		Map temp					= new HashMap();
		ArrayList list 				= new ArrayList();
		Connection connPLM 			= null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		PreparedStatement	pstmt 	= null;
		PreparedStatement	pstmt1 	= null;
		PreparedStatement	pstmt2 	= null;
		PreparedStatement	pstmt3 	= null;
		PreparedStatement	pstmt4 	= null;
		PreparedStatement	pstmt5 	= null;
		String 			list_id		= "";
		String			document_id	= "";
		int				deleteRowCnt= 0 ; 
		StringBuffer query = new StringBuffer();
		StringBuffer query1 = new StringBuffer();
		StringBuffer query2 = new StringBuffer();
		StringBuffer query3 = new StringBuffer();
		StringBuffer query4 = new StringBuffer();
		StringBuffer query5 = new StringBuffer();
		try {
			
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			String list_type = rBox.getString("list_type")== null ? "" : rBox.getString("list_type").toString();
			
			//list_id를 기준으로 전부 삭제한다
			//stx_DIS_info_list where list_id
			query.append("delete from stx_DIS_info_list where list_id = "+list_id+"	\n");
			pstmt=connPLM.prepareStatement(query.toString());
			pstmt.executeUpdate();
			if(list_type.equals("01")){
				//stx_DIS_info_list_catalog where list_id 
				query1.append("delete from stx_DIS_info_list_catalog where list_id = "+list_id+"	\n");
				pstmt1=connPLM.prepareStatement(query1.toString());
				pstmt1.executeUpdate();
			}else if(list_type.equals("02")){
				//stx_DIS_info_list_item where list_id
				query2.append("delete from stx_DIS_info_list_item where list_id = "+list_id+"	\n");
				pstmt2=connPLM.prepareStatement(query2.toString());
				pstmt2.executeUpdate();
			}
			
			//첨부 문서 삭제
			query4.append("delete from STX_DIS_INFO_DOC where list_id = "+list_id+"	\n");
			pstmt4=connPLM.prepareStatement(query4.toString());
			pstmt4.executeUpdate();
			//관련자 삭제
			query5.append("delete from STX_DIS_INFO_LIST_REF_USER where list_id = "+list_id+"	\n");
			pstmt5=connPLM.prepareStatement(query5.toString());
			pstmt5.executeUpdate();
			
			//STX_DIS_INFO_LIST_APPROVAL_HIS insert confirm_type = 04
			query3.append("insert into STX_DIS_INFO_LIST_APPROVAL_HIS	\n");
			query3.append("	(	\n");
			query3.append("		 LIST_ID	\n");
			query3.append("		,RETRUN_DATE	\n");
			query3.append("		,CONFIRM_TYPE	\n");
			query3.append("		,PROCESS_TYPE	\n");
			query3.append("		,APROVE_TYPE	\n");
			query3.append("		,APROVE_EMP_NO	\n");
			query3.append("		,APROVE_COMMENT	\n");
			query3.append("		,CONFIRM_FLAG	\n");
			query3.append("		,CONFIRM_DATE	\n");
			query3.append("		,LAST_UPDATE_DATE	\n");
			query3.append("		,LAST_UPDATED_BY	\n");
			query3.append("		,CREATION_DATE	\n");
			query3.append("		,CREATED_BY	\n");
			query3.append("	)	\n");
			query3.append("	values	\n");
			query3.append("	(	\n");
			query3.append("		"+list_id+"	\n");
			query3.append("		,sysdate	\n");
			query3.append("		,'04'	\n");
			query3.append("		,'"+rBox.getString("list_status")+"'	\n");
			query3.append("		,'05'	\n");
			query3.append("		,'"+rBox.getString("user_id")+"'	\n");
			query3.append("		,''	\n");
			query3.append("		,'Y'	\n");
			query3.append("		,sysdate	\n");
			query3.append("		,sysdate	\n");
			query3.append("		,'"+rBox.getString("user_id")+"'	\n");
			query3.append("		,sysdate	\n");
			query3.append("		,'"+rBox.getString("user_id")+"'	\n");
			query3.append("	)	\n");
			
			pstmt3=connPLM.prepareStatement(query3.toString());
			pstmt3.executeUpdate();
			
			rBox.put("Result_Msg", "삭제 성공");
			rBox.put("result", "true");
			connPLM.commit();
			result = true;
			list.add(rBox);
			
		
		} catch (Exception ex) {
			ex.printStackTrace();
			rBox.put("Result_Msg", "삭제 실패");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	//첨부파일  삭제 버튼 클릭 시 
	public ArrayList deleteDocument(String qryExp, RequestBox rBox)throws Exception {
		ArrayList ar 				= null;
		boolean result				= false;
		Map temp					= new HashMap();
		ArrayList list 				= new ArrayList();
		Connection connPLM 			= null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		PreparedStatement	pstmt 	= null;
		String 			list_id		= "";
		String			document_id	= "";
		int				deleteRowCnt= 0 ; 
		StringBuffer query = new StringBuffer();
		try {
			
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			java.util.List chmResultList = JsonUtil.toList(rBox.get("chmResultList"));
			for(int i=0;i<chmResultList.size();i++){
				Map rowData = (Map) chmResultList.get(i);
				document_id	= rowData.get("document_id").toString();
				
				query.delete(0, query.length());
				query.append("delete 	\n");
				query.append("	from stx_DIS_info_doc	\n");
				query.append(" where list_id = "+list_id+"	\n");
				query.append("	 and document_id = "+document_id+"	\n");
				
				pstmt=connPLM.prepareStatement(query.toString());
				deleteRowCnt += pstmt.executeUpdate();
				
			}
			
			rBox.put("Result_Msg", "첨부파일 삭제 성공");
			rBox.put("result", "true");
			connPLM.commit();
			result = true;
			list.add(rBox);
			
		
		} catch (Exception ex) {
			ex.printStackTrace();
			rBox.put("Result_Msg", "첨부파일 삭제 실패");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	//취소 버튼 눌렀을 때 
	public ArrayList deleteDoc(String qryExp, RequestBox rBox)throws Exception {
		ArrayList ar 				= null;
		boolean result				= false;
		Map temp					= new HashMap();
		ArrayList list 				= new ArrayList();
		Connection connPLM 			= null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		PreparedStatement	pstmt 	= null;
		String 			list_id		= "";
		try {
			
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			
			
			//list_id의 상태값 가져오기
			Map infoList = new HashMap();
			infoList = selectInfoList("selectInfoList",rBox);
			//String list_status = infoList.get("list_status")== null ? "" : infoList.get("list_status").toString();
			//list_status가 없다면 저장한 상태가 아니기 때문에 첨부한 문서를 다 지운다.
			if(infoList==null){
				StringBuffer deleteDoc = new StringBuffer();
				deleteDoc.append("delete  	\n");
				deleteDoc.append("	from	stx_DIS_info_doc	\n");
				deleteDoc.append(" where 	list_id = '"+list_id+"'	\n");
				
				pstmt=connPLM.prepareStatement(deleteDoc.toString());
				pstmt.executeUpdate();
				
				rBox.put("Result_Msg", "첨부파일 삭제성공");
				rBox.put("result", "true");
				connPLM.commit();
				result = true;
				list.add(rBox);
			}
			//list_status 가 있다면 저장한 상태이므로 목록으로 돌아간다.
			else{
				rBox.put("Result_Msg", "목록으로 돌아가기");
				rBox.put("result", "true");
				list.add(rBox);
				result = true;
				connPLM.commit();
			}
		
		} catch (Exception ex) {
			ex.printStackTrace();
			rBox.put("Result_Msg", "철회 실패");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	
	
	//철회
	public ArrayList updateRetract(String qryExp, RequestBox rBox)throws Exception {
		ArrayList ar = null;
		boolean result = false;
		Map temp	= new HashMap();
		ArrayList list = new ArrayList();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		
		String list_id	= "";
		try {
			
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			
			//list_id의 상태값 가져오기
			Map infoList = new HashMap();
			infoList = selectInfoList("selectInfoList",rBox);
			String list_status = infoList.get("list_status")== null ? "" : infoList.get("list_status").toString();
			if(list_status.equals("03")){
				rBox.put("Result_Msg", "검토중 문서는 회수할 수 없습니다");
				rBox.put("result", "false");
				connPLM.rollback();
				result = false;
				list.add(rBox);
			}else{
				//임시저장 상태로 update 쳐준다.
				rBox.put("list_status", "01");
				updateInfoListPromote(connPLM,rBox);
			
				rBox.put("Result_Msg", "철회 완료");
				rBox.put("result", "true");
				list.add(rBox);
				result = true;
				connPLM.commit();
			}
		
		} catch (Exception ex) {
			ex.printStackTrace();
			rBox.put("Result_Msg", "철회 실패");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	//반려
	public ArrayList updateReturn(String qryExp, RequestBox rBox)throws Exception {
		ArrayList ar = null;
		boolean result = false;
		Map temp	= new HashMap();
		ArrayList list = new ArrayList();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		
		String list_id	= "";
		try {
			
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			String list_type = rBox.getString("list_type")== null ? "" : rBox.getString("list_type").toString();
			//String list_status = rBox.get("list_status")== null ? "" : rBox.get("list_status").toString();
			String grantor_dept = rBox.getString("grantor_dept")== null ? "" : rBox.getString("grantor_dept").toString();
			String grantor_emp0 = rBox.getString("grantor_emp0")== null ? "" : rBox.getString("grantor_emp0").toString();
			String grantor_emp1 = rBox.getString("grantor_emp1")== null ? "" : rBox.getString("grantor_emp1").toString();
			String grantor_emp2 = rBox.getString("grantor_emp2")== null ? "" : rBox.getString("grantor_emp2").toString();
			String grantor_emp3 = rBox.getString("grantor_emp3")== null ? "" : rBox.getString("grantor_emp3").toString();
			String grantor_emp4 = rBox.getString("grantor_emp4")== null ? "" : rBox.getString("grantor_emp4").toString();
			String user_id = rBox.getString("user_id")== null ? "" : rBox.getString("user_id").toString();
			
			//list_id의 상태값 가져오기
			Map infoList = new HashMap();
			infoList = selectInfoList("selectInfoList",rBox);
			String list_status = infoList.get("list_status")== null ? "" : infoList.get("list_status").toString();
			if(list_status.equals("05")){
				rBox.put("Result_Msg", "검토 완료된 문서는 반려할 수 없습니다");
				rBox.put("result", "false");
				connPLM.rollback();
				result = false;
				list.add(rBox);
			}
			else if(list_status.equals("06")){
				rBox.put("Result_Msg", "완료된 문서는 반려할 수 없습니다");
				rBox.put("result", "false");
				connPLM.rollback();
				result = false;
				list.add(rBox);
			}
			else{
				//반려 시 stx_DIS_info_list_approval confirm_type = '03'(반려),confirm_flag = 'Y' last_updated_date,last_updated_by 
				//	    where list_id,confirm_emp_no = user_id
				rBox.put("confirm_type", "03");//반려상태
				if(grantor_emp0.equals(user_id)){
					String grantor_comment0 = rBox.getString("grantor_comment0")== null ? "" : rBox.getString("grantor_comment0").toString();
					rBox.put("aprove_comment", grantor_comment0);
					updateListApproval(connPLM,rBox);
				}else if(grantor_emp1.equals(user_id)){
					String grantor_comment1 = rBox.getString("grantor_comment1")== null ? "" : rBox.getString("grantor_comment1").toString();
					rBox.put("aprove_comment", grantor_comment1);
					updateListApproval(connPLM,rBox);
				}else if(grantor_emp2.equals(user_id)){
					String grantor_comment2 = rBox.getString("grantor_comment2")== null ? "" : rBox.getString("grantor_comment2").toString();
					rBox.put("aprove_comment", grantor_comment2);
					updateListApproval(connPLM,rBox);
				}else if(grantor_emp3.equals(user_id)){
					String grantor_comment3 = rBox.getString("grantor_comment3")== null ? "" : rBox.getString("grantor_comment3").toString();
					rBox.put("aprove_comment", grantor_comment3);
					updateListApproval(connPLM,rBox);
				}else if(grantor_emp4.equals(user_id)){
					String grantor_comment4 = rBox.getString("grantor_comment4")== null ? "" : rBox.getString("grantor_comment4").toString();
					rBox.put("aprove_comment", grantor_comment4);
					updateListApproval(connPLM,rBox);
				}
				
				//반려 history에 insert한다 (STX_DIS_INFO_LIST_APPROVAL_HIS)
				insertSelectLIST_APPROVAL_HIS(connPLM,rBox);
			
				//stx_DIS_info_list_approval에 FEEDBACK 데이터는 지우고 접수 데이터는 CONFIRM_FLAG 와 CONFIRM_DATE 를 초기화 한다
				deleteListApproval(connPLM,rBox);
				
				//임시저장 상태로 update 쳐준다.
				rBox.put("list_status", "01");
				updateInfoListPromote(connPLM,rBox);
			
				rBox.put("Result_Msg", "반려 완료");
				rBox.put("result", "true");
				list.add(rBox);
				result = true;
				connPLM.commit();
				//메일보내기 
				
				String err_code = stxTbcItemMailing(connPLM,list_id,"return");
				if(err_code.equals("OK")){
					connPLM.commit(); 
				}else{
					rBox.put("Result_Msg", "메일 전송 오류");
					rBox.put("result", "true");
					connPLM.commit();
					result = true;
					list.add(rBox);
				}
			}
		
		} catch (Exception ex) {
			ex.printStackTrace();
			rBox.put("Result_Msg", "시스템 내부 오류");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list; 
	}
	//list_id의 상태값 가져오기
	public Map selectInfoList(String qryExp, RequestBox rBox) throws Exception {

		Connection conn = null;
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		String query = "";
		
		try {
			list = new ArrayList();
			query = getQuery(qryExp, rBox);

			conn = DBConnect.getDBConnection("DIS");
			pstmt = conn.prepareStatement(query.toString());

			ls = new ListSet(conn);
			ls.run(pstmt);

			while (ls.next()) {
				resultList = ls.getDataMap();
				list.add(resultList);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (conn != null) {	try {conn.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return resultList;
	}
	
	//승인시
	public ArrayList updateInfoList(String qryExp, RequestBox rBox)throws Exception {
		ArrayList ar = null;
		boolean result = false;
		Map temp	= new HashMap();
		ArrayList list = new ArrayList();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		PreparedStatement	pstmt = null;
		String list_id	= "";
		try {
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			String list_status = rBox.getString("list_status")== null ? "" : rBox.getString("list_status").toString();
			String grantor_emp0 = rBox.getString("grantor_emp0")== null ? "" : rBox.getString("grantor_emp0").toString();
			String grantor_emp1 = rBox.getString("grantor_emp1")== null ? "" : rBox.getString("grantor_emp1").toString();
			String grantor_emp2 = rBox.getString("grantor_emp2")== null ? "" : rBox.getString("grantor_emp2").toString();
			String grantor_emp3 = rBox.getString("grantor_emp3")== null ? "" : rBox.getString("grantor_emp3").toString();
			String grantor_emp4 = rBox.getString("grantor_emp4")== null ? "" : rBox.getString("grantor_emp4").toString();
			String user_id = rBox.getString("user_id")== null ? "" : rBox.getString("user_id").toString();
			String aprove_comment = rBox.getString("aprove_comment") == null ? "" : rBox.getString("aprove_comment").toString();
			String admin_chk = rBox.getString("admin_chk")== null ? "" : rBox.getString("admin_chk").toString();
			String list_type = rBox.getString("list_type")== null ? "" : rBox.getString("list_type").toString();
			java.util.List chmResultList = JsonUtil.toList(rBox.get("chmResultList"));
			java.util.List refUserResultList = JsonUtil.toList(rBox.get("refUserResultList"));
			
			rBox.put("confirm_type", "02");
			rBox.put("confirm_flag", "Y");
			rBox.put("list_status",list_status);
			//ADMIN 유저가 승인 했을 경우 STX_DIS_INFO_LIST_APPROVAL UPDATE
			if(admin_chk.equals("Y")){
				StringBuffer adminUpdate = new StringBuffer();
				adminUpdate.append("UPDATE  STX_DIS_INFO_LIST_APPROVAL		\n");
				adminUpdate.append("  SET  									\n");
				adminUpdate.append("	   CONFIRM_FLAG		= 'Y'			\n");
				adminUpdate.append("	  ,LAST_UPDATE_DATE = SYSDATE		\n");
				adminUpdate.append("	  ,LAST_UPDATED_BY  = '"+user_id+"'	\n");
				adminUpdate.append("	  ,CONFIRM_COMMENT  = '"+aprove_comment+"'	\n");
				adminUpdate.append("WHERE  LIST_ID = "+list_id+"			\n");
				adminUpdate.append("  AND  process_type = '02'				\n");
				pstmt = connPLM.prepareStatement(adminUpdate.toString());
				pstmt.executeUpdate();
			}
			else{
				
				//승인 시 approval confirm_flag Y로 업데이트 
				if(grantor_emp0.equals(user_id)){
					rBox.put("aprove_type", rBox.getString("grantor_dept0"));
					rBox.put("aprove_emp_no", rBox.getString("grantor_emp0"));
					rBox.put("aprove_comment", rBox.getString("grantor_comment0"));
					insertListApproval(connPLM,rBox);
				}else if(grantor_emp1.equals(user_id)){
					rBox.put("aprove_type", rBox.getString("grantor_dept1"));
					rBox.put("aprove_emp_no", rBox.getString("grantor_emp1"));
					rBox.put("aprove_comment", rBox.getString("grantor_comment1"));
					insertListApproval(connPLM,rBox);
				}else if(grantor_emp2.equals(user_id)){
					rBox.put("aprove_type", rBox.getString("grantor_dept2"));
					rBox.put("aprove_emp_no", rBox.getString("grantor_emp2"));
					rBox.put("aprove_comment", rBox.getString("grantor_comment2"));
					insertListApproval(connPLM,rBox);
				}else if(grantor_emp3.equals(user_id)){
					rBox.put("aprove_type", rBox.getString("grantor_dept3"));
					rBox.put("aprove_emp_no", rBox.getString("grantor_emp3"));
					rBox.put("aprove_comment", rBox.getString("grantor_comment3"));
					insertListApproval(connPLM,rBox);
				}else if(grantor_emp4.equals(user_id)){
					rBox.put("aprove_type", rBox.getString("grantor_dept4"));
					rBox.put("aprove_emp_no", rBox.getString("grantor_emp4"));
					rBox.put("aprove_comment", rBox.getString("grantor_comment4"));
					insertListApproval(connPLM,rBox);
				}
			}
			
			
			
			//ADMIN 일 경우 STX_DIS_INFO_LIST_HIS에 기존에 있던 정보를 INSERT 해준다
			if(admin_chk.equals("Y")){
				insertInfoListHis(connPLM,rBox);
				//ADMIN일 경우 CATALOG,ITEM,관련자 UPDATE쳐준다
				for (int i = 0; i < chmResultList.size(); i++) {
					Map rowData = (Map) chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
					if(!rowid.equals("")){
						//CATALOG 신규 등록일 경우
						if(list_type.equals("01")){
							updateInfoCatalog(connPLM,rowData);
						}
						else if(list_status.equals("02")){
							updateInfoItem(connPLM,rowData);
						}
					}
				}//end of for
				//관련자 UPDATE
				for (int i = 0; i < refUserResultList.size(); i++) {
					Map rowData = (Map) refUserResultList.get(i);
					rowData.put("list_id", list_id);
					rowData.put("user_id", rBox.getString("user_id"));
					String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
					insertRefUser(connPLM,rowData);
				}
			}   //end of if(admin)
			else{
				if(list_status.equals("02") || list_status.equals("03")){
					//CATALOG,ITEM,관련자 UPDATE쳐준다 (검토자가 수정할수 있음)
					for (int i = 0; i < chmResultList.size(); i++) {
						Map rowData = (Map) chmResultList.get(i);
						rowData.put("list_id", list_id);
						String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
						if(!rowid.equals("")){
							//CATALOG 신규 등록일 경우
							if(list_type.equals("01")){
								updateInfoCatalog(connPLM,rowData);
							}
							else if(list_status.equals("02")){
								updateInfoItem(connPLM,rowData);
							}
						}
						
					}//end of for
				}
			}
				
			//승인 시 list_approval 상태 가져오기
			temp=selectListApproval(connPLM,rBox);
			
			String attribute_01 = "";
			String confirm_flag_cnt = "";
			if(temp!=null){
				attribute_01 = temp.get("attribute_01").toString();
				//list_status	 = temp.get("list_status").toString();
				confirm_flag_cnt	= temp.get("cnt").toString();
				//상태가 접수중일 경우
				if(list_status.equals("02")){
					//승인안한 사람이 있을 경우
					if(!confirm_flag_cnt.equals("0")){
						//상태를 검토중으로 넘겨준다
						rBox.put("list_status", "03");
						updateInfoListPromote(connPLM,rBox);
						
						rBox.put("Result_Msg", "승인 완료");
						rBox.put("result", "true");
						list.add(rBox);
						result = true;
						connPLM.commit();
					}
					//N FLAG가 없을경우는 모두다 승인한 경우기 때문에 LIST_TYPE의 ATTR1의 값에 따라서 상태 이동 ex(CATALOG는 04번 , ITEM은 05번 , 기준정보는 05번)
					else{
						
						rBox.put("list_status", attribute_01);
						updateInfoListPromote(connPLM,rBox);
						//다음단계가 feedback인 경우 feedback으로 설정된 인원 insert
						if(attribute_01.equals("04")){
							
							insertlistApprovalFeedback(connPLM,rBox);
						}
						
						rBox.put("Result_Msg", "승인 완료");
						rBox.put("result", "true");
						list.add(rBox);
						result = true;
						connPLM.commit();
						
						//피드백 상태로 넘어갔을때 메일보내기 
						if(list_type.equals("01")){
							String err_code = stxTbcItemMailing(connPLM,list_id,"approve");
							if(!err_code.equals("OK")){
								rBox.put("Result_Msg", "메일 전송 오류");
								rBox.put("result", "true");
								connPLM.commit();
								result = true;
								list.add(rBox);
							}
						}
					}
			
				}
				//상태가 검토중일 경우
				else if(list_status.equals("03")){
					//모두가 승인 했을 경우
					if(confirm_flag_cnt.equals("0")){
						rBox.put("list_status", attribute_01);
						updateInfoListPromote(connPLM,rBox);
						//다음단계가 feedback인 경우 feedback으로 설정된 인원 insert
						if(attribute_01.equals("04")){
							insertlistApprovalFeedback(connPLM,rBox);
						}
						rBox.put("Result_Msg", "승인 완료");
						rBox.put("result", "true");
						list.add(rBox);
						result = true;
						connPLM.commit();
						
						if(list_type.equals("01")){
							//피드백 상태로 넘어갔을때 메일보내기 
							String err_code = stxTbcItemMailing(connPLM,list_id,"approve");
							if(!err_code.equals("OK")){
								rBox.put("Result_Msg", "메일 전송 오류");
								rBox.put("result", "true");
								connPLM.commit();
								result = true;
								list.add(rBox);
							}
						}
					}
					
				}
				//상태가 feedback일 경우
				else if(list_status.equals("04")){
					rBox.put("aprove_type", "04");	//자동승인
					rBox.put("aprove_emp_no", user_id);
					rBox.put("aprove_comment", "FEEDBACK 강제 승인");
					rBox.put("list_status", "05");
					insertListApproval(connPLM,rBox);
					updateInfoListPromote(connPLM,rBox);
					
					rBox.put("Result_Msg", "승인 완료");
					rBox.put("result", "true");
					list.add(rBox);
					result = true;
					connPLM.commit();
				}
				//상태가 검토완료일 경우
				else if(list_status.equals("05")){
					rBox.put("list_status", "06");
					updateInfoListPromote(connPLM,rBox);
					
					rBox.put("Result_Msg", "승인 완료");
					rBox.put("result", "true");
					list.add(rBox);
					result = true;
					connPLM.commit();
					
					//등록완료시 메일보내기
					String err_code = stxTbcItemMailing(connPLM,list_id,"approve");
					if(!err_code.equals("OK")){
						rBox.put("Result_Msg", "메일 전송 오류");
						rBox.put("result", "true");
						connPLM.commit();
						result = true;
						list.add(rBox);
					}
				}
				
			}
			//게시물이 없습니다. 
			else{
				rBox.put("Result_Msg", "게시물이 삭제되었습니다.");
				rBox.put("result", "false");
				result = false;
				list.add(rBox);
				connPLM.rollback();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			rBox.put("Result_Msg", "시스템 내부 오류");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	//접수
	public ArrayList itemreceive(String qryExp, RequestBox rBox)throws Exception {
		ArrayList ar = null;
		boolean result = false;

		ArrayList list = new ArrayList();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		
		String list_id	= "";
		//접수 list 가져오기
		java.util.List chmResultList = JsonUtil.toList(rBox.get("chmResultList"));
		java.util.List refUserResultList = JsonUtil.toList(rBox.get("refUserResultList"));
		try {
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			String list_type = rBox.getString("list_type")== null ? "" : rBox.getString("list_type").toString();
			//처음 입력시 list_id 값을 받아서 stx_DIS_info_list
			if(list_id.equals("")){
				//list_id 얻어오기
				list_id = getListId(connPLM, rBox);
				rBox.put("list_id", list_id);
				//stx_DIS_info_list insert
				insertInfoList(connPLM, rBox);
			}else{
				insertInfoList(connPLM,rBox);
			}
			//catalog 등록시 
			if(list_type.equals("01")){
				//stx_DIS_info_list_catalog insert
				for (int i = 0; i < chmResultList.size(); i++) {
					Map rowData = (Map) chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
					if(rowid.equals("")){
						insertInfoListCatalog(connPLM, rowData);
					}else{
						updateInfoCatalog(connPLM,rowData);
					}
				}
			}
			//item 등록 시 
			else if(list_type.equals("02")){
				//stx_DIS_info_list_catalog insert
				for (int i = 0; i < chmResultList.size(); i++) {
					Map rowData = (Map) chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
					if(rowid.equals("")){
						insertInfoListItem(connPLM, rowData);
					}else{
						updateInfoItem(connPLM,rowData);
					}
				}
			}
			
			//stx_DIS_info_list_approval insert  설계 조달 영업별로 row 하나씩 insert (최대 5개 부서)
			String grantor_dept0 = rBox.getString("grantor_dept0") == null ? "" : rBox.getString("grantor_dept0").toString();
			String grantor_dept1 = rBox.getString("grantor_dept1") == null ? "" : rBox.getString("grantor_dept1").toString();
			String grantor_dept2 = rBox.getString("grantor_dept2") == null ? "" : rBox.getString("grantor_dept2").toString();
			String grantor_dept3 = rBox.getString("grantor_dept3") == null ? "" : rBox.getString("grantor_dept3").toString();
			String grantor_dept4 = rBox.getString("grantor_dept4") == null ? "" : rBox.getString("grantor_dept4").toString();
			rBox.put("confirm_type", "01");
			rBox.put("confirm_flag", "N");
			if(!grantor_dept0.equals("")){
			rBox.put("aprove_type", grantor_dept0);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp0"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment0"));
			insertListApproval(connPLM,rBox);
			}
			if(!grantor_dept1.equals("")){
			rBox.put("aprove_type", grantor_dept1);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp1"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment1"));
			insertListApproval(connPLM,rBox);
			}
			
			if(!grantor_dept2.equals("")){
			rBox.put("aprove_type", grantor_dept2);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp2"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment2"));
			insertListApproval(connPLM,rBox);
			}
			
			if(!grantor_dept3.equals("")){
			rBox.put("aprove_type", grantor_dept3);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp3"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment3"));
			insertListApproval(connPLM,rBox);
			}
			if(!grantor_dept4.equals("")){
			rBox.put("aprove_type", grantor_dept4);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp4"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment4"));
			insertListApproval(connPLM,rBox);
			}
			//관련자 insert
			for (int i = 0; i < refUserResultList.size(); i++) {
				Map rowData = (Map) refUserResultList.get(i);
				rowData.put("list_id", list_id);
				rowData.put("user_id", rBox.getString("user_id"));
				String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
				insertRefUser(connPLM,rowData);
			}
			
			Map listDetail=selectDetail(connPLM,rBox);
			rBox.put("Result_Msg", "접수 완료");
			rBox.put("result", "true");
			rBox.put("list_id", list_id);
			rBox.put("list_type", listDetail.get("list_type"));
			rBox.put("list_type_desc", listDetail.get("list_type_desc"));
			rBox.put("list_status", listDetail.get("list_status"));
			rBox.put("list_status_desc", listDetail.get("list_status_desc"));
			rBox.put("request_date", listDetail.get("request_date"));
			list.add(rBox);
			result = true;
			connPLM.commit();
			//메일보내기 
			String err_code = stxTbcItemMailing(connPLM,list_id,"approve");
			if(!err_code.equals("OK")){
				rBox.put("Result_Msg", "메일 전송 오류");
				rBox.put("result", "true");
				connPLM.commit();
				result = true;
				list.add(rBox);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			ex.printStackTrace();
			rBox.put("Result_Msg", "시스템 내부 오류");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	//	관련자 insertRefUser
	public void insertRefUser(Connection conn, Map rowData)throws Exception {
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		cs1 = conn.prepareCall("{call  STX_DIS_INFO_REF_USER_PROC(?, ?, ?, ?, ?)}");
		
		cs1.setString(i++, rowData.get("list_id").toString());
		cs1.setString(i++, rowData.get("print_user_id").toString());
		cs1.setString(i++, rowData.get("user_id").toString());
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.INTEGER);
		
		cs1.execute();
	}
	
	
	//stx_DIS_info_list_approval insert  설계 조달 영업별로 row 하나씩 insert
	public void insertListApproval(Connection conn, RequestBox rBox)throws Exception {
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		cs1 = conn.prepareCall("{call  stx_DIS_list_approval_proc(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
		
		String aprove_comment = rBox.getString("aprove_comment") == null ? "" : rBox.getString("aprove_comment");
		if(aprove_comment.equals("")){
			aprove_comment ="승인 완료";
		}
		cs1.setString(i++, rBox.getString("list_id"));
		cs1.setString(i++, rBox.getString("list_status"));
		cs1.setString(i++, rBox.getString("confirm_type"));
		cs1.setString(i++, rBox.getString("aprove_type"));
		cs1.setString(i++, rBox.getString("aprove_emp_no"));
		cs1.setString(i++, rBox.getString("aprove_comment"));
		cs1.setString(i++, rBox.getString("confirm_flag"));
		cs1.setString(i++, rBox.getString("user_id"));
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.INTEGER);
		
		cs1.execute();
	}
	
	
	//임시저장
	public ArrayList tbcTemporaryStorage(String qryExp, RequestBox rBox)
			throws Exception {
		ArrayList ar = null;
		boolean result = false;

		ArrayList list = new ArrayList();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		
		String list_id	= "";
		Map		chk_approval_list	= new HashMap();
		// 임시저장할 list 가져오기
		java.util.List chmResultList = JsonUtil.toList(rBox.get("chmResultList"));
		java.util.List refUserResultList = JsonUtil.toList(rBox.get("refUserResultList"));
		try {
			list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
			String list_type = rBox.getString("list_type")== null ? "" : rBox.getString("list_type").toString();
			//처음 입력시 list_id 값을 받아서 stx_DIS_info_list
			if(list_id.equals("")){
				//list_id 얻어오기
				list_id = getListId(connPLM, rBox);
				rBox.put("list_id", list_id);
				//stx_DIS_info_list insert
				insertInfoList(connPLM, rBox);
				
			}else{
				insertInfoList(connPLM,rBox);
			}
			//catalog 등록시 
			if(list_type.equals("01")){
				//stx_DIS_info_list_catalog insert
				for (int i = 0; i < chmResultList.size(); i++) {
					Map rowData = (Map) chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
					if(rowid.equals("")){
						insertInfoListCatalog(connPLM, rowData);
					}else{
						updateInfoCatalog(connPLM,rowData);
					}
				}
			}
			//item 등록 시
			else if(list_type.equals("02")){
				//stx_DIS_info_list_catalog insert
				for (int i = 0; i < chmResultList.size(); i++) {
					Map rowData = (Map) chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
					if(rowid.equals("")){
						insertInfoListItem(connPLM, rowData);
					}else{
						updateInfoItem(connPLM,rowData);
					}
				}
			}
//			stx_DIS_info_list_approval insert  설계 조달 영업별로 row 하나씩 insert (최대 5개 부서)
			String grantor_dept0 = rBox.getString("grantor_dept0") == null ? "" : rBox.getString("grantor_dept0").toString();
			String grantor_dept1 = rBox.getString("grantor_dept1") == null ? "" : rBox.getString("grantor_dept1").toString();
			String grantor_dept2 = rBox.getString("grantor_dept2") == null ? "" : rBox.getString("grantor_dept2").toString();
			String grantor_dept3 = rBox.getString("grantor_dept3") == null ? "" : rBox.getString("grantor_dept3").toString();
			String grantor_dept4 = rBox.getString("grantor_dept4") == null ? "" : rBox.getString("grantor_dept4").toString();
			
			
			rBox.put("confirm_type", "01");
			rBox.put("confirm_flag", "N");
			if(!grantor_dept0.equals("")){
			rBox.put("aprove_type", grantor_dept0);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp0"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment0"));
			insertListApproval(connPLM,rBox);
			}
			if(!grantor_dept1.equals("")){
			rBox.put("aprove_type", grantor_dept1);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp1"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment1"));
			insertListApproval(connPLM,rBox);
			}
			
			if(!grantor_dept2.equals("")){
			rBox.put("aprove_type", grantor_dept2);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp2"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment2"));
			insertListApproval(connPLM,rBox);
			}
			
			if(!grantor_dept3.equals("")){
			rBox.put("aprove_type", grantor_dept3);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp3"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment3"));
			insertListApproval(connPLM,rBox);
			}
			
			if(!grantor_dept4.equals("")){
			rBox.put("aprove_type", grantor_dept4);
			rBox.put("aprove_emp_no", rBox.getString("grantor_emp4"));
			rBox.put("aprove_comment", rBox.getString("grantor_comment4"));
			insertListApproval(connPLM,rBox);
			}
			
			//관련자 insert
			for (int i = 0; i < refUserResultList.size(); i++) {
				Map rowData = (Map) refUserResultList.get(i);
				rowData.put("list_id", list_id);
				rowData.put("user_id", rBox.getString("user_id"));
				String rowid = rowData.get("rowid")== null ? "" : rowData.get("rowid").toString();
				insertRefUser(connPLM,rowData);
			}
			
			
			
			
			Map listDetail=selectDetail(connPLM,rBox);
			rBox.put("Result_Msg", "Success");
			rBox.put("result", "true");
			rBox.put("list_id", list_id);
			rBox.put("list_type", listDetail.get("list_type"));
			rBox.put("list_type_desc", listDetail.get("list_type_desc"));
			rBox.put("list_status", listDetail.get("list_status"));
			rBox.put("list_status_desc", listDetail.get("list_status_desc"));
			rBox.put("request_date", listDetail.get("request_date"));
			list.add(rBox);
			result = true;
			connPLM.commit();
		} catch (Exception ex) {
			ex.printStackTrace();
			ex.printStackTrace();
			rBox.put("Result_Msg", "Fail");
			rBox.put("result", "false");
			connPLM.rollback();
			result = false;
			list.add(rBox);
		}

		return list;
	}
	
	public int updateInfoItem(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append(" UPDATE stx_DIS_info_list_item \n");
		query.append("    SET PART_NO      = '"+rowData.get("part_no")+"' \n");
		query.append("      , DESCRIPTION  = '"+rowData.get("description")+"' \n");
		query.append("      , WEIGHT       = '"+rowData.get("weight")+"'  \n");
		query.append("      , UOM          = '"+rowData.get("uom")+"' \n");
		query.append("      , ATTR00       = '"+rowData.get("attr00")+"' \n");
		query.append("      , ATTR01       = '"+rowData.get("attr01")+"' \n");
		query.append("      , ATTR02       = '"+rowData.get("attr02")+"' \n");
		query.append("      , ATTR03       = '"+rowData.get("attr03")+"' \n");
		query.append("      , ATTR04       = '"+rowData.get("attr04")+"' \n");
		query.append("      , ATTR05       = '"+rowData.get("attr05")+"' \n");
		query.append("      , ATTR06       = '"+rowData.get("attr06")+"' \n");
		query.append("      , ATTR07       = '"+rowData.get("attr07")+"' \n");
		query.append("      , ATTR08       = '"+rowData.get("attr08")+"' \n");
		query.append("      , ATTR09       = '"+rowData.get("attr09")+"' \n");
		query.append("      , ATTR10       = '"+rowData.get("attr10")+"' \n");
		query.append("      , ATTR11       = '"+rowData.get("attr11")+"' \n");
		query.append("      , ATTR12       = '"+rowData.get("attr12")+"' \n");
		query.append("      , ATTR13       = '"+rowData.get("attr13")+"' \n");
		query.append("      , ATTR14       = '"+rowData.get("attr14")+"' \n");
		query.append("      , CABLE_OUTDIA = '"+rowData.get("cable_outdia")+"' \n");
		query.append("      , CABLE_SIZE   = '"+rowData.get("cable_size")+"' \n");
		query.append("      , STXSVR       = '"+rowData.get("stxsvr")+"' \n");
		query.append("      , THINNER_CODE = '"+rowData.get("thinner_code")+"' \n");
		query.append("      , PAINT_CODE   = '"+rowData.get("paint_code")+"' \n");
		query.append("      , CABLE_TYPE   = '"+rowData.get("cable_type")+"' \n");
		query.append("      , CABLE_LENGTH = '"+rowData.get("cable_length")+"' \n");
		query.append("      , STXSTANDARD  = '"+rowData.get("stxstandard")+"' \n");
		query.append("  WHERE 1            = 1  \n");
		query.append("    AND \n");
		query.append("        rowid = '"+rowData.get("rowid")+"' \n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();

			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return result;
	}
	
	public int updateInfoCatalog(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append(" UPDATE stx_DIS_info_list_catalog \n");
		query.append("    SET catalog           = '"+rowData.get("catalog")+"' \n");
		query.append("      , category          = '"+rowData.get("category")+"' \n");
		query.append("      , description       = '"+rowData.get("description")+"' \n");
		query.append("      , uom               = '"+rowData.get("uom")+"' \n");
		query.append("      , attibute_01       = '"+rowData.get("attibute_01")+"' \n");
		query.append("      , attibute_02       = '"+rowData.get("attibute_02")+"' \n");
		query.append("      , attibute_03       = '"+rowData.get("attibute_03")+"' \n");
		query.append("      , attibute_04       = '"+rowData.get("attibute_04")+"' \n");
		query.append("      , attibute_05       = '"+rowData.get("attibute_05")+"' \n");
		query.append("      , attibute_06       = '"+rowData.get("attibute_06")+"' \n");
		query.append("      , attibute_07       = '"+rowData.get("attibute_07")+"' \n");
		query.append("      , attibute_08       = '"+rowData.get("attibute_08")+"' \n");
		query.append("      , attibute_09       = '"+rowData.get("attibute_09")+"' \n");
		query.append("      , attibute_10       = '"+rowData.get("attibute_10")+"' \n");
		query.append("      , attibute_11       = '"+rowData.get("attibute_11")+"' \n");
		query.append("      , attibute_12       = '"+rowData.get("attibute_12")+"' \n");
		query.append("      , attibute_13       = '"+rowData.get("attibute_13")+"' \n");
		query.append("      , attibute_14       = '"+rowData.get("attibute_14")+"' \n");
		query.append("      , attibute_15       = '"+rowData.get("attibute_15")+"' \n");
		query.append("      , po_request_type   = '"+rowData.get("po_request_type")+"' \n");
		query.append("      , po_delegate_item  = '"+rowData.get("po_delegate_item")+"' \n");
		query.append("      , vendor_drawing_no = '"+rowData.get("vendor_drawing_no")+"' \n");
		query.append("      , bom_create_date   = '"+rowData.get("bom_create_date")+"' \n");
		query.append("      , level_01          = '"+rowData.get("level_01")+"' \n");
		query.append("      , level_02          = '"+rowData.get("level_02")+"' \n");
		query.append("      , level_03          = '"+rowData.get("level_03")+"' \n");
//		query.append("      , n_ship_flag       = '"+rowData.get("n_ship_flag")+"' \n");
		query.append("      , tech_spec_flag    = '"+rowData.get("tech_spec_flag")+"' \n");
		query.append("      , ship_type    		= '"+rowData.get("ship_type")+"' \n");
		query.append("      , buyer_emp_no      = '"+rowData.get("buyer_emp_no")+"' \n");
		query.append("      , process_emp_no    = '"+rowData.get("process_emp_no")+"' \n");
		query.append("      , standar_lead_time = '"+rowData.get("standar_lead_time")+"' \n");
		query.append("      , mrp_planning_flag = '"+rowData.get("mrp_planning_flag")+"' \n");
		query.append("      , pegging_flag      = '"+rowData.get("pegging_flag")+"' \n");
		query.append("      , distributor_emp_no= '"+rowData.get("distributor_emp_no")+"' \n");
		query.append("      , f_order_cancel    = '"+rowData.get("f_order_cancel")+"' \n");
		query.append("      , f_order_open      = '"+rowData.get("f_order_open")+"' \n");
		query.append("  WHERE 1                 = 1 \n");
		query.append("    AND \n");
		query.append("        rowid = '"+rowData.get("rowid")+"' \n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();

			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return result;
	}
	
	public Map selectChkApproval(Connection conn,RequestBox rBox) throws Exception{
		ListSet ls = null;
		ArrayList list = null;
		Map resultMap = null;
		PreparedStatement pstmt = null;
		String query = "";
		try {
			list = new ArrayList();
			query = getQuery("selectChkApproval", rBox);

			pstmt = conn.prepareStatement(query.toString());
			// rs = pstmt.execute();
			ls = new ListSet(conn);
			ls.run(pstmt);

			while (ls.next()) {
				resultMap = ls.getDataMap();
				//list.add(resultMap);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return resultMap;
	}
	
	
	public Map selectListApproval(Connection conn,RequestBox rBox) throws Exception{
		ListSet ls = null;
		ArrayList list = null;
		Map resultMap = null;
		PreparedStatement pstmt = null;
		String query = "";
		try {
			list = new ArrayList();
			query = getQuery("selectListApproval", rBox);

			pstmt = conn.prepareStatement(query.toString());
			// rs = pstmt.execute();
			ls = new ListSet(conn);
			ls.run(pstmt);

			while (ls.next()) {
				resultMap = ls.getDataMap();
				//list.add(resultMap);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return resultMap;
	}
	
	
	
	public Map selectDetail(Connection conn,RequestBox rBox) throws Exception{
		ListSet ls = null;
		ArrayList list = null;
		Map resultMap = null;
		PreparedStatement pstmt = null;
		String query = "";
		try {
			list = new ArrayList();
			query = getQuery("selectDetail", rBox);

			pstmt = conn.prepareStatement(query.toString());
			// rs = pstmt.execute();
			ls = new ListSet(conn);
			ls.run(pstmt);

			while (ls.next()) {
				resultMap = ls.getDataMap();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return resultMap;
	}
	public int insertInfoListItem(Connection conn, Map rowData)throws Exception {
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO stx_DIS_info_list_item \n");
		query.append("        ( \n");
		query.append("                LIST_ID \n");
		query.append("              , PART_NO \n");
		query.append("              , DESCRIPTION \n");
		query.append("              , WEIGHT \n");
		query.append("              , UOM \n");
		query.append("              , ATTR00 \n");
		query.append("              , ATTR01 \n");
		query.append("              , ATTR02 \n");
		query.append("              , ATTR03 \n");
		query.append("              , ATTR04 \n");
		query.append("              , ATTR05 \n");
		query.append("              , ATTR06 \n");
		query.append("              , ATTR07 \n");
		query.append("              , ATTR08 \n");
		query.append("              , ATTR09 \n");
		query.append("              , ATTR10 \n");
		query.append("              , ATTR11 \n");
		query.append("              , ATTR12 \n");
		query.append("              , ATTR13 \n");
		query.append("              , ATTR14 \n");
		query.append("              , CABLE_OUTDIA \n");
		query.append("              , CABLE_SIZE \n");
		query.append("              , STXSVR \n");
		query.append("              , THINNER_CODE \n");
		query.append("              , PAINT_CODE \n");
		query.append("              , CABLE_TYPE \n");
		query.append("              , CABLE_LENGTH \n");
		query.append("              , STXSTANDARD \n");
		query.append("        ) \n");
		query.append("        VALUES \n");
		query.append("        ( \n");
		query.append("                 "+rowData.get("list_id")+" \n");
		query.append("              , '"+rowData.get("part_no")+"' \n");
		query.append("              , '"+rowData.get("description")+"' \n");
		query.append("              , '"+rowData.get("weight")+"' \n");
		query.append("              , '"+rowData.get("uom")+"' \n");
		query.append("              , '"+rowData.get("attr00")+"' \n");
		query.append("              , '"+rowData.get("attr01")+"' \n");
		query.append("              , '"+rowData.get("attr02")+"' \n");
		query.append("              , '"+rowData.get("attr03")+"' \n");
		query.append("              , '"+rowData.get("attr04")+"' \n");
		query.append("              , '"+rowData.get("attr05")+"' \n");
		query.append("              , '"+rowData.get("attr06")+"' \n");
		query.append("              , '"+rowData.get("attr07")+"' \n");
		query.append("              , '"+rowData.get("attr08")+"' \n");
		query.append("              , '"+rowData.get("attr09")+"' \n");
		query.append("              , '"+rowData.get("attr10")+"' \n");
		query.append("              , '"+rowData.get("attr11")+"' \n");
		query.append("              , '"+rowData.get("attr12")+"' \n");
		query.append("              , '"+rowData.get("attr13")+"' \n");
		query.append("              , '"+rowData.get("attr14")+"' \n");
		query.append("              , '"+rowData.get("cable_outdia")+"' \n");
		query.append("              , '"+rowData.get("cable_size")+"' \n");
		query.append("              , '"+rowData.get("stxsvr")+"' \n");
		query.append("              , '"+rowData.get("thinner_code")+"' \n");
		query.append("              , '"+rowData.get("paint_code")+"' \n");
		query.append("              , '"+rowData.get("cable_type")+"' \n");
		query.append("              , '"+rowData.get("cable_length")+"' \n");
		query.append("				, '"+rowData.get("stxstandard")+"'	 \n");
		query.append("        ) \n");


		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();

			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return result;
	}
	
	public int insertInfoListCatalog(Connection conn, Map rowData)throws Exception {
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO stx_DIS_info_list_catalog \n");
		query.append("        ( \n");
		query.append("                LIST_ID \n");
		query.append("              , CATALOG \n");
		query.append("              , CATEGORY \n");
		query.append("              , DESCRIPTION \n");
		query.append("              , UOM \n");
		query.append("              , ATTIBUTE_01 \n");
		query.append("              , ATTIBUTE_02 \n");
		query.append("              , ATTIBUTE_03 \n");
		query.append("              , ATTIBUTE_04 \n");
		query.append("              , ATTIBUTE_05 \n");
		query.append("              , ATTIBUTE_06 \n");
		query.append("              , ATTIBUTE_07 \n");
		query.append("              , ATTIBUTE_08 \n");
		query.append("              , ATTIBUTE_09 \n");
		query.append("              , ATTIBUTE_10 \n");
		query.append("              , ATTIBUTE_11 \n");
		query.append("              , ATTIBUTE_12 \n");
		query.append("              , ATTIBUTE_13 \n");
		query.append("              , ATTIBUTE_14 \n");
		query.append("              , ATTIBUTE_15 \n");
		query.append("              , PO_REQUEST_TYPE \n");
		query.append("              , PO_DELEGATE_ITEM \n");
		query.append("              , VENDOR_DRAWING_NO \n");
		query.append("              , BOM_CREATE_DATE \n");
		query.append("              , LEVEL_01 \n");
		query.append("              , LEVEL_02 \n");
		query.append("              , LEVEL_03 \n");
//		query.append("              , N_SHIP_FLAG \n");
		query.append("              , TECH_SPEC_FLAG \n");
		query.append("				, SHIP_TYPE	\n");
		query.append("              , BUYER_EMP_NO \n");
		query.append("				, PROCESS_EMP_NO	\n");
		query.append("              , STANDAR_LEAD_TIME \n");
		query.append("              , MRP_PLANNING_FLAG \n");
		query.append("              , PEGGING_FLAG \n");
		query.append("				, DISTRIBUTOR_EMP_NO	\n");
		query.append("				, F_ORDER_CANCEL	\n");
		query.append("				, F_ORDER_OPEN	\n");
		query.append("        ) \n");
		query.append("        VALUES \n");
		query.append("        ( \n");
		query.append("				   " + rowData.get("list_id") + " \n"); // LIST_ID
		query.append("              , '" + rowData.get("catalog") + "' \n"); // CATALOG
		query.append("              , '" + rowData.get("category") + "' \n"); // CATEGORY
		query.append("              , '" + rowData.get("description") + "' \n"); // DESCRIPTION
		query.append("              , '" + rowData.get("uom") + "' \n"); // UOM
		query.append("              , '" + rowData.get("attibute_01") + "' \n"); // ATTR1
		query.append("              , '" + rowData.get("attibute_02") + "' \n"); // ATTR2
		query.append("              , '" + rowData.get("attibute_03") + "' \n"); // ATTR3
		query.append("              , '" + rowData.get("attibute_04") + "' \n"); // ATTR4
		query.append("              , '" + rowData.get("attibute_05") + "' \n"); // ATTR5
		query.append("              , '" + rowData.get("attibute_06") + "' \n"); // ATTR6
		query.append("              , '" + rowData.get("attibute_07") + "' \n"); // ATTR7
		query.append("              , '" + rowData.get("attibute_08") + "' \n"); // ATTR8
		query.append("              , '" + rowData.get("attibute_09") + "' \n"); // ATTR9
		query.append("              , '" + rowData.get("attibute_10") + "' \n"); // ATTR10
		query.append("              , '" + rowData.get("attibute_11") + "' \n"); // ATTR11
		query.append("              , '" + rowData.get("attibute_12") + "' \n"); // ATTR12
		query.append("              , '" + rowData.get("attibute_13") + "' \n"); // ATTR13
		query.append("              , '" + rowData.get("attibute_14") + "' \n"); // ATTR14
		query.append("              , '" + rowData.get("attibute_15") + "' \n"); // ATTR15
		query.append("              , '" + rowData.get("po_request_type")+ "' \n"); // 구매요청기준
		query.append("              , '" + rowData.get("po_delegate_item")+ "' \n"); // 구매요청대표품목코드
		query.append("              , '" + rowData.get("vendor_drawing_no")+ "' \n"); // VENDOR_DRAWING_NO
		query.append("              , '" + rowData.get("bom_create_date")+ "' \n"); // BOM 구성예정
		query.append("              , '" + rowData.get("level_01")+ "' \n"); // 대분류
		query.append("              , '" + rowData.get("level_02")+ "' \n"); // 대중분류
		query.append("              , '" + rowData.get("level_03")+ "' \n"); // SALES
																				// BOM
																				// 재료비예산
																				// 중분류
//		query.append("              , '" + rowData.get("n_ship_flag")+ "' \n"); // 특수선
																					// 여부
		query.append("              , '" + rowData.get("tech_spec_flag")+ "' \n"); // TECH SPEC 품목 여부
		query.append("				, '" + rowData.get("ship_type")+ "'	\n");
		query.append("              , '" + rowData.get("buyer_emp_no")+ "' \n"); // 구매자
		query.append("              , '" + rowData.get("process_emp_no")+ "' \n"); // 공정관리자
		query.append("              , '" + rowData.get("standar_lead_time")+ "' \n"); // 표준 리드타임
		query.append("              , '" + rowData.get("mrp_planning_flag")+ "' \n"); // MRP계획 대상여부
		query.append("              , '" + rowData.get("pegging_flag")+ "' \n"); // 페깅여부
		query.append("              , '" + rowData.get("distributor_emp_no")+ "' \n"); // 물류담당자
		query.append("              , '" + rowData.get("f_order_cancel")+ "' \n"); // F.ORDER(취소)
		query.append("              , '" + rowData.get("f_order_open")+ "' \n"); // F.ORDER(납기)
		query.append("        ) \n");

		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();

			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return result;
	}
	
	public int updateInfoListPromote(Connection conn, RequestBox rBox)throws Exception {
		String list_status = rBox.getString("list_status") == null ? "" : rBox.getString("list_status").toString();
		String user_id	 = rBox.getString("user_id") == null ? "" : rBox.getString("user_id").toString();
		String list_id	 = rBox.getString("list_id") == null ? "" : rBox.getString("list_id").toString();
		String admin_chk	= rBox.getString("admin_chk") == null ? "" : rBox.getString("admin_chk").toString();
		String sub_title	= rBox.getString("sub_title") == null ? "" : rBox.getString("sub_title").toString();
		String request_desc	= rBox.getString("request_desc") == null ? "" : rBox.getString("request_desc").toString();
		
		
		StringBuffer query = new StringBuffer();
		query.append("update  stx_DIS_info_list \n");
		query.append("   set  list_status = '"+list_status+"' \n");
		if(list_status.equals("01")){
		query.append("		 ,confirm_date=''	\n");
		query.append("		 ,feedback_date=''	\n");
		}
		if(list_status.equals("03")){
		query.append("		 ,confirm_date=sysdate	\n");
		}
		if(list_status.equals("04")){
		query.append("		 ,feedback_date=sysdate	\n");
		}
		if(list_status.equals("05")){
		query.append("		 ,complete_date=sysdate	\n");
		}
		if(admin_chk.equals("Y")){
		query.append("		 ,request_title='"+sub_title+"'	\n");
		query.append("		 ,request_desc ='"+request_desc+"'	\n");
		}
		query.append(" where  list_id = '"+list_id+"' \n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();
		
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}
		
		return result;
	}
	
	//메일 프로시저 호출
	public String stxTbcItemMailing(Connection conn,String list_id,String gubun) throws Exception{
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		if(gubun.equals("approve")){
			cs1 = conn.prepareCall("{call  STX_DIS_ITEM_MAILING@"+ERP_DB+" (?, ?, ?)}");
		}
		else{
			cs1 = conn.prepareCall("{call  STX_DIS_ITEM_MAILING_RE@"+ERP_DB+" (?, ?, ?)}");
		}
		
		cs1.setString(i++, list_id);
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		
		cs1.execute();
		
		String err_code = cs1.getString(2)== null ? "" : cs1.getString(2) ;
		String err_msg = cs1.getString(3)== null ? "" : cs1.getString(3) ;
		return err_code;
	}
	
	public int deleteListApproval(Connection conn, RequestBox rBox)throws Exception {
		String list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
		
		StringBuffer query = new StringBuffer();
		query.append("delete 									\n");
		query.append("	from	stx_DIS_info_list_approval  	\n");
		query.append(" where	list_id = '"+list_id+"'      	\n");
		query.append("	 and    process_type in ('04','05')		\n");
		
		StringBuffer updateQuery = new StringBuffer();
		updateQuery.append("update	 stx_DIS_info_list_approval	\n");
		updateQuery.append("   set   confirm_flag = 'N'			\n");
		updateQuery.append("	    ,confirm_date = ''			\n");
		updateQuery.append(" where   list_id = '"+list_id+"'	\n");
		updateQuery.append("   and	 process_type = '02'		\n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		int result = 0;
		int updateResult = 0;
		try {
			list = new ArrayList();
		
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
			
			pstmt2 = conn.prepareStatement(updateQuery.toString());
			updateResult = +pstmt.executeUpdate();
			
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
			if (pstmt2 != null) {try {pstmt2.close();} catch (Exception e) {}}
		}
		
		return result;
	}
	
	//접수나 검토중상태에서 FEEDBACK 상태로 넘어갈때 LIST_APPROVAL 남기기  
	public int insertlistApprovalFeedback(Connection conn, RequestBox rBox)throws Exception {
		String list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
		String user_id = rBox.getString("user_id")== null ? "" : rBox.getString("user_id").toString();
		String list_type = rBox.getString("list_type")== null ? "" : rBox.getString("list_type").toString();
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO STX_DIS_INFO_LIST_APPROVAL \n");
		query.append("        ( \n");
		query.append("                LIST_ID \n");
		query.append("              , PROCESS_TYPE \n");
		query.append("              , CONFIRM_TYPE \n");
		query.append("              , APROVE_TYPE \n");
		query.append("              , CONFIRM_EMP_NO \n");
		query.append("              , CONFIRM_COMMENT \n");
		query.append("              , CONFIRM_FLAG \n");
		query.append("              , CONFIRM_DATE \n");
		query.append("              , LAST_UPDATE_DATE \n");
		query.append("              , LAST_UPDATED_BY \n");
		query.append("              , CREATION_DATE \n");
		query.append("              , CREATED_BY \n");
		query.append("        ) \n");
		query.append(" SELECT '"+list_id+"' \n");
		query.append("      , '04' \n");
		query.append("      , '01' \n");
		query.append("      , '04' \n");
		query.append("      , APROVE_EMP_NO \n");
		query.append("      , 'FEEDBACK' \n");
		query.append("      , 'N' \n");
		query.append("      , '' \n");
		query.append("      , SYSDATE \n");
		query.append("      , '"+user_id+"' \n");
		query.append("      , SYSDATE \n");
		query.append("      , '"+user_id+"' \n");
		query.append("   FROM STX_DIS_INFO_APPROVAL \n");
		query.append("  WHERE APROVE_SIGN = '03' \n");
		query.append("	  AND list_type	  = '"+list_type+"'	\n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();
		
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		
		return result;
	}
	
	//반려할때 승인 테이블에서 반려history에 inset해준다
	public int insertSelectLIST_APPROVAL_HIS(Connection conn, RequestBox rBox)throws Exception {
		String list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
		
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO STX_DIS_INFO_LIST_APPROVAL_HIS \n");
		query.append("        ( \n");
		query.append("                LIST_ID \n");
		query.append("              , RETRUN_DATE \n");
		query.append("              , PROCESS_TYPE \n");
		query.append("              , CONFIRM_TYPE \n");
		query.append("              , APROVE_TYPE \n");
		query.append("              , APROVE_EMP_NO \n");
		query.append("              , APROVE_COMMENT \n");
		query.append("              , CONFIRM_FLAG \n");
		query.append("              , CONFIRM_DATE \n");
		query.append("              , LAST_UPDATE_DATE \n");
		query.append("              , LAST_UPDATED_BY \n");
		query.append("              , CREATION_DATE \n");
		query.append("              , CREATED_BY \n");
		query.append("        ) \n");
		query.append(" SELECT LIST_ID \n");
		query.append("      , SYSDATE \n");
		query.append("      , PROCESS_TYPE \n");
		query.append("      , CONFIRM_TYPE \n");
		query.append("      , APROVE_TYPE \n");
		query.append("      , CONFIRM_EMP_NO \n");
		query.append("      , CONFIRM_COMMENT \n");
		query.append("      , CONFIRM_FLAG \n");
		query.append("      , CONFIRM_DATE \n");
		query.append("      , LAST_UPDATE_DATE \n");
		query.append("      , LAST_UPDATED_BY \n");
		query.append("      , CREATION_DATE \n");
		query.append("      , CREATED_BY \n");
		query.append("   FROM stx_DIS_info_list_approval \n");
		query.append("  WHERE list_id = '"+list_id+"' \n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();
		
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		
		return result;
	}
	//ADMIN 유저가 승인시 기존에 있던 데이터를 HISTORY 테이블에 넣어준다.
	public int insertInfoListHis(Connection conn, RequestBox rBox)throws Exception {
		String list_id = rBox.getString("list_id")== null ? "" : rBox.getString("list_id").toString();
		
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO STX_DIS_INFO_LIST_HIS \n");
		query.append("        ( \n");
		query.append("				  UPDATE_DATE			\n");
		query.append("              , LIST_ID \n");
		query.append("              , LIST_TYPE \n");
		query.append("              , LIST_STATUS \n");
		query.append("              , REQUEST_DEPT_CODE \n");
		query.append("              , REQUEST_EMP_NO \n");
		query.append("              , REQUEST_TITLE \n");
		query.append("              , REQUEST_DESC \n");
		query.append("              , REQUEST_DATE \n");
		query.append("              , CONFIRM_DATE \n");
		query.append("              , FEEDBACK_DATE \n");
		query.append("              , COMPLETE_DATE \n");
		query.append("        ) \n");
		query.append(" SELECT SYSDATE \n");
		query.append("      , LIST_ID \n");
		query.append("      , LIST_TYPE \n");
		query.append("      , LIST_STATUS \n");
		query.append("      , REQUEST_DEPT_CODE \n");
		query.append("      , REQUEST_EMP_NO \n");
		query.append("      , REQUEST_TITLE \n");
		query.append("      , REQUEST_DESC \n");
		query.append("      , REQUEST_DATE \n");
		query.append("      , CONFIRM_DATE \n");
		query.append("      , FEEDBACK_DATE \n");
		query.append("      , COMPLETE_DATE \n");
		query.append("   FROM STX_DIS_INFO_LIST \n");
		query.append("  WHERE list_id = '"+list_id+"' \n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();
		
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		
		return result;
	}
	
	public int updateListApproval(Connection conn, RequestBox rBox)throws Exception {
		String list_status = rBox.getString("list_status") == null ? "" : rBox.getString("list_status").toString();
		String user_id	 = rBox.getString("user_id") == null ? "" : rBox.getString("user_id").toString();
		String aprove_comment = rBox.getString("aprove_comment") == null ? "" : rBox.getString("aprove_comment").toString();
		String confirm_type = rBox.getString("confirm_type") == null ? "" : rBox.getString("confirm_type").toString();
		
		StringBuffer query = new StringBuffer();
		query.append("update  stx_DIS_info_list_approval \n");
		query.append("   set  confirm_type = '"+confirm_type+"' \n");
		query.append("		 ,confirm_comment = '"+aprove_comment+"'	\n");
		query.append("		 ,confirm_flag = 'Y'	\n");
		query.append("		 ,confirm_date = sysdate	\n");
		query.append("		 ,last_update_date = sysdate		\n");
		query.append("		 ,last_updated_by = '"+user_id+"'	\n");
		//query.append("       ,request_dept_code = '"+rBox.getString("dept_code")+"' \n");
		//query.append("       ,request_emp_no = '"+rBox.getString("user_id")+"' \n");
		//query.append("       ,request_date = sysdate \n");
		query.append(" where  list_id = '"+rBox.getString("list_id")+"' \n");
		query.append("	 and  confirm_emp_no = '"+user_id+"'	\n");
		
		ListSet ls = null;
		ArrayList list = null;
		DataBox dbox = null;
		Map resultList = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			list = new ArrayList();
		
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}
		
		return result;
	}
	
	public void insertInfoList(Connection conn, RequestBox rBox)throws Exception {
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		cs1 = conn.prepareCall("{call  STX_DIS_INFO_LIST_PROC(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
		
		cs1.setString(i++, rBox.getString("list_id"));
		cs1.setString(i++, rBox.getString("list_type"));
		cs1.setString(i++, rBox.getString("list_status"));
		cs1.setString(i++, rBox.getString("dept_code"));
		cs1.setString(i++, rBox.getString("user_id"));
		cs1.setString(i++, rBox.getString("request_desc"));
		cs1.setString(i++, rBox.getString("sub_title"));
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.INTEGER);
		
		cs1.execute();
	}

	// 시퀀스 따기
	public String getListId(Connection conn, RequestBox rBox) throws Exception {
		ListSet ls = null;
		PreparedStatement pstmt = null;
		String query 			= "";
		Map resultList 			= null;
		int 	listId 			= 0;
		try {

			query = getQuery("getListId", rBox);
			pstmt = conn.prepareStatement(query.toString());

			ls = new ListSet(conn);
			ls.run(pstmt);

			while (ls.next()) {
				resultList = ls.getDataMap();
				listId = Integer.parseInt(resultList.get("list_id").toString());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {try {ls.close();} catch (Exception e) {}}
			if (pstmt != null) {try {pstmt.close();} catch (Exception e) {}}
		}
		return String.valueOf(listId);
	}

	// 중복 문자열 제거
	private ArrayList removeOverlappedData(ArrayList list) {
		return new ArrayList(new HashSet(list));
	}

	public boolean updateDB(String qryExp, RequestBox rBox) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	private String getQuery(String qryExp, RequestBox box) {
		StringBuffer query = new StringBuffer();
		try {
			if (qryExp.equals("list")) {
				String fromDate = box.getString("fromDate") == null ? "" : box.getString("fromDate").toString();
				String ToDate = box.getString("ToDate") == null ? "" : box.getString("ToDate").toString();
				String p_type = box.getString("p_type") == null ? "" : box.getString("p_type").toString();
				String p_description = box.getString("p_description") == null ? ""	: box.getString("p_description").toString();
				String p_dept = box.getString("p_dept") == null ? "" : box.getString("p_dept").toString();
				String p_state = box.getString("p_state") == null ? "" : box.getString("p_state").toString();
				String p_requestor = box.getString("p_requestor") == null ? "" : box.getString("p_requestor").toString();
				String p_request_title = box.getString("p_request_title") == null ? "" : box.getString("p_request_title").toString();
				
				query.append("select t2.* 																					\n");
				query.append("from (   																						\n");
				query.append("select t1.*  																					\n");
				query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page 								\n");
				query.append("from 																							\n");
				query.append("(  																							\n");
				query.append("SELECT	*										\n");
				query.append("	FROM	stx_DIS_info_list_v						\n");
				query.append(" WHERE	1=1										\n");
				if (!fromDate.equals("")) {
					query.append("	 AND	request_date	>=	'" + fromDate+ "'		\n");
				}
				if (!ToDate.equals("")) {
					query.append("	 AND	request_date	<=	'" + ToDate + "'		\n");
				}
				if (!p_type.equals("")) {
					query.append("	 AND	list_type		=	'" + p_type + "'		\n");
				}
				if (!p_description.equals("")) {
					query.append("	 AND 	description		=	'" + p_description+ "'	\n");
				}
				if (!p_dept.equals("")) {
					query.append("	 AND	dept_name		like '" + p_dept + "%'		\n");
				}
				if (!p_state.equals("")) {
					query.append("	 AND	list_status		=	'" + p_state + "'		\n");
				}
				if (!p_requestor.equals("")) {
					query.append("	 AND	user_name		=	'" + p_requestor + "'	\n");
				}
				if (!p_request_title.equals("")){
					query.append("	 AND	request_title	like	'" + p_request_title + "%'	\n");
				}
				query.append(") t1 																							\n");
				query.append(") t2 																							\n");
				query.append("where page = "+box.getString("page")+" 														\n");
				
			} else if (qryExp.equals("itemTransTotalRecord")){
				String fromDate = box.getString("fromDate") == null ? "" : box.getString("fromDate").toString();
				String ToDate = box.getString("ToDate") == null ? "" : box.getString("ToDate").toString();
				String p_type = box.getString("p_type") == null ? "" : box.getString("p_type").toString();
				String p_description = box.getString("p_description") == null ? ""	: box.getString("p_description").toString();
				String p_dept = box.getString("p_dept") == null ? "" : box.getString("p_dept").toString();
				String p_state = box.getString("p_state") == null ? "" : box.getString("p_state").toString();
				String p_requestor = box.getString("p_requestor") == null ? "" : box.getString("p_requestor").toString();
				String p_request_title = box.getString("p_request_title") == null ? "" : box.getString("p_request_title").toString();
				
				query.append("SELECT	count(*) as cnt							\n");
				query.append("	FROM	stx_DIS_info_list_v						\n");
				query.append(" WHERE	1=1										\n");
				if (!fromDate.equals("")) {
					query.append("	 AND	request_date	>=	'" + fromDate+ "'		\n");
				}
				if (!ToDate.equals("")) {
					query.append("	 AND	request_date	<=	'" + ToDate + "'		\n");
				}
				if (!p_type.equals("")) {
					query.append("	 AND	list_type		=	'" + p_type + "'		\n");
				}
				if (!p_description.equals("")) {
					query.append("	 AND 	description		=	'" + p_description+ "'	\n");
				}
				if (!p_dept.equals("")) {
					query.append("	 AND	dept_name		=	'" + p_dept + "'		\n");
				}
				if (!p_state.equals("")) {
					query.append("	 AND	list_status		=	'" + p_state + "'		\n");
				}
				if (!p_requestor.equals("")) {
					query.append("	 AND	user_name		=	'" + p_requestor + "'	\n");
				}
				if (!p_request_title.equals("")){
					query.append("	 AND	request_title	like	'" + p_request_title + "%'	\n");
				}
			} else if (qryExp.equals("mainListExport")){
				query.append("SELECT	*																					\n");
				query.append("	FROM	stx_DIS_info_list_v																	\n");
				query.append(" WHERE	1=1																					\n");
				query.append("	 AND	request_date	>=	to_char(sysdate-7,'YYYY-MM-DD')									\n");
				query.append("	 AND	request_date	<=	to_char(sysdate,'YYYY-MM-DD')									\n");
			} else if (qryExp.equals("selectWeekList")) {
				query.append("select																\n");
				query.append("			  to_char(sysdate,'yyyy-MM-DD')    as created_date_end		\n");
				query.append("			, to_char(sysdate-7,'yyyy-MM-DD')  as created_date_start	\n");
				query.append("  from 	  dual														\n");
			} else if (qryExp.equals("selectListType")) {
				String list_type = box.getString("list_type") == null ? "" : box.getString("list_type").toString();
				String list_type_desc = box.getString("list_type_desc") == null ? "" : box.getString("list_type_desc").toString();
				query.append("SELECT	 common_code as sb_value		\n");
				query.append("			,common_name as sb_name			\n");
				query.append("  FROM	 stx_DIS_info_code_list			\n");
				query.append(" WHERE	 list_type = '" + list_type_desc + "'	\n");
				query.append(" ORDER BY  sb_value						\n");
			} else if (qryExp.equals("getListId")) {
				query.append("select to_char(stx_DIS_info_list_s.nextval) as list_id from dual	\n");
			} else if (qryExp.equals("selectApproverList")) {
				String list_id = box.getString("list_id") == null ? "" : box.getString("list_id").toString();
				query.append(" SELECT t11.aprove_type \n");
				query.append("      , t12.common_name \n");
				query.append("      , t11.sb_value \n");
				query.append("      , t11.sb_name \n");
				query.append("      , t11.confirm_comment \n");
				query.append("   FROM( SELECT stila.aprove_type \n");
				query.append("              , stila.confirm_emp_no  AS sb_value \n");
				query.append("              , sciu.user_name        AS sb_name \n");
				query.append("              , 1                     AS ORDER_BY \n");
				query.append("              , stila.confirm_comment AS confirm_comment \n");
				query.append("           FROM stx_DIS_info_list_approval stila \n");
				query.append("              , stx_com_insa_user@"+ERP_DB+" sciu \n");
				query.append("          WHERE 1 = 1 \n");
				if(!list_id.equals("")){
				query.append("			 and stila.list_id        = '"+list_id+"'	\n");
				}else{
				query.append("			 and stila.list_id        = 0	\n");
				}
				query.append("            AND \n");
				query.append("                stila.process_type = '02' \n");
				query.append("            AND \n");
				query.append("                stila.confirm_emp_no = sciu.emp_no \n");
				query.append("       \n");
				query.append("      UNION ALL \n");
				query.append("          \n");
				query.append("         SELECT t1.aprove_type \n");
				query.append("              , t1.aprove_emp_no AS sb_value \n");
				query.append("              , t4.user_name     AS sb_name \n");
				query.append("              , 2                AS ORDER_BY \n");
				query.append("              , ''               AS confirm_comment \n");
				query.append("           FROM stx_DIS_info_approval t1 \n");
				query.append("              , stx_DIS_info_code_list t2 \n");
				query.append("              , stx_DIS_info_code_list t3 \n");
				query.append("              , stx_com_insa_user@"+ERP_DB+" t4 \n");
				query.append("          WHERE t1.aprove_type = t2.common_code \n");
				query.append("            AND \n");
				query.append("                t2.list_type = 'APROVE_TYPE' \n");
				query.append("            AND \n");
				query.append("                t1.aprove_sign = t3.common_code \n");
				query.append("            AND \n");
				query.append("                t3.list_type = 'APROVE_SIGN' \n");
				query.append("            AND \n");
				query.append("                t3.common_code = '01' \n");
				query.append("            AND \n");
				query.append("                t1.aprove_emp_no = t4.emp_no \n");
				query.append("            AND \n");
				query.append("                t1.list_type = '"+box.getString("list_type")+"' \n");
				query.append("			  AND t1.enable_flag = 'Y'	\n");
				query.append("            AND \n");
				query.append("                NOT EXISTS \n");
				query.append("                ( SELECT 1 \n");
				query.append("                   FROM stx_DIS_info_list_approval stila \n");
				query.append("                  WHERE 1 = 1 \n");
				if(!list_id.equals("")){
				query.append("			 		  and stila.list_id        = '"+list_id+"'	\n");
				}else{
				query.append("			 		  and stila.list_id        = 0	\n");
				}
				query.append("                    AND \n");
				query.append("                        stila.process_type = '02' \n");
				query.append("                    AND \n");
				query.append("                        stila.aprove_type = t1.aprove_type \n");
				query.append("                    AND \n");
				query.append("                        stila.confirm_emp_no = t1.aprove_emp_no \n");
				query.append("                ) \n");
				query.append("        ) \n");
				query.append("        t11 \n");
				query.append("      , STX_DIS_INFO_CODE_LIST t12 \n");
				query.append("  WHERE t11.aprove_type = t12.common_code \n");
				query.append("    AND \n");
				query.append("        t12.list_type = 'APROVE_TYPE' \n");
				query.append("	  AND t12.attribute_01 = 'Y'	\n");
				query.append("ORDER BY aprove_type \n");
				query.append("      , ORDER_BY \n");
				query.append("      , sb_value \n");

			} else if (qryExp.equals("selectApproverListId")) {
				query.append(" select   \n");
				query.append("        t1.aprove_type  \n");
				query.append("       ,t2.common_name  \n");
				query.append("       ,confirm_comment \n");
				query.append("       ,t1.confirm_emp_no as sb_value \n");
				query.append("       ,t3.user_name      as sb_name  \n");
				query.append("  from stx_DIS_info_list_approval     t1  \n");
				query.append("       ,stx_DIS_info_code_list         t2  \n");
				query.append("       ,stx_com_insa_user@"+ERP_DB+"        t3 \n");
				query.append(" where 1=1  \n");
				query.append("   and t1.aprove_type = t2.common_code  \n");
				query.append("   and t2.list_type = 'APROVE_TYPE'  \n");
				query.append("   and t1.confirm_emp_no = t3.emp_no \n");
				query.append("	 and t1.list_id = '"+box.getString("list_id")+"'	\n");
				query.append("	 and t2.attribute_01 = 'Y'	\n");
				
			} else if (qryExp.equals("selectDetail")){
				query.append(" SELECT to_char(t1.list_id) as list_id \n");
				query.append("      , t1.list_type \n");
				query.append("      , t2.common_name as list_type_desc \n");
				query.append("      , t1.list_status \n");
				query.append("      , t3.common_name as list_status_desc \n");
				query.append("      , to_char(t1.request_date,'YYYY-MM-DD') as request_date \n");
				query.append("		, request_desc	\n");
				query.append("		, request_emp_no	\n");
				query.append("		, t4.user_name	\n");
				query.append("	 	, t1.request_title	\n");
				query.append("   FROM stx_DIS_info_list t1 \n");
				query.append("      , stx_DIS_info_code_list t2 \n");
				query.append("      , stx_DIS_info_code_list t3 \n");
				query.append("		, stx_com_insa_user@"+ERP_DB+" t4 \n");
				query.append("  WHERE t1.list_type = t2.common_code \n");
				query.append("    AND \n");
				query.append("        t2.list_type = 'LIST_TYPE' \n");
				query.append("    AND \n");
				query.append("        t1.list_status = t3.common_code \n");
				query.append("    AND \n");
				query.append("        t3.list_type = 'PROCESS_TYPE' \n");
				query.append("	  AND t1.request_emp_no = t4.emp_no	\n");
				query.append("    AND \n");
				query.append("        t1.list_id = '"+box.getString("list_id")+"' \n");
				
			} else if(qryExp.equals("selectCatalogList")){
				query.append("select a.rowid ,a.*	\n");
				query.append("		,(select user_name from stx_com_insa_user_erp where emp_no = a.buyer_emp_no) as buyer_user_name	\n");
				query.append("		,(select user_name from stx_com_insa_user_erp where emp_no = a.process_emp_no) as process_user_name	\n");
				query.append("  from stx_DIS_info_list_catalog	a	\n");
				query.append(" where list_id = '"+box.getString("list_id")+"'	\n");
			} else if(qryExp.equals("selectItemList")){
				query.append("select a.rowid ,a.*	\n");
				query.append("  from stx_DIS_info_list_item	a	\n");
				query.append(" where list_id = '"+box.getString("list_id")+"'	\n");
			} else if(qryExp.equals("selectListApproval")){
				query.append(" SELECT SUM( \n");
				query.append("        CASE \n");
				query.append("                WHEN t1.confirm_flag = 'N' \n");
				query.append("                THEN 1 \n");
				query.append("                ELSE 0 \n");
				query.append("        END )                 AS cnt \n");
				query.append("      , MAX( t3.list_status ) AS list_status \n");
				query.append("      ,( SELECT t2.attribute_01 \n");
				query.append("           FROM STX_DIS_INFO_CODE_LIST t2 \n");
				query.append("          WHERE 1 = 1 \n");
				query.append("            AND \n");
				query.append("                t2.common_code = '"+box.getString("list_type")+"' \n");
				query.append("            AND \n");
				query.append("                t2.list_type = 'LIST_TYPE' \n");
				query.append("        ) \n");
				query.append("        AS attribute_01 \n");
				query.append("   FROM stx_DIS_info_list_approval t1 \n");
				query.append("      , STX_DIS_INFO_LIST t3 \n");
				query.append("  WHERE t3.list_id = '"+box.getString("list_id")+"' \n");
				query.append("    AND \n");
				query.append("        t1.list_id = t3.list_id \n");
				query.append("	  AND t1.process_type = '02'  \n");
				query.append("GROUP BY t3.list_id \n");
			} else if(qryExp.equals("selectChkApproval")){
				query.append("select	\n");
				query.append("			count(*) as cnt	\n");
				query.append("	from	stx_DIS_info_list_approval	\n");
				query.append(" where	list_id = '"+box.getString("list_id")+"'	\n");
				
			} else if(qryExp.equals("selectApproveListDept")){
				query.append(" SELECT t1.aprove_type \n");
				query.append("      , t2.common_name \n");
				query.append("   FROM STX_DIS_INFO_APPROVAL t1 \n");
				query.append("      , STX_DIS_INFO_CODE_LIST t2 \n");
				query.append("  WHERE 1 = 1 \n");
				query.append("    AND \n");
				query.append("        t1.aprove_type = t2.common_code \n");
				query.append("    AND \n");
				query.append("        t2.list_type = UPPER( 'aprove_type' ) \n");
				query.append("    AND \n");
				query.append("        t1.list_type = '"+box.getString("list_type")+"' --parameter \n");
				query.append("    AND \n");
				query.append("        t1.aprove_sign = '01' --hard \n");
				query.append("GROUP BY t1.aprove_type \n");
				query.append("      , t2.common_name \n");

			} else if(qryExp.equals("selectConfirmList")){
				query.append("select	confirm_flag	\n");
				query.append("	from	stx_DIS_info_list_approval	\n");
				query.append(" where	list_id = "+box.getString("list_id")+"	\n");
				query.append("	 and 	confirm_emp_no = '"+box.getString("user_id")+"'	\n");
				query.append(" group by confirm_flag	\n");
			} else if(qryExp.equals("selectApproveListDeptComment")){
				query.append("select  \n");
				query.append("        t1.aprove_type \n");
				query.append("       ,t2.common_name \n");
				query.append("       ,confirm_comment \n");
				query.append("  from stx_DIS_info_list_approval     t1 \n");
				query.append("       ,stx_DIS_info_code_list         t2 \n");
				query.append(" where 1=1 \n");
				query.append("   and t1.aprove_type = t2.common_code \n");
				query.append("   and t2.list_type = 'APROVE_TYPE' \n");
				query.append("   and t1.list_id = '"+box.getString("list_id")+"' \n");

			} else if(qryExp.equals("selectInfoList")){
				query.append("select *	\n");
				query.append("	from stx_DIS_info_list_v	\n");
				query.append(" where list_id = '"+box.getString("list_id")+"'	\n");
			} else if(qryExp.equals("selectRefUser")){
				query.append("select ref_emp_no as print_user_id  \n");
				query.append("       ,t2.user_name as print_user_name \n");
				query.append("  from STX_DIS_INFO_LIST_REF_USER t1 \n");
				query.append("       ,stx_com_insa_user@"+ERP_DB+"  t2 \n");
				query.append(" where t1.ref_emp_no = t2.emp_no \n");
				query.append("	 and t1.list_id = '"+box.getString("list_id")+"'	\n");
			} else if(qryExp.equals("selectAdminUser")){
				query.append("select *	\n");
				query.append("	from STX_DIS_INFO_CODE_LIST	\n");
				query.append(" where list_type = 'ADMIN_USER'	\n");
			} else if(qryExp.equals("selectDocList")){
				String list_id = box.getString("list_id") == null ? "" : box.getString("list_id").toString();
				query.append("select *	\n");
				query.append("	from STX_DIS_INFO_DOC	\n");
				query.append(" where list_id = '"+list_id+"'	\n");
			} else if(qryExp.equals("ExcelList")){
				String fromDate = box.getString("fromDate") == null ? "" : box.getString("fromDate").toString();
				String ToDate = box.getString("ToDate") == null ? "" : box.getString("ToDate").toString();
				String p_type = box.getString("p_type") == null ? "" : box.getString("p_type").toString();
				String p_description = box.getString("p_description") == null ? ""	: box.getString("p_description").toString();
				String p_dept = box.getString("p_dept") == null ? "" : box.getString("p_dept").toString();
				String p_state = box.getString("p_state") == null ? "" : box.getString("p_state").toString();
				String p_requestor = box.getString("p_requestor") == null ? "" : box.getString("p_requestor").toString();
				String p_request_title = box.getString("p_request_title") == null ? "" : box.getString("p_request_title").toString();
				
				query.append("SELECT	*										\n");
				query.append("	FROM	stx_DIS_info_list_v						\n");
				query.append(" WHERE	1=1										\n");
				if (!fromDate.equals("")) {
					query.append("	 AND	request_date	>=	'" + fromDate+ "'		\n");
				}
				if (!ToDate.equals("")) {
					query.append("	 AND	request_date	<=	'" + ToDate + "'		\n");
				}
				if (!p_type.equals("")) {
					query.append("	 AND	list_type		=	'" + p_type + "'		\n");
				}
				if (!p_description.equals("")) {
					query.append("	 AND 	description		=	'" + p_description+ "'	\n");
				}
				if (!p_dept.equals("")) {
					query.append("	 AND	dept_name		=	'" + p_dept + "'		\n");
				}
				if (!p_state.equals("")) {
					query.append("	 AND	list_status		=	'" + p_state + "'		\n");
				}
				if (!p_requestor.equals("")) {
					query.append("	 AND	user_name		=	'" + p_requestor + "'	\n");
				}
				if (!p_request_title.equals("")){
					query.append("	 AND	request_title	like	'" + p_request_title + "%'	\n");
				}
			} else if(qryExp.equals("catalogExcelPrint")){
				String list_id = box.getString("list_id") == null ? "" : box.getString("list_id").toString();
				
				query.append("select a.rowid ,a.*	\n");
				query.append("		,(select user_name from stx_com_insa_user_erp where emp_no = a.buyer_emp_no) as buyer_user_name	\n");
				query.append("		,(select user_name from stx_com_insa_user_erp where emp_no = a.process_emp_no) as process_user_name	\n");
				query.append("  from stx_DIS_info_list_catalog	a	\n");
				query.append(" where list_id = '"+list_id+"'	\n");
				
			} else if(qryExp.equals("itemExcelPrint")){
				String list_id = box.getString("list_id") == null ? "" : box.getString("list_id").toString();
				query.append("SELECT *	\n");
				query.append("	FROM STX_DIS_INFO_LIST_ITEM	\n");
				query.append(" WHERE LIST_ID = '"+list_id+"'	\n");
			} else if(qryExp.equals("userSearchList")){
				String deptName = box.getString("deptName") == null ? "" : box.getString("deptName").toString();
				String userName = box.getString("userName") == null ? "" : box.getString("userName").toString();
				
				query.append("SELECT SCIU.EMP_NO AS PRINT_USER_ID \n");
				query.append("      ,SCIU.USER_NAME AS PRINT_USER_NAME \n");
				query.append("      ,SCIU.EP_MAIL || '@onestx.com' AS EMAIL \n");
				query.append("      ,SDD.DEPT_NAME AS PRINT_DEPT_NAME \n");
				query.append("      ,SCIU.DEPT_NAME AS INSA_DEPT_NAME \n");
				query.append("      ,SDD.DEPT_ID AS PRINT_DEPT_ID \n");
				query.append("      ,'사내' AS USER_TYPE \n");
				query.append(" FROM STX_COM_INSA_USER@"+ERP_DB+"    SCIU \n");
				query.append("     ,STX_DWG_DEPT_MAPPING@"+ERP_DB+" SDDM \n");
				query.append("     ,STX_DWG_DEPT_MANAGER@"+ERP_DB+" SDD \n");
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
			} else if(qryExp.equals("modifyView")){
				query.append("select * from dual	\n");
			} else if(qryExp.equals("selectGrantorChk")){
				String list_id = box.getString("list_id") == null ? "" : box.getString("list_id").toString();
				String user_id = box.getString("user_id") == null ? "" : box.getString("user_id").toString();
				query.append("select count(*) as cnt   						\n");
				query.append("  from stx_DIS_info_list_approval				\n");
				query.append(" where LIST_ID = '"+list_id+"'					\n");
				query.append("	 and process_type = '02' 					\n");
				query.append("	 and confirm_emp_no = '"+user_id+"'			\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();

	}

	public String quoteReplace(String str) {
		String temp = "";
		temp = str.replaceAll("\"", "\\\"");
		// temp=str.replaceAll("'", "\\\\u0027");
		temp = str.replaceAll("'", "''");

		return temp;
	}
}