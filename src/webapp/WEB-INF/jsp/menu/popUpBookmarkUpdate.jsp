<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Bookmark 편집</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<form id="application_form" name="application_form" method="post" action="">
		<div
			style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
			<!-- 			<img src="/images/main/info_tit.gif" /> -->
			<img src="/images/main/tit_bookmark.gif" style="padding-top: 10px; padding-bottom: 6px; padding-left: 10px;" />
		</div>
		
		<input type="hidden" id="roleCode" name="roleCode" value="${roleCode}" >
		<input type="hidden" id="before_res" name="before_res" class="select_input">
		<input type="hidden" id="res" name="res" class="select_input">
		
<div style=" width:580px; margin:0 auto">
    <div style="margin:10px 0; float:left; width:580px;">	
        
            <div style="float:left;">
                <select id="leftGrid" name="leftGrid" ondblclick="call.movetoright();" multiple="multiple" class="select_left" style="display:block;width:243px;height:500px;overflow:visible;">
                    <c:forEach var="item" items="${gridLeftList}" varStatus="status">
						<option id="${item.order_by}" title="${item.lev}" value="<c:out value="${item.menu_id}" />" <c:if test="${item.lev == 1}"> style="font-weight:bold; background-color:#003380; color:#ffffff;" </c:if>>
							<c:if test="${item.lev == 2}">&nbsp;▷</c:if>
							<c:out value="${item.pgm_name}" />
						</option>
					</c:forEach>
                </select>
            </div>
            <div style=" float:left; padding:8px;">
            	<p style="padding-top:200px; padding-bottom:12px;"><img src="./images/icon_right.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.movetoright();"></p>
                <p><img src="./images/icon_left.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.movetoleft();"></p>
            </div>
            <div style=" float:left;">
                <select id="rightGrid" name="rightGrid" ondblclick="call.movetoleft();" style=" width:243px; border:1px solid #ccc; overflow:visible; height:500px;" class="select_right" multiple="multiple">
                	<c:forEach var="item" items="${gridRightList}" varStatus="status">
						<option id="${item.order_by}" value="<c:out value="${item.menu_id}" />" <c:if test="${item.lev == 1}"> style="font-weight:bold; background-color:#003380; color:#ffffff;" </c:if>>
							<c:if test="${item.lev == 2}">&nbsp;▷</c:if>
							<c:out value="${item.pgm_name}" />
						</option>
					</c:forEach>
                </select>
                <p style="margin-top:5px">
