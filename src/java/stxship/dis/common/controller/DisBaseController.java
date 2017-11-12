package stxship.dis.common.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;

/**
 * @파일명 : DisBaseController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 8.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 공통적으로 사용되는 컨트롤을 정의한다.
 *     </pre>
 */
@Controller
public class DisBaseController extends CommonController {

	/**
	 * @메소드명 : popUpECORelatedAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO연계 조회 팝업화면 호출
	 * 1. Paint USC에서 ECO추가 선택했을시
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpECORelated.do")
	public ModelAndView popUpECORelatedAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoECORelatedAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO연계 조회 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoECORelated.do")
	public @ResponseBody Map<String, Object> infoECORelatedAction(CommandMap commandMap) {
		return commonService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoProjectShipTypeAction
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ProjectNo로 shipType를 취득
	 * 1. paint USC에서 사용
	 * 2. 쿼리만 BOM현황의 saveBomJobItem에서 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoProjectShipType.do")
	public @ResponseBody Map<String, Object> infoProjectShipTypeAction(CommandMap commandMap) {
		return commonService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : popUpProjectNoAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1. BOM 현황 정전개화면의 프로젝트 검색 팝업창 이동
	 * 2. BOM 조회화면
	 * 3. Paint USC
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpProjectNo.do")
	public ModelAndView popUpProjectNoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoProjectNoAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 프로젝트 검색 팝업창의 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoProjectNo.do")
	public @ResponseBody Map<String, Object> infoProjectNoAction(CommandMap commandMap) {
		return commonService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpDelegateProjectNo
	 * @날짜 : 2015. 12. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpDelegateProjectNo 팝업창을 실행한다.
	 * 1. BOM 조회
	 * 2. PaintUSC
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDelegateProjectNo.do")
	public ModelAndView popUpDelegateProjectNo(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : popUpDelegateProjectNoList
	 * @날짜 : 2015. 12. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpDelegateProjectNo 팝업창의 리스트를 취득한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "infoDelegateProjectNoList.do")
	public @ResponseBody Map<String, Object> popUpDelegateProjectNoList(CommandMap commandMap) {
		return commonService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoEmpNoRegisterListAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1. BOB현황에서 결제자 정보를 가져옴
	 * 2. ECO 에서 결재자 정보, 생성자 정보를 가져옴
	 * 3. ECR 에서 생성자 정보를 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEmpNoRegisterList.do")
	public @ResponseBody List<Map<String, Object>> infoEmpNoRegisterListAction(CommandMap commandMap) {
		return commonService.getDbDataList(commandMap);
	}

	/**
	 * @메소드명 : popUpCauseAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1. BOM 현황 정전개화면 상단의 원인코드를 검색하였을때의 팝업화면 이동
	 * 2. ECO 리스트의 ECO Cause를 선택했을때의 팝업화면 이동
	 * 리스트내용 출력 액션은 공통 컨트롤러 DisBaseController/infoEcoCategoryList에 정의
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCause.do")
	public ModelAndView popUpCauseAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoEcoCategoryListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.ECR ECO Mapping의 팝업창에서 EcoCategoty 리스트 정보를 출력
	 * 2.BOM현황의 원인코드 팝업창에서  EcoCategoty 리스트 정보를 출력
	 * 3.ECO 리스트의 ECO Cause를 선택했을때의 팝업창에서 EcoCategoty 리스트 정보를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoCategoryList.do")
	public @ResponseBody Map<String, Object> infoEcoCategoryListAction(CommandMap commandMap) {
		return commonService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectWeekListAction
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 일주일 단위의 날짜 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectWeekList.do")
	public @ResponseBody Map<String, Object> selectWeekListAction(CommandMap commandMap) {
		commandMap.put(DisConstants.MAPPER, "Main.selectWeekList");
		return commonService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : selectAddDayAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 당일 날짜 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectAddDay.do")
	public @ResponseBody Map<String, Object> selectAddDayAction(CommandMap commandMap) {
		commandMap.put(DisConstants.MAPPER, "Main.selectAddDay");
		return commonService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : popUpSearchCreateByAction
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpSearchCreateBy 팝업창을 실행한다.
	 *  1. ECO 작성자, 작업자 검색
	 *  2. ECR 작성자, 작업자 검색
	 *  3. Search Item 생성자 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpSearchCreateBy.do")
	public ModelAndView popUpSearchCreateByAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoSearchCreateByListAction
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpSearchCreateBy 팝업창 리스트를 취득환다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "infoSearchCreateByList.do")
	public @ResponseBody Map<String, Object> infoSearchCreateByListAction(CommandMap commandMap) {
		return commonService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpGroupAction
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 부서검색 팝업
	 * 1. ECO 부서 검색 팝업
	 * 2. ECR 부서 검색 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpGroup.do")
	public ModelAndView popUpGroupAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoGroupListAction
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 부서검색 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoGroupList.do")
	public @ResponseBody Map<String, Object> infoGroupListAction(CommandMap commandMap) {
		return commonService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpEmpNoAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1. BOM 현황 정전개화면 상단의 결재자 검색
	 * 2. ECO 화면의 ECO리스트의 결재자 검색
	 * 3. ECR 화면의 ECR리스트의 결재자 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmpNoAndRegiter.do")
	public ModelAndView popUpEmpNoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoEmpNoListAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEmpNoList.do")
	public @ResponseBody Map<String, Object> infoEmpNoListAction(CommandMap commandMap) {
		return commonService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveEngineerRegisterAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 결재자 변경 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEngineerRegister.do")
	public @ResponseBody Map<String, String> saveEngineerRegisterAction(CommandMap commandMap) throws Exception {
		return commonService.saveEngineerRegister(commandMap);
	}

	/**
	 * @메소드명 : infoIsAuthApproveAction
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 결재 권한을 취득
	 * 1. ECO Life Cycle에서 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoIsAuthApprove.do")
	public @ResponseBody Map<String, Object> infoIsAuthApproveAction(CommandMap commandMap) {
		return commonService.getDbDataOne(commandMap);
	}

	@RequestMapping(value = "infoComboCodeMaster.do")
	public @ResponseBody List<Map<String, Object>> infoComboCodeMasterAction(CommandMap commandMap) {
		return commonService.getDbDataList(commandMap);
	}

	/**
	 * @메소드명 : commonSelectBoxDataList
	 * @날짜 : 2015. 12. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		공통 셀렉트 박스 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commonSelectBoxDataList.do")
	public @ResponseBody String commonSelectBoxDataList(CommandMap commandMap) throws Exception {
		return commonService.getSelectBoxDataList(commandMap);
	}

	/**
	 * @메소드명 : updateUserControlAction
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * UserControl을 업데이트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "updateUserControl.do")
	public @ResponseBody int updateUserControlAction(CommandMap commandMap) {
		return commonService.updateDbData(commandMap);
	}

}
