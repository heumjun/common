<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
	String project = request.getParameter("project");
	String drawing = request.getParameter("drawing");
	
	String returnString = "";
	
	String projectNo		= "";
	String drawingNo		= "";
	String drawingTitle		= "";
	String drawingRev		= "";
	String drawingPlanStart = "";
	String drawingPlanFinish= "";
	String drawingActStart	= "";
	String drawingActFinish	= "";
	String ownerPlanStart	= "";
	String ownerPlanFinish	= "";
	String ownerActStart	= "";
	String ownerActFinish	= "";
	String classPlanStart	= "";
	String classPlanFinish	= "";
	String classActStart	= "";
	String classActFinish	= "";

	boolean makerDrawing = false;

	if(!("".equals(drawing) || drawing==null))
	{
		if(drawing.startsWith("V"))
		{
			makerDrawing = true;
		}
	}	
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	Statement stmt = conn.createStatement();
	
	StringBuffer selectDateSQL = new StringBuffer();
	selectDateSQL.append("SELECT DW.PROJECTNO, ");
	selectDateSQL.append("    SUBSTR(DW.ACTIVITYCODE, 1, 8) AS DWGCODE, ");
	selectDateSQL.append("    DW.DWGTITLE, ");
	selectDateSQL.append("    CASE WHEN (HC.DEPLOY_DATE IS NULL) THEN NULL ");
	selectDateSQL.append("         ELSE (F_GET_HARDCOPY_MAX_REV(DW.PROJECTNO, SUBSTR(DW.ACTIVITYCODE, 1, 8), HC.DEPLOY_DATE)) ");
	selectDateSQL.append("    END AS MAX_REVISION, ");

