//
//  DetailViewController.m
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize urlImage = _urlImage;

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_resultImageView setImageWithURL:[NSURL URLWithString:self.urlImage]];
    [_closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
}

-(void)closeModal {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
