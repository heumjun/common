package com.stx.tbc.dao;

import java.sql.CallableStatement;
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
import com.stx.common.util.JsonUtil;
import com.stx.tbc.dao.factory.Idao;

public class TbcDwgMainDao implements Idao{

	public ArrayList selectDB(String qryExp, RequestBox rBox) throws Exception {
		
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		conn.setAutoCommit(false);

        ListSet             ls      	= null;
        ArrayList           list    	= null; 
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		
			try 
	        { 
				if(qryExp.equals("list")){
					String cnt=(String) queryForOne(qryExp,rBox);
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
				}else if(rBox.getString("p_process").equals("receiverCheck")){
					list=(ArrayList) receiverCheck(conn,rBox);
				}else{
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
	public boolean requiredDWG(Connection conn, RequestBox rBox) throws Exception{
		
		boolean result = false;
		int		insertCnt = 0;
		int		insertDetailCnt = 0;
		int		updateCnt = 0;
		int		listSize  = 0;
		Connection	connPLM = null;
		ArrayList sendlist	= null;
		String frommail = (String)rBox.get("userList");
		StringBuffer pro_no = new StringBuffer();
		
		//요청보낼 도면 list 가져오기
		java.util.List requiredDWGList = JsonUtil.toList(rBox.get("chmResultList"));
		String dept = rBox.get("dept");
		
		
		try{
			connPLM = DBConnect.getDBConnection("PLM");
			connPLM.setAutoCommit(false);
			Map mailSendSeq = getDwgMailSendSeq(connPLM,rBox);
			String mailSendFrontSeq = mailSendSeq.get("seq").toString();
			String dwgMailSendSeq 	= mailSendFrontSeq;
			
			for(int i=0;i<requiredDWGList.size();i++)
			{
//				시퀀스 따기(YYMMDD9SEQ(140610A001))
				Map reqSeq = getDwgTransSeq(connPLM,rBox);
				
				
				String del_dwg_seq_id = (String)rBox.get("del_dwg_seq_id");
				StringBuffer sb = new StringBuffer();
				String dwg_seq_id[] = null;
				sb.append(del_dwg_seq_id.split(","));
				if(!del_dwg_seq_id.equals("") || del_dwg_seq_id==null){
					dwg_seq_id = del_dwg_seq_id.split(",");
				}
				String dwgTransSeq = (String)reqSeq.get("eco_no");
				String userList = (String)rBox.get("userList");
				
				String grantor = (String)rBox.get("grantor");
				String reqdept = (String)rBox.get("dept");
				String reqSabun = userList.substring(userList.indexOf("^")+1, userList.lastIndexOf("^"));
				
				Map rowData = (Map) requiredDWGList.get(i);
				//메일 지정자가 있는지 확인하기.
				Map receiver_id = selectECO_RECEIVER(conn,rowData,rBox);
				pro_no.append(rowData.get("shp_no")+"-"+rowData.get("dwg_no")+",");
				rowData.put("dept", dept);
				
				//요청 보낼 도면의 도면 list 가져오기 if(return의 경우 returnChk 가 체크되서 전Rev 도면 요청과 같은 도면을 요청하고 싶을 경우 조건 'R' 추가
				if(rowData.get("returnChk").equals("Y")){
					sendlist = selectDwgReturnInfo(rowData,rBox);
				}else{
					sendlist = dwgMailContentList(rowData,rBox); 
					//요청 보내지 않을 도면 list에서 제외 및 302tbl update trans_plm - > null
					if(dwg_seq_id!=null){
						for(int j=0;j<dwg_seq_id.length;j++){
							int delDwg = Integer.parseInt(dwg_seq_id[j]);
							for(int k=0;k<sendlist.size();k++){
								Map rowData2 = (Map)sendlist.get(k);
								String ccc =  rowData2.get("dwg_seq_id").toString();
								
								float bbb = Float.parseFloat(ccc);
								
								if(delDwg==bbb){
									sendlist.remove(k);
									updateRequiredNull(conn,delDwg);
									break;
								}
							}
						}
					}
				}
				//list를 요청 테이블에 insert 및 302테이블에 S로 UPDATE
				listSize = listSize + sendlist.size();
				rowData.put("dwgTransSeq", dwgTransSeq);
				rowData.put("reqSabun", reqSabun);
				rowData.put("grantor", grantor);
				rowData.put("reqdept", reqdept);
				rowData.put("mail_receiver", rowData.get("radioChk"));
				
				String receiverId = "";
				if(receiver_id !=null ){
					//메일 지정자가 있을경우 ECO UPDATE
					receiverId  = receiver_id.get("receiver_id").toString();
					rowData.put("receiver_id", receiverId);
					updateReceiverECO(conn,rowData);
				}else{
					rowData.put("receiver_id", receiverId);
				}
				
				
				
				
				rowData.put("resSabun",rBox.getString("grantor"));
				rowData.put("dwgMailSendSeq", dwgMailSendSeq);
				//요청 도면을 stx_tbc_dwg_trans 에 입력
				insertCnt=insertCnt+insertDwgTrans(connPLM,rowData);
				for(int j=0;j<sendlist.size();j++){
					Map rowData2 = (Map) sendlist.get(j);
					rowData2.put("dwgTransSeq", dwgTransSeq);
					rowData2.put("dwgMailSendSeq", dwgMailSendSeq);
					insertDetailCnt=insertDetailCnt+insertDwgTransDetail(connPLM,rowData2);
					updateCnt=updateCnt+updateRequiredDWG(conn,rowData2);
				}
			}
			
			//승인자 메일 구하기
			Map eMail = select_grantor_epMail(conn,rBox);
			String to = eMail.get("ep_mail")+"@onestx.com";
			String from = rBox.getString("required_user");
			//rBox.put("to",eMail.get("ep_mail")+"@onestx.com");
			
			
			
			if((requiredDWGList.size()==insertCnt)&&(listSize==updateCnt)&&(listSize==insertDetailCnt)){
//				요청자에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,from,from);
				//승인자에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,from,to);
				//양동협대리에게 한통
				stxTbcDwgMailing(connPLM,dwgMailSendSeq,from,"donghyupyang@onestx.com");
				connPLM.commit();
				conn.commit();
				result = true;
			}else{
				connPLM.rollback();
				conn.rollback();
			}
			
			
			
			
		}catch(Exception e){
			connPLM.rollback();
			conn.rollback();
			System.out.println(e.getMessage());
		}finally 
        { 
            if ( conn != null ) { try { conn.close(); } catch ( Exception e ) { } }
            if ( connPLM != null ) { try { connPLM.close(); } catch ( Exception e ) { } }
        }
		return result;
	}
	public Map selectECO_RECEIVER(Connection conn,Map rowData,RequestBox rBox) throws Exception{
		ListSet             ls      	= null;
        ArrayList           list    	= null; 
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		try 
        { 
			
			conn = DBConnect.getDBConnection("ERP_APPS"); 
			
            list = new ArrayList();
            query  = getQuery("selectReceiverId",rowData,rBox);           
            
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
	
	
	public void stxTbcDwgMailing(Connection conn,String dwgMailSendSeq,String from,String to) throws Exception{
		ListSet             ls      	= null;
        ArrayList           list    	= new ArrayList();
        DataBox             dbox    	= null;
        Map					resultList	= null;
        int					i			= 1;
		CallableStatement cs1 = null;
		cs1 = conn.prepareCall("{call  STX_TBC_DWG_MAILING (?, ?, ?, ?, ?, ?)}");
		
		cs1.setString(i++, dwgMailSendSeq);
		cs1.setString(i++, "required");
		cs1.setString(i++, from);
		cs1.setString(i++, to);
		cs1.registerOutParameter(i++, java.sql.Types.VARCHAR);
		cs1.registerOutParameter(i++, java.sql.Types.INTEGER);
		
		cs1.execute();
	}
	
	//	시퀀스 따기
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
	
	//시퀀스 따기(YYMMDD9SEQ(1406109001))
	public Map getDwgTransSeq(Connection conn, RequestBox rBox) throws Exception{
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	ResultSet			rs 			= null;
    	Map					resultList	= null;
    	  try 
          {
    		  
              query  = getQuery("getDwgTransSeq",rBox);           
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
	public ArrayList selectDwgReturnInfo(Map rowData,RequestBox rBox) throws Exception {
		ListSet             ls      	= null;
        ArrayList           list    	= null; 
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	Connection conn     = null;
		try 
        { 
			
			conn = DBConnect.getDBConnection("ERP_APPS"); 
			
            list = new ArrayList();
            query  = getQuery("selectDwgReturnInfo",rowData,rBox);           
            
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
	
	public ArrayList dwgMailContentList(Map rowData,RequestBox rBox) throws Exception {
		ListSet             ls      	= null;
        ArrayList           list    	= null; 
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
    	Connection conn     = null;
		try 
        { 
			
			conn = DBConnect.getDBConnection("ERP_APPS"); 
			
            list = new ArrayList();
            query  = getQuery("dwgMailContentList",rowData,rBox);           
            
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
	//총 레코드 숫자 구해오기
	public Object queryForOne(String qryExp, RequestBox rBox)	throws Exception {
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
		//		required 요청시 
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		conn.setAutoCommit(false);
		boolean result = false;
		if(rBox.getString("p_process").equals("required")){
			result=(boolean) requiredDWG(conn,rBox);
		}
		return result;
	}
public ArrayList receiverCheck(Connection conn, RequestBox rBox) throws Exception{
		
		Map result = new HashMap();
		ArrayList list		= new ArrayList();
		String dwg_no = "|";
		java.util.List requiredDWGList = JsonUtil.toList(rBox.get("chmResultList"));
		
		try{
			//호선 도면 revision 으로 receiver가 지정되있는지 가져와서 도면이 초도인경우엔 수신자 지정 불필요, 초도가 아닐경우엔 not required or 수신자 지정이 꼭 필요
			for(int i=0;i<requiredDWGList.size();i++)
			{
				Map rowData = (Map)requiredDWGList.get(i);
				ArrayList receiverList = selectReceiverUser(rowData,rBox);
				String radioChk = rowData.get("radioChk") == null ? "" : rowData.get("radioChk").toString();
				if(!rowData.get("dwg_rev").equals("00") && !rowData.get("dwg_rev").equals("0A") ){
					if(radioChk.equals("") && receiverList.size()==0){
						result.put("result", "success");
						dwg_no += " "+rowData.get("dwg_no")+"-"+rowData.get("dwg_rev")+" |";
					}
				}
				
			}
			result.put("dwg_no", dwg_no);
			list.add(result);
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
		return list;
	}
	
	public ArrayList selectReceiverUser(Map rowData,RequestBox rBox) throws Exception{
		Connection conn     = null;
		conn = DBConnect.getDBConnection("ERP_APPS");
		conn.setAutoCommit(false);

        ListSet             ls      	= null;
        ArrayList           list    	= null; 
        Map					resultList	= null;
        PreparedStatement 	pstmt 		= null;
    	String 				query 		= "";
		
			try 
	        { 
	    	
	            list = new ArrayList();
	            query  = getQuery("receiverCheck",rowData,rBox);           
	            
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
	
	public int updateReceiverECO(Connection conn,Map rowData) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update stx_dwg_eco_receiver \n");
		query.append("set eco_no = '"+rowData.get("dwgTransSeq")+"' \n");
		query.append("where 1=1 \n");
		query.append("and receiver_id = "+rowData.get("receiver_id"));
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
		int					result		= 0;
			try 
	        { 
				pstmt = conn.prepareStatement(query.toString());
	            result=pstmt.executeUpdate();
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
	
	
	public int insertDwgTransDetail(Connection conn, Map rowData2)throws Exception{
		StringBuffer insertQuery = new StringBuffer();
		insertQuery.append("INSERT INTO STX_TBC_DWG_TRANS_DETAIL \n");
		insertQuery.append("( \n");
		insertQuery.append("REQ_SEQ        \n");
		insertQuery.append(",REQ_DWG_SEQ_ID \n");
		insertQuery.append(",DWG_MAIL_SEND_SEQ \n");
		insertQuery.append(") \n");
		insertQuery.append("VALUES (?,?,?) \n");
		
        ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
		int					result		= 0;
		int 				i			= 1;
			try 
	        {
				pstmt = conn.prepareStatement(insertQuery.toString());
				pstmt.setString(i++, (String)rowData2.get("dwgTransSeq"));
				pstmt.setString(i++, (rowData2.get("dwg_seq_id").toString()));
				pstmt.setString(i++, (String)rowData2.get("dwgMailSendSeq"));
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
	
	public int insertDwgTrans(Connection conn, Map rowData)throws Exception{
		StringBuffer insertQuery = new StringBuffer();
		insertQuery.append("INSERT INTO STX_TBC_DWG_TRANS \n");
		insertQuery.append("( \n");
		insertQuery.append("REQ_SEQ        \n");
		insertQuery.append(",REQ_STATE \n");
		insertQuery.append(",REQ_SABUN \n");
		insertQuery.append(",REQ_DATE              \n");
		insertQuery.append(",REQ_DEPT              \n");
		insertQuery.append(",RES_SABUN                \n");
		insertQuery.append(",RES_DATE               \n");
		insertQuery.append(",MAIL_CHECK           \n");
		insertQuery.append(",ERP_TRANS         \n");
		insertQuery.append(",CREATED_BY \n");
		insertQuery.append(",CREATION_DATE \n");
		insertQuery.append(",LAST_UPDATED_BY \n");
		insertQuery.append(",LAST_UPDATE_DATE \n");
		insertQuery.append(",MAIL_RECEIVER \n");
		insertQuery.append(",DWG_MAIL_SEND_SEQ \n");
		insertQuery.append(",RECEIVER_ID \n");
		insertQuery.append(") \n");
		insertQuery.append("VALUES (?,'S',?,sysdate,?,?,'','N','N',?,sysdate,-1,'',?,?,?) \n");
		
        ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
		int					result		= 0;
		int 				i			= 1;
			try 
	        { 
				pstmt = conn.prepareStatement(insertQuery.toString());
				
				pstmt.setString(i++, (String)rowData.get("dwgTransSeq"));
				pstmt.setString(i++, (String)rowData.get("reqSabun"));
				pstmt.setString(i++, (String)rowData.get("reqdept"));
				pstmt.setString(i++, (String)rowData.get("resSabun"));
				pstmt.setString(i++, (String)rowData.get("reqSabun"));
				pstmt.setString(i++, (String)rowData.get("mail_receiver"));
				pstmt.setString(i++, (String)rowData.get("dwgMailSendSeq"));
				pstmt.setString(i++, (String)rowData.get("receiver_id"));
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
	public int updateRequiredNull(Connection conn,int delDwg) throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update stx_dwg_dw302tbl \n");
		query.append("set trans_plm = '' \n");
		query.append("where 1=1 \n");
		query.append("and dwg_seq_id = "+delDwg+" \n");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
		int					result		= 0;
			try 
	        { 
				pstmt = conn.prepareStatement(query.toString());
	            result=pstmt.executeUpdate();
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
	
	public int updateRequiredDWG(Connection conn,Map rowData2)throws Exception{
		StringBuffer query = new StringBuffer();
		query.append("update STX_DWG_DW302TBL \n");
		query.append("set trans_plm = 'S' \n");
		query.append("where 1=1 \n");
		query.append("and dwg_seq_id = "+rowData2.get("dwg_seq_id"));

		
		
        ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
		int					result		= 0;
			try 
	        { 
				pstmt = conn.prepareStatement(query.toString());
	            result=pstmt.executeUpdate();
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
	
	public Map select_grantor_epMail(Connection conn,RequestBox rBox) throws Exception{
		
		StringBuffer query = new StringBuffer();
		query.append("select  \n");
		query.append("ep_mail \n");
		query.append("from  \n");
		query.append("STX_COM_INSA_USER \n");
		query.append("where 1=1 \n");
		query.append("and     emp_no = '"+rBox.get("grantor")+"' \n");


		
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
	private String getQuery(String qryExp, RequestBox box){
		StringBuffer query = new StringBuffer();
		try {
			if(qryExp.equals("list")){
				String p_description = box.getString("p_description") == null ? "" : box.getString("p_description").toString();
				String p_dept = box.getString("dept") == null ? "" : box.getString("dept").toString();
				String p_shipNo = box.getString("shipNo") == null ? "" : box.getString("shipNo").toString();
				String p_dwgNo = box.getString("dwgNo") == null ? "" : box.getString("dwgNo").toString();
				String p_blockNo = box.getString("blockNo") == null ? "" : box.getString("blockNo").toString();
				String p_revNo = box.getString("revNo") == null ? "" : box.getString("revNo").toString();
				String p_state = box.getString("state") == null ? "" : box.getString("state").toString();
				String p_user_name = box.getString("p_user_name") == null ? "" : box.getString("p_user_name").toString();
				String p_deptGubun = box.getString("p_deptGubun") == null ? "" : box.getString("p_deptGubun").toString();
				
				String p_ts_dwgdeptcode = box.getSession("ts_dwgdeptcode") == null ? "" : box.getSession("ts_dwgdeptcode").toString();				
				// 상선 부서 인원 중 특수선DP에 등록되어 겸업하는 부서(방식기술, 공법) 가 있어 특수선 정보를 같이 가져와야한다.
				String dpsp_dept = p_dept;
				if(!"".equals(p_ts_dwgdeptcode))
				{
					dpsp_dept = p_ts_dwgdeptcode;
				}				
				
				query.append("select t13.* \n");
				query.append("from (  \n");
				query.append("select t12.* \n");
				query.append(",floor((rownum - 1) / "+box.getString("rows")+" + 1 ) as page \n");
				query.append("from \n");
				query.append("( \n");
				query.append("select t4.*  \n");
				query.append("      ,t5.description \n");
				//query.append("      ,t6.dept_name \n");
				query.append("      ,case   when t4.trans_plm='Y' then 'Release'  \n");
				query.append("              when t4.trans_plm='S' then 'Request'  \n");
				query.append("              when t4.trans_plm='R' then 'Return'  \n");
				query.append("              else 'Preliminary'  \n");
				query.append("       end as state  \n");
				query.append("      ,case when t4.trans_plm ='Y'       then 'N' \n");
				query.append("            when t4.trans_plm ='S'       then 'N' \n");
				query.append("            when t4.trans_plm ='R' and  dwg_rev < (select max(dwg_rev)  \n");
				query.append("                                                     from STX_DWG_DW302TBL \n");
				query.append("                                                    where shp_no    = t4.shp_no \n");
				query.append("                                                      and dwg_no    = t4.dwg_no \n");
				query.append("                                                      and trans_plm in ('Y','S') and working_flag =t4.working_flag )   then 'N'   \n");
				query.append("            when t4.trans_plm is null and  dwg_rev < (select max(dwg_rev)  \n");
				query.append("                                                        from STX_DWG_DW302TBL \n");
				query.append("                                                       where shp_no    = t4.shp_no \n");
				query.append("                                                         and dwg_no    = t4.dwg_no \n");
				query.append("                                                      and trans_plm in ('Y','S') and working_flag =t4.working_flag )   then 'N'   \n");
				query.append("           else 'Y' \n");
				query.append("       end as is_yn       \n");
				query.append("  from ( \n");
				query.append("		  select t2.*			\n");
				query.append("				,t3.user_name	\n");
				query.append("		    from	(			\n");
				query.append("        select t1.shp_no \n");
				query.append("              ,t1.dwg_no \n");
				query.append("              ,t1.dwg_rev \n");
				query.append("              ,max(t1.trans_plm) as trans_plm \n");
				query.append("              ,dp.dept_code 	   as dept_code \n");
				query.append("				,t1.working_flag				\n");
				query.append("				,min(t1.emp_no)   as emp_no	\n");
				query.append("          from stx_dwg_dw302tbl                 t1 \n");
				query.append("				,(select 	 da.projectno as project_no \n");
				query.append("							,substr(da.ACTIVITYCODE,1,8) as dwg_no	\n");
				query.append("							,da.DWGDEPTCODE              as dept_code	\n");
				query.append("				    from 	dpm_activity@"+DP_DB+" da									\n");
				query.append("				   where 	da.caseno       = '1' 										\n");
				query.append("					 and	da.projectno	= '"+box.getString("shipNo")+"' 			\n");
				query.append("					 and 	'S' = '"+p_deptGubun+"'										\n");
				if( !p_dwgNo.equals("")){
				query.append("					 and 	da.ACTIVITYCODE like '"+box.getString("dwgNo")+"%'||'DW' 	\n");
				}
				if( !p_blockNo.equals("")){
				query.append("			 		 and 	da.ACTIVITYCODE like '%"+box.getString("blockNo")+"'||'DW'  \n");
				}
				if(box.getSession("GrCode").equals("M1")){
				}
				else{
				query.append("           		 and 	da.DWGDEPTCODE  = '"+p_dept+"'  				\n");
				}
				query.append("					 union all	\n");
				query.append("				  select  da.projectno                as project_no					 	\n");
				query.append("				   		 ,substr(da.ACTIVITYCODE,1,8) as dwg_no							\n");
				query.append("						 ,da.DWGDEPTCODE              as dept_code						\n");
				query.append("				    from dpm_activity@"+DPSP_DB+" da	 								\n");
				query.append("				   where da.caseno = '1'												\n");
				query.append("					 and da.projectno    = '"+box.getString("shipNo")+"'				\n");
				query.append("					 and 'N' = '"+p_deptGubun+"'										\n");
				if( !p_dwgNo.equals("")){
				query.append("					 and 	da.ACTIVITYCODE like '"+box.getString("dwgNo")+"%'||'DW' 	\n");
				}
				if( !p_blockNo.equals("")){
				query.append("			 		 and 	da.ACTIVITYCODE like '%"+box.getString("blockNo")+"'||'DW'  \n");
				}
				if(box.getSession("GrCode").equals("M1")){
				}
				else{
				query.append("           		 and 	da.DWGDEPTCODE  = '"+dpsp_dept+"'  				\n");
				}
				
				query.append("					 )dp	\n");
				query.append("				where	t1.shp_no = dp.project_no	\n");
				query.append("				  and	t1.dwg_no = dp.dwg_no		\n");
				if( !p_revNo.equals("")){
					query.append("			 and t1.dwg_rev like '%"+box.getString("revNo")+"%' \n");
				}
				query.append("				group by t1.shp_no,t1.dwg_no,t1.dwg_rev,t1.working_flag , dp.dept_code	) t2	\n");
				query.append("				, stx_com_insa_user		t3	\n");
				query.append("			where t2.emp_no = t3.emp_no(+)	\n");
				query.append("				)	t4	\n");
				query.append("				, stx_dwg_category_masters     t5 	\n");
				query.append("			where substr(t4.dwg_no,1,5) = t5.dwg_no_concat 	\n");
				if(box.getString("state").equals("ALL")){
				}
				else if(box.getString("state").equals("Y")){
					query.append("and t4.trans_plm = 'Y' \n");
				}
				else if(box.getString("state").equals("R")){
					query.append("and t4.trans_plm = 'R' \n");
				}
				else if(box.getString("state").equals("S")){
					query.append("and t4.trans_plm = 'S' \n");
				}
				else{ 
					query.append("and 1 = case when (select max(sdw.trans_plm)	\n");
					query.append("					   from stx_dwg_dw302tbl sdw	\n");
					query.append("					  where sdw.shp_no = t4.shp_no	\n");
					query.append("					    and sdw.dwg_no = t4.dwg_no	\n");
					query.append("						and sdw.dwg_rev = t4.dwg_rev	\n");
					query.append("					) is null	\n");
					query.append("			   then 1	\n");
					query.append("		  	   else 2	\n");
					query.append("		  end	\n");
				}
				if( !p_description.equals("")){
				query.append("			  and t5.description like '%"+quoteReplace(box.getString("p_description"))+"%'	\n");
				}
				if(!p_user_name.equals("")){
					query.append("			  and t4.user_name like '"+box.getString("p_user_name")+"%'	\n");
				}
				query.append("			order by t4.dwg_no, t4.dwg_rev 	\n");
				query.append("			) t12 	\n");
				query.append("		) t13 		\n");
				query.append("where page = "+box.getString("page")+" 														\n");				
	  			
			} else if(qryExp.equals("selectTotalRecord")){
				String p_description = box.getString("p_description") == null ? "" : box.getString("p_description").toString();
				String p_dept = box.getString("dept") == null ? "" : box.getString("dept").toString();
				String p_shipNo = box.getString("shipNo") == null ? "" : box.getString("shipNo").toString();
				String p_dwgNo = box.getString("dwgNo") == null ? "" : box.getString("dwgNo").toString();
				String p_blockNo = box.getString("blockNo") == null ? "" : box.getString("blockNo").toString();
				String p_revNo = box.getString("revNo") == null ? "" : box.getString("revNo").toString();
				String p_state = box.getString("state") == null ? "" : box.getString("state").toString();
				String p_user_name = box.getString("p_user_name") == null ? "" : box.getString("p_user_name").toString();
				String p_deptGubun = box.getString("p_deptGubun") == null ? "" : box.getString("p_deptGubun").toString();
				
				String p_ts_dwgdeptcode = box.getSession("ts_dwgdeptcode") == null ? "" : box.getSession("ts_dwgdeptcode").toString();				
				// 상선 부서 인원 중 특수선DP에 등록되어 겸업하는 부서(방식기술, 공법) 가 있어 특수선 정보를 같이 가져와야한다.
				String dpsp_dept = p_dept;
				if(!"".equals(p_ts_dwgdeptcode))
				{
					dpsp_dept = p_ts_dwgdeptcode;
				}				
				
				query.append("select count(*) as cnt \n");
				query.append("from \n");
				query.append("(  \n");
				query.append("select t4.*  \n");
				query.append("      ,t5.description \n");
				//query.append("      ,t6.dept_name \n");
				query.append("      ,case   when t4.trans_plm='Y' then 'Release'  \n");
				query.append("              when t4.trans_plm='S' then 'Request'  \n");
				query.append("              when t4.trans_plm='R' then 'Return'  \n");
				query.append("              else 'Preliminary'  \n");
				query.append("       end as state  \n");
				query.append("      ,case when t4.trans_plm ='Y'       then 'N' \n");
				query.append("            when t4.trans_plm ='S'       then 'N' \n");
				query.append("            when t4.trans_plm ='R' and  dwg_rev < (select max(dwg_rev)  \n");
				query.append("                                                     from STX_DWG_DW302TBL \n");
				query.append("                                                    where shp_no    = t4.shp_no \n");
				query.append("                                                      and dwg_no    = t4.dwg_no \n");
				query.append("                                                      and trans_plm in ('Y','S') and working_flag =t4.working_flag )   then 'N'   \n");
				query.append("            when t4.trans_plm is null and  dwg_rev < (select max(dwg_rev)  \n");
				query.append("                                                        from STX_DWG_DW302TBL \n");
				query.append("                                                       where shp_no    = t4.shp_no \n");
				query.append("                                                         and dwg_no    = t4.dwg_no \n");
				query.append("                                                      and trans_plm in ('Y','S') and working_flag =t4.working_flag )   then 'N'   \n");
				query.append("           else 'Y' \n");
				query.append("       end as is_yn       \n");
				query.append("  from ( \n");
				query.append("		  select t2.*			\n");
				query.append("				,t3.user_name	\n");
				query.append("		    from	(			\n");
				query.append("        select t1.shp_no \n");
				query.append("              ,t1.dwg_no \n");
				query.append("              ,t1.dwg_rev \n");
				query.append("              ,max(t1.trans_plm) as trans_plm \n");
				query.append("              ,dp.dept_code 	   as dept_code \n");
				query.append("				,t1.working_flag				\n");
				query.append("				,min(t1.emp_no)   as emp_no	\n");
				query.append("          from stx_dwg_dw302tbl                 t1 \n");
				query.append("				,(select 	 da.projectno as project_no \n");
				query.append("							,substr(da.ACTIVITYCODE,1,8) as dwg_no	\n");
				query.append("							,da.DWGDEPTCODE              as dept_code	\n");
				query.append("				    from 	dpm_activity@"+DP_DB+" da	\n");
				query.append("				   where 	da.caseno       = '1' 	\n");
				query.append("					 and	da.projectno	= '"+box.getString("shipNo")+"' \n");
				query.append("					 and 	'S' = '"+p_deptGubun+"'										\n");
				if( !p_dwgNo.equals("")){
				query.append("					 and 	da.ACTIVITYCODE like '"+box.getString("dwgNo")+"%'||'DW' 	\n");
				}
				if( !p_blockNo.equals("")){
				query.append("			 		 and 	da.ACTIVITYCODE like '%"+box.getString("blockNo")+"'||'DW'  \n");
				}
				if(box.getSession("GrCode").equals("M1")){
				}
				else{
				query.append("           		 and 	da.DWGDEPTCODE  = '"+p_dept+"'  				\n");
				}
				query.append("					 union all	\n");
				query.append("				  select  da.projectno                as project_no					 	\n");
				query.append("				   		 ,substr(da.ACTIVITYCODE,1,8) as dwg_no							\n");
				query.append("						 ,da.DWGDEPTCODE              as dept_code						\n");
				query.append("				    from dpm_activity@"+DPSP_DB+" da	 								\n");
				query.append("				   where da.caseno = '1'												\n");
				query.append("					 and da.projectno    = '"+box.getString("shipNo")+"'				\n");
				query.append("					 and 	'N' = '"+p_deptGubun+"'										\n");
				if( !p_dwgNo.equals("")){
				query.append("					 and 	da.ACTIVITYCODE like '"+box.getString("dwgNo")+"%'||'DW' 	\n");
				}
				if( !p_blockNo.equals("")){
				query.append("			 		 and 	da.ACTIVITYCODE like '%"+box.getString("blockNo")+"'||'DW'  \n");
				}
				if(box.getSession("GrCode").equals("M1")){
				}
				else{
				query.append("           		 and 	da.DWGDEPTCODE  = '"+dpsp_dept+"'  				\n");
				}
				
				query.append("					 )dp	\n");
				query.append("				where	t1.shp_no = dp.project_no	\n");
				query.append("				  and	t1.dwg_no = dp.dwg_no		\n");
				if( !p_revNo.equals("")){
					query.append("			 and t1.dwg_rev like '%"+box.getString("revNo")+"%' \n");
				}
				
				query.append("				group by t1.shp_no,t1.dwg_no,t1.dwg_rev,t1.working_flag , dp.dept_code	) t2	\n");
				query.append("				, stx_com_insa_user		t3	\n");
				query.append("			where t2.emp_no = t3.emp_no(+)	\n");
				query.append("				)	t4	\n");
				query.append("				, stx_dwg_category_masters     t5 	\n");
				query.append("			where substr(t4.dwg_no,1,5) = t5.dwg_no_concat 	\n");
				if(box.getString("state").equals("ALL")){
				}
				else if(box.getString("state").equals("Y")){
					query.append("and t4.trans_plm = 'Y' \n");
				}
				else if(box.getString("state").equals("R")){
					query.append("and t4.trans_plm = 'R' \n");
				}
				else if(box.getString("state").equals("S")){
					query.append("and t4.trans_plm = 'S' \n");
				}
				else{ 
					query.append("and 1 = case when (select max(sdw.trans_plm)	\n");
					query.append("					   from stx_dwg_dw302tbl sdw	\n");
					query.append("					  where sdw.shp_no = t4.shp_no	\n");
					query.append("					    and sdw.dwg_no = t4.dwg_no	\n");
					query.append("						and sdw.dwg_rev = t4.dwg_rev	\n");
					query.append("					) is null	\n");
					query.append("			   then 1	\n");
					query.append("		  	   else 2	\n");
					query.append("		  end	\n");
				}
				if( !p_description.equals("")){
				query.append("			  and t5.description like '%"+quoteReplace(box.getString("p_description"))+"%'	\n");
				}
				if(!p_user_name.equals("")){
					query.append("			  and t4.user_name like '"+box.getString("p_user_name")+"%'	\n");
				}
				query.append("			order by t4.dwg_no, t4.dwg_rev ) 	\n");
				
			
			}
			//시퀀스 따기(YYMMDD9SEQ(1406109001))
			else if(qryExp.equals("getDwgTransSeq")){
				query.append("select STX_FN_GET_DWG_ECONO() as eco_no	\n");
				query.append("  from dual 						\n");
			}
			else if(qryExp.equals("getDwgMailSendSeq")){
				query.append("select to_char(STX_TBC_DWG_MAIL_SEND_SQ.nextval) as seq	\n");
				query.append("  from dual 										\n");
			}
			else if(qryExp.equals("selectDeptGubun")){
				query.append("select	\n");
				query.append("		 emp_no	\n");
				query.append("		,user_name	\n");
				query.append("	from  stx_com_insa_user@"+ERP_DB+"	\n");
				query.append(" where  1=1	\n");
				query.append("	 and  dept_name like '%특수선%'	\n");
				query.append("	 and  emp_no = '"+box.getString("userId")+"'	\n");
			}else if(qryExp.equals("selectdwgdeptcode")){
				String p_deptGubun = box.getString("p_deptGubun") == null ? "" : box.getString("p_deptGubun").toString();
				String userId = box.getString("userId") == null ? "" : box.getString("userId").toString();
				
				query.append("SELECT A.EMP_NO \n");
	        	query.append("     , A.USER_NAME \n");
	        	query.append("     , A.USER_ENG_NAME \n");
//	        	query.append("     , CASE WHEN B.DEPTNM IS NOT NULL THEN SUBSTR(B.DEPTNM, INSTR( B.DEPTNM,'-')+1) \n");
//	        	query.append("            ELSE C.DWGDEPTNM  \n");
//	        	query.append("       END AS DWGDEPTNM \n");
	        	query.append("     , C.DWGDEPTNM \n");
	        	query.append("     , A.DEPT_CODE  \n");
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
	        	query.append("           AND AA.EMP_NO = '"+userId+"'  \n");
	        	query.append("           AND CC.USERYN  = 'Y' \n");
	        	query.append("         ) AS TS_DWGDEPTCODE      \n");
	        	query.append("  FROM STX_COM_INSA_USER@"+ERP_DB+" A \n");
	        	query.append(" LEFT JOIN DCC_DEPTCODE@"+DP_DB+" B ON A.DEPT_CODE = B.DEPTCODE \n");
	        	query.append(" LEFT JOIN DCC_DWGDEPTCODE@"+DP_DB+" C ON B.DWGDEPTCODE = C.DWGDEPTCODE \n");
	        	query.append(" WHERE A.EMP_NO = '"+userId+"' \n");
	        	query.append("	 AND 'S' = '"+p_deptGubun+"'										\n");
	        	//query.append("   AND C.USERYN = 'Y' \n");
	        	query.append("UNION ALL \n"); 
	        	query.append("SELECT A.EMP_NO \n");
	        	query.append("     , A.USER_NAME \n");
	        	query.append("     , A.USER_ENG_NAME \n");
//	        	query.append("     , CASE WHEN B.DEPTNM IS NOT NULL THEN SUBSTR(B.DEPTNM, INSTR( B.DEPTNM,'-')+1) \n");
//	        	query.append("            ELSE C.DWGDEPTNM  \n");
//	        	query.append("       END AS DWGDEPTNM \n");
	        	query.append("     , C.DWGDEPTNM \n");
	        	query.append("     , A.DEPT_CODE  \n");
	        	query.append("     , B.DWGDEPTCODE \n");
	        	query.append("     , CASE WHEN B.DEPTCODE LIKE '568900' THEN 'M1'\n");
	        	query.append("            ELSE 'U1'\n");
	        	query.append("       END AS GRCODE\n");
	        	query.append("     , 'Y' AS DP_GUBUN \n");
	        	query.append("     , ''  AS TS_DWGDEPTCODE \n");
	        	query.append("  FROM STX_COM_INSA_USER@"+ERP_DB+" A \n");
	        	query.append(" LEFT JOIN DCC_DEPTCODE@"+DPSP_DB+" B ON A.DEPT_CODE = B.DEPTCODE \n");
	        	query.append(" LEFT JOIN DCC_DWGDEPTCODE@"+DPSP_DB+" C ON B.DWGDEPTCODE = C.DWGDEPTCODE \n");
	        	query.append(" WHERE A.EMP_NO = '"+userId+"' \n");
	        	//query.append("   AND C.USERYN = 'Y' \n");
	        	query.append("   AND C.DWGDEPTNM  LIKE '%특수%' \n");        	
	        	query.append("	 AND 'N' = '"+p_deptGubun+"'										\n");					
			}
			
		}catch (Exception e) 
		{
			e.printStackTrace();
			// TODO: handle exception
		}
		return query.toString();
	}
	private String getQuery(String qryExp, Map rowData,RequestBox box){
		StringBuffer query = new StringBuffer();
		try {
				if(qryExp.equals("dwgMailContentList")){
					query.append("select t1.trans_plm \n");
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
					query.append("       ,to_char(t1.dwg_seq_id) as dwg_seq_id \n");
					query.append(" from stx_dwg_dw302tbl        t1 \n");
					query.append("     ,(select * \n");
					query.append("        from stx_com_insa_user  \n");
					query.append("       where  dept_code in ( \n");
					query.append("      select dept_code \n");
					query.append("        from stx_dwg_mail_confirm_user_v \n");
					query.append("		 where 1=1							\n");
					if(box.getSession("GrCode").equals("M1")){
						query.append("				)						\n");
					}
					else{
						query.append("     and dwgdeptcode = '"+rowData.get("dept")+"')  \n");
					}
					query.append("      )                        t2  \n");
					query.append("     ,stx_dwg_category_masters t3   \n");
					query.append("where t3.dwg_no_concat   = substr(t1.dwg_no,1,5)  \n");
					query.append("  and t1.emp_no          = t2.emp_no(+)  \n");
					query.append("  and t1.shp_no = '"+rowData.get("shp_no")+"' \n");
					query.append("  and t1.dwg_no = '"+rowData.get("dwg_no")+"' \n");
					query.append("  and t1.dwg_rev = '"+rowData.get("dwg_rev")+"' \n");
					query.append("order by  t1.dwg_no, t1.dwg_sq, t1.dwg_rev  \n");
				}
				else if(qryExp.equals("selectDwgReturnInfo")){
					query.append("select t1.trans_plm \n");
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
					query.append("       ,to_char(t1.dwg_seq_id) as dwg_seq_id \n");
					query.append(" from stx_dwg_dw302tbl        t1 \n");
					query.append("     ,(select * \n");
					query.append("        from stx_com_insa_user  \n");
					query.append("       where  dept_code in ( \n");
					query.append("      select dept_code \n");
					query.append("        from stx_dwg_mail_confirm_user_v \n");
					query.append("		 where 1=1							\n");
					if(box.getSession("GrCode").equals("M1")){
						query.append("				)						\n");
					}
					else{
						query.append("     and dwgdeptcode = '"+rowData.get("dept")+"')  \n");
					}
					query.append("      )                        t2  \n");
					query.append("     ,stx_dwg_category_masters t3   \n");
					query.append("where t3.dwg_no_concat   = substr(t1.dwg_no,1,5)  \n");
					query.append("  and t1.emp_no          = t2.emp_no(+)  \n");
					query.append("  and t1.shp_no = '"+rowData.get("shp_no")+"' \n");
					query.append("  and t1.dwg_no = '"+rowData.get("dwg_no")+"' \n");
					query.append("  and t1.dwg_rev = '"+rowData.get("dwg_rev")+"' \n");
					query.append("	and t1.trans_plm = 'R' 								\n");
					query.append("order by  t1.dwg_no, t1.dwg_sq, t1.dwg_rev  \n");
				}
				else if(qryExp.equals("receiverCheck")){
					String shp_no	= rowData.get("shp_no")	== null ? "" : rowData.get("shp_no").toString();
					String dwg_no	= rowData.get("dwg_no")	== null ? "" : rowData.get("dwg_no").toString();
					
					
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
					if( !shp_no.equals("") ){
					query.append("   AND SDER.MASTER_PROJECT_NO = '"+rowData.get("shp_no")+"' \n");
					}
					query.append("   AND SDER.DWG_NO = '"+rowData.get("dwg_no")+"' \n");
					query.append("   AND SDER.REV_NO = '"+rowData.get("dwg_rev")+"' \n");
					query.append("   AND SDD.DEPT_ID = SDERU.RECEIVER_DEPT \n");
					//query.append("   AND SDERU.PROJECT_NO = '"+rowData.get("shipNo")+"' \n");
				}else if(qryExp.equals("selectReceiverId")){
					query.append("select *													\n");
					query.append("  from stx_dwg_eco_receiver								\n");
					query.append(" where 1=1 												\n");
					query.append("	 and master_project_no = '"+rowData.get("shp_no")+"'	\n");
					query.append("	 and dwg_no			   = '"+rowData.get("dwg_no")+"'	\n");
					query.append("	 and rev_no			   = '"+rowData.get("dwg_rev")+"'	\n");
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