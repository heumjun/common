<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Item 채번 결과</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<input type="hidden" id="cmd" name="cmd" />
	<div id="mainDiv" style="padding:5px;">
		<div  class = "topMain" style="height:20px;">
			
				<div class = "button" >
					<!--  <input type="button" value="저장" id="btnSave" /> -->
					<input type="button" value="닫기" id="btnClose" class="btn_gray2" />
				</div>
			
		</div>
		<div>
			<fieldset style="height:555px;">
			<legend class="sc_tit mgt10 sc_tit2">&nbsp;Item 채번 결과</legend>
				<div>
					<table id = itemCreateGrid></table>
					<!--  <div   id = "pcopyList"></div> -->
				</div>
			</fieldset>
		</div>
	</div>
</form>
<script type="text/javascript">

var createList  = jQuery.makeArray(window.dialogArguments["createList"]);
var columnList  = jQuery.makeArray(window.dialogArguments["columnList"]);
var is_hidden   = true;

$(document).ready(function() {
		
	$("#itemCreateGrid").jqGrid({ 
           datatype		: 'local', 
           mtype		: 'POST', 
           url			: '',
          colNames : [ 'Result', 'Item_Code', 'DESCRIPTION', 'Weight', 
			           'ATTR00_CODE', 'ATTR00', 'ATTR01_CODE', 'ATTR01', 'ATTR02_CODE', 'ATTR02', 
			           'ATTR03_CODE', 'ATTR03', 'ATTR04_CODE', 'ATTR04', 'ATTR05_CODE', 'ATTR05', 
			           'ATTR06_CODE', 'ATTR06', 'ATTR07_CODE', 'ATTR07', 'ATTR08_CODE', 'ATTR08', 
			           'ATTR09_CODE', 'ATTR09', 'ATTR10_CODE', 'ATTR10', 'ATTR11_CODE', 'ATTR11', 
			           'ATTR12_CODE', 'ATTR12', 'ATTR13_CODE', 'ATTR13', 'ATTR14_CODE', 'ATTR14', 
			           'ATTR15_CODE', 'ATTR15', 
			           '부가속성01', '부가속성02', '부가속성03', 
			           '부가속성04', '부가속성05', '부가속성06', 
			           '부가속성07', '부가속성08', '부가속성09', 
			           'ERROR' ],
			colModel : [ 
						 { name : 'err_msg',	 index : 'err_msg',  	width : 150},
						 { name : 'item_code', 	 index : 'item_code',   width : 110,  sortable : false, formatter: itemCodeFormatter },
						 { name : 'item_desc', 	 index : 'item_desc', 	width : 300 }, 
						 { name : 'weight', 	 index : 'weight', 		width : 60,  editrules:{number:true},  sortable : false }, 
			              
			             { name : 'attr00_code', width : 60, index : 'attr00_code', hidden : is_hidden }, 
			             { name : 'attr00_desc', width : 60, index : 'attr00_desc', hidden : is_hidden }, 
			             { name : 'attr01_code', width : 60, index : 'attr01_code', hidden : is_hidden }, 
			             { name : 'attr01_desc', index : 'attr01_desc', width : 82,  sortable : false  }, 
			             { name : 'attr02_code', width : 60, index : 'attr02_code', hidden : is_hidden }, 
			             { name : 'attr02_desc', index : 'attr02_desc', width : 82,  sortable : false  }, 
			             { name : 'attr03_code', width : 60, index : 'attr03_code', hidden : is_hidden }, 
			             { name : 'attr03_desc', index : 'attr03_desc', width : 82,  sortable : false  }, 
			             { name : 'attr04_code', width : 60, index : 'attr04_code', hidden : is_hidden }, 
			             { name : 'attr04_desc', index : 'attr04_desc', width : 82,  sortable : false  }, 
			             { name : 'attr05_code', width : 60, index : 'attr05_code', hidden : is_hidden }, 
			             { name : 'attr05_desc', index : 'attr05_desc', width : 82,  sortable : false  }, 
			             { name : 'attr06_code', width : 60, index : 'attr06_code', hidden : is_hidden }, 
			             { name : 'attr06_desc', index : 'attr06_desc', width : 82,  sortable : false  }, 
			             { name : 'attr07_code', width : 60, index : 'attr07_code', hidden : is_hidden }, 
			             { name : 'attr07_desc', index : 'attr07_desc', width : 80,  sortable : false  }, 
			             { name : 'attr08_code', width : 60, index : 'attr08_code', hidden : is_hidden }, 
			             { name : 'attr08_desc', index : 'attr08_desc', width : 80,  sortable : false  }, 
			             { name : 'attr09_code', width : 60, index : 'attr09_code', hidden : is_hidden }, 
			             { name : 'attr09_desc', index : 'attr09_desc', width : 80,  sortable : false  }, 
			             { name : 'attr10_code', width : 60, index : 'attr10_code', hidden : is_hidden }, 
			             { name : 'attr10_desc', index : 'attr10_desc', width : 80,  sortable : false  }, 
			             { name : 'attr11_code', width : 60, index : 'attr11_code', hidden : is_hidden }, 
			             { name : 'attr11_desc', index : 'attr11_desc', width : 80,  sortable : false  }, 
			             { name : 'attr12_code', width : 60, index : 'attr12_code', hidden : is_hidden }, 
			             { name : 'attr12_desc', index : 'attr12_desc', width : 80,  sortable : false  }, 
			             { name : 'attr13_code', width : 60, index : 'attr13_code', hidden : is_hidden }, 
			             { name : 'attr13_desc', index : 'attr13_desc', width : 80,  sortable : false  }, 
			             { name : 'attr14_code', width : 60, index : 'attr14_code', hidden : is_hidden }, 
			             { name : 'attr14_desc', index : 'attr14_desc', width : 80,  sortable : false  }, 
			             { name : 'attr15_code', width : 60, index : 'attr15_code', hidden : is_hidden }, 
			             { name : 'attr15_desc', index : 'attr15_desc', width : 80,  sortable : false  }, 
			             { name : 'add_attr01_desc', index : 'add_attr01_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr02_desc', index : 'add_attr02_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr03_desc', index : 'add_attr03_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr04_desc', index : 'add_attr04_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr05_desc', index : 'add_attr05_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr06_desc', index : 'add_attr06_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr07_desc', index : 'add_attr07_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr08_desc', index : 'add_attr08_desc', width : 80,  sortable : false}, 
			             { name : 'add_attr09_desc', index : 'add_attr09_desc', width : 80,  sortable : false}, 
			            
		            	 { name : 'error_yn',  		 index : 'error_yn',   		width : 25, hidden:true} ],
              
           gridview		: true,
           toolbar		: [false, "bottom"],
           viewrecords	: false,
           autowidth    : true,
           height		: 510,
           //pager		: $('#pcopyList'),
           rowNum		: -1, 
           cellEdit		: true,             // grid edit mode 1
           cellsubmit	: 'clientArray',  	// grid edit mode 2
           rownumbers 	: true,          	// 리스트 순번	
           pgbuttons	: false,
	 	   pgtext		: false,
	 	   pginput		: false,
	 	   shrinkToFit : false,
           loadComplete: function() {
           
		   },
		   gridComplete : function () {
		
		   },
	 	   beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
           
 		   },
           jsonReader : {
               root	: "rows",
               page	: "page",
               total	: "total",
               records: "records",  
               repeatitems: false,
              },        
           imgpath: 'themes/basic/images'
          
   	}); 
    
    //grid resize
	//fn_insideGridresize($(window),$("#mainDiv"),$("#itemCreateGrid"));

    
	if (createList.length > 0) {  	
    	for(var i=0; i<createList.length; i++) {
    		$("#itemCreateGrid").jqGrid('addRowData', i, createList[i]);   	
    	}	
    }
	
	$("#btnSave").click(function(){
		//fn_save();					
	});
	
	$("#btnClose").click(function(){
		self.close();					
	});
	
	fn_gridColumn(columnList);	
}); 

