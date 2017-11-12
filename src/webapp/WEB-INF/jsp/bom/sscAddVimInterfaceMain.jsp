<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DIS SSC Add Vim Interface Main</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>    
	.subheader {margin:10px; height:70px; width:1200px; }
	.subheader .searchArea {position:relative; float:left; margin:0;}
	.subheader .searchArea .searchDetail{position:relative; padding:3px 0 0 0; float:left; height:25px; margin:0 10px 4px 0px; font-weight:bold;}
	.subheader .searchArea .commonInput{width:60px; text-transform: uppercase;}
	.subheader .searchArea .disableinput{width:60px; background-color:#dedede;}
	.subheader .searchArea .uniqInput {width:60px; background-color:#FFE0C0;}	
	.subheader .searchArea .userInputArea {position:relative; float:left; height:25px; padding:3px 5px 0 5px; margin:0 10px 4px 0px; font-weight:bold; border:1px solid #ccc; background-color:#FFE0C0; clear:both; }
	.subheader .searchArea .totalEaArea {position:relative; float:left; height:25px; padding:3px 5px 0 5px; margin:0 10px 4px 0px; font-weight:bold; border:1px solid #ccc; background-color:#D7E4BC; }
	.userInput {text-transform: uppercase;}
	.subheader .buttonArea{position:relative; float:right; width:180px; height:60px; padding-top:3px; line-height:2.5;}	
	.subheader .buttonArea input {width:80px;}	
	.subheader .buttonArea .selRev{float:left; width:60px; }
	.jqGridArea {margin:10px;}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subheader">
			<input type="hidden" name="p_daoName" value="" />
			<input type="hidden" name="p_queryType" value="" />
			<input type="hidden" name="p_process" value="" />
			<input type="hidden" name="p_dwg_no" value="<c:out value="${p_dwgno}"/>" />
			<input type="hidden" name="p_item_type_cd" value="<c:out value="${p_item_type_cd}"/>" />
			
			<div class="searchArea">		
				<div class="searchDetail">
					Master <input type="text" name="p_master" class="uniqInput commonInput" style="width:45px;" alt="Project" value="<c:out value="${p_master_no}" />"/>
				</div>
				<div class="searchDetail">
					Project <input type="text" name="p_project_no" class="commonInput" style="width:35px;" value="" />
				</div>
				<div class="searchDetail">
					Item Code <input type="text" name="p_item_code" class="commonInput" style="width:35px;" value="" />
				</div>
				<div class="searchDetail">
					Block <input type="text" name="p_dwg_no" class="userInput" alt="DWG No" value="<c:out value="${p_dwg_no}" />" />
					Stage <input type="text" name="p_dept" class="disableinput" readonly="readonly" style="width:70px;" value="<c:out value="${loginUser.dept_name}" />" />
					STR <input type="text" name="p_user" class="disableinput" readonly="readonly" style="width:55px;" value="<c:out value="${loginUser.user_name}" />" />
				</div>
			</div>
			<div class="buttonArea">
				<input type="button" class="btn_blue" value="Search" id="btnSearch" />
				<input type="button" class="btn_blue" value="Transfer" id="btnTransfer" />
				<input type="button" class="btn_blue" value="Close" id="btnClose"/>
			</div>
		</div>	
		<div class="jqGridArea">
			<table id="jqGridAddTribonMainList"></table>
			<div id="bottomJqGridAddTribonMainList"></div>
		</div>
		<!-- loadingbox -->
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" src="/js/getGridColModel${p_item_type_cd}.js" charset='utf-8'></script>
<script type="text/javascript" >
	
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	
	var jqGridObj = $("#jqGridAddTribonMainList");
	
	var vItemTypeCd = $("input[name=p_item_type_cd]").val();
		
	$(document).ready(function(){
		
		
		///js/getGridColModel.js에서 그리드의 colomn을 받아온다.
		var gridColModel = getTribonGridColModel();
		
		
		//그리드 설정 
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'sscAddTribonMainList.do',
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
            pager: '#bottomJqGridAddTribonMainList',
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
			$(".uniqInput").each(function(){
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
			
			$(".userInput").each(function(){
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
				arrChkedData.push(jqGridObj.jqGrid("getRowData", chkedRowId[i]).cad_sub_id);
			}
			
			var formData = $('#application_form');
			var args = window.dialogArguments;	
			var item_type_cd = $("input[name=p_item_type_cd]").val();
			
			getJsonAjaxFrom("sscAddTribonTransferList.do?p_cad_sub_id="+arrChkedData, formData.serialize(), null, callback);
			
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
	//STR AutoComplete 셋팅
	var onFocusStr = function(){
	
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		//필수 파라미터 S
		$("input[name=p_daoName]").val("TBC_COMMONDAO");
		$("input[name=p_queryType]").val("select");
		$("input[name=p_process]").val("getAutoCompleteStr");
		//필수 파라미터 E
		
		getAjaxTextPost(null, "/ematrix/tbcCommonGetAutoCompleteList.tbc", form.serialize(), getStrCallback);
	}
		
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
		
		args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), json, 'first' );
		
		//모든 행 job code 세팅
		args.setAllJobCode();
		
		//모든 행 필수 입력 값 조정 세팅
		args.setAllEditColumn();
		
		
// 		args.totalEaAction();
// 		args.$("input[name=p_block]").each(function(){
// 			args.inputBlockKeyIn(this, "block");
// 		});
		
		
 		self.close();
		
	}
	
	var clickSearch = function(){
		$("#btnSearch").click();
	}
	

	function fn_search() {
		var sUrl = "sscAddTribonMainList.do";
		
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}
	
	
</script>
</body>

</html>