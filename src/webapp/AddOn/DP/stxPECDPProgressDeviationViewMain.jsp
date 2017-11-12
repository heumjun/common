<%--  
§DESCRIPTION: 공정 지연현황 조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressDeviationViewMain.jsp
§CHANGING HISTORY: 
§    2009-04-14: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String designerId = StringUtil.setEmptyExt(emxGetParameter(request, "designerId"));
    String dateSelected_to = StringUtil.setEmptyExt(emxGetParameter(request, "dateSelected_to"));
    String dateSelected_from = StringUtil.setEmptyExt(emxGetParameter(request, "dateSelected_from"));
    String searchComplete = StringUtil.setEmptyExt(emxGetParameter(request, "searchComplete"));
    String searchAll = StringUtil.setEmptyExt(emxGetParameter(request, "searchAll"));
    String userDept = StringUtil.setEmptyExt(emxGetParameter(request, "userDept"));
    String isAdmin = StringUtil.setEmptyExt(emxGetParameter(request, "isAdmin"));

    String bDS = StringUtil.setEmptyExt(emxGetParameter(request, "bDS"));
    String bDF = StringUtil.setEmptyExt(emxGetParameter(request, "bDF"));
    String bOS = StringUtil.setEmptyExt(emxGetParameter(request, "bOS"));
    String bOF = StringUtil.setEmptyExt(emxGetParameter(request, "bOF"));
    String bCS = StringUtil.setEmptyExt(emxGetParameter(request, "bCS"));
    String bCF = StringUtil.setEmptyExt(emxGetParameter(request, "bCF"));
    String bRF = StringUtil.setEmptyExt(emxGetParameter(request, "bRF"));
    String bWK = StringUtil.setEmptyExt(emxGetParameter(request, "bWK"));
    String mDS = StringUtil.setEmptyExt(emxGetParameter(request, "mDS"));
    String mDF = StringUtil.setEmptyExt(emxGetParameter(request, "mDF"));
    String mOS = StringUtil.setEmptyExt(emxGetParameter(request, "mOS"));
    String mOF = StringUtil.setEmptyExt(emxGetParameter(request, "mOF"));
    String mCS = StringUtil.setEmptyExt(emxGetParameter(request, "mCS"));
    String mCF = StringUtil.setEmptyExt(emxGetParameter(request, "mCF"));
    String mRF = StringUtil.setEmptyExt(emxGetParameter(request, "mRF"));
    String mWK = StringUtil.setEmptyExt(emxGetParameter(request, "mWK"));
    String pDS = StringUtil.setEmptyExt(emxGetParameter(request, "pDS"));
    String pDF = StringUtil.setEmptyExt(emxGetParameter(request, "pDF"));
    String pOS = StringUtil.setEmptyExt(emxGetParameter(request, "pOS"));
    String pOF = StringUtil.setEmptyExt(emxGetParameter(request, "pOF"));
    String pCS = StringUtil.setEmptyExt(emxGetParameter(request, "pCS"));
    String pCF = StringUtil.setEmptyExt(emxGetParameter(request, "pCF"));
    String pRF = StringUtil.setEmptyExt(emxGetParameter(request, "pRF"));
    String pWK = StringUtil.setEmptyExt(emxGetParameter(request, "pWK"));
        
    //String DW_S = StringUtil.setEmptyExt(emxGetParameter(request, "DW_S"));
    //String OW_S = StringUtil.setEmptyExt(emxGetParameter(request, "OW_S"));
    //String CL_S = StringUtil.setEmptyExt(emxGetParameter(request, "CL_S"));
    //String RF = StringUtil.setEmptyExt(emxGetParameter(request, "RF"));
    //String WK = StringUtil.setEmptyExt(emxGetParameter(request, "WK"));
    //String DW_F = StringUtil.setEmptyExt(emxGetParameter(request, "DW_F"));
    //String OW_F = StringUtil.setEmptyExt(emxGetParameter(request, "OW_F"));
    //String CL_F = StringUtil.setEmptyExt(emxGetParameter(request, "CL_F"));

    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));

    //20101224 kuni start - Table Data Sort
    String sortValue = StringUtil.setEmptyExt(emxGetParameter(request, "sortValue"));
    String sortType = StringUtil.setEmptyExt(emxGetParameter(request, "sortType"));
    String sortImage = "";
    //20101224 kuni end
    
    String errStr = "";

    ArrayList designProgressDevList = null;
    String lockDate = "";
    try {
        if (!projectNo.equals("")) {
            //String[] dateConditions = {DW_S, OW_S, CL_S, RF, WK, DW_F, OW_F, CL_F};
            String[] dateConditions = {
                                       bDS, bDF, bOS, bOF, bCS, bCF, bRF, bWK, 
                                       mDS, mDF, mOS, mOF, mCS, mCF, mRF, mWK, 
                                       pDS, pDF, pOS, pOF, pCS, pCF, pRF, pWK
                                      };

            designProgressDevList = getDesignProgressDevList(projectNo, deptCode, designerId, dateSelected_from, dateSelected_to, dateConditions, searchComplete, searchAll);
            lockDate = getDPProgressLockDate(userDept);
            

            //20101224 kuni start - Table Data Sort
            if(sortType==null || "".equals(sortType) || "descending".equals(sortType)){
            	sortType = "ascending";
            	sortImage = "<img src=\"../common/images/utilSortArrowUp.gif\" align=\"absmiddle\" border=\"0\" />";
            }else if("ascending".equals(sortType)){
            	sortType = "descending";
            	sortImage = "<img src=\"../common/images/utilSortArrowDown.gif\" align=\"absmiddle\" border=\"0\" />";
            }
            /**** DIS-ERROR : sort 부분 제거
            if(sortValue!=null && !"".equals(sortValue))
            	designProgressDevList.sort(sortValue , sortType , "String");
            ****/
			//20101224 kuni end
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>공정 지연현황 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<STYLE>   
    .hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
    }   
</STYLE>  

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff" oncontextmenu="return false;" ondragstart="return false;" onselectstart="return false;">
<form name="DPProgressDeviationMain">

    <input type="hidden" name="projectNo" value="<%=projectNo%>" />
    <input type="hidden" name="deptCode" value="<%=deptCode%>" />
    <input type="hidden" name="dateSelected_to" value="<%=dateSelected_to%>" />
    <input type="hidden" name="dateSelected_from" value="<%=dateSelected_from%>" />
    <input type="hidden" name="searchComplete" value="<%=searchComplete%>" />
    <input type="hidden" name="searchAll" value="<%=searchAll%>" />
    <input type="hidden" name="designerId" value="<%=designerId%>" />    
    <input type="hidden" name="userDept" value="<%=userDept%>" />    
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />    
    <input type="hidden" name="bDS" value="<%=bDS%>" />
    <input type="hidden" name="bDF" value="<%=bDF%>" />
    <input type="hidden" name="bOS" value="<%=bOS%>" />
    <input type="hidden" name="bOF" value="<%=bOF%>" />
    <input type="hidden" name="bCS" value="<%=bCS%>" />
    <input type="hidden" name="bCF" value="<%=bCF%>" />
    <input type="hidden" name="bRF" value="<%=bRF%>" />
    <input type="hidden" name="bWK" value="<%=bWK%>" />
    <input type="hidden" name="mDS" value="<%=mDS%>" />
    <input type="hidden" name="mDF" value="<%=mDF%>" />
    <input type="hidden" name="mOS" value="<%=mOS%>" />
    <input type="hidden" name="mOF" value="<%=mOF%>" />
    <input type="hidden" name="mCS" value="<%=mCS%>" />
    <input type="hidden" name="mCF" value="<%=mCF%>" />
    <input type="hidden" name="mRF" value="<%=mRF%>" />
    <input type="hidden" name="mWK" value="<%=mWK%>" />
    <input type="hidden" name="pDS" value="<%=pDS%>" />
    <input type="hidden" name="pDF" value="<%=pDF%>" />
    <input type="hidden" name="pOS" value="<%=pOS%>" />
    <input type="hidden" name="pOF" value="<%=pOF%>" />
    <input type="hidden" name="pCS" value="<%=pCS%>" />
    <input type="hidden" name="pCF" value="<%=pCF%>" />
    <input type="hidden" name="pRF" value="<%=pRF%>" />
    <input type="hidden" name="pWK" value="<%=pWK%>" />
    <input type="hidden" name="lockDate" value="<%=lockDate%>" />


<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="4" border="0">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                작업 중에 에러가 발생하였습니다. IT 담당자에게 문의하시기 바랍니다.<br>
                ※에러 메시지: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else
{
%>

<table id="data_table" border="0" cellpadding="0" cellspacing="0" width="1270" bgcolor="#ffffff" align="left">
    
    <tr valign="top">
        <td id="td_header_left" align="left">
            <div id="header_left" STYLE="width:690; overflow:hidden; position:relative;">
                <table id="table_header1" width="690" border="0" cellpadding="1" cellspacing="1" bgcolor="#cccccc" style="table-layout:fiexed;" align="right">
                    <tr height="20" bgcolor="#e5e5e5"> 
                        <td id="td_header_no" 		rowspan="2" width="26" class="td_standardSmall" nowrap>No</td>
                        <td id="td_header_project" 	rowspan="2" width="50" class="td_standardSmall" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('PROJECTNO','<%="PROJECTNO".equals(sortValue)?sortType:""%>')">Project<%="PROJECTNO".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_part" 	rowspan="2" width="90" class="td_standardSmall" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DEPTNAME','<%="DEPTNAME".equals(sortValue)?sortType:""%>')">Part<%="DEPTNAME".equals(sortValue)?sortImage:""%></td>
                        <!--<td rowspan="2" width="60" class="td_standardSmall" nowrap>Part Code</td>-->
                        <td id="td_header_dwgno" 	rowspan="2" width="60" class="td_standardSmall" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DWGCODE','<%="DWGCODE".equals(sortValue)?sortType:""%>')">DWG.No<%="DWGCODE".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_zone" 	rowspan="2" width="40" class="td_standardSmall" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DWGZONE','<%="DWGZONE".equals(sortValue)?sortType:""%>')">Zone<%="DWGZONE".equals(sortValue)?sortImage:""%></td>
                        <td 						colspan="3" class="td_standardSmall" nowrap>Outsourcing Plan</td>
                        <td id="td_header_task" 	rowspan="2" width="256" class="td_standardSmall" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DWGTITLE','<%="DWGTITLE".equals(sortValue)?sortType:""%>')">Task(Drawing Title)<%="DWGTITLE".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_user" 	rowspan="3" width="46" class="td_standardSmall" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('NAME','<%="NAME".equals(sortValue)?sortType:""%>')">담당자<%="NAME".equals(sortValue)?sortImage:""%></td>
                    </tr>
                    <tr height="37" bgcolor="#e5e5e5"> 
                        <td id="td_header_exist" 	class="td_standardSmall" width="32" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OUTSOURCINGYN','<%="OUTSOURCINGYN".equals(sortValue)?sortType:""%>')">Exist<%="OUTSOURCINGYN".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_1st" 		class="td_standardSmall" width="30" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OUTSOURCING1','<%="OUTSOURCING1".equals(sortValue)?sortType:""%>')">1st<%="OUTSOURCING1".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_2nd" 		class="td_standardSmall" width="30" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OUTSOURCING2','<%="OUTSOURCING2".equals(sortValue)?sortType:""%>')">2nd<%="OUTSOURCING2".equals(sortValue)?sortImage:""%></td>
                    </tr>
                </table>
            </div>		
        </td>

        <td id="td_header_right" width="580" align="left">
            <div id="header_right" STYLE="width:563; overflow:hidden; position:relative;">
                <table id="table_header2" width="1590" border="0" cellpadding="1" cellspacing="1" bgcolor="#cccccc" style="table-layout:fiexed;">
                    <tr height="20" bgcolor="#e5e5e5"> 
                        <td rowspan="3" class="td_standardSmall" width="130" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DELAYREASON','<%="DELAYREASON".equals(sortValue)?sortType:""%>')">지연사유<%="DELAYREASON".equals(sortValue)?sortImage:""%></td>
                        <td rowspan="3" class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('RESOLVEPLANDATE','<%="RESOLVEPLANDATE".equals(sortValue)?sortType:""%>')">조치예정일<%="RESOLVEPLANDATE".equals(sortValue)?sortImage:""%></td>
                        <td rowspan="3" class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('REQUIREDDATE','<%="REQUIREDDATE".equals(sortValue)?sortType:""%>')">현장<br>필요시점<%="REQUIREDDATE".equals(sortValue)?sortImage:""%></td>
                        <td rowspan="3" class="td_standardSmall" width="200" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DELAYREASON_DESC','<%="DELAYREASON_DESC".equals(sortValue)?sortType:""%>')">특기사항<%="DELAYREASON_DESC".equals(sortValue)?sortImage:""%></td>
                        <td id="yardDrawingHeader1" colspan="2" class="td_smallLRMarginBlue" nowrap>DrawingStart</td>
                        <td id="yardDrawingHeader2" colspan="2" class="td_smallLRMarginBlue" nowrap>DrawingFinish</td>
                        <td id="yardDrawingHeader3" colspan="2" class="td_smallLRMarginBlue" nowrap>OwnerApp.Submit</td>
                        <td id="yardDrawingHeader4" colspan="2" class="td_smallLRMarginBlue" nowrap>OwnerApp.Receive</td>
                        <td id="yardDrawingHeader5" colspan="2" class="td_smallLRMarginBlue" nowrap>ClassApp.Submit</td>
                        <td id="yardDrawingHeader6" colspan="2" class="td_smallLRMarginBlue" nowrap>ClassApp.Receive</td>
                        <td id="yardDrawingHeader7" colspan="2" class="td_smallLRMarginBlue" nowrap>Working</td>
                        <td id="commonDrawingHeader1" rowspan="2" colspan="2" class="td_smallLRMarginBlue" nowrap>Construction</td>
                    </tr>
                    <tr height="20" bgcolor="#e5e5e5">
                        <td id="vendorDrawingHeader1" colspan="2" class="td_smallLRMarginBlue" nowrap>Purchase Request</td>
                        <td id="vendorDrawingHeader2" colspan="2" class="td_smallLRMarginBlue" nowrap>Maker Selection</td>
                        <td id="vendorDrawingHeader3" colspan="2" class="td_smallLRMarginBlue" nowrap>Purchase Order</td>
                        <td id="vendorDrawingHeader4" colspan="2" class="td_smallLRMarginBlue" nowrap>Drawing Receive</td>
                        <td id="vendorDrawingHeader5" colspan="2" class="td_smallLRMarginBlue" nowrap>OwnerApp.Submit</td>
                        <td id="vendorDrawingHeader6" colspan="2" class="td_smallLRMarginBlue" nowrap>OwnerApp.Receive</td>
                        <td id="vendorDrawingHeader7" colspan="2" class="td_smallLRMarginBlue" nowrap>Maker Working</td>
                    </tr>
                    <tr height="16" bgcolor="#e5e5e5">
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DW_PLAN_S','<%="DW_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="DW_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DW_ACT_S','<%="DW_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="DW_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DW_PLAN_F','<%="DW_PLAN_F".equals(sortValue)?sortType:""%>')">Plan<%="DW_PLAN_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('DW_ACT_F','<%="DW_ACT_F".equals(sortValue)?sortType:""%>')">Action<%="DW_ACT_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OW_PLAN_S','<%="OW_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="OW_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OW_ACT_S','<%="OW_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="OW_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OW_PLAN_F','<%="OW_PLAN_F".equals(sortValue)?sortType:""%>')">Plan<%="OW_PLAN_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('OW_ACT_F','<%="OW_ACT_F".equals(sortValue)?sortType:""%>')">Action<%="OW_ACT_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('CL_PLAN_S','<%="CL_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="CL_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('CL_ACT_S','<%="CL_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="CL_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('CL_PLAN_F','<%="CL_PLAN_F".equals(sortValue)?sortType:""%>')">Plan<%="CL_PLAN_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('CL_ACT_F','<%="CL_ACT_F".equals(sortValue)?sortType:""%>')">Action<%="CL_ACT_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('RF_PLAN_S','<%="RF_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="RF_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('RF_ACT_S','<%="RF_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="RF_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('WK_PLAN_S','<%="WK_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="WK_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgressDeviation('WK_ACT_S','<%="WK_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="WK_ACT_S".equals(sortValue)?sortImage:""%></td>
                    </tr>
                </table>
            </div>	
        </td>
    </tr>

    <tr valign="top">
        <td id="td_list_left" align="left" style="vertical-align:top">
            <div id="list_left" STYLE="width:707; height:657; overflow:scroll; position:relative;" onScroll="onScrollHandler2();"> 
                <table id="table_size1" width="690" border="0" cellpadding="1" cellspacing="1" bgcolor="#cccccc" style="table-layout:fiexed;" align="right">
                <%
                for (int i = 0; designProgressDevList != null && i < designProgressDevList.size(); i++)
                {
                    Map designProgressDevMap = (Map)designProgressDevList.get(i);
                    String projectNoData = (String)designProgressDevMap.get("PROJECTNO");
                    String deptName = (String)designProgressDevMap.get("DEPTNAME");
                    String deptCodeData = (String)designProgressDevMap.get("DEPTCODE");
                    String dwgCode = (String)designProgressDevMap.get("DWGCODE");
                    String dwgZone = (String)designProgressDevMap.get("DWGZONE");
                    String outsourcingYN = (String)designProgressDevMap.get("OUTSOURCINGYN");
                    String outsourcing1 = (String)designProgressDevMap.get("OUTSOURCING1");
                    String outsourcing2 = (String)designProgressDevMap.get("OUTSOURCING2");
                    String dwgTitle = (String)designProgressDevMap.get("DWGTITLE");
                    String empNo = (String)designProgressDevMap.get("SABUN");
                    String empName = (String)designProgressDevMap.get("NAME");
                    String dwgTitleHint = replaceAmpAll(dwgTitle, "'", "＇");
                    %>
                    <tr height="20" bgcolor="#ffffff" onMouseOver="trOnMouseOver('<%=dwgCode%>');"> 
                        <td id="td_list_no" 		class="td_standardSmall" width="26" nowrap bgcolor="#eeeeee"><%=i+1%></td>
                        <td id="td_list_project" 	class="td_standardSmall" width="50" nowrap><%=projectNoData%></td>
                        <td id="td_list_part" 		class="td_standardSmall" width="90" nowrap>
                        	<nobr id="list_part" style="display:block;width:80;overflow:hidden;text-overflow:ellipsis;"><%=deptName%></nobr>
                        </td>
                        <!--<td class="td_standardSmall" width="60" nowrap><%//=deptCodeData%></td>-->
                        <td id="td_list_dwgno" 		class="td_standardSmall" width="60" nowrap><%=dwgCode%></td>
                        <td id="td_list_zone" 		class="td_standardSmall" width="40" nowrap><%=dwgZone%></td>
                        <td id="td_list_exist" 		class="td_standardSmall" width="32" nowrap><%=outsourcingYN%></td>
                        <td id="td_list_1st" 		class="td_standardSmall" width="30" nowrap><%=outsourcing1%></td>
                        <td id="td_list_2nd" 		class="td_standardSmall" width="30" nowrap><%=outsourcing2%></td>
                        <td id="td_list_task" 		class="td_standardSmall" width="256" style="text-align:left;" nowrap onmouseover="showhint(this, '<%=dwgTitleHint%>');">
                        	<nobr id="list_task" style="display:block;width:250;overflow:hidden;text-overflow:ellipsis;"><%=dwgTitle%></nobr>
                        </td>
                        <td id="td_list_user" 		class="td_standardSmall" width="46" nowrap><%=empName%></td>
                    </tr>
                    <% } %>
                </table>
            </div>			
        </td>

        <td id="td_list_right" width="580" align="left">
            <div id="list_right" STYLE="width:580; height:657; overflow:scroll; position:relative;ackground-color:#ffffff" onScroll="onScrollHandler();"> 
                <table id="table_size2" width="1590" border="0" cellpadding="1" cellspacing="1" bgcolor="#cccccc" style="table-layout:fiexed;">
                <%
                for (int i = 0; designProgressDevList != null && i < designProgressDevList.size(); i++)
                {
                    Map designProgressDevMap = (Map)designProgressDevList.get(i);
                    String projectNoData = (String)designProgressDevMap.get("PROJECTNO");
                    String dwgCode = (String)designProgressDevMap.get("DWGCODE");
                    String delayReason = (String)designProgressDevMap.get("DELAYREASON");
                    String resolvePlanDate = (String)designProgressDevMap.get("RESOLVEPLANDATE");
                    String requiredDate = (String)designProgressDevMap.get("REQUIREDDATE");
                    String delayReasonDesc = (String)designProgressDevMap.get("DELAYREASON_DESC");
                    String dwPlanStart = (String)designProgressDevMap.get("DW_PLAN_S");
                    String dwPlanFinish = (String)designProgressDevMap.get("DW_PLAN_F");
                    String dwActionStart = (String)designProgressDevMap.get("DW_ACT_S");
                    String dwActionFinish = (String)designProgressDevMap.get("DW_ACT_F");
                    String owPlanStart = (String)designProgressDevMap.get("OW_PLAN_S");
                    String owPlanFinish = (String)designProgressDevMap.get("OW_PLAN_F");
                    String owActionStart = (String)designProgressDevMap.get("OW_ACT_S");
                    String owActionFinish = (String)designProgressDevMap.get("OW_ACT_F");
                    String clPlanStart = (String)designProgressDevMap.get("CL_PLAN_S");
                    String clPlanFinish = (String)designProgressDevMap.get("CL_PLAN_F");
                    String clActionStart = (String)designProgressDevMap.get("CL_ACT_S");
                    String clActionFinish = (String)designProgressDevMap.get("CL_ACT_F");
                    String rfPlanStart = (String)designProgressDevMap.get("RF_PLAN_S");
                    String rfActionStart = (String)designProgressDevMap.get("RF_ACT_S");
                    String wkPlanStart = (String)designProgressDevMap.get("WK_PLAN_S");
                    String wkActionStart = (String)designProgressDevMap.get("WK_ACT_S");
                    String dwPlanStartOver = (String)designProgressDevMap.get("DW_PLAN_S_O");
                    String dwPlanFinishOver = (String)designProgressDevMap.get("DW_PLAN_F_O");
                    String owPlanStartOver = (String)designProgressDevMap.get("OW_PLAN_S_O");
                    String owPlanFinishOver = (String)designProgressDevMap.get("OW_PLAN_F_O");
                    String clPlanStartOver = (String)designProgressDevMap.get("CL_PLAN_S_O");
                    String clPlanFinishOver = (String)designProgressDevMap.get("CL_PLAN_F_O");
                    String rfPlanStartOver = (String)designProgressDevMap.get("RF_PLAN_S_O");
                    String wkPlanStartOver = (String)designProgressDevMap.get("WK_PLAN_S_O");

                    boolean isEditable = false;
                    if (isAdmin.equals("Y") || userDept.equals((String)designProgressDevMap.get("DEPTCODE"))) isEditable = true;

                    String dwActionStartBGColor = "#ffffe0";  if (!isEditable) dwActionStartBGColor = "#ffffff";
                    String dwActionFinishBGColor = "#ffffe0"; if (!isEditable) dwActionFinishBGColor = "#ffffff";
                    String owActionStartBGColor = "#ffffe0";  if (!isEditable) owActionStartBGColor = "#ffffff";
                    String owActionFinishBGColor = "#ffffe0"; if (!isEditable) owActionFinishBGColor = "#ffffff"; 
                    String clActionStartBGColor = "#ffffe0";  if (!isEditable) clActionStartBGColor = "#ffffff";
                    String clActionFinishBGColor = "#ffffe0"; if (!isEditable) clActionFinishBGColor = "#ffffff";
                    String rfActionStartBGColor = "#ffffe0";  if (!isEditable) rfActionStartBGColor = "#ffffff";
                    String wkActionStartBGColor = "#ffffe0";  if (!isEditable) wkActionStartBGColor = "#ffffff";
                    if (dwPlanStartOver.equals("Y") && dwActionStart.equals("")) dwActionStartBGColor = "#ff0000";
                    if (dwPlanFinishOver.equals("Y") && dwActionFinish.equals("")) dwActionFinishBGColor = "#ff0000";
                    if (owPlanStartOver.equals("Y") && owActionStart.equals("")) owActionStartBGColor = "#ff0000";
                    if (owPlanFinishOver.equals("Y") && owActionFinish.equals("")) owActionFinishBGColor = "#ff0000";
                    if (clPlanStartOver.equals("Y") && clActionStart.equals("")) clActionStartBGColor = "#ff0000";
                    if (clPlanFinishOver.equals("Y") && clActionFinish.equals("")) clActionFinishBGColor = "#ff0000";
                    if (rfPlanStartOver.equals("Y") && rfActionStart.equals("")) rfActionStartBGColor = "#ff0000";
                    if (wkPlanStartOver.equals("Y") && wkActionStart.equals("")) wkActionStartBGColor = "#ff0000";

                    %>
                    <tr height="20" bgcolor="#ffffff" onMouseOver="trOnMouseOver('<%=dwgCode%>');"> 
                        <td class="td_standardSmallYellowBack" width="130" nowrap 
                        	<% if (isEditable) { %>
                            onclick="selectReason(this, '<%=projectNoData%>', '<%=dwgCode%>', 'F1', '<%=delayReason%>');"
                            <% } %>
                            >
                            <%=delayReason%>
                        </td>
                        <td class="td_standardSmallYellowBack" width="70" nowrap 
                            <% if (isEditable) { %>
                            onclick="selectDate(this, '<%=projectNoData%>', '<%=dwgCode%>', 'F2', '<%=resolvePlanDate%>');"
                            ondblclick="deleteActionDate2(this, '<%=projectNoData%>', '<%=dwgCode%>', 'F2', '<%=resolvePlanDate%>');" 
                            <% } %>
                            >
                            <%=resolvePlanDate%>
                        </td>
                        <td class="td_standardSmallYellowBack" width="70" nowrap 
                            <% if (isEditable) { %>
                            onclick="selectDate(this, '<%=projectNoData%>', '<%=dwgCode%>', 'F3', '<%=requiredDate%>');"
                            ondblclick="deleteActionDate2(this, '<%=projectNoData%>', '<%=dwgCode%>', 'F3', '<%=requiredDate%>');" 
                            <% } %>
                            >
                            <%=requiredDate%>
                        </td>
                        <td class="td_standardSmallYellowBack" width="200" nowrap style="text-align:left;" 
                            onclick="showDescInputPopup(this, '<%=projectNoData%>', '<%=dwgCode%>', '<%=isEditable%>');" 
                            >
                            <nobr style="display:block;width:180;overflow:hidden;text-overflow:ellipsis;"><%=delayReasonDesc%></nobr>
                        </td>

                        <td class="td_standardSmall" width="70" nowrap><%=dwPlanStart%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>DW', 'S', '<%=dwActionStart%>');"  
                                ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>DW', 'S', '<%=dwActionStart%>');" 
                            <% } %>
                            bgcolor="<%=dwActionStartBGColor%>"><%=dwActionStart%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=dwPlanFinish%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>DW', 'F', '<%=dwActionFinish%>');" 
                                ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>DW', 'F', '<%=dwActionFinish%>');" 
                            <% } %>
                            bgcolor="<%=dwActionFinishBGColor%>"><%=dwActionFinish%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=owPlanStart%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>OW', 'S', '<%=owActionStart%>');" 
                                ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>OW', 'S', '<%=owActionStart%>');" 
                            <% } %>
                            bgcolor="<%=owActionStartBGColor%>"><%=owActionStart%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=owPlanFinish%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                    onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>OW', 'F', '<%=owActionFinish%>');" 
                                    ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>OW', 'F', '<%=owActionFinish%>');" 
                            <% } %>
                            bgcolor="<%=owActionFinishBGColor%>"><%=owActionFinish%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=clPlanStart%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>CL', 'S', '<%=clActionStart%>');" 
                                ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>CL', 'S', '<%=clActionStart%>');" 
                            <% } %>
                            bgcolor="<%=clActionStartBGColor%>"><%=clActionStart%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=clPlanFinish%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                    onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>CL', 'F', '<%=clActionFinish%>');" 
                                    ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>CL', 'F', '<%=clActionFinish%>');" 
                            <% } %>
                            bgcolor="<%=clActionFinishBGColor%>"><%=clActionFinish%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=rfPlanStart%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>RF', 'S', '<%=rfActionStart%>');" 
                                ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>RF', 'S', '<%=rfActionStart%>');" 
                            <% } %>
                            bgcolor="<%=rfActionStartBGColor%>"><%=rfActionStart%></td>
                        <td class="td_standardSmall" width="70" nowrap><%=wkPlanStart%></td>
                        <td class="td_standardSmall" width="70" nowrap 
                            <% if (isEditable) { %>
                                onclick="selectActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>WK', 'S', '<%=wkActionStart%>');" 
                                ondblclick="deleteActionDate(this, '<%=projectNoData%>', '<%=dwgCode%>WK', 'S', '<%=wkActionStart%>');" 
                            <% } %>
                            bgcolor="<%=wkActionStartBGColor%>"><%=wkActionStart%></td>
                    </tr>
                    <% } %>
                </table>
            </div>	
        </td>
    </tr>


