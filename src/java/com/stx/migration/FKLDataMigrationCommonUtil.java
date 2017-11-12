/**
 * <pre>
 * 프로젝트명 : FKL-PLM-MIGRATION
 * 시스템명   : MIGRATION (COMMON MODULE)
 * 버전       : 1.0
 * 작성자     : 김혜수
 * 작성일자   : 2005/06/29
 * V 1.0      : 김혜수, 2005/06/29
 * </pre>
 * 기능       : Migration PGM에서 사용되는 static 유틸리티 메소드들을 정의
 * 사용처     : Migration PGM
 */
package com.stx.migration;
public class FKLDataMigrationCommonUtil 
{
    /**
     * <pre>
     * 기능 : 문자열이 의미 없는 값인지를 검사한다
     * 설명 : 입력받은 문자열 값이 null, "null", 또는 "" 이면 true를 리턴한다
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  : 검사할 문자열 값
     * @return : 검사할 문자열 값이 null, "null", 또는 "" 이면 true, 아니면 false
     */
    public static boolean isNullString(String arg) {
      
        if (arg == null || arg.equalsIgnoreCase("null") || arg.equals(""))
            return true;
        else 
            return false;
    }
    
    /**
     * <pre>
     * 기능 : 의미없는 문자열 값을 제외시킨다
     * 설명 : 의미없는 문자열 값(null, "null", 또는 ""(공백))을 제외시킨다
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  : 검사할 문자열 값
     * @return : 검사할 문자열 값이 null, "null", 또는 "" 이면 "", 아니면 trim()된 값
     */
    public static String getEfficientStringValue(String arg) {
      
        if (isNullString(arg)) return "";
        else return arg.trim();
    }
    
    /**
     * <pre>
     * 기능 : 의미없는 문자열 값을 제외시킨다
     * 설명 : 의미없는 문자열 값(null, "null", ""(공백), 그리고 지정된 값)을 제외시킨다
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  : 검사할 문자열 값
     * @param String[]  : 제외시킬 값
     * @return : 검사할 문자열 값이 null, "null", 또는 "" 이면 "", 아니면 trim()된 값을 리턴한다.
     *           추가로 파라미터로 넘어온 제외할 문자열 값들 중에 해당하는 경우 ""를 리턴한다.
     */
    public static String getEfficientStringValueExt(String arg, String[] escapeSeqs) {
      
        String str = getEfficientStringValue(arg);
        if (!str.equals("")) {
            for (int i = 0; i < escapeSeqs.length; i++) {
                if (str.equalsIgnoreCase(escapeSeqs[i])) {
                    str = "";
                    break;
                }
            }
        }
        
        return str;
    }
}
