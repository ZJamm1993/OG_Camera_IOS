//
//  ViewController.m
//  OpenCVIOS
//
//  Created by zjj on 2019/10/25.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "ViewController.h"
#import "MyOGStyleTool.h"

@interface ViewController ()<CvVideoCameraDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CvVideoCamera *camera;

@end

@implementation ViewController {
    cv::Mat lutMat;
}

- (IBAction)capturePress:(id)sender {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.camera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.camera.defaultFPS = 30;
    self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.camera.delegate = self;
    [self.camera start];
    
//    self.camera.
}


#pragma mark - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
//    cv::Mat gray;
//    cv::cvtColor(image, gray, cv::COLOR_BGRA2GRAY);
//    cv::GaussianBlur(gray, gray, cv::Size(11, 11), 0);
//     track points
//    std::vector<cv::KeyPoint> keypoints;
//    cv::ORB::create() -> detect(gray, keypoints);
//    cv::drawKeypoints(image, keypoints, image);
    
    
    // blur
//    int blursize = 5;
//    cv::blur(image, image, cv::Size(blursize, blursize));
//    // sharp
//    cv::Mat sharpKernel = (cv::Mat_<float>(3, 3) << -1, 0, 1,
//                                                -1, 1, 1,
//                                               -1, 0, 1);
//    cv::filter2D(image, image, image.depth(), sharpKernel);
 

//    cv::Mat edges;
//    cv::Canny(gray, edges, 100, 255);
//    // Change color on edges
//    image.setTo(cv::Scalar(0,0,255,255),edges);
    
//    cv::Mat rgb;
//    cv::cvtColor(image, rgb, cv::COLOR_BGR2RGB);
//    UIImage *img = MatToUIImage(rgb);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.imageView.image = img;
//    });
    
    [MyOGStyleTool handleImage:image];
}

@end
