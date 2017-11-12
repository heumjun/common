package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;


public class TbcBuyBuyAutoCompleteService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
        PrintWriter out = response.getWriter();
		
        request.setAttribute("list", ar);
        request.setAttribute("listSize", Integer.toString(ar.size()));
        
		StringBuffer rtnString = jsonToString(ar);
		System.out.println(rtnString);
		out.println(rtnString);

        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
		return forward;
	}
}