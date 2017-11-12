package com.stx.common.service;
public class ServiceForward 
{
	String path;
	boolean redirect;
	boolean forward;
	
	public ServiceForward()
	{
		forward=true;
	}
	public boolean isForward() {
		return forward;
	}
	public void setForward(boolean forward) {
		this.forward = forward;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public boolean isRedirect() {
		return redirect;
	}
	public void setRedirect(boolean redirect) {
		this.redirect = redirect;
	}
}
