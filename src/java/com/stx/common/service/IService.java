package com.stx.common.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;


public interface IService 
{
	public ServiceForward execute(HttpServletRequest request,HttpServletResponse response,RequestBox box) throws Exception;
}
