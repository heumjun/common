<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>dwgMailReceiver</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div>
	<form id="application_form" name="application_form">
	<input type="hidden" name="pageYn" id="pageYn" value="N" />
	<input type="hidden" name="h_ShipNo" id="h_ShipNo" />
	<input type="hidden" name="h_DwgNo" id="h_DwgNo" />
	<input type="hidden" name="dwg_rev" id="dwg_rev" />
	<input type="hidden" name="shp_no" id="shp_no" />
	
	<input type="hidden" name="DWG_PROJECT_NO" id="DWG_PROJECT_NO" />
	<input type="hidden" name="DWG_NO" id="DWG_NO" />
	<input type="hidden" name="REV_NO" id="REV_NO" />
	
	<div style="margin-top:7px; margin-left:3px; width:100%;">
		<input type="button" name="btnSearch" id="btnSearch" value="Search"  class="btn_blue"/>		
		<input type="button" name="btnModify" id="btnModify" value="Modify"  class="btn_blue"/>
	</div>
	<table class="searchArea2" style="margin-top:10px;">
		<tr>
			<th>
			호선
			</th>
			<td colspan=5>
				<input style="width:70px; text-transform: uppercase;" onchange="onlyUpperCase(this);" type="text" name="shipNo" id="shipNo" />
				&nbsp;
				<input type="radio" name="notRequired" id="notRequired" style="vertical-align: middle;" /><label for="notRequired">Not Required</label>
			</td>
		</tr>
		<tr>
			<th>
			작업 Stage
			</th>
			<td style="width:150px;">
				<input type="text" name= "p_work_stage" id="p_work_stage" readonly style="width:70px; color: black; background: #dddddd;"/>
			</td>
			<th style="width:100px;">
			작업 시점
			</th>
			<td style="width:150px;">
				<input type="text" name= "p_work_time" id="p_work_time" readonly style="width:70px; color: black; background: #dddddd;"/>
			
			</td>
			<th style="width:100px;">
			담당자
			</th>
			<td>
				<input type="text" name= "p_user_list" id="p_user_list" readonly style="width:70px; color: black; background: #dddddd;"/>
			</td>
		</tr>
		<tr>
			<th>
			원인부서
			</th>
			<td>
				<input type="text" name= "causedept" id="causedept" readonly style="width:70px; color: black; background: #dddddd;"/>
			</td>
			<th>
			ITEM ECO No.
			</th>
			<td>
				<input type="text" name= "p_item_eco_no" id="p_item_eco_no" readonly style="width:70px; color: black; background: #dddddd;"/>
			</td>
			<th>
			ECR No.
			</th>
			<td>
				<input type="text" name= "p_ecr_no" id="p_ecr_no" readonly style="width:70px; color: black; background: #dddddd;"/>
			</td>
		</tr>
		<tr>
			<th>
			내용
			</th>
			<td colspan=5>
					<textarea name="description" id="description" rows="3" style="min-width:685px;color: black; background: #dddddd" readonly="readonly"></textarea>
			</td>
		</tr>
		<tr>
			<th>
			개정 물량
			</th>
			<td colspan=5>
					<input type="text" name= "p_eco_ea" id="p_eco_ea" readonly style="min-width:685px;color: black; background: #dddddd;"/>
			</td>
		</tr>
	</table>
	
	<div style="margin-top: 10px;">
		<div id="mailReceiverListDiv" class="content">
			<table id="mailReceiverList"></table>
			<div id="btn_mailReceiverList"></div>
		</div>
	</div>
	</form>
