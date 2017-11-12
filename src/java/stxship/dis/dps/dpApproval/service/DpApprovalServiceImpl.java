package stxship.dis.dps.dpApproval.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpApproval.dao.DpApprovalDAO;

import com.stxdis.util.util.StringUtil;

/**
 * @파일명 : DpApprovalServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpApproval에서 사용되는 서비스
 *     </pre>
 */
@Service("dpApprovalService")
public class DpApprovalServiceImpl extends DpsCommonServiceImpl implements DpApprovalService {

	@Resource(name = "dpApprovalDAO")
	private DpApprovalDAO dpApprovalDAO;
	
	/**
	 * 
	 * @메소드명	: getPartDPConfirmsList
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 결제 현황
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List getPartDPConfirmsList(CommandMap commandMap) throws Exception {
		try{
			return dpApprovalDAO.getPartDPConfirmsList(commandMap.getMap());	
		}catch(Exception e){
			List<Map<String,Object>> returnV = new ArrayList<Map<String,Object>>();
			Map<String,Object> temp = new HashedMap();
			temp.put("error", "error");
			temp.put("error_msg", e.getMessage());
			returnV.add(temp);
			return returnV;
		}
	}
	
	/**
	 * 
	 * @메소드명	: getPartDPInputRateList
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력률
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List getPartDPInputRateList(CommandMap commandMap) throws Exception {
		try{
			return dpApprovalDAO.getPartDPInputRateList(commandMap.getMap());
		}catch(Exception e){
			List<Map<String,Object>> returnV = new ArrayList<Map<String,Object>>();
			Map<String,Object> temp = new HashedMap();
			temp.put("error", "error");
			temp.put("error_msg", e.getMessage());
			returnV.add(temp);
			return returnV;
		}
	}
	
	/**
	 * 
	 * @메소드명	: getDwgDeptGubun
	 * @날짜		: 2016. 9. 22.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 부서의 종류(상선, 해양, 특수선)를 판단 - TODO (현재는 해양부서 여부만 Hard Code 로 판단)
	 * </pre>
	 * @param Map
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getDwgDeptGubun(CommandMap commandMap) throws Exception {
		int resultValue = 0;
		String deptCode = String.valueOf(commandMap.get("dept_code"));
		if (!StringUtil.isNullString(deptCode) && deptCode.equals("938000")) resultValue = 1;
        if (!StringUtil.isNullString(deptCode) && deptCode.substring(0, 1).equals("9")) resultValue = 2;

        return String.valueOf(resultValue);
	}
	
	/**
	 * 
	 * @메소드명	: dpApprovalMainGridSave
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * saveApprovals() : 시수결재 사항을 DB에 저장 + 공정 시수 업데이트 + 시수마감
	 * 2015-10-06 : PLM_DESIGN_MH_CLOSE_PROC가 saveApprovals()에서 수행하던 시수결재 저장, 공정 시수 업데이트, 시수마감 등 수행
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> dpApprovalMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		////boolean isMarine = (getDwgDeptGubun(commandMap).equals("2") ? true : false); // 해양부서인지 여부
		List<Map<String,Object>> designerIDList = new ArrayList<Map<String,Object>>();
		String mh_close_approveList = "";// 시수마감을 위한 결재 승인 대상리스트
		String mh_close_cancelList = "";// 시수마감을 위한 결재 취소 대상리스트		
		 String resultMsg = "";
		try{
			
			for (Map<String, Object> rowData : saveList) {
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				rowData.put("dateselected", commandMap.get("dateselected"));				

				// 시수결재 대상은 시수마감 대상으로, 시수결재 제외 대상은 시수마감 취소 대상.
				if(String.valueOf(rowData.get("confirm_yn")).equals("Y")){
					if ("".equals(mh_close_approveList))
					{
						mh_close_approveList = (String) rowData.get("employee_num");
					} else {
						mh_close_approveList += ","+(String) rowData.get("employee_num");
					}
				} else {
					if ("".equals(mh_close_cancelList))
					{
						mh_close_cancelList = (String) rowData.get("employee_num");
					} else {
						mh_close_cancelList += ","+(String) rowData.get("employee_num");
					}
				}
			}
			
			// 2015-03-17 : PLM 시수 결재시 일단위 마감 PROCEDURE 호출
			String returnFlag = "";
			if(!"".equals(mh_close_approveList))
			{
				Map<String,Object> procedureParam = new HashMap<String,Object>();
				procedureParam.put("dateselected", commandMap.get("dateselected"));
				procedureParam.put("mh_close",mh_close_approveList);
				procedureParam.put("number","1");
				procedureParam.put("loginId",commandMap.get("loginId"));
				dpApprovalDAO.plmConfirmProcedure(procedureParam);
				returnFlag = (String) (procedureParam.get("resultFlag") == null ? "" : procedureParam.get("resultFlag")) ;
			}
			if(!"".equals(mh_close_cancelList))
			{
				Map<String,Object> procedureParam = new HashMap<String,Object>();
				procedureParam.put("dateselected", commandMap.get("dateselected"));
				procedureParam.put("mh_close",mh_close_cancelList);
				procedureParam.put("number","2");
				procedureParam.put("loginId",commandMap.get("loginId"));
				dpApprovalDAO.plmConfirmProcedure(procedureParam);
				returnFlag = (String) (procedureParam.get("resultFlag") == null ? "" : procedureParam.get("resultFlag")) ;
			}
			
			if(!"Y".equals(returnFlag))
			{
				return DisMessageUtil.getResultMessage("처리실패:MH CLOSE ERROR",DisConstants.RESULT_FAIL);
			}

			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		} catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
	}
	
	/**
	 * 
	 * @메소드명	: getDwgMH_Overtime
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 도면 별 계획시수 대비 실적시수 초과사항 쿼리
	 * </pre>
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Override
	public List getDwgMH_Overtime(Map param) throws Exception {
		return dpApprovalDAO.getDwgMH_Overtime(param);
	}
	

}
