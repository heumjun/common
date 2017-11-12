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
					<input type="button" value="����" id="btnSave" />
					<input type="button" value="�ݱ�" id="btnClose" />
				</div>
			
		</div>
		<div>
			<fieldset>
			<legend>Excel Upload ����</legend>
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
	        rownumbers  : true,          	// ����Ʈ ����	
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
    	
    	// �׸��� ��ư ����
    	$("#excelUplodList").jqGrid('navGrid',"#pexcelUplodList",{refresh:false,search:false,edit:false,add:false,del:false});
		
		// �׸��� Row ���� �Լ� ����
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
	   
	    // ���ε� ������ �׸��忡 �߰�  		
        $("#excelUplodList")[0].addJSONData(data); */
     // ���ε� ������ �׸��忡 �߰�  		
    	$('#excelUplodList').setGridParam({
    					page : 1,
    					data : uploadList,
    							}).trigger('reloadGrid');
	    
		// ���� ��ư
	    $("#btnSave").click(function(){
			fn_save();					
	    });
		
		// �ݱ� ��ư
		$("#btnClose").click(function(){
			self.close();					
		});
		
}); 

/***********************************************************************************************																
* �̺�Ʈ �Լ� ȣ���ϴ� �κ� �Դϴ�. 	
*
************************************************************************************************/
// �׸��� row���� �Լ�
function deleteRow() {
	
	fn_applyData("#excelUplodList",change_stage_row_num,change_stage_col);
	
	//������ �迭�߿��� �ʿ��� �迭�� ��󳻱� 
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
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //�̺�Ʈ �����
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
}

/***********************************************************************************************																
* ��� �Լ� ȣ���ϴ� �κ� �Դϴ�. 	
*
************************************************************************************************/
// ���� ������ validationüũ�ϴ� �Լ�
function fn_checkStageValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
	
	if (arr1.length == 0) {
		result  = false;
		message = "����� ������ �����ϴ�.";	
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

// �׸����� ��� Row �������� �Լ�
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return true;
	});
			
	return changedData;
}

// �׸��� ��Ŀ�� �̵��� �������� cell���� �����ϴ� �Լ�
function fn_applyData(gridId, nRow, nCol) {
	$(gridId).saveCell(nRow, nCol);
}

// ��Ŀ�� �̵�
function setErrorFocus(gridId, rowId, colId, colName) {
	$("#" + rowId + "_"+colName).focus();
	$(gridId).jqGrid('editCell', rowId, colId, true);
}	

// �������͸� Json Arry�� ����ȭ
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

// �׸��忡 checkbox ����
function formatOpt1(cellvalue, options, rowObject){
	var rowid = options.rowId;
  	
  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
}

/***********************************************************************************************																
* ���� ȣ���ϴ� �κ� �Դϴ�. 	
*
************************************************************************************************/
// ���� ������ ���� ������ ȣ�� �Լ�		
function fn_save() {
	
	fn_applyData("#excelUplodList",change_stage_row_num,change_stage_col);
	
	// ERRORǥ�ø� ���� ROWID ����
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
		alert("�ý��� �����Դϴ�.\n�������ڿ��� �������ּ���.");
	}).always(function() {
    	lodingBox.remove();	
	});
}

</script>
</body>
</html>