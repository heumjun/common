package stxship.dis.bom.ssc.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface SscService extends CommonService {
	
	public Map<String, Object> selectMainList(CommandMap commandMap) throws Exception;
	
	public View sscMainExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	public String selectAutoCompleteDwgNoList(CommandMap commandMap);
	
	public String sscAutoCompleteUscJobTypeList(CommandMap commandMap);
	
	public List<Map<String, Object>> sscSeriesList(CommandMap commandMap);
	
	public String sscRevText(CommandMap commandMap);
	
	public String sscMasterNo(CommandMap commandMap);
	
	public List<Map<String, Object>> sscJobList(CommandMap commandMap);
	
	public Map<String, Object> sscAddValidationCheck(CommandMap commandMap) throws Exception;
	public Map<String, Object> sscAddValidationCheckStage(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscWorkValidationList(CommandMap commandMap) throws Exception;

	public List<Map<String, Object>> sscAddBackList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscAddItemCreate(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscAddApplyAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscAddTribonMainList(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> sscAddTribonTransferList(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> sscAddExcelImportAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscChekedMainList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscModifyValidationCheck(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscModifyApplyAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscDeleteValidationCheck(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscDeleteApplyAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBomApplyAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscAllBomApplyAction(CommandMap commandMap) throws Exception;
		
	public Map<String, Object> sscRestoreAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscCancelAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscCableTypeMainList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscCableTypeSaveAction(CommandMap commandMap) throws Exception;
	
	public View sscCableTypeExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
	
	public List<Map<String, Object>> sscCableTypeExcelImportAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscStructureList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscAddEmsMainList(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> sscAddEmsTransferList(CommandMap commandMap) throws Exception;
	
	public String sscPaintDwgNo(CommandMap commandMap);

	public Map<String, Object> sscAfterInfoList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscAfterInfoSaveAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscMainSaveAction(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectMainTotalList(CommandMap commandMap) throws Exception;

	public String dwgPopupViewList(CommandMap commandMap) throws Exception;

	public View sscMainTotalExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	public Map<String, Object> sscItemAddStageGetMother(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> getCatalogDesign(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscTribonInterfaceDelete(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyMainList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> getSscDescription(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyMainDelete(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyMainRestore(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyMainCancel(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyMainSave(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyAddNext(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyAddBack(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyAddApply(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> sscBuyBuyAddExcelImportAction(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> sscBuyBuyDwgNoList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> sscBuyBuyAddGetItemDesc(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> getDeliverySeries(CommandMap commandMap) throws Exception;

	//public Map<String, Object> getGridList(CommandMap commandMap);
}
