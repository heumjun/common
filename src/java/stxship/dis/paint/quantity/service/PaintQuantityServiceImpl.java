package stxship.dis.paint.quantity.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.common.dao.PaintCommonDAO;
import stxship.dis.paint.quantity.dao.PaintQuantityDAO;

@Service("paintQuantityService")
public class PaintQuantityServiceImpl extends CommonServiceImpl implements PaintQuantityService {

	@Resource(name = "paintQuantityDAO")
	private PaintQuantityDAO paintQuantityDAO;
	
	@Resource(name = "paintCommonDAO")
	private PaintCommonDAO paintCommonDAO;	

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, String> savePaintQuantity(CommandMap commandMap) throws Exception {
		
		commandMap.put("update_define_flag",  "Y");
		commandMap.put("current_define_flag", "N");
		
		// Quantity 확정 수행
		if (null != commandMap.get("chkBlock") && "Y".equals(commandMap.get("chkBlock"))) {			
			paintQuantityDAO.updatePaintQuantityBlockDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkPE") && "Y".equals(commandMap.get("chkPE"))) {			
			paintQuantityDAO.updatePaintQuantityPEDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkPrePE") && "Y".equals(commandMap.get("chkPrePE"))) {
			paintQuantityDAO.updatePaintQuantityPrePEDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkDock") && "Y".equals(commandMap.get("chkDock"))) {
			paintQuantityDAO.updatePaintQuantityHullDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkQuay") && "Y".equals(commandMap.get("chkQuay"))) {
			paintQuantityDAO.updatePaintQuantityQuayDefineFlag(commandMap.getMap());
		}			
		
		
		// BLOCK 별 동하절기 물량 중복 확정 체크
		List<Map<String, Object>> blockList = paintQuantityDAO.selectBlockSeasonCodeCnt(commandMap.getMap());
		
		
		String  sBlock	= "";
		boolean isError = false;
		int     nBlock	= 0;			
		
		for(Map<String, Object> blockRow : blockList) {
					
			isError = false;
			
			if (!isError && null != commandMap.get("chkBlock") && "Y".equals(commandMap.get("chkBlock"))) {
				
				if ( 0 < ((BigDecimal) blockRow.get("cnt_season_blk")).doubleValue()) {
					isError = true;
				}					
			}
			
			if (!isError && null != commandMap.get("chkPE") && "Y".equals(commandMap.get("chkPE"))) {
				if ( 0 < ((BigDecimal) blockRow.get("cnt_season_pe")).doubleValue()) {
					isError = true;
				}
			}
			
			if (!isError && null != commandMap.get("chkPrePE") && "Y".equals(commandMap.get("chkPrePE"))) {
				if ( 0 < ((BigDecimal) blockRow.get("cnt_season_pre_pe")).doubleValue()) {
					isError = true;
				}
			}
			
			if (!isError && null != commandMap.get("chkDock") && "Y".equals(commandMap.get("chkDock"))) {
				if ( 0 < ((BigDecimal) blockRow.get("cnt_season_hull")).doubleValue()) {
					isError = true;
				}
			}
			
			if (!isError && null != commandMap.get("chkQuay") && "Y".equals(commandMap.get("chkQuay"))) {
				if ( 0 < ((BigDecimal) blockRow.get("cnt_season_quay")).doubleValue()) {
					isError = true;
				}
			}
			
			if (isError) {
				
				nBlock++;
					
				
				if ( (nBlock % 6) == 1 ) {
					sBlock += (String) blockRow.get("BLOCK_CODE");
				} else {
					sBlock += "," + (String) blockRow.get("BLOCK_CODE");
				}
				
				if ( (nBlock % 6) == 0 ) {
					sBlock += "\n";
				} 
		
			}
		}
		
		if ( (nBlock % 6) != 0 ) {
			sBlock += "\n";
		}
		
		if (nBlock > 0) {
			// 동하절기 물량 확정 중복일 경우- 중복 BLOCK 메시지 표시,  Exception 발생시켜 update를 rollback 시킴				
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();   // rollback
			throw new DisException(DisMessageUtil.getMessage("paint.message23", sBlock));
		}
		
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, String> undefinePaintQuantity(CommandMap commandMap) throws Exception {
		
		commandMap.put("update_define_flag",  "N");
		commandMap.put("current_define_flag", "Y");
		
		if (null != commandMap.get("chkBlock") && "Y".equals(commandMap.get("chkBlock"))) {
			paintQuantityDAO.updatePaintQuantityBlockDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkPE") && "Y".equals(commandMap.get("chkPE"))) {
			paintQuantityDAO.updatePaintQuantityPEDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkPrePE") && "Y".equals(commandMap.get("chkPrePE"))) {
			paintQuantityDAO.updatePaintQuantityPrePEDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkDock") && "Y".equals(commandMap.get("chkDock"))) {
			paintQuantityDAO.updatePaintQuantityHullDefineFlag(commandMap.getMap());
		}
		
		if (null != commandMap.get("chkQuay") && "Y".equals(commandMap.get("chkQuay"))) {
			paintQuantityDAO.updatePaintQuantityQuayDefineFlag(commandMap.getMap());
		}
					
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}


	@Override
	public View allQuantityExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		String sProjectRevision = commandMap.get("project_no")+"_"+commandMap.get("revision");
		
		List<String> excelName = new ArrayList<String>();
		excelName.add(sProjectRevision+"_QUANTITY");
		excelName.add(sProjectRevision+"_QUANTITY_SUM");
		
		modelMap.put("excelName",  excelName);
		
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("Project");
		colName.add("QUAY");
		colName.add("ZONE");
		colName.add("PE");
		colName.add("Pre PE");
		colName.add("Block");
		
		colName.add("Area Code");
		colName.add("Area Desc");
		
		colName.add("Count");
		colName.add("Paint Code");
		colName.add("Paint Desc");
		colName.add("DFT");
		colName.add("Stage");
		colName.add("TSR");
		colName.add("SVR");
		
		colName.add("Pre Loss");
		colName.add("Post Loss");
		colName.add("Pre Loss(%)");
		colName.add("Post Loss(%)");
		
		colName.add("Block Area");
		colName.add("Pre PE Area");
		colName.add("PE Area");
		colName.add("Hull Area");
		colName.add("Quay Area");
		
		colName.add("Block Quantity");
		colName.add("Pre PE Quantity");
		colName.add("PE Quantity");
		colName.add("Hull Quantity");
		colName.add("Quay Quantity");
		
		colName.add("Block Theory Quantity");
		colName.add("Pre PE Theory Quantity");
		colName.add("PE Theory Quantity");
		colName.add("Hull Theory Quantity");
		colName.add("Quay Theory Quantity");
		
		colName.add("대표구역");
		colName.add("Zone Group");
		
		modelMap.put(sProjectRevision+"_QUANTITY_colName",    colName);			
		
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();
		
		List<Map<String, Object>> 	   list	  = paintQuantityDAO.selectAllQuantityListExport(commandMap.getMap());			

		for(Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object>   row   = new ArrayList<Object>();
			
			row.add( rowData.get("project_no"));
			row.add( rowData.get("quay"));
			row.add( rowData.get("zone_code"));
			row.add( rowData.get("pe_code"));
			row.add( rowData.get("pre_pe_code"));
			row.add( rowData.get("block_code"));
			
			row.add( rowData.get("area_code"));
			row.add( rowData.get("area_desc"));
			
			row.add( rowData.get("paint_count"));
			row.add( rowData.get("paint_item"));
			row.add( rowData.get("item_desc"));
			row.add( rowData.get("paint_dft"));
			row.add( rowData.get("paint_stage"));
			row.add( rowData.get("tsr"));
			row.add( rowData.get("paint_svr"));
			
			row.add( rowData.get("pre_loss"));
			row.add( rowData.get("post_loss"));
			row.add( rowData.get("pre_loss_rate"));
			row.add( rowData.get("post_loss_rate"));
			
			row.add( rowData.get("block_area"));
			row.add( rowData.get("pre_pe_area"));
			row.add( rowData.get("pe_area"));
			row.add( rowData.get("hull_area"));
			row.add( rowData.get("quay_area"));
			
			row.add( rowData.get("block_quantity"));
			row.add( rowData.get("pre_pe_quantity"));
			row.add( rowData.get("pe_quantity"));
			row.add( rowData.get("hull_quantity"));
			row.add( rowData.get("quay_quantity"));
			
			row.add( rowData.get("block_theory_quantity"));
			row.add( rowData.get("pre_pe_theory_quantity"));
			row.add( rowData.get("pe_theory_quantity"));
			row.add( rowData.get("hull_theory_quantity"));
			row.add( rowData.get("quay_theory_quantity"));
			
			row.add( rowData.get("master_area_code"));
			row.add( rowData.get("master_area_code_desc"));
			colValue.add(row);
		}
		
		modelMap.put(sProjectRevision+"_QUANTITY_colValue",   colValue);
		
		// 2페이지
		List<String> colName2 = new ArrayList<String>();
		colName2.add("Block");
		colName2.add("Block Area");
		colName2.add("PE Area");
		colName2.add("Hull Area");
		colName2.add("Quay Area");
		
		colName2.add("Block Quantity");
		colName2.add("PE Quantity");
		colName2.add("Hull Quantity");
		colName2.add("Quay Quantity");
		
		colName2.add("Block Theory Quantity");
		colName2.add("PE Theory Quantity");
		colName2.add("Hull Theory Quantity");
		colName2.add("Quay Theory Quantity");
		
		modelMap.put(sProjectRevision+"_QUANTITY_SUM_colName",    colName2);	
		
		// COLVALUE 설정
		List<List<Object>> colValue2 = new ArrayList<List<Object>>();		
		
		list	  = paintQuantityDAO.selectAllQuantityListExport2(commandMap.getMap());	
		
		for(Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object>   row   = new ArrayList<Object>();
					
			row.add( rowData.get("block_code"));
			row.add( rowData.get("block_area"));
			row.add( rowData.get("pe_area"));
			row.add( rowData.get("hull_area"));
			row.add( rowData.get("quay_area"));
			
			row.add( rowData.get("block_quantity"));
			row.add( rowData.get("pe_quantity"));
			row.add( rowData.get("hull_quantity"));
			row.add( rowData.get("quay_quantity"));
			
			row.add( rowData.get("block_theory_quantity"));
			row.add( rowData.get("pe_theory_quantity"));
			row.add( rowData.get("hull_theory_quantity"));
			row.add( rowData.get("quay_theory_quantity"));
			
			colValue2.add(row);
		}
		
		modelMap.put(sProjectRevision+"_QUANTITY_SUM_colValue",   colValue2);
		
		return new GenericExcelView();
	}


	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, String> savePaintQuantityTransfer(CommandMap commandMap) throws Exception {
		
		if (null != commandMap.get("chkPrePeHalf") && "Y".equals(commandMap.get("chkPrePeHalf"))) {
			// PE → Pre PE 50%
			paintQuantityDAO.updatePrePEQuantityHalfTransfer(commandMap.getMap());
			
		} else	if (null != commandMap.get("chkPrePeAll") && "Y".equals(commandMap.get("chkPrePeAll"))) {
			// PE → Pre PE 100%
			paintQuantityDAO.updatePrePEQuantityAllTransfer(commandMap.getMap());
			
		} else if (null != commandMap.get("chkDockAll") && "Y".equals(commandMap.get("chkDockAll"))) {
			// PE → DOCK 100%
			paintQuantityDAO.updateHullQuantityAllTransfer(commandMap.getMap());
			
		} else if (null != commandMap.get("chkBlockAll") && "Y".equals(commandMap.get("chkBlockAll"))) {			
			// PE → BLOCK 100%
			paintQuantityDAO.updateBlockQuantityAllTransfer(commandMap.getMap());
			
		}
					
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}


	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, String> savePaintQuantityAutoTransfer(CommandMap commandMap) throws Exception {

		// Paint 호선 Rule 체크 (DIS 호선 OR Migration 호선)
		Map<String, Object> checkMap = (Map<String, Object>) paintCommonDAO.selectPaintNewRuleFlag(commandMap.getMap());
		
		if(checkMap == null)
		{
			throw new Exception("DIS 호선 Rule이 없습니다.");
		}
		String paint_new_rule_flag = (String)checkMap.get("paint_new_rule_flag");
		System.out.println("!!!! paint_new_rule_flag = "+paint_new_rule_flag);
		
		if(paint_new_rule_flag==null || "".equals(paint_new_rule_flag))
		{
			throw new Exception("DIS 호선 Rule이 없습니다.");
		}
		
	
		// PE 물량을 선PE 또는 BLOCK 또는 Dock 또는 Quay에 물량 이관 (단, 900단위 block은 이관 제외)
		// 1. DIS 호선일 경우
		if("Y".equals(paint_new_rule_flag))
		{
			// 1-1. PRE PE가 있는 BLOCK의 PE 물량을 PRE PE로 50% or 100% 이관
			// (동일 PE의 모든 BLOCK이 모두 하나의 PRE PE를 가지고 있으면 100%이관, 아니면 50% 이관하는데.. 100%이관 CASE는 거의 없기에 50% 대상 먼저 작업 후 100%이관 대상 조치)
			
			// 1-1-1. PRE PE가 있는 BLOCK의 PE 물량을 PRE PE로 50%이관
			paintQuantityDAO.updatePrePEQuantityHalfAutoTransfer(commandMap.getMap());
			
			// 1-1-2. PE -> PRE PE로 100%이관
			// PE -> PRE PE 100% 이관로직 제거 (2016-04-08 김우석 과장 요청)
			////paintQuantityDAO.updatePrePEQuantityAllAutoTransfer(commandMap.getMap());

			
			// 1-2. PRE PE이관 후 남은 50% PE 물량과, PRE PE가 BLOCK의 PE 물량 이관
			//      HULL 물량이 있을 경우만 PE물량을 HULL로 이동,  HULL물량이 0면 PE물량을 QUAY로 이관
			paintQuantityDAO.updateHullorQuayQuantityAutoTransfer(commandMap.getMap());
			
			
		} else if("N".equals(paint_new_rule_flag)){
			// 2. MIG 호선일 경우
			
			// 2-1. 이관 블럭 설정 대상의 PE 물량을 전량 BLOCK으로 이관
			paintQuantityDAO.updateBlockQuantityAllAutoTransfer(commandMap.getMap());
			
			// 2-2. 이관 블럭이외의 PE 물량은 후행으로 이관.  DIS와 동일하게. HULL 물량이 있을 경우만 PE물량을 HULL로 이동,  HULL물량이 0면 PE물량을 QUAY로 이관 
			paintQuantityDAO.updateHullorQuayQuantityAutoTransfer(commandMap.getMap());
		}
		

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}	

}
