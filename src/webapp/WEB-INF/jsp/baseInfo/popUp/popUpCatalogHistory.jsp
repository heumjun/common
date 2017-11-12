<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>catalogHistory</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="wrap" class="mainDiv">
			<div class="topMain" style="margin: 0px; line-height: 45px;">
				<div class="conSearch">
					<span class="spanMargin"> <span class="pop_tit">Catalog</span>
						<input type="text" name="p_catalog_code" value=<c:out value="${sel_catalog_code}"/>>
					</span>
				</div>
				<div class="button">
					<input type="button" value="조회" id="btnSearch" class="btn_blue" />
					<input type="button" value="닫기" id="btnClose" class="btn_blue" />
				</div>
	
			</div>
			<div class="content">
				<table id="catalogHistory"></table>
				<div id="pcatalogHistory"></div>
			</div>
		</div>
		<script type="text/javascript">
		$(document).ready( function() {
			
			$( "#catalogHistory" ).jqGrid( {
				datatype : 'json',
				mtype : 'POST',
				url : 'infoCatalogHistory.do',
				postData : { gbn : 1, p_catalog_code : $( "input[name=p_catalog_code]" ).val() },
				colNames : [ 'Rev', 'Action', '변경날짜', '사번', '작업자', 'Catalog', 'Desc', 'Category', 'Desc', 'Uom', 'Part Familly Code', 'Desc', '무효일짜', 
				             'WBS', 'WBS하위', 'ACT', 'JOB', 'PD', 'PAINT', 'PAINT USC',
				             '사용유무' ],
				colModel : [ { name : 'revision_no', index : 'revision_no', width : 40 }, 
				             { name : 'process_action', index : 'process_action', width : 80 }, 
				             { name : 'last_update_date', index : 'last_update_date', width : 80 }, 
				             { name : 'last_updated_by', index : 'last_updated_by', width : 60 }, 
				             { name : 'last_update_by_name', index : 'last_update_by_name', width : 120 }, 
				             { name : 'catalog_code', index : 'catalog_code', width : 80 }, 
				             { name : 'catalog_desc', index : 'catalog_desc', width : 100 }, 
				             { name : 'category_id', index : 'category_id', width : 60 }, 
				             { name : 'category_desc', index : 'category_desc', width : 120 }, 
				             { name : 'uom_code', index : 'uom_code', width : 60 }, 
				             { name : 'part_family_code', index : 'job_flag', width : 60 }, 
				             { name : 'part_family_desc', index : 'enable_flag', width : 140 }, 
				             { name : 'invalid_date', index : 'invalid_date', width : 80 }, 
				             
				             { name : 'wbs_flag', index : 'wbs_flag', width : 35, formatter : "checkbox", align : "center" },
				             { name : 'wbs_sub_flag', index : 'wbs_sub_flag', width : 35, formatter : "checkbox", align : "center" },
				             { name : 'activity_flag', index : 'activity_flag', width : 35, formatter : "checkbox", align : "center" }, 
				             { name : 'job_flag', index : 'job_flag', width : 35, formatter : "checkbox", align : "center" }, 
				             { name : 'pd_flag', index : 'pd_flag', width : 35, formatter : "checkbox", align : "center" },
				             { name : 'paint_flag', index : 'paint_flag', width : 35, formatter : "checkbox", align : "center" },
				             { name : 'paint_usc_flag', index : 'paint_usc_flag', width : 35, formatter : "checkbox", align : "center" },
				             
				             { name : 'enable_flag', index : 'enable_flag', width : 35, formatter : "checkbox", align : "center" } ],

				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				sortname : 'revision_no',
				sortorder : "asc",
				viewrecords : true,
				autowidth : true,
				//altRows: false, 
				height : 650,
				pager : jQuery('#pcatalogHistory'),
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				loadComplete : function() {

				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images'

			});

					$("#btnSearch").click(function() {
						fn_search();
					});

					$("#btnClose").click(function() {
						self.close();
					});

				});

		function fn_search() {
			jQuery("#catalogHistory").jqGrid('setGridParam', {
				url : "infoCatalogHistory.do",
				page : 1,
				postData : {
					gbn : 1,
					p_catalog_code : $("input[name=p_catalog_code]").val()
				}
			}).trigger("reloadGrid");
		}
		</script>
	</body>
</html>