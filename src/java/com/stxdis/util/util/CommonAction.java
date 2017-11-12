package com.stxdis.util.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Session;


public class CommonAction {
	
	public static final String DELETE_OPER_SUCC  = "Data Delete Success!!";

	public static final String DELETE_OPER_FAIL  = "Data Delete Fail!!";
	
	public static final String INSERT_OPER_SUCC  = "Data Insert Success!!";

	public static final String INSERT_OPER_FAIL  = "Data Insert Fail!!";
	
	public static final String UPDATE_OPER_SUCC  = "Data Update Success!!";

	public static final String UPDATE_OPER_FAIL  = "Data Update Fail!!";
	
	public static final String OPER_EXIST_DATA   = "Data Already Exist!!";
	
	public static final String OPER_DEFAULT_SUCC = "Success!!";
	
	public static final String OPER_DEFAULT_FAIL = "Fail!!";
	
	public static final String ITEM_ERR1		 = "해당 Part Family의 ShipType은 필수 입력입니다.";
	
	public static final String ITEM_ERR2		 = "표준품 물성치 속성값 중 선택안한 항목이 있습니다!\n확인 후 다시 진행하시기 바랍니다";
		
	public static final String ITEM_ERR3		 = "ITEM 채번 리스트 중 확정현황 내 중복 속성값이 존재합니다!\n확인 후 다시 진행하시기 바랍니다.";
	
	public static final String ITEM_CREATE1		 = "{0}건의 ITEM이 정상적으로 생성되었습니다.";
	
	public static final String COMMON_MASSAGE1	 = "{0}이 이미 존재합니다.";
	
	public static final String COMMON_MASSAGE2	 = "{0}호선은 현재 진행중인 REVISION이 존재합니다.";
	
	public static final String COMMON_MASSAGE3	 = "{0}의 Loss Code가 존재하지 않습니다.";
	
	public static final String COMMON_MASSAGE4	 = "이미 존재하는 {0}입니다.";
	
	public static final String COMMON_MASSAGE5	 = "{0}가 존재하지 않습니다.";
	
	public static final String COMMON_MASSAGE6	 = "Excel Data 오류가 발생했습니다.";
	
	public static final String COMMON_MASSAGE7	 = "{0}의 {1}가  이미 등록 되었습니다.";
	
	public static final String COMMON_MASSAGE8	 = "{0}건  확정 되었습니다.";
	
	public static final String COMMON_MASSAGE9	 = "{0}건 확정 해제 되었습니다.";
	
	public static final String COMMON_MASSAGE10	 = "{0} 이미 확정 되었습니다.";
	
	public static final String COMMON_MASSAGE11	 = "{0}건 삭제 되었습니다.";
	
	
	public static final String PAINT_MASSAGE1	 = "{0} Loss Cdoe의 {1} SET {2} Count는 이미 존재 합니다.";
	
	public static final String PAINT_MASSAGE2	 = "{0} Block Code의 {1} Area Code가 이미 존재 합니다.";
	
	public static final String PAINT_MASSAGE3	 = "{0} Area Code가 존재하지 않습니다.";
	
	public static final String PAINT_MASSAGE4	 = "{0} Zone Code의 {1} Area Code가 존재하지 않습니다.";
	
	public static final String PAINT_MASSAGE5	 = "{0} Zone Code의 {1} Area Code가 이미 존재 합니다.";
	
	public static final String PAINT_MASSAGE6	 = "{0} PE Code의 {1} Block Code가 이미 존재 합니다.";
	
	public static final String PAINT_MASSAGE7	 = "{0} Block Code가 존재하지 않습니다.";
	
	public static final String PAINT_MASSAGE8	 = "{0} 회차의 {1} Season Code가 이미 존재 합니다.";
	
	public static final String PAINT_MASSAGE9	 = "{0} Pattern Code의 {1} Area Code가 이미 존재 합니다.";
	
	public static final String PAINT_MASSAGE10	 = "{0} {1} 존재하지 않습니다.";
		
	public static final String PAINT_MASSAGE11	 = "PAINT ITEM : {0}은 이미 추가 되었습니다.";
	
	public static final String PAINT_MASSAGE12	 = "{0}의 상태가 {1}입니다.\n Paint Import 불가 합니다.";
	
	public static final String PAINT_MASSAGE13	 = "{0}의 DESC : {1}은 이미 존재합니다.";
	
	public static final String PAINT_MASSAGE14	 = "AREA {0}은 이미 사용중입니다.\n저장 불가 합니다.";
	
	public static final String ECR_ECO_MAPPING_ERR1 = "ECO Name {0}의 원인코드 Mapping 정보가 일치하지 않습니다.";
	
