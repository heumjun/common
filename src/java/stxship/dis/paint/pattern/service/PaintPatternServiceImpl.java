package stxship.dis.paint.pattern.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.pattern.dao.PaintPatternDAO;

@Service("paintPatternService")
public class PaintPatternServiceImpl extends CommonServiceImpl implements PaintPatternService {

	@Resource(name = "paintPatternDAO")
	private PaintPatternDAO paintPatternDAO;

	@Override
	public ModelAndView searchPaintSeasonCodeList(CommandMap commandMap) {

		ModelAndView mav = new ModelAndView();

		if ("seasonCode".equals(commandMap.get("listCode"))) {
			commandMap.put("addCode", "ALL");
			commandMap.put("sd_type", "PAINT_SEASON");
		}

		List<Map<String, Object>> codeList = paintPatternDAO.selectPaintCodeList(commandMap.getMap());
		mav.addObject("selectBoxList", codeList);
		mav.addObject("listCode", commandMap.get("listCode"));

		return mav;
	}

	public boolean isDeleteExist(List<Map<String, Object>> list, Map<String, Object> rowData) {

		String sPaintCount = (String) rowData.get("paint_count");
		String sSeasonCode = (String) rowData.get("season_code");

		boolean isExist = false;

		for (Map<String, Object> checkRow : list) {
			if ("D".equals(checkRow.get("oper"))) {
				if (sPaintCount.equals(checkRow.get("paint_count"))
						&& sSeasonCode.equals(checkRow.get("season_code"))) {
					isExist = true;
					break;
				}
			}
		}

		return isExist;
	}

