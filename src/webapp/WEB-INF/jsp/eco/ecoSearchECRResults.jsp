<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CODE MASTER</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "wrap">
	<form id="application_form" name="application_form" >
			<input type="hidden" id="pageYn" name="pageYn" value="N">
			<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
			<input type="hidden" id="save" name="save" value="<%=request.getParameter("save")%>"/>
			<input type="hidden" id="sType" name="sType" value="ecoAddEcrRink"/>
			<input type="hidden" name="main_code" id="main_code" value="">
			<input type="hidden" name="sTypeName" id="sTypeName" value="">
			<input type="hidden" name="states_code" id="states_code" value="">
			<input type="hidden" name="eco_cause" id="eco_cause" value="">
			
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			
			<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="ecr" />
			<div style="margin-top: 10px;margin-left: 10px;">
				<input type="button" class="btn_blue" id="ecrCreate" name="ecrCreate" value="ECR연계" />
				<input type="button" class="btn_blue" id="ecrDelete" name="ecrDelete" value="ECR삭제" />
			</div>
		<div id="ecrListDiv" style="margin-top: 10px;" >
			<table id="ecrList"></table>
			<div id="pecrList"></div>
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
var main_code = parent.document.getElementById("main_code").value;
var sTypeName = parent.document.getElementById("sTypeName").value;
var states_code = parent.document.getElementById("states_code").value;
var main_name = window.parent.$("#ref_main_name").val();
var states_desc = parent.document.getElementById("states_desc").value;
var locker_by = parent.document.getElementById("locker_by").value;
var loginId = parent.document.getElementById("loginid").value;



 //url:'ecoSearchECRResultsList.do?main_code='+parent.document.getElementById("main_code").value,
 
