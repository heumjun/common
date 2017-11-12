package com.stx.tbc.service;

import java.io.PrintWriter;
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


public class TbcUnitManagerAddActionService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
//		 TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
				
		//Json으로  변환
		StringBuffer rtnString = jsonToString(ar);
		out.println(rtnString);
			
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
        return forward;
	}
}