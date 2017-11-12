package stxship.dis.buyerClass.buyerClassComment.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import stxship.dis.buyerClass.buyerClassComment.service.BuyerClassCommentService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.common.service.DpsCommonService;
import stxship.dis.dps.progressInput.service.ProgressInputService;

/**
 * @파일명 : BuyerClassCommentController.java
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
public class BuyerClassCommentController extends CommonController {
	@Resource(name = "buyerClassCommentService")
	private BuyerClassCommentService buyerClassCommentService;
	
	@Resource(name = "dpsCommonService")
	private DpsCommonService dpsCommonService;

	/**
	 * @메소드명 : buyerClassComment
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BuyerClassComment 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "buyerClassComment.do")
	public ModelAndView buyerClassComment(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/buyerClass/comment" + commandMap.get(DisConstants.JSP_NAME));

		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpsCommonService.getEmployeeInfo(param);
		List<Map<String,Object>> projectList = null;
		
		if(loginUserInfo != null){
			loginUserInfo.put("category", "PROGRESS");
			projectList = dpsCommonService.getProgressSearchableProjectList(loginUserInfo, true);
			
		}
		commandMap.put("projectList", projectList);
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		// 권한정보
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentList
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 문서접수 / 실적관리 리스트 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentList.do")
	public ModelAndView buyerClassCommentList(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentProcessFileOpen
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 접수문서 열기
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentProcessFileOpen.do")
	public ModelAndView buyerClassCommentProcessFileOpen(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentReceiveChangeProcesser
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 담당자 변경  (수신부서 팀장/파트장)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentChangeProcesser.do")
	public ModelAndView buyerClassCommentReceiveChangeProcesser(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentChangeProcesserAction
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 *  담당자 변경 처리
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentChangeProcesserAction.do")
    public ModelAndView buyerClassCommentChangeProcesserAction(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
        // get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
        mv.addAllObjects(commandMap.getMap());
        return mv;
    }
	
	/** 
	 * @메소드명	: buyerClassCommentReceiveSearchProcessPerson
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 담당자 변경 팝업창에서 담당자 지정을 선택했을때의 Comment 처리 담당자 지정 팝업창 오픈
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentReceiveSearchProcessPerson.do")
	public ModelAndView buyerClassCommentReceiveSearchProcessPerson(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	

	/** 
	 * @메소드명	: buyerClassCommentReceive
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 수신문서 접수 팝업창 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentReceive.do")
	public ModelAndView buyerClassCommentReceive(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentReceiveAction
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 수신문서 접수 실행
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentReceiveAction.do")
	public ModelAndView buyerClassCommentReceiveAction(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : buyerClassCommentProcess
	 * @날짜 : 2016. 6. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 실적등록 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentProcess.do")
	public ModelAndView buyerClassCommentProcess(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : buyerClassCommentProcessAction
	 * @날짜 : 2016. 6. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 실적등록 로직실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassCommentProcessAction.do")
	public ModelAndView buyerClassCommentProcessAction(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		buyerClassCommentService.saveBuyerClassCommentProcess(commandMap, request);
		return mv;
	}

	/**
	 * @메소드명 : buyerClassCommentPersonSearchRefNo
	 * @날짜 : 2016. 6. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 실적등록 Ref.No 찾기 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentPersonSearchRefNo.do")
	public ModelAndView buyerClassCommentPersonSearchRefNo(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : buyerClassCommentProcessAddition
	 * @날짜 : 2016. 6. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 실적추가 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentProcessAddition.do")
	public ModelAndView buyerClassCommentProcessAddition(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentProcessAdditionAction
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 문서 접수
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassCommentProcessAdditionAction.do")
	public ModelAndView buyerClassCommentProcessAdditionAction(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		buyerClassCommentService.saveBuyerClassCommentProcessAddition(commandMap, request);
		return mv;
	}

	/** 
	 * @메소드명	: buyerClassCommentForceClosed
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 강제 Closed
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassCommentForceClosed.do")
	public @ResponseBody Map<String, String> buyerClassCommentForceClosed(CommandMap commandMap) throws Exception {
		return buyerClassCommentService.buyerClassCommentForceClosed(commandMap);
	}

	/** 
	 * @메소드명	: buyerClassCommentExcelDownload
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 엑셀 다운로드
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassCommentExcelDownload.do")
	public ModelAndView buyerClassCommentExcelDownload(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

}
