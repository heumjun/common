package stxship.dis.ecr.ecrInterface.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.ecr.ecrInterface.service.EcrInterfaceService;

/**
 * @파일명 : EcrInterfaceController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 17.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 		ECR Interface Controller
 *     </pre>
 */
@Controller
public class EcrInterfaceController extends CommonController {
	@Resource(name = "ecrInterfaceService")
	private EcrInterfaceService ecrInterfaceService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 		ECR INTERFATE 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrInterface.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : ecrInterfaceList
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 		ECR INTER FACE 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrInterfaceList.do")
	public @ResponseBody Map<String, Object> ecrInterfaceList(CommandMap commandMap) {
		return ecrInterfaceService.getEcrInterfaceList(commandMap);
	}

	/** 
	 * @메소드명	: saveECRInterface01
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *		Interface un-completed I/F (ECR create)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveECRInterface01.do")
	public @ResponseBody Map<String, Object> saveECRInterface01(CommandMap commandMap) throws Exception {
		return ecrInterfaceService.saveECRInterface01(commandMap);
	}
	
	
	/** 
	 * @메소드명	: saveECRInterface02
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: BaekJaeHo
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveECRInterface02.do")
	public @ResponseBody Map<String, Object> saveECRInterface02(CommandMap commandMap) throws Exception {
		return ecrInterfaceService.saveECRInterface02(commandMap);
	}

}
