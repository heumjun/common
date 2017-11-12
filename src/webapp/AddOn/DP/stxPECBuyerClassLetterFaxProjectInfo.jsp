<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>

<%--========================== JSP =========================================--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
	
	String project = request.getParameter("project");
	String drawingFlag = request.getParameter("drawingFlag");
	String ownerClass = request.getParameter("ownerClass");
	
	String returnString = "";
	
	String ct = "";
	String sc = "";
	String kl = "";
	String lc = "";
	String dl = "";
	
	String seriesProject = "";
	String masterProject = "";
	String ownerabbr = "";
	String shipSize = "";
	String shipType = "";
	String shipOwner = "";
	String shipClass = "";
	
	String docNum = "";
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	Statement stmt = conn.createStatement();
	
	StringBuffer selectDateSQL = new StringBuffer();
	selectDateSQL.append("select TO_CHAR(CONTRACTDATE, 'YYYY-MM-DD')CONTRACTDATE ");
	selectDateSQL.append("  	,TO_CHAR(SC, 'YYYY-MM-DD')CONTRACTDATE ");
	selectDateSQL.append("  	,TO_CHAR(KL, 'YYYY-MM-DD')CONTRACTDATE ");
	selectDateSQL.append("  	,TO_CHAR(LC, 'YYYY-MM-DD')CONTRACTDATE ");
	selectDateSQL.append("  	,TO_CHAR(DL, 'YYYY-MM-DD')CONTRACTDATE ");
	selectDateSQL.append("  	, DWGSERIESPROJECTNO ");
	if("owner".equals(ownerClass))
		selectDateSQL.append("  	, ownerabbr ");
	else if("class".equals(ownerClass))
		selectDateSQL.append("  	, class ");
	selectDateSQL.append("  	, shipsize ");
	selectDateSQL.append("  	, shiptype ");
	selectDateSQL.append("  	, owner ");
	selectDateSQL.append("  	, class ");
	selectDateSQL.append("  from lpm_newproject ");
	selectDateSQL.append(" where projectno = '"+project+"' ");
	selectDateSQL.append("   and caseno = '1' ");
	
	java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
	
	while(selectDateRset.next()){
		
		ct 				= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
		sc 				= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
		kl 				= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
		lc 				= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
		dl 				= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
		masterProject 	= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
		ownerabbr 		= (selectDateRset.getString(7)==null || selectDateRset.getString(7).equals("-"))?"":selectDateRset.getString(7);
		shipSize 		= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
		shipType 		= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
		shipOwner 		= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
		shipClass 		= (selectDateRset.getString(11)==null || selectDateRset.getString(11).equals("-"))?"":selectDateRset.getString(11);
		// class에 - 가 있을 경우 시리얼 딸때 에러가 남...
		
		
		//ct = ct.length()>10?ct.substring(0,10):ct;
		//sc = sc.length()>10?sc.substring(0,10):sc;
		//kl = kl.length()>10?kl.substring(0,10):kl;
		//lc = lc.length()>10?lc.substring(0,10):lc;
		//dl = dl.length()>10?dl.substring(0,10):dl;
	}
	
	StringBuffer selectSeriesSQL = new StringBuffer();
	selectSeriesSQL.append("select b.projectno ");
	selectSeriesSQL.append("  from LPM_NEWPROJECT a ");
	selectSeriesSQL.append("     , LPM_NEWPROJECT b ");
	selectSeriesSQL.append(" where a.CASENO = '1' ");
	selectSeriesSQL.append("   AND b.CASENO = '1' ");
	selectSeriesSQL.append("   AND a.DWGMHYN = 'Y' ");
	selectSeriesSQL.append("   AND b.DWGMHYN = 'Y' ");
	selectSeriesSQL.append("   AND a.projectno = '"+project+"' ");
	selectSeriesSQL.append("   and a.dwgseriesprojectno = b.dwgseriesprojectno ");
	selectSeriesSQL.append(" group by b.projectno ");
	
	java.sql.ResultSet selectSeriesRset = stmt.executeQuery(selectSeriesSQL.toString());
	
	while(selectSeriesRset.next()){
		
		if(seriesProject.equals(""))
			seriesProject = selectSeriesRset.getString(1)==null?"":selectSeriesRset.getString(1);
		else
			seriesProject += ","+(selectSeriesRset.getString(1)==null?"":selectSeriesRset.getString(1));
		
	}
	
	StringBuffer selectDocNumSQL = new StringBuffer();
	selectDocNumSQL.append("select to_char(nvl(max(to_number(substr(ref_no , instr(ref_no , '-' , 1 , 2)+1)))+1,1) , 'FM0000') ");
	selectDocNumSQL.append("  from stx_oc_document_list ");
	//selectDocNumSQL.append(" where project = (SELECT seriesprojectno ");
	//selectDocNumSQL.append("                    FROM LPM_NEWPROJECT a ");
	//selectDocNumSQL.append("                   WHERE a.CASENO = '1' ");
	//selectDocNumSQL.append("                     AND a.projectno = '"+project+"') ");
	//대표호선 기준 시리얼 넘버 부여
	//selectDocNumSQL.append(" where project in (select projectno ");
	//selectDocNumSQL.append("                 	 from lpm_newproject ");
	//selectDocNumSQL.append("                	where caseno = '1' ");
	//selectDocNumSQL.append("                  	  and DWGSERIESPROJECTNO = (SELECT DWGSERIESPROJECTNO ");
	//selectDocNumSQL.append("                      	                          FROM LPM_NEWPROJECT a ");
	//selectDocNumSQL.append("                          	                  	 WHERE a.CASENO = '1' ");
	//selectDocNumSQL.append("                              	                   AND a.projectno = '"+project+"')) ");
	//문서호선 기준 시리얼 넘버 부여
	selectDocNumSQL.append(" where project in (select project ");
	selectDocNumSQL.append("                 	 from stx_oc_project_send_number ");
	selectDocNumSQL.append("                 	where DOC_PROJECT = (SELECT DOC_PROJECT ");
	selectDocNumSQL.append("                 	                       FROM stx_oc_project_send_number a ");
	selectDocNumSQL.append("                 	                      WHERE a.project = '"+project+"')) ");
	selectDocNumSQL.append("   and send_receive_type = 'send' ");
	selectDocNumSQL.append("   and instr(ref_no , '-' , 1 , 2) > 0 ");
	selectDocNumSQL.append("   and owner_class_type = '"+ownerClass+"' ");
	
	java.sql.ResultSet selectDocNumRset = stmt.executeQuery(selectDocNumSQL.toString());
	
	while(selectDocNumRset.next()){
		docNum = selectDocNumRset.getString(1)==null?"":selectDocNumRset.getString(1);
	}
	
	StringBuffer selectReceiverSQL = new StringBuffer();
	selectReceiverSQL.append("select RECEIVE_TYPE , PRIORITY , RECEIVER , FAX ");
	selectReceiverSQL.append("  from stx_oc_project_receive_list ");
	selectReceiverSQL.append(" where project = '"+project+"' ");
	selectReceiverSQL.append("   and drawing_type = '"+("drawing".equals(drawingFlag)?"도면":"비도면")+"' ");
	selectReceiverSQL.append("   and receiver_flag = 'Y' ");
	selectReceiverSQL.append(" order by priority ");
	
	//System.out.println(selectReceiverSQL.toString());
	
	java.sql.ResultSet selectReceiverRset = stmt.executeQuery(selectReceiverSQL.toString());
	
	String receiverInfo = "";
	while(selectReceiverRset.next()){
		
		//System.out.println(selectReceiverRset.getString(1));
		//System.out.println(selectReceiverRset.getString(2));
		//System.out.println(selectReceiverRset.getString(3));
		//System.out.println(selectReceiverRset.getString(4));
		
		if(receiverInfo.equals("")){
			receiverInfo =  selectReceiverRset.getString(1)
					+ "," + selectReceiverRset.getString(2)
					+ "," + selectReceiverRset.getString(3)
					+ "," + selectReceiverRset.getString(4)
							;
		}else{
			receiverInfo += "^" + ( selectReceiverRset.getString(1)
							+ "," + selectReceiverRset.getString(2)
							+ "," + selectReceiverRset.getString(3)
							+ "," + selectReceiverRset.getString(4))
							;
		}
	}
	
	if("".equals(receiverInfo) && "noDrawing".equals(drawingFlag)){
		StringBuffer selectReceiverSQL2 = new StringBuffer();
		selectReceiverSQL2.append("select RECEIVE_TYPE , PRIORITY , RECEIVER , FAX ");
		selectReceiverSQL2.append("  from stx_oc_project_receive_list ");
		selectReceiverSQL2.append(" where project = '"+project+"' ");
		selectReceiverSQL2.append("   and drawing_type = '도면' ");
		selectReceiverSQL2.append("   and receiver_flag = 'Y' ");
		selectReceiverSQL2.append(" order by priority ");
		
		//System.out.println(selectReceiverSQL.toString());
		
		java.sql.ResultSet selectReceiverRset2 = stmt.executeQuery(selectReceiverSQL2.toString());
		
		while(selectReceiverRset2.next()){
			
			//System.out.println(selectReceiverRset2.getString(1));
			//System.out.println(selectReceiverRset2.getString(2));
			//System.out.println(selectReceiverRset2.getString(3));
			//System.out.println(selectReceiverRset2.getString(4));
			
			if(receiverInfo.equals("")){
				receiverInfo =  selectReceiverRset2.getString(1)
						+ "," + selectReceiverRset2.getString(2)
						+ "," + selectReceiverRset2.getString(3)
						+ "," + selectReceiverRset2.getString(4)
								;
			}else{
				receiverInfo += "^" + ( selectReceiverRset2.getString(1)
								+ "," + selectReceiverRset2.getString(2)
								+ "," + selectReceiverRset2.getString(3)
								+ "," + selectReceiverRset2.getString(4))
								;
			}
		}
	}
	
	if("".equals(receiverInfo)){
		receiverInfo = ",,,";
	}
	
	//System.out.println(ct);
	//System.out.println(sc);
	//System.out.println(kl);
	//System.out.println(lc);
	//System.out.println(dl);
	
	//System.out.println(masterProject);
	
	//System.out.println(seriesProject);
	
	//System.out.println(ownerabbr);
	
	//System.out.println(shipSize+","+shipType+","+shipOwner+","+shipClass);
	
	returnString = ct +"|"+ sc +"|"+ kl +"|"+ lc +"|"+ dl +"|"+ masterProject +"|"+ seriesProject +"|"+ ownerabbr +"|"+ shipSize+" "+shipType +"|"+ shipOwner +"|"+ shipClass +"|"+ docNum +"|"+ receiverInfo;
	//System.out.println(returnString);
	%>
	
	<%=returnString %>
	
	