package com.stx.common.library;

import java.io.File;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


 /**
 * <p> ����: request/multipart �� session ���� ���̺귯��</p> 
 * <p> ����: </p> 
 * <p> Copyright: Copyright (c) 2013</p> 
 *@author ����ȣ
 *@date 2013. 08
 *@version 1.0
 */
public class RequestManager { 
    /** 
    * ���ھ���  ������
    */
    public RequestManager() { }

    /**
    *request ��ü�� �޾� ���ǽð� ����, ��Ƽ��Ʈ ��ó��, box hashtable �� session , parameters �� ��� ��ȯ�Ѵ�.
    @param request HttpServletRequest �� request ��ü�� ���ڷ� ����
    @return RequestBox request ��ü���� ���� �Ķ���� name �� value, session ��ü�� ���� hashtable ��ü�� ��ȯ��
    */
    public static RequestBox getBox(HttpServletRequest request)  {
        HttpSession session = null;
        RequestBox box = null;
        
        try {
            session = request.getSession(true);
            
            box = new RequestBox("requestbox");
            
            Enumeration e1 = request.getParameterNames();
            
            while ( e1.hasMoreElements() ) { 
                String key = (String)e1.nextElement();
                int length = request.getParameterValues(key).length;
                if(length <=1)
                	box.put(key, request.getParameter(key));
                else
                	box.put(key, request.getParameterValues(key));
                
//                System.out.println(key+":=============>"+request.getParameter(key));
            }
  
            box.put("session", session);
            box.put("userip", request.getRemoteAddr() );
            
         } catch ( Exception ex ) { 
            ex.printStackTrace(); 
        }
        return box;
    }
    
    /**
    * ContentType ���� Multipart form �ΰ� ���θ� Ȯ���Ѵ�
    @param request HttpServletRequest �� request ��ü�� ���ڷ� ����
    @return Multipart form �̸� true �� ��ȯ��
    */
    public static boolean isMultipartForm(HttpServletRequest request) { 
        String v_contentType = StringManager.chkNull(request.getContentType() );
        
        return v_contentType.indexOf("multipart/form-data") >= 0;           //      Multipart �� �Ѿ�Դ��� ����
    }
    
    /**
    * ������ξּ� �������� �����Ͽ� ��ȯ��
    @param servletPath ���� ��θ� ���ڷ� ����
    @return �������� ��ȯ��
    */
    public static String getServetName(String servletPath) 
    { 
    	try
    	{
    		return servletPath.substring(servletPath.lastIndexOf(".") +1, servletPath.lastIndexOf("Servlet") );
    	}catch (Exception e) 
    	{
			// TODO: handle exception
    		return servletPath;
    	}
    	
    }
   
    /**
    * ��Ű�� ���� box ��ü�� ��´�.
    @param request HttpServletRequest �� request ��ü�� ���ڷ� ����
    @return RequestBox request ��ü���� ��Ű�� name �� value �� ���� hashtable ��ü�� ��ȯ��
    */
    public static RequestBox getBoxFromCookie(HttpServletRequest request)  { 
        RequestBox cookiebox = new RequestBox("cookiebox");
        javax.servlet.http.Cookie[] cookies = request.getCookies();
        if ( cookies == null ) return cookiebox;
        
        for ( int i = 0; cookies != null && i< cookies.length; i++ ) { 
            String key = cookies[i].getName();
            String value = cookies[i].getValue();
            if ( value == null ) value = "";
            String[] values = new String[1];
            values[0] = value;
            cookiebox.put(key,values);
        }

        return cookiebox;
    }
}
