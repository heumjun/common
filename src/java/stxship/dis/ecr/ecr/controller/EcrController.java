package stxship.dis.ecr.ecr.controller;

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
import stxship.dis.ecr.ecr.service.EcrService;

/**
 * @파일명 : EcrController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 14.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 		ECR Controller
 *     </pre>
 */
@Controller
public class EcrController extends CommonController {
	@Resource(name = "ecrService")
	private EcrService ecrService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR 메인화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecr.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.ECR + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : ecrList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR 리스트 받아옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrList.do")
	public @ResponseBody Map<String, Object> ecrList(CommandMap commandMap) {
		return ecrService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : ecrHistory
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR HISTORY 탭 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrHistory.do")
	public ModelAndView ecrHistory(CommandMap commandMap) {
		return new ModelAndView("ecr/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : ecrHistoryList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR HISTORY 탭 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrHistoryList.do")
	public @ResponseBody Map<String, Object> ecrHistoryList(CommandMap commandMap) {
		return ecrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : ecrLifeCycle
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR LIFE CYCLE 탭 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrLifeCycle.do")
	public ModelAndView ecrLifeCycle(CommandMap commandMap) {
		return new ModelAndView("ecr/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : ecrLifeCycleList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR LIFE CYCLE 탭 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrLifeCycleList.do")
	public @ResponseBody Map<String, Object> ecrLifeCycleList(CommandMap commandMap) {
		return ecrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : ecrRoute
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR ROUTE 탭 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrRoute.do")
	public ModelAndView ecrRoute(CommandMap commandMap) {
		return new ModelAndView("ecr/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : ecrRouteList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR ROUTE 탭 화면  리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrRouteList.do")
	public @ResponseBody Map<String, Object> ecrRouteList(CommandMap commandMap) {
		return ecrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : ecrRelatedECOs
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR RelatedEco 탭 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrRelatedECOs.do")
	public ModelAndView ecrRelatedECOs(CommandMap commandMap) {
		return new ModelAndView("ecr/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : ecrRelatedECOsList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR RelatedEco 탭 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrRelatedECOsList.do")
	public @ResponseBody Map<String, Object> ecrRelatedECOsList(CommandMap commandMap) {
		return ecrService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : selectEcrEvaluatorList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR Evaluator 탭 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrEvaluatorList.do")
	public @ResponseBody Map<String, Object> selectEcrEvaluatorList(CommandMap commandMap) {
		return ecrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectEcrBasedList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR Evaluator 탭 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrBasedList.do")
	public @ResponseBody Map<String, Object> selectEcrBasedList(CommandMap commandMap) {
		return ecrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpGroup
	 * @날짜 : 2015. 12. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		1. 부서 검색 팝업 창 호출
	 *		2. 공통 Controller로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	// @RequestMapping(value = "popUpGroup.do")
	// public ModelAndView popUpGroup(CommandMap commandMap) {
	// return new ModelAndView("ecr/popUp/" +
	// commandMap.get(DisConstants.MAPPER_NAME));
	// }

	/**
	 * @메소드명 : popUpGroupList
	 * @날짜 : 2015. 12. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		부서 검색 팝업 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	// @RequestMapping(value = "popUpGroupList.do")
	// public @ResponseBody Map<String, Object> popUpGroupList(CommandMap
	// commandMap) {
	// commandMap.put(DisConstants.CUSTOM_SERVICE_KEY, ecrService);
	// return getGridList(commandMap);
	// }

	/**
	 * @메소드명 : popUpApproveEmpNo
	 * @날짜 : 2015. 12. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		결재 라인 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpApproveEmpNo.do")
	public ModelAndView popUpApproveEmpNo(CommandMap commandMap) {
		return new ModelAndView("ecr/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpApproveEmpNoList
	 * @날짜 : 2015. 12. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		결제라인 팝업 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpApproveEmpNoList.do")
	public @ResponseBody Map<String, Object> popUpApproveEmpNoList(CommandMap commandMap) {
		return ecrService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : getStatesReqList
	 * @날짜 : 2017. 1. 18.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *		getStatesReqList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "getStatesReqList.do")
	public @ResponseBody Map<String, Object> getStatesReqList(CommandMap commandMap) {
		return ecrService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveEcr
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR 저장 (추가 & 수정)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEcr.do")
	public @ResponseBody Map<String, Object> saveEcr(CommandMap commandMap) throws Exception {
		return ecrService.saveEcr(commandMap);
	}

	/**
	 * @메소드명 : itemExcelExport
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ecrExcelExport.do")
	public View itemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return ecrService.ecrExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : ecrPromoteDemote
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ECR Promote and Demote
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "ecrPromoteDemote.do")
	public @ResponseBody Map<String, Object> ecrPromoteDemote(CommandMap commandMap) throws Exception {
		return ecrService.saveEcrPromoteDemote(commandMap);
	}

	/**
	 * @메소드명 : deleteRelatedECOs
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		Related Ecos 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deleteRelatedECOs.do")
	public @ResponseBody Map<String, Object> deleteRelatedECOs(CommandMap commandMap) throws Exception {
		return ecrService.deleteRelatedECOs(commandMap);
	}

	/**
	 * @메소드명 : popUpEcrToEcoRelated
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Related Eco 추가 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEcrToEcoRelated.do")
	public ModelAndView popUpEcrToEcoRelated(CommandMap commandMap) {
		return new ModelAndView("ecr/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpEcrToEcrRelatedList
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		Related Eco 추가 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEcrToEcoRelatedList.do")
	public @ResponseBody Map<String, Object> popUpEcrToEcoRelatedList(CommandMap commandMap) {
		return ecrService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveEcrToEcoRelated
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEcrToEcoRelated.do")
	public @ResponseBody Map<String, String> saveEcrToEcoRelated(CommandMap commandMap) throws Exception {
		return ecrService.saveEcrToEcoRelated(commandMap);
	}
	
	/**
	 * @메소드명 : popUpEcrnoCreate
	 * @날짜 : 2016. 11. 28.
	 * @작성자 : 조흠준
	 * @설명 :
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpEcrnoCreate.do")
	public ModelAndView popUpEcrnoCreate(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

}
