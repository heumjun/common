<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>dwgInformation</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<div id="wrap">
<form id="application_form" name="application_form">
<input type="hidden" name="h_ShipNo" id="h_ShipNo"/>
<input type="hidden" name="h_DwgNo" id="h_DwgNo"/>
<input type="hidden" name="h_returnChk" id="h_returnChk"/>
<input type="hidden" name="dwg_seq_id" id="dwg_seq_id"/>
<input type="hidden" name="file_name" id="file_name"/>
<input type="hidden" name="h_state" id="h_state"/>
<input type="hidden" name="emp_no" id="emp_no"/>
<input type="hidden" name="deptNo" id="deptNo">
<input type="hidden" name="dwg_rev" id="dwg_rev">
<input type="hidden" name="dept" id="dept">
<input type="hidden" name="result" id="result">
<input type="hidden" name="P_FILE_NAME" id="P_FILE_NAME" />
<input type="hidden" name="revCancelCheck" id="revCancelCheck" value="N" />

<input type="hidden" name="pageYn" id="pageYn" value="N" />

	<div style="margin-top:7px; margin-left:3px;">
		<div style="float: left; width: 85%;">
			<div style="float: left; width: 500px;">
				<input type="button" name="selectView" id="selectView" value="SelectView" class="btn_blue"/>
				<input type="button" name="removeItem" id="removeItem" value="Remove selected item"  class="btn_blue"/>
				<!--<input type="button" name="dwgtransitem" id="dwgtransitem" value="dwgtransitem" />-->
				 &nbsp;<span style="font-size:11px;">리턴 도면과 동일</span>
				<input type="checkbox" name="returnChk" id="returnChk" disabled="disabled" />
			</div>
			<div style="float:right; text-align:right">
				<input type="button" name="revisionCancel" id="revisionCancel" value="Cancel" class="btn_blue" style="display: none;" />	
			</div>
		</div>
		<div style="float: right; width: 14%;">
		</div>			
	</div>
	<div style="width: 100%;margin-top: 5px;">
		<div id="dwgInformationListDiv" style="float: left; width: 85%; ">
			<table id = "dwgInformationList" ></table>
			<div id="btn_dwgInformationList"></div>
		</div>
		
		<div id="dwgItemListDiv" style="float: right; width: 14%;">
			<table id = "dwgItemList" ></table>
			<div id="btn_dwgItemList"></div>
		</div>
	</div>
