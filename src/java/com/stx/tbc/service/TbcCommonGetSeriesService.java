/*************************************************
*@DESCRIPTION				: Activity Manager
*@AUTHOR (MODIFIER)	: Jung ho cheol
*@FILENAME					: TbcActivityManagerSubBodyService.java
*@CREATE DATE				: 2013-09-25
*************************************************/
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;

import com.stx.common.service.ServiceForward;

public class TbcCommonGetSeriesService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

		StringBuffer rtnString = jsonToString(ar);
		PrintWriter out = response.getWriter();
		out.println(rtnString);

        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
		return forward;
		
	}
}