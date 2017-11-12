package stxship.dis.buyerClass.letterFaxInput.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.buyerClass.letterFaxInput.service.LetterFaxInputService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : LetterFaxInputController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxInput의 컨트롤러
 *     </pre>
 */
@Controller
public class LetterFaxInputController extends CommonController {
	@Resource(name = "letterFaxInputService")
	private LetterFaxInputService letterFaxInputService;

	/**
	 * @메소드명 : letterFaxInput
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LetterFaxInput 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "buyerClassLetterFaxInput.do")
	public ModelAndView buyerClassLetterFaxInput(CommandMap commandMap) throws Exception {
		Map<String,String> dpsUserInfo = letterFaxInputService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
			ModelAndView mv = new ModelAndView("/buyerClass/letterFaxInput" + commandMap.get(DisConstants.JSP_NAME));
			// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
			mv.addObject("dpsUserInfo", dpsUserInfo);			
			if("Y".equals(dpsUserInfo.get("adminyn"))){
				List<Map<String,Object>> departmentList = letterFaxInputService.getDepartmentForBuyerClass();	
				mv.addObject("departmentList", departmentList);
				
				if(commandMap.containsKey("department_s")){
					dpsUserInfo.put("DEPT_CODE", String.valueOf(commandMap.get("department_s")));
				}
				
				List<Map<String,Object>> personsList = letterFaxInputService.getPartPersonsForBuyerClass(dpsUserInfo);
				mv.addObject("personsList", personsList);
				if(personsList != null && personsList.size() > 0)commandMap.put("user_s", personsList.get(0).get("EMPLOYEE_NUM"));
				if(personsList == null || personsList.size() == 0){
					dpsUserInfo = letterFaxInputService.getDpsUserInfo(commandMap);
					personsList = letterFaxInputService.getPartPersonsForBuyerClass(dpsUserInfo);
					mv.addObject("personsList", personsList);
					mv.addObject("msg", "부서 인원이 없는 부서입니다. 초기화 합니다.");
				}
			} else {
				List<Map<String,Object>> personsList = letterFaxInputService.getPartPersonsForBuyerClass(dpsUserInfo);
				mv.addObject("personsList", personsList);
			}
			
			mv.addAllObjects(commandMap.getMap());
			return mv;
		}
	}

	/**
	 * @메소드명 : buyerClassLetterFaxOpenFile
	 * @날짜 : 2016. 6. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 문서 작성 버튼 선택
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxOpenFile.do")
	public ModelAndView buyerClassLetterFaxOpenFile(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxInput" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxProjectInfo
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 프로젝트 정보 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassLetterFaxProjectInfo.do")
	public @ResponseBody Map<String, String> buyerClassLetterFaxProjectInfo(CommandMap commandMap) throws Exception {
		Map<String, String> result = new HashMap<String, String>();
		result.put("result", letterFaxInputService.buyerClassLetterFaxProjectInfo(commandMap));
		return result;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxSerialCodeCheck
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 발신문서 번호 체크하여 사용중인 발신문서인경우 새로운 발신문서를 받아온다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassLetterFaxSerialCodeCheck.do")
	public @ResponseBody Map<String, String> buyerClassLetterFaxSerialCodeCheck(CommandMap commandMap)
			throws Exception {
		Map<String, String> result = new HashMap<String, String>();
		result.put("result", letterFaxInputService.buyerClassLetterFaxSerialCodeCheck(commandMap));
		return result;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxDocumentSaveProcess
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인 업무 확정
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassLetterFaxDocumentSaveProcess.do")
	public @ResponseBody Map<String, String> buyerClassLetterFaxDocumentSaveProcess(CommandMap commandMap)
			throws Exception {
		return letterFaxInputService.buyerClassLetterFaxDocumentSaveProcess(commandMap);
	}

	/**
	 * @메소드명 : buyerClassLetterFaxDrawingInfo
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 참조 도면 정보 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassLetterFaxDrawingInfo.do")
	public @ResponseBody Map<String, String> buyerClassLetterFaxDrawingInfo(CommandMap commandMap) throws Exception {
		Map<String, String> result = new HashMap<String, String>();
		result.put("result", letterFaxInputService.buyerClassLetterFaxDrawingInfo(commandMap));
		return result;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxDocumentInfo
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 참조 문서 정보 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassLetterFaxDocumentInfo.do")
	public @ResponseBody Map<String, String> buyerClassLetterFaxDocumentInfo(CommandMap commandMap) throws Exception {
		Map<String, String> result = new HashMap<String, String>();
		result.put("result", letterFaxInputService.buyerClassLetterFaxDocumentInfo(commandMap));
		return result;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxViewFileDialog
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 참조 파일 열기 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxViewFileDialog.do")
	public ModelAndView buyerClassLetterFaxViewFileDialog(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxInput" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxViewFileOpen
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 문서 파일 오픈 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxViewFileOpen.do")
	public ModelAndView buyerClassLetterFaxViewFileOpen(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxInput" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : buyerClassLetterFaxViewFileDelete
	 * @날짜 : 2016. 6. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 문서 파일 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxViewFileDelete.do")
	public ModelAndView buyerClassLetterFaxViewFileDelete(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxInput" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	/**
	 * 
	 * @메소드명	: buyerClassLetterFaxViewFileDelete
	 * @날짜		: 2016. 11. 24.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	호선추가 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxProjectSelect.do")
	public ModelAndView buyerClassLetterFaxProjectSelect(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxInput" + "/stxPECDPInput_ProjectSelect");
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	

}
