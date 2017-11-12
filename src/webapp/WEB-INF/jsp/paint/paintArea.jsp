<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Area</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>

<div id="mainDiv" class="mainDiv">

<form name="listForm" id="listForm"  method="get" >
<div class= "subtitle">
Paint Area Code
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>



<table class="searchArea conSearch">
		<col width="8%"><!--AREA CODE-->
		<col width="17%">
		<col width="8%">

		<tr>
		<th>AREA CODE</th>
		<td>
		 <input type="text" id="txtAreaCode" name="areaCode" class="wid200" style="ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
		 </td>

		<th>AREA NAME</th>
		<td>
		 <input type="text" id="txtAreaName"  name="areaName" class="wid200"/>
		 </td>

		<th>LOSS CODE</th>
		<td style="border-right:none">
		<input type="text" id="txtLossCode"  name="lossCode" class="wid200" style="ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
		</td>

		<td style="border-left:none;min-width:280px;">
			<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" value="조회" id="btnSearch" class="btn_blue" />
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">		
			<input type="button" value="저장" id="btnSave"  class="btn_blue"/>
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
			<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue"/>
			</c:if>
			<c:if test="${userRole.attribute6 == 'Y'}">
			<input type="button" value="Excel등록" id="btnExcelImport" class="btn_blue"/>
			</c:if>
			
			</div>
		</td>						
		</tr>	
</table>

	<!--
	<div class = "conSearch">
			<span class = "spanMargin">
			Area Code
			<input type="text" id="txtAreaCode" name="areaCode" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</span>
		</div>
		<div class = "conSearch">
			<span class = "spanMargin">
			Area Name
			<input type="text" id="txtAreaName"  name="areaName" style="width:200px;"/>
			</span>
		</div>
		<div class = "conSearch">
			<span class = "spanMargin">
			Loss Code
			<input type="text" id="txtLossCode"  name="lossCode" style="width:80px; ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
			</span>
		</div>
		
		<div class = "button">
			<input type="button" value="조  회" id="btnSearch"  />
			<input type="button" value="저  장" id="btnSave" disabled   />
			<input type="button" value="Excel등록" id="btnExcelImport" disabled />
			<input type="button" value="Excel출력" id="btnExcelExport"  />		
		</div>
	-->
	<div class="content">
		<table id = "areaGrid"></table>
		<div   id = "p_areaGrid"></div>
	</div>	
</form>
</div>	

<script type="text/javascript">

var change_area_row 	= 0;
var change_area_row_num = 0;
var change_area_col  	= 0;

var tableId	   			= "#areaGrid";
var deleteData 			= [];

var searchIndex 		= 0;
var lodingBox; 
var win;	
var userid				= "${loginUser.user_id}";

