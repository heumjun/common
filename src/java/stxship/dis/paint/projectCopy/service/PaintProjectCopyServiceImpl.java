package stxship.dis.paint.projectCopy.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.paint.projectCopy.dao.PaintProjectCopyDAO;

/**
 * @파일명 : PaintProjectCopyServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  PaintProjectCopy 서비스
 *     </pre>
 */
@Service("paintProjectCopyService")
public class PaintProjectCopyServiceImpl extends CommonServiceImpl implements PaintProjectCopyService {

	@Resource(name = "paintProjectCopyDAO")
	private PaintProjectCopyDAO paintProjectCopyDAO;

	/**
	 * @메소드명 : saveProjectCopyConfirm
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 카피정보의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveProjectCopyConfirm(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> copyList = DisJsonUtil.toList(commandMap.get("chmResultList"));

		int result = 0;
		int nExist = 0;
		for (Map<String, Object> rowData : copyList) {
			rowData.put("from_project_no", commandMap.get("from_project_no"));
			rowData.put("from_revision", commandMap.get("from_revision"));
			rowData.put("to_project_no", commandMap.get("to_project_no"));
			rowData.put("to_revision", commandMap.get("to_revision"));
			// 1번째 BLOCK을 복사한다.
			if ("BLOCK".equals(rowData.get("gbn"))) {
				// 이미 등록된 데이터 인지 확인한다.
				nExist = paintProjectCopyDAO.selectExistToBlock(rowData);

				if (nExist > 0) {
					throw new DisException("common.message4", (String) rowData.get("gbn"));
				} else {
					result = paintProjectCopyDAO.insertCopyBlock(rowData);
					if (result == 0) {
						throw new DisException("common.default.fail", (String) rowData.get("gbn"));
					}
				}
			}
			// 2번째 PE을 복사한다.
			if ("PE".equals(rowData.get("gbn"))) {
				// 이미 등록된 데이터 인지 확인한다.
				nExist = paintProjectCopyDAO.selectExistToPE(rowData);

				if (nExist > 0) {
					throw new DisException("common.message4", (String) rowData.get("gbn"));
				} else {
					nExist = paintProjectCopyDAO.selectExistBlockFromToPE(rowData);
					if (nExist > 0) {
						throw new DisException("common.message7", new String[] { "PE", "BLOCK" });
					}
					result = paintProjectCopyDAO.insertCopyPE(rowData);
					if (result == 0) {
						throw new DisException("common.default.fail", (String) rowData.get("gbn"));
					}
				}
			}
			// 3번째 ZONE을 복사한다.
			if ("ZONE".equals(rowData.get("gbn"))) {
				// 이미 등록된 데이터 인지 확인한다.
				nExist = paintProjectCopyDAO.selectExistToZone(rowData);

				if (nExist > 0) {
					throw new DisException("common.message4", (String) rowData.get("gbn"));
				} else {
					nExist = paintProjectCopyDAO.selectExistAreaFromToZone(rowData);
					if (nExist > 0) {
						throw new DisException("common.message7", new String[] { "ZONE", "AREA" });
					}
					result = paintProjectCopyDAO.insertCopyZone(rowData);
					if (result == 0) {
						throw new DisException("common.default.fail", (String) rowData.get("gbn"));
					}
				}
			}
			// 4번째 PATTERN 복사한다.
			if ("PATTERN".equals(rowData.get("gbn"))) {
				// 이미 등록된 데이터 인지 확인한다.
				nExist = paintProjectCopyDAO.selectExistToPattern(rowData);

				if (nExist > 0) {
					throw new DisException("common.message4", (String) rowData.get("gbn"));
				} else {
					result = paintProjectCopyDAO.insertCopyPatternCode(rowData);
					result = paintProjectCopyDAO.insertCopyPatternItem(rowData);
					result = paintProjectCopyDAO.insertCopyPatternArea(rowData);
					if (result == 0) {
						throw new DisException("common.default.fail", (String) rowData.get("gbn"));
					}
				}
			}
			// 5번째 OUTFITTING 복사한다.
			if ("OUTFITTING".equals(rowData.get("gbn"))) {
				// 이미 등록된 데이터 인지 확인한다.
				nExist = paintProjectCopyDAO.selectExistToOutfitting(rowData);

				if (nExist > 0) {
					throw new DisException("common.message4", (String) rowData.get("gbn"));
				} else {
					result = paintProjectCopyDAO.insertCopyOutfitting(rowData);
					result = paintProjectCopyDAO.insertCopyOutfittingArea(rowData);
					/*if (result == 0) {
						throw new DisException("common.default.fail", (String) rowData.get("gbn"));
					}*/
				}
			}
			// 6번째 COSMETIC을 복사한다.
			if ("COSMETIC".equals(rowData.get("gbn"))) {
				// 이미 등록된 데이터 인지 확인한다.
				nExist = paintProjectCopyDAO.selectExistToCosmetic(rowData);

				if (nExist > 0) {
					throw new DisException("common.message4", (String) rowData.get("gbn"));
				} else {
					result = paintProjectCopyDAO.insertCopyCosmetic(rowData);
					result = paintProjectCopyDAO.insertCopyCosmeticArea(rowData);
					/*if (result == 0) {
						throw new DisException("common.default.fail", (String) rowData.get("gbn"));
					}*/
				}
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}
