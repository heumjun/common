package com.stx.common.library;

import java.io.File;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


 /**
 * <p> 제목: request/multipart 와 session 관련 라이브러리</p> 
 * <p> 설명: </p> 
 * <p> Copyright: Copyright (c) 2013</p> 
 *@author 백재호
 *@date 2013. 08
 *@version 1.0
 */
public class RequestManager { 
    /** 
    * 인자없는  생성자
    */
    public RequestManager() { }

    /**
    *request 객체를 받아 세션시간 설정, 멀티파트 폼처리, box hashtable 에 session , parameters 를 담아 반환한다.
    @param request HttpServletRequest 의 request 객체를 인자로 받음
    @return RequestBox request 객체에서 받은 파라미터 name 과 value, session 객체를 담은 hashtable 객체를 반환함
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
    * ContentType 에서 Multipart form 인가 여부를 확인한다
    @param request HttpServletRequest 의 request 객체를 인자로 받음
    @return Multipart form 이면 true 를 반환함
    */
    public static boolean isMultipartForm(HttpServletRequest request) { 
        String v_contentType = StringManager.chkNull(request.getContentType() );
        
        return v_contentType.indexOf("multipart/form-data") >= 0;           //      Multipart 로 넘어왔는지 여부
    }
    
    /**
    * 서블릿경로애서 서블릿명을 추출하여 반환함
    @param servletPath 서블릿 경로를 인자로 받음
    @return 서블릿명을 받환함
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
    * 쿠키를 담은 box 객체를 얻는다.
    @param request HttpServletRequest 의 request 객체를 인자로 받음
    @return RequestBox request 객체에서 쿠키의 name 과 value 를 담은 hashtable 객체를 반환함
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