// 2012-10-10 : V 로 시작하는 도면 (Maker Drawing) 일 경우 일자 가져오는 부분이 틀려짐.  (주석은 DP 공정조회 상 보여지는 명칭임)
if(makerDrawing)
{
	selectDateSQL.append("    TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");         // PurchasingRequest Plan
	selectDateSQL.append("    TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");         // PurchasingOrder Plan
	selectDateSQL.append("    TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S, ");        // PurchasingRequest Action
	selectDateSQL.append("    TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_F, ");        // PurchasingOrder Action
	selectDateSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S, ");         // OwnerApp.Submit Plan  
	selectDateSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F, ");        // OwnerApp.Receive Plan
	selectDateSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S, ");        // OwnerApp.Submit Action
	selectDateSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F, ");       // OwnerApp.Receive Action
	selectDateSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S, ");         // OwnerApp.Submit Plan    (Maker Drawing은 Owner 정보만 존재함)
	selectDateSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F, ");        // OwnerApp.Receive Plan   (Maker Drawing은 Owner 정보만 존재함)
	selectDateSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S, ");        // OwnerApp.Submit Action  (Maker Drawing은 Owner 정보만 존재함)
	selectDateSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F ");        // OwnerApp.Receive Action (Maker Drawing은 Owner 정보만 존재함)
} else {
	selectDateSQL.append("    TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");         // DrawingStart Plan   
	selectDateSQL.append("    TO_CHAR(DW.PLANFINISHDATE, 'YYYY-MM-DD') AS DW_PLAN_F, ");        // DrawingFinish Plan
	selectDateSQL.append("    TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S, ");        // DrawingStart Action
	selectDateSQL.append("    TO_CHAR(DW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS DW_ACT_F, ");       // DrawingFinish Action
	selectDateSQL.append("    TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S, ");         // OwnerApp.Submit Plan
	selectDateSQL.append("    TO_CHAR(OW.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F, ");        // OwnerApp.Receive Plan
	selectDateSQL.append("    TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S, ");        // OwnerApp.Submit Action
	selectDateSQL.append("    TO_CHAR(OW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F, ");       // OwnerApp.Receive Action
	selectDateSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S, ");         // ClassApp.Submit Plan
	selectDateSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F, ");        // ClassApp.Receive Plan
	selectDateSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S, ");        // ClassApp.Submit Action
	selectDateSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F ");        // ClassApp.Receive Action
}
	selectDateSQL.append("  FROM PLM_ACTIVITY DW, ");
	selectDateSQL.append("    DCC_DWGDEPTCODE DEPT, ");
	selectDateSQL.append("    (SELECT A.PROJECTNO, A.ACTIVITYCODE, A.PLANSTARTDATE, A.PLANFINISHDATE, ");
	selectDateSQL.append("            A.ACTUALSTARTDATE, A.ACTUALFINISHDATE, A.DWGCATEGORY ");
	selectDateSQL.append("       FROM PLM_ACTIVITY A ");
	selectDateSQL.append("      WHERE A.WORKTYPE = 'OW' ");
	selectDateSQL.append("    ) OW, ");
	selectDateSQL.append("    (SELECT B.PROJECTNO, B.ACTIVITYCODE, B.PLANSTARTDATE, B.PLANFINISHDATE, ");
	selectDateSQL.append("            B.ACTUALSTARTDATE, B.ACTUALFINISHDATE, B.DWGCATEGORY ");
	selectDateSQL.append("       FROM PLM_ACTIVITY B ");
	selectDateSQL.append("      WHERE B.WORKTYPE = 'CL' ");
	selectDateSQL.append("    ) CL, ");
	selectDateSQL.append("    (SELECT C.PROJECTNO, C.ACTIVITYCODE, C.PLANSTARTDATE, C.PLANFINISHDATE, ");
	selectDateSQL.append("            C.ACTUALSTARTDATE, C.ACTUALFINISHDATE, C.DWGCATEGORY ");
	selectDateSQL.append("       FROM PLM_ACTIVITY C ");
	selectDateSQL.append("      WHERE C.WORKTYPE = 'RF' ");
	selectDateSQL.append("    ) RF, ");
	selectDateSQL.append("    (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.PLANFINISHDATE, ");
	selectDateSQL.append("            D.ACTUALSTARTDATE, D.ACTUALFINISHDATE, D.DWGCATEGORY, D.REFEVENT2 ");
	selectDateSQL.append("       FROM PLM_ACTIVITY D ");
	selectDateSQL.append("      WHERE D.WORKTYPE = 'WK' ");
	selectDateSQL.append("    ) WK, ");
	selectDateSQL.append("    ( ");
	selectDateSQL.append("    SELECT PROJECT_NO, DWG_CODE, MAX(REQUEST_DATE) AS DEPLOY_DATE ");
	selectDateSQL.append("      FROM PLM_HARDCOPY_DWG ");
	selectDateSQL.append("     GROUP BY PROJECT_NO, DWG_CODE ");
	selectDateSQL.append("    ) HC, ");
	selectDateSQL.append("    (SELECT STATE FROM PLM_SEARCHABLE_PROJECT ");
	selectDateSQL.append("      WHERE CATEGORY = 'PROGRESS' AND PROJECTNO = '"+project+"' ");
	selectDateSQL.append("    ) PP ");
	selectDateSQL.append(" WHERE DW.PROJECTNO = '"+project+"' ");
	selectDateSQL.append("   AND DW.PROJECTNO = OW.PROJECTNO(+) ");
	selectDateSQL.append("   AND DW.PROJECTNO = CL.PROJECTNO(+) ");
	selectDateSQL.append("   AND DW.PROJECTNO = RF.PROJECTNO(+) ");
	selectDateSQL.append("   AND DW.PROJECTNO = WK.PROJECTNO(+) ");
	selectDateSQL.append("   AND DW.DWGDEPTCODE = DEPT.DWGDEPTCODE(+) ");
	selectDateSQL.append("   AND DW.WORKTYPE = 'DW' ");
	selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(OW.ACTIVITYCODE(+), 1, 8) ");
	selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(CL.ACTIVITYCODE(+), 1, 8) ");
	selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(RF.ACTIVITYCODE(+), 1, 8) ");
	selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8) ");
	selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) like '"+drawing+"' ");
	selectDateSQL.append("   AND (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE DW.DWGCATEGORY END) = ");
	selectDateSQL.append("       (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE PP.STATE END) ");
	selectDateSQL.append("   AND DW.PROJECTNO = HC.PROJECT_NO(+) ");
	selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = HC.DWG_CODE(+) ");
	
	java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
	
	while(selectDateRset.next()){
		
		projectNo			= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
		drawingNo			= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
		drawingTitle		= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
		drawingRev			= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
		drawingPlanStart 	= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
		drawingPlanFinish	= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
		drawingActStart		= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
		drawingActFinish	= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
		ownerPlanStart		= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
		ownerPlanFinish		= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
		ownerActStart		= selectDateRset.getString(11)==null?"":selectDateRset.getString(11);
		ownerActFinish		= selectDateRset.getString(12)==null?"":selectDateRset.getString(12);
		classPlanStart		= selectDateRset.getString(13)==null?"":selectDateRset.getString(13);
		classPlanFinish		= selectDateRset.getString(14)==null?"":selectDateRset.getString(14);
		classActStart		= selectDateRset.getString(15)==null?"":selectDateRset.getString(15);
		classActFinish		= selectDateRset.getString(16)==null?"":selectDateRset.getString(16);
	}
	
	//System.out.println(projectNo);
	//System.out.println(drawingNo);
	//System.out.println(drawingTitle);
	//System.out.println(drawingRev);
	//System.out.println(drawingPlanStart);
	//System.out.println(drawingPlanFinish);
	//System.out.println(drawingActStart);
	//System.out.println(drawingActFinish);
	//System.out.println(ownerPlanStart);
	//System.out.println(ownerPlanFinish);
	//System.out.println(ownerActStart);
	//System.out.println(ownerActFinish);
	//System.out.println(classPlanStart);
	//System.out.println(classPlanFinish);
	//System.out.println(classActStart);
	//System.out.println(classActFinish);
	
	returnString = projectNo 
			 +"|"+ drawingNo 
			 +"|"+ drawingTitle 
			 +"|"+ drawingRev 
			 +"|"+ drawingPlanStart 
			 +"|"+ drawingPlanFinish 
			 +"|"+ drawingActStart 
			 +"|"+ drawingActFinish
			 +"|"+ ownerPlanStart 
			 +"|"+ ownerPlanFinish 
			 +"|"+ ownerActStart 
			 +"|"+ ownerActFinish
			 +"|"+ classPlanStart 
			 +"|"+ classPlanFinish 
			 +"|"+ classActStart 
			 +"|"+ classActFinish;
	
	//System.out.println("~~~returnString  =  "+returnString);
	%>
	
	<%=returnString %>
	
	