</table>

<%
}
%>

<div id="dummyDiv" style="position:absolute;width=0px;height:0px;">
    <input type="text" name="dummyText" value="" style="width=0px;height:0px;" />
</div>
<div id="reasonSelectDiv" style="position:absolute;display:none;">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="reasonSelect" style="width:150px;background-color:#fff0f5" onchange="reasonSelChanged();">
            <option value="">&nbsp;</option>
            <option value="자체지연">자체지연</option>
            <option value="계약지연">계약지연</option>
            <option value="Maker Dwg. 미접수">Maker Dwg. 미접수</option>
            <option value="선주승인지연">선주승인지연</option>
            <option value="선급승인지연">선급승인지연</option>
            <option value="타부서 관련도면 미접수">타부서 관련도면 미접수</option>
            <option value="Comment">Comment</option>
            <option value="기타">기타</option>
        </select>
    </td></tr>
    </table>
</div>
<div id="descInputDiv" style="position:absolute;display:none;">
    <textarea  name="descInput" style="width=200px;height:40px;background-color:#fff0f5;text-align:left;"  ></textarea>
    <input type="button" value="입력" onclick="descInputChanged();">
</div>
<div id="hintDiv" style="position:absolute;display:none;z-index:200;"></div>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

	//20101222 kuni start - 해상도 변경
	//var screenWidth = window.screen.width;
	//var screenHeight = window.screen.height;
	var screenWidth = window.document.body.clientWidth;
	var screenHeight = window.document.body.clientHeight;
	
	//alert("현재 해상도 : " + screenWidth + " X " + screenHeight);
	
	//if(screenWidth>2375)
	//	screenWidth = 2375;
	
	//alert(window.document.body.clientWidth);
	//alert(window.document.body.clientHeight);
	
	//Table 해상도 변경
	document.getElementById("data_table").width 				= screenWidth - 40;
	
	//Header Left(TD) 해상도 변경
	//document.getElementById("td_header_no").width 				= screenWidth*0.54*0.04;
	//document.getElementById("td_header_project").width 			= screenWidth*0.54*0.08;
	//document.getElementById("td_header_part").width 			= screenWidth*0.54*0.13;
	//document.getElementById("td_header_dwgno").width 			= screenWidth*0.54*0.09;
	//document.getElementById("td_header_zone").width 			= screenWidth*0.54*0.06;
	//document.getElementById("td_header_exist").width 			= screenWidth*0.54*0.05;
	//document.getElementById("td_header_1st").width 				= screenWidth*0.54*0.05;
	//document.getElementById("td_header_2nd").width 				= screenWidth*0.54*0.05;
	//document.getElementById("td_header_task").width 			= screenWidth*0.54*0.38;
	//document.getElementById("td_header_user").width 			= screenWidth*0.54*0.07;
	
	var header_left_width = parseInt(document.getElementById("td_header_no").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_project").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_part").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_dwgno").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_zone").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_exist").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_1st").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_2nd").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_task").width);
	header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_user").width);
	
	//Header Left(DIV) 해상도 변경
	//document.getElementById("header_left").style.width 			= (parseInt(header_left_width) + 10) + "px";
	
	//Header Left(TABLE) 해상도 변경
	//document.getElementById("table_header1").width 				= parseInt(header_left_width) + 10;
	
	//List Left(TD) 해상도 변경
	try{
		//document.getElementById("td_list_no").width 			= screenWidth*0.54*0.04;
		//document.getElementById("td_list_project").width 		= screenWidth*0.54*0.08;
		//document.getElementById("td_list_part").width 			= screenWidth*0.54*0.13;
		//document.getElementById("list_part").style.width 		= screenWidth*0.54*0.12 + "px";
		//document.getElementById("td_list_dwgno").width 			= screenWidth*0.54*0.09;
		//document.getElementById("td_list_zone").width 			= screenWidth*0.54*0.06;
		//document.getElementById("td_list_exist").width 			= screenWidth*0.54*0.05;
		//document.getElementById("td_list_1st").width 			= screenWidth*0.54*0.05;
		//document.getElementById("td_list_2nd").width 			= screenWidth*0.54*0.05;
		//document.getElementById("td_list_task").width 			= screenWidth*0.54*0.38;
		//document.getElementById("list_task").style.width 		= screenWidth*0.54*0.37 + "px";
		//document.getElementById("td_list_user").width 			= screenWidth*0.54*0.07;
	}catch(e){
		
	}
	
	//List Left(DIV) 해상도 변경
	//document.getElementById("list_left").style.width 			= (parseInt(header_left_width) + 27) + "px";
	//document.getElementById("list_left").style.height 			= screenHeight*0.6 + "px";
	document.getElementById("list_left").style.height 			= screenHeight*0.88 + "px";
	
	//List Left(TABLE) 해상도 변경
	//document.getElementById("table_size1").width 				= parseInt(header_left_width) + 10;
	
	//Header Right(TD) 해상도 변경
	document.getElementById("td_header_right").width 			= screenWidth - parseInt(header_left_width) - 50;
	
	//Header Right(DIV) 해상도 변경
	document.getElementById("header_right").style.width 		= (screenWidth - parseInt(header_left_width) - 47) + "px";
	
	//List Right(TD) 해상도 변경
	document.getElementById("td_list_right").width 				= screenWidth - parseInt(header_left_width) - 50;
	
	//List Right(DIV) 해상도 변경
	document.getElementById("list_right").style.width 			= (screenWidth - parseInt(header_left_width) - 33) + "px";
	//document.getElementById("list_right").style.height 			= screenHeight*0.6 + "px";
	document.getElementById("list_right").style.height 			= screenHeight*0.88 + "px";
	
	//alert("해상도 변경 완료");
	//20101222 kuni end
	
    // 조회 완료 메시지 
    <% if (showMsg.equals("") || showMsg.equalsIgnoreCase("true")) { %>
        alert("조회 완료");
    <% } %>
	
    // 스크롤 처리
    function onScrollHandler() 
    {
		header_right.scrollLeft = list_right.scrollLeft;
		list_left.scrollTop = list_right.scrollTop;
		return;
    }

    // 스크롤 처리
    function onScrollHandler2() 
    {
		list_right.scrollLeft = header_right.scrollLeft;
		list_right.scrollTop = list_left.scrollTop;
		return;
    }
    
    // Action Date 입력 관련 현재 선택된 TD 개체를 전역변수에 저장
    var activeTDObject = null;
    var activeFieldKey = ""; // 호선|도면코드|필드 키|필드 값으로 구성 (필드 키 - F1: 지연사유, F2: 조치예정일, F3: 현장필요시점, F4: 특기사항)
    var activeActivityCode = ""; // Action 일자 변경 처리 용
    var inputDataList = new Array(); // 지연사유, 조치예정일, 현장필요시점 항목의 입력 변경사항을 저장
    var inputDatesList = new Array(); // Action 일자 변경사항을 저장
    var descOriginalValues = new Array(); // 특기사항의 원본 값들을 저장
    var descChangedValues = new Array();  // 특기사항의 변경된 값들을 저장
    <% for (int i = 0; designProgressDevList != null && i < designProgressDevList.size(); i++) 
       { 
            Map designProgressDevMap = (Map)designProgressDevList.get(i);
            String projectNoData = (String)designProgressDevMap.get("PROJECTNO");
            String dwgCode = (String)designProgressDevMap.get("DWGCODE");
            String delayReasonDesc = (String)designProgressDevMap.get("DELAYREASON_DESC");
            String descStr = projectNoData + "|" + dwgCode + "|" + delayReasonDesc;
            descStr = descStr.replaceAll("\r\n","\\\\n");
            descStr = descStr.replaceAll("|","");
            descStr = descStr.replaceAll("'","");
            descStr = descStr.replaceAll("\"","");
    %>
            descOriginalValues[<%= i %>] = "<%= descStr %>";
    <% } %>

    <% if (designProgressDevList != null) { %>
            parent.PROGRESS_DEV_HEADER.DPProgressDeviationHeader.totalDeviation.value = '<%=designProgressDevList.size()%>';  
    <% } %>


    // 조치예정일 or 현장필요시점 일자 입력 처리 : 칼렌다 표시, 일자 선택 시 DB 반영
    function selectDate(tdObject, projectNo, dwgCode, fieldKind, currentData)
    {
        if (descInputDiv.style.display != 'none') { // 특기사항 입력이 Show 상태면 닫는다
            descInputChangedProc();
            hideDescInput();
        }

        var objPosition = getAbsolutePosition(tdObject);
        //dummyDiv.style.left = objPosition.x - list_right.scrollLeft; // dummyDiv & dummyText 는 칼렌다 팝업 위치 및 칼렌다 선택 값을 얻기 위해 필요		
        //dummyDiv.style.top = objPosition.y - list_right.scrollTop;
		//달력 짤림 방지를 위해 달력 위치 조정
		dummyDiv.style.left = objPosition.x - list_right.scrollLeft>1400?(objPosition.x - list_right.scrollLeft - 160):(objPosition.x - list_right.scrollLeft);
		dummyDiv.style.top = (objPosition.y - list_right.scrollTop)>510?(objPosition.y - list_right.scrollTop - 210):(objPosition.y - list_right.scrollTop);
        activeTDObject = tdObject;
        activeFieldKey = projectNo + "|" + dwgCode + "|" + fieldKind;

        showCalendar('DPProgressDeviationMain', 'dummyText', '', false, dateChanged);
    }

    // 날짜 출력 문자열을 형식화 & 유효성 체크
    function dateChanged()
    {
        var tmpStr = DPProgressDeviationMain.dummyText.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            DPProgressDeviationMain.dummyText.value = formatDateStr(tmpStr); // 2009.6.5 -> 2009-06-05 형식으로 변경

            // 값 당
            if (activeTDObject != null) activeTDObject.innerHTML = DPProgressDeviationMain.dummyText.value;
            if (activeFieldKey != "") {
                // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
                var isExist = false;
                for (var i = 0; i < inputDataList.length; i++) {
                    var str = inputDataList[i];
                    if (str.indexOf(activeFieldKey + "|") >= 0) {
                        inputDataList[i] = activeFieldKey + "|" + DPProgressDeviationMain.dummyText.value;
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) 
                    inputDataList[inputDataList.length] = activeFieldKey + "|" + DPProgressDeviationMain.dummyText.value;
            }
        }
    }

    // 날짜 출력 문자열을 형식화 & 유효성 체크: Action 일자 변경 처리 용
    function dateChanged2()
    {
        var tmpStr = DPProgressDeviationMain.dummyText.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            DPProgressDeviationMain.dummyText.value = formatDateStr(tmpStr); // 2009.6.5 -> 2009-06-05 형식으로 변경

            // 오늘 기준 -(lockDate0 ~ +1 일 이내 날짜만 입력 가능(체크)
            if (DPProgressDeviationMain.isAdmin.value != "Y") {
                var today = new Date();
                var dateStrs = (DPProgressDeviationMain.dummyText.value).split("-");

                var lockDate = DPProgressDeviationMain.lockDate.value;
                if (lockDate != "") {
                    if (lockDate.indexOf("-") == 0) lockDate = lockDate.substring(1);
                    // 선택일에 +(lockDate)일 한 일자(오늘날짜보다 같거나 커야함) 
                    var targetDate = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "+" + lockDate)); 
                    if (targetDate < today) {
                        alert("입력 가능 일자가 아닙니다.\n\n자세한 사항은 기술기획팀-기술계획P에 문의바랍니다.");
                        return;
                    }
                }

                // 선택일에 -1일 한 일자(오늘날짜보다 작거나 같아야함)
                var targetDate2 = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "-1")); 
                if (targetDate2 > today) {
                    alert("오늘날짜 기준 +1일 이내의 날짜만 입력할 수 있습니다!");
                    return;
                }
            }

            // 값 당
            if (activeTDObject != null) activeTDObject.innerHTML = DPProgressDeviationMain.dummyText.value;
            if (activeActivityCode != "") {
                // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
                var isExist = false;
                for (var i = 0; i < inputDatesList.length; i++) {
                    var str = inputDatesList[i];
                    if (str.indexOf(activeActivityCode + "|") >= 0) {
                        inputDatesList[i] = activeActivityCode + "|" + DPProgressDeviationMain.dummyText.value;
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) 
                    inputDatesList[inputDatesList.length] = activeActivityCode + "|" + DPProgressDeviationMain.dummyText.value;
            }
        }
    }

    // document click 이벤트 핸들러 지정
    document.onclick = mouseClickHandler;
    document.onkeydown = keydownHandler;
    var isNewShow = false;

    // 지연사유 선택 화면 Show
    function selectReason(tdObject, projectNo, dwgCode, fieldKind, currentData)
    {
        if (descInputDiv.style.display != 'none') { // 특기사항 입력이 Show 상태면 닫는다
            descInputChangedProc();
            hideDescInput();
        }

        var objPosition = getAbsolutePosition(tdObject);
        reasonSelectDiv.style.left = objPosition.x - 2 - list_right.scrollLeft;// + tdObject.offsetWidth;
        reasonSelectDiv.style.top = objPosition.y - 2 - list_right.scrollTop;
        activeTDObject = tdObject;
        activeFieldKey = projectNo + "|" + dwgCode + "|" + fieldKind;

        currentData = tdObject.innerHTML.trim();
        for (var i = 0; i < DPProgressDeviationMain.reasonSelect.options.length; i++) {
            var str = DPProgressDeviationMain.reasonSelect.options[i].value;
            if (str == currentData) {
                DPProgressDeviationMain.reasonSelect.selectedIndex = i;
                break;
            }
        }

        reasonSelectDiv.style.display = '';
        isNewShow = true;
    }
 
    // 지연사유 선택 화면 Hidden
    function hideReasonSelect()
    {
        if (reasonSelectDiv.style.display == 'none') return;
        DPProgressDeviationMain.reasonSelect.selectedIndex = 0;
        reasonSelectDiv.style.display = 'none';
    }

    // 지연사유 선택(입력) 처리
    function reasonSelChanged()
    {
        if (activeTDObject != null) activeTDObject.innerHTML = DPProgressDeviationMain.reasonSelect.value;
        if (activeFieldKey != "") {
            // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
            var isExist = false;
            for (var i = 0; i < inputDataList.length; i++) {
                var str = inputDataList[i];
                if (str.indexOf(activeFieldKey + "|") >= 0) {
                    inputDataList[i] = activeFieldKey + "|" + DPProgressDeviationMain.reasonSelect.value;
                    isExist = true;
                    break;
                }
            }
            if (!isExist) 
                inputDataList[inputDataList.length] = activeFieldKey + "|" + DPProgressDeviationMain.reasonSelect.value;
        }

        hideReasonSelect();
    }
    
    function showDescInputPopup(tdObject, projectNo, dwgCode, isEditable)
    {
    	var sProperties = 'dialogHeight:300px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "projectNo=" + projectNo;
        paramStr += "&dwgCode="+dwgCode;
        paramStr += "&isEditable="+isEditable;
        paramStr += "&designerId=<%=designerId%>";
        var result = window.showModalDialog("stxPECDPProgressDeviationViewDesc.jsp?" + paramStr, "", sProperties);
        if(result == 'ok')parent.PROGRESS_DEV_HEADER.viewDPProgressDeviation();
    }

    // 특기사항 화면 Show
    function showDescInput(tdObject, projectNo, dwgCode, fieldKind)
    {
        if (reasonSelectDiv.style.display != 'none') { // 지연사유 입력이 Show 상태면 닫는다
            hideReasonSelect();
        }
        if (descInputDiv.style.display != 'none') { // 다른 특기사항 입력이 Show 상태면 닫는다
            descInputChangedProc();
            hideDescInput();
        }

        var objPosition = getAbsolutePosition(tdObject);
        descInputDiv.style.left = objPosition.x - 1 - list_right.scrollLeft;
        descInputDiv.style.top = objPosition.y - 1 - list_right.scrollTop;
        activeTDObject = tdObject;

        activeFieldKey = projectNo + "|" + dwgCode; // + "|" + fieldKind; // 특기사항에 대한 activeFieldKey에는 fieldKind는 필요X

        var currentData = "";
        for (var i = 0; i < descChangedValues.length; i++) {
            var tempStr = descChangedValues[i];
            if (tempStr.indexOf(activeFieldKey + "|") >= 0) {
                currentData = (tempStr.split("|"))[2];
                break;
            }
        }
        if (currentData == "") {
            for (var i = 0; i < descOriginalValues.length; i++) {
                var tempStr = descOriginalValues[i];
                if (tempStr.indexOf(activeFieldKey + "|") >= 0) {
                    currentData = (tempStr.split("|"))[2];
                    break;
                }
            }
        }

        DPProgressDeviationMain.descInput.value = currentData;

        descInputDiv.style.display = '';
        isNewShow = true;
        DPProgressDeviationMain.descInput.focus();
    }
 
    // 특기사항 화면 Hidden
    function hideDescInput()
    {
        if (descInputDiv.style.display == 'none') return;
        descInputDiv.style.display = 'none';
    }

    // 특기사항 선택(입력) 처리
    function descInputChanged() 
    { 
        descInputChangedProc();
    }

    // 특기사항 선택(입력) 처리 (서브 프로시저)
    function descInputChangedProc()
    {
        if (descInputDiv.style.display == 'none') return;

        if (activeTDObject != null && activeFieldKey != "") {
            activeTDObject.innerHTML = '<NOBR style="DISPLAY: block; OVERFLOW: hidden; WIDTH: 180px; TEXT-OVERFLOW: ellipsis">' + 
                                       DPProgressDeviationMain.descInput.value + '</NOBR>';

            // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
            var isExist = false;
            for (var i = 0; i < descChangedValues.length; i++) {
                var str = descChangedValues[i];
                if (str.indexOf(activeFieldKey + "|") >= 0) {
                    descChangedValues[i] = activeFieldKey + "|" + DPProgressDeviationMain.descInput.value;
                    isExist = true;
                    break;
                }
            }
            if (!isExist) 
                descChangedValues[descChangedValues.length] = activeFieldKey + "|" + DPProgressDeviationMain.descInput.value;
        }

        hideDescInput();
    }

    // 지연사유 선택화면 & 특기사항 입력화면 외 다른 부분을 클릭 시 해당 화면들을 Hidden
    function mouseClickHandler(e)
    {
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        var posX = event.clientX + reasonSelectDiv.scrollLeft;
        var posY = event.clientY + reasonSelectDiv.scrollTop;
        var objPos = getAbsolutePosition(reasonSelectDiv);
        if (posX < objPos.x || posX > objPos.x + reasonSelectDiv.offsetWidth || posY < objPos.y  || posY > objPos.y + reasonSelectDiv.offsetHeight)
        {
            hideReasonSelect();
        }
        objPos = getAbsolutePosition(descInputDiv);
        if (posX < objPos.x || posX > objPos.x + descInputDiv.offsetWidth || posY < objPos.y  || posY > objPos.y + descInputDiv.offsetHeight)
        {
            descInputChangedProc();
            hideDescInput();
        }
    }

    // Action Date 입력 처리 : 칼렌다 표시, 일자 선택 시 DB 반영
    function selectActionDate(tdObject, projectNo, activityCode, startFinishCode, currentData)
    {
        if (currentData != "" && DPProgressDeviationMain.isAdmin.value != "Y") return; // 값이 있는 경우 진행X

        var objPosition = getAbsolutePosition(tdObject);
        //dummyDiv.style.left = objPosition.x - list_right.scrollLeft; // dummyDiv & dummyText 는 칼렌다 팝업 위치 및 칼렌다 선택 값을 얻기 위해 필요
        //dummyDiv.style.top = objPosition.y - list_right.scrollTop;
		//달력 짤림 방지를 위해 달력 위치 조정
		dummyDiv.style.left = objPosition.x - list_right.scrollLeft>1400?(objPosition.x - list_right.scrollLeft - 160):(objPosition.x - list_right.scrollLeft);
		dummyDiv.style.top = (objPosition.y - list_right.scrollTop)>510?(objPosition.y - list_right.scrollTop - 210):(objPosition.y - list_right.scrollTop);
        activeTDObject = tdObject;
        activeActivityCode = projectNo + "|" + activityCode + "|" + startFinishCode;

        showCalendar('DPProgressDeviationMain', 'dummyText', '', false, dateChanged2);
    }

    // 선택된 Action Date를 삭제
    function deleteActionDate(tdObject, projectNo, activityCode, startFinishCode, currentData)
    {
        if (DPProgressDeviationMain.isAdmin.value != "Y") return; // Admin이 아니면 exit
        if (tdObject.innerHTML == "") return; // 값이 있는 경우만 해당

        // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
        var isExist = false;
        for (var i = 0; i < inputDatesList.length; i++) {
            var str = inputDatesList[i];
            if (str.indexOf(projectNo + "|" + activityCode + "|" + startFinishCode + "|") >= 0) {
                inputDatesList[i] = projectNo + "|" + activityCode + "|" + startFinishCode + "|";
                isExist = true;
                break;
            }
        }
        if (!isExist) 
            inputDatesList[inputDatesList.length] = projectNo + "|" + activityCode + "|" + startFinishCode + "|";

        tdObject.innerHTML = "";
    }

    // 조치예정일, 현장필요시점 삭제
    function deleteActionDate2(tdObject, projectNo, activityCode, startFinishCode, currentData)
    {
        //if (DPProgressDeviationMain.isAdmin.value != "Y") return; // Admin이 아니면 exit
        if (tdObject.innerHTML == "") return; // 값이 있는 경우만 해당

        // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
        var isExist = false;
        for (var i = 0; i < inputDataList.length; i++) {
            var str = inputDataList[i];
            if (str.indexOf(projectNo + "|" + activityCode + "|" + startFinishCode + "|") >= 0) {
                inputDataList[i] = projectNo + "|" + activityCode + "|" + startFinishCode + "|";
                isExist = true;
                break;
            }
        }
        if (!isExist) 
            inputDataList[inputDataList.length] = projectNo + "|" + activityCode + "|" + startFinishCode + "|";

        tdObject.innerHTML = "";
    }

    // 공정지연 사유 등 입력사항 DB 저장
    function saveDPProgressDev()
    {
        if (inputDataList.length <= 0 && descChangedValues.length <= 0 && inputDatesList.length <= 0) {
            alert("변경사항이 없습니다");
            return;
        }

        var str = "";
        for (var i = 0; i < inputDataList.length; i++) {
            if (i > 0) str += ",";
            str += inputDataList[i];
        }
        var str2 = "";
        for (var i = 0; i < descChangedValues.length; i++) {
            if (i > 0) str2 += ",";
            str2 += descChangedValues[i];
        }
        var str3 = "";
        for (var i = 0; i < inputDatesList.length; i++) {
            if (i > 0) str3 += ",";
            str3 += inputDatesList[i];
        }

        var params = "inputDataList=" + str;
        params += "&descChangedValues=" + str2;
        params += "&inputDates=" + str3;
        params += "&loginID=" + parent.PROGRESS_DEV_HEADER.DPProgressDeviationHeader.loginID.value;

        var resultMsg = callDPCommonAjaxPostProc("SaveDPProgressDev", params);
        if (resultMsg == "Y") {
            alert("저장 완료!\n\n화면이 다시 로드됩니다. 잠시만 기다리십시오.");

            var urlStr = "stxPECDPProgressDeviationViewMain.jsp?projectNo=" + DPProgressDeviationMain.projectNo.value;
            urlStr += "&deptCode=" + DPProgressDeviationMain.deptCode.value;
            urlStr += "&dateSelected_to=" + DPProgressDeviationMain.dateSelected_to.value;
            urlStr += "&dateSelected_from=" + DPProgressDeviationMain.dateSelected_from.value;
            urlStr += "&searchComplete=" + parent.frames[0].DPProgressDeviationHeader.searchComplete.checked;
        	urlStr += "&searchAll=" + parent.frames[0].DPProgressDeviationHeader.searchAll.checked;
            urlStr += "&designerId=" + DPProgressDeviationMain.designerId.value;
            urlStr += "&userDept=" + DPProgressDeviationMain.userDept.value;
            urlStr += "&isAdmin=" + DPProgressDeviationMain.isAdmin.value;
            urlStr += "&showMsg=false";

            urlStr += "&bDS=" + DPProgressDeviationMain.bDS.value;
            urlStr += "&bDF=" + DPProgressDeviationMain.bDF.value;
            urlStr += "&bOS=" + DPProgressDeviationMain.bOS.value;
            urlStr += "&bOF=" + DPProgressDeviationMain.bOF.value;
            urlStr += "&bCS=" + DPProgressDeviationMain.bCS.value;
            urlStr += "&bCF=" + DPProgressDeviationMain.bCF.value;
            urlStr += "&bRF=" + DPProgressDeviationMain.bRF.value;
            urlStr += "&bWK=" + DPProgressDeviationMain.bWK.value;
            urlStr += "&mDS=" + DPProgressDeviationMain.mDS.value;
            urlStr += "&mDF=" + DPProgressDeviationMain.mDF.value;
            urlStr += "&mOS=" + DPProgressDeviationMain.mOS.value;
            urlStr += "&mOF=" + DPProgressDeviationMain.mOF.value;
            urlStr += "&mCS=" + DPProgressDeviationMain.mCS.value;
            urlStr += "&mCF=" + DPProgressDeviationMain.mCF.value;
            urlStr += "&mRF=" + DPProgressDeviationMain.mRF.value;
            urlStr += "&mWK=" + DPProgressDeviationMain.mWK.value;
            urlStr += "&pDS=" + DPProgressDeviationMain.pDS.value;
            urlStr += "&pDF=" + DPProgressDeviationMain.pDF.value;
            urlStr += "&pOS=" + DPProgressDeviationMain.pOS.value;
            urlStr += "&pOF=" + DPProgressDeviationMain.pOF.value;
            urlStr += "&pCS=" + DPProgressDeviationMain.pCS.value;
            urlStr += "&pCF=" + DPProgressDeviationMain.pCF.value;
            urlStr += "&pRF=" + DPProgressDeviationMain.pRF.value;
            urlStr += "&pWK=" + DPProgressDeviationMain.pWK.value;

            parent.PROGRESS_DEV_MAIN.location = urlStr;
        }
        else alert("에러 발생");
    }

    // 도면 Title 부분 MouseOver 시 도면 Title Full Text를 힌트 형태로 표시
    var hintcontainer = null;   
    function showhintNobr(obj) {  
       if (hintcontainer == null) {   
          hintcontainer = document.createElement("div");   
          hintcontainer.className = "hintstyle";   
          document.body.appendChild(hintcontainer);   
       }   
       obj.onmouseout = hidehint;   
       obj.onmousemove = movehint;   
       if(obj.firstChild != null)
       hintcontainer.innerHTML = obj.firstChild.innerHTML; 
    } 
    function showhint(obj, txt) {   
      if(txt == '') return;
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

    // 도면타입에 따라 Header 부분 선택 값을 변경(: Color-Highlight 로 표시)
    function trOnMouseOver(dwgCode)
    {
        if (dwgCode != null && dwgCode.indexOf("V") == 0) {
            document.getElementById('yardDrawingHeader1').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader2').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader3').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader4').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader5').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader6').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader7').style.backgroundColor = '#e5e5e5';

            document.getElementById('vendorDrawingHeader1').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader2').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader3').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader4').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader5').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader6').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader7').style.backgroundColor = '#32cd32';

            document.getElementById('commonDrawingHeader1').style.backgroundColor = '#32cd32';
        }
        else {
            document.getElementById('vendorDrawingHeader1').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader2').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader3').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader4').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader5').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader6').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader7').style.backgroundColor = '#e5e5e5';

            document.getElementById('yardDrawingHeader1').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader2').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader3').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader4').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader5').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader6').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader7').style.backgroundColor = '#32cd32';

            document.getElementById('commonDrawingHeader1').style.backgroundColor = '#32cd32';
        }
    }

	//20101228 kuni start - Column Sort
	function viewDPProgressDeviation(sortValue , sortType)
    {
        var urlStr = "stxPECDPProgressDeviationViewMain.jsp?projectNo=" + parent.frames[0].DPProgressDeviationHeader.projectList.value;
        urlStr += "&deptCode=" + parent.frames[0].DPProgressDeviationHeader.departmentList.value;
        urlStr += "&designerId=" + parent.frames[0].DPProgressDeviationHeader.designerList.value;
        urlStr += "&dateSelected_to=" + parent.frames[0].DPProgressDeviationHeader.dateSelected_to.value;
        urlStr += "&dateSelected_from=" + parent.frames[0].DPProgressDeviationHeader.dateSelected_from.value;
        urlStr += "&searchComplete=" + parent.frames[0].DPProgressDeviationHeader.searchComplete.checked;
        urlStr += "&searchAll=" + parent.frames[0].DPProgressDeviationHeader.searchAll.checked;
        urlStr += "&userDept=" + parent.frames[0].DPProgressDeviationHeader.dwgDepartmentCode.value;
        urlStr += "&isAdmin=" + parent.frames[0].DPProgressDeviationHeader.isAdmin.value;

        urlStr += "&bDS=" + (parent.frames[0].DPProgressDeviationHeader.bDS.checked ? "Y" : "N");
        urlStr += "&bDF=" + (parent.frames[0].DPProgressDeviationHeader.bDF.checked ? "Y" : "N");
        urlStr += "&bOS=" + (parent.frames[0].DPProgressDeviationHeader.bOS.checked ? "Y" : "N");
        urlStr += "&bOF=" + (parent.frames[0].DPProgressDeviationHeader.bOF.checked ? "Y" : "N");
        urlStr += "&bCS=" + (parent.frames[0].DPProgressDeviationHeader.bCS.checked ? "Y" : "N");
        urlStr += "&bCF=" + (parent.frames[0].DPProgressDeviationHeader.bCF.checked ? "Y" : "N");
        urlStr += "&bRF=" + (parent.frames[0].DPProgressDeviationHeader.bRF.checked ? "Y" : "N");
        urlStr += "&bWK=" + (parent.frames[0].DPProgressDeviationHeader.bWK.checked ? "Y" : "N");
        urlStr += "&mDS=" + (parent.frames[0].DPProgressDeviationHeader.mDS.checked ? "Y" : "N");
        urlStr += "&mDF=" + (parent.frames[0].DPProgressDeviationHeader.mDF.checked ? "Y" : "N");
        urlStr += "&mOS=" + (parent.frames[0].DPProgressDeviationHeader.mOS.checked ? "Y" : "N");
        urlStr += "&mOF=" + (parent.frames[0].DPProgressDeviationHeader.mOF.checked ? "Y" : "N");
        urlStr += "&mCS=" + (parent.frames[0].DPProgressDeviationHeader.mCS.checked ? "Y" : "N");
        urlStr += "&mCF=" + (parent.frames[0].DPProgressDeviationHeader.mCF.checked ? "Y" : "N");
        urlStr += "&mRF=" + (parent.frames[0].DPProgressDeviationHeader.mRF.checked ? "Y" : "N");
        urlStr += "&mWK=" + (parent.frames[0].DPProgressDeviationHeader.mWK.checked ? "Y" : "N");
        urlStr += "&pDS=" + (parent.frames[0].DPProgressDeviationHeader.pDS.checked ? "Y" : "N");
        urlStr += "&pDF=" + (parent.frames[0].DPProgressDeviationHeader.pDF.checked ? "Y" : "N");
        urlStr += "&pOS=" + (parent.frames[0].DPProgressDeviationHeader.pOS.checked ? "Y" : "N");
        urlStr += "&pOF=" + (parent.frames[0].DPProgressDeviationHeader.pOF.checked ? "Y" : "N");
        urlStr += "&pCS=" + (parent.frames[0].DPProgressDeviationHeader.pCS.checked ? "Y" : "N");
        urlStr += "&pCF=" + (parent.frames[0].DPProgressDeviationHeader.pCF.checked ? "Y" : "N");
        urlStr += "&pRF=" + (parent.frames[0].DPProgressDeviationHeader.pRF.checked ? "Y" : "N");
        urlStr += "&pWK=" + (parent.frames[0].DPProgressDeviationHeader.pWK.checked ? "Y" : "N");

		urlStr += "&sortValue=" + sortValue;
		urlStr += "&sortType=" + sortType;

        parent.PROGRESS_DEV_MAIN.location = urlStr;
    }
    //20101228 kuni end
</script>


</html>