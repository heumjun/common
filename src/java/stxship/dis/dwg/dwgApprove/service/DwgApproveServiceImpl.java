package stxship.dis.dwg.dwgApprove.service;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMailUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.dwg.dwgApprove.dao.DwgApproveDAO;
import stxship.dis.dwg.dwgSystem.dao.DwgSystemDAO;

/**
 * @파일명 : DwgApproveServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgApprove에서 사용되는 서비스
 *     </pre>
 */
@Service("dwgApproveService")
public class DwgApproveServiceImpl extends CommonServiceImpl implements DwgApproveService {

	@Resource(name = "dwgApproveDAO")
	private DwgApproveDAO dwgApproveDAO;

	@Resource(name = "dwgSystemDAO")
	private DwgSystemDAO dwgSystemDAO;

	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;

	@Override
	public Map<String, String> dwgReturn(CommandMap commandMap) throws Exception {
		// 반려할 도면 list 가져오기
		List<Map<String, Object>> requiredDWGList = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		Map<String, Object> mailSendSeq = dwgSystemDAO.getDwgMailSendSeq(commandMap.getMap());
		String mailSendFrontSeq = mailSendSeq.get("seq").toString();

		String dwgMailSendSeq = mailSendFrontSeq;
		ArrayList<Object> dwgList = null;
		ArrayList<String> reqMailList = new ArrayList<String>();
		int result = 0;
		StringBuffer pro_no = new StringBuffer();

		for (Map<String, Object> rowData : requiredDWGList) {
			dwgList = new ArrayList<Object>();
			reqMailList.add(rowData.get("ep_mail") + "@onestx.com");
			rowData.put("dwgMailSendSeq", dwgMailSendSeq);
			List<Map<String, Object>> list = dwgApproveDAO.selectDwgRequestList(rowData);
			for (Map<String, Object> dwg_seq_id : list) {
				dwgList.add(dwgApproveDAO.selectOne("dwgApprove.getDwgInfo", dwg_seq_id));
			}
			for (Object rowData2 : dwgList) {
				pro_no.append(rowData.get("shp_no") + "-" + rowData.get("dwg_no") + ",");
				// 반려시 . STX_DWG_DW302TBL trnas_plm = R -> update
				result = dwgApproveDAO.update("dwgApprove.updateDwgReturn", rowData2);
				// 반려시 . STX_TBC_DWG_TRANS_DETAIL DWG_MAIL_SEND_SEQ =
				// dwgMailSendSeq UPDATE
				result = dwgApproveDAO.updateDwgReturnTransDetail(rowData);
			}
			// 반려시 . stx_dis_dwg_trans req_state = R - > update
			result = dwgApproveDAO.update("dwgApprove.updateDwgReturnTrans", rowData);

			// 지정된 메일 리시버에 eco_no 제거
			dwgApproveDAO.update("dwgApprove.updateEcoReceiverNull", rowData);
		}
		if (result == 0) {
		}
		// 중복된 요청자 제거
		@SuppressWarnings({ "rawtypes", "unchecked" })
		List<HashSet> newReqMailList = new ArrayList(new HashSet(reqMailList));

		// 승인자 메일 구하기
		commandMap.put("grantor", commandMap.get("p_userId"));
		Map<String, Object> eMail = dwgSystemDAO.select_grantor_epMail(commandMap.getMap());

		String from = eMail.get("ep_mail") + "@onestx.com";
		StringBuffer to = new StringBuffer();
		//2017.01.19 양동협 대리 요청으로 승인자는 메일 전송x
		//to.append(eMail.get("ep_mail") + "@onestx.com" + ",");
		for (int i = 0; i < newReqMailList.size(); i++) {
			to.append(newReqMailList.get(i) + ",");
		}

		List<Map<String, Object>> contentList = dwgSystemDAO.selectMailContent(dwgMailSendSeq);
		Template template = velocityEngine.getTemplate("./mailTemplate/requiredDwgMail.html", "UTF-8");
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put("conContent", "Return");
		velocityContext.put("contentList", contentList);
		StringWriter stringWriter = new StringWriter();
		template.merge(velocityContext, stringWriter);
		DisMailUtil.sendEmail(from, to.toString(), "", "전자도면 반려", stringWriter.toString());

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	public Map<String, String> dwgApprove(CommandMap commandMap) throws Exception {
		// 승인할 도면 list 가져오기
		List<Map<String, Object>> requiredDWGList = DisJsonUtil.toList(commandMap.get("chmResultList"));
		String dwg_url = "http://mfgdoc.stxship.co.kr/dwg/DwgPdfView.asp?DwgFile=";
		// 요청번호 따기+
		Map<String, Object> mailSendSeq = dwgSystemDAO.getDwgMailSendSeq(commandMap.getMap());
		String mailSendFrontSeq = mailSendSeq.get("seq").toString();
		String dwgMailSendSeq = mailSendFrontSeq;
		ArrayList<String> reqMailList = new ArrayList<String>();
		int result = 0;
		for (Map<String, Object> rowData : requiredDWGList) {
			reqMailList.add(rowData.get("ep_mail") + "@onestx.com");
			rowData.put("dwgMailSendSeq", dwgMailSendSeq);

			// mailReceiverList 가져오기
			rowData.put("REV_NO", rowData.get("dwg_rev"));
			rowData.put("DWG_NO", rowData.get("dwg_no"));

			// mailReceiverList =
			// dwgSystemDAO.selectList("Dwg.selectDWG_RECEIVER_USER",
			// rowData);
			String req_seq = (String) rowData.get("req_seq");

			// 승인시 . STX_DWG_DW302TBL trnas_plm = Y -> update 를 하기 위한 도면 list
			// 가져오기
			List<Map<String, Object>> list = dwgApproveDAO.selectDwgRequestList(rowData);
			for (Map<String, Object> rowData2 : list) {
				// STX_DWG_DW303TBL_PLM insert할 list 가져오기
				Map<String, Object> mapParam = dwgSystemDAO.selectOne("dwgApprove.selectDWG_Approve_302List", rowData2);
				mapParam.put("req_seq", req_seq);
				mapParam.put("dwg_url", dwg_url + mapParam.get("file_name"));
				mapParam.put("dwg_no", (String) mapParam.get("shp_no") + "-" + mapParam.get("dwg_no"));
				// 승인시 . STX_DWG_DW303TBL_PLM(key =stx_dis_dwg_trans의
				// req_seq('YYMMDDA001') -> insert
				result = dwgSystemDAO.insert("dwgApprove.insertSTX_DWG_DW303TBL_PLM", mapParam);
				// 302 update trans_plm = 'Y'
				result = dwgSystemDAO.update("dwgApprove.updateSTX_DWG_DW302TBL", rowData2);
				result = dwgApproveDAO.updateDwgReturnTransDetail(rowData);
			}

			// 승인시 . stx_dis_dwg_trans 승인자 , - > update
			result = dwgSystemDAO.update("dwgApprove.updateSTX_DIS_DWG_TRANS", rowData);

		} // end of for
		if (result == 0) {
		}
		// 중복된 요청자 제거
		@SuppressWarnings({ "rawtypes", "unchecked" })
		List<HashSet> newReqMailList = new ArrayList(new HashSet(reqMailList));

		// 승인자 메일 구하기
		commandMap.put("grantor", commandMap.get("p_userId"));
		Map<String, Object> eMail = dwgSystemDAO.select_grantor_epMail(commandMap.getMap());

		String from = eMail.get("ep_mail") + "@onestx.com";
		StringBuffer to = new StringBuffer();
		//2017.01.19 양동협 대리 요청으로 승인자는 메일 전송x
		//to.append(eMail.get("ep_mail") + "@onestx.com" + ",");
		for (int i = 0; i < newReqMailList.size(); i++) {
			to.append(newReqMailList.get(i) + ",");
		}

		List<Map<String, Object>> contentList = dwgSystemDAO.selectMailContent(dwgMailSendSeq);
		Template template = velocityEngine.getTemplate("./mailTemplate/requiredDwgMail.html", "UTF-8");
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put("conContent", "Approve");
		velocityContext.put("contentList", contentList);
		StringWriter stringWriter = new StringWriter();
		template.merge(velocityContext, stringWriter);
		DisMailUtil.sendEmail(from, to.toString(), "", "전자도면 승인통보", stringWriter.toString());

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	public View dwgApproveExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		// 그리드에서 받아온 엑셀 헤더를 설정한다.
		String[] p_col_names = commandMap.get("p_col_name").toString().split(",");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();
		// 그리드에서 받아온 데이터 네임을 배열로 설정
		String[] p_data_names = commandMap.get("p_data_name").toString().split(",");

		// 그리드의 헤더를 콜네임으로 설정
		for (String p_col_name : p_col_names) {
			colName.add(p_col_name);
		}

		List<Map<String, Object>> list = dwgApproveDAO.dwgApproveExcelExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {

			List<String> row = new ArrayList<String>();

			// 데이터 네임을 이용해서 리스트에서 뽑아냄.
			for (String p_data_name : p_data_names) {
				row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
			}
			colValue.add(row);

		}
		modelMap.put("excelName", "DwgApprove");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();

	}
}