	@SuppressWarnings("unchecked")
	public static ArrayList DBOperation(String result, String sqlType) {
		
		ArrayList arr = new ArrayList();
		Map 	  map = new HashMap() ;
		
		map.put("result", 	 	result);
		
		if (result.equals("success"))
		{
			//map.put("Result_Msg", 	sqlType == "I" ? INSERT_OPER_SUCC : (sqlType == "U" ? UPDATE_OPER_SUCC : (sqlType == "D" ? DELETE_OPER_SUCC : OPER_DEFAULT_SUCC )));
			map.put("Result_Msg", 	OPER_DEFAULT_SUCC);
		}
		else if (result.equals("fail"))
		{
			//map.put("Result_Msg", 	sqlType == "I" ? INSERT_OPER_FAIL : (sqlType == "U" ? UPDATE_OPER_FAIL : (sqlType == "D" ? DELETE_OPER_FAIL : OPER_DEFAULT_FAIL )));
			map.put("Result_Msg", 	OPER_DEFAULT_FAIL);
		}
		else if (result.equals("duplication"))
		{
			map.put("Result_Msg", 	OPER_EXIST_DATA);
		}
		else
		{
			map.put("Result_Msg", 	"");
		}
				
		arr.add(map);
		
		return arr;
	}
	
	@SuppressWarnings("unchecked")
	public static ArrayList DBOperation(String result, String errGbn, String params) {
		ArrayList arr = new ArrayList();
		Map 	  map = new HashMap() ;
		
		map.put("result", 	 	result);
		map.put("Result_Msg", 	getErrorMassage(errGbn,params));
		
		arr.add(map);
		
		return arr;
	}
	
	public static String getErrorMassage(String errGbn, String params) {
		String massage = "";
		
		if (errGbn.equals("item_err1"))
		{
			massage = ITEM_ERR1;
		} 
		else if (errGbn.equals("item_err2"))
		{
			massage = ITEM_ERR2;
		} 
		else if (errGbn.equals("item_err3"))
		{
			massage = ITEM_ERR3;
		} 
		else if (errGbn.equals("item_create1")) 
		{
			massage = ITEM_CREATE1;
		} 
		else if (errGbn.equals("common_massage1")) 
		{
			massage = COMMON_MASSAGE1;
		} 
		else if (errGbn.equals("common_massage2")) 
		{
			massage = COMMON_MASSAGE2;
		}
		else if (errGbn.equals("common_massage3")) 
		{
			massage = COMMON_MASSAGE3;
		}
		else if (errGbn.equals("common_massage4")) 
		{
			massage = COMMON_MASSAGE4;
		}
		else if (errGbn.equals("common_massage5")) 
		{
			massage = COMMON_MASSAGE5;
		}
		else if (errGbn.equals("common_massage6")) 
		{
			massage = COMMON_MASSAGE6;
		}
		else if (errGbn.equals("common_massage7")) 
		{
			massage = COMMON_MASSAGE7;
		}
		else if (errGbn.equals("common_massage8")) 
		{
			massage = COMMON_MASSAGE8;
		}
		else if (errGbn.equals("common_massage9")) 
		{
			massage = COMMON_MASSAGE9;
		}
		else if (errGbn.equals("common_massage10")) 
		{
			massage = COMMON_MASSAGE10;
		}
		else if (errGbn.equals("common_massage11")) 
		{
			massage = COMMON_MASSAGE11;
		}
		else if (errGbn.equals("update_succ")) 
		{
			massage = UPDATE_OPER_SUCC;
		}
		else if (errGbn.equals("duplication"))
		{
			massage = OPER_EXIST_DATA;
		}
		else if (errGbn.equals("paint_massage1"))
		{
			massage = PAINT_MASSAGE1;
		}
		else if (errGbn.equals("paint_massage2")) 
		{
			massage = PAINT_MASSAGE2;
		}
		else if (errGbn.equals("paint_massage3")) 
		{
			massage = PAINT_MASSAGE3;
		}
		else if (errGbn.equals("paint_massage4")) 
		{
			massage = PAINT_MASSAGE4;
		}
		else if (errGbn.equals("paint_massage5")) 
		{
			massage = PAINT_MASSAGE5;
		}
		else if (errGbn.equals("paint_massage6")) 
		{
			massage = PAINT_MASSAGE6;
		}
		else if (errGbn.equals("paint_massage7")) 
		{
			massage = PAINT_MASSAGE7;
		}
		else if (errGbn.equals("paint_massage8")) 
		{
			massage = PAINT_MASSAGE8;
		}
		else if (errGbn.equals("paint_massage9")) 
		{
			massage = PAINT_MASSAGE9;
		}
		else if (errGbn.equals("paint_massage10")) 
		{
			massage = PAINT_MASSAGE10;
		}
		else if (errGbn.equals("paint_massage11")) 
		{
			massage = PAINT_MASSAGE11;
		}
		else if (errGbn.equals("paint_massage12")) 
		{
			massage = PAINT_MASSAGE12;
		} 
		else if (errGbn.equals("paint_massage13")) 
		{
			massage = PAINT_MASSAGE13;
		} 
		else if (errGbn.equals("paint_massage14")) 
		{
			massage = PAINT_MASSAGE14;
		} 
		else if (errGbn.equals("mapping"))
		{
			massage = ECR_ECO_MAPPING_ERR1;
		}
		else
		{
			massage = errGbn;
		}
			
		if (params != null && !"".equals(params)) {
			
			String[] temp = params.split(",");
			
			for(int i=0; i<temp.length;i++) {
				massage = massage.replaceAll("\\{"+i+"\\}",  temp[i]);
			}
		}
		
		
		return massage;
	}
    
}




