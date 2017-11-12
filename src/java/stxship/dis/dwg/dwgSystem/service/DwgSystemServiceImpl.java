package stxship.dis.dwg.dwgSystem.service;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMailUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.dwg.dwgSystem.dao.DwgSystemDAO;

/**
 * @파일명 : DwgSystemServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgSystem에서 사용되는 서비스
 *     </pre>
 */
@Service("dwgSystemService")
public class DwgSystemServiceImpl extends CommonServiceImpl implements DwgSystemService {

	@Resource(name = "dwgSystemDAO")
	private DwgSystemDAO dwgSystemDAO;

	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> dwgReceiverCheck(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> requiredDWGList = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		String dwg_no = "|";
		String result = DisConstants.RESULT_SUCCESS;
		// 호선 도면 revision 으로 receiver가 지정되있는지 가져와서 도면이 초도인경우엔 수신자 지정 불필요, 초도가
		// 아닐경우엔 not required or 수신자 지정이 꼭 필요
		for (int i = 0; i < requiredDWGList.size(); i++) {
			Map<String, Object> rowData = requiredDWGList.get(i);
			rowData.put("DWG_NO", rowData.get("dwg_no"));

			List<Map<String, Object>> receiverList = dwgSystemDAO.selectList("mailReceiverList.list", rowData);
			String radioChk = rowData.get("radioChk") == null ? "" : rowData.get("radioChk").toString();
			if (!rowData.get("dwg_rev").equals("00") && !rowData.get("dwg_rev").equals("0A")) {
				if (radioChk.equals("") && receiverList.size() == 0) {
					result = DisConstants.RESULT_FAIL;
					dwg_no += " " + rowData.get("dwg_no") + "-" + rowData.get("dwg_rev") + " |";
				}
			}
		}
		Map<String, Object> returnResult = DisMessageUtil.getResultObjMessage(result);
		returnResult.put("dwg_no", dwg_no);

		return returnResult;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> requiredDWG(CommandMap commandMap) throws Exception {
		int result = 0;
		String frommail = (String) commandMap.get("userList");
		StringBuffer pro_no = new StringBuffer();
		List<Map<String, Object>> sendlist = null;
		// 요청보낼 도면 list 가져오기
		List<Map<String, Object>> requiredDWGList = DisJsonUtil
				.toList(commandMap.get((DisConstants.FROM_GRID_DATA_LIST)));
		String dept = (String) commandMap.get("dept");

		Map<String, Object> mailSendSeq = dwgSystemDAO.getDwgMailSendSeq(commandMap.getMap());
		String mailSendFrontSeq = mailSendSeq.get("seq").toString();
		String dwgMailSendSeq = mailSendFrontSeq;

		for (Map<String, Object> rowData : requiredDWGList) {
			// 중복체크
			String maxTransPlm = (String) dwgSystemDAO.selectOne("requiredDWG.duplicationList", rowData);
			maxTransPlm = maxTransPlm == null ? "" : maxTransPlm;
			if (maxTransPlm.equals("S")) {
				// 요청중인 도면입니다. 재조회하세요
				throw new DisException("dwg.message1");
			} else if (maxTransPlm.equals("Y")) {
				// Release 도면입니다. 재조회하세요
				throw new DisException("dwg.message2");
			} else {
				// 시퀀스 따기(YYMMDD9SEQ(140610A001))
				Map<String, Object> reqSeq = dwgSystemDAO.selectOne("requiredDWG.getDwgTransSeq", commandMap.getMap());

				String del_dwg_seq_id = (String) commandMap.get("del_dwg_seq_id");
				StringBuffer sb = new StringBuffer();
				String dwg_seq_id[] = null;
				sb.append(del_dwg_seq_id.split(","));
				if (!del_dwg_seq_id.equals("") || del_dwg_seq_id == null) {
					dwg_seq_id = del_dwg_seq_id.split(",");
				}

				String dwgTransSeq = (String) reqSeq.get("eco_no");
				String userList = (String) commandMap.get("userList");

				String grantor = (String) commandMap.get("grantor");
				String reqdept = (String) commandMap.get("dept");
				String reqSabun = userList.substring(4, 10);

				Map<String, Object> receiver_id = dwgSystemDAO.selectOne("requiredDWG.selectECO_RECEIVER", rowData);
				pro_no.append(rowData.get("shp_no") + "-" + rowData.get("dwg_no") + ",");
				rowData.put("dept", dept);

				// 요청 보낼 도면의 도면 list 가져오기 if(return의 경우 returnChk 가 체크되서 전Rev 도면
				// 요청과 같은 도면을 요청하고 싶을 경우 조건 'R' 추가
				if (rowData.get("returnChk").equals("Y")) {
					sendlist = dwgSystemDAO.selectList("requiredDWG.selectDwgReturnInfo", rowData);
				} else {
					sendlist = dwgSystemDAO.selectList("requiredDWG.dwgMailContentList", rowData);
					if (dwg_seq_id != null) {
						for (int i = 0; i < dwg_seq_id.length; i++) {
							String delDwg = dwg_seq_id[i];
							for (int j = 0; j < sendlist.size(); j++) {
								Map<String, Object> rowData2 = sendlist.get(j);
								String bbb = String.valueOf(rowData2.get("dwg_seq_id"));
								if (delDwg.equals(bbb)) {
									sendlist.remove(j);
									dwgSystemDAO.update("requiredDWG.updateRequiredNull", delDwg);
									break;
								}
							}
						}
					}
				}
				// list를 요청 테이블에 insert 및 302테이블에 S로 UPDATE
				rowData.put("dwgTransSeq", dwgTransSeq);
				rowData.put("reqSabun", reqSabun);
				rowData.put("grantor", grantor);
				rowData.put("reqdept", reqdept);
				rowData.put("mail_receiver", rowData.get("radioChk"));

				String receiverId = "";
				if (receiver_id != null) {
					// 메일 지정자가 있을경우 ECO UPDATE
					receiverId = receiver_id.get("receiver_id").toString();
					rowData.put("receiver_id", receiverId);
					dwgSystemDAO.update("requiredDWG.updateReceiverECO", rowData);
				} else {
					rowData.put("receiver_id", receiverId);
				}

				rowData.put("resSabun", commandMap.get("grantor"));
				rowData.put("dwgMailSendSeq", dwgMailSendSeq);
				result = dwgSystemDAO.insert("requiredDWG.insertDwgTrans", rowData);
				for (Map<String, Object> rowData2 : sendlist) {
					rowData2.put("dwgTransSeq", dwgTransSeq);
					rowData2.put("dwgMailSendSeq", dwgMailSendSeq);

					result = dwgSystemDAO.insert("requiredDWG.insertDwgTransDetail", rowData2);
					result = dwgSystemDAO.update("requiredDWG.updateRequiredDWG", rowData2);
				}
			}
		}
		if (result == 0) {

		}
		// 승인자의 이메일 받아오기
		Map<String, Object> eMail = dwgSystemDAO.select_grantor_epMail(commandMap.getMap());
		// 메일보내기
		String to = eMail.get("ep_mail") + "@onestx.com" + "," + frommail.substring(11, frommail.length())
				+ "@onestx.com";
		String from = frommail.substring(11, frommail.length()) + "@onestx.com";
		List<Map<String, Object>> contentList = dwgSystemDAO.selectMailContent(dwgMailSendSeq);
		Template template = velocityEngine.getTemplate("./mailTemplate/requiredDwgMail.html", "UTF-8");
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put("conContent", "Required");
		velocityContext.put("contentList", contentList);
		StringWriter stringWriter = new StringWriter();
		template.merge(velocityContext, stringWriter);
		DisMailUtil.sendEmail(from, to, "", "전자도면 배포요청", stringWriter.toString());

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	public String selectView(CommandMap commandMap) throws Exception {
		StringBuffer pml_Code = new StringBuffer();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("emp_no", commandMap.get("vEmpNo"));
		if ("dwgView".equals(commandMap.get("VIEWMODE"))) {
			param.put("file_name", commandMap.get("P_FILE_NAME"));
			dwgSystemDAO.selectOne("selectView.procedureDwgViewSEQ", param);
			dwgSystemDAO.selectOne("selectView.procedureDwgViewXML", param);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("P_PML_CODE");
			for (Map<String, Object> rowData : list) {
				pml_Code.append(rowData.get("PML_CODE"));
			}
		} else {
			// 도면 Print Seq 추출
			dwgSystemDAO.selectOne("selectView.procedureCheckDWGViewSEQ", param);
			StringTokenizer st = new StringTokenizer((String) commandMap.get("P_FILE_NAME"), "|");
			while (st.hasMoreTokens()) {
				param.put("file_name", st.nextToken());
				// 도면 Print table에 Print Seq 별 선택된 도면파일명 저장
				dwgSystemDAO.selectOne("selectView.procedureCheckDwgHistory", param);
			}
			dwgSystemDAO.selectOne("selectView.procedureCheckDwgViewXML", param);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("P_PML_CODE");
			for (Map<String, Object> rowData : list) {
				pml_Code.append(rowData.get("PML_CODE"));
			}
		}
		return pml_Code.toString();
	}

	@Override
	public List<Map<String, Object>> modifyMailReceiver(CommandMap commandMap) throws Exception {
		String DWG = commandMap.get("h_ShipNo") + "-" + commandMap.get("h_DwgNo");
		commandMap.put("DWG", DWG);
		List<Map<String, Object>> selectSeriesProject = dwgSystemDAO.selectList("selectDWGSeriesERP.list",
				commandMap.getMap());
		return selectSeriesProject;
	}

	@Override
	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		if ("modifyMailReceiverList".equals(map.get(DisConstants.MAPPER_NAME))) {
			map.put("DWG_PROJECT_NO", DisStringUtil.nullString(map.get("h_ShipNo")));
			map.put("shp_no", DisStringUtil.nullString(map.get("shp_no")));
			map.put("DWG_NO", DisStringUtil.nullString(map.get("h_DwgNo")));
			map.put("REV_NO", DisStringUtil.nullString(map.get("dwg_rev")));
			map.put("PROJECT_NO", DisStringUtil.nullString(map.get("shipNo")));
			List<Map<String, Object>> mlHistory = dwgSystemDAO.selectList("selectDWGPringSummaryList.list", map);

			List<Map<String, Object>> mlExist = dwgSystemDAO.selectList("mailReceiverList.list", map);
			List<Map<String, Object>> list = getCheckExist(mlHistory, mlExist);
			return list;
		} else {
			return super.getGridData(map);
		}

	}

	/**
	 * AIL_RECEIVER 수정 시 RECEIVER LIST 가져와서 중복된 데이터를 지운다.
	 * 
	 * @param Map
	 *            mlHistory
	 * @param Map
	 *            mlExist
	 * @return ModelAndView
	 */
	public List<Map<String, Object>> getCheckExist(List<Map<String, Object>> mlHistory,
			List<Map<String, Object>> mlExist) {
		Iterator<Map<String, Object>> itrHistory = mlHistory.iterator();
		while (itrHistory.hasNext()) {
			Map<String, Object> mapHistory = itrHistory.next();
			String EMAIL = (String) mapHistory.get("email");
			String PROJECT_NO = (String) mapHistory.get("project_no");
			Iterator<Map<String, Object>> itrExist = mlExist.iterator();
			mapHistory.put("CHECKED", "FALSE");
			while (itrExist.hasNext()) {
				Map<String, Object> mapExist = itrExist.next();
				String EMAIL_E = (String) mapExist.get("email");
				String PROJECT_NO_E = (String) mapExist.get("project_no");
				// if(EMAIL_E.equals(EMAIL))
				if (EMAIL_E.equals(EMAIL) && PROJECT_NO.equals(PROJECT_NO_E)) {
					mlExist.remove(mapExist);
					mapHistory.put("CHECKED", "TRUE");
					break;
				}

			}
		}

		Iterator<Map<String, Object>> itrExist = mlExist.iterator();
		while (itrExist.hasNext()) {
			Map<String, Object> mapExist = itrExist.next();
			mlHistory.add(mapExist);
		}
		return mlHistory;
	}

	@Override
	public Map<String, String> delDWGReceiverGroup(CommandMap commandMap) throws Exception {
		dwgSystemDAO.delete("delDWGReceiverGroup.delete_STX_DWG_RECEIVER_GROUP_HEAD", commandMap.getMap());
		dwgSystemDAO.delete("delDWGReceiverGroup.delete_STX_DWG_RECEIVER_GROUP_DETAIL", commandMap.getMap());
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	public Map<String, String> saveDWGMailReceiver(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveDWGMailReceiverList = DisJsonUtil
				.toList(commandMap.get((DisConstants.FROM_GRID_DATA_LIST)));

		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("MASTER_PROJECT_NO", commandMap.get("h_ShipNo"));
		mapParam.put("DWG_NO", commandMap.get("h_DwgNo"));
		mapParam.put("REV_NO", commandMap.get("dwg_rev"));
		mapParam.put("ECO_NO", "");
		mapParam.put("DESCRIPTION", commandMap.get("description"));
		mapParam.put("CREATED_BY", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		mapParam.put("LAST_UPDATED_BY", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		mapParam.put("LAST_UPDATE_LOGIN", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		mapParam.put("CAUSEDEPT", commandMap.get("causedept"));

		mapParam.put("WORK_STAGE", commandMap.get("p_work_stage"));
		mapParam.put("WORK_TIME", commandMap.get("p_work_time"));
		mapParam.put("USER_LIST", commandMap.get("p_user_list"));
		mapParam.put("ITEM_ECO_NO", commandMap.get("p_item_eco_no"));
		mapParam.put("ECR_NO", commandMap.get("p_ecr_no"));
		mapParam.put("ECO_EA", commandMap.get("p_eco_ea"));

		Map<String, Object> mlID = dwgSystemDAO.selectOne("saveDWGMailReceiver.selectDWG_RECEIVER_ID", mapParam);
		// String.valueOf(mlID.get("RECEIVER_ID"));
		String RECEIVER_ID = DisStringUtil.nullString(mlID.get("RECEIVER_ID"));
		// String.valueOf(mlID.get("RECEIVER_ID_EXIST"));
		String RECEIVER_ID_EXIST = DisStringUtil.nullString(mlID.get("RECEIVER_ID_EXIST"));
		mapParam.put("RECEIVER_ID", RECEIVER_ID);
		if (!RECEIVER_ID_EXIST.equals("")) {
			dwgSystemDAO.delete("saveDWGMailReceiver.delSTX_DWG_ECO_RECEIVER_USER", mapParam);
			dwgSystemDAO.update("saveDWGMailReceiver.updateSTX_DWG_ECO_RECEIVER", mapParam);
		} else {
			dwgSystemDAO.insert("saveDWGMailReceiver.addSTX_DWG_ECO_RECEIVER", mapParam);
		}
		for (Map<String, Object> rowData : saveDWGMailReceiverList) {
			if (rowData.get("project_no").equals("") || rowData.get("project_no").equals(null)) {
				rowData.put("project_no", commandMap.get("chkList"));
			}
			Map<String, Object> mapAdd = new HashMap<String, Object>();
			mapAdd.put("RECEIVER_ID", RECEIVER_ID);
			mapAdd.put("PROJECT_NO", rowData.get("project_no"));
			mapAdd.put("EMAIL_ADRESS", rowData.get("email"));
			mapAdd.put("AFTER_WORKING_YN", "N");
			mapAdd.put("RECEIVER_NAME", rowData.get("print_user_name"));
			mapAdd.put("RECEIVER_DEPT", rowData.get("print_dept_id"));
			mapAdd.put("RECEIVER_TYPE", rowData.get("user_type"));
			mapAdd.put("RECEIVER_EMPNO", rowData.get("print_user_id"));
			mapAdd.put("CREATED_BY", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			mapAdd.put("LAST_UPDATED_BY", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			mapAdd.put("LAST_UPDATE_LOGIN", -1);
			mapAdd.put("DRAWING_SATAUS", rowData.get("drawing_status"));
			dwgSystemDAO.insert("saveDWGMailReceiver.addSTX_DWG_ECO_RECEIVER_USER", mapAdd);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	public Map<String, String> saveMailReceiverGroup(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveMailReceiverGroupList = DisJsonUtil
				.toList(commandMap.get((DisConstants.FROM_GRID_DATA_LIST)));

		String description = (String) commandMap.get("groupName");

		// group sequence 따기
		String seq = dwgSystemDAO.selectOne("saveMailReceiverGroup.getSeqNextVal", commandMap.getMap());

		Map<String, Object> mapParam = new HashMap<String, Object>();
		// 세션처리해서 현재 접속한 사람의 emp_no를 넣어준다
		mapParam.put("user", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		mapParam.put("group_id", seq);
		mapParam.put("description", description);

		dwgSystemDAO.insert("saveMailReceiverGroup.addSTX_DWG_RECEIVER_GROUP_HEAD", mapParam);
		int duplicationCnt;
		for (Map<String, Object> rowData : saveMailReceiverGroupList) {
			rowData.put("group_id", seq);
			rowData.put("user", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			duplicationCnt = dwgSystemDAO.selectOne("saveMailReceiverGroup.duplicate", rowData);
			if (duplicationCnt == 0) {
				dwgSystemDAO.insert("saveMailReceiverGroup.addSTX_DWG_RECEIVER_GROUP_DETAIL", rowData);
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	@Override
	public Map<String, String> dwgRevisionCancel(CommandMap commandMap) {
		//REVISION 삭제 시작
		dwgSystemDAO.dwgRevisionCancelItem(commandMap.getMap());
		dwgSystemDAO.dwgRevisionCancelMarkno(commandMap.getMap());
		dwgSystemDAO.dwgRevisionCancelSymbol(commandMap.getMap());
		dwgSystemDAO.dwgRevisionCancelMain(commandMap.getMap());
		
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	@Override
	public List<Map<String, Object>> selectDpDpspFlag(CommandMap commandMap) throws Exception {
		return dwgSystemDAO.selectDpDpspFlag(commandMap.getMap());
	}
	
	@Override
	public List<Map<String, Object>> selectDwgDeptCode(CommandMap commandMap) throws Exception {
		return dwgSystemDAO.selectDwgDeptCode(commandMap.getMap());
	}
}
