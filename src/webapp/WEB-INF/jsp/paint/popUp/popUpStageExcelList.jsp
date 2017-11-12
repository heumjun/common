<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Stage</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<input type="hidden" id="cmd" name="cmd" />
	<div id="mainDiv">
		<div  class = "topMain"  style="line-height:45px">
				<div class = "button" >
					<input type="button" value="저장" id="btnSave" />
					<input type="button" value="닫기" id="btnClose" />
				</div>
			
		</div>
		<div>
			<fieldset>
			<legend>Excel Upload 정보</legend>
				<div>
					<div style="margin: 0px 5px 0px 5px">
						<table id = "excelUplodList"></table>
						<div   id = "pexcelUplodList"></div>
					</div>
				</div>
			</fieldset>
		</div>
	</div>
</form>
<script type="text/javascript">
	
var change_stage_row 	= 0;
var change_stage_row_num = 0;
var change_stage_col  	= 0;

var uploadList = $.parseJSON('${uploadList}');

var lodingBox;

$(document).ready(function() {
		
		opener.resizeWin();
		
		$("#excelUplodList").jqGrid({ 
             datatype	: 'local', 
             mtype		: 'POST', 
             url		: '',
            colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Stage Code','Block Rate','PE Rate','Dock Rate', 'Quay Rate', ''],
               colModel:[
                   {name:'chk', index:'chk', width:25,align:'center',formatter: formatOpt1},
                   {name:'stage_code',index:'stage_code', width:100, editable:true,editrules:{required:true}},    
                   {name:'block_rate',index:'block_rate', width:100, align:"right", editable:true,editrules:{number:true, maxValue:100}},
                   {name:'pe_rate',index:'pe_rate', width:80, align:"right", editable:true,editrules:{number:true, maxValue:100}},
                   {name:'dock_rate',index:'dock_rate', width:80, align:"right", editable:true,editrules:{number:true, maxValue:100}},
                   {name:'quay_rate',index:'quay_rate', width:80, align:"right", editable:true,editrules:{number:true, maxValue:100}},
                   {name:'operId',  index:'operId', hidden : true}
               ],
               
            gridview	: true,
            cmTemplate: { title: false },
            toolbar		: [false, "bottom"],
            viewrecords	: false,
            autowidth 	: true,
            height		: G_HEADER_PAGER - 20,
            pager		: $('#pexcelUplodList'),
            rowNum		: 1000, 
            cellEdit	: true,             // grid edit mode 1
	        cellsubmit	: 'clientArray',  	// grid edit mode 2
	        rownumbers  : true,          	// 리스트 순번	
	        pgbuttons	: false,
			pgtext		: false,
			pginput		: false,
	        loadComplete : function (data) {
				  	
			 },	  
			gridComplete : function () {
			
			},
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	change_stage_row 	=	rowid;
            	change_stage_row_num =	iRow;
            	change_stage_col 	=	iCol;
	  		},
            jsonReader : {
                root		: "rows",
                page		: "page",
                total		: "total",
                records		: "records",  
                repeatitems	: false,
            },        
            imgpath: 'themes/basic/images'
           
    	}); 
    	
    	// 그리드 버튼 설정
    	$("#excelUplodList").jqGrid('navGrid',"#pexcelUplodList",{refresh:false,search:false,edit:false,add:false,del:false});
		
		// 그리드 Row 삭제 함수 설정
		$("#excelUplodList").navButtonAdd('#pexcelUplodList',
				{ 	caption:"", 
					buttonicon:"ui-icon-minus", 
					onClickButton: deleteRow,
					position: "first", 
					title:"Del", 
					cursor: "pointer"
				} 
		);
    	    	
    	    	
        /* var data =  {
        	"page": "1",
            "rows": uploadList
        };
	   
	    // 업로드 데이터 그리드에 추가  		
        $("#excelUplodList")[0].addJSONData(data); */
     // 업로드 데이터 그리드에 추가  		
    	$('#excelUplodList').setGridParam({
    					page : 1,
    					data : uploadList,
    							}).trigger('reloadGrid');
	    
		// 저장 버튼
	    $("#btnSave").click(function(){
			fn_save();					
	    });
		
		// 닫기 버튼
		$("#btnClose").click(function(){
			self.close();					
		});
		
}); 

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드 row삭제 함수
function deleteRow() {
	
	fn_applyData("#excelUplodList",change_stage_row_num,change_stage_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		chked_val += po.value+",";
	});
	
	var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		$('#excelUplodList').jqGrid('delRowData', selrow);
	}
	
	$('#excelUplodList').resetSelection();
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
// 엑셀 데이터 validation체크하는 함수
function fn_checkStageValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
	
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	if (result && arr1.length > 0) {
		ids = $("#excelUplodList").jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
					
			//if (oper == 'I' || oper == 'U') {
				
				var val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'stage_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Stage Code Field is required";
					
					setErrorFocus("#excelUplodList",ids[i],2,'stage_code');
					break;
				}
				
				val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'block_rate');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "Block Rate Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],3,'block_rate');
					break;
				}
				
				val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'pe_rate');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "PE Rate Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],4,'pe_rate');
					break;
				}
				
				val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'dock_rate');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "Dock Rate Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],5,'dock_rate');
					break;
				}
				
				val1 = $("#excelUplodList").jqGrid('getCell', ids[i], 'quay_rate');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "Quay Rate Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],6,'quay_rate');
					break;
				}
			//}
		}
	}
	
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 그리드의 모든 Row 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return true;
	});
			
	return changedData;
}

// 그리드 포커스 이동시 변경중인 cell내용 저장하는 함수
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
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

// 그리드에 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

/***********************************************************************************************																
* 서비스 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 엑셀 데이터 저장 서버스 호출 함수		
function fn_save() {
	
	fn_applyData("#excelUplodList",change_stage_row_num,change_stage_col);
	
	// ERROR표시를 위한 ROWID 저장
	var ids = $("#excelUplodList").jqGrid('getDataIDs');
	
	for(var  j = 0; j < ids.length; j++) {	
		$('#excelUplodList').setCell(ids[j],'operId',ids[j]);
	}
	
	var changeStageResultRows =  getChangedGridInfo("#excelUplodList");;
	
	if (!fn_checkStageValidate(changeStageResultRows)) { 
		return;	
	}
		
	
	var url			= "saveExcelPaintStage.do";
	var dataList    = {stageList:JSON.stringify(changeStageResultRows)};
	var formData 	= getFormData('#listForm');
	
	lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
		alert(data.resultMsg);
		if (data.result == "success") {
				$("#excelUplodList").clearGridData(true);
				opener.fn_search();
				self.close();
		} else if(data.result == "fail"){
			if (data.stageList != null) {
				for (var i=0; i<data.stageList.length; i++) {
					if (data.stageList[i].error_yn == "Y") {
						$("#excelUplodList").jqGrid('setRowData', data.stageList[i].operId, false, {  color:'black',weightfont:'bold',background:'red'});
						$("#"+data.stageList[i].operId+"_chkBoxOV").prop("checked", true);
					} else {
						$("#excelUplodList").jqGrid('setRowData', data.stageList[i].operId, false, {  color:'black',weightfont:'',background:''}); 
					}	
				}
			}	
		}
	}).fail(function(){
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	}).always(function() {
    	lodingBox.remove();	
	});
}

</script>
</body>
</html>