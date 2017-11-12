<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>JOB Catalog 기준정보 관리</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">

			<form id="application_form" name="application_form">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class="subtitle">
					JOB Catalog 기준정보 관리
				<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>	
				<span class="guide"><img src="/DIS/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>

				<table class="searchArea conSearch">
				<col width="90">
				<col width="200">
				<col width="">
				<tr>
					<th>Job Catalog</th>
					<td>
						<input type="text" name="p_job_catalog" id="p_job_catalog" class="toUpper" style="width: 50px;" />
						<input type="text" name="p_job_catalog_desc" id="p_job_catalog_desc" style="width: 90px; margin-left: -5px;" class="notdisabled" readonly="readonly" />
						<input type="button" name="btn_popup_job_catalog" id="btn_popup_job_catalog" value="검색" class="btn_gray2"/>
					</td>
					<td style="border-left:none;">
					<div class="button endbox">
						<c:if test="${userRole.attribute2 == 'Y'}">
							<input type="button" value="ADD" id="add_row"  class="btn_blue2"/>
						</c:if>
						
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" value="저장" id="btnSave"  class="btn_blue2"/>
						</c:if>
						
						<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" value="조회" id="btnSearch"  class="btn_blue2"/>
						</c:if>
					</div>
					</td>
				</tr>
				</table>

				<div class="content">
					<table id="pdUpperStructureMgntList"></table>
					<div id="btn_pdUpperStructureMgntList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var change_item_row 	= 0;
		var change_item_row_num = 0;
		var change_item_col  	= 0;
		
		var resultData = [];
		
		var loadingBox;
		
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			var is_hidden = true;
			
			$( "#pdUpperStructureMgntList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'Job Catalog', '...', '단일 연계', '', '', '부서기준(복수)', '', '', '도면기준(복수)', '', '', '최종작업자', '최종작업일', 'oper' ],
				colModel : [ { name : 'job_catalog', index : 'job_catalog', align : 'center', width : 100 },
				             { name : 'job_catalog_popup', index : 'job_catalog_popup', align : 'center', width : 30 },
				             { name : 'job_type1', index : 'job_type1', width : 100, align : 'center', formatter : formatOpt1, sortable : false },
				             { name : 'job_type1_flag', index : 'job_type1_flag', align : 'center', width : 100, hidden : is_hidden },
				             { name : 'job_type1_flag_change', index : 'job_type1_flag_change', align : 'center', width : 100, hidden : is_hidden },
				             { name : 'job_type2', index : 'job_type2', width : 100, align : 'center', formatter : formatOpt2, sortable : false },
				             { name : 'job_type2_flag', index : 'job_type2_flag', align : 'center', width : 100, hidden : is_hidden },
				             { name : 'job_type2_flag_change', index : 'job_type2_flag_change', align : 'center', width : 100, hidden : is_hidden },
				             { name : 'job_type3', index : 'job_type3', width : 100, align : 'center', formatter : formatOpt3, sortable : false },
				             { name : 'job_type3_flag', index : 'job_type3_flag', align : 'center', width : 100, hidden : is_hidden },
				             { name : 'job_type3_flag_change', index : 'job_type3_flag_change', align : 'center', width : 100, hidden : is_hidden },
				             { name : 'last_updated_by', index : 'last_updated_by', align : 'center', width : 220 },
				             { name : 'last_update_date', index : 'last_update_date', align : 'center', width : 100 },
				             { name : 'oper', index : 'oper', align : 'center', width : 220, hidden : is_hidden } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers:true,
				pager : '#btn_pdUpperStructureMgntList',
				sortname : 'pd_catalog',
				viewrecords : true,
				sortorder : "desc",
				shrinkToFit : false,
				autowidth : true,
				height : objectHeight,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				emptyrecords : '데이터가 존재하지 않습니다.',
				imgpath : 'themes/basic/images',
				multiselect : false,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if ( rowid != null ) {
						change_item_col = iCol;
						change_item_row_num = iRow;
	
						if ( change_item_row != rowid ) {
							change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#pdUpperStructureMgntList' ).jqGrid( 'getRowData', rowid );
					if (item.oper != 'I')
						item.oper = 'U';

					$( '#pdUpperStructureMgntList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					
					var cm = $( "#pdUpperStructureMgntList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $("#pdUpperStructureMgntList").jqGrid( "getRowData", rowid );
					
					if( item.oper != "" ) {
						if ( colName['index'] == "job_catalog_popup" ) {
							fn_popup_catalog_search( "OUT2", "G", rowid );
						}
					}
				},
				gridComplete : function () {
					$("#pdUpperStructureMgntList td:contains('...')").css("background","pink").css("cursor","pointer");
					
					var rows = $( "#pdUpperStructureMgntList" ).getDataIDs();

					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#pdUpperStructureMgntList" ).getCell( rows[i], "oper" );
						
						if( oper == "" ) {
							$( "#pdUpperStructureMgntList" ).jqGrid( 'setCell', rows[i], 'ship_type', '', { color : 'black', background : '#DADADA' } );
							$( "#pdUpperStructureMgntList" ).jqGrid( 'setCell', rows[i], 'drawing_no', '', { color : 'black', background : '#DADADA' } );
							$( "#pdUpperStructureMgntList" ).jqGrid( 'setCell', rows[i], 'history_no', '', { color : 'black', background : '#DADADA' } );
							$( "#pdUpperStructureMgntList" ).jqGrid( 'setCell', rows[i], 'modify_by', '', { color : 'black', background : '#DADADA' } );
							$( "#pdUpperStructureMgntList" ).jqGrid( 'setCell', rows[i], 'modify_date', '', { color : 'black', background : '#DADADA' } );
						}
					}
					
					//미입력 영역 회색 표시
					$("#pdUpperStructureMgntList .disables").css( "background", "#DADADA" );
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
			
			//grid resize
		    fn_gridresize( $(window), $( "#pdUpperStructureMgntList" ) );
			
			//그리드 내 콤보박스 바인딩
			fn_set_grid_combo();
			
			//조회조건 Combo 초기화 설정
			fn_get_combo();
			
			//라인추가 버튼 클릭
			$( "#add_row" ).click( function () {
				fn_add_row();
			} );
			
			//저장
			$( "#btnSave" ).click( function () {
				fn_save();
			} );
			
			//조회 버튼 클릭
			$( "#btnSearch" ).click( function () {
				fn_search();
			} );
			
			//pd catalog 찾기 팝업
			$( "#btn_popup_pd_catalog" ).click( function () {
				fn_popup_catalog_search( "PD", "C", "" );
			} );
			
			//activity catalog 찾기 팝업
			$( "#btn_popup_activity_catalog" ).click( function () {
				fn_popup_catalog_search( "OUT1", "C", "" );
			} );
			
			//job catalog 찾기 팝업
			$( "#btn_popup_job_catalog" ).click( function () {
				fn_popup_catalog_search( "OUT2", "C", "" );
			} );
			
			//pd catalog 검색조건 초기화
			$( "#p_pd_catalog" ).keyup( function () {
				if ( $( "#p_pd_catalog" ).val() == "" ) {
					$( "#p_pd_catalog_desc" ).val( "" );
				}
			} );
			
			//activity catalog 검색조건 초기화
			$( "#p_activity_catalog" ).keyup( function () {
				if ( $( "#p_activity_catalog" ).val() == "" ) {
					$( "#p_activity_catalog_desc" ).val( "" );
				}
			} );
			
			//job catalog 검색조건 초기화
			$( "#p_job_catalog" ).keyup( function () {
				if ( $( "#p_job_catalog" ).val() == "" ) {
					$( "#p_job_catalog_desc" ).val( "" );
				}
			} );
			
		} ); // end of ready Function
		
		//그리드 내 콤보박스 바인딩
		function fn_set_grid_combo() {
			//구분 콤보박스
			var param = { sd_type : "WORK_TYPE" };
			$.post( "selectComboCodeMaster.do", param, function( data ) {
				$( '#pdUpperStructureMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'work_type',
					data : data
				} );
			}, "json" );
		}
		
		//조회조건 Combo 초기화 설정
		function fn_get_combo() {
			$( "#p_work_type option" ).remove();
			$( "#p_work_type" ).append( "<option value=''>ALL</option>" );
			var param = { sd_type : "WORK_TYPE" };
			$.post( "selectComboCodeMaster.do", param, function( data ) {
				for( var i = 0; i < data.length; i++ ) {
					$( "#p_work_type" ).append( "<option value='"+data[i].value+"'>"+data[i].text+"</option>" );
				}
			}, "json" );
		}
		
		//라인추가
		function fn_add_row() {
			$( '#pdUpperStructureMgntList' ).saveCell( change_item_row_num, change_item_col );

			var item = {};
			var colModel = $( '#pdUpperStructureMgntList' ).jqGrid( 'getGridParam', 'colModel' );
			for ( var i in colModel )
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.job_catalog_popup = "...";
			item.job_type1 = 'Y';

			$( '#pdUpperStructureMgntList' ).resetSelection();
			$( '#pdUpperStructureMgntList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
		}
		
		//저장
		function fn_save() {
			$( '#pdUpperStructureMgntList' ).saveCell( change_item_row_num, change_item_col );
			
// 			var changedData = $( "#pdUpperStructureMgntList" ).jqGrid( 'getRowData' );
			
			var changedData = $( "#pdUpperStructureMgntList" ).jqGrid( 'getDataIDs' );
			
			// 변경된 체크 박스가 있는지 체크한다.
			for( var k = 0; k < changedData.length; k++ ) {
				var item = $( '#pdUpperStructureMgntList' ).jqGrid( 'getRowData', changedData[k] );
				if ( item.oper != 'I' && item.oper != 'U' ) {
					if( item.job_type1_flag != item.job_type1_flag_change ) {
						item.oper = 'U';
				    }
					
					if( item.job_type2_flag != item.job_type2_flag_change ) {
						item.oper = 'U';
				    }
					
					if( item.job_type3_flag != item.job_type3_flag_change ) {
						item.oper = 'U';
				    }
					if ( item.oper == 'U' ) {
						// apply the data which was entered.
						$( '#pdUpperStructureMgntList' ).jqGrid( "setRowData", changedData[k], item );
					}
				}	
			}
			
			var chmResultRows = [];
			getChangedChmResultData2( function( data ) {
				chmResultRows = data;
				
				//수정 유무 체크
				if ( !fn_checkGridModify( "#pdUpperStructureMgntList" ) ) {
					return;
				}
				
				//저장 유무 체크
				if ( !confirm( "변경된 데이터를 저장하시겠습니까?" ) ) {
					return;
				}

				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

				var url = 'saveUscJobType.do';
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				$.post( url, parameters, function( data2 ) {
					var msg = "";
					var result = "";
					
					for ( var keys in data2) {
						for ( var key in data2[keys]) {
							if (key == 'Result_Msg') {
								msg = data2[keys][key];
							}

							if (key == 'result') {
								result = data2[keys][key];
							}
						}
					}
					
					alert( msg );
					if ( result == 'success' ) {
						fn_search();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();	
				} );
			} );
		}
		
		//조회
		function fn_search() {
			var sUrl = 'selectUscJobType.do';
			$( "#pdUpperStructureMgntList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		function getChangedChmResultData2( callback ) {
			var changedData = $.grep( $( "#pdUpperStructureMgntList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		
		//catalog 조회 popup
		function fn_popup_catalog_search( catalog_type, search_locate, rowid ) {
			var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupCatalogSearch&catalog_type=" + catalog_type,
					window,
					"dialogWidth:550px; dialogHeight:435px; center:on; scroll:off; status:off" );

			if ( rs != null ) {
				if( search_locate == "C" ) {
					//조회조건에서 팝업호출
					if( catalog_type == "PD" ) {
						$( "#p_pd_catalog" ).val( rs[0] );
						$( "#p_pd_catalog_desc" ).val( rs[1] );
					} else if( catalog_type == "OUT1" ) {
						$( "#p_activity_catalog" ).val( rs[0] );
						$( "#p_activity_catalog_desc" ).val( rs[1] );
					} else if( catalog_type == "OUT2" ) {
						$( "#p_job_catalog" ).val( rs[0] );
						$( "#p_job_catalog_desc" ).val( rs[1] );
					}
				} else if( search_locate == "G" ) {
					//grid에서 팝업호출
					var item = $( '#pdUpperStructureMgntList' ).jqGrid( 'getRowData', rowid );

					if( catalog_type == "PD" ) {
						$( "#pdUpperStructureMgntList" ).setRowData( rowid, { pd_catalog: rs[0] } );
					} else if( catalog_type == "OUT1" ) {
						$( "#pdUpperStructureMgntList" ).setRowData( rowid, { activity_catalog : rs[0] } );
					} else if( catalog_type == "OUT2" ) {
						$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_catalog : rs[0] } );
					}
					
					if ( item.oper != 'I' ) {
						$( "#pdUpperStructureMgntList" ).setRowData( rowid, { oper : "U" } );
					}
				}
			}
		}
		
		//단일연계 체크박스
		function formatOpt1( cellvalue, options, rowObject ) {
			var rowid = options.rowId;
			var str = "";
			
			if( rowObject.job_type == "01" ) {
				str = "<input type='checkbox' name='checkbox' id='" + rowid
					+ "_chkBoxOV1' class='chkboxItem' checked value=" + rowid
					+ " onclick='chkClick(\"" + rowid + "\", 1)'/>";
			} else {
				str = "<input type='checkbox' name='checkbox' id='" + rowid
					+ "_chkBoxOV1' class='chkboxItem' value=" + rowid
					+ " onclick='chkClick(\"" + rowid + "\", 1)'/>";
			}
			
			return str;
		}
		
		//부서기준 체크박스
		function formatOpt2( cellvalue, options, rowObject ) {
			var rowid = options.rowId;
			var str = "";
			
			if( rowObject.job_type == "02" ) {
				str = "<input type='checkbox' name='checkbox' id='" + rowid
					+ "_chkBoxOV2' class='chkboxItem' checked value=" + rowid
					+ " onclick='chkClick(\"" + rowid + "\", 2)'/>";
			} else {
				str = "<input type='checkbox' name='checkbox' id='" + rowid
					+ "_chkBoxOV2' class='chkboxItem' value=" + rowid
					+ " onclick='chkClick(\"" + rowid + "\", 2)'/>";
			}
					
			return str;
		}
		
		//도면기준 체크박스
		function formatOpt3( cellvalue, options, rowObject ) {
			var rowid = options.rowId;
			var str = "";
			
			if( rowObject.job_type == "03" ) {
				str = "<input type='checkbox' name='checkbox' id='" + rowid
					+ "_chkBoxOV3' class='chkboxItem' checked value=" + rowid
					+ " onclick='chkClick(\"" + rowid + "\", 3)'/>";				
			} else {
				str = "<input type='checkbox' name='checkbox' id='" + rowid
					+ "_chkBoxOV3' class='chkboxItem' value=" + rowid
					+ " onclick='chkClick(\"" + rowid + "\", 3)'/>";
			}
								
			return str;
		}
		
		function chkClick( rowid, idx ) {
			if( idx == 1 ) {
				$( "#" + rowid + "_chkBoxOV2" ).attr( "checked", false );
				$( "#" + rowid + "_chkBoxOV3" ).attr( "checked", false );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type1_flag : "Y" } );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type2_flag : "N" } );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type3_flag : "N" } );
			} else if( idx == 2 ) {
				$( "#" + rowid + "_chkBoxOV1" ).attr( "checked", false );
				$( "#" + rowid + "_chkBoxOV3" ).attr( "checked", false );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type1_flag : "N" } );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type2_flag : "Y" } );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type3_flag : "N" } );
			} else if( idx == 3 ) {
				$( "#" + rowid + "_chkBoxOV1" ).attr( "checked", false );
				$( "#" + rowid + "_chkBoxOV2" ).attr( "checked", false );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type1_flag : "N" } );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type2_flag : "N" } );
				$( "#pdUpperStructureMgntList" ).setRowData( rowid, { job_type3_flag : "Y" } );
			}
		}
		</script>
	</body>
</html>
