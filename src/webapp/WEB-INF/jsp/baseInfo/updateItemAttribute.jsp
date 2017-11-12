<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Item Attribute Excel Upload</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div class="mainDiv" id="mainDiv">
			<form id="application_form" name="application_form" enctype="multipart/form-data" action="itemAttributeExcelImport.do" method="post">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="clearFlag" name="clearFlag" value="N" />
				<div class= "subtitle">
					Update Items Attr
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>


				
				<!--
				<div class="searchbox">
				<div class="conSearch" >
				
				<input type="file" size="40" id="fileName" name="fileName" />
				<a href="downloadFormFile.do?form_file_code=1">Form Download</a>
				<input type="button" id="btn_Upload" name="btn_Upload" value="Upload" class="btn_gray"/>
				<input type="button" id="btn_Clear" name="btn_Clear" value="Clear"  class="btn_gray"/>

				
				<div class="button endbox">
						<input type="button" id="btn_Update" name="btn_Update" value="Action Update" class="btn_gray"/>
					</div>
	
				</div>
				</div>	
				-->
					
				
				<table class="searchArea conSearch">
						<col width="*">
						<col width="*">

						<tr>
						<td style="border-right:none;">
						<input type="file" size="40" id="fileName" name="fileName" style="font-family:'돋움';"/>
						<a href="downloadFormFile.do?form_file_code=1" style="border:1px solid #000;padding:5px 5px;color:#fff; background:#000; border-radius:5px;">Form Download</a>
						<input type="button" id="btn_Upload" name="btn_Upload" value="Upload" class="btn_gray"/>
						<input type="button" id="btn_Clear" name="btn_Clear" value="Clear"  class="btn_gray"/>
						</td>
						<td style="border-left:none;">
						<div class="button endbox">
							<input type="button" id="btn_Update" name="btn_Update" value="Action Update" class="btn_gray"/>
						</div>
						</td>
						</tr>
					</table>
					

					<!--
					<div class="conSearch">
						<input type="file" size="40" id="fileName" name="fileName" />
						<a href="downloadFormFile.do?form_file_code=1">Form Download</a>
						<input type="button" id="btn_Upload" name="btn_Upload" value="Upload" />
						<input type="button" id="btn_Clear" name="btn_Clear" value="Clear" />
					</div>
					<div class="button">
						<input type="button" id="btn_Update" name="btn_Update" value="Action Update" />
					</div>
					-->
				
				<div class="content">
					<table id="itemAttributeUpdateList"></table>
					<div id="pitemAttributeUpdateList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var lodingBox;
		
		$(document).ready( function() {
			var objectHeight = gridObjectHeight(1);
			
			//화면초기화
			fn_init();
			
			$( "#itemAttributeUpdateList" ).jqGrid( {
				url : 'updateItemAttributeList.do',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'Item Name', 'Description', 'Weight(Kg)', 
				             'Attr1', 'Attr2', 'Attr3', 'Attr4', 'Attr5', 
				             'Attr6', 'Attr7', 'Attr8', 'Attr9', 'Attr10', 
				             'Attr11', 'Attr12', 'Attr13', 'Attr14', 'Attr15', 
				             'Cable Outdia', 'CAN Size', 'SVR(Solidity)', 
				             'Thinner Code', 'Paint Code', 
				             'Cable Type', 'Cable Lenth', 'STXStandard', 'TBC Paint Code', 'plmflag', 'erpflag', 'upload_date' ],
				colModel : [ { name : 'item', index : 'item' },
				             { name : 'item_desc', index : 'item_desc' },
				             { name : 'weight', index : 'weight' },
				             
				             { name : 'attr0', index : 'attr0' },
				             { name : 'attr1', index : 'attr1' },
				             { name : 'attr2', index : 'attr2' },
				             { name : 'attr3', index : 'attr3' },
				             { name : 'attr4', index : 'attr4' },
				             
				             { name : 'attr5', index : 'attr5' },
				             { name : 'attr6', index : 'attr6' },
				             { name : 'attr7', index : 'attr7' },
				             { name : 'attr8', index : 'attr8' },
				             { name : 'attr9', index : 'attr9' },
				             
				             { name : 'attr10', index : 'attr10' },
				             { name : 'attr11', index : 'attr11' },
				             { name : 'attr12', index : 'attr12' },
				             { name : 'attr13', index : 'attr13' },
				             { name : 'attr14', index : 'attr14' },
				             
				             { name : 'cable_outdia', index : 'cable_outdia' },
				             { name : 'can_size', index : 'can_size' },
				             { name : 'stxsvr', index : 'stxsvr' },
				             { name : 'thinner_code', index : 'thinner_code' },
				             { name : 'paint_code', index : 'paint_code' },
				             { name : 'cable_type', index : 'cable_type' },
				             { name : 'cable_length', index : 'cable_length' },
				             { name : 'stxstandard', index : 'stxstandard' },
				             { name : 'tbc_paint_code', index : 'tbc_paint_code' },
				             
				             { name : 'plmflag', index : 'plmflag' }, 
				             { name : 'erpflag', index : 'erpflag' },
				             { name : 'upload_date', index : 'upload_date' } ],
				rowNum : 1000,
				rowList : [ 100, 500, 1000 ],
				pager : '#pitemAttributeUpdateList',
				sortname : 'item',
				viewrecords : true,
				sortorder : "desc",
				//shrinkToFit : false,
				autowidth : true,
				rownumbers:true,
				height : objectHeight,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				emptyrecords : '데이터가 존재하지 않습니다.',
				imgpath : 'themes/basic/images',
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
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
					if ( $this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
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

						if ( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
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
					
					if( $( "#itemAttributeUpdateList" ).jqGrid( 'getGridParam','records' ) > 0 ) {
						$( "#btn_Update" ).removeAttr( "disabled" );
						$( "#btn_Update" ).removeClass("btn_gray");
						$( "#btn_Update" ).addClass("btn_blue");
					}
				}
			} );
			
			//grid resize
		    fn_gridresize( $(window), $( "#itemAttributeUpdateList" ) );
			
			//찾아보기 추가 시 Upload, Clear 버튼 활성화
			$( "#fileName" ).change( function() {
				$( "#btn_Upload" ).removeAttr( "disabled" );
				$( "#btn_Upload" ).removeClass("btn_gray");
				$( "#btn_Upload" ).addClass("btn_blue");
				
				$( "#btn_Clear" ).removeAttr( "disabled" );
				$( "#btn_Clear" ).removeClass("btn_gray");
				$( "#btn_Clear" ).addClass("btn_blue");
			} );
			
			//Excel Upload
			$( "#btn_Upload" ).click( function() {
				checkInput();
			} );
			
			//Clear 버튼 클릭 시 file 및 버튼 비활성화
			$( "#btn_Clear" ).click( function() {
				fn_clear();
			} );
			
			//Action Update 버튼 클릭
			$( "#btn_Update" ).click( function() {
				doSubmit();
			} );
		} );
		
		//화면초기화(Update, Clear, Action Update 버튼 비활성화)
		function fn_init(){
			$( "#btn_Upload" ).attr( "disabled", true );
			$( "#btn_Upload" ).removeClass("btn_blue");
			$( "#btn_Upload" ).addClass("btn_gray");
			
			$( "#btn_Clear" ).attr( "disabled", true );
			$( "#btn_Clear" ).removeClass("btn_blue");
			$( "#btn_Clear" ).addClass("btn_gray");
			
			$( "#btn_Update" ).attr( "disabled", true );
			$( "#btn_Update" ).removeClass("btn_blue");
			$( "#btn_Update" ).addClass("btn_gray");
		}
		
		//Clear(file 및 버튼 비활성화)
		function fn_clear() {
			
			$( "#clearFlag" ).val("Y");
			$( '#application_form' ).submit();
			
			$( '#fileName' ).each( function() {
				$(this).after( $(this).clone(true) ).remove();
			} );
			
			$( "#btn_Upload" ).attr( "disabled", true );
			$( "#btn_Upload" ).removeClass("btn_blue");
			$( "#btn_Upload" ).addClass("btn_gray");
			
			$( "#btn_Clear" ).attr( "disabled", true );
			$( "#btn_Clear" ).removeClass("btn_blue");
			$( "#btn_Clear" ).addClass("btn_gray");
			
			$( "#btn_Update" ).attr( "disabled", true );
			$( "#btn_Update" ).removeClass("btn_blue");
			$( "#btn_Update" ).addClass("btn_gray");
		}
		
		//Excel Upload
		function checkInput() {
			var fName = $( "#fileName" ).val();
			
			if( fName == "" || fName == null ) {
				alert( "Please select excel file to update." );
				return false;
			} else {
				$( '#application_form' ).submit();
				
			}
		}
		
		//temp table to plm and erp sending
		function doSubmit() {
			alert( "It takes a long time.\nPlease wait for a while it is completed." );
			
			var chmResultRows = [];
			
			chmResultRows = $( "#itemAttributeUpdateList" ).jqGrid( 'getRowData' );
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

			var url = "updatePlmErpDB.do";
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	lodingBox.remove();	
			} );
		}
		
		//조회
		function fn_search() {
			var sUrl = "updateItemAttributeList.do";
			$( "#itemAttributeUpdateList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
			$( "#clearFlag" ).val("N");
		}
		</script>
	</body>
</html>