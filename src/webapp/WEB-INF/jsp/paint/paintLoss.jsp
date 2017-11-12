<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Loss Code</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
<div class= "subtitle">
Paint Loss Code
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	
	
	<table class="searchArea conSearch">
			<col width="100">
			<col width="130">
			<col width="100">
			<col width="*">

			<tr>
			<th>LOSS CODE</th>
			<td>
			 <input type="text" id="txtLossCode" name="lossCode" class="wid200" style="ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			 </td>
			<td  style="border-right:none;">
				<input type="radio" value="Y" 		id="btnUseOn" />ON
				<input type="radio" value="N" 		id="btnUseOff"  />OFF
			 </td>
			<td style="border-left:none;min-width:260px;">
				<div class="button endbox">
				<c:if test="${userRole.attribute1 == 'Y'}">
					<input type="button" value="조회" 	id="btnSearch"  class="btn_blue"/>
					</c:if>
					<c:if test="${userRole.attribute2 == 'Y'}">
					<input type="button" value="신규" 		id="btnNew"  	class="btn_blue"/>
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">			
					<input type="button" value="수정" 		id="btnMod"  	class="btn_blue"/>
					</c:if>
					<c:if test="${userRole.attribute5 == 'Y'}">
					<input type="button" value="Excel출력" 	id="btnExcelExport" class="btn_blue"/>
					</c:if>
				</div>
			</td>						
			</tr>	
	</table>
	
	
	
	
	
	
	<!--
	
	<div class = "topMain" style="line-height:45px">
		<div class = "conSearch">
			<span class = "spanMargin">
			Loss Code
			<input type="text" id="txtLossCode" name="lossCode" style="width:100px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
			</span>
		</div>
		
		<div class = "button">
			<input type="button" value="조  회" 		id="btnSearch"  	  />
			<input type="button" value="신 규" 		id="btnNew"  		  />
			<input type="button" value="수 정" 		id="btnMod"  		  />
			<input type="button" value="Excel출력" 	id="btnExcelExport"   />			
		</div>
	</div>
	-->
	<div class="content">
		<table id = "lossGrid"></table>
		<div   id = "p_lossGrid"></div>
	</div>	
	
</div>	
</form>

<script type="text/javascript">

var change_loss_row 	= 0;
var change_loss_row_num = 0;
var change_loss_col  	= 0;

var tableId	   			= "#lossGrid";
var deleteData 			= [];

var searchIndex 		= 0;
var lodingBox; 
var win;	

var prevCellVal  = { cellId: undefined, value: undefined };	
var prevCellVal1 = { cellId: undefined, value: undefined };
var prevCellVal2 = { cellId: undefined, value: undefined, loss_code: undefined };
var prevCellVal3 = { cellId: undefined, value: undefined, loss_code: undefined, loss_desc: undefined };
var prevCellVal4 = { cellId: undefined, value: undefined, loss_code: undefined, loss_desc: undefined };	

var lossCodeOnOffFlag;

