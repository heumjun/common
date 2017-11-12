<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PURCHASING - MODIFY</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
	.viewBtnGroup_off{
		display: none;
	}
	.viewBtnGroup_on{
		display: inline;
	}
</style>
</head>
<body>
	<form id="application_form" name="application_form" >
		<input type="hidden" 	name="user_name" 		id="user_name"  	value="${loginUser.user_name}"		 	/>
		<input type="hidden" 	name="user_id" 			id="user_id"  		value="${loginUser.user_id}"		 	/>
		<input type="hidden" 	name="p_dp_dept_code" 	id="p_dp_dept_code" value="${loginUser.dwg_dept_code}" 		/>
		<input type="hidden" 	name="p_ems_pur_no"    	id="p_ems_pur_no" 	value="${p_ems_pur_no}"					/>
		<input type="hidden" 	name="p_work_key"    	id="p_work_key" 	value="${p_work_key}"					/>
		<input type="hidden" 	name="p_work_flag"    	id="p_work_flag" 	value="${p_work_flag}"					/>
		
		<div id="hiddenArea"></div>
		
		<div id="mainDiv" class="mainDiv">
			<div class= "subtitle" style="width: 96.5%;">
			Purchasing Modify
			<jsp:include page="../../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>
					 
			<table class="searchArea conSearch">
				<col width="65%">
				<col width="*">
				<tr>
				<td class="sscType" style="border-right:none;"> 
					MASTER
					<input type="text" class="required"	id="p_master" name="p_master" style="width:70px; ime-mode:disabled;" onChange="javascript:this.value=this.value.toUpperCase();" value="${p_master }" alt='도면번호' disabled="disabled"/>
					&nbsp;
					DWG NO.
					<input type="text" class="required" id="p_dwg_no" name="p_dwg_no" style="width:70px; ime-mode:disabled;" onChange="javascript:this.value=this.value.toUpperCase();" value="${p_dwg_no }" alt='도면번호' disabled="disabled"/>
				</td>
				<td style="border-left:none;">
					<div class="button endbox">
							<input type="button" value="POS" 	id="btnPos"  	class="btn_blue2 viewBtnGroup_on" 			/>
							<input type="button" value="NEXT" 	id="btnNext" 	class="btn_blue2 viewBtnGroup_on" 			/>
							<input type="button" value="BACK" 	id="btnBack"  	class="btn_blue2 viewBtnGroup_off" 			/>
							<input type="button" value="APPLY" 	id="btnApply" 	class="btn_blue2 viewBtnGroup_off"			/>
					</div>
				</td>						
				</tr>
			</table>
			<div class="series"> 
				<table class="searchArea">
					<tr>
						<td>
							<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
						</td>
					</tr>
				</table>
			</div>
			<div class="content" id="first">
				<table id="jqGridPuchasingFristAddList"></table>
				<div id="btnJqGridPuchasingFristAddList"></div>
			</div>
			<div class="content" id="second">
				<table id="jqGridPuchasingSecondAddList"></table>
				<div id="btnJqGridPuchasingSecondAddList"></div>
			</div>
		</div>
	</form>
