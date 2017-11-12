<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PURCHASING - Delete</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<form id="application_form" name="application_form" >
		<input type="hidden" 	name="user_name" 		id="user_name"  	value="${loginUser.user_name}"		 	/>
		<input type="hidden" 	name="user_id" 			id="user_id"  		value="${loginUser.user_id}"		 	/>
		<input type="hidden" 	name="p_work_key"    	id="p_work_key" 	value="${p_work_key}"					/>
		<input type="hidden" 	name="p_ems_pur_no"    	id="p_ems_pur_no" 	value="${p_ems_pur_no}"					/>
		<input type="hidden" 	name="p_work_type"    	id="p_work_type" 	value="${p_work_type}"					/>
		<input type="hidden" 	name="p_master"    		id="p_master" 		value="${p_master}"						/>
		<input type="hidden" 	name="p_dwg_no"    		id="p_dwg_no" 		value="${p_dwg_no}"						/>
		<input type="hidden" 	name="p_dp_dept_code" 	id="p_dp_dept_code" value="${loginUser.dwg_dept_code}" 		/>
		
		
		<div id="hiddenArea"></div>
		
		<div id="mainDiv" class="mainDiv">
			<div class= "subtitle" style="width: 96.5%;">
			Purchasing Delete
			<jsp:include page="../../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>
					 
			<table class="searchArea conSearch">
				<col width="65%">
				<col width="*">
				<tr>
				<td class="sscType" style="border-right:none;"> 
					<span style="font-weight: bold;  font-size: 13px;">삭제사유</span>
					<input type="text" class="required" id="p_reason" name="p_reason" style="width:90%;" onChange="javascript:this.value=this.value.toUpperCase();" value="" alt='사유'/>
				</td>
				<td style="border-left:none;">
					<div class="button endbox">
							<input type="button" value="POS" 	id="btnPos"  	class="btn_blue2" 			/>
							<input type="button" value="APPLY" 	id="btnApply" 	class="btn_blue2"			/>
					</div>
				</td>						
				</tr>
			</table>
			<div class="content">
				<table id="jqGridPuchasingDeleteList"></table>
				<div id="btnJqGridPuchasingDeleteList"></div>
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
	var gridObj = $("#jqGridPuchasingDeleteList");
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
	
	function popUpPosCallBack(data){
		var split_data = data.p_callbackmsg.split(",");
		var file_id = split_data[0];
		var pos_rev = split_data[1];
		var yn_chk = split_data[2];
		
		var rows = gridObj.getDataIDs();
		for ( var i = 0; i < rows.length; i++ ) {
			gridObj.jqGrid( 'setCell', rows[i], 'pos', yn_chk);
			if(yn_chk == "N"){
				pos_rev = "&nbsp;";
				file_id = "&nbsp;";
			}
			gridObj.jqGrid( 'setCell', rows[i], 'pos_rev', pos_rev);
			gridObj.jqGrid( 'setCell', rows[i], 'file_id', file_id);
		}
	}
	
	function disableRow(jqGridObj,rowId,cellNameAry,disableClr){
		for(var i = 0; i < cellNameAry.length; i++){
			jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', 'not-editable-cell' );
			if(disableClr == undefined)jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', { color : 'black', background : '#dadada' } );
			
		}
	}
	
	$(document).ready(function(){
		gridObj.jqGrid({ 
			datatype: 'json', 
	        mtype: 'POST', 
	        url:'popUpPurchasingNewDeleteList.do',
	        postData : fn_getFormData('#application_form'),
	        colModel:[				
                		{label:'STATE' 				,name:'status' 		,index:'status' 		,width:40 ,align:'center', sortable:false},
						{label:'MASTER' 			,name:'master' 		,index:'master' 		,width:50 ,align:'center', sortable:false},
						{label:'PROJECT' 			,name:'project' 	,index:'project' 		,width:50 ,align:'center', sortable:false},
						{label:'DWG NO.' 			,name:'dwg_no' 		,index:'dwg_no' 		,width:60 ,align:'center', sortable:false},
						{label:'DWG DESCRIPTION' 	,name:'dwg_desc' 	,index:'dwg_desc' 		,width:200,align:'left'	 , sortable:false},
						{label:'ITEM CODE' 			,name:'item_code' 	,index:'item_code' 		,width:100,align:'center', sortable:false},
						{label:'ITEM DESCRIPTION' 	,name:'item_desc' 	,index:'item_desc' 		,width:200,align:'left'	 , sortable:false},
						{label:'EA' 				,name:'ea' 			,index:'ea' 			,width:20 ,align:'center', formatter:'integer', sortable:false},
						{label:'DP부서' 				,name:'dp_dept_name',index:'dp_dept_name' 	,width:130,align:'center', sortable:false},
						{label:'DP담당자' 			,name:'dp_user_name',index:'dp_user_name' 	,width:55 ,align:'center', sortable:false},
						{label:'DP담당자ID' 			,name:'dp_user_id' 	,index:'dp_user_id' 	,width:60 ,align:'center', sortable:false, hidden:true},
						{label:'실제작업자ID' 		,name:'create_user_id',index:'create_user_id',width:60,align:'center', sortable:false, hidden:true},
						{label:'결재자' 				,name:'approved_by' ,index:'approved_by' 	,width:40 ,align:'center', sortable:false},
						{label:'POS' 				,name:'pos' 		,index:'pos' 			,width:30 ,align:'center', sortable:false, title:false},
						{label:'POS_TYPE' 			,name:'pos_type' 	,index:'pos_type' 		,width:80 ,align:'center', sortable:false, hidden:true},
						{label:'PR_NO' 				,name:'pr_no' 		,index:'pr_no' 			,width:50 ,align:'center', sortable:false},
						{label:'SPEC' 				,name:'spec_state' 	,index:'spec_state' 	,width:30 ,align:'center', sortable:false},
						{label:'조달담당자' 			,name:'obtain_by' 	,index:'obtain_by' 		,width:60 ,align:'center', sortable:false},
						{label:'PO_NO' 				,name:'po_state' 	,index:'po_state' 		,width:50 ,align:'center', sortable:false},
						{label:'BOM_EA' 			,name:'bom_ea' 		,index:'bom_ea' 		,width:30 ,align:'center', sortable:false, hidden:true},
						{label:'EMS_EA' 			,name:'ems_ea' 		,index:'ems_ea' 		,width:30 ,align:'center', sortable:false, hidden:true},
						{label:'DATE' 				,name:'creation_date',index:'creation_date' ,width:50 ,align:'center', sortable:false,hidden:true},
						{label:'FILEID' 			,name:'file_id' 	,index:'file_id' 		,width:80 ,align:'center', sortable:false, hidden:true},
						{label:'POS_REV' 			,name:'pos_rev' 	,index:'pos_rev' 		,width:80 ,align:'center', sortable:false, hidden:true}
	                  ],
	        gridview: true,
	        toolbar: [false, "bottom"],
	        viewrecords: true,
	        autowidth: true,
	        scrollOffset : 0,
	        shrinkToFit:false,
	        pager: jQuery('#btnJqGridPuchasingDeleteList'),
	        rowList:[100,500,1000],
	        recordtext: '내용 {0} - {1}, 전체 {2}',
	        emptyrecords:'조회 내역 없음',
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
		   			else if(pgButton == 'next_btnJqGridPuchasingDeleteList'){
		   				pages = currentPageIndex+1;
		   			} 
		   			else if(pgButton == 'last_btnJqGridPuchasingDeleteList'){
		   				pages = lastPageX;
		   			}
		   			else if(pgButton == 'prev_btnJqGridPuchasingDeleteList'){
		   				pages = currentPageIndex-1;
		   			}
		   			else if(pgButton == 'first_btnJqGridPuchasingDeleteList'){
		   				pages = 1;
		   			}
		 	   		else if(pgButton == 'records') {
		   				rowNum = $('.ui-pg-selbox option:selected').val();                
		   			}
		   			$(this).jqGrid("clearGridData");
		   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
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
				var rows = gridObj.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var ary = ['status','master','project','dwg_no','dwg_desc','item_code','item_desc','ea','dp_dept_name','user_name','dp_user_id'
					           ,'dp_user_name','create_user_id','approved_by','pos','pos_type','pr_no','spec_state','obtain_by'
					           ,'po_state','bom_ea','ems_ea','creation_date','file_id','pos_rev'];
					disableRow($(this),rows[i],ary);
				}
			 }
     	});
		//jqGrid 크기 동적화
		resizeJqGridWidth( $(window), $( "#jqGridPuchasingDeleteList" ),undefined, 0.7);
		
		$("#btnPos").click(function(){
			var project = $("#p_master").val();
			var dwg_no = $("#p_dwg_no").val();
			
			if(dwg_no.length == 0){ alert("도면번호를 입력해주십시오."); return;}
			
			$.ajax({
		    	url:'<c:url value="emsNewPosChk.do"/>',
		    	type:'POST',
		    	async: false,
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : {"p_project_no" : project,
		    			"p_dwg_no" : dwg_no,
		    			"p_dept_code" : $("#p_dp_dept_code").val()
		    			},
		    	success : function(data){
		    		if(data == "null"){
		    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
		    			return;
		    		}
		    		var jsonData = JSON.parse(data);
		    		master = jsonData.project_no;
		    		
		    		var rev_cp = "";
		    		var rows = gridObj.getDataIDs();
		    		for(var i = 0; i < rows.length; i++) {
		    			var rev = gridObj.jqGrid('getRowData',rows[i]).pos_rev;
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
		    	},
		    	error : function(e){
		    		alert(e);
		    	}
			});
		});
		$("#btnApply").click(function(){
			var rows = gridObj.getDataIDs();
			var file_id = gridObj.jqGrid( 'getCell', rows[0], 'file_id');
			var pos_rev = gridObj.jqGrid( 'getCell', rows[0], 'pos_rev');
			if(file_id ==  "" || pos_rev == ""){
				alert("POS부터 등록하세요");
				return;
			}
			if(!uniqeValidation()) return;
			lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3'});
			$.ajax({
		    	url:'<c:url value="popUpEmsPurchasingNewDeleteApply.do"/>',
		    	type:'POST',
		    	async: false,
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data :  {
		    				"p_work_key" 	: $("#p_work_key").val(),
		    				"p_reason"		: $("#p_reason").val(),
		    				"p_file_id"		: file_id,
		    				"p_pos_rev"		: pos_rev,
		    				"p_user_id"		: $("#user_id").val()
		    			},
		    	success : function(data){
		    			if(data == "null"){
			    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
			    			return;
			    		}
		    			alert(data.resultMsg);
		    			lodingBox.remove();
						if ( data.result == 'success' ) {
							opener.$("#btnSearch").click();
							window.close();
						} else {
							lodingBox.remove();
						}
		    	}, 
		    	error : function(e){
		    		alert(e);
		    		lodingBox.remove();
		    	}
		    });
		});
	});
</script>
</body>
</html>