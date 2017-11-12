<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>PartFamilyDesc</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="partFamilyCode_form" name="partFamilyCode_form">
<input type="hidden" 	id="txtCodeGbn"  name="p_code_gbn" 	value="partfamilyDesc" />
<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="conSearch">
		Code <input type="text" id="txtCodeFind" name="p_code_find" value="${cmtype}" style="text-transform:uppercase;" class="w200h25 mgt10" onchange="javascript:this.value=this.value.toUpperCase();" />
	</div>
	<div class="button">
		<input type="button" id="btncheck" value="확인" class="btn_blue" />
		<input type="button" id="btnFind" value="조회" class="btn_blue" />
		<input type="button" id="btncancle" value="닫기" class="btn_blue" />
	</div>
</div>
<div class="content">
	<table id="partFamilyTypeList"></table>
</div>

			
<!-- <div> -->
<!-- 찾기 <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 350px;"/> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<table id="partFamilyTypeList" style="width:100%;height:50%"></table> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<input type="button" id="btnfind"   value="찾기"/> -->
<!-- 	<input type="button" id="btncheck"  value="확인"/> -->
<!-- 	<input type="button" id="btncancle" value="취소"/> -->
<!-- </div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
	$("#partFamilyTypeList").jqGrid({ 
             datatype: 'json', 
             mtype : 'POST',
             url:'popUpPartFamilyDescList.do',
             postData : $("#partFamilyCode_form").serialize(),
             editUrl  : 'clientArray',
        	 colNames :['Part Family Desc','Part Family Code'],
                colModel:[
                    {name:'part_family_desc',index:'part_family_desc', width:150, sortable:false, editoptions:{size:11}},
                    {name:'part_family_code',index:'part_family_code', width:125, sortable:false, editoptions:{size:5}}
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 360,
             rowNum: 999999,
           
             pgbuttons: false,
			 pgtext: false,
			 pginput:false,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			var rowData = jQuery(this).getRowData(rowId); 
    			var part_family_code = rowData['part_family_code'];
    			var part_family_desc = rowData['part_family_desc'];
    			
    			var returnValue = new Array();
      			returnValue[0] = part_family_code;
      			returnValue[1] = part_family_desc;
      			window.returnValue = returnValue;
      			self.close();
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
	                             
                                 row_selected = row_id;
                             }
                          }
    });
    
        
    $('#btncancle').click(function(){
		self.close();
	});

	$('#btnFind').click(function(){
		
		var sUrl = "popUpPartFamilyDescList.do";
		jQuery("#partFamilyTypeList").jqGrid('setGridParam',{mtype: 'POST',url:sUrl,page:1,postData: $("#partFamilyCode_form").serialize()}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#partFamilyTypeList").getRowData(row_selected);  		
		var returnValue = new Array();
		returnValue[0] = ret.part_family_code;
		returnValue[1] = ret.part_family_desc;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});
</script>
</body>
</html>
