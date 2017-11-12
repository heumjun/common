<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Code</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listform" name="listform">
	<input type="hidden" 	id="txtCodeGbn"  name="p_code_gbn" 	value="paintCode" />
	
	
	
	
	<div class="topMain" style="margin: 0px;line-height: 45px;">
			<div class="conSearch">
				<span class="pop_tit">Paint Code</span>
				<input type="text" id="txtItemCode" name="item_code" style="width: 130px;" />
				&nbsp;&nbsp;
				<span class="pop_tit">Desc</span>
				<input type="text" id="txtItemDesc" name="item_desc" style="width: 150px;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			</div>
			<div class="button">
				<input type="button" id="btnfind"   value="조회" class="btn_blue"/>
				<input type="button" id="btncheck"  value="확인" class="btn_blue"/>
				<!-- <input type="button" id="btncancel" value="닫기" class="btn_blue"/> -->
			</div>
		</div>
		<div class="content">
			<table id="paintCodeList"></table>
			<div id="divPage"></div>
		</div>
		
		
		
<!-- 	<div> -->
<!-- 		<span class="pop_tit">Paint Code</span> <input type="text" id="txtItemCode" name="item_code"   style="width: 150px;"/> -->
<!-- 		&nbsp;&nbsp; -->
<!-- 		<span class="pop_tit">Desc</span> <input type="text" id="txtItemDesc" name="item_desc"   style="width: 180px;"/> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<table id="paintCodeList" style="width:100%;height:50%"></table> -->
<!-- 		<div   id="divPage"></div> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<input type="button" id="btnfind"   value="찾기" class="btn_blue"/> -->
<!-- 		<input type="button" id="btncheck"  value="확인" class="btn_blue"/> -->
<!-- 		<input type="button" id="btncancel" value="취소" class="btn_blue"/> -->
<!-- 	</div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
		
	$("input[name=item_code]").val(window.dialogArguments["item_code"]);
	
	$("#paintCodeList").jqGrid({ 
             datatype	: 'json', 
             url		: 'selectPaintItemCodeList.do',
             mtype:'POST',
             postData 	: getFormData("#listform"),
             editUrl  	: 'clientArray',
        	 colNames :['Paint Code','Desc','SVR','Can Size'],
                colModel:[
                    {name:'paint_code',	index:'paint_code', width:75, 	sortable:false},
                    {name:'paint_desc',	index:'paint_desc', width:150, 	sortable:false},
                    {name:'stxsvr',	   	index:'stxsvr', 	width:40, 	sortable:false},
                    {name:'can_size',	index:'can_size', 	width:40, 	sortable:false, hidden:true}
                ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,
             autowidth	: true,
             height		: 425,
             
             pager		: $('#divPage'),
             rowList	: [100,500,1000],
			 rowNum		: 1000,
			 
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                }, 
                       
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			var ret = jQuery(this).getRowData(rowId); 
    			
    			var returnValue = new Array();
      			returnValue[0]  = ret.paint_code;
      			returnValue[1]  = ret.paint_desc;
      			returnValue[2]  = ret.stxsvr;
      			returnValue[3]  = ret.can_size;
      			
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function() {
             	var rowCnt = $("#paintCodeList").getGridParam("reccount");
             	
             	if (rowCnt == 0) {
             		//self.close();	
             	} else if (rowCnt == 1) {
             		var ret = jQuery("#paintCodeList").getRowData(1);  		
		
					var returnValue = new Array();
					returnValue[0]  = ret.paint_code;
					returnValue[1]  = ret.paint_desc;
					returnValue[2]  = ret.stxsvr;
					returnValue[3]  = ret.can_size;
					
					window.returnValue = returnValue;		
					self.close();
             	}	
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
                                 row_selected = row_id;
                             }
                          }
    });
    
        
    $('#btncancel').click(function(){
		self.close();
	});

	$('#btnfind').click(function(){
		var sUrl = "selectPaintItemCodeList.do";
		jQuery("#paintCodeList").jqGrid('setGridParam',{url:sUrl,mtype:'POST',page:1,postData:getFormData("#listform")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#paintCodeList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0] = ret.paint_code;
		returnValue[1] = ret.paint_desc;
		returnValue[2] = ret.stxsvr;
		returnValue[3] = ret.can_size;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};

    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

</script>
</body>
</html>
