package com.stxdis.util.util;

import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

/**
 * 파일 다운로드에 관한 클래스를 정의한다.
 * @author 이상복
 * @since 2014.07.10
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2014.07.10  이상복          최초 생성
 *
 * </pre>
 */

public class FileDownLoad extends AbstractView {

	/**
	 * File을 다운로드한다.
	 * 
	 * @param	Map<String, Object>	model
	 * @param	HttpServletRequest	request
	 * @param	HttpServletResponse	response
	 * @return	NONE
	 * */
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		byte[] bytes = (byte[]) model.get("data");
		
		String header = getBrowser(request);
		String fileName = StringUtil.nullString( model.get("filename") );
		if (header.contains("MSIE")) {
			String docName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
			response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
		} else if (header.contains("Firefox")) {
			String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		} else if (header.contains("Opera")) {
			String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		} else if (header.contains("Chrome")) {
			String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		}

		response.setHeader("Content-Type", "application/octet-stream");
		response.setContentLength(bytes.length);
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");

		ServletOutputStream out = response.getOutputStream();
		out.write(bytes);
		out.flush();
		out.close();
	}
	
	
	private String getBrowser(HttpServletRequest request) {

		String header = request.getHeader("User-Agent");

		if (header.contains("MSIE")) {
			return "MSIE";
		} else if (header.contains("Chrome")) {
			return "Chrome";
		} else if (header.contains("Opera")) {
			return "Opera";
		}

		return "Firefox";
	}

}
