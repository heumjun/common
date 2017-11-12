<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ECO relaase notification</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "wrap">
	<form id="application_form" name="application_form" >
			<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
			<input type="hidden" id="save" name="save" value="<%=request.getParameter("save")%>"/>
			<input type="hidden" id="sType" name="sType" value="ecoAddEcrRink"/>
			<input type="hidden" name="sTypeName" id="sTypeName" value="<%=request.getParameter("sTypeName")%>">
			<input type="hidden" name="states_code" id="states_code" value="<%=request.getParameter("states_code")%>">
			<input type="hidden" id="main_code" name="main_code">
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="ecr" />

		<div id="ecoNotifiListDiv" style="margin-top: 10px;" >
			<table id="ecoNotifiList"></table>
			<div id="pecoNotifiList"></div>
		</div>
	</form>
</div>
<script type="text/javascript">
	var tableId = '';
	var resultData = [];
	var enable_flag   = "";
	var idRow = 0;
	var idCol = 0;	
	var nRow = 0;
	var cmtypedesc;
	var kRow = 0;
	var kCol = 0;
	var jqgHeight = $(window).height()*0.6;
	
	var mainCode = parent.document.getElementById("main_code").value;
	var main_name = window.parent.$("#ref_main_name").val();
	var states_desc = parent.document.getElementById("states_desc").value;
	var locker_by = parent.document.getElementById("locker_by").value;
	var loginId = parent.document.getElementById("loginid").value;
	
	$(document).ready(function(){
	 
	
		$("#ecoNotifiList").jqGrid({ 
             datatype: 'json', 
             mtype: '', 
             url:'',
             postData : $("#application_form").serialize(),
             //editurl:'saveCatalogMgnt.do',
             //editUrl: 'clientArray',
        	 //cellSubmit: 'clientArray',
              colNames:['선택','사번','이름','직위','부서','이메일','state_req_code',''],
	                colModel:[
	                	{name:'enable_flag',index:'enable_flag',align : "center", width:30, editable:true, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
	                    {name:'emp_no',index:'emp_no', width:100, editable:true,align:"center", editrules:{required:true}, editoptions:{size:90}},
	                    {name:'user_name',index:'user_name', width:100, editable:true,align:"center", editrules:{required:true}, editoptions:{size:90}},
	                    {name:'position_name', index:'position_name',width:100, editable:true,align:"center", editrules:{required:true}, editoptions:{size:90}},
	                    {name:'dept_name',index:'dept_name', width:200, editable:true, editoptions:{size:100}},
	                    {name:'ep_mail',index:'ep_mail', width:200, editable:true, editoptions:{size:100}},
	                    {name:'state_req_code',index:'state_req_code', width:25 ,hidden:true},
	                    {name:'oper',index:'oper', width:25 ,hidden:true},
	                ],
                
             gridview: true,
             cmTemplate: { title: false },
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             //height: $("#ecoNotifiList").height(),
             height : parent.objectHeight-135,
             caption : "ECO relaase notification",
             hidegrid : false,
             pager: jQuery('#pecoNotifiList'),
             pgbuttons: false,
			 pgtext: false,
			 pginput:false,
			 cellEdit: true,             // grid edit mode 1
	         cellsubmit: 'clientArray',  // grid edit mode 2
	         rowNum:-1, 
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow=rowid;
             	idCol=iCol;
             	kRow = iRow;
             	kCol = iCol;
   			 },
			 beforeSaveCell : chmResultEditEnd,
	         //afterSaveCell : chmResultEditEnd,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             
             
     }); 
		
	//fn_jqGridsetHeight($("#divCloseFlag").val(),"ecoNotifiList", screen.height);
	$("#ecoNotifiList").jqGrid('navGrid',"#pecoNotifiList",{search:false,edit:false,add:false,del:false});
	
	$("#ecoNotifiList").navButtonAdd('#pecoNotifiList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer",
				id : "minusBtn"
			} 
	);
 	$("#ecoNotifiList").navButtonAdd('#pecoNotifiList',
		{ 	caption:"", 
			buttonicon:"ui-icon-plus", 
			onClickButton: addChmResultRow,
			position: "first", 
			title:"Add", 
			cursor: "pointer",
			id : "addBtn"
		} 
	);
	$('#minusBtn').hide();
	$('#addBtn').hide();
	
	if( main_name == "" ) {
		$("#ecoNotifiList").jqGrid( "setCaption", 'ECO Relaase Notification' );
	} else {
		$("#ecoNotifiList").jqGrid( "setCaption", 'ECO Relaase Notification - ' + main_name );
	}
							
	//afterSaveCell oper 값 지정
	function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
		var item = $('#ecoNotifiList').jqGrid('getRowData',irowId);
		if(item.oper != 'I') item.oper = 'U';
		$('#ecoNotifiList').jqGrid("setRowData", irowId, item);
		$("input.editable,select.editable", this).attr("editable", "0");	
	};
		
	//저장버튼
	$("#btnRemove").click(function(){	
	
		var main_code = '';
    	var main_name = '';
		
		$('#ecoNotifiList').saveCell(kRow, idCol);
		//return;
		var changedData = $("#ecoNotifiList").jqGrid('getRowData');
		// 변경된 체크 박스가 있는지 체크한다.
		for(var i=1; i<changedData.length+1; i++)
		{
			var item = $('#ecoNotifiList').jqGrid('getRowData',i);
			
			if(item.enable_flag == 'Y'){ // ecr이 선택되어진것을 넣기
			
				main_code = item['main_code']+'|'+main_code;
				main_name = item['main_name']+'|'+main_name;

			}
			
			if ( item.oper != 'I' && item.oper != 'U' ) {
					if(item.enable_flag_changed != item.enable_flag){
						item.oper = 'U';
				    }
					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#ecoNotifiList').jqGrid("setRowData", i, item);
					}
			}	
		}
		
		var iSave = $("#save").val();
		
		var chmResultRows=[];
		getChangedChmResultData(function(data){ //변경된 row만 가져 오기 위한 함수
		chmResultRows = data;
		var dataList = {chmResultList:JSON.stringify(chmResultRows)};
		var url = 'saveReleaseNotificationResults.do?saveDel=del';
				//$('#frmChmProcess').find('select[class="ronly"]').removeAttr('disabled');
		var formData = getFormData('#application_form');
				//$('#frmChmProcess').find('select[class="ronly"]').attr('disabled','disabled');
		var parameters = $.extend({},dataList,formData); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
			$.post(url, parameters, function(data) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					parent.fn_search();	
				}
			},"json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	//lodingBox.remove();	
			} );
		});
		   //{username:"ravi",pass:"124",submit:true}).done(function(data, textStatus, jqXHR)          {           }).fail(function(jqXHR, textStatus, errorThrown)      {         alert(textStatus);     }); 
		fn_search();
	
	  });
	fn_gridresize( parent.objectWindow,$( "#ecoNotifiList" ),-100,0.5 );
	});  //end of ready Function 
	
	function addDelButtonCheck() {
		if(states_desc == "Create" && locker_by == loginId) {	
			$('#minusBtn').show();
			$('#addBtn').show();
		} else {
			$('#minusBtn').hide();
			$('#addBtn').hide();
		}
	}
	
	
	
	//Add 버튼 
	function addChmResultRow() {
	
		var maincode = parent.document.getElementById("main_code").value;
		var sTypeName = parent.document.getElementById("sTypeName").value;
		var states_code = parent.document.getElementById("states_code").value;
		
 		var rs = window.showModalDialog("popUpApproveEmpNo.do?maincode="+maincode+"&noti=NOTIFI",window,"dialogWidth:850px; dialogHeight:460px; center:on; scroll:off; status:off");
 		
 		if(rs!=null){
			fn_search();
		}
 	}
	
	//Del 버튼
	function deleteRow(){
		
		  if(!("Create" == states_desc && locker_by == loginId)){
		  	alert("삭제할 권한이 없습니다.");
		  
		  }else{
		  
		  	var quest = confirm('삭제 하시겠습니까?'); 
		    if(quest) // 예를 선택하실 경우;; 
		      { 
				
				$( '#ecoNewpartList' ).saveCell( kRow, idCol );
				
				var changedData = $("#ecoNotifiList").jqGrid('getRowData');
				// 변경된 체크 박스가 있는지 체크한다.
				for(var i=1; i<changedData.length+1; i++)
				{
					var item = $('#ecoNotifiList').jqGrid('getRowData',i);
					
					if(item.enable_flag == 'Y'){ // ecr이 선택되어진것을 넣기
							item.oper = 'U';
							// apply the data which was entered.
							$('#ecoNotifiList').jqGrid("setRowData", i, item);
					}	
				}
				
			
					var chmResultRows = [];
					getChangedChmResultData( function( data ) {
						chmResultRows = data;
						
						if( chmResultRows.length == 0 ) {
							alert( "삭제 대상을 선택해주세요." );
							return;
						}
						
						//필수입력 체크
						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
						
						var url = 'saveReleaseNotificationResults.do?saveDel=del';
						var formData = getFormData( '#application_form' );
						var parameters = $.extend( {}, dataList, formData );
						
						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								parent.fn_search();	
							}
							
						}, "json" ).error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
					    	//lodingBox.remove();	
						} );
					} );
				}
			}
	
	
	 }
	 
	function searchecrType(obj,nCode,nData,nRow,nCol){
	    searchIndex = $(obj).closest('tr').get(0).id;
		var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupBaseInfo",window,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");
		
		$(tableId).saveCell(nRow,nCol);
		
		if (rs != null) {
			$(tableId).setCell(searchIndex,'sd_type',rs[0]); 
			$(tableId).setCell(searchIndex,nData,rs[1]); 
			var item = $(tableId).jqGrid('getRowData',searchIndex);
			if(item.oper != 'I') $(tableId).setCell(searchIndex,"oper","U");
		}
	}
		
	//폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	function getChangedChmResultData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var changedData = $.grep($("#ecoNotifiList").jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D'; 
		});
		callback.apply(this, [changedData.concat(resultData)]);
	};
	function fn_search() {
		if(window.parent.$("#main_code").val() == "") {
			alert('ECO 선택후 조회 바랍니다.');
		} else {
			mainCode = parent.document.getElementById("main_code").value;
			main_name = window.parent.$("#ref_main_name").val();
			states_desc = parent.document.getElementById("states_desc").value;
			locker_by = parent.document.getElementById("locker_by").value;
			loginId = parent.document.getElementById("loginid").value;
			addDelButtonCheck();
			$("#main_code").val(window.parent.$("#main_code").val());
			$("#ecoNotifiList").jqGrid("setCaption", 'ECO Relaase Notification - ' + window.parent.$("#ref_main_name").val());
			var sUrl = 'infoEcoReleaseNotificationResultsList.do';
			jQuery("#ecoNotifiList").jqGrid('setGridParam',{url:sUrl
															 ,mtype: 'POST'
															 ,page:1
															 ,postData: getFormData( "#application_form" )
															 }).trigger("reloadGrid");	
		}
		
	}

// 	$('#btnAdd').click(function(){
// 		var maincode = parent.document.getElementById("main_code").value;
// 		var sTypeName = parent.document.getElementById("sTypeName").value;
// 		var states_code = parent.document.getElementById("states_code").value;
		
//  		window.showModalDialog("mainPopupSearch.do?cmd=popupApproveEmpNo&maincode="+maincode+"&noti=noti",window,"dialogWidth:700px; dialogHeight:460px; center:on; scroll:off; status:off");
// 	});
</script>
</body>
</html>
