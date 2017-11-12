<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>dts System</title>
		<style>
			.fontType {color:#324877;
					font-weight:bold; 
					 }
			input[type=text] {text-transform: uppercase;}
		</style>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" name="h_ShipNo" id="h_ShipNo" />
				<input type="hidden" name="h_DwgNo" id="h_DwgNo" />
				<input type="hidden" name="dwg_seq_id" id="dwg_seq_id" />
				<input type="hidden" name="deptNo" id="deptNo" />
				<input type="hidden" name="dwg_rev" id="dwg_rev" />
				<input type="hidden" name="h_state" id="h_state" />
				<input type="hidden" name="h_returnChk" id="h_returnChk" />
				<input type="hidden" name="organization_id" id="organization_id" />
				<input type="hidden" name="pageYn" id="pageYn" value="N" />
				<input type="hidden" name="del_dwg_seq_id" id="del_dwg_seq_id" />
				<input type="hidden" name="required_user" id="required_user" />
				<input type="hidden" name="loginid" id="loginid" value="${loginUser.user_id}" />
				<input type="hidden" id="GrCode" name="GrCode" value="${loginUser.gr_code}"/>
				<input type="hidden" id="DpGubun" name="DpGubun" value="${loginUser.dp_gubun}"/>
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				
				<div class="subtitle">
					DTS SYSTEM
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
				</div>
				<div id="top">
					<table class="searchArea conSearch">
						<col width="980">
						<col width="*">
						<tr>
						<td class="fontType" style="border-right: none;">
							<select id="p_deptGubun" name="p_deptGubun">
								<option value="S">상선</option>
								<option value="N">특수선</option>
							</select>
							&nbsp;
							부서
							<input type="text" id="dept" name="dept" readonly value="${loginUser.dwg_dept_code}" style="width: 40px; background: #dddddd; color: black;" />
							<input type="text" id="deptName" name="deptName" readonly value="${loginUser.dwg_dept_name}" style="margin-left: -5px; width: 70px; background: #dddddd; color: black;" />
							&nbsp;
							호선
							<input type="text" class="required" id="shipNo" name="shipNo" value="${shipNo }" style="width: 40px; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							<input type="button" id="btnmain" name="btnmain" value="검색" class="btn_gray2" />
							&nbsp;
							DWG
							<input type="text" class="textBox" id="dwgNo" name="dwgNo" value="${dwgNo}" style="width: 40px; text-transform: uppercase;" onchange="onlyUpperCase(this); " />
							<input type="text" class="textBox" id="blockNo" name="blockNo" value="${blockNo}" style="margin-left: -5px; width: 25px; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							<input type="button" id="btndwgNo" name="btndwgNo" value="검색" class="btn_gray2" />
							&nbsp;
							REV
							<input type="text" class="textBox" id="revNo" name="revNo" value="" maxlength="2" style="width: 25px;" />
							&nbsp;
							STATE
							<select id="state" name="state" class="wid85">
								<option value="ALL">ALL</option>
								<option value="PP">Preliminary</option>
								<option value="SS">Request</option>
								<option value="RR">Return</option>
								<option value="YY">Release</option>
							</select>
							&nbsp;
							사용자
							<input type="text" class="textBox" id="p_user_name" name="p_user_name" value="" style="width: 40px; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							&nbsp;
							DESCRIPTION
							<input type="text" class="textBox  wid70" id="p_description" name="p_description" value="" style="width: 90px; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							&nbsp;
							<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" value="조회" id="btnSearch" class="btn_blue" />
							</c:if>
						</td>
						<td class="fontType" style="border-left: none;" >
						<div class="button endbox" >
							요청자
							<select class="wid95" name="userList" id="userList"></select>
							&nbsp;
							승인자
							<input type="text" class="textBox" readonly id="grantor" name="grantor" style="width: 45px; background: #dddddd; color: black;" />
							<input type="text" class="textBox" readonly id="grantorName" name="grantorName" style="width: 40px; margin-left: -4px; background: #dddddd; color: black;" />
							<input type="button" id="btnGrantor" name="btnGrantor" value="검색" class="btn_gray2" />
							&nbsp;
							<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnRequired" name="btnRequired" class="btn_blue" value="요청" />
							</c:if>
						</div>
						</td>
						</tr>
					</table>
				</div>
				<div id="center" class="content">
					<div id="dwgSearchListDiv" style="float: left; width: 25%; max-width: 25%;">
						<table id="dwgSearchList"></table>
						<div id="btndwgSearchList"></div>
					</div>
					<div id="tabs_body" style="float: right; width: 74%;" >
						<div id="tabs">
							<ul>
								<li><a href="#tabs-1">INFORMATION</a></li>
								<li><a href="#tabs-2">MAIL RECEIVER</a></li>
							</ul>
							<div id="tabs-1">
								<iframe id="information" name="information" src="dwgInformation.do" 
									frameborder=0 marginwidth=0 marginheight=0 scrolling=no width="100%" style="border-width: 0px; border-color: white;" ></iframe>
							</div>
							<div id="tabs-2">
								<iframe id="dwgMailReceiver" name="dwgMailReceiver" src="dwgMailReceiver.do" 
									frameborder=0 marginwidth=0 marginheight=0 scrolling=no width="100%" style="border-width: 0px; border-color: white;" ></iframe>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</body>
	<script type="text/javascript">
	$( function() {
		$( "#tabs" ).tabs(); //탭이동
	} );
	var lodingBox;
	var tableId = '';
	var resultData = [];
	var delRowList = new Array();
	var delDwgList = new Array();
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var cmtypedesc;
	var kRow = 0;
	var kCol = 0;
	var row_selected = 0;

	$(document).ready( function() {
		$(window).bind('resize', function() {
			$("#tabs").css({'height':  $(window).height()-136});
			$("#information").css({'height':  $(window).height()-136});
			$("#dwgMailReceiver").css({'height':  $(window).height()-136});
		}).trigger('resize');
		
		var objectHeight = gridObjectHeight(2);
		
		$( "#dwgSearchList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : [ '<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', '호선', '도면', 'REV', 'STATE', '사용자', 'DESCRIPTION', 'dept_name', 'radioChk', 'is_YN', 'returnChk' ],
			colModel : [ { name : 'trans_plm', index : 'trans_plm', width : 20, align : 'center', formatter : formatOpt1, sortable : false }, 
			             { name : 'shp_no', index : 'shp_no', width : 40, align : 'center' }, 
			             { name : 'dwg_no', index : 'dwg_no', width : 85, align : 'center' }, 
			             { name : 'dwg_rev', index : 'dwg_rev', width : 30, align : 'center' }, 
			             { name : 'state', index : 'state', width : 72, classes : 'handcursor' }, 
			             { name : 'user_name', index : 'user_name', width : 52 }, 
			             { name : 'description', index : 'description', width : 110 }, 
			             { name : 'dept_name', index : 'dept_name', hidden : true }, 
			             { name : 'radioChk', index : 'radioChk', hidden : true }, 
			             { name : 'is_yn', index : 'is_yn', width : 10, hidden : true }, 
			             { name : 'returnChk', index : 'returnChk', width : 10, hidden : true } ],
			gridview : true,
			toolbar : [ false, "bottom" ],
			viewrecords : false,
			autowidth : true,
			shrinkToFit : false,
			rownumbers : true,
			//height: screen.height * 0.65,
			height : objectHeight,
			pager : $( '#btndwgSearchList' ),
			rowList : [ 100, 500, 1000 ],
			rowNum : 100,
			cellEdit : true, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
				idRow = rowid;
				idCol = iCol;
				kRow = iRow;
				kCol = iCol;
			},
			onPaging : function( pgButton ) {
				/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
				 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
				 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
				 */
				$(this).jqGrid( "clearGridData" );

				/* this is to make the grid to fetch data from server on page click*/
				$(this).setGridParam( {
					datatype : 'json',
					postData : {
						pageYn : 'Y'
					}
				} ).triggerHandler( "reloadGrid" );
			},
			loadComplete : function(data) {
				var $this = $(this);
				if ( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
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
			gridComplete : function() {
				organization();
			},
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			imgpath : 'themes/basic/images',
			onCellSelect : function( rowid, icol, cellcontent, e ) {
				row_selected = rowid;
				if (icol == 5) {
					removeDwgList(rowid);

					var item = $( '#dwgSearchList' ).jqGrid( 'getRowData', rowid );
					var shp_no = item.shp_no;
					var dwg_no = item.dwg_no;
					var dwg_rev = item.dwg_rev;
					var radioChk = item.radioChk;
					var state = item.state;
					var returnChk = item.returnChk;
					$("#h_ShipNo").val(shp_no);
					$("#h_DwgNo").val(dwg_no);
					$("#dwg_rev").val(dwg_rev);
					$("#h_state").val(state);
					$("#h_returnChk").val( returnChk );

					var ifra = document.getElementById('information').contentWindow;
					ifra.searchInfo(returnChk);

					var ifra2 = document.getElementById('dwgMailReceiver').contentWindow;
					ifra2.searchDWG(radioChk);
				}
			}
			
		} );

		//userList 가져오기
		getUserList();
		
		$("#btnmain").click( function() {
			var rs = window.showModalDialog( "popUpDPShipList.do",
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
			
			if( rs != null ) {
				$("#shipNo").val(rs[0]);
			}
		} );

		$("#btnGrantor").click( function() {
			var dept = $("#dept").val();

			var args = {
				dept : dept
			};
			
			var rs = window.showModalDialog( "popUpDwgGrantorList.do",
					args,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

			if( rs != null ) {
				$("#grantor").val(rs[0]);
				$("#grantorName").val(rs[1]);
			}
		} );

		$("#btndwgNo").click( function() {
			var dept = $("#dept").val();
			var shipNo = $("#shipNo").val();
			var dwgNo = $("#dwgNo").val();
			var blockNo = $("#blockNo").val();
			var dwg_no = dwgNo + blockNo;

			var args = {
				dept : dept,
				shipNo : shipNo,
				dwgNo : dwgNo,
				blockNo : blockNo,
				dwg_no : dwg_no
			};

			var rs = window.showModalDialog( "popUpDPDwgList.do",
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
			
			if( rs != null ) {
				$("#dwgNo").val(rs[0]);
				$("#blockNo").val(rs[1]);
			}
		} );
		
		//조회 버튼
		$("#btnSearch").click( function() {
			var shipNo = $("input[name=shipNo]").val();
			if (shipNo == "") {
				alert("호선을 입력해주세요");
				return;
			}
			fn_search();

			//grid 초기화
			var ifra = document.getElementById('information').contentWindow;
			ifra.resetGrid();
			
			var ifra2 = document.getElementById('dwgMailReceiver').contentWindow;
			ifra2.resetGrid();
		} );
		
		//요청버튼
		$("#btnRequired").click( function() {
			$("#del_dwg_seq_id").val(delDwgList);
			var user = $("#userList").val();
			var grantor = $("#grantor").val();

			if (user == '' || user == null) {
				alert('요청자를 선택해 주세요');
				return;
			}
			if (grantor == '' || grantor == null) {
				alert('승인자를 선택해 주세요');
				return;
			}

			var chklength = $('input:checkbox[class="chkboxItem"]:checked').length;
			if (chklength == 0) {
				alert('요청할 도면을 선택해주세요');
				return;
			}
			//mailreceiver check
			var chmResultRows = [];

			getChangedChmResultData(function(data) { //변경된 row만 가져 오기 위한 함수
				lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
				chmResultRows = data;
				var dataList = {
					chmResultList : JSON.stringify(chmResultRows)
				};

				var url = 'dwgReceiverCheck.do';
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend({}, dataList, formData); //객체를 합치기. dataList를 기준으로 formData를 합친다.
				$.post(url, parameters, function(data) {
					var dwg_no = data.dwg_no;
					//data = data.replace("\r\n","");
					if (data.result == "success") {
						if (confirm('선택한 도면을 요청하시겠습니까?') != 0) {
							var chmResultRows = [];
							getChangedChmResultData(function(data) { //변경된 row만 가져 오기 위한 함수
								chmResultRows = data;
								var dataList = {
									chmResultList : JSON.stringify(chmResultRows)
								};
								var url = 'requiredDWG.do';
								var formData = fn_getFormData( '#application_form' );
								var parameters = $.extend({}, dataList, formData); //객체를 합치기. dataList를 기준으로 formData를 합친다.
								$.post(url, parameters, function(data) {
									alert(data.resultMsg);

									if (data.result == "success") {
										fn_search();
									}
								}).fail(function() {
									alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
								}).always(function() {
									lodingBox.remove();	
								});
							});
						} else {
							lodingBox.remove();	
						}
					} else {
						alert(dwg_no + " 도면은 Receiver 지정이 필요합니다.");
						lodingBox.remove();	
					}
				});
			});
			
		} );
		
		$("#p_deptGubun").change( function () {
			var url = "selectDwgDeptCode.do";
			var parameters = fn_getFormData( '#application_form' );
			$.post(url, parameters, function(data) {
				if(data != null){
					var dwgdeptnm 		= data[0].dwgdeptnm;
					var dwgdeptcode 	= data[0].dwgdeptcode;
					$("#deptName").val(dwgdeptnm);
					$("#dept").val(dwgdeptcode);
				}
			}, "json" );
			
// 			$.post(url, parameters, function( data ) {
// 				var dwgdeptnm = "";
// 				var dwgdeptcode = "";
// 				if( data.length != 0 ) {
// 					for( var keys in data ) {
// 						for( var key in data[keys] ) {
// 							if( key == 'dwgdeptnm' ) {
// 								dwgdeptnm = data[keys][key];
// 							}
// 							if( key == 'dwgdeptcode' ) {
// 								dwgdeptcode = data[keys][key];
// 							}
// 						}
// 					}
// 					if( dwgdeptnm != "" ) {
// 						$( "#deptName" ).val( dwgdeptnm );
// 						$( "#dept" ).val( dwgdeptcode );
// 					}
// 				}
// 			}, "json" );
		} );
		
		//접속자가 특수일 경우 p_deptGubun = 'Y'
		getDeptGubun();
		
		fn_insideGridresize( $(window),$( "#dwgSearchListDiv" ),  $( "#dwgSearchList" ),-30 );
		
		/* 
		 * 2017-10-12 양동협 대리 요청으로 하드코딩 
		 * HSE 팀이 도면부서 등록 안되어있기때문에 양대리만 강제로 사용할수 있도록
		 */
		if( $("#loginid").val() == "211055" ){
			$("#dept").val("000002");
			$("#deptName").val("설계운영P");
		}
		
	} ); //end of ready Function 

	//organization_id Search
	function organization() {

	}

	function reloadGrid() {

	}
	
	function fn_main_getFormData() {
		return fn_getFormData( '#application_form' );
	}
	
	//접속자가 특수일 경우 p_deptGubun = 'Y'
	function getDeptGubun() {
		var url = "selectDpDpspFlag.do";
		$.post(url, "", function( data ) {
			if( data.length != 0 ) {
				$("#p_deptGubun").val("N");
			} else {
				$("#p_deptGubun").val("S");
			}
		}, "json" );
	} 
	
	function getChangedChmResultData(callback) {
		//가져온 배열중에서 필요한 배열만 골라내기 
		var chked_val = "";
		var item = new Array();
		
		$( ":checkbox[name='checkbox']:checked" ).each( function( pi, po ) {
			chked_val += po.value + ",";
		} );
		
		var selarrrow = chked_val.split( ',' );

		for( var i = 0; i < selarrrow.length - 1; i++ ) {
			item.push( $( "#dwgSearchList" ).jqGrid( 'getRowData', selarrrow[i] ) );
		}
		
		callback.apply( this, [ item ] );
	}

	//STATE 값에 따라서 checkbox 생성
	function formatOpt1( cellvalue, options, rowObject ) {
		var rowid = options.rowId;

		var item = $( '#dwgSearchList' ).jqGrid( 'getRowData', rowid );
		
		var str = "<input type='checkbox' name='checkbox' id='" + rowid
				+ "_chkBoxOV' class='chkboxItem' value=" + rowid
				+ " onclick='chkClick(" + rowid + ")'/>";
		
		if( cellvalue == "Y" || cellvalue == "S" ) {
			return "";
		} else if( rowObject.is_yn == 'N' ) {
			return "";
		} else {
			return str;
		}
	}
	
	function chkClick( rowid ) {
		if( ( $( "#" + rowid + "_chkBoxOV" ).is( ":checked" ) ) ) {
			$( "#dwgSearchList" ).jqGrid( 'setRowData', rowid, false, {
				color : 'black',
				weightfont : 'bold',
				background : '#E8DB6B'
			} );
		} else {
			$( "#dwgSearchList" ).jqGrid( 'setRowData', rowid, false, {
				color : 'black',
				weightfont : 'bold',
				background : '#FFFFFF'
			} );
		}
	}
	
	//header checkbox action 
	function checkBoxHeader(e) {
		e = e || event;/* get IE event ( not passed ) */
		e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
		if (($("#chkHeader").is(":checked"))) {
			$(".chkboxItem").prop("checked", true);
		} else {
			$("input.chkboxItem").prop("checked", false);
		}
	}
	
	//not required
	function nrParameter(fv_not_required) {
		if (fv_not_required == 1) {
			$("#dwgSearchList").jqGrid('setRowData', row_selected, {
				radioChk : 'Y'
			});
		} else {
			$("#dwgSearchList").jqGrid('setRowData', row_selected, {
				radioChk : ''
			});
		}
	}

	//returnChk
	function rtParameter(fv_returnChk) {
		if (fv_returnChk == 1) {
			$("#dwgSearchList").jqGrid('setRowData', row_selected, {
				returnChk : 'Y'
			});
		} else {
			$("#dwgSearchList").jqGrid('setRowData', row_selected, {
				returnChk : ''
			});
		}
	}

	function fn_search() {
		delRowList = [];
		delDwgList = [];
		$( "#dwgSearchList" ).jqGrid("clearGridData");

		var sUrl = "dwgSearchList.do";
		$("#dwgSearchList").jqGrid('setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( '#application_form' )
		}).trigger("reloadGrid");
		$("#tabs").tabs("option", "active", 0);
	}

	function dwgRemove(dwg_seq_id) {
		delRowList.push(row_selected);
		delDwgList.push(dwg_seq_id);
	}
	function removeDwgList(rowid) {
		if (delRowList.length > 0) {
			for (var i = 0; i < delRowList.length; i++) {
				if (delRowList[i] == rowid) {
					remove(delRowList, delDwgList, rowid)
				}
			}
		}
	}

	function remove(delRowList, delDwgList, value) {
		var i;
		if (delRowList.indexOf) {
			// IE9+,  다른 모든 브라우져     
			while ((i = delRowList.indexOf(value)) !== -1) {
				//해당 값이 arr에 있는 동안 루프       
				delRowList.splice(i, 1);
				delDwgList.splice(i, 1);
			}
		} else {
			// IE8 이하     
			for (i = delRowList.length; i--;) {
				//뒤에서부터 배열을 탐색       
				if (delRowList[i] === value) {
					delRowList.splice(i, 1);
					delDwgList.splice(i, 1);
				}
			}
		}
	}
	
	$("#userList").change(function() {
		getRequiredUser();
	});

	function getUserList() {
		var target = $("#userList");
		$.post( "selectDwgUserList.do", fn_getFormData( '#application_form' ), function( data ) {
			for(var i =0; i < data.length; i++){
				 $("#userList").append( "<option value='"+data[i].user_name + "^" + data[i].emp_no + "^" +data[i].ep_mail + "'>"
								 				+ data[i].user_name +"("
								 				+ data[i].emp_no + ")"
						 				+"</option>" );
			}	
		}, "json" );
	}

	function getRequiredUser() {
		var requiredUser = $("#userList").val();
		var e_mail = requiredUser.substring(requiredUser.lastIndexOf('^') + 1,
				requiredUser.length)
				+ "@onestx.com";
		$("#required_user").val(e_mail);
	}

	function onlyUpperCase(obj) {
		obj.value = obj.value.toUpperCase();
	}
	
	function revCancelSearch(){
		var selRow = row_selected;
		removeDwgList(selRow);
		var item = $( '#dwgSearchList' ).jqGrid( 'getRowData', selRow );
		var shp_no = item.shp_no;
		var dwg_no = item.dwg_no;
		var radioChk = item.radioChk;
		var state = "";
		var returnChk = item.returnChk;
		var temp_dwg_rev = item.dwg_rev;
		var dwg_rev = "";
		temp_dwg_rev = (temp_dwg_rev*1 - 1) + "";
		if(temp_dwg_rev.length == 1) dwg_rev = "0";
		dwg_rev += temp_dwg_rev;
		
		$("#h_ShipNo").val(shp_no);
		$("#h_DwgNo").val(dwg_no);
		$("#dwg_rev").val(dwg_rev);
		$("#h_state").val(state);
		$("#h_returnChk").val( returnChk );
		//alert("현재rowId:"+selRow + " / 그외:"+shp_no+","+dwg_no+","+state+","+dwg_rev);
		var ifra = document.getElementById('information').contentWindow;
		ifra.searchInfo(returnChk);

		var ifra2 = document.getElementById('dwgMailReceiver').contentWindow;
		ifra2.searchDWG(radioChk);

		$("#dwgSearchList").jqGrid('delRowData', selRow);
	}
	/* function autoHeight1(){
		var objectHeight = gridObjectHeight(1);
		
		$("#information").css("height", objectHeight + 22);
		
		information.autoHeight(objectHeight);
	}
	
	function autoHeight2(){
		var objectHeight = gridObjectHeight(1);
		
		$("#dwgMailReceiver").css("height", objectHeight + 22);
		
		dwgMailReceiver.autoHeight(objectHeight);
	} */
	</script>
</html>