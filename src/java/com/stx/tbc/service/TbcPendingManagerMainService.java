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


public class TbcPendingManagerMainService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
		//초기 세션 셋팅
		SessionUtil.setUserSession(box);
		
		//request.setAttribute("DeptPartCode", box.getSession("DeptCode").substring(0, 3));
		
        ServiceForward forward = new ServiceForward();
        
        forward.setRedirect(false);
        forward.setForward(true);
        forward.setPath("/WEB-INF/jsp/tbc/tbc_PendingManagerMain.jsp");
        
		return forward;
	}
}