<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 - 납기정보 확인화면
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterSearchEquipDate_SP.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>

<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	private ArrayList searchEquipDate(String projectNo, String deptCode) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
        if (StringUtil.isNullString(deptCode)) throw new Exception("deptCode is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

        try {
			conn = DBConnect.getDBConnection("ERP_APPS"); //SDPS
            StringBuffer drawingInfoQuery = new StringBuffer();

            drawingInfoQuery.append(" SELECT PR_INFO.PROJECTNO,                                                                                                                                            \n");
            drawingInfoQuery.append("        PR_INFO.DRAWING_NO,                                                                                                                                           \n");
            drawingInfoQuery.append("        PR_INFO.DRAWING_TITLE,                                                                                                                                        \n");
            drawingInfoQuery.append("        PR_INFO.EQUIP_DATE_1ST,                                                                                                                                       \n");
            drawingInfoQuery.append("        PR_INFO.EQUIP_DATE_2ST,                                                                                                                                       \n");
            drawingInfoQuery.append("        PR_INFO.EQUIP_DATE_3ST,                                                                                                                                       \n");
            drawingInfoQuery.append("        PR_INFO.EQUIP_DATE_4ST,                                                                                                                                       \n");
            drawingInfoQuery.append("        PR_INFO.EQUIP_DATE_5ST,                                                                                                                                       \n");
            drawingInfoQuery.append("        STX_PO_EQUIP_NEED_FNC('DELIVERED', PLL.LINE_LOCATION_ID, PLL.PO_HEADER_ID) PO_DELIVERED,                                                                      \n");
            drawingInfoQuery.append("        TO_CHAR((                                                                                                                                                     \n");
            drawingInfoQuery.append("                       CASE                                                                                                                                           \n");
            drawingInfoQuery.append("                         WHEN NVL(STX_PO_EQUIP_NEED_FNC('FIRST', PLL.LINE_LOCATION_ID, PLL.PO_HEADER_ID), 0) = 0 THEN NVL(PLL.NEED_BY_DATE, PR_INFO.NEED_BY_DATE)     \n");
            drawingInfoQuery.append("                         ELSE (SELECT /*+FIRST_ROWS*/                                                                                                                 \n");
            drawingInfoQuery.append("                  NVL(SPR.NEED_BY_DATE, NVL(PLL.NEED_BY_DATE, PR_INFO.NEED_BY_DATE))                                                                                  \n");
            drawingInfoQuery.append("                FROM   STX_PO_RESCHEDULE_HISTORY SPR                                                                                                                  \n");
            drawingInfoQuery.append("                WHERE  SPR.PO_HEADER_ID = PLL.PO_HEADER_ID                                                                                                            \n");
            drawingInfoQuery.append("                AND    SPR.PO_LINE_ID = PLL.PO_LINE_ID                                                                                                                \n");
            drawingInfoQuery.append("                AND    SPR.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID                                                                                                    \n");
            drawingInfoQuery.append("                AND    SPR.CREATION_DATE = (SELECT MIN(SPRH.CREATION_DATE)                                                                                            \n");
            drawingInfoQuery.append("                        FROM   STX_PO_RESCHEDULE_HISTORY SPRH                                                                                                         \n");
            drawingInfoQuery.append("                        WHERE  SPRH.PO_HEADER_ID = SPR.PO_HEADER_ID                                                                                                   \n");
            drawingInfoQuery.append("                        AND    SPRH.LINE_LOCATION_ID = SPR.LINE_LOCATION_ID ) )                                                                                       \n");
            drawingInfoQuery.append("                       END),'YYYY-MM-DD') FIRST_NEED_DATE ,                                                                                                           \n");
            drawingInfoQuery.append("        TO_CHAR((                                                                                                                                                     \n");
            drawingInfoQuery.append("                       CASE                                                                                                                                           \n");
            drawingInfoQuery.append("                         WHEN NVL(STX_PO_EQUIP_NEED_FNC('FIRST', PLL.LINE_LOCATION_ID, PLL.PO_HEADER_ID), 0) > 0 THEN (SELECT /*+FIRST_ROWS*/                         \n");
            drawingInfoQuery.append("                  SPR.NEED_BY_DATE                                                                                                                                    \n");
            drawingInfoQuery.append("                FROM   STX_PO_RESCHEDULE_HISTORY SPR                                                                                                                  \n");
            drawingInfoQuery.append("                WHERE  SPR.PO_HEADER_ID = PLL.PO_HEADER_ID                                                                                                            \n");
            drawingInfoQuery.append("                AND    SPR.PO_LINE_ID = PLL.PO_LINE_ID                                                                                                                \n");
            drawingInfoQuery.append("                AND    SPR.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID                                                                                                    \n");
            drawingInfoQuery.append("                AND    SPR.CREATION_DATE = (SELECT MAX(SPRH.CREATION_DATE)                                                                                            \n");
            drawingInfoQuery.append("                        FROM   STX_PO_RESCHEDULE_HISTORY SPRH                                                                                                         \n");
            drawingInfoQuery.append("                        WHERE  SPRH.PO_HEADER_ID = SPR.PO_HEADER_ID                                                                                                   \n");
            drawingInfoQuery.append("                        AND    SPRH.LINE_LOCATION_ID = SPR.LINE_LOCATION_ID ) )                                                                                       \n");
            drawingInfoQuery.append("                       END),'YYYY-MM-DD') CHANGE_NEED_DATE ,                                                                                                          \n");
            drawingInfoQuery.append("        TO_CHAR((                                                                                                                                                     \n");
            drawingInfoQuery.append("                       CASE                                                                                                                                           \n");
            drawingInfoQuery.append("                         WHEN STX_PO_EQUIP_NEED_FNC('JOB', PLL.LINE_LOCATION_ID, PLL.PO_HEADER_ID) = 'Y' THEN (SELECT NVL(SPR.NEED_BY_DATE, PLL.NEED_BY_DATE)         \n");
            drawingInfoQuery.append("                FROM   STX_PO_RESCHEDULE_HISTORY SPR                                                                                                                  \n");
            drawingInfoQuery.append("                WHERE  SPR.PO_HEADER_ID = PLL.PO_HEADER_ID                                                                                                            \n");
            drawingInfoQuery.append("                AND    SPR.PO_LINE_ID = PLL.PO_LINE_ID                                                                                                                \n");
            drawingInfoQuery.append("                AND    SPR.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID                                                                                                    \n");
            drawingInfoQuery.append("                AND    SPR.CREATION_DATE = (SELECT MIN(SPRH.CREATION_DATE)                                                                                            \n");
            drawingInfoQuery.append("                        FROM   STX_PO_RESCHEDULE_HISTORY SPRH                                                                                                         \n");
            drawingInfoQuery.append("                        WHERE  SPRH.PO_HEADER_ID = SPR.PO_HEADER_ID                                                                                                   \n");
            drawingInfoQuery.append("                        AND    SPRH.LINE_LOCATION_ID = SPR.LINE_LOCATION_ID ) )                                                                                       \n");
            drawingInfoQuery.append("                       END),'YYYY-MM-DD') JOB_FIRST_NEED ,                                                                                                            \n");
            drawingInfoQuery.append("        TO_CHAR((                                                                                                                                                     \n");
            drawingInfoQuery.append("                       CASE                                                                                                                                           \n");
            drawingInfoQuery.append("                         WHEN STX_PO_EQUIP_NEED_FNC('JOB', PLL.LINE_LOCATION_ID, PLL.PO_HEADER_ID) = 'Y' THEN (SELECT SPR.NEED_BY_DATE                                \n");
            drawingInfoQuery.append("                FROM   STX_PO_RESCHEDULE_HISTORY SPR                                                                                                                  \n");
            drawingInfoQuery.append("                WHERE  SPR.PO_HEADER_ID = PLL.PO_HEADER_ID                                                                                                            \n");
            drawingInfoQuery.append("                AND    SPR.PO_LINE_ID = PLL.PO_LINE_ID                                                                                                                \n");
            drawingInfoQuery.append("                AND    SPR.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID                                                                                                    \n");
            drawingInfoQuery.append("                AND    SPR.CREATION_DATE = (SELECT MAX(SPRH.CREATION_DATE)                                                                                            \n");
            drawingInfoQuery.append("                        FROM   STX_PO_RESCHEDULE_HISTORY SPRH                                                                                                         \n");
            drawingInfoQuery.append("                        WHERE  SPRH.PO_HEADER_ID = SPR.PO_HEADER_ID                                                                                                   \n");
            drawingInfoQuery.append("                        AND    SPRH.LINE_LOCATION_ID = SPR.LINE_LOCATION_ID ) )                                                                                       \n");
            drawingInfoQuery.append("                       END),'YYYY-MM-DD') JOB_LAST_NEED                                                                                                               \n");
            drawingInfoQuery.append("  FROM                                                                                                                                                                \n");
            drawingInfoQuery.append("	(                                                                                                                                                                  \n");
            drawingInfoQuery.append("	    SELECT AA.*,                                                                                                                                                   \n");
            drawingInfoQuery.append("		 (SELECT MIN(LINE_LOCATION_ID)                                                                                                                                 \n");
            drawingInfoQuery.append("		     FROM PO_REQUISITION_LINES_ALL PRLA                                                                                                                        \n");
            drawingInfoQuery.append("		    WHERE PRLA.REQUISITION_HEADER_ID = AA.REQUISITION_HEADER_ID                                                                                                \n");
            drawingInfoQuery.append("		      AND NVL(PRLA.CANCEL_FLAG, 'N') <> 'Y' ) LINE_LOCATION_ID,                                                                                                \n");
            drawingInfoQuery.append("		 (SELECT MIN(PRLA.NEED_BY_DATE)                                                                                                                                \n");
            drawingInfoQuery.append("			FROM   PO_REQUISITION_LINES_ALL PRLA                                                                                                                       \n");
            drawingInfoQuery.append("			WHERE  PRLA.REQUISITION_HEADER_ID = AA.REQUISITION_HEADER_ID                                                                                               \n");
            drawingInfoQuery.append("			AND    NVL(PRLA.CANCEL_FLAG, 'N') <> 'Y' ) NEED_BY_DATE                                                                                                    \n");
            drawingInfoQuery.append("	    FROM (                                                                                                                                                         \n");
            drawingInfoQuery.append("		SELECT  DW.PROJECTNO                                    AS PROJECTNO                                                                                           \n");
            drawingInfoQuery.append("		       ,SUBSTR(DW.ACTIVITYCODE, 1, 8)                   AS DRAWING_NO                                                                                          \n");
            drawingInfoQuery.append("		       ,DW.DWGTITLE                                     AS DRAWING_TITLE                                                                                       \n");
            drawingInfoQuery.append("		       ,TO_CHAR(SPEKV.EQUIP_DATE_1ST, 'YYYY-MM-DD')     AS EQUIP_DATE_1ST                                                                                      \n");
            drawingInfoQuery.append("		       ,TO_CHAR(SPEKV.EQUIP_DATE_2ST, 'YYYY-MM-DD')     AS EQUIP_DATE_2ST                                                                                      \n");
            drawingInfoQuery.append("		       ,TO_CHAR(SPEKV.EQUIP_DATE_3ST, 'YYYY-MM-DD')     AS EQUIP_DATE_3ST                                                                                      \n");
            drawingInfoQuery.append("		       ,TO_CHAR(SPEKV.EQUIP_DATE_4ST, 'YYYY-MM-DD')     AS EQUIP_DATE_4ST                                                                                      \n");
            drawingInfoQuery.append("		       ,TO_CHAR(SPEKV.EQUIP_DATE_5ST, 'YYYY-MM-DD')     AS EQUIP_DATE_5ST                                                                                      \n");
            drawingInfoQuery.append("		       ,(SELECT MAX(REQUISITION_HEADER_ID)                                                                                                                     \n");
            drawingInfoQuery.append("			   FROM STX_PO_EQUIPMENT_DP      SPED                                                                                                                      \n");
            drawingInfoQuery.append("			  WHERE SPED.PROJECT_NUMBER = DW.PROJECTNO                                                                                                                 \n");
            drawingInfoQuery.append("			    AND SPED.DRAWING_NO= SUBSTR(DW.ACTIVITYCODE, 1, 8)                                                                                                     \n");
            drawingInfoQuery.append("			    AND SPED.ORIGINAL_PR_FLAG = 'Y'                                                                                                                        \n");
            drawingInfoQuery.append("			) REQUISITION_HEADER_ID                                                                                                                                    \n");
            drawingInfoQuery.append("		 FROM   PLM_ACTIVITY@STXDP.STXSHIP.CO.KR                    DW                                                                                                 \n");
            drawingInfoQuery.append("		       ,DCC_DEPTCODE@STXDP.STXSHIP.CO.KR                    DDP                                                                                                \n");
            drawingInfoQuery.append("		       ,DCC_DWGDEPTCODE@STXDP.STXSHIP.CO.KR                 DWG_DEPT                                                                                           \n");           
            drawingInfoQuery.append("		       ,PLM_VENDOR_DWG_PR_INFO@STXDP.STXSHIP.CO.KR          B                                                                                                  \n");
            drawingInfoQuery.append("		       ,STX_PO_EQUIPMENT_KEY_V   SPEKV                                                                                                                         \n");
            drawingInfoQuery.append("		 WHERE  1 = 1                                                                                                                                                  \n");
            drawingInfoQuery.append("		   AND  DW.WORKTYPE = 'DW'                                                                                                                                     \n");     
            drawingInfoQuery.append("		   AND  DW.DWGCATEGORY = 'B'                                                                                                                                   \n");      
            drawingInfoQuery.append("		   AND  DW.DWGTYPE = 'V'                                                                                                                                       \n");          
            drawingInfoQuery.append("		   AND  DWG_DEPT.DWGDEPTCODE = DDP.DWGDEPTCODE                                                                                                                 \n");
            drawingInfoQuery.append("		   AND  DW.DWGDEPTCODE = DWG_DEPT.DWGDEPTCODE                                                                                                                  \n");
            drawingInfoQuery.append("		   AND  SUBSTR(DW.ACTIVITYCODE, 1, 8) = B.DWG_CODE                                                                                                             \n");
            drawingInfoQuery.append("		   AND  B.PR_REQ_YN ='Y'                                                                                                                                       \n");
            drawingInfoQuery.append("		   AND  INSTR(DW.DWGTITLE, '(BUYER SUPPLY)')=0                                                                                                                 \n");
            drawingInfoQuery.append("		   AND  SUBSTR(DW.ACTIVITYCODE, 1, 8) = SPEKV.DRAWING_NO(+)                                                                                                    \n");
            drawingInfoQuery.append("		   AND  DW.PROJECTNO = SPEKV.PROJECTNO(+)                                                                                                                      \n");
            drawingInfoQuery.append("		   AND  DW.PROJECTNO = '"+projectNo+"'                                                                                                                         \n");
            drawingInfoQuery.append("		   AND  DDP.DEPTCODE = '"+deptCode+"'                                                                                                                          \n");
            drawingInfoQuery.append("		 ORDER BY DW.ACTIVITYCODE                                                                                                                                      \n");
            drawingInfoQuery.append("		 ) AA                                                                                                                                                          \n");
            drawingInfoQuery.append("	)PR_INFO,                                                                                                                                                          \n");
            drawingInfoQuery.append("	PO_LINE_LOCATIONS_ALL PLL                                                                                                                                          \n");
            drawingInfoQuery.append(" WHERE PR_INFO.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID(+)                                                                                                             \n");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(drawingInfoQuery.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();                
				resultMap.put("PROJECT_NO", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("DRAWING_NO", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("DRAWING_TITLE", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("EQUIP_DATE_1ST", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("EQUIP_DATE_2ST", rset.getString(5) == null ? "" : rset.getString(5));
                resultMap.put("EQUIP_DATE_3ST", rset.getString(6) == null ? "" : rset.getString(6));
                resultMap.put("EQUIP_DATE_4ST", rset.getString(7) == null ? "" : rset.getString(7));
                resultMap.put("EQUIP_DATE_5ST", rset.getString(8) == null ? "" : rset.getString(8));
                resultMap.put("PO_DELIVERED", rset.getString(9) == null ? "" : rset.getString(9));
                resultMap.put("FIRST_NEED_DATE", rset.getString(10) == null ? "" : rset.getString(10));
                resultMap.put("CHANGE_NEED_DATE", rset.getString(11) == null ? "" : rset.getString(11));
                resultMap.put("JOB_FIRST_NEED", rset.getString(12) == null ? "" : rset.getString(12));
                resultMap.put("JOB_LAST_NEED", rset.getString(13) == null ? "" : rset.getString(13));
                resultArrayList.add(resultMap);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return resultArrayList;
    }

%>


<%--========================== JSP =========================================--%>
<%
    String projectNo = emxGetParameter(request, "projectNo");
   // String drawingNo = emxGetParameter(request, "drawingNo"); 

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String inputMakerListYN = StringUtil.setEmptyExt(emxGetParameter(request, "inputMakerListYN"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));

    //String personId = context.getUser();
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String personId = (String)loginUser.get("user_id");      

    String errStr = "";

    ArrayList equipDateList = null;

    try {

        equipDateList = searchEquipDate(projectNo, deptCode); 
    }
    catch (Exception e) {
        errStr = e.toString();
    }

%>


<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE> 
.hintstyle {   
    position:absolute; 
    word-break:break-all;        
    background:#EEEEEE;   
    border:1px solid black;   
    padding:2px;   
} 
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE> 


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 도면 Title 부분 MouseOver 시 도면 Title Full Text를 힌트 형태로 표시
    var hintcontainer = null;   
    function showhint(obj, txt) {
       if (txt==null || txt=="") return;
       if (hintcontainer == null) {   
          hintcontainer = document.createElement("div");   
          hintcontainer.className = "hintstyle";   
          document.body.appendChild(hintcontainer);   
       }   
       obj.onmouseout = hidehint;   
       obj.onmousemove = movehint;   
       hintcontainer.innerHTML = txt;   
    }   
    function movehint(e) {   
        if (!e) e = event; // line for IE compatibility   
        hintcontainer.style.top =  (e.clientY + document.documentElement.scrollTop + 2) + "px";   
        hintcontainer.style.left = (e.clientX + document.documentElement.scrollLeft + 10) + "px";   
        hintcontainer.style.display = "";   
    }   
    function hidehint() {   
       hintcontainer.style.display = "none";   
    }


</script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#f5f5f5">
<form name="frmEquipItemPurchasingManagementPRAddition" method="post">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="1070" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>납기 절점 정보.</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="1070" cellspacing="1" cellpadding="0" bgcolor="#cccccc" style="table-layout:fixed;">
        <tr height="22">           
            <td class="td_standardBold" style="background-color:#336699;" width="5%" rowspan="2"><font color="#ffffff">Project</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%" rowspan="2"><font color="#ffffff">도면 No.</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="20%" rowspan="2"><font color="#ffffff">도면 Title</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="14%" colspan="2"><font color="#ffffff">표준 납기</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="14%" colspan="2"><font color="#ffffff">생산(JOB) 납기</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="5%" rowspan="2"><font color="#ffffff">입고현황</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="35%" colspan="5"><font color="#ffffff">선적 차주/일자</font></td>
        </tr>
        <tr height="22">           
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">최초</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">변경</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">최초</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">변경</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">1차</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">2차</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">3차</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">4차</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">5차</font></td>
        </tr>
    </table>

        <div STYLE="width:1070; height:320; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="1070" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc" style="table-layout:fixed;">         
            <%

            //for(int i=0; i<equipDateList.size(); i++)
            for(int i=0; i<equipDateList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map equipDateMap = (Map)equipDateList.get(i);
                String project_no = (String)equipDateMap.get("PROJECT_NO");
                String drawing_no = (String)equipDateMap.get("DRAWING_NO");
                String drawing_title = (String)equipDateMap.get("DRAWING_TITLE");
                String equip_date_1st = (String)equipDateMap.get("EQUIP_DATE_1ST");
                String equip_date_2st = (String)equipDateMap.get("EQUIP_DATE_2ST");
                String equip_date_3st = (String)equipDateMap.get("EQUIP_DATE_3ST");
                String equip_date_4st = (String)equipDateMap.get("EQUIP_DATE_4ST");
                String equip_date_5st = (String)equipDateMap.get("EQUIP_DATE_5ST");
                String po_delivered = (String)equipDateMap.get("PO_DELIVERED");
                String first_need_date = (String)equipDateMap.get("FIRST_NEED_DATE");
                String change_need_date = (String)equipDateMap.get("CHANGE_NEED_DATE");
                String job_first_need = (String)equipDateMap.get("JOB_FIRST_NEED");
                String job_last_need = (String)equipDateMap.get("JOB_LAST_NEED");


                String dwgTitleHint = replaceAmpAll(drawing_title, "'", "＇");

                
             %>        

                <tr height="25" bgcolor="#f5f5f5">                    
                    <td class="td_standard" width="5%"><%=project_no%></td>
                    <td class="td_standard" width="7%"><%=drawing_no%></td>
                    <td class="td_standardLeft" width="20%" onmouseover="showhint(this, '<%=dwgTitleHint%>');">&nbsp;<%=drawing_title%></td>
                    <td class="td_standard" width="7%"><%=first_need_date%></td>
                    <td class="td_standard" width="7%"><%=change_need_date%></td>
                    <td class="td_standard" width="7%"><%=job_first_need%></td> 
                    <td class="td_standard" width="7%"><%=job_last_need%></td>                    
                    <td class="td_standard" width="5%"><%=po_delivered%></td>
                    <td class="td_standard" width="7%"><%=equip_date_1st%></td>
                    <td class="td_standard" width="7%"><%=equip_date_2st%></td>
                    <td class="td_standard" width="7%"><%=equip_date_3st%></td>
                    <td class="td_standard" width="7%"><%=equip_date_4st%></td>
                    <td class="td_standard" width="7%"><%=equip_date_5st%></td>
                </tr>
            <%
            }
            %>
        </table>
        </div>
<br>
<hr>   
    <table width="1070" cellspacing="1" cellpadding="1">
        <tr height="45">  
            <td style="text-align:right;">             
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>

<input type="hidden" name="projectNo" value="<%=projectNo%>">
<input type="hidden" name="loginID" value="<%=loginID%>">
<input type="hidden" name="deptCode" value="<%=deptCode%>">
<input type="hidden" name="inputMakerListYN" value="<%=inputMakerListYN%>">
</form>
</body>


</html>