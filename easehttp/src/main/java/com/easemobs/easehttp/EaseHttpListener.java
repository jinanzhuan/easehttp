package com.easemobs.easehttp;

import java.io.InputStream;

public interface EaseHttpListener {
    void onSuccess(InputStream in);

    void onProgress(int progress);

    void onFailure(int code, String message);
}
