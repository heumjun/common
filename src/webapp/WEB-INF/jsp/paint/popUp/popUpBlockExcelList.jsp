<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Block</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<input type="hidden" id="cmd" name="cmd" />
	<div id="mainDiv" class='mainDiv'>
		<div  class = "topMain" style="line-height:45px">
			
			<div class = "button" >
				<input type="button" value="저장" id="btnSave" class="btn_blue" />
				<input type="button" value="닫기" id="btnClose" class="btn_blue" />
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
	
var change_block_row 	= 0;
var change_block_row_num = 0;
var change_block_col  	= 0;

var uploadList = $.parseJSON('${uploadList}');

var lodingBox;

$(document).ready(function() {
		
		opener.resizeWin();
		
		$("#excelUplodList").jqGrid({ 
             datatype	: 'local', 
             mtype		: 'POST', 
             url		: '',
            colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','Project No','Revision','Block Code','Area Code','Area Desc','Area','Error MSG', ''],
               colModel:[
	               	{name:'chk', index:'chk', width:25,align:'center',formatter: formatOpt1},
	               	{name:'project_no', index:'project_no', width:70, editrules:{required:true}},
	               	{name:'revision', 	index:'revision', 	width:35, editrules:{required:true}, align:'right'},
	                {name:'block_code',	index:'block_code', width:60, editable:true,editrules:{required:true}},    
	                {name:'area_code',	index:'area_code',  width:60, editable:true,editrules:{required:true}},
	                {name:'area_desc',  index:'area_desc',  width:60, editable:true},
	                {name:'area',		index:'area',		width:40, editable:true,editrules:{number:true},align:'right'},
	                {name:'error_msg',	index:'error_msg',	width:140},
	                {name:'operId',  	index:'operId', 	hidden : true}
               ],
               
            gridview	: true,
            cmTemplate: { title: false },
            toolbar		: [false, "bottom"],
            viewrecords : false,
            autowidth 	: true,
            height		: G_HEADER_PAGER - 20,
            pager		: $('#pexcelUplodList'),
            rowNum		: 99999, 
            cellEdit	: true,             // grid edit mode 1
         	cellsubmit	: 'clientArray',  	// grid edit mode 2
         	rownumbers  : true,          	// 리스트 순번	
            pgbuttons	: false,
		 	pgtext		: false,
		 	pginput		: false,
         	loadComplete: function() {
         		// ERROR표시를 위한 ROWID 저장
         		var ids = $("#excelUplodList").jqGrid('getDataIDs');
       			for(var  j = 0; j < ids.length; j++) {	
       				$('#excelUplodList').setCell(ids[j],'operId',ids[j]);
       			}
		 	},
		 	gridComplete : function () {
		
		 	},
		 	beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	change_block_row 	=	rowid;
            	change_block_row_num =	iRow;
            	change_block_col 	=	iCol;
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
    	
    $("#excelUplodList").jqGrid('navGrid',"#pexcelUplodList",{refresh:false,search:false,edit:false,add:false,del:false});

	$("#excelUplodList").navButtonAdd('#pexcelUplodList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
	);
 
	$("#btnSave").click(function(){
		fn_save();					
	});
	
	$("#btnClose").click(function(){
		self.close();					
	});
		
	setLpad();	
}); 

/***********************************************************************************************																
* 이벤트 함수 호출하는 부분 입니다. 	
*
************************************************************************************************/
// 그리드 row삭제 함수 
function deleteRow(){
	
	fn_applyData("#excelUplodList",change_block_row_num,change_block_col);
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	var chked_val = "";
	$(":checkbox[name='checkbox']:checked").each(function(pi,po){
		$('#excelUplodList').jqGrid('delRowData', po.value);
		//chked_val += po.value+",";
	});
	
	/* var selarrrow = chked_val.split(',');
	
	for(var i=0;i<selarrrow.length-1;i++){
		var selrow = selarrrow[i];	
		$('#excelUplodList').jqGrid('delRowData', selrow);
	} */
	
	$('#excelUplodList').resetSelection();

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
// 엑셀 업로드한 block code 세자리로 설정하는 함수 
function setLpad() {
	
	for(var i=0; i<uploadList.length; i++) {
		uploadList[i].block_code = lpad(uploadList[i].block_code+"", 3, '0');		
	}
			    	
/*   	var data =  {
         		"page": "1",
         		"rows": uploadList
     			};

    $("#excelUplodList")[0].addJSONData(data); */
    
 // 업로드 데이터 그리드에 추가  		
	$('#excelUplodList').setGridParam({
					page : 1,
					data : uploadList,
							}).trigger('reloadGrid');
}

// 엑셀 데이터 validation체크하는 함수
function fn_checkBlockValidate(arr1) {
	var result   = true;
	var message  = "";
	var $grid	 = $("#excelUplodList");
	var ids ;
	
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	/* if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');
	
		for(var  i = 0; i < ids.length; i++) {
			
				var val1 = $grid.jqGrid('getCell', ids[i], 'project_no');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Project No Field is required";
					
					setErrorFocus("#excelUplodList",ids[i],2,'project_no');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'revision');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Revision Field is required";
					
					setErrorFocus("#excelUplodList",ids[i],3,'revision');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'block_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Block Code Field is required";
					
					setErrorFocus("#excelUplodList",ids[i],4,'block_code');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'area_code');
				if ($.jgrid.isEmpty(val1)) {
					result  = false;
					message = "Area Code Field is required";
					
					setErrorFocus("#excelUplodList",ids[i],5,'area_code');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'area');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "Area Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],7,'area');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'pre_loss');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "Pre Loss Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],6,'pre_loss');
					break;
				}
				
				val1 = $grid.jqGrid('getCell', ids[i], 'post_loss');					
				
				if (!$.jgrid.isEmpty(val1) && isNaN(val1)) {
					result  = false;
					message = "Post Loss Field is a numerical format";
					
					setErrorFocus("#excelUplodList",ids[i],7,'post_loss');
					break;
				}
		}
	}
		
	if (result && arr1.length > 0) {
		ids = $grid.jqGrid('getDataIDs');

		for(var i=0; i < ids.length; i++) {
			var iRow = $grid.jqGrid('getRowData', ids[i]);
	
			for (var j = i+1; j <ids.length; j++) {
				var jRow = $grid.jqGrid('getRowData', ids[j]);
				
				if (iRow.block_code == jRow.block_code 
					&& iRow.area_code == jRow.area_code) 
				{
					result  = false;
					message = $grid.jqGrid('getInd',ids[i]) +"ROW, "+ $grid.jqGrid('getInd',ids[j])+"ROW는 Block의 Area Code가 중복됩니다.";	
					break;	
				}
			}
			
			if (result == false) break;
		}
	} */
		
	if (!result) {
		alert(message);
	}
	
	return result;	
}

// 그리드 변경된 데이터를 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return true;
	});
			
	return changedData;
}

