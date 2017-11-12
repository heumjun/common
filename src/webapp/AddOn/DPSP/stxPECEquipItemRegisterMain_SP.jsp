<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 Main
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterMain_SP.jsp
§CHANGING HISTORY: 
§    2010-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%!
    // DPS에서 호선, 부서별 도면 정보 가져옴.
	private ArrayList getDeptDrawingList(String projectNo, String deptCode) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		deptCode = StringUtil.setEmptyExt(deptCode);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPSP");
			StringBuffer queryStr = new StringBuffer();

            queryStr.append("SELECT PROJECTNO                                      \n");
            queryStr.append("      ,DWGDEPTNM                                      \n"); 
            queryStr.append("      ,DWGCODE                                        \n");
            queryStr.append("      ,DWGTITLE                                       \n");
            queryStr.append("      ,DR_DATE                                        \n"); 
            queryStr.append("      ,PR_PLAN_DATE                                   \n");
            queryStr.append("      ,PO_PLAN_DATE                                   \n"); 
            queryStr.append("      ,RECEIVE_ACT_DATE                               \n");
            queryStr.append("      ,CATALOGS                                       \n");
            queryStr.append("      ,PR_ID                                          \n");
            queryStr.append("      ,PR_NO                                          \n");
            queryStr.append("      ,DRAWING_LIST                                   \n"); 
            queryStr.append("      ,MAKER_LIST                                     \n");
            queryStr.append("      ,REQUEST_DATE                                   \n"); 
            queryStr.append("      ,COMPLETE_DATE                                  \n");             
            queryStr.append("      ,PR_DATE                                        \n");
            queryStr.append("      ,AUTHORIZATION_STATUS                           \n");
            queryStr.append("      ,ORIGINAL_PR_FLAG                               \n");
            queryStr.append("      ,PO_ETC                                         \n"); 
            queryStr.append("      ,PND_DATE                                       \n"); 
            queryStr.append("      ,ITEM_CODE                                      \n"); 
            queryStr.append("      ,PR_REQUESTER                                   \n");
            queryStr.append("      ,SELECTED_MAKER                                 \n");
            queryStr.append("      ,PO_NO                                          \n");
            queryStr.append("      ,PO_REQUESTER                                   \n");
            queryStr.append("      ,PO_DEPT_NAME                                   \n");
            queryStr.append("      ,PO_DATE                                        \n");
            queryStr.append("      ,PR_DEPT_CHANGEABLE_YN                          \n"); 
            queryStr.append("  FROM PLM_PR_VENDOR_REGISTER_MAIN_V                  \n");
            queryStr.append(" WHERE 1=1                                            \n");
            queryStr.append("   AND PROJECTNO = '"+projectNo+"'                    \n");
            if(!"".equals(deptCode))
            {
                queryStr.append("   AND DEPTCODE  = '"+deptCode+"'               \n");
            }
            queryStr.append(" GROUP BY  PROJECTNO                                  \n");  
            queryStr.append("          ,DWGDEPTNM                                  \n");
            queryStr.append("          ,DWGCODE                                    \n"); 
            queryStr.append("          ,DWGTITLE                                   \n"); 
            queryStr.append("          ,DR_DATE                                    \n");
            queryStr.append("          ,PR_PLAN_DATE                               \n"); 
            queryStr.append("          ,PO_PLAN_DATE                               \n");
            queryStr.append("          ,RECEIVE_ACT_DATE                           \n");
            queryStr.append("          ,CATALOGS                                   \n");
            queryStr.append("          ,PR_ID                                      \n");
            queryStr.append("          ,PR_NO                                      \n");
            queryStr.append("          ,DRAWING_LIST                               \n");
            queryStr.append("          ,MAKER_LIST                                 \n");
            queryStr.append("          ,REQUEST_DATE                               \n");
            queryStr.append("          ,COMPLETE_DATE                              \n");            
            queryStr.append("          ,PR_DATE                                    \n"); 
            queryStr.append("          ,AUTHORIZATION_STATUS                       \n");
            queryStr.append("          ,ORIGINAL_PR_FLAG                           \n");
            queryStr.append("          ,PO_ETC                                     \n");
            queryStr.append("          ,PND_DATE                                   \n");
            queryStr.append("          ,ITEM_CODE                                  \n");
            queryStr.append("          ,PR_REQUESTER                               \n");
            queryStr.append("          ,SELECTED_MAKER                             \n");
            queryStr.append("          ,PO_NO                                      \n");
            queryStr.append("          ,PO_REQUESTER                               \n");  
            queryStr.append("          ,PO_DEPT_NAME                               \n");
            queryStr.append("          ,PO_DATE                                    \n"); 
            queryStr.append("          ,PR_DEPT_CHANGEABLE_YN                      \n"); 
            queryStr.append(" ORDER BY DWGCODE                                     \n"); 
            
            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());


			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("DWGDEPTNM", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("DWGCODE", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("DWGTITLE", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("DR_DATE", rset.getString(5) == null ? "" : rset.getString(5));
                resultMap.put("PR_PLAN_DATE", rset.getString(6) == null ? "" : rset.getString(6));
                resultMap.put("PO_PLAN_DATE", rset.getString(7) == null ? "" : rset.getString(7));
                resultMap.put("RECEIVE_ACT_DATE", rset.getString(8) == null ? "" : rset.getString(8));
                resultMap.put("CATALOGS", rset.getString(9) == null ? "" : rset.getString(9));
                resultMap.put("PR_ID", rset.getString(10) == null ? "" : rset.getString(10));
                resultMap.put("PR_NO", rset.getString(11) == null ? "" : rset.getString(11));
                resultMap.put("DRAWING_LIST", rset.getString(12) == null ? "" : rset.getString(12));
                resultMap.put("MAKER_LIST", rset.getString(13) == null ? "" : rset.getString(13));
                resultMap.put("REQUEST_DATE", rset.getString(14) == null ? "" : rset.getString(14));
                resultMap.put("COMPLETE_DATE", rset.getString(15) == null ? "" : rset.getString(15));
                resultMap.put("PR_DATE", rset.getString(16) == null ? "" : rset.getString(16));
                resultMap.put("AUTHORIZATION_STATUS", rset.getString(17) == null ? "" : rset.getString(17));
                resultMap.put("ORIGINAL_PR_FLAG", rset.getString(18) == null ? "" : rset.getString(18));
                resultMap.put("PO_ETC", rset.getString(19) == null ? "" : rset.getString(19));
                resultMap.put("PND_DATE", rset.getString(20) == null ? "" : rset.getString(20));
                resultMap.put("ITEM_CODE", rset.getString(21) == null ? "" : rset.getString(21));
                resultMap.put("PR_REQUESTER", rset.getString(22) == null ? "" : rset.getString(22));
                resultMap.put("SELECTED_MAKER", rset.getString(23) == null ? "" : rset.getString(23));
                resultMap.put("PO_NO", rset.getString(24) == null ? "" : rset.getString(24));
                resultMap.put("PO_REQUESTER", rset.getString(25) == null ? "" : rset.getString(25));
                resultMap.put("PO_DEPT_NAME", rset.getString(26) == null ? "" : rset.getString(26));
                resultMap.put("PO_DATE", rset.getString(27) == null ? "" : rset.getString(27));
                resultMap.put("PR_DEPT_CHANGEABLE_YN", rset.getString(28) == null ? "" : rset.getString(28));
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
        //System.out.println("~~~ resultArrayList = "+resultArrayList);
        return resultArrayList;        
    }
%>


<%
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String inputMakerListYN = StringUtil.setEmptyExt(emxGetParameter(request, "inputMakerListYN"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));

    String prCreatorDisplay = "Y".equals(inputMakerListYN) ? "block" : "none";


    //System.out.println("  projectNo = "+projectNo);
    //System.out.println("  deptCode = "+deptCode);
    //System.out.println("  inputMakerListYN = "+inputMakerListYN);
    //System.out.println("  loginID = "+loginID);

    ArrayList deptDrawingList = null;
    Map keyEventMap = null;
    if (!projectNo.equals(""))
    {
        deptDrawingList = getDeptDrawingList(projectNo,deptCode);   
        keyEventMap = getKeyEventDates(projectNo);
    }

    HashMap tempMap = new java.util.HashMap();
    String tempLastDwgCode = "";
    for(int h=0; h < deptDrawingList.size(); h++)
    {
        Map tMap = (Map)deptDrawingList.get(h);
        String tempDwgCode = (String)tMap.get("DWGCODE");
        if(!tempLastDwgCode.equals(tempDwgCode))
        {
            tempLastDwgCode = tempDwgCode;
            tempMap.put(tempDwgCode, "1");
        } else {
            int tempDwgCnt = Integer.parseInt((String)tempMap.get(tempLastDwgCode));
            tempDwgCnt++;
            tempMap.put(tempLastDwgCode,Integer.toString(tempDwgCnt));
        }
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
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript">
<% if(keyEventMap != null)
{ 
    %>
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventCT.value = '<%=(String)keyEventMap.get("CT")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventSC.value = '<%=(String)keyEventMap.get("SC")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventKL.value = '<%=(String)keyEventMap.get("KL")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventLC.value = '<%=(String)keyEventMap.get("LC")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventDL.value = '<%=(String)keyEventMap.get("DL")%>';
    <%
} 
%>

var activeElement = null;
var activeElementPair = null; 
var isNewShow = false;
//document.onclick = mouseClickHandler;

function f_scroll()
{
    var x = document.all["list"].scrollLeft;
    document.all["intitle"].style.left = 0 - x;
}

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

/*
// 입력 컨트롤에서 값 입력(변경) 시 입력 컨트롤은 숨기고 해당 필드에 입력된 값을 표시한다
function elementSelChanged(elemPrefix, timeKey)
{
    var elemInput = frmEquipItemPurchasingManagementMain.all('temp'+elemPrefix + timeKey);
    var elemSel = frmEquipItemPurchasingManagementMain.all(elemPrefix + timeKey);
    elemInput.value = elemSel.value;

    // 수정사항 발생 여부 플래그 설정
    frmEquipItemPurchasingManagementMain.dataChanged.value = "true";       
}


// 필드 선택 시 각 필드의 입력 컨트롤을 표시한다. 입력 컨트롤은 기본적으로 Hidden되어 있다가 해당 필드가 Click될 때만 보여진다.
function showElementSel(elemPrefix, timeKey)
{
    var elemInput = frmEquipItemPurchasingManagementMain.all('temp'+elemPrefix + timeKey);
    var elemSel = frmEquipItemPurchasingManagementMain.all(elemPrefix + timeKey);

    toggleActiveElementDisplay();
    elemInput.style.display = 'none';
    elemSel.style.display = '';

    activeElement = elemSel;
    activeElementPair = elemInput;
}

// 마우스 클릭 시 현재 활성화된 입력 컨트롤을 숨긴다(해당 컨트롤에 대한 마우스 클릭이 아닌 경우)
function mouseClickHandler(e)
{
    if (activeElement == null) return;
    if (isNewShow) {
        isNewShow = false;
        return;
    }

    var posX = event.clientX;
    var posY = event.clientY;
    var objPos = getAbsolutePosition(activeElement);
    if (posX < objPos.x || posX > objPos.x + activeElement.offsetWidth || posY < objPos.y  || posY > objPos.y + activeElement.offsetHeight)
    {
        toggleActiveElementDisplay();
    }
}

// 입력 값 표시 필드와 입력 컨트롤의 Display(보여지는 것)를 상호 대치한다
function toggleActiveElementDisplay()
{
    if (activeElement != null) {
        activeElement.style.display = 'none';
        if (activeElementPair != null) activeElementPair.style.display = '';
        activeElement = null;
        activeElementPair = null;
    }
}
*/

// checkbox 모두 체크
function allSelected()
{
   var operand = "";
   var bChecked = false;
   var count = eval("document.frmEquipItemPurchasingManagementMain.elements.length");

   var typeStr = "";
   //retrieve the checkAll's checkbox value
   var allChecked = eval("document.frmEquipItemPurchasingManagementMain.checkAll.checked");

   for(var i = 1; i < count; i++) 
   {
      operand = "document.frmEquipItemPurchasingManagementMain.elements[" + i + "].checked";
      
      typeStr = eval("document.frmEquipItemPurchasingManagementMain.elements[" + i + "].type");
      
      if(typeStr == "checkbox")
      {
         // Added the below line to check whether the check box is grayed or not.
         bChecked = eval("document.frmEquipItemPurchasingManagementMain.elements[" + i + "].disabled");
         
         // if the check box is grayed out, it cannot be selected.
         if(bChecked == false)
         {
             operand += " = " + allChecked + ";";
             
             eval (operand);
         }
      }
   }
   return;
}



function searchPurchasingCode(index, catalogs, pndDate)
{
    var itemcode_Qty = document.frmEquipItemPurchasingManagementMain.elements['itemCode'+index].value;

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

function searchPrPoInfo(projectNo, prNo, drawingNo)
{
    
    var url = "stxPECEquipItemRegisterSearchPrPoInfo_SP.jsp?projectNo=" + projectNo;
        url += "&prNo="+prNo;
        url += "&drawingNo="+drawingNo;
        url += "&deptCode=" + document.frmEquipItemPurchasingManagementMain.deptCode.value;
        url += "&inputMakerListYN=" + document.frmEquipItemPurchasingManagementMain.inputMakerListYN.value;
        url += "&loginID=" + document.frmEquipItemPurchasingManagementMain.loginID.value;

    //window.open(url,"","width=900px, height=500px");
    //window.open(url,"","width=1100px, height=500px");
    var nwidth = 1100;
    var nheight = 500;
    var LeftPosition = (screen.availWidth-nwidth)/2;
    var TopPosition = (screen.availHeight-nheight)/2;

    var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

    window.open(url,"",sProperties);
}

function searchPrDeptOwner(index, drawingNo)
{
    var url = "stxPECEquipItemRegisterSearchPrDeptOwner_SP.jsp?index=" + index;
        url += "&drawingNo="+drawingNo;

    // window.showModalDialog(url, "", sProperties);
   // showModalDialog(url, "700", "450", true); // url, width, height, scrollbars
   // window.open(url,"","width=700px, height=500px");

    var nwidth = 700;
    var nheight = 500;
    var LeftPosition = (screen.availWidth-nwidth)/2;
    var TopPosition = (screen.availHeight-nheight)/2;

    var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

    window.open(url,"",sProperties);

}


// 체크 박스 체크
function changeCheckbox(obj)
{
    document.frmEquipItemPurchasingManagementMain.elements[obj].checked = true;
}

// 첨부SPEC 파일 VIEW
function fileView(prId)
{
    var attURL = "stxPECEquipItemFileView_SP.jsp?";
    attURL += "prId="+prId;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

    //window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}

// 설계검토 요청 파일 VIEW
function fileView_1(project, drawingNo)
{
    var attURL = "stxPECEquipItemFileView_1_SP.jsp?";
    attURL += "project="+project;
    attURL += "&drawingNo="+drawingNo;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

   // window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}

// 설계검토 완료 파일 VIEW
function fileView_2(project, drawingNo)
{
    var attURL = "stxPECEquipItemFileView_2_SP.jsp?";
    attURL += "project="+project;
    attURL += "&drawingNo="+drawingNo;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

   // window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}
</script>





<%--========================== HTML BODY ===================================--%>
<% // oncontextmenu : 마우스 우클립 팝업메뉴,  ondragstart : 마우스 드래그 %>
<body style="background-color:#ffffff">
<form name="frmEquipItemPurchasingManagementMain" method="post">

<table id="data_table" border="0" cellpadding="0" cellspacing="0" width="1227" style="table-layout:fixed;" bgcolor="#ffffff">
    <tr>
        <td>
        <div id="header_left" style="width:630; height:30; overflow:hidden; position:absolute; left:1; top:10;">

            <table width="100%" border="0" cellpadding="0" cellspacing="1" style="table-layout:fixed;" bgcolor="#cccccc">
                <tr align="center" height="28" bgcolor="#e5e5e5">
                    <td width="20" class="td_standardSmall" >
                       <input type="checkbox" name="checkAll">
                    </td>
                    <td width="20" class="td_standardSmall">No.
                    </td>
                    <td width="50" class="td_standardSmall">Project
                    </td>
                    <td width="50" class="td_standardSmall">부서
                    </td>
                    <td width="70" class="td_standardSmall">도면 No.
                    </td>
                    <td width="100" class="td_standardSmall">도면 Title
                    </td>
                    <td width="80" class="td_standardSmall">Catalog
                    </td>
                    <td width="80" class="td_standardSmall">Item Code
                    </td>
                    <td width="80" class="td_standardSmall">Maker List
                    </td>
                    <td width="70" class="td_standardSmall">도면 접수<BR>계획일자
                    </td>
                </tr>
             </table>
         </div>
         </td>
         <td>
         <div id="header_right" style="width:983; height:30; overflow:hidden;position:absolute; left:631; top:10;">
            <table width="100%" border="0" cellpadding="0" cellspacing="1" style="table-layout:fixed;" bgcolor="#cccccc">
                <tr align="center" height="28" bgcolor="#e5e5e5"> 
       
                    <td width="70" class="td_standardSmall" style="display:<%=prCreatorDisplay%>">견적PR<br>설계담당자
                    </td>                
                    <td width="70" class="td_standardSmall">PR No.
                    </td>
                    <td width="50" class="td_standardSmall">PR<BR>요청자
                    </td>
                    <td width="70" class="td_standardSmall">PR 발행<BR>계획일자
                    </td>
                    <td width="70" class="td_standardSmall">PR 승인일자
                    </td>
                    <td width="150" class="td_standardSmall">첨부 Spec.
                    </td>
                    <td width="70" class="td_standardSmall">설계검토요청
                    </td>
                    <td width="150" class="td_standardSmall">설계검토완료
                    </td>
                    <td width="70" class="td_standardSmall">PO No.
                    </td>
                    <td width="70" class="td_standardSmall">PO 발행<BR>계획일자
                    </td>
                    <td width="70" class="td_standardSmall">PO 승인일자
                    </td>
                    <td width="70" class="td_standardSmall">선정 Maker
                    </td>
                    <td width="70" class="td_standardSmall">구매 담당자
                    </td>
                    <td width="70" class="td_standardSmall">구매 담당부서
                    </td>
                    <td width="70" class="td_standardSmall">승인도<BR>접수일자
                    </td>
                    <td width="70" class="td_standardSmall">승인도<BR>승인일자
                    </td>
                </tr>
            </table>
        </div>
        </td>
    </tr>
    <tr>
        <td>
        <div id="list_left" style="width:648; height:700; overflow:scroll; position:absolute; left:1; top:40; background-color:#ffffff" onScroll="onScrollHandler2();">
            <table border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
            <%
            String sRowClass = "";
            String lastDwgCode = "";
            int cntNo = 0;
            for(int i=0; i<deptDrawingList.size(); i++)
            {
                sRowClass = ( (cntNo % 10 ) > 4  ? "tr_blue" : "tr_white");

                Map deptDrawingMap = (Map)deptDrawingList.get(i);
                String projectNoData = (String)deptDrawingMap.get("PROJECTNO");
                String deptName = (String)deptDrawingMap.get("DWGDEPTNM");                
                String dwgCode = (String)deptDrawingMap.get("DWGCODE");
                String dwgTitle = (String)deptDrawingMap.get("DWGTITLE");
                String drDate = (String)deptDrawingMap.get("DR_DATE");
                String catalogs = (String)deptDrawingMap.get("CATALOGS");
                String prId = (String)deptDrawingMap.get("PR_ID");
                String prNo = (String)deptDrawingMap.get("PR_NO");
                String drawingList = (String)deptDrawingMap.get("DRAWING_LIST");
                String makerList = (String)deptDrawingMap.get("MAKER_LIST");
                String pndDate = (String)deptDrawingMap.get("PND_DATE"); 
                String itemCode = (String)deptDrawingMap.get("ITEM_CODE");

                String original_pr_flag = (String)deptDrawingMap.get("ORIGINAL_PR_FLAG");

                String purchasingCodeQty = "";

				dwgTitle = dwgTitle.replace('\n',' ');

                String dwgTitleHint = replaceAmpAll(dwgTitle, "'", "＇");

                boolean inputMakerList = false;
                if("".equals(makerList) && "Y".equals(inputMakerListYN))
                {
                    inputMakerList = true;
                }

                if(!lastDwgCode.equals(dwgCode))
                {
                    cntNo++;
                } 

            %>
                
                <tr class="<%=sRowClass%>" align="center" height="40">

                <%
                    if(!lastDwgCode.equals(dwgCode))
                    {
                        lastDwgCode = dwgCode;
                        int dwgCodeCnt = Integer.parseInt((String)tempMap.get(dwgCode));                               
                %>
                        <td width="20" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>">
                    <%
                        if(!"N".equals(original_pr_flag))
                        {
                    %>
                           <input type="checkbox" name="checkbox<%=i%>" value="<%=i%>">
                    <%
                        }
                    %>
                        </td>
                        <td width="20" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=cntNo%></td>
                <%
                    }
                %> 
                    <td width="50" class="td_standardSmall"><%=projectNoData%>
                    </td>
                    <td width="50" class="td_standardSmall"><%=deptName%>
                    </td>
                    <td width="70" class="td_standardSmall">
                        <input type="hidden" name="drawingNo<%=i%>" value="<%=dwgCode%>"><%=dwgCode%>
                    </td>
                    <td width="100" class="td_standardSmall" onmouseover="showhint(this, '<%=dwgTitleHint%>');">
                        <input type="hidden" name="drawingTitle<%=i%>" value="<%=dwgTitle%>"><%=dwgTitle%>
                    </td>
                    <td width="80" class="td_standardSmall" onmouseover="showhint(this, '<%=catalogs%>');"><%=catalogs%>
                        <input type="hidden" name="pndDate<%=i%>" value="<%=pndDate%>">                       
                    </td>

                    <% // 대표코드 및 수량이 없으면 입력가능하게..
                    if("".equals(prId))
                    {
                    %>
                      <td width="80" class="td_standardSmall" bgcolor="#fff0f5" style="cursor:hand;" onmouseover="showhint(this, frmEquipItemPurchasingManagementMain.itemCodeView<%=i%>.value);" onclick="searchPurchasingCode('<%=i%>','<%=catalogs%>','<%=pndDate%>');" >
                            <input name="itemCodeView<%=i%>" value="" class="input_noBorder" style="width:99; height:20;background-color:#fff0f5;">
                            <input type="hidden" name="itemCode<%=i%>" value="">

                        </td>
                    <%
                    } else {
                        
                    %>
                    <td width="80" class="td_standardSmall"><%=itemCode%></td>
                    <%
                    }
                    %>

                    <%
                    if("".equals(prId))  //if(inputMakerList && "".equals(prId))
                    {
                    %>
                        <td width="80" class="td_standardSmall" bgcolor="#fff0f5" onmouseover="showhint(this, frmEquipItemPurchasingManagementMain.makerList<%=i%>.value);">

                            <input name="makerList<%=i%>" value="<%=makerList%>" class="input_noBorder" style="width:79;height:20;background-color:#fff0f5;" onChange="changeCheckbox('checkbox<%=i%>');">                            
                        </td>
                    <%
                    } else {
                    %>
                      <td width="80" class="td_standardSmall" onmouseover ="showhint(this, frmEquipItemPurchasingManagementMain.makerList<%=i%>.value);">
                            <input type="hidden" name="makerList<%=i%>" value="<%=makerList%>"><%=makerList%>
                        </td>
                    <%
                    }
                    %>

                    <td width="70" class="td_standardSmall"><input type="hidden" name="drDate<%=i%>" value="<%=drDate%>"><%=drDate%>
                    </td>
                </tr>
            <%
            }
            if(deptDrawingList.size() < 1)
            {
            %>
                <tr align="center" height="40" bgcolor="#ffffff">
                    <td colspan="9" class="td_standardSmall" >
                        no data.
                    </td>
                </tr>
            <%
            }
            %>
            </table>
        </div>
        </td>
        <td>
        <div id="list_right" style="width:1000; height:700; overflow:scroll; position:absolute; left:631 ;top:40; background-color:#ffffff" onScroll="onScrollHandler();">
            <table border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">

            <%
            String sRowClass1 = "";
            String lastDwgCode1 = "";
            int cntNo1 = 0;
            for(int i=0; i<deptDrawingList.size(); i++)
            {
                sRowClass1 = ( (cntNo1 % 10 ) > 4 ? "tr_blue" : "tr_white");

                Map deptDrawingMap = (Map)deptDrawingList.get(i);
                String projectNoData = (String)deptDrawingMap.get("PROJECTNO");            
                String dwgCode = (String)deptDrawingMap.get("DWGCODE");
                String prPlanDate = (String)deptDrawingMap.get("PR_PLAN_DATE");
                String poPlanDate = (String)deptDrawingMap.get("PO_PLAN_DATE");
                String receive_act_date = (String)deptDrawingMap.get("RECEIVE_ACT_DATE");
                String prId = (String)deptDrawingMap.get("PR_ID");
                String prNo = (String)deptDrawingMap.get("PR_NO");
                String request_date = (String)deptDrawingMap.get("REQUEST_DATE");
                String complete_date = (String)deptDrawingMap.get("COMPLETE_DATE");
                String pr_requester = (String)deptDrawingMap.get("PR_REQUESTER");
                String pr_date = (String)deptDrawingMap.get("PR_DATE");
                String pr_authorization_status = (String)deptDrawingMap.get("AUTHORIZATION_STATUS");
                String original_pr_flag = (String)deptDrawingMap.get("ORIGINAL_PR_FLAG");
                String po_no = (String)deptDrawingMap.get("PO_NO");
                String po_date = (String)deptDrawingMap.get("PO_DATE");
                String po_requester = (String)deptDrawingMap.get("PO_REQUESTER");                
                String po_dept_name = (String)deptDrawingMap.get("PO_DEPT_NAME");
                String selected_maker = (String)deptDrawingMap.get("SELECTED_MAKER");
                String pr_dept_changeable_yn = (String)deptDrawingMap.get("PR_DEPT_CHANGEABLE_YN");

                if(!lastDwgCode1.equals(dwgCode))
                {
                    cntNo1++;
                    lastDwgCode1 = dwgCode;
                }

                // if(!"Y".equals(original_pr_flag)) original_pr_flag = "N";
                String original_pr_flag_desc = "";

                if("Y".equals(original_pr_flag))
                {
                    original_pr_flag_desc = "(본)";
                } else {
                   original_pr_flag_desc = "(추)";
                }

                String pr_authorization_status_desc = "";
                String bgcolor = "";
                if("INCOMPLETE".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"미완료"+")";
                    bgcolor = "red";
                } else if("PRE-APPROVED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"사전승인"+")";
                    bgcolor = "cyan";
                } else if("APPROVED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"승인됨"+")";
                    bgcolor = "yellowgreen";
                } else if("CANCELLED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"취소"+")";
                    bgcolor = "red";
                } else if("REJECTED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"거절"+")";
                    bgcolor = "orange";
                } else {
                    pr_authorization_status_desc = "";
                }

                if(!"Y".equals(original_pr_flag) && "APPROVED".equals(pr_authorization_status))
                {
                    bgcolor = "yellow";
                }

            %>
                <tr class="<%=sRowClass1%>" align="center" height="40">
                <input type="hidden" name="pr_dept_changeable_yn<%=i%>" value="<%=pr_dept_changeable_yn%>">
                    <% // 견적기획P에서 PR발행하는 도면의 경우 설계부서 담당자 지정 필요
                    if("Y".equals(inputMakerListYN))
                    {
                        if("Y".equals(pr_dept_changeable_yn) && ("".equals(prId)) )
                        {
                    %>
                            <td width="70" class="td_standardSmall" bgcolor="red" style="cursor:hand;" onclick="searchPrDeptOwner('<%=i%>','<%=dwgCode%>');">
                                <input name="pr_dept_changeable_ownerView<%=i%>" value="" class="input_noBorder" style="width:40; height:20;background-color:red;">
                                <input type="hidden" name="pr_dept_changeable_owner<%=i%>" value="">
                            </td>
                    <%
                        } else {
                    %>
                            <td width="70" class="td_standardSmall">
                                <input type="hidden" name="pr_dept_changeable_owner<%=i%>" value="">
                            </td> 
                    <%
                        } 
                    } else {
                    %>
                        <input type="hidden" name="pr_dept_changeable_owner<%=i%>" value="">
                    <%
                    }
                    %>                        

                    <%
                    if(!"".equals(prId))
                    {
                    %>
                        <td width="70" class="td_standardSmall" bgcolor="<%=bgcolor%>" style="cursor:hand;" onclick="searchPrPoInfo('<%=projectNoData%>','<%=prNo%>','<%=dwgCode%>');">
                            <input type="hidden" name="prNo<%=i%>" value="<%=prNo%>"><%=prNo%>&nbsp;&nbsp;<%=original_pr_flag_desc%><br><%=pr_authorization_status_desc%>
                        </td>
                    <%
                    } else {  
                    %>
                        <td width="70" class="td_standardSmall">
                            <input type="hidden" name="prNo<%=i%>" value="<%=prNo%>"><%=prNo%>
                        </td>
                    <%
                    }
                    %>
                    <input type="hidden" name="pr_authorization_status<%=i%>" value="<%=pr_authorization_status%>">
                    <input type="hidden" name="original_pr_flag<%=i%>" value="<%=original_pr_flag%>">

                    <td width="50" class="td_standardSmall"><%=pr_requester%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=prPlanDate%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=pr_date%>                        
                    </td>

                    <%
                    if("".equals(prId))
                    {
                    %>                    
                        <td width="150" class="td_standardSmall">
                            <input type="file" name="fileName<%=i%>" style="width:150;" onKeyDown="return false" onchange="changeCheckbox('checkbox<%=i%>')">                    
                        </td>
                    <%
                    } else {
                    %>
                        <td width="150" class="td_standardSmall">
                            <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView('<%=prId%>');">     
                        </td>
                    <%
                    }
                    %>
                    
                    <%
                    if("".equals(request_date))
                    {
                    %>                    
                        <td width="70" class="td_standardSmall">              
                        </td>
                    <%
                    } else {
                    %>
                        <td width="70" class="td_standardSmall"><%=request_date%>
                            <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView_1('<%=projectNoData%>','<%=dwgCode%>');">           
                        </td>
                    <%
                    }
                    %>                    
                    
                    <%
                    if(!"".equals(prId) && !"".equals(request_date) && "Y".equals(original_pr_flag))
                    {   // 첨부 SPEC이 있고, 설계검토요청도 있고
                        if("".equals(complete_date))
                        {  // 설계검토완료는 없을 때는 파일첨부 가능
                    %>                    
                            <td width="150" class="td_standardSmall">
                                <input type="file" name="completeFile<%=i%>" style="width:150;" onKeyDown="return false" onchange="changeCheckbox('checkbox<%=i%>')">                    
                            </td>
                    <%
                        } else {
                            // 설계검토완료가 있을 땐 VIEW
                    %>
                            <td width="150" class="td_standardSmall"><%=complete_date%>
                                <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView_2('<%=projectNoData%>','<%=dwgCode%>');">           
                            </td>                        
                    <%
                        }
                    } else { // 그외는 공란
                    %>
                         <td width="150" class="td_standardSmall">              
                        </td>
                    <%
                    }
                    %>                   

                    <td width="70" class="td_standardSmall"><%=po_no%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=poPlanDate%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=po_date%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=selected_maker%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=po_requester%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=po_dept_name%>
                    </td>
                    <td width="70" class="td_standardSmall"><%=receive_act_date%>
                    </td>
                    <td width="70" class="td_standardSmall">
                    </td>
                </tr>
            <%
            }
            if(deptDrawingList.size() < 1)
            {
            %>
                <tr align="center" height="40" bgcolor="#ffffff">
                    <td colspan="9" class="td_standardSmall" >
                        no data.
                    </td>
                </tr>
            <%
            }
            %>

            </table>
         </div>
         </td>
    </tr>
</table>

<input type="hidden" name="dataChanged" value="false">
<input type="hidden" name="loginID" value="<%=loginID%>">
<input type="hidden" name="projectNo" value="<%=projectNo%>">
<input type="hidden" name="deptCode" value="<%=deptCode%>">
<input type="hidden" name="inputMakerListYN" value="<%=inputMakerListYN%>">

</form>


<script language="javascript">
	// screen resize
	var screenWidth = window.document.body.clientWidth;
	var screenHeight = window.document.body.clientHeight;
	
	//alert("현재 해상도 : " + screenWidth + " X " + screenHeight);
	
	if(screenWidth>2375)
		screenWidth = 2375;
		
	//Table 해상도 변경
	document.getElementById("data_table").width 				= screenWidth - 30;		
	
	//List Left(DIV) 해상도 변경
	document.getElementById("list_left").style.height 			= screenHeight - 60;

	//Header Right(TD) 해상도 변경
	var header_left_width = parseInt(document.getElementById("header_left").style.width);
	document.getElementById("header_right").style.width 			= screenWidth - header_left_width - 30;

	//List Right(TD) 해상도 변경
	var list_left_width = parseInt(document.getElementById("list_left").style.width);
	document.getElementById("list_right").style.width 				= screenWidth - list_left_width - 30 + 36;  // 36은 scroll size (18*2)
	
	//List Right(DIV) 해상도 변경
	document.getElementById("list_right").style.height 			= screenHeight - 60;
</script>
</body>
</html>


            