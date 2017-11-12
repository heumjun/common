package com.stx.tbc.service;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.SessionUtil;


public class TbcMainService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
		//초기 세션 셋팅
		SessionUtil.setUserSession(box);
		
        ServiceForward forward = new ServiceForward();
        
        forward.setRedirect(false);
        forward.setForward(true);
        forward.setPath("/WEB-INF/jsp/tbc/tbc_Main.jsp");
        
		return forward;
	}
}