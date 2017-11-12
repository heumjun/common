/**************************************************
*@DESCRIPTION				: Activity Manager
*@AUTHOR (MODIFIER)	: Jung ho cheol
*@FILENAME					: TbcActivityManagerMainBodyService.java
*@CREATE DATE				: 2013-09-24
**************************************************/
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.JsonUtil;
import com.stx.common.util.PageUtil;

 

public class TbcDwgMainListService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

		//select, update, insert, delete
		String sProcess = box.getString("p_process");
		
		PrintWriter out	=	response.getWriter();
		ServiceForward forward = new ServiceForward();
		if(sProcess.equals("list")){
			//StringBuffer rtnString = jsonToString2(ar);
			
			String sPaging 		  = PageUtil.getPagingStringMap(box, ar);
			JSONObject jsonObject = (JSONObject)JSONSerializer.toJSON(sPaging);
			String		   rtnString = jsonObject.toString();
			out.print(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("receiverCheck")){
			StringBuffer rtnString = JsonUtil.jsonToString(ar);
			out.println(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("required")){
			Map map = (Map) ar.get(0);
			String rtnString = (String) map.get("result");
			out.println(rtnString); 
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("shipView")){
			forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgPopupList.jsp");
			//StringBuffer rtnString = JsonUtil.jsonToString(ar);
			//out.println(rtnString);
		}
		else if(sProcess.equals("shipList")){
			forward.setRedirect(false);
	        forward.setForward(false);
			StringBuffer rtnString = JsonUtil.jsonToString(ar);
			out.println(rtnString);
		}
		
		else if(sProcess.equals("grantorView")){
			forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgGrantorList.jsp");
		}
		else if(sProcess.equals("grantorList")){
			
			StringBuffer rtnString = JsonUtil.jsonToString(ar);
			out.println(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("dpDwgView")){
			forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgPopupDPDwgList.jsp");
		}
		else if(sProcess.equals("dpDwgList")){
			StringBuffer rtnString = JsonUtil.jsonToString(ar);
			out.println(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("deptView")){
			forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgPopupDeptList.jsp");
		}
		else if(sProcess.equals("selectDeptGubun")){
			StringBuffer rtnString = JsonUtil.jsonToString(ar);
			out.println(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("selectdwgdeptcode")){
			StringBuffer rtnString = JsonUtil.jsonToString(ar);
			out.println(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		else if(sProcess.equals("deptList")){
	        String sPaging 		  = PageUtil.getPagingStringMap(box, ar);
			JSONObject jsonObject = (JSONObject)JSONSerializer.toJSON(sPaging);
			String		   rtnString = jsonObject.toString();
			out.print(rtnString);
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		
		
		
		
        
        
       	//forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgMain.jsp");
       	
       	
		return forward;
	}
}