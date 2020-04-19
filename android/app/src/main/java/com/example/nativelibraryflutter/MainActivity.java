package com.example.nativelibraryflutter;

import android.util.Log;

import com.example.lwocryptocore.lcryptcore.CryptoCase;
import com.example.lwocryptocore.lcryptcore.LCryptCore;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "channel.ilya.crypto";
    private final static char[] hexArray = "0123456789ABCDEF".toCharArray();

    static {
        System.loadLibrary("cryptowrap");
    }

    public static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public String cryptString(String text, String algorithm) {

        byte[] arrBytesForDigest = new byte[(int) text.length()];
        arrBytesForDigest = text.getBytes();


        CryptoCase cryptoCaseDigest = null;

        cryptoCaseDigest = (new LCryptCore()).CreateDigest(algorithm, arrBytesForDigest, arrBytesForDigest.length);

        String myHash = bytesToHex(cryptoCaseDigest.digest);

        return myHash;
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("cryptString")) ;
                            {
                                String text = call.argument("text");
                                String algorithm = call.argument("algorithm");
                                String cryptS = cryptString(text, algorithm);
                                Log.d("asd", text);
                                Log.d("asd", algorithm);
                                Log.d("asd", cryptS);
                                result.success(cryptS);
                            }
                        }
                );
    }
}

