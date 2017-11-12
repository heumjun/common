/*************************************************
*@DESCRIPTION				: File Download
*@AUTHOR (MODIFIER)		 	: Back jae ho
*@FILENAME					: TbcCommonFileDownloadService.java
*@CREATE DATE				: 2014-11-05
*************************************************/
package com.stx.tbc.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;

public class TbcCommonFileDownloadService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

		String fileName = box.getString("fileName");
		String path = request.getSession().getServletContext().getRealPath("download");
		
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

		File file = new File(path +"\\"+ fileName);
		FileInputStream fileIn = new FileInputStream(file);		
		ServletOutputStream out = response.getOutputStream();
		
		byte[] outputByte = new byte[4096];		
		//copy binary contect to output stream
		while(fileIn.read(outputByte, 0, 4096) != -1){
			out.write(outputByte, 0, 4096);
		}
		
		fileIn.close();
		out.flush();
		out.close();
        
        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
		return forward;
		
	}
}