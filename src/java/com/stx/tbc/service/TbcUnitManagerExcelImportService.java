
package com.stx.tbc.service;


import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.FileScanner;
import com.stx.tbc.dao.factory.Idao;


public class TbcUnitManagerExcelImportService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
		try{
//			matrix.db.Context context = null;
//			context = Framework.getFrameContext(request.getSession());
//			String sTempDir = context.createWorkspace();
//			
//		    //file �б�		    
//			MultipartRequest multi = new MultipartRequest(request, sTempDir, -1, "euc-kr");
//			String fileName = multi.getFilesystemName("fileName") == null ? "" : multi.getFilesystemName("fileName");
//			String fileType = multi.getContentType("fileName") == null ? "" : multi.getContentType("fileName");
//		    //file �б� ��
//		    //���� �б�
//		    ArrayList list = FileScanner.excelToDataObj(sTempDir+"\\"+fileName, 1, true);
//		    
//		    //����Ʈ�� box�� �ִ´�.
//		    box.put("insertList",list);
//		    box.put("p_process",multi.getParameter("p_process"));
//		    // insertBB ȣ��
//		    
//		    Idao dao = super.createDAO(multi.getParameter("p_daoName"));
//		    
//		    dao.insertDB(multi.getParameter("p_process"), box);
//		    
		    
		}catch(Exception e){
			System.out.println(e.getMessage());
			e.getStackTrace();
		}

        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
         
        return forward;
	}
}


