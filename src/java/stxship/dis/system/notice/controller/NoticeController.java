package stxship.dis.system.notice.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.notice.service.NoticeService;

@Controller
public class NoticeController extends CommonController {
	@Resource(name = "noticeService")
	private NoticeService noticeService;

	@RequestMapping(value = "notice.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "noticeList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return noticeService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveNotice.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return noticeService.saveGridList(commandMap);
	}

	@RequestMapping(value = "/popUpNoticeList.do")
	public @ResponseBody ModelAndView popupNoticeList(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		mav.addObject("noticeList", noticeService.getDbDataList(commandMap));
		return mav;
	}

	@RequestMapping(value = "/popUpNotice.do")
	public @ResponseBody ModelAndView popupNotice(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("menu" + commandMap.get(DisConstants.JSP_NAME));
		noticeService.updateReadCount(commandMap);
		mav.addObject("notice", noticeService.getDbDataOne(commandMap));
		return mav;
	}
	
	/**
	 * @메소드명 : popUpNoticeAttachAdd
	 * @날짜 : 2017. 04. 03.
	 * @작성자 : Cho heumjun
	 * @설명 :
	 * 
	 *     <pre>
	 * Document 추가 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpNoticeAttachAdd.do")
	public ModelAndView popUpNoticeAttachAdd(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/system/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : NoticeAddSave
	 * @날짜 : 2017. 8. 31.
	 * @작성자 : 정재동
	 * @설명 :
	 * 
	 *     <pre>
	 * Document 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "NoticeAddSave.do")
	public @ResponseBody Map<String, Object> NoticeAddSave(HttpServletResponse response,
			HttpServletRequest request, CommandMap commandMap) throws Exception {
		return noticeService.NoticeAddSave(response, request, commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: noticeFileView
	 * @날짜 : 2017. 04. 03.
	 * @작성자 : Cho heumjun
	 * @설명		: 
	 * <pre>
	 * 파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "noticeFileView.do", method=RequestMethod.GET, produces="application/text; charset=utf8")
	public View noticeFileView(CommandMap commandMap, Map<String, Object> modelMap, @RequestParam("p_seq") String p_seq) throws Exception {

		return noticeService.noticeFileDownload(commandMap, modelMap);
	}
	
	
	//TODO 공지사항 등록창
	@RequestMapping(value = "/noticeRegister.do")
	public @ResponseBody ModelAndView noticeRegister(CommandMap commandMap) {
		
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/system/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		
		return mav;
	}
	
	/**
	 * @메소드명 : frmNoticeAddSave
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : Cho Heum Jun
	 * @설명 :
	 * 
	 *     <pre>
	 * Notice 등록
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "frmNoticeAddSave.do")
	public @ResponseBody Map<String, Object> frmNoticeAddSave(HttpServletResponse response, HttpServletRequest request, CommandMap commandMap) throws Exception {
		return noticeService.frmNoticeAddSave(response, request, commandMap);
	}
	
}
