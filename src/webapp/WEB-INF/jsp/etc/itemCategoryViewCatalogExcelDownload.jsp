<%--  
��DESCRIPTION: EP ǰ�� �������� ��ȸ - īŻ�α� ����Ʈ ���� �ٿ�ε� 
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxEPInfoViewCatalogExcelDownload.jsp
--%>

<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%  // ���������� ������ ������ ��ȯ�ϱ� ���� ����
	//response.setContentType("application/msexcel");
	response.setHeader("Content-Disposition", "attachment; filename=ExcelDownload.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 

%>


    

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr"/>
</head>
<body>
<form name="frmCatalog" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr><td>&nbsp;</td></tr>
    <tr><td>ǰ�� �з�ǥ - CATALOG</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr>
        <td>
            <table width="100%" border="1" cellpadding="0" cellspacing="1">
                <tr align="center" style="color:#ffffff" bgcolor="#006699">
                    <td>CATEGORY</td>
                    <td>CATALOG</td>
                    <td>CODE</td>
                    <td>ITEM����</td>
                    <td>CODE</td>
                    <td>��з�</td>
                    <td>CODE</td>
                    <td>�ߺз�</td>
                    <td>CODE</td>
                    <td>DESCRIPTION</td>
                    <td>���鿬��</td>
                    <td>UOM</td>
                    <td>L/T</td>
                    <td>MRP</td>
                    <td>L/T(Ư����)</td>
                    <td>MRP(Ư����)</td>                    
                    <td>������1</td>
                    <td>������2</td>
                    <td>������3</td>
                    <td>������4</td>
                    <td>������5</td>
                    <td>������6</td>
                    <td>������7</td>
                    <td>������8</td>
                    <td>������9</td>
                    <td>������10</td>
                    <td>������11</td>
                    <td>������12</td>
                    <td>������13</td>
                    <td>������14</td>
                    <td>������15</td>
                </tr>
            </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="1">
          		<c:forEach var="item" items="${list}" varStatus="status"> 
	                <tr bgcolor="#ffffff">
	                    <td align="center">${item.CATEGORY_CODE}</td>
	                    <td align="center" style = "mso-number-format:\@">${item.CATALOG_CODE}</td>
	                    <td align="center">${item.item_list_code}</td>
	                    <td>&nbsp;${item.item_list_desc}</td>
	                    <td align="center" style = "mso-number-format:\@">${item.l_catalog_code}</td>
	                    <td>&nbsp;${item.l_catalog_desc}</td>
	                    <td align="center" style = "mso-number-format:\@">${item.m_catalog_code}</td>
	                    <td>&nbsp;${item.m_catalog_desc}</td>
	                    <td align="center" style = "mso-number-format:\@">${item.s_catalog_code}</td>
	                    <td>&nbsp;${item.s_catalog_desc}</td>
	                    <td align="center">${item.dwg_flag}</td>
	                    <td>&nbsp;${item.uom_code}</td>
	                    <td>${item.full_lead_time}</td>
	                    <td>${item.mrp_planning_desc}</td>
	                    <td align="center">${item.sp_full_lead_time}</td>
	                    <td align="center">${item.sp_mrp_planning_desc}</td>
	                    <td>&nbsp;${item.ele_name_1}</td>
	                    <td>&nbsp;${item.ele_name_2}</td>
	                    <td>&nbsp;${item.ele_name_3}</td>
	                    <td>&nbsp;${item.ele_name_4}</td>
	                    <td>&nbsp;${item.ele_name_5}</td>
	                    <td>&nbsp;${item.ele_name_6}</td>
	                    <td>&nbsp;${item.ele_name_7}</td>
	                    <td>&nbsp;${item.ele_name_8}</td>
	                    <td>&nbsp;${item.ele_name_9}</td>
	                    <td>&nbsp;${item.ele_name_10}</td>
	                    <td>&nbsp;${item.ele_name_11}</td>
	                    <td>&nbsp;${item.ele_name_12}</td>
	                    <td>&nbsp;${item.ele_name_13}</td>
	                    <td>&nbsp;${item.ele_name_14}</td>
	                    <td>&nbsp;${item.ele_name_15}</td>
	                 </tr>
          		</c:forEach>
            </table>

        </td>
    </tr>
</table>
                  
</body>
</html>