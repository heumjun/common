package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;

import com.stx.common.service.ServiceForward;

public class TbcAftPopUpService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub

        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        String p_item_type_cd = box.getString("p_item_type_cd");
        System.out.println(p_item_type_cd);
        forward.setPath("/WEB-INF/jsp/tbc/tbc_After_Popup.jsp" );
        
		return forward;
	}
}