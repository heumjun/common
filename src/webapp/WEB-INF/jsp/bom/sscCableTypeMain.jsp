<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Cable Type</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	body{overflow-x:hidden; width:100%; }
	.popupHeader{position:relative; width:98%; height:30px; margin-top:10px; }
	.popupHeader .searchArea{width:45%; float:left; height:30px;}	
	.popupHeader .buttonArea{width:55%; float:right; text-align:right}
	.popupHeader .buttonArea input{height:24px;}
	.popupHeader .seriesArea .appProject{color:#376091; font-weight:bold;}
	
	input[type=button] {width:70px;}
	input[type=text] {text-transform: uppercase;}
	.disableInput {background-color:#dedede}

</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" name="pageYn" value="" />
	
	<div class="mainDiv" id="mainDiv">	
		<div class="subtitle">
		CABLE TYPE
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
		</div>
		<table class="searchArea conSearch">
			<tr>
				<td>
					<div class="popupHeader">
						<div class="searchArea">
							약어 <input type="text" name="p_type_abbr" value="" style="width:120px" />
							품명 <input type="text" name="p_type_spec" value="" style="width:220px"/>
						</div>
						<div class="buttonArea">
							
							<input type="button" class="btn_blue2" value="Export" id="btnExport" />
 							<input type="button" class="btn_blue2" value="Form" id="btnForm" />
 							<input type="button" class="btn_blue2" value="Import" id="btnExlImp" style="margin-right:20px;"/>
							
							<input type="button" class="btn_blue2" value="Search" id="btnSearch"/>
							<input type="button" class="btn_blue2" value="Add" id="btnAdd"/>
							<input type="button" class="btn_blue2" value="Save" id="btnSave"/>
							<input type="button" class="btn_blue2" value="Close" id="btnClose"/>
						</div>
					</div>
				</td>
			</tr>
		</table>
		<div class="content">
			<table id="jqGridCableTypeMainList"></table>
			<div id="bottomJqGridCableTypeMainList"></div>
		</div>
	</div>
	<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
</form>	

<script type="text/javascript" >
	var idRow;
	var idCol;
	var kRow;
	var kCol;

	var jqGridObj = $("#jqGridCableTypeMainList");
	
	
	$(document).ready(function(){
		
		var gridColModel = new Array();
		
		gridColModel.push({label:'약어', name:'type_abbr', width:100, align:'left', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'품명', name:'type_spec', width:200, align:'left', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'규격', name:'type_type', width:40, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'단중', name:'type_weight', width:40, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'단면적', name:'type_area', width:60, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'Out Dia', name:'out_dia', width:40, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'표준 Drum', name:'drum_len', width:50, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'UOM', name:'uom', width:30, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'Bind Group', name:'bind_group', width:60, align:'center', sortable:true, title:false, editable:true} );
		gridColModel.push({label:'등록자', name:'user_name', width:50, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'생성일', name:'create_date', width:80, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'사용유무', name:'is_use', width:40, align:'center', sortable:true, title:false, hidden:true, editable:true} );
		gridColModel.push({label:'oper', name:'oper', width:40, align:'center', sortable:true, title:false, hidden:true} );
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:"sscCableTypeMainList.do",
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
            multiselect: false,
            shrinkToFit: true,
            height: 460,
            pager: '#bottomJqGridCableTypeMainList',
            rowList:[100,500,1000],
	        rowNum:100, 
	        recordtext: '내용 {0} - {1}, 전체 {2}',
       	    emptyrecords:'조회 내역 없음',
       	    afterSaveCell : chmResultEditEnd,
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
				jqGridObj.saveCell(kRow, idCol);
				
				if (rowid != null) {
					var ret = jqGridObj.getRowData(rowid);
					if (ret.oper != "I") {
						jqGridObj.jqGrid('setCell',rowid, 'type_abbr','','not-editable-cell');
						jqGridObj.jqGrid('setCell',rowid, 'type_weight','','not-editable-cell');
					}
				}
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, -35 );

		//Close 버튼 클릭.
		$("#btnClose").click(function(){
			self.close();
		});
		
		//Search 클릭
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			//Paging Setting
			$("input[name=p_is_excel]").val("N");
			$("input[name=pageYn]").val("N");
			
			var sUrl = "sscCableTypeMainList.do";
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		});


		//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
		$("#btnAdd").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
			
			var item = {};
			var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
			
			for ( var i in colModel ) {
				item[colModel[i].name] = '';
			}
			
			item.oper = 'I';

			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
			
		});
		
		//Del 버튼
		$("#btnDel").click(function(){
			fn_applyData(jqGridObj, change_item_row_num, change_item_col);

			var selrow = jqGridObj.jqGrid('getGridParam', 'selrow');
			var item = jqGridObj.jqGrid('getRowData', selrow);

			if (item.oper != 'I') {
				item.oper = 'D';
			}

			jqGridObj.jqGrid('delRowData', selrow);
			jqGridObj.resetSelection();
		});
		
		$("#btnForm").click(function(){
			//$.download('/ematrix/TBC/download/CableTypeExcelFormat.xls',null,'post' );
			$.download('fileDownload.do?fileName=CableTypeExcelFormat.xls',null,'post');
		});
		
		//Excel Import 클릭
		$("#btnExlImp").click(function(){		
			/* var sURL = "/ematrix/tbcCableTypeExcelImport.tbc";
			var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions); */
			
			var sURL = "popUpSscCableTypeExcelImport.do";
			var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
			
		});
		
		$("#btnSave").click(function(){

			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			jqGridObj.saveCell(kRow, idCol );
			
			if(confirm('저장하시겠습니까?')){
				var formData = fn_getFormData('#application_form');
				
				getGridChangedData(jqGridObj,function(data) {
					changeRows = data;
					
					if (changeRows.length == 0) {
						alert("변경 내용이 없습니다.");
						return;
					}
					
					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var parameters = $.extend({}, dataList, formData);
				
					$.post("/sscCableTypeSaveAction.do",parameters ,function(data){
						$(".loadingBoxArea").hide();
						alert(data.resultMsg);
						$("#btnSearch").click();
					},"json");
					
				});
			}
		});
		
		//Excel 버튼 클릭 시 
		$("#btnExport").click(function(){
					
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			for(var i=0; i<gridColModel.length; i++ ){
				if(gridColModel[i].name != "oper"){
					colName.push(gridColModel[i].label);
					dataName.push(gridColModel[i].name);
				}
			}
			
			form = $('#application_form');

			$("input[name=p_is_excel]").val("Y");
			//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
			form.attr("action", "sscCableTypeExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName);
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
		});
		
		
	});
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
		
	}
	
	
	
	
</script>
</body>

</html>