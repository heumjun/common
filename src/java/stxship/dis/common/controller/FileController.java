package stxship.dis.common.controller;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import stxship.dis.common.command.CommandMap;

@Controller
public class FileController {

	/**
	 * @메소드명 : getFile
	 * @날짜 : 2016. 1. 13.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param response
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "fileDownload.do", produces="text/plain;charset=UTF-8")
	public void getFileDownload(CommandMap commandMap, HttpServletResponse response, HttpServletRequest request)
			throws Exception {

		String fileName = (String) commandMap.get("fileName");
		String path = request.getSession().getServletContext().getRealPath("download");

		// 한글파일명 깨지지 않도록
		String docName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

		response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
		response.setContentType("text/plain");

		File down_file = new File(path + "\\" + fileName); // 파일 생성
		FileInputStream fileIn = new FileInputStream(down_file); // 파일 읽어오기
		// ByteStreams.copy(fileIn, response.getOutputStream());
//		response.flushBuffer();
			
		ServletOutputStream out = response.getOutputStream();
		
		byte[] outputByte = new byte[4096];		
		//copy binary contect to output stream
		while(fileIn.read(outputByte, 0, 4096) != -1){
			out.write(outputByte, 0, 4096);
		}
		
		fileIn.close();
		out.flush();
		out.close();

	}
}