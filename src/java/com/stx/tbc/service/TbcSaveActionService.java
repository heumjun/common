package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.tbc.dao.factory.DaoCreator;
import com.stx.tbc.dao.factory.FactoryDAO;
import com.stx.tbc.dao.factory.Idao;

public class TbcSaveActionService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		
		//Json으로  변환
		StringBuffer rtnString = jsonToString(ar);
		
		System.out.println(rtnString);
		
		out.println(rtnString);
			
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
        return forward;
	}
}