<script type="text/javascript" >
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var lastSelection;
	var asteric = false;
	var firstGrid = $("#jqGridPuchasingFristAddList");
	var secondGrid = $("#jqGridPuchasingSecondAddList");
	var resultData = [];
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".required").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}
	
	function btnViewChanger(){
		$(".button.endbox").find("[class*=viewBtnGroup_]").each(function(index){
			if($(this).attr("class").indexOf("viewBtnGroup_on") > 0){
				$(this).removeClass("viewBtnGroup_on");
				$(this).addClass("btn_disable").attr("disabled",true);
				$(this).addClass("viewBtnGroup_off");
			} else {
				$(this).removeClass("viewBtnGroup_off");
				$(this).removeClass("btn_disable").attr("disabled",false);
				$(this).addClass("viewBtnGroup_on");
			}
		});
	}
	
	function disableRow(jqGridObj,rowId,cellNameAry,disableClr){
		for(var i = 0; i < cellNameAry.length; i++){
			jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', 'not-editable-cell' );
			if(disableClr == undefined)jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', { color : 'black', background : '#dadada' } );
			
		}
	}
	
	function popUpPosCallBack(data){
		var chk_ids = firstGrid.jqGrid('getGridParam','selarrrow');
		var split_data = data.p_callbackmsg.split(",");
		var file_id = split_data[0];
		var pos_rev = split_data[1];
		var yn_chk = split_data[2];
		
		for(var i=0; i < chk_ids.length; i++){
			firstGrid.jqGrid( 'setCell', chk_ids[i], 'pos', yn_chk);
			if(yn_chk == "N"){
				pos_rev = "&nbsp;";
				file_id = "&nbsp;";
			}
			firstGrid.jqGrid( 'setCell', chk_ids[i], 'pos_rev', pos_rev);
			firstGrid.jqGrid( 'setCell', chk_ids[i], 'file_id', file_id);
		}
	}
	
	function getChkedChmResultData(gridObj,callback) {
		var chk_ids = gridObj.jqGrid('getGridParam','selarrrow');
		var changedData = [];
		for(var i = 0; i< chk_ids.length; i++){
			changedData.push(gridObj.jqGrid('getRowData',chk_ids[i]));
		}
		callback.apply(this, [ changedData.concat(resultData) ]);
	}
	
	function getChmResultData(gridObj,callback) {
		var changedData = $.grep(gridObj.jqGrid('getRowData'),
				function(obj) {
					return true;
				});
		callback.apply(this, [ changedData.concat(resultData) ]);
	}
	
	$(document).ready(function(){
		firstGrid.jqGrid({ 
			datatype: 'json', 
	        mtype: 'POST', 
	        url:'popUpPurchasingNewModifyFirstList.do',
	        postData : fn_getFormData('#application_form'),
	        colModel:[				
	                  				{label:'PROJECT', 			name:'project', 	index:'project', 	width:50, 	align:'center', sortable:false, title:false},
	                				{label:'DWG No.', 			name:'dwg_no', 		index:'dwg_no', 	width:60, 	align:'center', sortable:false, title:false},
	                				{label:'ITEM CODE',			name:'item_code', 	index:'item_code', 	width:85, 	align:'center', sortable:false, title:false},
	                				{label:'ITEM DESCRIPTION',	name:'item_desc', 	index:'item_desc', 	width:240, 	align:'left', 	sortable:false,	title:false},
	                				{label:'EA',				name:'ea', 			index:'ea', 		width:30, 	align:'center', sortable:false,	title:false},
	                				{label:'EA',				name:'modi_ea', 	index:'modi_ea',	width:30, 	align:'center', sortable:false, title:false,    editable:true, eidttype:'text',		formatter:'integer'},
	                				{label:'POS',				name:'pos', 		index:'pos', 		width:40, 	align:'center', sortable:false,	title:false},
	                				{label:'FILE_ID',			name:'file_id', 	index:'file_id',	width:50,	align:'center', sortable:false,	title:false,	hidden:true},
	                				{label:'POS_REV',			name:'pos_rev', 	index:'pos_rev',	width:50,	align:'center', sortable:false,	title:false,	hidden:true},
	                				{label:'PUR_NO', 			name:'ems_pur_no', 	index:'ems_pur_no',	width:50, 	align:'center', sortable:false, title:false,	hidden:true}
	                  ],
	        gridview: true,
	        toolbar: [false, "bottom"],
	        viewrecords: true,
	        autowidth: true,
	        scrollOffset : 0,
	        shrinkToFit:true,
	        pager: jQuery('#btnJqGridPuchasingFristAddList'),
	        rowList:[100,500,1000],
	        recordtext: '내용 {0} - {1}, 전체 {2}',
	        emptyrecords:'조회 내역 없음',
	        multiselect: true,
	        cellEdit : true,
	        cellsubmit : 'clientArray', // grid edit mode 2
	        rowNum:100, 
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	        	idRow=rowid;
	        	idCol=iCol;
	        	kRow = iRow;
	        	kCol = iCol;
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
		    	
	        		var pageIndex         = parseInt($(".ui-pg-input").val());
		   			var currentPageIndex  = parseInt($("#jqGridPurchasingList").getGridParam("page"));// 페이지 인덱스
		   			var lastPageX         = parseInt($("#jqGridPurchasingList").getGridParam("lastpage"));  
		   			var pages = 1;
		   			var rowNum 			  = 100;	   			
		   			if (pgButton == "user") {
		   				if (pageIndex > lastPageX) {
		   			    	pages = lastPageX
		   			    } else pages = pageIndex;
		   			}
		   			else if(pgButton == 'next_btnJqGridPuchasingFristAddList'){
		   				pages = currentPageIndex+1;
		   			} 
		   			else if(pgButton == 'last_btnJqGridPuchasingFristAddList'){
		   				pages = lastPageX;
		   			}
		   			else if(pgButton == 'prev_btnJqGridPuchasingFristAddList'){
		   				pages = currentPageIndex-1;
		   			}
		   			else if(pgButton == 'first_btnJqGridPuchasingFristAddList'){
		   				pages = 1;
		   			}
		 	   		else if(pgButton == 'records') {
		   				rowNum = $('.ui-pg-selbox option:selected').val();                
		   			}
		   			$(this).jqGrid("clearGridData");
		   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
			 },		
			 afterEditCell: function(id,name,val,iRow,iCol){
				  //Modify event handler to save on blur.
				  $("#"+iRow+"_"+name).bind('blur',function(){
					$('#jqGridPuchasingFristAddList').saveCell(iRow,iCol);
				  });
			 },
			 loadComplete: function (data) {
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    $this.jqGrid('setGridParam', {
				        datatype: 'local',
				        data: data.rows,
				        pageServer: data.page,
				        recordsServer: data.records,
				        lastpageServer: data.total
				    });
				
				    this.refreshIndex();
				
				    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
				for ( var i = 0; i < rows.length; i++ ) {
					var ary = ['project','master','dwg_no','item_code','item_desc','ea','pos'];
					disableRow($(this),rows[i],ary);
					
					$(this).jqGrid( 'setCell', rows[i], 'modi_ea', '', { color : 'black', background : '#FFFFCC' } );
				}
			 }
     	});
		//jqGrid 크기 동적화
		resizeJqGridWidth( $(window), $( "#jqGridPuchasingFristAddList" ),undefined, 0.7);
		
		secondGrid.jqGrid({ 
			datatype: 'json', 
	        mtype: 'POST', 
	        url:'',
	        postData : fn_getFormData('#application_form'),
	        colModel:[				
									{label:'STATE', 			name:'status', 		index:'status',		width:50, 	align:'center', sortable:false, title:false},
	                  				{label:'PROJECT', 			name:'project', 	index:'project', 	width:50, 	align:'center', sortable:false, title:false},
	                				{label:'DWG No.', 			name:'dwg_no', 		index:'dwg_no', 	width:60, 	align:'center', sortable:false, title:false},
	                				{label:'ITEM CODE',			name:'item_code', 	index:'item_code', 	width:85, 	align:'center', sortable:false, title:false},
	                				{label:'ITEM DESCRIPTION',	name:'item_desc', 	index:'item_desc', 	width:240, 	align:'left', 	sortable:false,	title:false},
	                				{label:'EA',				name:'ea', 			index:'ea', 		width:30, 	align:'center', sortable:false,	title:false},
	                				{label:'POS',				name:'pos', 		index:'pos', 		width:40, 	align:'center', sortable:false,	title:false},
	                				{label:'FILE_ID',			name:'file_id', 	index:'file_id',	width:50,	align:'center', sortable:false,	title:false,	hidden:true},
	                				{label:'POS_REV',			name:'pos_rev', 	index:'pos_rev',	width:50,	align:'center', sortable:false,	title:false,	hidden:true},
	                				{label:'PUR_NO', 			name:'ems_pur_no', 	index:'ems_pur_no',	width:50, 	align:'center', sortable:false, title:false,	hidden:true}
	                  ],
	        gridview: true,
	        toolbar: [false, "bottom"],
	        viewrecords: true,
	        autowidth: true,
	        scrollOffset : 0,
	        shrinkToFit:true,
	        pager: jQuery('#btnJqGridPuchasingSecondAddList'),
	        rowList:[100,500,1000],
	        recordtext: '내용 {0} - {1}, 전체 {2}',
	        emptyrecords:'조회 내역 없음',
	        multiselect: false,
	        rowNum:100, 
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	        	idRow=rowid;
	        	idCol=iCol;
	        	kRow = iRow;
	        	kCol = iCol;
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
		    	
        		var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt($("#jqGridPurchasingList").getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt($("#jqGridPurchasingList").getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnJqGridPuchasingSecondAddList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnJqGridPuchasingSecondAddList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnJqGridPuchasingSecondAddList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnJqGridPuchasingSecondAddList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
			 },		
			 afterEditCell: function(id,name,val,iRow,iCol){
				  //Modify event handler to save on blur.
				  $("#"+iRow+"_"+name).bind('blur',function(){
					$('#secondGrid').saveCell(iRow,iCol);
				  });
			 },
			 loadComplete: function (data) {
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    $this.jqGrid('setGridParam', {
				        datatype: 'local',
				        data: data.rows,
				        pageServer: data.page,
				        recordsServer: data.records,
				        lastpageServer: data.total
				    });
				
				    this.refreshIndex();
				
				    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
				for ( var i = 0; i < rows.length; i++ ) {
					var ary = ['status','project','dwg_no','dwg_desc','item_code','item_desc','item_desc','ea',
					           'location_no','stage_no','supply_type','pos','pos_rev'];
					disableRow($(this),rows[i],ary);
					if($(this).jqGrid('getCell',rows[i],'pos_rev') != "")$(this).jqGrid( 'setCell', rows[i], 'pos', 'Y');
				}
			 }
     	});
		//jqGrid 크기 동적화
		resizeJqGridWidth( $(window), $( "#jqGridPuchasingSecondAddList" ),undefined, 0.7);
		$("#second").hide();
		
		$("#btnNext").click(function(){
			var chk_ids = firstGrid.jqGrid('getGridParam','selarrrow');
			if(chk_ids.length <= 0){
				alert("선택된 항목이 없습니다.");
				return;
			}
			var rev_cp = "";
			for(var i =0; i < chk_ids.length; i++){
				var rowData = firstGrid.getRowData(chk_ids[i]);
				var rev = rowData.pos_rev;
				if(rowData.modi_ea 			== 	""	){ alert("수량이 없습니다."); 			return; }
				if(rowData.modi_ea 			==	"0"	){ alert("수량이 0이 될 수 없습니다.");	return; }
				if(rowData.pos 				== 	"N"	){ alert("POS부터 업로드 하십시오.");	return; }
				if(rowData.modi_ea			== 	rowData.ea	){ alert("수정 수량이 원래 수량과 같을 수 없습니다.");	return; }
				if(rev_cp == "") rev_cp = rev;
				else {
					if(rev_cp != rev){
						alert("선택한 DATA간 상이한 POS가 포함되어 다음 작업이 불가합니다.");
						return;
					}
				}
			}
			
			firstGrid.saveCell(kRow, idCol);
			var chmResultRows = [];
			
			getChkedChmResultData(firstGrid,function(data) {
				btnViewChanger();
				$("#first").hide();
				$("#second").show();

				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify(chmResultRows) };
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend({}, dataList, formData);
				
				lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3'});
				var sUrl = "popUpPurchasingNewModifyChk.do";
				$.post(sUrl, parameters, function(data){
					if(data == "null"){
		    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
		    			return;
		    		}

		    		if(data.p_result_flag != "S"){
		    			alert("ERROR : "+data.p_result_msg);
		    			$("#btnBack").click();
		    			return;
		    		}
		    		
		    		sUrl = "popUpPurchasingNewModifySecondList.do";
					
					secondGrid.jqGrid( "clearGridData" );
					secondGrid.jqGrid( 'setGridParam', {
						url : sUrl,
						mtype : 'POST',
						datatype : 'json',
						page : 1,
						postData : formData
					} ).trigger( "reloadGrid" );
					//검색 시 스크롤 깨짐현상 해결
					secondGrid.closest(".ui-jqgrid-bdiv").scrollLeft(0);
					
				}, "json").error(function() {
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				}).always(function() {
					lodingBox.remove();
				});
				
			});
		});
		
		$("#btnPos").click(function(){
			var chk_ids = firstGrid.jqGrid('getGridParam','selarrrow');
			if(chk_ids.length <= 0){
				alert("선택된 항목이 없습니다.");
				return;
			}
			var master = $("#p_master").val();
			var dwg_no = $("#p_dwg_no").val();
			
			if(dwg_no.length == 0){ alert("도면번호를 입력해주십시오."); return;}
			
			var rev_cp = "";
    		for(var i = 0; i < chk_ids.length; i++) {
    			var rev = firstGrid.jqGrid('getRowData',chk_ids[i]).pos_rev;
    			if(rev_cp == "") rev_cp = rev;
				else {
					if(rev_cp != rev){
						alert("선택한 DATA는 상이한 POS가 포함되어 POS 작업이 불가합니다.");
						return;
					}
				}
    		}
    		
    		var url = "popUpPurchasingNewPos.do?p_master="+master+"&p_dwg_no="+dwg_no+"&p_callback=Y&p_ems_pur_no="+"&p_pos_rev="+rev_cp;
    		var nwidth = 1050;
    		var nheight = 800;
    		var LeftPosition = (screen.availWidth-nwidth)/2;
    		var TopPosition = (screen.availHeight-nheight)/2;

    		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

    		window.open(url,"",sProperties).focus();
			
		});
		$("#btnBack").click(function(){
			btnViewChanger();
			$("#second").hide();
			$("#first").show();
		});
		
		$("#btnApply").click(function(){
			secondGrid.saveCell(kRow, idCol);
			var chmResultRows = [];
			
			getChmResultData(secondGrid,function(data) {
				lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3'});
				
				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify(chmResultRows) };
				
				var url = 'popUpEmsPurchasingNewModifyApply.do';
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend({}, dataList, formData);
				
				$.post(url, parameters, function(data){
					alert(data.resultMsg);
					if ( data.result == 'success' ) {
						opener.$("#btnSearch").click();
						window.close();
					}
				}, "json").error(function() {
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				}).always(function() {
					lodingBox.remove();
				});
			});
		});
	});
</script>
</body>
</html>