function itemCodeFormatter(cellvalue, options, rowObject ) {
	
	return "<input type=\"text\" value=\""+cellvalue+"\" readonly=\"readonly\" />";
}

function fn_gridColumn(obj) {
		
	if (obj.length > 0) {
	
		if(obj[0].attr01 == "ATTR01") {
			$('#itemCreateGrid').hideCol('attr01_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr01_desc",obj[0].attr01.split("/")[0]);
		}
		
		if(obj[0].attr02 == "ATTR02") {
			$('#itemCreateGrid').hideCol('attr02_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr02_desc",obj[0].attr02.split("/")[0]);
		}
		
		if(obj[0].attr03 == "ATTR03") {
			$('#itemCreateGrid').hideCol('attr03_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr03_desc",obj[0].attr03.split("/")[0]);
		}
		
		if(obj[0].attr04 == "ATTR04") {
			$('#itemCreateGrid').hideCol('attr04_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr04_desc",obj[0].attr04.split("/")[0]);
		}
		
		if(obj[0].attr05 == "ATTR05") {
			$('#itemCreateGrid').hideCol('attr05_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr05_desc",obj[0].attr05.split("/")[0]);
		}
		
		if(obj[0].attr06 == "ATTR06") {
			$('#itemCreateGrid').hideCol('attr06_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr06_desc",obj[0].attr06.split("/")[0]);
		}

		if(obj[0].attr07 == "ATTR07") {
			$('#itemCreateGrid').hideCol('attr07_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr07_desc",obj[0].attr07.split("/")[0]);
		}
		
		if(obj[0].attr08 == "ATTR08") {
			$('#itemCreateGrid').hideCol('attr08_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr08_desc",obj[0].attr08.split("/")[0]);
		}
		
		if(obj[0].attr09 == "ATTR09") {
			$('#itemCreateGrid').hideCol('attr09_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr09_desc",obj[0].attr09.split("/")[0]);
		}
		
		if(obj[0].attr10 == "ATTR10") {
			$('#itemCreateGrid').hideCol('attr10_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr10_desc",obj[0].attr10.split("/")[0]);
		}
		
		if(obj[0].attr11 == "ATTR11") {
			$('#itemCreateGrid').hideCol('attr11_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr11_desc",obj[0].attr11.split("/")[0]);
		}
		
		if(obj[0].attr12 == "ATTR12") {
			$('#itemCreateGrid').hideCol('attr12_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr12_desc",obj[0].attr12.split("/")[0]);
		}
		
		if(obj[0].attr13 == "ATTR13") {
			$('#itemCreateGrid').hideCol('attr13_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr13_desc",obj[0].attr13.split("/")[0]);
		}
		
		if(obj[0].attr14 == "ATTR14") {
			$('#itemCreateGrid').hideCol('attr14_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr14_desc",obj[0].attr14.split("/")[0]);
		}
		
		if(obj[0].attr15 == "ATTR15") {
			$('#itemCreateGrid').hideCol('attr15_desc');
		} else {
			$('#itemCreateGrid').jqGrid('setLabel', "attr15_desc",obj[0].attr15.split("/")[0]);
		}
		
		/* $('#itemCreateGrid').jqGrid('setLabel', "attr08_desc",obj[0].attr08);
		$('#itemCreateGrid').jqGrid('setLabel', "attr09_desc",obj[0].attr09);
		$('#itemCreateGrid').jqGrid('setLabel', "attr10_desc",obj[0].attr10);
		$('#itemCreateGrid').jqGrid('setLabel', "attr11_desc",obj[0].attr11);
		$('#itemCreateGrid').jqGrid('setLabel', "attr12_desc",obj[0].attr12);
		$('#itemCreateGrid').jqGrid('setLabel', "attr13_desc",obj[0].attr13);
		$('#itemCreateGrid').jqGrid('setLabel', "attr14_desc",obj[0].attr14);
		$('#itemCreateGrid').jqGrid('setLabel', "attr15_desc",obj[0].attr15); */
		
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr01_desc",obj[0].add_attr01);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr02_desc",obj[0].add_attr02);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr03_desc",obj[0].add_attr03);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr04_desc",obj[0].add_attr04);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr05_desc",obj[0].add_attr05);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr06_desc",obj[0].add_attr06);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr07_desc",obj[0].add_attr07);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr08_desc",obj[0].add_attr08);
		$('#itemCreateGrid').jqGrid('setLabel', "add_attr09_desc",obj[0].add_attr09);

		if (obj[0].add_attr01 == "부가속성01")
			jQuery("#itemCreateGrid").hideCol("add_attr01_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr01_desc");

		if (obj[0].add_attr02 == "부가속성02")
			jQuery("#itemCreateGrid").hideCol("add_attr02_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr02_desc");

		if (obj[0].add_attr03 == "부가속성03")
			jQuery("#itemCreateGrid").hideCol("add_attr03_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr03_desc");

		if (obj[0].add_attr04 == "부가속성04")
			jQuery("#itemCreateGrid").hideCol("add_attr04_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr04_desc");

		if (obj[0].add_attr05 == "부가속성05")
			jQuery("#itemCreateGrid").hideCol("add_attr05_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr05_desc");

		if (obj[0].add_attr06 == "부가속성06")
			jQuery("#itemCreateGrid").hideCol("add_attr06_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr06_desc");

		if (obj[0].add_attr07 == "부가속성07")
			jQuery("#itemCreateGrid").hideCol("add_attr07_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr07_desc");

		if (obj[0].add_attr08 == "부가속성08")
			jQuery("#itemCreateGrid").hideCol("add_attr08_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr08_desc");

		if (obj[0].add_attr09 == "부가속성09")
			jQuery("#itemCreateGrid").hideCol("add_attr09_desc");
		else
			jQuery("#itemCreateGrid").showCol("add_attr09_desc");

// 		fn_search();
		/*
		for(var i=0; i<obj.length; i++) {
			
			if (obj[i].attribute_code == "01") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr01_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "02") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr02_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "03") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr03_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "04") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr04_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "05") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr05_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "06") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr06_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "07") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr07_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "08") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr08_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "09") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr09_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "10") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr10_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "11") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr11_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "12") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr12_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "13") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr13_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "14") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr14_desc", obj[i].attribute_name);
			} else if (obj[i].attribute_code == "15") {
				$('#itemCreateGrid').jqGrid('setLabel', "attr15_desc", obj[i].attribute_name);
			}
		}*/
		
	}
	//$(window),$("#mainDiv")
	/*
	$(window).bind('resize', function() {
		$('#itemCreateGrid').setGridWidth($("#mainDiv").width()-2);
		//gridId.setGridWidth(winObj.width()-204);
	}).trigger('resize');*/


}
	

</script>
</body>
</html>