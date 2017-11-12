/**
 * 
 */
package stxship.dis.dps.dpDataMgmtOld.service;

import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpDataMgmtOld.dao.DataMgmtOldDAO;

/** 
 * @파일명	: DataMgmtServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 10. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 설계시수 Data 관리 service 구현부
 * </pre>
 */
@Service("dataMgmtOldService")
public class DataMgmtOldServiceImpl extends DpsCommonServiceImpl implements DataMgmtOldService {
	@Resource(name="dataMgmtOldDAO")
	private DataMgmtOldDAO dataMgmtDAO;

	@Override
	public View dataMgmtExcelExport(CommandMap commandMap,Map<String, Object> modelMap) {
		List<String> colName = new ArrayList<String>();
		colName.add("No");
		colName.add("PROJECT");
		colName.add("작업일자");
		colName.add("사번");
		colName.add("성명");
		colName.add("부서CODE");
		colName.add("부서");
		colName.add("도면번호");
		colName.add("OP코드");
		colName.add("직접");
		colName.add("배부");
		colName.add("공사구분");
		colName.add("정상");
		colName.add("잔업");
		colName.add("특근");
		

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = dataMgmtDAO.selectDataMgmtList(commandMap.getMap());
		
		int rn = 1;
		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();
			row.add(""+rn);
			row.add(DisStringUtil.nullString(rowData.get("project_no")));
			row.add(DisStringUtil.nullString(rowData.get("workday")));
			row.add(DisStringUtil.nullString(rowData.get("employee_no")));
			row.add(DisStringUtil.nullString(rowData.get("emp_name")));
			row.add(DisStringUtil.nullString(rowData.get("dept_code")));
			row.add(DisStringUtil.nullString(rowData.get("dept_name")));
			row.add(DisStringUtil.nullString(rowData.get("dwg_code")));
			row.add(DisStringUtil.nullString(rowData.get("op_code")));
			row.add(DisStringUtil.nullString(rowData.get("direct_mh")));
			row.add(DisStringUtil.nullString(rowData.get("dist_mh")));
			row.add(DisStringUtil.nullString(rowData.get("project_gbn")));
			row.add(DisStringUtil.nullString(rowData.get("normal_time_factor")));
			row.add(DisStringUtil.nullString(rowData.get("over_time_factor")));
			row.add(DisStringUtil.nullString(rowData.get("special_time_factor")));

			colValue.add(row);
			rn++;
		}

		modelMap.put("excelName", "DataMgmt");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}
	
	

}
