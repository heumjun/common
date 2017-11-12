package stxship.dis.commentSend.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.commentSend.service.CommentSendService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

@Controller
public class CommentSendController extends CommonController {

	@Resource(name = "CommentSendService")
	private CommentSendService commentSendService;
	
	/**
	 * @메소드명 : commentSend
	 * @날짜 : 2017. 6. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "commentSend.do")
	public ModelAndView commentSend(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendList
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 요청 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendList.do")
	public @ResponseBody Map<String, Object> commentSendList(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendList(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendSave
	 * @날짜 : 2017. 06. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 요청 SAVE
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendSave.do")
	public @ResponseBody Map<String, Object> commentSendSave(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendSave(commandMap);
	}
	
	/**
	 * @메소드명 : popUpCommentSendDwgNo
	 * @날짜 : 2017. 07. 13.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		SUB 도면번호 등록 팝업 창
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentSendDwgNo.do")
	public ModelAndView popUpCommentSendDwgNo(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : popUpCommentSendDwgNoList
	 * @날짜 : 2017. 07. 13.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		SUB 도면번호 등록 팝업 창 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentSendDwgNoList.do")
	public @ResponseBody Map<String, Object> popUpCommentSendDwgNoList(CommandMap commandMap) throws Exception {
		return commentSendService.popUpCommentSendDwgNoList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpCommentSendDwgNoSave
	 * @날짜 : 2017. 07. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		SUB 도면번호 등록 팝업 창 SAVE
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentSendDwgNoSave.do")
	public @ResponseBody Map<String, Object> popUpCommentSendDwgNoSave(CommandMap commandMap) throws Exception {
		return commentSendService.popUpCommentSendDwgNoSave(commandMap);
	}
	
	/**
	 * @메소드명 : popupCommentSendGridDwgNo
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 DWG NO. 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupCommentSendGridDwgNo.do")
	public @ResponseBody List<Map<String, Object>> popupCommentSendGridDwgNo(CommandMap commandMap) throws Exception {
		return commentSendService.popupCommentSendGridDwgNo(commandMap);
	}
	
	/**
	 * @메소드명 : popupCommentSendGridDwgNoAppSubmit
	 * @날짜 : 2017. 08. 11.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 DWG NO. 콤보박스 - Change (app Submit No)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupCommentSendGridDwgNoAppSubmit.do")
	public @ResponseBody List<Map<String, Object>> popupCommentSendGridDwgNoAppSubmit(CommandMap commandMap) throws Exception {
		return commentSendService.popupCommentSendGridDwgNoAppSubmit(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendFormDownload
	 * @날짜 : 2017. 07. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		서버파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendFormDownload.do")
	public ModelAndView commentSendFormDownload(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("comment" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	
	/**
	 * @메소드명 : commentSendGetFormName
	 * @날짜 : 2017. 07. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		FORM NAME을 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendGetFormName.do")
	public @ResponseBody Map<String, Object> commentSendGetFormName(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendGetFormName(commandMap);
	}
	
	/**
	 * @메소드명 : popUpCommentSendAttach
	 * @날짜 : 2017. 07. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 다중 업로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentSendAttach.do")
	public ModelAndView popUpCommentSendAttach(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : popUpCommentSendAttachList
	 * @날짜 : 2017. 07. 05.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		업로드 된 문서 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentSendAttachList.do")
	public @ResponseBody Map<String, Object> popUpCommentSendAttachList(CommandMap commandMap) throws Exception {
		return commentSendService.popUpCommentSendAttachList(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendFileView
	 * @날짜 : 2017. 07. 05.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		업로드 된 문서 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendFileView.do", method=RequestMethod.GET, produces="application/text; charset=utf8")
	public View commentSendFileView(CommandMap commandMap, Map<String, Object> modelMap, @RequestParam("p_document_id") String p_document_id) throws Exception {
		return commentSendService.commentSendFileView(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : commentSendFileDelete
	 * @날짜 : 2017. 07. 06.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		업로드 된 문서 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendFileDelete.do")
	public @ResponseBody Map<String, Object> commentSendFileDelete(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendFileDelete(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendRequest
	 * @날짜 : 2017. 06. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 승인요청 로직
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendRequest.do")
	public @ResponseBody Map<String, Object> commentSendRequest(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendRequest(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendGridProject
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 PROJECT 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendGridProject.do")
	public @ResponseBody List<Map<String, Object>> commentSendGridProject(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendGridProject(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendGridOcType
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 OC TYPE 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendGridOcType.do")
	public @ResponseBody List<Map<String, Object>> commentSendGridOcType(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendGridOcType(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendGridReqUser
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 발송자 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendGridReqUser.do")
	public @ResponseBody List<Map<String, Object>> commentSendGridReqUser(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendGridReqUser(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendExcelExport
	 * @날짜 : 2016. 07. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		메인 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentSendExcelExport.do", produces="text/plain;charset=UTF-8")
	public View sscMainExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return commentSendService.commentSendExcelExport(commandMap, modelMap);
	}
	
	
	/**
	 * @메소드명 : commentSendAdmin
	 * @날짜 : 2017. 6. 19.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신승인 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "commentSendAdmin.do")
	public ModelAndView commentSendAdmin(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendAdminList
	 * @날짜 : 2017. 06. 19.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신승인 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendAdminList.do")
	public @ResponseBody Map<String, Object> commentSendAdminList(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendAdminList(commandMap);
	}
	
	/**
	 * @메소드명 : commentSendAdminApply
	 * @날짜 : 2017. 06. 19.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT ADMIN 발신문서 승인/반려
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentSendAdminApply.do")
	public @ResponseBody Map<String, Object> commentSendAdminApprove(CommandMap commandMap) throws Exception {
		return commentSendService.commentSendAdminApply(commandMap);
	}
	
	/**
	 * @메소드명 : popUpCommentSendAdminRefuseContent
	 * @날짜 : 2017. 06. 19.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT ADMIN 발신문서 반려 내용 작성 팝업창
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentSendAdminRefuseContent.do")
	public ModelAndView popUpCommentSendAdminRefuseContent(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/comment/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * 
	 * @메소드명	: commentRequestDeptSelectBoxDataList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentRequest 발신파트 SelectBoxDataList
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentRequestDeptSelectBoxDataList.do")
	public @ResponseBody String commentRequestDeptSelectBoxDataList(CommandMap commandMap) throws Exception {
		return commentSendService.commentRequestDeptSelectBoxDataList(commandMap);
	}
}
