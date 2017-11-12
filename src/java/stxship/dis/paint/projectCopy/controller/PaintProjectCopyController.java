package stxship.dis.paint.projectCopy.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.projectCopy.service.PaintProjectCopyService;

/**
 * @파일명 : PaintProjectCopyController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  PaintProjectCopy 컨트롤러
 *     </pre>
 */
@Controller
public class PaintProjectCopyController extends CommonController {
	@Resource(name = "paintProjectCopyService")
	private PaintProjectCopyService paintProjectCopyService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * paintProjectCopy 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintProjectCopy.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : searchFromCopyListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 카피 원본 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchFromCopyList.do")
	public @ResponseBody Map<String, Object> searchFromCopyListAction(CommandMap commandMap) {
		return paintProjectCopyService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : searchToCopyListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 카피 대상 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchToCopyList.do")
	public @ResponseBody Map<String, Object> searchToCopyListAction(CommandMap commandMap) {
		return paintProjectCopyService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveProjectCopyConfirmAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 카피된 정보의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveProjectCopyConfirm.do")
	public @ResponseBody Map<String, String> saveProjectCopyConfirmAction(CommandMap commandMap) throws Exception {
		return paintProjectCopyService.saveProjectCopyConfirm(commandMap);
	}
}
