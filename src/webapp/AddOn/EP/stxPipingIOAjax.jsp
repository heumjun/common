
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<%@page import="java.util.Iterator"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.stx.common.util.StringUtil"%>
<%@page import="com.stx.common.util.FrameworkUtil"%>
<%@include file="include/stx_jdbc_util.jspf"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%! 
	
	public static String createPIPINGIOPRJ(
			String sLoginUser
			,String PROJECT
			,String DESCRIPTION
			,String PIPING_IO_IDS
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			
			Map mapUser = new HashMap();
			mapUser.put("USER",sLoginUser);
			
			ArrayList mlUser = SQLSourceUtil.executeSelect("SDPS","USER.selectDPJOBUser",mapUser);
			conn = DBConnect.getDBConnection("PLM");
			
			Map mapParam = new HashMap();
			mapParam.put("PROJECT",PROJECT);
			mapParam.put("OWNER",sLoginUser);
			mapParam.put("DESCRIPTION",DESCRIPTION);
			mapParam.put("APP0",sLoginUser);
			mapParam.put("APP1","");
			mapParam.put("APP2","");
			if(mlUser.size() > 0)
			{
				mapParam.put("APP1",((Map)mlUser.get(0)).get("EMP_NO"));
				mapParam.put("DWGDEPTCODE",((Map)mlUser.get(0)).get("DWG_DEPT_CODE"));
			}
			if(mlUser.size() > 1)mapParam.put("APP2",((Map)mlUser.get(1)).get("EMP_NO"));
			
			ArrayList slPIPING_IO_ID = FrameworkUtil.split(PIPING_IO_IDS,"|");
			Iterator itr = slPIPING_IO_ID.iterator();
			while(itr.hasNext())
			{
				
				mapParam.put("PIPING_IO_ID",itr.next());
				ArrayList mlList = SQLSourceUtil.executeSelect(conn,"PIPINGIO.selectCHECKApplyProject",mapParam);
				if(mlList.size() > 0)
				{
					if(!((Map)mlList.get(0)).get("ERR_MSG").equals(""))throw new Exception(((Map)mlList.get(0)).get("ERR_MSG")+"");
				}
				
				SQLSourceUtil.executeUpdate(conn,"PIPINGIO.insertProjectSTX_PIPING_IO_ACT",preSQL(mapParam));
			}
			
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}

	public static String approvePIPINGIO(
			String USER
			,String APPROVED_TYPE
			,String[] PIPING_IO_ID
			,String[] PROJECT
			,String ISFIRST
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			
			conn = DBConnect.getDBConnection("PLM");
			
			for(int index = 0;index < PIPING_IO_ID.length;index++)
			{
				Map mapParam = new HashMap();
				mapParam.put("PIPING_IO_ID",PIPING_IO_ID[index]);
				mapParam.put("PROJECT",PROJECT[index]);
				mapParam.put("USER",USER);
				mapParam.put("APPROVED_TYPE",APPROVED_TYPE);
				
				ArrayList mlCheck = SQLSourceUtil.executeSelect(conn,"PIPINGIO.checkApproverSTX_PIPING_IO_ACT",mapParam);
				if(mlCheck.size() >0 )
				{
					if(ISFIRST != null && !((Map)mlCheck.get(0)).get("STATUS").equals("0"))
					{
						throw new Exception("이미 결재가 진행 중입니다.("+PIPING_IO_ID[index]+","+PROJECT[index]+")");
					}
					if(ISFIRST != null && ((Map)mlCheck.get(0)).get("DUE_DATE").equals("") && !PROJECT[index].equals("DB"))
					{
						throw new Exception("DUE DATE 일자는 필수입니다.("+PIPING_IO_ID[index]+","+PROJECT[index]+")");
					}
					if(ISFIRST != null && ((Map)mlCheck.get(0)).get("ACTION_DATE").equals("") && !PROJECT[index].equals("DB"))
					{
						throw new Exception("ACTION DATE 일자는 필수입니다.("+PIPING_IO_ID[index]+","+PROJECT[index]+")");
					}
					SQLSourceUtil.executeUpdate(conn,"PIPINGIO.insertSTX_PIPING_IO_ACT_APP",mapParam);
					if(PROJECT[index].equals("DB"))
					{
						SQLSourceUtil.executeUpdate(conn,"PIPINGIO.approveSTX_PIPING_IO_ACT_DB",mapParam);
					} else {
						SQLSourceUtil.executeUpdate(conn,"PIPINGIO.approveSTX_PIPING_IO_ACT",mapParam);
					}
				} else {
					if(PROJECT[index].equals("DB"))
					{
						throw new Exception("해당 결재자가 아니거나 다른사람이 결재 진행중입니다.("+PIPING_IO_ID[index]+","+PROJECT[index]+")");
					} else {
						throw new Exception("해당 결재자가 아니거나 라인장이 지정되어 있지 않습니다.("+PIPING_IO_ID[index]+","+PROJECT[index]+")");
					}
				}
			}
			
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
	
	public static String withdrawPIPINGIO(
			String USER
			,String[] PIPING_IO_ID
			,String[] PROJECT
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			
			conn = DBConnect.getDBConnection("PLM");
			
			for(int index = 0;index < PIPING_IO_ID.length;index++)
			{
				Map mapParam = new HashMap();
				mapParam.put("PIPING_IO_ID",PIPING_IO_ID[index]);
				mapParam.put("PROJECT",PROJECT[index]);
				mapParam.put("USER",USER);
				mapParam.put("APPROVED_TYPE","WITHDRAW");
				
				ArrayList mlCheck = SQLSourceUtil.executeSelect(conn,"PIPINGIO.checkWithDrawSTX_PIPING_IO_ACT",mapParam);
				if(mlCheck.size() > 0)
				{
					throw new Exception(((Map)mlCheck.get(0)).get("MSG")+"");
				}
				
				SQLSourceUtil.executeUpdate(conn,"PIPINGIO.insertSTX_PIPING_IO_ACT_APP",mapParam);
				if(PROJECT[index].equals("DB"))
				{
					SQLSourceUtil.executeUpdate(conn,"PIPINGIO.approveSTX_PIPING_IO_ACT_DB",mapParam);
				} else {
					SQLSourceUtil.executeUpdate(conn,"PIPINGIO.approveSTX_PIPING_IO_ACT",mapParam);
				}
			}
			
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
	
	public static String editPIPINGIODB(
			String USER
			,String[] PIPING_IO_ID
			,String[] ACTIVITY
			,String[] APP1
			,String[] SHIPTYPE
			,String[] AREA
			,String[] SYSTEM
			,String[] ITEM
			,String[] DETAILS
			,String[] CONDERATIONS
			,String[] OUTPUT
			,String[] DESIGN_BASIS
			,String[] EVENT
			,String[] FACTOR
			,String[] IMPORTANCE
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			Map mapUser = new HashMap();
			mapUser.put("USER",USER);
			ArrayList mlUser = SQLSourceUtil.executeSelect("SDPS","USER.selectDPJOBUser",mapUser);
			
			conn = DBConnect.getDBConnection("PLM");
			for(int i=0;i<PIPING_IO_ID.length;i++)
			{
				Map mapParam = new HashMap();
				mapParam.put("USER",USER);
				mapParam.put("PIPING_IO_ID",PIPING_IO_ID[i].trim());
				mapParam.put("ACTIVITY",ACTIVITY[i].trim());
				mapParam.put("SHIPTYPE",SHIPTYPE[i].trim());
				mapParam.put("AREA",AREA[i].trim());
				mapParam.put("SYSTEM",SYSTEM[i].trim());
				mapParam.put("ITEM",ITEM[i].trim());
				mapParam.put("DETAILS",DETAILS[i].trim());
				mapParam.put("CONDERATIONS",CONDERATIONS[i].trim());
				mapParam.put("OUTPUT",OUTPUT[i].trim());
				mapParam.put("DESIGN_BASIS",DESIGN_BASIS[i].trim());
				mapParam.put("EVENT",EVENT[i].trim());
				mapParam.put("FACTOR",FACTOR[i].trim());
				mapParam.put("IMPORTANCE",IMPORTANCE[i].trim());
				mapParam.put("APP0","");
				mapParam.put("APP1","");
				System.out.println(mapParam);
				ArrayList slAPP1 = FrameworkUtil.split(APP1[i],"|");
				
				if(slAPP1.size() > 1)
				{
					mapParam.put("APP1",slAPP1.get(0));
				}
				mapParam.put("PROJECT","DB");
				ArrayList mlCheck = SQLSourceUtil.executeSelect(conn,"PIPINGIO.checkSaveSTX_PIPING_IO",mapParam);
				if(mlCheck.size() > 0 )throw new Exception(((Map)mlCheck.get(0)).get("MSG")+"");
				
				if(mlUser.size() > 0)mapParam.put("APP0",((Map)mlUser.get(0)).get("EMP_NO"));
				
				SQLSourceUtil.executeUpdate(conn,"PIPINGIO.saveSTX_PIPING_IO_ACT_DB",preSQL(mapParam));
			}
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
	
	public static String editPIPINGIO(
			String USER
			,String[] PIPING_IO_ID
			,String[] PROJECT
			,String[] DESCRIPTION
			,String[] DUE_DATE
			,String[] ACTION_DATE
			,String[] APP0
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			Map mapUser = new HashMap();
			mapUser.put("USER",USER);
			conn = DBConnect.getDBConnection("PLM");
			System.out.println(PIPING_IO_ID);
			for(int i=0;i<PIPING_IO_ID.length;i++)
			{
				Map mapParam = new HashMap();
				mapParam.put("USER",USER);
				mapParam.put("PIPING_IO_ID",PIPING_IO_ID[i]);
				mapParam.put("PROJECT",PROJECT[i]);
				mapParam.put("DESCRIPTION",DESCRIPTION[i]);
				mapParam.put("DUE_DATE",DUE_DATE[i]);
				mapParam.put("ACTION_DATE",ACTION_DATE[i]);
				mapParam.put("APP0","");
				
				ArrayList mlCheck = SQLSourceUtil.executeSelect(conn,"PIPINGIO.checkSaveSTX_PIPING_IO",mapParam);
				if(mlCheck.size() > 0 )throw new Exception(((Map)mlCheck.get(0)).get("MSG")+"");
				
				ArrayList slAPP1 = FrameworkUtil.split(APP0[i],"|");
				if(slAPP1.size() > 1)
				{
					mapParam.put("APP0",slAPP1.get(0));
				}
				SQLSourceUtil.executeUpdate(conn,"PIPINGIO.saveSTX_PIPING_IO_ACT",preSQL(mapParam));
			}
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
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
	
	public static ArrayList selectDWGDEPTCODE() throws Exception
	{
		Map mapParam = new HashMap();
		mapParam.put("SORT","true");
		ArrayList mlReturn = SQLSourceUtil.executeSelect("PLM","DEPT.selectDWGDept",mapParam);
		return mlReturn;
	}
	
	public static ArrayList selectGetOption(String COL) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		if(COL == null)
		{
			
		} else if(COL.equals("DWGDEPTCODE"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBDept",new HashMap());
		} else if(COL.equals("SHIPTYPE"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBSHIPTYPE",new HashMap());
		} else if(COL.equals("OUTPUT"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBOUTPUT",new HashMap());
		} else if(COL.equals("AREA"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBAREA",new HashMap());
		} else if(COL.equals("SYSTEM"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBSYSTEM",new HashMap());
		} else if(COL.equals("ITEM"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBITEM",new HashMap());
		}
		return mlReturn;
	}
	
	public static ArrayList selectGetIOOption(String COL) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		if(COL == null)
		{
			
		} else if(COL.equals("DWGDEPTCODE"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODept",new HashMap());
		} else if(COL.equals("PROJECT"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIOPROJECT",new HashMap());
		} else if(COL.equals("OUTPUT"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIOOUTPUT",new HashMap());
		} else if(COL.equals("AREA"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIOAREA",new HashMap());
		} else if(COL.equals("SYSTEM"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIOSYSTEM",new HashMap());
		} else if(COL.equals("ITEM"))
		{
			mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIOITEM",new HashMap());
		}
		return mlReturn;
	}
	
	public static ArrayList selectPIPINGIODBDept() throws Exception
	{
		Map mapParam = new HashMap();
		ArrayList mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectPIPINGIODBDept",mapParam);
		return mlReturn;
	}
	
	public static ArrayList getPipingIOFile(
			String USER
			,String PIPING_IO_ID
			,String PROJECT
			) throws Exception
	{
		Map mapParam = new HashMap();
		mapParam.put("PIPING_IO_ID",PIPING_IO_ID);
		mapParam.put("PROJECT",PROJECT);
		ArrayList mlReturn = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectSTX_PIPING_IO_FILE",mapParam);
		return mlReturn;
	}
	
	public static String deleteFile(
			String USER
			,String FILEID
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			conn = DBConnect.getDBConnection("PLM");
			
			Map mapWhere = new HashMap();
			mapWhere.put("FILEID",FILEID);
			deleteTableSimple(conn,"STX_PIPING_IO_FILE",mapWhere);
			
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
	

	
	public static String delPIPINGIODB(
			String USER
			,String[] PIPING_IO_ID
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			conn = DBConnect.getDBConnection("PLM");
			
			java.sql.PreparedStatement pstmt = null; 
			java.sql.ResultSet rset = null;
			
	        StringBuffer sbSql = new StringBuffer();
	        sbSql.append("SELECT     						\n");
	        sbSql.append(" APP1,OWNER    						\n");
	        sbSql.append("from STX_PIPING_IO_ACT_DB                        \n");
	        sbSql.append("WHERE PIPING_IO_ID = ?       			\n");		
	        
	        pstmt = conn.prepareStatement(sbSql.toString());	
			
			for(int i=0;i<PIPING_IO_ID.length;i++)
			{
				Map mapParam = new HashMap();
				mapParam.put("PIPING_IO_ID",PIPING_IO_ID[i]);
				ArrayList mlList = selectTableSimple(conn,"STX_PIPING_IO_ACT",mapParam);
				//ArrayList mlDBList = selectTableSimple(conn,"STX_PIPING_IO_ACT_DB",mapParam);   STX_PIPING_IO_ACT_DB에 blob 컬럼때문에 에러 발생하여 select 구문변경
				ArrayList mlDBList = new ArrayList();
				pstmt.setString(1, PIPING_IO_ID[i]);
		        rset = pstmt.executeQuery();	
		        
		        while (rset.next()) {
		        	HashMap resultMap = new HashMap();
		        	resultMap.put("APP1", rset.getString(1) == null ? "" : rset.getString(1));
		        	resultMap.put("OWNER", rset.getString(2) == null ? "" : rset.getString(2));
		        	mlDBList.add(resultMap);		        
		        }			
				
				String APP1 ="";
				String OWNER ="";
				if(mlDBList.size()>0)
				{
					APP1 = (String)((Map)mlDBList.get(0)).get("APP1");
					OWNER = (String)((Map)mlDBList.get(0)).get("OWNER");
				}
					
				if(!USER.equals(APP1) && mlList.size() > 0)
				{
					throw new Exception("해당 DATA에 연계되어있는 호선 있는 경우 삭제가 불가능 합니다.Manager를 통해서 삭제 하십시요.("+PIPING_IO_ID[i]+")");
				} else if(!USER.equals(APP1) && !USER.equals(OWNER) ){
					throw new Exception("Manager 또는 승인요청자만 삭제가 가능합니다.("+PIPING_IO_ID[i]+")");
				}
				deleteTableSimple(conn,"STX_PIPING_IO_ACT_DB",mapParam);
			}
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
	
	public static String delPIPINGIO(
			String USER
			,String[] PIPING_IO_ID
			,String[] PROJECT
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			conn = DBConnect.getDBConnection("PLM");
			for(int i=0;i<PIPING_IO_ID.length;i++)
			{
				Map mapParam = new HashMap();
				mapParam.put("PIPING_IO_ID",PIPING_IO_ID[i]);
				mapParam.put("PROJECT",PROJECT[i]);
				ArrayList mlList = selectTableSimple(conn,"STX_PIPING_IO_ACT",mapParam);
				
				String APP1 ="";
				String OWNER ="";
				String STATUS ="";
				if(mlList.size()>0)
				{
					APP1 = (String)((Map)mlList.get(0)).get("APP1");
					OWNER = (String)((Map)mlList.get(0)).get("OWNER");
					STATUS = (String)((Map)mlList.get(0)).get("STATUS");
				}
					
				if(!STATUS.equals("0"))
				{
					throw new Exception("해당 DATA가 결재 진행중입니다. 반려후 삭제하십시요.("+PIPING_IO_ID[i]+")");
				} else if(!USER.equals(APP1) && !USER.equals(OWNER) ){
					throw new Exception("Manager 또는 승인요청자만 삭제가 가능합니다.("+PIPING_IO_ID[i]+")");
				}
				deleteTableSimple(conn,"STX_PIPING_IO_ACT",mapParam);
			}
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
	
	public static String createPIPINGIODB(
			String USER
			,String DWGDEPTCODE
			,String SHIPTYPE
			,String AREA
			,String SYSTEM
			,String ITEM
			,String DETAILS
			,String CONSIDERATIONS
			,String DESIGN_BASIS
			,String ACTIVITY
			,String OUTPUT
			,String EVENT
			,String FACTOR
			,String IMPORTANCE
			) throws Exception
	{
		String sReturn = "";
		Connection conn = null;
		try{
			conn = DBConnect.getDBConnection("PLM");
			Map mapUser = new HashMap();
			mapUser.put("USER",USER);
			
			ArrayList mlUser = SQLSourceUtil.executeSelect("SDPS","USER.selectDPJOBUser",mapUser);
			
			Map map = new HashMap();
			map.put("STATUS","0");
			map.put("OWNER",USER);
			map.put("DWGDEPTCODE",DWGDEPTCODE);
			map.put("APP0","");
			map.put("APP1","");
			map.put("APP2","");
			map.put("MAX_APP","2");
			map.put("SHIPTYPE",SHIPTYPE.trim());
			map.put("AREA",AREA.trim());
			map.put("SYSTEM",SYSTEM.trim());
			map.put("ITEM",ITEM.trim());
			map.put("DETAILS",DETAILS.trim());
			map.put("CONDERATIONS",CONSIDERATIONS.trim());
			map.put("DESIGN_BASIS",DESIGN_BASIS.trim());
			map.put("ACTIVITY",ACTIVITY.trim());
			map.put("OUTPUT",OUTPUT.trim());
			map.put("EVENT",EVENT.trim());
			map.put("FACTOR",FACTOR.trim());
			map.put("IMPORTANCE",IMPORTANCE.trim());
			map.put("APP0","");
			map.put("CREATED_BY",USER);
			map.put("UPDATED_BY",USER);
			
			if(mlUser.size() > 0){
				map.put("APP0",((Map)mlUser.get(0)).get("EMP_NO"));
				map.put("DWGDEPTCODE",((Map)mlUser.get(0)).get("DWG_DEPT_CODE"));
			} else {
				throw new Exception("생성자 정보에 오류가 있습니다.");
			}
			
			SQLSourceUtil.executeUpdate(conn,"PIPINGIO.insertSTX_PIPING_IO_ACT_DB",map);
			
			conn.commit();
		} catch (Exception e) 
		{
			e.printStackTrace();
			if(conn != null)conn.rollback();
			sReturn = e.toString();
		} finally {
			DBConnect.closeConnection(conn);
		}
		return sReturn;
	}
%>
<%
	String sOutPut = "";
	String sMode = request.getParameter("mode");
	
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String USER = (String)loginUser.get("user_id");	

	try{
		if(sMode == null)
		{
		} if(sMode.equals("selectDWGDEPTCODE"))
		{
			ArrayList mlResult = selectDWGDEPTCODE();
			sOutPut = getXMLResultFromArrayList(mlResult);
		} if(sMode.equals("selectGetOption"))
		{
			String COL = request.getParameter("COL");
			ArrayList mlResult = selectGetOption(COL);
			sOutPut = getXMLResultFromArrayList(mlResult);
		}  if(sMode.equals("selectGetIOOption"))
		{
			String COL = request.getParameter("COL");
			ArrayList mlResult = selectGetIOOption(COL);
			sOutPut = getXMLResultFromArrayList(mlResult);
		}  if(sMode.equals("selectPIPINGIODBDept"))
		{
			ArrayList mlResult = selectPIPINGIODBDept();
			sOutPut = getXMLResultFromArrayList(mlResult);
		}  if(sMode.equals("createPIPINGIOPRJ"))
		{
			String PROJECT 					= request.getParameter("PROJECT");
			String DESCRIPTION 				= request.getParameter("DESCRIPTION");
			String PIPING_IO_IDS 					= request.getParameter("PIPING_IO_IDS");
			String sReturn = createPIPINGIOPRJ(
					USER
					,PROJECT
					,DESCRIPTION
					,PIPING_IO_IDS
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("approvePIPINGIO"))
		{
			String[] PIPING_IO_ID	= request.getParameterValues("PIPING_IO_ID");
			String[] PROJECT 		= request.getParameterValues("PROJECT");
			String APPROVED_TYPE 	= request.getParameter("APPROVED_TYPE");
			String ISFIRST			= request.getParameter("ISFIRST");
			String sReturn = approvePIPINGIO(
					USER
					,APPROVED_TYPE
					,PIPING_IO_ID
					,PROJECT
					,ISFIRST
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("editPIPINGIODB"))
		{
			
			String[] PIPING_IO_ID 	= request.getParameterValues("PIPING_IO_ID");
			String[] ACTIVITY 		= request.getParameterValues("ACTIVITY");
			String[] APP1 			= request.getParameterValues("APP1");
			String[] SHIPTYPE 		= request.getParameterValues("SHIPTYPE");
			String[] AREA 			= request.getParameterValues("AREA");
			String[] SYSTEM 		= request.getParameterValues("SYSTEM");
			String[] ITEM 			= request.getParameterValues("ITEM");
			String[] DETAILS 		= request.getParameterValues("DETAILS");
			String[] CONDERATIONS 	= request.getParameterValues("CONDERATIONS");
			String[] OUTPUT 		= request.getParameterValues("OUTPUT");
			String[] DESIGN_BASIS 	= request.getParameterValues("DESIGN_BASIS");
			String[] EVENT 			= request.getParameterValues("EVENT");
			String[] FACTOR 			= request.getParameterValues("FACTOR");
			String[] IMPORTANCE 			= request.getParameterValues("IMPORTANCE");
			System.out.println(PIPING_IO_ID[0]);
			System.out.println(ACTIVITY[0]);
			System.out.println(APP1[0]);
			String sReturn = editPIPINGIODB(
					USER
					,PIPING_IO_ID
					,ACTIVITY
					,APP1
					,SHIPTYPE
					,AREA
					,SYSTEM
					,ITEM
					,DETAILS
					,CONDERATIONS
					,OUTPUT
					,DESIGN_BASIS
					,EVENT
					,FACTOR
					,IMPORTANCE
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("editPIPINGIO"))
		{
			String[] PROJECT 		= request.getParameterValues("PROJECT");
			String[] PIPING_IO_ID 	= request.getParameterValues("PIPING_IO_ID");
			String[] DUE_DATE 		= request.getParameterValues("DUE_DATE");
			String[] ACTION_DATE 		= request.getParameterValues("ACTION_DATE");
			String[] DESCRIPTION 		= request.getParameterValues("DESCRIPTION");
			String[] APP0 		= request.getParameterValues("APP0");
			String sReturn = editPIPINGIO(
					USER
					,PIPING_IO_ID
					,PROJECT
					,DESCRIPTION
					,DUE_DATE
					,ACTION_DATE
					,APP0
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("getPipingIOFile"))
		{
			String PIPING_IO_ID = request.getParameter("PIPING_IO_ID");
			String PROJECT = request.getParameter("PROJECT");
			ArrayList mlResult = getPipingIOFile(
					USER
					,PIPING_IO_ID
					,PROJECT
					);
			sOutPut = getXMLResultFromArrayList(mlResult);
		} if(sMode.equals("deleteFile"))
		{
			String FILEID	= request.getParameter("FILEID");
			String sReturn = deleteFile(USER,FILEID);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("delPIPINGIODB"))
		{
			String[] PIPING_IO_ID 	= request.getParameterValues("PIPING_IO_ID");
			String sReturn = delPIPINGIODB(
					USER
					,PIPING_IO_ID
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		}  if(sMode.equals("withdrawPIPINGIO"))
		{
			String[] PIPING_IO_ID 	= request.getParameterValues("PIPING_IO_ID");
			String[] PROJECT 	= request.getParameterValues("PROJECT");
			String sReturn = withdrawPIPINGIO(
					USER
					,PIPING_IO_ID
					,PROJECT
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("createPIPINGIODB"))
		{
			
			String DWGDEPTCODE 				= request.getParameter("DWGDEPTCODE");
			String SHIPTYPE 				= request.getParameter("SHIPTYPE");
			String AREA 					= request.getParameter("AREA");
			String SYSTEM 					= request.getParameter("SYSTEM");
			String ITEM 					= request.getParameter("ITEM");
			String DETAILS 					= request.getParameter("DETAILS");
			String CONSIDERATIONS 			= request.getParameter("CONSIDERATIONS");
			String DESIGN_BASIS 			= request.getParameter("DESIGN_BASIS");
			String ACTIVITY 				= request.getParameter("ACTIVITY");
			String OUTPUT 					= request.getParameter("OUTPUT");
			String EVENT 					= request.getParameter("EVENT");
			String FACTOR 					= request.getParameter("FACTOR");
			String IMPORTANCE 				= request.getParameter("IMPORTANCE");
			
			String sReturn = createPIPINGIODB(
					USER
					,DWGDEPTCODE
					,SHIPTYPE
					,AREA
					,SYSTEM
					,ITEM
					,DETAILS
					,CONSIDERATIONS
					,DESIGN_BASIS
					,ACTIVITY
					,OUTPUT
					,EVENT
					,FACTOR
					,IMPORTANCE
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		} if(sMode.equals("delPIPINGIO"))
		{
			String[] PIPING_IO_ID 	= request.getParameterValues("PIPING_IO_ID");
			String[] PROJECT 	= request.getParameterValues("PROJECT");
			String sReturn = delPIPINGIO(
					USER
					,PIPING_IO_ID
					,PROJECT
					);
			if(!StringUtil.isNullString(sReturn))
			{
				sOutPut = getResultXML("false",sReturn);
			} else {
				sOutPut = getResultXML("true",sReturn);
			}
		}
	} catch (Exception e)
	{
		e.printStackTrace();
	}
	System.out.println(sOutPut);
%>
<%=sOutPut%>
