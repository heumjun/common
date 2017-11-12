package stxship.dis.ems.admin.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.ems.admin.service.EmsAdminService;

/** 
 * @파일명	: EmsAdminController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 03. 21. 
 * @작성자	: 이상빈 
 * @설명
 * <pre>
 * EmsAdmin 컨트롤러
 * </pre>
 */

@Controller
public class EmsAdminController extends CommonController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "emsAdminService")
	private EmsAdminService emsAdminService;
	
	/** 
	 * @메소드명	: linkSelectedMenu
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * EmsAdmin 모듈로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsAdmin.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/** 
	 * @메소드명	: emsAdminGetDeptList
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 조회조건 부서 SelectBox 리스트 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsAdminSelectBoxDept.do")
	public @ResponseBody List<Map<String, Object>> emsAdminSelectBoxDept(CommandMap commandMap) throws Exception {
		return emsAdminService.emsAdminSelectBoxDept(commandMap);
	}
	
	/** 
	 * @메소드명	: emsAdminList
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * emsAdmin 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsAdminList.do")
	public @ResponseBody Map<String, Object> emsAdminList(CommandMap commandMap) {
		return emsAdminService.getErpGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: emsAdminApprove
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * emsAdmin 선택항목 승인
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "emsAdminApprove.do")
	public @ResponseBody Map<String, Object> emsAdminApprove(CommandMap commandMap) throws Exception {
		return emsAdminService.emsAdminApprove(commandMap);
	}
	
	/** 
	 * @메소드명	: emsAdminRefuse
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * emsAdmin 선택항목 반려
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "emsAdminRefuse.do")
	public @ResponseBody Map<String, Object> emsAdminRefuse(CommandMap commandMap) throws Exception {
		return emsAdminService.emsAdminRefuse(commandMap);
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpec
	 * @날짜 : 2016. 03. 28.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양서 버튼 팝업창을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpAdminSpec.do")
	public ModelAndView popUpAdminSpec(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/** 
	 * @메소드명	: popUpAdminSpecList
	 * @날짜		: 2016. 03. 28. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 *  사양서 버튼 팝업창 : 리스트 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpAdminSpecList.do")
	public @ResponseBody Map<String, Object> popUpAdminSpecList(CommandMap commandMap) {
		// 선택 호선 배열로 변환
		String dwgNoArray[] = commandMap.get("p_dwg_no").toString().split(",");
		commandMap.put("dwgNoArray", dwgNoArray);
		return emsAdminService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpAdminSpecDownloadFile
	 * @날짜 : 2016. 03. 31.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양서 버튼 팝업창 : 파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpAdminSpecDownloadFile.do")
	public View popUpAdminSpecDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsAdminService.popUpAdminSpecDownloadFile(commandMap, modelMap);
	}
}
