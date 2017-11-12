<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %> 
<%request.setCharacterEncoding("UTF-8");%>
<%!
	public static Map preSQL(Map map) throws Exception
	{
		if(map != null)
		{
			try{
				Set set = map.keySet();
				Iterator itr = set.iterator();
				while(itr.hasNext())
				{
					String key = (String)itr.next();
					Object objVal = map.get(key);
					if( objVal != null && objVal instanceof String)
					{
						String sVal = (String)objVal;
						System.out.println(sVal);
						map.put(key,sVal.replaceAll("'", "''"));
					}
				}
			} catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		return map;
	}
%>
<%
	response.setHeader("Content-Disposition", "attachment; filename=excel.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 
	
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");	
	String PROJECT = request.getParameter("PROJECT");
	String OUTPUT = request.getParameter("OUTPUT");
	String AREA = request.getParameter("AREA");
	String ACTIVITY = request.getParameter("ACTIVITY");
	String ITEM = request.getParameter("ITEM");
	String SYSTEM = request.getParameter("SYSTEM");
	String DWGDEPTCODE = request.getParameter("DWGDEPTCODE");
	String QUERYON 		= request.getParameter("QUERYON");
	String SORTCOL 		= request.getParameter("SORTCOL");
	String DESCRIPTION 		= request.getParameter("DESCRIPTION");
	
	
	Map mapParam = new HashMap();
	mapParam.put("USER",USER);
	mapParam.put("PROJECT",PROJECT);
	mapParam.put("OUTPUT",OUTPUT);
	mapParam.put("AREA",AREA);
	mapParam.put("ACTIVITY",ACTIVITY);
	mapParam.put("ITEM",ITEM);
	mapParam.put("SYSTEM",SYSTEM);
	mapParam.put("DWGDEPTCODE",DWGDEPTCODE);
	mapParam.put("DESCRIPTION",DESCRIPTION);
	mapParam.put("SORT_" + SORTCOL		,"true");
	
	ArrayList mlList = new ArrayList();
	if(QUERYON != null && !QUERYON.equals(""))	mlList = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectSTX_PIPING_IO_ACT",preSQL(mapParam));
%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<%@page import="com.stx.common.util.StringUtil"%>

<html> 
<head> 
	<title>HTML코드가 엑셀파일변환</title> 
</head> 
<body> 
    <table border=1> <!-- border=1은 필수 excel 셀의 테두리가 생기게함 --> 
        <tr bgcolor=#CACACA> <!-- bgcolor=#CACACA excel 셀의 바탕색을 회색으로 --> 
            <td colspan=3><H3>Project Design I/O Data Management</H3></td> 
        </tr> 
        
        <tr>
			<td rowspan="1" colspan="4" align="center" >DESIGN SUBJECT</td>
			<td rowspan="1" colspan="2" align="center" >INPUT DATA</td>
			<td rowspan="2" colspan="1" align="center" >OUTPUT DATA</td>
			<td rowspan="2" colspan="1" align="center" >DESCRIPTION</td>
			<td rowspan="1" colspan="2" align="center" >PROCESSING</td>
			<td rowspan="1" colspan="2" align="center" >STATUS</td>
			<td rowspan="1" colspan="4" align="center" >LIFECYCLE</td>
		</tr>
		<tr>
			<td colspan="1" align="center" >호선</td>
			<td colspan="1" align="center" >AREA</td>
			<td colspan="1" align="center" >SYSTEM</td>
			<td colspan="1" align="center" >ITEM</td>
			<td colspan="1" align="center" >DETAILS</td>
			<td colspan="1" align="center" >CONSIDERATIONS</td>
			<td colspan="1" align="center" >DESIGN BASIS</td>
			<td colspan="1" align="center" >ACTIVITY</td>
			<td colspan="1" align="center" >DUE DATE</td>
			<td colspan="1" align="center" >ACTION DATE</td>
			<td colspan="1" align="center" >승인요청</td>
			<td colspan="1" align="center" >라인장</td>
			<td colspan="1" align="center" >파트장</td>
			<td colspan="1" align="center" >팀장</td>
		</tr>
		<%
		Iterator itr = mlList.iterator();
		while(itr.hasNext())
		{
			Map map = (HashMap)itr.next();
		%>
			<tr>
			<td align="center" ><%=map.get("PROJECT")%></td>
			<td align="center" ><%=map.get("AREA")%></td>
			<td align="center" ><%=map.get("SYSTEM")%></td>
			<td align="center" ><%=map.get("ITEM")%></td>
			<td align="center" ><%=map.get("DETAILS")%></td>
			<td align="center" ><%=map.get("CONDERATIONS")%></td>
			<td align="center" ><%=map.get("OUTPUT")%></td>
			<td align="center" ><%=map.get("DESCRIPTION")%></td>
			<td align="center" ><%=map.get("DESIGN_BASIS")%></td>
			<td align="center" ><%=map.get("ACTIVITY")%></td>
			<td align="center" ><%=map.get("DUE_DATE")%></td>
			<td align="center" ><%=map.get("ACTION_DATE")%></td>
			<td align="center" ><%=map.get("OWNER_NM")%><BR><%=map.get("APPROVED_DATE0")%><BR><%=map.get("APPROVED_REQUIRED0")%></td>
			<td align="center" ><%=map.get("APP0_NM")%><BR><%=map.get("APPROVED_DATE1")%><BR><%=map.get("APPROVED_REQUIRED1")%></td>
			<td align="center" ><%=map.get("APP1_NM")%><BR><%=map.get("APPROVED_DATE2")%><BR><%=map.get("APPROVED_REQUIRED2")%></td>
			<td align="center" ><%=map.get("APP2_NM")%><BR><%=map.get("APPROVED_DATE3")%><BR><%=map.get("APPROVED_REQUIRED3")%></td>
			</tr>
		<%
		}
		%>
			
    </table> 

</body> 
</html> 
