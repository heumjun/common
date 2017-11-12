package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;

import com.stx.common.service.ServiceForward;

public class TbcAftPopUpORBodyService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub

        request.setAttribute("orderList", ar);
		request.setAttribute("orderListSize", Integer.toString(ar.size()));
		
        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        String p_item_type_cd = box.getString("p_item_type_cd");
        
        forward.setPath("/WEB-INF/jsp/tbc/tbc_After_Popup_ALL_OR_Body.jsp" );
        
		return forward;
	}
}