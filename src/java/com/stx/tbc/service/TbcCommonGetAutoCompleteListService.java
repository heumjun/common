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

public class TbcCommonGetAutoCompleteListService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

        String rtnString = "";
        
        for(int i=0; i< ar.size(); i++){
        	DataBox dbox = (DataBox)ar.get(i);
        	rtnString += dbox.getString("d_object") + "|";
        }
                
        PrintWriter out = response.getWriter();
		
        out.println(rtnString);
        //request.setAttribute("list", list);
        //request.setAttribute("listSize", Integer.toString(ar.size()));
        
		//StringBuffer rtnString = jsonToString(ar);
		//System.out.println(rtnString);
		//out.println(rtnString);

        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
        //forward.setPath("/WEB-INF/jsp/tbc/tbc_CommonAutoCompliteList.jsp");
        
		return forward;
		
	}
}