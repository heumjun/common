package stxship.dis.etc.systemStandardView.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.etc.systemStandardView.service.SystemStandardViewService;

/**
 * 
 * @파일명	: SystemStandardViewController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 9. 8. 
 * @작성자	: 정재동 
 * @설명
 * <pre>
 * 	SystemStandard 컨트롤러
 * </pre>
 */
@Controller
public class SystemStandardViewController extends CommonController {
	@Resource(name = "systemStandardViewService")
	private SystemStandardViewService systemStandardViewService;

	/**
	 * 
	 * @메소드명	: systemStandardView
	 * @날짜		: 2016. 9. 8.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 시스템 표준관리 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "systemStandardView.do")
	public ModelAndView systemStandardView(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: systemStandardViewList
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	시스템 표준 용어/명칭 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	
	@RequestMapping(value = "systemStandardViewList.do")
	public @ResponseBody Map<String, Object> systemStandardViewList(CommandMap commandMap) {
		return systemStandardViewService.systemStandardViewList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: systemStandardExcelExport
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	시스템 표준 용어/명칭 리스트 엑셀 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "systemStandardExcelExport.do")
	public View systemStandardExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return systemStandardViewService.systemStandardExcelExport(commandMap, modelMap);
	}
	
	/**
	 * 
	 * @메소드명	: systemStandardViewFileList
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: STX_User
	 * @설명		: 
	 * <pre>
	 *	시스템 표준 형식 첨부파일
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "systemStandardViewFileList.do")
	public @ResponseBody Map<String, Object> systemStandardViewFileList(CommandMap commandMap) {
		return systemStandardViewService.systemStandardViewFileList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: saveSystemStandardView
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *		시스템 표준 용어/명칭 저장 및 수정
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveSystemStandardView.do")
	public @ResponseBody Map<String, String> saveSystemStandardView(CommandMap commandMap) throws Exception {
		return systemStandardViewService.saveSystemStandardView(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: popUpSystemStandardDoc
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	시스템 표준 형식 파일첨부 팝업창
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpSystemStandardDoc.do")
	public ModelAndView popUpSystemStandardDoc(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/etc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: systemStandardFileUpload
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	시스템 표준형식 파일 첨부
	 * </pre>
	 * @param response
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "systemStandardFileUpload.do")
	public @ResponseBody Map<String, Object> systemStandardFileUpload(HttpServletResponse response,
			HttpServletRequest request, CommandMap commandMap) throws Exception {
		return systemStandardViewService.systemStandardFileUpload(response, request, commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: saveSystemStandardFile
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	시스템 표준형식 데이터 수정
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveSystemStandardFile.do")
	public @ResponseBody Map<String, String> saveSystemStandardFile(CommandMap commandMap) throws Exception {
		return systemStandardViewService.saveSystemStandardFile(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: systemStandardFileDownload
	 * @날짜		: 2016. 9. 9.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	시스템 표준형식 첨부파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "systemStandardFileDownload.do")
	public View systemStandardFileDownload(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return systemStandardViewService.systemStandardFileDownload(commandMap, modelMap);
	}
}
