<%--  
��DESCRIPTION: EP ǰ�� �������� ��ȸ - ���ſ�û/��뼺/BSI/GSI �׸� ���� �ٿ�ε�
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxEPInfoViewItemListExcelDownload.jsp
--%>

<%  // ���������� ������ ������ ��ȯ�ϱ� ���� ����
	//response.setContentType("application/vnd.ms-excel; charset=UTF-8");
	response.setContentType("application/msexcel");
	response.setHeader("Content-Disposition", "attachment; filename=ExcelDownload.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 
%>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body>
<form name="frmCatalog" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr><td>&nbsp;</td></tr>
    <tr><td>ǰ�� �з�ǥ - ���ſ�û/��뼺ǰ��/BSI/GSI</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr>
        <td>
            <table width="100%" border="1" cellpadding="0" cellspacing="1">
                <tr align="center" style="color:#ffffff" bgcolor="#006699">
                    <td>CATALOG</td>
                    <td>CATEGORY</td>
                    <td>ITEM CODE</td>
                    <td>DESCRIPTION</td>
                    <td>TEMPLATE</td>
                </tr>
            </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="1">
           		<c:forEach var="item" items="${list}" varStatus="status"> 
	                <tr class="title_8" height="24" bgcolor="#ffffff">
	                    <td align="center" style = "mso-number-format:\@">${item.catalog_code}</td>
	                    <td align="center">${item.category_code}</td>
	                    <td align="center">${item.part_no}</td>
	                    <td>&nbsp;&nbsp;${item.description}</td>
	                    <td align="center">${item.item_type_desc}</td>
	                 </tr>
          		</c:forEach>
            </table>

        </td>
    </tr>
</table>
                  
</body>
</html>