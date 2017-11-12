<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Life Cycle</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" id="main_code" name="main_code" />
			<input type="hidden" id="states_code" name="states_code" />
			<input type="hidden" id="states_desc" name="states_desc" />
			<input type="hidden" id="states_type" name="states_type" />
			<input type="hidden" id="states_main_category" name="states_main_category" />
			<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
			<input type="hidden" id="admin_yn" name="admin_yn" value="${loginUser.admin_yn}" />
			<input type="hidden" id="main_name" name="main_name" />
			<% String divCloseFlag = request.getParameter("divCloseFlag") == null ? "" : request.getParameter("divCloseFlag").toString(); %>
			<input type="hidden" id="divCloseFlag" name="divCloseFlag" value="<%=divCloseFlag %>" />
			
			<input type="hidden" id="promote" name="promote" />
<!-- 			<div id="promotedemmote" style="display: none;"> -->
			<div id="promotedemmote" style="margin-top:10px;margin-left: 10px;">
			<table>
			<col width="600"/>
			<col width="*"/>
				<td>
					<input type="button" id="btnDemote" name="btnDemote" value="Demote" class="btn_blue" />
					<input type="button" id="btnPromote" name="btnPromote" value="Promote" class="btn_blue" />
					<input type="button" id="btnCancel" name="btnCancel" value="Cancel" class="btn_blue" />
					Comments : 
					<input type="text" id="notify_msg" name="notify_msg" size="20" style="width:300px;height:20px">
				</td>
				<td id="state_code"></td>
			</table>	
			</div>
			<div id="ecrLifeCycleDiv" style="margin-top : 10px;" >
				<table id="ecrLifeCycle"></table>
				<div id="pecrLifeCycle"></div>
			</div>
	
		</form>
		<script type="text/javascript">
			var resultData = [];
			var maincode = window.parent.$("#main_code").val();
			var states_code = window.parent.$("#states_code").val();
			var states_type = window.parent.$("#states_type").val();
			var states_main_category = window.parent.$("#states_main_category").val();
			var states_desc = window.parent.$("#states_desc").val();
			var main_name = window.parent.$("#ref_main_name").val();
			
			
			$("#main_code").val( maincode );
			$("#states_code").val( states_code );
			$("#states_type").val( states_type );
			$("#states_main_category").val( states_main_category );
			$("#states_desc").val( states_desc );
			$("#main_name").val( main_name );
			
			$(document).ready( function() {
				
				fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
				
				$("#ecrLifeCycle").jqGrid( {
					datatype : 'json',
					mtype : '',
					url : '',
					editUrl : 'clientArray',
					colNames : [ 
									'ECR Name', 
									'상태', 
									'Related Project', 
									'기술변경내용', 
									'관련자',
									'기술변경원인', 
									'평가자', 
									'결재자',
									'작업자', 
									'작성자'
								],
					colModel : [
									{ hidden : false, name : 'main_name', index : 'main_name', align : 'center', width : 90 },
									{ hidden : false, name : 'states_desc', index : 'states_desc', align : "center", width : 60 },
									{ hidden : false, name : 'eng_change_related_project', index : 'eng_change_related_project', align : "left", width : 100 },
									{ hidden : false, name : 'eng_change_description', index : 'eng_change_description', width : 270, edittype : "textarea", editoptions : { rows : "3", cols : "40" } },
									{ hidden : false, name : 'related_person_emp_name', index : 'related_person_emp_name', width : 220 },
									{ hidden : true, name : 'eng_change_based_on', index : 'eng_change_based_on', align : 'left', width : 350 },
									{ hidden : true, name : 'user_code', index : 'user_code', align : 'left', width : 220 },
									{ hidden : false, name : 'design_engineer', index : 'design_engineer', align : "left", width : 220 },
									{ hidden : true, name : 'locker_by_name', index : 'locker_by_name', align : "left", width : 220 },
									{ hidden : false, name : 'created_by_name', index : 'created_by_name', align : 'left', width : 220 }
								],
					gridview : true,
					cmTemplate: { title: false },
					toolbar : [ false, "bottom" ],
					viewrecords : true,
					autowidth : true,
					height : parent.objectHeight-168,
					//shrinkToFit : false,
					caption : "Life Cycle",
					hidegrid : false,
					pager : $('#pecrLifeCycle'),
					pgbuttons : false,
					pgtext : false,
					pginput : false,
					cellEdit : true, // grid edit mode 1
					cellsubmit : 'clientArray', // grid edit mode 2
					rowNum : -1,
					jsonReader : {
						root : "rows",
						page : "page",
						total : "total",
						records : "records",
						repeatitems : false,
					},
					imgpath : 'themes/basic/images'
				} );
				fn_gridresize( parent.objectWindow, $( "#ecrLifeCycle" ) ,-67,0.5 );
				//fn_jqGridsetHeight( $( "#divCloseFlag" ).val(), "ecrLifeCycle", screen.height );
				
				/* if( main_name == "" ) {
					$("#ecrLifeCycle").jqGrid( "setCaption", 'Life Cycle' );
				} else {
					$("#ecrLifeCycle").jqGrid( "setCaption", 'Life Cycle - ' + main_name );
				} */
				
				
				
				//Promote
				$( "#btnPromote" ).click( function() {
					if( $("#ecrLifeCycle").getRowData().length == 0 ) {
						alert( "선택된 ECR이 없습니다." );
					} else {
						$("#promote").val("promote");
						
						var chmResultRows=[];
						
						//변경된 row만 가져 오기 위한 함수
						getChangedChmResultData( function( data ) {
							chmResultRows = data;
						
							var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
							var url = 'ecrPromoteDemote.do';
							var formData = getFormData('#application_form');
							
							//객체를 합치기. dataList를 기준으로 formData를 합친다.
							var parameters = $.extend( {}, dataList, formData ); 
							
							$.post( url, parameters, function( data ) {
								
								alert(data.resultMsg);
								if ( data.result == 'success' ) {
									window.parent.fn_search("#tabs-2");
								}
							}, "json" );
							
							$('#ecrLifeCycle').resetSelection();
						});
					}
				} );
				
				//Demote
				$( "#btnDemote" ).click( function() {
					if( $("#ecrLifeCycle").getRowData().length == 0 ) {
						alert( "선택된 ECR이 없습니다." );
					} else {
						if( $( "#notify_msg" ).val() == "" ) {
							alert( "Comment를 입력해주세요." );
							$( "#notify_msg" ).focus();
							return;
						}
						
						$("#promote").val("demote");
						
						var chmResultRows=[];
						
						//변경된 row만 가져 오기 위한 함수
						getChangedChmResultData( function( data ) {
							chmResultRows = data;
						
							var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
							var url = 'ecrPromoteDemote.do';
							var formData = getFormData('#application_form');
							
							//객체를 합치기. dataList를 기준으로 formData를 합친다.
							var parameters = $.extend( {}, dataList, formData ); 
							
							$.post( url, parameters, function( data ) {
								
								alert(data.resultMsg);
								if ( data.result == 'success' ) {
									window.parent.fn_search("#tabs-2");
								}
							}, "json" );
							
							$('#ecrLifeCycle').resetSelection();
						});
					}
				} );
				
				//Cancel
				$( "#btnCancel" ).click( function() {
					if( $("#ecrLifeCycle").getRowData().length == 0 ) {
						alert( "선택된 ECR이 없습니다." );
					} else {
						if( $( "#notify_msg" ).val() == "" ) {
							alert( "Comment를 입력해주세요." );
							$( "#notify_msg" ).focus();
							return;
						}
						
						$("#promote").val("cancel");
						
						var chmResultRows=[];
						
						//변경된 row만 가져 오기 위한 함수
						getChangedChmResultData( function( data ) {
							chmResultRows = data;
						
							var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
							var url = 'ecrPromoteDemote.do';
							var formData = getFormData('#application_form');
							
							//객체를 합치기. dataList를 기준으로 formData를 합친다.
							var parameters = $.extend( {}, dataList, formData ); 
							
							$.post( url, parameters, function( data ) {
								alert(data.resultMsg);
								if ( data.result == 'success' ) {
									fn_search();
								}
							}, "json" );
							
							$('#ecrLifeCycle').resetSelection();
						});
					}
				} );
			} );
			//폼데이터를 Json Arry로 직렬화
			function getFormData(form) {
			    var unindexed_array = $(form).serializeArray();
			    var indexed_array = {};
				
			    $.map(unindexed_array, function(n, i){
			        indexed_array[n['name']] = n['value'];
			    });
				
			    return indexed_array;
			};
			
			function getChangedChmResultData( callback ) {
				var changedData = $.grep( $( "#ecrLifeCycle" ).jqGrid( 'getRowData' ), function ( obj ) {
					return obj;
					//obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D'; 
				} );
				
				callback.apply( this, [changedData.concat( resultData ) ] );
			};
			
			//Promote / Demote 가능여부 체크
			function fn_IsAuthApprove() {
				
				var url = 'infoIsAuthApprove.do';
				var formData = getFormData('#application_form');
				//$("#promotedemmote").hide();
				if( formData.main_code != "" ) {
					$.post( url, formData, function( data ) {
						if( data.is_auth_approve == "Y" || $("#admin_yn").val() == 'Y') {
							if( $( "#states_desc" ).val() == "Cancel" ) {
								fn_buttonDisabled( ["#btnDemote", "#btnPromote", "#btnCancel"] );
							} else {
								//Promote or Demote button enable & disable
								if( $( "#states_desc" ).val() == "Create" ) {
									fn_buttonDisabled( ["#btnDemote"] );
									fn_buttonEnable( ["#btnPromote", "#btnCancel"] );
								} else if( $( "#states_desc" ).val() == "Evaluate" ) {
									fn_buttonDisabled( ["#btnCancel"] );
									fn_buttonEnable( ["#btnDemote", "#btnPromote"] );
								} else if( $( "#states_desc" ).val() == "Review" ) {
									fn_buttonDisabled( ["#btnCancel"] );
									fn_buttonEnable( ["#btnDemote", "#btnPromote"] );
								} else if( $( "#states_desc" ).val() == "Plan ECO" ) {
									fn_buttonDisabled( ["#btnDemote", "#btnPromote", "#btnCancel"] );
									if($("#admin_yn").val() == 'Y') {
										fn_buttonEnable( ["#btnDemote"] );	
									}
								} else if( $( "#states_desc" ).val() == "Complete" ) {
									fn_buttonDisabled( ["#btnDemote", "#btnPromote", "#btnCancel"] );
									if($("#admin_yn").val() == 'Y') {
										fn_buttonEnable( ["#btnDemote"] );	
									}
								}
							}
						}
					}, "json" ).error( function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					} ).always( function() {
						//lodingBox.remove();
					} );
				}
			}
			function fn_search() {
				fn_buttonDisabled([ "#btnPromote", "#btnDemote", "#btnCancel" ]);
				if(window.parent.$("#main_code").val() == "") {
					alert('ECR 선택후 조회 바랍니다.');
				} else {
					$("#states_code").val(window.parent.$("#states_code").val());
					$("#states_desc").val(window.parent.$("#states_desc").val());
					$("#main_code").val(window.parent.$("#main_code").val());
					$("#ecrLifeCycle").jqGrid("setCaption", 'Life Cycle - ' + window.parent.$("#ref_main_name").val());
					
					//window.parent.fn_search();
					var stateImg = '';
					if($("#states_code").val() == 'CREATE') {
						stateImg = '<img src=\"/images/ecr/create.png\"/>';
					} else if($("#states_code").val() == 'REVIEW') {
						stateImg = '<img src=\"/images/ecr/review.png\"/>';
					} else if($("#states_code").val() == 'PLAN_ECO') {
						stateImg = '<img src=\"/images/ecr/plan.png\"/>';
					} else if($("#states_code").val() == 'CANCEL') {
						stateImg = '<img src=\"/images/ecr/cancel.png\"/>';
					} else if($("#states_code").val() == 'EVALUATE') {
						stateImg = '<img src=\"/images/ecr/evaluate.png\"/>';
					} else if($("#states_code").val() == 'COMPLETE') {
						stateImg = '<img src=\"/images/ecr/complete.png\"/>';
					}
					$("#state_code").html(stateImg);
					
					fn_IsAuthApprove();
					
					var sUrl = "ecrLifeCycleList.do";
					//alert(sUrl);
					$("#ecrLifeCycle").jqGrid('setGridParam', {
						url : sUrl,
						mtype : 'POST',
						page : 1,
						postData : $("#application_form").serialize()
					}).trigger("reloadGrid");

					//재조회 후 promotedemmote 숨김
					//$("#promotedemmote").hide();
					//$("#ecoLifeCycleList").setGridHeight(295);
				}
				/* 
				
				window.parent.fn_search();
				var sUrl = 'ecrLifeCycleList.do?main_code='+maincode;
				$("#ecrLifeCycle").jqGrid( 'setGridParam', {
					url : sUrl,
					page : 1,
					postData : $("#application_form").serialize()
				} ).trigger("reloadGrid");
				
				//재조회 후 promotedemmote 숨김
				$("#promotedemmote").hide(); */
			}
		</script>
	</body>
</html>
