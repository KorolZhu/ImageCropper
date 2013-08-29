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
    double zoomScale = [[_cropingImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    double rotationZ = [[_croperScrollView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    CGPoint cropperViewOrigin;
    cropperViewOrigin.x = (_maskView.cropRect.origin.x - (CGRectGetMinX(_cropingImageView.frame) - _croperScrollView.contentOffset.x + CGRectGetMinX(_croperScrollView.frame))) * 1.0f / zoomScale;
    cropperViewOrigin.y = (_maskView.cropRect.origin.y - (CGRectGetMinY(_cropingImageView.frame) - _croperScrollView.contentOffset.y + CGRectGetMinY(_croperScrollView.frame))) * 1.0f / zoomScale;
    CGSize cropperViewSize = CGSizeMake(_maskView.cropRect.size.width * (1/zoomScale) ,_maskView.cropRect.size.height * (1/zoomScale));
    CGRect cropingViewRect;
    cropingViewRect.origin = cropperViewOrigin;
    cropingViewRect.size = cropperViewSize;
        
    UIImage *cropingImage = [_originImage imageByRotatingImage:_originImage fromImageOrientation:_originImage.imageOrientation];
    
    CGImageRef tmpImageRef = CGImageCreateWithImageInRect([cropingImage CGImage], cropingViewRect);
    UIImage *tmpcropImage = [UIImage imageWithCGImage:tmpImageRef];
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