$(document).ready(function(){
	fn_all_text_upper();
	var objectHeight = gridObjectHeight(1);
	
	// Cell - Merge
    rowspaner = function (rowId, val, rawObject, cm, rdata) {
                 var result;
					
                 if (prevCellVal.value == rawObject.loss_code) {
                     result = ' style="display: none" rowspanid="' + prevCellVal.cellId + '"';
                 }
                 else {
                     var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                     result = ' rowspan="1" id="' + cellId + '"';
                     prevCellVal = { cellId: cellId, value: rawObject.loss_code };
                 }

                 return result;
             };
    
    // Cell - Merge         
	rowspaner1 = function (rowId, val, rawObject, cm, rdata) {
                 var result;

                 if (prevCellVal1.value == val) {
                     result = ' style="display: none" rowspanid="' + prevCellVal1.cellId + '"';
                 }
                 else {
                     var cellId = this.id + '_row_' + rowId + '_' + cm.name;

                     result = ' rowspan="1" id="' + cellId + '"';
                     prevCellVal1 = { cellId: cellId, value: val };
                 }

                 return result;
             };
     
     // Cell - Merge       
     rowspaner2 = function (rowId, val, rawObject, cm, rdata) {
         var result;
			
         if (prevCellVal2.value == val && prevCellVal2.loss_code == rdata.loss_code) {
             result = ' style="display: none" rowspanid="' + prevCellVal2.cellId + '"';
         }
         else {
             var cellId = this.id + '_row_' + rowId + '_' + cm.name;

             result = ' rowspan="1" id="' + cellId + '"';
             prevCellVal2 = { cellId: cellId, value: val,  loss_code: rdata.loss_code};
         }

         return result;
     };
     
     // Cell - Merge
     rowspaner3 = function (rowId, val, rawObject, cm, rdata) {
         var result;

         if (prevCellVal3.value == val && prevCellVal3.loss_code == rdata.loss_code  && prevCellVal3.loss_desc == rdata.loss_desc) {
             result = ' style="display: none" rowspanid="' + prevCellVal3.cellId + '"';
         }
         else {
             var cellId = this.id + '_row_' + rowId + '_' + cm.name;

             result = ' rowspan="1" id="' + cellId + '"';
             prevCellVal3 = { cellId: cellId, value: val, loss_code: rdata.loss_code, loss_desc: rdata.loss_desc};
         }

         return result;
     };
	 
	 // Cell - Merge
	 rowspaner4 = function (rowId, val, rawObject, cm, rdata) {
         var result;

         if (prevCellVal4.value == rdata.set_name 
         	 && prevCellVal4.loss_code == rdata.loss_code  
         	 && prevCellVal4.loss_desc == rdata.loss_desc) 
         {
             result = ' style="display: none" rowspanid="' + prevCellVal4.cellId + '"';
         }
         else {
             var cellId = this.id + '_row_' + rowId + '_' + cm.name;

             result = ' rowspan="1" id="' + cellId + '"';
             prevCellVal4 = { cellId: cellId, value: rdata.set_name, loss_code: rdata.loss_code, loss_desc: rdata.loss_desc};
         }

         return result;
     };
    
     
	$("#lossGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['Order','Loss Code','구획명','Set','Count','선행 Loss','후행 Loss','선행(%)','후행(%)','도료TYPE','Stage','Remark',''],
                colModel:[
                	{name:'order_seq',index:'order_seq', width:25, sortable:false, cellattr: rowspaner, align : 'right'},
                	{name:'loss_code',index:'loss_code', width:60, sortable:false, cellattr: rowspaner1},
                   	{name:'loss_desc',index:'loss_desc', width:140, sortable:false, cellattr: rowspaner2},
                   	{name:'set_name', index:'set_name', width:40, sortable:false, cellattr: rowspaner3},
                    {name:'paint_count',index:'paint_count', width:40, sortable:false, editrules:{number:true}, align:"right"},
                    {name:'pre_loss',index:'pre_loss', width:50, sortable:false, editrules:{number:true}, align:"right", classes:'yellow'},
                    {name:'post_loss',index:'post_loss', width:50, sortable:false, editrules:{number:true}, align:"right", classes:'yellow'},
                    {name:'pre_loss_rate',index:'pre_loss_rate', width:50, sortable:false, editrules:{number:true}, align:"right"},
                    {name:'post_loss_rate',index:'post_loss_rate', width:50, sortable:false, editrules:{number:true}, align:"right"},
                    {name:'paint_type',index:'paint_type'/*,  editoptions: { dataInit: function(elem) {$(elem).width(80);}}  */ // set the width which you need
                     ,align :'left',  width:80, sortable : false/* , edittype : 'select', formatter : 'select' */},
                    {name:'stage_desc',index:'stage_desc', editoptions: { dataInit: function(elem) {$(elem).width(30);}}  // set the width which you need
                     ,align :'center',  width:30, sortable : false, edittype : 'select', formatter : 'select'}, 
                    {name:'remark',index:'remark', width:160, sortable:false, edittype:"textarea", align:"left", wrap:"on",cellattr: rowspaner4},
                    {name:'oper',index:'oper', width:25, hidden:true }
                   
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
           
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_lossGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         //rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changeLossEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
             				
	         },
	         onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
				fn_initPrevCellVal();
				
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
			 gridComplete : function () {
		 		//미입력 영역 회색 표시
				$("#lossGrid .yellow").css( "background", "yellow" );
				
			    var grid = this;

		        $('td[rowspan="1"]', grid).each(function () {
		            var spans = $('td[rowspanid="' + this.id + '"]', grid).length + 1;

		            if (spans > 1) {
		                $(this).attr('rowspan', spans);
		            }
		        });
			 },
	         loadComplete : function (data) {
			  			  
			    deleteArrayClear();
			  
			    var $this = $(this);
			    if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			        // because one use repeatitems: false option and uses no
			        // jsonmap in the colModel the setting of data parameter
			        // is very easy. We can set data parameter to data.rows:
			        $this.jqGrid('setGridParam', {
			            datatype: 'local',
			            data: data.rows,
			            pageServer: data.page,
			            recordsServer: data.records,
			            lastpageServer: data.total
			        });
				
			        // because we changed the value of the data parameter
			        // we need update internal _index parameter:
			        this.refreshIndex();
			
			        if ($this.jqGrid('getGridParam', 'sortname') !== '') {
			            // we need reload grid only if we use sortname parameter,
			            // but the server return unsorted data
			            $this.triggerHandler('reloadGrid');
			        }
			       
			    } else {
			        $this.jqGrid('setGridParam', {
			            page: $this.jqGrid('getGridParam', 'pageServer'),
			            records: $this.jqGrid('getGridParam', 'recordsServer'),
			            lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
			        });
			        this.updatepager(false, true);
			    }
			 },	         
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_loss_row 	=	rowid;
             	change_loss_row_num =	iRow;
             	change_loss_col 	=	iCol;
   			 },
			   	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root	: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page	: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total	: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             onCellSelect: function(row_id, colId) {
             	if(row_id != null) 
                {
                	var ret 	= jQuery("#lossGrid").getRowData(row_id);
                	
	               	if (colId == 2 && ret.oper != "I") jQuery("#lossGrid").jqGrid('setCell', row_id, 'loss_code', '', 'not-editable-cell');
                } 
             }
     }); 
	
	//grid resize
	fn_gridresize($(window),$("#lossGrid"));
	
	// 그리드 버튼 설정
	$("#lossGrid").jqGrid('navGrid',"#p_lossGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 Row 추가 함수 설정	
	$("#lossGrid").navButtonAdd("#p_lossGrid",
			{
				caption:"",
				buttonicon:"ui-icon-refresh",
				onClickButton: function(){
					fn_search();
				},
				position:"first",
				title:"",
				cursor:"pointer"
			}
	);
	</c:if>
		
	/* //PAINT TYPE
	$.post( "selectPaintCode.do", {addCode:'',main_category:'PAINT',states_type:'PAINT TYPE'}, function( data ) {
		var data2 = $.parseJSON( data );
		
		$( '#lossGrid' ).setObject( { value : 'value', text : 'text', name : 'paint_type', data : data2 } );
	} ); */
	
	//Stage Desc
	var data = [{value:"B", text:"B"},
				{value:"H", text:"H"}		
			   ];
	$( '#lossGrid' ).setObject( { value : 'value', text : 'text', name : 'stage_desc', data : data } );
	
	//$(window).bind('resize', function() {
    //	$("#lossGrid").setGridWidth($(window).width()*0.8);
	//}).trigger('resize');
	
	// 신규
	$("#btnNew").click(function() {
		fn_new();
	});
	
	// 수정
	$("#btnMod").click(function() {
		fn_modify();
	});
	
	// 조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	});
	
	$("#btnUseOn").click(function() {
		fn_Use('Y');
	});
	$("#btnUseOff").click(function() {
		fn_Use('N');
	});
	
	/* // 엑셀 import
	$("#btnExcelImport").click(function() {
		fn_excelUpload();	
	}); */
	
	// 엑셀 export
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
	fn_changeLoseCodeOnOff();
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Del 버튼
function deleteRow(){
	
	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		var item   = $('#lossGrid').jqGrid('getRowData',selrow);
		
		if(item.oper != 'I') {
			item.oper = 'D';
			deleteData.push(item);
		}
		
		$('#lossGrid').jqGrid('delRowData', selrow);
	}
	
	$('#lossGrid').resetSelection();
}

