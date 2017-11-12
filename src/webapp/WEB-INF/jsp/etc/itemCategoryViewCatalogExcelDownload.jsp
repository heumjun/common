<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 카탈로그 리스트 엑셀 다운로드 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewCatalogExcelDownload.jsp
--%>

<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%  // 웹페이지의 내용을 엑셀로 변환하기 위한 구문
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
    <tr><td>품목 분류표 - CATALOG</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr>
        <td>
            <table width="100%" border="1" cellpadding="0" cellspacing="1">
                <tr align="center" style="color:#ffffff" bgcolor="#006699">
                    <td>CATEGORY</td>
                    <td>CATALOG</td>
                    <td>CODE</td>
                    <td>ITEM구분</td>
                    <td>CODE</td>
                    <td>대분류</td>
                    <td>CODE</td>
                    <td>중분류</td>
                    <td>CODE</td>
                    <td>DESCRIPTION</td>
                    <td>도면연계</td>
                    <td>UOM</td>
                    <td>L/T</td>
                    <td>MRP</td>
                    <td>L/T(특수선)</td>
                    <td>MRP(특수선)</td>                    
                    <td>물성값1</td>
                    <td>물성값2</td>
                    <td>물성값3</td>
                    <td>물성값4</td>
                    <td>물성값5</td>
                    <td>물성값6</td>
                    <td>물성값7</td>
                    <td>물성값8</td>
                    <td>물성값9</td>
                    <td>물성값10</td>
                    <td>물성값11</td>
                    <td>물성값12</td>
                    <td>물성값13</td>
                    <td>물성값14</td>
                    <td>물성값15</td>
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