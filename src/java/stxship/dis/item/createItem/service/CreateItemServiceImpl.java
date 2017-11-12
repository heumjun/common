package stxship.dis.item.createItem.service;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.item.createItem.dao.CreateItemDAO;

@Service("createItemService")
public class CreateItemServiceImpl extends CommonServiceImpl implements CreateItemService {

	@Resource(name = "createItemDAO")
	private CreateItemDAO createItemDAO;

	@Override
	public Map<String, Object> saveItemNextAction(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> itemCreateWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sShipType = DisStringUtil.nullString(commandMap.get("shipType"));
		String sAttr00_code = DisStringUtil.nullString(commandMap.get("attr00_code"));
		String sAttr00_desc = DisStringUtil.nullString(commandMap.get("attr00_desc"));
		
		// ship type flag를 받아온다.
		String sShipTypeFlag = createItemDAO.selectShipTypeFlag(commandMap.getMap());

		if (sShipTypeFlag == null || "".equals(sShipTypeFlag)) {
			sShipTypeFlag = "N";
		}
		
		// 타입이 필수인 part_family_code 인경우 체크
		if ("Y".equals(sShipTypeFlag) && (sShipType == null || "".equals(sShipType))) {
			// 에러 메시지 출력
			// SHIP TYPE이 없습니다.
			throw new DisException("SHIP TYPE이 없습니다.");
		}
		
		// 리스트를 취득한다.
		Object pageSize = "99999";
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> tempList = new ArrayList<Map<String, Object>>();
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			
			for (Map<String, Object> rowData : itemCreateWorkList) {
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					commandMap.put("p_" + key, rowData.get(key));
				}
				
				commandMap.put("p_ship_type", sShipType);
				commandMap.put("p_loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commandMap.put("p_attr00_code", sAttr00_code);
				commandMap.put("p_attr00_desc", sAttr00_desc);
				commandMap.put("p_paint_code1", "");
				commandMap.put("p_paint_code2", "");
				commandMap.put("p_attr_list", "");
				
				Map<String, Object> resultData = createItemDAO.saveItemNextAction(commandMap.getMap());
				List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
				tempList.add(listData.get(0));
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(resultData.get("p_err_msg"));
				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
				
			}
			
			// 리스트 총 사이즈를 구한다.
			Object listRowCnt = tempList.size();
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			}
			// 라스트 페이지를 구한다.
			Object lastPageCnt = "page>total";
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
				lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
			}

			result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
			result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
			result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
			result.put(DisConstants.GRID_RESULT_DATA, tempList);
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
			
			// 여기까지 Exception 없으면 성공 메시지
			result.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			
		} catch(Exception e) {
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return result;
	}
	
	/**
	 * @메소드명 : saveItemCreate
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 생성
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> saveItemCreate(CommandMap commandMap) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {

			String sShipType = (String) commandMap.get("shipType");

			String sAttr00_code = (String) commandMap.get("attr00_code");
			String sAttr00_desc = (String) commandMap.get("attr00_desc");

			List<Map<String, Object>> itemList = DisJsonUtil
					.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

			// ship type flag를 받아온다.
			String sShipTypeFlag = createItemDAO.selectShipTypeFlag(commandMap.getMap());

			if (sShipTypeFlag == null || "".equals(sShipTypeFlag)) {
				sShipTypeFlag = "N";
			}

			// 타입이 필수인 part_family_code 인경우 체크
			if ("Y".equals(sShipTypeFlag) && (sShipType == null || "".equals(sShipType))) {
				// 에러 메시지 출력
				// SHIP TYPE이 없습니다.
				throw new DisException("SHIP TYPE이 없습니다.");
			}

			List<Map<String, Object>> rtnItemList = new ArrayList<Map<String, Object>>();

			// 그리드에 있는 아이템 리스트를 LOOP를 돌려 각각 프로시저를 태운다.
			for (Map<String, Object> rowData : itemList) {

				Map<String, Object> pkgParam = new HashMap<String, Object>();

				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				pkgParam.put("p_ship_type", sShipType);
				pkgParam.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_attr00_code", sAttr00_code);
				pkgParam.put("p_attr00_desc", sAttr00_desc);
				pkgParam.put("p_paint_code1", "");
				pkgParam.put("p_paint_code2", "");

				// 프로시저 실행
				createItemDAO.insertItemCodeCreate(pkgParam);

				// 프로시저 결과 받음
				String sErrMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));
				String sItemCode = DisStringUtil.nullString(pkgParam.get("p_item_code"));

				// 오류가 있으면
				if (!"".equals(sErrMsg)) {
					throw new Exception(sErrMsg);
				}

				// 엑셀 업로드의 경우 ITEM TEMP 테이블에 입력
				if ("Y".equals(DisStringUtil.nullString(rowData.get("excel_upload_flag")))) {
					// ITEM TEMP 테이블에 확정 컬럼에 'Y' 입력
					int isOk = createItemDAO.updateItemConfirm(rowData);
					if(isOk < 0){
						throw new Exception();
					}
					// 확정 컬럼 이 Y 인것들은 삭제
					int isOk2 = createItemDAO.deleteCatalogConfirmItemList(rowData);
					
					if(isOk2 < 0){
						throw new Exception();
					}
				}

				rowData.put("err_msg", "생성 성공");
				rowData.put("err_code", sErrCode);
				rowData.put("item_code", sItemCode);

				// 채번된 아이템 정보들을 리스트에 담는다.
				rtnItemList.add(rowData);
				
			} // LOOP 종료
	
			// 입력한 아이템리스트를 리턴맵에 담는다.
			rtnMap.put("itemList", rtnItemList);
			// 리턴 메시지 담음
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisConstants.RESULT_SUCCESS);
		

		} catch (Exception e) {			
			throw new Exception(e.getMessage());
		}
		return rtnMap;
	}

	/**
	 * @메소드명 : itemExcelExport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View itemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("CATALOG_CODE");
		colName.add("WEIGHT");
		// colName.add("OLD_ITEM_CODE");
		colName.add("ATTR01");
		colName.add("ATTR02");
		colName.add("ATTR03");
		colName.add("ATTR04");
		colName.add("ATTR05");
		colName.add("ATTR06");
		colName.add("ATTR07");
		colName.add("ATTR08");
		colName.add("ATTR09");
		colName.add("ATTR10");
		colName.add("ATTR11");
		colName.add("ATTR12");
		colName.add("ATTR13");
		colName.add("ATTR14");
		colName.add("ATTR15");
		colName.add("부가속성01");
		colName.add("부가속성02");
		colName.add("부가속성03");
		colName.add("부가속성04");
		colName.add("부가속성05");
		colName.add("부가속성06");
		colName.add("부가속성07");
		colName.add("부가속성08");
		colName.add("부가속성09");
		colName.add("부가속성10");
		colName.add("부가속성11");
		colName.add("부가속성12");
		colName.add("부가속성13");
		colName.add("부가속성14");
		colName.add("부가속성15");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> itemList = createItemDAO.selectitemExcelExportList(commandMap.getMap());

		for (Map<String, Object> rowData : itemList) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add(DisStringUtil.nullString(rowData.get("catalog_code")));
			row.add(DisStringUtil.nullString(rowData.get("weight")));
			// row.add((String) rowData.get("old_item_code"));
			row.add(DisStringUtil.nullString(rowData.get("attr01")));
			row.add(DisStringUtil.nullString(rowData.get("attr02")));
			row.add(DisStringUtil.nullString(rowData.get("attr03")));
			row.add(DisStringUtil.nullString(rowData.get("attr04")));
			row.add(DisStringUtil.nullString(rowData.get("attr05")));

			row.add(DisStringUtil.nullString(rowData.get("attr06")));
			row.add(DisStringUtil.nullString(rowData.get("attr07")));
			row.add(DisStringUtil.nullString(rowData.get("attr08")));
			row.add(DisStringUtil.nullString(rowData.get("attr09")));
			row.add(DisStringUtil.nullString(rowData.get("attr10")));

			row.add(DisStringUtil.nullString(rowData.get("attr11")));
			row.add(DisStringUtil.nullString(rowData.get("attr12")));
			row.add(DisStringUtil.nullString(rowData.get("attr13")));
			row.add(DisStringUtil.nullString(rowData.get("attr14")));
			row.add(DisStringUtil.nullString(rowData.get("attr15")));

			row.add(DisStringUtil.nullString(rowData.get("add_attr01")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr02")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr03")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr04")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr05")));

			row.add(DisStringUtil.nullString(rowData.get("add_attr06")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr07")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr08")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr09")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr10")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr11")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr12")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr13")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr14")));
			row.add(DisStringUtil.nullString(rowData.get("add_attr15")));

			colValue.add(row);
		}

		// 오늘 날짜 구함 시작
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);
		// 오늘 날짜 구함 끝

		modelMap.put("excelName", commandMap.get("catalog_code") + "_" + dateToday);
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();

	}

	/**
	 * @메소드명 : selectTempCatalogItemExist
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String selectTempCatalogItemExist(CommandMap commandMap) throws Exception {
		return createItemDAO.selectExistCatalogItemUpload(commandMap.getMap());
	}

	/**
	 * @메소드명 : itemExcelImport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void itemExcelImport(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		response.setContentType("text/html;charset=UTF-8");

		PrintWriter out = response.getWriter();
		String savePath = (request.getSession().getServletContext().getRealPath("/")).replace("\\", "/")
				+ DisConstants.EXCEL;

		// int sizeLimit = 30 * 1024 *1024;
		// String formName = "";
		String fileName = "";
		StringBuffer sb = null;
		OutputStream fileOut = null;

		String vCatalogCode = DisStringUtil.nullString(commandMap.get("catalog_code"));
		String vDeleteYn = DisStringUtil.nullString(commandMap.get("delete_yn"));
		CommonsMultipartFile file = (CommonsMultipartFile) commandMap.get("file");

		// Map<String, Object> columnInfo = (Map<String, Object>)
		// stxDisCommonService.queryForOne("ItemCreate.selectCatalogAttribute",
		// rtnMap);
		Map<String, Object> columnInfo = createItemDAO.selectCatalogAttribute(commandMap.getMap());

		try {

			// 파일 생성
			if (!file.isEmpty()) {
				File dirFile = new File(savePath + "/");
				if (!dirFile.exists())
					dirFile.mkdirs();

				fileName = file.getOriginalFilename();
				fileOut = new FileOutputStream(savePath + "/" + fileName);

				BufferedInputStream bis = new BufferedInputStream(file.getInputStream());
				byte[] buffer = new byte[8106];
				int read;

				while ((read = bis.read(buffer)) > 0) {
					fileOut.write(buffer, 0, read);
				}

				fileOut.close();
			}

			//System.out.println(">>>>>>>>>>>>>>>>>" + savePath + "/" + fileName);

			//파일 복호화
			File DecryptFile = null; 
			DecryptFile = DisEGDecrypt.createDecryptFile(file);
			
			FileInputStream tempFile = new FileInputStream(DecryptFile);
			//FileInputStream tempFile = new FileInputStream(new File(savePath + "/" + fileName));
			org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(tempFile);
			org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);
			

			Iterator<Row> rowIterator = sheet.iterator();

			List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();
			while (rowIterator.hasNext()) {
				Row row = rowIterator.next();

				// 첫번째는 컬럼 정보
				System.out.println("====Excel to DB Insert====");
				if (row.getRowNum() == 0 || row.getRowNum() == 1) {
				} else {
					// Map에 insert 파라미트 설정한다.
					uploadList.add(toMap(row, columnInfo,
							DisStringUtil.nullString(commandMap.get(DisConstants.SET_DB_LOGIN_ID))));
				}
			}

			tempFile.close();
			//복화화된 파일 삭제
			DisEGDecrypt.deleteDecryptFile(DecryptFile);
			
			// UPLOAD리스트가 있으면 업로드 할 리스트를 받아서 INSERT 해준다.
			if (uploadList.size() > 0) {

				if ("Y".equals(vDeleteYn)) {
					// 기존 데이터가 있으면 삭제한다.
					createItemDAO.deleteCatalogItemListUp(commandMap.getMap());
					createItemDAO.deleteCatalogItemList(commandMap.getMap());
				}
				// stx_dis_sd_item_list_up 에 입력.
				for (Map<String, Object> rowData : uploadList) {
					createItemDAO.insertCatalogItemListUpload(rowData);
				}

				commandMap.put("p_catalog_code", vCatalogCode == null ? "" : vCatalogCode);

				// 체크 프로시저 호출
				if (vCatalogCode.startsWith("1") || vCatalogCode.startsWith("2") || vCatalogCode.startsWith("3")
						|| vCatalogCode.startsWith("4") || vCatalogCode.startsWith("5")
						|| vCatalogCode.startsWith("Z")) {

					if (!vCatalogCode.startsWith("Z")) {
						//excuteExcelCheck(commandMap.getMap());
						createItemDAO.procedureItemCheck(commandMap.getMap());
						
						// 프로시저 결과 받음
						String sErrorMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
						String sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

						// 오류가 있으면 스탑
						if (!"".equals(sErrorMsg)) {
							sb = resultPopUp(sErrorMsg, null, "E");
						}
						
					} else {
						commandMap.put("p_err_code", "S");
						commandMap.put("p_err_msg", "");
					}

					if (vCatalogCode.startsWith("ZR") || vCatalogCode.startsWith("ZK") || vCatalogCode.startsWith("ZJ")
							|| vCatalogCode.startsWith("ZL") || vCatalogCode.startsWith("ZM")) {

					} else {

						if (commandMap.get("p_err_code") != null && "S".equals(commandMap.get("p_err_code"))) {
							excuteExcelWeightCheck(commandMap.getMap());
						}
					}

				} else {
					commandMap.put("p_err_code", "S");
					commandMap.put("p_err_msg", "");
				}

				if (commandMap.get("p_err_code") != null && "S".equals(commandMap.get("p_err_code"))) {
					// 저장 프로시저 호출
					excuteExcelUpload(commandMap.getMap());

					if (commandMap.get("p_err_code") != null && !"S".equals(commandMap.get("p_err_code"))) {
						// 오류 처리
						sb = resultPopUp(DisStringUtil.nullString(commandMap.get("p_err_msg")), vCatalogCode, "E");
					}
				} else {
					// 오류 처리
					sb = resultPopUp(DisStringUtil.nullString(commandMap.get("p_err_msg")), vCatalogCode, "E");
				}

				if (sb == null) {
					sb = resultPopUp("엑셀 업로드 완료되었습니다.", null, "S");
				}

			} else {
				sb = resultPopUp("입력할 데이터가 없습니다.", null, "E");
			}

		} catch (Exception e) {
			//e.printStackTrace();
			sb = resultPopUp(e.getMessage(), null, "E");
			throw e;
		} finally {

			File deletefile = new File(savePath + "/" + fileName);
			deletefile.delete();

			//response.getWriter().write("엑셀 업로드 완료되었습니다.");
			out.write(sb.toString());
			out.flush();
		}
	}

	/**
	 * @메소드명 : resultPopUp
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		결과 팝업 화면 출력
	 *     </pre>
	 * 
	 * @param message
	 * @param catalogCode
	 * @param errCode
	 * @return
	 */
	private StringBuffer resultPopUp(String message, String catalogCode, String errCode) {
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\" >");
		sb.append("alert('" + message.replaceAll("\n", "\\\\n") + "');");

		if ("S".equals(errCode)) {
			sb.append("opener.location.href='javascript:fn_search();';");
			sb.append("self.close();");
		} else {
			sb.append("location.href='./itemExcelUpload.do?gbn=itemExcelUpload&catalog_code=" + catalogCode + "';");
		}

		sb.append("</script>");

		return sb;
	}

	/**
	 * @메소드명 : excuteExcelCheck
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 체크
	 *     </pre>
	 * 
	 * @param param
	 */
	private void excuteExcelCheck(Map<String, Object> param) {
		System.out.println("파람:" + param);
		createItemDAO.procedureItemCheck(param);
		System.out.println("결과:" + param);
	}

	/**
	 * @메소드명 : excuteExcelWeightCheck
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		weight가 있는지 체크
	 *     </pre>
	 * 
	 * @param param
	 */
	private void excuteExcelWeightCheck(Map<String, Object> param) {
		System.out.println("파람:" + param);
		createItemDAO.procedureItemWeightCheck(param);
		System.out.println("결과:" + param);
	}

	/**
	 * @메소드명 : excuteExcelUpload
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 업로드 실행
	 *     </pre>
	 * 
	 * @param param
	 */
	private void excuteExcelUpload(Map<String, Object> param) {
		System.out.println("파람:" + param);
		createItemDAO.procedureItemUpload(param);
		System.out.println("결과:" + param);
	}

	/**
	 * @메소드명 : toMap
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		맵 생성
	 *     </pre>
	 * 
	 * @param row
	 * @param columnInfo
	 * @param vUserId
	 * @return
	 */
	private Map<String, Object> toMap(Row row, Map<String, Object> columnInfo, String vUserId) {
		// 편집해야됩니다.
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("catalog_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
		map.put("weight", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1)));
		// map.put("old_item_code", row.getCell(2) == null ? "" :
		// DisExcelUtil.getCellValue(row.getCell(2)) );

		if (!"ATTR01".equals(columnInfo.get("attr01"))) {
			map.put("attr01", row.getCell(2) == null ? "" : DisExcelUtil.getCellValue(row.getCell(2)));
		} else {
			map.put("attr01", "");
		}

		if (!"ATTR02".equals(columnInfo.get("attr02"))) {
			map.put("attr02", row.getCell(3) == null ? "" : DisExcelUtil.getCellValue(row.getCell(3)));
		} else {
			map.put("attr02", "");
		}

		if (!"ATTR03".equals(columnInfo.get("attr03"))) {
			map.put("attr03", row.getCell(4) == null ? "" : DisExcelUtil.getCellValue(row.getCell(4)));
		} else {
			map.put("attr03", "");
		}

		if (!"ATTR04".equals(columnInfo.get("attr04"))) {
			map.put("attr04", row.getCell(5) == null ? "" : DisExcelUtil.getCellValue(row.getCell(5)));
		} else {
			map.put("attr04", "");
		}

		if (!"ATTR05".equals(columnInfo.get("attr05"))) {
			map.put("attr05", row.getCell(6) == null ? "" : DisExcelUtil.getCellValue(row.getCell(6)));
		} else {
			map.put("attr05", "");
		}

		if (!"ATTR06".equals(columnInfo.get("attr06"))) {
			map.put("attr06", row.getCell(7) == null ? "" : DisExcelUtil.getCellValue(row.getCell(7)));
		} else {
			map.put("attr06", "");
		}

		if (!"ATTR07".equals(columnInfo.get("attr07"))) {
			map.put("attr07", row.getCell(8) == null ? "" : DisExcelUtil.getCellValue(row.getCell(8)));
		} else {
			map.put("attr07", "");
		}

		if (!"ATTR08".equals(columnInfo.get("attr08"))) {
			map.put("attr08", row.getCell(9) == null ? "" : DisExcelUtil.getCellValue(row.getCell(9)));
		} else {
			map.put("attr08", "");
		}

		if (!"ATTR09".equals(columnInfo.get("attr09"))) {
			map.put("attr09", row.getCell(10) == null ? "" : DisExcelUtil.getCellValue(row.getCell(10)));
		} else {
			map.put("attr09", "");
		}

		if (!"ATTR10".equals(columnInfo.get("attr10"))) {
			map.put("attr10", row.getCell(11) == null ? "" : DisExcelUtil.getCellValue(row.getCell(11)));
		} else {
			map.put("attr10", "");
		}

		if (!"ATTR11".equals(columnInfo.get("attr11"))) {
			map.put("attr11", row.getCell(12) == null ? "" : DisExcelUtil.getCellValue(row.getCell(12)));
		} else {
			map.put("attr11", "");
		}

		if (!"ATTR12".equals(columnInfo.get("attr12"))) {
			map.put("attr12", row.getCell(13) == null ? "" : DisExcelUtil.getCellValue(row.getCell(13)));
		} else {
			map.put("attr12", "");
		}

		if (!"ATTR13".equals(columnInfo.get("attr13"))) {
			map.put("attr13", row.getCell(14) == null ? "" : DisExcelUtil.getCellValue(row.getCell(14)));
		} else {
			map.put("attr13", "");
		}

		if (!"ATTR14".equals(columnInfo.get("attr14"))) {
			map.put("attr14", row.getCell(15) == null ? "" : DisExcelUtil.getCellValue(row.getCell(15)));
		} else {
			map.put("attr14", "");
		}

		if (!"ATTR15".equals(columnInfo.get("attr15"))) {
			map.put("attr15", row.getCell(16) == null ? "" : DisExcelUtil.getCellValue(row.getCell(16)));
		} else {
			map.put("attr15", "");
		}

		if (!"부가속성01".equals(columnInfo.get("add_attr01"))) {
			map.put("add_attr01", row.getCell(17) == null ? "" : DisExcelUtil.getCellValue(row.getCell(17)));
		} else {
			map.put("add_attr01", "");
		}

		if (!"부가속성02".equals(columnInfo.get("add_attr02"))) {
			map.put("add_attr02", row.getCell(18) == null ? "" : DisExcelUtil.getCellValue(row.getCell(18)));
		} else {
			map.put("add_attr02", "");
		}

		if (!"부가속성03".equals(columnInfo.get("add_attr03"))) {
			map.put("add_attr03", row.getCell(19) == null ? "" : DisExcelUtil.getCellValue(row.getCell(19)));
		} else {
			map.put("add_attr03", "");
		}

		if (!"부가속성04".equals(columnInfo.get("add_attr04"))) {
			map.put("add_attr04", row.getCell(20) == null ? "" : DisExcelUtil.getCellValue(row.getCell(20)));
		} else {
			map.put("add_attr04", "");
		}

		if (!"부가속성05".equals(columnInfo.get("add_attr05"))) {
			map.put("add_attr05", row.getCell(21) == null ? "" : DisExcelUtil.getCellValue(row.getCell(21)));
		} else {
			map.put("add_attr05", "");
		}

		if (!"부가속성06".equals(columnInfo.get("add_attr06"))) {
			map.put("add_attr06", row.getCell(22) == null ? "" : DisExcelUtil.getCellValue(row.getCell(22)));
		} else {
			map.put("add_attr06", "");
		}

		if (!"부가속성07".equals(columnInfo.get("add_attr07"))) {
			map.put("add_attr07", row.getCell(23) == null ? "" : DisExcelUtil.getCellValue(row.getCell(23)));
		} else {
			map.put("add_attr07", "");
		}

		if (!"부가속성08".equals(columnInfo.get("add_attr08"))) {
			map.put("add_attr08", row.getCell(24) == null ? "" : DisExcelUtil.getCellValue(row.getCell(24)));
		} else {
			map.put("add_attr08", "");
		}

		if (!"부가속성09".equals(columnInfo.get("add_attr09"))) {
			map.put("add_attr09", row.getCell(25) == null ? "" : DisExcelUtil.getCellValue(row.getCell(25)));
		} else {
			map.put("add_attr09", "");
		}

		if (!"부가속성10".equals(columnInfo.get("add_attr10"))) {
			map.put("add_attr10", row.getCell(26) == null ? "" : DisExcelUtil.getCellValue(row.getCell(26)));
		} else {
			map.put("add_attr10", "");
		}
		
		if (!"부가속성11".equals(columnInfo.get("add_attr11"))) {
			map.put("add_attr11", row.getCell(27) == null ? "" : DisExcelUtil.getCellValue(row.getCell(27)));
		} else {
			map.put("add_attr11", "");
		}
		
		if (!"부가속성12".equals(columnInfo.get("add_attr12"))) {
			map.put("add_attr12", row.getCell(28) == null ? "" : DisExcelUtil.getCellValue(row.getCell(28)));
		} else {
			map.put("add_attr12", "");
		}
		
		if (!"부가속성13".equals(columnInfo.get("add_attr13"))) {
			map.put("add_attr13", row.getCell(29) == null ? "" : DisExcelUtil.getCellValue(row.getCell(29)));
		} else {
			map.put("add_attr13", "");
		}
		
		if (!"부가속성14".equals(columnInfo.get("add_attr14"))) {
			map.put("add_attr14", row.getCell(30) == null ? "" : DisExcelUtil.getCellValue(row.getCell(30)));
		} else {
			map.put("add_attr14", "");
		}
		
		if (!"부가속성15".equals(columnInfo.get("add_attr15"))) {
			map.put("add_attr15", row.getCell(31) == null ? "" : DisExcelUtil.getCellValue(row.getCell(31)));
		} else {
			map.put("add_attr15", "");
		}
		map.put("loginid", vUserId);
		return map;
	}

	/**
	 * @메소드명 : selectItemCatalogAttribute
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		CATALOG ATTRRIBUTE 해더를 받아옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> selectItemCatalogAttribute(CommandMap commandMap) {
		return createItemDAO.selectCatalogAttribute(commandMap.getMap());
	}

	/**
	 * @메소드명 : selectItemAllCatalog
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> selectItemAllCatalog(CommandMap commandMap) {
		return createItemDAO.selectItemAllCatalog(commandMap.getMap());
	}

	@Override
	public String itemAttributeCheck(CommandMap commandMap) throws Exception {
		
		String attrResult = "";
		List<Map<String, Object>> attrList = createItemDAO.itemAttributeCheck(commandMap.getMap());

		// 그리드에 있는 아이템 리스트를 LOOP를 돌려 각각 프로시저를 태운다.
		for (Map<String, Object> rowData : attrList) {
			attrResult += rowData.get("ATTRIBUTE_CODE") + ",";
		}
		
		return attrResult;
	}

	@Override
	public Map<String, Object> itemCloneAction(CommandMap commandMap) throws DisException {
		
		createItemDAO.itemCloneAction(commandMap.getMap());
		
		String sErrorMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
		String sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));

		// 오류가 있으면 스탑
		if (!"".equals(sErrorMsg)) {
			throw new DisException(sErrorMsg);
		}
		
		// 여기까지 Exception 없으면 성공 메시지
		commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
		
		return commandMap.getMap();
	}

	@Override
	public Map<String, Object> itemAttributeDelete(CommandMap commandMap) throws Exception {
		
		int isOk = createItemDAO.itemAttributeDelete(commandMap.getMap());
		
		if(isOk < 0){
			throw new Exception();
		}
		
		commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisConstants.RESULT_SUCCESS);
		return commandMap.getMap();
	}

}
