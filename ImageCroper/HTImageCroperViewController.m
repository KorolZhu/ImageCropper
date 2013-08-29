//
//  HTImageCroperViewController.m
//  ImageCroper
//
//  Created by zhuzhi on 13-8-28.
//  Copyright (c) 2013年 TCJ. All rights reserved.
//

#import "HTImageCroperViewController.h"
#import "HTImageCroperView.h"
#import "HTCroperMaskView.h"

@interface HTImageCroperViewController ()
{
    HTImageCroperView       *_croperView;
}

@end

@implementation HTImageCroperViewController

- (id)init{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    return self;
}

- (void)loadView{
    _croperView = [[HTImageCroperView alloc] initWithFrame:[[UIScreen mainScreen] bounds] croperSize:CGSizeMake(300.0f, 300.0f) image:[UIImage imageNamed:@"test6.jpg"]];
    _croperView.backgroundColor = [UIColor blackColor];
    
    self.view = _croperView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44.0f, 320.0f, 44.0f)];
    [toolbar setBarStyle:UIBarStyleBlack];
    [toolbar setTranslucent:YES];
    
    UIBarButtonItem *test = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"picture_rotation_left"] style:UIBarButtonItemStylePlain target:self.view action:@selector(crop)];

    
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSString *text = NSLocalizedString(@"Move and Scale", @"");
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:20.f]];
    UILabel *moveAndScaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    moveAndScaleLabel.backgroundColor = [UIColor clearColor];
    moveAndScaleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    moveAndScaleLabel.text = text;
    moveAndScaleLabel.textColor = [UIColor whiteColor];
    moveAndScaleLabel.shadowOffset = CGSizeMake(0, 1);
    UIBarButtonItem *moveAndScaleItem = [[UIBarButtonItem alloc] initWithCustomView:moveAndScaleLabel];
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btn_rotationRight = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"picture_rotation_left"] style:UIBarButtonItemStylePlain target:self.view action:@selector(rotateLeftAnimated)];
    [toolbar setItems:[NSArray arrayWithObjects:test,flexItem1,moveAndScaleItem,flexItem2,btn_rotationRight, nil]];
    [self.view addSubview:toolbar];
}

@end
