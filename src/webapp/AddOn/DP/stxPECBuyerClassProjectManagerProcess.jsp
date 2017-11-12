<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%--========================== JSP =========================================--%>
<%!
	public static String isNullString(String checkString){
		if(checkString==null || "null".equalsIgnoreCase(checkString) || "".equals(checkString) || "undefined".equals(checkString)){
			return "";
		}else{
			return checkString;
		}
	}
%>
<%
	request.setCharacterEncoding("euc-kr");
	//project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , processType
	String project 			= isNullString(request.getParameter("project"));
	String drawingType 		= isNullString(request.getParameter("drawingType"));
	String refType 			= isNullString(request.getParameter("refType"));
	String workRank 		= isNullString(request.getParameter("workRank"));
	String mailList			= isNullString(request.getParameter("mailList"));
	String position			= isNullString(request.getParameter("position"));
	String companyName		= isNullString(request.getParameter("companyName"));
	String address			= isNullString(request.getParameter("address"));
	String faxNum			= isNullString(request.getParameter("faxNum"));
	String eMailAddr		= isNullString(request.getParameter("eMailAddr"));
	String phoneNum			= isNullString(request.getParameter("phoneNum"));
	String mailListFlag		= isNullString(request.getParameter("mailListFlag"));
	String companyNameFlag	= isNullString(request.getParameter("companyNameFlag"));
	String addressFlag		= isNullString(request.getParameter("addressFlag"));
	String faxNumFlag		= isNullString(request.getParameter("faxNumFlag"));
	String department		= isNullString(request.getParameter("department"));
	String refBasis			= isNullString(request.getParameter("refBasis"));
	String processType		= isNullString(request.getParameter("processType"));
	
	//System.out.println(project 	);
	//System.out.println(drawingType 	);
	//System.out.println(refType 	);
	//System.out.println(workRank 	);
	//System.out.println(mailList	);
	//System.out.println(position	);
	//System.out.println(companyName	);
	//System.out.println(address	);	
	//System.out.println(faxNum	);	
	//System.out.println(eMailAddr	);
	//System.out.println(phoneNum	);
	//System.out.println(mailListFlag	);
	//System.out.println(companyNameFlag);	
	//System.out.println(addressFlag	);
	//System.out.println(faxNumFlag	);
	//System.out.println(department	);
	//System.out.println(refBasis	);
	//System.out.println(processType);
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	conn.setAutoCommit(false);
	
	if("add".equals(processType)){
		//project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , processType
		StringBuffer updateSQL = new StringBuffer();
		updateSQL.append("update stx_oc_project_receive_list ");
		updateSQL.append("   set priority = priority + 1 ");
		updateSQL.append(" where project = '"+project+"' ");
		updateSQL.append("   and drawing_type = '"+drawingType+"' ");
		updateSQL.append("   and receive_type = '"+refType+"' ");
		updateSQL.append("   and priority >= '"+workRank+"' ");
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(updateSQL.toString());
		
		conn.commit();
		
		if(stmt!=null)
			stmt.close();
		
		StringBuffer insertSQL = new StringBuffer();
		insertSQL.append("insert into stx_oc_project_receive_list( ");
		insertSQL.append("       project, ");
		insertSQL.append("       drawing_type, ");
		insertSQL.append("       receive_type, ");
		insertSQL.append("       priority, ");
		insertSQL.append("       receiver, ");
		insertSQL.append("       position, ");
		insertSQL.append("       company, ");
		insertSQL.append("       address, ");
		insertSQL.append("       fax, ");
		insertSQL.append("       email, ");
		insertSQL.append("       phone, ");
		insertSQL.append("       receiver_flag, ");
		insertSQL.append("       company_flag, ");
		insertSQL.append("       address_flag, ");
		insertSQL.append("       fax_flag, ");
		insertSQL.append("       department, ");
		insertSQL.append("       basis) ");
		insertSQL.append("values( ");
		insertSQL.append("       '"+project+"', ");
		insertSQL.append("       '"+drawingType+"', ");
		insertSQL.append("       '"+refType+"', ");
		insertSQL.append("       '"+workRank+"', ");
		insertSQL.append("       '"+mailList+"', ");
		insertSQL.append("       '"+position+"', ");
		insertSQL.append("       '"+companyName+"', ");
		insertSQL.append("       '"+address+"', ");
		insertSQL.append("       '"+faxNum+"', ");
		insertSQL.append("       '"+eMailAddr+"', ");
		insertSQL.append("       '"+phoneNum+"', ");
		insertSQL.append("       '"+mailListFlag+"', ");
		insertSQL.append("       '"+companyNameFlag+"', ");
		insertSQL.append("       '"+addressFlag+"', ");
		insertSQL.append("       '"+faxNumFlag+"', ");
		insertSQL.append("       '"+department+"', ");
		insertSQL.append("       '"+refBasis+"') ");
		
		Statement stmt2 = conn.createStatement();
		stmt2.executeQuery(insertSQL.toString());
		
		conn.commit();
		
		if(stmt2!=null)
			stmt2.close();
		if(conn!=null)
			conn.close();
	}else if("save".equals(processType)){
		StringBuffer selectSQL = new StringBuffer();
		selectSQL.append("update stx_oc_project_receive_list ");
		selectSQL.append("   set project = '"+project+"' , ");
		selectSQL.append("       drawing_type = '"+drawingType+"' , ");
		selectSQL.append("       receive_type = '"+refType+"' , ");
		selectSQL.append("       priority = '"+workRank+"' , ");
		selectSQL.append("       receiver = '"+mailList+"' , ");
		selectSQL.append("       position = '"+position+"' , ");
		selectSQL.append("       company = '"+companyName+"' , ");
		selectSQL.append("       address = '"+address+"' , ");
		selectSQL.append("       fax = '"+faxNum+"' , ");
		selectSQL.append("       email = '"+eMailAddr+"' , ");
		selectSQL.append("       phone = '"+phoneNum+"' , ");
		selectSQL.append("       receiver_flag = '"+mailListFlag+"' , ");
		selectSQL.append("       company_flag = '"+companyNameFlag+"' , ");
		selectSQL.append("       address_flag = '"+addressFlag+"' , ");
		selectSQL.append("       fax_flag = '"+faxNumFlag+"' , ");
		selectSQL.append("       department = '"+department+"' , ");
		selectSQL.append("       basis = '"+refBasis+"' ");
		selectSQL.append(" where project = '"+project+"' ");
		selectSQL.append("   and drawing_type = '"+drawingType+"' ");
		selectSQL.append("   and receive_type = '"+refType+"' ");
		selectSQL.append("   and receiver = '"+mailList+"' ");
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(selectSQL.toString());
		
		if(stmt!=null)
			stmt.close();
		if(conn!=null)
			conn.close();
	}else if("del".equals(processType)){
		StringBuffer deleteSQL = new StringBuffer();
		deleteSQL.append("delete ");
		deleteSQL.append("  from stx_oc_project_receive_list ");
		deleteSQL.append(" where project = '"+project+"'");
		deleteSQL.append("   and drawing_type = '"+drawingType+"'");
		deleteSQL.append("   and receive_type = '"+refType+"' ");
		deleteSQL.append("   and receiver = '"+mailList+"' ");
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(deleteSQL.toString());
		
		conn.commit();
		
		if(stmt!=null)
			stmt.close();
		
		StringBuffer updateSQL = new StringBuffer();
		updateSQL.append("update stx_oc_project_receive_list ");
		updateSQL.append("   set priority = priority - 1 ");
		updateSQL.append(" where project = '"+project+"' ");
		updateSQL.append("   and drawing_type = '"+drawingType+"' ");
		updateSQL.append("   and receive_type = '"+refType+"' ");
		updateSQL.append("   and priority >= '"+workRank+"' ");
		
		Statement stmt2 = conn.createStatement();
		stmt2.executeQuery(updateSQL.toString());
		
		conn.commit();
		
		if(stmt2!=null)
			stmt2.close();
		if(conn!=null)
			conn.close();
	}
%>
	<%="Success"%>
	
	