<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Import Paint</title>
		<style type="text/css">
		#divSeries {
			display: inline, overflow: auto;
			overflow-y: hidden;
			margin: 0 auto;
			white-space: nowrap
		}	
		</style>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form name="listForm" id="listForm" method="get">
			<%
			String sPaintProjectNo = session.getAttribute("paint_project_no") == null ? "" : session.getAttribute("paint_project_no").toString();
			String sPaintRevision = session.getAttribute("paint_revision") == null ? "" : session.getAttribute("paint_revision").toString();
			%>
			<input type="hidden" name="pageYn" value="N" />
			<input type="hidden" name="block_code" />
			<input type="hidden" name="area_code" />
			<input type="hidden" name="series_project_no" />
			<input type="hidden" name="checkbox_id" value="chkBlock" />
			<input type="hidden" name="eco_main_code" id="eco_main_code" />
			<input type="hidden" name="eco_states_desc" id="eco_states_desc" />
			<input type="hidden" id="paint_admin" name="paint_admin" value=""/>
			
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
			
			<div id="mainDiv" class="mainDiv">
				<div class="subtitle">
					Import Paint
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
				</div>
				<table class="searchArea conSearch" >
						<col width="110">
						<col width="210">
						<col width="350">
						<col width="" style="min-width:270px;">
					<tr>
						<th>PROJECT NO</th>
						<td>
							<input type="text"   id="txtProjectNo" class = "required" maxlength="10" name="project_no" value="<%=session.getAttribute("paint_project_no") == null ? "" : String.valueOf(session.getAttribute("paint_project_no"))%>" style="width:100px; text-align:center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);"/>
							<input type="text"   id="txtRevision"  class = "required" maxlength="2"  name="revision"   value="<%=session.getAttribute("paint_revision") == null ? "" : String.valueOf(session.getAttribute("paint_revision"))%>" style="width:40px; text-align:center; ime-mode:disabled; text-transform: uppercase;" onchange="changedRevistion();" onKeyPress="onlyNumber();" />
							<input type="button" id="btnProjNo" value="검색" class="btn_gray2">
						</td>
						<td>
							<fieldset style="border:none; display: inline; ">
								<input type="radio" id="chkBlock" name="chkBlock" class="check1" value="Y" onclick="fn_checkBox(this,event)" checked>Block
								<input type="radio" id="chkPrePE" name="chkPrePE" class="check1" value="Y" onclick="fn_checkBox(this,event)">Pre PE
								<input type="radio" id="chkPE" name="chkPE" class="check1" value="Y" onclick="fn_checkBox(this,event)">PE
								<input type="radio" id="chkHull" name="chkHull" class="check1" value="Y" onclick="fn_checkBox(this,event)">Hull
								<input type="radio" id="chkQuay" name="chkQuay" class="check1" value="Y" onclick="fn_checkBox(this,event)">Quay
								<input type="radio" id="chkOutfit" name="chkOutfit" class="check1" value="Y" onclick="fn_checkBox(this,event)">Outfitting
								<input type="radio" id="chkCosmetic" name="chkCosmetic" class="check1" value="Y" onclick="fn_checkBox(this,event)">Cosmetic
							</fieldset>
						</td>
						<td>
							<div class="button endbox">
								<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" value="조회" id="btnSearch" class="btn_blue" />
								</c:if>
								<c:if test="${userRole.attribute5 == 'Y'}">
								<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnRelease" value="　Release　" disabled class="btn_gray" />
								</c:if>
							</div>
						</td>
					</tr>
					</table>
					<table class="searchArea2" >
					<tr>
						<td width="">
							<div id="divSeries" style="float: left;  margin-right: 5px;"></div>
						</td>
						<th width="100px">ECO NO.</th>
						<td width="200px">
							<input type="text" id="eco_main_name" name="eco_main_name" style="width: 100px;" />
							<c:if test="${userRole.attribute2 == 'Y'}">
							<input type="button" id="btnCreateEco" value="ECO 추가" style="" disabled class="btn_gray" />
							</c:if>
						</td>
						<td width="170px">
							<div class="button endbox">
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnCreateBom" value="Create Bom" disabled class="btn_gray" />
								</c:if>
								
							</div>
						</td>
					</tr>
				</table>
				<div class="content" id="paintItemListDiv">
					<table id="paintItemList"></table>
					<div id="p_paintItemList"></div>
				</div>
			</div>
		</form>
	</body>
	<script type="text/javascript">
	var selected_tab_name = "#tabs-1";
	var tableId = "#";
	var selectData = [];
	var checkSeriesProData = [];

	var searchIndex = 0;
	var loadingBox;
	var win;

	var isLastRev = "N";
	var isExistProjNo = "N";
	var plan_release_cnt = "";
	var sState = "";

	var preProject_no;
	var preRevision;

	var prevCellVal = {
		cellId : undefined,
		value : undefined,
		team_desc : undefined
	};
	
	var objectHeight = gridObjectHeight(1);
	var quayCodeExist = true;
	$(document).ready( function() {
		rowspaner = function( rowId, val, rawObject, cm, rdata ) {
			var result;

			if( prevCellVal.value == val && prevCellVal.team_desc == rdata.team_desc ) {
				result = ' style="display: none" rowspanid="' + prevCellVal.cellId + '"';
			} else {
				var cellId = this.id + '_row_' + rowId + '_' + cm.name;

				result = ' rowspan="1" id="' + cellId + '"';
				prevCellVal = {
					cellId : cellId,
					value : val,
					team_desc : rdata.team_desc
				};
			}

			return result;
		};
		
		// 접속권한에 따른 설정 
		$.post( "paintAdminCheck.do", "", function( data ) {
			$("#paint_admin").val(data.paint_admin);
		}, "json" );		

		$( "#paintItemList" ).jqGrid( {
			datatype : 'json',
			url : '',
			postData : '',
			colNames : [ '<input type="checkbox" id = "chkHeader" onclick="checkBoxHeader(event)" />', 'Block', 'Pre PE', 'PE', 'ZONE', 'Quay', 'OUT/COS', 'TEAM', 'Area Code', 'Area Desc', 'Count', 'Paint Code', 'Paint Desc', 'Area', 'BOM Quantity', 'THEORI. Quantity', 'ACD Type', 'thinner_code', 'thinner_qty', 'thinner_theory_qty', '', '', '', '', '', '' ],
			colModel : [ { name : 'chk', index : 'chk', width : 15, sortable : false, align : 'center', formatter : formatOpt1 }, 
			             { name : 'block_code', index : 'block_code', width : 40, sortable : false, align : 'left' }, 
			             { name : 'pre_pe_code', index : 'pre_pe_code', width : 40, sortable : false, align : 'left' }, 
			             { name : 'pe_code', index : 'pe_code', width : 40, sortable : false, align : 'left' }, 
			             { name : 'zone_code', index : 'zone_code', width : 40, sortable : false, align : 'left' }, 
			             { name : 'quay_code', index : 'quay_code', width : 40, sortable : false, align : 'left' }, 
			             { name : 'outcos_code', index : 'outcos_code', width : 40, sortable : false, align : 'left' }, 
			             { name : 'team_desc', index : 'team_desc', width : 100, sortable : false, align : 'left' }, 
			             { name : 'area_code', index : 'area_code', width : 48, sortable : false, align : 'center' }, 
			             { name : 'area_desc', index : 'area_desc', width : 100, sortable : false, align : 'center' }, 
			             { name : 'paint_count', index : 'paint_count', width : 30, sortable : false, align : 'right' }, 
			             { name : 'paint_item', index : 'paint_item', width : 100, sortable : false }, 
			             { name : 'item_desc', index : 'item_desc', width : 220, sortable : false, align : 'left' }, 
			             { name : 'area', index : 'area', width : 50, sortable : false, align : 'right' }, 
			             { name : 'quantity', index : 'quantity', width : 50, sortable : false, align : 'right' }, 
			             { name : 'theory_quantity', index : 'theory_quantity', width : 60, sortable : false, align : 'right' }, 
			             { name : 'acd', index : 'acd', width : 40, sortable : false, align : 'left' }, 
			             { name : 'thinner_code', index : 'thinner_code', width : 25, hidden : true }, 
			             { name : 'thinner_quantity', index : 'thinner_quantity', width : 25, hidden : true }, 
			             { name : 'thinner_theory_quantity', index : 'thinner_theory_quantity', width : 25, hidden : true }, 
			             { name : 'project_no', index : 'project_no', width : 25, hidden : true }, 
			             { name : 'revision', index : 'revision', width : 25, hidden : true }, 
			             { name : 'team_count', index : 'team_count', width : 48, hidden : true }, 
			             { name : 'import_flag', index : 'import_flag', width : 25, hidden : true }, 
			             { name : 'stage', index : 'stage', width : 25, hidden : true }, 
			             { name : 'oper', index : 'oper', width : 25, hidden : true } ],
			gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			viewrecords : true, //하단 레코드 수 표시 유무
			autowidth : true, //사용자 화면 크기에 맞게 자동 조절
			height : objectHeight,
			pager : jQuery('#p_paintItemList'),
			cellEdit : true, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			//rowList	: [100,500,1000],
			rowNum : 99999,
			pgbuttons : false,
			pgtext : false,
			pginput : false,
			afterSaveCell : function( rowid, name, val, iRow, iCol) {
			},
			onPaging : function(pgButton) {
				/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
				 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
				 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
				 */
				$(this).jqGrid("clearGridData");

				/* this is to make the grid to fetch data from server on page click*/
				$(this).setGridParam({
					datatype : 'json',
					postData : {
						pageYn : 'Y'
					}
				}).triggerHandler("reloadGrid");
			},
			loadComplete : function(data) {
				
				// OUTIFTTING / COSMETIC에 한하여 동일 리비전 내에서 이미 Import paint가 수행된 대상은 DISALBED 처리 (행 색을 변경).. CHECKBOX는 fomatter에서 처리
				if($("#chkOutfit").is(":checked") || $("#chkCosmetic").is(":checked"))  
				{
					var rows = $( "#paintItemList" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						
						var import_flag = $( "#paintItemList" ).getCell( rows[i], "import_flag" );
						if( import_flag == "Y" ) 
						{							
							// 해당 row를 disabled 색상 표시							
							$( "#paintItemList" ).jqGrid( 'setRowData', rows[i] , false , { background : '#DADADA' } );	
						}		
					}
				}			
				
				
				// 전체 선택 체크박스 선택
				$( "#chkHeader") .prop( "checked", true );

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

					if( $this.jqGrid( 'getGridParam', 'sortname') !== '' ) {
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
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			},
			gridComplete : function() {
				quayCodeExist = true;
				var rows = $( '#paintItemList' ).getDataIDs();

				for( var i = 0; i < rows.length; i++ ) {
					var quay_code = $( '#paintItemList' ).getCell( rows[i], 'quay_code' );

					if( quay_code == '' ) {
						quayCodeExist = false;
						$( "#paintItemList" ).jqGrid( 'setCell', rows[i], 'quay_code', '', { background : 'pink' } );
					}
				}
			},
			onCellSelect : function( row_id, colId, b1, b2, b3 ) {
			},
			jsonReader : {
				// json에서 page, total, root등 필요한 정보를 어떤 키값에서 가져와야 되는지 설정하는듯.
				root : "rows", // 실제 jqgrid에 뿌려져야할 데이터들이 있는 json 키값
				page : "page", // 현재 페이지. 하단 navi에 출력됨.  
				total : "total", // 총 페이지 수
				records : "records",
				repeatitems : false,
			},
			imgpath : 'themes/basic/images'
		} );


		$( "#paintItemList" ).jqGrid( 'navGrid', "#p_paintItemList", {
			refresh : false,
			search : false,
			edit : false,
			add : false,
			del : false
		} );

		<c:if test="${userRole.attribute1 == 'Y'}">
		$( "#paintItemList" ).navButtonAdd( "#p_paintItemList", {
			caption : "",
			buttonicon : "ui-icon-refresh",
			onClickButton : function() {
				fn_search();
			},
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		fn_setGridCol("chkBlock");

		//Create BOM
		$( "#btnCreateBom" ).click( function() {
			if( fn_ProjectNoCheck( true ) ) {
				// ECO Valid 체크 및 Create BOM 진행
				fn_new_save();	
			}
		} );

		//ECO 추가
		$( "#btnCreateEco" ).click( function() {
			if( fn_ProjectNoCheck( false ) ) {
				ecoAddStateFun();
			}
		} );

		//조회 버튼
		$( "#btnSearch" ).click( function() {
			if( fn_ProjectNoCheck( false ) ) {
				fn_search();
			}
		} );
		
		// Excel출력 (미구현)
		$( "#btnExcelExport" ).click( function() {
			if( fn_ProjectNoCheck( false ) ) {
				fn_downloadStart();
				fn_excelDownload();
			}
		} );

		$( "#btnProjNo" ).click( function() {
			searchProjectNo();
		} );

		// Release
		$("#btnRelease").click(function() {
			if( fn_ProjectNoCheck(true)) {
				fn_release();
			}
		} );
		
		fn_searchLastRevision();
		//grid resize
		fn_gridresize( $(window), $( "#paintItemList" ) ,37 );
		//fn_insideGridresize($(window),$("#paintItemListDiv"),$("#paintItemList"));
	} ); //end of ready Function 	

	function fn_ProjectNoCheck( isLastCheck ) {
		if( $.jgrid.isEmpty( $( "input[name=project_no]" ).val() ) ) {
			alert( "Project No is required" );
			setTimeout( '$( "input[name=project_no]" ).focus()', 200 );
			return false;
		}

		if( $.jgrid.isEmpty( $( "input[name=revision]" ).val() ) ) {
			alert( "Revision is required" );
			setTimeout( '$( "input[name=revision]" ).focus()', 200 );
			return false;
		}

		if( isExistProjNo == "N" && isLastCheck == true ) {
			alert( "Project No does not exist" );
			return false;
		}

		if( sState == "D" && isLastCheck == true ) {
			alert( "State of the revision is released" );
			return false;
		}

		if( isLastRev == "N" && isLastCheck == true ) {
			alert( "PaintPlan Revision is not the end" );
			return false;
		}
		
		if( !$("#chkBlock").is(":checked") 
			&& !$("#chkPE").is(":checked")
			&& !$("#chkPrePE").is(":checked")
			&& !$("#chkHull").is(":checked")
			&& !$("#chkQuay").is(":checked")
			&& !$("#chkOutfit").is(":checked")
			&& !$("#chkCosmetic").is(":checked"))
		{
			alert( "Stage is not select" );
			return false;
		} 		
			

		return true;
	}
	
	
	function fn_new_save()
	{		
		if( $( "#eco_main_name" ).val() == "" ) {
			alert( "ECO를 추가후 진행해 주세요." );
			return;
		} else {
			//var url = "selectEcoAddStateList.do";
			var url = "paintSelectEcoAddStateList.do";
			var formData = fn_getFormData( '#listForm' );

			$.post( url, formData, function( data ) {
				if( data.length == 0 ) {					
					alert( "입력하신 ECO는 존재하지 않거나 RELEASE 상태입니다.\n확인후 진행해 주세요." );
					return;
				} else {
					// ECO가 정상적일 경우 Create BOM 생성 시작
					fn_CreateBOM();
				}
			}, "json" ).error(function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				return;
			} );
		}		
	}
	
	function fn_CreateBOM() {
		if($( "input[name=checkbox_id]" ).val() == 'chkQuay'){
			if(!quayCodeExist) {
				alert("Quay IMPORT의 경우 Quay정보가 필수입력입니다. 확인바랍니다.");	
				return;
			}
			
		}
		if( confirm( 'BOM IMPORT 하시겠습니까?' ) == 0 ) {
			return;
		}

		loadingBox = new ajaxLoader( $( '#mainDiv' ), {
			classOveride : 'blue-loader',
			bgColor : '#000',
			opacity : '0.3'
		} );

		// arrayData 삭제
		arrayDataClear();
		
		//가져온 배열중에서 필요한 배열만 골라내기 
		var chked_val = "";
		$( ":checkbox[name='checkbox']:checked" ).each( function( pi, po ) {
			chked_val += po.value + ",";
		} );

		var selarrrow = chked_val.split( ',' );

		if( chked_val == "" ) {
			alert( "조회 후 시도해주세요." );
			loadingBox.remove();
			return;
		}

		for( var i = 0; i < selarrrow.length - 1; i++ ) {
			var item = $( '#paintItemList' ).jqGrid( 'getRowData', selarrrow[i] );
			selectData.push( item );
		}
		
		checkSeriesProData.push( $( "input[name=project_no]" ).val() );
		$( ":checkbox[class='chkboxSeriesItem']:checked" ).each( function( pi, po ) {
			if( po.value != $( "input[name=project_no]" ).val() )
				checkSeriesProData.push(po.value);
		} );

		var checkSeriesProjectList = checkSeriesProData.join( ',' );

		var dataList = {
			paintPlanList : JSON.stringify( selectData ),
			seriesProject : checkSeriesProjectList
		};
		
		var formData = fn_getFormData( '#listForm' );

		var url = "savePaintImportCreateBom.do";
		var parameters = $.extend( {}, dataList, formData );

		$.post( url, parameters, function( data ) {

			alert( data.resultMsg );
			
			if( data.result == 'success') {
				fn_search();
			}
		}, "json" ).error( function() {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
			loadingBox.remove();
		} );	
	}
	//eco 연결 가능 여부 판단 확인
	function ecoAddStateFun() {
		var dialog = $( '<p>ECO를 연결합니다.</p>' ).dialog( {
			buttons : {
				"SEARCH" : function() {
					//var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupECORelated&save=bomAddEco&ecotype=5&menu_id=${menu_id}",
					var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
							window,
							"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off" );

					if( rs != null ) {
						$( "input[name=eco_main_name]" ).val( rs[0] );
						/* $( "#eco_main_name" ).val( rs[1] ); */
						//$( "#eco_states_desc" ).val( rs[2] );
					}

					dialog.dialog( 'close' );
				},
//					"생성" : function() {
					
//						var sUrl = "eco.do?popupDiv=bomAddEco&popup_type=PAINT&menu_id=M00036";

//						var rs = window.showModalDialog(sUrl,
//								window,
//								"dialogWidth:1200px; dialogHeight:500px; center:on; scroll:off; states:off");
//						if( rs != null ) {
//							$( "input[name=p_eco_no]" ).val( rs[0] );
//							/* $( "#eco_main_name" ).val( rs[0] ); */
//						}
//						dialog.dialog( 'close' );
//					},
				"CREATE" : function() {
					var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=&mainType=ECO",
							"ECONO",
							"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
					if( rs != null ) {
						$( "input[name=eco_main_name]" ).val( rs[0] );
					}
					dialog.dialog( 'close' );
				},
				"CANCEL" : function() {
					dialog.dialog( 'close' );
				}
			}
		} );
	}
	
	//ECO Add 버튼 
	function addEcoResultRow() {
		var eng_eco_project = $( "#txtProjectNo" ).val();
		var sUrl = "eco.do?popupDiv=bomAddEco&eng_eco_project=" + eng_eco_project + "&popup_type=PAINT&menu_id=${menu_id}";

		var rs = window.showModalDialog(sUrl,
				window,
				"dialogWidth:1200px; dialogHeight:500px; center:on; scroll:off; states:off");
		if( rs != null ) {
			$( "#eco_main_code" ).val( rs[0] );
			$( "#eco_main_name" ).val( rs[0] );
		}
		
		//$( "#eco_states_desc" ).val( rs[2] );
	}
	
	function fn_search() {
		fn_initPrevCellVal();		
		
		fn_setPaintEco();

		var sUrl = "selectPaintImportPaintList.do";
		$( "#paintItemList" ).jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			page : 1,
			datatype : 'json',
			postData : fn_getFormData( "#listForm" )
		} ).trigger( "reloadGrid" );
		
		
	}
	
	function fn_initPrevCellVal() {
		prevCellVal = {
			cellId : undefined,
			value : undefined,
			team_desc : undefined
		};
	}
	
	function arrayDataClear() {
		// 전부 삭제한다.
		if( selectData.length > 0 )
			selectData.splice( 0, selectData.length );
		if( checkSeriesProData.length > 0 )
			checkSeriesProData.splice( 0, checkSeriesProData.length );
	}
	
	function fn_excelDownload() {
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		var cn = $( "#paintItemList" ).jqGrid( "getGridParam", "colNames" );
		var cm = $( "#paintItemList" ).jqGrid( "getGridParam", "colModel" );
		for(var i=1; i<cm.length; i++ ){
			
			if(cm[i]['hidden'] != "true") {
				colName.push(cn[i]);
				dataName.push(cm[i]['index']);	
			}
			
		}
		
		var sUrl = "paintImportExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName;
		
		var f = document.listForm;
		
		//f.target = "/blank"
		f.action = sUrl;
		f.method = "post";
		f.submit();
		//Import Paint용 Excel Download 기능 없음. allQuantityExcelExport는 파라미터 부족함(절기 코드 등)
		//var f = document.listForm;		
		//f.action = "allQuantityExcelExport.do";
		//f.method = "post";
		//f.submit();
	}
	
	function searchProjectNo() {
		var args = {
			project_no : $( "input[name=project_no]" ).val(),
			menu_id : $( "input[name=menu_id]" ).val()
		};

		var rs = window.showModalDialog( "popupPaintPlanProjectNo.do",
				args,
				"dialogWidth:420px; dialogHeight:480px; center:on; scroll:off; status:off; location:no" );

		if( rs != null ) {
			$( "input[name=project_no]" ).val( rs[0] );
			$( "input[name=revision]" ).val( rs[1] );
		}

		fn_searchLastRevision();
	}
	
	function fn_searchLastRevision() {
		var url = "paintPlanProjectNoCheck.do";
		var parameters = {
			project_no : $( "input[name=project_no]" ).val(),
			revision : $( "input[name=revision]" ).val(),
			menu_id : $( "input[name=menu_id]" ).val()
		};

		$.post( url, parameters, function( data ) {
			if(data !=null && data != ""){
				isExistProjNo  = "Y";
		  		if(data.state != null && data.state != 'undefined') sState = data.state;
		  		else sState = "";
		  		if (data.last_revision_yn == "Y") isLastRev = "Y";
		  		else isLastRev = "N";
		  		if(data.plan_release_cnt != null && data.plan_release_cnt != 'undefined') plan_release_cnt = data.plan_release_cnt;
		  		else plan_release_cnt = "";
			} else {
		  		isExistProjNo = "N";
		  		isLastRev 	  = "N";  
		  		sState		  = "";	
		  	}			

			if( preProject_no != $( "input[name=project_no]" ).val() || preRevision != $( "input[name=revision]" ).val() ) {
				$( "#paintItemList" ).clearGridData( true );

				preProject_no = $( "input[name=project_no]" ).val();
				preRevision = $( "input[name=revision]" ).val();
			}

			fn_setButtionEnable();
			fn_setSeriesProject( $( "input[name=project_no]" ).val() );
		}, "json" );
	}
	
	function fn_setPaintEco() {

		var url = "selectPaintEco.do";
		var parameters = fn_getParam();

		$( "#eco_main_name" ).val( "" );  // ECO NO. 컬럼 초기화

		$.post( url, parameters, function( data ) {
			if( data != null && data != "") {
				if(data.all_eco_no != null && data.all_eco_no != 'undefined'){
					$( "#eco_main_name" ).val( data.all_eco_no );
				} else {
					$( "#eco_main_name" ).val( "" );
				}
			} else {
				$( "#eco_main_name" ).val( "" );
			}
		}, "json" );
	}
	
	function fn_getParam() {
		return fn_getFormData( "#listForm" );
	}
	
	function fn_setButtionEnable() {
		if( "Y" == isLastRev && sState != "D" ) {
			fn_buttonEnable( [ "#btnCreateEco", "#btnCreateBom" ] );
		} else {
			fn_buttonDisabled( [ "#btnCreateEco", "#btnCreateBom" ] );
		}
		if( plan_release_cnt > 0 ) {
			$( "#btnRelease" ).val("Release");
			$( "#btnRelease" ).removeAttr( "disabled" );
			$( "#btnRelease" ).removeClass( "btn_gray" );
			$( "#btnRelease" ).addClass( "btn_red" );
			/* fn_buttonEnable( [ "#btnRelease" ] ); */
		} else {
			if($("#paint_admin").val() == "Y" ) {
				$( "#btnRelease" ).val("관리자 강제 Release");
				$( "#btnRelease" ).removeAttr( "disabled" );
				$( "#btnRelease" ).removeClass( "btn_gray" );
				$( "#btnRelease" ).addClass( "btn_red" );
			} else {
				$( "#btnRelease" ).attr( "disabled",true );
				$( "#btnRelease" ).removeClass( "btn_red" );
				$( "#btnRelease" ).addClass( "btn_gray" );
				/* fn_buttonDisabled( [ "#btnRelease" ] ); */	
			}
		}
	}
	
	function fn_setSeriesProject(project_no) {
		$( "#divSeries" ).text( "" );

		$.post( "selectSeriesProjectNo.do", { project_no : project_no }, function( data ) {
			var checked = "";
			if( data.length > 0 ) {
				checked = "checked";
				$( "#divSeries" ).append( "<input type='checkbox' id = 'chkSeries' onclick='checkBoxSeries(event)'" + checked + " />" + "ALL &nbsp" );
			}

			for( var i = 0; i < data.length; i++ ) {
				var val = data[i].project_no;
				var plan = data[i].planflag;
				if(plan == "PLAN"){
					$( "#divSeries" ).append( "<input id='chk_" + i + "' type='checkbox' style='margin-left:10px;background: #999;padding: 2px 5px 2px 5px;' class='' value='" + val + "'" + " disabled  />" + val + "" );
				} else {
					$( "#divSeries" ).append( "<input id='chk_" + i + "' type='checkbox' style='margin-left:10px' class='chkboxSeriesItem' value='" + val + "'" + checked +" />" + val + "" );	
				}
				
			}
		}, "json" );	

	}
	
	function fn_release() {

		if( confirm( 'Release 하시겠습니까?' ) == 0 ) {
			return;
		}

		loadingBox = new ajaxLoader( $( '#mainDiv' ), {
			classOveride : 'blue-loader',
			bgColor : '#000',
			opacity : '0.3'
		} );

		var url = "savePaintRelease.do";
		var parameters = fn_getFormData( '#listForm' );

		$.post( url, parameters, function( data ) {
			loadingBox.remove();

			alert(data.resultMsg);

			if (data.result == "success") {
				fn_searchLastRevision();
			}

		}, "json" ).fail(function() {
			alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
		} ).always(function() {
			loadingBox.remove();
		} );
	}
	
	function addEcoRow() {
		// eco 팝업에서 공통으로 보내줌. 
	}
	
	function onlyUpperCase(obj) {
		obj.value = obj.value.toUpperCase();
		searchProjectNo();
	}
	
	function changedRevistion(obj) {
		fn_searchLastRevision();
	}
		
	//STATE 값에 따라서 checkbox 생성
	function formatOpt1(cellvalue, options, rowObject) {
		
		var rowid = options.rowId;
		
		var str = "<input type='checkbox' name='checkbox' id='" + rowid + "_chkBoxOV' class='chkboxItem' value=" + rowid + " checked />";
		
		// 만일 OUTIFTTING / COSMETIC에 한하여 동일 리비전 내에서 이미 Import paint가 수행된 대상은 checkbox없음.
		if($("#chkOutfit").is(":checked") || $("#chkCosmetic").is(":checked")) 
		{
			if(rowObject.import_flag == "Y")
			{
				return "";	
			}
		}
		return str;
	}
	
	//header checkbox action 
	function checkBoxHeader(e) {
		e = e || event;/* get IE event ( not passed ) */
		e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
		if( ($("#chkHeader").is(":checked"))) {
			$(".chkboxItem").prop("checked", true);
		} else {
			$("input.chkboxItem").prop("checked", false);
		}
	}
	
	//header checkbox action 
	function checkBoxSeries(e) {
		e = e || event;/* get IE event ( not passed ) */
		e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
		if( ($("#chkSeries").is(":checked"))) {
			$(".chkboxSeriesItem").prop("checked", true);
		} else {
			$("input.chkboxSeriesItem").prop("checked", false);
		}
	}
	
	function fn_checkBox(obj, e) {
		var chkBox = $( "#" + obj.id );

		fn_setGridCol( obj.id );

		var isChecked = false;
		if( chkBox.is( ":checked" ) ) {
			isChecked = true;
		}

		$( ".check1" ).prop( "checked", false );
		chkBox.prop( "checked", isChecked );
		
	}
	
	function fn_setGridCol( objId ) {
		$( "input[name=checkbox_id]" ).val( objId );
		if( objId == "chkBlock" ) {
			$( "#paintItemList" ).hideCol( "pre_pe_code" );
			$( "#paintItemList" ).hideCol( "pe_code" );
			$( "#paintItemList" ).hideCol( "quay_code" );
			$( "#paintItemList" ).hideCol( "zone_code" );
			$( "#paintItemList" ).showCol( "block_code" );
			$( "#paintItemList" ).hideCol( "outcos_code" );
			$( "#paintItemList" ).hideCol( "team_desc" );
			$( "#paintItemList" ).showCol( "paint_count" );
			$( "#paintItemList" ).hideCol( "area_code" );
			$( "#paintItemList" ).hideCol( "area_desc" );
		} else if( objId == "chkPrePE" ) {
			$( "#paintItemList" ).hideCol( "block_code" );
			$( "#paintItemList" ).hideCol( "pe_code" );
			$( "#paintItemList" ).hideCol( "quay_code" );
			$( "#paintItemList" ).hideCol( "zone_code" );
			$( "#paintItemList" ).showCol( "pre_pe_code" );
			$( "#paintItemList" ).hideCol( "outcos_code" );
			$( "#paintItemList" ).hideCol( "team_desc" );
			$( "#paintItemList" ).showCol( "paint_count" );
			$( "#paintItemList" ).hideCol( "area_code" );
			$( "#paintItemList" ).hideCol( "area_desc" );
		} else if( objId == "chkPE" ) {
			$( "#paintItemList" ).hideCol( "block_code" );
			$( "#paintItemList" ).showCol( "pe_code" );
			$( "#paintItemList" ).hideCol( "quay_code" );
			$( "#paintItemList" ).hideCol( "zone_code" );
			$( "#paintItemList" ).hideCol( "pre_pe_code" );
			$( "#paintItemList" ).hideCol( "outcos_code" );
			$( "#paintItemList" ).hideCol( "team_desc" );
			$( "#paintItemList" ).showCol( "paint_count" );
			$( "#paintItemList" ).showCol( "area_code" );
			$( "#paintItemList" ).showCol( "area_desc" );
		} else if( objId == "chkHull" ) {
			$( "#paintItemList" ).hideCol( "block_code" );
			$( "#paintItemList" ).hideCol( "pe_code" );
			$( "#paintItemList" ).hideCol( "quay_code" );
			$( "#paintItemList" ).showCol( "zone_code" );
			$( "#paintItemList" ).hideCol( "pre_pe_code" );
			$( "#paintItemList" ).hideCol( "outcos_code" );
			$( "#paintItemList" ).hideCol( "team_desc" );
			$( "#paintItemList" ).showCol( "paint_count" );
			$( "#paintItemList" ).showCol( "area_code" );
			$( "#paintItemList" ).showCol( "area_desc" );
		} else if( objId == "chkQuay" ) {
			$( "#paintItemList" ).hideCol( "block_code" );
			$( "#paintItemList" ).hideCol( "pe_code" );
			$( "#paintItemList" ).showCol( "quay_code" );
			$( "#paintItemList" ).hideCol( "zone_code" );
			$( "#paintItemList" ).hideCol( "pre_pe_code" );
			$( "#paintItemList" ).hideCol( "outcos_code" );
			$( "#paintItemList" ).hideCol( "team_desc" );
			$( "#paintItemList" ).showCol( "paint_count" );
			$( "#paintItemList" ).showCol( "area_code" );
			$( "#paintItemList" ).showCol( "area_desc" );
		} else if( objId == "chkOutfit" || objId == "chkCosmetic" ) {
			$( "#paintItemList" ).showCol( "outcos_code" );
			$( "#paintItemList" ).showCol( "team_desc" );
			$( "#paintItemList" ).hideCol( "block_code" );
			$( "#paintItemList" ).hideCol( "pe_code" );
			$( "#paintItemList" ).hideCol( "quay_code" );
			$( "#paintItemList" ).hideCol( "zone_code" );
			$( "#paintItemList" ).hideCol( "pre_pe_code" );
			$( "#paintItemList" ).hideCol( "area_code" );
			$( "#paintItemList" ).hideCol( "area_desc" );
			$( "#paintItemList" ).hideCol( "paint_count" );
		}

		$( "#chkHeader" ).prop( "checked", false );
		$( "#paintItemList" ).clearGridData( true );
		
		$( "#eco_main_name" ).val( "" );  // ECO NO. 컬럼 초기화
		fn_insideGridresize($(window),$("#paintItemListDiv"),$("#paintItemList"),37);
		/* resizeJqGridWidth(); */
	}
	
	/* function resizeJqGridWidth() {
		// window에 resize 이벤트를 바인딩 한다. 
		$(window).bind( 'resize', function() {
			// 그리드의 width 초기화
			$( '#paintItemList' ).setGridWidth(0);
			// 그리드의 width를 div 에 맞춰서 적용
			$( '#paintItemList' ).setGridWidth( $( '#content' ).width()-20 );
			//Resized to new width as per window
		} ).trigger( 'resize' );
	} */
	</script>
</html>