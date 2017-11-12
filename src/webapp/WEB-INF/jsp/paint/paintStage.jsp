<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Paint Stage</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form name="listForm" id="listForm"  method="get">
<div id="mainDiv" class="mainDiv">
<div class= "subtitle">
Paint Stage Code
<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
</div>
<input type="hidden"  name="pageYn" value="N"  />
<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	
	
<table class="searchArea conSearch">
		<col width="100"><!--AREA CODE-->
		<col width="120">
		<col width="*">

		<tr>
		<th>STAGE CODE</th>
		<td>
		 <input type="text" id="txtStageCode" name="stageCode" style="width:100px;"/>
		 </td>

		<td style="border-left:none;min-width:260px;">
			<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" value="조회" id="btnSearch"  class="btn_blue" />
			</c:if>
			<c:if test="${userRole.attribute4 == 'Y'}">		
			<input type="button" value="저장" id="btnSave"  class="btn_blue"  />
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
			<input type="button" value="Excel출력" id="btnExcelExport"  class="btn_blue"  />
			</c:if>
			<c:if test="${userRole.attribute6 == 'Y'}">
			<input type="button" value="Excel등록" id="btnExcelImport"  class="btn_blue"  />
			</c:if>
			
			
			
			</div>
		</td>						
		</tr>	
</table>
	
	
	
	
	
	
	
	<!--
	<div class = "topMain" style="line-height:45px">
		<div class = "conSearch">
			<span class = "spanMargin">
			Stage Code
			<input type="text" id="txtStageCode" name="stageCode" style="width:100px;"/>
			</span>
		</div>
		
		<div class = "button">
			<input type="button" value="조  회" id="btnSearch"  />
			<input type="button" value="저  장" id="btnSave"  />
			<input type="button" value="Excel등록" id="btnExcelImport"  />
			<input type="button" value="Excel출력" id="btnExcelExport"  />		
		</div>
	</div>
	-->
	<div class="content">
		<table id = "stageGrid"></table>
		<div   id = "p_stageGrid"></div>
	</div>	
</div>	
</form>

<script type="text/javascript">

var change_stage_row 	 = 0;
var change_stage_row_num = 0;
var change_stage_col  	 = 0;

var tableId	   			 = "#stageGrid";
var deleteData 			 = [];

var searchIndex 		 = 0;
var lodingBox; 
var win;	

$(document).ready(function(){
	fn_all_text_upper();
	var objectHeight = gridObjectHeight(1);
	$("#stageGrid").jqGrid({ 
             datatype	: 'json', 
             mtype		: '', 
             url		: '',
             postData   : '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Stage Code','Block Rate','PE Rate','Dock Rate', 'Quay Rate', ''],
                colModel:[
                	{name:'chk', index:'chk', width:12,align:'center',formatter: formatOpt1},
                    {name:'stage_code',index:'stage_code', width:100, editable:true,editrules:{required:true}, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }}},
                    {name:'block_rate',index:'block_rate', width:100, editable:true,editrules:{number:true, maxValue:100}},
                    {name:'pe_rate',index:'pe_rate', width:100, editable:true,editrules:{number:true, maxValue:100}},
                    {name:'dock_rate',index:'dock_rate', width:100, editable:true,editrules:{number:true, maxValue:100}},
                    {name:'quay_rate',index:'quay_rate', width:100, editable:true,editrules:{number:true, maxValue:100}},
                    {name:'oper',index:'oper', width:25, hidden:true },
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: true,                		//하단 레코드 수 표시 유무
             //recordpos : center,   				//viewrecords 위치 설정. 기본은 right left,center,right
             //emptyrecords : 'DATA가 없습니다.',       //row가 없을 경우 출력 할 text
             autowidth	: true,                     //사용자 화면 크기에 맞게 자동 조절
             height		: objectHeight,
             pager		: $('#p_stageGrid'),
             
			 cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         
	         rowList	: [100,500,1000],
			 rowNum		: 1000, 
	         rownumbers : true,          	// 리스트 순번
	         beforeSaveCell : changeStageEditEnd, 
	         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
            	if (name == "stage_code") setUpperCase("#stageGrid",rowid,name);
            	fn_jqGridChangedCell('#stageGrid', rowid, 'chk', {background:'pink'});	
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
				var rows = $( "#stageGrid" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = $( "#stageGrid" ).getCell( rows[i], "oper" );
					if( oper != "D") {
						if( oper != "I") {
							//미입력 영역 회색 표시
							$( "#stageGrid" ).jqGrid( 'setCell', rows[i], 'stage_code', '', { background : '#DADADA' } );
						}	
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
             	change_stage_row 	=	rowid;
             	change_stage_row_num =	iRow;
             	change_stage_col 	=	iCol;
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
                	var ret 	= jQuery("#stageGrid").getRowData(row_id);
                	
	               	if (colId == 2 && ret.oper != "I") jQuery("#stageGrid").jqGrid('setCell', row_id, 'stage_code', '', 'not-editable-cell');
                } 
             }
     }); 
	
	// grid resize
	fn_gridresize($(window),$("#stageGrid"));
	
	// 그리드 버튼 설정
	$("#stageGrid").jqGrid('navGrid',"#p_stageGrid",{refresh:false,search:false,edit:false,add:false,del:false});
	
	<c:if test="${userRole.attribute1 == 'Y'}">
	// 그리드 초기화 함수 설정
	$("#stageGrid").navButtonAdd("#p_stageGrid",
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
	// 그리드 Row 삭제 함수 설정
	$("#stageGrid").navButtonAdd('#p_stageGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
	</c:if>
	
	<c:if test="${userRole.attribute2 == 'Y'}">
	// 그리드 Row 추가 함수 설정
 	$("#stageGrid").navButtonAdd('#p_stageGrid',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
	);
 	</c:if>
	
	/* //AF CODE
	$.post( "selectPaintCode.do", {addCode:'Not',main_category:'PAINT',states_type:'AF CODE'}, function( data ) {
		var data2 = $.parseJSON( data );
		
		$( '#stageGrid' ).setObject( { value : 'value', text : 'text', name : 'af_code', data : data2 } );
	} ); */
	
	/* 
	 그리드 데이터 저장
	 */
	$("#btnSave").click(function() {
		fn_save();
	});
	
	//조회 버튼
	$("#btnSearch").click(function() {
		fn_search();
	});
	
	//엑셀 import
	$("#btnExcelImport").click(function() {
		fn_excelUpload();	
	});
	
	//엑셀 export
	$("#btnExcelExport").click(function() {
		fn_excelDownload();	
	});
	
	
});  //end of ready Function 	

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// Del 버튼
function deleteRow(){
	
	fn_applyData("#stageGrid",change_stage_row_num,change_stage_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		var item   = $('#stageGrid').jqGrid('getRowData',selrow);
		
		if(item.oper =='') {
			item.oper = 'D';
			$('#stageGrid').jqGrid("setRowData", selrow, item);
			var colModel = $( '#stageGrid' ).jqGrid( 'getGridParam', 'colModel' );
			
			for( var j in colModel ) {
				$( '#stageGrid' ).jqGrid( 'setCell', selrow, colModel[j].name,'', {background : '#FF7E9D' } );
			}
			//deleteData.push(item);
		} else if(item.oper == 'I') {
				$('#stageGrid').jqGrid('delRowData', selrow);
		} else if(item.oper == 'U') {
			alert("수정된 내용은 삭제 할수 없습니다.");
		}
	}
	
	$('#stageGrid').resetSelection();
}

