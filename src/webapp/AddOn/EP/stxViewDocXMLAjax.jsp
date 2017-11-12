<%@page import="java.util.StringTokenizer"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="org.jdom.Element"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%! 
	public String getStandardItemViewXML(
			String p_emp_no
			,String p_ITEM_CATALOG_GROUP_ID
			,String p_PART_SEQ_ID) throws Exception
	{
		StringBuffer sbXml = new StringBuffer();
		java.sql.Connection conn = null;
		CallableStatement cs1 = null;
		CallableStatement cs2 = null;
		PreparedStatement ps = null;
		String sResult = "";
		try
		{
			
			conn = DBConnect.getDBConnection("ERP_APPS");			
			conn.setAutoCommit(false);

			cs1 = conn.prepareCall("{call  stx_dwg_ep_view_insert_proc (?, ?, ?, ?, ?, ?)}");
			
			int ip_ITEM_CATALOG_GROUP_ID = Integer.parseInt(p_ITEM_CATALOG_GROUP_ID);
			int ip_PART_SEQ_ID = Integer.parseInt(p_PART_SEQ_ID);
			cs1.setString(1, p_emp_no);
			cs1.setInt(2, ip_ITEM_CATALOG_GROUP_ID); 
			cs1.setInt(3, ip_PART_SEQ_ID); 
			cs1.registerOutParameter(4, java.sql.Types.INTEGER);
			cs1.registerOutParameter(5, java.sql.Types.VARCHAR);
			cs1.registerOutParameter(6, java.sql.Types.VARCHAR);
			
			cs1.execute();
			
			String sErrCode = cs1.getString(6);
			if (sErrCode != null && !sErrCode.equals("")) 
				sResult = "E";
			else
			{
				int iSeq = cs1.getInt(4);
				
				cs2 = conn.prepareCall("{call  stx_dwg_pm_part_scm_vi_proc (?, ?, ?)}");
				
				cs2.setInt(1, iSeq); 
				cs2.registerOutParameter(2, java.sql.Types.VARCHAR);
				cs2.registerOutParameter(3, java.sql.Types.VARCHAR);
				
				cs2.execute();
				
				String sResult2 = cs2.getString(2);
				if(sResult2!= null && sResult2.equals("S"))
				{
					StringBuffer sbSql = new StringBuffer();
					sbSql.append(" select PML_CODE from STX_DWG_SCM_PRINT_INFO\n");
					sbSql.append(" where PRINT_SEQ = "+iSeq+"\n");
					sbSql.append(" order by ROW_SEQ\n");
					
					ps = conn.prepareStatement(sbSql.toString()); 
					
					ArrayList mlReturn = new ArrayList();
					
					mlReturn = getResultMapRows(ps.executeQuery());
					Iterator itrReturn = mlReturn.iterator();
					while(itrReturn.hasNext())
					{
						Map mapReturn = (Map)itrReturn.next();
						if(mapReturn.get("PML_CODE") != null)sbXml.append(mapReturn.get("PML_CODE") + "\n");
					}
					
				}
			}
			conn.commit();
		}
		catch(Exception e)
		{
			if(conn != null)conn.rollback();
			e.printStackTrace();
		}finally{
			if(cs1 != null)cs1.close();
			if(cs2 != null)cs2.close();
			if(ps != null)ps.close();
			if(conn != null)conn.close();
		}
		return sbXml.toString();
	}

	public String getDWGViewXML(
			String P_EMP_NO
			,String P_FILE_NAME
			) throws Exception
	{
		StringBuffer sbXml = new StringBuffer();
		java.sql.Connection conn = null;
		CallableStatement cs1 = null;
		CallableStatement cs2 = null;
		PreparedStatement ps = null;
		String sResult = "";
		try
		{
			
			conn = DBConnect.getDBConnection("ERP_APPS");			
			conn.setAutoCommit(false);

			cs1 = conn.prepareCall("{call  stx_dwg_plm_view_insert_proc (?, ?, ?, ?, ?)}");
			
			cs1.setString(1, P_EMP_NO);
			cs1.setString(2, P_FILE_NAME); 
			cs1.registerOutParameter(3, java.sql.Types.INTEGER);
			cs1.registerOutParameter(4, java.sql.Types.VARCHAR);
			cs1.registerOutParameter(5, java.sql.Types.VARCHAR);
			
			cs1.execute();
			
			String sErrCode = cs1.getString(5);
			if (sErrCode != null && !sErrCode.equals("")) 
				sResult = "E";
			else
			{
				int iSeq = cs1.getInt(3);

				cs2 = conn.prepareCall("{call  stx_dwg_pm_scm_view_proc (?, ?, ?)}");
				
				cs2.setInt(1, iSeq); 
				cs2.registerOutParameter(2, java.sql.Types.VARCHAR);
				cs2.registerOutParameter(3, java.sql.Types.VARCHAR);
				
				cs2.execute();
				
				String sResult2 = cs2.getString(2);
				if(sResult2!= null && sResult2.equals("S"))
				{
					StringBuffer sbSql = new StringBuffer();
					sbSql.append(" select PML_CODE from STX_DWG_SCM_PRINT_INFO\n");
					sbSql.append(" where PRINT_SEQ = "+iSeq+"\n");
					sbSql.append(" order by ROW_SEQ\n");

					ps = conn.prepareStatement(sbSql.toString()); 
					
					ArrayList mlReturn = new ArrayList();
					mlReturn = getResultMapRows(ps.executeQuery());
					Iterator itrReturn = mlReturn.iterator();
					while(itrReturn.hasNext())
					{
						Map mapReturn = (Map)itrReturn.next();
						if(mapReturn.get("PML_CODE") != null)sbXml.append(mapReturn.get("PML_CODE") + "\n");
					}
					
				}
			}
			conn.commit();
		}
		catch(Exception e)
		{
			if(conn != null)conn.rollback();
			e.printStackTrace();
		}finally{
			if(cs1 != null)cs1.close();
			if(cs2 != null)cs2.close();
			if(ps != null)ps.close();
			if(conn != null)conn.close();
		}
		return sbXml.toString();
	}
	
	
	// 2014-04-22 Kang seonjung : Drawing URL에서 선택된 도면파일 DS View
	public String getCheckDWGViewXML(
			String P_EMP_NO
			,String checkFileList
			) throws Exception
	{
		StringBuffer sbXml = new StringBuffer();
		java.sql.Connection conn = null;
		CallableStatement cs1 = null;
		CallableStatement cs2 = null;
		CallableStatement cs3 = null;
		PreparedStatement ps = null;
		String sResult = "";

		try
		{
			
			conn = DBConnect.getDBConnection("ERP_APPS");			
			conn.setAutoCommit(false);

			// 도면 Print Seq 추출
			cs1 = conn.prepareCall("{call  stx_dwg_plm_multi_view_h_proc (?, ?, ?, ?)}");
			
			cs1.setString(1, P_EMP_NO);
			cs1.registerOutParameter(2, java.sql.Types.INTEGER);     // P_PRINT_SEQ
			cs1.registerOutParameter(3, java.sql.Types.VARCHAR);     // P_ERROR_MSG
			cs1.registerOutParameter(4, java.sql.Types.VARCHAR);     // P_ERROR_CODE
			
			cs1.execute();
			
			String sErrCode = "";
			sErrCode = cs1.getString(4);

			if (sErrCode != null && !sErrCode.equals("")) 
			{
				sResult = "E";
				throw new Exception(sResult);	
			}
			else
			{
				int iSeq = cs1.getInt(2);

				// 도면 Print table에 Print Seq 별 선택된 도면파일명 저장
				cs2 = conn.prepareCall("{call  stx_dwg_plm_multi_view_d_proc (?, ?, ?, ?)}");
				
				// ex: S3027-M1727S01-COV-0010-05.PDF|S3027-M1727S01-COV-0010-06.PDF|S3027-M1727S01-COV-0010-07.PDF
				StringTokenizer st = new StringTokenizer(checkFileList, "|");
				while(st.hasMoreTokens())
				{
					String checkFileName = st.nextToken();
					cs2.setInt(1, iSeq); 
					cs2.setString(2, checkFileName); 
					cs2.registerOutParameter(3, java.sql.Types.VARCHAR);           // P_ERROR_MSG
					cs2.registerOutParameter(4, java.sql.Types.VARCHAR);           // P_ERROR_CODE
					cs2.execute();	
					
					sErrCode = cs2.getString(4);
					
					if (sErrCode != null && !sErrCode.equals("")) 
					{
						sResult = "E";
						throw new Exception(sResult);	
					}					
					
				}		
				
				// DS View 화면 출력 내용 받아오기
				cs3 = conn.prepareCall("{call  stx_dwg_plm_multi_view_proc (?, ?, ?)}");
				
				cs3.setInt(1, iSeq);                                          // P_PRINT_SEQ
				cs3.registerOutParameter(2, java.sql.Types.VARCHAR);          // P_PRINT_FLAG
				cs3.registerOutParameter(3, java.sql.Types.VARCHAR);          // P_PRINT_RESULT
				
				cs3.execute();
				
				String sResult2 = cs3.getString(2);
				if(sResult2!= null && sResult2.equals("S"))
				{
					StringBuffer sbSql = new StringBuffer();
					sbSql.append(" select PML_CODE from STX_DWG_SCM_PRINT_INFO\n");
					sbSql.append(" where PRINT_SEQ = "+iSeq+"\n");
					sbSql.append(" order by ROW_SEQ\n");

					ps = conn.prepareStatement(sbSql.toString()); 
					
					ArrayList mlReturn = getResultMapRows(ps.executeQuery());
					Iterator itrReturn = mlReturn.iterator();
					while(itrReturn.hasNext())
					{
						Map mapReturn = (Map)itrReturn.next();
						if(mapReturn.get("PML_CODE") != null)sbXml.append(mapReturn.get("PML_CODE") + "\n");
					}					
				}	
			}
			conn.commit();
		}
		catch(Exception e)
		{
			if(conn != null)conn.rollback();
			e.printStackTrace();
		}finally{
			if(cs1 != null)cs1.close();
			if(cs2 != null)cs2.close();
			if(cs3 != null)cs3.close();
			if(ps != null)ps.close();
			if(conn != null)conn.close();
		}
		return sbXml.toString();
	}	
%>
<%
	
	String sOutPut = "";

	String VIEWMODE = request.getParameter("VIEWMODE");
	String loginID = request.getParameter("loginID");
	
	String p_ITEM_CATALOG_GROUP_ID = request.getParameter("p_ITEM_CATALOG_GROUP_ID");
	String p_PART_SEQ_ID = request.getParameter("p_PART_SEQ_ID");
	sOutPut = getStandardItemViewXML(loginID,p_ITEM_CATALOG_GROUP_ID,p_PART_SEQ_ID);

%>
<%=sOutPut%>