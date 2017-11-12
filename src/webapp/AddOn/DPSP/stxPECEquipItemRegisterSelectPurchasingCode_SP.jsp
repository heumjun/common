<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 대표코르 및 수량 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterSelectPurchasingCode_SP.jsp
§CHANGING HISTORY: 
§    2010-03-25: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "com.stx.common.util.FrameworkUtil"%>
<%@ page import="java.util.*" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

    private ArrayList searchCatalogPurchasingCode(String catalogs) throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

        ArrayList catalogList = FrameworkUtil.split(catalogs, ",");

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");    
            stmt = conn.createStatement();

            for(int i=0; i<catalogList.size(); i++)
            {
                String sCatalog = (String)catalogList.get(i);

                StringBuffer queryStr = new StringBuffer();
                queryStr.append("select micg.segment1         as catalog_code                      \n");
                queryStr.append("      ,msi.segment1          as item_code                         \n");
                queryStr.append("      ,msi.description       as item_desc                         \n");
                queryStr.append("  from mtl_system_items_b        msi                              \n");
                queryStr.append("      ,mtl_item_catalog_groups_b micg                             \n");
                queryStr.append(" where micg.item_catalog_group_id = msi.item_catalog_group_id     \n");
                queryStr.append("   and msi.organization_id = 82                                   \n");
				queryStr.append("   AND msi.ITEM_TYPE NOT IN ('BS','GS','CT')                      \n");   // 2012-04-28 Kang seonjung : BS,GS,CT(비용성자재)는 PR 발행못함. Manual로 해라.
				queryStr.append("   AND msi.MRP_PLANNING_CODE != 3                                 \n");   // 2012-04-28 Kang seonjung : MRP 발행 대상 품목은 기자재 PR 발행 못함
				queryStr.append("   AND msi.INVENTORY_ITEM_STATUS_CODE != 'Inactive'               \n");   // 2013-01-07 Kang seonjung : Inactive Item은 PR 발행 못함.
                if( sCatalog.startsWith("Z") || sCatalog.startsWith("3BF") || sCatalog.startsWith("3BG") || sCatalog.startsWith("1AC") || sCatalog.startsWith("1B1") || sCatalog.startsWith("3AB") )
                {
                    queryStr.append("   and msi.segment1       = '"+sCatalog+"-00000"+"'           \n");
                } else {
                    queryStr.append("   and micg.segment1      = '"+sCatalog+"'                    \n");
                }
                queryStr.append(" order by msi.segment1 asc, micg.segment1 desc                    \n");

                rset = stmt.executeQuery(queryStr.toString());

                int count = 0;
                while (rset.next())
                {
                    count++;
                    java.util.HashMap resultMap = new java.util.HashMap();
                    resultMap.put("CATALOG_CODE", rset.getString(1));
                    resultMap.put("ITEM_CODE", rset.getString(2));
                    resultMap.put("ITEM_DESC", rset.getString(3));
                    resultArrayList.add(resultMap);
                }
            }
		} catch (Exception e) {
            e.printStackTrace();
        }

		finally {
            if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
    }


%>


<%--========================== JSP =========================================--%>
<%

   // request.setCharacterEncoding("euc-kr"); 

    String index = emxGetParameter(request, "index");
    String catalogs = emxGetParameter(request, "catalogs");
    String pndDate = emxGetParameter(request, "pndDate");  
    String itemcode_Qty = emxGetParameter(request, "itemcode_Qty");
    ArrayList itemList = new ArrayList();
    ArrayList quantityList = new ArrayList();

    StringTokenizer itemCodeListToken = new StringTokenizer(itemcode_Qty , ",");  //AA|1,BB|2,CC|1 이런식
    while(itemCodeListToken.hasMoreTokens())
    {
        String tempItemCodeToken = itemCodeListToken.nextToken();

        StringTokenizer itemCodeToken = new StringTokenizer(tempItemCodeToken , "|");
        itemList.add(itemCodeToken.nextToken());
        quantityList.add(itemCodeToken.nextToken());
    }   


    String errStr = "";

    ArrayList purchasingCodeList = null;
    try {
        purchasingCodeList = searchCatalogPurchasingCode(catalogs);
    }
    catch (Exception e) {
        errStr = e.toString();
    }

%>


<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE> 
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE> 


