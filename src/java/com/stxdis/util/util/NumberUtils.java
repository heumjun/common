/*
 * @Class Name : NumberUtils.java
 * @Description : org.springframework.util.NumberUtils extends  메소드 추가
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2013.12.26    배동오         최초 생성
 *
 * @author 배동오
 * @since 2013.12.26
 * @version 1.0
 * @see
 */
package com.stxdis.util.util;




// TODO: Auto-generated Javadoc
/**
 * The Class StringUtils.
 */
public class NumberUtils extends org.springframework.util.NumberUtils{

	
	/**값이 가장 큰 데이터를 찾는다**/
	public static double getMaxvalue(double a , double b){
		double returnValue = 0;
		if(a > b){
			returnValue = a;
		}else{
			returnValue = b;
		}
		
		return returnValue;
	}

	/**값이 가장 작은 데이터를 찾는다**/
	public static double getMinvalue(double a , double b){
		double returnValue = 0;
		if(a < b && returnValue == 0){
			returnValue = a;
		}else{
			returnValue = b;
		}
		
		return returnValue;
	}
	


	/**값이 가장 작은 데이터를 찾는다**/
	public static double getNotZeroMinvalue(double a , double b){
		double returnValue = 0;
		if(b != 0){	
			if(a < b && returnValue == 0){
				returnValue = a;
			}else{
				returnValue = b;
			}
		}else{
			return a;
		}
		
		return returnValue;
	}
	
}