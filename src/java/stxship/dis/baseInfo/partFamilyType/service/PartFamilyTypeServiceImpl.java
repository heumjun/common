package stxship.dis.baseInfo.partFamilyType.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.partFamilyType.dao.PartFamilyTypeDAO;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : PartFamilyTypeServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Part Family Type 메뉴 선택시 사용되는 서비스
 *     </pre>
 */
@Service("partFamilyTypeService")
public class PartFamilyTypeServiceImpl extends CommonServiceImpl implements PartFamilyTypeService {

	@Resource(name = "partFamilyTypeDAO")
	private PartFamilyTypeDAO partFamilyTypeDAO;

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * part Family Type를 저장후에 Item 채변 규칙 테이블에 저장
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataInsert(Map<String, Object> rowData) {
		int insertResult = 0;
		// 기본정보 저장이 성공한 후에 처리
		if (super.gridDataInsert(rowData).equals(DisConstants.RESULT_SUCCESS)) {
			String[] itemValueList = rowData.get("item_rule_desc").toString().split(",");
			// 데이터 입력
			Map<String, Object> itemValue = new HashMap<String, Object>();
			itemValue.put("part_family_code", rowData.get("part_family_code"));
			itemValue.put("category_type", rowData.get("category_type"));
			insertResult = partFamilyTypeDAO.deleteItemValueRule(itemValue);

			for (int i = 0; i < itemValueList.length; i++) {
				if (!"".equals(itemValueList[i])) {
					itemValue.put("item_rule_desc", itemValueList[i]);
					insertResult = partFamilyTypeDAO.insertItemValueRule(itemValue);
					if (insertResult == 0) {
						break;
					}
				}
			}
		}
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	@Override
	public String gridDataUpdate(Map<String, Object> rowData) {
		int updateResult = 0;
		if (super.gridDataUpdate(rowData).equals(DisConstants.RESULT_SUCCESS)) {
			String[] itemValueList = rowData.get("item_rule_desc").toString().split(",");
			// 데이터 입력
			Map<String, Object> itemValue = new HashMap<String, Object>();
			itemValue.put("part_family_code", rowData.get("o_part_family_code"));
			itemValue.put("category_type", rowData.get("o_category_type"));
			updateResult = partFamilyTypeDAO.deleteItemValueRule(itemValue);

			for (int i = 0; i < itemValueList.length; i++) {
				if (!"".equals(itemValueList[i])) {
					itemValue.put("item_rule_desc", itemValueList[i]);
					updateResult = partFamilyTypeDAO.insertItemValueRule(itemValue);
					if (updateResult == 0) {
						break;
					}
				}
			}
		}
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	@Override
	public String gridDataDelete(Map<String, Object> rowData) {
		int deleteResult = 0;
		if (super.gridDataUpdate(rowData).equals(DisConstants.RESULT_SUCCESS)) {
			// 데이터 입력
			Map<String, Object> itemValue = new HashMap<String, Object>();
			itemValue.put("part_family_code", rowData.get("o_part_family_code"));
			itemValue.put("category_type", rowData.get("o_category_type"));
			deleteResult = partFamilyTypeDAO.deleteItemValueRule(itemValue);
		}
		if (deleteResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
}
