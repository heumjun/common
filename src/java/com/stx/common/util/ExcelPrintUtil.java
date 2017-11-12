package com.stx.common.util;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;

public class ExcelPrintUtil 
{
	public static void getCode(HttpServletResponse response, String realFileName) throws Exception {
		
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
		String vTime = dayTime.format(new Date(time));
		
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setContentType("application/vnd.ms-excel;charset=euc-kr"); //content type setting
		response.setHeader("Content-Disposition", "attachment;filename="+new String(realFileName.getBytes(),"ISO-8859-1")+vTime+".xls");// 한글 파일명 설정시에..

    }
}
