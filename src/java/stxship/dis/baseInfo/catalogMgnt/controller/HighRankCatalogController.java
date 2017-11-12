package stxship.dis.baseInfo.catalogMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.catalogMgnt.service.HighRankCatalogService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : HighRankCatalogController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 2.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 상위 Catalog 버튼이 선택되어졌을때 사용되는 액션
 *     </pre>
 */
@Controller
public class HighRankCatalogController extends CommonController {

	@Resource(name = "highRankCatalogService")
	private HighRankCatalogService highRankCatalogService;

	/**
	 * @메소드명 : popUpCatalogHighRankCatalogAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상위 Catalog 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogHighRankCatalog.do")
	public ModelAndView popUpCatalogHighRankCatalogAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : selectHighRankCatalogListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상위 Catalog 리스트 정보 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoHighRankCatalogList.do")
	public @ResponseBody Map<String, Object> selectHighRankCatalogListAction(CommandMap commandMap) {
		return highRankCatalogService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveHighRankCatalogAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상위 Catalog에서 저장을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveHighRankCatalog.do")
	public @ResponseBody Map<String, String> saveHighRankCatalogAction(CommandMap commandMap) throws Exception {
		return highRankCatalogService.saveHighRankCatalog(commandMap);
	}
}
