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
	System.out.println("~~~~~ USER="+USER);
	
	String QUERYON 		= request.getParameter("QUERYON");
	String SHIPTYPE 	= request.getParameter("SHIPTYPE");
	String AREA 		= request.getParameter("AREA");
	String SYSTEM 		= request.getParameter("SYSTEM");
	String ITEM 		= request.getParameter("ITEM");
	String OUTPUT 		= request.getParameter("OUTPUT");
	String ACTIVITY		= request.getParameter("ACTIVITY");
	String DWGDEPTCODE	= request.getParameter("DWGDEPTCODE");
	String SORTCOL		= request.getParameter("SORTCOL");
	
	Map mapParam = new HashMap();
	mapParam.put("USER"			,USER);
	mapParam.put("SHIPTYPE"	,SHIPTYPE);
	mapParam.put("AREA"			,AREA);
	mapParam.put("SYSTEM"		,SYSTEM);
	mapParam.put("ITEM"			,ITEM);
	mapParam.put("OUTPUT"	,OUTPUT);
	mapParam.put("ACTIVITY"		,ACTIVITY);
	mapParam.put("DWGDEPTCODE"		,DWGDEPTCODE);
	mapParam.put("SORT_" + SORTCOL		,"true");
	
	String sReturn = "";
	
	ArrayList mlList = new ArrayList();
	mlList = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectSTX_PIPING_IO_ACT_DB",preSQL(mapParam));
%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<html> 
<head> 
	<title>HTML코드가 엑셀파일변환</title> 
</head> 
<body> 
    <table border=1> <!-- border=1은 필수 excel 셀의 테두리가 생기게함 --> 
        <tr bgcolor=#CACACA> <!-- bgcolor=#CACACA excel 셀의 바탕색을 회색으로 --> 
            <td colspan=3><H3>Master Design I/O Database Management</H3></td> 
        </tr> 
        
        <tr>
			<td rowspan="1" colspan="4" align="center" >DESIGN SUBJECT</td>
			<td rowspan="1" colspan="2" align="center" >INPUT DATA</td>
			<td rowspan="2" colspan="1" align="center" >OUTPUT DATA</td>
			<td rowspan="1" colspan="2" align="center" >PROCESSING</td>
			<td rowspan="1" colspan="3" align="center" >LIFECYCLE</td>
			<td rowspan="2" colspan="1" align="center" >EVENT</td>
			<td rowspan="2" colspan="1" align="center" >FACTOR</td>
		</tr>
		<tr>
			<td colspan="1" align="center" >선종</td>
			<td colspan="1" align="center" >AREA</td>
			<td colspan="1" align="center" >SYSTEM</td>
			<td colspan="1" align="center" >ITEM</td>
			<td colspan="1" align="center" >DETAILS</td>
			<td colspan="1" align="center" >CONSIDERATIONS</td>
			<td colspan="1" align="center" >DESIGN BASIS</td>
			<td colspan="1" align="center" >ACTIVITY</td>
			<td colspan="1" align="center" >승인요청</td>
			<td colspan="1" align="center" >파트장</td>
			<td colspan="1" align="center" >MANAGER</td>
		</tr>
		<%
		Iterator itr = mlList.iterator();
		while(itr.hasNext())
		{
			Map map = (HashMap)itr.next();
		%>
			<tr>
			<td align="center" ><%=map.get("SHIPTYPE")%></td>
			<td align="center" ><%=map.get("AREA")%></td>
			<td align="center" ><%=map.get("SYSTEM")%></td>
			<td align="center" ><%=map.get("ITEM")%></td>
			<td align="center" ><%=map.get("DETAILS")%></td>
			<td align="center" ><%=map.get("CONDERATIONS")%></td>
			<td align="center" ><%=map.get("OUTPUT")%></td>
			<td align="center" ><%=map.get("DESIGN_BASIS")%></td>
			<td align="center" ><%=map.get("ACTIVITY")%></td>
			<td align="center" ><%=map.get("OWNER_NM")%><%=map.get("APPROVED_DATE0")%><BR><%=map.get("APPROVED_REQUIRED0")%></td>
			<td align="center" ><%=map.get("APP0_NM")%><%=map.get("APPROVED_DATE1")%><BR><%=map.get("APPROVED_REQUIRED1")%></td>
			<td align="center" ><%=map.get("APP1_NM")%></td>
			<td align="center" ><%=map.get("EVENT")%></td>
			<td align="center" ><%=map.get("FACTOR")%></td>
			</tr>
		<%
		}
		%>
			
    </table> 

</body> 
</html> 
