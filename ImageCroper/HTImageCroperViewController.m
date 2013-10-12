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
    UIBarStyle              _previousNavBarStyle;
}

@end

@implementation HTImageCroperViewController

- (id)init{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (id)initWithCropSize:(CGSize)cropSize image:(UIImage *)originImage{
    self = [self init];
    if (self) {
        _croperView = [[HTImageCroperView alloc] initWithFrame:[[UIScreen mainScreen] bounds] croperSize:cropSize image:originImage];
        _croperView.backgroundColor = [UIColor blackColor];
        _croperView.clipsToBounds = YES;
    }
    return self;
}

- (void)loadView{
    self.view = _croperView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarStyle:_previousNavBarStyle];
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
