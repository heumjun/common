<%@ page contentType="text/html;charset=UTF-8"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<link rel="stylesheet" href="/css/common.css" type="text/css" />
<link rel="stylesheet" href="/css/common_table.css" type="text/css" />
<link rel="stylesheet" href="/css/ui.jqgrid.css" type="text/css" />
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.10.4.custom.css" type="text/css" />
<link rel="stylesheet" href="/css/jquery.treeview.css" />
<link rel="stylesheet" href="/css/dis_style.css" />
<link rel="stylesheet" href="/css/uploadify.css" />

<script type="text/javascript" src="/js/jquery-2.1.4.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jquery.form.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonGridUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/json2.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jqueryAjax.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/checkboxUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonTextUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonClientValidationUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonTableUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jquery-ui-1.10.3.min.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jqgrid/jquery.jqGrid.src.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jqgrid/i18n/grid.locale-en.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/ZeroClipboard.js" charset='utf-8'></script>

<!-- DIS 추가 -->

<script type="text/javascript" src="/js/commonConstraint.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript" src="/js/jquery.treeview.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/js/jquery.numeric.js"></script>


<script type="text/javascript" src="/js/paintUserAuthority.js"></script>
<script type="text/javascript" src="/js/loading.js"></script>
<script type="text/javascript" src="/js/commonButtonUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonDateUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonReportUtil.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/commonTextUtil.js" charset='utf-8'></script>

<script type="text/javascript" src="/js/jquery.blockUI.js"></script>
<script type="text/javascript" src="/js/jquery.MetaData.js"></script>
<script type="text/javascript" src="/js/jquery.MultiFile.js"></script>
<script type="text/javascript" src="/js/jquery.MultiFile.pack.js"></script>
<script type="text/javascript" src="/js/jquery.uploadify.min.js"></script>
<!-- <script type="text/javascript" src="./script/jquery.validate.js"></script> -->
<script>
	$(function() {

		$(document).tooltip({
			show : null,
			position : {
				my : "left top",
				at : "left bottom"
			},
			open : function(event, ui) {
				ui.tooltip.animate({
					top : ui.tooltip.position().top
				}, 0);
			},
			hide : {
				duration : 0
			}
		});
		//key evant 
		$("input").keypress(function(event) {
		  if (event.which == 13) {
		        event.preventDefault();
		        $('#btnSearch').click();
		    }
		});
	});
	
	$(document).ready(function() {
		if ('${newWin}' == 'Y') {
			$('.subtitle').removeClass('subtitle').addClass('subtitle2');
		}
		
	});
	window.onload  = function() {
		$('.ui-th-column').each(function() { $(this).attr('alt',$(this).text()).attr('title',$(this).text()); });	
	}
	
	var fileDownloadCheckTimer;
	var filelodingBox;
	function fn_downloadStart() {
		$.cookie('fileDownloadToken','NO');
		filelodingBox = new ajaxLoader($('#mainDiv'), {
			classOveride : 'blue-loader',
			bgColor : '#000',
			opacity : '0.3'
		});
		fileDownloadCheckTimer = window.setInterval(function() {
			var cookieValue = $.cookie('fileDownloadToken');
 			if (cookieValue == "OK") {
				finishDownload();
			}
		}, 1000);
	}
	function finishDownload() {
		window.clearInterval(fileDownloadCheckTimer);
		$.cookie('fileDownloadToken','NO');
		filelodingBox.remove();
		alert("Excel출력이 완료 되었습니다.");
	}
	
	// 숫자만 입력 가능하도록 한다.
	function onlyNumber() {
		if ((event.keyCode < 48) || (event.keyCode > 57)){event.returnValue = false;}
	}
</script>

