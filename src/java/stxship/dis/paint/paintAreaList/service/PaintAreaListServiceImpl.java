package stxship.dis.paint.paintAreaList.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.paintAreaList.dao.PaintAreaListDAO;

/**
 * @파일명 : PaintAreaListServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint Area List 서비스
 *     </pre>
 */
@Service("paintAreaListService")
public class PaintAreaListServiceImpl extends CommonServiceImpl implements PaintAreaListService {

	@Resource(name = "paintAreaListDAO")
	private PaintAreaListDAO paintAreaListDAO;

	/**
	 * @메소드명 : paintAreaListExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Area List 의 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View paintAreaListExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();
		String sqlId = "";
		String sTab = (String) commandMap.get("selected_tab");
		this.setTitle((String) commandMap.get("project_no"), (String) commandMap.get("season_code"), sTab, colName);
		if ("blockPaintAreaList".equals(sTab)) {
			sqlId = "selectBlockPaintAreaList.list";
		} else if ("pePaintAreaList".equals(sTab)) {
			sqlId = "selectPEPaintAreaList.list";
		} else if ("hullPaintAreaList".equals(sTab)) {
			sqlId = "selectHullPaintAreaList.list";
		} else if ("quayPaintAreaList".equals(sTab)) {
			sqlId = "selectQuayPaintAreaList.list";
		}
		this.setHead(sTab, colValue);
		// commandMap.put("code_list", "'" + commandMap.get("code_list") + "'");
		List<Map<String, Object>> list = paintAreaListDAO.selectList(sqlId, commandMap.getMap());
		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
			if ("blockPaintAreaList".equals(sTab)) {
				row.add(rowData.get("block_code"));
			} else if ("pePaintAreaList".equals(sTab)) {
				row.add(rowData.get("pe_code"));
			} else if ("hullPaintAreaList".equals(sTab)) {
				row.add(rowData.get("area_code"));
				row.add(rowData.get("area_desc"));
			} else if ("quayPaintAreaList".equals(sTab)) {
				row.add(rowData.get("area_code"));
				row.add(rowData.get("area_desc"));
			}
			row.add(rowData.get("make_name"));
			row.add(rowData.get("sp_area"));
			row.add(rowData.get("paint_area"));
			colValue.add(row);
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		modelMap.put("excelName", commandMap.get("project_no") + "_" + commandMap.get("revision") + "_PaintAreaList"
				+ sdf.format(new Date()));

		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();
	}

	private void setTitle(String sProject, String sSeason, String sTab, List<String> colName) {
		colName.add("호선 : " + sProject);
		colName.add("");
		colName.add("");
		colName.add("PAINT : " + sSeason);
		if ("hullPaintAreaList".equals(sTab) || "quayPaintAreaList".equals(sTab)) {
			colName.add("");
		}
	}

	private void setHead(String sTab, List<List<Object>> colValue) {
		List<Object> row1 = new ArrayList<Object>();
		List<Object> row2 = new ArrayList<Object>();
		if ("blockPaintAreaList".equals(sTab)) {
			row1.add("");
			row2.add("Block");
		} else if ("pePaintAreaList".equals(sTab)) {
			row1.add("");
			row2.add("PE");
		} else if ("hullPaintAreaList".equals(sTab)) {
			row1.add("");
			row1.add("");
			row2.add("Area Code");
			row2.add("Area Desc");
		} else if ("quayPaintAreaList".equals(sTab)) {
			row1.add("");
			row1.add("");
			row2.add("Area Code");
			row2.add("Area Desc");
		}
		row1.add("");
		row1.add("");
		row1.add("");
		row2.add("제작처");
		row2.add("S/P Area");
		row2.add("Paint Area");
		colValue.add(row1);
		colValue.add(row1);
		colValue.add(row2);
	}
}
