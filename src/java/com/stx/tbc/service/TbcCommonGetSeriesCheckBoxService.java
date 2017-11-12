/*************************************************
*@DESCRIPTION				: Activity Manager
*@AUTHOR (MODIFIER)	: Jung ho cheol
*@FILENAME					: TbcActivityManagerSubBodyService.java
*@CREATE DATE				: 2013-09-25
*************************************************/
package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;

import com.stx.common.service.ServiceForward;

public class TbcCommonGetSeriesCheckBoxService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

        request.setAttribute("seriesList", ar);
		request.setAttribute("seriesListSize", Integer.toString(ar.size()));

        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);

        forward.setPath("/WEB-INF/jsp/tbc/tbc_CommonSeriesCheckBox.jsp");
        
		return forward;
	}
}