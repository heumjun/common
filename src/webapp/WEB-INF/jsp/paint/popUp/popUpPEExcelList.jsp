<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Pe</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<form name="listForm" id="listForm">
	<input type="hidden" id="cmd" name="cmd" />
	<div id="mainDiv">
		<div  class = "topMain" style="line-height:45px">
			
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
	
	var change_pe_row 	= 0;
	var change_pe_row_num = 0;
	var change_pe_col  	= 0;
	
	var uploadList = $.parseJSON('${uploadList}');
	
	var lodingBox;
	
	$(document).ready(function() {
			
			opener.resizeWin();
			
			$("#excelUplodList").jqGrid({ 
	             datatype	: 'local', 
	             mtype		: 'POST', 
	             url		: '',
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', 'Project No','Revision','P.E Code','PRE PE','BLOCK','Error MSG', '', ''],
                colModel:[
                	{name:'chk', 		  index:'chk', 		  	width:20,align:'center',formatter: formatOpt1},
                	{name:'project_no',   index:'project_no', 	width:70, editrules:{required:true}},
                	{name:'revision', 	  index:'revision',   	width:35, editrules:{required:true}, align:'right'},
                    {name:'pe_code',	  index:'pe_code', 	  	width:60, editable:true,editrules:{required:true}},    
                    {name:'pre_pe_code',  index:'pre_pe_code',  width:60, editable:true,editrules:{required:true}},
                    {name:'block_code',   index:'block_code',   width:60, editable:true},
                    //{name:'area',		  index:'area',		width:40, editable:true,editrules:{number:true},align:'right'},
                    {name:'error_msg',	  index:'error_msg',	 width:130},
                    {name:'pre_pe_color', index:'pre_pe_color',  hidden : true},
                    {name:'operId',  	  index:'operId', 		 hidden : true}
                ],
                
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             viewrecords: false,
             autowidth  : true,
             height		: G_HEADER_PAGER - 20,
             pager		: $('#pexcelUplodList'),
             rowNum		: 9999, 
             cellEdit	: true,             // grid edit mode 1
	         cellsubmit	: 'clientArray',  	// grid edit mode 2
	         rownumbers : true,          	// 리스트 순번	
             pgbuttons	: false,
			 pgtext		: false,
			 pginput	: false,
			 			 
	         loadComplete: function() {
             	$("#excelUplodList").prop("checked", false);	
			 },
			 gridComplete : function () {
			 	var grid = $("#excelUplodList");
			 	
			 	var ids  = grid.jqGrid('getDataIDs');
			 				 	
			 	for(var i=0; i<ids.length; i++) {
			 		
			 		if (grid.getCell(ids[i],"pre_pe_color") == "color_code") grid.jqGrid('setCell',ids[i],"pre_pe_code","",{'background-color':'yellow',
                                         							 									'background-image':'none'});
			 	}
			 	
			 	//$("#excelUplodList td:contains('color_code')").css("background","yellow");	
			 },
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	change_pe_row 	=	rowid;
             	change_pe_row_num =	iRow;
             	change_pe_col 	=	iCol;
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
	function deleteRow(){
		
		fn_applyData("#excelUplodList",change_pe_row_num,change_pe_col);
		
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
	function fn_checkPeValidate(arr1) {
		var result   = true;
		var message  = "";
		var $grid	 = $("#excelUplodList");
		var ids ;
		
		if (arr1.length == 0) {
			result  = false;
			message = "변경된 내용이 없습니다.";	
		}
		
		if (result && arr1.length > 0) {
			ids = $grid.jqGrid('getDataIDs');

			for(var i=0; i < ids.length; i++) {
				var iRow = $grid.jqGrid('getRowData', ids[i]);
		
				for (var j = i+1; j <ids.length; j++) {
					var jRow = $grid.jqGrid('getRowData', ids[j]);
					
					if (iRow.block_code == jRow.block_code) {
						result  = false;
					
						message = $grid.jqGrid('getInd',ids[i]) +"ROW, "+ $grid.jqGrid('getInd',ids[j])+"ROW는 Block Code가 중복됩니다.";	
						break;	
					}
				}
				
				if (result == false) break;
			}
		}
		
		if (result && arr1.length > 0) {
			
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
					
					val1 = $grid.jqGrid('getCell', ids[i], 'pe_code');
					if ($.jgrid.isEmpty(val1)) {
						result  = false;
						message = "Pe Code Field is required";
						
						setErrorFocus("#excelUplodList",ids[i],4,'pe_code');
						break;
					}
					
					val1 = $grid.jqGrid('getCell', ids[i], 'block_code');
					if ($.jgrid.isEmpty(val1)) {
						result  = false;
						message = "Block Code Field is required";
						
						setErrorFocus("#excelUplodList",ids[i],6,'block_code');
						break;
					}
					
					
					/*
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
					}*/
			}
		}
		
		if (!result) {
			alert(message);
		}
		
		return result;	
	}
	
	// 그리드 포커스 이동시 변경중인 cell내용 저장하는 함수
	function fn_applyData(gridId, nRow, nCol) {
		$(gridId).saveCell(nRow, nCol);
	}
	
	// 그리드의 모든 Row 가져오는 함수
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
	
	// 폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	}
		
	// 그리드에  checkbox 생성
	function formatOpt1(cellvalue, options, rowObject) {
		var rowid = options.rowId;
	  	return "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
	}
	
	/***********************************************************************************************																
	* 서비스 호출하는 부분 입니다. 	
	*
	************************************************************************************************/
	// 엑셀 데이터 저장 서버스 호출 함수	
	function fn_save() {
		lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
		fn_applyData("#excelUplodList",change_pe_row_num,change_pe_col);
		
		// ERROR표시를 위한 ROWID 저장
		var ids = $("#excelUplodList").jqGrid('getDataIDs');
		
		for(var  j = 0; j < ids.length; j++) {	
			$('#excelUplodList').setCell(ids[j],'operId',ids[j]);
		}
		
		var changePeResultRows =  getChangedGridInfo("#excelUplodList");;
				
		if (!fn_checkPeValidate(changePeResultRows)) { 
			lodingBox.remove();
			return;	
		}
		
		var url			= "saveExcelPaintPE.do";
		var dataList    = {peList:JSON.stringify(changePeResultRows)};
		var formData 	= getFormData('#listForm');
				
		var parameters = $.extend({},dataList,formData);
				
		$.post(url, parameters, function(data) {
				
			alert(data.resultMsg);
			if (data.result == "success") {
				$("#excelUplodList").clearGridData(true);
				opener.fn_search();
				self.close();
			} else if(data.result == "fail"){
				if (data.peList !=  null) {
					for (var i=0; i<data.peList.length; i++) {
						
						if (data.peList[i].error_yn == "Y") {
							$("#excelUplodList").jqGrid('setRowData', data.peList[i].operId, false, {  color:'black',weightfont:'bold',background:'red'}); 
							$("#excelUplodList").setCell(data.peList[i].operId,'error_msg',data.peList[i].error_msg);
							$("#"+data.peList[i].operId+"_chkBoxOV").prop("checked", true);
						} else {
							$("#excelUplodList").jqGrid('setRowData', data.peList[i].operId, false, {  color:'black',weightfont:'',background:''}); 
							$("#excelUplodList").setCell(data.peList[i].operId,'error_msg',"");
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