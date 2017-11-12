<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="/css/common.css" type="text/css" />
<link rel="stylesheet" href="/css/common_table.css" type="text/css" />
<link rel="stylesheet" href="/css/ui.jqgrid.css" type="text/css" />
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.10.4.custom.css" type="text/css" />
<link rel="stylesheet" href="/css/jquery.treeview.css" />
<link rel="stylesheet" href="/css/dis_style.css" />
<link rel="stylesheet" href="/css/easyui.css" />
<script type="text/javascript" src="/js/jquery-2.1.4.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jquery.easyui.min.js" charset='utf-8'></script>
<script>
	$(document).ready(function() {
		$('#multiple').switchbutton({
			checked : parent.v_checked,
			onChange : function(checked) {
				parent.v_checked = checked;
				var controlFlag;
				if(checked){
					controlFlag = "Y";
				} else {
					controlFlag = "N";
				}
				$.post( "updateUserControl.do?emp_no=${loginUser.user_id}&controlFlag="+controlFlag, "", function( data ) {
				}, "json" );
				while(true){
					if($('#mainTab').tabs('exists', 1)){
						$('#mainTab').tabs('close', 1);				
					} else {
						break;
					}	
				}
			}
		});
		$('#mainTab').tabs({
			plain : true,
			//narrow : true,
			border : false,
		});

	});
	function checkRoleAddTab(title, url, upTitle, menu_id) {
		$.post( "getMenuRole.do?menu_id="+menu_id, "", function( data ) {
			if(data.attribute1 != 'Y') {
				alert("해당 메뉴의 권한이 없습니다.");
			} else {
				addTab(title, url, upTitle);
			}
		}, "json" );
	}
	function addTab(title, url, upTitle) {
		if (parent.v_checked) {
			if ($('#mainTab').tabs('exists', title)) {
				$('#mainTab').tabs('select', title);
			} else {
				var content = '<iframe frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
				$('#mainTab').tabs('add', {
					title : title,
					content : content,
					closable : true
				});
				var tab = $('#mainTab').tabs('getSelected');
				tab.css('margin-left', '-10px');

			}
		} else {

			$('#mainTab').tabs('close', 1);

			var content = '<iframe frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
			$('#mainTab').tabs('add', {
				title : upTitle,
				content : content,
				closable : false
			});
			var tab = $('#mainTab').tabs('getSelected');
			tab.css('margin-left', '-10px');
		}

	}
	
	function checkCountLink(link_url, type, title, url, upTitle, menu_id) {
		$.post( "getMenuRole.do?menu_id="+menu_id, "", function( data ) {
			if(data.attribute1 != 'Y') {
				alert("해당 메뉴의 권한이 없습니다.");
			} else {
				
				if(type == "DTS") {
					addTab(title, url, upTitle);
				} else {
					ecoNoClick(link_url, menu_id);
				}
				
			}
		}, "json" );
	}
	
	//Eco No. 버튼 클릭 시 		
	function ecoNoClick(link_url, menu_id){
		
		var sURL = link_url + "?menu_id=" + menu_id + "&mainType=Y&popupDiv=Y&checkPopup=Y";
		var popOptions = "width=1200, height=700, resizable=yes, scrollbars=yes, status=yes";
		var win = window.open(sURL, "", popOptions); 
	    
		setTimeout(function(){
			win.focus();
		 }, 500);
	}
</script>
<div id="mainTab" class="easyui-tabs" style="margin-top:0px; margin-left: 10px; width: 100%; " data-options="tools:'#tab-tools'">
	<div title="Home" id="home">
		<div class="maincontent" style="overflow: hidden">

			<div class="visualArea">
				<div id="visual" class="visualbox mgt30">
					<img src="./images/main/visual.jpg" />
				</div>
				<div class="boardbox mgl20">
					<ul class="mainborad">
						<li class="noticeArea"><a href="#"
							onClick="window.open('popUpNoticeList.do','공지사항','resizable=no, width=650, height=480, scrollbars=yes');return false"><img
								src="./images/main/main_tit01.gif" /></a>
							<ul class="notice">
								<c:choose>
									<c:when test="${fn:length(noticeList) > 0}">
										<c:forEach var="item" items="${noticeList}" varStatus="status">
											<li><a href="#"
												onClick="window.open('popUpNotice.do?seq=${item.seq}','공지사항','resizable=no, width=650, height=520, scrollbars=yes');return false">
													<span class="nt_txt">${item.subject}</span>
											</a><span class="date">${item.create_date }</span></li>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<li><a href="#"><span class="nt_txt">등록된 공지사항이 없습니다.</span></a></li>
									</c:otherwise>
								</c:choose>
							</ul></li>
						<li class="title02"><img src="./images/main/main_tit02.png" />
							<table class="table_st01">
								<col width="30">
								<col width="60">
								<c:forEach var="item" items="${approveCntList}" varStatus="status">
									<tr>
										<th><strong>${item.appr_type}</strong></th>
										<td class="end"><a
											onclick="checkCountLink('${item.link_url}','${item.appr_type}','${item.link_name}','${item.link_url}?sUrl=${item.surl}&menu_id=${item.menu_id}&main_appr=Y','${item.up_name}','${item.menu_id}')"><span
												class="color01">${item.appr_cnt}</span></a> 건</td>
									</tr>
								</c:forEach>
							</table></li>
						<li style="position: absolute; top: 135px; left: 460px;"><a href="#"
							onClick="window.open('popUpPersonInCharge.do','new','resizable=no, width=600, height=480, scrollbars=yes');return false">
								<img src="./images/main/btn_info.gif" />
						</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="tab-tools" style="border: none; margin: 0 30px 0 10px">
	<input id="multiple" class="easyui-switchbutton" style="width: 120px" checked
		data-options="onText:'다중선택 ON',offText:'다중선택 OFF'">
</div>