<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#f5f5f5">
<form name="frmSearchPurchasingCode">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="670" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>&nbsp;&nbsp;ITEM Code 및 Quantity</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="670" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">
            <td class="td_standardBold" style="background-color:#336699;" width="5%"><input type="checkbox" name="checkAll" onclick="allSelected()"></td>
            <td class="td_standardBold" style="background-color:#336699;" width="10%"><font color="#ffffff">Catalog</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="18%"><font color="#ffffff">Item Code</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="45%"><font color="#ffffff">Item Desc</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="10%"><font color="#ffffff">Quantity</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="12%"><font color="#ffffff">PND Date</font></td>
        </tr>
    </table>

        <div STYLE="width:670; height:300; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="670" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">            
            <%
            //String sRowClass = "";
            for(int i=0; i<purchasingCodeList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map purchasingCodeMap = (Map)purchasingCodeList.get(i);
                String catalog = (String)purchasingCodeMap.get("CATALOG_CODE");
                String itemCode = (String)purchasingCodeMap.get("ITEM_CODE");
                String itemDesc = (String)purchasingCodeMap.get("ITEM_DESC");
                String itemQty = "";
                String checked = "";
                
                for (int idx = 0; idx < itemList.size(); idx++)
                {
                    String prevItemStr = (String)itemList.get(idx);
                    if (itemCode.equals(prevItemStr))
                    {
                        checked = "checked";
                        itemQty = (String)quantityList.get(idx);
                    }
                }
             %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="5%"><input type="checkbox" name="checkbox<%=i%>" value="<%=i%>" <%=checked%>></td>
                    <td class="td_standard" width="10%"><%=catalog%></td>
                    <td class="td_standard" width="18%"><input type="hidden" name="itemCode<%=i%>" value="<%=itemCode%>"><%=itemCode%></td>
                    <td class="td_standardLeft" width="45%"><%=itemDesc%>
                    <td class="td_standard" width="10%"><input type="text" name="quantity<%=i%>" value="<%=itemQty%>" size=5 onblur="checkNumber(this);" onKeyDown="selectCheckbox(this,'checkbox<%=i%>');" onChange="changeCheckbox(this,'checkbox<%=i%>');"></td>
                    <td class="td_standard" width="12%"><%=pndDate%></td>
                </tr>
            <%
            }
            %>
        </table>
        </div>
<br><br>
    <table width="650" cellspacing="1" cellpadding="1">
        <tr height="45">
            <td style="text-align:right;">
                <hr>
                <input type="button" value="확인" class="button_simple" onclick="javascript:saveItemQuantity();"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>
<input type="hidden" name="index" value="<%=index%>">
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

// checkbox 모두 체크
function allSelected()
{
   var operand = "";
   var bChecked = false;
   var count = eval("document.frmSearchPurchasingCode.elements.length");

   var typeStr = "";
  
   //retrieve the checkAll's checkbox value
   var allChecked = eval("document.frmSearchPurchasingCode.checkAll.checked");

   for(var i = 0; i < count; i++) 
   {
      operand = "document.frmSearchPurchasingCode.elements[" + i + "].checked";
      
      typeStr = eval("document.frmSearchPurchasingCode.elements[" + i + "].type");
      
      
      if(typeStr == "checkbox")
      {
         // Added the below line to check whether the check box is grayed or not.
         bChecked = eval("document.frmSearchPurchasingCode.elements[" + i + "].disabled");
         
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

// 숫자만 사용 가능.
function checkNumber(obj)
{
    var attVal = obj.value;
    var chars = "0123456789";
    for (var index = 0; index < attVal.length; index++) {
       if (chars.indexOf(attVal.charAt(index)) == -1) {
           alert("only Number is possible");
           obj.focus();
           break;
       }
    }
}

// 체크 박스 체크
function selectCheckbox(obj, checkbox)
{

        document.frmSearchPurchasingCode.elements[checkbox].checked = true;

}

// 체크 박스 체크
function changeCheckbox(obj, checkbox)
{

    var attVal = obj.value;
    if(attVal=="" || attVal == null)
    {
        document.frmSearchPurchasingCode.elements[checkbox].checked = false;
    } /*else {
        document.frmSearchPurchasingCode.elements[checkbox].checked = true;
    }*/

}

function saveItemQuantity()
{
    var someSelected = false;
    var itemCodeList = "";
    var itemCodeViewList = "";
    var mainForm = document.frmSearchPurchasingCode;
    var index = mainForm.index.value;

    for(var i = 1; i < mainForm.elements.length; i++)
    {    
        if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
        {
            someSelected = true;

            checkboxIndex = mainForm.elements[i].value;

            tempitemCode = mainForm.elements['itemCode'+checkboxIndex].value;
            tempQuantity = mainForm.elements['quantity'+checkboxIndex].value;


            // Quantity의 시작이 0이면 에러
            if(tempQuantity.charAt(0) == '0')
            {
                alert("Quantity Format Error : " + tempQuantity);
                return;
            }

            if(tempQuantity=="" || tempQuantity==null)
            {
                alert("Quantity is empty !!");
                return;
            }

            tempSet1 = tempitemCode+"|"+tempQuantity;
            tempSet2 = tempitemCode+"  ( "+tempQuantity+" ) ";
            if(itemCodeList=="" || itemCodeList==null)
            {
                itemCodeList += tempSet1;
                itemCodeViewList += tempSet2;
            } else {
                itemCodeList += ","+tempSet1;
                itemCodeViewList += ",       <br>"+tempSet2;
            }
        }
    }
    /*
    if(!someSelected)
    {
        var msg = "Please make a selection.";
        alert(msg);
        return;
    }
    */
    //alert("itemCodeList = "+itemCodeList);
   // alert("itemCodeViewList = "+itemCodeViewList);

    //parent.window.opener.document.frmEquipItemPurchasingManagementMain.elements['itemCode'+index].value = itemCodeList;
    //parent.window.opener.document.frmEquipItemPurchasingManagementMain.elements['itemCodeView'+index].value = itemCodeViewList;
    parent.window.opener.document.forms[0].elements['itemCode'+index].value = itemCodeList;
    parent.window.opener.document.forms[0].elements['itemCodeView'+index].value = itemCodeViewList;
    window.close();
}
</script>


</html>