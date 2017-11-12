package stxship.dis.common.util;

import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

public class FileDownLoad extends AbstractView {

	/**
	 * File을 다운로드한다.
	 * 
	 * @param Map<String,
	 *            Object> model
	 * @param HttpServletRequest
	 *            request
	 * @param HttpServletResponse
	 *            response
	 * @return NONE
	 */
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		byte[] bytes = (byte[]) model.get("data");

		String header = getBrowser(request);
		String fileName = DisStringUtil.nullString(model.get("filename"));
		if (header.contains("MSIE")) {
			String docName = new String(fileName.getBytes("KSC5601"), "8859_1"); //URLEncoder.encode(fileName, "euc-kr").replaceAll("\\+", "%20");
			response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
		} else if (header.contains("Firefox")) {
			String docName = new String(fileName.getBytes("euc-kr"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		} else if (header.contains("Opera")) {
			String docName = new String(fileName.getBytes("euc-kr"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		} else if (header.contains("Chrome")) {
			String docName = new String(fileName.getBytes("euc-kr"), "ISO-8859-1");
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
