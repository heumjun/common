/***********************************************
*@DESCRIPTION				: Dwg
*@AUTHOR (MODIFIER)			: Kim dong hyoek
*@FILENAME					: TbcDwgMain.java
*@CREATE DATE				: 2014-08-12
***********************************************/
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;


public class TbcDwgPopupViewListService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		
		PrintWriter out	=	response.getWriter();
		String p_process  = box.getString("p_process");
		ServiceForward forward = new ServiceForward();
		
		if(p_process.equals("list")){
			StringBuffer pml_Code = new StringBuffer();
			Map			mapParam = null;
			for(int i=0;i<ar.size();i++){
				mapParam = (Map) ar.get(i);
				pml_Code.append(mapParam.get("pml_code"));
			}
			out.print(pml_Code.toString());
	        
	        forward.setRedirect(false);
	        forward.setForward(false);
		}else if(p_process.equals("preViewFileList")){
			StringBuffer file_Name = new StringBuffer();
			Map			mapParam = null;
			for(int i=0;i<ar.size();i++){
				mapParam = (Map) ar.get(i);
				file_Name.append(mapParam.get("file_name")+"|");
			}
			out.print(file_Name.toString());
			forward.setRedirect(false);
	        forward.setForward(false);
		}
		return forward;
	}
}