package stxship.dis.common.util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

@SuppressWarnings("restriction")
public class DisCodeUtil {
	// EP Parameter 전송 복호화 변수
	private static final String ENC_PARA_FORMAT = "DES/CBC/PKCS5Padding";
	// 각 사 또는 시스템별로 정의된 KEY (EP와 정의된 값 ) : 조선해양
	private static final String PARA_KEY = "STX^ONS7";
	// 각 사 또는 시스템별로 정의된 IV ( EP와 정의된값 ) : 조선해양
	private static final String IV = "OS$37INF";

	// EP Cookie 복호화 변수
	private static final String ENC_COOKIE_FORMAT = "DES/ECB/PKCS5Padding";
	private static final String COOKIE_KEY = "Forcetec"; // ONESTX EP 공통 KEY

	private static final String UTF_8 = "UTF-8";

	private static BASE64Decoder DECORDER = new BASE64Decoder();
	private static BASE64Encoder ENCORDER = new BASE64Encoder();

	public static String decrypt(String value) {
		SecretKeySpec SecureKey = new SecretKeySpec(PARA_KEY.getBytes(), "DES");
		IvParameterSpec InitialVector = new IvParameterSpec(IV.getBytes());
		String decrypt = "";
		try {
			Cipher dcipher = Cipher.getInstance(ENC_PARA_FORMAT);
			// ciphers 생성
			dcipher.init(Cipher.DECRYPT_MODE, SecureKey, InitialVector);
			// EP
			byte[] dec = DECORDER.decodeBuffer(value);
			// Decrypt
			byte[] byte_dec = dcipher.doFinal(dec);
			decrypt = new String(byte_dec, UTF_8);
		} catch (Exception e) {
			System.out.println("decrypt==>" + e.getMessage());
		}
		return decrypt;
	}

	// EP Parameter 암호화 Method ( DES/CBC모드) - 사용안함 ( EP에서 암호화 해서 넘겨 줌.)
	public static String encrypt(String value) {

		SecretKeySpec SecureKey = new SecretKeySpec(PARA_KEY.getBytes(), "DES");
		IvParameterSpec InitialVector = new IvParameterSpec(IV.getBytes());
		String encrypt = "";

		try {
			Cipher ecipher = Cipher.getInstance(ENC_PARA_FORMAT);

			// ciphers 생성
			ecipher.init(Cipher.ENCRYPT_MODE, SecureKey, InitialVector);

			byte[] byte_enc = value.getBytes(UTF_8);

			// Encrypt
			byte[] enc = ecipher.doFinal(byte_enc);

			encrypt = ENCORDER.encode(enc);

		} catch (Exception e) {

			System.out.println("encrypt==>" + e.getMessage());
		}

		return encrypt;
	}

	// EP Cookie 복호화 Method ( DES/ECB모드)
	public static String decryptCookie(String value) {

		SecretKeySpec SecureKey = new SecretKeySpec(COOKIE_KEY.getBytes(), "DES");
		String decrypt = "";

		try {
			Cipher dcipher = Cipher.getInstance(ENC_COOKIE_FORMAT);

			// ciphers 생성
			dcipher.init(Cipher.DECRYPT_MODE, SecureKey);

			// EP ( C# ) 에서 암호화된 값을 UrlEncode 해서 넘기므로
			// JAVA에서 URLDecoder 처리하여. base64 Decode 처리해 준다.
			byte[] dec = DECORDER.decodeBuffer(java.net.URLDecoder.decode(value, UTF_8));

			// Decrypt
			byte[] byte_dec = dcipher.doFinal(dec);

			decrypt = new String(byte_dec);

		} catch (Exception e) {

			System.out.println("decryptCookie==>" + e.getMessage());
		}
		return decrypt;
	}

	// EP Cookie 암호화 Method ( DES/ECB모드) - 사용안함 ( EP에서 Cookie 암호화 해서 Set 해줌.)
	public static String encryptCookie(String value) {

		SecretKeySpec SecureKey = new SecretKeySpec(COOKIE_KEY.getBytes(), "DES");
		String encrypt = "";

		try {
			Cipher ecipher = Cipher.getInstance(ENC_COOKIE_FORMAT);

			// ciphers 생성
			ecipher.init(Cipher.ENCRYPT_MODE, SecureKey);

			byte[] byte_enc = value.getBytes(UTF_8);

			// Encrypt
			byte[] enc = ecipher.doFinal(byte_enc);

			// EP에서 Encode 후 UrlEncode 해서 넘기므로 동일하게. 한번더 UTF8로 ENCODE 한다.
			encrypt = java.net.URLEncoder.encode(ENCORDER.encode(enc), UTF_8);

		} catch (Exception e) {

			System.out.println("encryptCookie==>" + e.getMessage());
		}

		return encrypt;
	}
}
