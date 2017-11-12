package stxship.dis.bom.bom.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.bom.bom.dao.BomDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;

@Service("bomService")
public class BomServiceImpl extends CommonServiceImpl implements BomService {
	@Resource(name = "bomDAO")
	private BomDAO bomDAO;

	@Override
	public View bomExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("LV");
		colName.add("2 LV");
		colName.add("3 LV");
		colName.add("4 LV");
		colName.add("5 LV");
		colName.add("6 LV");
		colName.add("7 LV");
		colName.add("8 LV");
		colName.add("9 LV");

		colName.add("Description");
		colName.add("UOM");
		colName.add("Catalog");
		colName.add("도면NO");
		colName.add("QTY");
		colName.add("Creator");
		colName.add("ECO NO");

		colName.add("BOM1");
		colName.add("BOM2");
		colName.add("BOM3");
		colName.add("BOM4");
		colName.add("BOM5");
		colName.add("BOM6");
		colName.add("BOM7");
		colName.add("BOM8");
		colName.add("BOM9");
		colName.add("BOM10");
		colName.add("BOM11");
		colName.add("BOM12");
		colName.add("BOM13");
		colName.add("BOM14");
		colName.add("BOM15");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> itemList = bomDAO.selectitemExcelExportList(commandMap.getMap());

		for (Map<String, Object> rowData : itemList) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add(DisStringUtil.nullString(rowData.get("level_1")));
			row.add(DisStringUtil.nullString(rowData.get("level_2")));
			row.add(DisStringUtil.nullString(rowData.get("level_3")));
			row.add(DisStringUtil.nullString(rowData.get("level_4")));
			row.add(DisStringUtil.nullString(rowData.get("level_5")));
			row.add(DisStringUtil.nullString(rowData.get("level_6")));
			row.add(DisStringUtil.nullString(rowData.get("level_7")));
			row.add(DisStringUtil.nullString(rowData.get("level_8")));
			row.add(DisStringUtil.nullString(rowData.get("level_9")));

			row.add(DisStringUtil.nullString(rowData.get("item_desc")));
			row.add(DisStringUtil.nullString(rowData.get("item_uom_code")));
			row.add(DisStringUtil.nullString(rowData.get("item_catalog")));
			row.add(DisStringUtil.nullString(rowData.get("dwg_no")));
			row.add(DisStringUtil.nullString(rowData.get("bom_qty")));
			row.add(DisStringUtil.nullString(rowData.get("emp_no")));
			row.add(DisStringUtil.nullString(rowData.get("eco_no")));

			row.add(DisStringUtil.nullString(rowData.get("bom1")));
			row.add(DisStringUtil.nullString(rowData.get("bom2")));
			row.add(DisStringUtil.nullString(rowData.get("bom3")));
			row.add(DisStringUtil.nullString(rowData.get("bom4")));
			row.add(DisStringUtil.nullString(rowData.get("bom5")));
			row.add(DisStringUtil.nullString(rowData.get("bom6")));
			row.add(DisStringUtil.nullString(rowData.get("bom7")));
			row.add(DisStringUtil.nullString(rowData.get("bom8")));
			row.add(DisStringUtil.nullString(rowData.get("bom9")));
			row.add(DisStringUtil.nullString(rowData.get("bom10")));
			row.add(DisStringUtil.nullString(rowData.get("bom11")));
			row.add(DisStringUtil.nullString(rowData.get("bom12")));
			row.add(DisStringUtil.nullString(rowData.get("bom13")));
			row.add(DisStringUtil.nullString(rowData.get("bom14")));
			row.add(DisStringUtil.nullString(rowData.get("bom15")));

			colValue.add(row);
		}

		// 오늘 날짜 구함 시작
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);
		// 오늘 날짜 구함 끝

		modelMap.put("excelName", commandMap.get("p_project_no") + "_" + dateToday);
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();

	}
}