</form>
</div>
<script type="text/javascript">
var row_selected=null;
var vFileName = "";
var vEmpNo = "";
var chboxCnt = 0;
var fv_returnChk = 0;
$(document).ready(function(){
	$("#dwgInformationList").jqGrid({
             datatype: 'json', 
             mtype: '', 
             editUrl: 'clientArray',
             postData : getFormData('#application_form'),
             colNames:['<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />','호선','도면번호','SEQ','REV','FILE NAME','SIZE','승인유무','사번','사용자명','부서명','전송일자','PCS NO','FORM TYPE','계열','PAINT CODE',''],
                colModel:[
                	{name:'rev', index:'rev'				, width:18	,align:'center',formatter: formatOpt1},
                    {name:'shp_no',index:'shp_no'			, width:40 	,align:'center'},
                    {name:'dwg_no',index:'dwg_no'			, width:55 	,align:'center'},
                    {name:'dwg_sq',index:'dwg_sq'			, width:30	,align:'right' },
                    {name:'dwg_rev',index:'dwg_rev'			, width:30	,align:'center'},
                    {name:'file_name',index:'file_name' 	, width:200					, classes:'handcursor' },
                    {name:'pri_set',index:'pri_set'			, width:40	,align:'center'},
                    {name:'trans_plm',index:'trans_plm'		, width:50	,align:'center' , hidden:true},
                    {name:'emp_no',index:'emp_no'			, width:50	,align:'center'},
                    {name:'user_name',index:'user_name'		, width:52	,align:'center'},
                    {name:'dept_name',index:'dept_name'		, width:110},
                    {name:'inp_date',index:'inp_date'		, width:90	,align:'center'},
                    {name:'pcs_no',index:'pcs_no'			, width:55	,align:'center'},
                    {name:'form_type',index:'form_type'		, width:90},
                    {name:'form_name',index:'form_name'		, width:40},
                    {name:'paint_code',index:'paint_code'	, width:80},
                    {name:'dwg_seq_id',index:'dwg_seq_id', hidden:true}
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             //height: 432,
             rowNum : 1000,
             rowList:[100,500,1000],
             //loadonce:true,
             pager: jQuery('#btn_dwgInformationList'),
             shrinkToFit:false,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  	
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
                                 row_selected = row_id;
                                 var item = $('#dwgInformationList').jqGrid('getRowData',row_id);
								 var dwg_seq_id = item.dwg_seq_id;
								 $("#dwg_seq_id").val(dwg_seq_id);
								 
                                 var iUrl = "dwgItemList.do";
								 jQuery("#dwgItemList").jqGrid('setGridParam',{
									 											url:iUrl
									 											,mtype: 'POST'
									 											,datatype:'json'
									 											,page:1
									 											,postData: getFormData('#application_form')})
									 					.trigger("reloadGrid");
		
                             }
                          },
             onCellSelect: function(rowid,icol,cellcontent,e){
             	if(icol==5){
					var item = $('#dwgInformationList').jqGrid('getRowData',rowid);
		    		vFileName = item.file_name;
		    		vEmpNo = item.emp_no;
					window.open("popUpDWGView.do?mode=dwgView&P_FILE_NAME="+vFileName+"&vEmpNo="+vEmpNo,"listForm","height=500,width=1200,top=150,left=200,location=no");
             	}
             },
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
			    
			    
			    
				var parent_rev = parent.document.getElementById("dwg_rev").value;
				
			    var rows = $("#dwgInformationList").getDataIDs(); 
			    for (var i = 0; i < rows.length; i++)
			    {
			        var dwg_rev = $("#dwgInformationList").getCell(rows[i],"dwg_rev");
			        if(parent_rev=='00'){
			        	return;
			        }
			        if(dwg_rev == parent_rev)
			        {
			            $("#dwgInformationList").jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#E8DB6B'});            
			        }
			    }
			    chboxCnt=0;
			    $(".chkboxItem").each(function() {
					var rowid = $(this).val();
					chboxCnt++;	    		
				});
			    //alert("조회완료");
			 },
			 gridComplete: function(){
			 	var h_state = parent.document.getElementById("h_state").value;
			    if(h_state=="Return"){
					$("input:checkbox[name='returnChk']").attr("disabled",false);
			    }else{
			    	$("input:checkbox[name='returnChk']").attr("disabled",true);
			    }
			 },
			 
			 
    });
    
    $("#dwgItemList").jqGrid({ 
             datatype: 'local', 
             mtype: '', 
             editUrl: 'clientArray',
             colNames:['ITEM NO'],
                colModel:[
                    {name:'part_no',index:'part_no', width:25},
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             autowidth: true,
             //height: 432,
             loadonce:true,
             cellEdit: true,             // grid edit mode 1
	         cellsubmit: 'clientArray',  // grid edit mode 2
	         rownumbers:true,
             pager: jQuery('#btn_dwgItemList'),
             pgbuttons: false,
			 pgtext: false,
			 pginput:false,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             
             
             
    });
	

    fn_insideGridresize( $(window),$( "#dwgInformationListDiv" ),  $( "#dwgInformationList" ), -95 );
	fn_insideGridresize( $(window),$( "#dwgItemListDiv" ),  $( "#dwgItemList" ), -95 );
    
}); //END OF READY FUNCTION
    
    $("#removeItem").click(function(){
    	
    	
    	var dwg_rev = parent.document.getElementById("dwg_rev").value;
    	var state = parent.document.getElementById("h_state").value;
    	
    	//가져온 배열중에서 필요한 배열만 골라내기 
		var chked_val = "";
		$(":checkbox[name='checkbox']:checked").each(function(pi,po){
			chked_val += po.value+",";
		});
		
		var selarrrow = chked_val.split(',');
		if(selarrrow.length==1){
			alert('삭제할 ROW를 CHECK 해주세요');
			return;
		}
		//alert(selarrrow.length-1+"//"+chboxCnt);
		if(selarrrow.length-1==chboxCnt){
			alert('모든 도면 삭제는 불가능 합니다. ');
			return;
		}
		if(state == 'Release' || state == 'Request'){
			alert("Release & Request 된 도면은 삭제가 불가능 합니다.");
			return;
		}
		
		for(var i=0;i<selarrrow.length-1;i++){
		
			var selrow = selarrrow[i];	
			var item   = $('#dwgInformationList').jqGrid('getRowData',selrow);
			
			$('#areaGrid').jqGrid('delRowData', selrow);
			if(dwg_rev != item.dwg_rev){
	    		return;
	    	}
	    	if((state == 'Request') || (state == 'Release') ){
	    		return;
	    	}
	    	window.parent.dwgRemove(item.dwg_seq_id);
	    	$('#dwgInformationList').jqGrid('delRowData', selrow);
	    	chboxCnt--;
			
		}
    	$('#dwgInformationList').resetSelection();
    });
    
    $("#selectView").click(function(){
    	vFileName="";
    	if($(".chkboxItem").is(":checked") == false){
    		alert('Please Select Row');
    		return;
    	}  
    	$(".chkboxItem:checked").each(function() {
				var rowid = $(this).val();
				var item = $('#dwgInformationList').jqGrid('getRowData',rowid);
	    		vFileName += item.file_name+"|";
	    		vEmpNo = item.emp_no;
	    		
		});
		
			$("#P_FILE_NAME").val(vFileName);
    		var sURL = "popUpDWGView.do?mode=dwgChkView&vEmpNo="+vEmpNo;
			form = $('#application_form');		
			form.attr("action", sURL);
			var myWindow = window.open("","listForm","height=500,width=1200,top=150,left=200,location=no");
				    
			form.attr("target","listForm");
			form.attr("method", "post");	
					
			myWindow.focus();
			form.submit();
    });
    
    $("#revisionCancel").click(function(){
    	if(confirm("현재 작업 중 REVISION 및 DATA 영구 삭제됩니다. 진행 하시겠습니까?")) {
    		$("#revCancelCheck").val("Y");
    		var formData = getFormData('#application_form');
    		$.post("dwgRevisionCancel.do", formData, function(data)
    		{	
    			parent.revCancelSearch();
    		},"json");	
    	}
    });
    
    //도면 아이템 연계 기능.
    $("#dwgtransitem").click(function(){
    	
    });
    
    function searchInfo(returnChk){
    	resetGrid();
    	chboxCnt = 0;
    	$("#chkHeader").attr("checked", false);
    	if(returnChk==''){
			$("input:checkbox[name='returnChk']").prop("checked",false);
			fv_returnChk=0;
			$("#h_returnChk").val("");
			$("#removeItem").attr("disabled",false);
     	}else{
			$("input:checkbox[name='returnChk']").prop("checked",true);
			fv_returnChk=1;
			$("#h_returnChk").val("Y");
			$("#removeItem").attr("disabled",true);
     	}

    	var h_ShipNo = parent.document.getElementById("h_ShipNo").value;
		var h_DwgNo = parent.document.getElementById("h_DwgNo").value;
		var dwg_seq_id = parent.document.getElementById("dwg_seq_id").value;
		var dwg_rev = parent.document.getElementById("dwg_rev").value;
		var dept = parent.document.getElementById("dept").value;
		var h_state = parent.document.getElementById("h_state").value;
		$("#h_ShipNo").val(h_ShipNo);
		$("#h_DwgNo").val(h_DwgNo);
		$("#dwg_seq_id").val(dwg_seq_id);
		$("#dwg_rev").val(dwg_rev);
		$("#dept").val(dept);
		$("#h_state").val(h_state);
		
		//상태 Preliminary, Return 의 경우 REVISION CANCEL 가능
		if(h_state == "Preliminary" || h_state == "Return" ){
			$("#revisionCancel").show();
		}
		else{
			$("#revisionCancel").hide();
		}
	
		//Rev조회조건을 찾아서 Reference 도면 일 경우 체크
		$("#result").val("false");
		 var charArray = dwg_rev.split('');
		  for (var j=0; j<charArray.length; j++) {
		   if ((charArray[j] >= 'A' && charArray[j] <= 'Z') || (charArray[j] >= 'a' && charArray[j] <= 'z')){
			   $("#result").val("true");
		   }
		  }
		//alert("조회시작:"+h_ShipNo+"/"+h_DwgNo+"/"+dwg_rev);
		var sUrl = "dwgInformationList.do";
		jQuery("#dwgInformationList").jqGrid('setGridParam',{url:sUrl
															,datatype:'json'
															,mtype: 'POST'
															,page:1
															,postData: getFormData('#application_form')}
											).trigger("reloadGrid");
		
		 
    }
    
    function resetGrid(){
    	jQuery("#dwgInformationList").clearGridData();
    	jQuery("#dwgItemList").clearGridData();
    	$("#revisionCancel").hide();
    }
	
	//STATE 값에 따라서 checkbox 생성
	function formatOpt1(cellvalue, options, rowObject){
		var dwg_rev = parent.document.getElementById("dwg_rev").value;
		var rowid = options.rowId;
   		var str ="<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+rowid+" />";
   		//var str ="<input type='checkbox' name='checkbox'  />";
  	 if( cellvalue == dwg_rev ){  
		return str;      
 	 }else{             
   	 	return "";
 	 }
	}

	
	//function chkClick(rowid){
	//	if(($("#"+rowid+"_chkBoxOV").is(":checked"))){
	//		$("#dwgInformationList").jqGrid('setRowData',rowid,false, {  color:'black',weightfont:'bold',background:'#E8DB6B'});
	//	}else{
	//		$("#dwgInformationList").jqGrid('setRowData',rowid,false, {  color:'black',weightfont:'bold',background:'#FFFFFF'});
	//	}
	//	
	//}
	//header checkbox action 
	function checkBoxHeader(e) {
  		e = e||event;/* get IE event ( not passed ) */
  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
		if(($("#chkHeader").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$("input.chkboxItem").prop("checked", false);
		}
	}
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	
	$("#returnChk").click(function(){
		var reChk = $("input:checkbox[id='returnChk']").is(":checked");
		if(reChk==true){
			fv_returnChk=1;
			$("#h_returnChk").val("Y");
			$("#removeItem").prop("disabled",true);
		}
		else{
			fv_returnChk=0;
			$("#h_returnChk").val("");
			$("#removeItem").prop("disabled",false);
		}
		window.parent.rtParameter(fv_returnChk);
		
		var sUrl = "dwgInformationList.do";
		jQuery("#dwgInformationList").jqGrid('setGridParam',{url:sUrl,datatype:'json',page:1,postData: getFormData('#application_form')}).trigger("reloadGrid");
		
     });
	
	/* function autoHeight(objectHeight){
		$("#dwgInformationList").jqGrid("setGridHeight", objectHeight - 70);
		$("#dwgItemList").jqGrid("setGridHeight", objectHeight - 70);
	} */
	

</script>
</body>
</html>