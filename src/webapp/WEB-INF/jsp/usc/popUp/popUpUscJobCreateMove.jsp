<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>JOB CREATE MOVE</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<input type="hidden" id="p_master_project_no" name="p_master_project_no"/>
		<input type="hidden" id="p_project_no" name="p_project_no" value="<c:out value="${p_project_no}" />"/>
		<input type="hidden" id="p_dept_name" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"/>
		<input type="hidden" id="p_user_name" name="p_user_name" value="<c:out value="${loginUser.user_name}" />"/>
		<div class="subtitle">
		JOB CREATE MOVE<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
		<col width="70"/>
		<col width="90"/>
		<col width="70"/>
		<col width="90"/>
		<col width="80"/>
		<col width="90"/>
		<col width="*"/>
		<tr>
			<th>BLOCK</th>
			<td>
				<select class="required" name="p_block_no" id="p_block_no" alt="BLOCK" style="width:70px;">
					<option value=""></option>
				</select>
			</td>
			<th>B_STR</th>
			<td>
				<select class="required" name="p_str_flag" id="p_str_flag" alt="STR" style="width:70px;">
					<option value=""></option>
				</select>
			</td>
			<th>ACT CATA</th>
			<td>
				<select class="required" name="p_act_code" id="p_act_code" alt="ACT CATA" style="width:70px;">
				</select>
			</td>
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
					<input type="button" class="btn_blue2" value="NEXT" id="btnApply"/>
				</div>
			</td>	
		</tr>
		</table>
		
		<div class="content" id="div1" style="display:block">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
		<div class="content" id="div2" style="display:none">
			<table id="jqGridMainList1"></table>
			<div id="bottomJqGridMainList1"></div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var resultData = [];
	
	var jqGridObj = $("#jqGridMainList");	
	var jqGridObj1 = $("#jqGridMainList1");
	
	$(document).ready(function(){
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
             colModel : [
     					{label:'MASTER'	    	, name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 80, editable : false, align : "center"},
     					{label:'PROJECT'		, name : 'project_no'	, index : 'project_no'	, width : 80, editable : false, align : "center"},
     					{label:'BLOCK'			, name : 'block_no'		, index : 'block_no'	, width : 80, editable : false, align : "center"}, 
     					{label:'JOB_STR'		, name : 'str_flag'		, index : 'str_flag'	, width : 80, editable : false, align : "center", hidden:true},
     					{label:'JOB_TYPE'		, name : 'usc_job_type'	, index : 'usc_job_type', width : 80, editable : false, align : "center"},     					
     					{label:'ACT ITEM'		, name : 'old_act_code'	, index : 'old_act_code', width : 100, editable : false, align : "center"},
     					{label:'MOVE ACT ITEM'  , name : 'act_code'		, index : 'act_code'	, width : 100, editable : false, align : "center"},
     					{label:'ACT CATA'   	, name : 'act_catalog'	, index : 'act_catalog'	, width : 100, editable : false, align : "center", hidden:true}, 
     					{label:'JOB ITEM'		, name : 'job_code'		, index : 'job_code'	, width : 100, editable : false, align : "center"},
     					{label:''   			, name : 'job_catalog'	, index : 'job_catalog'	, width : 100, editable : false, align : "center", hidden:true},
     					{label:'PROCESS'		, name : 'process'		, index : 'process'		, width : 100, editable : false, align : "center"},
     					{label:''		    	, name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true}
     				],
				gridview: true,
	             viewrecords: true,
	             autowidth: true,
	             cmTemplate: { title: false },
	             cellEdit : true,
	             cellsubmit : 'clientArray', // grid edit mode 2
				 scrollOffset : 17,
	             multiselect: true,
	             pgbuttons 	: false,
				 pgtext 	: false,
				 pginput 	: false,
	             height: 420,
	             pager: '#bottomJqGridMainList',
	             rowNum:999999, 
		         recordtext: '전체 {2}',
	        	 emptyrecords:'조회 내역 없음',
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow = rowid;
             	idCol = iCol;
             	kRow  = iRow;
             	kCol  = iCol;
   			 },
			 jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
   			 loadComplete: function (data) {
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        //datatype: 'local',
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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj.getRowData(rowid);
					afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
     	
     	jqGridObj1.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
             colModel : [
     					{label:'MASTER'	    	, name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 80, editable : false, align : "center"},
     					{label:'PROJECT'		, name : 'project_no'	, index : 'project_no'	, width : 80, editable : false, align : "center"},
     					{label:'BLOCK'			, name : 'block_no'		, index : 'block_no'	, width : 80, editable : false, align : "center"},    
     					{label:'B_STR'			, name : 'block_str_flag', index : 'block_str_flag'	, width : 80, editable : false, align : "center", hidden:true},
     					{label:'STR'			, name : 'str_flag'		, index : 'str_flag'	, width : 80, editable : false, align : "center", hidden:true},
     					{label:'JOB_TYPE'		, name : 'usc_job_type'	, index : 'usc_job_type', width : 80, editable : false, align : "center"},
     					{label:'ACT ITEM'		, name : 'old_act_code'	, index : 'old_act_code', width : 100, editable : false, align : "center"},
     					{label:'MOVE ACT ITEM'  , name : 'act_code'		, index : 'act_code'	, width : 100, editable : false, align : "center"},
     					{label:'ACT CATA'   	, name : 'act_catalog'	, index : 'act_catalog'	, width : 100, editable : false, align : "center", hidden:true},     					
     					{label:'JOB ITEM'		, name : 'job_code'		, index : 'job_code'	, width : 100, editable : false, align : "center"},
     					{label:''   			, name : 'job_catalog'	, index : 'job_catalog'	, width : 100, editable : false, align : "center", hidden:true},
     					{label:'PROCESS'		, name : 'process'		, index : 'process'		, width : 100, editable : false, align : "center"},     					
     					{label:''		    	, name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true}
     				],
				gridview: true,
	             viewrecords: true,
	             autowidth: true,
	             cmTemplate: { title: false },
	             cellEdit : true,
	             cellsubmit : 'clientArray', // grid edit mode 2
				 scrollOffset : 17,
	             multiselect: true,
	             pgbuttons 	: false,
				 pgtext 	: false,
				 pginput 	: false,
	             height: 420,
	             pager: '#bottomJqGridMainList',
	             rowNum:999999, 
		         recordtext: '전체 {2}',
	        	 emptyrecords:'조회 내역 없음',
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow = rowid;
             	idCol = iCol;
             	kRow  = iRow;
             	kCol  = iCol;
   			 },
			 jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             onPaging: function(pgButton) {
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
   			 loadComplete: function (data) {
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        //datatype: 'local',
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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj.getRowData(rowid);
					afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	//grid resize
     	
     	var args = window.opener;
		var row_id = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');

		var jsonGridData = new Array();
		for(var i=0; i<row_id.length; i++) {		
			var item = args.jqGridObj.jqGrid( 'getRowData', row_id[i]);

			jsonGridData.push({representative_pro_num : item.representative_pro_num
				             , project_no : item.project_no
				             , block_no : item.block_no
				             , str_flag : item.str_flag
				             , usc_job_type : item.usc_job_type
				             , old_act_code : item.act_code
				             , job_code : item.job_code
				             , job_catalog : item.job_catalog
				             , oper : 'I'
				             });					
			
			if(i == 0) {
				$("#p_master_project_no").val(item.representative_pro_num);
			}
		}
		
		jqGridObj.clearGridData(true);
		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
		
		//grid resize
	    fn_gridresize( $(window), jqGridObj, 0 );
	    fn_gridresize( $(window), jqGridObj1, 0 );
		
		// BLOCK 선택
		var master_project_no = $("#p_master_project_no").val();
		var project_no = $("#p_project_no").val();
     	$.post( "infoJobCreateMoveBlock.do?p_project_no="+project_no, "", function( data ) {
     		for (var i in data ){
     			$("#p_block_no").append("<option value='"+data[i].block_no+"'>"+data[i].block_no+"</option>");
     		}
		}, "json" );
		
     	//Delete 버튼 클릭
		$("#btnDelete").click(function(){
			if($("#btnDelete").attr("value")=="DELETE") {
				var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				if(row_id == ""){
					alert("행을 선택하십시오.");
					return;
				}
				
				//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
				//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
				var row_len = row_id.length;					
				//I 인것들은 바로 없앰
				for(var i=0; i<row_len; i++){
					var item = jqGridObj.jqGrid( 'getRowData', row_id[0]);					
					jqGridObj.jqGrid('delRowData',row_id[0]);						
				}
				//I가 아닌 것들을 다시 row_id 구해서 'D' 값 처리
				row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				
				for(var i=0; i<row_id.length; i++){
					jqGridObj.jqGrid('delRowData',row_id[i]);
				}
				
				//전체 체크 해제
				jqGridObj.resetSelection();
			} else if($("#btnDelete").attr("value")=="BACK") {
				$("#btnAdd").removeAttr("disabled");
				
				$("#btnDelete").attr("value", "DELETE");
				$("#btnApply").attr("value", "NEXT");
				
				$("#p_block_no").attr("disabled", false);
				$("#p_str_flag").attr("disabled", false);
				$("#p_act_code").attr("disabled", false);

				$("#div1").show();
				$("#div2").hide();
				
				jqGridObj1.clearGridData(true);
			}
		});

		//btnNext 버튼 클릭 시
		$("#btnApply").click(function(){
			if($("#btnApply").attr("value")=="NEXT") {
				if(uniqeValidation()) {
					var row_id = $( "#jqGridMainList" ).getDataIDs();
					var blockNo = $("#p_block_no").val();
					var strFlag = $("#p_str_flag").val();
					var actCode = $("#p_act_code").val();
					
					$("#btnDelete").attr("value", "BACK");
					$("#btnApply").attr("value", "APPLY");
					
					$("#p_block_no").attr("disabled", true);
					$("#p_str_flag").attr("disabled", true);
					$("#p_act_code").attr("disabled", true);
					
					for(var i=0; i<row_id.length; i++) {						
						var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
						var project = item.project_no;
						var block_no = blockNo;
						var block_str_flag = strFlag;
						var str_flag = item.str_flag;
						var usc_job_type = item.usc_job_type;
						var old_act_code = item.old_act_code;
						var act_catalog = item.act_catalog;
						var act_code = actCode;
						var job_code = item.job_code;
						var job_catalog = item.job_catalog;
		
						var url = "jobCreateMoveCheck.do?project_no="+project+"&p_blockNo="+block_no+"&p_strFlag="+block_str_flag+"&p_block_str_flag="+str_flag+"&p_usc_job_type="+usc_job_type+
								  "&p_old_act_code="+old_act_code+"&p_act_catalog="+act_catalog+"&p_actCode="+act_code+"&p_job_code="+job_code+"&p_job_catalog="+job_catalog;
						var form = $('#application_form');
		
						getJsonAjaxFrom(url, form.serialize(), null, callback);										
					}
					$("#div1").hide();
					$("#div2").show();
				}				
			} else if($("#btnApply").attr("value")=="APPLY") {
				var fromList = $( "#jqGridMainList1" ).getDataIDs();
				var str = "OK";
				//변경된 체크 박스가 있는지 체크한다.
				for( var i = 0; i < fromList.length; i++ ) {
					var item = $( '#jqGridMainList1' ).jqGrid( 'getRowData', fromList[i] );
					if( item.process != 'OK' ) {
						str = item.process;
						break;
					}					
				}
				
				if(str != "OK") {
					alert(str);
					return;
				}			
				
				if(confirm("적용 하시겠습니까?")) {
					var args = window.opener;
					var jsonGridData = new Array();										

					for(var i=0; i<fromList.length; i++) {						
						var item = jqGridObj1.jqGrid( 'getRowData', fromList[i]);
						
						var blockNo = $("#p_block_no").val();
						var strFlag = $("#p_str_flag").val();
						
						jsonGridData.push({state_flag : 'C'
				              , representative_pro_num : item.representative_pro_num
				              , project_no : item.project_no
				              , block_no : blockNo
				              , block_str_flag : strFlag
				              , str_flag : item.str_flag
				              , usc_job_type : item.usc_job_type
				              , old_act_code : item.old_act_code
					          , act_code : item.act_code
					          , act_catalog : item.act_catalog
				              , job_code : item.job_code
				              , job_catalog : item.job_catalog
				              , dwgdeptnm : $("#p_dept_name").val()
				           	  , user_name : $("#p_user_name").val()
				              });
					}	

					args.jqGridObj.clearGridData(true);
					//args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
					for(var a=0; a<jsonGridData.length; a++) {	
						args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData[a], 'last');
					}
					
					self.close();
				}				
			}
		});
		
		//block No 값 변경 시
		$("#p_block_no").change(function(){
			setStrFlag();
		});
		
		//STR 선택 변경 시
		$("#p_str_flag").change(function(){
			setActCode();
		});
	});
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		printCheckSelectCnt();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		printCheckSelectCnt();
	}
	
	
	//체크 유무 validation
	var isChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".required").each(function(){
			if($(this).val() == "" || $(this).val() == undefined){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}
	
	function setStrFlag() {
		var project_no = $("#p_project_no").val();
		var master_project_no = $("#p_master_project_no").val();
		var blockCd = $("#p_block_no").val();
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});

		if(!(blockCd == "" || blockCd == undefined)){
			$.post( "infoJobCreateMoveStr.do?p_project_no="+project_no+"&p_block_no="+blockCd, "", function( data ) {
				$("#p_str_flag").children().remove();
				for (var i in data ){
	     			$("#p_str_flag").append("<option value='"+data[i].str_flag+"'>"+data[i].str_flag+"</option>");
	     		}
				setActCode();
			}, "json" );
		} else {
			$("#p_str_flag").children().remove();
			$("#p_act_code").children().remove();
		}
	}
	
	function setActCode() {
		var master_project_no = $("#p_master_project_no").val();
		var project_no = $("#p_project_no").val();
		var blockCd = $("#p_block_no").val();
		var strFlag = $("#p_str_flag").val();
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});

		if(!(blockCd == "" || blockCd == undefined) && !(strFlag == "" || strFlag == undefined)){
			$.post( "infoJobCreateMoveActCode.do?p_project_no="+project_no+"&p_block_no="+blockCd+"&p_str_flag="+strFlag, "", function( data ) {
				$("#p_act_code").children().remove();
				for (var i in data ){
	     			$("#p_act_code").append("<option value='"+data[i].act_catalog+"'>"+data[i].act_catalog+"</option>");
	     		}
			}, "json" );
		}
	}
	
	var callback = function(json){
		var jsonGridData = new Array();

		jsonGridData.push({representative_pro_num : json.p_master_project_no
			             , project_no : json.project_no
			             , block_no : json.p_blockNo
			             , block_str_flag : json.p_strFlag
			             , str_flag : json.p_block_str_flag
			             , usc_job_type : json.p_usc_job_type	
			             , old_act_code : json.p_old_act_code
			             , act_code : json.o_act_code
			             , act_catalog : json.p_actCode
			             , job_code : json.p_job_code
			             , job_catalog : json.p_job_catalog
			             , process : json.error_msg
			             , oper : 'S'
			             });			
		
		jqGridObj1.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
	}

</script>
</body>

</html>