$(document).ready(function(){
	fn_all_text_upper();
	
	var objectHeight = gridObjectHeight(1);
	
	$("#areaGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Area Code','Area Name','Loss Code','AF Code',''],
                colModel:[
                    {name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt1},
                    {name:'area_code',index:'area_code', width:100, editable:true, editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},    //editrules:{required:true},
                    {name:'area_desc',index:'area_desc', width:200, editable:true },                                      
                    {name:'loss_code',index:'loss_code', width:100, editable:true, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},    //editrules:{required:true},
				 	{name:'af_code',index:'af_code', editoptions: { dataInit: function(elem) {$(elem).width(150);}}  // set the width which you need
                     ,editable : true, align :'left', sortable : false, edittype : 'select', formatter : 'select', editrules : { required:true } },
                    {name:'oper',index:'oper', width:25, hidden:true},
                ],
                cmTemplate: { title: false },   
             gridview	: true,
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_areaGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	       
	         beforeSaveCell : changeAreaEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	
            	if (name == "area_code" || name == "loss_code") setUpperCase('#areaGrid',rowid,name);	
            	fn_jqGridChangedCell('#areaGrid', rowid, 'chk', {background:'pink'});
            	
            	if (name == "loss_code") {
            		var item = $("#areaGrid").jqGrid('getRowData',rowid);		
            		var args = {p_code_find : item.loss_code};
            		var rs = window.showModalDialog("popUpLossCode.do",args,"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");
            		if (rs != null) {
            			item.loss_code = rs[0];
            		} else {
            			item.loss_code = '';
            		}
            		$('#areaGrid').jqGrid("setRowData", rowid, item);
            	}
	         },
	         onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
			 gridComplete : function() {
				var rows = $( "#areaGrid" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = $( "#areaGrid" ).getCell( rows[i], "oper" );
					if( oper != "D") {
						if( oper != "I") {
							//미입력 영역 회색 표시
							$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'area_code', '', { background : '#DADADA' } );
						}
						$( "#areaGrid" ).jqGrid( 'setCell', rows[i], 'loss_code', '', { cursor : 'pointer', background : 'pink' } );
					}
					
				}
				
			},
	         loadComplete : function (data) {
	         
			  	$("#chkHeader").prop("checked", false);	
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
             	change_area_row 	=	rowid;
             	change_area_row_num =	iRow;
             	change_area_col 	=	iCol;
   			 },
			 onCellSelect: function(row_id, colId) {
             	if(row_id != null) 
                {
                	var ret 	= jQuery("#areaGrid").getRowData(row_id);
                	
	               	if (colId == 2 && ret.oper != "I") jQuery("#areaGrid").jqGrid('setCell', row_id, 'area_code', '', 'not-editable-cell');
                } 
             },  	         
	         // json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
             jsonReader : {
                 root: "rows",                    // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
                 page: "page",                    // 현재 페이지. 하단 navi에 출력됨.  
                 total: "total",                  // 총 페이지 수
                 records: "records",
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images'
             
     }); 
	
	//grid resize
    fn_gridresize($(window),$("#areaGrid"));
    
	$("#areaGrid").jqGrid('navGrid',"#p_areaGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute2 == 'Y'}">
	$("#areaGrid").navButtonAdd("#p_areaGrid",
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
	
	<c:if test="${userRole.attribute3 == 'Y'}">
	$("#areaGrid").navButtonAdd('#p_areaGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute1 == 'Y'}">
 	$("#areaGrid").navButtonAdd('#p_areaGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if>
	
	//AF CODE selectPaintCodeList
// 	$.post( "getPaintAreaCodeList.do", {addCode:'Not',main_category:'PAINT',states_type:'AF CODE'}, function( data ) {
// 		var data2 = $.parseJSON( data );
		
// 		$( '#areaGrid' ).setObject( { value : 'value', text : 'text', name : 'af_code', data : data2.list } );
// 	} );
	
	$.post( "infoComboCodeMaster.do?sd_type=PAINT_AF_CODE", "", function( data ) {
		$( '#areaGrid' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'af_code',
			data : data
		} );
	}, "json" );
	
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	/* 
	 그리드 데이터 조회
	 */
	$("#btnSearch").click(function() {
		fn_search();
	});
	
	/* 
	 엑셀 데이터 import
	 */
	$("#btnExcelImport").click(function() {
		fn_excelUpload();	
	});
	
	/* 
	 엑셀 데이터 export
	 */
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
	
	// 버튼 권한 설정
	/* fn_buttonDisabledUser(userid, ["#btnSave","#btnExcelImport"]); */
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
//Del 버튼
function deleteRow(){
	
	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
	
		var selrow = selarrrow[i];	
		var item   = $('#areaGrid').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#areaGrid').jqGrid("setRowData", selrow, item);
			var colModel = $( '#areaGrid' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#areaGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
		}  else if(item.oper == 'I') {
				$('#areaGrid').jqGrid('delRowData', selrow);	
			} else if(item.oper == 'U') {
				alert("수정된 내용은 삭제 할수 없습니다.");
			}

		
	}
	
	$('#areaGrid').resetSelection();
}

//Add 버튼 
function addRow(item) {

	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
	
	var item = {};
	var colModel = $('#areaGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
	item.af_code = '0';
	
	var nRandId = $.jgrid.randId();
	$('#areaGrid').resetSelection();
	$('#areaGrid').jqGrid('addRowData', nRandId, item, 'first');
	fn_jqGridChangedCell('#areaGrid', nRandId, 'chk', {background:'pink'});
	
	tableId = '#areaGrid';	
}

//그리드 cell변경된 경우 호출하는 함수
function changeAreaEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#areaGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#areaGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#areaGrid').jqGrid("setRowData", irowId, item);
	// turn off editing.
	$("input.editable,select.editable", this).attr("editable", "0");
}	

//header checkbox action 
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
// 그리드 변경된 데이터 validation 체크하는 함수	
function fn_checkAreaValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	if (result && arr1.length > 0) {
		ids = $("#areaGrid").jqGrid('getDataIDs');
	
		 for(var  i = 0; i < ids.length; i++) {
			var oper = $("#areaGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#areaGrid").jqGrid('getCell', ids[i], 'area_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Area Code Field is required";
					
					setErrorFocus("#areaGrid",ids[i],2,'area_code');
					break;
				}
				
					
				val1 = $("#areaGrid").jqGrid('getCell', ids[i], 'loss_code');					
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Loss Code Field is required";
					
					setErrorFocus("#areaGrid",ids[i],4,'loss_code');
					break;
				}
				
				val1 = $("#areaGrid").jqGrid('getCell', ids[i], 'af_code');					
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "AF Code Field is required";
					
					setErrorFocus("#areaGrid",ids[i],5,'af_code');
					break;
				}
			}
		} 
	}
	
	if (result && arr1.length > 0) {
		ids = $("#areaGrid").jqGrid('getDataIDs');
		
		/* for(var i=0; i < ids.length; i++) {
		
			var iRow = $("#areaGrid").jqGrid('getRowData', ids[i]);
									
			for (var j = i+1; j <ids.length; j++) {
				
				var jRow = $("#areaGrid").jqGrid('getRowData', ids[j]);
				
				if (iRow.area_code == jRow.area_code) {
					result  = false;
					message =  $("#areaGrid").jqGrid('getInd',ids[i]) +"ROW, "+$("#areaGrid").jqGrid('getInd',ids[j])+"ROW는 Area Code가 중복됩니다.";	
					break;	
				}
			}
			
			if (result == false) break;
		} */
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 그리드의 변경된 row데이터를 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// 변경중인 cell 저장
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드 cell 대문자 변환
function setUpperCase(gridId, rowId, colNm) {
	
	if (rowId != 0 ) {
		
		var $grid = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

//팝업 화면 리사이즈
function resizeWin() {
    win.moveTo(200,0);
    win.resizeTo(720, 780);                             // Resizes the new window
    win.focus();                                        // Sets focus to the new window
}

// input text대문자로 변환하는 함수
function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
}

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject) {
	var rowid = options.rowId;
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}

// 그리드 cell로 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/	
// 그리드의 변경된 내용 저장
function fn_save() {
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	fn_applyData("#areaGrid",change_area_row_num,change_area_col);
		
	var changeAreaResultRows =  getChangedGridInfo("#areaGrid");
	
	if (!fn_checkAreaValidate(changeAreaResultRows)) { 
		lodingBox.remove();
		return;	
	}
		
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#areaGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#areaGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintArea.do";
	var dataList    = {chmResultList:JSON.stringify(changeAreaResultRows)};
	var formData 	= getFormData('#listForm');
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
		alert(data.resultMsg);
		if ( data.result == 'success' ) {
			fn_search();
		}
	}).fail(function(){
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	}).always(function() {
    	lodingBox.remove();	
	});
	
}


//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// Paint Area를 조회한다.
function fn_search() {
		
	var sUrl = "paintAreaList.do";
	jQuery("#areaGrid").jqGrid('setGridParam',{url		: sUrl
											  ,mtype    : 'POST'
											  ,page		: 1
											  ,datatype	: 'json'
											  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
} 

// lossCode 서버스 호출하는 함수
function searchLossCode(sCode,rowid) {
		
	
}

//엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null) {
		win.close();
	}
			   	
	win = window.open("popUpExcelUpload.do?gbn=areaExcelImport.do","listForm","height=260,width=680,top=200,left=200");
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	location.href='paintAreaExcelExport.do?areaCode='+$("input[name=areaCode]").val()+'&areaName='+$("input[name=areaName]").val()+'&lossCode='+$("input[name=lossCode]").val();;
}

</script>
</body>
</html>