<!--                     <strong><a href="javascript:call.top();" title="">최상위</a></strong> -->
<!--                     <strong><a href="javascript:call.up();" title="">위로</a></strong> -->
<!--                     <strong><a href="javascript:call.down();" title="">아래로</a></strong> -->
<!--                     <strong><a href="javascript:call.bottom();" title="">최하위</a></strong> -->
					선택 항목 수&nbsp;
                    <input type="text" id="countList" name="countList" class="select_input" style="width:40px; text-align:center;" >
                </p>
            </div>
            <div style=" float:left; padding:8px 0 8px 8px;">
            	<p style="padding-top:0px; padding-bottom:12px;">
            		<img src="./images/icon_top.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.top();">
            	</p>
            	<p style="padding-bottom:12px;">
            		<img src="./images/icon_up.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.up();">
            	</p>
            	<p style="padding-bottom:12px;">
            		<img src="./images/icon_down.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.down();">
            	</p>
                <p style="padding-bottom:12px;">
                	<img src="./images/icon_bottom.png" border="0" style="cursor:pointer;vertical-align:middle;" onclick="call.bottom();">
                </p>
            </div>

			
      
    </div>
	</form>
	<div style="float: right; padding: 5px 5px;">
		<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
	</div>
	<script type="text/javascript">
	
		function selectList(){};
		selectList.prototype={
			sel_left:".select_left",
			sel_right:".select_right",
			sel_input:".select_input",
			movetoright:function(){
				var sel_left=$(this.sel_left);
				var sel_right=$(this.sel_right);
				var select_html="";
				if(sel_left.find("option:selected").size()>0){
					res = new Array();
					sel_left.find("option:selected").each(function(i){
						//소메뉴만 담기
						if(sel_left.find("option:selected").eq(i).attr("title") == '2'){
							select_html+="<option value='"+sel_left.find("option:selected").eq(i).attr("value")+"' id='" + sel_left.find("option:selected").eq(i).attr("id") + "'>"+sel_left.find("option:selected").eq(i).html()+"</option>";
							res[i] = sel_left.find("option:selected").eq(i).val();
						}
					});
					sel_right.append(select_html);
					sel_left.find('option:selected[title!="1"]').remove();
					this.hiddenvalue();
				}else{
					this.warning();
				}
				$("#countList").val($("#rightGrid")[0].length + "/15");
			},
			movetoleft:function(){
				var sel_left=$(this.sel_left);
				var sel_right=$(this.sel_right);
				var select_html="";
				if(sel_right.find("option:selected").size()>0){
					sel_right.find("option:selected").each(function(i){
						 select_html+="<option value='"+sel_right.find("option:selected").eq(i).attr("value")+"' id='" + sel_right.find("option:selected").eq(i).attr("id") + "' title='2'>"+sel_right.find("option:selected").eq(i).html() + "</option>";
					});
					
					sel_left.append(select_html);
					sel_right.find("option:selected").remove();
					this.hiddenvalue();
				}else{
					this.warning();
				}
				// select box sort 
				var sort = $("select[name='leftGrid']>option").sort( 
	                  function(a,b) { return a.id*1 > b.id*1 ? 1 : -1; } 
				);
				$("select[name='leftGrid']").empty();         // 기존데이터 지우고
				$("select[name='leftGrid']").append(sort); // 정렬된 데이터 넣어주고
				$("#countList").val($("#rightGrid")[0].length + "/15");
			},
		
			hiddenvalue:function(){
				var sel_right=$(this.sel_right);
				var _cnt = sel_right.find("option").size();
				var res = new Array();
		
				for (var i=0; i<_cnt; i++) {
					res[i] = sel_right.find("option").eq(i).val();
		          }
				  res=res.join(",");
				  $("#res").val(res);
			},
			top:function(){
					var _select=$(this.sel_right);
					var _selected=_select.find("option:selected");
					var select_html="";
					if(_selected.size()>0){
						_selected.each(function(i){
							select_html+="<option selected='selected' value='"+_selected.eq(i).attr("value")+"'>"+_selected.eq(i).html()+"</option>"
						});
						_select.prepend(select_html);
						_selected.remove();
					}else{
						alert("선택하세요.");
					}
					this.hiddenvalue();
				},
		
			up:function(select_tag){
					var _select=$(this.sel_right);
					var _selected=_select.find("option:selected");
					var _selectedSize=_selected.size();
					var select_html="";
					if(_selectedSize==1){
						if(_selected.prevAll().size()>0){
							var prev_html="<option value='"+_selected.prev().attr("value")+"'>"+_selected.prev().html()+"</option>";
							var selected_html="<option selected='selected' value='"+_selected.attr("value")+"'>"+_selected.html()+"</option>";
							_selected.prev().remove();
							_selected.replaceWith(selected_html+prev_html);
							this.hiddenvalue();
						}else{
							alert("최상단 입니다.");
						}
					}else{
						alert("정렬을 선택하시기 바랍니다!");
					}
				},
				down:function(){
					var _select=$(this.sel_right);
					var _selected=_select.find("option:selected");
					var _selectedSize=_selected.size();
					var select_html="";
					if(_selectedSize==1){
						if(_selected.nextAll().size()>0){
							var next_html="<option value='"+_selected.next().attr("value")+"'>"+_selected.next().html()+"</option>";
							var selected_html="<option selected='selected' value='"+_selected.attr("value")+"'>"+_selected.html()+"</option>";
							_selected.next().remove();
							_selected.replaceWith(next_html+selected_html);
							this.hiddenvalue();
						}else{
							alert("마지막입니다.");
						}
					}else{
						alert("정렬을 선택하시기 바랍니다.");
					}
				},
				bottom:function(){
					var _select=$(this.sel_right);
					var _selected=_select.find("option:selected");
					var select_html="";
					if(_selected.size()>0){
						_selected.each(function(i){
							select_html+="<option selected='selected' value='"+_selected.eq(i).attr("value")+"'>"+_selected.eq(i).html()+"</option>"
						});
						_select.append(select_html);
						_selected.remove();
						this.hiddenvalue();
					}else{
						alert("선택하세요!");
					}
				},
		
			call:function(){//
			},
			warning:function(){//없을 경우는 false를 반환할지 여부를 선택.
				alert("선택하세요!");
			}
		};	
	
		var call = new selectList();	
		
		$(document).ready(function() {

			call.hiddenvalue();
			
			$("#before_res").val($("#res").val());
			$("#countList").val($("#rightGrid")[0].length + "/15");
			
			var message = "${message}";
			var result = "${result}";

			if (result == "S") {
				if (message != null && message != "") {
					alert(message);
				}
				//opener.document.location.href = "loginCheck.do";
				self.close();
			} else {
				if (message != null && message != "") {
					alert(message);
					return;
				}
			}

			$("#btnSave").click(function() {
				if ($("#res").val() == $("#before_res").val()) {
					alert("변경된 사항이 없습니다.");
					return;
				} 
				var count = $("#countList").val().split("/");
				if (count[0]*1 > 15) {
					alert("BOOKMARK는 최대 15개까지 등록이 가능합니다.");
					return;
				} 
				var formData = fn_getFormData('#application_form');
				$.post("saveBookmarkEdit.do", formData, function(data)
				{	
					alert(data.message);
					dialogArguments.refresh();
					window.close();
				});		
			});
		});
		
	</script>
</body>
</html>
