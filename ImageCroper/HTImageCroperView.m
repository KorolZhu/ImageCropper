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
        _cropingImageView = [[UIImageView alloc] initWithImage:image];
        
        _maskView = [[HTCroperMaskView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = NO;
        _maskView.cropsize = size;
        
        CGRect scrollFrame;
        scrollFrame.size.width = MAX(frame.size.width, frame.size.height);
        scrollFrame.size.height = scrollFrame.size.width;
        scrollFrame.origin.x = (frame.size.width - scrollFrame.size.width) / 2.0f;
        scrollFrame.origin.y = (frame.size.height - scrollFrame.size.width) / 2.0f;
        _croperScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        _croperScrollView.showsHorizontalScrollIndicator = NO;
        _croperScrollView.showsVerticalScrollIndicator = NO;
        _croperScrollView.contentSize = _cropingImageView.frame.size;
        UIEdgeInsets edgeInset;
        edgeInset.top = CGRectGetMinY(_maskView.cropRect) - CGRectGetMinY(_croperScrollView.frame);
        edgeInset.left = CGRectGetMinX(_maskView.cropRect) - CGRectGetMinX(_croperScrollView.frame);
        edgeInset.bottom = edgeInset.top;
        edgeInset.right = edgeInset.left;
        _croperScrollView.contentInset = edgeInset;
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
        _croperScrollView.transform = CGAffineTransformRotate(_croperScrollView.transform,-M_PI/2);
    }];
}

- (UIImage *)crop{    
    CGRect cropingViewRect = [_maskView convertRect:_maskView.cropRect toView:_cropingImageView];
    UIImage *cropingImage = [_originImage fixOrientation:_originImage];
    CGImageRef tmpImageRef = CGImageCreateWithImageInRect([cropingImage CGImage], cropingViewRect);
    UIImage *tmpcropImage = [UIImage imageWithCGImage:tmpImageRef scale:cropingImage.scale orientation:cropingImage.imageOrientation];
    
    double rotationZ = [[_croperScrollView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    UIImage *cropedImage = [tmpcropImage imageRotatedByRadians:rotationZ];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/test"];
    [UIImageJPEGRepresentation(cropedImage, 1.0f) writeToFile:path atomically:YES];
    
    return cropedImage;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _cropingImageView;
}

@end
