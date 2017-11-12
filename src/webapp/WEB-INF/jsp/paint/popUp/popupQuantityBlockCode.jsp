<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Block Code</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id="mainDiv" class="mainDiv">
<form id="listform" name="listform">
	<input type="hidden"  id="txtCodeGbn"   name="p_code_gbn" 	value="paintQuantityBlockCode" 	/>
	<input type="hidden"  id="txtProjectNo" name="project_no" 	value=""   						/>
	<input type="hidden"  id="txtRevision"  name="revision"   	value=""   						/>
	<table class="searchArea conSearch">
	<tr>
		<td style="border-right:none">
		<!-- <input type="button" id="full"  value="전체화면" class="btn_blue"/> -->
		</td>
		<td style="border-left:none">
		<div id="searchArea" class="button endbox">
			<input type="button" id="btncheck"  value="확인" class="btn_blue"/>
			<input type="button" id="btncancel" value="취소" class="btn_blue"/>
			<!--  <input type="button" id="btnfind"   value="찾기"/> -->
		</div>
		</td>
	</tr>
	</table>
	<div style="margin-top: 10px;">
		<table id="blockCodeList"></table>
	</div>
	
</form>
</div>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
	
	$(window).bind('resize', function() {
		$("#mainDiv").css({'width':  $(window).width()-20});
	}).trigger('resize');
	
	$("input[name=project_no]").val(window.dialogArguments["project_no"]);
	$("input[name=revision]").val(window.dialogArguments["revision"]);
	
	$("#blockCodeList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'selectPaintQuantityBlockCodeList.do',
             postData 	: getFormData("#listform"),
             editUrl  	: 'clientArray',
        	 colNames :['<input type="checkbox" id = "chkHeader0" onclick="checkBoxHeader(event,this.id)" />','Block0'
        	           ,'<input type="checkbox" id = "chkHeader1" onclick="checkBoxHeader(event,this.id)" />','Block1'
        	 		   ,'<input type="checkbox" id = "chkHeader2" onclick="checkBoxHeader(event,this.id)" />','Block2'
        	 		   ,'<input type="checkbox" id = "chkHeader3" onclick="checkBoxHeader(event,this.id)" />','Block3'
        	 		   ,'<input type="checkbox" id = "chkHeader4" onclick="checkBoxHeader(event,this.id)" />','Block4'
        	 		   ,'<input type="checkbox" id = "chkHeader5" onclick="checkBoxHeader(event,this.id)" />','Block5'
        	 		   ,'<input type="checkbox" id = "chkHeader6" onclick="checkBoxHeader(event,this.id)" />','Block6'
        	 		   ,'<input type="checkbox" id = "chkHeader7" onclick="checkBoxHeader(event,this.id)" />','Block7'
        	 		   ,'<input type="checkbox" id = "chkHeader8" onclick="checkBoxHeader(event,this.id)" />','Block8'
        	 		   ,'<input type="checkbox" id = "chkHeader9" onclick="checkBoxHeader(event,this.id)" />','Block9'],
                colModel:[
                	{name:'chk0', index:'chk0', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block0',index:'block0', width:75, sortable:false, align:'left'},
                	{name:'chk1', index:'chk1', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block1',index:'block1', width:75, sortable:false, align:'left'},
                    {name:'chk2', index:'chk2', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block2',index:'block2', width:75, sortable:false, align:'left'},
                    {name:'chk3', index:'chk3', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block3',index:'block3', width:75, sortable:false, align:'left'},
                    {name:'chk4', index:'chk4', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block4',index:'block4', width:75, sortable:false, align:'left'},
                    {name:'chk5', index:'chk5', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block5',index:'block5', width:75, sortable:false, align:'left'},
                    {name:'chk6', index:'chk6', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block6',index:'block6', width:75, sortable:false, align:'left'},
                    {name:'chk7', index:'chk7', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block7',index:'block7', width:75, sortable:false, align:'left'},
                    {name:'chk8', index:'chk8', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block8',index:'block8', width:75, sortable:false, align:'left'},
                    {name:'chk9', index:'chk9', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'block9',index:'block9', width:75, sortable:false, align:'left'},
                ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             autowidth	: true,
             height		: $(window).height(),
             rowNum		: 99999,
             cellEdit	: true,             // grid edit mode 1
             
             pgbuttons	: false,
			 pgtext		: false,
			 pginput	: false,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			
			 },
			 loadComplete: function() {
             	
			 },
			 gridComplete : function () {
			 	var rowCnt = $("#blockCodeList").getGridParam("reccount");
			 	
			 	if (rowCnt > 0) {
             		
             		var colModel = $('#blockCodeList').jqGrid('getGridParam', 'colModel');
						
					for(var i = colModel.length-1; i >= 0; i--) {
						
						var colNm = colModel[i].name;
						
						if (colNm.substring(0,5) == "block") {
							if ( $.jgrid.isEmpty($('#blockCodeList').getCell(1,colNm)) ) {
								$("#blockCodeList").hideCol(colNm);
								$("#blockCodeList").hideCol(colNm.replace("block","chk"));
							}
						}
             		}
					fn_gridresize($(window),$("#blockCodeList"),-100);
             		/*
             		if ($.jgrid.isEmpty(ret.block9)) {
             			$("#blockCodeList").hideCol("block9");
             			$("#blockCodeList").hideCol("chk9");
             		}*/
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
    
	
	
	
	$('#full').click(function(){
		self.resizeTo(1000,1000);
	});
	
	
    $('#btncancel').click(function(){
		self.close();
	});

	$('#btnfind').click(function(){
		var sUrl = "selectPaintQuantityBlockCodeList.do";
		jQuery("#blockCodeList").jqGrid('setGridParam',{url:sUrl,page:1,postData:getFormData("#listform")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		var chked_val = "";
		
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){			
			if (!$.jgrid.isEmpty(po.value) &&  !(po.value == 'undefined')) 
			{
				if(chked_val=="")
				{
					chked_val += po.value;
				} else {
					chked_val += "," + po.value;
				}
			}
		});
		
		var returnValue = new Array();		
		
		if (!$.jgrid.isEmpty(chked_val)) {
			returnValue[0]     = chked_val;
			window.returnValue = returnValue;
		} else {
			returnValue[0]     = "ALL";
			window.returnValue = returnValue;
		}
		
		self.close();
		
  		/*
  		var ret = jQuery("#blockCodeList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0] = ret.block_code;
		returnValue[1] = ret.block_desc;
		returnValue[2] = ret.loss_code;
		
		window.returnValue = returnValue;
      			
		self.close();*/
	});
	fn_gridresize($(window),$("#blockCodeList"),-100);
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

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid  = options.rowId;
	var clsNm  = "chkHeader";
	var colVal;
	
	switch(options.pos) {
		case 0:
			clsNm += "0";
			colVal = rowObject.block0;
		 	break;
		case 2:
			clsNm += "1";
			colVal = rowObject.block1;
		 	break; 	
		case 4:
			clsNm += "2";
			colVal = rowObject.block2;
		 	break;
		case 6:
			clsNm += "3";
			colVal = rowObject.block3;
		 	break;
		case 8:
			clsNm += "4";
			colVal = rowObject.block4;
		 	break;
		case 10:
			clsNm += "5";
			colVal = rowObject.block5;
		 	break;
		case 12:
			clsNm += "6";
			colVal = rowObject.block6;
		 	break;
		case 14:
			clsNm += "7";
			colVal = rowObject.block7;
		 	break;		 	 	 	 	
		case 16:
			clsNm += "8";
			colVal = rowObject.block8;
		 	break;	
		case 18:
			clsNm += "9";
			colVal = rowObject.block9;
		 	break;
	}
	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+options.pos+"_chkBoxOV' class='"+clsNm+"' value="+colVal+" />";
}

//header checkbox action 
function checkBoxHeader(e, chkeckId) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	
	if(($("#"+chkeckId).is(":checked"))){
		$("."+chkeckId).prop("checked", true);
	}else{
		$("input."+chkeckId).prop("checked", false);
	}
}

</script>
</body>
</html>
