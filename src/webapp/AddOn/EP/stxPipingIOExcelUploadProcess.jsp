<%@page import="org.jdom.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.util.StringUtil"%>
<%@page import="java.sql.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest" %>

<%@ page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%request.setCharacterEncoding("euc-kr");%>


<%!

	private ArrayList mappingColumn() throws Exception
	{
		ArrayList slColumnName = new ArrayList();
		slColumnName.add("SHIPTYPE");
		slColumnName.add("AREA");
		slColumnName.add("SYSTEM");
		slColumnName.add("ITEM");
		slColumnName.add("DETAILS");
		slColumnName.add("CONDERATIONS");
		slColumnName.add("DESIGN_BASIS");
		slColumnName.add("ACTIVITY");
		slColumnName.add("OUTPUT");
		slColumnName.add("EVENT");
		slColumnName.add("FACTOR");
		slColumnName.add("IMPORTANCE");
		return slColumnName;
	}

	private ArrayList getExcelToArrayList(File file,ArrayList slMappingCol) throws Exception
	{
		ArrayList mlReturn = new ArrayList();
		POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(file)); 
		HSSFWorkbook wb = new HSSFWorkbook(fs);
		HSSFSheet sheet = wb.getSheetAt(0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");  
		int max_r = sheet.getPhysicalNumberOfRows();
		for(int r = 3; r < max_r ;r ++)
		{
			HSSFRow row = sheet.getRow(r);
			if(row != null)
			{
				Map mapRow = new HashMap();
				for(short c = 0; c < slMappingCol.size() ;c ++)
				{
					HSSFCell cell = row.getCell(c);
					
					if(cell != null)
					{
						String sColName = (String)slMappingCol.get(c);
						mapRow.put(sColName, "");
						switch(cell.getCellType()) {
							case HSSFCell.CELL_TYPE_STRING:
								String sValue  = cell.getStringCellValue();
								sValue = sValue.replaceAll("'", "''");
								mapRow.put(sColName, sValue.trim());
								break;
							case HSSFCell.CELL_TYPE_NUMERIC:
								if(HSSFDateUtil.isCellDateFormatted(cell))
								{
									mapRow.put(sColName, formatter.format(cell.getDateCellValue()));
								} else {
									mapRow.put(sColName, (int)cell.getNumericCellValue()+"");
								}
								break;
						}
					}
				}
				// 2013-09-11 Kangseonjung : 엑셀의 SHIPTYPE값이 없으면 SKIP.
				String checkSHIPTYPE = (String)mapRow.get("SHIPTYPE");
				if(!mapRow.isEmpty() && !"".equals(checkSHIPTYPE))
				{
					mlReturn.add(mapRow);
				}
			} else {
				continue;
			}
		}
		return mlReturn;
	}

	private void insertSTX_PIPING_IO_ACT_DB_FromList(ArrayList mlList,ArrayList slMappingCol,String sUser,String DWGDEPTCODE) throws Exception
	{
		Connection conn = null;
		try{
			conn = DBConnect.getDBConnection("PLM");
			
			Map mapUser = new HashMap();
			mapUser.put("USER",sUser);
			
			ArrayList mlUser = SQLSourceUtil.executeSelect("SDPS","USER.selectDPJOBUser",mapUser);
			
			Iterator itr = mlList.iterator();
			while(itr.hasNext())
			{
				Map map = (Map)itr.next();
				map.put("STATUS","0");
				map.put("OWNER",sUser);
				map.put("DWGDEPTCODE","");
				map.put("APP0","");
				map.put("APP1","");
				map.put("APP2","");
				map.put("MAX_APP","2");
				if(mlUser.size() > 0)
				{
					map.put("APP0",((Map)mlUser.get(0)).get("EMP_NO"));
					map.put("DWGDEPTCODE",((Map)mlUser.get(0)).get("DWG_DEPT_CODE"));
				}
				map.put("CREATED_BY",sUser);
				map.put("UPDATED_BY",sUser);
				SQLSourceUtil.executeUpdate(conn,"PIPINGIO.insertSTX_PIPING_IO_ACT_DB",map);
			}
			conn.commit();
		} catch (Exception e)
		{
			conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			if(conn != null)conn.close();
		}
	}
%>
<%
	String sReturn = "";
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");	
		
    String sWorkDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가	
	
	try{
		ArrayList slMappingCol = mappingColumn();
		MultipartRequest multi = new MultipartRequest(request, sWorkDir, max_byte, "EUC-KR");
		String DWGDEPTCODE = multi.getParameter("DWGDEPTCODE");
		
		File file = multi.getFile("uploadfile");
		ArrayList mlExcel = getExcelToArrayList(file,slMappingCol);
		insertSTX_PIPING_IO_ACT_DB_FromList(mlExcel,slMappingCol,USER,DWGDEPTCODE);
	} catch (Exception e)
	{
			e.printStackTrace();
			sReturn = e.toString();
	} finally{
	}
	
	boolean saveDone = false;
	if(sReturn.equals(""))
	{
		sReturn = "저장 되었습니다.";
		saveDone = true;
	}
	
	sReturn = sReturn.replaceAll("\n","\\n");
	sReturn = sReturn.replaceAll("\"","\\\"");
%>

<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<%@page import="org.apache.poi.hssf.usermodel.HSSFDateUtil"%>
<script type="text/javascript">
	alert("<%=sReturn%>")
	top.fnProgressOff();
	top.close();
</script>
