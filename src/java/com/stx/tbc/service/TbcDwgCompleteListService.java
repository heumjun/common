/***********************************************
*@DESCRIPTION				: Dwg
*@AUTHOR (MODIFIER)			: Kim dong hyoek
*@FILENAME					: TbcDwgMailReceiverService.java
*@CREATE DATE				: 2014-08-12
***********************************************/
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.JsonUtil;
import com.stx.common.util.PageUtil;
import com.stx.common.util.SessionUtil;


public class TbcDwgCompleteListService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		String sQueryType = box.getString("p_queryType");
		String p_process  = box.getString("p_process");
		PrintWriter out	=	response.getWriter();
		if(sQueryType.equals("select")){
			if(p_process.equals("list")){
				String sPaging 		  = PageUtil.getPagingStringMap(box, ar);
				JSONObject jsonObject = (JSONObject)JSONSerializer.toJSON(sPaging);
				String		   rtnString = jsonObject.toString();
				out.print(rtnString);
			}else if(p_process.equals("getPermission")){
				StringBuffer rtnString = JsonUtil.jsonToString(ar);
				out.println(rtnString);
			}
		}
		else{
			Map map = (Map) ar.get(0);
			String rtnString = (String) map.get("result");
			out.println(rtnString);
		}
		
		ServiceForward forward = new ServiceForward();
        
        forward.setRedirect(false);
        forward.setForward(false);
        //forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgInformation.jsp");
        
		return forward;
	}
}