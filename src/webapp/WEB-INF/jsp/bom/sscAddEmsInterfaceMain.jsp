<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC Add EMS Interface Main</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<!-- <style>    
	.subheader {margin:10px; height:60px; width:100%;}
	.subheader .searchArea {position:relative; float:left; margin:0;}
	
	.button input {width:80px;}	
	.subheader .buttonArea .selRev{float:left; width:60px; }
	.jqGridArea {margin:10px;}
	.userInput{background-color: #FFE0C0}
</style> -->

<style>
	.totalEaArea {position:relative; margin-right:40px; padding:4px 0 6px 2px; font-weight:bold; border:1px solid #ccc; background-color:#D7E4BC; vertical-align:middle; }	
	
	/*.itemInput {text-transform: uppercase;} */
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
	.header .searchArea .buttonArea #btnForm{float:left;}
	.required_cell{background-color:#F7FC96}	
	.conSearch .userInput {
		background-color: #FFFFA2;
		font-family: '돋움';
		text-transform: uppercase;
	}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			SSC EMS Interface Main			
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_daoName" value="" />
		<input type="hidden" name="p_queryType" value="" />
		<input type="hidden" name="p_process" value="" />
		<input type="hidden" name="p_master_no" value="${p_master_no}" />
		<input type="hidden" name="p_item_type_cd" value="${p_item_type_cd}" />		
		<input type="hidden" name="totalCnt" value="" />		
		
			
		<table class="searchArea conSearch">
			<col width="60"/>
			<col width="70"/>
			<col width="60"/>
			<col width="80"/>
			<col width="70"/>
			<col width="150"/>
			<col width="70"/>
			<col width="170"/>
			<col width="40"/>
			<col width="70"/>
			<col width="*"/>
			<tr>
				<th>PROJECT </th>
				<td><input type="text" name="p_project_no" class="required commonInput" readonly="readonly" style="width:45px;" alt="Project" value="<c:out value="${p_project_no}" />"/></td>
				<th>DWG NO. </Th>
				<td><input type="text" name="p_dwg_no" class="required commonInput" readonly="readonly" style="width:60px;" alt="DWG No" value="<c:out value="${p_dwg_no}" />" /></td>
				<th>ITEM CODE </th>
				<td><input type="text" name="p_item_code" class="commonInput" style="width:130px;" alt="Item Code" value=""/></td>
				<th>Description</th>
				<td>
					<input type="text" name="p_item_desc" class="commonInput" style="width:150px;" alt="Description" value=""/>
				</td>
				<th>EA </th>
				<td>
					<select name="p_ea">
						<option value="ALL">ALL</option>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</td>
				<!-- <th>BLOCK</th>
				<td><input type="text" name="p_keyin_block_no" class="userInput userRequiredInput" style="width:40px;" value="" alt="Block" /></td>
				<th>STAGE</th>
				<td><input type="text" name="p_keyin_stage_no" class="userInput" alt="Stage" style="width:40px;" value="" /></td>
				<th>STR</th>
				<td><input type="text" name="p_keyin_str_flag" class="userInput userRequiredInput" alt="STR" style="width:40px;" value="" /></td>
				<th>TYPE</th>
				<td><input type="text" name="p_keyin_usc_job_type" class="userInput userRequiredInput" alt="Type" style="width:40px;" value="" /></td> -->
				<!-- <td class="bdl_no"  style="border-left:none;" colspan="3">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="Transfer" id="btnTransfer" />
					</div>	
				</td> -->
				<td class="bdl_no"  style="border-left:none;" colspan="15">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch" style="width: 80px;" />
						<!-- <input type="button" class="btn_blue2" value="Close" id="btnClose"/> -->
					</div>	
				</td>
			</tr>
		</table>
		<table class="searchArea2 conSearch">
		<col width="60"/>
		<col width="70"/>
		<col width="60"/>
		<col width="80"/>
		<col width="50"/>
		<col width="60"/>
		<col width="50"/>
		<col width="60"/>
		<col width="*"/>
		<tr>
			<th>BLOCK</th>
			<td><input type="text" name="p_keyin_block_no" class="userInput userRequiredInput" style="width:40px;" value="" alt="Block" /></td>
			<th>STAGE</th>
			<td><input type="text" name="p_keyin_stage_no" class="commonInput" alt="Stage" style="width:60px;" value="" /></td>
			<th>STR</th>
			<td><input type="text" name="p_keyin_str_flag" class="userInput userRequiredInput" alt="STR" style="width:40px;" value="" /></td>
			<th>TYPE</th>
			<td><input type="text" name="p_keyin_usc_job_type" class="commonInput" alt="Type" style="width:40px;" value="" /></td>
			<td  colspan="15">
				<div class="button endbox">
					<input type="button" class="btn_blue2" value="TRANSFER" id="btnTransfer" style="width: 80px;" />
				</div>
			</td>
		</tr>
		</table>
		<%-- <table class="searchArea2">
			
			<col width="*"/>	
			<tr>
				
			</tr>
		</table> --%>

		<div class="content">
			<table id="jqGridAddEmsMainList"></table>
			<div id="bottomJqGridAddEmsMainList"></div>
		</div>
		<!-- loadingbox -->
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>

<script type="text/javascript" >
	
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	
	var jqGridObj = $("#jqGridAddEmsMainList");
	
	var vItemTypeCd = $("input[name=p_item_type_cd]").val();
		
	$(document).ready(function(){
		

		//그리드 헤더 설정
		var gridColModel = new Array();
		gridColModel.push({label:'ems_pur_no', name:'ems_pur_no', width:60, align:'center', sortable:true, title:false, hidden:true} );
		gridColModel.push({label:'CNT', name:'cnt', width:60, align:'center', sortable:true, title:false, hidden:true} );
		gridColModel.push({label:'Master', name:'master', width:60, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'Project', name:'project', width:60, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'Dwg No', name:'dwg_no', width:80, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'Sub DWG No.', name:'sub_dwg_no', width:80, align:'center', sortable:true, title:false, editable:true, hidden:true} );
		gridColModel.push({label:'DWG Description', name:'dwg_desc', width:160, align:'center', sortable:true, title:true, editable:true} );
		gridColModel.push({label:'Item Code', name:'item_code', width:100, align:'center', sortable:true, title:true, editable:true} );
		gridColModel.push({label:'Description', name:'item_desc', width:300, align:'left', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'EA', name:'ea', width:60, align:'center', sortable:true, title:false, editable:true, formatter: eaFormatter} );
		gridColModel.push({label:'PR No.', name:'pr_no', width:80, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'PO No.', name:'po_no', width:80, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'SSC_EA', name:'ssc_ea', width:60, align:'center', sortable:true, title:false, editable:true, hidden:true } );
		
		//그리드 설정 
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'sscAddEmsMainList.do',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            mtype : 'POST',
            gridview: true,
            viewrecords: true,
            rownumbers:false,
            autowidth: true,
            cellEdit : false,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit : false,
            height: 500,
            pager: '#bottomJqGridAddEmsMainList',
            rowList:[100,500,1000],
	        rowNum:100, 
	        recordtext: '내용 {0} - {1}, 전체 {2}',
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
				
				var rows = $(this).getDataIDs();
				var item = jqGridObj.jqGrid( 'getRowData', rows[0] );
				
				$("#totalCnt").val(item.cnt);
				
			},		
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window),jqGridObj );
		
		
		//Search 클릭
		$("#btnSearch").click(function(){
			var rtn = true;
			$(".required").each(function(){
				if($(this).val() == ""){
					alert($(this).attr("alt")+"를 입력하십시오.");
					rtn = false;
					return false;
				}
			});
			
			if(!rtn){
				return false;
			}
			
			//모두 대문자로 변환
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			//모두 대문자로 변환
			$(".userInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			fn_search();
			
// 			form = $('#application_form');
// 			var item_type_cd = $("input[name=p_item_type_cd]").val();

// 			//필수 파라미터 S	
// 			$("input[name=p_daoName]").val("TBC_"+item_type_cd+"_ITEMADD");
// 			$("input[name=p_queryType]").val("select");
// 			$("input[name=p_process]").val("ManagerInputList");						
// 			//필수 파라미터 E	
// 			getAjaxHtmlPost($("#ContentArea"),"/ematrix/tbcItemAddManagerBody.tbc",form.serialize(),$("#loadingBar"));
		});
		//진입시 Search;
		$("#btnSearch").click();
		
		//Trasfer 버튼 클릭
		$("#btnTransfer").click(function(){
			
			var rtn = true;
			$("input[name=p_chkItem]:checked").each(function(){
				var isRequiredTxt = $(this).parent().parent().find(".isRequired");
				if($(isRequiredTxt).attr("alt") != undefined && $(isRequiredTxt).text() == ""){
					alert("항목["+$(isRequiredTxt).attr("alt")+"]이 누락되었습니다." );
					rtn = false;
					return false;
				}
			});
			
			if(!rtn){
				return false;
			}
			
			$(".userRequiredInput").each(function(){
				if($(this).val() == ""){
					alert("입력 항목["+$(this).attr("alt")+"]이 누락되었습니다." );
					$(this).focus();
					rtn = false;
					return false;
				}
			});
			
			if(!rtn){
				return false;
			}
			
			//모두 대문자로 변환
			$(".commonInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			//모두 대문자로 변환
			$(".userInput").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			
			var chkedRowId = jqGridObj.jqGrid('getGridParam', 'selarrrow');
            
			if(chkedRowId.length == 0){	//Check Validation
				alert("Item을 체크하십시오.");
				return false;
				
			}
			
			var arrChkedData = new Array();
			
			for(var i=0; i<chkedRowId.length; i++){
				arrChkedData.push(jqGridObj.jqGrid("getRowData", chkedRowId[i]).ems_pur_no);
			}
			
			var formData = $('#application_form');
			
			getJsonAjaxFrom("sscAddEmsTransferList.do?p_ems_pur_no="+arrChkedData, formData.serialize(), null, callback);
			
		});
		
		//Close 버튼 클릭
		$("#btnClose").click(function(){
			self.close();
		});
		
		
		//Delete 클릭
		$("#btnDelete").click(function(index){

			if(isItemChecked()){	//Check Validation
				if(confirm('Delete the selected item?')){	//Delete 확인
					var item_type_cd = $("input[name=p_item_type_cd]").val();

					//필수 파라미터 S	
					$("input[name=p_daoName]").val("TBC_"+item_type_cd+"_ITEMADD");
					$("input[name=p_queryType]").val("delete");
					$("input[name=p_process]").val("AddInputDelete");
					//필수 파라미터 E	
					form = $('#application_form');					
					$.post("/ematrix/tbcItemAddMainDelete.tbc",form.serialize(),function(json)
					{	
						afterDBTran(json);
						$("#btnSearch").click();
					},"json");
				}
			}
		});
		
	});
		
	//STR 받아온 후 AutoComplete
	var getStrCallback = function(txt){
		var arr_txt = txt.split("|");
	    $("input[name=p_str]").autocomplete({
			source: arr_txt,
			minLength:1,
			matchContains: true, 
			max: 3,
			autoFocus: true,
			selectFirst: true
		});
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		chkItemClickEaAction();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		chkItemClickEaAction();
	}
	//Total EA 출력
	var chkItemClickEaAction = function(){
		var totalEa = 0;
		$("input[name=p_chkItem]:checked").each(function(){
			totalEa += Number($(this).parent().parent().find(".td_ea").text());
		});
		$("#totalEa").val(totalEa);
	}
	
	//메시지 Call
	var afterDBTran = function(json)
	{
	 	var msg = "";
		for(var keys in json)
		{
			for(var key in json[keys])
			{
				if(key=='Result_Msg')
				{
					msg=json[keys][key];
				}
			}
		}
		alert(msg);
		
	}
	
	//Header 체크 유무 validation
	var isItemChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}
	
	//CallBack Next 이후 버튼 상태 변경
	var callback = function(json){
		
		var args = window.dialogArguments;
		
		args.jqGridObj.jqGrid("clearGridData");
		//alert(JSON.stringify(json));
		args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), json, 'first' );
		$("#totalEa").val($("#totalCnt").val());
		
		//모든 행 job code 세팅
		//args.setAllJobCode();
		
		//모든 행 필수 입력 값 조정 세팅
		args.setAllEditColumn();
		
 		args.totalEaAction();
 		
// 		args.$("input[name=p_block]").each(function(){
// 			args.inputBlockKeyIn(this, "block");
// 		});
		
		
 		self.close();
		
	}
	
	var clickSearch = function(){
		$("#btnSearch").click();
	}
	

	function fn_search() {
		var sUrl = "sscAddEmsMainList.do";
		
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}
	
	function eaFormatter(cellvalue, options, rowObject ) {
		if(cellvalue == null) {
			return '';
		} else {
			return rowObject.ssc_ea + "/"+cellvalue+"";
		}
	}
	
	
</script>
</body>

</html>