package stxship.dis.baseInfo.formFile.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.formFile.service.FormFileService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : FormFileController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class FormFileController extends CommonController {
	@Resource(name = "formFileService")
	private FormFileService formFileService;

	@RequestMapping(value = "formFileMgnt.do")
	public ModelAndView formFileMgnt(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : downloadFile
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * FormFile 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "downloadFormFile.do")
	public void downloadFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
		formFileService.downLoadFile(commandMap, response);
	}

	@RequestMapping(value = "FormFile.do")
	public @ResponseBody Map<String, Object> FormFile(CommandMap commandMap) {
		return formFileService.getGridList(commandMap);
	}

	@RequestMapping(value = "popUpAddFormFile.do")
	public ModelAndView popUpAddFormFile(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/popUp" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	@RequestMapping(value = "saveFormFile.do")
	public @ResponseBody Map<String, String> saveFormFile(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		return formFileService.saveFormFile(commandMap, request);
	}

	@RequestMapping(value = "/delFormFile.do")
	public @ResponseBody Map<String, String> delFormFile(CommandMap commandMap) throws Exception {
		return formFileService.delFormFile(commandMap);
	}
}
