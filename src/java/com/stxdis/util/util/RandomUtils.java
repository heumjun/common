/*
 * @Class Name : RandomUtils.java
 * @Description : 랜덤 유틸 class
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
 * 랜덤 유틸.
 */
public class RandomUtils {

	/**
	 * 랜덤 key 생성.
	 *
	 * @param len the len
	 * @return the random key
	 */
	public static String getRandomKey(int len) {
		
		int nSeed = 0;
		int nSeedSize = 10;
		String strSrc = "0123456789";
		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < len; i++) {
			nSeed = (int) (Math.random() * nSeedSize + 1);
			sb.append(String.valueOf(strSrc.charAt(nSeed - 1)));
		}

		return sb.toString();
	}

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 */
	public static void main(String[] args) {

		System.out.println(getRandomKey(4));

	}

}
