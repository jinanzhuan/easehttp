package com.easemobs.easehttp;

import android.content.Context;
import android.net.Uri;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.documentfile.provider.DocumentFile;

import java.io.File;

public class EaseHttpUtils {
    public static String getFilePath(Context context, @NonNull Uri fileUri) {
        return "";
    }

    public static String getImagePath(Context context, @NonNull Uri imageUri) {
        if(imageUri == null) {
            return "";
        }
        String path = imageUri.getPath();
        if(!TextUtils.isEmpty(path) && new File(path).exists()) {
            return path;
        }
        return imageUri.toString();
    }

    public static DocumentFile getDocumentFile(Context context, Uri uri) {
        if(uri == null) {
            return null;
        }
        DocumentFile documentFile = DocumentFile.fromSingleUri(context, uri);
        if(documentFile == null) {
            return null;
        }
        return documentFile;
    }

}

