package com.bhm.flutter.flutternb.ui;

import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.cjt2325.cameralibrary.JCameraView;
import com.cjt2325.cameralibrary.listener.ClickListener;
import com.cjt2325.cameralibrary.listener.ErrorListener;
import com.cjt2325.cameralibrary.listener.JCameraListener;

import java.io.File;
import java.io.FileOutputStream;

import androidx.appcompat.app.AppCompatActivity;
import io.reactivex.Observable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;


public class VideoRecordActivity extends AppCompatActivity {

    /*我也不知道为啥没有R文件，因此布局不能用layout，而用代码写*/
    private JCameraView cameraView;
    private Intent intent = new Intent();
    private String path = Environment.getExternalStorageDirectory().getPath() + File.separator + "BHMFlutter/video";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LinearLayout rootView = new LinearLayout(this);
        rootView.setOrientation(LinearLayout.VERTICAL);
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);
        rootView.setLayoutParams(params);
        cameraView = new JCameraView(this);
        cameraView.setLayoutParams(params);
        rootView.addView(cameraView);
        setContentView(rootView);
        init();
    }

    private void init() {
        if (Build.VERSION.SDK_INT >= 19) {
            View decorView = getWindow().getDecorView();
            decorView.setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        } else {
            View decorView = getWindow().getDecorView();
            int option = View.SYSTEM_UI_FLAG_FULLSCREEN;
            decorView.setSystemUiVisibility(option);
        }

        //设置视频保存路径
        cameraView.setSaveVideoPath(path);
        //设置只能录像或只能拍照或两种都可以（默认两种都可以）
        cameraView.setFeatures(JCameraView.BUTTON_STATE_ONLY_RECORDER);
        //设置视频质量
        cameraView.setMediaQuality(JCameraView.MEDIA_QUALITY_MIDDLE);
        //JCameraView监听
        cameraView.setErrorLisenter(new ErrorListener() {
            @Override
            public void onError() {
                //打开Camera失败回调
                intent.putExtra("result", "打开相机失败");
                setResult(1000, intent);
                finish();
            }

            @Override
            public void AudioPermissionError() {
                //没有录取权限回调
                intent.putExtra("result", "没有权限");
                setResult(1000, intent);
                finish();
            }
        });

        cameraView.setJCameraLisenter(new JCameraListener() {
            @Override
            public void captureSuccess(Bitmap bitmap) {
                //获取图片bitmap
                Log.i("JCameraView", "bitmap = " + bitmap.getWidth());
            }

            @Override
            public void recordSuccess(final String url, final Bitmap firstFrame) {
                //获取视频路径
                Log.i("CJT", "url = " + url);
                //---/storage/emulated/0/BHMFlutter/video/video_1555330381363.mp4
                Observable.just(url)
                        .observeOn(Schedulers.io())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String callBack1) throws Exception {
                                saveBitmap(url, firstFrame);
                            }
                        }, new Consumer<Throwable>() {
                            @Override
                            public void accept(Throwable throwable) throws Exception {
                                intent.putExtra("result", "视频保存失败");
                                setResult(1000, intent);
                                finish();
                            }
                        });
            }
        });
        //左边按钮点击事件
        cameraView.setLeftClickListener(new ClickListener() {
            @Override
            public void onClick() {
                finish();
            }
        });
        //右边按钮点击事件
        cameraView.setRightClickListener(new ClickListener() {
            @Override
            public void onClick() {

            }
        });
    }

    public void saveBitmap(String videoUrl, Bitmap firstFrame) {
        try {
            File f = new File(path, String.valueOf(System.currentTimeMillis()) + ".png");
            if (f.exists()) {
                f.delete();
            }
            FileOutputStream out = new FileOutputStream(f);
            firstFrame.compress(Bitmap.CompressFormat.PNG, 90, out);
            out.flush();
            out.close();

            android.media.MediaMetadataRetriever mmr = new android.media.MediaMetadataRetriever();
            mmr.setDataSource(videoUrl);
            String duration = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);

            intent.putExtra("result", videoUrl);
            intent.putExtra("thumbPath", f.getPath());
            intent.putExtra("length", Integer.valueOf(duration) / 1000);
            setResult(1000, intent);
            finish();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            intent.putExtra("result", "视频保存失败");
            setResult(1000, intent);
            finish();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        cameraView.onResume();
    }
    @Override
    protected void onPause() {
        super.onPause();
        cameraView.onPause();
    }
}
