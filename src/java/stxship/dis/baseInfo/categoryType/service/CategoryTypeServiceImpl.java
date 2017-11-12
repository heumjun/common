package stxship.dis.baseInfo.categoryType.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.categoryType.dao.CategoryTypeDAO;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : CategoryTypeServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CategoryType의 서비스
 *     </pre>
 */
@Service("categoryTypeService")
public class CategoryTypeServiceImpl extends CommonServiceImpl implements CategoryTypeService {

	@Resource(name = "categoryTypeDAO")
	private CategoryTypeDAO categoryTypeDAO;

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatagoryType의 추가시에 Flex값을 추가 저장
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataInsert(Map<String, Object> rowData) {
		int insertResult = 0;
		// 기본 정보 저장이 성공한후에 처리
		if (super.gridDataInsert(rowData).equals(DisConstants.RESULT_SUCCESS)) {
			insertResult = categoryTypeDAO.insertFndFlexValues(rowData);
			if (insertResult != 0) {
				insertResult = categoryTypeDAO.insertFndFlexValuesTl(rowData);
			}
		}
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatagoryType의 변경시에 Flex값을 추가로 변경
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String gridDataUpdate(Map<String, Object> rowData) {
		int updateResult = 0;
		// 기본정보 변경이 성공한후에 추가 변경처리
		if (super.gridDataUpdate(rowData).equals(DisConstants.RESULT_SUCCESS)) {
			Object tempMap = categoryTypeDAO.selectFndFlexValues(rowData);
			if (tempMap != null) {
				rowData.put("flex_value_id", ((Map<String, Object>) tempMap).get("flex_value_id"));
				updateResult = categoryTypeDAO.updateFndFlexValues(rowData);
				if (updateResult != 0) {
					updateResult = categoryTypeDAO.updateFndFlexValuesTl(rowData);
				}
			}
		}
		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
}
