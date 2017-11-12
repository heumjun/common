package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.baseInfo.catalogMgnt.dao.ItemDescChangeDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : ItemDescChangeServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 Text Fileter가 선택되어졌을때 사용되는 서비스
 *     </pre>
 */
@Service("itemDescChangeService")
public class ItemDescChangeServiceImpl extends CommonServiceImpl implements ItemDescChangeService {

	@Resource(name = "itemDescChangeDAO")
	private ItemDescChangeDAO itemDescChangeDAO;

	/**
	 * @메소드명 : saveCommonAttributeName
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 Item 속성 일괄반영 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveCommonAttributeName(CommandMap commandMap) throws Exception {
		int insertResult = itemDescChangeDAO.insertCommonAttributeName();
		if (insertResult == 0) {
			throw new DisException("일괄반영될 Catalog Item속성이 없습니다.");
		} else {
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		}

	}

	/**
	 * @메소드명 : saveChangeCatalogItemAttr
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Catalog Item 속성 일괄 반영을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveChangeCatalogItemAttr(CommandMap commandMap) throws Exception {
		int result = 0;
		List<Map<String, Object>> changeCatalogItemAttrList = DisJsonUtil
				.toList(commandMap.get("changeCatalogItemAttrList"));
		for (Map<String, Object> rowData : changeCatalogItemAttrList) {
			if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))
					&& !"".equals(rowData.get("edit_attribute_name"))) {
				// Catalog His 리비젼번호를 구한다.
				String sRevNo = itemDescChangeDAO.selectCatalogAttrHisRevNo(rowData);
				rowData.put("revision_no", sRevNo);

				// Catalog His에 저장한다.
				result = itemDescChangeDAO.insertCatalogAttributeNameHis(rowData);

				// attributeName변경 한다.
				result = itemDescChangeDAO.updateCatalogAttributeName(rowData);

				String sCatalogGroupId = itemDescChangeDAO.selectItemCatalogGroupId(rowData);

				rowData.put("v_item_catalog_group_id", sCatalogGroupId == null ? "" : sCatalogGroupId);

				result = itemDescChangeDAO.updateDescriptiveElements2(rowData);

			}
		}
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

}
