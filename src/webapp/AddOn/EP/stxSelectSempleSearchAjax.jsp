
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%>
<%@page import="java.util.*"%>
<%@page import="org.jdom.Document"%>
<%@page import="org.jdom.Element"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@page import="java.sql.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.util.StringUtil"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%! 
	public static ArrayList getEmployeeInfoList(String sUserName) throws Exception {
		ArrayList mlReturn = new ArrayList();
		if (StringUtil.isNullString(sUserName))
		{
			return mlReturn;
		}
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;
	
		try{
			conn = DBConnect.getDBConnection("PLM");// db접속
	
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT SCIU.EMP_NO           AS VALUE         \n");
			queryStr.append("      ,SCIU.USER_NAME        AS DISPLAY      \n");;
			queryStr.append("      ,DD.DWGDEPTCODE        AS DWG_DEPT_CODE  \n");
			queryStr.append("      ,DD.DEPTNM             AS DWG_DEPT_NAME  \n");
			queryStr.append("  FROM STX_COM_INSA_USER@"+STXPLMProperty.getPLMProperty("stxEngineeringCentralItemStringResource", "PLM.ERP.DBLINK.NAME")+" SCIU           \n");
			queryStr.append("      ,DCC_DEPTCODE@stxdp       DD             \n");
			queryStr.append(" WHERE SCIU.DEPT_CODE = DD.DEPTCODE            \n");
			queryStr.append("   AND SCIU.USER_NAME LIKE '" + sUserName + "%'     \n");
			System.out.println(queryStr.toString());
			stmt = conn.createStatement();
			rset = stmt.executeQuery(queryStr.toString());
			
			mlReturn = getResultMapRows(rset);
	
		} catch (Exception e) 
		{
			e.printStackTrace();
			throw e;
		}
		return mlReturn; 
	}

	private static ArrayList getDeptAddCustomDeptWithERPLog(String sCondition) throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;
	
		ArrayList resultArrayList = new ArrayList();
	
		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
	
			queryStr.append("SELECT A.DEPT_CODE AS VALUE,                                                                              ");
			queryStr.append("       A.DEPT_NAME AS DISPLAY                                                                              ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A                                                                             ");
			queryStr.append(" WHERE DEPT_CODE IN (                                                                                         ");
			queryStr.append("                        SELECT C.DEPTCODE                                                                     ");
			queryStr.append("                          FROM DCC_DEPTCODE C                                                                 ");
			queryStr.append("                         WHERE C.DWGDEPTCODE IN (SELECT DWG_DEPT_CODE                                           ");
			queryStr.append("                                                   FROM PLM_VENDOR_DWG_PR_INFO )                                 ");
			queryStr.append("                    )                                                                                         ");
			queryStr.append("   AND A.DEPT_NAME LIKE '" + sCondition + "%'     \n");
			queryStr.append(" ORDER BY DEPT_CODE                                                                                           ");
	
	        stmt = conn.createStatement();
	        rset = stmt.executeQuery(queryStr.toString());
	
	        resultArrayList = getResultMapRows(rset);
	        HashMap resultMap1 = new HashMap();
	        resultMap1.put("DEPT_CODE", "457400");
	        resultMap1.put("DEPT_NAME", "전장설계1-전장설계3P");
	        resultArrayList.add(resultMap1);
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
	
	private static ArrayList getEquipDept(String sCondition) throws Exception
	{
		Map mapParam = new HashMap();
		if(!StringUtil.isNullString(sCondition))
		{
			mapParam.put("USERID",sCondition);
		}
		ArrayList resultArrayList = SQLSourceUtil.executeSelect("PLM","EQUIP.selectEquipDept", mapParam);
		return resultArrayList;
	}
	
	private static ArrayList getST101TBLDrawing(String sCondition) throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;
	
		ArrayList resultArrayList = new ArrayList();
	
		try {
			conn = DBConnect.getDBConnection("TPI_TRIBON");
			StringBuffer queryStr = new StringBuffer();
	
			queryStr.append("select dwg_no AS VALUE ");
			queryStr.append("		,dwg_no AS DISPLAY  ");
			queryStr.append("  from ST101TBL ");
			queryStr.append(" where ship_no = '"+sCondition+"' ");
			queryStr.append("   and dwg_no is not null ");
			queryStr.append("   and maternal_code is not null ");
			queryStr.append("   and release_state is null ");
			queryStr.append("   and item_state is null ");
			queryStr.append(" group by dwg_no ");
			
			System.out.println(queryStr.toString());
			
	        stmt = conn.createStatement();
	        rset = stmt.executeQuery(queryStr.toString());
	
	        resultArrayList = getResultMapRows(rset);
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
	
	private static ArrayList getTPIProject(String sCondition) throws Exception
	{
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;
	
		ArrayList resultArrayList = new ArrayList();
	
		try {
			conn = DBConnect.getDBConnection("TPI_TRIBON");
			StringBuffer queryStr = new StringBuffer();
	
			queryStr.append("select ship_no AS VALUE ");
			queryStr.append("		,ship_no AS DISPLAY ");
			queryStr.append("  from ST101TBL ");
			queryStr.append(" where dwg_no is not null ");
			queryStr.append("   and maternal_code is not null ");
			queryStr.append("   and release_state is null ");
			queryStr.append("   and item_state is null ");
			queryStr.append(" group by ship_no ");
			System.out.println(queryStr.toString());
			
	        stmt = conn.createStatement();
	        rset = stmt.executeQuery(queryStr.toString());
	
	        resultArrayList = getResultMapRows(rset);
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
	
	private static ArrayList getProjectList( boolean openedOnly, String category) throws Exception
	{
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("SELECT \n");
			sbSQL.append("  A.PROJECTNO AS VALUE \n");
			sbSQL.append(", A.PROJECTNO AS DISPLAY \n");
		//	sbSQL.append("(SELECT B.DWGSERIESSERIALNO FROM LPM_NEWPROJECT B \n");
		//	sbSQL.append("WHERE B.CASENO='1' and B.PROJECTNO = A.PROJECTNO) AS S_NO \n");
			sbSQL.append("FROM PLM_SEARCHABLE_PROJECT A \n");
			sbSQL.append("WHERE 1 = 1 \n");
			sbSQL.append("AND A.CATEGORY = '" + category + "' \n");
			if (openedOnly)sbSQL.append("AND A.STATE <> 'CLOSED' \n");
			sbSQL.append("ORDER BY PROJECTNO   \n");
			
			System.out.println(sbSQL.toString());
			
			stmt = conn.createStatement();
            rset = stmt.executeQuery(sbSQL.toString());

            resultArrayList = getResultMapRows(rset);
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
	
	private static ArrayList getMasterProjectList() throws Exception
	{
		ArrayList mlReturn =new ArrayList();
		ArrayList mlMaster = SQLSourceUtil.executeSelect("PLM","PROJECT.selectMasterProject",null);
		Iterator itrMaster = mlMaster.iterator();
		while(itrMaster.hasNext())
		{
			Map mapMaster = (Map)itrMaster.next();
			String sProject = (String)mapMaster.get("DWGSERIESPROJECTNO");
			mapMaster.put("VALUE",sProject);
			mapMaster.put("DISPLAY",sProject);
			mlReturn.add(mapMaster);
		}
		return mlReturn;
	}

	public static String getResultXML(String isSuccess,String errorMsg) throws Exception
	{
		String sXML = "";
		Map mapXMLSet = new HashMap();
		mapXMLSet.put("isSuccess",isSuccess);
		mapXMLSet.put("errorMsg",errorMsg);
		sXML = genXMLFromMap(mapXMLSet);
		return sXML;
	}
	
	private static ArrayList getDwgDept(String sCondition) throws Exception
	{
		Map mapParam = new HashMap();
		if(!StringUtil.isNullString(sCondition))
		{
			mapParam.put("USERID",sCondition);
		}
		ArrayList resultArrayList = SQLSourceUtil.executeSelect("PLM","DEPT.selectDWGDept", mapParam);
		return resultArrayList;
	}
	
	private static ArrayList getDPUser(String NAME,String DWGDEPTCODE) throws Exception
	{
		Map mapParam = new HashMap();
		if(!StringUtil.isNullString(NAME))
		{
			mapParam.put("NAME",NAME);
		}
		if(!StringUtil.isNullString(DWGDEPTCODE))
		{
			mapParam.put("DWGDEPTCODE",DWGDEPTCODE);
		}
		ArrayList resultArrayList = SQLSourceUtil.executeSelect("PLM","USER.selectDPUserInfo", mapParam);
		return resultArrayList;
	}
	
	private static ArrayList getConstructionDate(String PROJECTNO,String BLOCKNO,String ACTIVITYDESC,String FACTOR) throws Exception
	{
		Map mapParam = new HashMap();
		mapParam.put("PROJECTNO",PROJECTNO);
		mapParam.put("BLOCKNO",BLOCKNO);
		mapParam.put("ACTIVITYDESC",ACTIVITYDESC);
		mapParam.put("FACTOR",FACTOR);
		ArrayList resultArrayList = SQLSourceUtil.executeSelect("SDPS","CONSTRUCTION.selectConstructionDate", mapParam);
		return resultArrayList;
	}
%>
	
<%
	
	String sOutPut = "";
	String sCondition = request.getParameter("condition");
	String sMode = request.getParameter("mode");
	ArrayList mlResult = new ArrayList();
	if(sMode == null)
	{
		
	} else if(sMode.equals("person"))
	{
		mlResult = getEmployeeInfoList(sCondition);
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else if(sMode.equals("equipDept"))
	{
		mlResult = getEquipDept(sCondition);
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else if(sMode.equals("getDwgDept"))
	{
		mlResult = getDwgDept(sCondition);
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else if(sMode.equals("getDPUser"))
	{
		mlResult = getDPUser(request.getParameter("NAME"),request.getParameter("DWGDEPTCODE"));
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else if(sMode.equals("department"))
	{
		mlResult = getDeptAddCustomDeptWithERPLog(sCondition);
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else if(sMode.equals("TPIProject"))
	{
		mlResult = getTPIProject(sCondition);
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else if(sMode.equals("ST101TBLDrawing"))
	{
		mlResult = getST101TBLDrawing(sCondition);
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else  if(sMode.equals("progressProject"))
	{
		mlResult = getProjectList(true, "PROGRESS");
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else  if(sMode.equals("masterProject"))
	{
		mlResult = getMasterProjectList();
		sOutPut = getXMLResultFromArrayList(mlResult); 
	} else  if(sMode.equals("getConstructionDate"))
	{
		String PROJECTNO = request.getParameter("PROJECTNO");
		String BLOCKNO = request.getParameter("BLOCKNO");
		String ACTIVITYDESC = request.getParameter("ACTIVITYDESC");
		String FACTOR = request.getParameter("FACTOR");
		mlResult = getConstructionDate(PROJECTNO,BLOCKNO,ACTIVITYDESC,FACTOR);
		sOutPut = getXMLResultFromArrayList(mlResult);  
	}
	System.out.println(sOutPut);
%>
<%=sOutPut%>