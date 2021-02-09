package com.easemobs.easehttp;

public interface EaseHttp {

    void setUrl(String url);

    void setRequestData(byte[] requestData);

    void execute();

    void setHttpCallBack(EaseHttpListener listener);
}
