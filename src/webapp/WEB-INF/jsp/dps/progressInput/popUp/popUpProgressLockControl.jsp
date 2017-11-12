<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>입력제한</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="loginID" value='<c:out value="${loginID }"/>'/>
				<div id="dataListDiv">
					<table id="dataList"></table>
					<div id="pDataList"></div>
				</div>
			</form>
		</div>
		<div style="clear: both; text-align: right;">
			<input type="button" value="저장"  id="btnOk" class="btn_blue" onclick="fn_saveProject('dataList');"/>
			<input type="button" value="닫기"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>
	
	<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		$(document).ready( function() {
			fn_all_text_upper();
			var objectHeight = gridObjectHeight(1);
			
			$( "#dataList" ).jqGrid( {
				url:'popUpProgressInputLock.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['부서코드','부서명','입력가능일','oper'],
				colModel : [{name : 'dept_code', index : 'dept_code', width: 120, align : "center" },
							{name : 'dept_name', index : 'dept_name', width: 220, align : "center"},
							{name : 'lock_date', index : 'lock_date', width: 120, align : "center", editable:true, edittype:"text",
								editoptions:{
									dataEvents : [ //숫자외 기타 입력 방지
									              {type:'keyup', fn:function(e) {
									            	 					if(!numCheck(this.value)){
									            	 						e.preventDefault();
									            	 						$(e.target).val($(e.target).val().substr(0,$(e.target).val().length-1));
									            		 				}
									            					}
									              },//int로 변경
									              {type:'focusout', fn:function(e) {
								            	  				e.preventDefault();
								            	  				if(this.value != ''){
								            	  					$(e.target).val(parseInt($(e.target).val()));
								            	  				}
					            					}
					              				  },
					              				  {
					              					  type:'change', fn:function(e) {
					              						e.preventDefault();
					              						var row = $(e.target).closest('tr.jqgrow');
					                                    var rowid = row.attr('id');
					                                    $( "#dataList" ).jqGrid( 'setCell', rowid, 'oper', 'U');
					              					  }
					              				  }
									              ] 
							}},
							{name : 'oper', index : 'oper', width: 120, align : "center", hidden:true}
				           ],
				gridview : true,
				cmTemplate: { title: false,sortable: false},
				toolbar : [ false, "bottom" ],
				hidegrid: false,
				viewrecords : true,
				caption : '선택 호선',
				autowidth : true, //autowidth: true,
				height : objectHeight,
				rowNum : -1,
				rownumbers: true,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : jQuery('#pDataList'),
				pgbuttons: false,     // disable page control like next, back button
			    pgtext: null,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				jsonReader : {
					//id : "item_code",
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
				},
				gridComplete : function() {
					var rows = $( "#dataList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						/* "#ffffe0" */
						 $( "#dataList" ).jqGrid( 'setCell', rows[i], 'lock_date', '', { background : "#ffffe0" } );
					}
				}
			});
			//grid resize
			$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} );
			/* fn_insideGridresize($(window), $("#dataListDiv"), $("#dataList")); */
			resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.60);
			
		});
		function fn_saveProject(saveGrid){
			var loadingBox  = new ajaxLoader( $( '#mainDiv' ));
			var formData = fn_getFormData('#application_form');
			$( '#dataList' ).saveCell( kRow, kCol );
			
			getGridChangedData($( "#"+saveGrid ),function(data) {
				changeRows = data;
				
				if (changeRows.length == 0) {
					alert("저장할 내용이 없습니다.");
					loadingBox.remove();
					return;
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);
			
				if(confirm('저장하시겠습니까?')){
					
					$.post("popUpProgressInputLockMainGridSave.do",parameters ,function(data){
						alert("저장완료하였습니다");
						window.close();
					},"json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				} else {
					loadingBox.remove();
				}
			});
		}
		//숫자 정수 체크
		function numCheck(obj){
			 var num_check=/^[+-]?[0-9]*$/;
				if(!num_check.test(obj)){
				return false;
	 		}
			return true;
		}
	</script>
</body>
</html>