// 포커스 이동
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
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

//그리드에  checkbox 생성
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
	lodingBox = new uploadAjaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
	fn_applyData("#excelUplodList",change_block_row_num,change_block_col);
	
	var changeBlockResultRows =  getChangedGridInfo("#excelUplodList");;
	
	if (!fn_checkBlockValidate(changeBlockResultRows)) { 
		lodingBox.remove();	
		return;	
	}
		
	
	var url			= "saveExcelPaintBlock.do";
	var dataList    = {blockList:JSON.stringify(changeBlockResultRows)};
	var formData 	= getFormData('#listForm');
	
		
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(data) {
			
			alert(data.resultMsg);
			if (data.result == "success") {
				$("#excelUplodList").clearGridData(true);
				opener.fn_search();
				self.close();
			} else if(data.result == "fail"){
				
				if (data.blockList.length >  0) {
					for (var i=0; i<data.blockList.length; i++) {
						
						if (data.blockList[i].error_yn == "Y") {
							$("#excelUplodList").jqGrid('setRowData', data.blockList[i].operId, false, {  color:'black',weightfont:'bold',background:'red'}); 
							$("#excelUplodList").setCell(data.blockList[i].operId,'error_msg',data.blockList[i].error_msg);
							$("#"+data.blockList[i].operId+"_chkBoxOV").prop("checked", true);
						} else {
							$("#excelUplodList").jqGrid('setRowData', data.blockList[i].operId, false, {  color:'black',weightfont:'',background:''}); 
							$("#excelUplodList").setCell(data.blockList[i].operId,'error_msg',"");
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