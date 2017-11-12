<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>PopUpGroup</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
			<input type="hidden" id="sType" name="sType" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			
			<div class="topMain" style="margin: 0px;line-height: 45px;">
				<div class="conSearch">
					<select name="sel_condition" id="sel_condition" class="h25">
						<option value="dept_name" selected="selected">부서</option>
						<option value="dept_code">부서코드</option>
					</select>
					<input type="text"  class="h25" id="txt_condition" name="txt_condition" style="text-transform:uppercase; width:60px;" />
				</div>
				<div class="button">
					<input type="button" id="btnfind" value="조회" class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				</div>
			</div>
			<div style="margin-top: 10px;">
				<table id="mainPopup" style="width:100%;height:50%"></table>
				<table id="pmainPopup" style="width:100%;height:50%"></table>
			</div>
		</form>
		<script type="text/javascript">
		var row_selected;
		$("#sType").val(window.dialogArguments);
		$(document).ready( function() {
			fn_all_text_upper();
			$("#mainPopup").jqGrid({
				url:'',
				datatype: "json",
				colNames:['부서코드','부서'],
				colModel:[ {name:'dept_code',index:'dept_code', width:70, editable:true, sortable:false, editrules:{required:true}, editoptions:{size:5}},
				           {name:'dept_name',index:'dept_name', width:90, editable:true, sortable:false, editoptions:{size:11}} ],
			   	rowNum:100,
			   	rowList:[100,500,1000],
			   	autowidth : true,
			   	height : 320,
			   	pager: '#pmainPopup',
			   	sortname: 'dept_code',
			    viewrecords: true,
			    sortorder: "desc",
// 			    caption:"Employee List",
			    ondblClickRow: function(rowId) {
					var rowData = jQuery(this).getRowData(rowId); 
					var dept_code = rowData['dept_code'];
					var dept_name = rowData['dept_name'];
			
					var returnValue = new Array();
					returnValue[0] = dept_code;
					returnValue[1] = dept_name;
					window.returnValue = returnValue;
					self.close();
				},
				onSelectRow: function(row_id) {
					if(row_id != null)  {
						row_selected = row_id;
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
						} );
						this.updatepager(false, true);
					}
				}
			});
			
			$('#btncancle').click(function(){
				self.close();
			});
	
			$('#btnfind').click(function(){
				fn_search();
			});
	
			$('#btncheck').click(function() {
				var ret = jQuery("#mainPopup").getRowData(row_selected);
		
				var returnValue = new Array();
				returnValue[0] = ret.dept_code;
				returnValue[1] = ret.dept_name;
				window.returnValue = returnValue;
		
				self.close();
			} );
	
			function fn_search() {
				var sUrl = "infoItemStandardUploadDeptList.do";
				$( "#mainPopup" ).jqGrid( 'setGridParam', {
					url : sUrl,
					mtype : 'POST',
					page : 1,
					datatype: "json",
					postData : fn_getFormData( "#application_form" )
				} ).trigger("reloadGrid");
			}
			
		} ); //$(document).ready( function() {			
		
		</script>
	</body>
</html>