// Add 버튼 
function addRow(item) {

	fn_applyData("#stageGrid",change_stage_row_num,change_stage_col);
	
	var item = {};
	var colModel = $('#stageGrid').jqGrid('getGridParam', 'colModel');
	for(var i in colModel) item[colModel[i].name] = '';
	item.oper 	 = 'I';
	
	var nRandId =  $.jgrid.randId();
	$('#stageGrid').resetSelection();
	$('#stageGrid').jqGrid('addRowData', nRandId, item, 'first');
	fn_jqGridChangedCell('#stageGrid', nRandId, 'chk', {background:'pink'});
	tableId = '#stageGrid';	
}

// afterSaveCell oper 값 지정
function changeStageEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $('#stageGrid').jqGrid('getRowData', irowId);
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#stageGrid' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}

	// apply the data which was entered.
	$('#stageGrid').jqGrid("setRowData", irowId, item);
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
// 그리드 cell편집시 대문자로 변환하는 함수
function setUpperCase(gridId, rowId, colNm){
	
	if (rowId != 0 ) {
		
		var $grid  = $(gridId);
		var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
				
		$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
	}
}

// 그리드 포커스 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 그리드에 변경된 데이터 Validation체크하는 함수	
function fn_checkStageValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	if (result && arr1.length > 0) {
		ids = $("#stageGrid").jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			var oper = $("#stageGrid").jqGrid('getCell', ids[i], 'oper');
		
			if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#stageGrid").jqGrid('getCell', ids[i], 'stage_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Stage Code Field is required";
					
					setErrorFocus("#stageGrid",ids[i],2,'stage_code');
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

// 그리드의 변경된 Row만 가져오는 함수	
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U'|| obj.oper == 'D';
	});
	
	changedData = changedData.concat(deleteData);	
		
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}

// window에 resize 이벤트를 바인딩 한다.
function resizeWin() {
    win.moveTo(200,0);
    win.resizeTo(680, 820);                             // Resizes the new window
  
    win.focus();                                        // Sets focus to the new window
}

// 그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

// 삭제 데이터가 저장된 array내용 삭제하는 함수
function deleteArrayClear() {
	if (deleteData.length  > 0) 	deleteData.splice(0, 	 deleteData.length);
}
	
/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드의 변경된 데이터를 저장하는 함수
function fn_save() {
	
	fn_applyData("#stageGrid",change_stage_row_num,change_stage_col);
	
	var changeStageResultRows =  getChangedGridInfo("#stageGrid");;
	
	if (!fn_checkStageValidate(changeStageResultRows)) { 
		return;	
	}
		
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#stageGrid").jqGrid('getDataIDs');
	for(var  j = 0; j < ids.length; j++) {	
		//$('#stageGrid').setCell(ids[j],'operId',ids[j]);
	}
	
	var url			= "savePaintStage.do";
	var dataList    = {chmResultList:JSON.stringify(changeStageResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
		
		alert(data.resultMsg);
		
		if (data.result == "success") fn_search();
	
	}, "json" ).error( function () {
		alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
	} ).always( function() {
    	lodingBox.remove();	
	});
}

// Paint Stage 리스트를 조회
function fn_search() {
				
	var sUrl = "searchPaintStage.do";
	jQuery("#stageGrid").jqGrid('setGridParam',{url		: sUrl
											  ,mtype	: 'POST'
											  ,page		: 1
											  ,datatype	: 'json'
											  ,postData : getFormData("#listForm")}).trigger("reloadGrid");
} 

//엑셀 업로드 화면 호출
function fn_excelUpload() {
	if (win != null){
		win.close();
	}
			   									
	win = window.open("popUpExcelUpload.do?gbn=stageExcelImport.do","listForm","height=260,width=680,top=200,left=200");
}

//엑셀 다운로드 화면 호출
function fn_excelDownload() {
	location.href='./stageExcelExport.do?stageCode='+$("input[name=stageCode]").val();
}

</script>
</body>
</html>