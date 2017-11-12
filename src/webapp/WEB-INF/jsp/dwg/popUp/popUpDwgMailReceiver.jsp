<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Mail Receiver</title>
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" style="width: 570px; padding-left: 13px;">
			<form id="application_form" name="application_form">
				<input type="hidden" name="h_ShipNo" id="h_ShipNo" value="<c:out value="${h_ShipNo}" />" />
				<input type="hidden" name="h_DwgNo" id="h_DwgNo" value="<c:out value="${h_DwgNo}" />" />
				<input type="hidden" name="dwg_rev" id="dwg_rev" value="<c:out value="${dwg_rev}" />" />
				<input type="hidden" name="shipNo" id="shipNo" value="<c:out value="${shipNo}" />" />
				<input type="hidden" name="userId" id="userId" value="${loginUser.user_id}" />
	
				<div style="height: 30px; padding: 10px 0; text-align: center; width: 100%; margin: 10px auto; border: 3px solid #e3e3e3;">
					<div style="margin: 3px 3px">
						<input type="button" name="btnAdd" id="btnAdd" value="ADD" class="btn_blue" />
						<input type="button" name="btnDel" id="btnDel" value="DELETE" class="btn_blue" />
						<input type="button" name="btnSearch" id="btnSearch" value="조회" class="btn_blue" />
						<input type="button" name="btnSaveGroup" id="btnSaveGroup" value="SAVE GROUP" class="btn_blue" />
						<input type="text" name="groupName" id="groupName" class="w200h25" />
					</div>
				</div>
				<div style="position:relative; float:left; width:250px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">작업 Stage</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="text" name="p_work_stage" id="p_work_stage" class="w100h25" />
					</div>
				</div>
				<div style="position:relative; float:left; width:250px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">작업 시점</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="text" name="p_work_time" id="p_work_time" class="w100h25" />
					</div>
				</div>
				<div style="position:relative; float:left; width:250px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">담당자</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="text" name="p_user_list" id="p_user_list" class="w100h25" />
					</div>
				</div>
				<div style="position:relative; float:left; width:250px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">원인 부서</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="hidden" name="causedeptcode" id="causedeptcode" />
						<input type="text" name="causedept" id="causedept" class="w100h25" />
						<input type="button" id="btnDept" name="btnDept" value="검색" class="btn_gray2" style="margin-left: -5px;" />
					</div>
				</div>
				<div style="position:relative; float:left; width:250px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">ITEM ECO No.</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="text" name="p_item_eco_no" id="p_item_eco_no" class="w100h25" />
					</div>
				</div>
				<div style="position:relative; float:left; width:250px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">ECR No.</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="text" name="p_ecr_no" id="p_ecr_no" class="w100h25" />
					</div>
				</div>
				<br />
				<div style="position:relative; float:left;height: 40px; margin-bottom: 17px;">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">내용</span>
						</div>
					</div>
					<div style="float: left;">
						<textarea name="description" id="description" rows="3" style="width: 350px;"></textarea>
					</div>
				</div>
				<div style="position:relative; float:left; width:500px; height: 30px; ">
					<div style="width: 100px; float: left;">
						<div style="margin: 5px 5px; text-align: left">
							<span class="pop_tit">개정 물량</span>
						</div>
					</div>
					<div style="float: left;">
						<input type="text" name="p_eco_ea" id="p_eco_ea" class="w100h25" style="width:350px;" />
					</div>
				</div>
				<div style="position:relative; float:left;" id="middleSeries" style="margin-top: 5px; height: 60px;">
					<div style="width:500px; text-align: center;">
						<input type="button" name="btnAddSearch" id="btnAddSearch" class="btn_blue" value="ADD Search" />
						<input type="button" name="btnAddGroup" id="btnAddGroup" class="btn_blue" value="ADD Group" />
						<input type="checkbox" name="chkHeader" id="chkHeader" value="" />Check Series All
					</div>
					<div style="width:500px; margin-top: 10px; text-align: center;">
						<c:if test="${listSize==0}">
							<input type="checkbox" class="chkboxItem" name="chkList" id="" value='<c:out value="${h_ShipNo}" />' />
							<c:out value="${h_ShipNo}" />
						</c:if>
						<c:forEach var="item" items="${selectSeriesProject}" varStatus="count">
							<input type="checkbox" class="chkboxItem" name="chkList" id="" value='<c:out value="${item.PROJECT_NO}" />' />
							<c:out value="${item.PROJECT_NO}" />
						</c:forEach>
					</div>
				</div>
				<div class="content" style="padding-top: 200px;">
					<table id="modifymailReceiverList"></table>
				</div>
				<br />
				<div style="float: right;">
					<input type="button" name="btnSave" id="btnSave" value="저장" class="btn_blue" />
					<input type="button" name="btnCancle" id="btnCancle" value="취소" class="btn_blue" />
				</div>