</div>
<script type="text/javascript">
var fv_not_required = 0;
var win				= null;
$(document).ready(function(){
	$("#mailReceiverList").jqGrid({
			datatype:'json',
			mtype	:'',
			editUrl :'clientArray',
			postData : getFormData('#application_form'),
			colNames:['호선','사/내외','수신부서','수신담당자','메일 주소','메일발송 여부','메일발송 일자','구분'],
				colModel:[
					{name:'project_no',index:'project_no',width:70 ,align:'center'},
					{name:'user_type',index:'user_type',width:60, align:'center' },
					{name:'print_dept_name',index:'print_dept_name',width:200 },
					{name:'print_user_name',index:'print_user_name',width:100 ,align:'center'},
					{name:'email',index:'email',width:200 },
					{name:'mail_send_flag',index:'mail_send_flag',width:120 ,align:'center'},
					{name:'mail_send_date',index:'mail_send_date',width:120 ,align:'center'},
					{name:'drawing_status',index:'drawing_status',width:70 },
				],
			gridview: true,
			viewrecords: true,
			toolbar: [false, "bottom"],
			autowidth:true,
			//height:295,
			//pgbuttons: false,
			//pgtext: false,
			//pginput:false,
			rowList:[100,500,1000],
     		rowNum:100,
			pager: $('#btn_mailReceiverList'),
			jsonReader:{
				root:"rows",
				page:"page",
				total:"total",
				records:"records",
				repeatitems:false,
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
			    
			    var item = $('#mailReceiverList').jqGrid('getRowData',1);
			    var h_state = parent.document.getElementById("h_state").value;
			    var h_returnChk = parent.document.getElementById("h_returnChk").value; 
			    
				if(item.project_no!=null){
					$("input:radio[name='notRequired']").prop("disabled",true);
					$("input:radio[name='notRequired']").prop("checked",false);
					fv_not_required=0;
					window.parent.nrParameter(fv_not_required);
				}else if(item.project_no == null){
					if(h_state == 'Release' || h_state == 'Request'){
						$("input:radio[name='notRequired']").prop("disabled",true);
					}else{
						$("input:radio[name='notRequired']").prop("disabled",false);
					}
				}
			 },
	});
	fn_insideGridresize( $(window), $( "#mailReceiverListDiv" ), $( "#mailReceiverList" ), 105 );
});
	 $("#btnSearch").click(function(){
		 fn_search();
	 });


	 $("#btnModify").click(function(){
		 fn_modify_popup();
     });
    
     $("#notRequired").click(function(){
		if(fv_not_required==0){
			fv_not_required=1;
			//$("input:radio[name='notRequired']").attr("checked",true);
			$("input:radio[name='notRequired']").prop("checked",true);
		}else{
			fv_not_required=0;
			//$("input:radio[name='notRequired']").attr("checked",false);
			$("input:radio[name='notRequired']").prop("checked",false);
		}
		window.parent.nrParameter(fv_not_required);
     }); 
     
     function fn_search() {
    	 
    	$( "#DWG_PROJECT_NO").val($( "#h_ShipNo").val());
 		$( "#DWG_NO").val($( "#h_DwgNo").val());
 		$( "#REV_NO").val($( "#dwg_rev").val());
    		
    	var surl = "mailReceiverList.do";
 		$( "#mailReceiverList" ).jqGrid( 'setGridParam', {
 			url : surl,
 			mtype	:'POST',
 			datatype : 'json',
 			page : 1,
 			postData : getFormData( '#application_form' )
		} ).trigger( "reloadGrid" );
     }
     
     function fn_modify_popup() {
 	 	var h_state = parent.document.getElementById("h_state").value;
 	 	if(h_state == "" || h_state == null){
 	 		alert('수정할 도면을 선택해 주세요');
 	 		return;
 	 	} 
 	 	
 	 	if(h_state=='Release' || h_state=='Request'){
 	 		alert("Request & Release 도면은 수정이 불가능합니다.");
 	 		return;
 	 	}
 	 	
 	 	var h_ShipNo = parent.document.getElementById("h_ShipNo").value;
 		var h_DwgNo = parent.document.getElementById("h_DwgNo").value;
 		var dwg_rev = parent.document.getElementById("dwg_rev").value;
 		var shipNo = $("#shipNo").val();
 		var description = $("#description").val();
 		
 		if (win != null){
 	   		win.close();
 	   	}
 	 	win=window.open("popUpDwgMailReceiver.do?h_ShipNo="+h_ShipNo+"&h_DwgNo="+h_DwgNo+"&dwg_rev="+dwg_rev+"&shipNo="+shipNo+"&description="+description,"application_form","height=560,width=600,top=200,left=100,location=no");
     	
     }
     
     
     
     function searchDWG(radioChk){
     	resetGrid();
		
     	if(radioChk==''){
			$("input:radio[name='notRequired']").prop("checked",false);
			fv_not_required=0;
     	}else{
			$("input:radio[name='notRequired']").prop("checked",true);
			fv_not_required=1;
     	}
     	
     	var h_ShipNo = parent.document.getElementById("h_ShipNo").value;
		var h_DwgNo = parent.document.getElementById("h_DwgNo").value;
		var dwg_rev = parent.document.getElementById("dwg_rev").value;
		var h_state = parent.document.getElementById("h_state").value;
		if(h_state=='Request' || h_state == 'Release'){
			$("input:radio[name='notRequired']").prop("disabled",true);
		}else{
			$("input:radio[name='notRequired']").prop("disabled",false);
		}
		$("#h_ShipNo").val(h_ShipNo);
		$("#h_DwgNo").val(h_DwgNo);
		$("#dwg_rev").val(dwg_rev);
		url= "selectDWGEcoReceiver.do";
		var parameters ={	
							h_ShipNo	: h_ShipNo,
							h_DwgNo   	: h_DwgNo,
							dwg_rev  	: dwg_rev,
							shipNo		: $("#shipNo").val() 
						};
		$.post(url, parameters , function(data) {
			$("#shipNo").val("");
	     	$("#p_work_stage").val("");
	     	$("#p_work_time").val("");
	     	$("#p_user_list").val("");
	     	$("#causedept").val("");
	     	$("#p_item_eco_no").val("");
	     	$("#p_ecr_no").val("");
	     	$("#description").val("");
	     	$("#p_eco_ea").val("");
			if( data != null ) {
				var description = data.description;
				var causedept = data.causedept;
				var work_stage = data.work_stage;
				var work_time = data.work_time;
				var user_list = data.user_list;
				var item_eco_no = data.item_eco_no;
				var ecr_no = data.ecr_no;
				var eco_ea = data.eco_ea;
				
				$( "#description" ).val( description );
				$( "#causedept" ).val( causedept );
				$( "#p_work_stage" ).val( work_stage );
				$( "#p_work_time" ).val( work_time );
				$( "#p_user_list" ).val( user_list );
				$( "#p_item_eco_no" ).val( item_eco_no );
				$( "#p_ecr_no" ).val( ecr_no );
				$( "#p_eco_ea" ).val( eco_ea );
			} else {
				$( "#description" ).val( "" );
				$( "#causedept" ).val( "" );
				$( "#p_work_stage" ).val( "" );
				$( "#p_work_time" ).val( "" );
				$( "#p_user_list" ).val( "" );
				$( "#p_item_eco_no" ).val( "" );
				$( "#p_ecr_no" ).val( "" );
				$( "#p_eco_ea" ).val( "" );
			}
		},"json" );
		
		url= "selectNotRequired.do";
		$.post(url, parameters , function(data) {
			if(data != null){
					if(data.mail_receiver == 'Y'){
						if(h_state=='Return'){
							$("input:radio[name='notRequired']").prop("checked", false);
							fv_not_required=0;
							window.parent.nrParameter(fv_not_required);
						}else{
							$("input:radio[name='notRequired']").prop("checked", true);
							fv_not_required=1;
							window.parent.nrParameter(fv_not_required);
						}
					}
			}
		}).responseText;
		
		fn_search();
// 		surl = "mailReceiverList.do";
// 		$("#mailReceiverList").jqGrid('setGridParam',{url:surl,datatype:'json',page:1,postData: getFormData('#application_form')}).trigger("reloadGrid");
     }
     
     function parentGridReload(){
     	var h_ShipNo = parent.document.getElementById("h_ShipNo").value;
		var h_DwgNo = parent.document.getElementById("h_DwgNo").value;
		var dwg_rev = parent.document.getElementById("dwg_rev").value;
		$("#h_ShipNo").val(h_ShipNo);
		$("#h_DwgNo").val(h_DwgNo);
		$("#dwg_rev").val(dwg_rev);
		
		url= "selectDWGEcoReceiver.do";
		var parameters ={	
							h_ShipNo	: h_ShipNo,
							h_DwgNo   	: h_DwgNo,
							dwg_rev  	: dwg_rev,
							shipNo		: $("#shipNo").val() 
						};
		$.post(url, parameters , function(data) {
			if( data != null ) {
				var description = data.description;
				var causedept = data.causedept;
				var work_stage = data.work_stage;
				var work_time = data.work_time;
				var user_list = data.user_list;
				var item_eco_no = data.item_eco_no;
				var ecr_no = data.ecr_no;
				var eco_ea = data.eco_ea;
				
				$( "#description" ).val( description );
				$( "#causedept" ).val( causedept );
				$( "#p_work_stage" ).val( work_stage );
				$( "#p_work_time" ).val( work_time );
				$( "#p_user_list" ).val( user_list );
				$( "#p_item_eco_no" ).val( item_eco_no );
				$( "#p_ecr_no" ).val( ecr_no );
				$( "#p_eco_ea" ).val( eco_ea );
			} else {
				$( "#description" ).val( "" );
				$( "#causedept" ).val( "" );
				$( "#p_work_stage" ).val( "" );
				$( "#p_work_time" ).val( "" );
				$( "#p_user_list" ).val( "" );
				$( "#p_item_eco_no" ).val( "" );
				$( "#p_ecr_no" ).val( "" );
				$( "#p_eco_ea" ).val( "" );
			}
		},"json" );
     	
		fn_search();
     	
     };
     //폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	
	function onlyUpperCase(obj) {
		obj.value = obj.value.toUpperCase();	
	}
	
	function resetGrid(){
    	$("#mailReceiverList").clearGridData();
    	$( "#description" ).val( "" );
		$( "#causedept" ).val( "" );
		$( "#p_work_stage" ).val( "" );
		$( "#p_work_time" ).val( "" );
		$( "#p_user_list" ).val( "" );
		$( "#p_item_eco_no" ).val( "" );
		$( "#p_ecr_no" ).val( "" );
		$( "#p_eco_ea" ).val( "" );
    }
	
	function autoHeight(objectHeight){
		$("#mailReceiverList").jqGrid("setGridHeight", objectHeight - 204);
	}
</script>
</body>
</html>