$(document).ready(function(){
	 
	 
	
	$("#ecrList").jqGrid({ 
         datatype: 'json', 
         mtype: '', 
         url: '',
         postData : getFormData("#application_form"),
         //editurl:'saveCatalogMgnt.do',
         //editUrl: 'clientArray',
    	 //cellSubmit: 'clientArray',
         colNames:['선택','main_code','이름','상태','Description','RelCode',''],
            colModel:[
            	{name:'enable_flag',index:'enable_flag',align : "center", width:30, editable:true, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false}},
            	{name:'main_code',index:'main_code', width:25 ,hidden:true},
            	{name:'main_code',index:'main_code', width:100, align:"center", editrules:{required:true}, editoptions:{size:90}},
                {name:'states_desc',states_desc:'states_desc', width:80,  editoptions:{size:79}},
                { hidden : false, name : 'main_name', index : 'main_name', width : 270, edittype : "textarea", editoptions : { rows : "3", cols : "40" } },
                {name:'eng_rel_code',index:'eng_rel_code', width:25 ,hidden:true},
                {name:'oper',index:'oper', width:25 ,hidden:true},
            ],
            
         gridview: true,
         cmTemplate: { title: false },
         toolbar: [false, "bottom"],
         viewrecords: true,
         autowidth: true,
         //height: $("#ecrList").height(),
         height : parent.objectHeight-168,
         rowNum:100,
		 rowList:[100,500,1000],
         hidegrid : false,
         pager: jQuery('#pecrList'),
		 cellEdit: true,             // grid edit mode 1
         cellsubmit: 'clientArray',  // grid edit mode 2
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
			 },
			 ondblClickRow : function( rowid, cellname, value, iRow, iCol) {
					/* var ret = $("#ecrList").jqGrid( "getRowData", rowid );
	              	var ecrName = ret.main_code;
	              	
            		var sUrl = "./popUpECR.do?ecr_name=" + ecrName;
        			
        			window.open( sUrl, "ECR_MAIN", "width=1500 height=750 toolbar=no menubar=no location=no" ); */
        			
//                 	window.showModalDialog(
// 								"mainPopupSearch.do?cmd=popupEcrMain&ecr_name=" + ecrName,
// 								"view",
// 								"dialogWidth:1200px; dialogHeight:768px; center:on; scroll:off; status:off" );
               	}
				
             
     }); 
     
     //fn_jqGridsetHeight($("#divCloseFlag").val(),"ecrList", screen.height);
     
     if( main_name == "" ) {
					$("#ecrList").jqGrid( "setCaption", 'Related ECRs' );
				} else {
					$("#ecrList").jqGrid( "setCaption", 'Related ECRs - ' + main_name );
				}
				

	$("#ecrList").jqGrid('navGrid',"#pecrList",{search:false,edit:false,add:false,del:false});
	
	
	$("#ecrCreate").click(function() {
		addChmResultRow();
	});
	$("#ecrDelete").click(function() {
		deleteRow();
	});
	/* $("#ecrList").navButtonAdd('#pecrList',
			{ 	caption:"", 
				buttonicon:"ui-icon-minus", 
				onClickButton: deleteRow,
				position: "first", 
				title:"Del", 
				cursor: "pointer"
			} 
		);
	 	$("#ecrList").navButtonAdd('#pecrList',
			{ 	caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: addChmResultRow,
				position: "first", 
				title:"Add", 
				cursor: "pointer"
			} 
		); */
			
				
				
	//afterSaveCell oper 값 지정
	function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
		var item = $('#ecrList').jqGrid('getRowData',irowId);
		if(item.oper != 'I') item.oper = 'U';
		$('#ecrList').jqGrid("setRowData", irowId, item);
		$("input.editable,select.editable", this).attr("editable", "0");	
	};
	
	
	function addChmResultRow() {
			
	
 		 var rs=window.showModalDialog("popUpECR.do?save=reEcr&main_code="+main_code+"&sTypeName="+sTypeName+"&states_code="+states_code+"&sEco_cause="+$( '#eco_cause').val(),window,"dialogWidth:1200px; dialogHeight:460px; center:on; scroll:off; status:off");
		 if(rs!=null){
			 parent.fn_search();
			 //fn_search();
		}
 	}
 		
 		
	//저장버튼
	function deleteRow(){
		
		  if(!("Create" == states_desc && locker_by == loginId)){
		  	alert("삭제할 권한이 없습니다.");
		  
		  }else{
		  
		  	var quest = confirm('삭제 하시겠습니까?'); 
		    if(quest) // 예를 선택하실 경우;; 
		      { 
		
				$( '#ecrList' ).saveCell( kRow, idCol );
			
					var chmResultRows = [];
					getChangedChmResultData( function( data ) {
						chmResultRows = data;
						
						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
						
						var url = 'saveEcrResult.do?saveDel=del';
						var formData = getFormData( '#application_form' );
						var parameters = $.extend( {}, dataList, formData );
						
						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								fn_search();
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
	fn_buttonDisabled([ "#ecrCreate","#ecrDelete" ]);
	
	fn_gridresize( parent.objectWindow, $( "#ecrList" ) ,-67,0.5 );
});  //end of ready Function
function buttonView(){
	fn_buttonEnable([ "#ecrCreate","#ecrDelete" ]);
	if(!(states_desc == "Create" && locker_by == loginId)){	
		fn_buttonDisabled([ "#ecrCreate","#ecrDelete" ]);
	}	
};
/* function searchecrType(obj,nCode,nData,nRow,nCol){
    searchIndex = $(obj).closest('tr').get(0).id;
	var rs = window.showModalDialog("popUpBaseInfo.do?cmd=popupBaseInfo",window,"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");
	
	$(tableId).saveCell(nRow,nCol);
	
	if (rs != null) {
		$(tableId).setCell(searchIndex,'sd_type',rs[0]); 
		$(tableId).setCell(searchIndex,nData,rs[1]); 
		var item = $(tableId).jqGrid('getRowData',searchIndex);
		if(item.oper != 'I') $(tableId).setCell(searchIndex,"oper","U");
	}
} */



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
	var changedData = $.grep($("#ecrList").jqGrid('getRowData'), function (obj) {
		return obj.enable_flag == 'Y'; 
	});
	callback.apply(this, [changedData.concat(resultData)]);
};


function fn_search() {
	//var sUrl = "ecoSearchECRResultsList.do";
	if(window.parent.$("#main_code").val() == "") {
		alert('ECO 선택후 조회 바랍니다.');
	} else {
		states_desc = window.parent.$("#states_desc").val();
		locker_by = window.parent.$("#locker_by").val();
		loginId = window.parent.$("#loginid").val();
		sTypeName = window.parent.$("#sTypeName").val();
		states_code = window.parent.$("#states_code").val();
		main_code = window.parent.$("#main_code").val();
			
		$("#main_code").val(window.parent.$("#main_code").val());
		$("#eco_cause").val(window.parent.$("#eco_cause").val());
		
		$("#ecrList").jqGrid("setCaption", 'Related ECRs - ' + window.parent.$("#ref_main_name").val());
		var sUrl = 'infoEcoEcrResultsList.do';												 
		$( "#ecrList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				mtype: 'POST',
				datatype : 'json',
				page : 1,
				postData : getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		buttonView();
	}
													 
}

// 	$('#btnAdd').click(function(){
// 		var maincode = parent.document.getElementById("main_code").value;
// 		var sTypeName = parent.document.getElementById("sTypeName").value;
// 		var states_code = parent.document.getElementById("states_code").value;
		
//  		var rs = window.showModalDialog("mainPopupSearch.do?cmd=popupECR&save=reEcr&maincode="+maincode+"&sTypeName="+sTypeName+"&states_code="+states_code,window,"dialogWidth:700px; dialogHeight:460px; center:on; scroll:off; status:off");
	
//  		if(rs!=null){
//  			parent.fn_search();
			
// 		}
// 	});
</script>
</body>
</html>
