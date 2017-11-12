package stxship.dis.comment.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.google.gson.Gson;

import stxship.dis.comment.service.CommentService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisJsonUtil;

/**
 * 
 * @파일명		: CommentController.java 
 * @프로젝트	: DIS
 * @날짜		: 2017. 7. 4. 
 * @작성자		: 이상빈
 * @설명
 * <pre>
 * 	COMMENT 수신, COMMENT MAIN, COMMENT 승인 (CONTROLLER CLASS)
 * </pre>
 */
@Controller
public class CommentController extends CommonController {

	@Resource(name = "CommentService")
	private CommentService commentService;
	
	//**************************************************************************
	// commentReceipt(수신문서) MAIN METHOD START  
	//**************************************************************************
	/**
	 * @메소드명 	: commentReceipt
	 * @날짜 		: 2017. 6. 1.
	 * @작성자 		: 이상빈
	 * @설명
	 *     <pre>
	 * 		commentReceipt 화면 이동
	 *     </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "commentReceipt.do")
	public ModelAndView commentReceipt(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptTeamSelectBoxDataList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentReceipt 담당팀 SelectBoxDataList
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptTeamSelectBoxDataList.do")
	public @ResponseBody String commentReceiptTeamSelectBoxDataList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptTeamSelectBoxDataList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptDeptSelectBoxDataList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentReceipt 담당부서 SelectBoxDataList
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptDeptSelectBoxDataList.do")
	public @ResponseBody String commentReceiptDeptSelectBoxDataList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptDeptSelectBoxDataList(commandMap);
	}
	
	/**
	 * @메소드명 	: commentReceiptList
	 * @날짜 		: 2016. 6. 9.
	 * @작성자 		: 이상빈
	 * @설명 		:
	 * 
	 *     <pre>
	 *		메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptList.do")
	public @ResponseBody Map<String, Object> commentReceiptList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptList(commandMap);
	}
	
	@RequestMapping(value = "commentReceiptDeleteAction.do")
	public @ResponseBody Map<String, Object> commentReceiptDeleteAction(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptDeleteAction(commandMap);
	}
	
	
	
	/**
	 * 
	 * @메소드명	: commentReceiptFileDownload
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentReceiptList Row 첨부파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @param p_receipt_id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="commentReceiptFileDownload.do", method=RequestMethod.GET, produces="application/text; charset=utf8")
	public View commentReceiptFileDownload(CommandMap commandMap, Map<String, Object> modelMap, @RequestParam("p_receipt_id") String p_receipt_id) throws Exception {
		return commentService.commentReceiptFileDownload(commandMap, modelMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptTeam
	 * @날짜		: 2017. 6. 16.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *		부서지정 팝업 호출
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpReceiptTeam.do")
	public ModelAndView popUpReceiptTeam(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}	
	
	/**
	 * 
	 * @메소드명	: popUpReceiptTeamList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	메인화면에서 선택된 1개의 Row를 부서지정 선택 팝업창으로 넘겨준다.
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpReceiptTeamList.do")
	public @ResponseBody Map<String, Object> popUpReceiptTeamList(CommandMap commandMap) throws Exception {
		return commentService.popUpReceiptTeamList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptGridTeamList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	부서지정 팝업 내 그리드에서 담당팀 SelectBox 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptGridTeamList.do")
	public @ResponseBody List<Map<String, Object>> commentReceiptGridTeamList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptGridTeamList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptTeamApplyAction
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	부서지정 팝업에서 부서지정 후 Apply Action
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptTeamApplyAction.do")
	public @ResponseBody Map<String, Object> commentReceiptTeamApplyAction(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptTeamApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : popUpReceiptUserId
	 * @날짜 : 2017. 6. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 *     <pre>
	 * 		담당자 팝업 호출
	 *     </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpReceiptUserId.do")
	public ModelAndView popupReceiptUserId(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptUserIdList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	메인화면에서 선택된 1개의 Row를 담당자 선택 팝업창으로 넘겨준다.
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpReceiptUserIdList.do")
	public @ResponseBody Map<String, Object> popUpReceiptUserIdList(CommandMap commandMap) throws Exception {
		return commentService.popUpReceiptUserIdList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptGridDeptList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	담당자 팝업 내 그리드에서 담당파트 SelectBox 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptGridDeptList.do")
	public @ResponseBody List<Map<String, Object>> commentReceiptGridDeptList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptGridDeptList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptGridUserList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	담당자 팝업 내 그리드에서 담당자 SelectBox 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptGridUserList.do")
	public @ResponseBody List<Map<String, Object>> commentReceiptGridUserList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptGridUserList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptUserList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	담당자 팝업 - 참조메일에서 User 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptUserList.do")
	public @ResponseBody List<Map<String, Object>> commentReceiptUserList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptUserList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptUserApplyAction
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	담당자 팝업에서 담당자 지정 후 Apply Action
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptUserApplyAction.do")
	public @ResponseBody Map<String, Object> commentReceiptUserApplyAction(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptUserApplyAction(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptDwg
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	도면 팝업 호출
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpReceiptDwg.do")
	public ModelAndView popUpReceiptDwg(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptDwgList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	메인화면에서 선택된 1개의 Row를 도면 선택 팝업창으로 넘겨준다.
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpReceiptDwgList.do")
	public @ResponseBody Map<String, Object> popUpReceiptDwgList(CommandMap commandMap) throws Exception {
		return commentService.popUpReceiptDwgList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptDwgApplyAction
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	도면 팝업에서 도면 지정 후 Apply Action(Update)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptDwgApplyAction.do")
	public @ResponseBody Map<String, Object> commentReceiptDwgApplyAction(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptDwgApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 	: popUpReceiptUserEtcMail
	 * @날짜 		: 2017. 6. 9.
	 * @작성자 		: 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		담당자 팝업 화면에서 참조메일 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException 
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpReceiptUserEtcMail.do")
	public ModelAndView popUpReceiptUserEtcMail(CommandMap commandMap) throws UnsupportedEncodingException {
		
		commandMap.put( "p_etc_user", URLDecoder.decode(commandMap.get("p_etc_user").toString(), "UTF-8") );
		
		ModelAndView mav = new ModelAndView("comment/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());

		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptUserEtcDeptSelectBoxDataList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 수신화면 담당자지정 - 참조메일 부서 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptUserEtcDeptSelectBoxDataList.do")
	public @ResponseBody String commentReceiptUserEtcDeptSelectBoxDataList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptUserEtcDeptSelectBoxDataList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptExcelExport
	 * @날짜		: 2017. 6. 2.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentReceipt 엑셀 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptExcelExport.do", produces="text/plain;charset=UTF-8")
	public View commentReceiptExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return commentService.commentReceiptExcelExport(commandMap, modelMap);
	}
	
	
	@RequestMapping(value = "popUpCommentReceiptChart.do")
	public ModelAndView popUpCommentReceiptChart(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	//**************************************************************************
	// commentReceipt(수신문서) MAIN METHOD END
	//**************************************************************************
	
	
	//**************************************************************************
	// commentReceipt(수신문서) ADD Method START
	//**************************************************************************
	/**
	 * @메소드명 	: commentReceiptAdd
	 * @날짜		: 2017. 06. 02.
	 * @작성자 		: 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *  	COMMENT 수신문서 등록 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "commentReceiptAdd.do")
	public ModelAndView commentReceiptAdd(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		ModelAndView mav = new ModelAndView("comment/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * 
	 * @메소드명	: commentReceiptProjectNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentReceipt ADD - Grid 내 프로젝트 자동완성
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptProjectNoList.do")
	public @ResponseBody String commentReceiptProjectNoList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptProjectNoList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptDwgNoList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *		commentReceipt ADD 부서에 따른 도면 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptDwgNoList.do")
	public @ResponseBody List<Map<String, Object>> commentReceiptDwgNoList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptDwgNoList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptAddValidationCheck
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *		commentReceipt ADD NEXT ACTION
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptAddValidationCheck.do")
	public @ResponseBody Map<String, Object> commentReceiptAddValidationCheck(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptAddValidationCheck(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptWorkValidationList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *		commentReceipt ADD NEXT ACTION 이후 데이터 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptWorkValidationList.do")
	public @ResponseBody Map<String, Object> commentReceiptWorkValidationList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptWorkValidationList(commandMap);
	}
	
	/**
	 * @메소드명 : commentReceiptAddApplyAction
	 * @날짜 : 2017. 06. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *		ADD Apply 버튼 클릭 시
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptAddApplyAction.do")
	public @ResponseBody Map<String, Object> commentReceiptAddApplyAction(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptAddApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : popUpCommentAttachFile
	 * @날짜 : 2017. 06. 02.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 수신문서 등록 화면 그리드 내에 있는 파일첨부 화면 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentAttachFile.do")
	public ModelAndView popUpCommentAttachFile(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptAttachFileAction
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 수신문서 등록 화면 그리드 해당 row 에 파일첨부 반영
	 * </pre>
	 * @param file
	 * @param commandMap
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptAttachFileAction.do")
	public void commentReceiptAttachFileAction(@RequestParam(value="fileName") MultipartFile file, CommandMap commandMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String, Object> map = commentService.commentReceiptAttachFileAction(file, commandMap);
		
		JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(map);
		
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().write(jsonObject.toString());
		
	}
	
	/**
	 * @메소드명 : popUpCommentAttachExcel
	 * @날짜 : 2017. 06. 02.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 수신문서 등록 화면 EXCEL IMPORT 화면이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentAttachExcel.do")
	public ModelAndView popUpCommentAttachExcel(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptExcelImportAction
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 수신문서 등록 화면 EXCEL IMPORT ACTION
	 * </pre>
	 * @param file
	 * @param commandMap
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptExcelImportAction.do")
	public void commentReceiptExcelImportAction(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		MultipartFile mf = null;
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;  
        Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
        
        for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {  
        	mf = entity.getValue();
        }
        
		File DecryptFile = null;
		DecryptFile = DisEGDecrypt.createDecryptFile(mf);
		
		commandMap.put("file", DecryptFile);
		commandMap.put("dec_document_name", DecryptFile.getName());
		
		//암호화 복호화 파일업로드 적용 해지
		//commandMap.put("file", file);
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
		if(mf.getOriginalFilename().equals("CommentReceiptAdd.xlsx")) {
			list = commentService.commentReceiptExcelImportAction(commandMap);
			
			for(Map<String, Object> tempMap : list) {
				
				if(!tempMap.get("column0").toString().trim().equals("")) {
					Map<String, Object> pkgParam = new HashMap<String, Object>();
					pkgParam.put("p_team_name", tempMap.get("column6"));
					
					Object teamCode = commentService.commentExcelTeamCode(pkgParam);
					tempMap.put("column8", teamCode);
					
					list1.add(tempMap);
				}
				
			}
			
        } else {
        	Map<String, Object> returnMap = new HashMap<String, Object>();
        	returnMap.put("dec_document_name", (Object) DecryptFile.getName());
        	list1.add(returnMap);
        }
		
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().write(DisJsonUtil.listToJsonstring(list1));
	}
	//**************************************************************************
	// commentReceipt(수신문서) ADD Method END
	//**************************************************************************
	
	
	//**************************************************************************
	//comment Main Method START
	//**************************************************************************
	/**
	 * @메소드명 : comment
	 * @날짜 : 2017. 6. 1.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "comment.do")
	public ModelAndView comment(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명	: commentAutoCompleteDwgNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 화면 - 도면번호 리스트 자동완성
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentAutoCompleteDwgNoList.do")
	public @ResponseBody String commentAutoCompleteDwgNoList(CommandMap commandMap) throws Exception {
		return commentService.commentAutoCompleteDwgNoList(commandMap);
	}
	
	/**
	 * @메소드명 	: commentList
	 * @날짜 		: 2016. 6. 19.
	 * @작성자 		: 이상빈
	 * @설명 		:
	 * 
	 *     <pre>
	 *		Comment 메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentList.do")
	public @ResponseBody Map<String, Object> commentList(CommandMap commandMap) throws Exception {
		return commentService.commentList(commandMap);
	}
	
	/**
	 * @메소드명	: commentReceiptNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *  Comment 메인 수신NO 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptNoList.do")
	public @ResponseBody List<Map<String, Object>> commentReceiptNoList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptNoList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpCommentMainAttach
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT MAIN  - 첨부파일 팝업 화면 
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentMainAttach.do")
	public ModelAndView popUpCommentMainAttach(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("comment/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: commentMainAttachAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT MAIN  - 첨부파일 복호화 후 uuid명으로 서버에 저장
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "commentMainAttachAction.do")
	public void commentMainAttachAction(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		MultipartFile mf = null;
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;  
        Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
        
        for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {  
        	mf = entity.getValue();
        }
        
		File DecryptFile = null;
		DecryptFile = DisEGDecrypt.createDecryptFile(mf);
		
		commandMap.put("file", DecryptFile);
		commandMap.put("dec_document_name", DecryptFile.getName());
		
		//암호화 복호화 파일업로드 적용 해지
		//commandMap.put("file", file);
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	Map<String, Object> returnMap = new HashMap<String, Object>();
    	returnMap.put("dec_sub_att", (Object) DecryptFile.getName());
    	list.add(returnMap);
		
		//DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}
	
	/**
	 * @메소드명	: commentMainSaveAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT MAIN 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentMainSaveAction.do")
	public @ResponseBody Map<String, Object> commentMainSaveAction(CommandMap commandMap) throws Exception {
		return commentService.commentMainSaveAction(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentPCFExcelExport
	 * @날짜		: 2017. 6. 2.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentReceipt PCF 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentPCFExcelExport.do", produces="text/plain;charset=UTF-8")
	public View commentPCFExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return commentService.commentPCFExcelExport(commandMap, modelMap);
		//return new GenericExcelView5();
	}
	
	/**
	 * 
	 * @메소드명	: commentReqeustApplyAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT MAIN 승인요청
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReqeustApplyAction.do")
	public @ResponseBody Map<String, Object> commentReqeustApplyAction(CommandMap commandMap) throws Exception {
		return commentService.commentReqeustApplyAction(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentRefNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 화면 - 그리드 내 발신번호 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentRefNoList.do")
	public @ResponseBody List<Map<String, Object>> commentRefNoList(CommandMap commandMap) throws Exception {
		return commentService.commentRefNoList(commandMap);
	}
	
	@RequestMapping(value = "popUpCommentCommentAttachList.do")
	public @ResponseBody Map<String, Object> popUpCommentCommentAttachList(CommandMap commandMap) throws Exception {
		return commentService.popUpCommentCommentAttachList(commandMap);
	}
	
	//**************************************************************************
	//comment Main Method END
	//**************************************************************************
	
	
	//**************************************************************************
	// comment 승인 Method START
	//**************************************************************************
	/**
	 * 
	 * @메소드명	: commentAdmin
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 승인 화면으로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentAdmin.do")
	public ModelAndView commentAdmin(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentAdminMaList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 승인화면 - 왼쪽 그리드 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentAdminMaList.do")
	public @ResponseBody Map<String, Object> commentAdminMaList(CommandMap commandMap) throws Exception {
		return commentService.commentAdminMaList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentAdminDeList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 승인화면 - 오른쪽 그리드 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentAdminDeList.do")
	public @ResponseBody Map<String, Object> commentAdminDeList(CommandMap commandMap) throws Exception {
		return commentService.commentAdminDeList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentAdminConfirmAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	COMMENT 승인화면 - 승인/반려 ACTION
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentAdminConfirmAction.do")
	public @ResponseBody Map<String, Object> commentAdminConfirmAction(CommandMap commandMap) throws Exception {
		return commentService.commentAdminConfirmAction(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpCommentAdminRefuse
	 * @날짜		: 2017. 7. 20.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *	COMMENT 승인화면 - 반려 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentAdminRefuse.do")
	public ModelAndView popUpCommentAdminRefuse(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/comment/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	//**************************************************************************
	// comment 승인 Method END
	//**************************************************************************
	
	
	//**************************************************************************
	// comment 현황 Method START
	//**************************************************************************
	/**
	 * @메소드명 : commentChart
	 * @날짜 : 2017. 6. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 현황 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "commentChart.do")
	public ModelAndView commentChart(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "commentChartList.do")
	public @ResponseBody String commentChartList(CommandMap commandMap) throws Exception {
		return new Gson().toJson(commentService.commentChartList(commandMap));
	}
	
	@RequestMapping(value = "commentChartDetailList.do")
	public @ResponseBody String commentChartDetailList(CommandMap commandMap) throws Exception {
		return new Gson().toJson(commentService.commentChartDetailList(commandMap));
	}
	
	@RequestMapping(value = "commentSelectBoxTeamList.do")
	public @ResponseBody String commentSelectBoxTeamList(CommandMap commandMap) throws Exception {
		return commentService.commentSelectBoxTeamList(commandMap);
	}
	
	@RequestMapping(value = "commentSelectBoxPartList.do")
	public @ResponseBody String commentSelectBoxPartList(CommandMap commandMap) throws Exception {
		return commentService.commentSelectBoxPartList(commandMap);
	}
	
	@RequestMapping(value = "commentSelectBoxUserList.do")
	public @ResponseBody String commentSelectBoxUserList(CommandMap commandMap) throws Exception {
		return commentService.commentSelectBoxUserList(commandMap);
	}
	
	
	@RequestMapping(value = "commentChartDetail.do")
	public ModelAndView commentChartDetail(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	//**************************************************************************
	// comment 현황 Method END
	//**************************************************************************
	
	/**
	 * 
	 * @메소드명	: popUpCommentExcel
	 * @날짜		: 2017. 7. 20.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *	
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentExcel.do")
	public ModelAndView popUpCommentExcel(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/comment/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpCommentReplyExcel
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentReplyExcel.do")
	public ModelAndView popUpCommentReplyExcel(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/comment/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpCommentExcelImport
	 * @날짜		: 2017. 7. 20.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentExcelImport.do")
	public ModelAndView popUpCommentExcelImport(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/comment/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpCommentReplyExcelImport
	 * @날짜		: 2017. 10. 13.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCommentReplyExcelImport.do")
	public ModelAndView popUpCommentReplyExcelImport(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/comment/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: sscAddExcelImportAction
	 * @날짜		: 2017. 7. 20.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param file
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "commentExcelImportAction.do")
	public void sscAddExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		commandMap.put("file", DecryptFile);
		
		List<Map<String, Object>> list = commentService.commentExcelImportAction(commandMap);
		
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}
	
	/**
	 * 
	 * @메소드명	: sscAddExcelImportAction
	 * @날짜		: 2017. 10. 13.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param file
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReplyExcelImportAction.do")
	public void commentReplyExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		commandMap.put("file", DecryptFile);
		
		List<Map<String, Object>> list = commentService.commentReplyExcelImportAction(commandMap);
		
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptNoSelectBoxDataList
	 * @날짜		: 2017. 7. 20.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReceiptNoSelectBoxDataList.do")
	public @ResponseBody String commentReceiptNoSelectBoxDataList(CommandMap commandMap) throws Exception {
		return commentService.commentReceiptNoSelectBoxDataList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentImportConfirmProc
	 * @날짜		: 2017. 7. 20.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentImportConfirmProc.do")
	public @ResponseBody Map<String, Object> commentImportConfirmProc(CommandMap commandMap) throws Exception {
		return commentService.commentImportConfirmProc(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: commentReplyImportConfirmProc
	 * @날짜		: 2017. 10. 16.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "commentReplyImportConfirmProc.do")
	public @ResponseBody Map<String, Object> commentReplyImportConfirmProc(CommandMap commandMap) throws Exception {
		return commentService.commentReplyImportConfirmProc(commandMap);
	}
	

}
