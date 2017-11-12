/***********************************************
*@DESCRIPTION				: Dwg
*@AUTHOR (MODIFIER)			: Kim dong hyoek
*@FILENAME					: TbcDwgMain.java
*@CREATE DATE				: 2014-08-12
***********************************************/
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.stx.common.library.RequestBox;
import com.stx.common.service.BService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.JsonUtil;
import com.stx.common.util.SessionUtil;


public class TbcItemTransService extends BService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

		//Context context = null;
		//context = Framework.getFrameContext(request.getSession());
		PrintWriter out	=	response.getWriter();
		String userId =request.getParameter("userId");
		String sQueryType = box.getString("p_queryType");
		String p_process  = box.getString("p_process");
		
		
		//if(box.getSession("UserId").equals("")){
		//	SessionUtil.setUserSession(box);
		//}
		
		ServiceForward forward = new ServiceForward();
		//���� ��¥�� �������� 7�� �� ��¥ �޾ƿ���
        if(p_process.equals("selectWeekList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //���� ȭ�� ��ȸ Ŭ�� �� 
        else if(p_process.equals("list")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //�۾��� or row ���� Ŭ�� ��
        else if(p_process.equals("modifyView")){
        	String list_status_desc = box.getString("list_status_desc");
        	list_status_desc = URLEncoder.encode(list_status_desc,"UTF-8");
        	box.put("list_status_desc", list_status_desc);
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransModifyView.jsp");
	        //forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransModifyView.jsp");
        }
        //main ȭ�� �޺��ڽ� ����
        else if(p_process.equals("selectListType")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //�ű� catalog �ӽ����� ��  
        else if(p_process.equals("temporarystorage")){
        	//MultipartRequest mr = new MultipartRequest(request,"utf-8");
        	
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //������ �޺��ڽ� ����
        else if(p_process.equals("selectApproverList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //������ �޺��ڽ� ����
        else if(p_process.equals("selectApproverListId")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        
        //main���� row ���� Ŭ���� list_id �˻�
        else if(p_process.equals("selectDetail")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //main���� row ���� Ŭ���� list_id�� catalogList �˻�
        else if(p_process.equals("selectCatalogList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
//      main���� row ���� Ŭ���� list_id�� itemList �˻�
        else if(p_process.equals("selectItemList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //catalog�� ���� ��ư Ŭ���� 
        else if(p_process.equals("itemreceive")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //���� ��ư Ŭ�� �� 
        else if(p_process.equals("updateInfoList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //������ �μ� list ��������
        else if(p_process.equals("selectApproveListDept")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //���� list ��������
        else if(p_process.equals("selectConfirmList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        else if(p_process.equals("selectApproveListDeptComment")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //�ݷ�
        else if(p_process.equals("updateReturn")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //öȸ
        else if(p_process.equals("updateRetract")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //REF_USER SELECT
        else if(p_process.equals("selectRefUser")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //SELECT ADMIN_USER
        else if(p_process.equals("selectAdminUser")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //file upload �˾�â ����
        else if(p_process.equals("itemPopupUpload")){
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemPopupDoc.jsp");
        }
        //��� ��ư
        else if(p_process.equals("btnCancel")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //Doc List ��ȸ
        else if(p_process.equals("selectDocList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //÷�� ���� ����
        else if(p_process.equals("deleteDocList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //������ ����
        else if(p_process.equals("AdminDelete")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //���� �˾�
        else if(p_process.equals("userSearch")){
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransUserSearch.jsp");
        }
        //UserSearch �˾�â List
        else if(p_process.equals("userSearchList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //÷������ �ٿ�ε� jsp
        else if(p_process.equals("fileDownload")){
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransFileDownload.jsp");
        }
        //�����ڰ� ���������� üũ
        else if(p_process.equals("selectGrantorChk")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //�ʱ� ȭ��
        else{
        	SessionUtil.setUserSession(box);
	        forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTrans.jsp");
        }
		return forward;
	}
}