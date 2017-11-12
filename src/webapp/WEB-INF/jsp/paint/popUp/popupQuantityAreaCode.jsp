<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Area Code</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id="mainDiv" class="mainDiv">
<form id="listform" name="listform">
	<input type="hidden"  id="txtCodeGbn"   name="p_code_gbn" 	value="paintQuantityAreaCode" 	/>
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
		<table id="areaCodeList"></table>
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
	
	$("#areaCodeList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'selectPaintQuantityAreaCodeList.do',
             postData 	: getFormData("#listform"),
             editUrl  	: 'clientArray',
        	 colNames :['<input type="checkbox" id = "chkHeader1" onclick="checkBoxHeader(event,this.id)" />','Area1'
        	 		   ,'<input type="checkbox" id = "chkHeader2" onclick="checkBoxHeader(event,this.id)" />','Area2'
        	 		   ,'<input type="checkbox" id = "chkHeader3" onclick="checkBoxHeader(event,this.id)" />','Area3'
        	 		   ,'<input type="checkbox" id = "chkHeader4" onclick="checkBoxHeader(event,this.id)" />','Area4'
        	 		   ,'<input type="checkbox" id = "chkHeader5" onclick="checkBoxHeader(event,this.id)" />','Area5'
        	 		   ,'<input type="checkbox" id = "chkHeader6" onclick="checkBoxHeader(event,this.id)" />','Area6'
        	 		   ,'<input type="checkbox" id = "chkHeader7" onclick="checkBoxHeader(event,this.id)" />','Area7'
        	 		   ,'<input type="checkbox" id = "chkHeader8" onclick="checkBoxHeader(event,this.id)" />','Area8'
        	 		   ,'<input type="checkbox" id = "chkHeader9" onclick="checkBoxHeader(event,this.id)" />','Area9'
        	 		   ,'<input type="checkbox" id = "chkHeader10" onclick="checkBoxHeader(event,this.id)" />','Area10'
        	 		   
        	 		   ,'<input type="checkbox" id = "chkHeader11" onclick="checkBoxHeader(event,this.id)" />','Area11'
        	 		   ,'<input type="checkbox" id = "chkHeader12" onclick="checkBoxHeader(event,this.id)" />','Area12'
        	 		   ,'<input type="checkbox" id = "chkHeader13" onclick="checkBoxHeader(event,this.id)" />','Area13'
        	 		   ,'<input type="checkbox" id = "chkHeader14" onclick="checkBoxHeader(event,this.id)" />','Area14'
        	 		   ,'<input type="checkbox" id = "chkHeader15" onclick="checkBoxHeader(event,this.id)" />','Area15'
        	 		   ,'<input type="checkbox" id = "chkHeader16" onclick="checkBoxHeader(event,this.id)" />','Area16'
        	 		   ,'<input type="checkbox" id = "chkHeader17" onclick="checkBoxHeader(event,this.id)" />','Area17'
        	 		   ,'<input type="checkbox" id = "chkHeader18" onclick="checkBoxHeader(event,this.id)" />','Area18'
        	 		   ,'<input type="checkbox" id = "chkHeader19" onclick="checkBoxHeader(event,this.id)" />','Area19'
        	 		   ,'<input type="checkbox" id = "chkHeader20" onclick="checkBoxHeader(event,this.id)" />','Area20'
        	 		   
        	 		   ,'<input type="checkbox" id = "chkHeader21" onclick="checkBoxHeader(event,this.id)" />','Area21'
        	 		   ,'<input type="checkbox" id = "chkHeader22" onclick="checkBoxHeader(event,this.id)" />','Area22'
        	 		   ,'<input type="checkbox" id = "chkHeader23" onclick="checkBoxHeader(event,this.id)" />','Area23'
        	 		   ,'<input type="checkbox" id = "chkHeader24" onclick="checkBoxHeader(event,this.id)" />','Area24'
        	 		   ,'<input type="checkbox" id = "chkHeader25" onclick="checkBoxHeader(event,this.id)" />','Area25'
        	 		   ,'<input type="checkbox" id = "chkHeader26" onclick="checkBoxHeader(event,this.id)" />','Area26'
        	 		],
                colModel:[
                	{name:'chk1', index:'chk1', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area1',index:'area1', width:60, sortable:false, align:'left'},
                    {name:'chk2', index:'chk2', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area2',index:'area2', width:60, sortable:false, align:'left'},
                    {name:'chk3', index:'chk3', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area3',index:'area3', width:60, sortable:false, align:'left'},
                    {name:'chk4', index:'chk4', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area4',index:'area4', width:60, sortable:false, align:'left'},
                    {name:'chk5', index:'chk5', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area5',index:'area5', width:60, sortable:false, align:'left'},
                    {name:'chk6', index:'chk6', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area6',index:'area6', width:60, sortable:false, align:'left'},
                    {name:'chk7', index:'chk7', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area7',index:'area7', width:60, sortable:false, align:'left'},
                    {name:'chk8', index:'chk8', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area8',index:'area8', width:60, sortable:false, align:'left'},
                    {name:'chk9', index:'chk9', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area9',index:'area9', width:60, sortable:false, align:'left'},
                    {name:'chk10', index:'chk10', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area10',index:'area10', width:60, sortable:false, align:'left'},
                    
                    {name:'chk11', index:'chk11', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area11',index:'area11', width:60, sortable:false, align:'left'},
                    {name:'chk12', index:'chk12', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area12',index:'area12', width:60, sortable:false, align:'left'},
                    {name:'chk13', index:'chk13', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area13',index:'area13', width:60, sortable:false, align:'left'},
                    {name:'chk14', index:'chk14', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area14',index:'area14', width:60, sortable:false, align:'left'},
                    {name:'chk15', index:'chk15', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area15',index:'area15', width:60, sortable:false, align:'left'},
                    {name:'chk16', index:'chk16', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area16',index:'area16', width:60, sortable:false, align:'left'},
                    {name:'chk17', index:'chk17', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area17',index:'area17', width:60, sortable:false, align:'left'},
                    {name:'chk18', index:'chk18', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area18',index:'area18', width:60, sortable:false, align:'left'},
                    {name:'chk19', index:'chk19', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area19',index:'area19', width:60, sortable:false, align:'left'},
                    {name:'chk20', index:'chk20', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area20',index:'area20', width:60, sortable:false, align:'left'},
                    
                    {name:'chk21', index:'chk21', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area21',index:'area21', width:60, sortable:false, align:'left'},
                    {name:'chk22', index:'chk22', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area22',index:'area22', width:60, sortable:false, align:'left'},
                    {name:'chk23', index:'chk23', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area23',index:'area23', width:60, sortable:false, align:'left'},
                    {name:'chk24', index:'chk24', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area24',index:'area24', width:60, sortable:false, align:'left'},
                    {name:'chk25', index:'chk25', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area25',index:'area25', width:60, sortable:false, align:'left'},
                    {name:'chk26', index:'chk26', width:24,align:'center',sortable:false,formatter: formatOpt1},
                    {name:'area26',index:'area26', width:60, sortable:false, align:'left'},
                    
                    
                ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             /*  width		: 870,                     //사용자 화면 크기에 맞게 자동 조절 */
             autowidth	: true,
             height		: $(window).height(),
             rowNum		: 99999,
             cellEdit	: true,             // grid edit mode 1
             
             /* shrinkToFit:false,  */
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
			 	var rowCnt = $("#areaCodeList").getGridParam("reccount");
			 	
			 	if (rowCnt > 0) {
             		
             		var colModel = $('#areaCodeList').jqGrid('getGridParam', 'colModel');
						
					for(var i = colModel.length-1; i >= 0; i--) {
						
						var colNm = colModel[i].name;
						
						if (colNm.substring(0,4) == "area") {
							if ( $.jgrid.isEmpty($('#areaCodeList').getCell(1,colNm)) ) {
								$("#areaCodeList").hideCol(colNm);
								$("#areaCodeList").hideCol(colNm.replace("area","chk"));
							}
						}
						
						//if ( $.jgrid.isEmpty($('#areaCodeList').getCell(1,colModel[i].name)) ) {
						//	$("#areaCodeList").hideCol("area26");
             			//	$("#areaCodeList").hideCol("chk26");
						//}					
					}
             	}	
			 	fn_gridresize($(window),$("#areaCodeList"),-100);
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
		var sUrl = "selectPaintQuantityAreaCodeList.do";
		$("#areaCodeList").jqGrid('setGridParam',{url:sUrl,page:1,postData:getFormData("#listform")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
		var row = $( "#areaCodeList" ).jqGrid( 'getDataIDs' );

		for( var i = 0; i < row.length; i++ ) {
			var oper = $( "#areaCodeList" ).jqGrid( 'getCell', row[i], 'oper' );
		}
			
  		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){	
			
			if (!$.jgrid.isEmpty(po.value) &&  !(po.value == 'undefined')) 
			{
				if(chked_val=="")
				{
					chked_val += "'" + po.value + "'";
				} else {
					chked_val += "," + "'" + po.value + "'";
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
		
	});
	fn_gridresize($(window),$("#areaCodeList"),-100);
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
	var colVal = "";
	
	switch(options.pos) {
		case 0:
			clsNm += "1";
			colVal = rowObject.area1;
		 	break;
		case 2:
			clsNm += "2";
			colVal = rowObject.area2;
		 	break;
		case 4:
			clsNm += "3";
			colVal = rowObject.area3;
		 	break;
		case 6:
			clsNm += "4";
			colVal = rowObject.area4;
		 	break;
		case 8:
			clsNm += "5";
			colVal = rowObject.area5;
		 	break;
		case 10:
			clsNm += "6";
			colVal = rowObject.area6;
		 	break;
		case 12:
			clsNm += "7";
			colVal = rowObject.area7;
		 	break;		 	 	 	 	
		case 14:
			clsNm += "8";
			colVal = rowObject.area8;
		 	break;	
		case 16:
			clsNm += "9";
			colVal = rowObject.area9;
		 	break;
		case 18:
			clsNm += "10";
			colVal = rowObject.area10;
		 	break; 
		case 20:
			clsNm += "11";
			colVal = rowObject.area11;
		 	break;
		case 22:
			clsNm += "12";
			colVal = rowObject.area12;
		 	break;
		case 24:
			clsNm += "13";
			colVal = rowObject.area13;
		 	break;
		case 26:
			clsNm += "14";
			colVal = rowObject.area14;
		 	break;
		case 28:
			clsNm += "15";
			colVal = rowObject.area15;
		 	break;
		case 30:
			clsNm += "16";
			colVal = rowObject.area16;
		 	break;
		case 32:
			clsNm += "17";
			colVal = rowObject.area17;
		 	break;		 	 	 	 	
		case 34:
			clsNm += "18";
			colVal = rowObject.area18;
		 	break;	
		case 36:
			clsNm += "19";
			colVal = rowObject.area19;
		 	break;
		case 38:
			clsNm += "20";
			colVal = rowObject.area20;
		 	break; 	
		case 40:
			clsNm += "21";
			colVal = rowObject.area21;
		 	break; 	 
		case 42:
			clsNm += "22";
			colVal = rowObject.area22;
		 	break; 	 
		case 44:
			clsNm += "23";
			colVal = rowObject.area23;
		 	break; 	 
		case 46:
			clsNm += "24";
			colVal = rowObject.area24;
		 	break; 	 
		case 48:
			clsNm += "25";
			colVal = rowObject.area25;
		 	break; 
		case 50:
			clsNm += "26";
			colVal = rowObject.area26;
		 	break;  		  	 	 	 	 	 		
	}
	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+'-'+options.pos+"_chkBoxOV' class='"+clsNm+"' value='"+colVal+"' />";
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
