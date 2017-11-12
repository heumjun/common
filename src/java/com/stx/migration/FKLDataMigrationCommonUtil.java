/**
 * <pre>
 * ������Ʈ�� : FKL-PLM-MIGRATION
 * �ý��۸�   : MIGRATION (COMMON MODULE)
 * ����       : 1.0
 * �ۼ���     : ������
 * �ۼ�����   : 2005/06/29
 * V 1.0      : ������, 2005/06/29
 * </pre>
 * ���       : Migration PGM���� ���Ǵ� static ��ƿ��Ƽ �޼ҵ���� ����
 * ���ó     : Migration PGM
 */
package com.stx.migration;
public class FKLDataMigrationCommonUtil 
{
    /**
     * <pre>
     * ��� : ���ڿ��� �ǹ� ���� �������� �˻��Ѵ�
     * ���� : �Է¹��� ���ڿ� ���� null, "null", �Ǵ� "" �̸� true�� �����Ѵ�
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  : �˻��� ���ڿ� ��
     * @return : �˻��� ���ڿ� ���� null, "null", �Ǵ� "" �̸� true, �ƴϸ� false
     */
    public static boolean isNullString(String arg) {
      
        if (arg == null || arg.equalsIgnoreCase("null") || arg.equals(""))
            return true;
        else 
            return false;
    }
    
    /**
     * <pre>
     * ��� : �ǹ̾��� ���ڿ� ���� ���ܽ�Ų��
     * ���� : �ǹ̾��� ���ڿ� ��(null, "null", �Ǵ� ""(����))�� ���ܽ�Ų��
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  : �˻��� ���ڿ� ��
     * @return : �˻��� ���ڿ� ���� null, "null", �Ǵ� "" �̸� "", �ƴϸ� trim()�� ��
     */
    public static String getEfficientStringValue(String arg) {
      
        if (isNullString(arg)) return "";
        else return arg.trim();
    }
    
    /**
     * <pre>
     * ��� : �ǹ̾��� ���ڿ� ���� ���ܽ�Ų��
     * ���� : �ǹ̾��� ���ڿ� ��(null, "null", ""(����), �׸��� ������ ��)�� ���ܽ�Ų��
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  : �˻��� ���ڿ� ��
     * @param String[]  : ���ܽ�ų ��
     * @return : �˻��� ���ڿ� ���� null, "null", �Ǵ� "" �̸� "", �ƴϸ� trim()�� ���� �����Ѵ�.
     *           �߰��� �Ķ���ͷ� �Ѿ�� ������ ���ڿ� ���� �߿� �ش��ϴ� ��� ""�� �����Ѵ�.
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