	public boolean isDeleteExist2(List<Map<String, Object>> list, Map<String, Object> rowData) {

		String sAreaCode = (String) rowData.get("area_code");

		boolean isExist = false;

		for (Map<String, Object> checkRow : list) {
			if ("D".equals(checkRow.get("oper"))) {
				if (sAreaCode.equals(checkRow.get("area_code"))) {
					isExist = true;
					break;
				}
			}
		}

		return isExist;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintPattern(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> paintCodeList = DisJsonUtil.toList(commandMap.get("paintCodeList"));
		List<Map<String, Object>> areaCodeList = DisJsonUtil.toList(commandMap.get("areaCodeList"));

		int result = 0;

		// pattern code 중복체크
		if ("I".equals(commandMap.get("mod"))) {

			int nExist = paintPatternDAO.selectExistPatternCodeCnt(commandMap.getMap());

			if (nExist > 0) {
				throw new DisException(DisMessageUtil.getMessage("common.message4","Pattern Code"));
			}

		}

		// paint Item 중복 체크
		for (Map<String, Object> rowData : paintCodeList) {
			rowData.put("project_no", commandMap.get("project_no"));
			rowData.put("revision", commandMap.get("revision"));
			rowData.put("pattern_code", commandMap.get("pattern_code"));

			if ("I".equals(rowData.get("oper")) || "U".equals(rowData.get("oper"))) {
				int nExist = paintPatternDAO.selectExistPatternPaintCodeCnt(rowData);

				if ("U".equals(rowData.get("oper"))) {
					if ("Y".equals(paintPatternDAO.selectIsItemModified(rowData)))
						nExist = 0;
				}

				if (!isDeleteExist(paintCodeList, rowData) && nExist > 0) {
					String paramMsg1 = (String) rowData.get("paint_count");
					String paramMsg2 = (String) rowData.get("season_code");
					throw new DisException(DisMessageUtil.getMessage("paint.message8", new String[]{paramMsg1, paramMsg2}));
				}

				nExist = paintPatternDAO.selectExistItemCodeCnt(rowData);

				if (nExist == 0) {
					throw new DisException(DisMessageUtil.getMessage("paint.message10","PAINT CODE"));
				}

				nExist = paintPatternDAO.selectExistStageCodeCnt(rowData);

				if (nExist == 0) {
					throw new DisException(DisMessageUtil.getMessage("paint.message10","STAGE CODE"));
				}
			}

		}

		// paint Area 중복 체크
		for (Map<String, Object> rowData : areaCodeList) {
			rowData.put("project_no", commandMap.get("project_no"));
			rowData.put("revision", commandMap.get("revision"));
			rowData.put("pattern_code", commandMap.get("pattern_code"));

			if ("I".equals(rowData.get("oper")) || "U".equals(rowData.get("oper"))) {

				int nExist = paintPatternDAO.selectExistPatternAreaCodeCnt(rowData);

				if ("U".equals(rowData.get("oper"))) {
					if ("Y".equals(paintPatternDAO.selectIsAreaModified(rowData)))
						nExist = 0;
				}

				if (!isDeleteExist2(paintCodeList, rowData) && nExist > 0) {
					String paramMsg1 = (String) rowData.get("pattern_code");
					String paramMsg2 = (String) rowData.get("area_code");
	
					throw new DisException(DisMessageUtil.getMessage("paint.message9", new String[]{paramMsg1, paramMsg2}));				

				}

				nExist = paintPatternDAO.selectExistAreaCodeCnt(rowData);

				if (nExist == 0) {
					throw new DisException(DisMessageUtil.getMessage("paint.message3", (String)rowData.get("area_code")));
				}
			}

		}

		if ("I".equals(commandMap.get("mod"))) {
			result = paintPatternDAO.insertPaintPatternCode(commandMap.getMap());
		}

		for (Map<String, Object> rowData : paintCodeList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if ("D".equals(rowData.get("oper"))) {
				result = paintPatternDAO.deletePaintPatternItem(rowData);
			}
		}

		// 데이터 입력
		for (Map<String, Object> rowData : paintCodeList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if ("I".equals(rowData.get("oper"))) {
				result = paintPatternDAO.insertPaintPatternItem(rowData);
			} else if ("U".equals(rowData.get("oper"))) {
				result = paintPatternDAO.updatePaintPatternItem(rowData);
			}
		}

		// 동절기 모두 지운다.
		paintPatternDAO.deletePaintPatternWinterItem(commandMap.getMap());

		// 하절기와 동일하게 동절기를 만든다.
		paintPatternDAO.insertPaintPatternWinterItem(commandMap.getMap());

		for (Map<String, Object> rowData : areaCodeList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if ("D".equals(rowData.get("oper"))) {
				result = paintPatternDAO.deletePaintPatternArea(rowData);
			}
		}

		// 데이터 입력
		for (Map<String, Object> rowData : areaCodeList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if ("I".equals(rowData.get("oper"))) {
				result = paintPatternDAO.insertPaintPatternArea(rowData);
			} else if ("U".equals(rowData.get("oper"))) {
				result = paintPatternDAO.updatePaintPatternArea(rowData);
			}
		}

		if (!"I".equals(commandMap.get("mod"))) {
			int nItemCnt = paintPatternDAO.selectCountPatternItem(commandMap.getMap());

			int nAreaCnt = paintPatternDAO.selectCountPatternArea(commandMap.getMap());

			if (nItemCnt == 0 && nAreaCnt == 0)
				paintPatternDAO.deletePaintPattern(commandMap.getMap());
		}

		if (result == 0) {
			throw new DisException();
		}
		// 결과값에 따른 메시지를 담아 전송
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> deletePatternList(CommandMap commandMap) throws Exception {
		// TODO Auto-generated method stub
		
		List<Map<String, Object>> patternCodeList = DisJsonUtil.toList(commandMap.get("patternCodeList"));
		List<Map<String, Object>> deleteList      = new ArrayList<Map<String, Object>> ();
	
			
		//데이터 입력
		String sPattern  = null;
		
		for(Map<String, Object> rowData : patternCodeList) {	
		
			if ( (sPattern == null || !sPattern.equals(rowData.get("pattern_code"))) ) {
				String defineFlag = (String) paintPatternDAO.selectPatternDefineFlag(rowData);
			
				if ("N".equals(defineFlag)) {
					deleteList.add(rowData);
				} else if ("Y".equals(defineFlag)) {

					throw new DisException(DisMessageUtil.getMessage("common.message10", (String)rowData.get("pattern_code")));
					
				} else {
					//deleteList.add(rowData);
				}
				
				
				sPattern  = (String) rowData.get("pattern_code");
			}
		}
		
		for (Map<String, Object> deleteRow : deleteList) {
			
			// Pattern 헤더 삭제
			paintPatternDAO.deletePaintPatternCode(deleteRow);
			
			// Pattern Item 삭제
			paintPatternDAO.deletePaintPatternItemList(deleteRow);
			
			// Pattern Area 삭제
			paintPatternDAO.deletePaintPatternAreaList(deleteRow);
				 
		}
		
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		resultMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.message11", String.valueOf(deleteList.size())));		
		
		return resultMap;

	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePatternConfirm(CommandMap commandMap) throws Exception {

		//데이터 입력
		String sPattern = null;
		int	   nConfirm = 0;
		if ( "Y".equals(commandMap.get("chkAll")) ) {

			List<Map<String, Object>> allPatternList = paintPatternDAO.selectAllPatternList(commandMap.getMap());
			
			for(Map<String, Object> rowData : allPatternList) {	
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				if ( (sPattern == null || !sPattern.equals(rowData.get("pattern_code"))) && (!"Y".equals(rowData.get("define_flag")))) {
					
					// 확정 합니다.
					patternConfirm(rowData);
								
					paintPatternDAO.updatePatternCodeConfirm(rowData);
					sPattern = (String) rowData.get("pattern_code");
					nConfirm = nConfirm + 1;
				}
			}	
			
		} else {
			
			List<Map<String, Object>> patternCodeList = DisJsonUtil.toList(commandMap.get("patternCodeList"));
			
			for(Map<String, Object> rowData : patternCodeList) {	
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				if ( (sPattern == null || !sPattern.equals(rowData.get("pattern_code"))) && (!"Y".equals(rowData.get("define_flag")))) {
					
					// 확정 합니다.
					patternConfirm(rowData);
									
					paintPatternDAO.updatePatternCodeConfirm(rowData);
					sPattern = (String) rowData.get("pattern_code");
					nConfirm = nConfirm + 1;
				}
			}
		}
	
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		resultMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.message8", String.valueOf(nConfirm)));	
		
		return resultMap;

	}
	
	private void patternConfirm(Map<String, Object> rowData) {
		
		// 확정한 데이터가 존재하면 데이터 삭제한다.
		if (paintPatternDAO.selectExistPatternScheme(rowData) > 0) {
			paintPatternDAO.deletePatternScheme(rowData);
		}
		
		// Patten의 Item 조회
		List<Map<String, Object>> itemList = paintPatternDAO.searchPatternPaintCodeTsr(rowData);
		
		// Pattern의 Area 조회
		List<Map<String, Object>> areaList = paintPatternDAO.searchPatternPaintArea(rowData);
							
		if (itemList != null && areaList != null) {
			
			for(Map<String, Object> itemRow : itemList) {
				
				for(Map<String, Object> areaRow : areaList) {
					
					//Paint Code의 paint_stage,paint_tsr,pre_tsr,post_tsr 설정
					areaRow.put("paint_stage",  itemRow.get("paint_stage"));
					areaRow.put("paint_tsr", 	itemRow.get("paint_tsr"));
					areaRow.put("pre_tsr", 		itemRow.get("pre_tsr"));
					areaRow.put("post_tsr", 	itemRow.get("post_tsr"));
					areaRow.put("zone_code", 	areaRow.get("zone_code") 	== null ? "" : areaRow.get("zone_code"));

					List<Map<String, Object>> blockList =  paintPatternDAO.selectBlockCodeFromAreaCode(areaRow);
					
					if ( blockList != null ) {
						
						for(Map<String, Object> blockRow : blockList) {
							blockRow.put(DisConstants.SET_DB_LOGIN_ID, rowData.get(DisConstants.SET_DB_LOGIN_ID));
							blockRow.put("season_code", itemRow.get("season_code"));
							blockRow.put("paint_count", itemRow.get("paint_count"));
							blockRow.put("paint_item",  itemRow.get("paint_item"));
							blockRow.put("paint_dft",   itemRow.get("paint_dft"));
							blockRow.put("paint_stage", itemRow.get("paint_stage"));
							blockRow.put("paint_svr",   itemRow.get("paint_svr"));
							blockRow.put("pre_loss",    itemRow.get("pre_loss"));
							blockRow.put("post_loss",   itemRow.get("post_loss"));
							blockRow.put("zone_code",   blockRow.get("zone_code") 	== null ? "" : blockRow.get("zone_code"));
							blockRow.put("pe_code",   	blockRow.get("pe_code") 	== null ? "" : blockRow.get("pe_code"));
							blockRow.put("pre_pe_code", blockRow.get("pre_pe_code") == null ? "" : blockRow.get("pre_pe_code"));

							paintPatternDAO.insertPaintPatternScheme(blockRow);
						}
					}
				}
			}
		}
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePatternUndefine(CommandMap commandMap) throws Exception {
		//데이터 입력
		String sPattern  = null;
		int    nUndefine = 0;
		
		if ( "Y".equals(commandMap.get("chkAll")))
		{
			List<Map<String, Object>> allPatternList = paintPatternDAO.selectAllPatternList(commandMap.getMap());
			
			for(Map<String, Object> rowData : allPatternList) {
				
				if ( (sPattern == null || !sPattern.equals(rowData.get("pattern_code"))) && ("Y".equals(rowData.get("define_flag"))) ) {
					
					//확정 해제 합니다.
					patternUndefine(rowData); 
					
					sPattern  = (String) rowData.get("pattern_code");
					nUndefine = nUndefine + 1;
				}	
			}
			
		} else {
			
			List<Map<String, Object>> 	patternList 	= DisJsonUtil.toList(commandMap.get("patternCodeList"));
			
			for(Map<String, Object> rowData : patternList) {	
				
				if ( (sPattern == null || !sPattern.equals(rowData.get("pattern_code"))) && ("Y".equals(rowData.get("define_flag"))) ) {
					
					//확정 해제 합니다.
					patternUndefine(rowData);
					
					sPattern  = (String) rowData.get("pattern_code");
					nUndefine = nUndefine + 1;
				}
			
			}
		}
		
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		resultMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.message9", String.valueOf(nUndefine)));	
		
		return resultMap;
	}	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	private void patternUndefine(Map<String, Object> rowData) {
		
		paintPatternDAO.deletePatternScheme(rowData);
		paintPatternDAO.updatePatternCodeUndefine(rowData);
	}

	@Override
	public View patternExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		String sProjectRevision = commandMap.get("project_no")+"_"+commandMap.get("revision");
		
		List<String> excelName = new ArrayList<String>();
		excelName.add(sProjectRevision+"_Pattern1");
		excelName.add(sProjectRevision+"_Pattern2");
		
		modelMap.put("excelName",  excelName);
		
		List<String> colName = new ArrayList<String>();
		colName.add("NAME");
		colName.add("AREA CODE");
		colName.add("AREA DESC");
		colName.add("회차");
		colName.add("PAINT CODE");
		colName.add("PAINT DESC");
		
		colName.add("SEASON");
		colName.add("DFT");
		colName.add("STAGE");
		colName.add("SVR");
		colName.add("선행 LOSS");
		colName.add("후행 LOSS");
		
		modelMap.put(sProjectRevision+"_Pattern1_colName",    colName);				
				
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();
		
		List<Map<String, Object>> 	   list	  = paintPatternDAO.selectPatternExport(commandMap.getMap());		

		for(Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object>   row   = new ArrayList<Object>();
			
			row.add( rowData.get("pattern_code"));
			row.add( rowData.get("area_code"));
			row.add( rowData.get("area_desc"));
			row.add( rowData.get("paint_count"));
			row.add( rowData.get("paint_item"));
			row.add( rowData.get("item_desc"));
			
			row.add( rowData.get("season_code"));
			row.add( rowData.get("paint_dft"));
			row.add( rowData.get("paint_stage"));
			row.add( rowData.get("paint_svr"));
			row.add( rowData.get("pre_loss"));
			row.add( rowData.get("post_loss"));
			
			colValue.add(row);
		}
		
		modelMap.put(sProjectRevision+"_Pattern1_colValue",   colValue);
		
		List<String> colName2 = new ArrayList<String>();
		colName2.add("NAME");
		colName2.add("AREA CODE");
		colName2.add("AREA DESC");
		colName2.add("LOSS CODE");
		colName2.add("회차");
		colName2.add("PAINT CODE");
		colName2.add("PAINT DESC");
		
		colName2.add("SEASON");
		colName2.add("DFT");
		colName2.add("STAGE");
		colName2.add("SVR");
		colName2.add("선행 LOSS");
		colName2.add("후행 LOSS");
		
		modelMap.put(sProjectRevision+"_Pattern2_colName",    colName2);		

		// COLVALUE 설정
		List<List<Object>> colValue2 = new ArrayList<List<Object>>();		
		list	  = paintPatternDAO.selectPatternExport2(commandMap.getMap());
		
		String sName = null;
		
		for(Map<String, Object> rowData : list) {
			
			if (sName != null && !sName.equals(rowData.get("pattern_code"))) {
				
				List<Object>   emptyRow   = new ArrayList<Object>();
				
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				emptyRow.add( "" );
				
				colValue2.add(emptyRow);
		
			}
			
			// Map을 리스트로 변경
			List<Object>   row   = new ArrayList<Object>();
					
			row.add( rowData.get("pattern_code"));
			row.add( rowData.get("area_code"));
			row.add( rowData.get("area_desc"));
			row.add( rowData.get("loss_code"));
			row.add( rowData.get("paint_count"));
			row.add( rowData.get("paint_item"));
			row.add( rowData.get("item_desc"));
			
			row.add( rowData.get("season_code"));
			row.add( rowData.get("paint_dft"));
			row.add( rowData.get("paint_stage"));
			row.add( rowData.get("paint_svr"));
			row.add( rowData.get("pre_loss"));
			row.add( rowData.get("post_loss"));
					
			colValue2.add(row);
			
			// Pattern 저장
			sName = (String) rowData.get("pattern_code");	
		}
		
		modelMap.put(sProjectRevision+"_Pattern2_colValue",   colValue2);
		
		
		return new GenericExcelView();
	}	
	
}
