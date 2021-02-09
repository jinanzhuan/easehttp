package com.easemobs.easehttp;

import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class EaseHttpImpl implements EaseHttp {
    private String url;
    private byte[] requestData;
    private EaseHttpListener httpListener;
    private HttpURLConnection urlConnection;

    @Override
    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public void setRequestData(byte[] requestData) {
        this.requestData = requestData;
    }

    @Override
    public void execute() {
        executeHttpRequest();
    }

    @Override
    public void setHttpCallBack(EaseHttpListener listener) {
        this.httpListener = listener;
    }

    private void executeHttpRequest() {
        URL url = null;
        try {
            url = new URL(this.url);
            urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.setConnectTimeout(6000);
            urlConnection.setUseCaches(false);
            urlConnection.setInstanceFollowRedirects(true);
            urlConnection.setReadTimeout(3000);
            urlConnection.setDoInput(true);
            urlConnection.setDoOutput(true);
            urlConnection.setRequestMethod("POST");
            urlConnection.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            urlConnection.connect();

            OutputStream out = urlConnection.getOutputStream();
            BufferedOutputStream bos = new BufferedOutputStream(out);
            if(requestData != null) {
                bos.write(requestData);
            }
            bos.flush();
            out.close();
            bos.close();

            if(urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                InputStream in = urlConnection.getInputStream();
                if(httpListener != null) {
                    httpListener.onSuccess(in);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

