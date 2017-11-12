package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.baseInfo.catalogMgnt.dao.HighRankCatalogDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : HighRankCatalogServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 상위Catalog가 선택되어졌을때 사용되는 서비스
 *     </pre>
 */
@Service("highRankCatalogService")
public class HighRankCatalogServiceImpl extends CommonServiceImpl implements HighRankCatalogService {

	@Resource(name = "highRankCatalogDAO")
	private HighRankCatalogDAO highRankCatalogDAO;

	/**
	 * @메소드명 : saveHighRankCatalog
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
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveHighRankCatalog(CommandMap commandMap) throws Exception {
		int result = 0;
		List<Map<String, Object>> selectedCatalogList = DisJsonUtil.toList(commandMap.get("selectedCatalogList"));

		for (Map<String, Object> rowData : selectedCatalogList) {
			rowData.put("catalog_code", commandMap.get("catalog_code"));
			int cnt = (Integer) highRankCatalogDAO.selectExistCatalogValueAssy(rowData);
			if (cnt > 0) {
				result = highRankCatalogDAO.updateCatalogValueAssy(rowData);
			} else {
				if ("Y".equals(rowData.get("enable_flag"))) {
					result = highRankCatalogDAO.insertCatalogValueAssy(rowData);
				}
			}
		}
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

}
