<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>DWG Info</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" id="p_project_no" name="p_project_no" value="<c:out value="${p_project_no}"/>" />
			<input type="hidden" name="p_ship" value="<c:out value="${p_ship}"/>" />
			<input type="hidden" id="p_job_cd" name="p_job_cd" value="<c:out value="${p_job_cd}"/>" />
			<input type="hidden" id="p_dept_code" name="p_dept_code" value="<c:out value="${p_dept_code}"/>" />
			<input type="hidden" id="user_name" name="user_name" value="<c:out value="${loginUser.user_name}"/>" />
			
			<table class="searchArea conSearch">
			<col width="100"/>
			<col width="100"/>
			<col width="*"/>
			<tr>
			
			<th>DWG No.</th>
			<td>
			<input type="text" id="p_dwg_no" name="p_dwg_no" class="commonInput" style="width:80px;" value="${p_dwg_no}" alt="DWG NO." />
			</td>
			<td class=""  style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
				<input type="button" class="btn_blue2" value="APPLY" id="btnApply"/>
			</div>
			</td>
			
			</tr>
			</table>
			
			<div class="content">
				<table id="jqGridMainList"></table>
				<div id="bottomJqGridMainList"></div>
			</div>
		</form>
		<script type="text/javascript" src="/js/getGridColModelPENDING.js" charset='utf-8'></script>
		<script type="text/javascript">
		
		//그리드 사용 전역 변수
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var row_selected = 0;
		
		var gridColModel = getAddDwgGridColModel();
		var jqGridObj = $("#jqGridMainList");
		
		$(document).ready(function() {
			
			jqGridObj.jqGrid({ 
	            datatype: 'json',
	            url:'popupPendingAddGetDwgnoList.do',
	            mtype : 'POST',
	            postData : fn_getFormData('#application_form'),
	            colModel: gridColModel,
	            gridview: true,
	            viewrecords: true,
	            autowidth: true,
	            cellEdit : true,
	            cellsubmit : 'clientArray', // grid edit mode 2
				scrollOffset : 17,
	            multiselect: true,
	            shrinkToFit: false,
	            //pager: '#bottomJqGridMainList',
	            //rowList:[100,500,1000],
		        rowNum:99999,
		        recordtext: '내용 {0} - {1}, 전체 {2}',
	       	 	emptyrecords:'조회 내역 없음',
		       	 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
		         	idRow = rowid;
		         	idCol = iCol;
		         	kRow  = iRow;
		         	kCol  = iCol;
		         },
		        afterSaveCell : chmResultEditEnd,
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
	    	
	    	fn_gridresize( $(window), jqGridObj, -70);
	    	
	    	$( '#btnSearch' ).click( function() {
	    		//모두 대문자로 변환
	    		$("input[type=text]").each(function(){
	    			$(this).val($(this).val().toUpperCase());
	    		});
	    		
    			var sUrl = "popupPendingAddGetDwgnoList.do";
    			jqGridObj.jqGrid( "clearGridData" );
    			jqGridObj.jqGrid( 'setGridParam', {
    				url : sUrl,
    				mtype : 'POST',
    				datatype : 'json',
    				page : 1,
    				postData : fn_getFormData( "#application_form" )
    			} ).trigger( "reloadGrid" );
			});
	    	
	    	//Transfer 클릭
			$("#btnApply").click(function(){
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				
				//아이템 체크 Validation
				var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
				
				if(selarrrow == ""){
					alert("Please check item");
					return false;
				}
				
				var args = window.dialogArguments;
				var p_arr = new Array();
				var p_arrDistinct = new Array();
				
				//아이템 체크 Validation
	            var checkArr = args.jqGridObj.jqGrid('getGridParam', 'selarrrow');
				
				//add 메인에서 체크된 것 만큼 루프
				for(var i=0; i<selarrrow.length; i++) {
					
					var item1 = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
					var item = {};
					
					var stageArr = item1.stage_no.split(",");
					
					$(stageArr).each(function(idx){
						
						//selarrrow를 반복문 돌려서 각종 처리.
			            for(var i=0; i<checkArr.length; i++) {
			            	
			            	item.project_no = args.jqGridObj.getCell(checkArr[i], 'project_no');
			            	item.block_no = args.jqGridObj.getCell(checkArr[i], 'block_no');
			            	item.str_flag = args.jqGridObj.getCell(checkArr[i], 'str_flag');
			            	item.job_catalog = args.jqGridObj.getCell(checkArr[i], 'job_catalog');
			            	item.usc_job_type = args.jqGridObj.getCell(checkArr[i], 'usc_job_type');
			            	item.dwg_no = item1.dwg_no;
			            	item.stage_no = stageArr[idx];
			            	item.ship_type = args.jqGridObj.getCell(checkArr[i], 'ship_type');
							item.oper = 'I';
							args.jqGridObj.jqGrid('setCell', checkArr[i], 'mode', 'C');
							
							if(item.usc_job_type == null) {
								item.usc_job_type = 'NULL';
							}
							
							p_arr.push(item.project_no + "@" + item.block_no + "@" + item.str_flag + "@" + item.job_catalog + "@" 
									 + item.usc_job_type + "@" + item.dwg_no + "@" + item.stage_no + "@" + item.ship_type);
			            }
						
					});
					
				}
				
				
				$(p_arr).each(function(index, item) {
					if($.inArray(item, p_arrDistinct) == -1) {
						p_arrDistinct.push(item);
					}
				});
				
				
				$(p_arrDistinct).each(function(i) {
					var reccount = args.jqGridObj.find(">tbody>tr.jqgrow:last").attr("id").replace("jqg", "") * 1;
					var idx = reccount+1;
					
					var distinct = p_arrDistinct[i];
					var item = {};
					
					item.project_no = distinct.split("@")[0];
	            	item.block_no = distinct.split("@")[1];
	            	item.str_flag = distinct.split("@")[2];
	            	item.job_catalog = distinct.split("@")[3];
	            	item.usc_job_type = distinct.split("@")[4];
	            	item.dwg_no = distinct.split("@")[5];
	            	item.stage_no = distinct.split("@")[6];
	            	item.ship_type = distinct.split("@")[7];
					item.mode = 'D';
					item.oper = 'I';
					
					args.jqGridObj.resetSelection();
					args.jqGridObj.jqGrid( 'addRowData', idx, item, 'last' );
				});
				
				var arr = (''+args.jqGridObj.jqGrid("getDataIDs")).split(',');

				$(arr).each(function(i){
					if (args.jqGridObj.getCell(arr[i], 'mode') == "C") {
						args.jqGridObj.delRowData(arr[i]);
					}
					//args.jqGridObj.jqGrid('setCell', arr[i], 'mode', 'D');
				});
				
				
				self.close();
			});
	    	
			//key evant 
			$(".commonInput").keypress(function(event) {
			  if (event.which == 13) {
			        event.preventDefault();
			        $('#btnSearch').click();
			    }
			});
			
			
		});
		
		var callback = function(html){	
			var args = window.dialogArguments;
			args.ModifyPrint();
			args.$("#pendingDetail").html(args.$("#pendingDetail").html()+html);
			args.callback_detail();
		}
		
		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
			
			//입력 후 대문자로 변환
			jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
			
		}
		
		</script>
	</body>
</html>