<%-- 				<jsp:include page="./tbc_CommonLoadingBox.jsp" flush="false"></jsp:include> --%>
			</form>
		</div>
		<script type="text/javascript">
		var fv_div_gbn = 0; //div(middleSeries) show/hide
		var resultData = [];
		var win = null;
		var winGroup = null;
		var change_row = 0;
		var change_row_num = 0;
		var change_col = 0;
		
		var loadingbox;

		$(document).ready( function() {
			$( "#middleSeries" ).hide();
			
			$( "#modifymailReceiverList" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'modifyMailReceiverList.do',
				postData : getFormData( '#application_form' ),
				editUrl : 'clientArray',
				colNames : [ '<input type="checkbox" id = "chkGridHeader" onclick="checkBoxHeader(event)" />', '호선', '사내외', '부서', '담당자', '메일주소', '구분', 'REV', '출력 날짜', 'emp_no', 'dept_id', 'DWG_PROJECT_NO' ],
				colModel : [ { name : 'chkcolumnbox', index : 'chkcolumnbox', width : 20, align : 'center', formatter : formatOpt1, sortable : false }, 
				             { name : 'project_no', index : 'project_no', width : 30, sortable : false }, 
				             { name : 'user_type', index : 'user_type', width : 20, sortable : false }, 
				             { name : 'print_dept_name', index : 'print_dept_name', width : 40, sortable : false }, 
				             { name : 'print_user_name', index : 'print_user_name', width : 40, sortable : false }, 
				             { name : 'email', index : 'email', width : 55, sortable : false }, 
				             { name : 'drawing_status', index : 'drawing_status', width : 40, editable : true, edittype : "select", formatoptions : { disabled : false }, editoptions : { value : "RE:RE;WK:WK" } }, 
				             { name : 'dwg_rev', index : 'dwg_rev', width : 30, sortable : false }, 
				             { name : 'print_date', index : 'print_date', width : 55, sortable : false }, 
				             { name : 'print_user_id', index : 'print_user_id', hidden : true, sortable : false }, 
				             { name : 'print_dept_id', index : 'print_dept_id', hidden : true, sortable : false }, 
				             { name : 'dwg_project_no', index : 'dwg_project_no', hidden : true, sortable : false } ],
				//multiselect: true,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				gridview : true,
				toolbar : [ false, "bottom" ],
				autowidth : true,
				height : 160,
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				rowNum : -1,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				loadComplete : function( data ) {
					var rows = $( "#modifymailReceiverList" ).getDataIDs();
					for( var i = 0; i < rows.length; i++ ) {
						var dwg_rev = $( "#modifymailReceiverList" ).getCell( rows[i], "dwg_rev" );
						var EMAIL = $( "#modifymailReceiverList" ).getCell( rows[i], "email" );

						if( EMAIL == "" || EMAIL == null || EMAIL == "@onestx.com" ) {
							$( "#modifymailReceiverList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', weightfont : 'bold', background : '#dddddd' } );
						}
					}
					getDescription();
				},
				onSelectRow : function( row_id ) {
					if( row_id != null ) {
						var ret = $( "#modifymailReceiverList" ).getRowData( row_id );
						if( ret.email == "" || ret.email == null || ret.email == "@onestx.com" ) {
							$( "#modifymailReceiverList" ).setSelection( row_id, false );
						}
					}
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					change_row = rowid;
					change_row_num = iRow;
					change_col = iCol;
				}
			} );
			
			
			$( "#btnDept" ).click( function() {
				var causedept = $("#causedept").val();

				var args = {
					causedept : causedept
				};

				var rs = window.showModalDialog( "./popUpDwgDeptView.do", 
						args,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

				if( rs != null ) {
					$( "#causedeptcode" ).val( rs[0] );
					$( "#causedept" ).val( rs[1] );
				}
			} );

			$( "#btnSearch" ).click( function() {
				fn_search();
			} );

			$( "#btnAddGroup" ).click( function() {
				if( ( $( ".chkboxItem" ).is( ":checked" ) ) ) {
					if( winGroup != null ) {
						winGroup.close();
					}
					
					winGroup = window.open( "./popUpDwgAddGroup.do",
							"popupDwgUserSearch",
							"height=560,width=600,top=200,left=900,location=no,scrollbars=no" );
				} else {
					alert( '전송될 Project기준을 선택해주세요' );
				}
			} );

			$( "#btnSaveGroup" ).click( function() {
				if( $( "#groupName" ).val() == '') {
					alert( 'Group 명을 지정하십시요.' );
					return;
				}

				var chmResultRows = [];
				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
// 					$( ".loadingBoxArea" ).show();
					loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					chmResultRows = data;
					var dataList = {
						chmResultList : JSON.stringify( chmResultRows )
					};
					
					var url = 'saveMailReceiverGroup.do';
					var formData = getFormData( '#application_form' );
					var parameters = $.extend({}, dataList, formData); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
					$.post( url, parameters, function( data ) {

						alert( data.resultMsg );

						if( data.result == "success" ) {
							//fn_search();
// 							if( winGroup != null ) {
// 								winGroup.getGroupList();
// 							}
						}
					} ).fail( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
// 						$( ".loadingBoxArea" ).hide();
						loadingBox.remove();
						$( '#modifymailReceiverList' ).resetSelection();
// 						$( "#groupName" ).val( "" );
					} );
				} );
			} );

			$( "#btnAddSearch" ).click( function() {
				if( ( $( ".chkboxItem" ).is( ":checked" ) ) ) {
					if( win != null ) {
						win.close();
					}
					
					win = window.open( "./popUpDwgUserSearch.do",
							"popupDwgUserSearch",
							"height=560,width=600,top=200,left=900,location=no,scrollbars=no" );
				} else {
					alert( '전송될 Project기준을 선택해주세요' );
				}
			} );

			$( "#btnAdd" ).click( function() {
				if( fv_div_gbn == 0 ) {
					fv_div_gbn = 1;
					$( "#middleSeries" ).show();
				} else {
					fv_div_gbn = 0;
					$( "#middleSeries" ).hide();
				}
			} );

			//Delete 버튼
			$( "#btnDel" ).click( function() {
				//가져온 배열중에서 필요한 배열만 골라내기 
				var chked_val = "";
				$( ":checkbox[name='checkbox']:checked" ).each( function( pi, po ) {
					chked_val += po.value + ",";
				} );

				var selarrrow = chked_val.split( ',' );
				if( selarrrow.length == 1 ) {
					alert( '삭제할 ROW를 CHECK 해주세요' );
					return;
				}

				for( var i = 0; i < selarrrow.length - 1; i++ ) {
					var selrow = selarrrow[i];
					var item = $( '#modifymailReceiverList' ).jqGrid( 'getRowData', selrow );

					$( '#modifymailReceiverList' ).jqGrid( 'delRowData', selrow );
				}
				$( '#modifymailReceiverList' ).resetSelection();
			} );

			$( "#chkHeader" ).click( function() {
				if( ( $( "#chkHeader" ).is( ":checked" ) ) ) {
					$( ".chkboxItem" ).prop( "checked", true );
				} else {
					$( "input.chkboxItem" ).prop( "checked", false );
				}
			} );
			
			$( "#btnCancle" ).click( function() {
				self.close();
			} );

			$( "#btnSave" ).click( function() {
				$( "#modifymailReceiverList" ).saveCell( change_row_num, change_col );
				if( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
					var chmResultRows = [];
					//변경된 row만 가져 오기 위한 함수
					getChangedChmResultData( function( data ) {
// 						$( ".loadingBoxArea" ).show();
						loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
						chmResultRows = data;
						var dataList = {
							chmResultList : JSON.stringify( chmResultRows )
						};
						var url = 'saveDWGMailReceiver.do';
						var formData = getFormData( '#application_form' );
						var parameters = $.extend( {}, dataList, formData ); //객체를 합치기. dataList를 기준으로 formData를 합친다. 
						$.post( url, parameters, function( data ) {
							alert( data.resultMsg );

							if( data.result == "success" ) {
								fn_search();
								self.close();
							}
						} ).fail( function() {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
// 							$( ".loadingBoxArea" ).hide();
							loadingBox.remove();
							$( '#modifymailReceiverList' ).resetSelection();
							opener.parentGridReload();
						} );
					} );
				}
			} );
		} ); //end of document ready
		
		//폼데이터를 Json Arry로 직렬화
		function getFormData( form ) {
			var unindexed_array = $( form ).serializeArray();
			var indexed_array = {};

			$.map( unindexed_array, function( n, i ) {
				indexed_array[n['name']] = n['value'];
			} );

			return indexed_array;
		}
		
		function getChangedChmResultData( callback ) {
			//가져온 배열중에서 필요한 배열만 골라내기 
			var chked_val = "";
			var item = new Array();
			$( ":checkbox[name='checkbox']:checked" ).each( function( pi, po ) {
				chked_val += po.value + ",";
			} );
			var selarrrow = chked_val.split( ',' );

			for( var i = 0; i < selarrrow.length - 1; i++ ) {
				item.push($( "#modifymailReceiverList" ).jqGrid( 'getRowData', selarrrow[i] ) );
			}
			callback.apply( this, [ item ] );
		}

		function formatOpt1( cellvalue, options, rowObject ) {
			var rowid = options.rowId;
			var eMail = rowObject.email;
			var item = $( '#modifymailReceiverList' ).jqGrid( 'getRowData', rowid );
			var str = "<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxcolumnItem' value="+rowid+" />";
			if( eMail == '' || eMail == null || eMail == "@onestx.com" ) {
				return "";
			} else {
				return str;
			}
		}

		//header checkbox action 
		function checkBoxHeader( e ) {
			e = e || event;/* get IE event ( not passed ) */
			e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기  
			if( ( $( "#chkGridHeader" ).is( ":checked" ) ) ) {
				$( ".chkboxcolumnItem" ).prop( "checked", true );
			} else {
				$( "input.chkboxcolumnItem" ).prop( "checked", false );
			}
		}

		function insertRow( selDatas ) {
			var chked_val = "";
			$( ":checkbox[name='chkList']:checked" ).each( function( pi, po ) {
				chked_val += "," + po.value;
			} );
			
			var projectNo = chked_val.split( ',' );
			var ids = $( '#modifymailReceiverList' ).getDataIDs();
			var email = selDatas.email;
			var userName = selDatas.print_user_name;
			for( var j = 1; j < projectNo.length; j++ ) {
				var isduplication = false;
				for( var i = 0; i < ids.length; i++ ) {
					var ret = $( "#modifymailReceiverList" ).getRowData( ids[i] );
					var grid_Mail = ret.email;
					var grid_shipNo = ret.project_no;
					if( grid_Mail == email && grid_shipNo == projectNo[j] && email != "@onestx.com") {
						//alert(projectNo[j]+'호선을 출력한 '+userName+'사원은 이미 지정되 있습니다.');
						isduplication = true;
						break;
					}
				}
				
				if( !isduplication ) {
					var nRandId = $.jgrid.randId();
					$( '#modifymailReceiverList' ).jqGrid('addRowData', nRandId, selDatas );
					$( "#modifymailReceiverList" ).jqGrid('setRowData', nRandId, { dwg_project_no : chked_val, project_no : projectNo[j], drawing_status : 'RE' } );
					if( email == "" || email == null || email == "@onestx.com" ) {
						$( "#modifymailReceiverList" ).jqGrid( 'setRowData', nRandId, false, { color : 'black', weightfont : 'bold', background : '#dddddd' } );
					}
				}
			}
		}

		function fn_search() {
			var sUrl = "modifyMailReceiverList.do";
			$( "#modifymailReceiverList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : getFormData( '#application_form' )
			} ).trigger( "reloadGrid" );
		}
		
		function getDescription() {
			url = "selectDWGEcoReceiver.do";
			
			var parameters = {
				h_ShipNo : $("#h_ShipNo").val(),
				h_DwgNo : $("#h_DwgNo").val(),
				dwg_rev : $("#dwg_rev").val(),
				shipNo : $("#shipNo").val()
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
			},"json" ).responseText;
		}
		</script>
	</body>
</html>