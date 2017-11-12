package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.SessionUtil;


public class TbcUnitManagerMainService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
//		Context context = null;
//		
//		context = Framework.getFrameContext(request.getSession());
//		
//		if(context != null){
//			//초기 세션 셋팅
//			SessionUtil.setUserSession(box);
//		}
		
        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        forward.setPath("/WEB-INF/jsp/tbc/tbc_UnitManagerMain.jsp");
        
		return forward;
	}
}