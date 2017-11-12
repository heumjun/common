<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
		<title>결재라인 지정</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" style="display:block; float:none;">
			<form id="application_form" name="application_form">
				<% String strNoti = request.getParameter("noti") == null ? "" : request.getParameter("noti").toString(); %>
				<% String strMaincode = request.getParameter("maincode") == null ? "" : request.getParameter("maincode").toString(); %>
				
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				
				<input type="hidden" id="inoti" name="inoti" value="<%=strNoti%>" /><!--  ECO release notification 일 경우 저장 되도록 설정 -->
				<input type="hidden" name="main_code" id="main_code" value="<%=strMaincode%>">
				<input type="hidden" id="sType" name="sType" value="ECR" />
				<input type="hidden" id="pageYn" name="pageYn" value="N">
				<input type="hidden" id="saveDel" name="saveDel" value="save" />
				<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
					<div class="conSearch">
						<select name="sel_condition" id="sel_condition" class="h25">
							<option value="empname" selected="selected">이름</option>
							<option value="empno">사번</option>
							<option value="deptname">부서</option>
						</select>
						<input type="text" class="" id="txt_condition" name="txt_condition" style="text-transform: uppercase; width: 100px; height:25px; ime-mode:active;" />
					</div>
					<div class="button">
						<input type="text" name="groupName" id="groupName" class="w100h25" />	
						<input type="button" name="btnSaveGroup" id="btnSaveGroup" value="SAVE Group" class="btn_blue" />	
						<input type="button" name="btnAddGroup" id="btnAddGroup" value="ADD Group" class="btn_blue"  />		
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;					
						<input type="button" id="btnfind" value=" 조 회 "  class="btn_blue"/>
						<input type="button" id="btncheck" value=" 확 인 " class="btn_blue"/>				
						<input type="button" id="btncancel" value=" 닫 기 "  class="btn_blue"/>
					</div>
					<div class="button">

					</div>					
											
						
				</div>
				<div class="content"  style="position:relative; float: left; width: 380px;">
					<table id="grdEmpList"></table>
					<div id="pgrdEmpList"></div>
				</div>
				<div class="content"  style="position:relative; float: left; width: 50px; text-align: center;">
					<br /><br /><br /><br /><br /><br /><br /><br />
					<input type="button" id="btnEntryAdd" value="&gt;&gt;" title="추가" class="btn_gray2"/>
					<br /><br />
					<input type="button" id="btnEntryDel" value="&lt;&lt;" title="제외"  class="btn_gray2"/>
				</div>
				<div class="content"  style="position:relative; float: left; width: 380px;">
					<table id="grdEmpList2"></table>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		 
			var winGroup = null;
			
			var inoti = $('#inoti').val();
			
			if(inoti == "NOTIFI"){
				document.title = '확정통보 담당자 지정';
			} else {
				$("#groupName").hide();
				$("#btnSaveGroup").hide();
				$("#btnAddGroup").hide();
			}

		
			var row_selected;
			
			$(document).ready( function() {
				fn_all_text_upper();
				//엔터 버튼 클릭
				$(":text").keypress(function(event) {
				  if (event.which == 13) {
				        event.preventDefault();
				        $('#btnfind').click();
				    }
				});
				$("#grdEmpList").jqGrid( {
					datatype : 'json',
					mtype : 'POST',
					//url : 'mainPopupSearchList.do?sType=EmpNo',
					//editurl:'saveCatalogMgnt.do',
					editUrl : 'clientArray',
					//cellSubmit: 'clientArray',
					colNames : [ '선택', '사번', '이름', '직급', '부서' ],
					colModel : [
						{ name : 'enable_flag',	index : 'enable_flag', width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
		            	{ name : 'emp_no', index : 'emp_no', width : 50, editable : true, align : "center", editrules : { required : true }, editoptions : { size : 5 } },
		            	{ name : 'user_name', index : 'user_name', width : 50, editable : true, align : "center", editoptions : { size : 11 } },
		            	{ name : 'position_name', index : 'position_name', width : 50, editable : true, editoptions : { size : 11 } },
		            	{ name : 'dept_name', index : 'dept_name', width : 90, editable : true, editoptions : { size : 11 } } ],
					gridview : true,
					cmTemplate: { title: false },
					toolbar : [ false, "bottom" ],
					viewrecords : true,
					autowidth : true,
					height : 320,
					rowList:[500,1000,5000],
					rowNum:500,
					emptyrecords : '데이터가 존재하지 않습니다. ',
					pager : jQuery('#pgrdEmpList'),
// 					pgbuttons : false,
// 					pgtext : false,
// 					pginput : false,
					jsonReader : {
						root : "rows",
						page : "page",
						total : "total",
						records : "records",
						repeatitems : false,
					},
					imgpath : 'themes/basic/images',
					ondblClickRow : function( rowId ) {
						//Comment by hs lee
						//더블클릭 이벤트 사용 안함.
						//더블클릭 이벤트 필요시 풀것.
// 						var rowData = jQuery(this).getRowData( rowId );
// 						var emp_no = rowData['emp_no'];
// 						var user_name = rowData['user_name'];
	
// 						var returnValue = new Array();
// 						returnValue[0] = emp_no;
// 						returnValue[1] = user_name;
// 						window.returnValue = returnValue;
// 						self.close();
					},
					onSelectRow : function( row_id ) {
						if ( row_id != null ) {
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
				} );
				
				$("#grdEmpList2").jqGrid( {
					datatype : 'json',
					mtype : 'POST',
					postData : getFormData("#application_form"),
					url : 'getStatesReqList.do',
					colNames : [ '사번', '이름', '직급', '부서' ],
					colModel : [
		            	{ name : 'emp_no', index : 'emp_no', width : 70, editable : false, editrules : { required : true }, editoptions : { size : 5 } },
		            	{ name : 'user_name', index : 'user_name', width : 50, editable : false, editoptions : { size : 11 } },
		            	{ name : 'position_name', index : 'position_name', width : 90, editable : false, editoptions : { size : 11 } },
		            	{ name : 'dept_name', index : 'dept_name', width : 90, editable : false, editoptions : { size : 11 } } ],
					gridview : true,
					toolbar : [ false, "bottom" ],
					viewrecords : true,
					autowidth : true,
					height : 320,
					pager : jQuery('#pmainPopupSearchList'),
					pgbuttons : false,
					pgtext : false,
					pginput : false,
					imgpath : 'themes/basic/images'
				} ).jqGrid('sortableRows');
	
				$( '#btncancel' ).click( function() {
					self.close();
				} );
	
				$( '#btnfind' ).click( function() {
					fn_search();
				} );
	
				$('#application_form').ajaxForm({
			                // 반환할 데이터의 타입. 'json'으로 하면 IE 에서만 제대로 동작하고 크롬, FF에서는 응답을 수신하지
			                // 못하는 문제점을 발견하였다. dataType을 정의하지 않을 경우 기본 값은 null 이다.
			        dataType : 'text', 
					beforeSerialize: function() {
						// form을 직렬화하기전 엘레먼트의 속성을 수정할 수도 있다.
					},
					beforeSubmit : function() {
						$('#result').html('uploading...');
					},
					success : function(data) {
						// 크롬, FF에서 반환되는 데이터(String)에는 pre 태그가 쌓여있으므로
						// 정규식으로 태그 제거. IE의 경우 정상적으로 값이 반환된다.
						//data = data.replace(/[<][^>]*[>]/gi, '');
						
						// JSON 객체로 변환
						//var jData = JSON.parse(data);
						
						
						if(inoti == "NOTIFI"){
							opener.fn_search();
							self.close();
						}
						//$('#result').html('Success - ' + jData.result);
					}
				});
	
				$( '#btncheck' ).click( function() {
					
					var k = 0;
					var seqNo = 99;
					
					var allData = $("#grdEmpList2").jqGrid('getRowData');
					var isFirst = true;
					var comma = ",";
					var separator = " | ";
					var empNoList = "";
					var empNameList = "";
					
					for( var i = 1; i < allData.length + 1; i++ ) {
						
						if(inoti == "NOTIFI"){
							//strJsonContent = item.emp_no+'|'+strJsonContent; // eco release notification
						}else{ //eco의 notifi가 아닌경우
							if( isFirst ) {
								isFirst = false;
								empNoList = allData[k].emp_no;
								empNameList = allData[k].emp_no + "(" + allData[k].user_name + ", " + allData[k].dept_name + ")";
								
								
							} else {
								empNoList += separator + allData[k].emp_no;
								empNameList += "\r\n" + allData[k].emp_no + "(" + allData[k].user_name + ", " + allData[k].dept_name + ")";
							}
						}
						
						k++;
						seqNo--;
					}
					
					if(inoti == "NOTIFI"){ // eco release notification로 저장
						
						var chmResultRows = [];
						chmResultRows = allData;
													
						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
						
						if( chmResultRows.length == 0 ) {
							alert( "추가할 확정통보담당자를 우측으로 보내주세요." );
							return;
						}
						
						var url = 'saveReleaseNotificationResults.do';
						var formData = getFormData( '#application_form' );
						var parameters = $.extend( {}, dataList, formData );

						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								var returnValue = 'ok';
								window.returnValue = returnValue;
								self.close();
							}
						
			
			
						}, "json" ).error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
					    	lodingBox.remove();	
						} );
		
						
					} else { //eco의 notifi가 아닌경우
						var returnValue = new Array();
						returnValue[0] = empNoList;
						if(empNameList != "" && empNameList.length > 0) {
							returnValue[1] = empNameList;
						} else {
							returnValue[1] = "없음";
						}
						window.returnValue = returnValue;
						
						self.close();
					}
					
				} );
				
				
				
				
				
				$( "#btnEntryAdd" ).click( function() {
					var lastId = 1;
					
					var allData = $("#grdEmpList").jqGrid('getRowData');
					var desData = $("#grdEmpList2").jqGrid('getRowData');

					if( desData.length == 0 ) {
						
						// 변경된 체크 박스가 있는지 체크한다.
						for( var i = 1; i < allData.length + 1; i++ ) {
							var item = $('#grdEmpList').jqGrid('getRowData',i);
							
							if(item.enable_flag == "Y"){
								
								if ($("#grdEmpList2").getDataIDs().length > 0) {
									lastId = parseInt($("#grdEmpList2").getDataIDs().length) + 1;
								}
								
								$("#grdEmpList2").jqGrid("addRowData", lastId, item, "last");
							}
						}
						
					} else {
						
						// 변경된 체크 박스가 있는지 체크한다.
						for( var i = 1; i < allData.length + 1; i++ ) {
							var isExist = false;
							var existEmpno = "";
							var item = $('#grdEmpList').jqGrid('getRowData',i);
							var item2 = null;
							if(item.enable_flag == "Y"){
								
								for( var j = 1; j < desData.length + 1; j++ ) {
									item2 = $('#grdEmpList2').jqGrid('getRowData',j);
									
									if(item2.emp_no == item.emp_no) {
										isExist = true;
										existEmpno = item2.emp_no;
									}
									
								}	
								
								if( isExist ) {
									alert( "선택한 사번 : " + existEmpno + "는 이미 추가되어있습니다." );
								} else {
									if ($("#grdEmpList2").getDataIDs().length > 0) {
										lastId = parseInt($("#grdEmpList2").getDataIDs().length) + 1;
									}
									
									$("#grdEmpList2").jqGrid("addRowData", lastId, item, "last");
								}
							}
						}
					}
					
					/*checkbox 해제*/
				} );
				
				$( "#btnEntryDel" ).click( function() {
					var rowid = $("#grdEmpList2").jqGrid('getGridParam', 'selrow');
					$('#grdEmpList2').jqGrid('delRowData',rowid);
					$('#grdEmpList2').resetSelection();
					
				} );
				
				//nav button area set width 0 
				$("#pgrdEmpList_left").css("width", 0);
				
				
				//SAVE GROUP
				$( "#btnSaveGroup" ).click( function() {
					if( $( "#groupName" ).val() == '') {
						alert( 'Group 명을 지정하십시요.' );
						return;
					}
					
					var desData = $("#grdEmpList2").jqGrid('getRowData');

					if( desData.length == 0 ) {	
						alert( 'Group 지정할 확정통보담당자를 우측으로 보내주세요.');
						return;
					}
					
					var chmResultRows = [];
					chmResultRows = desData;					
					
					var dataList = { chmResultList:JSON.stringify( chmResultRows ) };

					
					var url = 'saveEcoReleaseNotificationGroup.do';
					var formData = getFormData( '#application_form' );
					var parameters = $.extend( {}, dataList, formData );
					
					if(confirm('우측의 인원을 그룹으로 지정하시겠습니까?'))
					{
						$.post( url, parameters, function( data ) {
							//loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } )
							alert(data.resultMsg);
							if ( data.result == 'success' ) {							
								//var returnValue = 'ok';
								//window.returnValue = returnValue;
								//self.close();
							}
			
						}, "json" ).error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
							loadingBox.remove();	
						} );
					}

				} );		
				
				// ADD GROUP
				$( "#btnAddGroup" ).click( function() {
					if( winGroup != null ) {
						winGroup.close();
					}
					
					winGroup = window.open( "popUpAddEcoReleaseNotificationGroup.do",
							"popupEcoReleaseNotificationGroupSearch",
							"height=560,width=600,top=200,left=900,location=no,scrollbars=no" );
				} );				
				
			} );
		
			
			
			function fn_search() {
				var sUrl = "popUpApproveEmpNoList.do?sType=EmpNo";
				jQuery("#grdEmpList").jqGrid('setGridParam', {
					url : sUrl,					
					page : 1,
					datatype: "json",
					postData : getFormData("#application_form")
				} ).trigger("reloadGrid");
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
			

			function insertRow( selDatas ) {
				var ids = $( '#grdEmpList2' ).getDataIDs();
				var emp_no = selDatas.emp_no;
				var userName = selDatas.user_name;
				
				var isduplication = false;
				for( var i = 0; i < ids.length; i++ ) {
					var ret = $( "#grdEmpList2" ).getRowData( ids[i] );
					var grid_emp_no = ret.emp_no;					
					if( grid_emp_no == emp_no) {
						isduplication = true;
						break;
					}
				}
				
				if( !isduplication ) {
					var nRandId = $.jgrid.randId();
					$( '#grdEmpList2' ).jqGrid('addRowData', nRandId, selDatas );
				}
				
			}			
		</script>
	</body>
</html>
