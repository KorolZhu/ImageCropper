//
//  HTImageCroperView.m
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import "HTImageCroperView.h"
#import "HTCroperMaskView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage-Extension.h"

@interface HTImageCroperView ()<UIScrollViewDelegate>
{
    UIScrollView        *_croperScrollView;
    HTCroperMaskView    *_maskView;
    UIImageView         *_cropingImageView;
    UIImage             *_originImage;
}

@end

@implementation HTImageCroperView

- (id)initWithFrame:(CGRect)frame croperSize:(CGSize)size image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        _originImage = image;
        _cropingImageView = [[UIImageView alloc] initWithImage:_originImage];
        
        _maskView = [[HTCroperMaskView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = NO;
        _maskView.cropsize = size;
        
        _croperScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _croperScrollView.showsHorizontalScrollIndicator = NO;
        _croperScrollView.showsVerticalScrollIndicator = NO;
        _croperScrollView.contentSize = _cropingImageView.frame.size;
        _croperScrollView.contentInset = UIEdgeInsetsMake(_maskView.cropRect.origin.y, _maskView.cropRect.origin.x, _maskView.cropRect.origin.y, _maskView.cropRect.origin.x);
        _croperScrollView.minimumZoomScale = 1.0f;
        _croperScrollView.maximumZoomScale = 3.0f;
        _croperScrollView.delegate = self;
        
        [_croperScrollView addSubview:_cropingImageView];
        
        [self addSubview:_croperScrollView];
        [self addSubview:_maskView];
    }
    return self;
}

- (void)rotateLeftAnimated{
    [UIView animateWithDuration:0.2f animations:^{
        _cropingImageView.transform = CGAffineTransformRotate(_cropingImageView.transform,-M_PI/2);
        CGRect frame = _cropingImageView.frame;
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        _cropingImageView.frame = frame;
        
        _croperScrollView.contentOffset = CGPointZero;
        _croperScrollView.contentSize = _cropingImageView.frame.size;
    }];
}

- (UIImage *)crop{
    double zoomScale = [[_cropingImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    double rotationZ = [[_cropingImageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    CGPoint cropperViewOrigin = CGPointMake((_maskView.cropRect.origin.x - _cropingImageView.frame.origin.x + _croperScrollView.contentOffset.x)  *1/zoomScale ,( _maskView.cropRect.origin.y - _cropingImageView.frame.origin.y + _croperScrollView.contentOffset.y) * 1/zoomScale
                                            );
    CGSize cropperViewSize = CGSizeMake(_maskView.cropRect.size.width * (1/zoomScale) ,_maskView.cropRect.size.height * (1/zoomScale));
    CGRect cropingViewRect;
    cropingViewRect.origin = cropperViewOrigin;
    cropingViewRect.size = cropperViewSize;
    
    NSLog(@"CropinView : %@",NSStringFromCGRect(cropingViewRect));
    
    UIImage *cropingImage = [_originImage imageByRotatingImage:_originImage fromImageOrientation:_originImage.imageOrientation];
    cropingImage = [cropingImage imageRotatedByRadians:rotationZ];
    CGImageRef tmp = CGImageCreateWithImageInRect([cropingImage CGImage], cropingViewRect);
    UIImage *cropedImage = [UIImage imageWithCGImage:tmp scale:cropingImage.scale orientation:cropingImage.imageOrientation];
    CGImageRelease(tmp);
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/test"];
    [UIImageJPEGRepresentation(cropedImage, 1.0f) writeToFile:path atomically:YES];
//    UIImageWriteToSavedPhotosAlbum(cropedImage, nil, nil, nil);
    
    return cropedImage;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _cropingImageView;
}

@end
