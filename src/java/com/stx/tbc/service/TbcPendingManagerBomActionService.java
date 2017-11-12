package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;


public class TbcPendingManagerBomActionService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
//		 TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
				
		//Json으로  변환
		StringBuffer rtnString = jsonToString(ar);
		//out.println(rtnString);
		System.out.println(ar.size());
		
		DataBox dbox = (DataBox)ar.get(0);
		out.println(dbox.getString("Result_Msg"));
		
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
        return forward;
	}
}