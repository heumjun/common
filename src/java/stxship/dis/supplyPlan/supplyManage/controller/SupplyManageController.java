package stxship.dis.supplyPlan.supplyManage.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.supplyPlan.supplyManage.service.SupplyManageService;

/**
 * @파일명 : SupplyManageController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 07. 26.
 * @작성자 : 이상빈
 * @설명
 * 
 * 	<pre>
 *  항목관리 컨트롤러
 *     </pre>
 */
@Controller
public class SupplyManageController extends CommonController {
	@Resource(name = "supplyManageService")
	private SupplyManageService supplyManageService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 07. 26.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 항목관리 화면으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyManage.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/** 
	 * @메소드명	: supplyManageLoginGubun
	 * @날짜		: 2016. 10. 14.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 항목관리 관리자 구분
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "supplyManageLoginGubun.do")
	public @ResponseBody Map<String, Object> supplyManageLoginGubun(CommandMap commandMap) throws Exception {
		return supplyManageService.supplyManageLoginGubun(commandMap);
	}
	
	/** 
	 * @메소드명	: supplyManageList
	 * @날짜		: 2016. 08. 01.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyManageList.do")
	public @ResponseBody Map<String, Object> supplyManageList(CommandMap commandMap) {
		return supplyManageService.getGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: supplyDwgList
	 * @날짜		: 2016. 08. 01.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * DWG 디테일 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyDwgList.do")
	public @ResponseBody Map<String, Object> supplyDwgList(CommandMap commandMap) {
		return supplyManageService.getGridList(commandMap);
	}

	/** 
	 * @메소드명	: supplyCatalogList
	 * @날짜		: 2016. 08. 02.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * CATALOG 디테일 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyCatalogList.do")
	public @ResponseBody Map<String, Object> supplyCatalogList(CommandMap commandMap) {
		return supplyManageService.getGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: saveSupplyManageList
	 * @날짜		: 2016. 08. 03.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 수정사항 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveSupplyManageList.do")
	public @ResponseBody Map<String, Object> saveSupplyManageList(CommandMap commandMap) throws Exception {
		return supplyManageService.saveSupplyManageList(commandMap);
	}	
	
	/**
	 * @메소드명 : popUpSupplyDeptCode
	 * @날짜 : 2016. 08. 08.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpSupplyDeptCode 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpSupplyDeptCode.do")
	public ModelAndView popUpSupplyDeptCode(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView(
				"/supplyPlan" + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	
	/**
	 * @메소드명 : popUpSupplyDeptCodeList
	 * @날짜 : 2016. 08. 08.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpSupplyDeptCodeList 팝업창 리스트를 불러온다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpSupplyDeptCodeList.do")
	public @ResponseBody Map<String, Object> popUpSupplyDeptCodeList(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return supplyManageService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * @메소드명 : supplyManageExcelExport
	 * @날짜 : 2016. 09. 29.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * supplyManage 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "supplyManageExcelExport.do")
	public View supplyManageExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return supplyManageService.supplyManageExcelExport(commandMap, modelMap);
	}
}
