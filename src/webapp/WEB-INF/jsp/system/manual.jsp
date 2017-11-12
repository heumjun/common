<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>메뉴얼 관리</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<style>
			.conSearch input[type=text] {
				text-transform: none;
			}
			
			.searchArea input[type=text] {
				text-transform: none;
			}
		</style>
	</head>
	<body>
		<form id="application_form" name="application_form">
		<input type="hidden" name="loginId" id="loginId" value="${loginId}"/>
		<input type="hidden" name="delFlag" id="delFlag" value=""/>
		<input type="hidden" name="del_pgm_id" id="del_pgm_id" value=""/>
		<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			메뉴얼 관리
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
			<table class="searchArea conSearch">
			<col width="100"/>
			<col width="150"/>
			<col width="100"/>
			<col width="170"/>
			<col width="100"/>
			<col width="215"/>
			<col width="*"/>
			<tr>
			
				<th>분류</th>
				<td>
					<!-- <input type="text" id="p_manual_option" name="p_manual_option" class="commonInput" style="width:80px;" value="" alt="분류" /> -->
					<select id="p_manual_option" name="p_manual_option" style="width:120px;">
						<option value="">선택</option>
						<option value="MANUAL">MANUAL</option>
						<option value="양식지">양식지</option>
						<option value="기타양식지">기타양식지</option>
					</select>
				</td>
				
				<th>프로그램 명</th>
				<td>
				<input type="text" id="p_pgm_name" name="p_pgm_name" class="commonInput" style="width:140px;" value="" alt="프로그램 명" />
				</td>
				
				<th>DESCRIPTION</th>
				<td>
				<input type="text" id="p_description" name="p_description" class="commonInput" style="width:180px;" value="" alt="DESCRIPTION" />
				</td>
			
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
						<input type="button" class="btn_blue2" value="SAVE" id="btnSave"/>
					</div>
				</td>
				
			</tr>
			</table>
			
			<div id="divList" class="content" style="position:relative; float: left; width: 50%;">
				<table id="jqGridMainList"></table>
				<div id="bottomJqGridMainList"></div>
			</div>
			
			<div id="divDetailList" class="content" style="position:relative; float: right; width: 50%; ">
				<table id="jqGridDetailMainList"></table>
				<div id="bottomJqGridDetailMainList"></div>
			</div>
			
		</div>	
		</form>
		<script type="text/javascript">
		
		//그리드 사용 전역 변수
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var row_selected = 0;
		var resultData = [];
		var resultDetailData = [];
		var lodingBox;
		var lastsel;
		var tableId = '';
		
		var jqGridObj = $("#jqGridMainList");
		
		$(document).ready(function() {
			
			jqGridObj.jqGrid({ 
	            datatype: 'json',
	            url:'',
	            mtype : 'POST',
	            postData : fn_getFormData('#application_form'),
	            colModel: [ 
	                        { label:'분류', name:'manual_option', width:100, align:'center', sortable:true, title:false,  editable:true,
	                        	edittype : "select",
	                        	editoptions:{value:"MANUAL:MANUAL;양식지:양식지;기타양식지:기타양식지"}
	                        },
	                        { label:'프로그램ID', name:'pgm_id', width:200, align:'center', sortable:true, title:false, editrules:{custom:true,custom_func:mycheck}  },  
	                        { label:'프로그램명', name:'pgm_name', width:200, align:'center', sortable:true, title:false, editable:true}, 
	                        { label:'Manual Description', name:'description', width:320, align:'left', sortable:true, title:false,  editable:true}, 
	                        { label:'File Upload', name:'attach', width:80, align:'center', sortable:true, title:false, formatter: uploadFormatter},
	                        { label:'사용유무', name:'enable_flag', width:80, align:'center', editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, sortable : false},
	                        { label :'enable_flag_changed', name : 'enable_flag_changed', width : 25, hidden : false},
	                        { label:'OPER', name:'oper', width:25, align:'center', sortable:false, title:false, hidden: false}
	            		  ],
	            gridview: true,
	            viewrecords: true,
	            autowidth: true,
	            cellEdit : true,
	            cellsubmit : 'clientArray', // grid edit mode 2
				scroll : 1,
	            multiselect: false,
	            shrinkToFit: true,
	            pager: $("#bottomJqGridMainList"),
	            rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				rownumbers : true,
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
				editurl : "saveManual.do",
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        },
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					jqGridObj.saveCell(kRow, idCol );
					var rowIdx = kRow-1;
					
					var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
					
					var item = jqGridObj.getRowData(rowid);
					jqGridObj.setColProp('pgm_id',{editable:false});
					jqGridObj.setColProp('pgm_name',{editable:false});
					
					if(cm[iCol].name == 'pgm_id'){
						if(item.oper == 'I') {
							if(item.manual_option == 'MANUAL') {
								var rs = window.showModalDialog( "popUpProgramInfo.do", window, "dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
								if( rs != null ) {
									item.pgm_id = rs[0];
									item.pgm_name = rs[1];
									
									jqGridObj.jqGrid("setRowData", rowid, item);
								}
							} else {
								jqGridObj.setColProp('pgm_id',{editable:true});
							}
						} else {
							fn_detailSearch(item.pgm_id);
						}
					}
					
					if(cm[iCol].name == 'pgm_name'){
						if(item.oper == 'I') {
							if(item.manual_option != 'MANUAL') {
								jqGridObj.setColProp('pgm_name',{editable:true});
							}							
						} else {
							fn_detailSearch(item.pgm_id);
						}
					}
					
				}
	    	}); //end of jqGrid
	    	
	    	
	    	//그리드 버튼 숨김
			jqGridObj.jqGrid('navGrid', "#bottomJqGridMainList", {
					refresh : false,
					search : false,
					edit : false,
					add : false,
					del : false,								
				}
			);

			//Refresh
			jqGridObj.navButtonAdd('#bottomJqGridMainList', {
				caption : "",
				buttonicon : "ui-icon-refresh",
				onClickButton : function() {
					fn_search();
				},
				position : "first",
				title : "Refresh",
				cursor : "pointer"
			});
			
			//Del 버튼
			jqGridObj.navButtonAdd('#bottomJqGridMainList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "Del",
				cursor : "pointer"
			});

			//Add 버튼
			jqGridObj.navButtonAdd('#bottomJqGridMainList', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "Add",
				cursor : "pointer"
			});
			
			$("#jqGridDetailMainList").jqGrid({ 
	            datatype: 'json',
	            url:'',
	            mtype : 'POST',
	            postData : fn_getFormData('#application_form'),
	            colModel: [ 
							{ label:'PGM_ID', name:'pgm_id', width:100, align:'center', sortable:true, title:false, hidden:true },
	                        { label:'Rev. Description', name:'revision_desc', width:300, align:'center', sortable:true, title:false, editable:true }, 
	                        { label:'Rev.', name:'revision_no', width:60, align:'center', sortable:true, title:false }, 
	                        { label:'Date', name:'create_date', width:100, align:'center', sortable:true, title:false }, 
	                        { label:'첨부파일', name:'filename', width:50, align:'center', sortable:true, title:false, formatter: fileFormatter},
	                        { label:'첨부파일명', name:'filenameobj', width:50, align:'center', sortable:true, title:false, hidden: true}, 
	                        { label:'OPER', name:'oper', width:50, align:'center', sortable:false, title:false, hidden: false}
	            		  ],
	            gridview: true,
	            viewrecords: true,
	            autowidth: true,
	            cellEdit : true,
	            cellsubmit : 'clientArray', // grid edit mode 2
				scrollOffset : 17,
	            multiselect: false,
	            shrinkToFit: true,
	            //pager: $("#bottomJqGridDetailMainList"),
	            //rowList : [ 100, 500, 1000 ],
				rowNum : 99999,
				rownumbers : false,
		        recordtext: '내용 {0} - {1}, 전체 {2}',
	       	 	emptyrecords:'조회 내역 없음',
		       	 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
		         	idRow = rowid;
		         	idCol = iCol;
		         	kRow  = iRow;
		         	kCol  = iCol;
		         },
		        afterSaveCell : chmDetailResultEditEnd,
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
	    	
	    	//grid resize
		    fn_insideGridresize( $(window), $("#divList"), $("#jqGridMainList"), -474, .50);
		    fn_insideGridresize( $(window), $("#divDetailList"), $("#jqGridDetailMainList"), -500, .50);
			
			
			//조회 버튼
			$("#btnSearch").click(function() {
				fn_search();
			});

			//저장버튼
			$("#btnSave").click(function() {
				fn_save();
			});
			
		});
		
		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#jqGridMainList").jqGrid('getRowData'),
					function(obj) {
						return obj.oper == 'I' || obj.oper == 'U'
								|| obj.oper == 'D';
					});
			var changedDetailData = $.grep($("#jqGridDetailMainList").jqGrid('getRowData'),
					function(obj) {
						return obj.oper == 'I' || obj.oper == 'U'
								|| obj.oper == 'D';
					});

			callback.apply(this, [ changedData.concat(resultData), changedDetailData.concat(resultDetailData) ]);
		}

		//조회
		function fn_search() {

			jqGridObj.jqGrid("clearGridData");
			$("#jqGridDetailMainList").jqGrid("clearGridData");
			
			var sUrl = "manualList.do";
			jqGridObj.jqGrid('setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData("#application_form")
			}).trigger("reloadGrid");
			
			$("#delFlag").val("N");
		}
		
		//조회
		function fn_detailSearch(pgm_id) {

			$("#jqGridDetailMainList").jqGrid("clearGridData");
			
			var sUrl = "manualDetailList.do?p_pgm_id=" + encodeURIComponent(pgm_id);
			$("#jqGridDetailMainList").jqGrid('setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData("#application_form")
			}).trigger("reloadGrid");
		}

		//저장
		function fn_save() {
			$("#jqGridMainList").saveCell(kRow, idCol);
			$("#jqGridDetailMainList").saveCell(kRow, idCol);

			// 변경된 체크 박스가 있는지 체크한다.
			var changedData = $("#jqGridMainList").jqGrid('getRowData');
			var changedDetailData = $("#jqGridDetailMainList").jqGrid('getRowData');
			
			// 변경된 체크 박스가 있는지 체크한다.
			for (var i = 1; i < changedData.length + 1; i++) {
				var item = $('#jqGridMainList').jqGrid('getRowData', i);

				if (item.oper != 'I' && item.oper != 'U' && item.oper != 'D') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}

					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#jqGridMainList').jqGrid("setRowData", i, item);
					}
				}
			}
			
			// 변경된 체크 박스가 있는지 체크한다.
			/* for (var i = 1; i < changedDetailData.length + 1; i++) {
				var item = $('#jqGridDetailMainList').jqGrid('getRowData', i);
				
				if (item.oper != 'I' && item.oper != 'U' && item.oper != 'D') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}

					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#jqGridDetailMainList').jqGrid("setRowData", i, item);
					}
				}
			} */
			
			

			if (!fn_checkValidate()) {
				return;
			}

			if (confirm('변경된 데이터를 저장하시겠습니까?') != 0) {
				var chmResultRows = [];
				var chmDetailResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData(function(data, detailData) {
					lodingBox = new ajaxLoader($('#mainDiv'), {
						classOveride : 'blue-loader',
						bgColor : '#000',
						opacity : '0.3'
					});

					chmResultRows = data;
					chmDetailResultRows = detailData;
					var dataList = {
						chmResultList : JSON.stringify(chmResultRows),
						chmDetailResultList : JSON.stringify(chmDetailResultRows)
					};

					var url = 'saveManual.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend({}, dataList, formData);

					$.post(url, parameters, function(data) {
						
						if ( data.result == 'success' ) {
							
							if($("#delFlag").val() == "Y") {
								
								$.post("manualFileDelete.do", parameters, function(data) {
									
								}, "json").error(function() {
									alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
									return false;
								});
							} 
							
							alert(data.resultMsg);
							fn_search();
						}
					}, "json").error(function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
						lodingBox.remove();
					});
				});
				
				
			}
		}

		//필수입력 체크
		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $("#jqGridMainList").jqGrid('getDataIDs');
			var idsDetail = $("#jqGridDetailMainList").jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {
				var oper = jqGridObj.jqGrid('getCell', ids[i], 'oper');
				if (oper == 'I' || oper == 'U' || oper == 'D') {
					nChangedCnt++;

					var val1 = jqGridObj.jqGrid('getCell', ids[i], 'pgm_id');

					if ($.jgrid.isEmpty(val1)) {
						result = false;
						message = "프로그램ID Field is required";

						setErrorFocus("#jqGridMainList", ids[i], 0, 'pgm_id');
						break;
					}
				}
			}
			
			for (var i = 0; i < idsDetail.length; i++) {
				var oper = $("#jqGridDetailMainList").jqGrid('getCell', idsDetail[i], 'oper');
				if (oper == 'I' || oper == 'U' || oper == 'D') {
					nChangedCnt++;
				}
			}

			if (nChangedCnt == 0) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}

			if (!result) {
				alert(message);
			}

			return result;
		}

		//Del 버튼
		function deleteRow() {
			jqGridObj.saveCell(kRow, kCol);

			var selrow = jqGridObj.jqGrid('getGridParam', 'selrow');
			var item = jqGridObj.jqGrid('getRowData', selrow);
			
			if (item.oper == 'I') {
				jqGridObj.jqGrid('delRowData', selrow);
			} else {
				item.oper = 'D';

				$("#del_pgm_id").val(item.pgm_id);
				
				jqGridObj.jqGrid("setRowData", selrow, item);
				var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
				for( var i in colModel ) {
					jqGridObj.jqGrid( 'setCell', selrow, colModel[i].name,'', {background : '#FF7E9D' } );
				}
			}
			
			$("#delFlag").val("Y");

			jqGridObj.resetSelection();
		}

		//Add 버튼 
		function addChmResultRow() {

			jqGridObj.saveCell(kRow, idCol);

			var item = {};
			var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');

			for ( var i in colModel)
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.enable_flag = 'Y';

			jqGridObj.resetSelection();
			jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
			tableId = '#jqGridMainList';
			
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $("#jqGridMainList").jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';

			$("#jqGridMainList").jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");
		}
		
		function chmDetailResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $("#jqGridDetailMainList").jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';

			$("#jqGridDetailMainList").jqGrid("setRowData", irowId, item);
			$("input.editable,select.editable", this).attr("editable", "0");
		}

		//필수입력 표시
		function setErrorFocus(gridId, rowId, colId, colName) {
			$("#" + rowId + "_" + colName).focus();
			$(gridId).jqGrid('editCell', rowId, colId, true);
		}

		function cUpper(cObj) {
			cObj.value = cObj.value.toUpperCase();
		}
		
		function fileFormatter(cellvalue, options, rowObject ) {
			
			if(cellvalue == null) {
				return '';		
			} else {
				
				var fileExt = rowObject.filenameobj;
				//엑셀 파일 체크
				if( fileExt.indexOf(".pdf") < 0 ){
					return "<img src=\"./images/icon_file.gif\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"fileView('"+rowObject.revision_no+"','"+rowObject.pgm_id+"');\">";					
				}else{
					return "<img src=\"./images/icon_file.gif\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"hiddenFrame.go_fileView('/manualFileView.do?p_revision_no="+rowObject.revision_no+"&p_pgm_id="+rowObject.pgm_id+"','"+rowObject.filenameobj+"','${loginID}');\">";
				}
				
//				return "<a ondblclick=\"javascript:ecoNoClick('"+cellvalue+"')\">"+cellvalue+"</a>";
				
			}
		}
		
		function uploadFormatter(cellvalue, options, rowObject ) {
			return "<img src=\"./images/icon_upload.png\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"go_Add('"+rowObject.manual_option+"','" + rowObject.pgm_id + "','" + rowObject.oper +"')\">";
		}
		
		function go_Add(option, pgm_id, oper)
		{
		    var url = "popUpManualAttachAdd.do?";
		    url += "p_pgm_id="+pgm_id;
		    url += "&p_option="+option;
		    
		    if(oper == 'undefined' || oper == null) {
				window.open(url,"","width=520px,height=280px,top=300,left=400,resizable=no,scrollbars=auto,status=no");    
		    } else {
		    	alert("저장 후 등록 가능합니다.");
		    	return false;
		    }
		}
		
		function fileView(revision_no, pgm_id ) {
			var attURL = "manualFileView.do?";
		    attURL += "p_pgm_id="+pgm_id;
		    attURL += "&p_revision_no="+revision_no;
	
		    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
		    //window.showModalDialog(attURL,"",sProperties);
		    window.open(attURL,"",sProperties);
		    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
		}
		
		function mycheck(value, colname) {
			
			check = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
			if(check.test(value)) {
				return [false, "한글은 입력할 수 없습니다."];
			} else {
				return [true, ""];
			}
		}
		
		</script>
		
	</body>
</html>