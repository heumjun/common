<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수신문서_참조메일</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<form id="application_form" name="application_form" method="post" action="">
		
		<input type="hidden" name="dwg_dept_code" id="dwg_dept_code"  value="${loginUser.dwg_dept_code}" />
		<input type="hidden" id="before_res" name="before_res" class="select_input">
		<input type="hidden" id="res" name="res" class="select_input">
		<input type="hidden" id="res_name" name="res_name" class="select_input">
		<input type="hidden" id="p_etc_user_id" name="p_etc_user_id" value="${p_etc_user_id }" />
		<input type="hidden" id="p_etc_user" name="p_etc_user" value="${p_etc_user }" />
		
		
		<div class="topMain" style="margin: 0px; line-height: 23px;">
			<div class="conSearch">
				부서 : 
				<select name="p_sel_receipt_dept" id="p_sel_receipt_dept" class="h25" style="text-transform:uppercase; width:120px;" onchange="javascript:deptChage(this.value)" >
					<option value="000002">설계운영P</option>
				</select>
			</div>
		</div>
		
		<div style=" width:580px; margin:0 auto">
    		<div style="margin:10px 0; float:left; width:580px;">	
        
	            <div style="float:left;">
	                <select id="leftGrid" name="leftGrid" ondblclick="call.movetoright();" multiple="multiple" class="select_left" style="display:block;width:243px;height:500px;overflow:scroll;">
	                </select>
	            </div>
	            <div style=" float:left; padding:8px;">
	            	<p style="padding-top:200px; padding-bottom:12px;"><img src="/images/icon_right.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.movetoright();"></p>
	                <p><img src="/images/icon_left.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.movetoleft();"></p>
	            </div>
	            <div style=" float:left;">
	                <select id="rightGrid" name="rightGrid" ondblclick="call.movetoleft();" style=" width:243px; border:1px solid #ccc; overflow:visible; height:500px;" class="select_right" multiple="multiple">
	                </select>
	            </div>

    		</div>
	</form>
	<div style="float: right; padding: 5px 5px; margin-right: 35px;" >
		<input type="button" class="btnAct btn_blue" id="btnConfirm" name="btnConfirm" value="확인" />
	</div>

	<script type="text/javascript">
	
		if(typeof($("#p_sel_receipt_dept").val()) !== 'undefined'){
			getAjaxHtml($("#p_sel_receipt_dept"), "commentReceiptUserEtcDeptSelectBoxDataList.do?sb_type=all&p_dept_code="+$("input[name=dwg_dept_code]").val(), null, null);
		}
		
		function deptChage(deptCode) {
			
			var jsonObj;

			$.ajax({ 
				async: false,
				url: "commentReceiptUserList.do?p_dept_code="+deptCode, 
				data:jsonObj,
				dataType:'json',
				type:'GET', 
				success:function(jsonObj)
				{
					var rtSlt = '';
					$("select[name='leftGrid']").empty();
					for ( var idx=0 ; idx < jsonObj.length ; idx++) {
						rtSlt += '<option value="' + jsonObj[idx].sb_value + '">' + jsonObj[idx].sb_name + '</option>';	
					}
					$("select[name='leftGrid']").append(rtSlt);
				}, 
				error:function(jxhr,textStatus)
				{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
					if(textStatus=="parsererror") 
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				}  
			}); 
			
			
			var rtSlt = '';
			//$("select[name='rightGrid']").empty();
			var p_etc_user_id = $("#p_etc_user_id").val();
			var p_etc_user = $("#p_etc_user").val();
			if(p_etc_user_id.indexOf(",") > 0) {
				
				var arr_user_id = p_etc_user_id.split(',');
				var arr_user = p_etc_user.split(',');
				
					for ( var i in arr_user_id ) {
						$("select[name='leftGrid']").find("option").each(function(){
							if(arr_user_id[i] == this.value) {
								$(this).remove();
							}
						});
						
						//rtSlt += '<option value="' + arr_user_id[i] + '">' + arr_user[i] + '</option>';	
						
					}
			} else if(p_etc_user_id != '') {
				$("select[name='leftGrid']").find("option").each(function(){
					if(p_etc_user_id == this.value) {
						$(this).remove();
					}
				});
				
				//rtSlt += '<option value="' + p_etc_user_id + '">' + p_etc_user + '</option>';
			}
			
			//$("select[name='rightGrid']").append(rtSlt);
			
			
		}
	
		function selectList() {};
		
		selectList.prototype = {
		    sel_left: ".select_left",
		    sel_right: ".select_right",
		    sel_input: ".select_input",
		    movetoright: function () {
		        var sel_left = $(this.sel_left);
		        var sel_right = $(this.sel_right);
		        var select_html = "";
		        if (sel_left.find("option:selected").size() > 0) {
		            res = new Array();
		            sel_left.find("option:selected").each(function (i) {
		                //소메뉴만 담기
		                select_html += "<option value='" + sel_left.find("option:selected").eq(i).attr("value") + "'>" + sel_left.find("option:selected").eq(i).html() + "</option>";
		                res[i] = sel_left.find("option:selected").eq(i).val();
		            });
		            sel_right.append(select_html);
		            sel_left.find("option:selected").remove();
		            this.hiddenvalue();
		        }
		        else {
		            this.warning();
		        }
		    },
		    movetoleft: function () {
		    	var sel_left=$(this.sel_left);
				var sel_right=$(this.sel_right);
				var select_html="";
				if(sel_right.find("option:selected").size()>0){
					sel_right.find("option:selected").each(function(i){
						 select_html+="<option value='"+sel_right.find("option:selected").eq(i).attr("value")+"'>"+sel_right.find("option:selected").eq(i).html()+"</option>";
					});
					sel_left.append(select_html);
					sel_right.find("option:selected").remove();
					this.hiddenvalue();
				}else{
					this.warning();
				}
		    },

		    hiddenvalue: function () {
		        var sel_right = $(this.sel_right);
		        var _cnt = sel_right.find("option").size();
		        var res = new Array();
		        var res_name = new Array();

		        for (var i = 0; i < _cnt; i++) {
		            res[i] = sel_right.find("option").eq(i).val();
		            res_name[i] = sel_right.find("option").eq(i).text();
		        }
		        
		        res = res.join(",");
		        res_name = res_name.join(",");
		        $("#res").val(res);
		        $("#res_name").val(res_name);
		    },
		    call: function () {},
		    warning: function () { //없을 경우는 false를 반환할지 여부를 선택.
		        alert("선택하세요!");
		    }
		};	
	
		var call = new selectList();	
		
		$(document).ready(function() {

			call.hiddenvalue();
			
			var jsonObj;

			$.ajax({ 
				async: false,
				url: "commentReceiptUserList.do?p_dept_code="+$("input[name=dwg_dept_code]").val(), 
				data:jsonObj,
				dataType:'json',
				type:'GET', 
				success:function(jsonObj)
				{
					var rtSlt = '';
					$("select[name='leftGrid']").empty();
					for ( var idx=0 ; idx < jsonObj.length ; idx++) {
						rtSlt += '<option value="' + jsonObj[idx].sb_value + '">' + jsonObj[idx].sb_name + '</option>';	
					}
					$("select[name='leftGrid']").append(rtSlt);
				}, 
				error:function(jxhr,textStatus)
				{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
					if(textStatus=="parsererror") 
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				}  
			});
			
			//$("input[name=p_receipt_team_code]").val($(obj).find("option:selected").val());

			$("#btnConfirm").click(function() {
				
				var args = window.dialogArguments;
				
				args.$("#etcMailList").text($("#res_name").val());
				args.$("#p_etc_user_id").val($("#res").val());
				
				self.close();
				
			});
			
			var rtSlt = '';
			$("select[name='rightGrid']").empty();
			var p_etc_user_id = $("#p_etc_user_id").val();
			var p_etc_user = $("#p_etc_user").val();
			if(p_etc_user_id.indexOf(",") > 0) {
				
				var arr_user_id = p_etc_user_id.split(',');
				var arr_user = p_etc_user.split(',');
				
					for ( var i in arr_user_id ) {
						$("select[name='leftGrid']").find("option").each(function(){
							if(arr_user_id[i] == this.value) {
								$(this).remove();
							}
						});
						
						rtSlt += '<option value="' + arr_user_id[i] + '">' + arr_user[i] + '</option>';	
						
					}
			} else if(p_etc_user_id != '') {
				$("select[name='leftGrid']").find("option").each(function(){
					if(p_etc_user_id == this.value) {
						$(this).remove();
					}
				});
				
				rtSlt += '<option value="' + p_etc_user_id + '">' + p_etc_user + '</option>';
			}
			
			$("select[name='rightGrid']").append(rtSlt);
			
			
			
		});
		
	</script>	
	
</body>
</html>