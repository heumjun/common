package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.baseInfo.catalogMgnt.dao.TechnicalSpecrDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : TechnicalSpecServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 비용성코드 생성이 선택되어졌을때 사용되는 서비스
 *     </pre>
 */
@Service("technicalSpecService")
public class TechnicalSpecServiceImpl extends CommonServiceImpl implements TechnicalSpecService {

	@Resource(name = "technicalSpecrDAO")
	private TechnicalSpecrDAO technicalSpecrDAO;

	/**
	 * @메소드명 : saveTechnicalSpec
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 비용성 코드 생성을 생성했을때 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveTechnicalSpec(CommandMap commandMap) throws Exception {
		Map<String, Object> param = technicalSpecrDAO.selectTechnicalSpec(commandMap.getMap());
		if (param == null) {

			param = new HashMap<String, Object>();

			param.put("org_code", "");
			param.put("org_name", "");
			param.put("item_code", "");
			param.put("item_description", "");
			param.put("template_name", "");
		}

		// item 자재단위
		String sUomDescription = technicalSpecrDAO.selectUnitOfMeasure(commandMap.getMap());
		param.put("uom_description", sUomDescription == null ? "" : sUomDescription);

		// Catalog His 리비젼번호를 구한다.
		param.put("user_id", "1003");

		String sUserName = technicalSpecrDAO.selectUserName(param);
		param.put("emp_no", sUserName == null ? "" : sUserName);

		// Catalog His 리비젼번호를 구한다.
		String sExist = technicalSpecrDAO.selectExistSystemItems(param);

		param.put("catalog_code", commandMap.get("catalog_code"));
		param.put("category_code", commandMap.get("category_code"));

		int result = 0;
		if (sExist == null || !DisConstants.Y.equals(sExist)) {
			result = technicalSpecrDAO.procedurePlmItemInterface(param);
		} else {
			throw new DisException(DisMessageUtil.getMessage("common.default.duplication"));
		}
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}
