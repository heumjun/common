package stxship.dis.paint.loss.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.loss.dao.PaintLossDAO;

/**
 * @파일명 : PaintLossServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint Loss 서비스
 *     </pre>
 */
@Service("paintLossService")
public class PaintLossServiceImpl extends CommonServiceImpl implements PaintLossService {

	@Resource(name = "paintLossDAO")
	private PaintLossDAO paintLossDAO;

	/**
	 * @메소드명 : savePaintLoss
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss 정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintLoss(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> lossList = DisJsonUtil.toList(commandMap.get("lossList"));
		int result = 0;
		// 순번이 없을 경우 max 채번
		if ("".equals(commandMap.get("orderSeq"))) {
			commandMap.put("orderSeq", paintLossDAO.selectMaxOrderSeq());
		} else {
			String sLossCdoe = paintLossDAO.selectExistOrderSeq(commandMap.getMap());

			if (DisConstants.UPDATE.equals(commandMap.get("mod")) && sLossCdoe != null) {
				if (sLossCdoe.equals(commandMap.get("lossCode"))) {
					sLossCdoe = null;
				}
			}
			if (sLossCdoe != null) {
				throw new DisException("common.message4", "ORDER");
			}
		}

		// 신규 등록인 경우 Loss Code가 등록되어있는지 확인
		if (DisConstants.INSERT.equals(commandMap.get("mod"))) {
			int nExist = paintLossDAO.selectExistLossCodeCnt(commandMap.getMap());

			if (nExist > 0) {
				throw new DisException("common.message4", "Loss Code");
			}
		} else if (DisConstants.UPDATE.equals(commandMap.get("mod"))) {
			result = paintLossDAO.updatePaintLossDesc(commandMap.getMap());
			if (result == 0) {
				throw new DisException("구획명 변경이 실패했습니다.");
			}
		}

		for (Map<String, Object> rowData : lossList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("loss_code", commandMap.get("lossCode"));
			rowData.put("loss_desc", commandMap.get("lossDesc"));
			rowData.put("order_seq", commandMap.get("orderSeq"));

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// 중복 체크
				int nExist = paintLossDAO.selectExistLossSetPaintCnt(rowData);
				if (nExist > 0) {
					throw new DisException("common.message1", new Object[] { rowData.get("loss_code"),
							rowData.get("set_name"), rowData.get("paint_count") });
				}
				result = paintLossDAO.insertPaintLoss(rowData);
				if (result == 0) {
					throw new DisException("PaintLoss 등록에 실패했습니다.");
				}
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = paintLossDAO.updatePaintLoss(rowData);
				if (result == 0) {
					throw new DisException("PaintLoss 수정에 실패했습니다.");
				}
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = paintLossDAO.deletePaintLoss(rowData);
				if (result == 0) {
					throw new DisException("PaintLoss 삭제가 실패했습니다.");
				}
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : lossExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss 정보를 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View lossExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Order");
		colName.add("Loss Code");
		colName.add("구획명");
		colName.add("Set");
		colName.add("Count");
		colName.add("선행Loss");
		colName.add("후행Loss");
		colName.add("선행(%)");
		colName.add("선행(%)");
		colName.add("도료 TYPE");
		colName.add("Stage");
		colName.add("Remark");

		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = paintLossDAO.selectList("infoLossExportList.list", commandMap.getMap());

		String lossCode = "", setName = "";
		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();

			if (!lossCode.equals(rowData.get("loss_code"))) {
				row.add(rowData.get("order_seq"));
				row.add(rowData.get("loss_code"));
				row.add(rowData.get("loss_desc"));
			} else {
				row.add("");
				row.add("");
				row.add("");
			}

			if (!lossCode.equals(rowData.get("loss_code")) || !setName.equals(rowData.get("set_name"))) {
				row.add(rowData.get("set_name"));
			} else {
				row.add("");
			}

			row.add(rowData.get("paint_count"));
			row.add(rowData.get("pre_loss"));
			row.add(rowData.get("post_loss"));
			row.add(rowData.get("pre_loss_rate"));
			row.add(rowData.get("post_loss_rate"));
			row.add(rowData.get("paint_type"));
			row.add(rowData.get("stage_desc"));

			if (!lossCode.equals(rowData.get("loss_code"))) {
				row.add(rowData.get("remark"));
			} else {
				row.add("");
			}

			colValue.add(row);

			lossCode = (String) rowData.get("loss_code");
			setName = (String) rowData.get("set_name");
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);

		modelMap.put("excelName", "LossCode_" + dateToday);

		modelMap.put("colName", colName);

		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

}
