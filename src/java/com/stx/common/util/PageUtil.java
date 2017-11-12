package com.stx.common.util;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONSerializer;

import com.stx.common.library.RequestBox;

public class PageUtil {
	public static int getPageCount(int numPerPage, int dataCount) {
		int pageCount = 0;
		int remain;

		remain = dataCount % numPerPage;
		if(remain == 0)
			pageCount = dataCount / numPerPage;
		else
			pageCount = dataCount / numPerPage + 1;

		return pageCount;
	}
	
	
	
	public static String getPagingStringMap(RequestBox param, List list) {
		
		int pageCount = getPageCount( Integer.parseInt(param.get("rows").toString())   ,Integer.parseInt(param.get("listRowCnt").toString()));
		
		JSONArray jsonArray = (JSONArray)JSONSerializer.toJSON(list);
		
		String sPaging = "{'page':"+param.get("page")+",'total':"+pageCount+",'records':"+param.get("listRowCnt")+",'rows':"+jsonArray+"}";
		
		return sPaging;
	}
	
	public static Map getStartEndPageInfo(int count, int limit, int page) {
		Map param = new HashMap();
		
		int total_pages = 0;
		
		if( count > 0 ) {
			total_pages = (int) Math.ceil( (double) count / (double) limit );
		} else {
			total_pages = 0;
		}
		
		if( page > total_pages ) { 
			page = total_pages;
		}
		
		int start = ( limit * page - limit ) + 1;
		int end = ( limit * page - limit ) + limit;
		
		if( start < 0 ) {
			start = 0;
		}
		
		param.put("total_pages", Integer.toString(total_pages));
		param.put("start", Integer.toString(start));
		param.put("end", Integer.toString(end));
		
		return param;
	}
	
}
