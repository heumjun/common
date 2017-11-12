<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 추가 PR 등록화면
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterPRAddition_SP.jsp
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
	private ArrayList getDrawingInfo(String projectNo, String drawingNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
        if (StringUtil.isNullString(drawingNo)) throw new Exception("drawingNo is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

        try {
			conn = DBConnect.getDBConnection("SDPSP");
            StringBuffer drawingInfoQuery = new StringBuffer();

            drawingInfoQuery.append("SELECT A.*                                                                       \n"); 
            drawingInfoQuery.append("      ,TO_CHAR(                                                                  \n"); 
            drawingInfoQuery.append("               CASE                                                              \n"); 
            drawingInfoQuery.append("                   WHEN B.PND_REF_EVENT = 'SC' THEN C.SC + B.PND_LAG             \n"); 
            drawingInfoQuery.append("                   WHEN B.PND_REF_EVENT = 'KL' THEN C.KL + B.PND_LAG             \n"); 
            drawingInfoQuery.append("                   WHEN B.PND_REF_EVENT = 'FO' THEN C.FO + B.PND_LAG             \n"); 
            drawingInfoQuery.append("                   WHEN B.PND_REF_EVENT = 'LC' THEN C.LC + B.PND_LAG             \n"); 
            drawingInfoQuery.append("                   WHEN B.PND_REF_EVENT = 'DL' THEN C.DL + B.PND_LAG             \n"); 
            drawingInfoQuery.append("                   ELSE NULL                                                     \n"); 
            drawingInfoQuery.append("                END, 'YYYY-MM-DD') AS PND_DATE                                    \n"); 
            drawingInfoQuery.append("  FROM ( SELECT DW.PROJECTNO                   AS PROJECTNO                      \n");
            drawingInfoQuery.append("               ,SUBSTR(DW.ACTIVITYCODE, 1, 8)  AS DWGCODE                        \n");
            drawingInfoQuery.append("               ,DW.DWGTITLE                    AS DWGTITLE                       \n");
            drawingInfoQuery.append("               ,F_GET_PLM_PR_CATALOG(SUBSTR(DW.ACTIVITYCODE, 1, 8)) AS CATALOGS  \n");
            drawingInfoQuery.append("               ,TO_CHAR(OW.PLANFINISHDATE, 'YYYY-MM-DD') AS DR_DATE              \n");
            drawingInfoQuery.append("           FROM PLM_ACTIVITY DW                                                  \n"); 
            drawingInfoQuery.append("               ,(SELECT A.PROJECTNO                                              \n"); 
            drawingInfoQuery.append("                       ,A.ACTIVITYCODE                                           \n"); 
            drawingInfoQuery.append("                       ,A.PLANSTARTDATE                                          \n"); 
            drawingInfoQuery.append("                       ,A.PLANFINISHDATE                                         \n"); 
            drawingInfoQuery.append("                       ,A.ACTUALFINISHDATE                                       \n"); 
            drawingInfoQuery.append("                  FROM PLM_ACTIVITY A                                            \n");
            drawingInfoQuery.append("                 WHERE A.WORKTYPE = 'OW' ) OW                                    \n");
            drawingInfoQuery.append("          WHERE DW.PROJECTNO = '"+projectNo+"'                                   \n");
            drawingInfoQuery.append("            AND DW.WORKTYPE = 'DW'                                               \n");
            drawingInfoQuery.append("            AND DW.DWGCATEGORY = 'B'                                             \n");
            drawingInfoQuery.append("            AND DW.DWGTYPE = 'V'                                                 \n");
            drawingInfoQuery.append("            AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = '"+drawingNo+"'                  \n"); 
            drawingInfoQuery.append("            AND DW.PROJECTNO = OW.PROJECTNO(+)                                   \n");  
            drawingInfoQuery.append("            AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(OW.ACTIVITYCODE(+), 1, 8) \n");  
            drawingInfoQuery.append("        ) A                                                                      \n"); 
            drawingInfoQuery.append("       ,PLM_VENDOR_DWG_PR_INFO B                                                 \n");
            drawingInfoQuery.append("       ,LPM_NEWPROJECT C                                                         \n");
            drawingInfoQuery.append(" WHERE C.CASENO = '1'                                                            \n");
            drawingInfoQuery.append("   AND A.PROJECTNO = C.PROJECTNO                                                 \n");
            drawingInfoQuery.append("   AND A.DWGCODE = B.DWG_CODE                                                    \n");
            drawingInfoQuery.append("   AND B.PR_REQ_YN ='Y'                                                          \n");
            drawingInfoQuery.append("   AND INSTR(A.DWGTITLE, '(BUYER SUPPLY)')=0                                     \n");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(drawingInfoQuery.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("DRAWING_NO", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("DRAWING_TITLE", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("CATALOGS", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("DR_DATE", rset.getString(5) == null ? "" : rset.getString(5));
                resultMap.put("PND_DATE", rset.getString(6) == null ? "" : rset.getString(6));
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
    String drawingNo = emxGetParameter(request, "drawingNo"); 

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String inputMakerListYN = StringUtil.setEmptyExt(emxGetParameter(request, "inputMakerListYN"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));

    String drawingInfoHeader = "( "+projectNo+" - "+drawingNo+" )";

    //String personId = context.getUser();
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String personId = (String)loginUser.get("user_id");      

    String errStr = "";

    ArrayList drawingInfoList = null;

    try {

        drawingInfoList = getDrawingInfo(projectNo, drawingNo); 
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


    function searchPurchasingCode(index, catalogs, pndDate)
    {
        var itemcode_Qty = document.frmEquipItemPurchasingManagementPRAddition.elements['itemCode'+index].value;

        var url = "stxPECEquipItemRegisterSelectPurchasingCode_SP.jsp?index=" + index;
            url += "&catalogs="+catalogs;
            url += "&pndDate="+pndDate;
            url += "&itemcode_Qty="+itemcode_Qty;

        var nwidth = 700;
        var nheight = 500;
        var LeftPosition = (screen.availWidth-nwidth)/2;
        var TopPosition = (screen.availHeight-nheight)/2;

        var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

        window.open(url,"",sProperties);
    }



    function createPR_Addition()
    {
        
        var restrictedChars = "\"&";
        var mainForm = document.frmEquipItemPurchasingManagementPRAddition;

        // PR 중복 실행 방지
        var isDone = mainForm.createPRrunning.value;

        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }


        // 첨부SPEC이 없으면 PR 발행 방지
        fileName = mainForm.elements['fileName0'].value;
        if(fileName == "" || fileName==null)
        {
            alert("첨부 Spec이 없으면 PR을 발행할 수 없습니다.");
            return;
        }

        for(var index=0; index < fileName.length; index++)
        {
            if(restrictedChars.indexOf(fileName.charAt(index)) != -1)
            {
                alert("첨부 파일명에 &(Shift+7) 과 \" 를 사용할 수 없습니다.");
                return;
            }
        }
        
        // ITEM CODE, 수량 필수
        itemCode = mainForm.elements['itemCode0'].value;
        if(itemCode == "" || itemCode==null)
        {
            alert("선택된 Item Code 및 수량이 없습니다.");
            return;
        }

        if(confirm("PR 발행 시 30초 가량의 시간이 소요되오니, 결과가 나올때까지 기다려주십시오. 진행하시겠습니까?"))
        {
            mainForm.encoding = "multipart/form-data";
            mainForm.action = "stxPECEquipItemRegisterCreatePRAddition_SP.jsp";
            mainForm.createPRrunning.value = "TRUE";
            mainForm.submit();    
        }

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
           <td><br><font color="darkblue"><b>추가 PR 등록 화면.&nbsp;&nbsp;&nbsp;<%=drawingInfoHeader%></b></font> </td>
       </tr>
    </table>
    <br>

    <table width="1070" cellspacing="1" cellpadding="0" bgcolor="#cccccc" style="table-layout:fixed;">
        <tr height="25">           
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">Project</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="8%"><font color="#ffffff">도면 No.</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="28%"><font color="#ffffff">도면 Title</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="12%"><font color="#ffffff">Catalog</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">Item Code</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="30%"><font color="#ffffff">첨부 Spec.</font></td>
        </tr>
    </table>

        <div STYLE="width:1070; height:200; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="1070" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc" style="table-layout:fixed;">         
            <%

            //for(int i=0; i<drawingInfoList.size(); i++)
            for(int i=0; i<1; i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map drawingInfoMap = (Map)drawingInfoList.get(i);
                String project_no = (String)drawingInfoMap.get("PROJECT_NO");
                String drawing_no = (String)drawingInfoMap.get("DRAWING_NO");
                String drawing_title = (String)drawingInfoMap.get("DRAWING_TITLE");
                String catalogs = (String)drawingInfoMap.get("CATALOGS");
                String dr_date = (String)drawingInfoMap.get("DR_DATE");
                String pnd_date = (String)drawingInfoMap.get("PND_DATE");

                String dwgTitleHint = replaceAmpAll(drawing_title, "'", "＇");

                
             %>        

                <tr height="40" bgcolor="#f5f5f5">                    
                    <td class="td_standard" width="7%"><%=project_no%></td>
                    <td class="td_standard" width="8%">
                        <input type="hidden" name="drawingNo<%=i%>" value="<%=drawing_no%>"><%=drawing_no%></td>
                    <td class="td_standardLeft" width="28%" onmouseover="showhint(this, '<%=dwgTitleHint%>');">
                        <input type="hidden" name="drawingTitle<%=i%>" value="<%=drawing_title%>">&nbsp;<%=drawing_title%></td>
                    <td class="td_standard" width="12%" onmouseover="showhint(this, '<%=catalogs%>');"><%=catalogs%></td>
                        <input type="hidden" name="pndDate<%=i%>" value="<%=pnd_date%>"> 
                    <td class="td_standard" width="15%" bgcolor="#fff0f5" style="cursor:hand;" onmouseover="showhint(this, frmEquipItemPurchasingManagementPRAddition.itemCodeView<%=i%>.value);" onclick="searchPurchasingCode('<%=i%>','<%=catalogs%>','<%=pnd_date%>');" >
                        <input name="itemCodeView<%=i%>" value="" class="input_noBorder" style="width:130; height:20;background-color:#fff0f5;">
                        <input type="hidden" name="itemCode<%=i%>" value="">
                    </td>
                    <td class="td_standard" width="30%"><input type="file" name="fileName<%=i%>" style="width:300;" onKeyDown="return false"></td>
                    <input type="hidden" name="dr_date<%=i%>" value="<%=dr_date%>">
                </tr>
            <%
            }
            %>
        </table>
        </div>
<br><br>
<hr>   
    <table width="1070" cellspacing="1" cellpadding="1">
        <tr height="45">
            <td width="900" style="text-align:right;">
            <input type="button" name="buttonPRCreate" value='PR 발행' class="button_simple" onclick="createPR_Addition();">

            </td>    
            <td style="text-align:right;">             
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>

<input type="hidden" name="projectNo" value="<%=projectNo%>">
<input type="hidden" name="drawingNo" value="<%=drawingNo%>">
<input type="hidden" name="loginID" value="<%=loginID%>">
<input type="hidden" name="deptCode" value="<%=deptCode%>">
<input type="hidden" name="inputMakerListYN" value="<%=inputMakerListYN%>">
<input type="hidden" name="createPRrunning" value="FALSE">
</form>
</body>


</html>