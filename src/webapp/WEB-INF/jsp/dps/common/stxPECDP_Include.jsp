<%--  
§DESCRIPTION: 설계시수/실적 - Database 연동관련 코드들 및 기타 유틸리티 코드들 
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDP_Include.inc
§CHANGING HISTORY: 
§    2009-04-23: Initiative
--%>
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSetMetaData"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import = "java.util.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil"%>
<%@ page import = "com.stx.common.util.FrameworkUtil"%>
<%@ page import = "java.text.DecimalFormat" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<%--========================== JSP =========================================--%>
<%!
		
	private static String[] timeKeys = {"0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", 
										"1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", 
										"1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400"};
										
	private static ArrayList getResultMapRows(ResultSet rs) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		ResultSetMetaData metaData = rs.getMetaData();
		while (rs.next()) {
			HashMap mapReturn = new HashMap();
			for (int index = 0; index < metaData.getColumnCount(); index++) {
				String sColumnName = metaData.getColumnName(index + 1);
				mapReturn.put(StringUtil.setEmpty(sColumnName), StringUtil.setEmpty(rs.getString(sColumnName)));
			}
			mlReturn.add(mapReturn);
		}
		return mlReturn;
	}

	// getEmployeeInfo() : 해당 사번의 사원이름, 직책, 부서정보를 쿼리하고 ERP 권한로그 테이블에 로그를 기록
	private static synchronized Map getEmployeeInfo(String employeeID) throws Exception
	{
        // 해당 사번의 사원이름, 직책, 부서정보를 쿼리
        Map resultMap = getEmployeeInfo2(employeeID);
        
        // ERP 권한로그 테이블에 로그를 기록
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("INSERT INTO STX_LOGIN_RESPONSIBILITIES@STXERP          ");
			queryStr.append("       SELECT '2', 6,                                  ");
			queryStr.append("              A.GROUPNO,                               ");
			queryStr.append("              A.USERID,                                ");
			queryStr.append("              SYSDATE, -1, SYSDATE, SYSDATE, -1        ");
			queryStr.append("         FROM (                                        ");
			queryStr.append("               SELECT GROUPNO, USERID                  ");
			queryStr.append("                 FROM CCC_USER                         ");
			queryStr.append("                WHERE 1 = 1                            ");
			queryStr.append("                  AND USERID = '" + employeeID + "'    ");
			queryStr.append("              ) A                                      ");

            stmt = conn.createStatement();
            stmt.executeUpdate(queryStr.toString());
		}
        catch (Exception e) {
        	e.printStackTrace();
        }
		finally {
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}        

		return resultMap;
	}
    
    // getEmployeeInfo2() : 해당 사번의 사원이름, 직책, 부서정보를 쿼리
	private static synchronized Map getEmployeeInfo2(String employeeID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		HashMap resultMap = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,								     ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,								     ");
			queryStr.append("       (SELECT C.DEPT_NAME										     ");
			queryStr.append("          FROM STX_COM_INSA_DEPT@STXERP C						     ");
			queryStr.append("         WHERE C.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME,	     ");
			queryStr.append("       B.NAME AS NAME,											     ");
			queryStr.append("	    B.JOB AS TITLE, 											 ");
			queryStr.append("	    B.INPUT_MAN_HOUR_ENABLED AS MH_YN,        				     ");
			queryStr.append("       (SELECT GROUPNO										         ");
			queryStr.append("          FROM CCC_USER D						                     ");
			queryStr.append("         WHERE D.USERID = B.EMPLOYEE_NUM) AS GROUPNO,	             ");
			queryStr.append("	    TO_CHAR(TERMINATION_DATE, 'YYYY-MM-DD') AS TERMINATION_DATE, ");
			queryStr.append("	    (SELECT DWGDEPTCODE                                          ");
			queryStr.append("	       FROM DCC_DEPTCODE E                                       ");
			queryStr.append("	      WHERE E.DEPTCODE = B.DEPT_CODE) AS DWG_DEPTCODE,           ");
			queryStr.append("	    B.INPUT_PROGRESS_ENABLED AS PROGRESS_YN        				 ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A,								     ");
			queryStr.append("       CCC_SAWON B												     ");
			queryStr.append(" WHERE A.DEPT_CODE = B.DEPT_CODE								     ");
			queryStr.append("   AND B.EMPLOYEE_NUM = '" + employeeID + "'					     ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				String adminYN = "N";
				if (rset.getString(7) != null && 
					 (rset.getString(7).equals("Administrators") || 
					  rset.getString(7).equals("PLM관리자") ||
                      rset.getString(7).equals("해양공정관리자"))
				   )
				{	adminYN = "Y";	}

				resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("TITLE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("MH_YN", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("IS_ADMIN", adminYN);
				resultMap.put("TERMINATION_DATE", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("DWG_DEPTCODE", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("PROGRESS_YN", rset.getString(10) == null ? "" : rset.getString(10));
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultMap;
	}

	// getEmployeeInfo_Dalian() : 해당 사번의 사원이름, 직책, 부서정보를 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	private static synchronized Map getEmployeeInfo_Dalian(String employeeID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		HashMap resultMap = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.DEPTCODE AS DEPT_CODE,			");
			queryStr.append("       A.DEPTNM AS DEPT_NAME,				");
			queryStr.append("       '' AS UP_DEPT_NAME,	                ");
			queryStr.append("       B.SAWON_NAME AS NAME,				");
			queryStr.append("	    '' AS TITLE, 						");
			queryStr.append("	    '' AS MH_YN,        				");
			queryStr.append("       '' AS GROUPNO,	                    ");
			queryStr.append("	    '' AS TERMINATION_DATE,             ");
			queryStr.append("	    B.DWG_DEPTCODE AS DWG_DEPTCODE,     ");
			queryStr.append("	    'Y' AS PROGRESS_YN        			");
			queryStr.append("  FROM DCC_DEPTCODE A,						");
			queryStr.append("       Z_DALIAN_SAWON_TO111231 B			");
			queryStr.append(" WHERE A.DWGDEPTCODE = B.DWG_DEPTCODE		");
			queryStr.append("   AND B.SAWON_ID = '" + employeeID + "'   ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				String adminYN = "N";

				resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("TITLE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("MH_YN", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("IS_ADMIN", adminYN);
				resultMap.put("TERMINATION_DATE", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("DWG_DEPTCODE", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("PROGRESS_YN", rset.getString(10) == null ? "" : rset.getString(10).trim());
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultMap;
	}

	// getEmployeeInfo_Maritime() : 해당 사번의 사원이름, 직책, 부서정보를 쿼리 
    // - (FOR MARITIME) 해양사업관리팀/해양종합설계팀 인원의 공정조회 기능 부여 (* 임시기능)
	private static synchronized Map getEmployeeInfo_Maritime(String employeeID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		HashMap resultMap = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT '' AS DEPT_CODE,			        ");
			queryStr.append("       '' AS DEPT_NAME,				    ");
			queryStr.append("       '' AS UP_DEPT_NAME,	                ");
			queryStr.append("       SAWON_NAME AS NAME,				    ");
			queryStr.append("	    '' AS TITLE, 						");
			queryStr.append("	    '' AS MH_YN,        				");
			queryStr.append("       IS_ADMIN,	                        ");
			queryStr.append("	    '' AS TERMINATION_DATE,             ");
			queryStr.append("	    '' AS DWG_DEPTCODE,                 ");
			queryStr.append("	    'Y' AS PROGRESS_YN        			");
			queryStr.append("  FROM Z_MARITIME_SAWON_TO111231			");
			queryStr.append(" WHERE SAWON_ID = '" + employeeID + "'		");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("TITLE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("MH_YN", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("IS_ADMIN", rset.getString(7) == null ? "N" : rset.getString(7));
				resultMap.put("TERMINATION_DATE", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("DWG_DEPTCODE", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("PROGRESS_YN", rset.getString(10) == null ? "" : rset.getString(10).trim());
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultMap;
	}

	// isDepartmentManager(): 부서 관리자(팀장, 파트장) 여부
	private static synchronized String isDepartmentManagerYN(String titleStr)
	{
		if (StringUtil.isNullString(titleStr)) return "N";

		if (titleStr.equals("팀장") || titleStr.equals("팀장대") || titleStr.equals("팀장(대)") ||
            titleStr.equals("파트장") || titleStr.equals("파트대") || titleStr.equals("파트장(대)"))
		{ return "Y"; }

		return "N";
	}

	// isDepartmentManager(): 부서 관리자(팀장 Only) 여부
	private static synchronized boolean isTeamManager(String titleStr)
	{
		if (!StringUtil.isNullString(titleStr) && (titleStr.equals("팀장") || titleStr.equals("팀장대") || titleStr.equals("팀장(대)"))) return true;
		else return false;

        /* if (isDepartmentManagerYN(titleStr).equals("Y")) return true;
        else return false; */
	}

	// getAllDepartmentOfSTXShipList() : 부서목록 전체를 쿼리
	private static synchronized ArrayList getAllDepartmentOfSTXShipList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,                                                                              ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,                                                                              ");
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A                                                                             ");
			queryStr.append(" WHERE 1 = 1                                                                                                  ");
			queryStr.append("   AND USE_YN = 'Y'                                                                                           ");
			queryStr.append(" ORDER BY DEPT_NAME                                                                                           ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				if ("101000".equals(rset.getString(1))) continue; // (임시처리) 중역실 Skip
				if ("101101".equals(rset.getString(1))) continue; // (임시처리) 총괄(유럽) Skip
				if ("101140".equals(rset.getString(1))) continue; // (임시처리) 회장 Skip
				if ("101220".equals(rset.getString(1))) continue; // (임시처리) 대표(유럽) Skip
				if ("267000".equals(rset.getString(1))) continue; // (임시처리) 정보운영팀 Skip 
				if ("290000".equals(rset.getString(1))) continue; // (임시처리) PI팀 Skip

				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// 부서목록 전체를 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	private static synchronized ArrayList getAllDepartmentOfSTXShipList_Dalian() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,                                                                              ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,                                                                              ");
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A                                                                             ");
			queryStr.append(" WHERE 1 = 1                                                                                                  ");
			queryStr.append("   AND USE_YN = 'Y'                                                                                           ");
			
            queryStr.append("UNION ALL                                                                                                     ");
			
            queryStr.append("SELECT A.DEPTCODE AS DEPT_CODE,								                                               ");
			queryStr.append("       A.DEPTNM AS DEPT_NAME,								                                                   ");
			queryStr.append("       '' AS UP_DEPT_NAME                                                                                     ");
			queryStr.append("  FROM DCC_DEPTCODE A,								                                                           ");
			queryStr.append("       Z_DALIAN_SAWON_TO111231 B												                               ");
			queryStr.append(" WHERE A.DWGDEPTCODE = B.DWG_DEPTCODE                                                                         ");
			queryStr.append(" GROUP BY A.DEPTCODE, A.DEPTNM                                                                                ");

            queryStr.append(" ORDER BY DEPT_NAME                                                                                           ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				if ("101000".equals(rset.getString(1))) continue; // (임시처리) 중역실 Skip
				if ("101101".equals(rset.getString(1))) continue; // (임시처리) 총괄(유럽) Skip
				if ("101140".equals(rset.getString(1))) continue; // (임시처리) 회장 Skip
				if ("101220".equals(rset.getString(1))) continue; // (임시처리) 대표(유럽) Skip
				if ("267000".equals(rset.getString(1))) continue; // (임시처리) 정보운영팀 Skip 
				if ("290000".equals(rset.getString(1))) continue; // (임시처리) PI팀 Skip

				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getAllDepartmentList() : 부서목록 전체를 쿼리
	private static synchronized ArrayList getAllDepartmentList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,                                                                              ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,                                                                              ");
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A                                                                             ");
			queryStr.append(" WHERE DEPT_CODE IN (SELECT DISTINCT(DEPT_CODE) FROM CCC_SAWON)                                               ");
			queryStr.append(" ORDER BY DEPT_CODE                                                                                           ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				if ("101101".equals(rset.getString(1))) continue; // (임시처리) 부회장 Skip
				if ("267000".equals(rset.getString(1))) continue; // (임시처리) 정보운영팀 Skip 
				if ("290000".equals(rset.getString(1))) continue; // (임시처리) PI팀 Skip

				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getDepartmentList() : 설계 부서목록 전체를 쿼리
	private static synchronized ArrayList getDepartmentList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
            /*
			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,                                                                  ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,                                                                  ");
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE)     ");
			queryStr.append("       AS UP_DEPT_NAME,                                                                           ");
			queryStr.append("       B.DWGDEPTCODE AS DWGDEPTCODE                                                               ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A,                                                                ");
			queryStr.append("       (                                                                                          ");
			queryStr.append("        SELECT DEPTCODE, DWGDEPTCODE                                                              ");
			queryStr.append("          FROM DCC_DEPTCODE                                                                       ");
			queryStr.append("         WHERE DWGDEPTCODE IN (SELECT DWGDEPTCODE FROM DCC_DWGDEPTCODE)                           ");
			queryStr.append("       ) B                                                                                        ");
			queryStr.append(" WHERE 1 = 1                                                                                      ");
			queryStr.append("   AND A.DEPT_CODE = B.DEPTCODE                                                                   ");
			queryStr.append(" ORDER BY DEPT_CODE                                                                               ");
            */
			queryStr.append("SELECT DECODE(A.DEPT_CODE, NULL, B.DEPTCODE, A.DEPT_CODE) AS DEPT_CODE,                        "); 
			queryStr.append("       DECODE(A.DEPT_NAME, NULL, B.DEPTNM, A.DEPT_NAME) AS DEPT_NAME,                          "); 
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE)  "); 
			queryStr.append("       AS UP_DEPT_NAME,                                                                        "); 
			queryStr.append("       B.DWGDEPTCODE AS DWGDEPTCODE                                                            "); 
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A,                                                             "); 
			queryStr.append("       (                                                                                       "); 
			queryStr.append("        SELECT DEPTCODE, DWGDEPTCODE, DEPTNM                                                   "); 
			queryStr.append("          FROM DCC_DEPTCODE                                                                    "); 
			queryStr.append("         WHERE DWGDEPTCODE IN (SELECT DWGDEPTCODE FROM DCC_DWGDEPTCODE)                        "); 
			queryStr.append("       ) B                                                                                     "); 
			queryStr.append(" WHERE 1 = 1                                                                                   "); 
			queryStr.append("   AND A.DEPT_CODE(+) = B.DEPTCODE                                                             ");
			
			queryStr.append(" ORDER BY DEPT_CODE                                                                            "); 

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultMap.put("DWGDEPTCODE", rset.getString(4));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getMHInputDepartmentList() : 시수입력 부서 목록을 쿼리
	private static synchronized ArrayList getMHInputDepartmentList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT DEPT_CODE,                                                                                       ");
			queryStr.append("       DEPT_NAME,                                                                                       ");
			queryStr.append("       UP_DEPT_NAME,                                                                                    ");
			queryStr.append("       DWG_DEPTCODE,                                                                                    ");
			queryStr.append("       ORDERNO                                                                                          ");
			queryStr.append("  FROM (                                                                                                ");
			queryStr.append("        SELECT A.DEPT_CODE AS DEPT_CODE,                                                                ");    
			queryStr.append("               A.DEPT_NAME AS DEPT_NAME,                                                                ");
			queryStr.append("               (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE)   ");
			queryStr.append("               AS UP_DEPT_NAME,                                                                         ");
			queryStr.append("               B.DWGDEPTCODE AS DWG_DEPTCODE                                                            ");
			queryStr.append("          FROM STX_COM_INSA_DEPT@STXERP A,                                                              ");
			queryStr.append("               DCC_DEPTCODE B                                                                           ");
			queryStr.append("         WHERE DEPT_CODE IN (                                                                           ");
			queryStr.append("                                SELECT DISTINCT(DEPT_CODE)                                              ");
			queryStr.append("                                  FROM CCC_SAWON                                                        ");
			queryStr.append("                                 WHERE INPUT_MAN_HOUR_ENABLED = 'Y' AND TERMINATION_DATE IS NULL        ");
			queryStr.append("                            )                                                                           ");
			queryStr.append("           AND A.DEPT_CODE = B.DEPTCODE(+)                                                              ");
			queryStr.append("       ) A, DCC_DWGDEPTCODE B                                                                           ");
			queryStr.append(" WHERE A.DWG_DEPTCODE = B.DWGDEPTCODE(+)                                                                ");
			queryStr.append(" ORDER BY B.ORDERNO, A.DEPT_CODE                                                                        ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}
	
	// getMHInputDepartmentTeamList() : 팀내 파트 목록 쿼리
		private static synchronized ArrayList getMHInputDepartmentTeamList(String insaDepartmentCode) throws Exception
		{
			java.sql.Connection conn = null;
			java.sql.Statement stmt = null;
			java.sql.ResultSet rset = null;

			ArrayList resultMapList = new ArrayList();

			try {
				conn = DBConnect.getDBConnection("SDPS");

				StringBuffer queryStr = new StringBuffer();

				queryStr.append("SELECT DEPT_CODE,                                                     ");
				queryStr.append("       DEPT_NAME                                                      ");
				queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP                                       ");
				queryStr.append(" WHERE 1=1                                                            ");
				queryStr.append("   AND USE_YN = 'Y'                                                   ");
				queryStr.append("   AND TEAM_CODE IN ( SELECT TEAM_CODE                                ");
				queryStr.append("                        FROM STX_COM_INSA_DEPT@STXERP                 ");
				queryStr.append("                       WHERE 1=1                                      ");
				queryStr.append("                         AND USE_YN = 'Y'                             ");
				queryStr.append("                         AND DEPT_CODE = '" + insaDepartmentCode + "')");
				queryStr.append(" ORDER BY DEPT_CODE                                                   ");

	            stmt = conn.createStatement();
	            rset = stmt.executeQuery(queryStr.toString());

				while (rset.next()) {
					HashMap resultMap = new HashMap();
					resultMap.put("DEPT_CODE", rset.getString(1));
					resultMap.put("DEPT_NAME", rset.getString(2));
					resultMapList.add(resultMap);
				}
			} catch (Exception e)
			{
				e.printStackTrace();
				throw e;
			}
			finally {
				if (rset != null) rset.close();
				if (stmt != null) stmt.close();
				DBConnect.closeConnection(conn);
			}

			return resultMapList;
		}
	
	// getProgressDepartmentList() : 공정사용 부서 목록을 쿼리
	private static synchronized ArrayList getProgressDepartmentList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
            /*
			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,                                                                              ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,                                                                              ");
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A                                                                             ");
			queryStr.append(" WHERE DEPT_CODE IN (                                                                                         ");
			queryStr.append("                        SELECT C.DEPTCODE                                                                     ");
			queryStr.append("                          FROM DCC_DEPTCODE C                                                                 ");
			queryStr.append("                         WHERE C.DWGDEPTCODE IN (SELECT DWGDEPTCODE FROM DCC_DWGDEPTCODE WHERE COUNTYN = 'Y') ");
			queryStr.append("                    )                                                                                         ");
			queryStr.append(" ORDER BY DEPT_CODE                                                                                           ");
            */
			queryStr.append("SELECT A.DEPTCODE AS DEPT_CODE,                                                                               "); 
			queryStr.append("       DECODE(B.DEPT_NAME, NULL, A.DEPTNM, B.DEPT_NAME) AS DEPT_NAME,                                         "); 
			queryStr.append("       DECODE(B.PARENT_CODE, NULL, '', (SELECT C.DEPT_NAME                                                    "); 
			queryStr.append("                                          FROM STX_COM_INSA_DEPT@STXERP C WHERE C.DEPT_CODE = B.PARENT_CODE)  "); 
			queryStr.append("             )                                                                                                "); 
			queryStr.append("       AS UP_DEPT_NAME                                                                                        "); 
			queryStr.append("  FROM (                                                                                                      "); 
			queryStr.append("        SELECT C.DEPTCODE, C.DEPTNM                                                                           "); 
			queryStr.append("          FROM DCC_DEPTCODE C                                                                                 "); 
			queryStr.append("         WHERE C.DWGDEPTCODE IN (SELECT DWGDEPTCODE FROM DCC_DWGDEPTCODE WHERE COUNTYN = 'Y')                 "); 
			queryStr.append("       ) A,                                                                                                   "); 
			queryStr.append("       STX_COM_INSA_DEPT@STXERP B                                                                             "); 
			queryStr.append(" WHERE 1 = 1                                                                                                  "); 
			queryStr.append("   AND A.DEPTCODE = B.DEPT_CODE(+)                                                                            ");
			queryStr.append("   AND B.USE_YN = 'Y'                                                                                         ");
			queryStr.append("  ORDER BY DEPTCODE                                                                                           "); 

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getPartListUnderTeamStr() : 팀 하위의 파트 부서코드 리스트를 CSV 형태로 리턴
	private static synchronized String getPartListUnderTeamStr(String teamDeptCode) throws Exception
	{
		if (StringUtil.isNullString(teamDeptCode)) throw new Exception("Team Code is null!");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String partListStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			// 2015-07-09 Kang seonjung : 현재 사용 부서만 조회
			//queryStr.append("SELECT DEPT_CODE                                                ");
			//queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP                                 ");
			//queryStr.append(" WHERE DEPT_CODE LIKE '" + teamDeptCode.substring(0, 3) + "%'   ");

			queryStr.append("SELECT DEPT_CODE                                                ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP                                 ");
			queryStr.append(" WHERE TEAM_CODE = '" + teamDeptCode + "'                       ");
			queryStr.append("   AND USE_YN = 'Y'                                             ");
			queryStr.append(" ORDER BY DEPT_CODE                                             ");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				if (!partListStr.equals("")) partListStr += ",";
				partListStr += rset.getString(1);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return partListStr;
	}

	// 부서의 종류(상선, 해양, 특수선)를 판단 - TODO (현재는 해양부서 여부만 Hard Code 로 판단)
	private static int getDwgDeptGubun(String deptCode) throws Exception
	{
        /* RETRUN 값 = 1: 상선, 2: 해양, 3: 특수선, 0: Unknown */

        int resultValue = 0;
		if (!StringUtil.isNullString(deptCode) && deptCode.equals("938000")) resultValue = 1;
        if (!StringUtil.isNullString(deptCode) && deptCode.substring(0, 1).equals("9")) resultValue = 2;

        return resultValue;
	}

	// getDPInputLockList() : 설계부서 전체와 각 부서의 시수입력 LOCk 정보를 쿼리
	private static synchronized ArrayList getDPInputLockList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.DEPT_CODE,                                                                                        ");
			queryStr.append("       B.DEPT_NAME,                                                                                        ");
			queryStr.append("       TO_CHAR((SELECT NVL(                                                                                ");
			queryStr.append("                               (                                                                           ");
			queryStr.append("                                SELECT C.START_DATE                                                        ");
			queryStr.append("                                  FROM PLM_DESIGN_MH_LOCK C                                                ");
			queryStr.append("                                 WHERE C.DEPT_CODE = A.DEPT_CODE                                           ");
			queryStr.append("                                   AND TO_CHAR(C.END_DATE, 'YYYY-MM-DD') >= TO_CHAR(SYSDATE, 'YYYY-MM-DD') ");
			queryStr.append("                               ),                                                                          ");
			queryStr.append("                               (                                                                           ");
			queryStr.append("                                SELECT DDD.WORKINGDAY AS S_DATE                                            ");
			queryStr.append("                                  FROM (                                                                   ");
			queryStr.append("                                        SELECT ROWNUM AS ROW_NUM, DD.WORKINGDAY                            ");
			queryStr.append("                                          FROM (                                                           ");
			queryStr.append("                                                SELECT CALENDAR.WORKINGDAY                                 ");
			queryStr.append("                                                  FROM CCC_CALENDAR CALENDAR                               ");
			queryStr.append("                                                 WHERE CALENDAR.WORKINGDAY <= SYSDATE                      ");
			queryStr.append("                                                   AND CALENDAR.ISWORKDAY = 'Y'                            ");
			queryStr.append("                                                 ORDER BY CALENDAR.WORKINGDAY DESC                         ");
			queryStr.append("                                                ) DD                                                       ");
			queryStr.append("                                       ) DDD                                                               ");
			queryStr.append("                                 WHERE DDD.ROW_NUM = 2                                                     ");
			queryStr.append("                               )                                                                           ");
			queryStr.append("                          )                                                                                ");
			queryStr.append("                  FROM DUAL), 'YYYY-MM-DD')                                                                ");
			queryStr.append("       AS LOCK_DATE                                                                                        ");
			queryStr.append("  FROM (                                                                                                   ");
			queryStr.append("        SELECT DISTINCT(DEPT_CODE)                                                                         ");
			queryStr.append("          FROM CCC_SAWON                                                                                   ");
			queryStr.append("         WHERE INPUT_MAN_HOUR_ENABLED = 'Y'                                                                ");
			queryStr.append("           AND TERMINATION_DATE IS NULL                                                                    ");
			queryStr.append("       ) A,                                                                                                ");
			queryStr.append("       STX_COM_INSA_DEPT@STXERP B                                                                          ");
			queryStr.append(" WHERE A.DEPT_CODE = B.DEPT_CODE                                                                           ");
			queryStr.append(" ORDER BY DEPT_CODE                                                                                        ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("LOCK_DATE", rset.getString(3));
				//resultMap.put("DEFAULT_DATE", rset.getString(4));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// updateDPInputLockList() : 설계부서 시수입력 LOCk 정보 DB 업데이트
	private static synchronized void updateDPInputLockList(ArrayList lockDataList) throws Exception
	{
		if (lockDataList == null || lockDataList.size() <= 0) throw new Exception("No item to update!");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer queryStr = new StringBuffer();

				queryStr.append("MERGE INTO PLM_DESIGN_MH_LOCK A                                             ");
				queryStr.append("USING (SELECT 1 FROM DUAL)                                                  ");
				queryStr.append("   ON (? IN A.DEPT_CODE)                                                    ");
				queryStr.append(" WHEN MATCHED THEN                                                          ");
				queryStr.append("      UPDATE SET START_DATE = TO_DATE(?, 'YYYY-MM-DD'),                     ");
				queryStr.append("                 END_DATE = SYSDATE, UPDATE_DATE = SYSDATE, UPDATE_BY = ''  ");
				queryStr.append(" WHEN NOT MATCHED THEN                                                      ");
				queryStr.append("      INSERT VALUES(?, TO_DATE(?, 'YYYY-MM-DD'),                            ");
				queryStr.append("                    SYSDATE, SYSDATE, '', SYSDATE, '')                      ");

				ppStmt = conn.prepareStatement(queryStr.toString()); 

				for (int i = 0; i < lockDataList.size(); i++) {
					String str = (String)lockDataList.get(i);
					ArrayList strs = FrameworkUtil.split(str, "|");
					ppStmt.setString(1, (String)strs.get(0));
					ppStmt.setString(2, (String)strs.get(1));
					ppStmt.setString(3, (String)strs.get(0));
					ppStmt.setString(4, (String)strs.get(1));
					ppStmt.executeUpdate();
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getDPInputLockDate() : 해당 부서의 시수입력 LOCK 일자를 쿼리
	private static synchronized String getDPInputLockDate(String empNo) throws Exception
	{
		if (StringUtil.isNullString(empNo)) throw new Exception("Employee No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT TO_CHAR((SELECT NVL(                                                                                      ");
			queryStr.append("                               (                                                                                 ");
			queryStr.append("                                SELECT C.START_DATE                                                              ");
			queryStr.append("                                  FROM PLM_DESIGN_MH_LOCK C                                                      ");
			queryStr.append("                                 WHERE C.DEPT_CODE = (SELECT DEPT_CODE                                           ");
			queryStr.append("                                                        FROM CCC_SAWON                                           ");
			queryStr.append("                                                       WHERE EMPLOYEE_NUM = '" + empNo + "')                     ");
			queryStr.append("                                   AND TO_CHAR(C.END_DATE, 'YYYY-MM-DD') >= TO_CHAR(SYSDATE, 'YYYY-MM-DD')       ");
			queryStr.append("                               ),                                                                                ");
			queryStr.append("                               (                                                                                 ");
			queryStr.append("                                SELECT DDD.WORKINGDAY AS S_DATE                                                  ");
			queryStr.append("                                  FROM (                                                                         ");
			queryStr.append("                                        SELECT ROWNUM AS ROW_NUM, DD.WORKINGDAY                                  ");
			queryStr.append("                                          FROM (                                                                 ");
			queryStr.append("                                                SELECT CALENDAR.WORKINGDAY                                       ");
			queryStr.append("                                                  FROM CCC_CALENDAR CALENDAR                                     ");
			queryStr.append("                                                 WHERE CALENDAR.WORKINGDAY <= SYSDATE                            ");
			queryStr.append("                                                   AND CALENDAR.ISWORKDAY = 'Y'                                  ");
			queryStr.append("                                                 ORDER BY CALENDAR.WORKINGDAY DESC                               ");
			queryStr.append("                                                ) DD                                                             ");
			queryStr.append("                                       ) DDD                                                                     ");
			queryStr.append("                                 WHERE DDD.ROW_NUM = 2                                                           ");
			queryStr.append("                               )                                                                                 ");
			queryStr.append("                          )                                                                                      ");
			queryStr.append("                  FROM DUAL), 'YYYY-MM-DD')                                                                      ");
			queryStr.append("       AS LOCK_DATE                                                                                              ");
			queryStr.append("  FROM DUAL                                                                                                      ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultStr = rset.getString(1);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getDPProgressLockList() : 설계부서 전체와 각 부서의 공정(실적)입력 LOCk 정보를 쿼리
	private static synchronized ArrayList getDPProgressLockList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.DWGDEPTCODE AS DEPT_CODE,                                                                   ");
			queryStr.append("       A.DWGDEPTNM AS DEPT_NAME,                                                                     ");
			queryStr.append("       NVL((SELECT C.RESTRICT_TO FROM PLM_PROGRESS_LOCK C WHERE C.DEPT_CODE = A.DWGDEPTCODE), '')    ");
			queryStr.append("       AS LOCK_DATE                                                                                  ");
			queryStr.append("  FROM DCC_DWGDEPTCODE A                                                                             ");
			queryStr.append(" WHERE A.COUNTYN = 'Y'                                                                               ");
			queryStr.append(" ORDER BY A.DWGDEPTCODE                                                                              ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("LOCK_DATE", rset.getString(3) == null ? "" : rset.getString(3));
				resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
			throw e;
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// updateDPProgressLockList() : 설계부서 별 공정(실적)입력 LOCk 정보 DB 업데이트
	private static synchronized void updateDPProgressLockList(ArrayList lockDataList) throws Exception
	{
		if (lockDataList == null || lockDataList.size() <= 0) throw new Exception("No item to update!");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer queryStr = new StringBuffer();

				queryStr.append("MERGE INTO PLM_PROGRESS_LOCK A                            ");            
				queryStr.append("USING (SELECT 1 FROM DUAL)                                ");             
				queryStr.append("   ON (? IN A.DEPT_CODE)                                  ");             
				queryStr.append(" WHEN MATCHED THEN                                        ");             
				queryStr.append("      UPDATE SET RESTRICT_TO = ?,                         ");
				queryStr.append("                 UPDATE_DATE = SYSDATE, UPDATE_BY = ''    ");
				queryStr.append(" WHEN NOT MATCHED THEN                                    ");             
				queryStr.append("      INSERT VALUES(?, ?,                                 ");
				queryStr.append("                    SYSDATE, '', SYSDATE, '')             ");

				ppStmt = conn.prepareStatement(queryStr.toString()); 

				for (int i = 0; i < lockDataList.size(); i++) {
					String str = (String)lockDataList.get(i);
					ArrayList strs = FrameworkUtil.split(str, "|");
					ppStmt.setString(1, (String)strs.get(0));
					ppStmt.setString(2, (String)strs.get(1));
					ppStmt.setString(3, (String)strs.get(0));
					ppStmt.setString(4, (String)strs.get(1));
					ppStmt.executeUpdate();
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getDPProgressLockDate() : 해당 부서의 공정(실적)입력 제한 값을 쿼리
	private static synchronized String getDPProgressLockDate(String deptCode) throws Exception
	{
		if (StringUtil.isNullString(deptCode)) throw new Exception("Dept. Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT RESTRICT_TO                     ");
			queryStr.append("  FROM PLM_PROGRESS_LOCK               ");
			queryStr.append(" WHERE DEPT_CODE = '" + deptCode + "'  ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultStr = (rset.getString(1) == null) ? "" : rset.getString(1);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	/* => getDPInputLockDate() 추가로 필요 없어짐 (2009-06-30)
	// getWorkingDaysGap() : 해당 날짜와 오늘날자 사이에 Work Day가 몇일 존재하는지 쿼리(단, 일 년 이상이면 계산하지 않고 -1 리턴)
	private static synchronized String getWorkDaysGap(String dateStr) throws Exception
	{
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT (																							");
			queryStr.append("   CASE WHEN ADD_MONTHS(TO_DATE('" + dateStr + "', 'YYYY-MM-DD'), 12) < SYSDATE THEN -1		    ");
			queryStr.append("        ELSE (SELECT COUNT(*) FROM CCC_CALENDAR													");
			queryStr.append("               WHERE WORKINGDAY BETWEEN TO_DATE('" + dateStr + "', 'YYYY-MM-DD') + 1 AND SYSDATE	");
			queryStr.append("                 AND ISWORKDAY = 'Y')																");
			queryStr.append("        END																						");
			queryStr.append("  ) AS WORKDAY_GAP																					");
			queryStr.append("FROM DUAL																							");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultStr = rset.getString(1);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}
	*/

	// getDateHolidayInfo() : 해당 날짜의 휴일 여부를 쿼리
	private static synchronized String getDateHolidayInfo(String dateStr) throws Exception
	{
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			String queryStr = "SELECT ISWORKDAY, INSIDEWORKTIME FROM CCC_CALENDAR WHERE WORKINGDAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD')";

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr);

			if (rset.next()) {
				resultStr = rset.getString(1);
				if (rset.getString(2) != null && rset.getString(2).equals("4")) resultStr = "4H";
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getMHInputConfirmYN() : 해당 사번 + 날짜의 시수입력의 결재 여부를 쿼리
	private static synchronized String getMHInputConfirmYN(String employeeID, String dateStr) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT distinct(NVL(CONFIRM_YN, 'N'))   					");
			queryStr.append("  FROM PLM_DESIGN_MH										");
			queryStr.append(" WHERE EMPLOYEE_NO = '" + employeeID + "'					");
			queryStr.append("   AND WORK_DAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD') ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());
            
			if (rset.next()) {
				resultStr = rset.getString(1); // "Y" or "N"
				System.out.println(resultStr);
				if (rset.next()) resultStr = "N";
			}
			
			else resultStr = "N";
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getSelectedProjectList() : 해당 사번에 대해 선택된 작업호선 목록을 쿼리
	private static synchronized ArrayList getSelectedProjectList(String employeeID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			/*
			queryStr.append("SELECT PROJECTNO, NVL(DL, SYSDATE + 1) AS DL,                                                                      ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - ADD_MONTHS(NVL(DL, SYSDATE + 1), 1)), 1, 'N', 0, 'N', -1, 'Y') AS DL_EFFECTIVE	");
			queryStr.append("  FROM LPM_NEWPROJECT																								");
			queryStr.append(" WHERE CASENO='1' AND PROJECTNO IN (																				");
			queryStr.append("                                    SELECT PROJECT_NO																");
			queryStr.append("                                    FROM PLM_USER_PROJECT WHERE EMPLOYEE_NO = '" + employeeID + "'					");
			queryStr.append("                                                            AND (END_DATE IS NULL OR END_DATE >= SYSDATE)			");
			queryStr.append("                                   )																				");
			queryStr.append(" ORDER BY PROJECTNO																								");
			*/

			queryStr.append("SELECT PROJECTNO, DL, DL_EFFECTIVE, DWGSERIESPROJECTNO                                                            ");
			queryStr.append("  FROM (                                                                                                          ");
			queryStr.append("        SELECT PROJECTNO, NVL(DL, SYSDATE + 1) AS DL,                                                             ");
			queryStr.append("               DECODE(SIGN(TRUNC(SYSDATE) - LAST_DAY(ADD_MONTHS(NVL(DL, SYSDATE + 1), 1))), 1, 'N', 0, 'N', -1, 'Y')        ");
			queryStr.append("               AS DL_EFFECTIVE,	                                                                               ");
			queryStr.append("               DWGSERIESPROJECTNO                                                                                 ");
			queryStr.append("          FROM LPM_NEWPROJECT																					   ");
			queryStr.append("         WHERE CASENO='1' AND PROJECTNO IN (																	   ");
			queryStr.append("                                            SELECT PROJECT_NO													   ");
			queryStr.append("                                            FROM PLM_USER_PROJECT WHERE EMPLOYEE_NO = '" + employeeID + "'		   ");
			queryStr.append("                                                                    AND (END_DATE IS NULL OR END_DATE >= SYSDATE) ");
			queryStr.append("                                           )																	   ");
			queryStr.append("           AND DWGMHYN = 'Y'		                                                                               ");
			queryStr.append("         ORDER BY PROJECTNO		                                                                               ");
			queryStr.append("       )                                                                                                          ");
			queryStr.append("UNION                                                                                                             ");
			queryStr.append("SELECT PROJECT_NO, SYSDATE + 1, 'Y', ''                                                                           ");
			queryStr.append("  FROM PLM_USER_PROJECT   A                                                                                        ");
			queryStr.append(" WHERE EMPLOYEE_NO = '" + employeeID + "'					                                                       ");
			queryStr.append("   AND (END_DATE IS NULL OR END_DATE >= SYSDATE)                                                                  ");
			queryStr.append("   AND SUBSTR(PROJECT_NO, 1, 1) >= '1'                                                                            ");
			queryStr.append("   AND SUBSTR(PROJECT_NO, 1, 1) <= '9'                                                                            ");
			queryStr.append("   AND EXISTS (SELECT 1                                                                                           ");
			queryStr.append("                 FROM LPM_NEWPROJECT L                                                                            ");
			queryStr.append("                WHERE L.PROJECTNO = A.PROJECT_NO                                                                  ");
			queryStr.append("                  AND L.CASENO = '1'                                                                              ");
			queryStr.append("                  AND NVL(L.DWGMHYN,'N') = 'Y' )                                                                  ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1));
				resultMap.put("DL_EFFECTIVE", rset.getString(3));
				resultMap.put("DWGSERIESPROJECTNO", rset.getString(4));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getInvalidSelectedProjectList() : 해당 사번에 대해 선택된 작업호선 항목들 중에 호선명 변경 등으로 비-유효해진 항목들을 쿼리
	private static synchronized ArrayList getInvalidSelectedProjectList(String employeeID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			/*
			queryStr.append("SELECT PROJECT_NO																			");
			queryStr.append("  FROM PLM_USER_PROJECT																	");
			queryStr.append(" WHERE EMPLOYEE_NO = '" + employeeID + "' AND (END_DATE IS NULL OR END_DATE >= SYSDATE)	");
			queryStr.append("   AND PROJECT_NO NOT IN (SELECT PROJECTNO FROM LPM_NEWPROJECT WHERE CASENO = '1')			");
			queryStr.append(" ORDER BY PROJECT_NO																		");
			*/

			queryStr.append("SELECT PROJECT_NO                                                                                  ");
			queryStr.append("  FROM (                                                                                           ");
			queryStr.append("        SELECT PROJECT_NO																		    ");
			queryStr.append("          FROM PLM_USER_PROJECT																    ");
			queryStr.append("         WHERE EMPLOYEE_NO = '" + employeeID + "' AND (END_DATE IS NULL OR END_DATE >= SYSDATE)    ");
			queryStr.append("           AND PROJECT_NO NOT IN (SELECT PROJECTNO FROM LPM_NEWPROJECT WHERE CASENO = '1')		    ");
			queryStr.append("         ORDER BY PROJECT_NO																	    ");
			queryStr.append("       )                                                                                           ");
			queryStr.append("MINUS                                                                                              "); 
			queryStr.append("SELECT PROJECT_NO                                                                                  ");
			queryStr.append("  FROM PLM_USER_PROJECT                                                                            ");
			queryStr.append(" WHERE EMPLOYEE_NO = '" + employeeID + "'					                                        ");
			queryStr.append("   AND (END_DATE IS NULL OR END_DATE >= SYSDATE)                                                   ");
			queryStr.append("   AND SUBSTR(PROJECT_NO, 1, 1) >= '1'                                                             ");
			queryStr.append("   AND SUBSTR(PROJECT_NO, 1, 1) <= '9'                                                             ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getAllProjectList() : 전체 호선 목록을 쿼리
	private static synchronized ArrayList getAllProjectList(String employeeID) throws Exception
	{
		//if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT PROJECTNO, NVL(DL, SYSDATE + 1) AS DL,                                                                      ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - LAST_DAY(ADD_MONTHS(NVL(DL, SYSDATE + 1), 1))), 1, 'N', 0, 'N', -1, 'Y') AS DL_EFFECTIVE ");
			queryStr.append("  FROM LPM_NEWPROJECT                                                                                              ");
			queryStr.append(" WHERE CASENO='1' AND PROJECTNO <> 'S0000'                                                                         ");
			queryStr.append("   AND DWGMHYN='Y'                                                                                                 ");
			//queryStr.append("              AND PROJECTNO NOT IN ( ");
			//queryStr.append("                                   SELECT PROJECT_NO ");
			//queryStr.append("                                   FROM PLM_USER_PROJECT WHERE EMPLOYEE_NO = '" + employeeID + "' AND (END_DATE IS NULL OR END_DATE >= SYSDATE) ");
			//queryStr.append("                                    ) ");
			queryStr.append(" ORDER BY PROJECTNO                                                                                                ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1));
				resultMap.put("DL_EFFECTIVE", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getAllModelList() : 전체 모델 목록을 쿼리(ERP 견적관련 테이블에서 쿼리)
	private static synchronized ArrayList getAllModelList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT MODEL_NO FROM STX_DT_MODEL@STXERP ORDER BY MODEL_NO ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("MODEL_NO", rset.getString(1));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// updateSelectedProjectList() : 해당 사번에 대해 선택된 작업호선 목록을 업데이트
	private static synchronized void updateSelectedProjectList(String employeeID, ArrayList selectedProjects) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.PreparedStatement ppStmt1 = null;
		java.sql.PreparedStatement ppStmt2 = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String initQueryStr = "UPDATE PLM_USER_PROJECT A SET A.END_DATE = SYSDATE -1 " + 
					                   "WHERE A.EMPLOYEE_NO = '" + employeeID + "' AND (A.END_DATE IS NULL OR A.END_DATE >= SYSDATE)";
				String execQueryStr1 = "UPDATE PLM_USER_PROJECT A SET A.END_DATE = NULL WHERE A.EMPLOYEE_NO = '" + employeeID + "' AND A.PROJECT_NO = ?";
				StringBuffer execQueryStr2 = new StringBuffer();
				execQueryStr2.append("INSERT INTO PLM_USER_PROJECT A  ");
				execQueryStr2.append("            SELECT '" + employeeID + "', ?, SYSDATE, NULL, SYSDATE, '" + employeeID + "', SYSDATE, '" + employeeID + "' ");
				execQueryStr2.append("              FROM DUAL ");
				execQueryStr2.append("             WHERE NOT EXISTS( ");
				execQueryStr2.append("                              SELECT 1 FROM PLM_USER_PROJECT B WHERE  B.EMPLOYEE_NO = '" + employeeID + "' and B.PROJECT_NO = ? ");
				execQueryStr2.append("                             ) ");

				stmt = conn.createStatement(); // 먼저 기 존재하는 것을 모두 Inactive 상태로 만들고, 
				stmt.executeUpdate(initQueryStr);

				if (selectedProjects.size() > 0) {
					ppStmt1 = conn.prepareStatement(execQueryStr1); // 기 존재하는 것이 있으면 업데이트하고 그리고 
					ppStmt2 = conn.prepareStatement(execQueryStr2.toString()); // 존재하지 않는 것은 신규로 추가한다.

					for (int i = 0; i < selectedProjects.size(); i++) {
						String projectNo = (String)selectedProjects.get(i);
						ppStmt1.setString(1, projectNo);
						ppStmt1.executeUpdate();

						ppStmt2.setString(1, projectNo);
						ppStmt2.setString(2, projectNo);
						ppStmt2.executeUpdate();
					}
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (stmt != null) stmt.close();
			if (ppStmt1 != null) ppStmt1.close();
			if (ppStmt2 != null) ppStmt2.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getProgressSearchableProjectList() : 공정부분 조회가능 Project 리스트 쿼리
	private static synchronized ArrayList getProgressSearchableProjectList(String loginID, boolean openedOnly, String category) 
	throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement updateStmt = null;
		java.sql.Statement queryStmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("MERGE INTO PLM_SEARCHABLE_PROJECT A                                                      ");
			queryStr.append("USING (SELECT DISTINCT(PROJECTNO) AS B FROM PLM_ACTIVITY)                                ");
			queryStr.append("   ON (B IN A.PROJECTNO AND A.CATEGORY = '" + category + "')                             ");
			queryStr.append(" WHEN MATCHED THEN                                                                       ");
			queryStr.append("      UPDATE SET UPDATEDATE = UPDATEDATE                                                 ");
			queryStr.append(" WHEN NOT MATCHED THEN                                                                   ");
			queryStr.append("      INSERT VALUES('" + category + "', B, 'ALL', SYSDATE, '" + loginID + "',            ");
			queryStr.append("                    SYSDATE, '" + loginID + "')                                          ");

			String queryStr2 =           "SELECT A.PROJECTNO, A.STATE,                                                ";
            queryStr2 +=                 "       (SELECT B.DWGSERIESSERIALNO FROM LPM_NEWPROJECT B                    ";
			queryStr2 +=                 "         WHERE B.CASENO='1' and B.PROJECTNO = A.PROJECTNO) AS S_NO          ";
			queryStr2 +=                 "  FROM PLM_SEARCHABLE_PROJECT A                                             ";
			queryStr2 +=                 " WHERE 1 = 1                                                                ";
			queryStr2 +=                 "   AND A.CATEGORY = '" + category + "'                                      ";
			if (openedOnly) queryStr2 += "   AND A.STATE <> 'CLOSED'                                                  ";
			queryStr2 +=                 "   ORDER BY PROJECTNO                                                       ";


            updateStmt = conn.createStatement();
            queryStmt = conn.createStatement();

			// 먼저 DP 확정된 모든 호선은 PLM_SEARCHABLE_PROJECT 테이블에 등록시킨다(이미 있으면 무시, 없으면 Insert)
			if (!openedOnly) updateStmt.executeUpdate(queryStr.toString());

			// PLM_SEARCHABLE_PROJECT 테이블에서 호선과 상태(Opened or Closed) 목록을 쿼리한다
            rset = queryStmt.executeQuery(queryStr2);

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1));
				resultMap.put("STATE", rset.getString(2));
				resultMap.put("SERIALNO", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (updateStmt != null) updateStmt.close();
			if (queryStmt != null) queryStmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// 공정부분 조회가능 Project 리스트 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	private static synchronized ArrayList getProgressSearchableProjectList_Dalian(String loginID, boolean openedOnly, String category) 
	throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement queryStmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
            queryStmt = conn.createStatement();
            rset = queryStmt.executeQuery("SELECT * FROM Z_DALIAN_PROJECT_TO111231");

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1));
				resultMap.put("STATE", "ALL");
				resultMap.put("SERIALNO", "0");
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (queryStmt != null) queryStmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// updateSearchableProjectList() : 공정부분 조회가능 Project 목록 업데이트
	private static synchronized void updateSearchableProjectList(ArrayList projectList, String loginID, String category) 
	throws Exception
	{
		if (projectList == null || projectList.size() <= 0) throw new Exception("No item to update!");
		loginID = StringUtil.setEmptyExt(loginID);

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr = "UPDATE PLM_SEARCHABLE_PROJECT                                        " + 
					                  "   SET STATE = ?, UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "' " + 
					                  " WHERE PROJECTNO = ?                                                 " + 
					                  "   AND CATEGORY = '" + category + "'                                 ";

				ppStmt = conn.prepareStatement(execQueryStr); 

				for (int i = 0; i < projectList.size(); i++) {
					String str = (String)projectList.get(i);
					ArrayList strs = FrameworkUtil.split(str, "|");
					ppStmt.setString(1, (String)strs.get(1));
					ppStmt.setString(2, (String)strs.get(0));
					ppStmt.executeUpdate();
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getDrawingTypesForWork() : 부서 + 호선에 대해 할당된 도면구분(도면코드의 첫 글자)들을 쿼리
	private static synchronized String getDrawingTypesForWork(String departCode, String projectNo) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.Statement stmt2 = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			String queryStr = "";
            queryStr += "SELECT DISTINCT(DWGTYPE)                                                                                "; 
			queryStr += "  FROM PLM_ACTIVITY                                                                                     "; 
			queryStr += " WHERE PROJECTNO = '" + projectNo + "' AND WORKTYPE = 'DW'                                              "; 
			if (!departCode.equals("440500"))  
			{   // 검도교육P는 업무특성으로 인해 전 부서 도면을 조회
				queryStr += "   AND DWGDEPTCODE = (SELECT E.DWGDEPTCODE FROM DCC_DEPTCODE E WHERE E.DEPTCODE = '" + departCode + "') "; 
			} 
			queryStr += " ORDER BY DWGTYPE                                                                                       ";

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				if (!resultStr.equals("")) resultStr += "|";
				resultStr += rset.getString(1);
			}
			
			//if (resultStr.equals("")) resultStr = "B"; // 생성된 DP가 없어도(PLM_ACTIVITY 테이블에 데이터 X) 기본도(B) 항목은 기본 표시한다

			// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
			// : DPC_HEAD 테이블에서 Max CaseNo 이고 DWGDEPTCODE 가 해당 부서인 것이면서 
			// : SHIPTYPE(선종) 컬럼 값이 해당 호선의 선종을 포함하는 것이 대상 
			// : - 참고: SHIPTYPE 컬럼 값은 Bit 합으로 되어 있고 선종코드는 코드테이블(CCC_CODE)에 정의되어 있다
			if (resultStr.equals("")) 
			{ 
				StringBuffer queryStr2 = new StringBuffer();
				queryStr2.append("SELECT DISTINCT(DWGTYPE)                                                                                    ");
				queryStr2.append("  FROM DPC_HEAD A                                                                                           ");
				queryStr2.append(" WHERE 1 = 1                                                                                                ");
				queryStr2.append("   AND A.CASENO = (SELECT MAX(CASENO) FROM DPC_HEAD)                                                        ");
				if (!departCode.equals("440500")) 
				{   // 검도교육P는 업무특성으로 인해 전 부서 도면을 조회
					queryStr2.append("   AND A.DWGDEPTCODE = (SELECT DWGDEPTCODE FROM DCC_DEPTCODE WHERE DEPTCODE = '" + departCode + "')    ");
				}
				queryStr2.append("   AND (SELECT COUNT(*) FROM CCC_CODE B                                                                     ");
				queryStr2.append("         WHERE B.P_CODE = 'SHIPTYPE' AND B.M_CODE = 'SHIPTYPE'                                              ");
				queryStr2.append("           AND B.C_CODE = (SELECT C.SHIPTYPE FROM LPM_NEWPROJECT C WHERE C.CASENO = '1'                     ");
				queryStr2.append("                                                                     AND C.PROJECTNO = '" + projectNo + "') ");
				queryStr2.append("           AND B.ATTRIBUTE1 = BITAND(B.ATTRIBUTE1, A.SHIPTYPE)                                              ");
				queryStr2.append("        ) > 0                                                                                               ");

				stmt2 = conn.createStatement();
				rset = stmt2.executeQuery(queryStr2.toString());

				while (rset.next()) {
					if (!resultStr.equals("")) resultStr += "|";
					resultStr += rset.getString(1);
				}
			}
			
			// Start :: 2015-02-04 Kang seonjung : (서광훈 과장 요청) 선체생산설계-선형기술P(480100)는 000029(선형기술P), 000051(선체생설P) 조회 가능
			// 선형기술P가 선체생설P 도면 조회 때도 DP에 없으면 WBS에서 가져옴
			if(departCode.equals("480100")) 
			{
				boolean resultFlag = false;
				String queryStr3 = "";				
				queryStr3 += "SELECT DISTINCT(DWGTYPE)                                                                                "; 
				queryStr3 += "  FROM PLM_ACTIVITY                                                                                     "; 
				queryStr3 += " WHERE PROJECTNO = '" + projectNo + "' AND WORKTYPE = 'DW'                                              "; 
				queryStr3 += "   AND DWGDEPTCODE IN ('000051')                                                                        "; 
				queryStr3 += " ORDER BY DWGTYPE                                                                                       ";

				rset = stmt.executeQuery(queryStr3.toString());

				while (rset.next())
				{
					resultFlag = true;
					String tempDWGTYPE = rset.getString(1);
					if(resultStr.indexOf(tempDWGTYPE) < 1)
					{
						if (!resultStr.equals("")) resultStr += "|";
						resultStr += tempDWGTYPE;
					}
				}
				
				// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
				if(!resultFlag)
				{
					StringBuffer queryStr4 = new StringBuffer();
					queryStr4.append("SELECT DISTINCT(DWGTYPE)                                                                                    ");
					queryStr4.append("  FROM DPC_HEAD A                                                                                           ");
					queryStr4.append(" WHERE 1 = 1                                                                                                ");
					queryStr4.append("   AND A.CASENO = (SELECT MAX(CASENO) FROM DPC_HEAD)                                                        ");
					queryStr4.append("   AND DWGDEPTCODE IN ('000051')                                                                            "); 					
					queryStr4.append("   AND (SELECT COUNT(*) FROM CCC_CODE B                                                                     ");
					queryStr4.append("         WHERE B.P_CODE = 'SHIPTYPE' AND B.M_CODE = 'SHIPTYPE'                                              ");
					queryStr4.append("           AND B.C_CODE = (SELECT C.SHIPTYPE FROM LPM_NEWPROJECT C WHERE C.CASENO = '1'                     ");
					queryStr4.append("                                                                     AND C.PROJECTNO = '" + projectNo + "') ");
					queryStr4.append("           AND B.ATTRIBUTE1 = BITAND(B.ATTRIBUTE1, A.SHIPTYPE)                                              ");
					queryStr4.append("        ) > 0                                                                                               ");

					rset = stmt.executeQuery(queryStr4.toString());

					while (rset.next())
					{
						
						String tempDWGTYPE = rset.getString(1);
						if(resultStr.indexOf(tempDWGTYPE) < 1)
						{
							if (!resultStr.equals("")) resultStr += "|";
							resultStr += tempDWGTYPE;
						}
					}
				}
			}
			//END :: 2015-02-04 Kang seonjung
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			if (stmt2 != null) stmt2.close();
			DBConnect.closeConnection(conn);
		}
		return resultStr;
	}

	// getDrawingListForWork() : 부서 + 호선 + 타입에 해당하는 도면들 목록을 쿼리
	private static synchronized String getDrawingListForWork(String departCode, String projectNo, String drawingType) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (StringUtil.isNullString(drawingType)) throw new Exception("Drawing Type is null");
		if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.Statement stmt2 = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			String queryStr = "";
            queryStr += "SELECT SUBSTR(ACTIVITYCODE, 1, 8), DWGTITLE                                                             "; 
			queryStr += "  FROM PLM_ACTIVITY                                                                                     "; 
			queryStr += " WHERE PROJECTNO = '" + projectNo + "'                                                                  "; 
			queryStr += "   AND WORKTYPE = 'DW'                                                                                  ";
			if (!departCode.equals("440500"))  
			{   // 검도교육P는 업무특성으로 인해 전 부서 도면을 조회
				queryStr += "   AND DWGDEPTCODE = (SELECT E.DWGDEPTCODE FROM DCC_DEPTCODE E WHERE E.DEPTCODE = '" + departCode + "') "; 
			} 
			queryStr += "   AND DWGTYPE = '" + drawingType + "'                                                                  "; 
			queryStr += " ORDER BY ACTIVITYCODE                                                                                  ";

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr);

			while (rset.next()) {
				if (!resultStr.equals("")) resultStr += "|";
				resultStr += rset.getString(1) + "," + rset.getString(2);
			}

			// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
			// : DPC_HEAD 테이블에서 Max CaseNo 이고 DWGDEPTCODE 가 해당 부서인 것이면서 
			// : SHIPTYPE(선종) 컬럼 값이 해당 호선의 선종을 포함하는 것이 대상 
			// : - 참고: SHIPTYPE 컬럼 값은 Bit 합으로 되어 있고 선종코드는 코드테이블(CCC_CODE)에 정의되어 있다
			if (resultStr.equals("")) 
			{ 
				StringBuffer queryStr2 = new StringBuffer();
				queryStr2.append("SELECT A.DWGNO, A.DWGTITLE                                                                                  ");
				queryStr2.append("  FROM DPC_HEAD A                                                                                           ");
				queryStr2.append(" WHERE 1 = 1                                                                                                ");
				queryStr2.append("   AND A.CASENO = (SELECT MAX(CASENO) FROM DPC_HEAD)                                                        ");
				queryStr2.append("   AND A.DWGTYPE = '" + drawingType + "'                                                                    ");
				if (!departCode.equals("440500")) 
				{   // 검도교육P는 업무특성으로 인해 전 부서 도면을 조회
					queryStr2.append("   AND A.DWGDEPTCODE = (SELECT DWGDEPTCODE FROM DCC_DEPTCODE WHERE DEPTCODE = '" + departCode + "')    ");
				}
				queryStr2.append("   AND (SELECT COUNT(*) FROM CCC_CODE B                                                                     ");
				queryStr2.append("         WHERE B.P_CODE = 'SHIPTYPE' AND B.M_CODE = 'SHIPTYPE'                                              ");
				queryStr2.append("           AND B.C_CODE = (SELECT C.SHIPTYPE FROM LPM_NEWPROJECT C WHERE C.CASENO = '1'                     ");
				queryStr2.append("                                                                     AND C.PROJECTNO = '" + projectNo + "') ");
				queryStr2.append("           AND B.ATTRIBUTE1 = BITAND(B.ATTRIBUTE1, A.SHIPTYPE)                                              ");
				queryStr2.append("        ) > 0                                                                                               ");

				stmt2 = conn.createStatement();
				rset = stmt2.executeQuery(queryStr2.toString());

				while (rset.next()) {
					if (!resultStr.equals("")) resultStr += "|";
					resultStr += rset.getString(1) + "," + rset.getString(2);
				}
			}
			
			// Start :: 2015-02-04 Kang seonjung : (서광훈 과장 요청) 선체생산설계-선형기술P(480100)는 000029(선형기술P), 000051(선체생설P) 조회 가능
			// 선형기술P가 선체생설P 도면 조회 때도 DP에 없으면 WBS에서 가져옴
			if(departCode.equals("480100")) 
			{
				boolean resultFlag = false;
				String queryStr3 = "";
				queryStr3 += "SELECT SUBSTR(ACTIVITYCODE, 1, 8), DWGTITLE                                                             "; 
				queryStr3 += "  FROM PLM_ACTIVITY                                                                                     "; 
				queryStr3 += " WHERE PROJECTNO = '" + projectNo + "'                                                                  "; 
				queryStr3 += "   AND WORKTYPE = 'DW'                                                                                  ";
				queryStr3 += "   AND DWGDEPTCODE IN ('000051')                                                         "; 
				queryStr3 += "   AND DWGTYPE = '" + drawingType + "'                                                                  "; 
				queryStr3 += " ORDER BY ACTIVITYCODE                                                                                  ";

				rset = stmt.executeQuery(queryStr3);
				while (rset.next()) {
					resultFlag = true;
					String tempDWGNO = rset.getString(1);
					if(resultStr.indexOf(tempDWGNO) < 1)
					{
						if (!resultStr.equals("")) resultStr += "|";
						resultStr += rset.getString(1) + "," + rset.getString(2);
					}
				}

				// DP가 생성되지 않은 경우에는 WBS에서 쿼리해 온다
				if(!resultFlag)
				{
					StringBuffer queryStr4 = new StringBuffer();
					queryStr4.append("SELECT A.DWGNO, A.DWGTITLE                                                                                  ");
					queryStr4.append("  FROM DPC_HEAD A                                                                                           ");
					queryStr4.append(" WHERE 1 = 1                                                                                                ");
					queryStr4.append("   AND A.CASENO = (SELECT MAX(CASENO) FROM DPC_HEAD)                                                        ");
					queryStr4.append("   AND A.DWGTYPE = '" + drawingType + "'                                                                    ");
					queryStr4.append("   AND DWGDEPTCODE IN ('000051')                                                                            "); 					
					queryStr4.append("   AND (SELECT COUNT(*) FROM CCC_CODE B                                                                     ");
					queryStr4.append("         WHERE B.P_CODE = 'SHIPTYPE' AND B.M_CODE = 'SHIPTYPE'                                              ");
					queryStr4.append("           AND B.C_CODE = (SELECT C.SHIPTYPE FROM LPM_NEWPROJECT C WHERE C.CASENO = '1'                     ");
					queryStr4.append("                                                                     AND C.PROJECTNO = '" + projectNo + "') ");
					queryStr4.append("           AND B.ATTRIBUTE1 = BITAND(B.ATTRIBUTE1, A.SHIPTYPE)                                              ");
					queryStr4.append("        ) > 0                                                                                               ");

					rset = stmt.executeQuery(queryStr4.toString());

					while (rset.next()) {
						String tempDWGNO = rset.getString(1);
						if(resultStr.indexOf(tempDWGNO) < 1)
						{
							if (!resultStr.equals("")) resultStr += "|";
							resultStr += rset.getString(1) + "," + rset.getString(2);
						}
					}
				}

			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			if (stmt2 != null) stmt2.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getDrawingListForWork2() : 부서 + 호선에 해당하는 도면들 목록을 쿼리
	private static synchronized String getDrawingListForWork2(String departCode, String projectNo) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			/* 시공 전, 시공 후 개념은 2010-05-13 부터 더 이상 사용 X */

			queryStr.append("SELECT DWGCODE,                                                                                                  ");
			queryStr.append("       DWGTITLE,                                                                                                 ");
			queryStr.append("       CASE WHEN DWGCATEGORY = 'B'                                                                               ");
			queryStr.append("            THEN DECODE(DW_PLAN_F, NULL, '시공 전',                                                              "); 
			queryStr.append("                        CASE WHEN DW_PLAN_F + 7 >= SYSDATE THEN '시공 전' ELSE '시공 후' END)                    ");
			queryStr.append("            ELSE DECODE(WK_PLAN_S, NULL, '시공 전',                                                              ");
			queryStr.append("                        CASE WHEN WK_PLAN_S >= SYSDATE THEN '시공 전' ELSE '시공 후' END)                        ");
			queryStr.append("       END AS D_TIMING,                                                                                          ");
			queryStr.append("       DWGCATEGORY                                                                                               ");
			queryStr.append("  FROM (                                                                                                         ");
			queryStr.append("        SELECT SUBSTR(DW.ACTIVITYCODE, 1, 8) AS DWGCODE,                                                         ");     
			queryStr.append("               DW.DWGTITLE,                                                                                      ");
			queryStr.append("               DW.DWGCATEGORY,                                                                                   ");
			queryStr.append("               DW.DWGTYPE,                                                                                       ");
			queryStr.append("               DW.PLANFINISHDATE AS DW_PLAN_F,                                                                   ");
			queryStr.append("               WK.PLANSTARTDATE AS WK_PLAN_S                                                                     ");
			queryStr.append("          FROM PLM_ACTIVITY DW,                                                                                  ");
			queryStr.append("               (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.DWGCATEGORY                               ");
			queryStr.append("                  FROM PLM_ACTIVITY D                                                                            ");
			queryStr.append("                 WHERE D.WORKTYPE = 'WK'                                                                         ");
			queryStr.append("               ) WK                                                                                              ");
			queryStr.append("         WHERE 1 = 1                                                                                             ");
			queryStr.append("           AND DW.PROJECTNO = '" + projectNo + "'                                                                ");
			queryStr.append("           AND DW.WORKTYPE = 'DW'                                                                                ");
			queryStr.append("           AND DW.PROJECTNO = WK.PROJECTNO(+)                                                                    ");
			queryStr.append("           AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8)                                  ");
			queryStr.append("           AND DW.DWGDEPTCODE = (SELECT E.DWGDEPTCODE FROM DCC_DEPTCODE E WHERE E.DEPTCODE='" + departCode + "') ");
			queryStr.append("       )                                                                                                         ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				if (!resultStr.equals("")) resultStr += "∥";
				resultStr += rset.getString(1) + "‥" + rset.getString(2) + "‥" + rset.getString(3) + "‥" + rset.getString(4);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getDrawingListForWork3() : 부서 + 호선 + 도면에 해당하는 도면정보를 쿼리
	private static synchronized String getDrawingListForWork3(String projectNo, String departCode, String dwgNo) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (StringUtil.isNullString(dwgNo)) throw new Exception("DwgNo. is null");
		if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			/* 시공 전, 시공 후 개념은 2010-05-13 부터 더 이상 사용 X */

			queryStr.append("SELECT DWGCODE,                                                                                                  ");
			queryStr.append("       DWGTITLE,                                                                                                 ");
			queryStr.append("       CASE WHEN DWGCATEGORY = 'B'                                                                               ");
			queryStr.append("            THEN DECODE(DW_PLAN_F, NULL, '시공 전',                                                              ");
			queryStr.append("                        CASE WHEN DW_PLAN_F + 7 >= SYSDATE THEN '시공 전' ELSE '시공 후' END)                    ");
			queryStr.append("            ELSE DECODE(WK_PLAN_S, NULL, '시공 전',                                                              ");
			queryStr.append("                        CASE WHEN WK_PLAN_S >= SYSDATE THEN '시공 전' ELSE '시공 후' END)                        ");
			queryStr.append("       END AS D_TIMING,                                                                                          ");
			queryStr.append("       DWGCATEGORY                                                                                               ");
			queryStr.append("  FROM (                                                                                                         ");
			queryStr.append("        SELECT SUBSTR(DW.ACTIVITYCODE, 1, 8) AS DWGCODE,                                                         ");     
			queryStr.append("               DW.DWGTITLE,                                                                                      ");
			queryStr.append("               DW.DWGCATEGORY,                                                                                   ");
			queryStr.append("               DW.DWGTYPE,                                                                                       ");
			queryStr.append("               DW.PLANFINISHDATE AS DW_PLAN_F,                                                                   ");
			queryStr.append("               WK.PLANSTARTDATE AS WK_PLAN_S                                                                     ");
			queryStr.append("          FROM PLM_ACTIVITY DW,                                                                                  ");
			queryStr.append("               (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.DWGCATEGORY                               ");
			queryStr.append("                  FROM PLM_ACTIVITY D                                                                            ");
			queryStr.append("                 WHERE D.WORKTYPE = 'WK'                                                                         ");
			queryStr.append("               ) WK                                                                                              ");
			queryStr.append("         WHERE 1 = 1                                                                                             ");
			queryStr.append("           AND DW.PROJECTNO = '" + projectNo + "'                                                                ");
			queryStr.append("           AND DW.WORKTYPE = 'DW'                                                                                ");
			queryStr.append("           AND DW.PROJECTNO = WK.PROJECTNO(+)                                                                    ");
			queryStr.append("           AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = '" + dwgNo + "'                                                   ");
			queryStr.append("           AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8)                                  ");
			queryStr.append("           AND DW.DWGDEPTCODE = (SELECT E.DWGDEPTCODE FROM DCC_DEPTCODE E WHERE E.DEPTCODE='" + departCode + "') ");
			queryStr.append("       )                                                                                                         ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultStr = rset.getString(1) + "‥" + rset.getString(2) + "‥" + rset.getString(3) + "‥" + rset.getString(4);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getDesignMHInputs() : 사번 + 날짜의 시수입력 사항을 쿼리
	private static synchronized ArrayList getDesignMHInputs(String employeeID, String dateStr) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT START_TIME, PROJECT_NO, DWG_TYPE, DWG_CODE, OP_CODE, CAUSE_DEPART, BASIS, WORK_DESC, EVENT1, EVENT2, EVENT3, ");
			queryStr.append("       NORMAL_TIME, OVERTIME, SPECIAL_TIME,                                                                         ");
			queryStr.append("       (SELECT B.VALUE FROM PLM_CODE_TBL B WHERE B.CATEGORY='OP_CODE' AND B.KEY=OP_CODE) AS OP_STR,                 ");
			queryStr.append("       (SELECT B.VALUE FROM PLM_CODE_TBL B WHERE B.CATEGORY='DWG_EVENT' AND B.KEY=EVENT1) AS EVENT1_STR,            ");
			queryStr.append("       (SELECT B.VALUE FROM PLM_CODE_TBL B WHERE B.CATEGORY='DWG_EVENT' AND B.KEY=EVENT2) AS EVENT2_STR,            ");
			queryStr.append("       (SELECT B.VALUE FROM PLM_CODE_TBL B WHERE B.CATEGORY='DWG_EVENT' AND B.KEY=EVENT3) AS EVENT3_STR,            ");
			queryStr.append("       SHIP_TYPE                                                                                                    ");
			queryStr.append("  FROM PLM_DESIGN_MH                                                                                                ");
			queryStr.append(" WHERE EMPLOYEE_NO='" + employeeID + "'                                                                             ");
			queryStr.append("   AND WORK_DAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD')                                                          ");
			queryStr.append(" ORDER BY START_TIME ASC                                                                                            ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("START_TIME", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("PROJECT_NO", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("DWG_TYPE", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("DWG_CODE", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("OP_CODE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("CAUSE_DEPART", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("BASIS", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("WORK_DESC", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("EVENT1", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("EVENT2", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("EVENT3", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("NORMAL", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("OVERTIME", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("SPECIAL", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("OP_STR", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("EVENT1_STR", rset.getString(16) == null ? "" : rset.getString(16));
				resultMap.put("EVENT2_STR", rset.getString(17) == null ? "" : rset.getString(17));
				resultMap.put("EVENT3_STR", rset.getString(18) == null ? "" : rset.getString(18));
				resultMap.put("SHIP_TYPE", rset.getString(19) == null ? "" : rset.getString(19));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getDesignMHInputsList2() : 선택 조건에 따라 해당 조건에 맞는 시수입력 사항들을 조회(2)
	private static synchronized ArrayList getDesignMHInputsList2(String deptCode, String designerID, String dateFrom, String dateTo, 
					String projectNo, String causeDeptCode, String[] drawingNoArray, String opCode, String factorCase) throws Exception
	{
		String drawingNo = "";
		boolean hasDrawingNo = false;
		for (int i = 0; i < drawingNoArray.length; i++) {
			if (!"".equals(drawingNoArray[i])) {
				drawingNo +=  drawingNoArray[i];
				hasDrawingNo = true;
			}
			else drawingNo +=  "_";
		}

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT PROJECT_NO,                                                                                             ");
			queryStr.append("       WORKDAY,                                                                                                ");
			queryStr.append("       EMPLOYEE_NO,                                                                                            ");
			queryStr.append("       EMP_NAME,                                                                                               ");
			queryStr.append("       DEPT_CODE,                                                                                              ");
			queryStr.append("       DEPT_NAME,                                                                                              ");
			queryStr.append("       DWG_CODE,                                                                                               ");
			queryStr.append("       OP_CODE,                                                                                                ");
			queryStr.append("       CAUSE_DEPART,                                                                                           ");
			queryStr.append("       TO_CHAR(NORMAL_TIME * MH_FACTOR, '99990D9'),                                                            ");
			queryStr.append("       TO_CHAR(OVERTIME * MH_FACTOR, '99990D9'),                                                               ");
			queryStr.append("       TO_CHAR(SPECIAL_TIME * MH_FACTOR, '99990D9'),                                                           ");
			queryStr.append("       EVENT1,                                                                                                 ");
			queryStr.append("       EVENT2,                                                                                                 ");
			queryStr.append("       EVENT3,                                                                                                 ");
			queryStr.append("       START_TIME                                                                                              ");
			queryStr.append("  FROM (                                                                                                       ");
			queryStr.append("        SELECT PROJECT_NO,                                                                                     ");
			queryStr.append("               WORKDAY,                                                                                        ");
			queryStr.append("               EMPLOYEE_NO,                                                                                    ");
			queryStr.append("               NVL(EMP_NAME, (SELECT B.USER_NAME FROM STX_COM_INSA_USER@STXERP B WHERE B.EMP_NO = EMPLOYEE_NO)) AS EMP_NAME,    ");
			queryStr.append("               DEPT_CODE,                                                                                      ");
			queryStr.append("               DEPT_NAME,                                                                                      ");
			queryStr.append("               DWG_CODE,                                                                                       ");
			queryStr.append("               OP_CODE,                                                                                        ");
			queryStr.append("               CAUSE_DEPART,                                                                                   ");
			queryStr.append("               NORMAL_TIME,                                                                                    ");
			queryStr.append("               OVERTIME,                                                                                       ");
			queryStr.append("               SPECIAL_TIME,                                                                                   ");
			queryStr.append("               EVENT1,                                                                                         ");
			queryStr.append("               EVENT2,                                                                                         ");
			queryStr.append("               EVENT3,                                                                                         ");
			queryStr.append("               START_TIME,                                                                                     ");
			queryStr.append("               CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                          ");
			queryStr.append("                    ELSE (                                                                                     ");
			queryStr.append("                             SELECT FACTOR_VALUE                                                               ");
			queryStr.append("                               FROM (                                                                          ");
			queryStr.append("                                     SELECT CAREER_MONTH_FROM,                                                 ");
			queryStr.append("                                            CAREER_MONTH_TO,                                                   ");
			queryStr.append("                                            FACTOR_VALUE                                                       ");
			queryStr.append("                                       FROM PLM_DESIGN_MH_FACTOR                                               ");
			queryStr.append("                                      WHERE 1 = 1                                                              ");
			queryStr.append("                                        AND CASE_NO = '" + factorCase + "'                                     ");
			queryStr.append("                                    )                                                                          ");
			queryStr.append("                              WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                         ");
			queryStr.append("                                AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                ");
			queryStr.append("                         )                                                                                     ");
			queryStr.append("               END AS MH_FACTOR                                                                                ");
			queryStr.append("          FROM (                                                                                               ");
			queryStr.append("                SELECT A.PROJECT_NO,                                                                           ");
			queryStr.append("                       TO_CHAR(A.WORK_DAY, 'YYYY-MM-DD') AS WORKDAY,                                           ");
			queryStr.append("                       A.EMPLOYEE_NO,                                                                          ");
			queryStr.append("                       (SELECT C.NAME FROM CCC_SAWON C WHERE C.EMPLOYEE_NUM = A.EMPLOYEE_NO) AS EMP_NAME,      ");
			queryStr.append("                       A.DEPT_CODE,                                                                            ");
			queryStr.append("                       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.DEPT_CODE)    ");
			queryStr.append("                       AS DEPT_NAME,                                                                           ");
			queryStr.append("                       A.DWG_CODE,                                                                             ");
			queryStr.append("                       A.OP_CODE,                                                                              ");
			queryStr.append("                       A.CAUSE_DEPART,                                                                         ");
			queryStr.append("                       A.NORMAL_TIME,                                                                          ");
			queryStr.append("                       A.OVERTIME,                                                                             ");
			queryStr.append("                       A.SPECIAL_TIME,                                                                         ");
			queryStr.append("                       A.EVENT1,                                                                               ");
			queryStr.append("                       A.EVENT2,                                                                               ");
			queryStr.append("                       A.EVENT3,                                                                               ");
			queryStr.append("                       A.START_TIME,                                                                           ");
			queryStr.append("                       B.POSITION,                                                                             ");
			//queryStr.append("                       CASE WHEN SUBSTR(B.POSITION, 1, 2) <> '주임' THEN NULL                                  ");
			//queryStr.append("                            ELSE (                                                                             ");
			queryStr.append("                                   ((TO_CHAR(A.WORK_DAY, 'YYYY') - TO_CHAR(B.DESIGN_APPLY_DATE, 'YYYY'))* 12 + ");
			queryStr.append("                                    (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +        ");
			queryStr.append("                                   CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                   ");
			queryStr.append("                                        WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                    ");
			queryStr.append("                                   END +                                                                       ");
			queryStr.append("                                   NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                             ");
			//queryStr.append("                                 )                                                                             ");
			//queryStr.append("                       END                                                                                     ");
			queryStr.append("                       AS CAREER_MONTHS                                                                        ");
			queryStr.append("                  FROM PLM_DESIGN_MH A,                                                                        ");
			queryStr.append("                       CCC_SAWON B                                                                             ");
			queryStr.append("                 WHERE 1 = 1                                                                                   ");
			queryStr.append("                   AND A.EMPLOYEE_NO = B.EMPLOYEE_NUM(+)                                                         ");
			queryStr.append("                   AND A.OP_CODE <> '90'                                                                       ");
			if (!opCode.equals(""))
			queryStr.append("                   AND A.OP_CODE IN (" + opCode + ")                                                           ");
			if (hasDrawingNo)
			queryStr.append("                   AND A.DWG_CODE LIKE '" + drawingNo + "'                                                     ");
			if (!designerID.equals(""))
			queryStr.append("                   AND A.EMPLOYEE_NO = '" + designerID + "'                                                    ");
			if (!causeDeptCode.equals(""))
			queryStr.append("                   AND CAUSE_DEPART = '" + causeDeptCode + "'                                                  ");
			if (!deptCode.equals(""))
			queryStr.append("                   AND A.DEPT_CODE IN (" + deptCode + ")                                                       ");
			if (!projectNo.equals(""))
			queryStr.append("                   AND A.PROJECT_NO IN (" + projectNo + ")                                                     ");
			queryStr.append("                   AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD') AND                        ");
			queryStr.append("                                          TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                              ");
			queryStr.append("               )                                                                                               ");
			queryStr.append("       )                                                                                                       ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("WORKDAY", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("EMPLOYEE_NO", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("EMP_NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("DEPT_CODE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("DEPT_NAME", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("DWG_CODE", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("OP_CODE", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("CAUSE_DEPART", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("NORMAL", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("OVERTIME", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("SPECIAL", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("EVENT1", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("EVENT2", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("EVENT3", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("START_TIME", rset.getString(16) == null ? "" : rset.getString(16));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getDesignMHInputsList3() : 시수 Data 관리 : 배부 시수 기준으로 변경
		private static synchronized ArrayList getDesignMHInputsList3(String deptCode, String designerID, String dateFrom, String dateTo, 
						String projectNo, String[] drawingNoArray, String opCode, String factorCase) throws Exception
		{
			String drawingNo = "";
			boolean hasDrawingNo = false;
			for (int i = 0; i < drawingNoArray.length; i++) {
				if (!"".equals(drawingNoArray[i])) {
					drawingNo +=  drawingNoArray[i];
					hasDrawingNo = true;
				}
				else drawingNo +=  "_";
			}

			java.sql.Connection conn = null;
			java.sql.Statement stmt = null;
			java.sql.ResultSet rset = null;

			ArrayList resultMapList = new ArrayList();

			try {
				conn = DBConnect.getDBConnection("SDPS");

				StringBuffer queryStr = new StringBuffer();

				queryStr.append("SELECT PROJECT_NO,                                                                                             ");
				queryStr.append("       WORKDAY,                                                                                                ");
				queryStr.append("       EMPLOYEE_NO,                                                                                            ");
				queryStr.append("       EMP_NAME,                                                                                               ");
				queryStr.append("       DEPT_CODE,                                                                                              ");
				queryStr.append("       DEPT_NAME,                                                                                              ");
				queryStr.append("       DWG_CODE,                                                                                               ");
				queryStr.append("       OP_CODE,                                                                                                ");
				queryStr.append("       ROUND(DIRECT_MH * MH_FACTOR, 1)                 AS    DIRECT_MH,                                        ");
				queryStr.append("       ROUND(DIST_MH * MH_FACTOR, 1)                   AS    DIST_MH,                                          ");
				queryStr.append("       DECODE(PROJECT_GBN,'P','공사시수','비공사시수') AS    PROJECT_GBN,                                      ");
				queryStr.append("       ROUND(NORMAL_TIME * MH_FACTOR, 1)               AS    NORMAL_TIME,                                      ");
				queryStr.append("       ROUND(OVERTIME * MH_FACTOR, 1)                  AS    OVERTIME,                                         ");
				queryStr.append("       ROUND(SPECIAL_TIME * MH_FACTOR, 1)              AS    SPECIAL_TIME                                      ");
				queryStr.append("  FROM (                                                                                                       ");
				queryStr.append("        SELECT PROJECT_NO,                                                                                     ");
				queryStr.append("               WORKDAY,                                                                                        ");
				queryStr.append("               EMPLOYEE_NO,                                                                                    ");
				queryStr.append("               NVL(EMP_NAME, (SELECT B.USER_NAME FROM STX_COM_INSA_USER@STXERP B WHERE B.EMP_NO = EMPLOYEE_NO)) AS EMP_NAME,    ");
				queryStr.append("               DEPT_CODE,                                                                                      ");
				queryStr.append("               DEPT_NAME,                                                                                      ");
				queryStr.append("               DWG_CODE,                                                                                       ");
				queryStr.append("               OP_CODE,                                                                                        ");
				queryStr.append("               DIRECT_MH,                                                                                        ");
				queryStr.append("               DIST_MH,                                                                                        ");
				queryStr.append("               PROJECT_GBN,                                                                                        ");
				queryStr.append("               NORMAL_TIME,                                                                                    ");
				queryStr.append("               OVERTIME,                                                                                       ");
				queryStr.append("               SPECIAL_TIME,                                                                                   ");
				queryStr.append("               CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                          ");
				queryStr.append("                    ELSE (                                                                                     ");
				queryStr.append("                             SELECT FACTOR_VALUE                                                               ");
				queryStr.append("                               FROM (                                                                          ");
				queryStr.append("                                     SELECT CAREER_MONTH_FROM,                                                 ");
				queryStr.append("                                            CAREER_MONTH_TO,                                                   ");
				queryStr.append("                                            FACTOR_VALUE                                                       ");
				queryStr.append("                                       FROM PLM_DESIGN_MH_FACTOR                                               ");
				queryStr.append("                                      WHERE 1 = 1                                                              ");
				queryStr.append("                                        AND CASE_NO = '" + factorCase + "'                                     ");
				queryStr.append("                                    )                                                                          ");
				queryStr.append("                              WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                         ");
				queryStr.append("                                AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                ");
				queryStr.append("                         )                                                                                     ");
				queryStr.append("               END AS MH_FACTOR                                                                                ");
				queryStr.append("          FROM (                                                                                               ");
				queryStr.append("                SELECT A.PROJECT_NO,                                                                           ");
				queryStr.append("                       TO_CHAR(A.WORK_DAY, 'YYYY-MM-DD') AS WORKDAY,                                           ");
				queryStr.append("                       A.EMPLOYEE_NO,                                                                          ");
				queryStr.append("                       (SELECT C.NAME FROM CCC_SAWON C WHERE C.EMPLOYEE_NUM = A.EMPLOYEE_NO) AS EMP_NAME,      ");
				queryStr.append("                       A.DEPT_CODE,                                                                            ");
				queryStr.append("                       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.DEPT_CODE)    ");
				queryStr.append("                       AS DEPT_NAME,                                                                           ");
				queryStr.append("                       A.DWG_CODE,                                                                             ");
				queryStr.append("                       A.OP_CODE,                                                                              ");
				queryStr.append("                       A.DIRECT_MH,                                                                              ");
				queryStr.append("                       A.DIST_MH,                                                                              ");
				queryStr.append("                       A.PROJECT_GBN,                                                                          ");
				queryStr.append("                       A.NORMAL_TIME,                                                                          ");
				queryStr.append("                       A.OVERTIME,                                                                             ");
				queryStr.append("                       A.SPECIAL_TIME,                                                                         ");
				queryStr.append("                       B.POSITION,                                                                             ");
				//queryStr.append("                       CASE WHEN SUBSTR(B.POSITION, 1, 2) <> '주임' THEN NULL                                  ");
				//queryStr.append("                            ELSE (                                                                             ");
				queryStr.append("                                   ((TO_CHAR(A.WORK_DAY, 'YYYY') - TO_CHAR(B.DESIGN_APPLY_DATE, 'YYYY'))* 12 + ");
				queryStr.append("                                    (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +        ");
				queryStr.append("                                   CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                   ");
				queryStr.append("                                        WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                    ");
				queryStr.append("                                   END +                                                                       ");
				queryStr.append("                                   NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                             ");
				//queryStr.append("                                 )                                                                             ");
				//queryStr.append("                       END                                                                                     ");
				queryStr.append("                       AS CAREER_MONTHS                                                                        ");
				queryStr.append("                  FROM PLM_DESIGN_MH_CLOSE A,                                                                  ");
				queryStr.append("                       CCC_SAWON B                                                                             ");
				queryStr.append("                 WHERE 1 = 1                                                                                   ");
				queryStr.append("                   AND A.EMPLOYEE_NO = B.EMPLOYEE_NUM(+)                                                         ");
				queryStr.append("                   AND A.OP_CODE <> 'D1Z'                                                                       ");
				if (!opCode.equals(""))
				queryStr.append("                   AND A.OP_CODE IN (" + opCode + ")                                                           ");
				if (hasDrawingNo)
				queryStr.append("                   AND A.DWG_CODE LIKE '" + drawingNo + "'                                                     ");
				if (!designerID.equals(""))
				queryStr.append("                   AND A.EMPLOYEE_NO = '" + designerID + "'                                                    ");
				if (!deptCode.equals(""))
				queryStr.append("                   AND A.DEPT_CODE IN (" + deptCode + ")                                                       ");
				if (!projectNo.equals(""))
				queryStr.append("                   AND A.PROJECT_NO IN (" + projectNo + ")                                                     ");
				queryStr.append("                   AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD') AND                        ");
				queryStr.append("                                          TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                              ");
				queryStr.append("               )                                                                                               ");
				queryStr.append("       )                                                                                                       ");
				queryStr.append("  ORDER BY WORKDAY, DEPT_CODE, EMPLOYEE_NO, PROJECT_NO, DWG_CODE, OP_CODE                                      ");

	            stmt = conn.createStatement();
	            rset = stmt.executeQuery(queryStr.toString());

				while (rset.next()) {
					HashMap resultMap = new HashMap();
					resultMap.put("PROJECT_NO", rset.getString(1) == null ? "" : rset.getString(1));
					resultMap.put("WORKDAY", rset.getString(2) == null ? "" : rset.getString(2));
					resultMap.put("EMPLOYEE_NO", rset.getString(3) == null ? "" : rset.getString(3));
					resultMap.put("EMP_NAME", rset.getString(4) == null ? "" : rset.getString(4));
					resultMap.put("DEPT_CODE", rset.getString(5) == null ? "" : rset.getString(5));
					resultMap.put("DEPT_NAME", rset.getString(6) == null ? "" : rset.getString(6));
					resultMap.put("DWG_CODE", rset.getString(7) == null ? "" : rset.getString(7));
					resultMap.put("OP_CODE", rset.getString(8) == null ? "" : rset.getString(8));
					resultMap.put("DIRECT_MH", rset.getString(9) == null ? "" : rset.getString(9));
					resultMap.put("DIST_MH", rset.getString(10) == null ? "" : rset.getString(10));
					resultMap.put("PROJECT_GBN", rset.getString(11) == null ? "" : rset.getString(11));
					resultMap.put("NORMAL_TIME", rset.getString(12) == null ? "" : rset.getString(12));
					resultMap.put("OVERTIME", rset.getString(13) == null ? "" : rset.getString(13));
					resultMap.put("SPECIAL_TIME", rset.getString(14)== null ? "" : rset.getString(14));
					resultMapList.add(resultMap);
				}
			}
			finally {
				if (rset != null) rset.close();
				if (stmt != null) stmt.close();
				DBConnect.closeConnection(conn);
			}

			return resultMapList;
		}
	
	// 도면 별 계획시수 대비 실적시수 초과사항 쿼리
	private static synchronized ArrayList getDwgMH_Overtime(String employeeID, String dateStr) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT PROJECT_NO, DWG_CODE, PLAN_MH, ACTUAL_MH,                                                                   ");
			queryStr.append("       DECODE(SIGN(ACTUAL_MH - PLAN_MH), -1, '', 0, '', 1, ACTUAL_MH - PLAN_MH) AS DIFF_MH                         ");
			queryStr.append("  FROM                                                                                                             ");
			queryStr.append("(                                                                                                                  ");
			queryStr.append("SELECT A.PROJECT_NO,                                                                                               ");
			queryStr.append("       A.DWG_CODE,                                                                                                 ");
			queryStr.append("       NVL(B.PLANSTDMH, 0) + NVL(B.PLANFOLLOWMH, 0) AS PLAN_MH,                                                    ");
			queryStr.append("       NVL(A.TOTAL_MH, 0) + NVL(B.ACTUALSTDMH, 0) + NVL(B.ACTUALFOLLOWMH, 0) AS ACTUAL_MH                          ");
			queryStr.append("  FROM (                                                                                                           ");
			queryStr.append("            SELECT PROJECT_NO,                                                                                     ");
			queryStr.append("                   DWG_CODE,                                                                                       ");
			queryStr.append("                   SUM(TOTAL_MH * MH_FACTOR) AS TOTAL_MH                                                           ");
			queryStr.append("              FROM                                                                                                 ");
			queryStr.append("                    (                                                                                              ");
			queryStr.append("                    SELECT PROJECT_NO,                                                                             ");
			queryStr.append("                           DWG_CODE,                                                                               ");
			queryStr.append("                           TOTAL_MH,                                                                               ");
			queryStr.append("                                                                                                                   ");
			queryStr.append("                           CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                  ");
			queryStr.append("                                ELSE (                                                                             ");
			queryStr.append("                                        SELECT FACTOR_VALUE                                                        ");
			queryStr.append("                                          FROM (                                                                   ");
			queryStr.append("                                                SELECT CAREER_MONTH_FROM,                                          ");
			queryStr.append("                                                       CAREER_MONTH_TO,                                            ");
			queryStr.append("                                                       FACTOR_VALUE                                                ");
			queryStr.append("                                                  FROM PLM_DESIGN_MH_FACTOR A                                      ");
			queryStr.append("                                                 WHERE 1 = 1                                                       ");
			queryStr.append("                                                   AND A.CASE_NO = (                                               ");
			queryStr.append("                                                                    SELECT VALUE                                   ");
			queryStr.append("                                                                      FROM PLM_CODE_TBL A                          ");
			queryStr.append("                                                                     WHERE A.CATEGORY = 'MH_FACTOR'                ");
			queryStr.append("                                                                       AND A.KEY = 'ACTIVE_CASE'                   ");
			queryStr.append("                                                                   )                                               ");
			queryStr.append("                                               )                                                                   ");
			queryStr.append("                                         WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                  ");
			queryStr.append("                                           AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                         ");
			queryStr.append("                                     )                                                                             ");
			queryStr.append("                           END AS MH_FACTOR                                                                        ");
			queryStr.append("                                                                                                                   ");
			queryStr.append("                     FROM                                                                                          ");
			queryStr.append("                            (                                                                                      ");
			queryStr.append("                            SELECT A.PROJECT_NO,                                                                   ");
			queryStr.append("                                   A.DWG_CODE,                                                                     ");
			queryStr.append("                                   A.NORMAL_TIME + A.OVERTIME + A.SPECIAL_TIME AS TOTAL_MH,                        ");
			queryStr.append("                                                                                                                   ");
			queryStr.append("                                       ((TO_CHAR(A.WORK_DAY, 'YYYY') - TO_CHAR(B.DESIGN_APPLY_DATE, 'YYYY'))* 12 + ");
			queryStr.append("                                        (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +        ");
			queryStr.append("                                       CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                   ");
			queryStr.append("                                            WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                    ");
			queryStr.append("                                       END +                                                                       ");
			queryStr.append("                                       NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                             ");
			queryStr.append("                                   AS CAREER_MONTHS                                                                ");
			queryStr.append("                                                                                                                   ");
			queryStr.append("                             FROM PLM_DESIGN_MH A,                                                                 ");
			queryStr.append("                                  CCC_SAWON B                                                                      ");
			queryStr.append("                            WHERE 1 = 1                                                                            ");
			queryStr.append("                              AND A.WORK_DAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD')                            ");
			queryStr.append("                              AND A.EMPLOYEE_NO = '" + employeeID + "'                                             ");
			queryStr.append("                              AND A.CONFIRM_YN <> 'Y'                                                              ");
			queryStr.append("                              AND SUBSTR(A.DWG_CODE, 1, 1) <> '*'                                                  ");
			queryStr.append("                              AND A.DWG_CODE IS NOT NULL                                                           ");
			queryStr.append("                              AND A.EMPLOYEE_NO = B.EMPLOYEE_NUM                                                   ");
			queryStr.append("                            )                                                                                      ");
			queryStr.append("                    )                                                                                              ");
			queryStr.append("            GROUP BY PROJECT_NO, DWG_CODE                                                                          ");
			queryStr.append("       ) A,                                                                                                        ");
			queryStr.append("       PLM_ACTIVITY B                                                                                              ");
			queryStr.append(" WHERE 1 = 1                                                                                                       ");
			queryStr.append("   AND A.PROJECT_NO = B.PROJECTNO                                                                                  ");
			queryStr.append("   AND A.DWG_CODE || 'DW' = B.ACTIVITYCODE                                                                         ");
			queryStr.append(")                                                                                                                  ");
			queryStr.append("ORDER BY PROJECT_NO, DWG_CODE                                                                                      ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1));
				resultMap.put("DWG_CODE", rset.getString(2));
				resultMap.put("PLAN_MH", rset.getString(3));
				resultMap.put("ACTUAL_MH", rset.getString(4));
				resultMap.put("DIFF_MH", StringUtil.isNullString(rset.getString(5)) ? "" : rset.getString(5));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// saveDPInputs() : 시수입력 사항을 DB에 저장
	private static synchronized void saveDPInputs(String employeeID, String dateStr, String loginID, ArrayList paramList, String inputDoneYN) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");
		if (paramList.size() <= 0) throw new Exception("No items to save");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.PreparedStatement ppStmt = null;
		/*
		java.sql.PreparedStatement ppStmt2 = null;
		java.sql.PreparedStatement ppStmt3 = null;
		*/

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr = "DELETE FROM PLM_DESIGN_MH                                  " + 
				                      " WHERE EMPLOYEE_NO = '" + employeeID + "'                  " + 
					                  "  AND WORK_DAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD') ";

				StringBuffer execQueryStr2 = new StringBuffer();
				execQueryStr2.append("INSERT INTO PLM_DESIGN_MH  (  EMPLOYEE_NO, DEPT_CODE, WORK_DAY, START_TIME, PROJECT_NO, DWG_TYPE, DWG_CODE,       ");
				execQueryStr2.append("                              OP_CODE, CAUSE_DEPART, BASIS, WORK_DESC, EVENT1, EVENT2, EVENT3, NORMAL_TIME,       ");
				execQueryStr2.append("                              OVERTIME, SPECIAL_TIME, INPUTDONE_YN, CONFIRM_YN, CREATE_DATE, CREATE_BY,           ");
				execQueryStr2.append("                              UPDATE_DATE, UPDATE_BY, SHIP_TYPE     )                                             ");
				execQueryStr2.append("                     VALUES (     ?, (SELECT DEPT_CODE FROM CCC_SAWON WHERE EMPLOYEE_NUM = '" + employeeID + "'), ");
				execQueryStr2.append("                                  TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,             ");
				execQueryStr2.append("                                  ?, 'N', SYSDATE, ?, SYSDATE, ?, ?                                               ");
				execQueryStr2.append("                                 )                                                                                ");

				/*
				StringBuffer execQueryStr3 = new StringBuffer();
				execQueryStr3.append("SELECT PROJECT_NO,                                                                               ");
				execQueryStr3.append("       DWG_CODE,                                                                                 ");
				execQueryStr3.append("       SUM((TOTAL_MH - FOLLOWUP_MH) *  MH_FACTOR) AS STD_MH,                                     ");
				execQueryStr3.append("       SUM(FOLLOWUP_MH * MH_FACTOR) AS FOLLOWUP_MH,                                              ");
				execQueryStr3.append("       SUM(TOTAL_MH * MH_FACTOR) AS TOTAL_MH                                                     ");
				execQueryStr3.append("  FROM                                                                                           ");
				execQueryStr3.append("        (                                                                                        ");
				execQueryStr3.append("        SELECT PROJECT_NO,                                                                       ");
				execQueryStr3.append("               DWG_CODE,                                                                         ");
				execQueryStr3.append("               TOTAL_MH,                                                                         ");
				execQueryStr3.append("               FOLLOWUP_MH,                                                                      ");
				execQueryStr3.append("               CASE WHEN CAREER_MONTHS < 3 THEN 0                                                ");
				execQueryStr3.append("                    WHEN CAREER_MONTHS <= 12 THEN 0.5                                            ");
				execQueryStr3.append("                    ELSE 1                                                                       ");
				execQueryStr3.append("               END AS MH_FACTOR                                                                  ");
				execQueryStr3.append("         FROM                                                                                    ");
				execQueryStr3.append("                (                                                                                ");
				execQueryStr3.append("                SELECT A.PROJECT_NO,                                                             ");
				execQueryStr3.append("                       A.DWG_CODE,                                                               ");
				execQueryStr3.append("                       A.EMPLOYEE_NO,                                                            ");
				execQueryStr3.append("                       A.WORK_DAY,                                                               ");
				execQueryStr3.append("                       B.APPLY_DATE,                                                             ");
				execQueryStr3.append("                                                                                                 ");
				execQueryStr3.append("                       A.NORMAL_TIME + A.OVERTIME + A.SPECIAL_TIME AS TOTAL_MH,                  ");
				execQueryStr3.append("                       DECODE(A.OP_CODE, '2A', A.NORMAL_TIME + A.OVERTIME + A.SPECIAL_TIME,      ");
				execQueryStr3.append("                                         '2B', A.NORMAL_TIME + A.OVERTIME + A.SPECIAL_TIME, 0)   ");
				execQueryStr3.append("                       AS FOLLOWUP_MH,                                                           ");
				execQueryStr3.append("                                                                                                 ");
				execQueryStr3.append("                       ((TO_CHAR(A.WORK_DAY, 'YYYY') - TO_CHAR(B.APPLY_DATE, 'YYYY')) * 12 +     ");
				execQueryStr3.append("                        (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.APPLY_DATE, 'MM'))) - 1 +         ");
				execQueryStr3.append("                       CASE WHEN TO_CHAR(B.APPLY_DATE, 'DD') <= 15 THEN 1                        ");
				execQueryStr3.append("                            WHEN TO_CHAR(B.APPLY_DATE, 'DD') > 15 THEN 0                         ");
				execQueryStr3.append("                       END +                                                                     ");
				execQueryStr3.append("                       CASE WHEN TO_CHAR(A.WORK_DAY, 'DD') >= 15 THEN 1                          ");
				execQueryStr3.append("                            WHEN TO_CHAR(A.WORK_DAY, 'DD') < 15 THEN 0                           ");
				execQueryStr3.append("                       END +                                                                     ");
				execQueryStr3.append("                       NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0) AS CAREER_MONTHS          ");
				execQueryStr3.append("                                                                                                 ");
				execQueryStr3.append("                 FROM PLM_DESIGN_MH A,                                                           ");
				execQueryStr3.append("                      CCC_SAWON B                                                                ");
				execQueryStr3.append("                WHERE A.EMPLOYEE_NO = B.EMPLOYEE_NUM                                             ");
				execQueryStr3.append("                  AND PROJECT_NO = ?                                                             ");
				execQueryStr3.append("                  AND DWG_CODE = ?                                                               ");
				execQueryStr3.append("                )                                                                                ");
				execQueryStr3.append("        )                                                                                        ");
				execQueryStr3.append("GROUP BY PROJECT_NO, DWG_CODE                                                                    ");

				StringBuffer execQueryStr4 = new StringBuffer();
				execQueryStr4.append("UPDATE PLM_ACTIVITY                         ");
				execQueryStr4.append("   SET ACTUALSTDMH = ?, ACTUALFOLLOWMH = ?  ");
				execQueryStr4.append(" WHERE PROJECTNO = ? AND ACTIVITYCODE = ?   ");
				*/

				stmt = conn.createStatement();
				stmt.executeUpdate(execQueryStr); // 먼저 기 존재하는 값들을 모두 삭제

				if (paramList.size() > 0) {
					ppStmt = conn.prepareStatement(execQueryStr2.toString()); 
					/*
					ppStmt2 = conn.prepareStatement(execQueryStr3.toString()); 
					ppStmt3 = conn.prepareStatement(execQueryStr4.toString()); 
					*/

					for (int i = 0; i < paramList.size(); i++) {
						Map map = (Map)paramList.get(i);

						//String timeKey = (String)map.get("timeStr");
						
						ppStmt.setString(1, employeeID);
						ppStmt.setString(2, dateStr);
						ppStmt.setString(3, (String)map.get("timeStr"));
						ppStmt.setString(4, (String)map.get("pjt"));
						ppStmt.setString(5, (String)map.get("drwType"));
						ppStmt.setString(6, (String)map.get("drwNo"));
						ppStmt.setString(7, (String)map.get("op"));
						ppStmt.setString(8, (String)map.get("depart"));
						ppStmt.setString(9, (String)map.get("basis"));
						ppStmt.setString(10, (String)map.get("workContent"));
						ppStmt.setString(11, (String)map.get("event1"));
						ppStmt.setString(12, (String)map.get("event2"));
						ppStmt.setString(13, (String)map.get("event3"));
						ppStmt.setFloat(14, Float.parseFloat((String)map.get("normalTime"))); 
						ppStmt.setFloat(15, Float.parseFloat((String)map.get("overtime"))); 
						ppStmt.setFloat(16, Float.parseFloat((String)map.get("specialTime"))); 
						ppStmt.setString(17, inputDoneYN);
						ppStmt.setString(18, loginID);
						ppStmt.setString(19, loginID);
						ppStmt.setString(20, (String)map.get("shipType"));

						ppStmt.executeUpdate();

						/*
						// Event1, Event2, Event3 값이 있으면 공정 Action Date를 업데이트
						for (int j = 1; j <= 3; j++) {
							String fieldKey = "event" + Integer.toString(j);
							String fieldValue = (String)map.get(fieldKey);
							if (fieldValue.startsWith("Y") || fieldValue.startsWith("V")) {
								String dbFieldName = "";
								String workTypeStr = "";
								if (fieldValue.endsWith("1")) { dbFieldName = "ACTUALSTARTDATE"; workTypeStr = "DW"; }
								else if (fieldValue.endsWith("2")) { dbFieldName = "ACTUALFINISHDATE"; workTypeStr = "DW"; }
								else if (fieldValue.endsWith("3")) { dbFieldName = "ACTUALSTARTDATE"; workTypeStr = "OW"; }
								else if (fieldValue.endsWith("4")) { dbFieldName = "ACTUALFINISHDATE"; workTypeStr = "OW"; }
								else if (fieldValue.endsWith("5")) { dbFieldName = "ACTUALSTARTDATE"; workTypeStr = "CL"; }
								else if (fieldValue.endsWith("6")) { dbFieldName = "ACTUALFINISHDATE"; workTypeStr = "CL"; }
								else if (fieldValue.endsWith("7")) { dbFieldName = "ACTUALSTARTDATE"; workTypeStr = "RF"; }
								else if (fieldValue.endsWith("8")) { dbFieldName = "ACTUALSTARTDATE"; workTypeStr = "WK"; }

								String execQueryStr5 = "UPDATE PLM_ACTIVITY                                                      " + 
													   "   SET " + dbFieldName + " = TO_DATE('" + dateStr + "', 'YYYY-MM-DD')    " + 
													   " WHERE PROJECTNO = '" + (String)map.get("pjt") + "'                      " + 
								                       "   AND ACTIVITYCODE = '" + (String)map.get("drwNo") + workTypeStr +  "'  " + 
									                   "   AND " + dbFieldName + " IS NULL                                       ";
								
								java.sql.Statement stmt2 = null;
								try {
									stmt2 = conn.createStatement();
									stmt2.executeUpdate(execQueryStr5);
								} finally {
									if (stmt2 != null) stmt2.close();
								}
							}
						}
						*/

						/*
						// 공정 시수를 업데이트
						if (!"*****".equals((String)map.get("drwNo")) && !"#####".equals((String)map.get("drwNo"))) {
							ppStmt2.setString(1, (String)map.get("pjt"));
							ppStmt2.setString(2, (String)map.get("drwNo"));

							java.sql.ResultSet rset = ppStmt2.executeQuery();
							if (rset.next()) {
								ppStmt3.setString(1, rset.getString(3));
								ppStmt3.setString(2, rset.getString(4));
								ppStmt3.setString(3, rset.getString(1));
								ppStmt3.setString(4, rset.getString(2) + "DW");

								ppStmt3.executeUpdate();
							}
						}
						*/
					}
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (stmt != null) stmt.close();
			if (ppStmt != null) ppStmt.close();
			/*
			if (ppStmt2 != null) ppStmt2.close();
			if (ppStmt3 != null) ppStmt3.close();
			*/
			DBConnect.closeConnection(conn);
		}
	}

	// saveAsOneDayOverJobDPInputs() : 시수입력 사항을 DB에 저장(1 일 이상 - 기술회의 및 교육, 일반출장)
	private static synchronized String saveAsOneDayOverJobDPInputs(String employeeID, String fromDateStr, String toDateStr, 
	                                                               String workContentStr, String opCode, String loginID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(fromDateStr)) throw new Exception("From Date String is null");
		if (StringUtil.isNullString(toDateStr)) throw new Exception("To Date String is null");
		if (StringUtil.isNullString(workContentStr)) throw new Exception("Work Content String is null");
		if (StringUtil.isNullString(opCode)) throw new Exception("OP CODE is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt1 = null;
		java.sql.Statement stmt2 = null;
		java.sql.PreparedStatement ppStmt = null;
		java.sql.ResultSet rset = null;

		int insertedCnt = 0;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr1 = "DELETE FROM PLM_DESIGN_MH                                       " +
                                       " WHERE EMPLOYEE_NO = '" + employeeID + "'                       " +
                                       "   AND WORK_DAY >= TO_DATE('" + fromDateStr + "', 'YYYY-MM-DD') " +
                                       "   AND WORK_DAY <= TO_DATE('" + toDateStr + "', 'YYYY-MM-DD')   ";

				String execQueryStr2 = "SELECT TO_CHAR(WORKINGDAY, 'YYYY-MM-DD'), INSIDEWORKTIME               " + 
                                       "  FROM CCC_CALENDAR                                                    " + 
                                       " WHERE WORKINGDAY BETWEEN TO_DATE('" + fromDateStr + "', 'YYYY-MM-DD') " + 
                                       "                      AND TO_DATE('" + toDateStr + "', 'YYYY-MM-DD')   " +
                                       "   AND ISWORKDAY = 'Y'                                                 " +
                                       " ORDER BY WORKINGDAY                                                   ";


				String execQueryStr3 = "INSERT INTO PLM_DESIGN_MH                                                                     " + 
									   " ( EMPLOYEE_NO, DEPT_CODE, WORK_DAY, START_TIME, PROJECT_NO, DWG_TYPE, DWG_CODE,              " +
									   "   OP_CODE, CAUSE_DEPART, BASIS, WORK_DESC, EVENT1, EVENT2, EVENT3, NORMAL_TIME,              " +
					                   "   OVERTIME, SPECIAL_TIME, INPUTDONE_YN, CONFIRM_YN, CREATE_DATE, CREATE_BY,                  " +
					                   "   UPDATE_DATE, UPDATE_BY, SHIP_TYPE     )                                                    " +
									   "VALUES (?, (SELECT DEPT_CODE FROM CCC_SAWON WHERE EMPLOYEE_NUM = '" + employeeID + "'),       " +
				                       "        TO_DATE(?, 'YYYY-MM-DD'), '08:00', 'S000', '', '*****', '" + opCode + "', '', '',     " + 
					                   "        '" + workContentStr + "', '', '', '', ?, 0, 0, 'Y', 'N', SYSDATE, ?, SYSDATE, ?, '')  ";

				// 먼저 기 존재하는 값들을 모두 삭제
				stmt1 = conn.createStatement();
				stmt1.executeUpdate(execQueryStr1); 

				// 기간에 해당하는 날짜 범위를 쿼리(시작~종료 날짜 사이의 모든 날짜에서 휴일은 제외)
				stmt2 = conn.createStatement();
				rset = stmt2.executeQuery(execQueryStr2);

				// 기간 범위 내 모든 날짜에 해당 시수 적용
				while (rset.next()) {
					String dateStr = rset.getString(1);
					String workTimeStr = rset.getString(2);

					if (ppStmt == null) ppStmt = conn.prepareStatement(execQueryStr3); 
					ppStmt.setString(1, employeeID);
					ppStmt.setString(2, dateStr);
					ppStmt.setFloat(3, Float.parseFloat(workTimeStr)); // 4H 인 경우 시수 4 시간, 그 외(9H)는 9 시간
					ppStmt.setString(4, loginID);
					ppStmt.setString(5, loginID);
					ppStmt.executeUpdate();
					
					insertedCnt++;
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt1 != null) stmt1.close();
			if (stmt2 != null) stmt2.close();
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}

		return Integer.toString(insertedCnt);
	}

	// saveAsOneDayOverJobDPInputs() : 시수입력 사항을 DB에 저장(1 일 이상(호선선택 포함) - 사외 협의 검토)
	private static synchronized String saveAsOneDayOverJobWithProjectDPInputs(String employeeID, String projectNo, 
		String fromDateStr, String toDateStr, String workContentStr, String opCode, String loginID) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(projectNo)) throw new Exception("Projet No. is null");
		if (StringUtil.isNullString(fromDateStr)) throw new Exception("From Date String is null");
		if (StringUtil.isNullString(toDateStr)) throw new Exception("To Date String is null");
		if (StringUtil.isNullString(workContentStr)) throw new Exception("Work Content String is null");
		if (StringUtil.isNullString(opCode)) throw new Exception("OP CODE is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt1 = null;
		java.sql.Statement stmt2 = null;
		java.sql.PreparedStatement ppStmt = null;
		java.sql.ResultSet rset = null;

		int insertedCnt = 0;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr1 = "DELETE FROM PLM_DESIGN_MH                                       " +
                                       " WHERE EMPLOYEE_NO = '" + employeeID + "'                       " +
                                       "   AND WORK_DAY >= TO_DATE('" + fromDateStr + "', 'YYYY-MM-DD') " +
                                       "   AND WORK_DAY <= TO_DATE('" + toDateStr + "', 'YYYY-MM-DD')   ";

				String execQueryStr2 = "SELECT TO_CHAR(WORKINGDAY, 'YYYY-MM-DD'), INSIDEWORKTIME               " + 
                                       "  FROM CCC_CALENDAR                                                    " + 
                                       " WHERE WORKINGDAY BETWEEN TO_DATE('" + fromDateStr + "', 'YYYY-MM-DD') " + 
                                       "                      AND TO_DATE('" + toDateStr + "', 'YYYY-MM-DD')   " +
                                       "   AND ISWORKDAY = 'Y'                                                 " +
                                       " ORDER BY WORKINGDAY                                                   ";

				String execQueryStr3 = "INSERT INTO PLM_DESIGN_MH                                                                             " + 
									   " ( EMPLOYEE_NO, DEPT_CODE, WORK_DAY, START_TIME, PROJECT_NO, DWG_TYPE, DWG_CODE,                      " +
									   "   OP_CODE, CAUSE_DEPART, BASIS, WORK_DESC, EVENT1, EVENT2, EVENT3, NORMAL_TIME,                      " +
					                   "   OVERTIME, SPECIAL_TIME, INPUTDONE_YN, CONFIRM_YN, CREATE_DATE, CREATE_BY,                          " +
					                   "   UPDATE_DATE, UPDATE_BY, SHIP_TYPE     )                                                            " +
									   "VALUES (?, (SELECT DEPT_CODE FROM CCC_SAWON WHERE EMPLOYEE_NUM = '" + employeeID + "'),               " +
				                       "        TO_DATE(?, 'YYYY-MM-DD'), '08:00', '" + projectNo + "', '', '*****', '" + opCode + "',        " + 
					                   "        '', '', '" + workContentStr + "', '', '', '', ?, 0, 0, 'Y', 'N', SYSDATE, ?, SYSDATE, ?, '')  ";

				// 먼저 기 존재하는 값들을 모두 삭제
				stmt1 = conn.createStatement();
				stmt1.executeUpdate(execQueryStr1); 

				// 기간에 해당하는 날짜 범위를 쿼리(시작~종료 날짜 사이의 모든 날짜에서 휴일은 제외)
				stmt2 = conn.createStatement();
				rset = stmt2.executeQuery(execQueryStr2);

				// 기간 범위 내 모든 날짜에 해당 시수 적용
				while (rset.next()) {
					String dateStr = rset.getString(1);
					String workTimeStr = rset.getString(2);

					if (ppStmt == null) ppStmt = conn.prepareStatement(execQueryStr3); 
					ppStmt.setString(1, employeeID);
					ppStmt.setString(2, dateStr);
					ppStmt.setFloat(3, Float.parseFloat(workTimeStr)); // 4H 인 경우 시수 4 시간, 그 외(9H)는 9 시간
					ppStmt.setString(4, loginID);
					ppStmt.setString(5, loginID);
					ppStmt.executeUpdate();
					
					insertedCnt++;
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt1 != null) stmt1.close();
			if (stmt2 != null) stmt2.close();
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}

		return Integer.toString(insertedCnt);
	}

	// saveSeaTrialDPInputs() : 시수입력 사항을 DB에 저장(시운전 Only 케이스)
	private static synchronized void saveSeaTrialDPInputs(String employeeID, String dateStr, String loginID, String projectNo) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt1 = null;
		java.sql.Statement stmt2 = null;
		java.sql.PreparedStatement ppStmt = null;
		java.sql.ResultSet rset = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr1 = "DELETE FROM PLM_DESIGN_MH                                       " +
                                       " WHERE EMPLOYEE_NO = '" + employeeID + "'                       " +
                                       "   AND WORK_DAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD')      ";

				String execQueryStr2 = "SELECT ISWORKDAY, INSIDEWORKTIME                             " + 
                                       "  FROM CCC_CALENDAR                                          " + 
                                       " WHERE WORKINGDAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD') ";

				String execQueryStr3 = "INSERT INTO PLM_DESIGN_MH                                                                   " + 
									   " ( EMPLOYEE_NO, DEPT_CODE, WORK_DAY, START_TIME, PROJECT_NO, DWG_TYPE, DWG_CODE,            " +
									   "   OP_CODE, CAUSE_DEPART, BASIS, WORK_DESC, EVENT1, EVENT2, EVENT3, NORMAL_TIME,            " +
					                   "   OVERTIME, SPECIAL_TIME, INPUTDONE_YN, CONFIRM_YN, CREATE_DATE, CREATE_BY,                " +
					                   "   UPDATE_DATE, UPDATE_BY, SHIP_TYPE     )                                                  " +
									   "VALUES (?, (SELECT DEPT_CODE FROM CCC_SAWON WHERE EMPLOYEE_NUM = '" + employeeID + "'),     " + 
					                   "TO_DATE(?, 'YYYY-MM-DD'), '08:00', ?, '', '*****', 'B53', '', '',                           " + 
					                   "        '시운전', '', '', '', ?, ?, ?, 'Y', 'N', SYSDATE, ?, SYSDATE, ?, '')                ";

				// 먼저 기 존재하는 값들을 모두 삭제
				stmt1 = conn.createStatement();
				stmt1.executeUpdate(execQueryStr1); 

				// 해당일자의 평일/4H/휴일 여부 쿼리
				stmt2 = conn.createStatement();
				rset = stmt2.executeQuery(execQueryStr2);

				// '시운전' 시수 적용
				rset.next();
				String isWorkingDay = rset.getString(1);
				String workTimeStr = rset.getString(2);
				float normalTime = 0;
				float overtime = 0;
				float specialTime = 0;
				if (isWorkingDay.equals("N")) specialTime = 8;	 // 휴일이면 특근 8 시간으로 처리
				else {
					if (workTimeStr.equals("4")) normalTime = 4; // 4H 이면 정상근무 4 시간 + 잔업 3 시간
					else normalTime = 9;                         // 나머지는 정상근무 9 시간 + 잔업 3 시간
					overtime = 3;
				}

				ppStmt = conn.prepareStatement(execQueryStr3); 
				ppStmt.setString(1, employeeID);
				ppStmt.setString(2, dateStr);
				ppStmt.setString(3, projectNo);
				ppStmt.setFloat(4, normalTime); 
				ppStmt.setFloat(5, overtime); 
				ppStmt.setFloat(6, specialTime); 
				ppStmt.setString(7, loginID);
				ppStmt.setString(8, loginID);
				ppStmt.executeUpdate();

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt1 != null) stmt1.close();
			if (stmt2 != null) stmt2.close();
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getDesignMHConfirmYNs() : 사번 + 기간에 대한 입력시수 결재 정보를 쿼리
	private static synchronized ArrayList getDesignMHConfirmYNs(String employeeID, String fromDate, String toDate) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(fromDate)) throw new Exception("From Date String is null");
		if (StringUtil.isNullString(toDate)) throw new Exception("To Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT TO_CHAR(A.WORKINGDAY, 'YYYY-MM-DD') AS WORKINGDAY, B.EMPLOYEE_NO, A.ISWORKDAY,                             ");
			queryStr.append("       SUM(B.NORMAL_TIME) AS NORMAL, SUM(B.OVERTIME) AS OVERTIME, SUM(B.SPECIAL_TIME) AS SPECIAL,                 ");
			queryStr.append("       B.INPUTDONE_YN, B.CONFIRM_YN                                                                               ");
			queryStr.append("  FROM CCC_CALENDAR A, PLM_DESIGN_MH B                                                                            ");
			queryStr.append(" WHERE A.WORKINGDAY BETWEEN TO_DATE('" + fromDate + "', 'YYYY-MM-DD') AND TO_DATE('" + toDate + "', 'YYYY-MM-DD') ");
			queryStr.append("   AND A.WORKINGDAY= B.WORK_DAY(+)                                                                                ");
			queryStr.append("   AND B.EMPLOYEE_NO(+)='" + employeeID + "'                                                                      ");
			queryStr.append(" GROUP BY A.WORKINGDAY, B.EMPLOYEE_NO, A.ISWORKDAY, B.INPUTDONE_YN, B.CONFIRM_YN                                  ");
			queryStr.append(" ORDER BY A.WORKINGDAY                                                                                            ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("WORKINGDAY", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NO", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("ISWORKDAY", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("NORMAL", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("OVERTIME", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("SPECIAL", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("INPUTDONE_YN", rset.getString(7) == null ? "N" : rset.getString(7));
				resultMap.put("CONFIRM_YN", rset.getString(8) == null ? "N" : rset.getString(8));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getDesignMHConfirmExist() : 사번 + 기간에 결재완료된 입력시수가 존재하는지 체크(쿼리)
	private static synchronized String getDesignMHConfirmExist(String employeeID, String fromDate, String toDate) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(fromDate)) throw new Exception("From Date String is null");
		if (StringUtil.isNullString(toDate)) throw new Exception("To Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultMsg = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT DECODE(COUNT(*), 0, 'N', 'Y') AS CONFIRM_EXIST                                                           ");
			queryStr.append("  FROM PLM_DESIGN_MH A                                                                                          ");
			queryStr.append(" WHERE A.WORK_DAY BETWEEN TO_DATE('" + fromDate + "', 'YYYY-MM-DD') AND TO_DATE('" + toDate + "', 'YYYY-MM-DD') ");
			queryStr.append("   AND A.EMPLOYEE_NO='" + employeeID + "'                                                                       ");
			queryStr.append("   AND A.CONFIRM_YN='Y'                                                                                         ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultMsg = rset.getString(1);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultMsg;
	}

	// getPartPersonDPConfirms() : 부서(파트) + 날짜에 해당하는 입력시수 결재 여부를 쿼리
	private static synchronized ArrayList getPartPersonDPConfirms(String departCode, String dateStr) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();


			queryStr.append("SELECT EMPLOYEE_NUM, NAME, WORKTIME, NORMAL, OVERTIME, SPECIAL, INPUTDONE_YN, CONFIRM_YN,                         ");
			queryStr.append("                                                                                                                  ");
			queryStr.append("       CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                                     ");
			queryStr.append("       	 ELSE (                                                                                                ");
			queryStr.append("       			SELECT FACTOR_VALUE                                                                            ");
			queryStr.append("       			  FROM (                                                                                       ");
			queryStr.append("       					SELECT CAREER_MONTH_FROM,                                                              ");
			queryStr.append("       							CAREER_MONTH_TO,                                                               ");
			queryStr.append("       							FACTOR_VALUE                                                                   ");
			queryStr.append("       					  FROM PLM_DESIGN_MH_FACTOR A                                                          ");
			queryStr.append("       					 WHERE 1 = 1                                                                           ");
			queryStr.append("       					   AND A.CASE_NO = (                                                                   ");
			queryStr.append("       										 SELECT VALUE                                                      ");
			queryStr.append("       										   FROM PLM_CODE_TBL A                                             ");
			queryStr.append("       										  WHERE A.CATEGORY = 'MH_FACTOR'                                   ");
			queryStr.append("       											AND A.KEY = 'ACTIVE_CASE'                                      ");
			queryStr.append("       										)                                                                  ");
			queryStr.append("       					)                                                                                      ");
			queryStr.append("       			  WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                                     ");
			queryStr.append("       				AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                            ");
			queryStr.append("       		  )                                                                                                ");
			queryStr.append("       END AS MH_FACTOR                                                                                           ");
			queryStr.append("                                                                                                                  ");
			queryStr.append("  FROM                                                                                                            ");
			queryStr.append("    (                                                                                                             ");
			queryStr.append("    SELECT A.EMPLOYEE_NUM, A.NAME, SUM(B.NORMAL_TIME) + SUM(B.OVERTIME) + SUM(B.SPECIAL_TIME) AS WORKTIME,        ");
			queryStr.append("           SUM(B.NORMAL_TIME) AS NORMAL, SUM(B.OVERTIME) AS OVERTIME, SUM(B.SPECIAL_TIME) AS SPECIAL,             ");
			queryStr.append("           B.INPUTDONE_YN, B.CONFIRM_YN,                                                                          ");
			queryStr.append("                                                                                                                  ");
			queryStr.append("           A.POSITION,                                                                                            ");
			queryStr.append("           (                                                                                                      ");
			//queryStr.append("           CASE WHEN SUBSTR(A.POSITION, 1, 2) <> '주임' THEN NULL                                                 ");
			//queryStr.append("           	ELSE                                                                                               ");
			//queryStr.append("           	(                                                                                                  ");
			queryStr.append("           	  ((TO_CHAR(TO_DATE('"+dateStr+"','YYYY-MM-DD'),'YYYY') - TO_CHAR(A.DESIGN_APPLY_DATE, 'YYYY'))    ");
			queryStr.append("                 * 12 +                                                                                           ");
			queryStr.append("           	  (TO_CHAR(TO_DATE('"+dateStr+"', 'YYYY-MM-DD'), 'MM') - TO_CHAR(A.DESIGN_APPLY_DATE, 'MM'))) +    ");
			queryStr.append("           	  CASE WHEN TO_CHAR(A.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                                        ");
			queryStr.append("           	  	   WHEN TO_CHAR(A.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                                         ");
			queryStr.append("           	  END +                                                                                            ");
			queryStr.append("           	  NVL(ROUND(A.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                                                  ");
			//queryStr.append("           	)                                                                                                  ");
			//queryStr.append("           END                                                                                                    ");
			queryStr.append("           )AS CAREER_MONTHS                                                                                      ");
			queryStr.append("                                                                                                                  ");
			queryStr.append("      FROM CCC_SAWON A, PLM_DESIGN_MH B                                                                           ");
			queryStr.append("     WHERE A.EMPLOYEE_NUM = B.EMPLOYEE_NO(+)                                                                      ");
			queryStr.append("       AND A.TERMINATION_DATE IS NULL                                                                             ");
			queryStr.append("       AND A.INPUT_MAN_HOUR_ENABLED = 'Y'                                                                         ");
			queryStr.append("       AND A.DEPT_CODE(+) = '" + departCode + "'                                                                  ");
			queryStr.append("       AND B.WORK_DAY(+) = TO_DATE('" + dateStr + "', 'YYYY-MM-DD')                                               ");
			queryStr.append("     GROUP BY A.EMPLOYEE_NUM, A.NAME, A.DESIGN_APPLY_DATE, A.BEFORE_ENTRANCE_CAREER, A.POSITION,                  ");
			queryStr.append("              B.INPUTDONE_YN, B.CONFIRM_YN                                                                        ");
			queryStr.append("     ORDER BY A.EMPLOYEE_NUM                                                                                      ");
			queryStr.append("    )                                                                                                             ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("WORKTIME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("NORMAL", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("OVERTIME", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("SPECIAL", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("INPUTDONE_YN", rset.getString(7) == null ? "N" : rset.getString(7));
				resultMap.put("CONFIRM_YN", rset.getString(8) == null ? "N" : rset.getString(8));
				resultMap.put("MH_FACTOR", Float.toString(rset.getFloat(9)));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getPartDPConfirmsList() : 해당 날짜(기간)에 부서원 전체의 시수결재가 완료되었는지 여부를 쿼리
	private static synchronized ArrayList getPartDPConfirmsList(String departCode, String dateFrom, String dateTo) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT WORK_DAY,                                                                                       ");
			queryStr.append("       CASE WHEN ISWORKDAY = 'N' THEN                                                                  ");
			queryStr.append("                 (                                                                                     ");
			queryStr.append("                    CASE WHEN PART_INPUT_EMP_COUNT = 0 THEN '-'                                        ");
			queryStr.append("                         WHEN CONFIRM_NO_COUNT = 0 THEN 'Y'                                            ");
			queryStr.append("                         ELSE 'N'                                                                      ");
			queryStr.append("                    END                                                                                ");
			queryStr.append("                 )                                                                                     ");
			queryStr.append("            ELSE (                                                                                     ");
			queryStr.append("                    CASE WHEN CONFIRM_NO_COUNT = 0 AND PART_EMP_COUNT <= PART_INPUT_EMP_COUNT THEN 'Y'  ");
			queryStr.append("                         ELSE 'N'                                                                      ");
			queryStr.append("                    END                                                                                ");
			queryStr.append("                 )                                                                                     ");
			queryStr.append("       END AS CONFIRM_ALL_YN                                                                           ");
			queryStr.append("  FROM                                                                                                 ");
			queryStr.append("  (                                                                                                    ");
			queryStr.append("    SELECT TO_CHAR(WORKINGDAY, 'YYYY-MM-DD') AS WORK_DAY,                                              ");
			queryStr.append("           ISWORKDAY,                                                                                  ");
			queryStr.append("           CONFIRM_NO_COUNT,                                                                           ");
			queryStr.append("           (                                                                                           ");
			queryStr.append("                SELECT COUNT(*)                                                                        ");
			queryStr.append("                  FROM CCC_SAWON                                                                       ");
			queryStr.append("                 WHERE 1= 1                                                                            ");
			queryStr.append("                   AND TERMINATION_DATE IS NULL                                                        ");
			queryStr.append("                   AND INPUT_MAN_HOUR_ENABLED = 'Y'                                                    ");
			queryStr.append("                   AND DEPT_CODE = '" + departCode + "'                                                ");
			queryStr.append("           ) AS PART_EMP_COUNT,                                                                        ");
			queryStr.append("           (                                                                                           ");
			queryStr.append("                SELECT COUNT(DISTINCT EMPLOYEE_NO)                                                     ");
			queryStr.append("                  FROM PLM_DESIGN_MH C                                                                 ");
			queryStr.append("                 WHERE C.WORK_DAY = WORKINGDAY                                                         ");
			queryStr.append("                   AND DEPT_CODE = '" + departCode + "'                                                ");
			queryStr.append("           ) AS PART_INPUT_EMP_COUNT                                                                   ");
			queryStr.append("      FROM (                                                                                           ");
			queryStr.append("                SELECT B.WORKINGDAY,                                                                   ");
			queryStr.append("                       B.ISWORKDAY,                                                                    ");
			queryStr.append("                       A.CONFIRM_NO_COUNT                                                              ");
			queryStr.append("                  FROM (                                                                               ");
			queryStr.append("                        SELECT B.WORK_DAY,                                                             ");
			queryStr.append("                               SUM(DECODE(B.CONFIRM_YN, 'N', 1, 0)) AS CONFIRM_NO_COUNT                ");
			queryStr.append("                          FROM CCC_SAWON A,                                                            ");
			queryStr.append("                               PLM_DESIGN_MH B                                                         ");
			queryStr.append("                         WHERE A.EMPLOYEE_NUM = B.EMPLOYEE_NO                                          ");
			queryStr.append("                           AND A.DEPT_CODE = '" + departCode + "'                                      ");
			queryStr.append("                           AND B.WORK_DAY >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                 ");
			queryStr.append("                           AND B.WORK_DAY <= TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                   ");
			queryStr.append("                         GROUP BY B.WORK_DAY                                                           ");
			queryStr.append("                       ) A,                                                                            ");
			queryStr.append("                       CCC_CALENDAR B                                                                  ");
			queryStr.append("                 WHERE 1 = 1                                                                           ");
			queryStr.append("                   AND B.WORKINGDAY >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                       ");
			queryStr.append("                   AND B.WORKINGDAY <= TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                         ");
			queryStr.append("                   AND B.WORKINGDAY = A.WORK_DAY(+)                                                    ");
			queryStr.append("           )                                                                                           ");
			queryStr.append("  )                                                                                                    ");
			queryStr.append(" ORDER BY WORK_DAY                                                                                     ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("WORK_DAY", rset.getString(1));
				resultMap.put("CONFIRM_YN", rset.getString(2));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getPartDPInputRateList() : 부서(파트) + 날짜에 해당하는 시수 입력 현황을 쿼리
	private static synchronized ArrayList getPartDPInputRateList(String departCode, String dateFrom, String dateTo) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT WORK_DAY,                                                                                      \n");
			queryStr.append("       ISWORKDAY,                                                                                     \n");
			queryStr.append("       CASE WHEN ISWORKDAY = 'N' THEN                                                                 \n");
			queryStr.append("                 (                                                                                    \n");
			queryStr.append("                    CASE WHEN INPUTDONE_NO_COUNT != 0 THEN                                            \n");
			queryStr.append("                              (                                                                       \n");
			queryStr.append("									CASE WHEN ROUND(INPUTDONE_NO_COUNT / PART_EMP_COUNT * 100,0) > 100 THEN '100'   \n");
			queryStr.append("										 ELSE TO_CHAR(ROUND(INPUTDONE_NO_COUNT / PART_EMP_COUNT * 100,0))           \n");
			queryStr.append("									END                                                                \n");
			queryStr.append("								)                                                                      \n");
			queryStr.append("                         ELSE '-'                                                                     \n");
			queryStr.append("                    END                                                                               \n");
			queryStr.append("                 )                                                                                    \n");
			queryStr.append("            ELSE (                                                                                    \n");
			queryStr.append("                    CASE WHEN ROUND(INPUTDONE_NO_COUNT / PART_EMP_COUNT * 100,0) > 100 THEN '100'     \n");
			queryStr.append("                         ELSE TO_CHAR(ROUND(INPUTDONE_NO_COUNT / PART_EMP_COUNT * 100,0))             \n");
			queryStr.append("                    END                                                                               \n");
			queryStr.append("                 )                                                                                    \n");
			queryStr.append("       END AS INPUT_RATE                                                                              \n");
			queryStr.append("  FROM                                                                                                \n");
			queryStr.append("  (                                                                                                   \n");
			queryStr.append("    SELECT TO_CHAR(WORKINGDAY, 'YYYY-MM-DD') AS WORK_DAY,                                             \n");
			queryStr.append("           ISWORKDAY,                                                                                 \n");
			queryStr.append("           INPUTDONE_NO_COUNT,                                                                        \n");
			queryStr.append("           (                                                                                          \n");
			queryStr.append("                SELECT COUNT(*)                                                                       \n");
			queryStr.append("                  FROM CCC_SAWON                                                                      \n");
			queryStr.append("                 WHERE 1= 1                                                                           \n");
			queryStr.append("                   AND TERMINATION_DATE IS NULL                                                       \n");
			queryStr.append("                   AND INPUT_MAN_HOUR_ENABLED = 'Y'                                                   \n");
			queryStr.append("                   AND DEPT_CODE = '" + departCode + "'                                               \n");
			queryStr.append("           ) AS PART_EMP_COUNT                                                                        \n");
			queryStr.append("      FROM (                                                                                          \n");
			queryStr.append("                SELECT B.WORKINGDAY,                                                                  \n");
			queryStr.append("                       B.ISWORKDAY,                                                                   \n");
			queryStr.append("                       NVL(A.INPUTDONE_NO_COUNT,0) AS INPUTDONE_NO_COUNT                              \n");
			queryStr.append("                  FROM (                                                                              \n");
			queryStr.append("                        SELECT B.WORK_DAY,                                                            \n");
			queryStr.append("                               COUNT(DISTINCT EMPLOYEE_NO) AS INPUTDONE_NO_COUNT                      \n");
			queryStr.append("                          FROM CCC_SAWON A,                                                           \n");
			queryStr.append("                               PLM_DESIGN_MH B                                                        \n");
			queryStr.append("                         WHERE A.EMPLOYEE_NUM = B.EMPLOYEE_NO                                         \n");
			queryStr.append("                           AND A.DEPT_CODE = '" + departCode + "'                                     \n");
			queryStr.append("                           AND B.WORK_DAY >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                \n");
			queryStr.append("                           AND B.WORK_DAY <= TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                  \n");
			queryStr.append("                           AND B.INPUTDONE_YN = 'Y'                                                   \n");
			queryStr.append("                         GROUP BY B.WORK_DAY                                                          \n");
			queryStr.append("                       ) A,                                                                           \n");
			queryStr.append("                       CCC_CALENDAR B                                                                 \n");
			queryStr.append("                 WHERE 1 = 1                                                                          \n");
			queryStr.append("                   AND B.WORKINGDAY >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                      \n");
			queryStr.append("                   AND B.WORKINGDAY <= TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                        \n");
			queryStr.append("                   AND B.WORKINGDAY = A.WORK_DAY(+)                                                   \n");
			queryStr.append("           )                                                                                          \n");
			queryStr.append("  )                                                                                                   \n");
			queryStr.append(" ORDER BY WORK_DAY                                                                                    \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("WORK_DAY", rset.getString(1));
				resultMap.put("ISWORKDAY", rset.getString(2));
				resultMap.put("INPUT_RATE", rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getHolidayMHList() : 해당 날짜(기간)에 휴일에 근무(시수입력)한 부서원이 있는지 쿼리
	private static synchronized ArrayList getHolidayMHList(String departCode, String dateFrom, String dateTo) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT TO_CHAR(A.WORK_DAY, 'YYYY-MM-DD'),                                                                       ");
			queryStr.append("       A.EMPLOYEE_NO,                                                                                           ");
			queryStr.append("       (SELECT C.POSITION FROM CCC_SAWON C WHERE C.EMPLOYEE_NUM = A.EMPLOYEE_NO) AS POSITION,                   ");
			queryStr.append("       (SELECT C.NAME FROM CCC_SAWON C WHERE C.EMPLOYEE_NUM = A.EMPLOYEE_NO) AS NAME                            ");
			queryStr.append("  FROM PLM_DESIGN_MH A, CCC_CALENDAR B                                                                          ");
			queryStr.append(" WHERE 1 = 1                                                                                                    ");
			queryStr.append("   AND A.WORK_DAY = B.WORKINGDAY                                                                                ");
			queryStr.append("   AND B.ISWORKDAY = 'N'                                                                                        ");
			queryStr.append("   AND A.DEPT_CODE = '" + departCode + "'                                                                       ");
			queryStr.append("   AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD') AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD') ");
			queryStr.append(" GROUP BY A.WORK_DAY, A.EMPLOYEE_NO                                                                             ");
			queryStr.append(" ORDER BY WORK_DAY ASC                                                                                          ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("WORK_DAY", rset.getString(1));
				resultMap.put("EMPLOYEE_NO", rset.getString(2));
				resultMap.put("POSITION", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("EMP_NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getInputRateList() : 해당 날짜(기간)에 부서원의 시수입력율 조회
	private static synchronized ArrayList getInputRateList(String departCode, String dateFrom, String dateTo, boolean under100Only) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT ROWNUM, AA.*                                                                                           ");
			queryStr.append("  FROM                                                                                                        ");
			queryStr.append("        (                                                                                                     ");
			queryStr.append("        WITH MAX_WTIME_TBL AS                                                                                 ");
			queryStr.append("             (                                                                                                ");
			queryStr.append("              SELECT DECODE(SUM(INSIDEWORKTIME), 0, 1, SUM(INSIDEWORKTIME)) AS MAX_WTIME                      ");
			queryStr.append("                FROM CCC_CALENDAR                                                                             ");
			queryStr.append("               WHERE WORKINGDAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                             ");
			queryStr.append("                                    AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                               ");
			queryStr.append("             )                                                                                                ");
			queryStr.append("        SELECT B.EMPLOYEE_NUM,                                                                                ");
			queryStr.append("               B.POSITION,                                                                                    ");
			queryStr.append("               B.NAME AS EMP_NAME,                                                                            ");
			queryStr.append("               NVL(SUM(A.NORMAL_TIME), 0) AS NORMAL_TIME,                                                     ");
			queryStr.append("               NVL(SUM(A.OVERTIME), 0) AS OVERTIME,                                                           ");
			queryStr.append("               NVL(SUM(A.SPECIAL_TIME), 0) AS SPECIAL_TIME,                                                   ");
			queryStr.append("               TRUNC(NVL(SUM(A.NORMAL_TIME), 0) / (SELECT MAX_WTIME FROM MAX_WTIME_TBL) * 100) AS INPUT_RATIO ");
			queryStr.append("          FROM PLM_DESIGN_MH A,                                                                               ");
			queryStr.append("                CCC_SAWON B                                                                                   ");
			queryStr.append("         WHERE 1 = 1                                                                                          ");
			queryStr.append("           AND A.EMPLOYEE_NO(+) = B.EMPLOYEE_NUM                                                              ");
			//queryStr.append("           AND SUBSTR(B.EMPLOYEE_NUM, 1, 1) <> 'P'                                                            ");
			queryStr.append("           AND B.TERMINATION_DATE IS NULL                                                                     ");
			queryStr.append("           AND B.INPUT_MAN_HOUR_ENABLED = 'Y'                                                                 ");
			queryStr.append("           AND B.DEPT_CODE = '" + departCode + "'                                                             ");
			queryStr.append("           AND A.WORK_DAY(+) BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                                ");
			queryStr.append("                                 AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                                  ");
			queryStr.append("         GROUP BY B.EMPLOYEE_NUM, B.POSITION, B.NAME                                                          ");
			queryStr.append("        ) AA                                                                                                  ");
			queryStr.append(" WHERE 1 = 1                                                                                                  ");
			if (under100Only)
				queryStr.append("   AND AA.INPUT_RATIO < 100                                                                               ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("ROWNUM", rset.getString(1));
				resultMap.put("EMPLOYEE_NO", rset.getString(2));
				resultMap.put("POSITION", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("EMP_NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("NORMAL_TIME", rset.getString(5));
				resultMap.put("OVERTIME", rset.getString(6));
				resultMap.put("SPECIAL_TIME", rset.getString(7));
				resultMap.put("INPUT_RATIO", rset.getString(8));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getPartPersons() : 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자 & 시수입력 비 대상자 제외
	private static synchronized ArrayList getPartPersons(String departCode) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.EMPLOYEE_NUM, A.NAME, A.WORK_TELEPHONE ");
			queryStr.append("  FROM CCC_SAWON A                              ");
			queryStr.append(" WHERE A.DEPT_CODE = '" + departCode + "'       ");
			queryStr.append("   AND TERMINATION_DATE IS NULL                 ");
			queryStr.append("   AND INPUT_MAN_HOUR_ENABLED = 'Y'             ");
			queryStr.append(" ORDER BY A.EMPLOYEE_NUM                        ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("PHONE", rset.getString(3) == null ? "" : rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// 부서(파트)의 구성원(파트원) 목록을 쿼리 - (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
	private static synchronized ArrayList getPartPersons_Dalian(String departCode) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.SAWON_ID,                             ");
			queryStr.append("       A.SAWON_NAME,                           ");
			queryStr.append("       '' AS PHONE                             ");
			queryStr.append("  FROM Z_DALIAN_SAWON_TO111231 A,              ");
			queryStr.append("       DCC_DEPTCODE B                          ");
			queryStr.append(" WHERE 1 = 1                                   ");
			queryStr.append("   AND A.DWG_DEPTCODE = B.DWGDEPTCODE          ");
			queryStr.append("   AND B.DEPTCODE = '" + departCode + "'       ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("PHONE", rset.getString(3) == null ? "" : rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getPartPersons2() : 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자 & 시수입력 비 대상자 제외 (다수 개 부서 처리)
	private static synchronized ArrayList getPartPersons2(String departCode) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.EMPLOYEE_NUM, A.NAME, A.WORK_TELEPHONE ");
			queryStr.append("  FROM CCC_SAWON A                              ");
			queryStr.append(" WHERE A.DEPT_CODE IN (" + departCode + ")      ");
			queryStr.append("   AND TERMINATION_DATE IS NULL                 ");
			queryStr.append("   AND INPUT_MAN_HOUR_ENABLED = 'Y'             ");
			queryStr.append(" ORDER BY A.EMPLOYEE_NUM                        ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("PHONE", rset.getString(3) == null ? "" : rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

	// getPartPersonsForDPProgress() : 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자&시수입력&공정입력 비 대상자 제외
	private static synchronized ArrayList getPartPersonsForDPProgress(String departCode) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.EMPLOYEE_NUM, A.NAME, A.WORK_TELEPHONE                        ");
			queryStr.append("  FROM CCC_SAWON A                                                     ");
			queryStr.append(" WHERE A.DEPT_CODE = '" + departCode + "'                              ");
			queryStr.append("   AND TERMINATION_DATE IS NULL                                        ");
			queryStr.append("   AND (INPUT_MAN_HOUR_ENABLED = 'Y' OR INPUT_PROGRESS_ENABLED = 'Y')  ");
			queryStr.append(" ORDER BY A.EMPLOYEE_NUM                                               ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("PHONE", rset.getString(3) == null ? "" : rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}


	// 2016-01-08 추가 : getPartOutsidePersonsForDPProgress() : 부서(파트)의 외주구성원 목록을 쿼리 
	private static synchronized ArrayList getPartOutsidePersonsForDPProgress(String departCode) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.EMPLOYEE_NUM, A.NAME, A.WORK_TELEPHONE                              ");
			queryStr.append("  FROM CCC_SAWON A                                                           ");
			queryStr.append(" WHERE 1=1                                                                   ");
			queryStr.append("   AND A.TERMINATION_DATE IS NULL                                            ");
			queryStr.append("   AND A.OUTSIDER_FLAG='Y'                                                   ");
			queryStr.append("   AND A.DEPT_CODE IN (SELECT DEPT_1.DEPTCODE                                ");
			queryStr.append("                         FROM DCC_DEPTCODE DEPT                              ");
			queryStr.append("                             ,DCC_DEPTCODE DEPT_1                            ");
			queryStr.append("                             ,STX_COM_INSA_DEPT@STXERP INSA_DEPT             ");
			queryStr.append("                        WHERE 1=1                                            ");
			queryStr.append("                          AND DEPT.DWGDEPTCODE = DEPT_1.DWGDEPTCODE          ");
			queryStr.append("                          AND DEPT_1.DEPTCODE = INSA_DEPT.DEPT_CODE          ");
			queryStr.append("                          AND INSA_DEPT.USE_YN ='Y'                          ");
			queryStr.append("                          AND DEPT.DEPTCODE = '" + departCode + "')           ");
			queryStr.append(" ORDER BY A.EMPLOYEE_NUM                                                     ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("PHONE", rset.getString(3) == null ? "" : rset.getString(3));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}



	// saveApprovals() : 시수결재 사항을 DB에 저장 + 공정 시수 업데이트 + 시수마감
	// 2015-10-06 : PLM_DESIGN_MH_CLOSE_PROC가 saveApprovals()에서 수행하던 시수결재 저장, 공정 시수 업데이트, 시수마감 등 수행
	private static synchronized String saveApprovals(String applyStrs, String dateStr, String loginID, String deptCode, String allChecked) throws Exception
	{
		if (StringUtil.isNullString(applyStrs)) throw new Exception("No items to save");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");
		if (StringUtil.isNullString(loginID)) loginID = "";
		if (StringUtil.isNullString(deptCode)) throw new Exception("Dept. Code is null");
		if (StringUtil.isNullString(allChecked)) allChecked = "N";

        String resultMsg = "";

        ArrayList paramList = FrameworkUtil.split(applyStrs, ",");

		java.sql.Connection conn = null;
		java.sql.CallableStatement mh_close_stmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {

				String mh_close_approveList = "";   // 시수마감을 위한 결재 승인 대상리스트
				String mh_close_cancelList = "";    // 시수마감을 위한 결재 취소 대상리스트				

				for (int i = 0; i < paramList.size(); i++) {
					String str = (String)paramList.get(i);
					ArrayList params = FrameworkUtil.split(str, "|");

					String designerID = (String)params.get(0);
					String confirmYN = (String)params.get(1);
                    

					// 시수결재 대상은 시수마감 대상으로, 시수결재 제외 대상은 시수마감 취소 대상.
					if("Y".equals(confirmYN))
					{
						if ("".equals(mh_close_approveList))
						{
							mh_close_approveList = designerID;
						} else {
							mh_close_approveList += ","+designerID;
						}
					} else {
						if ("".equals(mh_close_cancelList))
						{
							mh_close_cancelList = designerID;
						} else {
							mh_close_cancelList += ","+designerID;
						}
					}
				}

				// 2015-03-17 : PLM 시수 결재시 일단위 마감 PROCEDURE 호출				
				mh_close_stmt = conn.prepareCall( "{call PLM_DESIGN_MH_CLOSE_PROC(?,?,?,?,?)}" );
				String returnFlag = "";
				if(!"".equals(mh_close_approveList))
				{
					//System.out.println("~~~~ mh_close_approveList = "+mh_close_approveList);
					mh_close_stmt.setString(1 ,dateStr);
					mh_close_stmt.setString(2, mh_close_approveList);
					mh_close_stmt.setString(3 ,"1");   // 1:마감, 2:취소				
					mh_close_stmt.setString(4 ,loginID);
					mh_close_stmt.registerOutParameter(5, java.sql.Types.VARCHAR);
					mh_close_stmt.execute();
					returnFlag = mh_close_stmt.getString(5)== null ? "" : mh_close_stmt.getString(5) ;
					//System.out.println("~~~~ mh_close_approveList : returnFlag = " + returnFlag);
				}
				if(!"".equals(mh_close_cancelList))
				{
					//System.out.println("~~~~ mh_close_cancelList = "+mh_close_cancelList);
					mh_close_stmt.setString(1 ,dateStr);
					mh_close_stmt.setString(2, mh_close_cancelList);
					mh_close_stmt.setString(3 ,"2");   // 1:마감, 2:취소				
					mh_close_stmt.setString(4 ,loginID);
					mh_close_stmt.registerOutParameter(5, java.sql.Types.VARCHAR);
					mh_close_stmt.execute();
					returnFlag = mh_close_stmt.getString(5)== null ? "" : mh_close_stmt.getString(5) ;
					//System.out.println("~~~~ mh_close_cancelList : returnFlag = " + returnFlag);
				}

				if(!"Y".equals(returnFlag))
				{
					System.out.println("MH CLOSE ERROR  :: dateStr = "+dateStr+" , loginID = "+loginID+"  , mh_close_approveList = "+mh_close_approveList + "   , mh_close_cancelList = "+mh_close_cancelList);
					throw new Exception("MH CLOSE ERROR");

				}

			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
                e.printStackTrace();
				throw new Exception(e.toString());
			}
		}
		finally {
			if (mh_close_stmt != null) mh_close_stmt.close();			
			DBConnect.closeConnection(conn);
		}

        return resultMsg;
	}

	// deleteDPInputs() : 선택된 날짜 + 설계자의 입력시수를 일괄 삭제
	private static synchronized void deleteDPInputs(String employeeID, String dateStr) throws Exception
	{
		if (StringUtil.isNullString(employeeID)) throw new Exception("Empoyee ID is null");
		if (StringUtil.isNullString(dateStr)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			String execQueryStr = "DELETE FROM PLM_DESIGN_MH " + 
								  " WHERE EMPLOYEE_NO = '" + employeeID + 
								  "'  AND WORK_DAY = TO_DATE('" + dateStr + "', 'YYYY-MM-DD') ";

			stmt = conn.createStatement();
			stmt.executeUpdate(execQueryStr); 
		}
		finally {
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getKeyEventDates() : 호선의 Key Event 일자를 쿼리
	private static synchronized Map getKeyEventDates(String projectNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		Map resultMap = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT TO_CHAR(CONTRACTDATE, 'YYYY-MM-DD'),   ");
			queryStr.append("       TO_CHAR(SC, 'YYYY-MM-DD'),             ");
			queryStr.append("       TO_CHAR(KL, 'YYYY-MM-DD'),             ");
			queryStr.append("       TO_CHAR(LC, 'YYYY-MM-DD'),             ");
			queryStr.append("       TO_CHAR(DL, 'YYYY-MM-DD')              ");
			queryStr.append("  FROM LPM_NEWPROJECT                         ");
			queryStr.append(" WHERE 1 = 1                                  ");
			queryStr.append("   AND PROJECTNO = '" + projectNo + "'        ");
			queryStr.append("   AND CASENO = '1'                           ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultMap = new HashMap();
				resultMap.put("CT", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("SC", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("KL", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("LC", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("DL", rset.getString(5) == null ? "" : rset.getString(5));
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultMap;
	}

	// getDesignProgressDevList() : 공정 지연현황 조회
	private static ArrayList getDesignProgressDevList(String projectNo, String deptCode, String designerId, 
	                                                String dateSelected_from, String dateSelected_to, String[] dateConditions, String searchComplete, String searchAll) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (StringUtil.isNullString(dateSelected_to)) throw new Exception("Target Date is null");
		deptCode = StringUtil.setEmptyExt(deptCode);
		designerId = StringUtil.setEmptyExt(designerId);

		String projectNoStrs = "";
		ArrayList projectNoList = FrameworkUtil.split(projectNo, ",");
		for (int i = 0; i < projectNoList.size(); i++) {
			String tempStr = (String)projectNoList.get(i);
			if (i > 0) projectNoStrs += ",";
			projectNoStrs += "'" + tempStr.trim() + "'";
		}
		
		boolean existF = false;
		boolean isComplete = false;
		boolean isAll = false;
		if(dateSelected_from != null && !dateSelected_from.equals(""))existF = true;
		if(searchComplete != null && searchComplete.equals("true"))isComplete = true;
		if(searchAll != null && searchAll.equals("true"))
		{
			isAll = true;
			isComplete = true;
		}
		

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT  C.PROJECTNO                                                                                          ");
			queryStr.append("       ,C.SABUN                                                                                              ");
			queryStr.append("       ,C.DWGDEPTCODENM                                                                                      ");
			queryStr.append("       ,C.DWGDEPTCODE                                                                                        ");
			queryStr.append("       ,C.DWGNO                                                                                              ");
			queryStr.append("       ,C.OUTSOURCINGYN                                                                                      ");
			queryStr.append("       ,C.OUTSOURCING1                                                                                       ");
			queryStr.append("       ,C.OUTSOURCING2                                                                                       ");
			queryStr.append("       ,C.DWGTITLE                                                                                           ");
			queryStr.append("       ,C.DW_PLANSTART                                                                                       ");
			queryStr.append("       ,C.DW_PLANFINISH                                                                                      ");
			queryStr.append("       ,C.DW_ACTIONSTART                                                                                     ");
			queryStr.append("       ,C.DW_ACTIONFINISH                                                                                    ");
			queryStr.append("       ,C.OW_PLANSTART                                                                                       ");
			queryStr.append("       ,C.OW_PLANFINISH                                                                                      ");
			queryStr.append("       ,C.OW_ACTIONSTART                                                                                     ");
			queryStr.append("       ,C.OW_ACTIONFINISH                                                                                    ");
			queryStr.append("       ,C.CL_PLANSTART                                                                                       ");
			queryStr.append("       ,C.CL_PLANFINISH                                                                                      ");
			queryStr.append("       ,C.CL_ACTIONSTART                                                                                     ");
			queryStr.append("       ,C.CL_ACTIONFINISH                                                                                    ");
			queryStr.append("       ,C.RF_PLANSTART                                                                                       ");
			queryStr.append("       ,C.RF_ACTIONSTART                                                                                     ");
			//queryStr.append("       --,C.RF_PLANFINISH                                                                                  ");
			//queryStr.append("       --,C.RF_ACTIONFINISH                                                                                ");
			queryStr.append("       ,C.WK_PLANSTART                                                                                       ");
			queryStr.append("       ,C.WK_ACTIONSTART                                                                                     ");
			//queryStr.append("       --,C.WK_PLANFINISH                                                                                  ");
			//queryStr.append("       --,C.WK_ACTIONFINISH                                                                                ");
			queryStr.append("       ,C.DWGZONE                                                                                            ");
			queryStr.append("       ,(SELECT DELAYREASON FROM PLM_ACTIVITY_DEVIATION                                                      ");
			queryStr.append("          WHERE PROJECTNO = C.PROJECTNO AND DWGNO = C.DWGNO) AS DELAYREASON                                  ");
			queryStr.append("       ,(SELECT TO_CHAR(RESOLVEPLANDATE, 'YYYY-MM-DD')                                                       ");
			queryStr.append("           FROM PLM_ACTIVITY_DEVIATION                                                                       ");
			queryStr.append("          WHERE PROJECTNO = C.PROJECTNO AND DWGNO = C.DWGNO) AS RESOLVEPLANDATE                              ");
			queryStr.append("       ,(SELECT TO_CHAR(REQUIREDDATE, 'YYYY-MM-DD')                                                          ");
			queryStr.append("           FROM PLM_ACTIVITY_DEVIATION                                                                       ");
			queryStr.append("          WHERE PROJECTNO = C.PROJECTNO AND DWGNO = C.DWGNO) AS REQUIREDDATE                                 ");
			queryStr.append("       ,(SELECT DELAYREASON_DESC FROM PLM_ACTIVITY_DEVIATION                                                 ");
			queryStr.append("          WHERE PROJECTNO = C.PROJECTNO AND DWGNO = C.DWGNO) AS DELAYREASON_DESC                             ");
			queryStr.append("       ,(SELECT SAWON.NAME FROM CCC_SAWON SAWON WHERE SAWON.EMPLOYEE_NUM = C.SABUN)                          ");
			queryStr.append("        AS NAME,                                                                                             ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.DW_PLANSTART,'YYYY-MM-DD'))), 1, 'Y', 'N') AS DW_PLAN_S_O, ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.DW_PLANFINISH,'YYYY-MM-DD'))), 1, 'Y', 'N') AS DW_PLAN_F_O,");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.OW_PLANSTART,'YYYY-MM-DD'))), 1, 'Y', 'N') AS OW_PLAN_S_O, ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.OW_PLANFINISH,'YYYY-MM-DD'))), 1, 'Y', 'N') AS OW_PLAN_F_O,");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.CL_PLANSTART,'YYYY-MM-DD'))), 1, 'Y', 'N') AS CL_PLAN_S_O, ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.CL_PLANFINISH,'YYYY-MM-DD'))), 1, 'Y', 'N') AS CL_PLAN_F_O,");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.RF_PLANSTART,'YYYY-MM-DD'))), 1, 'Y', 'N') AS RF_PLAN_S_O, ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE)-TRUNC(TO_DATE(C.WK_PLANSTART,'YYYY-MM-DD'))), 1, 'Y', 'N') AS WK_PLAN_S_O  ");
			queryStr.append("                                                                                                             ");
			queryStr.append("  FROM (SELECT   A.PROJECTNO                                                                                 ");
			queryStr.append("                 ,F_GET_DWGDEPT_INFO('', A.DWGDEPTCODE,'') AS DWGDEPTCODENM                                  ");
			queryStr.append("                 ,A.DWGDEPTCODE                                                                              ");
			queryStr.append("                 ,SUBSTR(A.ACTIVITYCODE, 1, 8) AS DWGNO                                                      ");
			queryStr.append("                 ,A.DWGZONE                                                                                  ");
			queryStr.append("                 ,A.DWGCATEGORY                                                                              ");
			queryStr.append("                 ,A.DWGTYPE                                                                                  ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW'                                                            ");
			queryStr.append("                           THEN DECODE(NVL(A.OUTSOURCINGYN, 'N'), 'N', ' ', NVL(A.OUTSOURCINGYN, 'N')) END)  ");
			queryStr.append("                  AS OUTSOURCINGYN                                                                           ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW'                                                            ");
			queryStr.append("                           THEN DECODE(NVL(A.OUTSOURCING1, 'N'), 'N', ' ', NVL(A.OUTSOURCING1, 'N'))  END)   ");
			queryStr.append("                  AS OUTSOURCING1                                                                            ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW'                                                            ");
			queryStr.append("                           THEN DECODE(NVL(A.OUTSOURCING2, 'N'), 'N', ' ', NVL(A.OUTSOURCING2, 'N')) END)    ");
			queryStr.append("                  AS OUTSOURCING2                                                                            ");
			queryStr.append("                 ,A.DWGTITLE                                                                                 ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW' THEN A.SABUN END) AS SABUN                                 ");
			queryStr.append("                                                                                                             ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW' THEN TO_CHAR(A.PLANSTARTDATE, 'YYYY-MM-DD') END)           ");
			queryStr.append("                  AS DW_PLANSTART                                                                            ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW' THEN TO_CHAR(A.ACTUALSTARTDATE, 'YYYY-MM-DD') END)         ");
			queryStr.append("                  AS DW_ACTIONSTART                                                                          ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW' THEN TO_CHAR(A.PLANFINISHDATE, 'YYYY-MM-DD') END)          ");
			queryStr.append("                  AS DW_PLANFINISH                                                                           ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'DW' THEN TO_CHAR(A.ACTUALFINISHDATE, 'YYYY-MM-DD') END)        ");
			queryStr.append("                  AS DW_ACTIONFINISH                                                                         ");
			queryStr.append("                                                                                                             ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'OW' THEN TO_CHAR(A.PLANSTARTDATE, 'YYYY-MM-DD') END)           ");
			queryStr.append("                  AS OW_PLANSTART                                                                            ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'OW' THEN TO_CHAR(A.ACTUALSTARTDATE, 'YYYY-MM-DD') END)         ");
			queryStr.append("                  AS OW_ACTIONSTART                                                                          ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'OW' THEN TO_CHAR(A.PLANFINISHDATE, 'YYYY-MM-DD') END)          ");
			queryStr.append("                  AS OW_PLANFINISH                                                                           ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'OW' THEN TO_CHAR(A.ACTUALFINISHDATE, 'YYYY-MM-DD') END)        ");
			queryStr.append("                  AS OW_ACTIONFINISH                                                                         ");
			queryStr.append("                                                                                                             ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'CL' THEN TO_CHAR(A.PLANSTARTDATE, 'YYYY-MM-DD') END)           ");
			queryStr.append("                  AS CL_PLANSTART                                                                            ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'CL' THEN TO_CHAR(A.ACTUALSTARTDATE, 'YYYY-MM-DD') END)         ");
			queryStr.append("                  AS CL_ACTIONSTART                                                                          ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'CL' THEN TO_CHAR(A.PLANFINISHDATE, 'YYYY-MM-DD') END)          ");
			queryStr.append("                  AS CL_PLANFINISH                                                                           ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'CL' THEN TO_CHAR(A.ACTUALFINISHDATE, 'YYYY-MM-DD') END)        ");
			queryStr.append("                  AS CL_ACTIONFINISH                                                                         ");
			queryStr.append("                                                                                                             ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'RF' THEN TO_CHAR(A.PLANSTARTDATE, 'YYYY-MM-DD') END)           ");
			queryStr.append("                  AS RF_PLANSTART                                                                            ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'RF' THEN TO_CHAR(A.ACTUALSTARTDATE, 'YYYY-MM-DD') END)         ");
			queryStr.append("                  AS RF_ACTIONSTART                                                                          ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'RF' THEN TO_CHAR(A.PLANFINISHDATE, 'YYYY-MM-DD') END)          ");
			queryStr.append("                  AS RF_PLANFINISH                                                                           ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'RF' THEN TO_CHAR(A.ACTUALFINISHDATE, 'YYYY-MM-DD') END)        ");
			queryStr.append("                  AS RF_ACTIONFINISH                                                                         ");
			queryStr.append("                                                                                                             ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'WK' THEN TO_CHAR(A.PLANSTARTDATE, 'YYYY-MM-DD') END)           ");
			queryStr.append("                  AS WK_PLANSTART                                                                            ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'WK' THEN TO_CHAR(A.ACTUALSTARTDATE, 'YYYY-MM-DD') END)         ");
			queryStr.append("                  AS WK_ACTIONSTART                                                                          ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'WK' THEN TO_CHAR(A.PLANFINISHDATE, 'YYYY-MM-DD') END)          ");
			queryStr.append("                  AS WK_PLANFINISH                                                                           ");
			queryStr.append("                 ,MAX(CASE WHEN A.WORKTYPE = 'WK' THEN TO_CHAR(A.ACTUALFINISHDATE, 'YYYY-MM-DD') END)        ");
			queryStr.append("                  AS WK_ACTIONFINISH                                                                         ");
			queryStr.append("                                                                                                             ");
			queryStr.append("            FROM PLM_ACTIVITY  A                                                                             ");
			queryStr.append("           WHERE 1=1                                                                                         ");
			queryStr.append("             AND A.PROJECTNO IN (" + projectNoStrs + ")                                                      ");
			queryStr.append("             AND (CASE WHEN NVL('" + deptCode + "', ' ') = ' '                                               ");
			queryStr.append("                      THEN ' ' ELSE  A.DWGDEPTCODE  END) = NVL((SELECT MAX(E.DWGDEPTCODE)                    ");
			queryStr.append("                                                                  FROM DCC_DEPTCODE E                        ");
			queryStr.append("                      										      WHERE E.DEPTCODE='" + deptCode + "'), ' ')  ");
			queryStr.append("             AND (CASE WHEN NVL('" + designerId + "', ' ') = ' '                                             ");
			queryStr.append("                      THEN ' ' ELSE A.SABUN END) = NVL('" + designerId + "', ' ')                            ");
			queryStr.append("           GROUP BY  A.PROJECTNO                                                                             ");
			queryStr.append("                    ,SUBSTR(A.ACTIVITYCODE, 1, 8)                                                            ");
			queryStr.append("                    ,A.DWGCATEGORY                                                                           ");
			queryStr.append("                    ,A.DWGTYPE                                                                               ");
			queryStr.append("                    ,A.DWGDEPTCODE                                                                           ");
			queryStr.append("                    ,A.DWGZONE                                                                               ");
			queryStr.append("                    ,A.DWGTITLE) C                                                                           ");
			queryStr.append(" WHERE (0 < (CASE WHEN NVL('" + dateConditions[0] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.DW_PLANSTART IS NOT NULL                                     ");
			queryStr.append("                       AND C.DW_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.DW_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.DW_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.DW_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.DW_ACTIONSTART is not null and to_date(C.DW_PLANSTART,'yyyy-mm-dd') < to_date(C.DW_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[1] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.DW_PLANFINISH IS NOT NULL                                    ");
			queryStr.append("                       AND C.DW_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.DW_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.DW_ACTIONFINISH IS NULL                                                 ");
			if(!isAll)queryStr.append("              AND ((C.DW_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.DW_ACTIONFINISH is not null and to_date(C.DW_PLANFINISH,'yyyy-mm-dd') < to_date(C.DW_ACTIONFINISH,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[2] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.OW_PLANSTART IS NOT NULL                                     ");
			queryStr.append("                       AND C.OW_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.OW_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.OW_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.OW_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.OW_ACTIONSTART is not null and to_date(C.OW_PLANSTART,'yyyy-mm-dd') < to_date(C.OW_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[3] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.OW_PLANFINISH IS NOT NULL                                    ");
			queryStr.append("                       AND C.OW_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.OW_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.OW_ACTIONFINISH IS NULL                                                         ");
			if(!isAll)queryStr.append("              AND ((C.OW_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.OW_ACTIONFINISH is not null and to_date(C.OW_PLANFINISH,'yyyy-mm-dd') < to_date(C.OW_ACTIONFINISH,'yyyy-mm-dd')))   	");
            queryStr.append("                       AND C.OW_PLANSTART <> C.OW_PLANFINISH THEN 1                                          ");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[4] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.CL_PLANSTART IS NOT NULL                                     ");
			queryStr.append("                       AND C.CL_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.CL_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.CL_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.CL_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.CL_ACTIONSTART is not null and to_date(C.CL_PLANSTART,'yyyy-mm-dd') < to_date(C.CL_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[5] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.CL_PLANFINISH IS NOT NULL                                    ");
			queryStr.append("                       AND C.CL_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.CL_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.CL_ACTIONFINISH IS NULL                                                         ");
			if(!isAll)queryStr.append("              AND ((C.CL_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.CL_ACTIONFINISH is not null and to_date(C.CL_PLANFINISH,'yyyy-mm-dd') < to_date(C.CL_ACTIONFINISH,'yyyy-mm-dd')))   	");
            queryStr.append("                       AND C.CL_PLANSTART <> C.CL_PLANFINISH THEN 1                                          ");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[6] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.RF_PLANSTART IS NOT NULL                                     ");
			queryStr.append("                       AND C.RF_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.RF_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.RF_ACTIONSTART IS NULL                                                  ");
			if(!isAll)queryStr.append("              AND ((C.RF_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.RF_ACTIONSTART is not null and to_date(C.RF_PLANSTART,'yyyy-mm-dd') < to_date(C.RF_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[7] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE <> 'V' AND C.WK_PLANSTART IS NOT NULL                                     ");
			queryStr.append("                       AND C.WK_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.WK_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.WK_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.WK_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.WK_ACTIONSTART is not null and to_date(C.WK_PLANSTART,'yyyy-mm-dd') < to_date(C.WK_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("                                                                                                             ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("       0 < (CASE WHEN NVL('" + dateConditions[8] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                    ");
			queryStr.append("                      AND DWGTYPE = 'V' AND C.DW_PLANSTART IS NOT NULL                                       ");
			queryStr.append("                      AND C.DW_PLANSTART <= '" + dateSelected_to + "'                                           ");
			if(existF)queryStr.append("                      AND C.DW_PLANSTART >= '" + dateSelected_from + "'                                           ");
			if(!isComplete)queryStr.append("                      AND C.DW_ACTIONSTART IS NULL                                                    ");
			if(!isAll)queryStr.append("              AND ((C.DW_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.DW_ACTIONSTART is not null and to_date(C.DW_PLANSTART,'yyyy-mm-dd') < to_date(C.DW_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[9] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                   ");
			queryStr.append("                       AND DWGTYPE = 'V' AND C.DW_PLANFINISH IS NOT NULL                                     ");
			queryStr.append("                       AND C.DW_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.DW_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.DW_ACTIONFINISH IS NULL                                                 ");
			if(!isAll)queryStr.append("              AND ((C.DW_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.DW_ACTIONFINISH is not null and to_date(C.DW_PLANFINISH,'yyyy-mm-dd') < to_date(C.DW_ACTIONFINISH,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[10] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                  ");
			queryStr.append("                       AND DWGTYPE = 'V' AND C.OW_PLANSTART IS NOT NULL                                      ");
			queryStr.append("                       AND C.OW_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.OW_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.OW_ACTIONSTART IS NULL                                                  ");
			if(!isAll)queryStr.append("              AND ((C.OW_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.OW_ACTIONSTART is not null and to_date(C.OW_PLANSTART,'yyyy-mm-dd') < to_date(C.OW_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[11] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                  ");
			queryStr.append("                       AND DWGTYPE = 'V' AND C.OW_PLANFINISH IS NOT NULL                                     ");
			queryStr.append("                       AND C.OW_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.OW_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.OW_ACTIONFINISH IS NULL                                                         ");
			if(!isAll)queryStr.append("              AND ((C.OW_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.OW_ACTIONFINISH is not null and to_date(C.OW_PLANFINISH,'yyyy-mm-dd') < to_date(C.OW_ACTIONFINISH,'yyyy-mm-dd')))   	");
            queryStr.append("                       AND C.OW_PLANSTART <> C.OW_PLANFINISH THEN 1                                          ");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[12] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                  ");
			queryStr.append("                       AND DWGTYPE = 'V' AND C.CL_PLANSTART IS NOT NULL                                      ");
			queryStr.append("                       AND C.CL_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.CL_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.CL_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.CL_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.CL_ACTIONSTART is not null and to_date(C.CL_PLANSTART,'yyyy-mm-dd') < to_date(C.CL_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[13] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                  ");
			queryStr.append("                       AND DWGTYPE = 'V' AND C.CL_PLANFINISH IS NOT NULL                                     ");
			queryStr.append("                       AND C.CL_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.CL_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.CL_ACTIONFINISH IS NULL                                                         ");
			if(!isAll)queryStr.append("              AND ((C.CL_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.CL_ACTIONFINISH is not null and to_date(C.CL_PLANFINISH,'yyyy-mm-dd') < to_date(C.CL_ACTIONFINISH,'yyyy-mm-dd')))   	");
            queryStr.append("                       AND C.CL_PLANSTART <> C.CL_PLANFINISH THEN 1                                          ");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[14] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                  ");
			queryStr.append("             AND DWGTYPE = 'V' AND C.RF_PLANSTART IS NOT NULL                                                ");
			queryStr.append("             AND C.RF_PLANSTART <= '" + dateSelected_to + "'                                                    ");
			if(existF)queryStr.append("             AND C.RF_PLANSTART >= '" + dateSelected_from + "'                                                    ");
			if(!isComplete)queryStr.append("             AND C.RF_ACTIONSTART IS NULL                                                             ");
			if(!isAll)queryStr.append("              AND ((C.RF_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.RF_ACTIONSTART is not null and to_date(C.RF_PLANSTART,'yyyy-mm-dd') < to_date(C.RF_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[15] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'B'                  ");
			queryStr.append("                  AND DWGTYPE = 'V' AND C.WK_PLANSTART IS NOT NULL                                           ");
			queryStr.append("                  AND C.WK_PLANSTART <= '" + dateSelected_to + "'                                               ");
			if(existF)queryStr.append("                  AND C.WK_PLANSTART >= '" + dateSelected_from + "'                                               ");
			if(!isComplete)queryStr.append("                  AND C.WK_ACTIONSTART IS NULL                                                        ");
			if(!isAll)queryStr.append("              AND ((C.WK_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.WK_ACTIONSTART is not null and to_date(C.WK_PLANSTART,'yyyy-mm-dd') < to_date(C.WK_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("                                                                                                             ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("       0 < (CASE WHEN NVL('" + dateConditions[16] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                   ");
			queryStr.append("                      AND C.DW_PLANSTART IS NOT NULL                                                         ");
			queryStr.append("                      AND C.DW_PLANSTART <= '" + dateSelected_to + "'                                           ");
			if(existF)queryStr.append("                      AND C.DW_PLANSTART >= '" + dateSelected_from + "'                                           ");
			if(!isComplete)queryStr.append("                      AND C.DW_ACTIONSTART IS NULL                                                    ");
			if(!isAll)queryStr.append("              AND ((C.DW_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.DW_ACTIONSTART is not null and to_date(C.DW_PLANSTART,'yyyy-mm-dd') < to_date(C.DW_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[17] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.DW_PLANFINISH IS NOT NULL                                                       ");
			queryStr.append("                       AND C.DW_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.DW_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.DW_ACTIONFINISH IS NULL                                                  ");
			if(!isAll)queryStr.append("              AND ((C.DW_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.DW_ACTIONFINISH is not null and to_date(C.DW_PLANFINISH,'yyyy-mm-dd') < to_date(C.DW_ACTIONFINISH,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[18] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.OW_PLANSTART IS NOT NULL                                                        ");
			queryStr.append("                       AND C.OW_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.OW_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.OW_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.OW_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.OW_ACTIONSTART is not null and to_date(C.OW_PLANSTART,'yyyy-mm-dd') < to_date(C.OW_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[19] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.OW_PLANFINISH IS NOT NULL                                                       ");
			queryStr.append("                       AND C.OW_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.OW_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.OW_ACTIONFINISH IS NULL                                                         ");
			if(!isAll)queryStr.append("              AND ((C.OW_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.OW_ACTIONFINISH is not null and to_date(C.OW_PLANFINISH,'yyyy-mm-dd') < to_date(C.OW_ACTIONFINISH,'yyyy-mm-dd')))   	");
            queryStr.append("                       AND C.OW_PLANSTART <> C.OW_PLANFINISH THEN 1                                          ");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[20] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.CL_PLANSTART IS NOT NULL                                                        ");
			queryStr.append("                       AND C.CL_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.CL_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.CL_ACTIONSTART IS NULL                                                  ");
			if(!isAll)queryStr.append("              AND ((C.CL_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.CL_ACTIONSTART is not null and to_date(C.CL_PLANSTART,'yyyy-mm-dd') < to_date(C.CL_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[21] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.CL_PLANFINISH IS NOT NULL                                                       ");
			queryStr.append("                       AND C.CL_PLANFINISH <= '" + dateSelected_to + "'                                         ");
			if(existF)queryStr.append("                       AND C.CL_PLANFINISH >= '" + dateSelected_from + "'                                         ");
			if(!isComplete)queryStr.append("                       AND C.CL_ACTIONFINISH IS NULL                                                         ");
			if(!isAll)queryStr.append("              AND ((C.CL_ACTIONFINISH is null)                          					");
			if(!isAll)queryStr.append("              		or (C.CL_ACTIONFINISH is not null and to_date(C.CL_PLANFINISH,'yyyy-mm-dd') < to_date(C.CL_ACTIONFINISH,'yyyy-mm-dd')))   	");
            queryStr.append("                       AND C.CL_ACTIONSTART <> C.CL_ACTIONSTART THEN 1                                          ");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[22] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.RF_PLANSTART IS NOT NULL                                                        ");
			queryStr.append("                       AND C.RF_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.RF_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.RF_ACTIONSTART IS NULL                                                   ");
			if(!isAll)queryStr.append("              AND ((C.RF_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.RF_ACTIONSTART is not null and to_date(C.RF_PLANSTART,'yyyy-mm-dd') < to_date(C.RF_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       OR                                                                                                    ");
			queryStr.append("        0 < (CASE WHEN NVL('" + dateConditions[23] + "', 'N') = 'Y' AND C.DWGCATEGORY = 'P'                  ");
			queryStr.append("                       AND C.WK_PLANSTART IS NOT NULL                                                        ");
			queryStr.append("                       AND C.WK_PLANSTART <= '" + dateSelected_to + "'                                          ");
			if(existF)queryStr.append("                       AND C.WK_PLANSTART >= '" + dateSelected_from + "'                                          ");
			if(!isComplete)queryStr.append("                       AND C.WK_ACTIONSTART IS NULL                                                ");
			if(!isAll)queryStr.append("              AND ((C.WK_ACTIONSTART is null)                          					");
			if(!isAll)queryStr.append("              		or (C.WK_ACTIONSTART is not null and to_date(C.WK_PLANSTART,'yyyy-mm-dd') < to_date(C.WK_ACTIONSTART,'yyyy-mm-dd')))   	");
			queryStr.append("                       THEN 1                                                   	");
			queryStr.append("                  ELSE 0                                                                                     ");
			queryStr.append("              END)                                                                                           ");
			queryStr.append("       )                                                                                                     ");
			queryStr.append(" ORDER BY C.PROJECTNO, F_GET_DWGDEPT_ORDER('',C.DWGDEPTCODE)                                                 ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());
           

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("SABUN", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("DEPTNAME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("DEPTCODE", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("DWGCODE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("OUTSOURCINGYN", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("OUTSOURCING1", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("OUTSOURCING2", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("DWGTITLE", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("DW_PLAN_S", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("DW_PLAN_F", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("DW_ACT_S", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("DW_ACT_F", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("OW_PLAN_S", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("OW_PLAN_F", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("OW_ACT_S", rset.getString(16) == null ? "" : rset.getString(16));
				resultMap.put("OW_ACT_F", rset.getString(17) == null ? "" : rset.getString(17));
				resultMap.put("CL_PLAN_S", rset.getString(18) == null ? "" : rset.getString(18));
				resultMap.put("CL_PLAN_F", rset.getString(19) == null ? "" : rset.getString(19));
				resultMap.put("CL_ACT_S", rset.getString(20) == null ? "" : rset.getString(20));
				resultMap.put("CL_ACT_F", rset.getString(21) == null ? "" : rset.getString(21));
				resultMap.put("RF_PLAN_S", rset.getString(22) == null ? "" : rset.getString(22));
				resultMap.put("RF_ACT_S", rset.getString(23) == null ? "" : rset.getString(23));
				resultMap.put("WK_PLAN_S", rset.getString(24) == null ? "" : rset.getString(24));
				resultMap.put("WK_ACT_S", rset.getString(25) == null ? "" : rset.getString(25));
				resultMap.put("DWGZONE", rset.getString(26) == null ? "" : rset.getString(26));
				resultMap.put("DELAYREASON", rset.getString(27) == null ? "" : rset.getString(27));
				resultMap.put("RESOLVEPLANDATE", rset.getString(28) == null ? "" : rset.getString(28));
				resultMap.put("REQUIREDDATE", rset.getString(29) == null ? "" : rset.getString(29));
				resultMap.put("DELAYREASON_DESC", rset.getString(30) == null ? "" : rset.getString(30));
				resultMap.put("NAME", rset.getString(31) == null ? "" : rset.getString(31));
				resultMap.put("DW_PLAN_S_O", rset.getString(32));
				resultMap.put("DW_PLAN_F_O", rset.getString(33));
				resultMap.put("OW_PLAN_S_O", rset.getString(34));
				resultMap.put("OW_PLAN_F_O", rset.getString(35));
				resultMap.put("CL_PLAN_S_O", rset.getString(36));
				resultMap.put("CL_PLAN_F_O", rset.getString(37));
				resultMap.put("RF_PLAN_S_O", rset.getString(38));
				resultMap.put("WK_PLAN_S_O", rset.getString(39));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}
	
	// getDesignProgressInfo() : 도면 하나에 대한 공정정보 조회
	private static synchronized String getDesignProgressInfo(String projectNo, String drawingNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (StringUtil.isNullString(drawingNo)) throw new Exception("Drawing No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S,  										");
			queryStr.append("       TO_CHAR(DW.PLANFINISHDATE, 'YYYY-MM-DD') AS DW_PLAN_F, 										");
			queryStr.append("       TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S, 										");
			queryStr.append("       TO_CHAR(DW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS DW_ACT_F,										");
			queryStr.append("       TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S,  										");
			queryStr.append("       TO_CHAR(OW.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F, 										");
			queryStr.append("       TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S, 										");
			queryStr.append("       TO_CHAR(OW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F,										");
			queryStr.append("       TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S,  										");
			queryStr.append("       TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F, 										");
			queryStr.append("       TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S, 										");
			queryStr.append("       TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F,										");
			queryStr.append("       TO_CHAR(RF.PLANSTARTDATE, 'YYYY-MM-DD') AS RF_PLAN_S,  										");
			queryStr.append("       TO_CHAR(RF.ACTUALSTARTDATE, 'YYYY-MM-DD') AS RF_ACT_S, 										");
			queryStr.append("       TO_CHAR(WK.PLANSTARTDATE, 'YYYY-MM-DD') AS WK_PLAN_S,  										");
			queryStr.append("       TO_CHAR(WK.ACTUALSTARTDATE, 'YYYY-MM-DD') AS WK_ACT_S,										"); 
			//queryStr.append("       (NVL(DW.PLANSTDMH, 0) + NVL(OW.PLANSTDMH, 0) + NVL(CL.PLANSTDMH, 0)                         ");
			//queryStr.append("         + NVL(RF.PLANSTDMH, 0) + NVL(WK.PLANSTDMH, 0)) AS PLANMH,                                 ");
			//queryStr.append("       (NVL(DW.ACTUALSTDMH, 0) + NVL(OW.ACTUALSTDMH, 0) + NVL(CL.ACTUALSTDMH, 0)                   ");
			//queryStr.append("         + NVL(RF.ACTUALSTDMH, 0) + NVL(WK.ACTUALSTDMH, 0)) AS ACTUALMH                            ");
			queryStr.append("       (NVL(DW.PLANSTDMH, 0)) AS PLANMH,                                                           ");
			queryStr.append("       (NVL(DW.ACTUALSTDMH, 0)) AS ACTUALMH                                                        ");
			queryStr.append("  FROM PLM_ACTIVITY DW,                                                                            ");
			queryStr.append("       (SELECT A.PROJECTNO, A.ACTIVITYCODE, A.PLANSTARTDATE, A.PLANFINISHDATE, A.ACTUALSTARTDATE,  ");
			queryStr.append("               A.ACTUALFINISHDATE, A.PLANSTDMH, A.ACTUALSTDMH                                      ");
			queryStr.append("          FROM PLM_ACTIVITY A                     													");                                                                    
			queryStr.append("         WHERE A.WORKTYPE = 'OW'                                                                   ");
			queryStr.append("       ) OW,                                                                                       ");
			queryStr.append("       (SELECT B.PROJECTNO, B.ACTIVITYCODE, B.PLANSTARTDATE, B.PLANFINISHDATE, B.ACTUALSTARTDATE,  ");
			queryStr.append("               B.ACTUALFINISHDATE, B.PLANSTDMH, B.ACTUALSTDMH                                      ");
			queryStr.append("          FROM PLM_ACTIVITY B                                                                      ");
			queryStr.append("         WHERE B.WORKTYPE = 'CL'                                                                   ");
			queryStr.append("       ) CL,                                                                                       ");
			queryStr.append("       (SELECT C.PROJECTNO, C.ACTIVITYCODE, C.PLANSTARTDATE, C.PLANFINISHDATE, C.ACTUALSTARTDATE,  ");
			queryStr.append("               C.ACTUALFINISHDATE, C.PLANSTDMH, C.ACTUALSTDMH                                      ");
			queryStr.append("          FROM PLM_ACTIVITY C                                                                      ");
			queryStr.append("         WHERE C.WORKTYPE = 'RF'                                                                   ");
			queryStr.append("       ) RF,																						");			
			queryStr.append("       (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.PLANFINISHDATE, D.ACTUALSTARTDATE,  ");
			queryStr.append("               D.ACTUALFINISHDATE, D.PLANSTDMH, D.ACTUALSTDMH                                      ");
			queryStr.append("          FROM PLM_ACTIVITY D                                                                      ");
			queryStr.append("         WHERE D.WORKTYPE = 'WK'                                                                   ");
			queryStr.append("       ) WK                                                                                        ");
			queryStr.append(" WHERE DW.PROJECTNO = '" + projectNo + "'                                                          ");
			queryStr.append("   AND DW.PROJECTNO = OW.PROJECTNO(+)                                                              ");
			queryStr.append("   AND DW.PROJECTNO = CL.PROJECTNO(+)                                                              ");
			queryStr.append("   AND DW.PROJECTNO = RF.PROJECTNO(+)                                                              ");
			queryStr.append("   AND DW.PROJECTNO = WK.PROJECTNO(+)                                                              ");
			queryStr.append("   AND DW.WORKTYPE = 'DW'																			");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = '" + drawingNo + "'											");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(OW.ACTIVITYCODE(+), 1, 8)                            ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(CL.ACTIVITYCODE(+), 1, 8)                            ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(RF.ACTIVITYCODE(+), 1, 8)                            ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8)							");
			// * RF, WK의 경우 통상 Start-Finish가 동일하여 하나만 표시한다
			//queryStr.append("       TO_CHAR(RF.PLANFINISHDATE, 'YYYY-MM-DD') AS RF_PLAN_F, 									"); 
			//queryStr.append("       TO_CHAR(RF.ACTUALFINISHDATE, 'YYYY-MM-DD') AS RF_ACT_F,									");
			//queryStr.append("       TO_CHAR(WK.PLANFINISHDATE, 'YYYY-MM-DD') AS WK_PLAN_F, 									");
			//queryStr.append("       TO_CHAR(WK.ACTUALFINISHDATE, 'YYYY-MM-DD') AS WK_ACT_F									");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) {
				resultStr += rset.getString(1) == null ? "," : rset.getString(1) + ",";
				resultStr += rset.getString(2) == null ? "," : rset.getString(2) + ",";
				resultStr += rset.getString(3) == null ? "," : rset.getString(3) + ",";
				resultStr += rset.getString(4) == null ? "," : rset.getString(4) + ",";
				resultStr += rset.getString(5) == null ? "," : rset.getString(5) + ",";
				resultStr += rset.getString(6) == null ? "," : rset.getString(6) + ",";
				resultStr += rset.getString(7) == null ? "," : rset.getString(7) + ",";
				resultStr += rset.getString(8) == null ? "," : rset.getString(8) + ",";
				resultStr += rset.getString(9) == null ? "," : rset.getString(9) + ",";
				resultStr += rset.getString(10) == null ? "," : rset.getString(10) + ",";
				resultStr += rset.getString(11) == null ? "," : rset.getString(11) + ",";
				resultStr += rset.getString(12) == null ? "," : rset.getString(12) + ",";
				resultStr += rset.getString(13) == null ? "," : rset.getString(13) + ",";
				resultStr += rset.getString(14) == null ? "," : rset.getString(14) + ",";
				resultStr += rset.getString(15) == null ? "," : rset.getString(15) + ",";
				resultStr += rset.getString(16) == null ? "," : rset.getString(16) + ",";
				resultStr += rset.getString(17) == null ? "," : rset.getString(17) + ",";
				resultStr += rset.getString(18) == null ? "," : rset.getString(18) + ",";
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getDrawingWorkStartDate() : 도면의 출도일자 쿼리
	private static synchronized String getDrawingWorkStartDate(String projectNo, String drawingNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (StringUtil.isNullString(drawingNo)) throw new Exception("Drawing No. is null");

        if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT TO_CHAR(A.ACTUALSTARTDATE, 'YYYY-MM-DD') AS WK_PLAN_S ");
			queryStr.append("  FROM PLM_ACTIVITY A                                        ");
			queryStr.append(" WHERE A.WORKTYPE = 'WK'                                     ");
			queryStr.append("   AND SUBSTR(A.ACTIVITYCODE, 1, 8) = '" + drawingNo + "'    ");
			queryStr.append("   AND A.PROJECTNO = '" + projectNo + "'                     ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) resultStr = rset.getString(1) == null ? "" : rset.getString(1);
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// saveDPProgress() : 공정 실제시수 입력사항 저장
	private static synchronized void saveDPProgress(String projectNo, String inputDates, String inputPersons, String inputOutsidePersons, String loginID) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No is null");
		if (StringUtil.isNullString(inputDates) && StringUtil.isNullString(inputPersons) && StringUtil.isNullString(inputOutsidePersons)) throw new Exception("No item to save");
		if (StringUtil.isNullString(loginID)) loginID = "";

		ArrayList inputDateList = FrameworkUtil.split(inputDates, ",");
		ArrayList inputPersonList = FrameworkUtil.split(inputPersons, ",");
		ArrayList inputOutsidePersonsList = FrameworkUtil.split(inputOutsidePersons, ",");
		
		java.sql.Connection conn = null;
		java.sql.PreparedStatement startPPStmt = null;
		java.sql.PreparedStatement finishPPStmt = null;
		java.sql.PreparedStatement personPPStmt = null;
		java.sql.PreparedStatement outSidePersonPPStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr1 = "UPDATE PLM_ACTIVITY                                                         " + 
				                      "    SET ACTUALSTARTDATE = TO_DATE(?, 'YYYY-MM-DD'),                          " + 
                                      "        ATTRIBUTE4 = '', UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'  " + 
					                  "  WHERE PROJECTNO = '" + projectNo + "' AND ACTIVITYCODE = ?                 ";

				String execQueryStr2 = "UPDATE PLM_ACTIVITY                                                         " + 
				                      "    SET ACTUALFINISHDATE = TO_DATE(?, 'YYYY-MM-DD'),                         " + 
                                      "        ATTRIBUTE5 = '', UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'  " + 
					                  "  WHERE PROJECTNO = '" + projectNo + "' AND ACTIVITYCODE = ?                 ";

				String execQueryStr3 = "UPDATE PLM_ACTIVITY                                                         " + 
				                      "    SET SABUN = ?, UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'        " + 
					                  "  WHERE PROJECTNO = '" + projectNo + "' AND ACTIVITYCODE like ? || '%'       ";

				String execQueryStr4 = "UPDATE PLM_ACTIVITY                                                         " + 
				                      "    SET SUB_SABUN = ?, UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'    " + 
					                  "  WHERE PROJECTNO = '" + projectNo + "' AND ACTIVITYCODE like ? || '%'       ";

				startPPStmt = conn.prepareStatement(execQueryStr1); 
				finishPPStmt = conn.prepareStatement(execQueryStr2); 
				personPPStmt = conn.prepareStatement(execQueryStr3); 
				outSidePersonPPStmt = conn.prepareStatement(execQueryStr4); 				

				// update Start & Finish Date
				for (int i = 0; i < inputDateList.size(); i++) {
					String strs = (String)inputDateList.get(i);
					ArrayList params = FrameworkUtil.split(strs, "|");

					String activityCode = (String)params.get(0);
					String startFinishCode = (String)params.get(1);
					String dateStr = (String)params.get(2);

					if (startFinishCode.equals("S") || startFinishCode.equals("A")) {
						startPPStmt.setString(1, dateStr);
						startPPStmt.setString(2, activityCode);
						startPPStmt.executeUpdate();
					}
					if (startFinishCode.equals("F") || startFinishCode.equals("A")) {
						finishPPStmt.setString(1, dateStr);
						finishPPStmt.setString(2, activityCode);
						finishPPStmt.executeUpdate();
					}
				}
				// update 담당자
				for (int i = 0; i < inputPersonList.size(); i++) {
					String strs = (String)inputPersonList.get(i);
					ArrayList params = FrameworkUtil.split(strs, "|");

					String activityCode = (String)params.get(0);
					String personID = (String)params.get(1);
                    activityCode = activityCode.substring(0, activityCode.length() - 2);

					personPPStmt.setString(1, personID);
					personPPStmt.setString(2, activityCode);
					personPPStmt.executeUpdate();
				}

				// update 2nd 담당자
				for (int i = 0; i < inputOutsidePersonsList.size(); i++) {
					String strs = (String)inputOutsidePersonsList.get(i);
					ArrayList params = FrameworkUtil.split(strs, "|");

					String activityCode = (String)params.get(0);
					String personID = (String)params.get(1);
                    activityCode = activityCode.substring(0, activityCode.length() - 2);

					outSidePersonPPStmt.setString(1, personID);
					outSidePersonPPStmt.setString(2, activityCode);
					outSidePersonPPStmt.executeUpdate();
				}
				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (startPPStmt != null) startPPStmt.close();
			if (finishPPStmt != null) finishPPStmt.close();
			if (personPPStmt != null) personPPStmt.close();
			if (outSidePersonPPStmt != null) outSidePersonPPStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// saveDPProgressDev() : 공정 지연 사유 등 입력사항 저장
	private static synchronized void saveDPProgressDev(String inputDataValues, String descChangedValues, String inputDates , String loginID) 
	throws Exception
	{
		if (StringUtil.isNullString(inputDataValues) && StringUtil.isNullString(descChangedValues) && StringUtil.isNullString(inputDates)) 
			throw new Exception("No item to save");
		if (StringUtil.isNullString(loginID)) loginID = "";

		ArrayList inputDataList = FrameworkUtil.split(inputDataValues, ",");
		ArrayList descChangedList = FrameworkUtil.split(descChangedValues, ",");
		ArrayList inputDateList = FrameworkUtil.split(inputDates, ",");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement delayResaonPPStmt = null;
		java.sql.PreparedStatement planDatePPStmt = null;
		java.sql.PreparedStatement reqDatePPStmt = null;
		java.sql.PreparedStatement readonDescPPStmt = null;
		java.sql.PreparedStatement startPPStmt = null;
		java.sql.PreparedStatement finishPPStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				String execQueryStr1 = "MERGE INTO PLM_ACTIVITY_DEVIATION                                                        " +  
                                       "USING DUAL                                                                               " +  
                                       "   ON (PROJECTNO = ? AND DWGNO = ?)                                                      " +  
                                       " WHEN MATCHED THEN                                                                       " +  
                                       "      UPDATE SET DELAYREASON = ?, UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'     " +  
                                       " WHEN NOT MATCHED THEN                                                                   " + 
                                       "      INSERT (PROJECTNO, DWGNO, DELAYREASON, CREATEDATE, CREATEBY, UPDATEDATE, UPDATEBY) " + 
                                       "      VALUES (?, ?, ?, SYSDATE, '" + loginID + "', SYSDATE, '" + loginID + "')           ";

				String execQueryStr2 = "MERGE INTO PLM_ACTIVITY_DEVIATION                                                                                  " +  
                                       "USING DUAL                                                                                                         " +  
                                       "   ON (PROJECTNO = ? AND DWGNO = ?)                                                                                " +  
                                       " WHEN MATCHED THEN                                                                                                 " +  
                                       "      UPDATE SET RESOLVEPLANDATE = TO_DATE(?, 'YYYY-MM-DD'), UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'    " +  
                                       " WHEN NOT MATCHED THEN                                                                                             " + 
                                       "      INSERT (PROJECTNO, DWGNO, RESOLVEPLANDATE, CREATEDATE, CREATEBY, UPDATEDATE, UPDATEBY)                       " + 
                                       "      VALUES (?, ?, TO_DATE(?, 'YYYY-MM-DD'), SYSDATE, '" + loginID + "', SYSDATE, '" + loginID + "')              ";

				String execQueryStr3 = "MERGE INTO PLM_ACTIVITY_DEVIATION                                                                                  " +  
                                       "USING DUAL                                                                                                         " +  
                                       "   ON (PROJECTNO = ? AND DWGNO = ?)                                                                                " +  
                                       " WHEN MATCHED THEN                                                                                                 " +  
                                       "      UPDATE SET REQUIREDDATE = TO_DATE(?, 'YYYY-MM-DD'), UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'       " +  
                                       " WHEN NOT MATCHED THEN                                                                                             " + 
                                       "      INSERT (PROJECTNO, DWGNO, REQUIREDDATE, CREATEDATE, CREATEBY, UPDATEDATE, UPDATEBY)                          " + 
                                       "      VALUES (?, ?, TO_DATE(?, 'YYYY-MM-DD'), SYSDATE, '" + loginID + "', SYSDATE, '" + loginID + "')              ";

				String execQueryStr4 = "MERGE INTO PLM_ACTIVITY_DEVIATION                                                             " +  
                                       "USING DUAL                                                                                    " +  
                                       "   ON (PROJECTNO = ? AND DWGNO = ?)                                                           " +  
                                       " WHEN MATCHED THEN                                                                            " +  
                                       "      UPDATE SET DELAYREASON_DESC = ?, UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'     " +  
                                       " WHEN NOT MATCHED THEN                                                                        " + 
                                       "      INSERT (PROJECTNO, DWGNO, DELAYREASON_DESC, CREATEDATE, CREATEBY, UPDATEDATE, UPDATEBY) " + 
                                       "      VALUES (?, ?, ?, SYSDATE, '" + loginID + "', SYSDATE, '" + loginID + "')                ";

				String execQueryStr5 = "UPDATE PLM_ACTIVITY                                                                                    " + 
				                      "    SET ACTUALSTARTDATE = TO_DATE(?, 'YYYY-MM-DD'), UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'  " + 
					                  "  WHERE PROJECTNO = ? AND ACTIVITYCODE = ?                                                              ";

				String execQueryStr6 = "UPDATE PLM_ACTIVITY                                                                                    " + 
				                      "    SET ACTUALFINISHDATE = TO_DATE(?, 'YYYY-MM-DD'), UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "' " + 
					                  "  WHERE PROJECTNO = ? AND ACTIVITYCODE = ?                                                              ";

				delayResaonPPStmt = conn.prepareStatement(execQueryStr1); 
				planDatePPStmt = conn.prepareStatement(execQueryStr2); 
				reqDatePPStmt = conn.prepareStatement(execQueryStr3); 
				readonDescPPStmt = conn.prepareStatement(execQueryStr4); 
				startPPStmt = conn.prepareStatement(execQueryStr5); 
				finishPPStmt = conn.prepareStatement(execQueryStr6); 

				// 지연사유, 조치예정일, 현장필요시점 업데이트
				for (int i = 0; i < inputDataList.size(); i++) {
					String strs = (String)inputDataList.get(i);
					ArrayList params = FrameworkUtil.split(strs, "|");

					String projectNo = (String)params.get(0);
					String dwgCode = (String)params.get(1);
					String fieldKey = (String)params.get(2);
					String valueStr = (String)params.get(3);

					if (fieldKey.equals("F1")) { // 지연사유
						delayResaonPPStmt.setString(1, projectNo);
						delayResaonPPStmt.setString(2, dwgCode);
						delayResaonPPStmt.setString(3, valueStr);
						delayResaonPPStmt.setString(4, projectNo);
						delayResaonPPStmt.setString(5, dwgCode);
						delayResaonPPStmt.setString(6, valueStr);
						delayResaonPPStmt.executeUpdate();
					}
					else if (fieldKey.equals("F2")) { // 조치예정일
						planDatePPStmt.setString(1, projectNo);
						planDatePPStmt.setString(2, dwgCode);
						planDatePPStmt.setString(3, valueStr);
						planDatePPStmt.setString(4, projectNo);
						planDatePPStmt.setString(5, dwgCode);
						planDatePPStmt.setString(6, valueStr);
						planDatePPStmt.executeUpdate();
					}
					else if (fieldKey.equals("F3")) { // 현장필요시점
						reqDatePPStmt.setString(1, projectNo);
						reqDatePPStmt.setString(2, dwgCode);
						reqDatePPStmt.setString(3, valueStr);
						reqDatePPStmt.setString(4, projectNo);
						reqDatePPStmt.setString(5, dwgCode);
						reqDatePPStmt.setString(6, valueStr);
						reqDatePPStmt.executeUpdate();
					}
				}
				// 특기사항 업데이트
				for (int i = 0; i < descChangedList.size(); i++) {
					String strs = (String)descChangedList.get(i);
					ArrayList params = FrameworkUtil.split(strs, "|");

					String projectNo = (String)params.get(0);
					String dwgCode = (String)params.get(1);
					String valueStr = (String)params.get(2);

					readonDescPPStmt.setString(1, projectNo);
					readonDescPPStmt.setString(2, dwgCode);
					readonDescPPStmt.setString(3, valueStr);
					readonDescPPStmt.setString(4, projectNo);
					readonDescPPStmt.setString(5, dwgCode);
					readonDescPPStmt.setString(6, valueStr);
					readonDescPPStmt.executeUpdate();
				}

				// update Start & Finish Date
				for (int i = 0; i < inputDateList.size(); i++) {
					String strs = (String)inputDateList.get(i);
					ArrayList params = FrameworkUtil.split(strs, "|");

					String projectNo = (String)params.get(0);
					String activityCode = (String)params.get(1);
					String startFinishCode = (String)params.get(2);
					String dateStr = (String)params.get(3);

					if (startFinishCode.equals("S")) {
						startPPStmt.setString(1, dateStr);
						startPPStmt.setString(2, projectNo);
						startPPStmt.setString(3, activityCode);
						startPPStmt.executeUpdate();
					}
					else if (startFinishCode.equals("F")) {
						finishPPStmt.setString(1, dateStr);
						finishPPStmt.setString(2, projectNo);
						finishPPStmt.setString(3, activityCode);
						finishPPStmt.executeUpdate();
					}
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (delayResaonPPStmt != null) delayResaonPPStmt.close();
			if (planDatePPStmt != null) planDatePPStmt.close();
			if (reqDatePPStmt != null) reqDatePPStmt.close();
			if (readonDescPPStmt != null) readonDescPPStmt.close();
			if (startPPStmt != null) startPPStmt.close();
			if (finishPPStmt != null) finishPPStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getMHFactorCaseList() : 시수 적용율(FACTOR) CASE 목록을 쿼리
	private static synchronized ArrayList getMHFactorCaseList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("WITH ACTIVE_CASE_TBL AS                                                         ");
			queryStr.append("    (                                                                           ");
			queryStr.append("        SELECT VALUE AS ACTIVE_CASE                                             ");
			queryStr.append("          FROM PLM_CODE_TBL                                                     ");
			queryStr.append("         WHERE CATEGORY = 'MH_FACTOR'                                           ");
			queryStr.append("           AND KEY = 'ACTIVE_CASE'                                              ");
			queryStr.append("    )                                                                           ");
			queryStr.append("SELECT CASE_NO,                                                                 ");
			queryStr.append("       CASE WHEN CASE_NO = (SELECT ACTIVE_CASE FROM ACTIVE_CASE_TBL) THEN 'Y'   ");
			queryStr.append("            ELSE 'N'                                                            ");
			queryStr.append("       END                                                                      ");
			queryStr.append("       AS ACTIVE_CASE_YN                                                        ");
			queryStr.append("  FROM PLM_DESIGN_MH_FACTOR                                                     ");
			queryStr.append(" GROUP BY CASE_NO                                                               ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("CASE_NO", rset.getString(1));
				resultMap.put("ACTIVE_CASE_YN", rset.getString(2));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// getMHFactorCaseValue() : 시수 적용율(FACTOR) CASE 정의를 쿼리
	private static synchronized ArrayList getMHFactorCaseValue(String caseNo) throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT FACTOR_NO, CAREER_MONTH_FROM, CAREER_MONTH_TO, TO_CHAR(FACTOR_VALUE, '99990D9')  ");
			queryStr.append("  FROM PLM_DESIGN_MH_FACTOR                                                             ");
			queryStr.append(" WHERE CASE_NO = '" + caseNo + "'                                                       ");
			queryStr.append(" ORDER BY FACTOR_NO                                                                     ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("FACTOR_NO", rset.getString(1));
				resultMap.put("CAREER_MONTH_FROM", rset.getString(2));
				resultMap.put("CAREER_MONTH_TO", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("FACTOR_VALUE", rset.getString(4));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}
	
	// getMHFactorCaseAndValueList() : 시수 적용율(FACTOR) CASE 목록과 정의사항을 쿼리
	private static synchronized ArrayList getMHFactorCaseAndValueList() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("WITH ACTIVE_CASE_TBL AS                                                                          ");
			queryStr.append("    (                                                                                            ");
			queryStr.append("        SELECT VALUE AS ACTIVE_CASE                                                              ");
			queryStr.append("          FROM PLM_CODE_TBL                                                                      ");
			queryStr.append("         WHERE CATEGORY = 'MH_FACTOR'                                                            ");
			queryStr.append("           AND KEY = 'ACTIVE_CASE'                                                               ");
			queryStr.append("    )                                                                                            ");
			queryStr.append("SELECT CASE_NO, FACTOR_NO, CAREER_MONTH_FROM, CAREER_MONTH_TO, TO_CHAR(FACTOR_VALUE, '99990D9'), ");
			queryStr.append("       CASE WHEN CASE_NO = (SELECT ACTIVE_CASE FROM ACTIVE_CASE_TBL) THEN 'Y'                    ");
			queryStr.append("            ELSE 'N'                                                                             ");
			queryStr.append("       END                                                                                       ");
			queryStr.append("       AS ACTIVE_CASE_YN                                                                         ");
			queryStr.append("  FROM PLM_DESIGN_MH_FACTOR                                                                      ");
			queryStr.append(" ORDER BY CASE_NO, FACTOR_NO                                                                     ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("CASE_NO", rset.getString(1));
				resultMap.put("FACTOR_NO", rset.getString(2));
				resultMap.put("CAREER_MONTH_FROM", rset.getString(3));
				resultMap.put("CAREER_MONTH_TO", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("FACTOR_VALUE", rset.getString(5));
				resultMap.put("ACTIVE_CASE_YN", rset.getString(6));
				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// updateActiveMHFactorCase() : 시수 적용율 Default(Active) Case를 업데이트
	private static synchronized void updateActiveMHFactorCase(String factorCase, String loginID) throws Exception
	{
		if (StringUtil.isNullString(factorCase)) throw new Exception("No item to update!");
		if (StringUtil.isNullString(loginID)) loginID = "";

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer queryStr = new StringBuffer();

				queryStr.append("UPDATE PLM_CODE_TBL A                                                                         ");
				queryStr.append("SET A.VALUE = '" + factorCase + "', A.UPDATE_DATE = SYSDATE, A.UPDATE_BY = '" + loginID + "'  ");
				queryStr.append("WHERE A.CATEGORY = 'MH_FACTOR' AND A.KEY = 'ACTIVE_CASE'                                      ");

				stmt = conn.createStatement();
				stmt.executeUpdate(queryStr.toString());

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// addActiveMHFactorCase() : 시수 적용율 Case를 추가
	private static synchronized void addActiveMHFactorCase(ArrayList paramValues) throws Exception
	{
		ArrayList factorList1 = FrameworkUtil.split((String)paramValues.get(1), "|");
		ArrayList factorList2 = FrameworkUtil.split((String)paramValues.get(2), "|");
		ArrayList factorList3 = FrameworkUtil.split((String)paramValues.get(3), "|");

		String caseNo = (String)paramValues.get(0);
		String monthFrom1 = (String)factorList1.get(0);
		String monthTo1 = (String)factorList1.get(1);
		String factorValue1 = (String)factorList1.get(2);
		String monthFrom2 = factorList2.size() > 0 ? (String)factorList2.get(0) : "";
		String monthTo2 = factorList2.size() > 1 ? (String)factorList2.get(1) : "";
		String factorValue2 = factorList2.size() > 2 ? (String)factorList2.get(2) : "";
		String monthFrom3 = factorList3.size() > 0 ? (String)factorList3.get(0) : "";
		String monthTo3 = factorList3.size() > 1 ? (String)factorList3.get(1) : "";
		String factorValue3 = factorList3.size() > 2 ? (String)factorList3.get(2) : "";
		String defaultCaseCheck = (String)paramValues.get(4);
		String loginID = (String)paramValues.get(5);

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;
		java.sql.Statement stmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer queryStr = new StringBuffer();

				queryStr.append("INSERT INTO PLM_DESIGN_MH_FACTOR                                                                     ");
				queryStr.append("       VALUES('" + caseNo + "', ?, ?, ?, ?, SYSDATE, '" + loginID + "', SYSDATE, '" + loginID + "')  ");

				ppStmt = conn.prepareStatement(queryStr.toString()); 
				ppStmt.setInt(1, 1);
				ppStmt.setInt(2, Integer.parseInt(monthFrom1));
				if (!monthTo1.equals("")) ppStmt.setInt(3, Integer.parseInt(monthTo1));
				else ppStmt.setNull(3, java.sql.Types.INTEGER);
				ppStmt.setFloat(4, Float.parseFloat(factorValue1));
				ppStmt.executeUpdate();

				if (!monthFrom2.equals("") && !factorValue2.equals("")) {
					ppStmt.setInt(1, 2);
					ppStmt.setInt(2, Integer.parseInt(monthFrom2));
					if (!monthTo2.equals("")) ppStmt.setInt(3, Integer.parseInt(monthTo2));
					else ppStmt.setNull(3, java.sql.Types.INTEGER);
					ppStmt.setFloat(4, Float.parseFloat(factorValue2));
					ppStmt.executeUpdate();
				}
				if (!monthFrom3.equals("") && !factorValue3.equals("")) {
					ppStmt.setInt(1, 3);
					ppStmt.setInt(2, Integer.parseInt(monthFrom3));
					if (!monthTo3.equals("")) ppStmt.setInt(3, Integer.parseInt(monthTo3));
					else ppStmt.setNull(3, java.sql.Types.INTEGER);
					ppStmt.setFloat(4, Float.parseFloat(factorValue3));
					ppStmt.executeUpdate();
				}

				if (defaultCaseCheck.equalsIgnoreCase("true")) {
					StringBuffer queryStr2 = new StringBuffer();
					queryStr2.append("UPDATE PLM_CODE_TBL A                                                                     ");
					queryStr2.append("SET A.VALUE = '" + caseNo + "', A.UPDATE_DATE = SYSDATE, A.UPDATE_BY = '" + loginID + "'  ");
					queryStr2.append("WHERE A.CATEGORY = 'MH_FACTOR' AND A.KEY = 'ACTIVE_CASE'                                  ");

					stmt = conn.createStatement();
					stmt.executeUpdate(queryStr2.toString());
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// saveDepartmentChange() : 설계시수 입력사항 중 부서코드를 변경하는 케이스(설계시수 DATA 관리 화면에서 호출함)
	private static synchronized void saveDepartmentChange(String deptChanged, String loginID) throws Exception
	{
		if (StringUtil.isNullString(deptChanged)) throw new Exception("Department-Changed Data is null");
		if (StringUtil.isNullString(loginID)) loginID = "";

		ArrayList deptChangedList = FrameworkUtil.split(deptChanged, "‥");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer execQueryStr = new StringBuffer();

				execQueryStr.append("UPDATE PLM_DESIGN_MH                         ");
				execQueryStr.append("   SET DEPT_CODE = ?,                        ");
				execQueryStr.append("       UPDATE_DATE = SYSDATE,                ");
				execQueryStr.append("       UPDATE_BY = '" + loginID + "'         ");
				execQueryStr.append(" WHERE WORK_DAY = TO_DATE(?, 'YYYY-MM-DD')   ");
				execQueryStr.append("   AND EMPLOYEE_NO = ?                       ");
				execQueryStr.append("   AND PROJECT_NO = ?                        ");
				execQueryStr.append("   AND DWG_CODE = ?                          ");
				execQueryStr.append("   AND OP_CODE = ?                           ");
				execQueryStr.append("   AND START_TIME = ?                        ");

				ppStmt = conn.prepareStatement(execQueryStr.toString()); 

				for (int i = 0; i < deptChangedList.size(); i++) {
					String strs = (String)deptChangedList.get(i);

					ArrayList params = FrameworkUtil.split(strs, "|");

					ArrayList keyStrs = FrameworkUtil.split((String)params.get(0), "†");
					String valueStr = (String)params.get(1);

					ppStmt.setString(1, valueStr);
					ppStmt.setString(2, (String)keyStrs.get(0));
					ppStmt.setString(3, (String)keyStrs.get(1));
					ppStmt.setString(4, (String)keyStrs.get(2));
					ppStmt.setString(5, (String)keyStrs.get(3));
					ppStmt.setString(6, (String)keyStrs.get(4));
					ppStmt.setString(7, (String)keyStrs.get(5));
					ppStmt.executeUpdate();
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				e.printStackTrace();
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getBaseWorkTime() : 해당 기간의 당연투입시수를 쿼리
	private static String getBaseWorkTime(String dateFrom, String dateTo) throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT SUM(INSIDEWORKTIME) AS MAX_WTIME                                 ");
			queryStr.append("  FROM CCC_CALENDAR                                                     ");                           
			queryStr.append(" WHERE WORKINGDAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')     ");
			queryStr.append("                      AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')       ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) resultStr = rset.getString(1);
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// executeProjectDataERPIF() : 호선 별 설계시수를 ERP로 I/F
	private static void executeProjectDataERPIF(String dataList, String createDate, String target) throws Exception
	{
		if (StringUtil.isNullString(dataList)) throw new Exception("No item to I/F!");
		if (StringUtil.isNullString(target)) throw new Exception("Target is null!");
		ArrayList projectDataList = FrameworkUtil.split(dataList, "|");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;
		java.sql.PreparedStatement ppStmt2 = null;

		java.sql.PreparedStatement ppStmt3 = null;
		java.sql.PreparedStatement ppStmt4 = null;

		java.sql.ResultSet rset = null;
		java.sql.ResultSet rset2 = null;

		DecimalFormat df = new DecimalFormat("#.#");

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");
			
			try {
				// 기존 입력되던 원가팀 시수테이블 (기존입력)
				StringBuffer queryStr = new StringBuffer();
				queryStr.append("INSERT INTO STX_PA_CST_MASTER_INFO A                                           ");
				queryStr.append("            (COLLECTION_CODE, UNIT_SEGMENT, CURRENT_MONTH, QTY2, PROJECT_ID,   ");
				queryStr.append("             PROJECT_NAME_S, PROJECT_ID_T, CREATION_DATE)                      ");
				queryStr.append("VALUES ('PLM_J_01', '" + target + "', ?, ?, -1, ?, -1,                         ");
				queryStr.append("        TO_DATE(?, 'YYYY-MM-DD'))                                              ");

				StringBuffer queryStr2 = new StringBuffer();
				queryStr2.append("SELECT *                                                                      ");
				queryStr2.append("  FROM STX_PA_CST_MASTER_INFO                                                 ");
				queryStr2.append("WHERE 1 = 1                                                                   ");
				queryStr2.append("  AND COLLECTION_CODE = 'PLM_J_01'                                            ");
				queryStr2.append("  AND UNIT_SEGMENT = '" + target + "'                                         ");
				queryStr2.append("  AND PROJECT_NAME_S = ?                                                      ");
				queryStr2.append("  AND CURRENT_MONTH = ?                                                       ");


				// 추가 요청 원가팀 시수테이블
				StringBuffer queryStr3 = new StringBuffer();
				queryStr3.append("INSERT INTO STX_IFRS_PA_CST_MASTER_INFO A                                      ");
				queryStr3.append("            (COLLECTION_CODE, UNIT_SEGMENT, CURRENT_MONTH, QTY2, PROJECT_ID,   ");
				queryStr3.append("             PROJECT_NAME_S, PROJECT_ID_T, CREATION_DATE, SET_OF_BOOKS_ID)     ");  
				queryStr3.append("VALUES ('PLM_J_01', '" + target + "', ?, ?, -1, ?, -1,                         ");
				queryStr3.append("        TO_DATE(?, 'YYYY-MM-DD'), 2)                                           "); //SET_OF_BOOKS_ID : 2 고정

				StringBuffer queryStr4 = new StringBuffer();
				queryStr4.append("SELECT *                                                                      ");
				queryStr4.append("  FROM STX_IFRS_PA_CST_MASTER_INFO                                            ");
				queryStr4.append("WHERE 1 = 1                                                                   ");
				queryStr4.append("  AND COLLECTION_CODE = 'PLM_J_01'                                            ");
				queryStr4.append("  AND UNIT_SEGMENT = '" + target + "'                                         ");
				queryStr4.append("  AND PROJECT_NAME_S = ?                                                      ");
				queryStr4.append("  AND CURRENT_MONTH = ?                                                       ");


				ppStmt = conn.prepareStatement(queryStr.toString()); 
				ppStmt2 = conn.prepareStatement(queryStr2.toString()); 
				ppStmt3 = conn.prepareStatement(queryStr3.toString()); 
				ppStmt4 = conn.prepareStatement(queryStr4.toString()); 


				for (int i = 0; i < projectDataList.size(); i++) 
				{
					String str = (String)projectDataList.get(i);
					ArrayList strs = FrameworkUtil.split(str, ",");
					boolean skipFlag = false;

					// START : 기존 입력되던 원가팀 시수테이블
					ppStmt2.setString(1, (String)strs.get(1));
					ppStmt2.setString(2, (String)strs.get(0));
					rset = ppStmt2.executeQuery();
					if (rset.next()) {
						rset.close();
						skipFlag = true;
						//continue;
					}
					
					// 전송실적이 있을경우는 PASS
					if(!skipFlag)
					{
						float mhValue = Float.parseFloat((String)strs.get(2));
						String mhValueStr = df.format((Math.round(mhValue * 10) / 10.0));

						ppStmt.setString(1, (String)strs.get(0));
						ppStmt.setString(2, mhValueStr);
						ppStmt.setString(3, (String)strs.get(1));
						ppStmt.setString(4, createDate);
						ppStmt.executeUpdate();
					}
					skipFlag = false;
					// END : 기존 입력되던 원가팀 시수테이블


					// START : 추가 요청 원가팀 시수테이블
					ppStmt4.setString(1, (String)strs.get(1));
					ppStmt4.setString(2, (String)strs.get(0));
					rset2 = ppStmt4.executeQuery();
					if (rset2.next()) {
						rset2.close();
						skipFlag = true;
						//continue;
					}
					
					// 전송실적이 있을경우는 PASS
					if(!skipFlag)
					{
						float mhValue = Float.parseFloat((String)strs.get(2));
						String mhValueStr = df.format((Math.round(mhValue * 10) / 10.0));

						ppStmt3.setString(1, (String)strs.get(0));
						ppStmt3.setString(2, mhValueStr);
						ppStmt3.setString(3, (String)strs.get(1));
						ppStmt3.setString(4, createDate);
						ppStmt3.executeUpdate();
					}
					// END : 추가 요청 원가팀 시수테이블
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				e.printStackTrace();
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (rset != null) rset.close();
			if (rset2 != null) rset2.close();
			if (ppStmt != null) ppStmt.close();
			if (ppStmt2 != null) ppStmt2.close();
			if (ppStmt3 != null) ppStmt3.close();
			if (ppStmt4 != null) ppStmt4.close();
			DBConnect.closeConnection(conn);
		}
	}

	// getOPCodesForRevision(): 개정 관련 OP CODE 정보 쿼리
	private static ArrayList getOPCodesForRevision() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT KEY, VALUE             ");
			queryStr.append("  FROM PLM_CODE_TBL           ");
			queryStr.append(" WHERE CATEGORY = 'OP_CODE'   ");
			queryStr.append("   AND KEY LIKE '5%'          ");
			queryStr.append(" ORDER BY KEY                 ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("OP_KEY", rset.getString(1));
				resultMap.put("OP_VALUE", rset.getString(2));

				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

	// saveHardCopyInputs() : 도면 출도대장(Hard Copy) 입력을 디비에 저장
	private synchronized String saveHardCopyInputs(String loginID, String deployNoPrefix, String deptCode, String requestDate, 
	                                             String deployDate, String gubun, ArrayList paramList) throws Exception
	{
		if (StringUtil.isNullString(loginID)) throw new Exception("loginID is null");
		if (StringUtil.isNullString(deployNoPrefix)) throw new Exception("deployNoPrefix is null");
		if (StringUtil.isNullString(deptCode)) throw new Exception("deptCode is null");
		if (StringUtil.isNullString(requestDate)) throw new Exception("requestDate is null");
		if (StringUtil.isNullString(gubun)) throw new Exception("gubun is null");
		if (paramList.size() <= 0) throw new Exception("No items to save");

        java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.PreparedStatement ppStmt = null;
		java.sql.PreparedStatement ppStmt2 = null;
		java.sql.ResultSet rset = null;
		String deployNo = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				// 배포 NO. 채번 위한 Max. Serial 값 쿼리
				String queryStr = "SELECT NVL(TO_CHAR(TO_NUMBER(MAX(DEPLOY_NO_POSTFIX)) + 1, '00009'), '00001') AS MAXNO " + 
				                  "  FROM PLM_HARDCOPY_DWG                                                               " + 
					              " WHERE DEPLOY_NO_PREFIX = '" + deployNoPrefix + "'                                    ";

				stmt = conn.createStatement();
				rset = stmt.executeQuery(queryStr.toString()); 
				rset.next();
				String deployNoPostfix = rset.getString(1).trim();
				deployNo = deployNoPrefix + "-" + deployNoPostfix;

				// INSERT
				StringBuffer execQuery = new StringBuffer();
				execQuery.append("INSERT INTO PLM_HARDCOPY_DWG                                                                      ");
				execQuery.append("VALUES (                                                                                          ");
				execQuery.append("        '" + gubun + "', '" + deployNo + "', '" + deployNoPrefix + "', '" + deployNoPostfix + "', ");
				execQuery.append("        '" + deptCode + "', '" + loginID + "', TO_DATE('" + requestDate + "', 'YYYY-MM-DD'),      ");
				
				if (!StringUtil.isNullString(deployDate))
					execQuery.append("    TO_DATE('" + deployDate + "', 'YYYY-MM-DD'),                                              ");
				else 
					execQuery.append("    NULL,                                                                                     ");

				execQuery.append("        ?, ?, ?, ?, ?, ?, ?, ?, NULL, NULL, SYSDATE, '" + loginID + "', NULL, NULL, ?             ");
				execQuery.append("       )                                                                                          ");

                // DP 실적일자 업데이트
				StringBuffer execQuery2 = new StringBuffer();
				execQuery2.append("UPDATE PLM_ACTIVITY                      				                ");
				execQuery2.append("   SET ACTUALSTARTDATE = TRUNC(SYSDATE),                                 ");
				execQuery2.append("       ACTUALFINISHDATE = TRUNC(SYSDATE),                                ");
				execQuery2.append("       ATTRIBUTE4 = 'HARD COPY',                                         ");
				execQuery2.append("       ATTRIBUTE5 = 'HARD COPY'                                          ");
				execQuery2.append(" WHERE PROJECTNO = ?                                                     ");
				execQuery2.append("   AND ACTIVITYCODE = ?                                                  ");
				execQuery2.append("   AND ACTUALSTARTDATE IS NULL                                           ");

                // 실행
				if (paramList.size() > 0) 
                {
					ppStmt = conn.prepareStatement(execQuery.toString()); 
					ppStmt2 = conn.prepareStatement(execQuery2.toString()); 

					for (int i = 0; i < paramList.size(); i++) {
						Map map = (Map)paramList.get(i);

						ppStmt.setString(1, (String)map.get("project"));
						ppStmt.setString(2, (String)map.get("rev"));
						ppStmt.setString(3, (String)map.get("dwg"));
						ppStmt.setString(4, (String)map.get("dwgDesc"));
						ppStmt.setString(5, (String)map.get("reasonCode"));
						ppStmt.setString(6, (String)map.get("causeDept"));
						ppStmt.setString(7, (String)map.get("revTiming"));
						ppStmt.setString(8, (String)map.get("deployDesc"));
						ppStmt.setString(9, (String)map.get("ecoNo"));
						ppStmt.executeUpdate();

						String dwgno_query = (String)map.get("dwg");

                        if ("0".equals((String)map.get("rev"))) 
                        {
                            ppStmt2.setString(1, (String)map.get("project"));
                            ppStmt2.setString(2, (String)map.get("dwg") + "WK");
                            ppStmt2.executeUpdate();
                        }
                        else if ("A".equals((String)map.get("rev")) && dwgno_query.indexOf("V") != 0) 
                        {
                            ppStmt2.setString(1, (String)map.get("project"));
                            ppStmt2.setString(2, (String)map.get("dwg") + "RF");
                            ppStmt2.executeUpdate();
                        }
                    }
				}

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				e.printStackTrace();
				throw new Exception(e.toString());
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			if (ppStmt != null) ppStmt.close();
			if (ppStmt2 != null) ppStmt2.close();
			DBConnect.closeConnection(conn);
		}

		return deployNo;
	}

	/*
	// utility function : 임시
	private static synchronized String getEventCodeStr(String eventCode)
	{
		eventCode = StringUtil.setEmptyExt(eventCode);

		if (eventCode.equals("Y1")) return "Y1:착수일";
        else if (eventCode.equals("Y2")) return "Y2:완료일";
        else if (eventCode.equals("Y3")) return "Y3:선주승인발송";
        else if (eventCode.equals("Y4")) return "Y4:선주승인접수";
        else if (eventCode.equals("Y5")) return "Y5:선급승인발송";
        else if (eventCode.equals("Y6")) return "Y5:선급승인접수";
        else if (eventCode.equals("Y7")) return "Y7:참고용발송";
        else if (eventCode.equals("Y8")) return "Y8:작업용발송";
        else if (eventCode.equals("V1")) return "V1:P.O.S 발행";
        else if (eventCode.equals("V2")) return "V2:업체선정";
        else if (eventCode.equals("V3")) return "V3:구매오더";
        else if (eventCode.equals("V4")) return "V4:업체도면접수";
        else if (eventCode.equals("V5")) return "V5:선주승인발송";
        else if (eventCode.equals("V6")) return "V6:선주승인접수";
        else if (eventCode.equals("V7")) return "V7:업체출도일";
        else if (eventCode.equals("V8")) return "V8:작업용출도일";
		else return "";
	}
	*/

	// utility function : replaceAmpAll
	private static synchronized String replaceAmpAll(String str, String oldstr, String newstr) 
	{
		StringBuffer buf = new StringBuffer(); 
		int savedpos = 0; 

		while(true) { 
			int pos = str.indexOf(oldstr, savedpos); 
			if (pos != -1) { 
				buf.append(str.substring(savedpos, pos)); 
				buf.append(newstr); 
				savedpos = pos + oldstr.length(); 
				if(savedpos >= str.length()) break; 
			} 
			else break; 
		} 

		buf.append(str.substring(savedpos, str.length())); 
		return buf.toString(); 
	} 
	
	
	private String saveSelectedProjects(String loginID, ArrayList slProject) throws Exception
	{
	    java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		
		String sReturn = "저장 되었습니다.";
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("delete DP_PERSON_SELECT_PROJECT t where t.userid = '"+loginID+"' ");
			
			stmt = conn.createStatement();
			stmt.executeUpdate(sbSQL.toString());
			
			Iterator itrPrj = slProject.iterator();
			while(itrPrj.hasNext())
			{
				String sProject = (String)itrPrj.next();
				sbSQL = new StringBuffer();
				sbSQL.append("insert into DP_PERSON_SELECT_PROJECT values('"+loginID+"','"+sProject+"')");
				stmt.executeUpdate(sbSQL.toString());
			}
			DBConnect.commitJDBCTransaction(conn);
		} 
		catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			sReturn = e.toString();
		} finally {
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
	
		return sReturn;
	}
	
	private static ArrayList getSaveSelectedPrj(String loginID) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("select * from DP_PERSON_SELECT_PROJECT t where t.userid = '"+loginID+"' ");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}
	
	private static ArrayList getPLM_ACTIVITY_DEVIATIONDesc(String PROJECTNO,String DWGNO) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("select * from PLM_ACTIVITY_DEVIATION t where t.PROJECTNO = '"+PROJECTNO+"' and t.DWGNO = '"+DWGNO+"'");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}
	
	private String saveDELAYREASON_DESC(String projectNo,String dwgCode,String DELAYREASON_DESC,String loginID) throws Exception
	{
	    java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		
		String sReturn = "";
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("MERGE INTO PLM_ACTIVITY_DEVIATION\n");
			sbSQL.append("USING DUAL\n");
			sbSQL.append("   ON (PROJECTNO = ? AND DWGNO = ?)\n");
			sbSQL.append(" WHEN MATCHED THEN\n");
			sbSQL.append("      UPDATE SET DELAYREASON_DESC = ?, UPDATEDATE = SYSDATE, UPDATEBY = '" + loginID + "'     \n");
			sbSQL.append(" WHEN NOT MATCHED THEN                                                                        \n");
			sbSQL.append("      INSERT (PROJECTNO, DWGNO, DELAYREASON_DESC, CREATEDATE, CREATEBY, UPDATEDATE, UPDATEBY) \n");
			sbSQL.append("      VALUES (?, ?, ?, SYSDATE, '" + loginID + "', SYSDATE, '" + loginID + "')                \n");
			
			pstmt = conn.prepareStatement(sbSQL.toString()); 
			
			pstmt.setString(1, projectNo);
			pstmt.setString(2, dwgCode);
			pstmt.setString(3, DELAYREASON_DESC);
			pstmt.setString(4, projectNo);
			pstmt.setString(5, dwgCode);
			pstmt.setString(6, DELAYREASON_DESC);
			pstmt.executeUpdate();
			
			DBConnect.commitJDBCTransaction(conn);
		} 
		catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			sReturn = e.toString();
		} finally {
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		}
	
		return sReturn;
	}
	
	private static ArrayList getProjectChangableDateDWGList() throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT PRJ.PROJECTNO \n");
			sbSQL.append("       ,B.DWG_KIND B_KIND \n");
			sbSQL.append("       ,M.DWG_KIND M_KIND \n");
			sbSQL.append("       ,P.DWG_KIND P_KIND \n");
			sbSQL.append("   FROM (SELECT DISTINCT PSP.PROJECTNO FROM PLM_SEARCHABLE_PROJECT PSP) PRJ \n");
			sbSQL.append("       ,(SELECT * \n");
			sbSQL.append("           FROM PLM_DATE_CHANGE_ABLE_PROJECT \n");
			sbSQL.append("          WHERE DWG_KIND = '기본도') B \n");
			sbSQL.append("       ,(SELECT * \n");
			sbSQL.append("           FROM PLM_DATE_CHANGE_ABLE_PROJECT \n");
			sbSQL.append("          WHERE DWG_KIND = 'MAKER') M \n");
			sbSQL.append("       ,(SELECT * \n");
			sbSQL.append("           FROM PLM_DATE_CHANGE_ABLE_PROJECT \n");
			sbSQL.append("          WHERE DWG_KIND = '생설도') P \n");
			sbSQL.append("  WHERE PRJ.PROJECTNO = B.PROJECTNO(+) \n");
			sbSQL.append("    AND PRJ.PROJECTNO = M.PROJECTNO(+) \n");
			sbSQL.append("    AND PRJ.PROJECTNO = P.PROJECTNO(+) \n");
			sbSQL.append("  ORDER BY PRJ.PROJECTNO               \n");
			sbSQL.append("        \n");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}
	
	private static ArrayList getChangableDateDPList(String PROJECTNO,String ACTIVITYCODE,String startFinishCode) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT DWG.*                                                       \n");
			sbSQL.append("      ,NVL((SELECT 'Y'                                             \n");
			sbSQL.append("              FROM PLM_ACTIVITY_NO_DTS_DWG_LIST A                  \n");
			sbSQL.append("             WHERE DWG.DWGNO LIKE A.DWG_NO                         \n");
			sbSQL.append("               AND DWG.DWG_KIND = '생설도'), 'N') AS CHECKFLAG      \n");
			sbSQL.append("  FROM PLM_DATE_CHANGE_ABLE_PROJECT PDCAP                          \n");
			sbSQL.append("  	,PLM_DATE_CHANGE_ABLE_DWG_TYPE PDCADT                        \n");
			sbSQL.append("      ,(SELECT PA.PROJECTNO                                        \n");
			sbSQL.append("              ,PA.DWGDEPTCODE                                      \n");
			sbSQL.append("              ,case pa.dwgcategory                                 \n");
			sbSQL.append("                 WHEN 'P' THEN                                     \n");
			sbSQL.append("                  '생설도'                                          \n");
			sbSQL.append("                 ELSE                                              \n");
			sbSQL.append("                  CASE SUBSTR(PA.ACTIVITYCODE                      \n");
			sbSQL.append("                             ,0                                    \n");
			sbSQL.append("                             ,1)                                   \n");
			sbSQL.append("                 WHEN 'V' then                                     \n");
			sbSQL.append("                  'MAKER'                                          \n");
			sbSQL.append("                 ELSE                                              \n");
			sbSQL.append("                  '기본도'                                          \n");
			sbSQL.append("               END END DWG_KIND                                    \n");
			sbSQL.append("              ,SUBSTR(PA.ACTIVITYCODE,0,8) DWGNO                   \n");
			sbSQL.append("              ,SUBSTR(PA.ACTIVITYCODE,9,2) DWG_TYPE                \n");
			sbSQL.append("          FROM PLM_ACTIVITY PA                                     \n");
			sbSQL.append("         WHERE PA.PROJECTNO = '"+PROJECTNO+"'                      \n");
			sbSQL.append("           AND PA.ACTIVITYCODE = '"+ACTIVITYCODE+"') DWG           \n");
			sbSQL.append(" WHERE PDCAP.PROJECTNO = DWG.PROJECTNO                             \n");
			sbSQL.append("   AND DWG.DWG_KIND = PDCAP.DWG_KIND                               \n");
			sbSQL.append("   AND DWG.DWG_KIND = PDCADT.DWG_KIND                              \n");
			sbSQL.append("   AND DWG.DWGDEPTCODE IN('000017','000014','000024','000016','000023','000027','000029','000051','000141','000033','000036','000038','000039','000041','000139','000042','000043','000044','000045','000046','000047','000057','000002') \n");
			sbSQL.append("   AND DWG.DWG_TYPE || '"+startFinishCode+"' = PDCADT.DWG_TYPE       \n");
			sbSQL.append("   AND ((DWG.DWG_KIND = 'MAKER' AND DWG.DWGNO IN (SELECT PVDPC.DWG_CODE FROM PLM_VENDOR_DWG_PR_CATALOG PVDPC)) OR (DWG.DWG_KIND != 'MAKER'))\n");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}
	
	private static ArrayList getPLM_DATE_CHANGE_ABLE_DWG_TYPE() throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT T.DWG_KIND \n");
			sbSQL.append("      ,T.DWG_TYPE \n");
			sbSQL.append("  FROM PLM_DATE_CHANGE_ABLE_DWG_TYPE T \n");
			sbSQL.append(" ORDER BY T.DWG_KIND \n");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}
	
	private String setAbleChangeDPDateProject(String PROJECTNO,String DWG_KIND) throws Exception
	{
	    java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		String sReturn = "";
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
		
			StringBuffer selectSQL = new StringBuffer();
			selectSQL.append("SELECT * \n");
		    selectSQL.append("  FROM PLM_DATE_CHANGE_ABLE_PROJECT T \n");
		    selectSQL.append(" WHERE T.PROJECTNO = '"+PROJECTNO+"' \n");
		    selectSQL.append("   AND T.DWG_KIND = '"+DWG_KIND+"' \n");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(selectSQL.toString());
			ArrayList mlProject = getResultMapRows(rs);
			if(mlProject.size() < 1)
			{
				StringBuffer sbSQL = new StringBuffer();
			    sbSQL.append("INSERT INTO PLM_DATE_CHANGE_ABLE_PROJECT \n");
			    sbSQL.append("  (PROJECTNO \n");
			    sbSQL.append("  ,DWG_KIND) \n");
			    sbSQL.append("VALUES \n");
			    sbSQL.append("  (? \n");
			    sbSQL.append("  ,?) \n");
				pstmt = conn.prepareStatement(sbSQL.toString()); 
				pstmt.setString(1, PROJECTNO);
				pstmt.setString(2, DWG_KIND);
				pstmt.executeUpdate();
			}
			
			DBConnect.commitJDBCTransaction(conn);
		} 
		catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			sReturn = e.toString();
		} finally {
			if(rs != null)rs.close();
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		}
	
		return sReturn;
	}
	
	private String setDisableChangeDPDateProject(String PROJECTNO,String DWG_KIND) throws Exception
	{
	    java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		
		String sReturn = "";
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			
		    sbSQL.append("DELETE PLM_DATE_CHANGE_ABLE_PROJECT T \n");
		    sbSQL.append(" WHERE T.PROJECTNO = ? \n");
		    sbSQL.append("   AND T.DWG_KIND = ? \n");
			
			pstmt = conn.prepareStatement(sbSQL.toString()); 
			
			pstmt.setString(1, PROJECTNO);
			pstmt.setString(2, DWG_KIND);
			pstmt.executeUpdate();
			
			DBConnect.commitJDBCTransaction(conn);
		} 
		catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			sReturn = e.toString();
		} finally {
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		}
	
		return sReturn;
	}
	
	private ArrayList getArrayToList(String[] arrInput)
	{
		ArrayList slReturn = new ArrayList();
		if(arrInput == null)return slReturn;
		for(int index = 0 ;index<arrInput.length;index++)
		{
			slReturn.add(arrInput[index]);
		}
		return slReturn;
	}
	
	private String addPLM_DATE_CHANGE_ABLE_DWG_TYPE(String DWG_KIND,String DWG_TYPE) throws Exception
	{
	    java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sReturn = "";
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
		
				StringBuffer sbSQL = new StringBuffer();
			    sbSQL.append("INSERT INTO PLM_DATE_CHANGE_ABLE_DWG_TYPE \n");
			    sbSQL.append("  (DWG_KIND \n");
			    sbSQL.append("  ,DWG_TYPE) \n");
			    sbSQL.append("VALUES \n");
			    sbSQL.append("  (? \n");
			    sbSQL.append("  ,?) \n");
				pstmt = conn.prepareStatement(sbSQL.toString()); 
				pstmt.setString(1, DWG_KIND);
				pstmt.setString(2, DWG_TYPE);
				pstmt.executeUpdate();
				
			DBConnect.commitJDBCTransaction(conn);
		} 
		catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			sReturn = e.toString();
		} finally {
			if(rs != null)rs.close();
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		}
	
		return sReturn;
	}
	
	private String delPLM_DATE_CHANGE_ABLE_DWG_TYPE(String DWG_KIND,String DWG_TYPE) throws Exception
	{
	    java.sql.Connection conn = null;
		java.sql.PreparedStatement pstmt = null;
		
		String sReturn = "";
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			
		    sbSQL.append("DELETE PLM_DATE_CHANGE_ABLE_DWG_TYPE T \n");
		    sbSQL.append(" WHERE T.DWG_KIND = ? \n");
		    sbSQL.append("   AND T.DWG_TYPE = ? \n");
			
			pstmt = conn.prepareStatement(sbSQL.toString()); 
			
			pstmt.setString(1, DWG_KIND);
			pstmt.setString(2, DWG_TYPE);
			pstmt.executeUpdate();
			
			DBConnect.commitJDBCTransaction(conn);
		} 
		catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			sReturn = e.toString();
		} finally {
			if(pstmt != null)pstmt.close();
			if(conn != null)conn.close();
		}
	
		return sReturn;
	}

	// OP CODE 대분류 리스트 추출
	private static ArrayList getOpCodeListGRT(boolean isNonProject, boolean isMultiProject, boolean isRealProject) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT T.GRT_CODE                   \n");
			sbSQL.append("      ,T.GRT_DESC                   \n");
			sbSQL.append("  FROM PLM_DESIGN_MH_OP_GRT  T      \n");
			sbSQL.append(" WHERE 1=1                          \n");
			sbSQL.append("   AND USE_YN='Y'                   \n");

			if(isNonProject)
			{
				sbSQL.append("AND GRT_CODE IN ('C','D')       \n");
			} else if(isMultiProject)
			{
				sbSQL.append("AND GRT_CODE IN ('B')           \n");
			} else if(isRealProject)
			{
				sbSQL.append("AND GRT_CODE IN ('A','B')       \n");
			}
			sbSQL.append(" ORDER BY T.GRT_CODE                \n");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}

	// OP CODE 중분류 리스트 추출
	private static ArrayList getOpCodeListMID(boolean isNonProject, boolean isMultiProject, boolean isRealProject) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT T.GRT_CODE                   \n");
			sbSQL.append("      ,T.MID_CODE                   \n");
			sbSQL.append("      ,T.MID_DESC                   \n");
			sbSQL.append("  FROM PLM_DESIGN_MH_OP_MID  T      \n");
			sbSQL.append(" WHERE 1=1                          \n");
			sbSQL.append("   AND USE_YN='Y'                   \n");

			if(isNonProject)
			{
				sbSQL.append("AND GRT_CODE IN ('C','D')       \n");
			} else if(isMultiProject)
			{
				sbSQL.append("AND GRT_CODE IN ('B')           \n");
			} else if(isRealProject)
			{
				sbSQL.append("AND GRT_CODE IN ('A','B')       \n");
			}
			sbSQL.append(" ORDER BY T.GRT_CODE, T.MID_CODE    \n");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}

	// OP CODE 소분류 리스트 추출 
	private static ArrayList getOpCodeListSUB(boolean isNonProject, boolean isMultiProject, boolean isRealProject) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT (T.GRT_CODE || T.MID_CODE || T.SUB_CODE) AS OP_CODE   \n");
			sbSQL.append("      ,T.GRT_CODE                                            \n");
			sbSQL.append("      ,T.MID_CODE                                            \n");
			sbSQL.append("      ,T.SUB_CODE                                            \n");
			sbSQL.append("      ,T.SUB_DESC                                            \n");
			sbSQL.append("  FROM PLM_DESIGN_MH_OP_SUB  T                               \n");
			sbSQL.append(" WHERE 1=1                                                   \n");
			sbSQL.append("   AND USE_YN = 'Y'                                          \n");
			if(isNonProject)
			{
				sbSQL.append("AND GRT_CODE IN ('C','D')       \n");
			} else if(isMultiProject)
			{
				sbSQL.append("AND GRT_CODE IN ('B')           \n");
			} else if(isRealProject)
			{
				sbSQL.append("AND GRT_CODE IN ('A','B')       \n");
			}
			sbSQL.append(" ORDER BY T.GRT_CODE, T.MID_CODE, T.SUB_CODE                 \n");

			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbSQL.toString());
			mlReturn = getResultMapRows(rs);
		} 
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)rs.close();
			if(stmt != null)stmt.close();
			if(conn != null)conn.close();
		}
		return mlReturn;
	}


	// getShipType() : DPS에 정의된 선종 리스트 쿼리
	private static synchronized String getShipType() throws Exception
	{

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			String queryStr = "";
            queryStr += "SELECT A.C_CODE                     "; 
			queryStr += "  FROM CCC_CODE A                   "; 
			queryStr += " WHERE A.P_CODE = 'SHIPTYPE'        "; 
			queryStr += "   AND A.USE_FLAG = 'Y'             "; 
			queryStr += "  ORDER BY A.TAG                    "; 
    

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				if (!resultStr.equals("")) resultStr += "|";
				resultStr += rset.getString(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}
%>