// Add 버튼 
function addRow(item) {

	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
	
	var item = {};
	var colModel = $('#lossGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
		
	$('#lossGrid').resetSelection();
	$('#lossGrid').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
	tableId = '#lossGrid';	
}

// afterSaveCell oper 값 지정
function changeLossEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#lossGrid').jqGrid('getRowData', irowId);
	if (item.oper != 'I')
		item.oper = 'U';

	// apply the data which was entered.
	$('#lossGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}	

// header checkbox action 
function checkBoxHeader(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
}

/***********************************************************************************************																
* 기능 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Grid Text입력시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

// 그리드ㄹFocus 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드에 변경된 데이터validation체크하는 함수
function fn_checkLossValidate(arr1)
{
	var result   = true;
	var message  = "";
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	if (result && arr1.length > 0) {
		ids = $("#lossGrid").jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $("#lossGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#lossGrid").jqGrid('getCell', ids[i], 'loss_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Loss Code Field is required";
					
					setErrorFocus("#lossGrid",ids[i],2,'loss_code');
					break;
				}
				
			}
		}
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// 그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.resizeTo(550, 750);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// 그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" onclick='chkClick("+rowid+")'/>";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	

// Cell - Merge변수 초기화
function fn_initPrevCellVal() {
	prevCellVal  = { cellId: undefined, value: undefined };
	prevCellVal1 = { cellId: undefined, value: undefined };
 	prevCellVal2 = { cellId: undefined, value: undefined, loss_code: undefined };
 	prevCellVal3 = { cellId: undefined, value: undefined, loss_code: undefined, loss_desc: undefined };
 	prevCellVal4 = { cellId: undefined, value: undefined, loss_code: undefined, loss_desc: undefined };

}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 신규 생성 화면 호출
function fn_new() {
	
	if (win != null){
   		win.close();
   	}
	var args = {loss_code  : '',
				loss_desc	: '',
				order_seq   : ''};
	win = window.showModalDialog("popUpPaintLossEdit.do?gbn=paintLossEdit&menu_id=${menu_id}",args,"dialogWidth:1300px; dialogHeight:640px; center:on; scroll:off; status:off; location:no");	
	fn_search();
}

// 수정 생성 화면 호출
function fn_modify() {

	var rowId 	= jQuery("#lossGrid").jqGrid('getGridParam','selrow');  
	
	if (rowId == null) {
		alert("Please select Loss Code");
		return;
	}
	
	var rowData = jQuery("#lossGrid").getRowData(rowId);
	if (win != null){
   		win.close();
   	}
	var param =   "&loss_code=" + rowData.loss_code
				+ "&loss_desc=" + rowData.loss_desc
				+ "&order_seq=" + rowData.order_seq;
	
	var args = {loss_code  : rowData.loss_code,
				loss_desc	: rowData.loss_desc,
				order_seq   : rowData.order_seq};
	
	win = window.showModalDialog("popUpPaintLossEdit.do?gbn=paintLossEdit&menu_id=${menu_id}"+param,args,"dialogWidth:1300px; dialogHeight:640px; center:on; scroll:off; status:off; location:no");
	fn_search();
}

// 그리의 변경된 데이터를 저장하는 함수
/* function fn_save() {
	
	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
	
	var changeLossResultRows =  getChangedGridInfo("#lossGrid");;
	
	if (!fn_checkLossValidate(changeLossResultRows)) { 
		return;	
	}
		
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#lossGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#lossGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintLoss.do";
	var dataList    = {lossList:JSON.stringify(changeLossResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
			
			lodingBox.remove();
			
			var obj = jQuery.parseJSON(data);
			
			alert(obj[0].Result_Msg);
			
			if (obj[0].result == "success") fn_search();
		
	});
} */

// 저장된 lossCode를 조회하는 함수
function fn_search() {
	
	fn_initPrevCellVal();	
				
	var sUrl = "infoPaintLossList.do";
	$("#lossGrid").jqGrid('setGridParam',{url		: sUrl
										,mtype		: 'POST'
									    ,page		: 1
									    ,datatype	: 'json'
									    ,postData   : getFormData("#listForm")}).trigger("reloadGrid");
} 

/* // Paint Area 조회하는 화면 호출
function searchAreaCode(obj,sCode,sDesc,sTypeCode) {
		
	var searchIndex = $(obj).closest('tr').get(0).id;
	
	fn_applyData("#lossGrid",change_loss_row_num,change_loss_col);
		
	var item = $(tableId).jqGrid('getRowData',searchIndex);		
	
	var args = {p_code_find : item.area_code};
		
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupLossCode",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,sCode,rs[0]);
		$(tableId).setCell(searchIndex,sDesc,rs[1]);
	}
} */

/* //엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
			   									
	win = window.open("./lossExcelUpload.do?gbn=paintLossExcelUpload","listForm","height=260,width=650,top=200,left=200");
} */

//엑셀 업로드 화면 호출
function fn_excelDownload() {
	location.href='./lossExcelExport.do?lossCode='+$("input[name=lossCode]").val();
}

//Lose코드 끄기/켜기
function fn_Use(useFlag) {
	$.post( "updateLoseCodeOnOff.do?useFlag=" + useFlag, "", function( data ) {
		fn_changeLoseCodeOnOff();
	}, "json" );
}

function fn_changeLoseCodeOnOff() {
	$.post( "selectLoseCodeOnOff.do", "", function( data ) {
		lossCodeOnOffFlag = data.attribute2;
		if(data.attribute2 == 'N'){
			$( "#btnUseOn" ).prop( "checked", false );
			$( "#btnUseOff" ).prop( "checked", true );
			
		} else {
			$( "#btnUseOn" ).prop( "checked", true );
			$( "#btnUseOff" ).prop( "checked", false );
		}
	}, "json" );	
}

</script>
</body>
</html>