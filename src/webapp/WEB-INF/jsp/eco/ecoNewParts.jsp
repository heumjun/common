<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>new part</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "wrap">
	<form id="application_form" name="application_form" >
				
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
		
			<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
			<input type="hidden" id="save" name="save" value="<%=request.getParameter("save")%>"/>
			<input type="hidden" name="tabName" id="tabName" value="<%=request.getParameter("tabName")%>"> <!-- New part,obsolete parts,revised parts -->
			<input type="hidden" name="main_type" id="main_type" value="ECO">
			<input type="hidden" name="eng_sub_type" id="eng_sub_type" value="PART">
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			<input type="hidden" name="eco_no" id="eco_no">
			<input type="hidden" name="states_desc" id="states_desc">
			<input type="hidden" id="pageYn" name="pageYn" value="N" />

		<div id="ecoNewpartListDiv" style="margin-top: 10px;" >
			<table id="ecoNewpartList1"></table>
			<table id="ecoNewpartList2"></table>
			<table id="ecoNewpartList3"></table>
			<div id="pecoNewpartList"></div>
		</div>
	</form>
</div>
<script type="text/javascript">
<%
String tableNo = request.getParameter("tabNo") == null ? "" : request.getParameter("tabNo").toString();
%>
	var tableNo = 'ecoNewpartList' + <%=tableNo%>;
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
	
	var tabName = $("#tabName").val();
	var states_desc = parent.document.getElementById("states_desc").value;
	var locker_by = parent.document.getElementById("locker_by").value;
	var loginId = parent.document.getElementById("loginid").value;
	
	var main_name = parent.document.getElementById("ref_main_name").value;
	var paMain_code= parent.document.getElementById("main_code").value;
	
	$('#eco_no').val(main_name);
	$('#states_desc').val(states_desc);
	
	var p_tabName;
	 if("newpart" == tabName){
	 	p_tabName = "New Parts";
	  } else if("obsoletepart" == tabName){
	    p_tabName = "Obsolete Parts";
	  }else{ //revisedpart
	  	p_tabName = "Revised Parts";
	  }
		
	$(document).ready(function(){
		 
		
		$("#"+tableNo).jqGrid({ 
	             datatype: 'json', 
	             mtype: '', 
	             url:'',
	             postData : fn_getFormData( "#application_form" ),
	             //editurl:'saveCatalogMgnt.do',
	             //editUrl: 'clientArray',
	        	 //cellSubmit: 'clientArray',
	             colNames:['선택','PROJECT NO','MOTHER ITEM','CHILD ITEM','EA','UM','Part Description','ACD','State','Date','oper'],
	                colModel:[
	                	{name:'enable_flag',index:'enable_flag',align : "center", width:30, edittype:'checkbox', formatter: "checkbox", editoptions: {value:"Y:N" }, formatoptions:{disabled:false},hidden:true},
	                	{name:'project_no',index:'project_no', width:80, align:"center"},
	                	{name:'mother_code',index:'mother_code', width:100, align:"center"},
	                    {name:'item_code',index:'item_code', width:100, align:"center"},
	                    {name:'bom_qty',index:'bom_qty', width:30, align:"center"},
	                    {name:'uom',index:'uom', width:30, align:"center"},
	                    {name:'main_description',index:'main_description', width:300},
	                    {name:'acd_desc',index:'acd_desc', width:80,align:"center"},
	                    {name:'states_desc',index:'states_desc', width:80,align:"center"},  
	                    {name:'modify_date',index:'modify_date', width:100},
	                    {name:'oper',index:'oper', width:25 ,hidden:true}
	                ],
					rowNum : 100,
					cmTemplate: { title: false },
					rowList : [ 100, 500, 1000 ],
	             gridview: true,
	             toolbar: [false, "bottom"],
	             viewrecords: true,
	             autowidth: true,
	             //height: $("#ecrList").height(),
	             height : parent.objectHeight-135,
	             hidegrid : false,
	             pager: jQuery('#pecoNewpartList'),
// 	             pgbuttons: false,
// 				 pgtext: false,
// 				 pginput:false,
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
	             onPaging : function( pgButton ) {
						/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
						 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
						 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
						 */
						$(this).jqGrid( "clearGridData" );

						/* this is to make the grid to fetch data from server on page click*/
						$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
					},
					loadComplete : function( data ) {
						var $this = $(this);
						if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
							// because one use repeatitems: false option and uses no
							// jsonmap in the colModel the setting of data parameter
							// is very easy. We can set data parameter to data.rows:
							$this.jqGrid( 'setGridParam', {
								datatype : 'local',
								data : data.rows,
								pageServer : data.page,
								recordsServer : data.records,
								lastpageServer : data.total
							} );

							// because we changed the value of the data parameter
							// we need update internal _index parameter:
							this.refreshIndex();

							if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
								// we need reload grid only if we use sortname parameter,
								// but the server return unsorted data
								$this.triggerHandler( 'reloadGrid' );
							}
						} else {
							$this.jqGrid( 'setGridParam', {
								page : $this.jqGrid( 'getGridParam', 'pageServer' ),
								records : $this.jqGrid( 'getGridParam', 'recordsServer' ),
								lastpage : $this.jqGrid( 'getGridParam', 'lastpageServer' )
							} );
							this.updatepager( false, true );
						}
					},
// 	             ondblClickRow: function(rowid, cellname, value, iRow, iCol) {
            
// 	            	var ret 	= jQuery("#"+tableNo).getRowData(rowid);
// 					var item_type = ret.item_type;
// 					var item_code = ret.main_name; 
			
// 					if( item_code != "" ) {
						
// 						var sUrl = "./popupItem.do?item_code=" + item_code+"&popupDiv=Y" ;
												
// 						window.showModalDialog(sUrl,window,"dialogWidth:1500px; dialogHeight:750px; center:on; scroll:off; status:off");
// 					}		
					
// 			 	}
	             
	             
	     }); 
	     //fn_jqGridsetHeight($("#divCloseFlag").val(),tableNo, screen.height);
	     
	     if( main_name == "" ) {
					$("#"+tableNo).jqGrid( "setCaption", p_tabName );
				} else {
					$("#"+tableNo).jqGrid( "setCaption", p_tabName +' - ' + main_name );
				}
			
				
	     $("#"+tableNo).jqGrid('navGrid',"#pecoNewpartList",{search:false,edit:false,add:false,del:false});

		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $("#"+tableNo).jqGrid('getRowData',irowId);
			if(item.oper != 'I') item.oper = 'U';
			$("#"+tableNo).jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");	
		};
		fn_gridresize( parent.objectWindow,$( "#"+tableNo ),-100,0.5 );
	});  //end of ready Function
	
	/*황경호 function searchecrType(obj,nCode,nData,nRow,nCol){
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

	/* 황경호 //폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	}; */
	
	/*황경호 function getChangedChmResultData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var changedData = $.grep($("#"+tableNo).jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D'; 
		});
		callback.apply(this, [changedData.concat(resultData)]);
	}; */
	
	function fn_search() {
		if(window.parent.$("#main_code").val() == "") {
			alert('ECO 선택후 조회 바랍니다.');
		} else {
			$("#"+tableNo).jqGrid("setCaption", p_tabName+' - ' + window.parent.$("#ref_main_name").val());
			$('#eco_no').val(parent.document.getElementById("main_code").value);
			var sUrl = 'infoEcoNewPartsList.do';
			jQuery("#"+tableNo).jqGrid('setGridParam',{url:sUrl
															 ,mtype: 'POST'
															 ,page:1
															 ,datatype: 'json',
															 postData: fn_getFormData( "#application_form" )}).trigger("reloadGrid");
		}
	}

	
</script>
</body>
</html>
