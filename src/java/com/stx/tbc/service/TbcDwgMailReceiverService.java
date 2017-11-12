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
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.JsonUtil;
import com.stx.common.util.SessionUtil;


public class TbcDwgMailReceiverService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		
		String sProcess = box.getString("p_process");
		PrintWriter out	=	response.getWriter();
		
		ServiceForward forward = new ServiceForward();
        
		if(sProcess.equals("list")){
			String rtnStr = JsonUtil.listToJsonstring(ar);
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("description")){
			String	rtnStr = "";
			if(ar.size()==0){
				rtnStr = null;
			}else{
				rtnStr = JsonUtil.listToJsonstring(ar);
			}
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("notRequired")){
			String	rtnStr = "";
			if(ar.size()==0){
				rtnStr = null;
			}else{
				rtnStr = JsonUtil.listToJsonstring(ar);
			}
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("modifyView")){
			request.setAttribute("selectSeriesProject", ar);
			request.setAttribute("listSize", Integer.toString(ar.size()));
			request.setAttribute("h_DwgNo", box.getString("h_DwgNo"));
			request.setAttribute("h_ShipNo", box.getString("h_ShipNo"));
			request.setAttribute("dwg_rev", box.getString("dwg_rev"));
			request.setAttribute("shipNo", box.getString("shipNo"));
			
			forward.setRedirect(false);
			forward.setForward(true);
			forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgModifyMailReceiver.jsp");
		}
		else if(sProcess.equals("modifyList")){
			String rtnStr = JsonUtil.listToJsonstring(ar);
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("userSearch")){
			forward.setRedirect(false);
			forward.setForward(true);
			forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgPopupUserSearch.jsp");
		}
		else if(sProcess.equals("userSearchList")){
			String rtnStr = JsonUtil.listToJsonstring(ar);
			out.print(rtnStr);
			
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("addGroup")){
			forward.setRedirect(false);
			forward.setForward(true);
			forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgPopupAddGroup.jsp");
		}
		else if(sProcess.equals("mailReceiverSave")){
			Map map = (Map) ar.get(0);
			String rtnString = (String) map.get("result");
			out.println(rtnString);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("mailReceiverGroupSave")){
			Map map = (Map) ar.get(0);
			String rtnString = (String) map.get("result");
			out.println(rtnString);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("mailReceiverGroupList")){
			request.setAttribute("condition", "groupList");
			request.setAttribute("groupList", ar);
	        forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgUserList.jsp");
		}
		else if(sProcess.equals("selectDwgReceiverGroupDetail")){
			String rtnStr = JsonUtil.listToJsonstring(ar);
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else if(sProcess.equals("delete_STX_DWG_RECEIVER_GROUP_HEAD")){
			Map map = (Map) ar.get(0);
			String rtnString = (String) map.get("result");
			out.println(rtnString);
			forward.setRedirect(false);
			forward.setForward(false);
		}
		else{
			forward.setRedirect(false);
			forward.setForward(true);
			forward.setPath("/WEB-INF/jsp/tbc/tbc_DwgMailReceiver.jsp");
		}
		
		return forward;
	}
}