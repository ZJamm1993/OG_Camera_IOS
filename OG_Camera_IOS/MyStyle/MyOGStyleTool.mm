//
//  MyOGStyleTool.m
//  OG_Camera_IOS
//
//  Created by zjj on 2020/1/2.
//  Copyright © 2020 zjj. All rights reserved.
//

#import "MyOGStyleTool.h"

static MyOGStyleTool *_sharedMyOGStyleToolInstance = nil;

@implementation MyOGStyleTool {
    cv::Mat lutMat;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *lutImage = [UIImage imageNamed:@"lookup_vx.png"];
        UIImageToMat(lutImage, lutMat, true);
        cv::cvtColor(lutMat, lutMat, cv::COLOR_RGBA2BGR);
    }
    return self;
}

+ (void)handleImage:(cv::Mat &)image {
    if (_sharedMyOGStyleToolInstance == nil) {
        _sharedMyOGStyleToolInstance = [[MyOGStyleTool alloc] init];
    }
    [_sharedMyOGStyleToolInstance handleImage:image];
}

- (void)handleImage:(cv::Mat &)image {
    cv::GaussianBlur(image, image, cv::Size(5, 5), 0);
    [self myUSMWithImage:image];
    [self myLutWithImage:image];
    [self myNTSCLineWithImage:image];
}

#pragma mark my private methods

- (void)myLutWithImage:(cv::Mat &)image {
    //     try lut
    int imgChannels = image.channels();
    int lutChannels = lutMat.channels();
    for (int y = 0; y < image.rows; y++) {
        uchar *row = image.ptr<uchar>(y);
        for (int x = 0; x < image.cols; x++) {
            int offset_x = x * imgChannels;
            uchar b = row[offset_x + 0] / 4;
            uchar g = row[offset_x + 1] / 4;
            uchar r = row[offset_x + 2] / 4;
            int lut_x = (b % 8) * 64 + r;
            int lut_y = (b / 8) * 64 + g;
            uchar *lut_row = lutMat.ptr<uchar>(lut_y);
            int offset_lut_x = lut_x * lutChannels;
            row[offset_x + 0] = lut_row[offset_lut_x + 0];
            row[offset_x + 1] = lut_row[offset_lut_x + 1];
            row[offset_x + 2] = lut_row[offset_lut_x + 2];
            // ptr<uchar>比at<T>的速度快得多
        }
    }
}

- (void)myUSMWithImage:(cv::Mat &)image {
    double val = 4.0;
    int radius = 7;
    cv::Mat blur;
    cv::GaussianBlur(image, blur, cv::Size(radius, radius), 3);
    cv::addWeighted(image, val, blur, 1.0 - val, 0, image);
}

- (void)myNTSCLineWithImage:(cv::Mat &)image {
    int channels = image.channels();
    uchar *lastRow = NULL;
    for (int y = 0; y < image.rows; y++) {
        if (y % 2 == 0) {
            lastRow = image.ptr<uchar>(y);
        } else {
            // 将上一行赋值到此行
            // 有没有修改整行的方法？
            uchar *thisRow = image.ptr<uchar>(y);
            memcpy(thisRow, lastRow, image.cols * channels);
            /*
            for (int x = 0; x < image.cols; x++) {
                int offset_x = x * 4;
                for (int index = 0; index < 4; index ++) {
                    thisRow[offset_x + index] = lastRow[offset_x + index];
                }
            }
            // */
        }
    }
}

@end
